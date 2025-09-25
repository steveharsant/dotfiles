#!/usr/bin/env bash

# shellcheck disable=SC1090
# shellcheck disable=SC2207
# shellcheck disable=SC1091

# Only apply the below for interactive shells
case $- in
    *i*) ;;
      *) return;;
esac

# History & Prompt
HISTCONTROL=ignoreboth
HISTFILESIZE=20000
HISTSIZE=10000
HISTIGNORE="clear:history:man"
PROMPT_COMMAND='history -a; history -n'
PROMPT_DIRTRIM=2

PS1="\[\033[38;5;39m\]\u\
\[$(tput sgr0)\]\[\033[38;5;7m\]@\
\[$(tput sgr0)\]\[\033[38;5;201m\]\
$(echo "${HOSTNAME:-$(hostname)}" | cut -d. -f1-2)\
\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;7m\]\w\
\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;39m\]\\$\
\[$(tput sgr0)\] \[$(tput sgr0)\]"

# Shell Options
shopt -s cdable_vars
shopt -s cdspell 2> /dev/null
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell 2> /dev/null
shopt -s histappend

# Bindings
bind '"\e[A": history-search-backward' > /dev/null 2>&1
bind '"\e[B": history-search-forward' > /dev/null 2>&1
bind '"\e[C": forward-char' > /dev/null 2>&1
bind '"\e[D": backward-char' > /dev/null 2>&1
bind "set mark-symlinked-directories on" > /dev/null 2>&1
bind Space:magic-space > /dev/null 2>&1

# Source external config files
source_files=(
  "$HOME/.bash_aliases"
  "$HOME/.local/bin/env"
  "$HOME/.tokens"
  '/usr/share/bash-completion/bash_completion'
  '/usr/share/doc/fzf/examples/key-bindings.bash'
)

for file in "${source_files[@]}"; do
  [ -f "$file" ] && . "$file"
done

# Configure/init external binaries
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)" # Extend less
[ -x /usr/bin/oh-my-posh ] && eval "$(oh-my-posh init bash)" # OMP Prompt

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export PATH=$PATH:$HOME/.tfenv/bin


# Helper functions
tldr () {
  if command -v curl &> /dev/null; then curl "https://cheat.sh/tldr:$1"
  elif command -v wget &> /dev/null; then wget -qO - "https://cheat.sh/tldr:$1"
  else echo 'Needs either curl or wget to function'
  fi
}

# Debian derivative specific behaviour
if [ -f "/etc/debian_version" ]; then
  update-repo() { # Update specific repo
      for source in "$@"; do
        sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/${source}" \
          -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
      done
  }

  _ppa_lists(){ # Auto complete for above function
    local cur
    _init_completion || return
    COMPREPLY=( $( find /etc/apt/sources.list.d/ -name "*$cur*.list" \
      -exec basename {} \; 2> /dev/null ) )
    return 0
  } && complete -F _ppa_lists update-repo
fi
