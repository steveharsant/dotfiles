# Application overrides
alias top='htop'
alias ll='ls -lh'
alias rm='rm -f'
alias ssh='sshrc'

# Docker
alias dk='sudo docker'
alias dkc='sudo docker container'
alias dkcls='sudo docker ps --format "Name:         {{.Names}}\n└─Status:       {{.Status}}\n└─Container ID: {{.ID}}\n└─Image:        {{.Image}}\n└─Ports:        {{.Ports}}\n"'
alias dkcll='sudo docker ps --format="Name:         {{.Names}}\n└─Status:       {{.Status}}\n└─Container ID: {{.ID}}\n└─Image:        {{.Image}}\n└─Command:      {{.Command}}\n└─Ports:        {{.Ports}}\n└─Mounts:       {{.Mounts}}\n└─Networks:     {{.Networks}}\n└─Created:      {{.RunningFor}}\n"'
alias dkexec='sudo docker exec -it'
alias dki='sudo docker image'
alias dkils='sudo docker image list'
alias dkps='sudo docker container list'
alias docker='sudo docker'

# Files & filesystem
alias lg='ls -lah | grep'
alias rcgrep='grep -rnw ./ -e '
alias repos='grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/*'

# init
alias init='sudo init'

# Network
alias pg='ping google.com'
alias pgd='ping 8.8.8.8'
alias xip='curl https://api.ipify.org && echo '

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
alias instsall='install'
alias ipconfig='ifconfig'
alias sudo="sudo "
alias sudp='sudo'

# Vagrant
alias vg='vagrant'

# Volume
alias vol='pactl set-sink-volume 0'

# Remove aliases for specific programs like sshrc that are not installed on remote hosts
if [[ -n $SSH_CONNECTION ]]; then
    unalias ssh
fi
