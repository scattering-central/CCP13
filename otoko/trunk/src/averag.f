C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE AVERAG
      IMPLICIT NONE
C
C Purpose: Calculate the average of a multiple set of data files for
C          all channels. Data set input sequence is terminated by
C          <ctrl-Z>.( <ctrl-D> if unix ).
C
      INCLUDE 'COMMON.FOR'
C
C Calls   5: APLOT  , DAWRT , FILL   , GETHDR , OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,ICOUNT,NCHAN
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NFRAME
      INTEGER I,J,K,MFRAME
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
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
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C ICOUNT : Number of frames to be averaged
C
      DATA  IMEM/1/ , KREC/1/ , ICLO/1/ , MFRAME/1/
C
C-----------------------------------------------------------------------
10    JOP=0
      ICOUNT=0      
C
20    CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.EQ.0) THEN
C
         IFRAME=IHFMAX+IFRMAX-1
         IF (ICOUNT.EQ.0) CALL FILL (SP2,NCHAN,0.0)
         DO 50 I=1,IHFMAX
C
            CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,
     1                   NFRAME,IRC)
            IF (IRC.EQ.0) THEN
C
               ISPEC=ISPEC+INCR
               DO 40 J=1,IFRMAX
                  READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
                  IFFR=IFFR+IFINC
                  DO 30 K=1,NCHAN
                     SP2(K)=SP2(K)+SP1(K)
30                CONTINUE
                  ICOUNT=ICOUNT+1
40             CONTINUE
               CLOSE (UNIT=JUNIT)
            ENDIF
50       CONTINUE
      ELSE
         IF (ICOUNT.NE.0) THEN
            DO 60 I=1,NCHAN
               SP2(I)=SP2(I)/REAL(ICOUNT)
60          CONTINUE
            CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
            CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF (IRC.EQ.0) THEN
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,MFRAME,HEAD1,HEAD2,
     1                     SP2,KREC,JOP,ICLO,IRC)
            ENDIF
            GOTO 10
         ELSE
            RETURN
         ENDIF
      ENDIF
      GOTO 20
      END
