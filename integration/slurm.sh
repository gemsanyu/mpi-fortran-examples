#!/bin/bash
#
#SBATCH --job-name=trpz
#SBATCH --output=%A.out
#SBATCH --error=%A.err
#
#SBATCH --time=00:05:00
#SBATCH --nodelist=komputasi05

make clean; make all;
mpirun -np 4 integration 0 10

# mpirun --report-bindings --oversubscribe --bind-to hwthread -np 4 integration 0 10
# mpirun -h hosts --report-bindings --oversubscribe --bind-to core -npernode integration 0 10
