C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE PRTVAL
      IMPLICIT   NONE
C
C Purpose: Print values of data on lineprinter or terminal.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   5: RFRAME , IMSIZE , GETHDR , OPNFIL , GETVAL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10)
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER      IFPIX,ILPIX,IFRAST,ILRAST,I,J,K,L,M,IDEV
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
C KPIC   : Current image nos.
C NVAL   : Nos. of values entered at terminal
C
C-----------------------------------------------------------------------
10    KPIC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      IDEV=0
20    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GE.1) IDEV=INT(VALUE(1))
      IF (IDEV.LT.0.OR.IDEV.GT.1) THEN
         CALL ERRMSG ('Error: Invalid device specified')
         GOTO 20
      ENDIF
C
      CALL IMSIZE (ITERM,IPRINT,NPIX,NRAST,IFPIX,ILPIX,IFRAST,
     &             ILRAST,IRC)
      IF (IRC.NE.0) GOTO 10
C
      IF (IDEV.NE.0) OPEN (UNIT=KUNIT,FILE='LP:',STATUS='NEW')
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
               KPIC=KPIC+1
C
               IF (IDEV.EQ.0) THEN
                  DO 30 K=IFRAST,ILRAST
                     M=(K-1)*NPIX
                     WRITE (IPRINT,1010) HFNAM,IFFR,K,IFPIX,ILPIX
                     WRITE (IPRINT,1020) (L,SP1(M+L),L=IFPIX,ILPIX)
30                CONTINUE
               ELSE
                  DO 35 K=IFRAST,ILRAST
                     M=(K-1)*NPIX
                     WRITE (KUNIT,1010) HFNAM,IFFR,K,IFPIX,ILPIX
                     WRITE (KUNIT,1020) (L,SP1(M+L),L=IFPIX,ILPIX)
35                CONTINUE
               ENDIF
               IFFR=IFFR+IFINC
C
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
80    CALL FCLOSE (JUNIT)
      IF (IDEV.NE.0) CALL FCLOSE (KUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Print output on [0] TT: or [1] LP:  [0]: ',$)
1010  FORMAT (' Header file: ',A,' Frame: ',I3,' Raster ',I4,/,
     1        ' First and last pixels ',2I5)
1020  FORMAT (4(' ',I4,G13.5))
      END
