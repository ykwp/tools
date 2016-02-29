#!/usr/bin/perl 


use strict;
use warnings;


use Aux::Sh 'all';

sub run {

    my $res = xargs(
        ls('/usr/local/bin/'),
        show()
#        grepp(qr/oo/),
    );
    exit;
    foreach my $i (ls('/usr/local/bin')){
        print $i
    }

    #dump $res;


    #echo "ka", '>',  'test.txt';

    my $f = cat( "test.txt");
    cat "test.txt" ;
    ls ('/usr/local/bin');
    echo( ls( '/usr/local/bin' ));
    echo  ref $f ;
}

sub foo {
    print "jsdffoo"
}
__PACKAGE__->run unless caller;
1;
