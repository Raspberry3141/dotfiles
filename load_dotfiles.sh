#!/usr/biin/bash

mkdir --parents "$HOME";
function load {
	#1. make the directory necessary
	#2. cp files to the location and rename
	cp "$2" "$1/$3";
}

load "$HOME" "$HOME/.dotfiles/.bash_profile" ".bash_profile"
load "$HOME" "$HOME/.dotfiles/.bashrc" ".bashrc"
load "$HOME" "$HOME/.dotfiles/.xinit" ".xinit"
load "$HOME" "$HOME/.dotfiles/.Xresources" ".Xresources"
load "$HOME" "$HOME/.dotfiles/i3" "config"
load "$HOME" "$HOME/.dotfiles/i3status" "config"
load "$HOME" "$HOME/.dotfiles/init.lua" "init.lua"
load "$HOME" "$HOME/.dotfiles/alacritty" "alacritty.toml"
