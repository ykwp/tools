package Aux::Utils;

use strict;
use warnings;
use File::Spec;

=head1 NAME

Aux::Utils - base utils for Aux 

=head1 VERSION
Version  0.00_01
=cut

our $VERSION = '0.01';
our $COPYRIGHT;
BEGIN {
        $VERSION = '0.00_01';
            $COPYRIGHT = 'Copyright 2005-2015 Ben auxsend.';
        }




sub path {

    my @elms = split '/', shift;
    File::Spec->catfile(@elms);
}

=head1 SYNOPSIS
=cut

=head1 COPYRIGHT & LICENSE
Copyright 2005-2015 Ben auxsend.
This program is free software; you can redistribute it and/or modify
it under the terms of the Artistic License v2.0.
=cut
1;
