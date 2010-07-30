#!/usr/bin/perl
use File::Basename;
use Cwd 'abs_path';

($inputfile) = (abs_path($ARGV[0]));

$root   = $ENV{'OPV'};
$srcdir = dirname($inputfile);
$input  = basename($inputfile);

if($inputfile =~ /([^\/]+)\/([^\/]+)\/([^\/]+)\.in$/){
    ($molecule,$exp1,$exp2) = ($1,$2,$3);
}

$logdir = "/others/avery/outputs/${molecule}/${exp1}";
system("mkdir -p $logdir");

$script = << "END"
#!/bin/sh
# @ output = $logdir/${exp2}.\$(Host).\$(Cluster).\$(Process).out
# @ error = $logdir/${exp2}.\$(Host).\$(Cluster).\$(Process).err
# @ wall_clock_limit = 24000 
# @ class = large
# @ resources = ConsumableCpus(4) ConsumableMemory(4gb) 
# @ queue
SCR=/scratch/\$LOADL_STEP_ID/${molecule}/${exp1}/${exp2}
mkdir -p \$SCR
cd $root
cp -R bases opv5parameters.in geometries ${srcdir}/*.msh ${inputfile} \$SCR/
cd \$SCR

echo "\$SCR"
hostname
uname -a
cat /proc/cpuinfo

(( while true; do
    hostname > ${logdir}/qscf.\${LOADL_STEP_ID}.top; 
    top -b -n1 | head -n 30 >> ${logdir}/qscf.\${LOADL_STEP_ID}.top; 
    sleep 60;
   done ) &); toppid=\$!

echo "toppid = \$toppid"

openmp-qscf ${input}

kill \$toppid
END
;
print $script;

