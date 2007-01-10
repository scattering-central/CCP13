C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FJOIN
      IMPLICIT NONE
C
C Purpose: Combine a series of time frames into a single sequence
C
      INCLUDE 'COMMON.FOR'
C
C Calls   9: APLOT  , DAWRT  , ERRMSG , GETCHN , GETHDR , OPNFIL , 
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME,NSAVE,IMEM
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,I,J,K
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,SFNAM
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
C CONST  : Weighting factor
C SAME   : Same weighting factors to be used
C RZERO  : Zero data outside selected range
C NVAL   : Nos. of values entered at terminal
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
      ICLO=0
      JOP=0
      KREC=0
C
10    CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 55
      IFRAME=IHFMAX+IFRMAX-1
      IF (KREC.EQ.0) THEN
         NSAVE=NCHAN
         CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
         IF (IRC.NE.0) GOTO 999
         SFNAM=OFNAM
      ELSEIF (NCHAN.NE.NSAVE) THEN
         CALL ERRMSG ('Error: Incompatible nos. of channels')
         GOTO 55
      ENDIF
C
      DO 50 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 40 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP1,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 60
40          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
50    CONTINUE
      GOTO 10
C
C========CLOSE OUTPUT FILE AND REWRITE HEADER FILE
C
55    IF (KREC.GT.0) THEN
         CLOSE (UNIT=KUNIT,STATUS='KEEP')
         CALL HDRGEN (NCHAN,KREC,1,SFNAM,MEM,KUNIT,HEAD1,HEAD2,IRC)
         IF (IRC.NE.0) GOTO 999
      ENDIF
60    CLOSE (UNIT=JUNIT)
C
999   RETURN
      END
