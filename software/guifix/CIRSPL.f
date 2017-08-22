C     LAST UPDATE 29/11/94
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE CIRSPL(X,Y,N,Y2)
      IMPLICIT NONE
C
C Purpose: Given arrays X and Y of length N containing a tabulated
C          function,  Yi = f(Xi),  with   X1<X2<...Xn ,  this routine
C          returns an array Y2 of length N which contains the second
C          derivatives of the interpolating function at the tabulated 
C          points Xi, assuming circular boundary conditions i.e. Y0 = Yn
C
      INTEGER N
      REAL X(N),Y(N),Y2(N)
C
C Calls   0:
C Called by: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER NMAX
      PARAMETER(NMAX=50)
      REAL A(NMAX,NMAX)
      REAL DX1,DX2,DY1,DY2,D
      INTEGER INDX(NMAX)
      INTEGER I,K,IP1,IM1
C
C---------------------------------------------------------------------
C
      DO 10 I=1,N
         DO 5 K=1,N
            A(I,K) = 0.0
 5       CONTINUE
C
C========Set up circular boundary conditions
C
         IF(I.EQ.1)THEN
            IM1 = N
         ELSE
            IM1 = I - 1
         ENDIF
         IF(I.EQ.N)THEN
            IP1 = 1
         ELSE
            IP1 = I + 1
         ENDIF
         DX1 = X(I) - X(IM1)
         DX2 = X(IP1) - X(I)
         DY1 = Y(I) - Y(IM1)
         DY2 = Y(IP1) - Y(I)
         A(I,IM1) = DX1/6.0
         A(I,I) = (DX2+DX1)/3.0
         A(I,IP1) = DX2/6.0
         Y2(I) = DY2/DX2 - DY1/DX1
 10   CONTINUE
C
C========Solve linear equations for y" using LU decomposition
C 
      CALL LUDCMP(A,N,NMAX,INDX,D)
      CALL LUBKSB(A,N,NMAX,INDX,Y2)
      RETURN
      END
