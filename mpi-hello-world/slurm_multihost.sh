#!/bin/bash
#
#SBATCH --job-name=mpi_send
#SBATCH --output=mpi_send_%A.out
#SBATCH --error=mpi_send_%A.err
#
#SBATCH --time=00:01:00
#SBATCH --nodelist=komputasi03,komputasi04

make clean; make all;
mpirun --hostfile hosts -npernode 2 hello_world;
