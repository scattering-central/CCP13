C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE PRTVAL
      IMPLICIT NONE
C
C Purpose: Print values of data on lineprinter or terminal.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   3: GETCHN , GETHDR , OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10)
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,IDEV,ICH1,ICH2,NCHAN,NFRAME
      INTEGER      ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,K,I,J,NVAL
      CHARACTER*13 HFNAM
C
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C ISPEC  : First header file of sequence
C LSPEC  : Last header file in sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C IDEV   : Output device
C ICH1   : First channel of interest
C ICH2   : Last channel of interest
C
C-----------------------------------------------------------------------
C
10    CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
20    IDEV=0
      WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GE.1) IDEV=INT(VALUE(1))
      IF (IDEV.LT.0.OR.IDEV.GT.1) THEN
         CALL ERRMSG ('Error: Invalid device specified')
         GOTO 20
      ENDIF
      CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
      IF (IRC.NE.0) GOTO 10
      IF (IDEV.EQ.1) OPEN (UNIT=KUNIT,FILE='LP:',STATUS='NEW')
      DO 40 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 30 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IF (IDEV.EQ.0) THEN
                  WRITE (IPRINT,1010) HFNAM,IFFR,ICH1,ICH2
                  WRITE (IPRINT,1020) (K,SP1(K),K=ICH1,ICH2)
               ELSE
                  WRITE (KUNIT,1010) HFNAM,IFFR,ICH1,ICH2
                  WRITE (KUNIT,1020) (K,SP1(K),K=ICH1,ICH2)
               ENDIF
               IFFR=IFFR+IFINC
30          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
40    CONTINUE
      CLOSE (UNIT=KUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Print output on [0] TT:, [1] LP:  [0]: ',$)
1010  FORMAT (' Header file: ',A,' Frame: ',I3,/,
     1        ' First and last channel ',2I5)
1020  FORMAT (4(' ',I4,G13.5))
      END
