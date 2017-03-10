copy() {
    if [[ `uname` = 'Darwin' ]]; then
        if [[ ! -n $TMUX ]]; then
            if `which reattach-to-user-namespace &>/dev/null`; then
                cat $1 |reattach-to-user-namespace pbcopy
            else
                echo "reattach-to-user-namespace is required while copy under tmux environment!"
                echo "use homebrew to install: brew install reattach-to-user-namespace"
            fi
        else
            cat $1 |pbcopy
        fi
    else
        echo 'Linux support need to be implemented.'
    fi
}

copypath() {
    if [[ `uname` = 'Darwin' ]]; then
        if ! `which greadlink &>/dev/null`; then
            echo 'use homebrew to install: brew install coreutils'
        fi

        if [[ ! -n $TMUX ]]; then
            if `which reattach-to-user-namespace &>/dev/null`; then
                greadlink -f $1 |tr -d '\r\n' |reattach-to-user-namespace pbcopy
            else
                echo "reattach-to-user-namespace is required while copy under tmux environment!"
                echo "use homebrew to install: brew install reattach-to-user-namespace"
            fi
        else
            greadlink -f $1 |tr -d '\r\n' |pbcopy
        fi
    else
        echo 'Linux support need to be implemented.'
    fi
}
