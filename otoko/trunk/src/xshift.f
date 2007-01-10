C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE XSHIFT
      IMPLICIT NONE
C
C PURPOSE: SHIFT AN SPECTRUM IN Y DIRECTION.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   9: APLOT  , DAWRT  , ERRMSG , FILL , GETVAL , GETHDR , OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER IMEM,IFIRST,ILAST,ISHIFT,I,J,K,L
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
      IF (NVAL.LT.2) GOTO 20
      IFIRST=INT(VALUE(1))
      ILAST=INT(VALUE(2))
30    WRITE (IPRINT,1010) 
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 30
      IF (NVAL.EQ.0) GOTO 30
      ISHIFT=INT(VALUE(1))
      IF (ISHIFT.EQ.0) GOTO 10
C
      DO 110 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 100 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
               CALL FILL (SP2,NCHAN,0.0)
C
C========RIGHT SHIFT
C
               IF (ISHIFT.GT.0) THEN
                  DO 40 L=1,IFIRST-1
                     SP2(L)=SP1(L)
40                CONTINUE
                  DO 50 L=IFIRST+ISHIFT,ILAST
                     SP2(L)=SP1(L-ISHIFT)
50                CONTINUE
                  DO 60 L=ILAST+1,NCHAN
                     SP2(L)=SP1(L)
60                CONTINUE
C
C========LEFT SHIFT
C
               ELSE
                  DO 70 L=NCHAN,ILAST+1,-1
                     SP2(L)=SP1(L)
70                CONTINUE
                  DO 80 L=ILAST+ISHIFT,IFIRST,-1
                     SP2(L)=SP1(L-ISHIFT)
80                CONTINUE
                  DO 90 L=IFIRST-1,1,-1
                     SP2(L)=SP1(L)
90                CONTINUE
               ENDIF
C
               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
               IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 120
               ENDIF
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP2,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 120
100         CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
110   CONTINUE
120   CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter first & last channels to shift: ',$)
1010  FORMAT (' Enter shift +ve for right -ve for left: ',$)
      END
