module functions
  implicit none

  contains
    function f(x) result(y)
      implicit none
      double precision :: pi = 4.D0*DATAN(1.D0)
      real, intent(in) :: x
      real :: y
      y = sin(10*pi*x)/2*x + (x-1)**4
    end function f

end module functions
