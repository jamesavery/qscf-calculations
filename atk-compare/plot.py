from NanoLanguage import *;
from pylab import *;


potential = nlread('neutest.nc', ElectrostaticDifferencePotential)[0]
rho       = nlread('neutest.nc', ElectronDifferenceDensity)[0]

m = 43;
xs = arange(0,18.897259886,18.897259886/87.0);
rholine = array(rho[:,m,m]).transpose()[0,0];
potline = array(potential[:,m,m]).transpose()[0,0];

plot(rholine);
show();
