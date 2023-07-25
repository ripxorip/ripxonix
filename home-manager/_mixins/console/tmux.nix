{ pkgs, ... }: {
  programs.tmux = {
    enable = true;

    plugins = [
      pkgs.tmuxPlugins.yank
    ];

    # Replaces ~/.tmux.conf
    extraConfig = ''
      bind-key r source-file ~/.tmux.conf

      # This is how to see colors...
      # for i in {0..255}; do
      #    printf "\x1b[38;5;''${i}mcolour''${i}\x1b[0m\n"
      #    done
      set -g status-style fg=colour240
      set -g pane-border-style fg=colour240
      set -g pane-active-border-style fg=colour245
      set-window-option -g window-status-current-style fg=colour250

      setw -g mouse on
      set -g prefix C-a
      unbind-key C-b
      bind-key C-a send-prefix

      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"

      ## Vim style splitting
      bind-key v split-window -h
      bind-key s split-window -v
      #
      # x is used to kill the split
      set-window-option -g mode-keys vi

      unbind [
      bind a copy-mode
      set -s escape-time 0

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind-key J resize-pane -D 3
      bind-key K resize-pane -U 3
      bind-key H resize-pane -L 3
      bind-key L resize-pane -R 3

      ## Vim syle switching
      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-Left' if-shell "$is_vim" 'send-keys C-Left'  'select-pane -L'
      bind-key -n 'C-Down' if-shell "$is_vim" 'send-keys C-Down'  'select-pane -D'
      bind-key -n 'C-Up' if-shell "$is_vim" 'send-keys C-Up'  'select-pane -U'
      bind-key -n 'C-Right' if-shell "$is_vim" 'send-keys C-Right'  'select-pane -R'

      bind-key m if-shell "$is_vim" 'send-keys C-Left'  'select-pane -L'
      bind-key n if-shell "$is_vim" 'send-keys C-Down'  'select-pane -D'
      bind-key e if-shell "$is_vim" 'send-keys C-Up'  'select-pane -U'
      bind-key i if-shell "$is_vim" 'send-keys C-Right'  'select-pane -R'

      bind-key -T copy-mode-vi 'C-Left' select-pane -L
      bind-key -T copy-mode-vi 'C-Down' select-pane -D
      bind-key -T copy-mode-vi 'C-Up' select-pane -U
      bind-key -T copy-mode-vi 'C-Right' select-pane -R

      # split -v S
      unbind S
      ## bind S split-window <- this is an original line.
      bind S split-window \; select-layout even-vertical

      # split vertically
      unbind |
      ## bind | split-window <- this is an original line.
      bind | split-window -h \; select-layout even-horizontal

      set -g history-limit 20000
      # set-option -g default-shell /bin/zsh
      set-option -g default-shell ''${SHELL}

      set -g @yank_selection_mouse 'primary'
      set -g @yank_selection 'primary'
      set -g @yank_with_mouse on
      # Make middle-mouse-click paste from the primary selection (without having to hold down Shift).
      bind-key -n MouseDown2Pane run "tmux set-buffer -b primary_selection \"$(xsel -o)\"; tmux paste-buffer -b primary_selection; tmux delete-buffer -b primary_selection"

      bind-key -T root F1 select-window -t 0
      bind-key -T root F2 select-window -t 1
      bind-key -T root F3 select-window -t 2
      bind-key -T root F4 select-window -t 3
      bind-key -T root F5 select-window -t 4
      bind-key -T root F6 select-window -t 5
      bind-key -T root F7 select-window -t 6
      bind-key -T root F8 select-window -t 7
      bind-key -T root F9 select-window -t 8

      bind-key -n F10 last-window
      bind-key -n F11 last-window
      bind-key -n F12 source-file ~/.dot/tmux/tmux_build_last.conf

      # Emulate scrolling by sending up and down keys if these commands are running in the pane
      tmux_commands_with_legacy_scroll="less bat man git"

      bind-key -T root WheelUpPane \
              if-shell -Ft= '#{?mouse_any_flag,1,#{pane_in_mode}}' \
              'send -Mt=' \
              'if-shell -t= "#{?alternate_on,true,false} || echo \"#{tmux_commands_with_legacy_scroll}\" | grep -q \"#{pane_current_command}\"" \
              "send -t= Up;send -t= Up;send -t= Up" "copy-mode -et="'

              bind-key -T root WheelDownPane \
                  if-shell -Ft = '#{?pane_in_mode,1,#{mouse_any_flag}}' \
                  'send -Mt=' \
                  'if-shell -t= "#{?alternate_on,true,false} || echo \"#{tmux_commands_with_legacy_scroll}\" | grep -q \"#{pane_current_command}\"" \
                  "send -t= Down;send -t= Down;send -t= Down" "send -Mt="'

      # --> Catppuccin (Macchiato)
      thm_bg="#181926"
      thm_fg="#cad3f5"
      thm_cyan="#91d7e3"
      thm_black="#1e2030"
      thm_gray="#494d64"
      thm_magenta="#c6a0f6"
      thm_pink="#f5bde6"
      thm_red="#ed8796"
      thm_green="#a6da95"
      thm_yellow="#eed49f"
      thm_blue="#8aadf4"
      thm_orange="#f5a97f"
      thm_black4="#5b6078"

      # ----------------------------=== Theme ===--------------------------


      # status
      set -g status "on"
      set -g status-bg "''${thm_bg}"
      set -g status-justify "left"
      set -g status-left-length "100"
      set -g status-right-length "100"

      # messages
      set -g message-style "fg=''${thm_cyan},bg=''${thm_gray},align=centre"
      set -g message-command-style "fg=''${thm_cyan},bg=''${thm_gray},align=centre"

      # panes
      set -g pane-border-style "fg=''${thm_gray}"
      set -g pane-active-border-style "fg=''${thm_blue}"

      # windows
      setw -g window-status-activity-style "fg=''${thm_fg},bg=''${thm_bg},none"
      setw -g window-status-separator ""
      setw -g window-status-style "fg=''${thm_fg},bg=''${thm_bg},none"

      # --------=== Statusline

      set -g status-left ""
      set -g status-right "#[fg=$thm_pink,bg=$thm_bg,nobold,nounderscore,noitalics]#[fg=$thm_bg,bg=$thm_pink,nobold,nounderscore,noitalics] #[fg=$thm_fg,bg=$thm_gray] #W #{?client_prefix,#[fg=$thm_red],#[fg=$thm_green]}#[bg=$thm_gray]#{?client_prefix,#[bg=$thm_red],#[bg=$thm_green]}#[fg=$thm_bg] #[fg=$thm_fg,bg=$thm_gray] #S "

      # current_dir
      setw -g window-status-format "#[fg=$thm_bg,bg=$thm_blue] #I #[fg=$thm_fg,bg=$thm_gray] #{b:pane_current_path} "
      setw -g window-status-current-format "#[fg=$thm_bg,bg=$thm_orange] #I #[fg=$thm_fg,bg=$thm_bg] #{b:pane_current_path} "

      # parent_dir/current_dir
      # setw window-status-format "#[fg=colour232,bg=colour111] #I #[fg=colour222,bg=colour235] #(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev) "
      # setw window-status-current-format "#[fg=colour232,bg=colour208] #I #[fg=colour255,bg=colour237] #(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev) "

      # --------=== Modes
      setw -g clock-mode-colour "''${thm_blue}"
      setw -g mode-style "fg=''${thm_pink} bg=''${thm_black4} bold"

    '';
  };
}
