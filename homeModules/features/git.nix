{ inputs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "endofu@gmail.com";
    userName = "endofu";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
