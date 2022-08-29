let
  hsm = {
    michael = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF8gRh4Q/hxVbGDTRj8knKmEpkSuEHW3LPZKi4VupKOE litchard.michael@gmail.com";
    nick = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnYLYtN4Bc8HfwWXYOm2Uztfp8AP9BhgxQbSjkppcM7 vandenbroeck@cs-vdb.com";
    evan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8IJI7B2H2V9vQ1QNVMwjoGiNJAM/kJLMFUnt6G/5yv evan.piro@platonic.systems";
    brian = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrRw/DDphEjtRsl6G9of6CSNmtx0n6H5qUK7l5EvxYBrkQCmKqlK+XAxlrpyZGkQnM+3YQj/MQVRhpwqZCHec6M3f8O2Q2uH+bO+IbPlm+kuFZIFP8z5I+tW1b0Tc0mAZDHduzr/RHcf5G04wXOQpzz1L+/d0vJzAKDyBVvW+xQ//g0t7HI5mVly0eHk/mHOXSkVjslSMlwEG9dMO4rO3gIFaNC3GzCVDPY4HSsxq5bQhC4I1dL/YTkvzXhyANyTH6wGFOCe8JfMuviVCupBrYMlpI7dlYAMcF9CyS2SeAJybmMyiXyVT0SPdszoJLykRruoqPc7Ir9cMAtrevHGFXm2Ql0NtmBOb7E1GVbIKnlJqAyZGpPmKvzTq0YmOVo5jw1YJwpeeSvHN0k8rioTo65SYEgVenD/ZbCjAYAg5kct5RQysMxEwoBlqGTudD2s3V4vib2lRQespIQ1HKUHubahib1oCWjOq9vmhVmFMmJ5vNTmKNlt6gcUfRSaxi5/E= bbrian@am";
  };
in
{
  users = {
    groups.yubihsm = {};
    users.hsm = {
      isNormalUser = true; 
      openssh.authorizedKeys.keys = with hsm; [ michael nick evan brian ];
      extraGroups = [ "yubihsm" ];
    };
  };
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0030", GROUP="yubihsm", MODE="0666"
  '';
}
