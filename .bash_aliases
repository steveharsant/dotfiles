#!/usr/bin/env bash

# Dynamically set aliases if the binary exists
aliases=("top=htop" "ssh=sshrc asd")
for a in "${aliases[@]}"; do
  [[ "$a" =~ ^(.*)=(.*)$ ]]
  root_command=$(echo "${BASH_REMATCH[2]}" | cut -d ' ' -f1)
  if [ "$(command -v "$root_command")" ]
    then alias "${BASH_REMATCH[1]}"="${BASH_REMATCH[2]}"
  fi
done

# General
alias ll='ls -lah'
alias rm='rm -f'
alias clrlast='history -d -2'

# Docker
alias dk="docker"
alias dkc="docker container"
alias dkcip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dkcll="docker ps --format 'Name:         {{.Names}}\n└─Status:       {{.Status}}\n└─Container ID: {{.ID}}\n└─Image:        {{.Image}}\n└─Command:      {{.Command}}\n└─Ports:        {{.Ports}}\n└─Mounts:       {{.Mounts}}\n└─Networks:     {{.Networks}}\n└─Created:      {{.RunningFor}}\n'"
alias dkcls="docker ps --format 'Name:         {{.Names}}\n└─Status:       {{.Status}}\n└─Container ID: {{.ID}}\n└─Image:        {{.Image}}\n└─Ports:        {{.Ports}}\n'"
alias dkcx="docker exec -it"
alias dki="docker image"
alias dkils="docker image ls"
alias dkix="docker run -it"

# Files & filesystem
alias lg='ls -lah | grep'
alias rcgrep='grep -rnw ./ -e '
alias repos='grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/*'

# Network
alias pg='ping google.com'
alias pgd='ping 8.8.8.8'
alias xip='curl https://api.ipify.org && echo '
alias flushdns='sudo systemd-resolve --flush-caches'
# Shortened binaries
alias py='python3'
alias pip='pip3'
alias tf='terraform'
alias vg='vagrant'

# sudo [command]
alias arp-scan='sudo arp-scan'
alias powershell='sudo powershell'
alias init='sudo init'

# Typo Correction
alias instsall='install'
alias ipconfig='ifconfig'
alias sudo='sudo '
alias sudp='sudo'
