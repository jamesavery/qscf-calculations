#!/usr/bin/perl

my ($dir,$prefix) = @ARGV;

my @lines = `cd $dir && grep "Total potential energy" ${prefix}.*.out|sed -e "s/\:/\ /g"`;

foreach $l (@lines){
    if($l =~ /([^\.]+)\.([\-\d\.\ ]+)\.out\ Total\ potential\ energy\s*=\s*([\-\d\.]+)/){
	my ($job,$vals,$e) = ($1,$2,$3);
	print "$vals $e\n";
    }
}



