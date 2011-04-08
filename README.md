Laptop Configuration Files
==========================

dzen
----
pixmaps

Contains all the icons used by dzen.

emacs
-----

| Source | Destination |
|:-------|:------------|
| .      | ~/.emacs.d  |

git
---
config
------
Symlink `~/.gitconfig` to this file.

linux
-----
VERSION.config
--------------
Symlink `/usr/src/linux-VERSION/.config` to these files.

mpd
---
config
------
Symlink `~/.mpdconf` to this file.

portage
-------
env
---
Symlink `etc/portage/env` to this directory.

layman/make.conf
----------------
Symlink `/var/lib/layman/make.conf` to this file.

make.conf
---------
Symlink `/etc/make.conf` to this file.

portage/package.keywords
------------------------
Symlink `/etc/portage/package.keywords` to this file.

portage/package.license
-----------------------
Symlink `/etc/portage/package.license` to this file.

portage/package.mask
--------------------
Symlink `/etc/portage/package.mask` to this file.

portage/package.unmask
----------------------
Symlink `/etc/portage/package.unmask` to this file.

portage/package.use
-------------------
Symlink `/etc/portage/package.use` to this file.

portage/world
-------------
Symlink `/var/lib/portage/world` to this file.

xmonad
------
xmonad.hs
---------
Symlink `~/.xmonad/xmonad.hs` to this file.

xorg
----
fontlist-fix
------------
Python script that finds all installed fonts and runs mkfontdir on those that
have not been indexed yet, then generates output to be pasted into
`/etc/X11/xorg.conf`. Original source
[here](http://en.gentoo-wiki.com/wiki/X.Org/Fonts).

init
----
Symlink `~/.xinitrc` and `~/.xsession` to this file.

resources
---------
Symlink `~/.Xresources` to this file.

zsh
---
functions
---------
Contains my custom functions.

rc
--
Symlink `~/.zshrc` to this file.
