{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";

    nixinate.url = "github:matthewcroughan/nixinate";
    nixinate.inputs.nixpkgs.follows = "nixpkgs";

    hci-effects.url = "github:hercules-ci/hercules-ci-effects";
    hci-effects.inputs.nixpkgs.follows = "nixpkgs";

    danaswapstats.url = "git+ssh://git@github.com/ArdanaLabs/danaswapstats";
    dana-circulating-supply.url = "git+ssh://git@github.com/ArdanaLabs/dana-circulating-supply?ref=main";
    hello-cardano-template.url = "github:ArdanaLabs/hello-cardano-template/hello-world-nixos-module";
  };
  outputs =
    { self
    , nixpkgs
    , nixinate
    , hci-effects
    , ...
    }@inputs:
    let
      # A function that will compose a tenant nixos system with the given flake inputs.
      mkTenantSystem =
        { danaswapstats
        , dana-circulating-supply
        , hello-cardano-template
        , nixpkgs
        , ...
        }@inputs:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./hosts/tenant/configuration.nix)
            (import ./mixins/common.nix)
            danaswapstats.nixosModules.danaswapstats
            dana-circulating-supply.nixosModules.dana-circulating-supply
            hello-cardano-template.nixosModules.hello-world
            {
              _module.args = {
                nixinate = {
                  host = "216.24.131.4";
                  sshUser = "deploy";
                  buildOn = "local";
                };
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      apps = nixinate.nixinate.x86_64-linux self;
      nixosConfigurations = {
        tenant = mkTenantSystem inputs;
      };
      herculesCI = { branch, ... }: {
        onPush.default = {
          outputs.effects = {
            ardanaTenantDeploy =
              let
                system = "x86_64-linux";
                pkgs = nixpkgs.legacyPackages.${system};
                effects = hci-effects.lib.withPkgs pkgs;
                inherit (effects) runIf mkEffect;

                # We have to do this so that we avoid using the SSH inputs.
                # These require a SSH key. Instead we can just make use of the netrc
                # file with HTTPS which is also recommended by Hercules.
                # (https://docs.hercules-ci.com/hercules-ci-agent/netrc/#git-ssh)
                tenant =
                  let
                    # Read the flake.lock so we can get the information we need
                    # Eg. Git revisions and NAR hashes.
                    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes;
                    # Define some helper functions to create a flake input.
                    # The main thing here is `builtins.getFlake` which will fetch
                    # the flake, and the result will be usable as a flake input.
                    mkInput = url: node:
                      builtins.getFlake "${url}/${node.rev}?narHash=${node.narHash}";
                    mkArdanaInput = name:
                      mkInput "github:ArdanaLabs/${name}" lock.${name}.locked;
                  in
                  mkTenantSystem (
                    inputs // {
                      danaswapstats = mkArdanaInput "danaswapstats";
                      dana-circulating-supply = mkArdanaInput "dana-circulating-supply";
                    }
                  );
                # Create the deploy apps using nixinate.
                deployApps =
                  nixinate.nixinate.${system}
                    (self // { nixosConfigurations.tenant = tenant; });
              in
              # Only run this effect on master branch.
                # The CI will build the dependencies of this effect even if it won't run.
              runIf (branch == "master") (mkEffect {
                inputs = [ pkgs.openssh pkgs.git ];
                secretsMap.ssh = "tenantDeployKeys";
                userSetupScript = ''
                  writeSSHKey ssh
                  cat >>~/.ssh/known_hosts <<EOF
                    216.24.131.4 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkK+eMwud2J9oYUhIWfmDRsfn1DfaGxtt3EM/BUPmcp
                  EOF
                '';
                effectScript = ''
                  # deploy tenant (dry run)
                  ${deployApps.nixinate.tenant-dry-run.program}
                  # deploy tenant
                  ${deployApps.nixinate.tenant.program}
                '';
              });
          };
        };
      };
    };
}
