#!/bin/bash
# update_gfwlist.sh
# Author : VincentSit
# Copyright (c) http://xuexuefeng.com
#
# Example usage
#
# ./whatever-you-name-this.sh
#
# Task Scheduling (Optional)
#
#   crontab -e
#
# add:
# 30 9 * * * sh /path/whatever-you-name-this.sh
#
# Now it will update the PAC at 9:30 every day.
#
# Remember to chmod +x the script.


GFWLIST="https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt"
PROXY="127.0.0.1:1080"
USER_RULE_NAME="user-rule.txt"

check_module_installed()
{
    pip list | grep gfwlist2pac &> /dev/null

    if [ $? -eq 1 ]; then
        echo "Installing gfwlist2pac."

        pip install gfwlist2pac
    fi
}

update_gfwlist()
{
    echo "Downloading gfwlist."

    curl -s "$GFWLIST" --fail --socks5-hostname "$PROXY" --output /tmp/gfwlist.txt

    if [[ $? -ne 0 ]]; then
        echo "abort due to error occurred."
    exit 1
    fi

    cd ~/.ShadowsocksX || exit 1

    if [ -f "gfwlist.js" ]; then
        mv gfwlist.js ~/.Trash
    fi

    if [ ! -f $USER_RULE_NAME ]; then
        touch $USER_RULE_NAME
    fi

    /usr/local/bin/gfwlist2pac \
    --input /tmp/gfwlist.txt \
    --file gfwlist.js \
    --proxy "SOCKS5 $PROXY; SOCKS $PROXY; DIRECT" \
    --user-rule $USER_RULE_NAME \
    --precise

  rm -f /tmp/gfwlist.txt

  echo "Updated."
}

check_module_installed
update_gfwlist
