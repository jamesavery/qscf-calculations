# This file defines parameters for the numerical calculations.

# Parameters for SCF-iteration
%convergenceparams = (
    tolerance => 1.e-7,
    maxiterations => 80,
    electrontemperature => 0.01
);

# Parameters for FEM-code
%feparams = (
    'fe_order' => 1,
    'write_mesh' => "false",		
    'write_solution' => "none",
#'refinement_strategy' => 'centers_density_plus_curve',
    'refinement_strategy' => 'centers_plus_density',
    'centers_max_diameter'=>4,
    'centers_near_diameter'=>7,	# Any cell within this distance must
				# have diameter centers_max_diameter
				# or smaller.

    'end_refine' => 0.0,        # How much should the mesh be refined
				# when doing final total-energy
				# calculation?

    'initial_refinement' => 2,	# For unit-cell meshes, what should the
                                # initial refinement be? Doesn't apply 
	                        # when loading meshes.
    'final_dE' => `grep final_dE config.sh | cut -f 2 -d = `,
    'final_dC' => `grep final_dC config.sh | cut -f 2 -d = `
 );
 

