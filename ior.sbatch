#!/bin/bash

#SBATCH -N 10
#SBATCH --ntasks-per-node=4
#SBATCH -o /home/jlin/run_bench_%j.out
#SBATCH -e /home/jlin/run_bench_%j.out

set -ex

source wfenv.sh

# run dir setup
sudo mkdir -p /hammerspace/bench/ior/bin_$SLURM_JOB_ID /hammerspace/bench/ior/run_$SLURM_JOB_ID
sudo mkdir -p /hammerspace/bench/mdtest/bin_$SLURM_JOB_ID /hammerspace/bench/mdtest/run_$SLURM_JOB_ID

# ior tests
mpirun -ppn $SLURM_CPUS_ON_NODE singularity exec ior.sif ior -w -r -i 3 -o /hammerspace/bench/ior/run_$SLURM_JOB_ID/out -t 64m -b 64m -s 16 -F -C -e > iort64mb64m_$SLURM_JOB_ID.txt
mpirun -ppn $SLURM_CPUS_ON_NODE singularity exec --bind /hammerspace ior.sif ior -w -r -i 3 -o /hammerspace/bench/ior/run_$SLURM_JOB_ID/out -t 1m -b 64m -s 16 -F -C -e > iort1mb64m_$SLURM_JOB_ID.txt
mpirun -ppn $SLURM_CPUS_ON_NODE singularity exec --bind /hammerspace ior.sif ior -w -r -i 3 -o /hammerspace/bench/ior/run_$SLURM_JOB_ID/out -t 4k -b 64m -s 16 -F -C -e > iort4kb64m_$SLURM_JOB_ID.txt

# mdtest
mpirun -ppn $SLURM_CPUS_ON_NODE /hammerspace/bench/mdtest/bin_$SLURM_JOB_ID/mdtest -n 20840 -e 4096 -w 4096 -i 3 -u -d /hammerspace/bench/mdtest/run_$SLURM_JOB_ID > $HOME/standard_mdtest_$SLURM_JOB_ID.txt
mpirun -ppn $SLURM_CPUS_ON_NODE /hammerspace/bench/mdtest/bin_$SLURM_JOB_ID/mdtest -n 20840 -i 1 -u -d /hammerspace/bench/mdtest/run_$SLURM_JOB_ID > $HOME/minimal_mdtest_$SLURM_JOB_ID.txt