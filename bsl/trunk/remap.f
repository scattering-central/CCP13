C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE REMAP
      IMPLICIT NONE
C
C Purpose: Remap an image according to a given set of remapping points
C          either/or in X & Y directions.
C
      INCLUDE 'COMMON.FOR'
C
C Calls  10: IMDISP , WFRAME , RFRAME , IMSIZE , OUTFIL
C            GETVAL , GETHDR , OPNFIL , OPNNEW , FILL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL    VALUE(10),XINC,XTOT,GRAD
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM,NCH
      INTEGER KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,I,J,K,II
      INTEGER L,M,NCHANX,NCHANY,NPNTX,NPNTY,IFIRST,ILAST,N,NN,NNN,INDEX
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
C NVAL   : Nos. of values entered at terminal
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    KPIC=0
      NPNTX=0
      NPNTY=0
      WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 999
      IF (IRC.EQ.2) GOTO 10
      IF (NVAL.GE.1) NPNTX=INT(VALUE(1))             
      IF (NVAL.GE.2) NPNTY=INT(VALUE(2))             
C
C========GET PIXEL REMAPPING DATA
C
      IF (NPNTX.GT.0) THEN
         WRITE (IPRINT,*) 'Pixel remapping file'
         CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,
     &                IFFR,ILFR,IFINC,IHFMAX,IFRMAX,NCHANX,NRAST,IRC)
         IF (IRC.NE.0) GOTO 999
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHANX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.NE.0) GOTO 140
         CALL RFRAME (JUNIT,IFFR,NCHANX,NRAST,SP1,IRC)
         IF (IRC.NE.0) GOTO 140
         CALL FCLOSE (JUNIT)
      ENDIF
C
C========GET RASTER REMAPPING DATA
C
      IF (NPNTY.GT.0) THEN
         WRITE (IPRINT,*) 'Raster remapping file'
         CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,
     &                IFFR,ILFR,IFINC,IHFMAX,IFRMAX,NCHANY,NRAST,IRC)
         IF (IRC.NE.0) GOTO 999
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHANY,NRAST,
     &                NFRAME,IRC)
         IF (IRC.NE.0) GOTO 140
         CALL RFRAME (JUNIT,IFFR,NCHANY,NRAST,SP4,IRC)
         IF (IRC.NE.0) GOTO 140
         CALL FCLOSE (JUNIT)
      ENDIF
C
C========GET HEADER & BINARY FILE ATTRIBUTES
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      DO 130 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 120 J=1,IFRMAX
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP2,IRC)
               IF (IRC.NE.0) GOTO 140
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
C========REMAP PIXELS
C
               CALL FILL (SP3,NPIX*NRAST,0.0)
               IF (NPNTX.NE.0) THEN
                  DO 50 K=1,NRAST
                     II=1
                     N=(K-1)*NPIX
                     DO 40 M=1,NCHANX+1
                        IF (M.EQ.1) THEN
                           IFIRST=1
                           ILAST=SP1(M)-1
                        ELSEIF (M.EQ.NCHANX+1) THEN
                           IFIRST=SP1(M-1)
                           ILAST=NPIX
                        ELSE
                           IFIRST=SP1(M-1)
                           ILAST=SP1(M)-1
                        ENDIF   
                        IF (M.EQ.1.OR.M.EQ.NCHANX+1) THEN
                           DO 20 L=IFIRST,ILAST
                              SP3(N+II)=SP2(N+L)
                              II=II+1
20                         CONTINUE
                        ELSE
                           NCH=ILAST-IFIRST+1
                           XINC=REAL(NCH-1)/REAL(NPNTX-1)
                           SP3(N+II)=SP2(N+IFIRST)
                           SP3(N+II+NPNTX-1)=SP2(N+ILAST)
                           XTOT=REAL(IFIRST)
                           DO 30 L=2,NPNTX-1
                              XTOT=XTOT+XINC
                              INDEX=IFIX(XTOT)
                              GRAD=SP2(N+INDEX+1)-SP2(N+INDEX)
                              SP3(N+II+L-1)=GRAD*(XTOT-REAL(INDEX))+
     &                                     SP2(N+INDEX)
30                         CONTINUE            
                           II=II+NPNTX
                        ENDIF
40                   CONTINUE
50                CONTINUE
                  IF (NPNTY.NE.0) THEN
                     DO 60 K=1,NPIX*NRAST
                        SP2(K)=SP3(K)
 60                  CONTINUE
                     CALL FILL (SP3,NPIX*NRAST,0.0)
                  ENDIF
               ENDIF
C
C========REMAP RASTERS
C
               IF (NPNTY.NE.0) THEN
                  II=1
                  DO 110 M=1,NCHANY+1
                     IF (M.EQ.1) THEN
                        IFIRST=1
                        ILAST=SP4(M)-1
                     ELSEIF (M.EQ.NCHANY+1) THEN
                        IFIRST=SP4(M-1)
                        ILAST=NRAST
                     ELSE
                        IFIRST=SP4(M-1)
                        ILAST=SP4(M)-1
                     ENDIF   
C
C========DON'T REMAP FIRST OR LAST PORTION
C
                     IF (M.EQ.1.OR.M.EQ.NCHANY+1) THEN
                        DO 80 K=IFIRST,ILAST
                           DO 70 L=1,NPIX
                              N=(K-1)*NPIX+L
                              NN=(II-1)*NPIX+L
                              SP3(NN)=SP2(N)
70                         CONTINUE
                           II=II+1
80                      CONTINUE
C
                     ELSE
                        NCH=ILAST-IFIRST+1
                        XINC=REAL(NCH-1)/REAL(NPNTY-1)
                        DO 100 L=1,NPIX
                           N=(IFIRST-1)*NPIX+L
                           NN=(II-1)*NPIX+L
                           SP3(NN)=SP2(N)
                           N=(ILAST-1)*NPIX+L
                           NN=(II+NPNTY-2)*NPIX+L
                           SP3(NN)=SP2(N)
                           XTOT=REAL(IFIRST)
                           DO 90 K=2,NPNTY-1
                              XTOT=XTOT+XINC
                              INDEX=IFIX(XTOT)
                              N=(INDEX-1)*NPIX+L
                              NN=(INDEX)*NPIX+L
                              NNN=(II+K-2)*NPIX+L
                              GRAD=SP2(NN)-SP2(N)
                              SP3(NNN)=GRAD*(XTOT-REAL(INDEX))+
     &                                     SP2(N)
90                         CONTINUE            
100                     CONTINUE
                        II=II+NPNTY
                     ENDIF
110               CONTINUE
               ENDIF
C
               IF (IFRAME.EQ.1) CALL IMDISP(ITERM,IPRINT,SP3,NPIX,NRAST)
               IF (KPIC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 140
                  CALL OPNNEW (KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 140
               ENDIF
               CALL WFRAME (KUNIT,KPIC,NPIX,NRAST,SP3,IRC)
               IF (IRC.NE.0) GOTO 140
120         CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
130   CONTINUE
140   CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
1000  FORMAT (' How many remapped points in X & Y [0,0]: ',$)
      END
