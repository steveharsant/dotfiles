#!/usr/bin/env bash

#shellcheck disable=SC2207

script_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Symlinking dotfiles from $script_path to $HOME"

dotfiles=( $(find "$script_path" -maxdepth 1 -name ".*" -type f) )

for dotfile_path in "${dotfiles[@]}"; do
  dotfile=$(basename "$dotfile_path")
  target="$HOME/$dotfile"

  echo "Processing $dotfile..."

  if [[ -e "$target" && ! -L "$target" ]]; then
    echo "  Backing up existing $dotfile to $dotfile.bak"
    mv "$target" "$target.bak"
  fi

  echo "  Creating symlink: $target -> $dotfile_path"
  ln -sf "$dotfile_path" "$target"
done

echo "Dotfiles installation complete!"
