#!/bin/sh


rm -rf modulinos
mkdir modulinos
cd modulinos

for f in ../bin/* ; do
    [ -f $f ] || continue
    name="$(basename $f | sed 's/.*/\u&/')"
    #bf=$(basename $f | tr '[:loZZ:]' '[:lower:]')

    #bff=${bf%.*}

    ln -s $f ${name}.pm

done

ln -s ../Aux .

cd ..
    #{ 
    #    echo '#!/bin/sh'
    #    echo 'perl $(dirname $0)/'$f
    #} > $bff

    #chmod 0755 $bff
