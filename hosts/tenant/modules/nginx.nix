{ config, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    certs = {
      "api.ardana.org".email = "marijan.petricevic@platonic.systems";
      "stats.ardana.org".email = "marijan.petricevic@platonic.systems";
      "hello.ardana.org".email = "marijan.petricevic@platonic.systems";
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."api.ardana.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:${toString config.services.dana-circulating-supply.port}";
    };
    virtualHosts."stats.ardana.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:${toString config.services.danaswapstats.port}";
    };
    virtualHosts."hello.ardana.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/".proxyPass = "http://127.0.0.1:${toString config.services.hello-world.port}/";
        "/ctl/ctl/" = {
          proxyPass = "http://0.0.0.0:${toString config.services.ctl-server.port}/";
        };
        "/ctl/ogmios" = {
          proxyPass = "http://127.0.0.1:${toString config.services.cardano-ogmios.port}/";
          proxyWebsockets = true;
        };
        "/ctl/odc/ws" = {
          proxyPass = "http://0.0.0.0:${toString config.services.ogmios-datum-cache.port}/ws";
          proxyWebsockets = true;
        };
      };
    };
  };
}

