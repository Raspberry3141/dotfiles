#
# ~/.bashrc
#
function cl() {
	cd "$@" && ls;
}
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='\[\033[0;36m\]\u@\h\[\033[0m\]:\[\033[0;36m\]\w\[\033[0m\]\$ '

