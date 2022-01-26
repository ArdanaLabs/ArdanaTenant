{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/yubihsm.nix
      ./modules/traefik.nix
      ../../mixins/users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "tenant";
    useDHCP = false;
    hostId = "00000000";
    nameservers = [ "216.87.64.2" "209.170.216.5" ];
    defaultGateway.address = "216.24.131.1";
    interfaces = {
      eno1.useDHCP = false;
      eno1.ipv4.addresses = [
        { address = "216.24.131.4";
          prefixLength = 29;
        }
      ];
      eno2.useDHCP = false;
      eno3.useDHCP = false;
      eno4.useDHCP = false;
    };
  };

  services = {
    danaswapstats = {
      enable = true;
      port = 8001;
    };
    dana-circulating-supply = {
      enable = true;
      port = 8002;
    };
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

