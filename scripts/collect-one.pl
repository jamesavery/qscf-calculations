#!/usr/bin/perl
use File::Basename;
use Cwd 'abs_path';

$root   = $ENV{'OPV'};
my $exp2 = $ARGV[0];
my $path = abs_path($ARGV[1]);

if($path =~ /([^\/]+)\/([^\/]+)-([0-9\.]+)\/([^\/]+)$/){
    ($m,$exp1,$dE,$jobid) = ($1,$2,$3);
} else {
   print "Source dir $path doesn't match correct pattern.\n";
   exit -1;
}


$outdir ="${root}/results/$m/$dE";
$outfile="${outdir}/${exp1}-${exp2}.m";

`mkdir -p ${outdir}`;
print "Generating ${outfile} from $m/${exp1}-$dE/${exp2}.*.out\n";

`energies-math.py ${exp2}.*.out > ${outfile}`;

