C     LAST UPDATE 29/09/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FDEBYE(X,A,Y,DYDA)
      IMPLICIT NONE
C
C Purpose: Y(X;A) is the Debye approximation to the intensity transform 
C          for chain molecules. 
C          of A: A(1) = I(0),  A(2) = Origin,  A(3) = 1/Rg
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      DOUBLE PRECISION TINY
      PARAMETER(TINY=1.0D-10)
C
C Arguments:
C
      DOUBLE PRECISION A(*),DYDA(*)
      DOUBLE PRECISION X,Y  
C
C Local variables:
C
      DOUBLE PRECISION ARG,ARG2,ARG4,EX,FAC,DARG
C
C-----------------------------------------------------------------------
      IF(A(3).LT.TINY)A(3) = TINY
      ARG = (X-A(2))/A(3)
      ARG2 = ARG*ARG
      IF(ARG2.LT.TINY)THEN
         Y = A(1)
         DYDA(1) = 1.0D0
         DYDA(2) = 0.0D0
         DYDA(3) = 0.0D0
      ELSE
         ARG4 = ARG2*ARG2
         EX = EXP(-ARG2)
         FAC = 2.0D0*(EX-1.0D0+ARG2)
         Y = A(1)*FAC/ARG4
         DYDA(1) = FAC/ARG4
         DARG = 2.0D0*A(1)*((2.0D0/ARG2)*(1.0D0-EX)-EX-1.0D0)/ARG4
         DYDA(2) = -2.0D0*ARG*DARG/A(3)
         DYDA(3) = -2.0D0*ARG2*DARG/A(3)
      ENDIF
C
      RETURN
      END


