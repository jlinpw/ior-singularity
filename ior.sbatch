#!/bin/bash

#SBATCH --job-name=ior_mdtest
#SBATCH -N 10
#SBATCH --ntasks-per-node=4
#SBATCH -o /home/jlin/run_bench_%j.out
#SBATCH -e /home/jlin/run_bench_%j.out

set -ex

source wfenv.sh

# run dir setup
mkdir -p /lustre/bench/ior/bin_$SLURM_JOB_ID /lustre/bench/ior/run_$SLURM_JOB_ID
mkdir -p /lustre/bench/mdtest/bin_$SLURM_JOB_ID /lustre/bench/mdtest/run_$SLURM_JOB_ID

# standard ior
mpiexec -np $SLURM_CPUS_ON_NODE singularity exec --bind /lustre ior.sif ior -w -i 3 -o /lustre/bench/ior/run_$SLURM_JOB_ID/out -t 64m -b 64m -s 16 -F -C -e > ior_$SLURM_JOB_ID.txt