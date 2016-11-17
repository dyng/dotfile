#!/bin/bash

# Show the color setting for ls
# Source: http://stackoverflow.com/questions/598107/how-do-you-determine-what-bash-ls-colours-mean

eval $(echo "no:global default;fi:normal file;di:directory;ln:symbolic link;pi:named pipe;so:socket;do:door;bd:block device;cd:character device;or:orphan symlink;mi:missing file;su:set uid;sg:set gid;tw:sticky other writable;ow:other writable;st:sticky;ex:executable;"|sed -e 's/:/="/g; s/\;/"\n/g')

{
    IFS=:
    for i in $LS_COLORS
    do
        echo -e "\e[${i#*=}m$( x=${i%=*}; [ "${!x}" ] && echo "${!x}" || echo "$x" )\e[m"
    done
}

