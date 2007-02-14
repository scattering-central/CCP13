C     LAST UPDATE 18/02/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      REAL FUNCTION FUNC(X)
      IMPLICIT NONE
C
C Purpose: Evaluates the square of the residual for circle fitting
C          given X(1) = XC, X(2) = YC, X(3) = R 
C
C Calls   0:
C Called by: FRPRMN, F1DIM 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C 
C Arguments:
C
      REAL X(3)
C
C Common block:
C
      REAL XD(MAXPTS),YD(MAXPTS)
      INTEGER NDAT 
      COMMON /CIRDAT/ XD,YD,NDAT  
C
C Local variables:
C
      INTEGER I
C
C-----------------------------------------------------------------------
      FUNC = 0.0
      DO 10 I=1,NDAT 
         FUNC = FUNC + (SQRT((X(1)-XD(I))**2+(X(2)-YD(I))**2) - X(3))**2
 10   CONTINUE
      RETURN
C
      END                  





C     LAST UPDATE 18/02/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE DFUNC(X,D)
      IMPLICIT NONE
C
C Purpose: Evaluates the gradient of the square of the residual for 
C          circle fitting given X(1) = XC, X(2) = YC, X(3) = R,
C          returning partial derivatives in array D. 
C          
C
C Calls   0:
C Called by: FRPRMN, DF1DIM 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C 
C Arguments:
C
      REAL X(3),D(3)
C
C Common block:
C
      REAL XD(MAXPTS),YD(MAXPTS)
      INTEGER NDAT 
      COMMON /CIRDAT/ XD,YD,NDAT  
C
C Local variables:
C
      INTEGER I
      REAL DD 
C
C-----------------------------------------------------------------------
      DO 10 I=1,3
         D(I) = 0.0
 10   CONTINUE 
      DO 20 I=1,NDAT 
         DD = SQRT((X(1)-XD(I))**2+(X(2)-YD(I))**2)
         D(1) = D(1) + (X(1)-XD(I))*(1.0-X(3)/DD)
         D(2) = D(2) + (X(2)-YD(I))*(1.0-X(3)/DD)
         D(3) = D(3) + X(3) - DD 
 20   CONTINUE
      DO 30 I=1,3
         D(I) = 2.0*D(I)
 30   CONTINUE 
      RETURN
C
      END                  

