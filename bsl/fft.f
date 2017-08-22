C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FFT
      IMPLICIT NONE
C
C Purpose: Calculate 2-d fourier transform of an image.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   9: IMDISP , WFRAME , RFRAME , OUTFIL , FFT2D
C            GETHDR , OPNFIL , OPNNEW , FILL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         WORK(2305),TEMP
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM,I,J,K
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,IDR(1024)
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,PFNAM
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
C OFNAM  : Modulus output header filename
C PFNAM  : Phase output header filename
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
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
C========OPEN FILE AND READ REQUESTED FRAME
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
               CALL FILL  (SP2,NPIX*NRAST,0.0)
               call timer ()
               CALL FFT2D (SP1,SP2,NPIX,1,-1,WORK,IDR)
               call timer ()
C
C========CALCULATE MODULUS & PHASE
C
               DO 20 K=1,NPIX*NRAST
                  TEMP=SP1(K)
                  SP1(K)=SQRT(SP1(K)*SP1(K)+SP2(K)*SP2(K))
                  IF (ABS(SP2(K)).GT.0.0.OR.ABS(TEMP).GT.0.0) THEN
                     SP2(K)=ATAN2 (SP2(K),TEMP)
                  ENDIF
20             CONTINUE
C
               IF (IFRAME.EQ.1) CALL IMDISP(ITERM,IPRINT,SP1,NPIX,NRAST)
               IF (KPIC.EQ.1) THEN
                  WRITE (IPRINT,*) 'Modulus data'
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               CALL WFRAME (KUNIT,KPIC,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 80
C
               IF (KPIC.EQ.1) THEN
                  WRITE (IPRINT,*) 'Phase data'
                  CALL OUTFIL (ITERM,IPRINT,PFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
                  CALL OPNNEW (LUNIT,NPIX,NRAST,IFRAME,PFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 80
               ENDIF
               CALL WFRAME (LUNIT,KPIC,NPIX,NRAST,SP2,IRC)
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
      END
