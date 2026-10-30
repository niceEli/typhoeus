{
  pkgs,
  osConfig,
  inputs,
  ...
}:
let
  gpg-key = osConfig.niceeli.gpgKey;
in
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  imports = [
    inputs.nixvim.homeModules.nixvim
    ./nvim
    ./shell/nushell.nix
    ./shell/tmux.nix
  ];

  home = {
    username = "niceeli";
    homeDirectory = "/home/niceeli";
    stateVersion = osConfig.system.stateVersion;

    packages = with pkgs; [
      ripgrep
      fd
      jq
      btop
      fastfetch
      lazygit
    ];
  };

  programs = {
    home-manager.enable = true;

    gpg = {
      enable = true;
      settings = {
        default-key = gpg-key;
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Eli Cardoso-Grdovic";
          email = "tape-infix.3m@icloud.com";
        };
        init.defaultBranch = "master";
        core = {
          autocrlf = "input";
          eol = "lf";
        };
        diff = {
          tool = "nvimdiff";
          algorithm = "histogram";
          colorMoved = "zebra";
        };
        difftool.prompt = false;
        merge.tool = "nvimdiff";
      };
      signing = {
        key = gpg-key;
        signByDefault = true;
      };
    };

    nushell = {
      enable = true;
      loadSessionVariables = true;
    };

    bash = {
      enable = true;
      initExtra = ''
        if [[ $(ps --no-header --pid=$PPID --format=comm) != "nu" ]] && [[ -z "$BASH_EXECUTION_STRING" ]]; then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.nushell}/bin/nu $LOGIN_OPTION
        fi
      '';
    };

    oh-my-posh = {
      enable = true;
      enableNushellIntegration = true;
      settings = builtins.fromJSON (builtins.readFile ./shell/config.omp.json);
    };

    yazi = {
      enable = true;
      enableNushellIntegration = true;
    };

    devenv = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
  services = {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-curses;
    };
  };
}
