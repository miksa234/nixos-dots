{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "3f09f5d0eb88572f0f31cbfe97a48b05d3bfdb27";

  };
  nvim-config = builtins.fetchGit {
    url = "git://popovic.xyz/config.nvim.git";
    ref = "master";
    rev = "678c7992ad31174a825c896cd724b3a6c155a87c";

  };
}
