C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE OT3PLO (SP1,SPW,NPTS,KREC,IOPT,ILIN,NM,IFRAME,DELY,
     1                   FMIN)
      IMPLICIT NONE
C
C PURPOSE:
C
      REAL    SP1(1),SPW(1),DELY,FMIN
      INTEGER NPTS,KREC,IOPT,ILIN,NM,IFRAME
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL    TEMP,X,Y,XX,YY,XXX,YYY,XO,YO,HHA,HHB,HHLA,DEL
      INTEGER ISW,JSW,KSW,I,J
C
C-----------------------------------------------------------------------
      IF (IOPT.EQ.0) THEN
         DO 10 I=1,NPTS/2
            J=NPTS-I+1
            TEMP=SP1(I)
            SP1(I)=SP1(J)
            SP1(J)=TEMP
10       CONTINUE
      ENDIF
      DO 20 J=1,NPTS-NM+1
         SPW(J)=SPW(J+NM-1)
20    CONTINUE
      XX=REAL((IFRAME-(IFRAME-KREC+1))*(NM-1))
      YY=REAL(KREC-1)*DELY
      XO=XX
      YO=YY
      KSW=0
      ISW=0
      HHB=SPW(1)
      CALL POSITN(XO,YO)
      IF (KREC.EQ.1) THEN
         X=XO+REAL(NPTS-1)
         Y=YO
         CALL JOIN(X,Y)
      ELSE
         DO 40 J=1,NPTS
            Y=YO
            X=XO+REAL(J-1)
            JSW=0
            IF (Y.GE.SPW(J)) JSW=1
            IF (JSW+ISW.NE.0) THEN
               IF (JSW.EQ.0.AND.ISW.GT.0) THEN
                  CALL CROSS(YY,Y,HHB,SPW(J),YYY,DEL)
                  XXX=X-1+DEL
                  CALL JOIN(XXX,YYY)
               ELSEIF (JSW.GT.0.AND.ISW.EQ.0) THEN
                  CALL CROSS(YY,Y,HHB,SPW(J),YYY,DEL)
                  XXX=X-1+DEL
                  CALL POSITN(XXX,YYY)
                  CALL JOIN(X,Y)
               ELSE
                  CALL JOIN(X,Y)
               ENDIF
            ENDIF
            ISW=JSW
            XX=X
            YY=Y
            HHB=SPW(J)
40       CONTINUE
      ENDIF
      XX=XO
      YY=YO
      ISW=0
      HHLA=SPW(NPTS)
      HHB=SPW(1)
      CALL POSITN(XO,YO)
      DO 50 J=1,NPTS
         X=XO+REAL(J-1)
         Y=SP1(J)+YO-FMIN
         HHA=SPW(J)
         JSW=0
         IF (Y.GE.SPW(J)) JSW=1
         IF (JSW+ISW.NE.0) THEN
            IF (JSW.EQ.0.AND.ISW.GT.0) THEN
                CALL CROSS(YY,Y,HHB,SPW(J),YYY,DEL)
                XXX=X-1+DEL
                CALL JOIN(XXX,YYY)
            ELSEIF (JSW.GT.0.AND.ISW.EQ.0) THEN
               CALL CROSS(YY,Y,HHB,SPW(J),YYY,DEL)
               XXX=X-1+DEL
               CALL POSITN(XXX,YYY)
               SPW(J)=Y
               CALL JOIN(X,Y)
            ELSE
               SPW(J)=Y
               CALL JOIN(X,Y)
            ENDIF
         ENDIF
         ISW=JSW
         XX=X
         YY=Y
         HHB=HHA
50    CONTINUE
      IF (Y.GT.HHLA.AND.HHLA.GT.YO) THEN
         CALL POSITN (X,Y)
         CALL JOIN (X,HHLA)
      ENDIF
      RETURN
      END
