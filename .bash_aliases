# Application overrides
alias top='htop'
alias ll='ls -lh'
alias rm='rm -f'

# Docker
alias docker='sudo docker'
alias dk='sudo docker'
alias dkc='sudo docker container'
alias dkcls='sudo docker container list --all'
alias dki='sudo docker image'
alias dkils='sudo docker image list'

# Files & filesystem
alias lg='ls -lah | grep'
alias rcgrep='grep -rnw ./ -e '
alias repos='grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/*'

# init
alias init='sudo init'

# Network
alias pg='ping google.com'
alias pgd='ping 8.8.8.8'
alias xip='curl icanhazip.com'

alias flushdns='sudo systemd-resolve --flush-caches'

# Python
alias py='python3'
alias pip='pip3'

# sudo [command]
alias arp-scan='sudo arp-scan'
alias powershell='sudo powershell'

# Terraform
alias tf='terraform'

# Typo Correction
alias ipconfig='ifconfig'
alias sudo="sudo "
alias sudp='sudo'

# Vagrant
alias vg='vagrant'

# Volume
alias vol='pactl set-sink-volume 0'

# sshrc
# Source .vimrc for sshrc script to ssh connections
# export VIMINIT="let \$MYVIMRC='$SSHHOME/.sshrc.d/.vimrc' | source \$MYVIMRC"

# Remove aliases for specific programs like cat/bat that are not installed on remote hosts
# if [ "$HOSTNAME" != "steve-laptop" ]; then
#     alias cat='cat'
# fi
