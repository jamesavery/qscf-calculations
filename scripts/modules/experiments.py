#!/usr/bin/env python

experiments = {
    'vacuum' :{
        'Exp1': {
            'description': "Molecule sitting in a large box of vacuum.",
            'order': ['charge']
            }
        },
    'large': {
        'SET':  {
            'description': "Full diamond calculation of molecule in SET-environment.",
            'order': ['charge','Vg','Vsd']
            }
        },
    'Vzero': {
        'SET':  {
            'description': "Molecule in SET-environment. Fixed Vsd=0, Vg varied.",
            'order': ['charge','Vg','Vsd']
            },
        'SET2': {
            'description': "Molecule in SET-environment. Fixed Vsd=1V, Vg varied.",
            'order': ['charge','Vg','Vsd'],
            }
        },
    'groundzero': {
        'SET':  {
            'description': "Molecule in SET-environment. Fixed Vg=0, Vsd varied.",
            'order': ['charge','Vg','Vsd'],
            }
        },
    'SET-lengths': {
        'Exp1': {
            'description': "Molecule in SET-environment. Fixed dist_y,dist_x=1AA,\n"
                          +"oxideH and Vg varied.",
            'order': ['charge','Vg','oxideH']
            },
        'Exp2': {
            'description': "Molecule in SET-environment. Fixed dist_x=1AA, oxideH=50AA, Vsd=0\n"
                          +"dist_y and Vg varied.",
            'order': ['charge','Vg','dist_y']
            },
        'Exp3': {
            'description': "Molecule in SET-environment. Fixed dist_y=1AA, oxideH=50AA, Vsd=0\n"
                          +"dist_x and Vg varied.",
            'order': ['charge','Vg','dist_x']
            },
        'Exp4': {
            'description': "Molecule in SET-environment. Fixed dist_y=1AA, oxideH=50AA, Vsd=0\n"
            +"dist_x and Vsd varied.",
            'order': ['charge','Vsd','dist_x']
            }
        },
    'SET-dimensions': {
        'description': "Molecule in SET-environment. Dimensions of 'world box' increased",
        'vacuum': ['charge','boxW'],
        'SET-2':  ['charge','Vg','boxW']
        },
    'SET-accuracy': {
        'description': "Molecule in SET-environment. Vsd=2V. final_dE varied and approximate "
                     + "diamond plot is calculated for each accuracy to determine convergence.",
        'SET-2': ['charge','Vg','Vsd','final_dE']
        }
    };
