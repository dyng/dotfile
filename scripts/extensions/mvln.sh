mvln () {
    if [[ -e $2 ]]; then
        if [[ -d $2 ]]; then
            filename=$(basename $1)
            dest=$2/$filename
        else
            dest=$2
        fi
    else
        dest=$2
    fi
    src=$1

    if [[ "${dest:0:1}" = "/" ]]; then
        abs_dest=$dest
    else
        abs_dest=$PWD/$dest
    fi

    echo "moving $src to $dest"
    mv $src $dest
    echo "linking $dest to $src"
    ln -s $abs_dest $src
}
