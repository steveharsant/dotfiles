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
alias watch='watch ' # Allows for aliases to be passed to watch

# Docker
alias dk="docker"
alias dkc="docker container"
alias dkcip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dkcll="docker ps -a --format '{{.Names}} ({{.ID}})\n  State: {{.State}} ({{.Status}})\n  Image: {{.Image}}\n  Mounts: {{.Mounts}}\n  Ports: {{.Ports}}\n'"
alias dkcls="docker ps --format 'table {{.Names}}\t{{.State}}\t{{.Status}}\t{{.RunningFor}}'"
alias dkclss="docker ps --filter 'status=exited'  --format 'table {{.Names}}\t{{.State}}\t{{.Status}}\t{{.RunningFor}}'"
alias dkcx="docker exec -it"
alias dki="docker image"
alias dkils="docker image ls"
alias dkix="docker run -it"
function dkcl(){ : > "$(docker inspect --format='{{.LogPath}}' "$1")" ; }

# Files & filesystem
alias lg='ls -lah | grep'
alias rcgrep='grep -rnw ./ -e '
alias repos='grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/*'

# Network
alias flushdns='sudo systemd-resolve --flush-caches'
alias pg='ping google.com'
alias pgd='ping 8.8.8.8'
alias xip='curl https://api.ipify.org && echo '

# Shortened binaries
alias pip='pip3'
alias py='python3'
alias tf='terraform'
alias ts='tailscale'
alias vg='vagrant'

# sudo [command]
alias arp-scan='sudo arp-scan'
alias init='sudo init'
alias powershell='sudo powershell'

# Typo Correction
alias instsall='install'
alias ipconfig='ifconfig'
alias sudo='sudo '
alias sudp='sudo'
