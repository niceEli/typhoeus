{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    prefix = "C-b";

    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    terminal = "tmux-256color";
    sensibleOnTop = false;
    shell = "${pkgs.nushell}/bin/nu";

    extraConfig = ''
      set -g focus-events on
      set -g renumber-windows on
      set -g status-keys vi
      set -g set-clipboard on

      set -as terminal-features ",*:RGB"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      unbind '"'
      unbind %
      bind s split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind z resize-pane -Z

      bind -r n next-window
      bind -r p previous-window
      bind Tab last-window

      bind [ copy-mode
      bind -T copy-mode-vi v   send -X begin-selection
      bind -T copy-mode-vi V   send -X select-line
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y   send -X copy-pipe-and-cancel "clip.exe"
      bind -T copy-mode-vi Escape send -X cancel
      bind -T copy-mode-vi H send -X start-of-line
      bind -T copy-mode-vi L send -X end-of-line
      bind p paste-buffer

      set -g status-position top
      set -g status-interval 5
      set -g status-style "bg=#1c1c1c,fg=#c7c7c7"
      set -g status-left-length 40
      set -g status-right-length 80

      set -g status-left "#[bg=#{?client_prefix,#d7af87,#af87af},fg=#1c1c1c,bold]  #S #[bg=#1c1c1c,fg=default] "
      set -g status-right "#[fg=#767676]#{b:pane_current_path}  #[bg=#303030,fg=#c7c7c7] %a %d %b  %H:%M "

      set -g status-justify left
      setw -g window-status-separator ""
      setw -g window-status-format         "#[fg=#767676] #I #W "
      setw -g window-status-current-format "#[bg=#9e9e9e,fg=#1c1c1c,bold] #I #W#{?window_zoomed_flag, 󰁌,} "
      setw -g window-status-activity-style "fg=#d7af87"
      setw -g monitor-activity on
      set -g visual-activity off

      set -g pane-border-style "fg=#3a3a3a"
      set -g pane-active-border-style "fg=#af87af"
      set -g pane-border-lines heavy

      set -g message-style "bg=#3a3a3a,fg=#c7c7c7"
      set -g message-command-style "bg=#3a3a3a,fg=#87af87"
      setw -g mode-style "bg=#1a3456,fg=#c7c7c7"
    '';
  };
}
