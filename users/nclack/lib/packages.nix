{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      bat
      delta
      eza
      fd
      fish
      fzf
      gh
      git
      markdown-oxide
      marksman
      ripgrep
      tree
      typos-lsp
    ]
    ++ lib.optionals config.xsession.enable [
      xclip
      xsel
    ];
}
