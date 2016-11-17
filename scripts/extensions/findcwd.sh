findcwd () {
    find . -name "*$1*" | sed 's+^\./++'
}
