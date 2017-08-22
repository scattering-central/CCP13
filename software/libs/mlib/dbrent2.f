C     LAST UPDATE 17/07/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION DBRENT2(AX,BX,CX,F,DF,TOL,XMIN)
      IMPLICIT NONE
C
C Purpose: Given a function F and its derivative function DF, and
C          given a bracketing triplet of abscissas AX,BX,CX [such
C          that BX is between AX and CX, and F(BX) is less than 
C          both F(AX) and F(CX)], this routine isolates the minimum
C          to a fractional precision of about TOL using a modification
C          of Brent's method that uses derivatives. The abscissa of the
C          minimum is returned as XMIN and the minimum function value
C          is returned as DBRENT2, the returned function value. 
C
C Calls   2: F, DF
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER ITMAX
      REAL ZEPS
      PARAMETER(ITMAX=100, ZEPS=1.0E-10)
C
C Scalar arguments:
C
      REAL AX,BX,CX,TOL,XMIN 
C
C Function arguments:
C
      REAL F
      EXTERNAL F,DF
C
C External functions:
C
      REAL F1DIM,DF1DIM
      EXTERNAL F1DIM,DF1DIM
C 
C Local variables:
C
      INTEGER ITER
      LOGICAL OK1,OK2
      REAL A,B,D,DU,DV,DW,DX,E,FU,FV,FW,FX,U,V,W,X,XM,TOL1,TOL2,D1,D2,
     &     U1,U2,OLDE  
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
      DX = DF1DIM(X,DF)
      DV = DX
      DW = DX
      DO 10 ITER=1,ITMAX
         XM = 0.5*(A+B)
         TOL1 = TOL*ABS(X) + ZEPS
         TOL2 = 2.0*TOL1
         IF(ABS(X-XM).LE.(TOL2-0.5*(B-A)))GOTO 3
         IF(ABS(E).GT.TOL1)THEN
            D1 = 2.0*(B-A)
            D2 = D1
            IF(DW.NE.DX)D1 = (W-X)*DX/(DX-DW)
            IF(DV.NE.DX)D2 = (V-X)*DX/(DX-DV)
            U1 = X + D1
            U2 = X + D2
            OK1 = ((A-U1)*(U1-B).GT.0.0).AND.(DX*D1.LE.0.0)
            OK2 = ((A-U2)*(U2-B).GT.0.0).AND.(DX*D2.LE.0.0)
            OLDE = E
            E = D
            IF(.NOT.(OK1.OR.OK2))THEN
               GOTO 1
            ELSEIF(OK1.AND.OK2)THEN
               IF(ABS(D1).LT.ABS(D2))THEN
                  D = D1
               ELSE
                  D = D2
               ENDIF
            ELSEIF(OK1)THEN
               D = D1
            ELSE
               D = D2
            ENDIF
            IF(ABS(D).GT.ABS(0.5*OLDE))GOTO 1
            U = X + D
            IF(U.LT.TOL2.OR.B-U.LT.TOL2)D=SIGN(TOL1,XM-X)
            GOTO 2
         ENDIF 
 1       IF(DX.GE.0.0)THEN
            E = A - X
         ELSE
            E = B - X
         ENDIF
         D = 0.5*E
 2       IF(ABS(D).GE.TOL1)THEN
            U = X + D
            FU = F1DIM(U,F)
         ELSE
            U = X + SIGN(TOL1,D)
            FU = F1DIM(U,F)
            IF(FU.GT.FX)GOTO 3
         ENDIF
         DU = DF1DIM(U,DF)
         IF(FU.LE.FX)THEN
            IF(U.GE.X)THEN
               A = X
            ELSE
               B = X
            ENDIF
            V = W
            FV = FW
            DV = DW
            W = X
            FW = FX
            DW = DX
            X = U
            FX = FU
            DX = DU
         ELSE
            IF(U.LT.X)THEN
               A = U
            ELSE
               B = U
            ENDIF
            IF(FU.LE.FW.OR.W.EQ.X)THEN
               V = W
               FV = FW
               DV = DW
               W = U
               FW = FU
               DW = DU
            ELSEIF(FU.LE.FV.OR.V.EQ.X.OR.V.EQ.W)THEN
               V = U
               FV = FU
               DV = DU
            ENDIF
         ENDIF
 10   CONTINUE 
      WRITE(6,1000)
 3    XMIN = X
      DBRENT2 = FX
      RETURN
C
 1000 FORMAT(1X,'DBRENT:Warning - maximum number of iterations reached')
C-----------------------------------------------------------------------
      END                  
