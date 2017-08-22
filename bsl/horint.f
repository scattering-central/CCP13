C     LAST UPDATE 11/06/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE HORINT
      IMPLICIT NONE
C
C PURPOSE: ALLOW USER TO SELECT A RECTANGULAR SECTION OF THE IMAGE,
C          INTEGRATE HORIZONTALLY OVER THAT SECTION, AND PLOT THE RESULT
C
      INCLUDE 'COMMON.FOR'
C
C Calls  11: WFRAME , RFRAME , IMSIZE , OUTFIL , FILL  , PUTIMAGE
C            GETHDR , OPNFIL , OPNNEW , APLOT  , ASKNO
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10)
      INTEGER      ISPEC,LSPEC,INCR,MEM,IFFR,ILFR,IFINC,IHFMAX,ITEMP
      INTEGER      IFRMAX,NPIX,NRAST,NFRAME,IMEM,I,J,K,L,IFRAME,JLPIX
      INTEGER      IRC,IFPIX,ILPIX,IFRAST,ILRAST,MPIX,M,N,KPIC,JFPIX
      INTEGER      JFRAME,NVAL
      LOGICAL      KEYB,ROWS,ASKNO,PUTIMAGE,FIRST
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
 10   FIRST=.TRUE.
      KPIC=0
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
      ENDIF
C
      WRITE (IPRINT,1010) 
      ROWS=ASKNO (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
      IF (.NOT.ROWS) THEN
         JFPIX=((NPIX/2)+1)+((NPIX/2)-JFPIX)
         JLPIX=((NPIX/2)+1)+((NPIX/2)-JLPIX)
         IF (JLPIX.LT.JFPIX) THEN
            ITEMP=JFPIX
            JFPIX=JLPIX
            JLPIX=ITEMP
         ENDIF
      ENDIF
      CALL FILL (SP2,NPIX*NRAST,0.0)
      M=1
C
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
18                   WRITE (IPRINT,1050) JFRAME
                     CALL GETVAL(ITERM,VALUE,NVAL,IRC)
                     IF (IRC.EQ.1) THEN
                        CALL FCLOSE (JUNIT)
                        GOTO 10
                     ENDIF
                     IF (IRC.EQ.2) GOTO 18
                     IF (NVAL.GT.0) JFRAME=INT(VALUE(1))
                     IF (JFRAME.LT.IFFR.OR.JFRAME.GT.ILFR) GOTO 18
                  ENDIF
                  CALL RFRAME (JUNIT,JFRAME,NPIX,NRAST,SP1,IRC)
                  IF (IRC.NE.0) THEN
                     CALL FCLOSE (JUNIT)
                     GOTO 10
                  ENDIF
                  IF (.NOT.PUTIMAGE (SP1,NPIX,NRAST)) THEN
                     CALL FCLOSE (JUNIT)
                     GOTO 10
                  ENDIF
                  CALL VARREC (NPIX,NRAST,IFPIX,ILPIX,IFRAST,ILRAST)
                  WRITE (IPRINT,1020) IFPIX,IFRAST,ILPIX,ILRAST
               ENDIF
C
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) THEN
                  CALL FCLOSE (JUNIT)
                  GOTO 10
               ENDIF
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
               MPIX=ILRAST-IFRAST+1
               DO 40 K=IFRAST,ILRAST
                  N=(K-1)*NPIX
                  DO 30 L=IFPIX,ILPIX
                     SP2(M)=SP2(M)+SP1(N+L)
30                CONTINUE
                  IF (.NOT.ROWS) THEN
                     DO 35 L=JFPIX,JLPIX
                        SP2(M)=SP2(M)+SP1(N+L)
35                   CONTINUE
                  ENDIF
                  M=M+1
40             CONTINUE
C
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
      CALL APLOT (ITERM,IPRINT,SP2,SP3,MPIX)
      CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
      IF (IRC.EQ.0) THEN
         CALL OPNNEW (KUNIT,MPIX,IFRAME,1,OFNAM,IMEM,HEAD1,HEAD2,IRC)
         IF (IRC.EQ.0) THEN
            CALL WFRAME (KUNIT,1,MPIX,IFRAME,SP2,IRC)
            CALL FCLOSE (KUNIT)
         ENDIF
      ENDIF
      GOTO 10
999   RETURN
C
1000  FORMAT (' Do you want to use cursor selection [Y/N] [N]: ',$) 
1010  FORMAT (' Do you want to include mirrored section [Y/N] [N]: ',$)
1020  FORMAT (' Selected values are: [',I4,',',I4,'] & [',I4,',',I4,']')
1050  FORMAT (' Enter frame nos. for image display [',I3,']: ',$) 
      END
