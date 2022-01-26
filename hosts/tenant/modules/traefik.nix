{ config, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.traefik = {
    enable = true;
    dynamicConfigOptions = {
      http.middlewares.redirect-to-https.redirectscheme = {
        scheme = "https";
        permanent = true;
      };
      http = {
        services = {
          dana-circulating-supply.loadBalancer.servers = [ { url = "http://127.0.0.1:${toString config.services.dana-circulating-supply.port}"; } ];
          danaswapstats.loadBalancer.servers = [ { url = "http://127.0.0.1:${toString config.services.danaswapstats.port}"; } ];
        };
        routers = {
          dana-circulating-supply-insecure = {
            rule = "Host(`api.ardana.org`)";
            entryPoints = [ "web" ];
            service = "dana-circulating-supply";
            middlewares = "redirect-to-https";
          };
          dana-circulating-supply = {
            rule = "Host(`api.ardana.org`)";
            entryPoints = [ "websecure" ];
            service = "dana-circulating-supply";
            tls.certresolver = "letsencrypt";
          };
          danaswapstats-insecure = {
            rule = "Host(`stats.ardana.org`)";
            entryPoints = [ "web" ];
            service = "danaswapstats";
            middlewares = "redirect-to-https";
          };
          danaswapstats = {
            rule = "Host(`stats.ardana.org`)";
            entryPoints = [ "websecure" ];
            service = "danaswapstats";
            tls.certresolver = "letsencrypt";
          };
        };
      };
    };

    staticConfigOptions = {
      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };

      entryPoints.web.address = ":80";
      entryPoints.websecure.address = ":443";

      certificatesResolvers = {
        letsencrypt.acme = {
          email = "letsencrypt@croughan.sh";
#          caServer = "https://acme-staging-v02.api.letsencrypt.org/directory"; # Uncomment to use ACME staging server
          storage = "/var/lib/traefik/cert.json";
          httpChallenge = {
            entryPoint = "web";
          };
        };
      };
    };
  };
}
