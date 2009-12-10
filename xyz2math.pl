#!/usr/bin/perl

my ($toformat) = @ARGV;

my @lines = <STDIN>;

do "elements.pm";

if(!($toformat cmp "gamess")){ # No preamble
} elsif (!($toformat cmp "gaussian")){ # Don't know how to do preamble automatically
} elsif (!($toformat cmp "mathematica")){
    $result .= "molecule = {\n";
} elsif (!($toformat cmp "qscf")){
    $result .= "  { atom_labels atoms geometry } = {\n";
}
my $i=0;
foreach $l (@lines){
    if($l =~ /(\w+)\s+([\-\+e\d.]+)\s+([\-\+e\d.]+)\s+([\-\+e\d.]+)/){
	$i++;
	my ($atom,$x,$y,$z) = ($1,eval($2),eval($3),eval($4));

	if(!($toformat cmp "gamess")){
	    $result .= "$atom$i      ".($elements{$atom})."\t$x $y $z\n";
	} elsif (!($toformat cmp "gaussian")){
	    
	} elsif (!($toformat cmp "mathematica")){ # must remove final ','
	    $x =~ s/e/\*\^/g;
	    $y =~ s/e/\*\^/g;
	    $z =~ s/e/\*\^/g;
	    $result .= "\t{\"$atom\",".$elements{$atom}.",{$x,$y,$z}},\n";
	} elsif (!($toformat cmp "qscf")){
	    $result .= "\t$atom $atom [$x $y $z]\n";
	}
    }
}
if(!($toformat cmp "gamess")){ # No postscript
} elsif (!($toformat cmp "gaussian")){ 
    $result .= "\n\n";
} elsif (!($toformat cmp "mathematica")){
    $result .= "};\n";
    $result =~ s/,\n\}/\n\}/isg;
} elsif (!($toformat cmp "qscf")){
    $result .= "}\n";
}

print $result;
