sub iter (&$) {
    my ($fun, $l ) = @_;


    foreach (@$l){
        $fun->($_);
    }
}

my $ref = [ 33, 99 ] ;

sub lister {
    if(wantarray){
        print 'ww' ;
        [];
    }elsif(defined wantarray ){
        print 'dw' ;
        [];
    }else{
        print 'ee' ;
        [];
    }
}

iter {
    print "jsdf"
} lister();

cat ( 'test.txt' => sub {
        print $_
})

    
