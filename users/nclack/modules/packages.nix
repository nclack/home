{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    bat
    claude-code
    gemini-cli
    delta
    eza
    fd
    fish
    ffmpeg-full
    fzf
    gersemi # cmake formatter
    gh
    ghostty
    git
    gnupg
    jq
    markdown-oxide
    marksman
    nb
    neocmakelsp # cmake lsp
    nixd
    pandoc
    pinentry-qt
    poppler
    readability-cli
    resvg
    ripgrep
    taplo # lsp for toml
    tig
    tree
    typos-lsp
    vim # provides xxd
    w3m
    xclip
    yazi
    zoxide

    # Fonts
    nerd-fonts.jetbrains-mono
    font-awesome

    (obs-studio.override {
      cudaSupport = true;
    })
  ];
}
