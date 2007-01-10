C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GENFUN (ITERM,IPRINT,SP,NCHAN,IRC)
      IMPLICIT NONE
C
C Purpose: Generate a function
C
      REAL    SP(1)
      INTEGER ITERM,IPRINT,NCHAN,IRC
C
C SP     : Data array
C ITERM  : Terminal input stream
C IPRINT : Terminal output stream
C NCHAN  : Number of data points
C IRC    : Return code 0 - succesfull
C                      1 - <ctrl-Z> for VMS/<ctrl-D> for unix
C
C Calls   2: BESJ   , GETVAL
C Called by: FUNCT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      DOUBLE PRECISION ARG
      REAL    DD,ARG1,ARG2,ARG3,ARGINC,XMUL,BES,VALUE(10)
      REAL    PI,SIGMA,TEMP,XSQ,ZERO
      INTEGER JRC,IOPT,JOPT,NBES,NVAL,i
C
      DATA  PI/3.141592654/
C
C-----------------------------------------------------------------------
      ARG1=0.0
      ARG2=10.0
      ARG3=0.0
      DD=1.0E-4
10    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 999
      IF (IRC.EQ.2) GOTO 10
      IF (NVAL.EQ.0) THEN
         IOPT=1
      ELSE
         IOPT=INT(VALUE(1))
      ENDIF
C
      IF (IOPT.LT.3) THEN
         IF (IOPT.EQ.1) THEN
20          WRITE (IPRINT,1010)
            CALL GETVAL (ITERM,VALUE,NVAL,IRC)
            IF (IRC.EQ.1) GOTO 999
            IF (IRC.EQ.2) GOTO 20
            IF (NVAL.EQ.0) THEN
               JOPT=1
            ELSE
               JOPT=INT(VALUE(1))
            ENDIF
         ELSE
30          WRITE (IPRINT,1020)
            CALL GETVAL (ITERM,VALUE,NVAL,IRC)
            IF (IRC.EQ.1) GOTO 999
            IF (IRC.EQ.2) GOTO 30
            IF (NVAL.EQ.0) THEN
               NBES=0
            ELSE
               NBES=INT(VALUE(1))
            ENDIF
         ENDIF
35       WRITE (IPRINT,1030)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 35
         IF (NVAL.GT.2) ARG3=VALUE(3)
         IF (NVAL.GT.1) ARG2=VALUE(2)
         IF (NVAL.GT.0) ARG1=VALUE(1)
         IF (NVAL.EQ.0) ARG2=10.0
40       WRITE (IPRINT,1040)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 40
         IF (NVAL.EQ.0) THEN
            XMUL=1.0
         ELSE
            XMUL=VALUE(1)
         ENDIF
         IF (ARG3.NE.0.0) THEN
            ARG1=ARG1*ARG3*6.28319
            ARG2=ARG2*ARG3*6.28319
         ENDIF
         ARGINC=(ARG2-ARG1)/REAL(NCHAN-1)
         ARG=ARG1-ARGINC
         DO 50 I=1,NCHAN
            JRC=0
            ARG=ARG+ARGINC
            IF (IOPT.EQ.1) THEN
               IF (JOPT.EQ.1) THEN
                  SP(I)=DSIN(ARG)*XMUL
               ELSEIF (JOPT.EQ.2) THEN
                  SP(I)=DCOS(ARG)*XMUL
               ELSE
                  SP(I)=1.
                  IF (ARG.NE.0.0) SP(I)=(DSIN(ARG)/ARG)*XMUL
               ENDIF
            ELSE
               IF (ARG.GT.0.0) THEN
                  CALL BESJ (ARG,NBES,BES,DD,JRC)
                  IF (JRC.EQ.3) WRITE(IPRINT,1060) I
                  IF (JRC.EQ.4.AND.ARG.LE.15.) WRITE (IPRINT,1070) I
                  IF (JRC.EQ.4.AND.ARG.GT.15.) WRITE (IPRINT,1080) I
               ELSE
                  IF (ARG.LT.0.0) WRITE (IPRINT,1050) I
                  BES=0.
                  IF (NBES.EQ.0) BES=1.
               ENDIF
               SP(I)=BES*XMUL
            ENDIF
50       CONTINUE
      ELSEIF (IOPT.EQ.3) THEN
60       WRITE (IPRINT,1090)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 60
         IF (NVAL.GT.2) ARG3=VALUE(3)
         IF (NVAL.GT.1) ARG2=VALUE(2)
         IF (NVAL.GT.0) ARG1=VALUE(1)
         IF (NVAL.EQ.0) ARG2=10.0
70       WRITE (IPRINT,1100)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 70
         IF (NVAL.EQ.0) THEN
            XMUL=1.0
         ELSE
            XMUL=VALUE(1)
         ENDIF
         IF (ARG3.NE.0.0) THEN
            ARG1=ARG1*ARG3
            ARG2=ARG2*ARG3
         ENDIF
         ARGINC=(ARG2-ARG1)/REAL(NCHAN-1)
         ARG=ARG1-ARGINC
         DO 80 I=1,NCHAN
            ARG=ARG+ARGINC
            SP(I)=XMUL*DEXP(ARG)
80       CONTINUE
      ELSE
90       WRITE (IPRINT,1130)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 90
         IF (NVAL.EQ.0) THEN
            XMUL=1.0
         ELSE
            XMUL=VALUE(1)
         ENDIF
100      WRITE (IPRINT,1110)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 100
         IF (NVAL.EQ.0) GOTO 100
         SIGMA=VALUE(1)
110      WRITE (IPRINT,1120)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 110
 216     IF (NVAL.EQ.0) GOTO 110
         ZERO=VALUE(1)
         IF (ZERO.GT.REAL(NCHAN)) THEN
            CALL ERRMSG ('Error: Centre channel outside range')
            GOTO 110
         ENDIF
         TEMP=1.0/(SIGMA*SQRT(PI))    
         DO 120 I=1,NCHAN
            XSQ=(REAL(I)-ZERO)*(REAL(I)-ZERO)
            SP(I)=TEMP*EXP(-XSQ/(SIGMA*SIGMA))*XMUL
cx            SP(I)=TEMP*EXP(-XSQ/(2*SIGMA*SIGMA))*XMUL
120      CONTINUE
      ENDIF
      IRC=0
999   RETURN
C
1000  FORMAT (' Enter type of function'/, ' 1:Trigonometric'/
     1        ' 2:Bessel'/' 3:Exponential'/,' 4:Gaussian [1]: ',$)
1010  FORMAT (' Enter function '/,' 1:SIN(X)'/,' 2:COS(X)'/,
     1        ' 3:SIN(X)/X [1]: ',$)
1020  FORMAT (' Enter order of Bessel function [0]: ',$)
1030  FORMAT (' Enter value of X in first and last channel or '/,
     1        ' SMIN, SMAX and R for X=2*PI*S*R [0.,10.,0.]: ',$)
1040  FORMAT (' Enter amplitude [1.0]: ',$)
1050  FORMAT (' Negative argument set to 0. in channel ', I5)
1060  FORMAT (' Required accuracy (0.0001) not reached in channel ',I5)
1070  FORMAT (' Order of Bessel function must .LT. 20+10*X-X**2/3 ',I5) 
1080  FORMAT (' Order of Bessel function must be .LT. 90+X/2 ',I5)
1090  FORMAT (' Enter value of X in first and last channel or'/,
     1        ' XMIN, XMAX and U to compute EXP(UX) [0.,10.,0.]: ',$)
1100  FORMAT (' Enter pre-exponential factor [1.0]: ',$)
1110  FORMAT (' Enter sigma (halfwidth): ',$)
1120  FORMAT (' Enter channel for centre of gaussian: ',$)
1130  FORMAT (' Enter integrated intensity [1.0]: ',$)
      END
