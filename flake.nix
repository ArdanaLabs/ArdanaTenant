{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixinate.url = "github:matthewcroughan/nixinate";
    danaswapstats.url = "git+ssh://git@github.com/ArdanaLabs/danaswapstats?ref=mc/fix-overlaying";
    dana-circulating-supply.url = "git+ssh://git@github.com/ArdanaLabs/dana-circulating-supply?ref=main";
  };
  outputs = { self, nixpkgs, danaswapstats, dana-circulating-supply, nixinate, ... }@inputs: {
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
  };
}
