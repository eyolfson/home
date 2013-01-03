#!/bin/bash

GIT_DIR="$(dirname $(readlink -f $0))"

create_symlink()
{
    local SOURCE="${GIT_DIR}/${1}"
    local TARGET="${HOME}/${2}"
    echo -n "Creating symlink ${2}"
    if [ -e $TARGET ]
    then
        echo -e " \033[1;31mfail\033[0m"
    else
        ln -s $SOURCE $TARGET
        echo -e " \033[1;32mdone\033[0m"
    fi
}

# dzen
create_symlink "dzen/pixmaps" ".dzen/pixmaps"

# emacs
create_symlink "emacs/init.el" ".emacs.d/init.el"
create_symlink "emacs/site-lisp" ".emacs.d/site-lisp"
create_symlink "emacs/themes" ".emacs.d/themes"

# git
create_symlink "git/gitconfig" ".gitconfig"

# mpd
create_symlink "mpd/mpdconf" ".mpdconf"

# mplayer
create_symlink "mplayer/config" ".mplayer/config"

# xmonad
create_symlink "xmonad/xmonad.hs" ".xmonad/xmonad.hs"

# xorg
create_symlink "xorg/Xresources" ".Xresources"
create_symlink "xorg/xinitrc" ".xinitrc"

# zsh
create_symlink "zsh/oh-my-zsh" ".oh-my-zsh"
create_symlink "zsh/zshrc" ".zshrc"
