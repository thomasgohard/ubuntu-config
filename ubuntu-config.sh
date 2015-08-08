#!/bin/bash

USER=$(whoami)
INPUTRC=/home/$USER/.inputrc
INPUTRC_COMMANDS=('"\e[A": history-search-backward' '"\e[B": history-search-forward' 'set show-all-if-ambiguous on' 'set completion-ignore-case on' '"\e[1;5C": end-of-line' '"\e[1;5D": beginning-of-line' '"\e[1;3C": forward-word' '"\e[1;3D": backward-word')

if [ ! -f "$INPUTRC" ]; then
	touch "$INPUTRC"
fi

for cmd in "${INPUTRC_COMMANDS[@]}"; do
	if ! grep -Fxq "$cmd" "$INPUTRC"; then
		echo "$cmd" >> "$INPUTRC"
	fi
done

exit 0
