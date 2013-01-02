#!/bin/bash

GIT_DIR="$(dirname $(readlink -f $0))"

create_symlink()
{
    local SOURCE="${GIT_DIR}/${1}"
    local TARGET="${HOME}/${2}"
    ln -sf $SOURCE $TARGET
}

# emacs
create_symlink "emacs" ".emacs.d"

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
