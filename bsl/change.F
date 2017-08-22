C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE CHANGE
      IMPLICIT   NONE
C
C Purpose: Modify selected points in an image.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   2: GETVAL , GETHDR , ERRMSG , RDHDR
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL         VALUE(10)
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,I,J,K
      INTEGER      IOS,MPIX,MRAST,IREC,JREC,JRC
      CHARACTER*13 HFNAM,FNAM
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
C FNAM   : Current file being changed
C
C-----------------------------------------------------------------------
10    KPIC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      DO 50 I=1,IHFMAX
         CALL RDHDR (HFNAM,FNAM,ISPEC,MEM,IUNIT,NPIX,NRAST,NFRAME,JRC)
         IF (JRC.NE.0) THEN
            CALL ERRMSG ('Error: Header file not found')
            IRC=1
         ELSEIF (IFFR.GT.NFRAME.OR.ILFR.GT.NFRAME) THEN
            CALL ERRMSG ('Error: Missing file or frame')
            IRC=1
         ELSE
#if defined titan || sgi
            OPEN (UNIT=IUNIT,FILE=FNAM,STATUS='OLD',IOSTAT=IOS,
     &            ACCESS='DIRECT',RECL=NPIX)
#else
            OPEN (UNIT=IUNIT,FILE=FNAM,STATUS='OLD',IOSTAT=IOS,
     &            ACCESS='DIRECT',RECL=NPIX*4)
#endif
            IF (IOS.NE.0) THEN
               CALL ERRMSG ('Error: Binary file not found')
               IRC=1
            ELSE
               ISPEC=ISPEC+INCR
C
               DO 40 J=1,IFRMAX
                  WRITE (FNAM(4:4),'(I1)') IFFR/100
                  WRITE (FNAM(5:5),'(I1)') MOD(IFFR,100)/10
                  WRITE (FNAM(6:6),'(I1)') MOD(IFFR,10)
                  WRITE (IPRINT,1000) FNAM
C
                  IREC=0
30                WRITE (IPRINT,1010)
                  CALL GETVAL (ITERM,VALUE,NVAL,IRC)
                  IF (IRC.EQ.1) THEN
                     IF (IREC.GT.0) THEN
                        WRITE (IUNIT,REC=IREC) (SP1(K),K=1,NPIX)
                        IREC=0
                     ENDIF
                  ELSEIF (IRC.EQ.2) THEN
                     GOTO 30
                  ELSEIF (NVAL.LT.3) THEN
                     CALL ERRMSG ('Error: Three values required')
                     GOTO 30
                  ELSE
                     MPIX=INT (VALUE(1))
                     MRAST=INT (VALUE(2))
                     JREC=(IFFR-1)*NRAST+MRAST
                     IF (IREC.NE.JREC) THEN
                        IF (IREC.NE.0) THEN
                           WRITE (IUNIT,REC=IREC) (SP1(K),K=1,NPIX)
                        ENDIF
                        READ (IUNIT,REC=JREC) (SP1(K),K=1,NPIX)
                        IREC=JREC
                     ENDIF
                     SP1(MPIX)=VALUE(3)
                     GOTO 30
                  ENDIF                   
                  IFFR=IFFR+IFINC
                  KPIC=KPIC+1
40             CONTINUE
               CLOSE (UNIT=IUNIT)
            ENDIF
         ENDIF
50    CONTINUE
      CLOSE (UNIT=IUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Editing file: ',A)
1010  FORMAT (' Enter pixel, raster and value or <ctrl-D>: ',$)
      END
