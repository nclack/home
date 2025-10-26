{pkgs ? import <nixpkgs> {}}: let
  fishConfig = pkgs.writeText "devshell-config.fish" ''
    # Create an alias for claude-code using npx
    alias claude="npx @anthropic-ai/claude-code@latest"
  '';
in
  pkgs.mkShell {
    name = "dev-home";

    packages = with pkgs; [
      alejandra
      helix
      nil
      nixd
      markdown-oxide
      marksman
      xclip
      xsel
      git
      gh

      fish
      fzf
      ripgrep
      tree

      # For claude-code
      nodejs
    ];

    shellHook = ''
      export EDITOR=hx
      exec fish -C "source ${fishConfig}"
    '';

    interactiveShellInit = ''
      fzf_key_bindings
      set -U FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"
    '';
  }
