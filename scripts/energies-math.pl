#!/usr/bin/perl

my ($dir,$prefix) = @ARGV;

my @lines = `cd $dir && grep "Total potential energy" ${prefix}.*.out|sed -e "s/\:/\ /g"`;

print "propertylist = {";
for($i=0;$i<@lines;$i++){
    my $l = $lines[$i];
#    if($l =~ /([^\.]+)\.([\-\d\.\ ]+)\.out\ ([\-\d\.]+)/){
    if($l =~ /([^\.]+)\.([\-\d\.\ ]+)\.out\ Total\ potential\ energy\s*=\s*([\-\d\.]+)/){
	my ($job,$vals,$e) = ($1,$2,$3);
	my @vals = split /\s+/,$vals;
	if(1<@vals){
	    print "{".&liststring(@vals).",$e}".($i+1<@lines?",\n":"");
	} else {
	    print &liststring(@vals,$e).($i+1<@lines?",\n":"");;
	}
    }
}
print "};\n\n";



sub liststring {
    my @l = @_;
    my $i;
    my $s = "{";
    for($i=0;$i<@l;$i++){
	$s .= "$l[$i]".($i+1<@l?",":"");
    } 
    $s .= "}";

    return $s;
}



