C     LAST UPDATE 31/07/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE BACK
      IMPLICIT NONE
C
C Purpose: Background subtraction of an image.
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
      REAL         SP5(2048),SP6(2048),SP7(2048),SP8(2048)
      REAL         SP9(2048),SP10(2048),SP11(2048),SP12(2048),SP13(2048)
      REAL         SP14(2048),SP15(2048),SPW(2048)
      REAL         VALUE(10),XPOS,YPOS,RMIN,RMAX,PCENT(25)
      INTEGER      ISPEC,LSPEC,INCR,IFFR,ILFR,IFINC,IHFMAX,IFRMAX,IFRAME
      INTEGER      NPIX,NRAST,NFRAME,KPIC,MEM,IMEM,NREG
      INTEGER      IRC,NVAL,I,J,K,L,JCH1,JCH2,M,N,ICOL(8)
      INTEGER      IMIN(25),IMAX(25),MDEG(25),JMIN,JMAX,NSTART,NTOT(25)
      INTEGER      IFROW,ILROW,INCROW,ISAVE,NPOINT,NDATA,ICH1,ICH2
      INTEGER      ICALL,IPLOT,IAUTO,ISYMB,IAXIS,IWINDO,KCHAR,IXPOS
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
      CHARACTER*6  TITLE,XANOT,YANOT
      LOGICAL      REPEAT,ASKNO,SAME,ASKYES
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
      DATA IMEM/1/
      DATA IAXIS/1/ , IAUTO/1/ , IWINDO/0/ , ICOL/0,0,0,0,0,0,0,0/
      DATA XANOT/'X-AXIS'/ , YANOT/'Y-AXIS'/, TITLE/' '/
C
C-----------------------------------------------------------------------
10    KPIC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      IFROW=1
      ILROW=NPIX
      INCROW=1
20    WRITE (IPRINT,1000) NPIX
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GE.1) IFROW=INT(VALUE(1))
      IF (NVAL.GE.2) ILROW=INT(VALUE(2))
      IF (NVAL.GE.3) INCROW=INT(VALUE(3))
C
C========OPEN FILE AND READ REQUESTED FRAME
C
      CALL FILL (SP3,NPIX*NRAST,0.0)
      IFRAME=IHFMAX+IFRMAX-1
      CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &             NFRAME,IRC)

      IF (IRC.NE.0) GOTO 10
C
      ISAVE=IFFR
      SAME=.FALSE.
      DO 260 I=IFROW,ILROW,INCROW
         IFFR=ISAVE
         NPOINT=1
         KPIC=0
         DO 30 J=1,NRAST
            SP4(J)=REAL(J)
30       CONTINUE
C
         DO 50 J=1,IFRMAX
C
            CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
            IF (IRC.NE.0) GOTO 270
            IFFR=IFFR+IFINC
            KPIC=KPIC+1
C
            DO 40 K=1,NRAST
               SP2(NPOINT)=SP1((K-1)*NPIX+I)
               NPOINT=NPOINT+1
40          CONTINUE
50       CONTINUE
C
60       IF (.NOT.SAME) NREG=1
70       IF (SAME) THEN
            RMIN=SP2(ICH1)
            RMAX=SP2(ICH1)
            DO 90 K=1,KPIC
               L=(K-1)*NRAST
               DO 80 J=ICH1,ICH2
                  RMIN=MIN (RMIN,SP2(L+J))
                  RMAX=MAX (RMAX,SP2(L+J))
80             CONTINUE
90          CONTINUE
            NSTART=1
            DO 120 M=1,NREG
               DO 110 J=1,NTOT(M)
                  N=NSTART+J-1
                  IXPOS=INT(SP5(N))
                  SP6(N)=SP2(IXPOS)
                  DO 100 K=1,KPIC
                     L=(K-1)*NRAST+IXPOS
                     SP6(N)=MIN (SP6(N),SP2(L))
100               CONTINUE
                  SP6(N)=SP6(N)-PCENT(M)*SP6(N)
110            CONTINUE
C
               CALL FILL (SP7,NRAST,1.0)
               CALL VC01A (SP5(NSTART),SP6(NSTART),SP7,SP8,NTOT(M),SP9,
     &                  SP10,SP11,SP12,SP13,SP14,MDEG(M),SPW)
               NPOINT=IMAX(M)-IMIN(M)+1
               IF (M.EQ.1) CALL FILL (SP15,NRAST,0.0)
               JMIN=IMIN(M)
               JMAX=IMAX(M)
               CALL POLCAL (SP4(JMIN),SP15(JMIN),SP9,SP10,SP11,MDEG(M),
     &                      1,NPOINT)
               NSTART=NSTART+NTOT(M)-1
120         CONTINUE
C
         ELSE
            IF (NREG.EQ.1) THEN
               IMIN(1)=NRAST
               IMAX(1)=1
               NDATA=0
               NTOT(NREG)=0
               NSTART=1
            ELSE
               IMIN(NREG)=IMAX(NREG-1)
               IMAX(NREG)=IMAX(NREG-1)
               NSTART=NDATA
               NTOT(NREG)=1
            ENDIF
            PCENT(NREG)=1.0
130         WRITE (IPRINT,1010) 
            CALL GETVAL (ITERM,VALUE,NVAL,IRC)
            IF (IRC.EQ.1) GOTO 270
            IF (IRC.EQ.2) GOTO 130
            IF (NVAL.GE.1) PCENT(NREG)=VALUE(1)
            IF (PCENT(NREG).LE.0.0.OR.PCENT(NREG).GT.100.0) GOTO 130
            PCENT(NREG)=PCENT(NREG)/100.
            IRC=0
            IF (NREG.NE.1) GOTO 170
140         CALL GETCHN (ITERM,IPRINT,NRAST,ICH1,ICH2,IRC)
 170        IF (IRC.EQ.0) THEN
               IF (NREG.EQ.1) THEN
                  RMIN=SP2(ICH1)
                  RMAX=SP2(ICH1)
                  DO 160 K=1,KPIC
                     L=(K-1)*NRAST
                     DO 150 J=ICH1,ICH2
                        RMIN=MIN (RMIN,SP2(L+J))
                        RMAX=MAX (RMAX,SP2(L+J))
 150                 CONTINUE
 160              CONTINUE
                  WRITE (IPRINT,1030) ICH1,ICH2,RMIN,RMAX
                  JCH1=ICH1
                  JCH2=ICH2
               ENDIF
C
               ICALL=0
               IPLOT=1
               NPOINT=JCH2-JCH1+1
               DO 180 J=1,KPIC
                  CALL FRPLOT (ITERM,IPRINT,SP4(JCH1),
     &                      SP2((J-1)*NRAST+JCH1),NPOINT,ICALL,IAXIS,
     &                      IAUTO,IPLOT,IWINDO,ISYMB,ICOL,
     &                      XANOT,YANOT,TITLE)
180            CONTINUE
C
190            CALL CURSOR (XPOS,YPOS,KCHAR)
               IF (KCHAR.NE.83.AND.KCHAR.NE.115.AND.
     &             KCHAR.NE.82.AND.KCHAR.NE.114) THEN
                  IXPOS=INT(XPOS)
                  IF (NDATA.GT.1.AND.XPOS.EQ.SP5(NDATA)) GOTO 190
                  IF (IXPOS.LT.ICH1.AND.IXPOS.GT.ICH2) GOTO 190
                  IF (NREG.GT.1.AND.IXPOS.LT.IMIN(NREG-1)) GOTO 190
                  IF (IXPOS.GT.IMAX(NREG)) IMAX(NREG)=IXPOS
                  IF (IXPOS.LT.IMIN(NREG)) IMIN(NREG)=IXPOS
                  NTOT(NREG)=NTOT(NREG)+1
                  NDATA=NDATA+1
                  SP5(NDATA)=REAL(IXPOS)
                  SP6(NDATA)=SP2(IXPOS)
                  DO 200 J=1,KPIC
                     L=(J-1)*NRAST+IXPOS
                     SP6(NDATA)=MIN (SP6(NDATA),SP2(L))
200               CONTINUE
                  SP6(NDATA)=SP6(NDATA)-PCENT(NREG)*SP6(NDATA)
                  CALL PLOTNC (REAL(IXPOS),SP6(NDATA),230)
                  GOTO 190
               ENDIF
               call trmode
               GOTO 140
            ENDIF
C
            MDEG(NREG)=1
210         WRITE (IPRINT,1020)
            CALL GETVAL (ITERM,VALUE,NVAL,IRC)
            IF (IRC.EQ.1) GOTO 270
            IF (IRC.EQ.2) GOTO 210
            IF (NVAL.GE.1) MDEG(NREG)=INT(VALUE(1))
C
            JMIN=IMIN(NREG)
            JMAX=IMAX(NREG)
            CALL FILL (SP7,NRAST,1.0)
            CALL VC01A (SP5(NSTART),SP6(NSTART),SP7,SP8,NTOT(NREG),SP9,
     &                  SP10,SP11,SP12,SP13,SP14,MDEG(NREG),SPW)
            NPOINT=JMAX-JMIN+1
            IF (NREG.EQ.0) CALL FILL (SP15,NRAST,0.0)
            CALL POLCAL (SP4(JMIN),SP15(JMIN),SP9,SP10,SP11,MDEG(NREG),
     &                   1,NPOINT)
C
            DO 220 J=JMIN,JMAX
               RMIN=MIN (RMIN,SP15(J))
               RMAX=MAX (RMAX,SP15(J))
220         CONTINUE
            WRITE (IPRINT,1030) IMIN(1),JMAX,RMIN,RMAX
         ENDIF
C
         ICALL=0
         IPLOT=1
         JMIN=IMIN(1)
         JMAX=IMAX(NREG)
         NPOINT=JMAX-JMIN+1
         DO 230 J=1,KPIC
            CALL FRPLOT (ITERM,IPRINT,SP4(JMIN),
     &                   SP2((J-1)*NRAST+JMIN),NPOINT,ICALL,IAXIS,
     &                   IAUTO,IPLOT,IWINDO,ISYMB,ICOL,
     &                   XANOT,YANOT,TITLE)
230      CONTINUE
         IPLOT=2
         CALL FRPLOT (ITERM,IPRINT,SP4(JMIN),SP15(JMIN),NPOINT,
     &         ICALL,IAXIS,IAUTO,IPLOT,IWINDO,ISYMB,ICOL,
     &         XANOT,YANOT,TITLE)
         call trmode
C
         IF (KCHAR.EQ.82.OR.KCHAR.EQ.114) THEN
            NREG=NREG+1
            GOTO 70
         ENDIF
C
         WRITE (IPRINT,1040)
         REPEAT=ASKNO (ITERM,IRC)
         IF (IRC.NE.0) GOTO 240
         IF (.NOT.REPEAT) THEN
            SAME=.FALSE.
            GOTO 60
         ENDIF
C
240      DO 250 J=IMIN(1),IMAX(NREG)
            L=(J-1)*NPIX+I
            SP3(L)=SP15(J)
250      CONTINUE
C
         IF (I.NE.ILROW) THEN
            WRITE (IPRINT,1050)
            SAME=ASKYES (ITERM,IRC)
            IF (IRC.NE.0) GOTO 270
         ENDIF
260   CONTINUE
C
      CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
      IF (IRC.NE.0) GOTO 270
      IFRAME=1
      CALL OPNNEW (KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &             HEAD2,IRC)
      IF (IRC.NE.0) GOTO 270
      CALL WFRAME (KUNIT,IFRAME,NPIX,NRAST,SP3,IRC)
270   CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter first, last & incr row lines [1,',I4,',1]: ',$)
1010  FORMAT (' Enter percentage drop from real data [1.0]: ',$)
1020  FORMAT (' Enter degree of polynomial [1]: ',$)
1030  FORMAT (' Suggested limits are: ',2I4,2G13.4)
1040  FORMAT (' Do you want to repeat the fitting [Y/N] [N]: ',$)
1050  FORMAT (' Do you want to the same x positions [Y/N] [Y]: ',$)
      END
