{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      zsh-fzf-tab
      zsh-autosuggestions
      zsh-syntax-highlighting
      zsh-z
    ];

  };
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "history-substring-search"
        "last-working-dir"
      ];
    };
    initExtra = ''
      export PATH=~/tools:~/dev/workspace/tools:/home/ripxorip/dev/ptools:/home/ripxorip/dev/tools:~/.local/bin:$PATH:~/.cargo/bin
      alias ws="cd ~/dev/workspace"
      alias c="cd"
      alias ..="cd .."
      alias v="nvim"
      alias k="/home/ripxorip/dev/kde/build/kde/applications/kate/bin/kate"
      alias l="exa -la --git --icons"
      alias cat='bat'
      alias less='bat'
      alias s="sudo"
      alias so="source"
      alias gs="git status"
      alias gc="git commit -m"
      alias b="docker_builder.py"
      # alias find='/usr/bin/fd'
      alias ff="find . -name"
      alias r2c="r2 -e asm.cpu=cortex"
      alias rgi="rg --no-ignore --iglob !tags "
      alias gsm="submodutil.py 5 | v -c 'set buftype=nofile'"
      alias gsd="git diff --submodule=diff | v -c 'set ft=diff' -c 'set buftype=nofile'"

      alias sco="~/home/super_checkout.py"
      alias sst="~/home/super_status.py"
      alias scm="~/home/super_commit_msg.py"
      alias srv="~/home/super_git_review.py"
      alias sbr="~/home/super_branch.py"
      alias sso="~/home/super_git_show.py"
      alias sca="~/home/super_commit_all.py"

      alias vc="v -c 'set buftype=nofile' -c '+normal G'"
      alias vd="v -d"
      alias git='LANG=en_US.UTF-8 git'
      alias t='tmux'
      alias gcap="git add -A && git commit -m \"Inc\" && git push"
      alias rv='sudo -E nvim'
      alias ddo="find -name \*.orig -delete"
      alias dbgs="rsync -razhmv --delete ./ ~/shared/debug --exclude='.git/' --exclude='node_modules/' --exclude='.venv/'"
      alias rr="rax2 -r"

      alias markdown_preview="grip -b"

      bindkey -v
      # bindkey ii vi-cmd-mode
      # Appends every command to the history file once it is executed
      setopt inc_append_history
      # Taking care of history
      setopt share_history

      setopt EXTENDED_HISTORY
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_BEEP

      # Accpept suggestions with space
      bindkey '^ ' autosuggest-accept
      bindkey '^o' autosuggest-accept
      # Reloads the history whenever you use it
      setopt share_history

      # fzf keybindings
      # fd - cd to selected directory
      fzvv() {
          local file
          file=$(rg --files --no-ignore | fzf)
          print -s "nvim $file"
          fc -R =(print "nvim $file")
          nvim "$file"
      }

      fzkk() {
          local file
          file=$(rg --files --no-ignore | fzf)
          print -s "k $file"
          fc -R =(print "k $file")
          k "$file"
      }

      fdd() {
        local dir
          dir=$(find ''${1:-.} -path '*/\.*' -prune \
                          -o -type d -print 2> /dev/null | fzf +m) &&
          cd "$dir"
      }

      if [ -n "''${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      zle -N fdd
      zle -N fzvv
      zle -N fzkk
      bindkey "^T" fzvv
      bindkey "^A" fzkk
      bindkey '^G' fdd
      bindkey '^F' fzf-file-widget
      bindkey "^P" up-line-or-search
      bindkey "^N" down-line-or-search

      mkdir -p ~/.history
      # Patch history to a shared directory
      HISTFILE=~/.history/.zsh_history

      # armcompiler6 gdb helper
      function axf_dbg()
      {
          gdb_cmd="gdb-multiarch -ex 'target remote localhost:2331'"
          hex_file=''${1%.*}.hex
          gdb_cmd="$gdb_cmd -ex 'set confirm off'"
          gdb_cmd="$gdb_cmd -ex 'load'"
          gdb_cmd="$gdb_cmd -ex 'monitor SWO EnableTarget 120000000 6000000 1 0'"
          gdb_cmd="$gdb_cmd -ex 'monitor reset'"
          gdb_cmd="$gdb_cmd -ex 'add-symbol-file $1'"
          gdb_cmd="$gdb_cmd -ex 'set \$pc=&Reset_Handler'"
          gdb_cmd="$gdb_cmd -ex 'c'"
          gdb_cmd="$gdb_cmd $hex_file"
          # Start gdb
          eval ''${gdb_cmd}
      }

      # "docker build"
      function db()
      {
          docker_image=$1
          shift
          dcmd="docker run --rm --user 1000:1000 --privileged \
              -w /workspace -v $PWD:/workspace \
              $docker_image /bin/sh -c \"$@\""
          eval ''${dcmd}
      }

      # start working in a docker container
      function ds()
      {
          docker_image=$1
          dcmd="docker run --rm -it \
          --group-add $(stat -c '%g' /var/run/docker.sock) \
          -v /home/ripxorip/dev/workspace:/home/ripxorip/dev/workspace \
          -v /var/run/docker.sock:/var/run/docker.sock \
          -v /home/ripxorip/.history:/home/ripxorip/.history \
          --privileged=true --name $1 \
          $docker_image \
          /bin/zsh -c \
          \"cd ~/.dot && git pull && \
          cd ~/dev/wiki && git pull && \
          cd ~/dev/workspace && \
          /bin/zsh\""
          eval ''${dcmd}
      }

      function stfu()
      {
          "$@" &> /dev/null < /dev/null &
      }

      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'

      export PICO_SDK_PATH=~/dev/pico-sdk

      export FZF_DEFAULT_OPTS=" \
      --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
      --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
      --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

      source ~/.nix-profile/share/fzf-tab/fzf-tab.plugin.zsh
      source ~/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ~/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ~/.nix-profile/share/zsh-z/zsh-z.plugin.zsh
      eval "$(starship init zsh)"
    '';
  };
}
