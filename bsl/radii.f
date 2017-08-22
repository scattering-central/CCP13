C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE RADII
      IMPLICIT   NONE
C
C PURPOSE: Create circles around a centre point to act as a psuedo 2D
C          X-axis
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
      REAL         VALUE(10)
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,I,J,K
      INTEGER      ICENTRX,ICENTRY,IX,IY,L,M
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
20    ICENTRX=NPIX/2
      ICENTRY=NRAST/2
      WRITE (IPRINT,1000) ICENTRX,ICENTRY
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.2) GOTO 20
      IF (IRC.EQ.1) GOTO 10
      IF (NVAL.GE.1) ICENTRX=INT(VALUE(1))
      IF (NVAL.GE.2) ICENTRY=INT(VALUE(2))         
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
               DO 50 K=1,NRAST
                  M=(K-1)*NPIX
                  IY=K-ICENTRY
                  DO 40 L=1,NPIX
                     IX=L-ICENTRX
                     SP2(M+L)=SQRT(REAL(IX*IX+IY*IY))
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
1000  FORMAT (' Enter X,Y centre coordinates [',I3,',',I3,']: ',$)
      END
