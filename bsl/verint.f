C     LAST UPDATE 11/06/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE VERINT
      IMPLICIT NONE
C
C PURPOSE: ALLOW USER TO SELECT A RECTANGULAR SECTION OF THE IMAGE,
C          INTEGRATE VERTICALLY OVER THAT SECTION, AND PLOT THE RESULT
C
      INCLUDE 'COMMON.FOR'
C
C Calls  11: WFRAME , RFRAME , IMSIZE , OUTFIL , FILL   , ASKNO
C            GETHDR , OPNFIL , OPNNEW , APLOT  , PUTIMAGE
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10)
      INTEGER      ISPEC,LSPEC,INCR,MEM,IFFR,ILFR,IFINC,IHFMAX
      INTEGER      IFRMAX,NPIX,NRAST,NFRAME,IMEM,I,J,K,L,IFRAME
      INTEGER      IRC,IFPIX,ILPIX,IFRAST,ILRAST,MPIX,M,N,KPIC,ITEMP
      INTEGER      JFRAST,JLRAST,INDX,JFRAME,NVAL
      LOGICAL      KEYB,LAYS,ASKNO,PUTIMAGE,FIRST
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
      LAYS=ASKNO (ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
C
      IF (.NOT.LAYS) THEN
         JFRAST=((NRAST/2)+1)+((NRAST/2)-JFRAST)
         JLRAST=((NRAST/2)+1)+((NRAST/2)-JLRAST)
         IF (JLRAST.LT.JFRAST) THEN
            ITEMP=JFRAST
            JFRAST=JLRAST
            JLRAST=ITEMP
         ENDIF
      ENDIF
      INDX=0
      CALL FILL (SP2,NPIX*NRAST,0.0)
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
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) THEN
                  CALL FCLOSE (JUNIT)
                  GOTO 10
               ENDIF
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
               MPIX=ILPIX-IFPIX+1
               DO 40 K=IFRAST,ILRAST
                  M=1
                  N=(K-1)*NPIX
                  DO 30 L=IFPIX,ILPIX
                     SP2(INDX+M)=SP2(INDX+M)+SP1(N+L)
                     M=M+1
30                CONTINUE
40             CONTINUE
               IF (.NOT.LAYS) THEN
                 DO 50 K=JFRAST,JLRAST
                     M=1
                     N=(K-1)*NPIX
                     DO 45 L=IFPIX,ILPIX
                        SP2(INDX+M)=SP2(INDX+M)+SP1(N+L)
                        M=M+1
45                   CONTINUE
50                CONTINUE
               ENDIF
               INDX=INDX+MPIX
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
