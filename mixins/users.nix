{ config, pkgs, ... }:

let
  marijan = {
    key1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAtLW0s97pM4VMf6iZlGF0hs5lSuJycmJTrTDdaFxAqi";
  };
  isaac = {
    key1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZzKmSxSVqol+YNsGr5Cts5Cr/eIHqCm/KISHsluVtJ isaac@dunlap";
  };
  ci = {
    key1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfZU658BwNVcxAb4MDjfiu8iQIbLz/mBc5UdhC5sGNd root@nixos";
  };
in
{
  # TODO: Move the deploy user to its own file and import it.
  nix.trustedUsers = [ "deploy" ];
  security.sudo.extraRules = [{
    users = [ "deploy" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];
  users = {
    mutableUsers = false;
    users = {
      deploy = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ ci.key1 marijan.key1 ];
      };
      marijan = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ marijan.key1 ];
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$vpkqFLVXsC3I7QHo$F2H0nZdkf5NLQ9H6q8UUPFkwaNsCoIH38ut4Wa/RTsfit5gFwCAIz7R3/F9cbGZ3Nx4VvOZeYS2Jtcf25v8sD/";
      };
      isaac = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ isaac.key1 ];
        extraGroups = [ "wheel" ];
      };
    };
  };
}

