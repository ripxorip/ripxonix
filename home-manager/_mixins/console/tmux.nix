{ pkgs, darkmode, ... }:
let
  light_theme = ''
    ## COLORSCHEME: gruvbox light (medium)
    #
    # Some colors are not used by gruvbox light medium theme.
    # The main idea is to find best version of colors that fit
    # the spirit of gruvbox light theme with limited numbers of
    # 256 color palette.

    set-option -g status "on"

    # default statusbar colors
    set-option -g status-style bg=colour252,fg=colour239 # bg=notInGruvboxPallete, #fg=fg1

    # default window title colors
    set-window-option -g window-status-style bg=colour66,fg=colour229 # bg=aqua, fg=bg5

    # default window with an activity alert
    set-window-option -g window-status-activity-style bg=colour237,fg=colour241 # bg=bg1, fg=notInGruvboxPallete

    # active window title colors
    set-window-option -g window-status-current-style bg=default,fg=colour237 # bg=default, fg=bg1

    # pane border
    set-option -g pane-active-border-style fg=colour241 # fg=notInGruvboxPallete
    set-option -g pane-border-style fg=colour252 # bg1=notInGruvboxPallete

    # message infos (visible while writing command)
    set-option -g message-style bg=colour252,fg=colour241 # bg=notInGruvboxPallete, fg=notInGruvboxPallete

    # writing commands inactive
    set-option -g message-command-style bg=colour124,fg=colour241 # bg=notInGruvboxPallete, fg=notInGruvboxPallete

    # pane number display
    set-option -g display-panes-active-colour colour241 # notInGruvboxPallete
    set-option -g display-panes-colour colour248 # notInGruvboxPallete

    # clock
    set-window-option -g clock-mode-colour colour172 # orange

    # bell
    set-window-option -g window-status-bell-style bg=colour124,fg=colour229 # bg=red, fg=bg

    ## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
    set-option -g status-justify "left"
    set-option -g status-left-style none
    set-option -g status-left-length "80"
    set-option -g status-right-style none
    set-option -g status-right-length "80"
    set-window-option -g window-status-separator ""

    set-option -g status-left "#[bg=colour243,fg=colour255] #S #[bg=colour252,fg=colour243,nobold,noitalics,nounderscore]"
    set-option -g status-right "#[bg=colour252,fg=colour243,nobold,nounderscore,noitalics]#[bg=colour243,fg=colour255] %Y-%m-%d  %H:%M #[bg=colour243,fg=colour237,nobold,noitalics,nounderscore]#[bg=colour237,fg=colour255] #h "

    set-window-option -g window-status-current-format "#[bg=colour215,fg=colour252,nobold,noitalics,nounderscore]#[bg=colour215,fg=colour239] #I #[bg=colour215,fg=colour239,bold] #W#{?window_zoomed_flag,*Z,} #[bg=colour252,fg=colour215,nobold,noitalics,nounderscore]"
    set-window-option -g window-status-format "#[bg=colour249,fg=colour252,noitalics]#[bg=colour249,fg=colour241] #I #[bg=colour249,fg=colour241] #W #[bg=colour252,fg=colour249,noitalics]"

    set-option -g mode-style "fg=gray, bg=blue"
  '';

  dark_theme = ''
        ## COLORSCHEME: gruvbox dark (medium)
    set-option -g status "on"

    # default statusbar color
    set-option -g status-style bg=colour237,fg=colour15 # bg=bg1, fg=fg1

    # default window title colors
    set-window-option -g window-status-style bg=colour4,fg=colour237 # bg=yellow, fg=bg1

    # default window with an activity alert
    set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

    # active window title colors
    set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

    # pane border
    set-option -g pane-active-border-style fg=colour250 #fg2
    set-option -g pane-border-style fg=colour237 #bg1

    # message infos
    set-option -g message-style bg=colour239,fg=colour15 # bg=bg2, fg=fg1

    # writing commands inactive
    set-option -g message-command-style bg=colour239,fg=colour15 # bg=fg3, fg=bg1

    # pane number display
    set-option -g display-panes-active-colour colour250 #fg2
    set-option -g display-panes-colour colour237 #bg1

    # clock
    set-window-option -g clock-mode-colour colour109 #blue

    # bell
    set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

    ## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
    set-option -g status-justify "left"
    set-option -g status-left-style none
    set-option -g status-left-length "80"
    set-option -g status-right-style none
    set-option -g status-right-length "80"
    set-window-option -g window-status-separator ""

    set-option -g status-left "#[bg=colour241,fg=colour248] #S #[bg=colour237,fg=colour241,nobold,noitalics,nounderscore]"
    set-option -g status-right "#[bg=colour237,fg=colour239 nobold, nounderscore, noitalics]#[bg=colour239,fg=colour246] %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #h "

    set-window-option -g window-status-current-format "#[bg=colour4,fg=colour237,nobold,noitalics,nounderscore]#[bg=colour4,fg=colour239] #I #[bg=colour4,fg=colour239,bold] #W#{?window_zoomed_flag,*Z,} #[bg=colour237,fg=colour4,nobold,noitalics,nounderscore]"
    set-window-option -g window-status-format "#[bg=colour239,fg=colour237,noitalics]#[bg=colour239,fg=colour15] #I #[bg=colour239,fg=colour15] #W #[bg=colour237,fg=colour239,noitalics]"

  '';

  theme = if darkmode then dark_theme else light_theme;
in
{
  programs.tmux = {
    enable = true;

    plugins = [
      pkgs.tmuxPlugins.yank
      pkgs.tmuxPlugins.resurrect
    ];

    # Replaces ~/.tmux.conf
    extraConfig = ''
        bind-key r source-file ~/.config/tmux/tmux.conf

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

      ${theme}

    '';
  };
}
