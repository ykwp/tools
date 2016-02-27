#!/bin/sh

cwd=$(pwd)
dev=$HOME/dev
aux=$HOME/aux

[ -d "$aux" ] || mkdir -p $aux
[ -d "$aux" ] || mkdir -p $aux
[ -e "$dev/aux" ] || ln -s $aux $dev/aux

# Links to 
## ~/aux/tools (script access), 
## ~/dev/tools (dev environment) 

for item in $dev $aux ; do
   rm -f $item/tools
   ln -s $(pwd) $item/tools
done


