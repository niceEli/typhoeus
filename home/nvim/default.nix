{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    nixpkgs.useGlobalPackages = true;

    colorscheme = "habamax";

    performance = {
      byteCompileLua = {
        enable = true;
        nvimRuntime = true;
        configs = true;
        plugins = true;
      };
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";

      loaded_gzip = 1;
      loaded_tarPlugin = 1;
      loaded_tohtml = 1;
      loaded_tutor = 1;
      loaded_zipPlugin = 1;

      compile_mode.bang_expansion = true;

      clipboard = {
        name = "WSL Clipboard";
        copy = {
          "+" = [ "clip.exe" ];
          "*" = [ "clip.exe" ];
        };
        paste = {
          "+" = [
            "powershell.exe"
            "-NoProfile"
            "-Command"
            "[Console]::Out.Write((Get-Clipboard -Raw).Replace(\"`r\", \"\"))"
          ];
          "*" = [
            "powershell.exe"
            "-NoProfile"
            "-Command"
            "[Console]::Out.Write((Get-Clipboard -Raw).Replace(\"`r\", \"\"))"
          ];
        };
        cache_enabled = false;
      };
    };

    opts = {
      exrc = true;
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 4;
      tabstop = 4;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;
      signcolumn = "yes";
      scrolloff = 10;
      sidescrolloff = 10;
      smoothscroll = true;
      splitright = true;
      splitbelow = true;
      undofile = true;
      swapfile = false;
      updatetime = 250;
      cmdheight = 1;
      mouse = "a";
      incsearch = true;
      hlsearch = true;
      path = [
        "."
        ""
        "**"
      ];
      completeopt = [
        "menu"
        "menuone"
        "noselect"
        "fuzzy"
        "popup"
      ];
      colorcolumn = "80";
      wildoptions = [
        "pum"
        "fuzzy"
      ];
      wildignore = [
        "*/.git/*"
        "*/node_modules/*"
        "*/bin/*"
        "*/obj/*"
      ];
    };

    highlightOverride =
      lib.genAttrs
        [
          "Normal"
          "NormalNC"
          "NormalFloat"
          "FloatBorder"
          "SignColumn"
          "EndOfBuffer"
          "LineNr"
          "CursorLineNr"
          "FoldColumn"
          "WinSeparator"
        ]
        (_: {
          bg = "none";
          ctermbg = "none";
          update = true;
        });

    keymaps = [
      {
        mode = "n";
        key = "<leader>fw";
        action = "<cmd>w<cr>";
        options.desc = "Write file";
      }
      {
        mode = "n";
        key = "<leader>qq";
        action = "<cmd>q<cr>";
        options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>QQ";
        action = "<cmd>qa!<cr>";
        options.desc = "Force quit all";
      }
      {
        mode = "n";
        key = "<leader>fo";
        action.__raw = "function() MiniPick.builtin.buffers() end";
        options.desc = "Open buffers";
      }
      {
        mode = "n";
        key = "<leader>fd";
        action = "<cmd>bdelete<cr>";
        options.desc = "Delete current buffer";
      }
      {
        mode = "n";
        key = "<M-/>";
        action = "<cmd>nohlsearch<cr>";
        options.desc = "Clear search highlight";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<cr>";
        options.desc = "File explorer (oil)";
      }
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<cr>";
        options.desc = "Open parent dir";
      }

      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
      }

      {
        mode = "n";
        key = "<M-h>";
        action = "<cmd>vertical resize -3<cr>";
        options.desc = "Shrink width";
      }
      {
        mode = "n";
        key = "<M-l>";
        action = "<cmd>vertical resize +3<cr>";
        options.desc = "Grow width";
      }
      {
        mode = "n";
        key = "<M-j>";
        action = "<cmd>resize -2<cr>";
        options.desc = "Shrink height";
      }
      {
        mode = "n";
        key = "<M-k>";
        action = "<cmd>resize +2<cr>";
        options.desc = "Grow height";
      }
      {
        mode = "n";
        key = "<M-=>";
        action = "<C-w>=";
        options.desc = "Equalize panes";
      }

      {
        mode = "v";
        key = "<";
        action = "<gv";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
      }

      {
        mode = "i";
        key = "<C-Space>";
        action.__raw = "vim.lsp.completion.get";
        options.desc = "Trigger LSP Completion";
      }
      {
        mode = "t";
        key = "<C-x>";
        action = "<C-\\><C-n>";
      }
      {
        mode = "n";
        key = "<leader><leader>";
        action.__raw = "function() MiniPick.builtin.files() end";
        options.desc = "Quick open";
      }
    ];

    plugins = {
      mini-icons.enable = true;
      mini-pick.enable = true;
      mini-pairs.enable = true;
      mini-statusline.enable = true;

      fidget.enable = true;
      render-markdown.enable = true;

      lspconfig.enable = true;

      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          columns = [
            "permissions"
            "size"
            "mtime"
          ];
          constrain_cursor = false;
          view_options.show_hidden = true;
        };
      };

      image = {
        enable = true;
        settings = {
          backend = "sixel";
          integrations.typst.enabled = false;
        };
      };

      which-key = {
        enable = true;
        settings = {
          icons.mappings = false;
          spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "file";
            }
            {
              __unkeyed-1 = "<leader>q";
              group = "quit";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "code";
            }
          ];
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
      baleia-nvim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "compile-mode-nvim";
        version = "git";
        src = inputs.compile-mode-nvim;
        dependencies = [ plenary-nvim ];
      })
    ];

    extraLuaPackages = ps: [ ps.magick ];
    extraPackages = [ pkgs.ghostscript ];

    diagnostic.settings = {
      virtual_text = {
        spacing = 2;
        source = "if_many";
      };
      signs = true;
      underline = true;
      severity_sort = true;
      update_in_insert = false;
      float = {
        border = "rounded";
        source = true;
        header = "";
        prefix = " ";
      };
    };

    lsp = {
      inlayHints.enable = true;

      completion = {
        enable = true;
        settings.autotrigger = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "gd";
          lspBufAction = "definition";
          options.desc = "Go to definition";
        }
        {
          mode = "n";
          key = "gD";
          lspBufAction = "declaration";
          options.desc = "Go to declaration";
        }
        {
          mode = "n";
          key = "gr";
          lspBufAction = "references";
          options.desc = "Find references";
        }
        {
          mode = "n";
          key = "gi";
          lspBufAction = "implementation";
          options.desc = "Go to implementation";
        }
        {
          mode = "n";
          key = "K";
          lspBufAction = "hover";
          options.desc = "Hover documentation";
        }
        {
          mode = "i";
          key = "<C-k>";
          lspBufAction = "signature_help";
          options.desc = "Signature help";
        }
        {
          mode = "n";
          key = "<leader>ca";
          lspBufAction = "code_action";
          options.desc = "Code action";
        }
        {
          mode = "n";
          key = "<leader>rn";
          lspBufAction = "rename";
          options.desc = "Rename";
        }
        {
          mode = "n";
          key = "<leader>cf";
          action.__raw = "function() vim.lsp.buf.format({ async = true }) end";
          options.desc = "Format";
        }
        {
          mode = "n";
          key = "<leader>d";
          action.__raw = "vim.diagnostic.open_float";
          options.desc = "Line diagnostics";
        }
        {
          mode = "n";
          key = "[d";
          action.__raw = "function() vim.diagnostic.jump({ count = -1, float = true }) end";
          options.desc = "Previous diagnostic";
        }
        {
          mode = "n";
          key = "]d";
          action.__raw = "function() vim.diagnostic.jump({ count = 1, float = true }) end";
          options.desc = "Next diagnostic";
        }
        {
          mode = "n";
          key = "<leader>dl";
          action.__raw = "vim.diagnostic.setloclist";
          options.desc = "Diagnostics list";
        }
        {
          mode = "n";
          key = "<leader>uh";
          action.__raw = "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end";
          options.desc = "Toggle inlay hints";
        }
      ];
    };

    autoCmd = [
      {
        event = "CursorHold";
        callback.__raw = ''
          function()
            vim.diagnostic.open_float(nil, {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = "rounded",
              source = "if_many",
              scope = "cursor",
            })
          end
        '';
      }
    ];

    extraConfigLua = ''
      if vim.o.shell:match("/nu$") then
        vim.opt.shellpipe = "| ^tee"
      end

      vim.g.baleia = require("baleia").setup({})
    '';

    # neovide config
    extraConfigLuaPost = ''
      if vim.g.neovide then
        vim.o.guifont = "DepartureMono Nerd Font,Unifont:h14"
        vim.keymap.set("n", "<F11>", function()
          vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
        end, { desc = "Toggle Neovide fullscreen" })
      end
    '';
  };
}
