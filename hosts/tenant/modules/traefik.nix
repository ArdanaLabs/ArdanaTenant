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
          dana-circulating-supply.loadBalancer.servers = [{ url = "http://127.0.0.1:${toString config.services.dana-circulating-supply.port}"; }];
          danaswapstats.loadBalancer.servers = [{ url = "http://127.0.0.1:${toString config.services.danaswapstats.port}"; }];
          hello-world.loadBalancer.servers = [{ url = "http://127.0.0.1:${toString config.services.hello-world.port}"; }];
          ctl-server.loadBalancer.servers = [{ url = "http://127.0.0.1:${toString config.services.ctl-server.port}"; }];
          cardano-ogmios.loadBalancer.servers = [{ url = "http://127.0.0.1:${toString config.services.cardano-ogmios.port}"; }];
          ogmios-datum-cache.loadBalancer.servers = [{ url = "http://127.0.0.1:${toString config.services.ogmios-datum-cache.port}"; }];
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
          hello-world-insecure = {
            rule = "Host(`hello.ardana.org`)";
            entryPoints = [ "web" ];
            service = "hello-world";
            middlewares = "redirect-to-https";
          };
          hello-world = {
            rule = "Host(`hello.ardana.org`)";
            entryPoints = [ "websecure" ];
            service = "hello-world";
            tls.certresolver = "letsencrypt";
          };

          # CTL runtime dependencies
          ctl-server-insecure = {
            rule = "Host(`hello.ardana.org`) && Path(`/ctl/ctl`)";
            entryPoints = [ "web" ];
            service = "hello-world";
            middlewares = "redirect-to-https";
          };
          ctl-server = {
            rule = "Host(`hello.ardana.org`) && Path(`/ctl/ctl`)";
            entryPoints = [ "websecure" ];
            service = "hello-world";
            tls.certresolver = "letsencrypt";
          };
          cardano-ogmios-insecure = {
            rule = "Host(`hello.ardana.org`) && Path(`/ctl/ogmios`)";
            entryPoints = [ "web" ];
            service = "hello-world";
            middlewares = "redirect-to-https";
          };
          cardano-ogmios = {
            rule = "Host(`hello.ardana.org`) && Path(`/ctl/ogmios`)";
            entryPoints = [ "websecure" ];
            service = "hello-world";
            tls.certresolver = "letsencrypt";
          };
          ogmios-datum-cache-insecure = {
            rule = "Host(`hello.ardana.org`) && Path(`/ctl/odt`)";
            entryPoints = [ "web" ];
            service = "hello-world";
            middlewares = "redirect-to-https";
          };
          ogmios-datum-cache = {
            rule = "Host(`hello.ardana.org`) && Path(`/ctl/odt`)";
            entryPoints = [ "websecure" ];
            service = "hello-world";
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
          # caServer = "https://acme-staging-v02.api.letsencrypt.org/directory"; # Uncomment to use ACME staging server
          storage = "/var/lib/traefik/cert.json";
          httpChallenge = {
            entryPoint = "web";
          };
        };
      };
    };
  };
}
