C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ADD
      IMPLICIT NONE
C
C PURPOSE: WEIGHTED ADDITION OF TWO IMAGES, POINT PER POINT.
C          (VECTOR SUM)
C
      INCLUDE 'COMMON.FOR'
C
C Calls  10: ASKYES , ASKNO  , WFRAME , GETHDR , GETVAL
C            IMDISP , RFRAME , OPNNEW , OPNFIL , OUTFIL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    WEIGHT(10)
      INTEGER NPIX1,NPIX2,NRAST1,NRAST2,NFRAM1,NFRAM2
      INTEGER NPIX,NRAST,IRC,IMEM,KPIC,IFRAME
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER IHFMX1,IFRMX1,IHFMX2,IFRMX2,NVAL,I,K
      LOGICAL SAME,ASKYES,ZEROOP,ASKNO
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM1,HFNAM2,OFNAM
C
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMX1 : Nos. of frames in sequence
C IHFMX1 : Nos. of header file in sequence
C ISPEC1 : First header file in sequence
C LSPEC1 : Last header file in sequence
C MEM1   : Positional or calibration data indicator
C IFFR1  : First frame in sequence
C ILFR1  : Last frame in sequence
C INCR1  : Header file increment
C IFINC1 : Frame increment
C HFNAM1 : Header filename
C IFRMX2 : Nos. of frames in sequence
C IHFMX2 : Nos. of header file in sequence
C ISPEC2 : First header file in sequence
C LSPEC2 : Last header file in sequence
C MEM2   : Positional or calibration data indicator
C IFFR2  : First frame in sequence
C ILFR2  : Last frame in sequence
C INCR2  : Header file increment
C IFINC2 : Frame increment
C HFNAM2 : Header filename
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NFRAME : Nos of time frames
C SAME   : Same weighting factors to be used
C WEIGHT : Weighting factors
C NVAL   : Nos. of numeric values entered
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    KPIC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     &             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NPIX1,NRAST1,IRC)
      IF (IRC.NE.0) GOTO 999
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,INCR2,MEM2,
     &             IFFR2,ILFR2,IFINC2,IHFMX2,IFRMX2,NPIX2,NRAST2,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IF (NPIX2.LT.NPIX1) THEN
         NPIX=NPIX2
         NRAST=NRAST2
      ELSE
         NPIX=NPIX1
         NRAST=NRAST1
      ENDIF
      IF (IHFMX1.LT.IHFMX2) IHFMX1=IHFMX2
      IF (IFRMX1.LT.IFRMX2) IFRMX1=IFRMX2
      IFRAME=IHFMX1+IFRMX1-1
C
      WRITE (IPRINT,1000)
      SAME=ASKYES (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
C
      WRITE (IPRINT,1010)
      ZEROOP=ASKNO(ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
C
      DO 40 I=1,IFRAME
         IF (I.EQ.1.OR.INCR1.NE.0) THEN
            CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NPIX1,
     &                   NRAST1,NFRAM1,IRC)
            IF (IRC.NE.0) GOTO 50
            ISPEC1=ISPEC1+INCR1
         ENDIF
         IF (I.EQ.1.OR.INCR2.NE.0) THEN
            CALL OPNFIL (KUNIT,HFNAM2,ISPEC2,MEM2,IFFR2,ILFR2,NPIX2,
     &                   NRAST2,NFRAM2,IRC)
            IF (IRC.NE.0) GOTO 50
            ISPEC2=ISPEC2+INCR2
         ENDIF
C
         CALL RFRAME (JUNIT,IFFR1,NPIX1,NRAST1,SP1,IRC)
         IF (IRC.NE.0) GOTO 50
         CALL RFRAME (KUNIT,IFFR2,NPIX2,NRAST2,SP2,IRC)
         IF (IRC.NE.0) GOTO 50
         IFFR1=IFFR1+IFINC1
         IFFR2=IFFR2+IFINC2
         KPIC=KPIC+1
         IF (INCR1.NE.0) CALL FCLOSE (JUNIT)
         IF (INCR2.NE.0) CALL FCLOSE (KUNIT)
C
         IF (KPIC.EQ.1.OR.(.NOT.SAME)) THEN
15          WRITE (IPRINT,1020)
            CALL GETVAL (ITERM,WEIGHT,NVAL,IRC)
            IF (IRC.EQ.1) GOTO 50
            IF (IRC.EQ.2) GOTO 15
            IF (NVAL.LT.2) WEIGHT(2)=1.0
            IF (NVAL.LT.1) WEIGHT(1)=1.0
         ENDIF
C
C========TEST FOR ZERO CLAMP OPTION
C
         IF (ZEROOP) THEN
            DO 20 K=1,NRAST*NPIX
               SP3(K)=SP1(K)*WEIGHT(1)+SP2(K)*WEIGHT(2)
20          CONTINUE
         ELSE
            DO 30 K=1,NRAST*NPIX
               SP3(K)=SP1(K)*WEIGHT(1)+SP2(K)*WEIGHT(2)
               IF (SP3(K).LT.0.0) SP3(K)=0.0
30          CONTINUE
         ENDIF
C
         IF (IFRAME.EQ.1) CALL IMDISP (ITERM,IPRINT,SP3,NPIX,NRAST)
         IF (KPIC.EQ.1) THEN
            CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF (IRC.NE.0) GOTO 50
            CALL OPNNEW (LUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                   HEAD2,IRC)
            IF (IRC.NE.0) GOTO 50
         ENDIF
         CALL WFRAME (LUNIT,KPIC,NPIX,NRAST,SP3,IRC)
         IF (IRC.NE.0) GOTO 50
40    CONTINUE
50    CALL FCLOSE (LUNIT)
      CALL FCLOSE (JUNIT)
      CALL FCLOSE (KUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Do you want the same constants for all for all spectra',
     1        ' [Y/N] [Y]: ',$)
1010  FORMAT (' Do you want to zero negative values (Y/N) [N]: ',$)
1020  FORMAT (' Enter weights of first & second spectrum [1.0,1.0]: ',$)
      END
