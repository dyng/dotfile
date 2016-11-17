function svn-addall()
alias 'svn-addall'=svn st | awk '/\?/ {print $2}' | xargs svn add
