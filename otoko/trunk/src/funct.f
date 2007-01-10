C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FUNCT
      IMPLICIT NONE
C
C Purpose: Generate a function
C
      INCLUDE 'COMMON.FOR'
C
C Calls   3: APLOT  , DAWRT  , GETCHN , GETFUN
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER ICLO,JOP,IRC,IFRAME,KREC,IMEM,NCHAN,ICH1,ICH2
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 OFNAM
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C KREC   : Output file record
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C
      DATA IMEM/1/ , ICLO/1/ , IFRAME/1/ , KREC/1/
C
C-----------------------------------------------------------------------
10    JOP=0
      NCHAN=256
      CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
      IF (IRC.EQ.0) THEN
         NCHAN=ICH2-ICH1+1
         CALL GENFUN (ITERM,IPRINT,SP2,NCHAN,IRC)
         IF (IRC.EQ.0) THEN
            CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
            CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF (IRC.EQ.0) THEN
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP2,KREC,JOP,ICLO,IRC)
            ENDIF
         ENDIF
         GOTO 10
      ENDIF
      RETURN
      END
