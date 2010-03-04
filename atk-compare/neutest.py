##
# LCAO Module imports
##
from NanoLanguage import *

##
# Bulk configuration
##

# Set up lattice
charge = -1
vector_a = [10.,  0.0, 0.0]*Angstrom
vector_b = [0.0,  10., 0.0]*Angstrom
vector_c = [0.0,  0.0, 10.]*Angstrom
lattice = UnitCell(vector_a, vector_b, vector_c)

# Define elements
elements = [Hydrogen]

# Define coordinates
cartesian_coordinates = [[  5.1,   5.1,  5.1 ]]*Angstrom



# Set up configuration
bulk_configuration = BulkConfiguration(
    bravais_lattice=lattice,
    elements=elements,
    cartesian_coordinates=cartesian_coordinates
)

nlprint(bulk_configuration)

##
# Calculator
##
poisson_solver = MultigridSolver(
    boundary_conditions=[DirichletBoundaryCondition,
                         NeumannBoundaryCondition,
                         NeumannBoundaryCondition]
)

calculator = LCAOCalculator(
    charge=float(charge),
    poisson_solver=poisson_solver,
    numerical_accuracy_parameters=NumericalAccuracyParameters(
        grid_mesh_cutoff=100*Hartree,
        k_point_sampling = [1, 1, 1]
    )
)

bulk_configuration.setCalculator(calculator)

##
# Analysis
##
bulk_configuration.update()
filename = 'neutest.q='+str(int(charge))+'/neutest.nc'
nlsave(filename, bulk_configuration)

potential = ElectrostaticDifferencePotential(bulk_configuration)
nlsave(filename, potential)

rho = ElectronDifferenceDensity(bulk_configuration)
nlsave(filename, rho)

molecular_energy_spectrum = MolecularEnergySpectrum(
    configuration=bulk_configuration,
    energy_zero_parameter=FermiLevel,
    projection_list=ProjectionList(All)
    )
nlsave(filename, molecular_energy_spectrum)
nlprint(molecular_energy_spectrum)

total_energy = TotalEnergy(bulk_configuration)
nlprint(total_energy)
nlsave(filename, total_energy)

