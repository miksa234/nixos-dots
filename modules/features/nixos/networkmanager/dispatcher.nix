{ ... }:
{
  dendritic.modules.nixos.networkmanager-dispatcher =
    { pkgs, ... }:
    {
      networking.networkmanager.dispatcherScripts = [
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
    };
}
