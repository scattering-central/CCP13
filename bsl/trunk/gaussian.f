C     LAST UPDATE 16/04/91
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GAUSSIAN
      IMPLICIT NONE
C
C Purpose: Generate a 2-D gaussian function
C
      INCLUDE 'COMMON.FOR'
C
C Calls   5: WFRAME , GETVAL , IMDISP , OPNNEW , OUTFIL
C Called by: BSL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),XSQ,YSQ,SQNX,SQNY,RNX,RNY
      INTEGER NPIX,NRAST,IRC,IMEM,KPIC,IFRAME
      INTEGER I,J,K,ICENTX,ICENTY,NVAL
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 OFNAM
C
C IRC    : Return code
C IFRAME : Total nos. of frames
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NFRAME : Nos of time frames
C NVAL   : Nos. of numeric values entered
C
      DATA  IMEM/1/ , KPIC/1/ , IFRAME/1/
C
C-----------------------------------------------------------------------
      NPIX = 512
      NRAST = 512
 10   WRITE (IPRINT,1000) NPIX,NRAST
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 50
      IF (IRC.EQ.2) GOTO 10
      IF (NVAL.GT.0) NPIX=INT(VALUE(1))
      IF (NVAL.GT.1) NRAST=INT(VALUE(2))
C
      ICENTX=(NPIX/2)+1
      ICENTY=(NRAST/2)+1
15    WRITE (IPRINT,1010) ICENTX,ICENTY
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 50
      IF (IRC.EQ.2) GOTO 15
      IF (NVAL.GT.0) ICENTX=INT(VALUE(1))
      IF (NVAL.GT.1) ICENTY=INT(VALUE(2))
C
      RNX = 1.0
      RNY = 1.0
20    WRITE (IPRINT,1020)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 50
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GT.0) RNX=VALUE(1)
      IF (NVAL.GT.1) RNY=VALUE(2)
C
C========GENERATE THE FUNCTION
C
      SQNX = (1.0/RNX)*(1.0/RNX)
      SQNY = (1.0/RNY)*(1.0/RNY)
cx      print *,nx,ny,sqnx,sqny
      K=1
      DO 40 I=1,NRAST
         YSQ=(I-ICENTY)*(I-ICENTY)
         DO 30 J=1,NPIX
            XSQ=(J-ICENTX)*(J-ICENTX)
            SP3(K)=EXP(-(SQNX*XSQ + SQNY*YSQ))
cx            print *,k,xsq,ysq,(SQNX*XSQ + SQNY*YSQ),sp3(k)
            K=K+1
30       CONTINUE
40    CONTINUE
C
C==========DISPLAY & OUTPUT FUNCTION
C
      CALL IMDISP (ITERM,IPRINT,SP3,NPIX,NRAST)
      CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
      IF (IRC.NE.0) GOTO 50
      CALL OPNNEW (LUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,HEAD2,IRC)
      IF (IRC.NE.0) GOTO 50
      CALL WFRAME (LUNIT,KPIC,NPIX,NRAST,SP3,IRC)
50    CALL FCLOSE (LUNIT)
999   RETURN
C     
1000  FORMAT (' Enter nos of pixels and rasters for image',
     &        ' [',I4,',',I4,'] : ',$)
1010  FORMAT (' Enter x,y coordinate for image centre',
     &        ' [',I4,',',I4,'] : ',$)
1020  FORMAT (' Enter x-factor,yfactor: ',$)
      END
