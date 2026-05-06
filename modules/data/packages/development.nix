{ ... }:
{
  dendritic.data.packageSetDevelopment =
    { pkgs }:
    with pkgs;
    {
      development = [
        gh
        tree-sitter
        python313Packages.tiktoken
        python313Packages.pylatexenc
        luajitPackages.jsregexp
        nil
        marksman
        nodejs
        pnpm
        cmake
        gnumake
        gcc
        luarocks
        javaPackages.compiler.openjdk17
        lua5_1
        go
        ruby
        php
        julia-bin
        python3
        python313Packages.pip
        rustup
      ];
    };
}
