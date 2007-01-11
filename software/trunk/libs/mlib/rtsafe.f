      REAL FUNCTION RTSAFE(FUNCD,X1,X2,XACC)
      IMPLICIT NONE
C----------------------------------------------------------------------
C Purpose: Calculate roots of a function (FUNCD) by a combination
C          of Newton-Raphson and bisection.
C
C Parameters:
C
      INTEGER MAXIT
      PARAMETER(MAXIT=100)
C
C Arguments:
C
      EXTERNAL FUNCD
      REAL X1,X2,XACC
C
C Local variables:
C
      INTEGER J
      REAL XL,XH,FL,FH,DX,DXOLD,F,DF,TEMP
C----------------------------------------------------------------------
      RTSAFE = 0.0
      CALL FUNCD(X1,FL,DF)
      CALL FUNCD(X2,FH,DF)
      IF(FL*FH.GE.0.0)THEN
         WRITE(6,2000)
         RETURN
      ENDIF
      IF(FL.LT.0.0)THEN
         XL = X1
         XH = X2
      ELSE
         XH = X1
         XL = X2
      ENDIF
      RTSAFE = 0.5*(X1+X2)
      DXOLD = ABS(X1-X2)
      DX = DXOLD
      CALL FUNCD(RTSAFE,F,DF)
      DO 10 J=1,MAXIT
         IF(((RTSAFE-XH)*DF-F)*((RTSAFE-XL)*DF-F).GE.0.0.OR.
     &      ABS(2.0*F).GT.ABS(DXOLD*DF))THEN
            DXOLD = DX
            DX = 0.5*(XH-XL)
            RTSAFE = XL + DX
            IF(XL.EQ.RTSAFE)RETURN
         ELSE
            DXOLD = DX
            DX = F/DF
            TEMP = RTSAFE
            RTSAFE = RTSAFE - DX
            IF(TEMP.EQ.RTSAFE)RETURN
         ENDIF
         IF(ABS(DX).LT.XACC)RETURN
         CALL FUNCD(RTSAFE,F,DF)
         IF(F.LT.0.0)THEN
            XL = RTSAFE
         ELSE
            XH = RTSAFE
         ENDIF
 10   CONTINUE
      WRITE(6,1000)
      RETURN
 1000 FORMAT(1X,'ROOT:Warning - maximum number of iterations exceeded')
 2000 FORMAT(1X,'ROOT:Error - root must be bracketed')
      END
