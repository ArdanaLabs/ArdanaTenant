let
  hsm = {
    michael = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF8gRh4Q/hxVbGDTRj8knKmEpkSuEHW3LPZKi4VupKOE litchard.michael@gmail.com";
    nick = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnYLYtN4Bc8HfwWXYOm2Uztfp8AP9BhgxQbSjkppcM7 vandenbroeck@cs-vdb.com";
    evan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8IJI7B2H2V9vQ1QNVMwjoGiNJAM/kJLMFUnt6G/5yv evan.piro@platonic.systems";
  };
in
{
  users = {
    groups.yubihsm = {};
    users.hsm = {
      isNormalUser = true; 
      openssh.authorizedKeys.keys = with hsm; [ michael nick evan ];
      extraGroups = [ "yubihsm" ];
    };
  };
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0030", GROUP="yubihsm", MODE="0666"
  '';
}
