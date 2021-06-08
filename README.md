# voter-model-MC
Montecarlo simulation for the voter model with speciation. The core simulation is implemented in Fortran 95, with data fitted and plotted in Python.

The file coresim.f95 runs the Montecarlo simulation. It starts with a 100x100 lattice with periodic boundary conditions where each site is randomly occupied by one of 300 different species.
The user needs to enter the speciation probability. After running the simulation the program outputs a file containing the final state of the lattice.

The file correlations.f95 reads the output file from the core simulation and calculates the spatial correlations between the sites of the lattice. 
The file correl-length.py takes this data as input and fits a Bessel function, obtaining the beta-diversity from the fit parameters.

The file histogram-and-fits.py builds an histogram with the abundance of each species in the lattice obtained from the core simulation, and fits it with an exponential function. 
