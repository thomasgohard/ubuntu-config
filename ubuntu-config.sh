#!/bin/bash

USER=$(whoami)
HOME=/home/$USER
CODENAME=$(lsb_release -sc)
DOTFILES_ROOT="https://raw.githubusercontent.com/thomasgohard/dotfiles/master/"
INPUTRC=.inputrc
VIMRC=.vimrc
VIRTUALBOX_DEB="deb http://download.virtualbox.org/virtualbox/debian $CODENAME contrib"
VIRTUALBOX_EXTPACK="http://download.virtualbox.org/virtualbox/{version}/Oracle_VM_VirtualBox_Extension_Pack-{version}-{release}.vbox-extpack"

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

if [ -f "$HOME/$INPUTRC" ]; then
	rm "$HOME/$INPUTRC"
fi
wget -O $HOME/$INPUTRC $DOTFILES_ROOT/$INPUTRC

if [ -f "$HOME/$VIMRC" ]; then
	rm "$HOME/$VIMRC"
fi
wget -O $HOME/$VIMRC $DOTFILES_ROOT/$VIMRC

exit 0
