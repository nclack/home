{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    bat
    delta
    eza
    fd
    fish
    fzf
    gh
    git
    gnupg
    jq
    markdown-oxide
    marksman
    nb
    pandoc
    pinentry-gnome3
    readability-cli
    ripgrep
    tig
    tree
    typos-lsp
    vim # provides xxd
    w3m

    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    font-awesome

    logseq
    obs-studio
  ];
}
