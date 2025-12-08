{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    bat
    claude-code
    delta
    eza
    fd
    fish
    ffmpeg
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
    poppler
    readability-cli
    resvg
    ripgrep
    tig
    tree
    typos-lsp
    vim # provides xxd
    w3m
    xclip
    yazi
    zoxide

    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    font-awesome

    logseq
    obs-studio
  ];
}
