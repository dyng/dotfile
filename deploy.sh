deploy () {
    wd=$1
    # config files start with '_'
    file_list=$(find $1 -depth 1 -regex "$1/_.*")
    for file in $file_list; do
        target_file=$HOME/$(basename $file|sed -E 's/^_/./')
        if [[ -e $target_file ]]; then
            # if target exists and is symlink
            if [[ -h $target_file ]]; then
                rm -f $target_file
            else
                echo "$target_file exists but is not a symlink! Ignore it."
                break
            fi
        fi
        ln -s $PWD/$file $target_file
    done
    echo "deploying $wd done."
}

paks=(git shell vim tmux vimperator ideavim)

for pak in ${paks[@]}; do
    deploy $pak
done
