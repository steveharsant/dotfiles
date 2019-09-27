# Application overrides
alias cat='bat'
alias top='htop'

# Files & filesystem
alias dfr='df -h | grep root'
alias lg='ls | grep'
alias rcgrep='grep -rnw ./ -e '
alias repos='grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/*'
alias topdir='echo Drive Space Usage && echo ================= && echo && sudo du -Sh --exclude=./proc --exclude=./run --exclude=./home/.ecryptfs | sort -rh | head -25'

# fzf
alias preview="fzf --preview 'bat --color \"always\" {}'"

# Network 
alias pg='ping google.com'
alias pgd='ping 8.8.8.8'
alias ldns='nmcli device show enp0s31f6 | grep IP4.DNS'
alias wdns='nmcli device show wlp4s0 | grep IP4.DNS'
alias xip='curl icanhazip.com'

# Python
alias py='python3'

# Spotify Media Controls & Extras
alias next='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next'
alias pause='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause'
alias play='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play'
alias pp='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause'
alias prev='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous'
alias sctrl='google-chrome --app="https://play.spotify.com" --hide-scrollbars  </dev/null &>/dev/null & '

# sudo [command]
alias arp-scan='sudo arp-scan'
alias powershell='sudo powershell'

# Typo Correction
alias ipconfig='ifconfig'
alias sudo="sudo "
alias sudp='sudo'

# Volume
alias vol='pactl set-sink-volume 0'

# Wine
alias winbox='wine /home/steve/applications/winbox.exe </dev/null &>/dev/null & '

#-----------------------#
# Special Configuration #
#-----------------------#

# Source .vimrc for sshrc script to ssh connections
export VIMINIT="let \$MYVIMRC='$SSHHOME/.sshrc.d/.vimrc' | source \$MYVIMRC"

# Remove aliases for specific programs like cat/bat that are not installed on remote hosts
if [ "$HOSTNAME" != "steve-laptop" ]; then
    alias cat='cat'
fi
