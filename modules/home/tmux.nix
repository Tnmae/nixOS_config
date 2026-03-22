{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-s";
    clock24 = true;
    baseIndex = 1;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.catppuccin
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig =
    ''
      set -g default-terminal "tmux-256color"

      set -g @catppuccin-window-status-style "rounded"

      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      set-option -g set-titles on
      set-option -g status-position top
      set -g @catppuccin-flavour 'mocha'
    '';
    mouse = true;
  };
}
