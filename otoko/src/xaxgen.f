C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE XAXGEN
      IMPLICIT NONE
C
C Purpose: Generate an x-axis
C
      INCLUDE 'COMMON.FOR'
C
C Calls   5: APLOT  , DAWRT  , ERRMSG , GETCHN , GETVAL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),RMIN,RMAX,XMIN
      INTEGER NCHAN,JCH1,JCH2,IMEM,IFRAME,KREC,JOP,ICLO,IRC,NVAL,I
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 OFNAM
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C KREC   : Output file record
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C JCH1   : First channel of xaxis
C JCH2   : Last channel of xaxis
C VALUE  : Numeric values entered at terminal
C NVAL   : Nos. of values entered
C RMIN   :
C RMAX   :
C XMIN   :
C
      DATA ICLO/1/ , KREC/1/ , IFRAME/1/ , IMEM/1/
C
C-----------------------------------------------------------------------
      JOP=0
      NCHAN=256
      CALL GETCHN (ITERM,IPRINT,NCHAN,JCH1,JCH2,IRC)
      IF (IRC.EQ.0) THEN
         NCHAN=JCH2-JCH1+1
10       WRITE (IPRINT,1000)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 10
         IF (NVAL.LT.2) THEN
            CALL ERRMSG ('Error: Two values required')
            GOTO 10
         ELSE
            JCH1=INT(VALUE(1))
            RMIN=VALUE(2)
         ENDIF
C
20       WRITE (IPRINT,1000)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 999
         IF (IRC.EQ.2) GOTO 20
         IF (NVAL.LT.2) THEN
            CALL ERRMSG ('Error: Two values required')
            GOTO 20
         ELSE
            JCH2=INT(VALUE(1))
            RMAX=VALUE(2)
         ENDIF
C
         IF (JCH1.EQ.0) JCH1=1
         IF (JCH2.EQ.0) JCH2=NCHAN
         XMIN=(RMAX-RMIN)/INT((JCH2-JCH1))
         SP2(1)=RMIN-(JCH1-1)*XMIN
         DO 30 I=2,NCHAN
            SP2(I)=SP2(1)+XMIN*REAL(I-1)
30       CONTINUE
C
         CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
         CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
         IF (IRC.EQ.0) THEN
            CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                  SP2,KREC,JOP,ICLO,IRC)
         ENDIF
      ENDIF
999   RETURN
C
1000  FORMAT (' Enter channel & value: ',$)
      END
