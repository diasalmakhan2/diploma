{ pkgs, ... }: {
  channel = "stable-24.05";

  packages = [
    pkgs.flutter
    pkgs.jdk17
    pkgs.android-tools
  ];

  idx.previews = {
    enable = true;
    previews = {
      android = {
        manager = "flutter";
      };
      web = {
        command = [
          "flutter"
          "run"
          "-d"
          "web-server"
          "--web-hostname"
          "0.0.0.0"
          "--web-port"
          "$PORT"
        ];
        manager = "web";
      };
    };
  };
}
