#!/bin/bash
#
#SBATCH --job-name=mpi_send
#SBATCH --output=mpi_send_%A.out
#SBATCH --error=mpi_send_%A.err
#
#SBATCH --time=00:01:00

make clean; make all;
mpirun -np 4 send
