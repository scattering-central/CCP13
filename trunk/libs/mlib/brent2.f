C     LAST UPDATE 17/07/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION BRENT2(AX,BX,CX,F,TOL,XMIN)
      IMPLICIT NONE
C
C Purpose: Given a function F and
C          given a bracketing triplet of abscissas AX,BX,CX [such
C          that BX is between AX and CX, and F(BX) is less than 
C          both F(AX) and F(CX)], this routine isolates the minimum
C          to a fractional precision of about TOL using a modification
C          of Brent's method that uses derivatives. The abscissa of the
C          minimum is returned as XMIN and the minimum function value
C          is returned as BRENT2, the returned function value. 
C
C Calls   1: F
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER ITMAX
      REAL GOLD,ZEPS
      PARAMETER(ITMAX=100, GOLD=0.3819660,ZEPS=1.0E-10)
C
C Scalar arguments:
C
      REAL AX,BX,CX,TOL,XMIN 
C
C Function arguments:
C
      REAL F
      EXTERNAL F
C
C External function:
C
      REAL F1DIM
      EXTERNAL F1DIM
C 
C Local variables:
C
      INTEGER ITER
      REAL A,B,D,E,FU,FV,FW,FX,U,V,W,X,XM,TOL1,TOL2,ETEMP,P,Q,R  
C
C-----------------------------------------------------------------------
      A = MIN(AX,CX)
      B = MAX(AX,CX)
      V = BX
      W = V
      X = V 
      E = 0.0
      FX = F1DIM(X,F)
      FV = FX
      FW = FX
      DO 10 ITER=1,ITMAX
         XM = 0.5*(A+B)
         TOL1 = TOL*ABS(X) + ZEPS
         TOL2 = 2.0*TOL1
         IF(ABS(X-XM).LE.(TOL2-0.5*(B-A)))GOTO 3
         IF(ABS(E).GT.TOL1)THEN
            R = (X-W)*(FX-FV)
            Q = (X-V)*(FX-FW)
            P = (X-V)*Q - (X-W)*R
            Q = 2.0*(Q-R)
            IF(Q.GT.0.0)P=-P
            Q = ABS(Q)
            ETEMP = E
            E = D 
            IF(ABS(P).GE.ABS(0.5*Q*ETEMP).OR.P.LE.Q*(A-X).OR.
     &         P.GE.Q*(B-X))GOTO 1
            D = P/Q 
            U = X + D
            IF(U-A.LT.TOL2.OR.B-U.LT.TOL2)D=SIGN(TOL1,XM-X)
            GOTO 2
         ENDIF 
 1       IF(X.GE.XM)THEN 
            E = A - X
         ELSE
            E = B - X
         ENDIF
         D = GOLD*E
 2       IF(ABS(D).GE.TOL1)THEN
            U = X + D
            FU = F1DIM(U,F)
         ELSE
            U = X + SIGN(TOL1,D)
         ENDIF
         FU = F1DIM(U,F)
         IF(FU.LE.FX)THEN
            IF(U.GE.X)THEN
               A = X
            ELSE
               B = X
            ENDIF
            V = W
            FV = FW
            W = X
            FW = FX
            X = U
            FX = FU
         ELSE
            IF(U.LT.X)THEN
               A = U
            ELSE
               B = U
            ENDIF
            IF(FU.LE.FW.OR.W.EQ.X)THEN
               V = W
               FV = FW
               W = U
               FW = FU
            ELSEIF(FU.LE.FV.OR.V.EQ.X.OR.V.EQ.W)THEN
               V = U
               FV = FU
            ENDIF
         ENDIF
 10   CONTINUE 
      WRITE(6,1000)
 3    XMIN = X
      BRENT2 = FX
      RETURN
C
 1000 FORMAT(1X,'BRENT:Warning - maximum number of iterations reached')
C-----------------------------------------------------------------------
      END                  
