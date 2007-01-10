C     LAST UPDATE 20/06/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE SHIFT
      IMPLICIT   NONE
C
C PURPOSE: SHIFT AN IMAGE IN X AND/OR Y DIRECTIONS.
C
      INCLUDE 'COMMON.FOR'
C
C Calls  10: IMDISP , WFRAME , RFRAME , SHFLIM , OUTFIL
C            GETVAL , GETHDR , OPNFIL , OPNNEW , FILL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER      IFPIX,ILPIX,IFRAST,ILRAST,I,J,K,L,M,N,IXSH,IYSH
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
      CALL SHFLIM (ITERM,IPRINT,NPIX,NRAST,IFPIX,ILPIX,IFRAST,
     &             ILRAST,IXSH,IYSH,IRC)
      IF (IRC.NE.0) GOTO 10
C
      DO 250 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 240 J=1,IFRMAX
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 260
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
C========SHIFT RIGHT IN X DIRECTION
C
               CALL FILL (SP2,NPIX*NRAST,0.0)
               IF (IXSH.GT.0) THEN
                  DO 50 K=1,NRAST
                     DO 20 L=1,IFPIX-1
                        M=(K-1)*NPIX
                        SP2(M+L)=SP1(M+L)
20                   CONTINUE
                     DO 30 L=IFPIX+IXSH,ILPIX
                        M=(K-1)*NPIX
                        SP2(M+L)=SP1(M+L-IXSH)
30                   CONTINUE
                     DO 40 L=ILPIX+1,NPIX
                        M=(K-1)*NPIX
                        SP2(M+L)=SP1(M+L)
40                   CONTINUE
50                CONTINUE
C
C========SHIFT LEFT IN X DIRECTION
C
               ELSEIF (IXSH.LT.0) THEN
                  DO 90 K=1,NRAST
                     DO 60 L=NPIX,ILPIX+1,-1
                        M=(K-1)*NPIX
                        SP2(M+L)=SP1(M+L)
60                   CONTINUE
                     DO 70 L=ILPIX+IXSH,IFPIX,-1
                        M=(K-1)*NPIX
                        SP2(M+L)=SP1(M+L-IXSH)
70                   CONTINUE
                     DO 80 L=IFPIX-1,1,-1
                        M=(K-1)*NPIX
                        SP2(M+L)=SP1(M+L)
80                   CONTINUE
90                CONTINUE
               ELSE
                  DO 100 K=1,NRAST*NPIX
                     SP2(K)=SP1(K)
100               CONTINUE
               ENDIF
C
C========SHIFT DOWN IN Y DIRECTION
C
               CALL FILL (SP3,NPIX*NRAST,0.0)
               IF (IYSH.GT.0) THEN
                  DO 120 K=1,IFRAST-1
                     DO 110 L=1,NPIX
                        M=(K-1)*NPIX
                        SP3(M+L)=SP2(M+L)
110                  CONTINUE
120               CONTINUE
                  DO 140 K=IFRAST,ILRAST-IYSH
                     DO 130 L=1,NPIX
                        M=(K-1)*NPIX
                        N=(K-1+IYSH)*NPIX
                        SP3(N+L)=SP2(M+L)
130                  CONTINUE
140               CONTINUE
                  DO 160 K=ILRAST+1,NRAST
                     DO 150 L=1,NPIX
                        M=(K-1)*NPIX
                        SP3(M+L)=SP2(M+L)
150                  CONTINUE
160               CONTINUE
C
C========SHIFT UP IN Y DIRECTION
C
               ELSEIF (IYSH.LT.0) THEN
                  DO 180 K=NRAST,ILRAST+1,-1
                     DO 170 L=1,NPIX
                        M=(K-1)*NPIX
                        SP3(M+L)=SP2(M+L)
170                  CONTINUE
180               CONTINUE
                  DO 200 K=ILRAST,IFRAST-IYSH,-1
                     DO 190 L=1,NPIX
                        M=(K-1)*NPIX
                        N=(K-1+IYSH)*NPIX
                        SP3(N+L)=SP2(M+L)
190                  CONTINUE
200               CONTINUE
                  DO 220 K=IFRAST-1,1,-1
                     DO 210 L=1,NPIX
                        M=(K-1)*NPIX
                        SP3(M+L)=SP2(M+L)
210                  CONTINUE
220               CONTINUE
               ELSE
                  DO 230 K=1,NRAST*NPIX
                     SP3(K)=SP2(K)
230               CONTINUE
               ENDIF
C
               IF (IFRAME.EQ.1) CALL IMDISP(ITERM,IPRINT,SP3,NPIX,NRAST)
               IF (KPIC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 260
                  CALL OPNNEW (KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 260
               ENDIF
               CALL WFRAME (KUNIT,KPIC,NPIX,NRAST,SP3,IRC)
               IF (IRC.NE.0) GOTO 260
240         CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
250   CONTINUE
260   CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
      END
