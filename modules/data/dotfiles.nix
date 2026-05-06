{ ... }:
{
  dendritic.data.dotfiles = {
    configDots = builtins.fetchGit {
      url = "https://github.com/miksa234/config.git";
      ref = "master";
      rev = "40ce8e88b8e50ba85dabc8a5088d5b3291c1117f";
    };

    configNvim = builtins.fetchGit {
      url = "https://github.com/miksa234/config.nvim.git";
      ref = "main";
      rev = "c5060f64211f8138584cb46d2319d28c41f85f4a";
    };
  };
}
