C     LAST UPDATE 10/12/92
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SVDFIT(X,Y,SIG,NDATA,A,MA,U,V,W,MP,NP,CHISQ,FUNCS)
      IMPLICIT NONE
C
C Purpose: Performs linear least squares given a set of NDATA points
C          X(I),Y(I) with individual standard deviations SIG(I) to 
C          determine the MA coefficients of A of the fitting function
C          y = sum j {Aj * AFUNCj(x)} by singular value decomposition.
C          of the NDATA by MA matrix. Arrays U,V,W provide workspace
C          on input, on output they define the singular value
C          decomposition and can be used to obtain the covariance
C          matrix. MP,NP are the physical dimensions of the matrices
C          U,V,W . It is necessary that MP>=NDATA, NP>=MA. The program 
C          returns values for the MA fit parameters A and CHISQ.
C          The user supplied subroutine FUNCS(X,AFUNC,MA) returns the
C          MA basis functions evaluated at x = X in the array AFUNC.
C
      INTEGER NDATA,MA,MP,NP
      REAL X(NDATA),Y(NDATA),SIG(NDATA)
      REAL A(MA),V(NP,NP),U(MP,NP),W(NP)
      REAL CHISQ
C
C Calls   2: SVDVAR , FUNCS
C Called by: 
C
      EXTERNAL FUNCS
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER NMAX,MMAX
      REAL TOL
      PARAMETER(NMAX=1000,MMAX=50,TOL=1.0E-05)
      REAL B(NMAX),AFUNC(MMAX)
      REAL THRESH,WMAX,SUM,TMP 
      INTEGER I,J
C
C---------------------------------------------------------------------
      DO 20 I=1,NDATA
         CALL FUNCS(X(I),AFUNC,MA)
         TMP = 1.0/SIG(I)
         DO 10 J=1,MA
            U(I,J) = AFUNC(J)*TMP
 10      CONTINUE
         B(I) = Y(I)*TMP
 20   CONTINUE
      CALL SVDCMP(U,NDATA,MA,MP,NP,W,V)
      WMAX = 0.0
      DO 30 J=1,MA
         IF(W(J).GT.WMAX)WMAX = W(J)
 30   CONTINUE
      THRESH = TOL*WMAX
      DO 40 J=1,MA
         IF(W(J).LT.THRESH)W(J) = 0.0
 40   CONTINUE
      CALL SVBKSB(U,W,V,NDATA,MA,MP,NP,B,A)
      CHISQ = 0.0
      DO 60 I=1,NDATA
         CALL FUNCS(X(I),AFUNC,MA)
         SUM = 0.0
         DO 50 J=1,MA
            SUM = SUM + A(J)*AFUNC(J)
 50      CONTINUE
         CHISQ = CHISQ + ((Y(I)-SUM)/SIG(I))**2
 60   CONTINUE
      RETURN
      END
