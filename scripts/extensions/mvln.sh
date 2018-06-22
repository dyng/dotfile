mvln () {
    while [[ $# > 1 ]]; do
        src=$1
        dest=${@:$#}
        if [[ -e $dest && -d $dest ]]; then
            dest=$dest/$(basename $1)
        fi

        if [[ "${dest:0:1}" = "/" ]]; then
            abs_dest=$dest
        else
            abs_dest=$PWD/$dest
        fi

        echo "moving $src to $dest"
        mv $src $dest
        echo "linking $dest to $src"
        ln -s $abs_dest $src

        shift
    done
}
