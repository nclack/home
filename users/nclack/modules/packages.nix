{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    bat
    claude-code
    delta
    eza
    fd
    fish
    fzf
    gh
    ghostty
    git
    gnupg
    jq
    markdown-oxide
    marksman
    nb
    pandoc
    pinentry-qt
    readability-cli
    ripgrep
    tig
    tree
    typos-lsp
    vim # provides xxd
    w3m
    xclip
    zoxide

    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    font-awesome

    logseq
    obs-studio
  ];
}
