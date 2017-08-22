C     LAST UPDATE 17/07/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FRPRMN(P,N,FTOL,ITER,FRET,FUNC,DFUNC)
      IMPLICIT NONE
C
C Purpose: Minimization of a function FUNC of N variables. Input
C          consists of an initial starting point P that is a vector
C          of length N, and FTOL, the fractional tolerance in the 
C          function value. On output, P is set to the best point
C          found, FRET is the minimum obtained, ITER is the number
C          of iterations taken.
C
C Calls   2: DLINMIN, DFUNC 
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER NMAX,ITMAX
      REAL EPS 
      PARAMETER(NMAX=50, ITMAX=200, EPS=1.0E-10)
C
C Arguments:
C
      INTEGER N,ITER  
      REAL P(N)
      REAL FTOL,FRET 
C
C External functions:
C
      REAL FUNC
      EXTERNAL FUNC,DFUNC
C 
C Local variables:
C
      INTEGER J,ITS 
      REAL G(NMAX),H(NMAX),XI(NMAX) 
      REAL FP,GG,DGG,GAM 
C
C-----------------------------------------------------------------------
      FP = FUNC(P)
      CALL DFUNC(P,XI)
      DO 10 J=1,N
         G(J) = -XI(J)
         H(J) = G(J)
         XI(J) = H(J)
 10   CONTINUE
      DO 40 ITS=1,ITMAX
         ITER = ITS 
         CALL DLINMIN(P,XI,N,FRET,FUNC,DFUNC)
         IF(2.0*ABS(FP-FRET).LE.FTOL*(ABS(FP)+ABS(FRET)))RETURN
         FP = FUNC(P)
         CALL DFUNC(P,XI)
         GG = 0.0
         DGG = 0.0
         DO 20 J=1,N
            GG = GG + G(J)**2
C           DGG = DGG + XI(J)**2
            DGG = DGG + (XI(J)+G(J))*XI(J)
 20      CONTINUE
         IF(GG.EQ.0.0)RETURN
         GAM = DGG/GG 
         DO 30 J=1,N
            G(J) = -XI(J)
            H(J) = G(J) + GAM*H(J)
            XI(J) = H(J)
 30      CONTINUE
 40   CONTINUE 
      WRITE(6,1000)
      RETURN
C
 1000 FORMAT(1X,'FRPRMN:Warning - maximum number of iterations')
      END                  
