C     LAST UPDATE 17/07/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION F1DIM(X,FUNC)
      IMPLICIT NONE
C
C Purpose: Evaluates function FUNC along P + X.XI  
C 
C Calls   1: FUNC
C Called by: DLINMIN 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER NMAX
      PARAMETER(NMAX=500)
C
C Arguments:
C
      REAL X
C
C External functions:
C
      REAL FUNC
      EXTERNAL FUNC 
C
C Common block:
C
      INTEGER NCOM
      REAL PCOM(NMAX),XICOM(NMAX)
      COMMON /F1COM/ PCOM,XICOM,NCOM
C
C Local variables:
C
      INTEGER J 
      REAL XT(NMAX)
C
C-----------------------------------------------------------------------
      DO 10 J=1,NCOM
         XT(J) = PCOM(J) + X*XICOM(J)
 10   CONTINUE
      F1DIM = FUNC(XT)
      RETURN
      END 





C     LAST UPDATE 17/07/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION DF1DIM(X,DFUNC)
      IMPLICIT NONE
C
C Purpose: Evaluates scalar product of DFUNC(XI) with XI  
C 
C Calls   1: DFUNC
C Called by: DLINMIN 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER NMAX
      PARAMETER(NMAX=500)
C
C Arguments:
C
      REAL X
      EXTERNAL DFUNC
C
C Common block:
C
      INTEGER NCOM
      REAL PCOM(NMAX),XICOM(NMAX)
      COMMON /F1COM/ PCOM,XICOM,NCOM
C
C Local variables:
C
      INTEGER J 
      REAL XT(NMAX),DF(NMAX)
C
C-----------------------------------------------------------------------
      DO 10 J=1,NCOM
         XT(J) = PCOM(J) + X*XICOM(J)
 10   CONTINUE
      CALL DFUNC(XT,DF)
      DF1DIM = 0.0 
      DO 20 J=1,NCOM
         DF1DIM = DF1DIM + DF(J)*XICOM(J)
 20   CONTINUE 
      RETURN
      END 

