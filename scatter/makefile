MPI_FLAGS = -g -ffpe-trap=zero,invalid,overflow,underflow -Wall -Werror

all: scatter scatterv

scatterv:
	mpifort $(MPI_FLAGS) scatterv.f90 -o scatterv

scatter:
	mpifort $(MPI_FLAGS) scatter.f90 -o scatter

clean:
	rm -rf scatter scatterv
