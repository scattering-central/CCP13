C     LAST UPDATE 16/10/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      INTEGER FUNCTION NMIN(L,U,T,NSTRT,NSTCK,NMAX)
      IMPLICIT NONE
C
C Purpose: Find the minimum bessel function order (unsigned) which 
C          will contribute to a layer line.
C
C Calls   0:
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Arguments:
C
      INTEGER L,U,T,NSTRT,NSTCK,NMAX
C
C Local variables:
C
      INTEGER MMAX,M,N
C
C-----------------------------------------------------------------------
      IF(MOD(NSTCK*L,U).EQ.0)THEN
         NMIN = 0
         RETURN
      ENDIF
      NMIN = NMAX + 1
      MMAX = (ABS(NSTCK*L)+ABS(T)*NMAX)/ABS(U) + 1
      DO 10 M=-MMAX,MMAX
         N = ABS(L)*NSTCK - ABS(U)*M
         IF(MOD(N,T).EQ.0)THEN
            N = ABS(N/T)
            IF(MOD(N,NSTRT).EQ.0)NMIN = MIN(NMIN,N)
         ENDIF
 10   CONTINUE
      IF(NMIN.GT.NMAX)NMIN = -1
      RETURN
      END                  
