#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\[\033[0;36m\]\u@\h\[\033[0m\]:\[\033[0;36m\]\w\[\033[0m\]]\$ '

f() {
	OPENPATH=$(fzf | xargs -r)
    if [ -n "$OPENPATH" ]; then
        xdg-open "$OPENPATH"
        history -s "nvim $(pwd| xargs)/$OPENPATH"
    fi
}
fd() {
	GITPATH=$(find ~ -path "/home/admin/.local/share/nvim/lazy" -prune -o -type d -name .git -exec dirname {} \; | fzf)
	if [ -n "$GITPATH" ]; then
		cd "$GITPATH"
		nvim "$GITPATH"
		history -s "nvim ."
	fi
}

. "$HOME/.local/bin/env"
