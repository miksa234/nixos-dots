{ ... }:
{
  dendritic.data.networkmanagerProfilesGajba = {
    Gajba = {
      connection = {
        id = "Gajba";
        interface-name = "wlan0";
        type = "wifi";
        uuid = "34880767-ea49-4b44-8f7f-22d0d3fc8cc1";
      };
      ipv4.method = "auto";
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
      ipv4.method = "auto";
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
  };
}
