C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE MASK
      IMPLICIT NONE
C
C PURPOSE: Display an image & create a bit mask of selected areas.
C
      INCLUDE 'COMMON.FOR'
C
C Calls  15: WFRAME , RFRAME , OUTFIL , APLOT , POLFIL , CIRFIL
C            GETVAL , GETHDR , OPNFIL , OPNNEW , FILL  , RECFIL
C            ELLFIL , PARFIL , PUTIMAGE
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10)
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM,IDEC
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,I,J,K
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,PFNAM
      LOGICAL      PUTIMAGE
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
C========DISPLAY PICTURE & SELECT MASK
C
               IF (.NOT.PUTIMAGE (SP1,NPIX,NRAST)) GOTO 80
               CALL FILL (SP2,NPIX*NRAST,0.0)
C
C========SELECT TYPE OF MASK
C
               IF (KPIC.EQ.1) THEN
20                IDEC=1
                  WRITE (IPRINT,1000)
                  CALL GETVAL(ITERM,VALUE,NVAL,IRC)
                  IF (IRC.EQ.1) GOTO 30
                  IF (IRC.EQ.2) GOTO 20
                  IF (NVAL.GT.0) IDEC=INT(VALUE(1))
                  IF (IDEC.EQ.1) THEN
                     CALL POLFIL (SP2,NPIX,NRAST)
                  ELSEIF (IDEC.EQ.2) THEN
                     CALL RECFIL (SP2,NPIX,NRAST)
                  ELSEIF (IDEC.EQ.3) THEN
                     CALL CIRFIL (SP2,NPIX,NRAST)
                  ELSEIF (IDEC.EQ.4) THEN
                     CALL ELLFIL (SP2,NPIX,NRAST)
                  ELSEIF (IDEC.EQ.5) THEN
                     CALL PARFIL (SP2,NPIX,NRAST)
                  ENDIF
                  GOTO 20
               ENDIF
C
C========CALCULATE MASKED IMAGE
C
30             DO 40 K=1,NRAST*NPIX
                  SP3(K)=SP1(K)*SP2(K)
40             CONTINUE
C
               IF (KPIC.EQ.1) THEN
                  WRITE (IPRINT,*) 'Masked image'
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               CALL WFRAME (KUNIT,KPIC,NPIX,NRAST,SP3,IRC)
               IF (IRC.NE.0) GOTO 80
C
               IF (KPIC.EQ.1) THEN
                  WRITE (IPRINT,*) 'Mask bitmap data'
                  CALL OUTFIL (ITERM,IPRINT,PFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (LUNIT,NPIX,NRAST,IFRAME,PFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               CALL WFRAME (LUNIT,KPIC,NPIX,NRAST,SP2,IRC)
               IF (IRC.NE.0) GOTO 80
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
80    CALL FCLOSE (KUNIT)
      CALL FCLOSE (LUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT(' Enter option for mask selection or <CTRL-D>:',/,
     &       ' 1 : Select polygons',/,
     &       ' 2 : Select rectangles',/,
     &       ' 3 : Select circles',/,
     &       ' 4 : Select ellipses',/,
     &       ' 5 : Select paralleogram [1] : ',$)
      END
