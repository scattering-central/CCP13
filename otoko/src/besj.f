C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE BESJ (X,N,BJ,D,IRC)
C
C Purpose: Calculate a Bessel function.
C
      DOUBLE PRECISION X
      REAL    BJ,D
      INTEGER N,IRC
C
C X      :
C BJ     :
C D      :
C N      :
C IRC    :
C
C Calls   0:
C Called by: GENFUN
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
C-----------------------------------------------------------------------
      BJ=0.
      IF (N.LT.0) THEN
         IRC=1
      ELSEIF (X.LE.0.0) THEN
         IRC=2
      ELSE
         IF ((X-15.0).LE.0.0) THEN
            NTEST=20.+10.*X-X**2/3
         ELSE
            NTEST=90.+X/2.
         ENDIF
         IF ((N-NTEST).GE.0) THEN
            IRC=4
         ELSE
            IRC=0
            N1=N+1
            BPREV=0.
            IF ((X-5.0).LT.0.0) THEN
               MA=X+6.
            ELSE
               MA=1.4*X+60./X
            ENDIF
            MB=N+INT(X)/4+2
            MZERO=MAX0(MA,MB)
            MMAX=NTEST
            DO 10 M=MZERO,MMAX,3
               FM1=1.0E-28
               FM=0
               ALPHA=0.
               IF ((M-(M/2)*2).EQ.0) THEN
                  JT= -1
               ELSE
                  JT=1
               ENDIF
               M2=M-2
               DO 20 K=1,M2
                  MK=M-K
                  BMK=2.*REAL(MK)*FM1/X-FM
                  FM=FM1
                  FM1=BMK
                  IF ((MK-N-1).EQ.0) BJ=BMK
                  JT=-JT
                  S=1+JT
                  ALPHA=ALPHA+BMK*S
20             CONTINUE
               BMK =2.*FM1/X-FM
               IF (N.EQ.0) BJ=BMK
               ALPHA=ALPHA+BMK
               BJ=BJ/ALPHA
               IF ((ABS(BJ-BPREV)-ABS(D*BJ)).LE.0.0) GOTO 999
               BPREV=BJ
10          CONTINUE
            IER=3
         ENDIF
      ENDIF
999   RETURN
      END
