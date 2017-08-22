C     LAST UPDATE 10/10/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FUNCS(X,A,Y,DYDA,NA)
      IMPLICIT NONE
C
C Purpose: Calls specific functions for curve fitting
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Include file:
C
      INCLUDE 'FIT.COM'
C
C Arguments:
C
      INTEGER NA
      DOUBLE PRECISION A(MAXPAR),DYDA(MAXPAR)
      DOUBLE PRECISION X,Y  
C
C Common block:
C
      INTEGER NPEAKS,NBAK,FEXP,NSELPK,KORIG
      LOGICAL LATCON
      INTEGER FTYPE(20),VTABLE(MAXPAR),FTABLE(MAXPAR),LTABLE(MAXPAR)
      DOUBLE PRECISION XORIG
      DOUBLE PRECISION X1CON(MAXPAR),X2CON(MAXPAR),X3CON(MAXPAR)
      DOUBLE PRECISION X1LIM(MAXPAR),X2LIM(MAXPAR)
      COMMON /FCOM  /NPEAKS,NBAK,FEXP,FTYPE,VTABLE,NSELPK
      COMMON /FCOM1 /X1CON,X2CON,X3CON,FTABLE
      COMMON /FCOM2 /XORIG,KORIG,LATCON
      COMMON /FCOM3 /X1LIM,X2LIM,LTABLE
C
C Local variables:
C
      INTEGER I,J,K,NPPAR
      DOUBLE PRECISION  AP(10),DP(10),YP,EX,ARG,DTMP
C
C External functions:
C
      DOUBLE PRECISION FCONST,DFCONST
      EXTERNAL FCONST,DFCONST
C
C-----------------------------------------------------------------------
      K = 0
      Y=0.0D0
      DO 5 I=1,MIN(NA+NBAK+FEXP+1,MAXPAR)
         DYDA(I) = 0.0D0
 5    CONTINUE
      IF(LATCON)THEN
         XORIG = A(KORIG)
         DYDA(KORIG) = 0.0D0
      ENDIF
      DO 30 I=1,NPEAKS
         IF(FTYPE(I).EQ.1)THEN
            NPPAR = 3
         ELSEIF(FTYPE(I).EQ.2)THEN
            NPPAR = 3
         ELSEIF(FTYPE(I).EQ.3)THEN
            NPPAR = 4
         ELSEIF(FTYPE(I).EQ.4)THEN
            NPPAR = 4
         ELSEIF(FTYPE(I).EQ.5)THEN
            NPPAR = 3
         ELSEIF(FTYPE(I).EQ.6)THEN
            NPPAR = 4
         ENDIF
         DO 10 J=1,NPPAR
            K = K + 1
            IF(VTABLE(K).GT.0)THEN
               IF(VTABLE(K).EQ.K)THEN
                  IF(LTABLE(K).EQ.1)THEN
                     IF(A(K).LT.X1LIM(K))A(K) = X1LIM(K)
                     IF(A(K).GT.X2LIM(K))A(K) = X2LIM(K)
                  ENDIF
               ENDIF
               AP(J) = FCONST(A(VTABLE(K)),FTABLE(K),X1CON(K),
     &                        X2CON(K),X3CON(K),XORIG)
               A(K) = AP(J)
            ELSE
               AP(J) = A(K)
            ENDIF
 10      CONTINUE
         K = K - NPPAR
         IF(NSELPK.EQ.0.OR.NSELPK.EQ.I)THEN
            IF(FTYPE(I).EQ.1)THEN
               CALL FGAUSS(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.2)THEN
               CALL FLORENTZ(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.3)THEN
               CALL FPEARSON(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.4)THEN
               CALL FVOIGT(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.5)THEN
               CALL FDEBYE(X,AP,YP,DP)
            ELSEIF(FTYPE(I).EQ.6)THEN
               CALL FDEXP(X,AP,YP,DP)
            ENDIF
            Y = Y + YP
         ENDIF
         DO 20 J=1,NPPAR
            K = K + 1
            IF(VTABLE(K).GT.0)THEN
               A(VTABLE(K)) = AP(J)
               DTMP = DP(J)*DFCONST(A(VTABLE(K)),
     &                FTABLE(K),X1CON(K),X2CON(K),X3CON(K))
               DYDA(VTABLE(K)) = DYDA(VTABLE(K)) + DTMP
               IF(FTABLE(K).GT.0.AND.FTABLE(K).LE.3)THEN
                  IF(LATCON.AND.VTABLE(KORIG).GT.0)THEN
                     DYDA(VTABLE(KORIG)) =  DYDA(VTABLE(KORIG)) - DTMP
                  ENDIF
               ENDIF
            ELSE
               DYDA(K) = 0.0D0
            ENDIF
 20      CONTINUE
 30   CONTINUE
C
C=======Calculate background
C
      IF(NBAK.GE.0)THEN
         DO 40 I=1,NBAK+1
            IF(VTABLE(K+I).GT.0)THEN
               IF(VTABLE(K+I).EQ.K+I)THEN
                  IF(LTABLE(K+I).EQ.1)THEN
                     IF(A(K+I).LT.X1LIM(K+I))A(K+I) = X1LIM(K+I)
                     IF(A(K+I).GT.X2LIM(K+I))A(K+I) = X2LIM(K+I)
                  ENDIF
               ENDIF
               AP(I) = FCONST(A(VTABLE(K+I)),FTABLE(K+I),X1CON(K+I),
     &                        X2CON(K+I),X3CON(K+I),XORIG)
               A(K+I) = AP(I)
            ELSE
               AP(I) = A(K+I)
            ENDIF
 40      CONTINUE
         CALL FPOLY(X,AP,YP,DP,NBAK)
         Y = Y + YP
         DO 50 I=1,NBAK+1
            IF(VTABLE(K+I).GT.0)THEN
               DTMP = DP(I)*DFCONST(A(VTABLE(K+I)),
     &                FTABLE(K+I),X1CON(K+I),X2CON(K+I),X3CON(K+I))
               DYDA(VTABLE(K+I)) = DYDA(VTABLE(K+I)) + DTMP
               IF(FTABLE(K+I).GT.0.AND.FTABLE(K+I).LE.3)THEN
                  IF(LATCON.AND.VTABLE(KORIG).GT.0)THEN
                     DYDA(VTABLE(KORIG)) =  DYDA(VTABLE(KORIG)) - DTMP
                  ENDIF
               ENDIF
            ELSE
               DYDA(K+I) = 0.0D0
            ENDIF
 50      CONTINUE
      ENDIF
      IF(FEXP.GT.0)THEN
         K = K + NBAK + 1
         DO 60 I=1,2
            IF(VTABLE(K+I).GT.0)THEN
               IF(VTABLE(K+I).EQ.K+I)THEN
                  IF(LTABLE(K+I).EQ.1)THEN
                     IF(A(K+I).LT.X1LIM(K+I))A(K+I) = X1LIM(K+I)
                     IF(A(K+I).GT.X2LIM(K+I))A(K+I) = X2LIM(K+I)
                  ENDIF
               ENDIF
               AP(I) = FCONST(A(VTABLE(K+I)),FTABLE(K+I),X1CON(K+I),
     &                        X2CON(K+I),X3CON(K+I),XORIG)
               A(K+I) = AP(I)
            ELSE
               AP(I) = A(K+I)
            ENDIF
 60      CONTINUE
         ARG = X*AP(2)
         EX = EXP(ARG)
         Y = Y + AP(1)*EX
         DP(1) = EX
         DP(2) = X*AP(1)*EX
         DO 70 I=1,2
            IF(VTABLE(K+I).GT.0)THEN
               DTMP = DP(I)*DFCONST(A(VTABLE(K+I)),
     &                FTABLE(K+I),X1CON(K+I),X2CON(K+I),X3CON(K+I))
               DYDA(VTABLE(K+I)) = DYDA(VTABLE(K+I)) + DTMP
               IF(FTABLE(K+I).GT.0.AND.FTABLE(K+I).LE.3)THEN
                  IF(LATCON.AND.VTABLE(KORIG).GT.0)THEN
                     DYDA(VTABLE(KORIG)) =  DYDA(VTABLE(KORIG)) - DTMP
                  ENDIF
               ENDIF
            ELSE
               DYDA(K+I) = 0.0D0
            ENDIF
 70      CONTINUE     
      ENDIF
C
      RETURN
      END

      DOUBLE PRECISION FUNCTION FCONST(X,NF,A1,A2,A3,XO)
      IMPLICIT NONE
      DOUBLE PRECISION X,A1,A2,A3,XO
      INTEGER NF
      IF(NF.EQ.0)THEN
         FCONST = X
         RETURN
      ELSEIF(NF.EQ.1)THEN
         FCONST = SQRT(A1*A1+A2*A2+A1*A2)*(X-XO) + XO
         RETURN
      ELSEIF(NF.EQ.2)THEN
         FCONST = SQRT(A1*A1+A2*A2)*(X-XO) + XO
         RETURN
      ELSEIF(NF.EQ.3)THEN
         FCONST = SQRT(A1*A1+A2*A2+A3*A3)*(X-XO) + XO
         RETURN
      ELSE
         WRITE(6,1000)NF
         FCONST=0.
         RETURN
      ENDIF
 1000 FORMAT(1X,'***Unrecognised contraint function',I4)
      END

      DOUBLE PRECISION FUNCTION DFCONST(X,NF,A1,A2,A3)
      IMPLICIT NONE
      DOUBLE PRECISION X,A1,A2,A3
      INTEGER NF
      IF(NF.EQ.0)THEN
         DFCONST = 1.0D0 
         RETURN
      ELSEIF(NF.EQ.1)THEN
         DFCONST = SQRT(A1*A1+A2*A2+A1*A2)
         RETURN
      ELSEIF(NF.EQ.2)THEN
         DFCONST = SQRT(A1*A1+A2*A2)
         RETURN
      ELSEIF(NF.EQ.3)THEN
         DFCONST = SQRT(A1*A1+A2*A2+A3*A3)
         RETURN
      ELSE
         WRITE(6,1000)NF
         DFCONST=0.
         RETURN
      ENDIF
 1000 FORMAT(1X,'***Unrecognised contraint function',I4)
      END


