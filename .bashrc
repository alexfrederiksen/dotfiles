#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load active directory
if [[ -f /tmp/active-dir ]]; then
    cd $(cat /tmp/active-dir)
fi

export HISTSIZE=1

export EDITOR=nvim
export CHICKEN_DOC_REPOSITORY=/home/ajay/.chicken/chicken-doc
export CHICKEN_INSTALL_REPOSITORY=/home/ajay/.chicken/11
export CHICKEN_REPOSITORY_PATH=/home/ajay/.chicken/11
export PATH="$PATH:/home/ajay/.local/bin"

cd-active () {
    cd -P "$@"
    echo $(pwd) > /tmp/active-dir
}

bat () {
    cat /sys/class/power_supply/BAT0/capacity
}

encrypt () {
    gpg -c --no-symkey-cache "$@"
}

decrypt () {
    gpg --no-symkey-cache "$@"
}

repl () {
    if [[ ! -e /tmp/.repl ]]; then
        mkfifo /tmp/.repl
    fi

    chicken-csi -:c < /tmp/.repl & 
    cat > /tmp/.repl
}

z () {
    zathura $@ &
    disown
}

alias cd='cd-active'
alias vim='nvim'
alias rm='rm -i'

eval "$(dircolors ~/.dircolors)"

alias ls='ls --color=always'
alias less='less -r'
# PS1='[\u@\h \W]\$ '
# PS1="\u@\h \W\$ "
PS1='\[\033[01;04;33m\]\u@\h\[\033[00m\] \[\033[01;04;35m\]\W\[\033[00m\]\$ '


set -o vi

alias reboot='systemctl reboot'
alias poweroff='systemctl poweroff'
alias suspend='systemctl suspend'
alias emacs='spawn emacs'
