program scatterv
  use mpi
  implicit none

  integer :: process_rank, cluster_size, ierror
  integer, parameter :: MASTER_RANK = 0
  integer, allocatable :: arr(:), arr_p(:), arr_squared(:), arr_p_sizes(:)
  integer, allocatable :: displs(:)
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

  if (arr_size < cluster_size) then
    print *, "The total array size can't be smaller than the cluster size"
    stop
  end if

  ! initiate whole array in master process
  if (MASTER_RANK == process_rank) then
    allocate(arr(arr_size))
    allocate(arr_squared(arr_size))
    arr = [(i, i=1,arr_size)]
  end if

  ! now that each process can have different partial array size
  ! the arr_p_size must be determined by its rank
  ! example arr_size = 10, cluster_size = 4
  ! arr_p_size = 3,3,2,2, note the up to the 2-nd element is (2+1) because
  ! 2 == 10 mod 4, and 2 == floor(10/4)

  ! first allocate the array to store the partial array sizes in the master
  ! and for displacements
  if (MASTER_RANK == process_rank) then
    allocate(arr_p_sizes(cluster_size))
    allocate(displs(cluster_size))
  end if

  ! then calculate each process' partial arr size
  ! floored automatically because both are int
  arr_p_size = arr_size/cluster_size
  if (process_rank < mod(arr_size, cluster_size)) then
    arr_p_size = arr_p_size + 1
  end if

  ! then gather the appropriate arr_p_size to the master
  call MPI_GATHER(arr_p_size, 1, MPI_INT, arr_p_sizes, 1, MPI_INT, &
    MASTER_RANK, MPI_COMM_WORLD, ierror)

  ! calculate displacements for each process
  if (MASTER_RANK == process_rank) then
    print *, "Partial Arr Sizes", arr_p_sizes
    displs(1) = 0
    do i=2, cluster_size
      displs(i)=displs(i-1)+arr_p_sizes(i-1)
    end do
  end if

  ! allocate partial array in all processes
  allocate(arr_p(arr_p_size))

  ! scatter/distribute the whole array to all processes
  call MPI_SCATTERV(arr, arr_p_sizes, displs, MPI_INT, arr_p, arr_p_size, &
    MPI_INT, MASTER_RANK, MPI_COMM_WORLD, ierror)

  ! square the array members
  print *, "Process:", process_rank, "squaring", arr_p
  do i=1,arr_p_size
    arr_p(i) = arr_p(i)**2
  end do
  print *, "Process:", process_rank, "now with", arr_p

  ! gather again
  call MPI_GATHERV(arr_p, arr_p_size, MPI_INT, arr_squared, arr_p_sizes, &
    displs, MPI_INT, MASTER_RANK, MPI_COMM_WORLD, ierror)

  if (MASTER_RANK == process_rank) then
    print *, arr_squared
  end if

  call MPI_FINALIZE(ierror)
end program scatterv
