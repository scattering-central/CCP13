C     LAST UPDATE 11/06/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE INTEG
      IMPLICIT NONE
C
C PURPOSE: ALLOW USER TO SELECT A RECTANGULAR SECTION OF THE IMAGE,
C          INTEGRATE OVER THAT SECTION, AND PLOT THE RESULT OF THE
C          TIME COURSE.
C
      INCLUDE 'COMMON.FOR'
C
C Calls  12: WFRAME , RFRAME , IMSIZE , OUTFIL , FILL  , PUTIMAGE
C            GETHDR , OPNFIL , OPNNEW , APLOT  , ASKNO , GETVAL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         SUM,VALUE(10),SUMINT(4096)
      INTEGER      ISPEC,LSPEC,INCR,MEM,IFFR,ILFR,IFINC,IHFMAX
      INTEGER      IFRMAX,NPIX,NRAST,NFRAME,IMEM,I,J,K,L,M,N,IFRAME
      INTEGER      IRC,IFPIX,ILPIX,IFRAST,ILRAST,IDEC,NVAL,ISAVE1,ISAVE2
      INTEGER      JFRAME
      LOGICAL      KEYB,ASKNO,PUTIMAGE,FINISH,FIRST
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,PFNAM
C
C IFRMAX : NOS. OF FRAMES IN SEQUENCE
C IHFMAX : NOS. OF HEADER FILE IN SEQUENCE
C ISPEC  : FIRST HEADER FILE OF SEQUENCE
C LSPEC  : LAST HEADER FILE IN SEQUENCE
C MEM    : POSITIONAL OR CALIBRATION DATA INDICATOR
C IFFR   : FIRST FRAME IN SEQUENCE
C ILFR   : LAST FRAME IN SEQUENCE
C INCR   : HEADER FILE INCREMENT
C IFINC  : FRAME INCREMENT
C IMEM   : OUTPUT MEMORY DATASET
C NPIX   : NOS. OF PIXELS
C NRAST  : NOS. OF RASTERS
C NFRAME : NOS. OF TIME FRAMES
C OFNAM  : OUTPUT FILENAME
C HFNAM  : INPUT FILENAME
C HEAD1  : HEADER RECORD 1
C HEAD2  : HEADER RECORD 2
C IRC    : RETURN CODE   
C
      DATA IMEM/1/
C
C-----------------------------------------------------------------------
C
      FIRST = .TRUE.
10    CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      ISAVE1=ISPEC
      ISAVE2=IFFR
      CALL FILL (SP3,NPIX*NRAST,0.0)
C
      WRITE (IPRINT,1000)
      KEYB=ASKNO (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
15    IF (KEYB) THEN
         CALL IMSIZE (ITERM,IPRINT,NPIX,NRAST,IFPIX,ILPIX,IFRAST,
     &                ILRAST,IRC)
         IF (IRC.NE.0) GOTO 10
      ENDIF
C
      M=1
      IDEC=2
      ISPEC=ISAVE1
      IFFR=ISAVE2
      DO 70 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 60 J=1,IFRMAX
C
               IF ((FIRST).AND.(.NOT.KEYB)) THEN
                  FIRST=.FALSE.
                  JFRAME=IFFR
                  IF (ILFR.GT.IFFR) THEN
18                   WRITE (IPRINT,1040) JFRAME
                     CALL GETVAL(ITERM,VALUE,NVAL,IRC)
                     IF (IRC.EQ.1) GOTO 90
                     IF (IRC.EQ.2) GOTO 18
                     IF (NVAL.GT.0) JFRAME=INT(VALUE(1))
                     IF (JFRAME.LT.IFFR.OR.JFRAME.GT.ILFR) GOTO 18
                  ENDIF
                  CALL RFRAME (JUNIT,JFRAME,NPIX,NRAST,SP1,IRC)
                  IF (IRC.NE.0) GOTO 90
                  IF (.NOT.PUTIMAGE (SP1,NPIX,NRAST)) GOTO 90
               ENDIF
               SUM=0.0
               IF (M.EQ.1.AND.(.NOT.KEYB)) THEN
                  CALL FILL (SP2,NPIX*NRAST,0.0)
C
C========SELECT TYPE OF MASK
C
20                WRITE (IPRINT,1010) IDEC
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
30             ENDIF
C
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 90
               IFFR=IFFR+IFINC
C
               IF (IDEC.EQ.2) THEN
                  DO 55 K=IFRAST,ILRAST
                     N=(K-1)*NPIX
                     DO 50 L=IFPIX,ILPIX
                        SUM=SUM+SP1(N+L)
50                   CONTINUE
55                CONTINUE
                  IF (.NOT.KEYB) THEN
                     DO 57 K=1,NPIX*NRAST
                        SP3(K)=SP3(K)+SP2(K)
57                   CONTINUE
                  ENDIF
               ELSE
                  DO 56 K=1,NPIX*NRAST
                     IF (ABS(SP2(K)).GT.0.0) SUM=SUM+SP1(K)
                     SP3(K)=SP3(K)+SP2(K)
56                CONTINUE
               ENDIF
C
               IF (IFRAME.GT.1) SUMINT(M)=SUM
               M=M+1
60          CONTINUE
         CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
C
      IF (IFRAME.EQ.1) WRITE (IPRINT,1020) SUM
      IF (IFRAME.GT.1) THEN
         CALL APLOT(ITERM,IPRINT,SUMINT,SP2,IFRAME)
         CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
         IF (IRC.NE.0) GOTO 80
         CALL OPNNEW (KUNIT,IFRAME,1,1,OFNAM,IMEM,HEAD1,HEAD2,IRC)
         IF (IRC.NE.0) GOTO 80
         CALL WFRAME (KUNIT,1,IFRAME,1,SUMINT,IRC)
80       CALL FCLOSE (KUNIT)
      ENDIF
C
      WRITE (IPRINT,1030)
      FINISH=ASKNO (ITERM,IRC)
      IF (.NOT.FINISH) GOTO 15
C
      IF (.NOT.KEYB) THEN
         WRITE (IPRINT,*) 'Mask bitmap data'
         CALL OUTFIL (ITERM,IPRINT,PFNAM,HEAD1,HEAD2,IRC)
         IF (IRC.NE.0) GOTO 85
         CALL OPNNEW (LUNIT,NPIX,NRAST,1,PFNAM,IMEM,HEAD1,HEAD2,IRC)
         IF (IRC.NE.0) GOTO 85
         CALL WFRAME (LUNIT,1,NPIX,NRAST,SP3,IRC)
         IF (IRC.NE.0) GOTO 85
85       CALL FCLOSE (LUNIT)
      ENDIF
90    CALL FCLOSE (JUNIT)
      GOTO 10
C
999   RETURN
1000  FORMAT (' Do you want to use cursor selection [Y/N] [N]: ',$)
1010  FORMAT (' Enter [1] for polygon',/,
     &        '       [2] for rectangles',/,
     &        '       [3] for circles',/,
     &        '       [4] for ellipses',/,
     &        '       [5] for parallelograms',/,
     &        ' or <CTRL-Z> to end selection [',I1,']: ',$)
1020  FORMAT (' Integrated intensity is ',G13.5)
1030  FORMAT (' Do you want another selection [Y/N] [N]: ',$)
1040  FORMAT (' Enter frame nos. for image display [',I3,']: ',$) 
      END
