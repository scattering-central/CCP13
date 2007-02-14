C     LAST UPDATE 22/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FGAUSS(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is Gaussian. The amplitude. centre
C          and width of the Gaussian are stored in consecutive locations
C          of A: A(1) = H,  A(2) = P,  A(3) = FWHM
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY,FACTOR
      PARAMETER(TINY=1.0D-10,FACTOR=1.66510922231D0)
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
      W = A(3)/FACTOR
      ARG = (X-A(2))/W
      EX = EXP(-ARG*ARG)
      FAC = A(1)*EX*2.0D0*ARG
      Y = A(1)*EX
      DYDA(1) = EX
      DYDA(2) = FAC/W
      DYDA(3) = FACTOR*FAC*ARG/W
C
      RETURN
      END


