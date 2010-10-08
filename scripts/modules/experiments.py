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
    'natVzero': {
        'natSET':  {
            'description': "Molecule in SET-environment. Fixed Vsd=0, Vg varied.",
            'order': ['charge','Vg','Vsd']
            },
        'natSET-2': {
            'description': "Molecule in SET-environment. Fixed Vsd=1V, Vg varied.",
            'order': ['charge','Vg','Vsd'],
            }
        },
        'Vzero': {
        'SET':  {
            'description': "Molecule in SET-environment. Fixed Vsd=0, Vg varied.",
            'order': ['charge','Vg','Vsd']
            },
        'SET-2': {
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
            'order': ['charge','Vg','Vsd','dist_x']
            },
        'Exp4': {
            'description': "Molecule in SET-environment. Fixed dist_y=1AA, oxideH=50AA, Vsd=0\n"
            +"dist_x and Vsd varied.",
            'order': ['charge','Vsd','dist_x']
            }
        },
    'SET-dimensions': {
        'vacuum': { 'order': ['charge','boxW'] },
        'SET-2':  { 'order': ['charge','Vg','boxW'] }
        },
    'SET-accuracy': {
        'SET-2': {
            'description': "Molecule in SET-environment. Vsd=2V. final_dE varied and approximate "
                     + "diamond plot is calculated for each accuracy to determine convergence.",
           'order': ['charge','Vg','Vsd','final_dE']
           }
        },
    'sanity' : {
        'Exp2b' : {
          'description': "H atom at distance dX from metal surface (V=0).",
          'order': ['charge','dX']
        }
    }
    };
