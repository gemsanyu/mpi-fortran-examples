MPI_FLAGS = -g -ffpe-trap=zero,invalid,overflow,underflow -Wall -Werror

all: reduce reduce_many

reduce:
	mpifort $(MPI_FLAGS) reduce.f90 -o reduce


reduce_many:
	mpifort $(MPI_FLAGS) reduce_many.f90 -o reduce_many


clean:
	rm -rf reduce reduce_many
