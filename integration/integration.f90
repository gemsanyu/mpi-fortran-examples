program integration
  use mpi
  use functions
  implicit none

  integer :: process_rank, cluster_size, ierror
  integer, parameter :: MASTER_RANK = 0
  real, parameter :: D = 0.00000001
  real :: a, b
  character(100) :: a_str, b_str
  real :: proc_a, proc_b
  real :: z, proc_z
  double precision :: start_time, end_time
  double precision :: calc_time, max_calc_time

  call MPI_INIT(ierror)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, cluster_size, ierror)
  call MPI_COMM_RANK(MPI_COMM_WORLD, process_rank, ierror)

  ! Read a,b from command line argument
  ! the argument is treated as string, need to convert to real
  call get_command_argument(1, a_str)
  call get_command_argument(2, b_str)
  read(a_str, *) a
  read(b_str, *) b

  ! calculate the a,b segment for each process into proc_a,proc_b
  start_time = MPI_WTIME()
  proc_a = (b-a)/cluster_size * process_rank + a
  proc_b = proc_a + (b-a)/cluster_size
  proc_b = min(proc_b, b)
  proc_z = integrate(proc_a, proc_b, D)
  end_time = MPI_WTIME()
  calc_time = end_time - start_time

  print *, "Process:", process_rank, "A=", proc_a, "B=", proc_b, "time", calc_time
  call MPI_REDUCE(proc_z, z, 1, MPI_REAL, MPI_SUM, MASTER_RANK, MPI_COMM_WORLD, ierror)
  call MPI_REDUCE(calc_time, max_calc_time, 1, MPI_DOUBLE, MPI_MAX, MASTER_RANK, &
   MPI_COMM_WORLD, ierror)
  call MPI_BARRIER(MPI_COMM_WORLD, ierror)
  if (MASTER_RANK == process_rank) then
    print *,"The result of integrating f(x) from A=:",a,"to B=",b, "is", z
    print *,"Maximum computation time:", max_calc_time
  end if

  call MPI_FINALIZE(ierror)

end program integration
