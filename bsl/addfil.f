C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ADDFIL
      IMPLICIT NONE
C
C PURPOSE: Add/subtract a single file/raster to an image.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   8: WFRAME , GETHDR , OUTFIL , GETVAL
C            IMDISP , RFRAME , OPNNEW , OPNFIL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),CONST
      INTEGER NPIX1,NPIX2,NRAST1,NRAST2,NFRAM1,NFRAM2
      INTEGER IRC,IMEM,KPIC,IFRAME
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER IHFMX1,IFRMX1,IHFMX2,IFRMX2,I,J,K,L,M,NVAL
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
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    KPIC=0
      WRITE (IPRINT,*) 'Single file(s)'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     &             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NPIX1,NRAST1,IRC)
      IF (IRC.NE.0) GOTO 999
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,INCR2,MEM2,
     &             IFFR2,ILFR2,IFINC2,IHFMX2,IFRMX2,NPIX2,NRAST2,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMX2+IFRMX2-1
C
      IF (NPIX1.NE.NPIX2) THEN
         CALL ERRMSG ('Error: Mismatched operation')
         GOTO 10
      ENDIF
C
      CONST=1.0
20    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 20
      IF (IRC.EQ.2) GOTO 10
      IF (NVAL.GT.0) CONST=VALUE(1)
C
      DO 40 I=1,IHFMX2
         IF (I.EQ.1.OR.INCR1.NE.0) THEN
            CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NPIX1,
     &                   NRAST1,NFRAM1,IRC)
            IF (IRC.NE.0) GOTO 50
            ISPEC1=ISPEC1+INCR1
         ENDIF
C
         CALL OPNFIL (KUNIT,HFNAM2,ISPEC2,MEM2,IFFR2,ILFR2,NPIX2,
     &                NRAST2,NFRAM2,IRC)
         IF (IRC.NE.0) GOTO 50
         ISPEC2=ISPEC2+INCR2
C
         DO 30 J=1,IFRMX2
            IF (J.EQ.1.OR.IFINC1.NE.0) THEN
               CALL RFRAME (JUNIT,IFFR1,NPIX1,NRAST1,SP1,IRC)
               IF (IRC.NE.0) GOTO 50
               IFFR1=IFFR1+IFINC1
            ENDIF
            CALL RFRAME (KUNIT,IFFR2,NPIX2,NRAST2,SP2,IRC)
            IF (IRC.NE.0) GOTO 50
            IFFR2=IFFR2+IFINC2
            KPIC=KPIC+1
C
C========ADD/SUBTRACT  SINGLE FILE
C
            M=1
            DO 26 K=1,NRAST2
               DO 24 L=1,NPIX2
                  SP3(M)=SP2(M)+SP1(L)*CONST
                  M=M+1
24             CONTINUE
26          CONTINUE
C
            IF (IFRAME.EQ.1) CALL IMDISP (ITERM,IPRINT,SP3,NPIX2,NRAST2)
            IF (KPIC.EQ.1) THEN
               CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
               IF (IRC.NE.0) GOTO 50
               CALL OPNNEW (LUNIT,NPIX2,NRAST2,IFRAME,OFNAM,IMEM,HEAD1,
     &                      HEAD2,IRC)
               IF (IRC.NE.0) GOTO 50
            ENDIF
            CALL WFRAME (LUNIT,KPIC,NPIX2,NRAST2,SP3,IRC)
            IF (IRC.NE.0) GOTO 50
30       CONTINUE
         IF (INCR1.NE.0) CALL FCLOSE (JUNIT)
         CALL FCLOSE (LUNIT)
40    CONTINUE
50    CALL FCLOSE (LUNIT)
      CALL FCLOSE (JUNIT)
      CALL FCLOSE (KUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter single file weight [1.0]: ',$)
      END
