program send
  use mpi
  implicit none

  integer :: process_rank, cluster_size, ierror
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

  ! master send partial array to all other process
  ! except master process, because this is synchronous
  ! MPI_SEND, which means the MPI_SEND process will wait
  ! until the receiver process do MPI_RECV
  ! if master do MPI_SEND, then it will wait forever
  ! because the line with MPI_RECV is never reached
  ! DEADLOCK, Source: MPI 1.1 Section 3.2.4
  if (MASTER_RANK == process_rank) then
    do receiver_rank = 0, cluster_size-1
      if (MASTER_RANK == receiver_rank) then
        arr_p(1:arr_p_size)=arr(1:arr_p_size)
      else
        start_idx = receiver_rank*arr_p_size + 1
        end_idx = (receiver_rank+1)*arr_p_size
        call MPI_SEND(arr(start_idx:end_idx), arr_p_size, MPI_INT, receiver_rank, 1, MPI_COMM_WORLD, ierror)
      end if
    end do
  end if

  ! All process except the master prepare to receive message
  if (MASTER_RANK /= process_rank) then
    call MPI_RECV(arr_p(1:arr_p_size), arr_p_size, MPI_INT, MASTER_RANK, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierror)
  end if

  print *,"Hi I'm rank:",process_rank,"I have arr_p=",arr_p(:)

  deallocate(arr_p)
  if (MASTER_RANK == process_rank) then
    deallocate(arr)
  end if
  call MPI_FINALIZE(ierror)
end program send
