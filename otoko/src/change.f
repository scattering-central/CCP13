C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE CHANGE
      IMPLICIT NONE
C
C Purpose: Modify selected channels of a spectrum.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   4: ERRMSG , GETHDR , GETVAL , OPNFIL 
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUES(10)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NFRAME,NCHAN,I,J,K
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,ICHAN
      CHARACTER*13 HFNAM,FNAM
      CHARACTER EOFCHAR
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C KREC   : Output file record
C ISPEC  : First header file of sequence
C LSPEC  : Last header file in sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C VALUES : Numeric values entered at terminal
C NVAL   : Nos. of values entered
C ICHAN  : Channel selected
C FNAM   : Current file being changed
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      KREC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      DO 20 I=1,LEN(HFNAM)
         FNAM(I:I)=HFNAM(I:I)
20    CONTINUE
      IFRAME=IHFMAX+IFRMAX-1
      DO 50 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 40 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
C
               WRITE (FNAM(4:4),'(I1)') IFFR/100
               WRITE (FNAM(5:5),'(I1)') MOD(IFFR,100)/100
               WRITE (FNAM(6:6),'(I1)') MOD(IFFR,10)
               WRITE (IPRINT,1000) FNAM
               KREC=KREC+1
C
30             WRITE (IPRINT,1010) EOFCHAR ()
               CALL GETVAL (ITERM,VALUES,NVAL,IRC)
               IF (IRC.EQ.1) THEN
                  WRITE (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               ELSEIF (IRC.EQ.2) THEN
                  GOTO 30
               ELSEIF (NVAL.LT.2) THEN
                  CALL ERRMSG ('Error: Two values required')
                  GOTO 30
               ELSE
                  ICHAN=INT (VALUES(1))
                  SP1(ICHAN)=VALUES(2)
                  GOTO 30
               ENDIF                   
               IFFR=IFFR+IFINC
40          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
50    CONTINUE
      GOTO 10
C
1000  FORMAT (' Editing file: ',A)
1010  FORMAT (' Enter channel and value or <ctrl-',a1,'>: ',$)
999   RETURN
      END
