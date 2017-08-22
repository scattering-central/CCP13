C     LAST UPDATE 20/06/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE INTERP
      IMPLICIT NONE
C
C PURPOSE: INTERPOLATE 2D IMAGE.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   8: IMDISP , WFRAME , RFRAME , OUTFIL
C            GETVAL , GETHDR , OPNFIL , OPNNEW
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL         VALUE(10),GRAD,XTOT,YTOT,XINC,YINC
      INTEGER      IRC,IFRAME,IHFMAX,IFRMAX,NPIX,NRAST,NFRAME,IMEM
      INTEGER      KPIC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER      I,J,K,L,M,N,M1,LL,MPIX,MRAST
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
C========GET NEW IMAGE SIZE
C
20    MPIX=512
      MRAST=512
      WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GE.1) MPIX=INT(VALUE(1))
      IF (NVAL.GE.2) MRAST=INT(VALUE(2))
      IF (MPIX*MRAST.GT.MAXDIM) THEN
         CALL ERRMSG ('Error: Invalid image size')
         GOTO 20
      ENDIF
C
      DO 90 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 80 J=1,IFRMAX
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,SP1,IRC)
               IF (IRC.NE.0) GOTO 100
               IFFR=IFFR+IFINC
               KPIC=KPIC+1
C
C========INTERPOLATE IN X
C
               DO 40 K=1,NRAST
                  XTOT=1.0
                  XINC=REAL(NPIX-1)/REAL(MPIX-1)
                  M=(K-1)*NPIX
                  N=(K-1)*MPIX
                  SP2(N+1)=SP1(M+1)
                  SP2(N+MPIX)=SP1(M+NPIX)
                  DO 30 L=2,MPIX-1
                     XTOT=XTOT+XINC
                     LL=INT(XTOT)
                     GRAD=SP1(M+LL+1)-SP1(M+LL)
                     SP2(N+L)=GRAD*(XTOT-REAL(LL))+SP1(M+LL)
30                CONTINUE            
40             CONTINUE
C
C========INTERPOLATE IN Y
C
               M=(NRAST-1)*MPIX
               N=(MRAST-1)*MPIX
               DO 50 K=1,MPIX
                  SP3(K)=SP2(K)
                  SP3(N+K)=SP2(M+K)
50             CONTINUE
               YTOT=1.0
               YINC=REAL(NRAST-1)/REAL(MRAST-1)
               DO 70 K=2,MRAST-1
                  N=(K-1)*MPIX
                  YTOT=YTOT+YINC
                  LL=INT(YTOT)
                  M=(LL-1)*MPIX
                  M1=LL*MPIX
                  DO 60 L=1,MPIX
                     GRAD=SP2(M1+L)-SP2(M+L)
                     SP3(N+L)=GRAD*(YTOT-REAL(LL))+SP2(M+L)
60                CONTINUE
70             CONTINUE
C
               IF (IFRAME.EQ.1) CALL IMDISP(ITERM,IPRINT,SP3,MPIX,MRAST)
               IF (KPIC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
                  CALL OPNNEW (KUNIT,MPIX,MRAST,IFRAME,OFNAM,IMEM,HEAD1,
     &                         HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
               ENDIF
               CALL WFRAME (KUNIT,KPIC,MPIX,MRAST,SP3,IRC)
               IF (IRC.NE.0) GOTO 100
80          CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
90    CONTINUE
100   CALL FCLOSE (KUNIT)
      CALL FCLOSE (JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter new image size [512,512]: ',$)
      END
