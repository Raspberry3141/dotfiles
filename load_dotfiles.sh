#!/usr/biin/bash

function load {
	#1. make the directory necessary
	#2. cp files to the location and rename
	echo $1;
	mkdir --parents "$1";
	cp "$2" "$1/$3";
}

load "/home/admin" "/home/admin/.dotfiles/.bash_profile" ".bash_profile"
load "/home/admin" "/home/admin/.dotfiles/.bashrc" ".bashrc"
load "/home/admin" "/home/admin/.dotfiles/.xinit" ".xinit"
load "/home/admin" "/home/admin/.dotfiles/.Xresources" ".Xresources"
load "/home/admin/.config/i3" "/home/admin/.dotfiles/i3" "config"
load "/home/admin/.config/i3status" "/home/admin/.dotfiles/i3status" "config"
load "/home/admin/.config/nvim" "/home/admin/.dotfiles/init.lua" "init.lua"
load "/home/admin/.config/alacritty" "/home/admin/.dotfiles/alacritty" "alacritty.toml"
