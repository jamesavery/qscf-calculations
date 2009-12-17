#!/usr/bin/perl

my ($infile) = @ARGV;

do "elements.pm";


sub trim {
    my $s = $_[0];
    $s =~ s/^\s*(.*?)\s*$/$1/;
    return $s;
}


open(INFILE,"< ${infile}.out") or die "Can't open ${infile}.out for reading";
my @lines = <INFILE>;
close INFILE;

my $j = 0;
for($i=0;$i<@lines;$i++){
    if($lines[$i] =~ /RUN\ TITLE/){
	$i+=2;
	$title = &trim($lines[$i]);
	print STDERR "Job: $title\n";
    }
    if($lines[$i] =~ /COORDINATES\ OF\ ALL\ ATOMS\ ARE\ \((.*?)\)/){
	$j++;
	my $unit = $1;
	$i = $i+3;
	my (@charges,@xs,@ys,@zs) = ();
	print STDERR "Found coordinates for step $j\n";

	while(($lines[$i] cmp "\n") && ($lines[$i] cmp "\r\n")){
	    my ($dummy,$label,$charge,$x,$y,$z) = split(/\s+/,$lines[$i]);
	    $charge = int($charge);
	    push @charges, $charge;
	    push @xs,$x;
	    push @ys,$y;
	    push @zs,$z;
	    $i++;
	}
	my $number_of_atoms = @xs;
	print STDERR "Number of atoms: $number_of_atoms\n";

	open(OUTFILE,"> ${infile}.${j}.xyz") or die "Can't open ${infile}.${j}.xyz for writing.";
	print OUTFILE "$number_of_atoms\n$title\n";
	for($k=0;$k<$number_of_atoms;$k++){
	    print OUTFILE "$elementnames{$charges[$k]}\t$xs[$k]\t$ys[$k]\t$zs[$k]\n";
	}
	close OUTFILE;
    }
}
