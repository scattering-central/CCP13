C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GENFRM
      IMPLICIT NONE
C
C Purpose: Generate a frame of data
C
      INCLUDE 'COMMON.FOR'
C
C Calls   3: APLOT , DAWRT  , ERRMSG , GETVAL 
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10)
      INTEGER NCHAN,IMEM,IFRAME,KREC,JOP,ICLO,IRC,NVAL
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 OFNAM
      CHARACTER EOFCHAR
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C KREC   : Output file record
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C VALUE  : Values entered at the terminal
C NVAL   : Nos. of values entered at terminal
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C
      DATA KREC/1/ , IFRAME/1/ , IMEM/1/
C
C-----------------------------------------------------------------------
      JOP=0
      ICLO=1
      NCHAN=1
10    WRITE (IPRINT,1000) NCHAN,EOFCHAR ()
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 20
      IF (IRC.EQ.2) GOTO 10
      IF (NVAL.EQ.0) THEN
         CALL ERRMSG ('Error: No value entered')
      ELSE
         SP2(NCHAN)=VALUE(1)
         NCHAN=NCHAN+1
      ENDIF
      GOTO 10
C
20    NCHAN=NCHAN-1
      CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
      CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
      IF (IRC.EQ.0) THEN
         CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1               SP2,KREC,JOP,ICLO,IRC)
      ENDIF
      RETURN
C
1000  FORMAT (' Enter value',I4,' or <ctrl-',a1,'>: ',$)
      END
