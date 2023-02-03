export ZSH=$HOME/.zsh

## history ##
export HISTFILE=$ZSH/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTTIMEFORMAT="[%F %T] "

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS  # dont show duplicate commands
setopt INC_APPEND_HISTORY # add to history immediately
setopt EXTENDED_HISTORY   # add timestamp to to history

# PYENV configuration
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# replacing ls and tree
alias ls="exa -1a --icons --group-directories-first"
alias tree="exa -1a --icons -T --group-directories-first"

alias reload="exec $SHELL"

# preview a formatted json file in the terminal
peek_json () {
    jq -C '.' $1 | less -R
}

# pyenv virtual env stuff
eval "$(pyenv virtualenv-init -)"

# PATH
export PATH=$HOME/bin/:$PATH

# thef*ck - rerun a failed command with auto-corrections
# (handy for git push!)
eval $(thefuck --alias)
eval $(thefuck --alias yikes) # PG version 


# DOCKER
# get environment variable from inside a container
d_env () {
    docker exec $1 printenv $2
}
alias de="d_env"

# Enter into an interactive `bash` shell in the docker container
d_shell () {
    docker exec -it $1 /bin/bash
}

alias ds="d_shell"

## LUIGI
# get the mapped HOST_PORT from the container
d_luigi_port () {
    d_env $1 LUIGI_HOST_PORT
}

# runs the luigi module then opens the dashboard in firefox
d_luigi_run () {
    echo "$1  ::   running luigi --module $2 $3"

    echo "opening dashboard in firefox"
    open -a firefox -g "localhost:$(d_luigi_port $1)"

    # run luigi for the given module
    docker exec --env COLUMNS=${COLUMNS} $1 luigi --module $2 $3 --workers=8
}

## PYENV ALIASES

alias pea='pyenv activate' # Py.Env.Activate
alias pen='pyenv virtualenv' # Py.Env.New
alias ped='pyenv virtualenv-delete' # Py.Env.Delete


alias gs='git status'
alias s='gs'

alias ga='git add'
alias a='ga'

alias gc='git commit'
alias c='gc'

alias gb='git branch --remotes'
alias b='gb'

alias gl='git log --graph'
alias l='gl'

alias pull='git pull'
alias push='git push'
alias switch='git switch'

alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'

# coding bookmarks
export dir_repos="$HOME/repos"
alias repos="cd $dir_repos"

# open a repo folder
change_repo () {
    cd $dir_repos/$1
}

alias cr="change_repo"

# --- Auto Completion ---
#autoload -Uz compinit
#zstyle ':completion:*' menu select
# zmodload zsh/complist
#compinit
#_comp_options+=(globdots)

# use vim keys for tab complete menu
# bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'l' vi-forward-char
#bindkey -M menuselect 'j' vi-down-line-or-history
#bindkey -v '^?' backward-delete-char

# VI-Mode
bindkey -v
export KEYTIMEOUT=1

# plugins
# improved vi-mode
source $ZSH/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh


source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fpath=($ZSH/plugins/zsh-completions/src $fpath)

export ZSH_AUTOSUGGEST_STRATEGY=(completion history)
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
