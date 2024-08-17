[[  -f ~/.Xresources  ]] && xrdb -merge -I$HOME ~/.Xresources
exec i3
xset r rate 190 25
