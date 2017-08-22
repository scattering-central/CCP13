C     LAST UPDATE 29/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FPOLY(X,A,Y,DYDA,NA)
      IMPLICIT NONE
C
C Purpose: Calculates function and derivatives for polynomial
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Arguments:
C
      INTEGER NA 
      DOUBLE PRECISION A(NA+1),DYDA(NA+1)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      INTEGER I,J
      DOUBLE PRECISION TEMP
C
C-----------------------------------------------------------------------
      Y = 0.0D0 
      TEMP = 1.0D0
      J = NA + 1
      DO 10 I=1,NA+1
         Y = Y*X + A(I)
         DYDA(J) = TEMP
         TEMP = TEMP*X
         J = J - 1 
 10   CONTINUE
C
      RETURN
      END
