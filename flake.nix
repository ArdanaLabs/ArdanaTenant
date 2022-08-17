{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixinate.url = "github:matthewcroughan/nixinate";
    danaswapstats.url = "git+ssh://git@github.com/ArdanaLabs/danaswapstats";
    dana-circulating-supply.url = "git+ssh://git@github.com/ArdanaLabs/dana-circulating-supply?ref=main";
    hci-effects.url = "github:hercules-ci/hercules-ci-effects";
  };
  outputs = {
    self,
    nixpkgs,
    hci-effects,
    ...
  }@inputs:
  let
    makeNixosOutputs = {
      nixinate,
      danaswapstats,
      dana-circulating-supply,
      nixpkgs,
      ...
    }@inputs:
      let
        nixosConfigurations = {
          # tenant is the co-located machine that Isaac provisioned. It is running
          # at the IP address 216.24.131.4
          tenant = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              (import ./hosts/tenant/configuration.nix)
              (import ./mixins/common.nix)
              danaswapstats.nixosModules.danaswapstats
              dana-circulating-supply.nixosModules.dana-circulating-supply
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
        };
      in {
        inherit nixosConfigurations;
        apps = nixinate.nixinate.x86_64-linux (
          inputs.self // {inherit nixosConfigurations;}
        );
      };
    flakeLock = builtins.fromJSON (builtins.readFile ./flake.lock);
    outputsForLocalCheckout = makeNixosOutputs inputs;
    outputsForCI =
      let
        makeFlakeInput = url: node: builtins.getFlake "${url}/${node.rev}?narHash=${node.narHash}";
      in
        makeNixosOutputs (
          inputs // {
            danaswapstats =
              makeFlakeInput
              "github:ArdanaLabs/danaswapstats"
              flakeLock.nodes."danaswapstats".locked;
            dana-circulating-supply =
              makeFlakeInput
              "github:ArdanaLabs/dana-circulating-supply"
              flakeLock.nodes."dana-circulating-supply".locked;
          }
        );
  in
  outputsForLocalCheckout // {
    herculesCI = { branch, ... }: {
      onPush.default = {
        outputs.effects = {
          ardanaTenantDeploy =
            let
              pkgs = nixpkgs.legacyPackages."x86_64-linux";
              effects = hci-effects.lib.withPkgs pkgs;
              inherit (effects) runIf mkEffect;
            in
              runIf (branch == "master") (mkEffect {
                secretsMap.ssh = "tenantDeployKeys";
                userSetupScript = ''
                  writeSSHKey ssh
                  cat >>~/.ssh/known_hosts <<EOF
                    216.24.131.4 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkK+eMwud2J9oYUhIWfmDRsfn1DfaGxtt3EM/BUPmcp
                  EOF
                '';
                effectScript = ''
                  # deploy tenant (dry run)
                  ${outputsForCI.apps.nixinate.tenant-dry-run.program}
                  # deploy tenant
                  ${outputsForCI.apps.nixinate.tenant.program}
                '';
              });
        };
      };
    };
  };
}
