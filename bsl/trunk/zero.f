C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE ZERO
      IMPLICIT NONE
C
C Purpose: Set all negative values in an image equal to 0.0
C
      INCLUDE 'COMMON.FOR'
C
C Calls   7: IMDISP , WFRAME , RFRAME , OUTFIL
C            GETHDR , OPNFIL , OPNNEW
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,I,J,K
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
      DO 70 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 60 J=1,IFRMAX
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) THEN
                  CALL FCLOSE (JUNIT)
                  IF (KPIC.NE.0) CALL FCLOSE (KUNIT)
                  GOTO 10
               ENDIF
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
               DO 20 K=1,NRAST*NPIX
                  IF (SP1(K).LT.0.0) SP1(K)=0.0
20             CONTINUE
C
               IF (IFRAME.EQ.1) CALL IMDISP(ITERM,IPRINT,SP1,NPIX,NRAST)
               IF (KPIC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) THEN
                     CALL FCLOSE (JUNIT)
                     GOTO 10
                  ENDIF
                  CALL OPNNEW (KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) THEN
                     CALL FCLOSE (JUNIT)
                     GOTO 10
                  ENDIF
               ENDIF
               CALL WFRAME (KUNIT,KPIC,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) THEN 
                  CALL FCLOSE (KUNIT)
                  CALL FCLOSE (JUNIT)
                  GOTO 10
               ENDIF
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
      CALL FCLOSE (KUNIT)
      GOTO 10
999   RETURN
C
      END
