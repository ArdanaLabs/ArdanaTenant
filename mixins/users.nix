{ config, pkgs, ... }:

let
  isaac = {
    key1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZzKmSxSVqol+YNsGr5Cts5Cr/eIHqCm/KISHsluVtJ isaac@dunlap";
  };
  l33 = {
    key1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4sVElSyrM986QEpsTlrGPXSs1LkkcaxvidnlZhCHBV8V9IPqwfU8TRhJVngL6zOLEt4aPgtdCPeFQgpPMgkheD1AHQWJo6zO4HwXkVcjO8Rw6EdwHznmy6bnIzX4DDPMhWZ9N0Vhn134tsrJGAkX5NvJ19HRSBJlqgYdfPqtNHetAFXXSG2yp99yFfeorJuNFHMTRfsPimDtQ7h9nidW0EEoTcuMU97rdczK6Og11A133ROd0EzNdsZTgJ9iFbYLW9a+Z510Asr8XrF7jylQwau70214ICM0NTkU4fqFeCfRUVhuUYzAUnYIwTdNhsGhfhQQ5rZXGaYea5oRa3o9qgzfgvyry2NdW2fOuolee5AsXPIXe3QPdZVnPwVQMwYGeGar2cdQQwYAUY4G6Ylf+w/KUEWenxJsP2eVX+UxN5F0Qw/eS8wPA02oYoqcmhR9AVeVNY7fMz5DiU9W72c3SqLQAdcGPWhmnfOdCsFpe2CaT/TzcfX5KVrrJe9D5S6fOhb74Lncv/beEb+CoJIPRlFLy9Mq2458yeiXZQbfxJdKYD/zwZR7qWEZ/KHPAW1RUr5Y0gWI3sX8u7FgPVKTj0+PxAWc4SyNq9MLDW5HL44a7izly4PyC728L4Nz/B5F4YsBAinBHoBqx/C9vgn0XKJHBQtUNhUd5XcM1ofEKVQ== 33lockdown33@protomail.com";
    key2 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbfyNtj4t5GvRbFBkIMzK14oyOs5fRSDJARTR49ooXruS6Uf7Lh03anVYod8wIrc4O4arY+5Ect7Ilu96WqhJ2GCwsHv19J93NbXdU6BwO35tO35oXG2tsHfe/2mpS8C3Tm4xbk8vbxHPXiRd6c0mK2i1Cn26E7bFMUIr45QEGlOA3PvwEpPcIX7ica4dWDhTIyhPxPPgDshbhLSmymCiCqUJ4p61U0e1qcOO5nxogH0Ld6JCzEvPQsBI5KVOltHteePA6PISFk79735e5HSdqGtAjqcWXwMtSfRI2jfayh84TJh9P2HLlb+MEYm+3VqqcA+ffN246Idf2//n6siF3 l33@nixos";
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
        openssh.authorizedKeys.keys = [ matthew.key1 matthew.key2 l33.key1 l33.key2 ];
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

