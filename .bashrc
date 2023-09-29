alias config='/usr/bin/git --git-dir=/home/fkheinstein/dotfiles/ --work-tree=/home/fkheinstein'


##
## Slightly nicer .bashrc
## Makes pretty colors and stuff
##

## Set $PATH, which tells the computer where to search for commands
export PATH="$PATH:/usr/sbin:/sbin:/bin:/usr/bin:/etc:/usr/ucb:/usr/local/bin:/usr/local/local_dfs/bin:/usr/bin/X11:/usr/local/sas"

## Where to search for manual pages
export MANPATH="/usr/share/man:/usr/local/man:/usr/local/local_dfs/man"

## Which pager to use.
export PAGER=less

## Choose your weapon
EDITOR=/usr/bin/vim
#EDITOR=/usr/bin/emacs
#EDITOR=/usr/bin/nano
export EDITOR

## The maximum number of lines in your history file
export HISTFILESIZE=50

## UVM!
export ORGANIZATION="University of Vermont"

## Enables displaying colors in the terminal
export TERM=xterm-color

# Uncomment the following lines if you are an ARC/INFO user
#alias arc=/usr/local/bin/arc
#alias arcdoc=/usr/local/bin/arcdoc
#alias info=/usr/local/bin/arcinfo

## Disable automatic mail checking
unset MAILCHECK 

## If this is an interactive console, disable messaging
#tty -s && mesg n

## Aliases from 'ol EMBA tcsh
#alias bye=logout
#alias h=history
#alias jobs='jobs -l'
#alias lf='ls -algF'
#alias log=logout
#alias cls=clear
#alias edit=$EDITOR
#alias restore=/usr/local/local_dfs/bin/restore

## Automatically correct mistyped 'cd' directories
#shopt -s cdspell

## Append to history file; do not overwrite
shopt -s histappend

## Prevent accidental overwrites when using IO redirection
set -o noclobber

## Set the prompt to display the current git branch
## and use pretty colors
export PS1='$(git branch &>/dev/null; if [ $? -eq 0 ]; then \
echo "\[\e[1m\]\u@\h\[\e[0m\]: \w [\[\e[34m\]$(git branch | grep ^* | sed s/\*\ //)\[\e[0m\]\
$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; if [ "$?" -ne "0" ]; then \
echo "\[\e[1;31m\]*\[\e[0m\]"; fi)] \$ "; else \
echo "\[\e[1m\]\u@\h\[\e[0m\]: \w \$ "; fi )'




if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi


# Swap Ctrl_L and CapsLock
if [[ -n $DISPLAY ]]; then
	setxkbmap de
	setxkbmap -option ctrl:nocaps       # Make Caps Lock a Control key
fi




export EDITOR=vim
export VISUAL=vim
export SUDO_EDITOR=vim


# Set ZSH config root to home (which is the default)

# XDG Base Directory specification
# https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_RUNTIME_DIR="${HOME}/.run"
[[ "${UID}" -ge 500 && -n "${XDG_CONFIG_HOME}" && ! -d "${XDG_CONFIG_HOME}" ]] && mkdir -p "${XDG_CONFIG_HOME}"
[[ "${UID}" -ge 500 && -n "${XDG_CACHE_HOME}" && ! -d "${XDG_CACHE_HOME}" ]] && mkdir -p "${XDG_CACHE_HOME}"
[[ "${UID}" -ge 500 && -n "${XDG_DATA_HOME}" && ! -d "${XDG_DATA_HOME}" ]] && mkdir -p "${XDG_DATA_HOME}"
[[ "${UID}" -ge 500 && -n "${XDG_RUNTIME_DIR}" && ! -d "${XDG_RUNTIME_DIR}" ]] && mkdir -p "${XDG_RUNTIME_DIR}"


# FZF configuration
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Less doesn't do anything if there's less than one page.
export LESS="-FRX $LESS"


# Language
# export LANGUAGE=C.UTF-8
export LANGUAGE=en_US.UTF-8
# export LANG=C.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
# export LC_ALL=C
# export LC_ALL=C.UTF-8
export LC_ALL=en_US.UTF-8
# export TERM=xterm-256color

export LANG=en_US.UTF-8
export TERM=xterm-256color
export COLORTERM=truecolor
#export FZF_BASE=/usr/local/bin/fzf
export BAT_STYLE=changes,numbers




source $HOME/.alias
