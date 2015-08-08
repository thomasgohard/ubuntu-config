#!/bin/bash

USER=$(whoami)
INPUTRC=/home/$USER/.inputrc
INPUTRC_COMMANDS=('"\e[A": history-search-backward' '"\e[B": history-search-forward' 'set show-all-if-ambiguous on' 'set completion-ignore-case on' '"\e[1;5C": end-of-line' '"\e[1;5D": beginning-of-line' '"\e[1;3C": forward-word' '"\e[1;3D": backward-word')
VIMRC=/home/$USER/.vimrc
VIMRC_COMMANDS=('syntax enable' 'set encoding=utf-8' 'set softtabstop=4' 'set shiftwidth=4' 'set autoindent' 'set smartindent' 'set smarttab')

if [ ! -f "$INPUTRC" ]; then
    touch "$INPUTRC"
fi

for cmd in "${INPUTRC_COMMANDS[@]}"; do
    if ! grep -Fxq "$cmd" "$INPUTRC"; then
    	echo "$cmd" >> "$INPUTRC"
    fi
done

gsettings set org.gnome.settings-daemon.peripherals.touchpad natural-scroll true
gsettings set com.canonical.Unity.Lenses remote-content-search none

sudo apt-get update -y
sudo apt-get install vim -y

if [ ! -f "$VIMRC" ]; then
    touch "$VIMRC"
fi

for cmd in "${VIMRC_COMMANDS[@]}"; do 
    if ! grep -Fxq "$cmd" "$VIMRC"; then
    	echo "$cmd" >> "$VIMRC"
    fi
done

exit 0
