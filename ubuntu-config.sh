#!/bin/bash

USER=$(whoami)
CODENAME=$(lsb_release -sc)
INPUTRC=/home/$USER/.inputrc
INPUTRC_COMMANDS=('"\e[A": history-search-backward' '"\e[B": history-search-forward' 'set show-all-if-ambiguous on' 'set completion-ignore-case on' '"\e[1;5C": end-of-line' '"\e[1;5D": beginning-of-line' '"\e[1;3C": forward-word' '"\e[1;3D": backward-word')
VIMRC=/home/$USER/.vimrc
VIMRC_COMMANDS=('syntax enable' 'set encoding=utf-8' 'set tabstop=4' 'set softtabstop=4' 'set shiftwidth=4' 'set autoindent' 'set smartindent' 'set smarttab' 'set noexpandtab')
VIRTUALBOX_DEB="deb http://download.virtualbox.org/virtualbox/debian $CODENAME contrib"
VIRTUALBOX_EXTPACK="http://download.virtualbox.org/virtualbox/{version}/Oracle_VM_VirtualBox_Extension_Pack-{version}-{release}.vbox-extpack"

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

if ! grep -Fxq "$VIRTUALBOX_DEB" /etc/apt/sources.list; then
	sudo add-apt-repository "$VIRTUALBOX_DEB"
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
fi

sudo apt-get update -y
sudo apt-get install vim git virtualbox-5.0 dkms vagrant -y

VIRTUALBOX_EXTPACK=${VIRTUALBOX_EXTPACK//\{version\}/$(VBoxManage -v | cut -dr -f 1)}
VIRTUALBOX_EXTPACK=${VIRTUALBOX_EXTPACK//\{release\}/$(VBoxManage -v | cut -dr -f 2)}

wget $VIRTUALBOX_EXTPACK 
sudo VBoxManage extpack install --replace ${VIRTUALBOX_EXTPACK##*/} && rm ${VIRTUALBOX_EXTPACK##*/}

if [ ! -f "$VIMRC" ]; then
	touch "$VIMRC"
fi

for cmd in "${VIMRC_COMMANDS[@]}"; do 
	if ! grep -Fxq "$cmd" "$VIMRC"; then
		echo "$cmd" >> "$VIMRC"
	fi
done

exit 0
