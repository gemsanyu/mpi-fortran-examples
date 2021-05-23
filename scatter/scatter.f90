program scatter
  use mpi
  implicit none

  integer :: process_rank, cluster_size, ierror
  integer, parameter :: MASTER_RANK = 0
  integer, allocatable :: arr(:), arr_p(:), arr_squared(:)
  integer :: i
  integer :: arr_size, arr_p_size


  character(100) :: arr_size_char

  call MPI_INIT(ierror)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, cluster_size, ierror)
  call MPI_COMM_RANK(MPI_COMM_WORLD, process_rank, ierror)

  ! Read arr_size from command line argument
  ! the argument is treated as string, need to convert to int
  call get_command_argument(1, arr_size_char)
  read(arr_size_char, *) arr_size

  if (mod(arr_size, cluster_size) /= 0) then
    print *, "The total array size must be divisible by the cluster size"
  end if

  ! initiate whole array in master process
  if (MASTER_RANK == process_rank) then
    allocate(arr(arr_size))
    allocate(arr_squared(arr_size))
    arr = [(i, i=1,arr_size)]
  end if

  ! allocate partial array in all processes
  arr_p_size = arr_size/cluster_size
  allocate(arr_p(arr_p_size))

  ! scatter/distribute the whole array to all processes
  call MPI_SCATTER(arr, arr_p_size, MPI_INT, arr_p, arr_p_size, MPI_INT, &
    MASTER_RANK, MPI_COMM_WORLD, ierror)

  ! square the array members
  print *, "Process:", process_rank, "squaring", arr_p
  do i=1,arr_p_size
    arr_p(i) = arr_p(i)**2
  end do
  print *, "Process:", process_rank, "now with", arr_p

  ! gather again
  call MPI_GATHER(arr_p, arr_p_size, MPI_INT, arr_squared, arr_p_size, MPI_INT, &
    MASTER_RANK, MPI_COMM_WORLD, ierror)

  if (MASTER_RANK == process_rank) then
    print *, arr_squared
  end if

  call MPI_FINALIZE(ierror)
end program scatter
