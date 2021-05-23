module functions
  implicit none

  contains
    function f(x) result(y)
      implicit none
      real, intent(in) :: x
      real :: y
      y = sin(x)+sqrt(x)
    end function f

    function integrate(a, b, d) result(z)
      implicit none
      real, intent(in) :: a, b, d
      real :: z
      integer :: N
      integer :: i

      N = floor((b-a)/d)
      z = 0
      do i=0,N-1
        z = z + ((f(a+d*real(i))+f(a+d*real(i+1)))*d/2)
      end do
    end function integrate

end module functions
