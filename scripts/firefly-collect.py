#!/usr/bin/env python
from modules.convert import *;
from modules.collect import *;

[molecule] = argv[1:];

energies = collect_molecule("Firefly",molecule);

print mathematica_repr(energies);
