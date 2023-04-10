{ config, pkgs, ... }:

{
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "andy@tck.mn";
  security.acme.certs."tsetse.tck.mn".extraDomainNames = [
    "dyn.tck.mn"
    "pzplus.tck.mn"
  ];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "tsetse.tck.mn" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5353";
        };
        locations."/ws/" = {
          proxyPass = "http://127.0.0.1:5354";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_read_timeout 86400;
          '';
        };
      };
      "pzplus.tck.mn" = {
        forceSSL = true;
        useACMEHost = "tsetse.tck.mn";
        locations."/" = {
          proxyPass = "http://127.0.0.1:2345";
        };
      };
      "dyn.tck.mn" = {
        forceSSL = true;
        useACMEHost = "tsetse.tck.mn";
        locations."/" = {
          proxyPass = "http://127.0.0.1:1729";
          extraConfig = ''
            add_header 'Access-Control-Allow-Origin' 'https://tck.mn' always;
            add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, DELETE, PUT' always;
            add_header 'Access-Control-Allow-Credentials' 'true' always;
            add_header 'Access-Control-Allow-Headers' 'User-Agent,Keep-Alive,Content-Type' always;
          '';
        };
      };
    };
  };
}
