# Local nginx reverse proxy for development.
# Runs as a launchd service, serves configs from conf.d/ dynamically.
# Scripts that manage configs live in the project repo, not here.
{ pkgs, lib, ... }:
let
  dataDir = "/usr/local/var/gn-nginx";
  confDir = "${dataDir}/conf.d";
  certDir = "${dataDir}/certs";
  logDir = "${dataDir}/logs";
  pidFile = "${dataDir}/nginx.pid";

  nginxConfig = pkgs.writeText "gn-nginx.conf" ''
    worker_processes auto;
    pid ${pidFile};
    error_log ${logDir}/error.log;

    events {
        worker_connections 4096;
        multi_accept on;
    }

    http {
        include ${pkgs.nginx}/conf/mime.types;
        access_log ${logDir}/access.log;
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;

        keepalive_timeout 65;
        keepalive_requests 10000;

        proxy_connect_timeout 5s;
        proxy_read_timeout 300s;
        proxy_send_timeout 60s;

        proxy_socket_keepalive on;

        map $http_upgrade $connection_upgrade {
            default upgrade;
            "" "";
        }

        include ${confDir}/*.conf;
    }
  '';
in
{
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo "Setting up gn-nginx directories..."
    mkdir -p ${confDir} ${certDir} ${logDir}
    chown -R dave:staff ${dataDir}
    chmod -R 755 ${dataDir}
  '';

  launchd.daemons.gn-nginx = {
    serviceConfig = {
      Label = "com.local.nginx-proxy";
      ProgramArguments = [
        "${pkgs.nginx}/bin/nginx"
        "-g"
        "daemon off;"
        "-c"
        "${nginxConfig}"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${logDir}/stdout.log";
      StandardErrorPath = "${logDir}/stderr.log";
    };
  };
}
