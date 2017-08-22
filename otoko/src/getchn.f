C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
      IMPLICIT NONE
C
C Purpose: Get region of interest in spectrum.
C
      INTEGER ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC
C
C ITERM  : Terminal input stream
C IPRINT : Terminal output stream
C NCHAN  : Nos. of channels
C ICH1   : First channel of interest
C ICH2   : Last channel of interest
C IRC    : Return code 0 - successful
C                      1 - <ctrl-z>
C
C Calls   2: ERRMSG , GETVAL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10)
      INTEGER NVAL
C
C VALUE  : Numeric values entered at terminal
C NVAL   : Nos. of numeric values entered
c
C-----------------------------------------------------------------------
      ICH1=1
      ICH2=NCHAN
10    WRITE (IPRINT,1000) NCHAN
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) THEN
         IRC=1
      ELSEIF (IRC.EQ.2) THEN
         GOTO 10
      ELSE
         IF (NVAL.GE.1) ICH1=INT(VALUE(1))
         IF (NVAL.GE.2) ICH2=INT(VALUE(2))
         IF (ICH2.LT.ICH1) THEN
            CALL ERRMSG ('Error: Invalid channel range')
            GOTO 10
         ENDIF
         IF (ICH1.LT.0.OR.ICH2.LT.0) THEN
            CALL ERRMSG ('Error: Invalid channel range')
            GOTO 10
         ENDIF
         IRC=0
      ENDIF
      RETURN
C
1000  FORMAT (' Enter first and last channels of output [1,'
     1        ,I4,']: ',$)
      END
