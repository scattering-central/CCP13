C     LAST UPDATE 10/12/92
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SVDVAR(V,MA,NP,W,CVM,NCVM)
      IMPLICIT NONE
C
C Purpose: Evaluates the covariancs matrix CVM of the fit for MA
C          parameters obtained by SVDFIT. Call this routine with
C          matrices V,W as returned from SVDFIT. NP,NCVM give the
C          physical dimensions of V,W,CVM.
C
      INTEGER MA,NP,NCVM
      REAL V(NP,NP),W(NP),CVM(NCVM,NCVM)
C
C Calls   0:
C Called by: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER MMAX
      PARAMETER(MMAX=5000)
      REAL WTI(MMAX)
      REAL SUM 
      INTEGER I,J,K
C
C---------------------------------------------------------------------
      DO 10 I=1,MA
         WTI(I) = 0.0
         IF(W(I).NE.0.0)WTI(I) = 1.0/(W(I)*W(I))
 10   CONTINUE
      DO 40 I=1,MA
         DO 30 J=1,I
            SUM = 0.0
            DO 20 K=1,MA
               SUM = SUM + V(I,K)*V(J,K)*WTI(K)
 20         CONTINUE
            CVM(I,J) = SUM
            CVM(J,I) = SUM
 30      CONTINUE
 40   CONTINUE
      RETURN
      END
