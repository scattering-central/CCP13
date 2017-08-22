C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FRDATA (ITERM,IPRINT,IFFR,ILFR,IFINC,NCHAN,NFRAME,
     1                   MEM,IRC)
      IMPLICIT NONE
C
C Purpose: Prompt for first , last frame & increment and set default
C          values.
C
      INTEGER ITERM,IPRINT,IFFR,ILFR,IFINC,NCHAN,NFRAME,MEM,IRC
c
C ITERM  : Terminal input
C IPRINT : Terminal output
C IFFR   : First frame
C ILFR   : Last frame
C IFINC  : Frame increment
C NCHAN	 : Nos. of channels
C NFRAME : Nos. of frames
C MEM    : Memory number
C IRC    : Return code 0 - no errors
C                      1 - <ctrl-Z> for VMS/<ctrl-d> for unix
C
C Calls   1: ERRMSG , GETVAL
C Called by: GETHDR
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C LOCAL VARIABLES:
C
      REAL    VALUE(10)
      INTEGER NVAL
      CHARACTER EOFCHAR
C
C VALUE  : TERMINAL INPUT
C NVAL   : NOS. OF VALUES ENTERED
C
C-----------------------------------------------------------------------
      IRC=1
      IFFR=0
      ILFR=0
      IFINC=0
      IF (NFRAME.NE.1) THEN
10       WRITE (IPRINT,1000) NFRAME
20       WRITE (IPRINT,1010) EOFCHAR ()
         CALL FLUSH (IPRINT)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 20
         IF (NVAL.GE.1) IFFR=INT(VALUE(1))
         IF (NVAL.GE.2) ILFR=INT(VALUE(2))
         IF (NVAL.GE.3) IFINC=INT(VALUE(3))
         IF (ILFR.GT.NFRAME) THEN
            CALL ERRMSG ('Error: Last frame too large')
            GOTO 10
         ENDIF
      ENDIF
      IF (IFFR.EQ.0) IFFR=1
      IF (ILFR.EQ.0) ILFR=IFFR
      IF (IFINC.EQ.0) IFINC=1
      IF (ILFR.LT.IFFR.AND.IFINC.GT.0) IFINC=-IFINC
      IF (ILFR.EQ.IFFR) IFINC=0
      WRITE (IPRINT,1020) MEM,IFFR,ILFR,IFINC
      CALL FLUSH (IPRINT)
      IRC=0
999   RETURN
C
1000  FORMAT (' Total number of frames: ',I5)
1010  FORMAT (' Enter first and last frame, increment or <ctrl-',
     &         a1,'>: ',$)
1020  FORMAT (' Memory ',I5,'  first and last frame',2I5,'  incr ',I5)
      END
