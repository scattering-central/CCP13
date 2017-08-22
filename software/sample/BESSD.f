C     LAST UPDATE 02/09/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE BESSD(X,F,DF)
      IMPLICIT NONE
C
C Purpose: Calculates the value and derivative of a bessel function
C          order NBESS (passed in common) at X.
C
C Calls   1: BESSJ
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Arguments:
C
      REAL X,F,DF
C
C External function:
C
      REAL BESSJ
      EXTERNAL BESSJ
C
C Common block variables:
C
      INTEGER NBESS
C
C Common blocks:
C
      COMMON /BORDER/NBESS
C
C-----------------------------------------------------------------------
      F = BESSJ(NBESS,X)
      IF(ABS(X).GT.0.0)THEN
         DF = BESSJ(NBESS-1,X) - FLOAT(NBESS)*F/X
      ELSE
         IF(ABS(NBESS).EQ.1)THEN
            DF = FLOAT(NBESS)/2.0
         ELSE
            DF = 0.0
         ENDIF
      ENDIF
      RETURN
      END                  
