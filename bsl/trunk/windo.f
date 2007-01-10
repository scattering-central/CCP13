C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE WINDO
      IMPLICIT NONE
C
C PURPOSE: Create a contrast transfer function in 2D from 1D file
C
      INCLUDE 'COMMON.FOR'
C
C Calls   9: WFRAME , GETHDR , IMSIZE , OUTFIL , FILL
C            IMDISP , RFRAME , OPNNEW , OPNFIL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10),X,Y,RADIUS
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER      I,J,K,L,M,NCHAN,ICENTX,ICENTY
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,MFNAM
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
      WRITE (IPRINT,*) '1D Tukey window'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
C
      CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NRAST,
     &             NFRAME,IRC)
      IF (IRC.NE.0) GOTO 80
      CALL RFRAME (JUNIT,IFFR,NCHAN,NRAST,SP1,IRC)
      IF (IRC.NE.0) GOTO 80
      CALL FCLOSE (JUNIT)
C
C========GET HEADER & BINARY FILE ATTRIBUTES
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
C========FIND X,Y COORDINATES FOR CENTRE OF POLAR COORDINATES
C
      ICENTX=NPIX/2
      ICENTY=NRAST/2
20    WRITE (IPRINT,1000) ICENTX,ICENTY
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GT.0) ICENTX=VALUE(1)
      IF (NVAL.GT.1) ICENTY=VALUE(2)
C
      DO 70 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 60 J=1,IFRMAX
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP2,IRC)
               IF (IRC.NE.0) GOTO 80
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
               CALL FILL (SP3,NPIX*NRAST,0.0)
               DO 40 K=1,NRAST
                  M=(K-1)*NPIX
                  DO 30 L=1,NPIX
                     Y=L-ICENTY-0.5
                     X=K-ICENTX-0.5


                     RADIUS=SQRT(X*X+Y*Y)
                     IF (INT(RADIUS).GT.NCHAN) THEN
                        SP3(M+L)=0.0
                     ELSE
                        SP3(M+L)=SP1(INT(RADIUS)+1)
                     ENDIF
30                CONTINUE
40             CONTINUE
               DO 50 K=1,NRAST*NPIX
                  SP2(K)=SP2(K)*SP3(K)
50             CONTINUE
C
               IF (IFRAME.EQ.1) CALL IMDISP(ITERM,IPRINT,SP2,NPIX,NRAST)
               IF (KPIC.EQ.1) THEN
                  WRITE (IPRINT,*) 'Windowed data'
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               CALL WFRAME (KUNIT,KPIC,NPIX,NRAST,SP2,IRC)
               IF (IRC.NE.0) GOTO 80
C
               IF (KPIC.EQ.1) THEN
                  WRITE (IPRINT,*) 'Window mask'
                  CALL OUTFIL (ITERM,IPRINT,MFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (LUNIT,NPIX,NRAST,IFRAME,MFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               CALL WFRAME (LUNIT,KPIC,NPIX,NRAST,SP3,IRC)
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
1000  FORMAT (' Enter x,y coordinate for rotation centre of 1D window',
     &        ' [',I4,',',I4,'] : ',$)
      END
