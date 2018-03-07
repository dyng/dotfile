proxyit() {
    last=$(echo `history |tail -n2 |head -n1` | sed 's/[0-9]* //')
    eval "ALL_PROXY=socks5://127.0.0.1:1080 $last"
}
