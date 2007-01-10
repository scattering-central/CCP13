C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE MIRROR
      IMPLICIT   NONE
C
C Purpose: MIRROR THE FOUR QUADRANTS OF AN IMAGE.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   8: IMDISP , WFRAME , RFRAME , OUTFIL
C            GETVAL , GETHDR , OPNFIL , OPNNEW
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10),TEMP
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER      ICENTRX,ICENTRY,NX,NY,M1,M2,M3,M4,I,J,K,L
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
C ICENTRX: Centre x coordinate
C ICENTRY: Centre y coordinate
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
C
C========FIND X,Y COORDINATES OF CENTRE FOR MIRROR
C
      ICENTRX=(NPIX/2)+1
      ICENTRY=(NRAST/2)+1
20    WRITE (IPRINT,1000) ICENTRX,ICENTRY
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GT.0) ICENTRX=VALUE(1)
      IF (NVAL.GT.1) ICENTRY=VALUE(2)
      IF (ICENTRX.LT.1.OR.ICENTRX.GT.NPIX.OR.
     &    ICENTRY.LT.1.OR.ICENTRY.GT.NRAST) GOTO 20
C
C========FIND MAXIMUM RADIUS OBTAINABLE FROM GIVEN CENTRE
C
      NX=MIN (NPIX-ICENTRX+1,ICENTRX-1)
      NY=MIN (NRAST-ICENTRY+1,ICENTRY-1)
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
C========MIRROR DATA 
C
               DO 50 K=ICENTRY-NY,ICENTRY-1
                  DO 40 L=ICENTRX-NX,ICENTRX-1
                     M1=(K-1)*NPIX+L
                     M2=(K-1)*NPIX+(2*ICENTRX)-L-1
                     M3=(2*ICENTRY-K-2)*NPIX+L
                     M4=(2*ICENTRY-K-2)*NPIX+(2*ICENTRX)-L-1
                     TEMP=(SP1(M1)+SP1(M2)+
     &                     SP1(M3)+SP1(M4))/4.0
                     SP2(M1)=TEMP
                     SP2(M2)=TEMP
                     SP2(M3)=TEMP
                     SP2(M4)=TEMP
40                CONTINUE
50             CONTINUE
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
1000  FORMAT (' Enter x,y coordinates for image centre',
     &        ' [',I3,',',I3,'] : ',$)
      END
