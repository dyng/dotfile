### oh-my-zsh {{{

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="muse"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(gitfast git-extras vagrant brew ruby z)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# }}}

### Global {{{

# Set locale in case
if [[ -z $LANG ]]; then
    echo "Warning: \$LANG is not set in profile."
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
fi

# }}}

### History {{{

HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=20000
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt share_history

# }}}

### PATH {{{

# add script dir
export PATH="$PATH:$HOME/script"

# Homebrew
if which brew 2>&1 1>/dev/null; then
    export PATH="/usr/local/bin:$PATH"
fi

# Perlbrew
if [[ -s "$HOME/perl5/perlbrew/etc/bashrc" ]]; then
    source "$HOME/perl5/perlbrew/etc/bashrc"
    export PATH="$HOME/perl5/perlbrew/bin:$PATH"
fi

# RVM
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
    export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
fi

# }}}

### Alias {{{

# Regular Alias
alias -r ll="ls -lAh"
alias -r la="ls -aTlFh"
alias -r lr="ls -Rlh"
alias -r lR="ls -RAlh"
alias -r tia="tig --all"
alias -r diff="diff -u"

# Global Alias
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'

# }}}

### Key binding {{{

# use pattern in history search
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

#}}}

### Utils {{{

# Json Parser
alias -r pjson="python -mjson.tool"

# Insert Unicode Character
autoload insert-unicode-char
zle -N insert-unicode-char
bindkey '^Xi' insert-unicode-char

# }}}

# vim: set foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
