#We obliterate channels here and reply purely on nix flake inputs. All users are tied the system flakes revision.
{ config, pkgs, lib, inputs, ...}:
{
  environment.systemPackages = with pkgs; [ vim git ];
  nix = {
    trustedUsers = [ "@wheel" "root" ];
    package = pkgs.nixFlakes;
    extraOptions =
      let empty_registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}''; in
      ''
        experimental-features = nix-command flakes
        flake-registry = ${empty_registry}
      '';
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
}
