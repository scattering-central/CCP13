C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE MERGE
      IMPLICIT NONE
C
C PURPOSE: MERGE SEVERAL SMALL IMAGE FILES INTO ONE LARGE IMAGE FILE.
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
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,I,J
      INTEGER JNDX,INDX,ITEMP,NSIDE,MPIX,MRAST,K,L
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
      NSIDE=INT(SQRT(REAL(IFRAME-1)))+1
      MPIX=NSIDE*NPIX
      MRAST=NSIDE*NRAST
C
      CALL FILL (SP2,MPIX*MRAST,0.0)
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
C========PACK IMAGE INTO LARGE IMAGE
C
               JNDX=1
               ITEMP=(KPIC-1)/NSIDE
               INDX=MPIX*ITEMP*NRAST+((KPIC-(ITEMP*NSIDE)-1)*NPIX)+1
               DO 25 K=1,NRAST
                  DO 20 L=1,NPIX
                     SP2(INDX)=SP1(JNDX)
                     INDX=INDX+1
                     JNDX=JNDX+1
20                CONTINUE
                  INDX=INDX+MPIX-NPIX
25             CONTINUE
C
60          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
70    CONTINUE
C
      CALL IMDISP(ITERM,IPRINT,SP2,MPIX,MRAST)
      CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
      IF (IRC.NE.0) GOTO 80
      CALL OPNNEW (KUNIT,MPIX,MRAST,1,OFNAM,IMEM,HEAD1,HEAD2,IRC)
      IF (IRC.NE.0) GOTO 80
      CALL WFRAME (KUNIT,1,MPIX,MRAST,SP2,IRC)
      IF (IRC.NE.0) GOTO 80
80    CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
      END
