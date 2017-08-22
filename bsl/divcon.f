C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE DIVCON
      IMPLICIT NONE
C
C Purpose: Divide a selected region of an image by a constant.
C
      INCLUDE 'COMMON.FOR'
C
C Calls  11: IMDISP , ASKYES , WFRAME , RFRAME , IMSIZE , OUTFIL
C            GETVAL , GETHDR , OPNFIL , OPNNEW , ASKNO
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL    CONST(10)
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,I,J,K
      INTEGER IFPIX,ILPIX,IFRAST,ILRAST,L,M
      LOGICAL SAME,RZERO,ASKYES,ZEROOP,ASKNO
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
C ZEROOP : True if zero option not selected
C CONST  : Weighting factor
C SAME   : Same weighting factors to be used
C RZERO  : Zero data outside selected range
C NVAL   : Nos. of values entered at terminal
C
      DATA  IMEM/1/
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
      WRITE (IPRINT,1000)
      RZERO=ASKYES (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
C
      WRITE (IPRINT,1010)
      SAME=ASKYES (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
C
      WRITE (IPRINT,1020)
      ZEROOP=ASKNO (ITERM,IRC)
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
               IF (KPIC.EQ.1.OR.(.NOT.SAME)) THEN
15                WRITE (IPRINT,1030)
                  CALL GETVAL (ITERM,CONST,NVAL,IRC)
                  IF (IRC.EQ.1) GOTO 80
                  IF (IRC.EQ.2) GOTO 15
                  IF (NVAL.EQ.0) CONST(1)=1.0
                  IF (CONST(1).EQ.0.0) THEN
                     CALL ERRMSG ('Error: Divide by zero not allowed')
                     GOTO 15
                  ENDIF
               ENDIF
C
C========TEST FOR ZERO OPTION
C
               IF (ZEROOP) THEN
                  DO 30 K=1,NRAST
                     DO 20 L=1,NPIX
                        M=(K-1)*NPIX+L
                        IF (K.GE.IFRAST.AND.K.LE.ILRAST.AND.
     &                      L.GE.IFPIX.AND.L.LE.ILPIX) THEN
                           SP2(M)=SP1(M)/CONST(1)
                        ELSEIF (.NOT.RZERO) THEN
                           SP2(M)=SP1(M)
                        ELSE
                           SP2(M)=0.0
                        ENDIF
20                   CONTINUE
30                CONTINUE
               ELSE
                  DO 50 K=1,NRAST
                     DO 40 L=1,NPIX
                        M=(K-1)*NPIX+L
                        IF (K.GE.IFRAST.AND.K.LE.ILRAST.AND.
     &                      L.GE.IFPIX.AND.L.LE.ILPIX) THEN
                           SP2(M)=SP1(M)/CONST(1)
                           IF (SP2(M).LT.0.0) SP2(M)=0.0
                        ELSEIF (.NOT.RZERO) THEN
                           SP2(M)=SP1(M)
                           IF (SP2(M).LT.0.0) SP2(M)=0.0
                        ELSE
                           SP2(M)=0.0
                        ENDIF
40                   CONTINUE
50                CONTINUE
               ENDIF
C
               IF (IFRAME.EQ.1) CALL IMDISP(ITERM,IPRINT,SP2,NPIX,NRAST)
               IF (KPIC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               CALL WFRAME (KUNIT,KPIC,NPIX,NRAST,SP2,IRC)
               IF (IRC.NE.0) GOTO 80
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
80    CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Zero output outside range [Y/N] [Y]: ',$)
1010  FORMAT (' Do you want the same constants for all spectra',
     1        ' [Y/N] [Y]: ',$)
1020  FORMAT (' Do you want to zero negative values (Y/N) [N]: ',$)
1030  FORMAT (' Enter constant [1.0]: ',$)
      END
