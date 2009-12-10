#!/usr/bin/perl

my ($dir) = @ARGV;

opendir(FEM,"./$dir") or die;
@femouts = grep { /\.out/ } readdir FEM;
closedir(FEM);

foreach $file (@femouts){
    if($file =~ /(\w+)\.(-?\d+\.\d+)\.out/){
	my ($base,$theta) = ($1,$2);
	open(OUTFILE,"< ./$dir/$file");
	my @energy = grep { /^\-[0-9]/ } <OUTFILE>;
	print "$theta $energy[0]";
	close OUTFILE;
    }
}
