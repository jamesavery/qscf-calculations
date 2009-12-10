#!/usr/bin/perl

my ($dir) = @ARGV;

open(FOO,"./collate.pl $dir | sort -n |") or die;
my @points = <FOO>;
close FOO;

my $prefix = $dir; 

my $string = "${prefix}points = {";
foreach $p (@points){
    my ($x,$y) = split /\s+/, $p;
    $string .= "{$x,$y},";
}
$string =~ s/,$/\}\;\n/;

print $string;
