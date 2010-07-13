#!/usr/bin/perl

($jobid,$inputdir) = @ARGV;

$root   = $ENV{PWD};
$logdir = "/others/avery/outputs/${jobid}";
system("mkdir -p $logdir");

$script = << "END"
#!/bin/sh
# @ output = $logdir/qscf.\$(Host).\$(Cluster).\$(Process).out
# @ error = $logdir/qscf.\$(Host).\$(Cluster).\$(Process).err
# @ wall_clock_limit = 48000 
# @ class = large
# @ resources = ConsumableCpus(8) ConsumableMemory(10gb) 
# @ queue
SCR=/scratch/\$LOADL_STEP_ID/${jobid}
mkdir -p \$SCR
cp -R bases opv5parameters.in geometries ${inputdir}/* \$SCR/
cd \$SCR

echo "\$SCR"
cat /proc/cpuinfo
hostname
uname -a
for a in *.in; do
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

