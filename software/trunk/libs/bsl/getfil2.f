C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GETFIL (ITERM,IPRINT,FNAM2,MEM,ISPEC,LSPEC,INCR,IFFR,
     &                   ILFR,IFINC,IRC)
      IMPLICIT NONE
C	
C Purpose: Reads and decodes filenames entered at terminal.
C
      INTEGER ITERM,IPRINT,IRC,ISPEC,LSPEC,INCR,IFFR,ILFR,IFINC,MEM
      INTEGER IPOS
      CHARACTER*13 FNAM
      CHARACTER*80 PATH
      CHARACTER*(*) FNAM2
C
C ITERM  : Terminal input stream
C IPRINT : Terminal output stream
C FNAM   : 13 character header filename
C MEM    : Memory number 
C IRC    : 0 - no errors detected
C          1 - end of file (CTRL-Z) for VMS/<ctrl_D> for unix read
C ISPEC  : Numeric part of first header filename
C LSPEC  : Numeric part of last header filename
C INCR   : Header filename increment
C IFFR   : First frame in file
C ILFR   : Last frame in file
C IFINC  : Frame increment
C
C Calls   1: ERRMSG , GETVAL
C Called by: GETHDR
C
C+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
C LOCAL VARIABLES:
C
      REAL    VALUE(10)
      INTEGER NVAL,JCHAR,I
      CHARACTER EOFCHAR
      LOGICAL IGETS
C
C VALUE  : TERMINAL INPUT
C NVAL   : NOS. OF VALUES ENTERED
C
C-----------------------------------------------------------------------
      IRC=0
      LSPEC=0
      ILFR=0
      INCR=1
 10   IF(IPRINT.EQ.0)THEN
         WRITE (*,1000) EOFCHAR ()
         CALL FLUSH(IPRINT)
      ELSE
         WRITE (IPRINT,1000) EOFCHAR ()
         CALL FLUSH(IPRINT)
      ENDIF
      IF (.NOT.IGETS (ITERM,FNAM2,80)) GOTO 999
      CALL STRIPPATH(FNAM2,FNAM,PATH,IPOS)
      JCHAR=INDEX(FNAM,' ')-1
      CALL UPCASE (FNAM,FNAM)
      IF (FNAM(1:2).EQ.'^D') GOTO 999
C
C========CHECK FOR CORRECTLY SPECIFIED FILENAME 
C     
      IF (FNAM(1:1).NE.'.'.AND.FNAM(1:1).NE.'*'.AND.JCHAR.GE.10) THEN
         IF (JCHAR.EQ.10) THEN
            IF (FNAM(10:10).EQ.'/') THEN
               GOTO 20
            ENDIF 
         ENDIF
C
C========DECODE RUNNUMBER AND FRAME NUMBER
C
         READ (FNAM(2:3),'(I2)',ERR=20) ISPEC
         READ (FNAM(4:6),'(I3)',ERR=20) IFFR
         ISPEC=ISPEC*1000
         IF (JCHAR.GT.10) THEN
            IF (FNAM(11:11).EQ.'/'.OR.FNAM(JCHAR:JCHAR).EQ.'/') THEN
               IF (FNAM(11:11).EQ.'/') FNAM(11:11)=' '
               IF (FNAM(JCHAR:JCHAR).EQ.'/') FNAM(JCHAR:JCHAR)=' '
 15            IF(IPRINT.EQ.0)THEN
                  WRITE (*,1010) EOFCHAR ()
                  CALL FLUSH(IPRINT)
               ELSE
                  WRITE (IPRINT,1010) EOFCHAR ()
                  CALL FLUSH(IPRINT)
               ENDIF
               CALL GETVAL (ITERM,VALUE,NVAL,IRC)
               IF (IRC.EQ.1) GOTO 999
               IF (IRC.EQ.2) GOTO 15
               IF (NVAL.GE.1) LSPEC=INT(VALUE(1))
               IF (NVAL.GE.2) INCR=INT(VALUE(2))
               INCR=IABS(INCR)
               ILFR=LSPEC-(LSPEC/1000)*1000
               LSPEC=(LSPEC/1000)*1000
               IFINC=INCR-(INCR/1000)
               IF(INCR.EQ.0) INCR=1000
               IF(IFINC.EQ.0) IFINC=1
            ELSEIF (FNAM(11:11).NE.';') THEN
               GOTO 20
            ENDIF
         ENDIF
      ELSE
         GOTO 20
      ENDIF
C
C========CHECK VALUES FOR VALIDITY
C
      IF (LSPEC.EQ.0) LSPEC=ISPEC
      IF (ILFR.EQ.0) ILFR=IFFR
      IF (ILFR.LT.IFFR.AND.IFINC.GT.0) THEN
            IFINC=-IFINC
      ELSEIF (IFFR.EQ.ILFR) THEN
         IFINC=0
      ENDIF
      IF (LSPEC.LT.ISPEC.AND.INCR.GT.0) THEN
            INCR=-INCR
      ELSEIF (LSPEC.EQ.ISPEC) THEN
         INCR=0
      ENDIF
      IF (IFFR.EQ.0) THEN
50       MEM=1
         IF(IPRINT.EQ.0)THEN
            WRITE(*,1040)
            CALL FLUSH(IPRINT)
         ELSE
            WRITE (IPRINT,1040)
            CALL FLUSH(IPRINT)
         ENDIF
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 50
         IF (NVAL.GE.1) MEM=INT(VALUE(1))
C
C========MAKE SURE ITS THE HEADER FILENAME RETURNED
C
      ELSE
         DO 60 I=4,6
            FNAM(I:I)='0'
60       CONTINUE
         MEM=1
      ENDIF

      IF(IPOS.GT.0)THEN
        FNAM2=path(1:ipos)//fnam(1:13)
      ELSE
        FNAM2=FNAM
      ENDIF

      RETURN
C
20    CALL ERRMSG ('Error: Invalid filename')
      CALL FLUSH(IPRINT)
      GOTO 10
C
C========TRAP <CTRL-D>
C
999   IRC=1
      RETURN
1000  FORMAT (' Enter filename (X99999.xxx[/]) or <ctrl-',a1,'>: ',$)
1010  FORMAT (' Enter last file number, increment or <ctrl-',a1,'>: ',$)
1040  FORMAT (' Enter [1] positional, [2] calibration data or',
     &        ' aux [3]  [1]: ',$)
      END
