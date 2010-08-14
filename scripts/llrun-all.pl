#!/usr/bin/perl
use File::Basename;
use Cwd 'abs_path';

$gb = 1024*1024*1024;
($maxcpu,$maxmem) = (8,16*$gb);

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
# @ wall_clock_limit = 12000
# @ class = large
# @ resources = ConsumableCpus($maxcpu) ConsumableMemory(16gb) 
# @ queue
SCR=/scratch/\$LOADL_STEP_ID/${jobid}
mkdir -p \$SCR
cd $root
cp -R bases opv5parameters.in geometries ${srcdir}/* \$SCR/
cd \$SCR

# Restrict number of processors to the allocated four 
# LoadLeveler apparently just runs on the honour system.
export OMP_NUM_THREADS=$maxcpu

# Limit memory usage -- LoadLeveler does nothing at all to enforce
# this either.  
ulimit -m $maxmem

echo "\$SCR"
hostname
uname -a
(( while true; do
     hostname > ${logdir}/qscf.\${LOADL_STEP_ID}.top; 
     top -b -n1 | head -n 30 >> ${logdir}/qscf.\${LOADL_STEP_ID}.top; 
     sleep 60;
done ) &); 


for base in @basenames; do
 echo "Calculating ${jobid}/\${base}";
 (openmp-qscf \${base}.in | tee \${base}.out) 2> >(tee \${base}.err >&2);
done
cd ..
tar czf ${logdir}/${jobid}.\${LOADL_STEP_ID}.tar.gz $jobid 
cd ..
rm -rf \$LOADL_STEP_ID


# Kill anything that might still be running.
top -n 1 -b | grep avery | grep lljob | cut -f 1 -d ' ' | xargs kill -9

END
;
print $script;

