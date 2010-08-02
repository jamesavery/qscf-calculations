#!/usr/bin/env python
from __future__ import with_statement;
import os, errno;
from sys import argv;
from modules.scanf import sscanf;

[log,prefix] = argv[1:3];

def mkdir_p(path):
    try:
        os.makedirs(path);
    except OSError: 
        pass;

inputfiles = [];
jobids     = [];

with open(log,'r') as f:
    lines = f.readlines();
    splitpoints = [i for i in range(len(lines))
                   if lines[i].startswith("Calculating ")];
    splitpoints.append(len(lines));
    
    for k in range(len(splitpoints)-1):
        [i,j] = splitpoints[k:k+2];
        
        (jobid) = sscanf(lines[i],"Calculating %s")[0];
        (jobid,inputfile) = jobid.split("/");
        inputfiles.append(inputfile);
        jobids.append(jobid);
        
        mkdir_p(prefix+"/"+jobid);

        outputs = lines[i:j+1];
        print (jobid,inputfile);

        with open(prefix+"/"+jobid+"/"+inputfile+".out",'w') as g:
            g.writelines(outputs);

with open(path.splitext(log)[0]+".err",'r') as f:
    lines = f.readlines();
    splitpoints = [i for i in range(len(lines))
                   if lines[i].startswith("No ScfParam")];
    splitpoints.append(len(lines));

    for k in range(len(splitpoints)-1):
        [i,j] = splitpoints[k:k+2];
        outputs = lines[i:j+1];

        with open(prefix+"/"+jobid+"/"+inputfile+".err",'w') as g:
            g.writelines(outputs);
