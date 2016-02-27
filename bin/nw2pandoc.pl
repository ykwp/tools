#!/usr/bin/perl
#
use Text::Markdown 'markdown';



my $filename = $ARGV[0]; 
my $trace = $ARGV[1]; 

$style = do {
   local $/;
   <DATA>;
};


open(my $fh, '<', $filename)
  or die "Could not open file '$filename' $!";


$text = qq(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Content-Style-Type" content="text/css" />
  <meta name="generator" content="pandoc" />
  <style type="text/css">$style </style>);


@links =();
@lines=();
$title;
$level; # title level

$inpre;
while (<$fh>) {
   if(/^\<\<(.*)\>\>=\s*$/) {
      $inpre=1;
      push @links, $1;
      $hashtag = '#' x ($level + 1);
      push @lines, "$hashtag $1\n";
      #push @lines, "<a name=$1></a> \n";
      push @lines, "~~~~ {#$1 }\n";
      
   }elsif(/^\@\s*$/) {  
      undef $inpre;
      push @lines, '~~~~~~~' . "\n";
      push @lines, '<a href="#TOP">top</a>' . "\n";
   }elsif(/^\#\s*(.*)\s*$/) {  
      $title=$1;
      $level = split '#', $_;
   }elsif(/^\#\#*(.*)\s*$/) {  
      push @lines, "$_\n";
      push @links, "$1";
      $level = split '#', $_;
   } else { 
      if($inpre){
         push @lines, "$_";
      }else{
         push @lines, "$_";
      }
   } 
}



$text = $text .  "<title>$title</title>
</head>";
#<div id='TOC'>
$text = $text .  "$trace\n<h1 id='TOP'>$title</h1>
<body>
<ul>";



$text = $text . 
   join "\n", 
      map { "<li><a href='#$_'>$_</a></li>" } @links;

$text = $text .  "</ul><hr>\n";

$text = $text .  join "",  @lines;

$text = $text .  "\n";

$text = $text .  '</body></html>';


print $text;

__DATA__
pre, code 
    {
    background-color: #fdf7ee;
    /* BEGIN word wrap */
    /* Need all the following to word wrap instead of scroll box */
    /* This will override the overflow:auto if present */
    white-space: pre-wrap; /* css-3 */
    white-space: -moz-pre-wrap !important; /* Mozilla, since 1999 */
    white-space: -pre-wrap; /* Opera 4-6 */
    white-space: -o-pre-wrap; /* Opera 7 */
    word-wrap: break-word; /* Internet Explorer 5.5+ */
    /* END word wrap */
    }

pre /* Code blocks */
    {
    /* Distinguish pre blocks from other text by more than the font with a background tint. */
    padding: 0.5em; /* Since we have a background color */
    border-radius: 5px; /* Softens it */
    /* Give it a some definition */
    border: 1px solid #aaa;
    /* Set it off left and right, seems to look a bit nicer when we have a background */
    margin-left:  0.5em;
    margin-right: 0.5em;
    }
