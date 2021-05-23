program send_async
  use mpi
  implicit none

  integer :: process_rank, cluster_size, ierror, request, status(MPI_STATUS_SIZE)
  integer, parameter :: MASTER_RANK = 0, ARR_SIZE = 10
  integer, allocatable :: arr(:), arr_p(:)
  integer :: i
  integer :: arr_p_size
  integer :: receiver_rank, start_idx, end_idx

  call MPI_INIT(ierror)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, cluster_size, ierror)
  call MPI_COMM_RANK(MPI_COMM_WORLD, process_rank, ierror)

  ! Initiate the whole array only in the master process
  if (MASTER_RANK == process_rank) then
    allocate(arr(ARR_SIZE))
    arr = [(i, i=1,ARR_SIZE)]
  end if

  ! Initiate partial array in each process (even the master)
  arr_p_size = ARR_SIZE/cluster_size
  allocate(arr_p(arr_p_size))
  ! Master send partial array even to itself
  if (MASTER_RANK == process_rank) then
    do receiver_rank = 0, cluster_size-1
      start_idx = receiver_rank*arr_p_size + 1
      end_idx = (receiver_rank+1)*arr_p_size
      call MPI_ISEND(arr(start_idx:end_idx), arr_p_size, MPI_INT, receiver_rank, &
        1, MPI_COMM_WORLD, request, ierror)
    end do
  end if

  call MPI_IRECV(arr_p(1:arr_p_size), arr_p_size, MPI_INT, MASTER_RANK, 1, &
    MPI_COMM_WORLD, request, ierror)
  call MPI_WAIT(request, status, ierror)
  print *,"Hi I'm rank:",process_rank,"I have arr_p=",arr_p(:)

  call MPI_FINALIZE(ierror)
end program send_async
