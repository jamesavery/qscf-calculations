###############################################################
# LCAO Module imports
###############################################################
from NanoLanguage import *

###############################################################
# Bulk configuration
###############################################################

# Set up lattice
lattice = SimpleCubic(10*Angstrom)

# Define elements
elements = [Carbon]

# Define coordinates
cartesian_coordinates = [[ 5.1,  5.1,  5.1]]*Angstrom

# Set up configuration
bulk_configuration = BulkConfiguration(
    bravais_lattice=lattice,
    elements=elements,
    cartesian_coordinates=cartesian_coordinates
    )
nlprint(bulk_configuration)

###############################################################
# Calculator
###############################################################
poisson_solver = MultigridSolver(
    boundary_conditions=[[DirichletBoundaryCondition,DirichletBoundaryCondition],
                         [NeumannBoundaryCondition,NeumannBoundaryCondition],
                         [NeumannBoundaryCondition,NeumannBoundaryCondition]]
    )

calculator = LCAOCalculator(
    poisson_solver=poisson_solver,
    )

bulk_configuration.setCalculator(calculator)

###############################################################
# Analysis
###############################################################
bulk_configuration.update()
nlsave('analysis.nc', bulk_configuration)

total_energy = TotalEnergy(bulk_configuration)
nlprint(total_energy)
nlsave('analysis.nc', total_energy)