C     LAST UPDATE 19/06/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SURFACE
      IMPLICIT   NONE
C
C PURPOSE: DISPLAY 2D REPRESENTATION OF IMAGE
C
      INCLUDE 'COMMON.FOR'
C
C Calls   6: RFRAME , GETHDR , OPNFIL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,I,J
      CHARACTER*13 HFNAM
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
C NPIX   : Nos. of pixels in image
C NRAST  : Nos. of rasters in image
C NFRAME : Nos. of frames in dataset
C TITLE  : Title for contour map
C
C-----------------------------------------------------------------------
C
 10   CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      DO 70 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 60 J=1,IFRMAX
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) THEN
                  CALL FCLOSE (JUNIT)
                  GOTO 10
               ENDIF
               IFFR=IFFR+IFINC
               CALL ISOMET (ITERM,IPRINT,SP1,NPIX,NRAST)
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
      GOTO 10
999   RETURN
C
      END

