C     LAST UPDATE 11/06/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE CUT
      IMPLICIT   NONE
C
C PURPOSE: CUT PART OF AM IMAGE INTO SMALLER IMAGE.
C
      INCLUDE 'COMMON.FOR'
C
C Calls  13: WFRAME , RFRAME , IMSIZE , OUTFIL , FILL   , ASKNO
C            GETHDR , OPNFIL , OPNNEW , APLOT  , FIXREC , VARREC
C            PUTIMAGE
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10)
      INTEGER      ISPEC,LSPEC,INCR,MEM,IFFR,ILFR,IFINC,IHFMAX
      INTEGER      IFRMAX,NPIX,NRAST,NFRAME,IMEM,I,J,K,L,IFRAME
      INTEGER      IRC,IFPIX,ILPIX,IFRAST,ILRAST,MPIX,M,N,KPIC,MRAST
      INTEGER      IHBOX,IWBOX,NVAL
      LOGICAL      KEYB,FIXED,ASKNO,PUTIMAGE
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
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
10    KPIC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      WRITE (IPRINT,1000)
      KEYB=ASKNO (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
      IF (KEYB) THEN
         CALL IMSIZE (ITERM,IPRINT,NPIX,NRAST,IFPIX,ILPIX,IFRAST,
     &                ILRAST,IRC)
         IF (IRC.NE.0) GOTO 10
      ELSE
         WRITE (IPRINT,1010)
         FIXED=ASKNO (ITERM,IRC)
         IF (IRC.NE.0) GOTO 10
         IF (.NOT.FIXED) THEN
20          IWBOX=NPIX/4
            IHBOX=NRAST/4
            WRITE (IPRINT,1020) IWBOX,IHBOX
            CALL GETVAL (ITERM,VALUE,NVAL,IRC)
            IF (IRC.EQ.1) GOTO 10
            IF (IRC.EQ.2) GOTO 20
            IF (NVAL.GE.1) IWBOX=INT(VALUE(1))
            IF (NVAL.GE.2) IHBOX=INT(VALUE(2))
         ENDIF
      ENDIF
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
               IF (KPIC.EQ.1.AND.(.NOT.KEYB)) THEN
                  IF (.NOT.PUTIMAGE(SP1,NPIX,NRAST)) GOTO 80
                  IF (.NOT.FIXED) THEN
                     CALL FIXREC (NPIX,NRAST,IWBOX,IHBOX,IFPIX,IFRAST)
                     WRITE (IPRINT,1030) IFPIX,IFRAST
                     ILPIX=IFPIX+IWBOX-1
                     ILRAST=IFRAST+IHBOX-1
                  ELSE
                     CALL VARREC (NPIX,NRAST,IFPIX,ILPIX,IFRAST,ILRAST)
                     WRITE (IPRINT,1030) IFPIX,IFRAST,ILPIX,ILRAST
                  ENDIF
               ENDIF
C
               M=1
               MRAST=ILRAST-IFRAST+1
               MPIX=ILPIX-IFPIX+1
               DO 40 K=IFRAST,ILRAST
                  N=(K-1)*NPIX
                  DO 30 L=IFPIX,ILPIX
                     SP2(M)=SP1(N+L)
                     M=M+1
30                CONTINUE
40             CONTINUE
C
               IF (IFRAME.EQ.1) CALL IMDISP(ITERM,IPRINT,SP2,MPIX,MRAST)
               IF (KPIC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (KUNIT,MPIX,MRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               CALL WFRAME (KUNIT,KPIC,MPIX,MRAST,SP2,IRC)
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
1000  FORMAT (' Do you want to use cursor selection [Y/N] [N]: ',$) 
1010  FORMAT (' Do you want a fixed rectangle [Y/N] [N]: ',$)
1020  FORMAT (' Enter box size (width,height) [',I4,',',I4,']: ',$)
1030  FORMAT (' Selected values are: [',I4,',',I4,']')
1040  FORMAT (' Selected values are: [',I4,',',I4,'] & [',I4,',',I4,']')
      END
