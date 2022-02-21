{ config, pkgs, ... }:

let
  isaac = {
    key1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZzKmSxSVqol+YNsGr5Cts5Cr/eIHqCm/KISHsluVtJ isaac@dunlap";
  };
  matthew = {
    key1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD7jt+f8gURZcWeo9Sko5kdPW1ORd+CDXsCxyHgGRK5IVKLrluAEC7ha0xlOQ3WtHEiWj3P9/C9UzATjWaMZU5j/A7Ysib2peBFQZ0roYwHDYVZzutF7HJWBc4WW/CPSjWZfza2jC3e/Qe2ktmnbri0oq27EXYJwhs+/70+VA4NZ5d7xD1CnYhv4LdsudSTLJjsyCL6PLVbtUZKW8avyH359R4rLTkklk9H1d0RYGDkHKMFB5ADdlEJwnjRAbjK94u+M6jhN9ahMrfSsbLUd1DcASMoW7fw+Y16l//7cDr8rN32Mi1Vs/mBvJmnN//84QtqJM2UD/lxI/k8aJEXskojfmBP2qd+mevHfuA30b6BtngeDvh5RPnYYDL28g9iyDKMWtBEYMkyF+kbERiiOkxFpudyB7Vd0fYAZxusqq8EOpVnjj97T0hFbGspam/Q9H5tT4U02JG127Z2+ohq5DUYeiMDh3mOs5uc/R+svj00NJtmEuNdqjtyktYP6zfhiVs= matthew@swordfish";
    key2 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClm+SMN9Bg1HZ+MjH1VQYEXAnslGWT9564pj/KGO79WMQLUxdp3WWa1hQadf2PleAIEFEul3knrpRSEK3yHcCk3g+sCh3XIJcFZLesswe0V+kCAw+JBSd18ESJ4Qko+iDK95cDzucLFwXB10FMVKQCrX90KR+Fp6s6eJHcZGmpxTPgNulDpAjM2APluM3xBCe6zZzt+iNIzn3J8PRKbpNNbuw/LMRU8+udrGbLavUMcSk7ER9pAyLGhz//9aHWDPu7ZRje+vTWgnGFpzbtEzdjnP+2v45nLKWG7o7WdTAsAR8WSccjtNoBiVgSmpHr07zJ0/gTeL4PUkk3lbtzF/PdtTQGm3Ng4SjOBlhRVaTuKBlF2X/Rwq+W4LCbHVgA79MyhJxL2TDbKBPUSLfckqxP89e8Q7iQ4XjIHqVb50ojNNLGcOQRrHq14Twwx/ZDDQvMXCsLwM6vyoYa8KdSaASEr1clx78qNp9PHGlr+UztW+EsoZI7j1tzcHMmq2BSK90= matthew@t480";
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
        openssh.authorizedKeys.keys = [ matthew.key1 matthew.key2 ];
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

