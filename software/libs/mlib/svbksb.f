C     LAST UPDATE 10/12/92
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SVBKSB(U,W,V,M,N,MP,NP,B,X)
      IMPLICIT NONE
C
C Purpose: Solves A.X = B for a vector X, where A is specified by the 
C          arrays U,W,V as returned by SDVCMP. M and N are the logical
C          dimensions of A and will be equal for quare matrices. MP and
C          NP are the physical dimensions of A. B is the input right
C          hand side. X is the output solution vector. No input
C          quantities are destroyed so the routine may be called 
C          sequentially wuth different B's. M must be greater or equal
C          to N; see SVDCMP.
C
      INTEGER M,N,MP,NP
      REAL U(MP,MP),V(NP,NP),W(NP),B(MP),X(NP)
C
C Calls   0:
C Called by: SVDFIT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER NMAX
      PARAMETER(NMAX=5000)
      REAL TMP(NMAX)
      REAL S 
      INTEGER I,J,JJ
C
C---------------------------------------------------------------------
      DO 20 J=1,N
         S = 0.0
         IF(W(J).NE.0.0)THEN
            DO 10 I=1,M
               S = S + U(I,J)*B(I)
 10         CONTINUE
            S = S/W(J)
         ENDIF
         TMP(J) = S
 20   CONTINUE
      DO 40 J=1,N
         S = 0.0
         DO 30 JJ=1,N
            S = S + V(J,JJ)*TMP(JJ)
 30      CONTINUE
         X(J) = S
 40   CONTINUE
      RETURN
      END
