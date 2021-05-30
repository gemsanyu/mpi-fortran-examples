program integration
  use mpi
  use functions
  implicit none

  integer :: process_rank, cluster_size, ierror
  integer, parameter :: MASTER_RANK = 0
  real :: x, y

  call MPI_INIT(ierror)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, cluster_size, ierror)
  call MPI_COMM_RANK(MPI_COMM_WORLD, process_rank, ierror)

  ! Generate x first
  ! fortran generate random function : call random_number(x)
  ! remember random_number only generate from 0 to 1, need to scale

  ! Compute the y using y = f(x)

  ! By using argmin operator (MPI_MINLOC), we can find which process_rank
  ! has the smallest value
  ! then ask that process to print its x (IF BLOCK)
  ! remember to convert proc_rank to integer again

  call MPI_FINALIZE(ierror)

end program integration
