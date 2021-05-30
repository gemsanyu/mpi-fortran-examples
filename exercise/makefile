all: integration

integration:
	mpifort -g -ffpe-trap=zero,invalid,overflow,underflow -Wall -Werror functions.f90 integration.f90 -o integration

clean:
	rm -rf functions integration
