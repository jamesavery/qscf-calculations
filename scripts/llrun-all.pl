#!/usr/bin/perl
use File::Basename;
use Cwd 'abs_path';

($jobid,@inputfiles) = @ARGV;

$root   = $ENV{'OPV'};
$srcdir = dirname(abs_path($inputfiles[0]));

if($srcdir =~ /([^\/]+)\/([^\/]+)$/){
    ($molecule,$exp1) = ($1,$2);
}


@basenames = ();
@fullnames = ();
foreach $i (@inputfiles){
    push @fullnames,abs_path($i);
    push @basenames,basename($i,'.in');
}

$logdir = "/others/avery/outputs/${jobid}/${molecule}/${exp1}";
system("mkdir -p $logdir");

$script = << "END"
#!/bin/bash
# @ output = $logdir/qscf.\$(Host).\$(Cluster).\$(Process).out
# @ error = $logdir/qscf.\$(Host).\$(Cluster).\$(Process).err
# @ wall_clock_limit = 48000 
# @ class = large
# @ resources = ConsumableCpus(4) ConsumableMemory(10gb) 
# @ queue
SCR=/scratch/\$LOADL_STEP_ID/${jobid}
mkdir -p \$SCR
cd $root
cp -R bases opv5parameters.in geometries ${srcdir}/* \$SCR/
cd \$SCR

echo "\$SCR"
hostname
uname -a
( while true; do
    hostname > ${logdir}/${jobid}.\${LOADL_STEP_ID}.top; 
    top -b -n 1 | head -n 30 >> ${logdir}/${jobid}.\${LOADL_STEP_ID}.top; sleep 60;
done ) &
toppid=$!

echo "toppid = $toppid\n"

for base in @basenames; do
 echo "Calculating ${jobid}/\${base}";
 (openmp-qscf \${base}.in | tee \${base}.out) 2> >(tee \${base}.err >&2);
done
cd ..
tar czf ${logdir}/${jobid}.\${LOADL_STEP_ID}.tar.gz $jobid 
rm -rf $jobid

killall toppid
END
;
print $script;

