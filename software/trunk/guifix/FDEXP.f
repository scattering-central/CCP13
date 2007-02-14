C     LAST UPDATE 18/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FDEXP(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is double exponential. The amplitude. centre and widths
C          of the double exponential are stored in consecutive locations 
C          of A: 
C          A(1) = B,  A(2) = E,  A(3) = G1, A(4) = G2
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
      DOUBLE PRECISION  ARG1,ARG2,EX1,EX2,FAC
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      IF(A(4).LT.TINY)A(4) = TINY
      ARG1 = (X-A(2))/A(3)
      ARG2 = (X-A(2))/A(4)
      EX1 = EXP(-ARG1)
      EX2 = EXP(ARG2)
      FAC = EX1 + EX2
      Y = 2.0D0*A(1)/FAC
      DYDA(1) = 2.0D0/FAC
      DYDA(2) = Y*(EX2/A(4)-EX1/A(3))/FAC
      DYDA(3) = -Y*ARG1*EX1/(FAC*A(3))
      DYDA(4) = Y*ARG2*EX2/(FAC*A(4))
C
      RETURN
      END


