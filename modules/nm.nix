{ pkgs, config, ... }:
{
  sops = {
    secrets = {
      "networking/gajba" = {};
      "networking/wg0_ponnect_prv" = {};
      "networking/wg0_ponnect_pre" = {};
      "networking/wg0_router_prv" = {};
      "networking/wg0_server_prv" = {};
      "networking/wg0_server_pre" = {};
    };
    templates.wifi = {
      content = ''
        Gajba=${config.sops.placeholder."networking/gajba"}
        wg0_ponnect_prv=${config.sops.placeholder."networking/wg0_ponnect_prv"}
        wg0_ponnect_pre=${config.sops.placeholder."networking/wg0_ponnect_pre"}
        wg0_router_prv=${config.sops.placeholder."networking/wg0_router_prv"}
        wg0_server_prv=${config.sops.placeholder."networking/wg0_server_prv"}
        wg0_server_pre=${config.sops.placeholder."networking/wg0_server_pre"}
      '';
    };
  };

  networking.networkmanager = {
    enable = true;
    dispatcherScripts = [
      {
        source = pkgs.writeShellScriptBin "09-timezone" ''
          #!/bin/sh
          INTERFACE="$1"
          ACTION="$2"

          case "$2" in
            up)
              if [[ $INTERFACE == "wlan0" ]]; then
                  timedatectl set-timezone "$(curl --fail https://ipapi.co/timezone)"
              fi
              ;;
            down)
              if [[ $INTERFACE == "wlan0" ]]; then
                  ./home/mika/.local/bin/scripts/vpn stop
              fi
              ;;
          esac
        '';
      }
    ];
    ensureProfiles = {
      environmentFiles = [ config.sops.templates.wifi.path ];
      profiles = {

        Gajba = {
          connection = {
            id = "Gajba";
            interface-name = "wlan0";
            type = "wifi";
            uuid = "34880767-ea49-4b44-8f7f-22d0d3fc8cc1";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "Gajba";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$Gajba";
          };
        };

        Gajba_5G = {
          connection = {
            id = "Gajba_5G";
            interface-name = "wlan0";
            timestamp = "1765067220";
            type = "wifi";
            uuid = "3fffdcbb-a859-4eb9-bd3e-55cd74403267";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "Gajba_5G";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$Gajba";
          };
        };

        wg0-ponnect = {
          connection = {
            autoconnect = "false";
            id = "wg0-ponnect";
            interface-name = "wg0-ponnect";
            type = "wireguard";
            uuid = "b60f69f7-8e2a-4e7f-93ec-027d5a1a1f96";
          };
          ipv4 = {
            address1 = "10.0.0.2/32";
            dns = "8.8.4.4;8.8.8.8;";
            dns-search = "~;";
            method = "manual";
          };
          ipv6 = {
            addr-gen-mode = "default";
            address1 = "fd42:42:42::2/128";
            method = "manual";
          };
          proxy = { };
          wireguard = {
            private-key = "$wg0_ponnect_prv";
          };
          "wireguard-peer.vadaAF6n58daN9sqQ7o2yUjy8CmKXbXSWzIrzVqHUCs=" = {
            allowed-ips = "0.0.0.0/0;::/0;";
            endpoint = "ponnect.rs:1194";
            persistent-keepalive = "25";
            preshared-key = "$wg0_ponnect_pre";
            preshared-key-flags = "0";
          };
        };

        wg0-router = {
          connection = {
            autoconnect = "false";
            id = "wg0-router";
            interface-name = "wg0-router";
            timestamp = "1765706206";
            type = "wireguard";
            uuid = "62cc1ad0-18b9-4405-afec-ae086652510e";
          };
          ipv4 = {
            address1 = "10.0.0.2/32";
            method = "manual";
          };
          ipv6 = {
            addr-gen-mode = "default";
            address1 = "fd42:42:42::2/128";
            method = "manual";
          };
          proxy = { };
          wireguard = {
            private-key = "$wg0_router_prv";
          };
          "wireguard-peer.M1KoNQqQ3zK4hYnblqwJw34x8R46jAJaJlXJKOKxg2g=" = {
            allowed-ips = "0.0.0.0/0;::/0;";
            endpoint = "gajbapt.duckdns.org:51820";
            persistent-keepalive = "25";
          };
        };

        wg0-server = {
          connection = {
            autoconnect = "false";
            id = "wg0-server";
            interface-name = "wg0-server";
            timestamp = "1765706207";
            type = "wireguard";
            uuid = "45a4463f-a008-4c40-be45-5585452959ee";
          };
          ipv4 = {
            address1 = "10.8.0.6/32";
            method = "manual";
          };
          ipv6 = {
            addr-gen-mode = "default";
            address1 = "fd42:42:42::6/128";
            method = "manual";
          };
          proxy = { };
          wireguard = {
            private-key = "$wg0_server_prv";
          };
          "wireguard-peer.HLNNBQypzLWhWE4UFB2zd7bk9pmAC4iWM8qpDeDGwDw=" = {
            allowed-ips = "0.0.0.0/0;::/0;";
            endpoint = "213.136.71.18:1194";
            preshared-key = "$wg0_server_pre";
            preshared-key-flags = "0";
          };

        };
      };
    };
  };
}
