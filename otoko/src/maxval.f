C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE MAXVAL (XAXIS)
      IMPLICIT NONE
C
C Purpose: Calculates maximum value of spectrum.
C
      LOGICAL XAXIS
C
C XAXIS  : Set true if user defined x-axis to be used.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   7: APLOT  , DAWRT  , GETCHN , GETHDR , MINMAX , OPNFIL
C            GETXAX
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    XMAX,XMIN
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,MFRAME,NPOINT
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,JCH1,JCH2
      INTEGER NFRAME,NCHAN,IMIN,IMAX,I,J,K,NCHANX
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
C JCH1   : First channel of interest
C JCH2   : Last channel of interest
C NPOINT : Nos. of channels to write
C MFRAME : Nos. of frames to write
C XMIN   : Minimum value
C XMAX   : Maximum value
C IMIN   : Channel containing xmin
C IMAX   : Channel containing xmax
C
      DATA  IMEM/1/ , KREC/1/ , MFRAME/2/
C
C-----------------------------------------------------------------------
C
      IF (XAXIS) THEN
         WRITE (IPRINT,*) 'X-axis'
         CALL GETXAX (NCHANX,IRC)
         IF (IRC.NE.0) GOTO 999
      ENDIF
C
10    NPOINT=0
      JOP=0
      ICLO=0
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IFRAME=IHFMAX+IFRMAX-1
      CALL GETCHN (ITERM,IPRINT,NCHAN,JCH1,JCH2,IRC)
      IF (IRC.NE.0) GOTO 10
C
      DO 30 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 20 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               NPOINT=NPOINT+1
               CALL MINMAX (SP1,NCHAN,JCH1,JCH2,IMIN,IMAX,XMIN,XMAX)
               SP3(NPOINT) = XMAX
               IF (XAXIS) THEN
                  SP2(NPOINT) = XAX(IMAX)
               ELSE
                  SP2(NPOINT)=REAL(IMAX)
               ENDIF
20          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
30    CONTINUE
      IF (IFRAME.EQ.1) THEN
         IF (XAXIS) THEN
            WRITE(IPRINT,1000) XMAX,SP2(1)
         ELSE
            WRITE(IPRINT,1010) XMAX,IMAX
         ENDIF
      ELSE
         CALL APLOT (ITERM,IPRINT,SP2,NPOINT)
         CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
         IF (IRC.EQ.0) THEN
            CALL DAWRT (KUNIT,OFNAM,IMEM,NPOINT,MFRAME,HEAD1,HEAD2,
     1                  SP2,1,JOP,ICLO,IRC)
            IF (IRC.EQ.0) THEN
               ICLO=1
               CALL DAWRT (KUNIT,OFNAM,IMEM,NPOINT,MFRAME,HEAD1,HEAD2,
     1                  SP3,2,JOP,ICLO,IRC)
            ELSE
               CLOSE (KUNIT)
            ENDIF
         ENDIF
      ENDIF
      GOTO 10
999   RETURN
C
1000  FORMAT (' Maximum value : ',G13.5,' at channel : ',G13.5)
1010  FORMAT (' Maximum value : ',G13.5,' at channel : ',I4)
      END
