#!/usr/bin/env bash

# shellcheck disable=SC2010

# Installs dotfiles for the current user

script_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
dotfiles=$(ls "$script_path" -ap | grep '^\.' | grep -v '/')

for dotfile in $dotfiles; do
    echo "Installing $dotfile"
    ln -sf "$script_path/$dotfile" "$HOME/$dotfile"
done
