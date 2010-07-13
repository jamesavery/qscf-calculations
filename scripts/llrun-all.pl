#!/usr/bin/perl
use File::Basename;
use Cwd 'abs_path';

($jobid,@inputfiles) = @ARGV;

$root   = $ENV{'OPV'};
$srcdir = dirname(abs_path($inputfiles[0]));

$logdir = "/others/avery/outputs/${jobid}";
system("mkdir -p $logdir");

$script = << "END"
#!/bin/sh
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
top -b -n1 
for a in @inputfiles; do
 base=`basename \$a .in`;
 echo "Calculating ${jobid}/\${base}";
 (openmp-qscf \${base}.in | tee \${base}.out) 2> \${base}.err;
done
cd ..
tar czf ${logdir}/${jobid}.tar.gz $jobid 
rm -rf $jobid

END
;
print $script;

