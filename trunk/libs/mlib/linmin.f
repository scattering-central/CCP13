C     LAST UPDATE 17/07/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE LINMIN(P,XI,N,FRET,FUNC)
      IMPLICIT NONE
C
C Purpose: Given an N dimensional point P and an N dimensional direction
C          XI, moves and resets P to where the function FUNC(P) takes on
C          a minimum along the direction XI from P, and replaces XI by
C          the actual vector displacement that P was moved. Also returns
C          as FRET the value of FUNC at the returned location of P. This
C          is accomplished by calling the routines MNBRAK2 and BRENT2. 
C
C Calls   2: NMBRAK, BRENT 
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER NMAX
      REAL TOL
      PARAMETER(NMAX=500, TOL=1.0E-04)
C
C Arguments:
C
      INTEGER N
      REAL P(N),XI(N)
      REAL FRET
      REAL FUNC
      EXTERNAL FUNC
C
C External functions:
C
      REAL F1DIM,BRENT2
      EXTERNAL F1DIM,BRENT2
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
      REAL AX,XX,BX,FA,FX,FB,XMIN,SUM
C
C-----------------------------------------------------------------------
      NCOM = N
      SUM = 0.0
      DO 10 J=1,N
         PCOM(J) = P(J)
         XICOM(J) = XI(J)
         SUM = SUM + XI(J)*XI(J)
 10   CONTINUE
      IF(SUM.EQ.0.0)RETURN
      AX = 0.0
      XX = 1.0
      CALL MNBRAK2(AX,XX,BX,FA,FX,FB,FUNC)
      FRET = BRENT2(AX,XX,BX,FUNC,TOL,XMIN)
      DO 20 J=1,N
         XI(J) = XMIN*XI(J)
         P(J) = P(J) + XI(J)
 20   CONTINUE 
      RETURN
C
C-----------------------------------------------------------------------
      END                 


