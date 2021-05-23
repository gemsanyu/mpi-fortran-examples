! Each process will generate a random number, and then the main process will compute
! the mean of all generated random numbers
program reduce
  use mpi
  implicit none

  integer :: process_rank, cluster_size, ierror
  integer, parameter :: MASTER_RANK = 0
  real :: r, mean

  call MPI_INIT(ierror)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, cluster_size, ierror)
  call MPI_COMM_RANK(MPI_COMM_WORLD, process_rank, ierror)

  call random_number(r)
  r = FLOOR(r*5)
  print *, "process rank:", process_rank, "generated", r
  call MPI_REDUCE(r, mean, 1, MPI_REAL, MPI_SUM, MASTER_RANK, MPI_COMM_WORLD, ierror)

  if (MASTER_RANK == process_rank) then
    mean = mean/cluster_size
    print *,"The mean of the generated numbers is:", mean
  end if

  call MPI_FINALIZE(ierror)
end program reduce
