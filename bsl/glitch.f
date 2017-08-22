C     LAST UPDATE 14/12/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GLITCH
      IMPLICIT NONE
C
C PURPOSE: Deglitch an image.
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
      REAL         TEMP
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER      INDX,NPTS,I,J,K,L,M
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
C
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
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
C NPIX   : Nos. of pixels in image
C NRAST  : Nos. of rasters in image
C NFRAME : Nos. of frames in dataset
C KPIC   : Current image nos.
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    WRITE (IPRINT,*) 'Maxima file'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &             NFRAME,IRC)
      IF (IRC.EQ.0) THEN
         CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP3,IRC)
         IF (IRC.NE.0) GOTO 80
         NPTS=NPIX
      ENDIF
      CALL FCLOSE (JUNIT)
C
      KPIC=0
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
      IF (NPTS.LT.IFRAME) THEN
         CALL ERRMSG ('Error: Not enough maxima points in file')
         GOTO 80
      ENDIF
C
      DO 70 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 60 J=1,IFRMAX
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 80

               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
C========DEGLITCH
C
               INDX=1
               DO 25 K=1,NRAST
                  DO 20 L=1,NPIX
                     IF (SP1(INDX).GT.SP3(KPIC)) THEN
                        IF (K.GT.1.AND.K.LT.NRAST) THEN
                           TEMP=SP1(INDX)
                           DO 18 M=1,NPIX-L
                              if (SP1(INDX+M).LE.SP3(KPIC)) GOTO 19
 18                        CONTINUE
 19                        SP1(INDX)=SP1(INDX-1)+(SP1(INDX+m)-
     &                                  SP1(INDX-1))/m+1

cx                       PRINT *,'CHANGING VALUE AT RASTER ',K,' PIXEL ',L
cx                       PRINT *,'FROM ',TEMP,' TO ',SP1(INDX),'using ',m
                        ELSE
                           SP1(INDX)=0.0
cx                       PRINT *,'CHANGING VALUE AT RASTER ',K,' PIXEL ',L
cx                       PRINT *,'FROM ',TEMP,' TO ',SP1(INDX)
                        ENDIF
                     ENDIF
                     INDX=INDX+1
20                CONTINUE
25             CONTINUE
C
               IF (IFRAME.EQ.1) CALL IMDISP(ITERM,IPRINT,SP1,NPIX,NRAST)
               IF (KPIC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               CALL WFRAME (KUNIT,KPIC,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 80
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
80    CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
      END
