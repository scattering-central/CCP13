C     LAST UPDATE 30/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FLORENTZ(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Lorentzian. The amplitude. centre and width of the
C           Lorentzian are stored in consecutive locations of A: 
C           A(1) = H,  A(2) = P,  A(3) = FWHM
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY
      PARAMETER(TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A(10),DYDA(10)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION  ARG,EX,FAC,W
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      W = A(3)/2.0D0
      ARG = (X-A(2))/W
      FAC = (1.0D0+ARG*ARG)
      Y = A(1)/FAC
      EX = 2.0D0*ARG*A(1)/(FAC*FAC)
      DYDA(1) = 1.0D0/FAC
      DYDA(2) = EX/W
      DYDA(3) = 2.0D0*ARG*EX/W
C
      RETURN
      END


