{ ... }:
{
  dendritic.data.networkmanagerProfilesWireguard = {
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
      wireguard.private-key = "$wg0_ponnect_prv";
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
      wireguard.private-key = "$wg0_router_prv";
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
      wireguard.private-key = "$wg0_server_prv";
      "wireguard-peer.HLNNBQypzLWhWE4UFB2zd7bk9pmAC4iWM8qpDeDGwDw=" = {
        allowed-ips = "0.0.0.0/0;::/0;";
        endpoint = "213.136.71.18:1194";
        preshared-key = "$wg0_server_pre";
        preshared-key-flags = "0";
      };
    };
  };
}
