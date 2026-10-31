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
      subversion
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
          editor = "nvim";
          pager = "less -FRX";
          whitespace = "trailing-space,space-before-tab";
        };

        push = {
          default = "simple";
          autoSetupRemote = true;
          followTags = true;
        };

        fetch = {
          prune = true;
          pruneTags = true;
        };

        pull.rebase = true;

        diff = {
          algorithm = "histogram";
          colorMoved = "zebra";
          mnemonicPrefix = true;
          renames = true;
        };

        difftool = {
          prompt = false;
          nvimdiff.layout = "diff2";
        };

        merge = {
          tool = "nvimdiff";
          conflictStyle = "zdiff3";
        };

        mergetool = {
          prompt = false;
          nvimdiff = {
            layout = "LOCAL,BASE,REMOTE / MERGED";
            write = true;
          };
        };

        commit = {
          verbose = true;
          gpgsign = true;
        };

        status = {
          branch = true;
          showStash = true;
          showUntrackedFiles = "all";
        };

        color = {
          ui = "auto";
          diff = "auto";
          status = "auto";
          branch = "auto";
        };

        alias = {
          st = "status -sb";
          co = "checkout";
          sw = "switch";
          br = "branch";
          ci = "commit";
          amend = "commit --amend --no-edit";
          unstage = "restore --staged";
          undo = "reset --soft HEAD~1";
          last = "log -1 HEAD --stat";
          graph = "log --graph --oneline --decorate --all";
          lg = "log --graph --pretty=format:'%C(auto)%h %d %s %C(dim)(%cr) %C(bold blue)<%an>' --all";
          aliases = "config --get-regexp '^alias\\.'";
        };

        help.autocorrect = "prompt";
        rerere.enabled = true;
        rerere.autoupdate = true;
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
