copy() {
    if [[ `uname` = 'Darwin' ]]; then
        if `which reattach-to-user-namespace &>/dev/null`; then
            cat $1 |reattach-to-user-namespace pbcopy
        else
            echo "reattach-to-user-namespace is required while copy under tmux environment!"
        fi
    else
        echo 'Linux support need to be implemented.'
    fi
}
