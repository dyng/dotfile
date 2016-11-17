#!/bin/bash

path=$HOME/Dropbox/todo
cd $path

case $1 in
    undone)
        grep -Pv -e "done$|^\s*$" *
        ;;
    *)
        string=${1-now}
        date=`date -d $string +%Y-%m-%d`
        if [[ -e $date ]]; then
            vim $date 
        else
            vim $date 
        fi
        ;;
esac
