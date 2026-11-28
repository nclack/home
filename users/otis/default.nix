{...}: {
  home-manager.users.otis = import ./home.nix;

  users.users.otis = {
    isNormalUser = true;
    description = "Otis";
    initialHashedPassword = "$y$j9T$.rphMD08/7LpVJxJzZp2U/$61oyhNDzA1beC7sXPXAM1ymvPni2jA5ul/YUBc.DHbD";
  };
}
