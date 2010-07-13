#!/usr/bin/perl

($molecule,$exp1,$exp2) = @ARGV;

$root   = $ENV{PWD};
$srcdir = "${root}/${molecule}/${exp1}";
$inputfile = "${srcdir}/${exp2}.in";
$logdir = "/others/avery/outputs/${molecule}/${exp1}";
system("mkdir -p $logdir");

$script = << "END"
#!/bin/sh
# @ output = $logdir/${exp2}.\$(Host).\$(Cluster).\$(Process).out
# @ error = $logdir/${exp2}.\$(Host).\$(Cluster).\$(Process).err
# @ wall_clock_limit = 24000 
# @ class = large
# @ resources = ConsumableCpus(1) ConsumableMemory(1mb) 
# @ queue
SCR=/scratch/\$LOADL_STEP_ID/${molecule}/${exp1}/${exp2}
mkdir -p \$SCR
cp -R bases opv5parameters.in geometries ${srcdir}/*.msh ${inputfile} \$SCR/
cd \$SCR

echo "\$SCR"
cat /proc/cpuinfo
hostname
uname -a
openmp-qscf ${exp2}.in

END
;
print $script;

