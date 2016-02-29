package Aux::Sh;

use strict;
use warnings;
no warnings 'once';
use Data::Dumper;
use Aux::Utils;

=head1 NAME

Aux::Sh - shell utils for Aux 


=cut

my %Dispatch = ( 
    cat => \&cat,
    ls => \&ls,
    echo => \&echo,
    show => \&show,
    fun => \&fun,
    xargs => \&xargs,
    dump => \&dump,
    grepp => \&grepp,
);

sub grepp {
    my $pat = shift;
    if (wantarray) {
        return bless sub {
            my $o = shift;
            $o = '' unless $o;

            ($o =~ $pat)
                ?  $o 
                : undef;
        }, 'Aux.Sh.grepFUN';
    }elsif (defined wantarray) {
        die 'todo';
    }else{
        print Dumper @_;
    }
}

sub dump {
    if (wantarray) {
        return bless sub {
            print Dumper @_;
        }, 'Aux.Sh.FUN';
    }elsif (defined wantarray) {
        die 'todo';
    }else{
        print Dumper @_;
    }
}

sub xargs {
    my $res; 
    my $gen = shift;

    $gen->(GEN => @_);
}
sub show {
    my $o = shift;
    if ( wantarray) {
        return bless 
            sub { 
                if ( defined $_[0] ){
                    print @_ ;
                    print "\n";
                }
                }, 'Aux.Sh.xIT' ;
    }
}
sub fun (&) {
    my $fun = shift;
    if (defined wantarray) {
            return bless sub {
                $fun->(@_)
            
            }, 'Aux.Sh.IT';
    }else{
        die 'todo'
    }
}
sub ls {
        my $dirname = shift;
    if (wantarray){
        opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";
        map { $_ } readdir $dh ;
    }elsif (defined wantarray) {
        opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";

        return bless sub {
            my ($kind, @iters) = @_;
            my $i;
            if($kind eq 'GEN'){
                my $res;
                my @acc;
                
                foreach (readdir $dh){ 

                    $res = $_;
                    foreach my $fun (@iters){
                        $res = $fun->($res);
                    }
                    push @acc, $res
                }
                $iters[0]->();
                closedir $dh;
                return [ grep { $_ if (defined $_) } @acc ] ; 
            }else{
            }
        }, 'Aux.Sh.fun';

   } else {
        my $dirname = shift;
        opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";

        foreach (readdir $dh){ 
           print $_;
           print "\n";
        }
        closedir $dh;
    }
}

sub frame {
}
sub cat {
   if (wantarray) {
       print 'LIST';
   } elsif (defined wantarray) {
       my $fpath = Aux::Utils::path shift;
        open (my $fh, '<', $fpath) || die "Err: couldn't read '$fpath': $!";
        return $fh;
   } else {
        my $filename = shift;
        open(my $fh, '<', $filename)
            or die "Could not open file '$filename' $!";
        while ( <$fh>) {
            chomp $_;
            print "$_\n";
        }
        close $fh;
   }
}



sub echo {
    return unless @_;

    if(@_ == 1){
        print @_;
        print "\n";
    }else{
        if(@_ == 3){
            my ($string, $redir, $fname) = @_;
            my $filepath = Aux::Utils::path $fname;
            if (($redir eq '>') or ($redir eq '>>')){
                open (my $fh, $redir, $filepath) || die "Err: couldn't write to '$filepath': $!";
            }
        }
    }
}

sub import {
    shift;


    if(@_){
        no strict 'refs';
        my @funs = ($_[0] eq 'all')
            ? keys %Dispatch
            : @_;
        map {
            my $fun = (exists $Dispatch{$_}) 
                ? $Dispatch{$_} 
                : die "Err: function $_ not exists ";
            *{"main::$_"} = $fun;
        } @funs 


    }else{ # import all
        die "todo";
    }
}


=head1 SYNOPSIS
=cut

1;
