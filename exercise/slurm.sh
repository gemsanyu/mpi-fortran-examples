#!/bin/bash
#
#SBATCH --job-name=exercise
#SBATCH --output=%A.out
#SBATCH --error=%A.err
#
#SBATCH --time=00:05:00
#SBATCH --nodelist=komputasi05

hostname -s;
whoami;

make clean; make all;
mpirun -np 1 exercise
