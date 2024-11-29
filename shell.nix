{pkgs ? import <nixpkgs> {}}: let
  fishConfig = pkgs.writeText "devshell-config.fish" ''
    function fish_right_prompt
        echo -n (set_color blue)"[dev home] "(set_color normal)
    end
  '';
in
  pkgs.mkShell {
    packages = with pkgs; [
      alejandra
      helix
      nil
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
