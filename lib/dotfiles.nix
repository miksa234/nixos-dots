{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "115f33302bf01129625bedaf04c33836cc863d9b";
  };
}
