#!/usr/biin/bash

# make sure to cd in the directory containing this file before running it
mkdir --parents "$HOME/.config/";
CONFIGLOC="$HOME/.config/"

function load {
	ln -s "$1" "$2";
}

load ".dotfiles/.bash_profile" "$HOME/.bash_profile"
load ".dotfiles/.bashrc" "$HOME/.bashrc"
load ".dotfiles/.xinit" "$HOME/.xinitrc"
load ".dotfiles/.Xresources" "$HOME/.Xresources"
load ".dotfiles/.Xmodmap" "$HOME/.Xmodmap"

load ".dotfiles/.i3" "$CONFIGLOC/i3/config"
load ".dotfiles/.i3status" "$CONFIGLOC/i3status/config"
load ".dotfiles/init.lua" "$CONFIGLOC/nvim/init.lua"
load ".dotfiles/alacritty" "$CONFIGLOC/alacritty/alacritty.toml"

