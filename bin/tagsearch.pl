#!/usr/bin/perl
#
#
use File::Find;

($Dir) = shift @ARGV;
($maintag) =  $ARGV[0];

die "Err: dir $Dir is no valid dirctory" unless (-d $Dir );

die "usage: search.pl <dir> <maintag> tags" unless $maintag;


$tags = join '|', @ARGV;

%dict;
 sub wanted {
    if((-f $_) or (-l $_)){
       if($File::Find::name =~ /$maintag/){
          open $fh, '<', $_;
          $fln = <$fh>;
          close $fh;
          $fln =~ s/^\s*\-\s*tags\:\s//g;
          @linetags = split ' ', $fln;
          @res = grep { $_ =~ /$tags/ } ( @linetags);
          $dict{$File::Find::name} = scalar @res;

       }
       
    }

 }

find({ 
       wanted =>\&wanted,
       follow => 1,
   },
       $Dir);

#    use Data::Dumper Dumper;
#    print Dumper %dict;
#
my @keys =  reverse sort { $h{$a} <=> $h{$b} } keys(%dict);
my @vals = @h{@keys};
print join "\n", @keys;
