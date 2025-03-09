{pkgs ? import <nixpkgs> {}}: let
  fishConfig = pkgs.writeText "devshell-config.fish" ''
    function fish_right_prompt
        echo -n (set_color blue)"[dev home] "(set_color normal)
    end
    
    # Add npm global bin to PATH
    set -gx PATH $HOME/.npm-packages/bin $PATH
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
      
      nodejs
      nodePackages.npm
    ];

    shellHook = ''
      export EDITOR=hx
      
      # Configure npm to use a different directory for global packages
      mkdir -p $HOME/.npm-packages
      npm config set prefix $HOME/.npm-packages
      export PATH="$HOME/.npm-packages/bin:$PATH"
      
      # Install @anthropic-ai/claude-code if not already available
      if ! command -v claude &> /dev/null; then
        echo "Installing @anthropic-ai/claude-code..."
        npm install -g @anthropic-ai/claude-code
      fi
      
      exec fish -C "source ${fishConfig}"
    '';

    interactiveShellInit = ''
      fzf_key_bindings
      set -U FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"
    '';
  }
