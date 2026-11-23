{ inputs, pkgs, ... }:
{
  imports = [
    ./options.nix
    inputs.nixos-wsl.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];

  wsl = {
    enable = true;
    defaultUser = "niceeli";

    interop = {
      includePath = true;
      register = true;
    };

    useWindowsDriver = true;

    wslConf.automount = {
      enabled = true;
      mountFsTab = true;
    };

    docker-desktop.enable = true;

    extraBin = with pkgs; [
      { src = "${coreutils}/bin/install"; }
      { src = "${coreutils}/bin/mv"; }
    ];
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "niceeli"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
  programs.fuse = {
    enable = true;
    userAllowOther = true;
  };

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    vim
    wget
    curl
    xdg-utils
    wsl-open
    fuse
    fuse3
    appimage-run
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.niceeli = import ../../home/niceeli.nix;
  };

  time.timeZone = "America/Toronto";
}
