# Aliases
alias ta=_tmux_attach
alias ll='ls -lh'
alias lr='ls -thor'
alias ipy=ipython
alias py=python
alias pydoc='=python -m pydoc'
alias pylab='ipython --pylab'
alias clear-pycs='find ${PWD} -name "*.pyc" -delete'
alias g='git'
alias ga='git commit --amend'
alias es='exec $SHELL'
alias sqlite3='rlwrap =sqlite3'
alias k=kubectl
alias sourceenv="source ./venv/bin/activate"
alias vup="vim +PlugClean! +PlugUpgrade +PlugUpdate +UpdateRemotePlugins +qa"

# set up alias for opening today's note
alias today='note $(date +%Y-%m-%d)'
alias todo='note TODO'

if has_executable rg; then
    alias grep=rg
elif has_executable ag; then
    alias grep=ag
else
    alias grep='grep --color=auto'
fi

if has_executable task; then
    alias t=task
fi

if has_executable exa; then
    alias ls=exa
    alias thor="exa -snew -l"
else
    alias thor="ls -thor"
fi

if has_executable yay; then
    alias pacman=yay
fi

if has_executable bat; then
    alias cat=bat
    alias less=bat
    alias more=bat
fi
