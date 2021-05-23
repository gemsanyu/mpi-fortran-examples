MPI_FLAGS = -g -ffpe-trap=zero,invalid,overflow,underflow -Wall -Werror

all: send send_async

send: send.f90
	mpifort $(MPI_FLAGS) send.f90 -o send

send_async: send_async.f90
	mpifort $(MPI_FLAGS) send_async.f90 -o send_async

clean:
	rm -rf send send_async
