# Set locale in case
if [[ -z $LANG ]]; then
    echo "Warning: \$LANG is not set in profile."
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
fi

# History
HISTSIZE=20000

# PATH
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
