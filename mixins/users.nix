{ config, pkgs, ... }:

let
  yusuf = {
    key1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUeDBW4hnHgnT0SjVFeGDztht9owObSmiyWXmmIEGQp2IMPqFpCxkOU61osvfCf4ZT92Ok9iJTohLwFBvHJRD/+CH8/b54sgFAx1lLObkJOMLz4iWZ5y4fNtBYuIA2McQSQoMDpDz6TDym7v7HF7zoUyBmfHMT/9WiX/z6Ft9hY63eh9DcF7WVURzeUvXLApt9wUYUxxdC2KZ/VrDPrIOxCcOgj3le+1zTiD8zwfAGhkzRD3IEx0yCYK6oztrh6WTwA5ZW+cLziH2sVEvSHFa2O398gIvZpzsdYTcQt06d/oyZIvftcpxD8IvjpGgHEsN/mAg0ovexyqAVk+TV/1XySKaoPPVCekap0R50CVD9kEk+GlD78XBYi++aAMIq0/D+NOXkgksfODt3yJPPzQx4KH8gcn0dQJM5zeyTwDfclzMRqCwL1eVHY00EbtG9IcLmMsWk/lM6vpHfyHqHlqNJ3CnUuDBccz9p5ORC1cuj4r9CmXPPmh7OYk7gGiQb4oxuqsYClzp93qmU7qMvGwmxBJaVagNIJgBqb5fsne0OMlcer5CH4L31ozszkSkzCXtFWNoTdgQHU1J3DxxL9WQJCfKku4EPJadYOh80USnauOke5CqfsGtf6uMq4l5Ylcc1QcNhRqxpeTLAIZx0EYDhmQ4eGjAZbiv6ddUp9dAdiQ==";
  };
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
        openssh.authorizedKeys.keys = [ ci.key1 yusuf.key1 marijan.key1 ];
      };
      yusuf = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ yusuf.key1 ];
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$wZnyFXlzYYB3kAQd$jNvHAUfrEsPr4ADo8yiKNWId5sBLdUIBvUY6fKCWfMglBoFX497GkU3fslZ6wLEunxvFxoxNUD1/pOdx7ZNXW1";
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

