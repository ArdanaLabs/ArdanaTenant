{ config, pkgs, ... }:

let
  yusuf = {
    key1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUeDBW4hnHgnT0SjVFeGDztht9owObSmiyWXmmIEGQp2IMPqFpCxkOU61osvfCf4ZT92Ok9iJTohLwFBvHJRD/+CH8/b54sgFAx1lLObkJOMLz4iWZ5y4fNtBYuIA2McQSQoMDpDz6TDym7v7HF7zoUyBmfHMT/9WiX/z6Ft9hY63eh9DcF7WVURzeUvXLApt9wUYUxxdC2KZ/VrDPrIOxCcOgj3le+1zTiD8zwfAGhkzRD3IEx0yCYK6oztrh6WTwA5ZW+cLziH2sVEvSHFa2O398gIvZpzsdYTcQt06d/oyZIvftcpxD8IvjpGgHEsN/mAg0ovexyqAVk+TV/1XySKaoPPVCekap0R50CVD9kEk+GlD78XBYi++aAMIq0/D+NOXkgksfODt3yJPPzQx4KH8gcn0dQJM5zeyTwDfclzMRqCwL1eVHY00EbtG9IcLmMsWk/lM6vpHfyHqHlqNJ3CnUuDBccz9p5ORC1cuj4r9CmXPPmh7OYk7gGiQb4oxuqsYClzp93qmU7qMvGwmxBJaVagNIJgBqb5fsne0OMlcer5CH4L31ozszkSkzCXtFWNoTdgQHU1J3DxxL9WQJCfKku4EPJadYOh80USnauOke5CqfsGtf6uMq4l5Ylcc1QcNhRqxpeTLAIZx0EYDhmQ4eGjAZbiv6ddUp9dAdiQ==";
  };
  isaac = {
    key1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZzKmSxSVqol+YNsGr5Cts5Cr/eIHqCm/KISHsluVtJ isaac@dunlap";
  };
  matthew = {
    key1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD7jt+f8gURZcWeo9Sko5kdPW1ORd+CDXsCxyHgGRK5IVKLrluAEC7ha0xlOQ3WtHEiWj3P9/C9UzATjWaMZU5j/A7Ysib2peBFQZ0roYwHDYVZzutF7HJWBc4WW/CPSjWZfza2jC3e/Qe2ktmnbri0oq27EXYJwhs+/70+VA4NZ5d7xD1CnYhv4LdsudSTLJjsyCL6PLVbtUZKW8avyH359R4rLTkklk9H1d0RYGDkHKMFB5ADdlEJwnjRAbjK94u+M6jhN9ahMrfSsbLUd1DcASMoW7fw+Y16l//7cDr8rN32Mi1Vs/mBvJmnN//84QtqJM2UD/lxI/k8aJEXskojfmBP2qd+mevHfuA30b6BtngeDvh5RPnYYDL28g9iyDKMWtBEYMkyF+kbERiiOkxFpudyB7Vd0fYAZxusqq8EOpVnjj97T0hFbGspam/Q9H5tT4U02JG127Z2+ohq5DUYeiMDh3mOs5uc/R+svj00NJtmEuNdqjtyktYP6zfhiVs= matthew@swordfish";
    key2 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClm+SMN9Bg1HZ+MjH1VQYEXAnslGWT9564pj/KGO79WMQLUxdp3WWa1hQadf2PleAIEFEul3knrpRSEK3yHcCk3g+sCh3XIJcFZLesswe0V+kCAw+JBSd18ESJ4Qko+iDK95cDzucLFwXB10FMVKQCrX90KR+Fp6s6eJHcZGmpxTPgNulDpAjM2APluM3xBCe6zZzt+iNIzn3J8PRKbpNNbuw/LMRU8+udrGbLavUMcSk7ER9pAyLGhz//9aHWDPu7ZRje+vTWgnGFpzbtEzdjnP+2v45nLKWG7o7WdTAsAR8WSccjtNoBiVgSmpHr07zJ0/gTeL4PUkk3lbtzF/PdtTQGm3Ng4SjOBlhRVaTuKBlF2X/Rwq+W4LCbHVgA79MyhJxL2TDbKBPUSLfckqxP89e8Q7iQ4XjIHqVb50ojNNLGcOQRrHq14Twwx/ZDDQvMXCsLwM6vyoYa8KdSaASEr1clx78qNp9PHGlr+UztW+EsoZI7j1tzcHMmq2BSK90= matthew@t480";
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
        openssh.authorizedKeys.keys = [ ci.key1 matthew.key1 matthew.key2 yusuf.key1 ];
      };
      yusuf = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ yusuf.key1 ];
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$wZnyFXlzYYB3kAQd$jNvHAUfrEsPr4ADo8yiKNWId5sBLdUIBvUY6fKCWfMglBoFX497GkU3fslZ6wLEunxvFxoxNUD1/pOdx7ZNXW1";
      };
      matthew = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ matthew.key1 matthew.key2 ];
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$I5AtvK7mlyMXfb/j$pZxeJXTVt5huLfBxOZB0jUFncNh/yoYr39orKn.ZJtUTpLXFRnqdZwDh3s.6zicb.BxPocRkWZYelxC8xggiS/";
      };
      isaac = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ isaac.key1 ];
        extraGroups = [ "wheel" ];
      };
    };
  };
}

