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
    danaswapstats,
    dana-circulating-supply,
    nixinate,
    hci-effects,
    ...
  }@inputs: {
    apps = nixinate.nixinate.x86_64-linux self;
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
    herculesCI = { branch, ... }: {
      onPush.default = {
        outputs.effects = {
          ardanaTenantDeploy =
            let
              pkgs = nixpkgs.legacyPackages."x86_64-linux";
              effects = hci-effects.lib.withPkgs pkgs;
              inherit (effect) runIf mkEffect;
            in
              runIf (branch == "master") (mkEffect {
                effectScript = ''
                  # deploy tenant (dry run)
                  ${self.apps.nixinate.tenant-dry-run}
                  # deploy tenant
                  ${self.apps.nixinate.tenant}
                '';
              });
        };
      };
    };
  };
}
