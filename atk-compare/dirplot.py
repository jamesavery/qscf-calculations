from NanoLanguage import *;
from pylab import *;


potential = nlread('dirtest.nc', ElectrostaticDifferencePotential)[0]
rho       = nlread('dirtest.nc', ElectronDifferenceDensity)[0]

m  = 38;
mf = 75;
xs = arange(0,18.897259886,18.897259886/mf);
rholine = array(rho[:,m,m]).transpose()[0,0];
potline = array(potential[:,m,m]).transpose()[0,0];

plot(xs,rholine);
show();
