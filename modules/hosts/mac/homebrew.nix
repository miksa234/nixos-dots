{ ... }:
{
  dendritic.modules.darwin.host-mac-homebrew =
    { ... }:
    {
      homebrew = {
        enable = true;
        user = "mika";
        prefix = "/opt/homebrew";
        brews = [
          "cocoapods"
          "fastlane"
          "watchman"
        ];
        casks = [ ];
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };
      };
    };
}
