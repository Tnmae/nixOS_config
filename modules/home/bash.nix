{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      grep = "grep --color=auto";
      ls = "lsd";
      ll = "ls -l";
      la = "ls -lAtr";
      cat = "bat";
    };
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "npm"
        "history"
        "node"
        "rust"
        "deno"
      ];
    };
    # Your environment variables
    initContent = ''
      export GOPATH=$HOME/go
      export PATH="$PATH:$HOME/go/bin"
      export PATH="$PATH:$HOME/.local/bin"
      eval "$(starship init zsh)"
      "fastfetch"
    '';

  };
}
