extract () {
    for archive in $*
    do
        if [ -f $archive ] ; then
            case $archive in
                *.tar.bz2)   tar xjf $archive     ;;
                *.tar.gz)    tar xzf $archive     ;;
                *.bz2)       bunzip2 $archive     ;;
                *.rar)       unrar e $archive     ;;
                *.gz)        gunzip $archive      ;;
                *.tar)       tar xf $archive      ;;
                *.tbz2)      tar xjf $archive     ;;
                *.tgz)       tar xzf $archive     ;;
                *.zip)       unzip $archive       ;;
                *.Z)         uncompress $archive  ;;
                *.7z)        7z x $archive        ;;
                *)     echo "'$archive' cannot be extracted via extract()" ;;
            esac
        else
            echo "'$archive' is not a valid file"
        fi
    done
}
