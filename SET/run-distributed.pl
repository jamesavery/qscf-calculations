#!/usr/bin/perl

my ($config,$job,$dir) = @ARGV;

my %capacity;
my $number_of_procs=0;
my $hostname = &trim(`hostname -s`);

my @inputs;
my @proc_chunks;
my @proc_chunk_lengths;
my $number_of_jobs;
my $number_of_hosts;
my $my_pid;
my $my_job;
my $my_job_length;
my @my_inputs;

sub trim {
    my $s = $_[0];
    $s =~ s/^\s*(.*?)\s*$/$1/;
    return $s;
}

sub take {
    my ($start,$n,@list) = @_;
    my @r = ();
    my $i;

    for($i=$start;($i<$start+$n) && ($i<@list);$i++){
	push @r,$list[$i];
    }
    return @r;
}

sub readpool {
    print STDERR "Reading $_[0].pool\n";
    open(POOL,"< ./$_[0].pool");
    my @lines = <POOL>;
    my $i;
    for($i=0;$i<@lines;$i++)
    {
	$l = $lines[$i];
	if($l =~ /\s*(\w+)\s*\:\s*(\d+)/){
	    $capacity{$1} = $2;
	    if(!($1 cmp $hostname)){
		$my_pid = $i;
		$my_procs_start = $number_of_procs;
		$my_procs_end   = $my_procs_start + $capacity{$1} - 1;
	    }
	    $number_of_procs += $2;
	    $number_of_hosts += 1;
	}
    }
    close POOL;
}

sub getjobs {
    opendir(JOBDIR,"./$dir");
    @inputs = grep { /^$job.*?.in$/ } readdir(JOBDIR);
    $number_of_jobs = $#inputs+1;
    closedir(JOBDIR);
}

sub division_of_labour {
    # First divide the jobs among the available processors:
    # I can't find integer division, modulo, ceil and floor in Perl. Look them up!
    my $unit_chunk_length = sprintf("%d",$number_of_jobs/$number_of_procs);
    my $remainder = sprintf("%d",($number_of_jobs/$number_of_procs-$unit_chunk_length)*$number_of_procs+1e-6);

#    print STDERR "Unit chunk length: $unit_chunk_length; Remainder: $remainder.\n";
    my $chunk = 0;
    my ($p,$i);
    for($p=0;$p<$number_of_procs;$p++){
	$proc_chunk_lengths[$p] = $unit_chunk_length + ($p<$remainder?1:0);
	$proc_chunks[$p] = $chunk;
	$chunk += $proc_chunk_lengths[$p];
    }
    
    # Now find what jobs for which this host is responsible:
    $my_job = $proc_chunks[$my_procs_start];
    $my_job_length = 0; 
    for($p=$my_procs_start;$p<=$my_procs_end;$p++){
	$my_job_length += $proc_chunk_lengths[$p];
    }
    for($i=$my_job;$i<$my_job+$my_job_length;$i++){
	push @my_inputs, $inputs[$i];
    }
}

&readpool($config);
&getjobs;
&division_of_labour;


# foreach $I (@inputs){
#     print "$I\n";
# }
# print "In total $number_of_jobs jobs.\n";

# foreach $k (keys %capacity){
#     print "$k should run $capacity{$k} concurrent jobs.\n";
# }
# print "In total $number_of_procs_total concurrent jobs.\n";

for($p=0;$p<$number_of_procs;$p++){
    print STDERR "$p: $proc_chunks[$p]-".($proc_chunks[$p]+$proc_chunk_lengths[$p]-1)
	." ($proc_chunk_lengths[$p])\n";
}

#  print STDERR "$hostname($capacity{$hostname}): $my_job-".($my_job+$my_job_length-1)."\n";
#  for($i=$my_job;$i<$my_job+$my_job_length;$i++){
#      print STDERR "I own $inputs[$i].\n";
#  }

# Use fork() and wait() instead. Look up how.
chdir $dir;
for($i=0;$i<@my_inputs;$i+=$capacity{$hostname}){
    print STDERR "Chunk: ${i}-".($i+$capacity{$hostname}-1).".\n";
    my @chunk = &take($i+1,$capacity{$hostname}-1,@my_inputs);
    my $I0 = $my_inputs[$i];
     system("for I in @chunk; do echo \$I; (((qscf \$I >  `basename \$I .in`.out) 2> `basename \$I .in`.err)&) done; echo I0: ${I0}; ((qscf ${I0} >  `basename ${I0} .in`.out) 2> `basename ${I0} .in`.err)");    

}

# for($i=0;$i<@my_inputs;$i+=$capacity{$hostname}){
#      print STDERR "Chunk: ${i}-".($i+$capacity{$hostname}-1).".\n";
#      my @chunk = &take($i+1,$capacity{$hostname}-1,@my_inputs);
#      my $I0 = $my_inputs[$i];
     
#      system("for I in @chunk; do echo \$I; (((qscf \$I >  `basename \$I .in`.out) 2> `basename \$I .in`.err)&) done; echo I0: ${I0}; (qscf ${I0} >  `basename ${I0} .in`.out) 2> `basename ${I0} .in`.err");
# }
