{pkgs, ...}: 

let
  claude-code = pkgs.stdenv.mkDerivation {
    pname = "claude-code";
    version = "0.1.0";
    
    dontUnpack = true;
    
    buildInputs = with pkgs; [
      nodejs
      makeWrapper
    ];
    
    propagatedBuildInputs = with pkgs; [
      git
      gh
      ripgrep
    ];
    
    installPhase = ''
      mkdir -p $out/bin
      
      # Install Claude Code globally
      export HOME=$TMPDIR
      ${pkgs.nodejs}/bin/npm install -g @anthropic/claude-code --prefix $out
      
      # Ensure dependencies are available
      wrapProgram $out/bin/claude-code --prefix PATH : ${pkgs.lib.makeBinPath [
        pkgs.git
        pkgs.gh
        pkgs.ripgrep
      ]}
    '';
    
    meta = with pkgs.lib; {
      description = "Claude Code - Anthropic's command-line AI tool";
      homepage = "https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview";
      license = licenses.unfree;
      platforms = platforms.unix;
      mainProgram = "claude-code";
    };
  };

in {
  home.packages = [
    claude-code
  ];

}
