C     LAST UPDATE 25/03/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION GAMMP(A,X)
      IMPLICIT NONE
C
C Purpose: Calculates the incomplete gamma function P(a,x)
C
C Calls   2: GSER   , GCF 
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Arguments:
C
      REAL A,X
C  
C Local variables:
C
      REAL GAMSER,GAMMCF,GLN 
C
C-----------------------------------------------------------------------
      GAMMP = 0.0
      IF(X.LT.0.0.OR.A.LE.0.0)THEN
         WRITE(6,1000)
         RETURN
      ENDIF 
      IF(X.LT.A+1.0)THEN
         CALL GSER(GAMSER,A,X,GLN)
         GAMMP = GAMSER  
      ELSE
         CALL GCF(GAMMCF,A,X,GLN)
         GAMMP = 1.0 - GAMMCF
      ENDIF
      RETURN
C
 1000 FORMAT(1X,'Error - invalid argument to gamma function')
      END                  
