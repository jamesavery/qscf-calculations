#!/usr/bin/env python
from modules.convert import *;
from modules.qm_collect import *;

[molecule] = argv[1:];

energies = collect_molecule("Firefly",molecule);

print "results = %s;\n" % mathematica_repr(energies);
