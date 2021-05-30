! Each process will generate a random number, and then the main process will compute
! the mean of all generated random numbers
program reduce
  use mpi
  implicit none

  integer :: process_rank, cluster_size, ierror
  integer, parameter :: MASTER_RANK = 0
  real :: r(2), argmin_r(2)

  call MPI_INIT(ierror)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, cluster_size, ierror)
  call MPI_COMM_RANK(MPI_COMM_WORLD, process_rank, ierror)

  ! Save the proc_rank in the second element of r
  call random_number(r(1))
  r(2) = process_rank

  print *, "process rank:", process_rank, "generated", r(1)
  call MPI_ALLREDUCE(r, argmin_r, 1, MPI_2REAL, MPI_MINLOC, &
    MPI_COMM_WORLD, ierror)

  print *, "process rank:", process_rank, "knows the smallest is", argmin_r

  call MPI_FINALIZE(ierror)
end program reduce
