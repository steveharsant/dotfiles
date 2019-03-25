alias xip='curl icanhazip.com'
alias wdns='nmcli device show wlp4s0 | grep IP4.DNS'
alias ldns='nmcli device show enp0s31f6 | grep IP4.DNS'
alias topdir='echo Drive Space Usage && echo ================= && echo && sudo du -Sh --exclude=./proc --exclude=./run --exclude=./home/.ecryptfs | sort -rh | head -25'
alias repos='grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/*'
alias sudp='sudo'
alias sudo="sudo "
alias lg='ls | grep'
alias pg='ping google.com'
alias pgd='ping 8.8.8.8'
alias vpnu='nmcli c up'
alias vpnd='nmcli c down'
alias dfr='df -h | grep root'
alias top='htop'
alias vol='pactl set-sink-volume 0'
alias py='python3'
alias winbox='wine /home/steve/applications/winbox.exe </dev/null &>/dev/null & '
alias detatch='</dev/null &>/dev/null & '
alias op='ncb -o && passes '
alias gp='ncb -g && passes '
alias rcgrep='grep -rnw ./ -e '
alias cat='bat'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias arp-scan='sudo arp-scan'
alias powershell='sudo powershell'
alias ipconfig='ifconfig'

# Spotify Media Controls & Extras
alias sctrl='google-chrome --app="https://play.spotify.com" --hide-scrollbars  </dev/null &>/dev/null & '
alias play='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play'
alias pause='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause'
alias pp='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause'
alias prev='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous'
alias next='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next'

# Special command to source .vimrc for sshrc script to ssh connections
export VIMINIT="let \$MYVIMRC='$SSHHOME/.sshrc.d/.vimrc' | source \$MYVIMRC"
# $MYVIMRC='$SSHHOME/.sshrc.d/.vimrc'


# Removes aliases for specific programs like cat/bat that are not installed on remote hosts
if [ "$HOSTNAME" != "steve-laptop" ]; then
    alias cat='cat'
fi
