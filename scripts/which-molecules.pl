#!/usr/bin/perl

require molecules;

my $host = `hostname -s`;
$host =~ s/[\n\r]//g;

my @molecules = ();

foreach $m (keys %molecule){
    if($molecule{$m}{"hosts"} =~ /^\Q$host/){
	push @molecules, $m;
    } 
}

print (join ' ',@molecules) . "\n";
