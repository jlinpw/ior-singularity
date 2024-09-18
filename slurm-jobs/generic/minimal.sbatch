#!/bin/bash

#SBATCH -N 10
#SBATCH --ntasks-per-node=4
#SBATCH -o /home/jlin/run_bench_%j.out
#SBATCH -e /home/jlin/run_bench_%j.out

source wfenv.sh

# run dir setup
mkdir -p /lustre/bench/ior/bin_$SLURM_JOB_ID /lustre/bench/ior/run_$SLURM_JOB_ID
mkdir -p /lustre/bench/mdtest/bin_$SLURM_JOB_ID /lustre/bench/mdtest/run_$SLURM_JOB_ID

# ior tests
mpirun -ppn $SLURM_CPUS_ON_NODE singularity exec --bind /lustre ior.sif ior -w -r -i 1 -o /lustre/bench/ior/run_$SLURM_JOB_ID/out  -t 1m -b 16m -s 16 -F -C -e

# mdtest
mpirun -ppn $SLURM_CPUS_ON_NODE singularity exec --bind /lustre ior.sif mdtest -n 20840 -i 1 -u -d /lustre/bench/mdtest/run_$SLURM_JOB_ID