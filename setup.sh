#!/bin/bash

source inputs.sh

# build singularity
singularity build ior.sif docker://joshuarobinson/ior

# get openmpi
wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.5.tar.bz2
tar -xjf openmpi-5.0.5.tar.bz2
cd openmpi-5.0.5
./configure --prefix=$HOME/openmpi
make -j ${commands_nnodes}
make install

export PATH=$HOME/openmpi/bin:$PATH