program mpi_hello_world
  use mpi

  real, parameter :: MASTER_RANK = 0

  integer :: process_rank, cluster_size, ierror
  integer :: hostname_len
  character(32) :: hostname

  call MPI_INIT(ierror)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, cluster_size, ierror)
  call MPI_COMM_RANK(MPI_COMM_WORLD, process_rank, ierror)
  call MPI_GET_PROCESSOR_NAME(hostname, hostname_len, ierror)

  print *, "Hello World, I'm Process with Rank:", process_rank, "From Host:", hostname

  call MPI_FINALIZE(ierror)
end program mpi_hello_world
