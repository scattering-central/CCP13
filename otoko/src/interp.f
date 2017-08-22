C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE INTERP
      IMPLICIT NONE
C
C Purpose: INTERPOLATE FOR DATA POINTS.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   9: APLOT  , DAWRT  , ERRMSG , GETVAL , GETHDR , OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL         VALUE(10),XTOT,XINC,GRAD
      INTEGER      ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME
      INTEGER      KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER      IMEM,NPNTS,INDEX,I,J,K
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
C NVAL   : Nos. of values entered at terminal
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
      IFRAME=IHFMAX+IFRMAX-1
C
20    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.EQ.0) THEN
         NPNTS=512
      ELSE
         NPNTS=INT(VALUE(1))             
      ENDIF
      IF (NPNTS.GT.5120) THEN
         CALL ERRMSG ('Error: Invalid number of points')
         GOTO 20
      ENDIF
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
C
               XTOT=1.0
               XINC=REAL(NCHAN-1)/REAL(NPNTS-1)
               SP2(1)=SP1(1)
               SP2(NPNTS)=SP1(NCHAN)
               DO 30 K=2,NPNTS-1
                  XTOT=XTOT+XINC
                  INDEX=IFIX(XTOT)
                  GRAD=SP1(INDEX+1)-SP1(INDEX)
                  SP2(K)=GRAD*(XTOT-REAL(INDEX))+SP1(INDEX)
30             CONTINUE            

               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP2,NPNTS)
               IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 60
               ENDIF
               CALL DAWRT (KUNIT,OFNAM,IMEM,NPNTS,IFRAME,HEAD1,HEAD2,
     1                     SP2,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 60
40          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
50    CONTINUE
60    CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' How many points [512]: ',$)
      END
