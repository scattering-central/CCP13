C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE DUPE
      IMPLICIT NONE
C
C Purpose: Duplicate and or remove frames of an image.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   7: WFRAME , RFRAME , OUTFIL
C            GETVAL , GETHDR , OPNFIL , OPNNEW
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10)
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,I,J,K
      INTEGER      IDUPE,NDUPE,IREMOV,NREMOV,JFRAME,KOUT
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
C========GET SHIFT PARAMETERS
C
30    NDUPE=0
      WRITE (IPRINT,1010) 
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 30
      IF (NVAL.GE.0) NDUPE=INT(VALUE(1))
C
      IF (NDUPE.NE.0) THEN
20       IDUPE=1
         WRITE (IPRINT,1000) 
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 10
         IF (IRC.EQ.2) GOTO 20
         IF (NVAL.GE.1) IDUPE=INT(VALUE(1))
      ENDIF
C
50    NREMOV=0
      WRITE (IPRINT,1030) 
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 50
      IF (NVAL.GE.1) NREMOV=INT(VALUE(1))
C
      IF (NREMOV.NE.0) THEN
40       IREMOV=1
         WRITE (IPRINT,1020)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 10
         IF (IRC.EQ.2) GOTO 40
         IF (NVAL.GE.1) IREMOV=INT(VALUE(1))
      ENDIF
C
      IF (IDUPE.GE.IREMOV.AND.IDUPE.LT.IREMOV+NREMOV) THEN
         CALL ERRMSG ('Error: Cant duplicate frame you want removed')
         GOTO 10
      ENDIF
C
      DO 70 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 60 J=1,IFRMAX
               IF (KPIC.EQ.0) THEN
                  JFRAME=IFRAME+NDUPE-NREMOV
                  KOUT=1
             CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (KUNIT,NPIX,NRAST,JFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               IF (J.EQ.IDUPE) THEN
                  CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
                  IF (IRC.NE.0) GOTO 80
                  KPIC=KPIC+1
                  DO 55 K=1,NDUPE+1
                     CALL WFRAME (KUNIT,KOUT,NPIX,NRAST,SP1,IRC)
                     IF (IRC.NE.0) GOTO 80
                     KOUT=KOUT+1
55                CONTINUE
               ELSEIF (J.LT.IREMOV.AND.J.GE.IREMOV+NREMOV) THEN
                  CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
                  IF (IRC.NE.0) GOTO 80
                  KPIC=KPIC+1
                  CALL WFRAME (KUNIT,KOUT,NPIX,NRAST,SP1,IRC)
                  IF (IRC.NE.0) GOTO 80
                  KOUT=KOUT+1
               ENDIF
               IFFR=IFFR+IFINC
C
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
80    CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter frame to duplicate [1]: ',$)
1010  FORMAT (' Enter nos. of duplicate frame [0]: ',$)
1020  FORMAT (' Enter frame to start removal [1]: ',$)
1030  FORMAT (' Enter nos. of frames to remove [0]: ',$)
      END
