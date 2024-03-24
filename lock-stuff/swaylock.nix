{pkgs, ...}: {
  programs.swaylock = {
    enable = true;
    settings = {
      image = "/home/ntrinite/Downloads/cat.jpg";
      daemonize = true;
      ignore-empty-password = true;
    };
  };
}
