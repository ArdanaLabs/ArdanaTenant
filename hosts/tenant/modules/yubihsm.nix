let
  hsm = {
    michael = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF8gRh4Q/hxVbGDTRj8knKmEpkSuEHW3LPZKi4VupKOE litchard.michael@gmail.com";
    nick = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQClgFEZi+lKsANagFtmek3OAjNvr8pB1NNCOhfyIYMiIVRjypn3CQFNTePKRd4ux18f2p8DnXO8QCnd3E/G8qxGgyuHc8oUe8uuSuImcPawrQ1aIXIi1ekb7qC3Mrcb/tmZCYxs1R9xugefPjraFqwKJRKLinz7fvP3UfhgTbHl98DOUwRSdtc+FISvCmC/Ggk1d98hR+1uqAQx+9yjWKhgpT/RsLkVj/udvck7W/gXRKvRXOamjEC3FNWExdP0xPLkrXIn6TaZ8Wa+p+OnUyJE3OfzeKhknO3JinuxkTTti9g8DGmGESllT5UcWNFwfQtVcT/83lVojn4w2XYlg0JTji8qbjb6yP0gOCmP4zCKwdEBYsj6yMI7K3N3n0ZLHgfthnm2qhUFe0R/pIF3w6lOjGfOjBzmKp0H+CLp5AF6oANrWJ3jnnZWsMl2Fgbj8bAA9tR73m2b2maMAOSsfW46/Rk3lid6BNsCGzRBFhdMpeNkCk9U9dCRWBQ+cNVGnLi/SQBYTApB6RVGKM+HmCqxY4VOSL+bvSyphdO4waHqzYXk98NzuyJlggveXGPUH4mIATNJhAWb0HkUTnc+E5QdzOfd91+q0HT3yqZOZEB8BzUTarTyO2ENSxEDK46mf/MjxQW+slSqjYCyx8IkxaHqhoe98nHCiTrPMF8F8wR2fw== vandenbroeck@cs-vdb.com";
  };
in
{
  users = {
    groups.yubihsm = {};
    users.hsm = {
      isNormalUser = true; 
      openssh.authorizedKeys.keys = [ hsm.michael hsm.nick ];
      extraGroups = [ "yubihsm" ];
    };
  };
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0030", GROUP="yubihsm", MODE="0666"
  '';
}
