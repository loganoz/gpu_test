program main
   use iso_fortran_env
   implicit none

   integer, parameter :: n = 1000000
   real(real32), allocatable :: a(:), b(:), c(:)
   integer :: i
   real(real64) :: t1, t2

   allocate(a(n), b(n), c(n))

   ! Initialize
   a = 1.0
   b = 2.0
   c = 0.0

   call cpu_time(t1)

   ! Offload loop to GPU
   !$acc data copyin(a,b) copyout(c)
   !$acc parallel loop
   do i = 1, n
      c(i) = a(i) + b(i)
   end do
   !$acc end parallel loop
   !$acc end data

   call cpu_time(t2)

   print *, "Check result: c(1)=", c(1), " (expected 3.0)"
   print *, "Time: ", t2 - t1, " seconds"

   deallocate(a, b, c)
end program main
