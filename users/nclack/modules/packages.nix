{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    bat
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
    gemini-cli
    delta
    eza
    fd
    fish
    ffmpeg-full
    fzf
    gh
    ghostty
    git
    gnupg
    jq
    markdown-oxide
    marksman
    nb
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
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    font-awesome

    logseq
    (obs-studio.override {
      cudaSupport = true;
    })
  ];
}
