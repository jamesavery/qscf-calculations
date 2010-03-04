##
# LCAO Module imports
##
from NanoLanguage import *

##
# Bulk configuration
##

# Set up lattice
vector_a = [12.0, 0.0, 0.0]*Angstrom
vector_b = [0.0, 12.0, 0.0]*Angstrom
vector_c = [0.0, 0.0, 18.63]*Angstrom
lattice = UnitCell(vector_a, vector_b, vector_c)

# Define elements
elements = [Hydrogen]

# Define coordinates
cartesian_coordinates = [[  6.      ,   6.      ,  9.315 ]]*Angstrom

# Set up configuration
bulk_configuration = BulkConfiguration(
    bravais_lattice=lattice,
    elements=elements,
    cartesian_coordinates=cartesian_coordinates
    )

# Add metallic region
metallic_region_0 = BoxRegion(
    0*Volt,
    xmin = 0*Angstrom, xmax = 12*Angstrom, 
    ymin = 0*Angstrom, ymax = 1*Angstrom, 
    zmin = 0*Angstrom, zmax = 18.63*Angstrom
)

metallic_region_1 = BoxRegion(
    0*Volt,
    xmin = 0*Angstrom, xmax = 12*Angstrom, 
    ymin = 4.77*Angstrom, ymax = 12*Angstrom, 
    zmin = 0*Angstrom, zmax = 4*Angstrom
)

metallic_region_2 = BoxRegion(
    0*Volt,
    xmin = 0*Angstrom, xmax = 12*Angstrom, 
    ymin = 4.77*Angstrom, ymax = 12*Angstrom, 
    zmin = 14.63*Angstrom, zmax = 18.63*Angstrom
)

metallic_regions = [metallic_region_0, metallic_region_1, metallic_region_2]
bulk_configuration.setMetallicRegions(metallic_regions)

# Add dielectric region
dielectric_region_0 = BoxRegion(
    10,
    xmin = 0*Angstrom, xmax = 12*Angstrom, 
    ymin = 1*Angstrom, ymax = 4.77*Angstrom, 
    zmin = 0*Angstrom, zmax = 18.63*Angstrom
)

dielectric_regions = [dielectric_region_0]
bulk_configuration.setDielectricRegions(dielectric_regions)
nlprint(bulk_configuration)

##
# Calculator
##
poisson_solver = MultigridSolver(
    boundary_conditions=[NeumannBoundaryCondition,NeumannBoundaryCondition,NeumannBoundaryCondition]
    )

calculator = LCAOCalculator(
    charge=-1,
    poisson_solver=poisson_solver,
    )

bulk_configuration.setCalculator(calculator)

##
# Analysis
##
bulk_configuration.update()
filename = 'benzene_set0.nc'
nlsave(filename, bulk_configuration)

electrostatic_potential = ElectrostaticDifferencePotential(bulk_configuration)
nlsave(filename, electrostatic_potential)

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

