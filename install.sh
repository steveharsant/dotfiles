#!/usr/bin/env bash

#shellcheck disable=SC1090
#shellcheck disable=SC2010

script_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

### Bash ###
dotfiles=( $( ls $script_path -a | grep bash ) )
for dotfile in "${dotfiles[@]}"; do
  source "$script_path/$dotfile"
done

cat <<EOL >> /etc/bash.bashrc

# Source personal customisations from github.com/steveharsant/dotfiles
dotfiles=( \$( ls $script_path -a | grep bash ) )
for dotfile in "\${dotfiles[@]}"; do
  source "$script_path/\$dotfile"
done
EOL

### vimrc ###
ln -sf "$script_path/.vimrc" /etc/vim/vimrc.local

### screenrc ###
echo "SCREENRC='$script_path/.screenrc" >> /etc/environment

dotfiles=( $( ls /srv/dotfiles -a | grep bash ) )
for dotfile in "${dotfiles[@]}"; do
  source "/srv/dotfiles/$dotfile"
done
