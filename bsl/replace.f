C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REPLACE
      IMPLICIT NONE
C
C PURPOSE: Replace a single raster or rasters in an image.
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
      REAL    VALUE(10)
      INTEGER NPIX1,NPIX2,NRAST1,NRAST2,NFRAM1,NFRAM2
      INTEGER IRC,IMEM,KPIC,IFRAME
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER IHFMX1,IFRMX1,IHFMX2,IFRMX2,I,J,K,L,M
      INTEGER IFRAST,ILRAST,NVAL
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
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     &             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NPIX1,NRAST1,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMX1+IFRMX1-1
C
      DO 90 I=1,IHFMX1
         CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NPIX1,
     &                NRAST1,NFRAM1,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC1=ISPEC1+INCR1
            DO 80 J=1,IFRMX1
               CALL RFRAME (JUNIT,IFFR1,NPIX1,NRAST1,SP1,IRC)
               IF (IRC.NE.0) GOTO 100
               IFFR1=IFFR1+IFINC1
               KPIC=KPIC+1
C
15             IF (KPIC.EQ.1) THEN
20                WRITE (IPRINT,*) 'Single file(s)'
                  CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,
     &                         INCR2,MEM2,IFFR2,ILFR2,IFINC2,IHFMX2,
     &                         IFRMX2,NPIX2,NRAST2,IRC)
                  IF (IRC.NE.0) GOTO 70
C
                  CALL OPNFIL (KUNIT,HFNAM2,ISPEC2,MEM2,IFFR2,ILFR2,
     &                         NPIX2,NRAST2,NFRAM2,IRC)
                  IF (IRC.NE.0) GOTO 100
C
                  CALL RFRAME (KUNIT,IFFR2,NPIX2,NRAST2,SP2,IRC)
                  IF (IRC.NE.0) GOTO 100
                  CALL FCLOSE (KUNIT)
C
                  IF (NPIX1.NE.NPIX2) THEN
                     CALL ERRMSG ('Error: Mismatched operation')
                     GOTO 20
                  ENDIF
C
                  IF (NRAST2.EQ.1) THEN
30                   IFRAST=1
                     ILRAST=NRAST2
                     WRITE (IPRINT,1000) NRAST2
                     CALL GETVAL (ITERM,VALUE,NVAL,IRC)
                     IF (IRC.EQ.2) GOTO 30
                     IF (IRC.EQ.1) GOTO 100
                     IF (NVAL.GE.1) IFRAST=INT(VALUE(1))
                     IF (NVAL.GE.2) ILRAST=INT(VALUE(2))
                  ENDIF
               ENDIF
C
C========REPLACE RASTER(S)
C
               IF (NRAST2.EQ.1) THEN
                  DO 50 K=IFRAST,ILRAST
                     M=(K-1)*NPIX1
                     DO 40 L=1,NPIX1
                        SP1(M+L)=SP2(L)
40                   CONTINUE
50                CONTINUE
               ELSE
                  M=(IFRAST-1)*NPIX1
                  DO 60 L=1,NPIX1*NRAST2
                     SP1(M+L)=SP2(L)
60                CONTINUE                     
               ENDIF
               IF (KPIC.EQ.1.AND.IFRAME.EQ.1) GOTO 15
C
70             IF (IFRAME.EQ.1) CALL IMDISP (ITERM,IPRINT,SP1,NPIX1,
     &                                       NRAST1)
               IF (KPIC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
                  CALL OPNNEW (LUNIT,NPIX1,NRAST1,IFRAME,OFNAM,IMEM,
     &                         HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
               ENDIF
               CALL WFRAME (LUNIT,KPIC,NPIX1,NRAST1,SP1,IRC)
               IF (IRC.NE.0) GOTO 100
80          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
90    CONTINUE
100   CALL FCLOSE (LUNIT)
      CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter first & last rasters [1,',I4,']: ',$)
      END
