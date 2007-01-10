C     LAST UPDATE 19/06/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE CONPLOT
      IMPLICIT   NONE
C
C PURPOSE: READ AN IMAGE AND PLOT A CONTOUR MAP OF THAT IMAGE.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   6: RFRAME , IMSIZE , GETHDR , OPNFIL , IGETS , CONTOUR
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME
      INTEGER KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,I,J,K,L,M
      INTEGER IFPIX,ILPIX,IFRAST,ILRAST
      CHARACTER*80 TITLE
      CHARACTER*13 HFNAM
      LOGICAL IGETS
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
C KPIC   : Current image nos.
C TITLE  : Title for contour map
C
C-----------------------------------------------------------------------
10    KPIC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      CALL IMSIZE (ITERM,IPRINT,NPIX,NRAST,IFPIX,ILPIX,IFRAST,
     &             ILRAST,IRC)
      IF (IRC.NE.0) GOTO 10
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
               WRITE (IPRINT,1000)
               IF (.NOT.IGETS (ITERM,TITLE)) GOTO 80
               M=1
               DO 50 K=IFRAST,ILRAST
                  DO 40 L=IFPIX,ILPIX
                     SP2(M)=SP1(NPIX*(K-1)+L)
                     M=M+1
40                CONTINUE
50             CONTINUE
               CALL CONTOUR (ITERM,IPRINT,SP2,ILPIX-IFPIX+1,
     &              ILRAST-IFRAST+1,IFPIX,IFRAST,TITLE)
C
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
80    CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT ('Enter plot title: ',$)
      END
