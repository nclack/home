{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    bat
    claude-code
    chafa
    inputs.codex-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    mosh
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
    tmux
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
  ];
}
