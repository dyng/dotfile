cm() {
    local COMMAND=$(cat ~/.shortcuts|fzf)
    echo "$COMMAND"
    eval "$COMMAND"
}
