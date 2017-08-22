C     LAST UPDATE 09/11/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE FPLOT(BUF,NBUF,REPEAT,FIT,A,ASTDER,INIT,NFRAMI,
     &                 XPOS,SIG,XAXIS,AUTO,IFLAG)
      IMPLICIT NONE
C
C Purpose: Plots 1-D data and allows fitting of peaks
C
C Calls  16: RDCOMF , MAP    , DEFPEN , SCALES , LINCOL , PTPLOT , 
C            ASK    , CURSOR , POSITN , JOIN   , MRQMIN , FUNCS  , 
C            CURVEO , PICNOW , PTJOIN
C Called by: 
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Include file:
C
      INCLUDE 'FIT.COM'
C
C Arguments:
C
      INTEGER NBUF,NPKPAR,NFRAMI,IFLAG
      REAL BUF(NBUF),XPOS(MAXDIM),SIG(MAXDIM)
      DOUBLE PRECISION A(MAXPAR),ASTDER(MAXPAR)
      LOGICAL REPEAT,FIT,INIT,XAXIS,AUTO
C
C Local variables:
C
      INTEGER I,J,K,IXMIN,IXMAX,NW,NV,IRC,MARKER,KCHAR,MA,MFIT,IXMINF,
     &        IXMAXF,NLSQ,TYPE,M,KPAR,NV1,NV2,ITMAX,ISTEP,ITMP
      INTEGER ITEM(20),LISTA(MAXPAR)
      REAL VAL(10),SFIT(MAXDIM),XFIT(MAXDIM),YFIT(MAXDIM)
      DOUBLE PRECISION COVAR(MAXPAR,MAXPAR),ALPHA(MAXPAR,MAXPAR)
      DOUBLE PRECISION DYDA(MAXPAR)
      CHARACTER*10 WRD(10)
      REAL XMIN,XMAX,YMIN,YMAX,XCURSR,YCURSR,TEMP,CHISQ,ALAMDA,ENDLAM
      REAL ASPECT,XMAP,XMINF,XMAXF,XMAPF,OCHISQ,CHITST,ESTD
      REAL PRECHI,FACTOR
      LOGICAL REPLY,RETRY,STEP,CONVGD
      CHARACTER*12 CTYPE(6)
      CHARACTER*40 STAT1,STAT2
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CHARACTER*1 CH
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C External function:
C
      CHARACTER*40 STATUS
      EXTERNAL STATUS
      EXTERNAL FUNCS
C
C Common block:
C
      INTEGER NPEAKS,NBAK,FEXP,NSELPK,KORIG
      LOGICAL LATCON
      INTEGER FTYPE(20),VTABLE(MAXPAR),FTABLE(MAXPAR),LTABLE(MAXPAR)
      DOUBLE PRECISION X1COM(MAXPAR),X2COM(MAXPAR),X3COM(MAXPAR)
      DOUBLE PRECISION XORIG
      DOUBLE PRECISION X1LIM(MAXPAR),X2LIM(MAXPAR)
      COMMON /FCOM  /NPEAKS,NBAK,FEXP,FTYPE,VTABLE,NSELPK
      COMMON /FCOM1 /X1COM,X2COM,X3COM,FTABLE
      COMMON /FCOM2 /XORIG,KORIG,LATCON
      COMMON /FCOM3 /X1LIM,X2LIM,LTABLE
C
C Save local variables for next call:
C
      SAVE
C
C Data:
C
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      DATA MARKER /243/
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      DATA MARKER /16/
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      DATA ASPECT /0.714/ , CHITST /0.1/ , FACTOR /10.0/
      DATA  CTYPE /'Gaussian    ' , 'Lorentzian  ' , 'Pearson-VII ' , 
     &             'Voigt       ' , 'Debye       ' , 'Dble-expntl '/
C-----------------------------------------------------------------------
C
C========Initialize plotting area
C
      IF(REPEAT)THEN
         IF(FIT)THEN
            XMIN = XMINF
            XMAX = XMAXF
            XMAP = XMAPF
            IXMIN = IXMINF
            IXMAX = IXMAXF
         ENDIF
      ELSE
         IF(.NOT.XAXIS)THEN
            DO 1 I=1,NBUF
               XPOS(I) = FLOAT(I)
 1          CONTINUE
         ENDIF
         XMIN = XPOS(1)
         XMAX = XPOS(NBUF)
         IXMIN = 1
         IXMAX = NBUF
      ENDIF
      RETRY = .FALSE.
 5    IF(.NOT.REPEAT.OR.RETRY)THEN
         IF(.NOT.RETRY)THEN
            WRITE(6,1000)IXMIN,IXMAX
            CALL FLUSH(6)
            CALL RDCOMF(5,WRD,NW,VAL,NV,ITEM,10,10,10,IRC)
            IF(IRC.NE.0)THEN
               IFLAG = -1
               RETURN
            ENDIF
            IF(NW.GT.0)THEN
               IF(WRD(1)(1:2).EQ.'^D')THEN
                  IFLAG = -2
                  RETURN
               ELSEIF(WRD(1)(1:2).EQ.'^d')THEN
                  IFLAG = -1
                  RETURN
               ELSE
                  WRITE(6,2010)
               ENDIF
            ENDIF
            IF(NV.GE.1)IXMIN = NINT(VAL(1))
            IF(NV.GE.2)IXMAX = NINT(VAL(2))
            XMIN = XPOS(IXMIN)
            XMAX = XPOS(IXMAX)
         ENDIF
         XMAP = XMIN + (XMAX-XMIN)*ASPECT
      ENDIF
      IF(.NOT.RETRY.AND..NOT.REPEAT)THEN
         YMIN = 1.0E+10
         YMAX = 1.0E-10
         DO 7 I=IXMIN,IXMAX
            IF(BUF(I).GT.YMAX)YMAX = BUF(I)
            IF(BUF(I).LT.YMIN)YMIN = BUF(I)
 7       CONTINUE
         IF(YMIN.LT.-0.99E+30)YMIN = 0.0
      ENDIF
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c 8    CALL MAP(XMIN,XMAP,YMIN,YMAX)
c      CALL WINDOW(XMIN,XMAX,YMIN,YMAX)
c      CALL DEFPEN
c      CALL FULL
c      CALL SCALES
c      CALL LINCOL(3)
c      CALL PTJOIN(XPOS,BUF,IXMIN,IXMAX,1)
c      CALL PICNOW
c      CALL DEFPEN
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 8    CALL PGBBUF
      CALL PGSWIN(XMIN,XMAX,YMIN,YMAX)
      CALL PGSCI(1)
      CALL PGSLS(1)
      CALL PGBOX('BCNST',0.0,0,'BCNSTV',0.0,0)
      CALL PGSCI(3)
      CALL PGLINE(IXMAX-IXMIN+1,XPOS(IXMIN),BUF(IXMIN))
      CALL PGSCI(1)
      CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(.NOT.RETRY.AND..NOT.AUTO)THEN
         WRITE(6,1005)YMIN,YMAX
         CALL FLUSH(6)
         CALL RDCOMF(5,WRD,NW,VAL,NV,ITEM,10,10,10,IRC)
         IF(IRC.NE.0)THEN
            IFLAG = -1
            RETURN
         ENDIF
         IF(NW.GT.0)THEN
            IF(WRD(1)(1:2).EQ.'^D')THEN
               IFLAG = -2
               RETURN
            ELSEIF(WRD(1)(1:2).EQ.'^d')THEN
               IFLAG = -1
               RETURN
            ELSE
               WRITE(6,2010)
            ENDIF
         ENDIF
         IF(NV.EQ.0)GOTO 9
         IF(NV.GE.1)YMIN = VAL(1)
         IF(NV.GE.2)YMAX = VAL(2)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL ERASE
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         CALL PGPAGE
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         GOTO 8
      ENDIF
 9    IF(FIT)THEN
C
C========Select range on graph for fitting
C
         IF(.NOT.REPEAT.AND..NOT.RETRY)THEN
            REPLY = .FALSE.
            CALL ASK('700 Cursor selection of fitting region',REPLY,0)
            IF(REPLY)THEN
               WRITE(6,1007)
               CALL FLUSH(6)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c               CALL CURSOR(XCURSR,YCURSR,KCHAR)
c               CALL POSITN(XCURSR,YMIN)
c               CALL JOIN(XCURSR,YMAX)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               CALL PGBBUF
               CALL PGBAND(6,0,0.0,0.0,XCURSR,YCURSR,CH)
               KCHAR=ICHAR(CH)
               CALL PGMOVE(XCURSR,YMIN)
               CALL PGDRAW(XCURSR,YMAX)
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               XMINF = XCURSR
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c               CALL CURSOR(XCURSR,YCURSR,KCHAR)
c               CALL POSITN(XCURSR,YMIN)
c               CALL JOIN(XCURSR,YMAX)
c               CALL PICNOW
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               CALL PGBAND(6,0,0.0,0.0,XCURSR,YCURSR,CH)
               KCHAR=ICHAR(CH)
               CALL PGMOVE(XCURSR,YMIN)
               CALL PGDRAW(XCURSR,YMAX)
               CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               XMAXF = XCURSR
               IF((XMINF.GT.XMAXF).EQV.(XPOS(NBUF).GT.XPOS(1)))THEN
                  TEMP = XMINF
                  XMINF = XMAXF
                  XMAXF = TEMP
               ENDIF
               XMAPF = XMINF + (XMAXF-XMINF)*ASPECT
            ELSE 
               XMINF = XMIN
               XMAXF = XMAX
               XMAPF = XMAP
            ENDIF
            IF(XAXIS)THEN
               CALL LOCATE(XPOS,MAXDIM,IXMIN,IXMAX,XMINF,IXMINF)
               CALL LOCATE(XPOS,MAXDIM,IXMIN,IXMAX,XMAXF,IXMAXF)
            ELSE
               IXMINF = NINT(XMINF)
               IXMAXF = NINT(XMAXF)
            ENDIF
            WRITE(6,1010)IXMINF,IXMAXF,XMINF,XMAXF
            CALL FLUSH(6)
            IF(REPLY)THEN
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c               CALL ERASE
c               CALL MAP(XMINF,XMAPF,YMIN,YMAX)
c               CALL WINDOW(XMINF,XMAXF,YMIN,YMAX)
c               CALL DEFPEN
c               CALL FULL
c               CALL SCALES
c               CALL LINCOL(3)
c               CALL PTJOIN(XPOS,BUF,IXMINF,IXMAXF,1)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               CALL PGBBUF
               CALL PGPAGE
               CALL PGSWIN(XMINF,XMAXF,YMIN,YMAX)
               CALL PGSCI(1)
               CALL PGSLS(1)
               CALL PGBOX('BCNST',0.0,0,'BCNSTV',0.0,0)
               CALL PGSCI(3)
               CALL PGLINE(IXMAXF-IXMINF+1,XPOS(IXMINF),BUF(IXMINF))
               CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ENDIF
         ENDIF
C
C========Initialize background order, peak type etc
C
         IF(.NOT.(REPEAT.OR.INIT).OR.RETRY)THEN
            NBAK = 3
            FEXP = 0
            TYPE = 1
            NPKPAR = 3
C
C========Initialize fitting parameters
C
            MA = 0
            NPEAKS = 0
            DO 10 I=1,MAXPAR
               A(I) = 0.0D0
               ASTDER(I) = 0.0D0
 10         CONTINUE
            XORIG = DBLE(XMINF)
            KORIG = 0
            LATCON = .FALSE.
         ENDIF
C
C========If initial A values have been taken from a file,
C========plot peaks and initialize MA and MFIT
C
         IF(INIT.AND..NOT.RETRY)THEN
            MA = 0
            DO 12 M=1,NPEAKS
               IF(FTYPE(M).EQ.1.OR.FTYPE(M).EQ.2)THEN
                  NPKPAR = 3
               ELSEIF(FTYPE(M).EQ.3.OR.FTYPE(M).EQ.4)THEN
                  NPKPAR = 4
               ELSEIF(FTYPE(M).EQ.5)THEN
                  NPKPAR = 3
               ELSEIF(FTYPE(M).EQ.6)THEN
                  NPKPAR = 4
               ENDIF
               MA = MA + NPKPAR
               NSELPK = M
               CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
 12         CONTINUE
            MFIT = MA + NBAK + FEXP + 1
            MA = MFIT
C
C========Initialize dependency list
C
            IF(.NOT.REPEAT)THEN
               DO 16 J=1,MFIT
                  VTABLE(J) = J
                  FTABLE(J) = 0
                  LTABLE(J) = 0
 16            CONTINUE
            ENDIF
         ENDIF
C     
C========Get user to estimate initial parameters
C
         IF((.NOT.REPEAT.AND..NOT.INIT).OR.RETRY)THEN
            WRITE(6,1015)
            WRITE(6,1020)
            CALL FLUSH(6)
            WRITE(6,1016)CTYPE(TYPE)
            CALL FLUSH(6)
            WRITE(6,1017)NBAK
            CALL FLUSH(6)
            WRITE(6,1018)
            CALL FLUSH(6)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            CALL LINCOL(2)
c 20         CALL CURSOR(XCURSR,YCURSR,KCHAR)
c            IF(KCHAR.EQ.108.OR.KCHAR.EQ.114)THEN
c               IF(KCHAR.EQ.108)THEN
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CALL PGSCI(2)
 20         CALL PGBAND(7,0,0.0,0.0,XCURSR,YCURSR,CH)
            KCHAR=ICHAR(CH)
            IF(KCHAR.EQ.65.OR.KCHAR.EQ.88)THEN
               IF(KCHAR.EQ.65)THEN
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  NPEAKS = NPEAKS + 1
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c                  CALL FULL
c                  CALL POSITN(XCURSR,YMIN)
c                  CALL JOIN(XCURSR,YMAX)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  CALL PGBBUF
                  CALL PGSLS(1)
                  CALL PGMOVE(XCURSR,YMIN)
                  CALL PGDRAW(XCURSR,YMAX)
                  CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  CALL LOCATE(XPOS,MAXDIM,IXMINF,IXMAXF,XCURSR,ITMP)
                  A(MA+1) = DBLE(BUF(ITMP)-YMIN)
                  A(MA+2) = DBLE(XCURSR)
                  TEMP = (YCURSR-YMIN)*(XMAPF-XMINF)/(YMAX-YMIN)
                  A(MA+3) = DBLE(ABS(TEMP))
                  IF(TYPE.EQ.3)A(MA+4) = 2.0D0
                  IF(TYPE.EQ.4)A(MA+4) = 0.1D0
                  IF(TYPE.EQ.6)A(MA+4) = A(MA+3)
                  FTYPE(NPEAKS) = TYPE
                  DO 22 J=1,NPKPAR 
                     VTABLE(MA+J) = MA + J
                     FTABLE(MA+J) = 0
                     LTABLE(MA+J) = 0
 22               CONTINUE
                  MA = MA + NPKPAR
               ELSE
                  WRITE(6,1030)NPEAKS
                  CALL FLUSH(6)
               ENDIF
               MFIT = MA + NBAK + FEXP + 1
               IF(MFIT.GT.MAXPAR)THEN
                  WRITE(6,1040)
                  CALL FLUSH(6)
                  IFLAG = -2
                  RETURN
               ENDIF
               DO 24 J=1,MFIT
                  IF(J.GT.MA.AND.J.LE.MA+NBAK+1)THEN
                     A(J) = 0.0D0
                     VTABLE(J) = J
                     FTABLE(J) = 0
                     LTABLE(J) = 0
                  ENDIF
 24            CONTINUE
               IF(NBAK.GE.0)A(MA+NBAK+1) = DBLE(YMIN)
               IF(FEXP.GT.0)THEN
                  A(MFIT-1) = 1.0D0
                  A(MFIT) = 0.0D0
                  VTABLE(MFIT-1) = MFIT - 1
                  FTABLE(MFIT-1) = 0
                  LTABLE(MFIT-1) = 0
                  VTABLE(MFIT) = MFIT
                  FTABLE(MFIT) = 0
                  LTABLE(MFIT) = 0
               ENDIF
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c               IF(KCHAR.EQ.108)THEN
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
               IF(KCHAR.EQ.65)THEN
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  NSELPK = NPEAKS
                  CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
                  GOTO 20
               ELSE
                  MA = MFIT
               ENDIF
            ELSEIF(KCHAR.GE.48.AND.KCHAR.LE.52)THEN
               NBAK = KCHAR - 48   
               WRITE(6,1017)NBAK
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.103)THEN
               TYPE = 1
               NPKPAR = 3
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.99)THEN
               TYPE = 2
               NPKPAR = 3
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.112)THEN
               TYPE = 3
               NPKPAR = 4
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.118)THEN
               TYPE = 4
               NPKPAR = 4
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.100)THEN
               TYPE = 5
               NPKPAR = 3
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.120)THEN
               TYPE = 6
               NPKPAR = 4
               WRITE(6,1016)CTYPE(TYPE)
               CALL FLUSH(6)
               GOTO 20
            ELSEIF(KCHAR.EQ.101)THEN
               FEXP = 2
               WRITE(6,1019)
               CALL FLUSH(6)
               GOTO 20
            ELSE
               GOTO 20
            ENDIF
         ENDIF
C
C========Draw first guess at peaks
C
         NSELPK = 0
         CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
         NSELPK = -1
         CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
         IF(.NOT.RETRY.OR.REPEAT.OR.INIT)THEN
            DO 30 J=1,NPEAKS
               NSELPK = J
               CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
 30         CONTINUE
         ENDIF
C
C========Allow user to set variables to a fixed value or tie them to 
C========other variables
C
         IF(.NOT.AUTO)THEN
            WRITE(6,1110)
            CALL FLUSH(6)
         ENDIF
         STEP = .FALSE.
 31      KPAR = 0
         IF(.NOT.AUTO)THEN
            WRITE(6,'(/1X,A3)')'805'
            CALL FLUSH(6)
         ENDIF
         DO 32 J=1,NPEAKS
            IF(FTYPE(J).EQ.1)THEN
               NPKPAR = 3
            ELSEIF(FTYPE(J).EQ.2)THEN
               NPKPAR = 3
            ELSEIF(FTYPE(J).EQ.3)THEN
               NPKPAR = 4
            ELSEIF(FTYPE(J).EQ.4)THEN
               NPKPAR = 4
            ELSEIF(FTYPE(J).EQ.5)THEN
               NPKPAR = 3
            ELSEIF(FTYPE(J).EQ.6)THEN
               NPKPAR = 4
            ENDIF
            IF(.NOT.AUTO)THEN
               WRITE(6,1041)J,CTYPE(FTYPE(J))
               CALL FLUSH(6)
               STAT1 = STATUS(VTABLE(KPAR+1),KPAR+1,
     &              LTABLE(KPAR+1),X1LIM(KPAR+1),X2LIM(KPAR+1))
               WRITE(6,1042)KPAR+1,A(KPAR+1),STAT1
               CALL FLUSH(6)
               STAT1 = STATUS(VTABLE(KPAR+2),KPAR+2,
     &              LTABLE(KPAR+2),X1LIM(KPAR+2),X2LIM(KPAR+2))
               WRITE(6,1043)KPAR+2,A(KPAR+2),STAT1
               CALL FLUSH(6)
               STAT1 = STATUS(VTABLE(KPAR+3),KPAR+3,
     &              LTABLE(KPAR+3),X1LIM(KPAR+3),X2LIM(KPAR+3))
               WRITE(6,1044)KPAR+3,A(KPAR+3),STAT1
               CALL FLUSH(6)
               IF(NPKPAR.EQ.4)THEN
                  STAT1 = STATUS(VTABLE(KPAR+4),KPAR+4,
     &                 LTABLE(KPAR+4),X1LIM(KPAR+4),X2LIM(KPAR+4))
                  WRITE(6,1045)KPAR+4,A(KPAR+4),STAT1
                  CALL FLUSH(6)
               ENDIF
            ENDIF
            KPAR = KPAR + NPKPAR
 32      CONTINUE
         IF(.NOT.AUTO)THEN
            WRITE(6,1070)NBAK
            CALL FLUSH(6)
            DO 33 K=KPAR+1,KPAR+NBAK+1
               STAT1 = STATUS(VTABLE(K),K,LTABLE(K),X1LIM(K),X2LIM(K))
               WRITE(6,1080)K,KPAR+NBAK+1-K,A(K),STAT1
               CALL FLUSH(6)
 33         CONTINUE
            K = KPAR + NBAK + 1
            IF(FEXP.GT.0)THEN
               WRITE(6,1090)
               CALL FLUSH(6)
               STAT1 = STATUS(VTABLE(K+1),K+1,LTABLE(K+1),X1LIM(K+1),
     &              X2LIM(K+1))
               STAT2 = STATUS(VTABLE(K+2),K+2,LTABLE(K+2),X1LIM(K+2),
     &              X2LIM(K+2))
               WRITE(6,1100)K+1,A(K+1),STAT1,K+2,A(K+2),STAT2
               CALL FLUSH(6)
            ENDIF
            IF(LATCON)THEN
               WRITE(6,1105)
               CALL FLUSH(6)
               STAT1 = STATUS(VTABLE(KORIG),KORIG,LTABLE(KORIG),
     &              X1LIM(KORIG),X2LIM(KORIG))
               WRITE(6,1107)KORIG,XORIG,STAT1
               CALL FLUSH(6)
            ENDIF
            WRITE(6,'(1X)')
            CALL FLUSH(6)
         ENDIF
 34      IF(.NOT.AUTO)THEN
            WRITE(6,'(1X,A3,1X,A7,$)')'200','SETUP: '
            CALL FLUSH(6)
            CALL RDCOMF(5,WRD,NW,VAL,NV,ITEM,10,10,10,IRC)
            IF(IRC.EQ.2)THEN
               IFLAG = -2
               RETURN
            ENDIF
         ELSE
            IRC = 1
         ENDIF
         IF(.NOT.STEP)THEN
C
C========Initialize Levenberg-Marquardt parameter and no. of steps
C
            ALAMDA = -1.0
            CONVGD = .FALSE.
            ISTEP = 1
         ENDIF
         IF(IRC.EQ.1)THEN
            STEP = .FALSE.
            ITMAX = ISTEP + 50
            GOTO 40
         ENDIF
         CALL UPPER(WRD(1),10)
         IF(WRD(1)(1:2).EQ.'^D')THEN
            IFLAG = -2
            RETURN
         ELSEIF(WRD(1)(1:3).EQ.'RUN')THEN
            STEP = .FALSE.
            ITMAX = ISTEP + 50
            GOTO 40
         ELSEIF(WRD(1)(1:3).EQ.'SET')THEN
            STEP = .FALSE.
            IF(NW.GT.1)THEN
               CALL UPPER(WRD(2),10)
               IF(WRD(2)(1:3).EQ.'ORI')THEN
                  IF(NV.GT.0)XORIG = DBLE(VAL(1))
                  IF(LATCON)THEN
                     IF(VTABLE(KORIG).NE.0)THEN
                        A(VTABLE(KORIG)) = XORIG
                        VTABLE(KORIG) = 0
                        LTABLE(KORIG) = 0
                        MFIT = MFIT - 1
                     ENDIF
                  ENDIF
               ENDIF
            ELSEIF(NV.GT.0)THEN
               NV1 = NINT(VAL(1))
               IF(VTABLE(NV1).EQ.NV1)MFIT = MFIT - 1
               IF(NV.GE.1)THEN
                  VTABLE(NV1) = 0
                  LTABLE(NV1) = 0
               ENDIF
               IF(NV.EQ.2)A(NV1) = DBLE(VAL(2))
               IF(NV1.EQ.KORIG)XORIG = A(NV1)
            ENDIF
         ELSEIF(WRD(1)(1:3).EQ.'INI')THEN
            STEP = .FALSE.
            IF(NV.GT.0)THEN
               NV1 = NINT(VAL(1))
               IF(NV.EQ.2.AND.VTABLE(NV1).GT.0)THEN
                  A(VTABLE(NV1)) = DBLE(VAL(2))
                  IF(NV1.EQ.KORIG)XORIG = A(NV1)
               ENDIF
               IF(NW.GT.1)THEN
                  CALL UPPER(WRD(2),10)
                  IF(WRD(2)(1:3).EQ.'ORI'.AND.NV.GE.1)THEN
                     XORIG = DBLE(VAL(1))
                     IF(LATCON)THEN
                        IF(VTABLE(KORIG).GT.0)A(VTABLE(KORIG)) = XORIG
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF(WRD(1)(1:3).EQ.'FRE')THEN
            STEP = .FALSE.
            IF(NV.GT.0)THEN
               NV1 = NINT(VAL(1))
               IF(VTABLE(NV1).NE.NV1)THEN
                  VTABLE(NV1) = NV1
                  MFIT = MFIT + 1
               ENDIF
               LTABLE(NV1) = 0
            ELSEIF(NW.GT.1)THEN
               CALL UPPER(WRD(2),10)
               IF(WRD(2)(1:3).EQ.'ORI')THEN
                  IF(VTABLE(KORIG).EQ.0)THEN
                     VTABLE(KORIG) = KORIG
                     MFIT = MFIT + 1
                  ENDIF
                  LTABLE(KORIG) = 0
               ENDIF
            ENDIF
         ELSEIF(WRD(1)(1:3).EQ.'TIE')THEN
            STEP = .FALSE.
            IF(NV.GE.1)NV1 = NINT(VAL(1))
            IF(NV.GE.2)THEN
               NV2 = NINT(VAL(2))
               IF(NV1.GT.NV2)THEN
                  IF(VTABLE(NV1).EQ.NV1)MFIT = MFIT - 1
                  VTABLE(NV1) = VTABLE(NV2)
                  LTABLE(NV1) = 0
               ELSEIF(NV2.GT.NV1)THEN                
                  IF(VTABLE(NV2).EQ.NV2)MFIT = MFIT - 1
                  VTABLE(NV2) = VTABLE(NV1)
                  LTABLE(NV2) = 0
                  NV1 = NV2
               ENDIF
               IF(NW.GT.1)THEN
                  CALL UPPER(WRD(2),10)
                  IF(WRD(2)(1:3).EQ.'HEX')THEN
                     FTABLE(NV1) = 1
                     X1COM(NV1) = DBLE(VAL(3))
                     X2COM(NV1) = DBLE(VAL(4))
                     IF(.NOT.LATCON)THEN
                        MA = MA + 1
                        KORIG = MA
                        A(KORIG) = XORIG
                        VTABLE(KORIG) = KORIG
                        LTABLE(KORIG) = 0
                        MFIT = MFIT + 1
                        LATCON = .TRUE.
                     ENDIF
                  ELSEIF(WRD(2)(1:3).EQ.'TET')THEN
                     FTABLE(NV1) = 2
                     X1COM(NV1) = DBLE(VAL(3))
                     X2COM(NV1) = DBLE(VAL(4))
                     IF(.NOT.LATCON)THEN
                        MA = MA + 1
                        KORIG = MA
                        A(KORIG) = XORIG
                        VTABLE(KORIG) = KORIG
                        LTABLE(KORIG) = 0
                        MFIT = MFIT + 1
                        LATCON = .TRUE.
                     ENDIF
                  ELSEIF(WRD(2)(1:3).EQ.'CUB')THEN
                     FTABLE(NV1) = 3
                     X1COM(NV1) = DBLE(VAL(3))
                     X2COM(NV1) = DBLE(VAL(4))
                     X3COM(NV1) = DBLE(VAL(5))
                     IF(.NOT.LATCON)THEN
                        MA = MA + 1
                        KORIG = MA
                        A(KORIG) = XORIG
                        VTABLE(KORIG) = KORIG
                        LTABLE(KORIG) = 0
                        MFIT = MFIT + 1
                        LATCON = .TRUE.
                     ENDIF
                  ENDIF
               ENDIF
            ELSEIF(NV.EQ.1)THEN
               IF(NW.EQ.2)THEN
                  CALL UPPER(WRD(2),10)
                  IF(WRD(2)(1:3).EQ.'ORI')THEN
                     IF(VTABLE(NV1).EQ.NV1)MFIT = MFIT - 1
                     VTABLE(NV1) = VTABLE(KORIG)
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF(WRD(1)(1:3).EQ.'DEL')THEN
            STEP = .FALSE.
            IF(NV.GT.1)THEN
               NV1 = NINT(VAL(1))
               IF(VTABLE(NV1).GT.0)THEN
                  NV2 = VTABLE(NV1)
                  LTABLE(NV2) = 1
                  IF(NV.EQ.2)THEN
                     X1LIM(NV2) = MIN(A(NV2)-DBLE(VAL(2)),
     &                                 A(NV2)+DBLE(VAL(2)))
                     X2LIM(NV2) = MAX(A(NV2)-DBLE(VAL(2)),
     &                                A(NV2)+DBLE(VAL(2)))
                  ELSE
                     X1LIM(NV2) = MIN(VAL(2),VAL(3))
                     X2LIM(NV2) = MAX(VAL(2),VAL(3))
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF(WRD(1)(1:3).EQ.'PLO')THEN
            STEP = .FALSE.
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            CALL ERASE
c            CALL DEFPEN
c            CALL FULL
c            CALL SCALES
c            CALL LINCOL(3)
c            CALL PTJOIN(XPOS,BUF,IXMINF,IXMAXF,1)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CALL PGBBUF
            CALL PGPAGE
            CALL PGSCI(1)
            CALL PGSLS(1)
            CALL PGBOX('BCNST',0.0,0,'BCNSTV',0.0,0)
            CALL PGSCI(3)
            CALL PGLINE(IXMAXF-IXMINF+1,XPOS(IXMINF),BUF(IXMINF))
            CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            IF(NBAK.GE.0.OR.FEXP.GT.0)THEN
               NSELPK = -1
               CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
            ENDIF
            DO 38 K=1,NPEAKS
               NSELPK = K
               CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
 38         CONTINUE
            NSELPK = 0
            CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
         ELSEIF(WRD(1)(1:3).EQ.'STE')THEN
            STEP = .TRUE.
            ITMAX = ISTEP
            GOTO 40
         ELSEIF(WRD(1)(1:3).EQ.'PRI')THEN
            GOTO 31
         ELSE
            WRITE(6,2030)
            CALL FLUSH(6)
         ENDIF
         IF(.NOT.AUTO)GOTO 34
 40      K = 0
         DO 42 J=1,MA
            IF(VTABLE(J).EQ.J)THEN
               K = K + 1
               LISTA(K) = J
            ENDIF
 42      CONTINUE
         IF(.NOT.AUTO)THEN
            WRITE(6,1046)MFIT
            CALL FLUSH(6)
         ENDIF
C
C========Prepare for least-squares fit
C
         J = 0
         IF(LATCON)A(KORIG) = XORIG
         DO 45 I=IXMINF,IXMAXF
            J = J + 1
            XFIT(J) = XPOS(I)
            YFIT(J) = BUF(I)
            SFIT(J) = SIG(I)
 45      CONTINUE
         NLSQ = J
         NSELPK = 0
C
C========Do fitting 
C
         DO 50 I=ISTEP,ITMAX
            CALL MRQMIN(XFIT,YFIT,SFIT,NLSQ,A,MA,LISTA,MFIT,COVAR,ALPHA,
     &                  MAXPAR,CHISQ,FUNCS,ALAMDA)
C
C========Convergence test
C
            IF(I.GT.1)THEN
               IF(ALAMDA.LT.0.0)THEN
                  TEMP = (OCHISQ-CHISQ)*FLOAT(IXMAXF-IXMINF)/CHISQ
                  CHISQ = OCHISQ
                  ALAMDA = -ALAMDA
                  IF(ABS(TEMP).LT.CHITST)THEN
                     WRITE(6,1050)I
                     CALL FLUSH(6)
                     CONVGD = .TRUE.
                     GOTO 55
                  ENDIF
               ENDIF
            ENDIF
            OCHISQ = CHISQ
 50      CONTINUE
         WRITE(6,1060)I-1
         CALL FLUSH(6)
 55      IF(NLSQ.GT.MFIT)THEN
            ESTD = SQRT(CHISQ/FLOAT(NLSQ-MFIT))
         ELSE
            ESTD = 0.0
         ENDIF
         WRITE(6,1065)CHISQ,ESTD
         CALL FLUSH(6)
         IF(.NOT.STEP.AND.(CONVGD.OR.I.EQ.ITMAX+1))THEN
            ENDLAM = 0.0
            CALL MRQMIN(XFIT,YFIT,SIG,NLSQ,A,MA,LISTA,MFIT,COVAR,ALPHA,
     &           MAXPAR,CHISQ,FUNCS,ENDLAM) 
            DO 57 J=1,MA
               IF(VTABLE(J).EQ.J)THEN
                  ASTDER(J) = DBLE(ESTD)*SQRT(COVAR(J,J))
               ELSE
                  ASTDER(J) = 0.0D0
               ENDIF
 57         CONTINUE
            RETRY = .FALSE.
            IF(AUTO)THEN
               IF(CHISQ.GT.FACTOR*PRECHI)THEN
                  WRITE(6,2040)FACTOR
                  AUTO = .FALSE.
                  RETRY = .TRUE.
               ENDIF
            ENDIF
            PRECHI = CHISQ
         ENDIF
C
C========Plot results of fit
C
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL ERASE
c         CALL MAP(XMINF,XMAPF,YMIN,YMAX)
c         CALL WINDOW(XMINF,XMAXF,YMIN,YMAX)
c         CALL DEFPEN
c         CALL FULL
c         CALL SCALES
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         CALL PGBBUF
         CALL PGPAGE
         CALL PGSWIN(XMINF,XMAXF,YMIN,YMAX)
         CALL PGSCI(1)
         CALL PGSLS(1)
         CALL PGBOX('BCNST',0.0,0,'BCNSTV',0.0,0)
         CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         NSELPK = 0
         CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL LINCOL(3)
c         CALL PTPLOT(XPOS,BUF,IXMINF,IXMAXF,MARKER)
c         CALL PICNOW
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         CALL PGBBUF
         CALL PGSCI(3)
         CALL PGPT(IXMAXF-IXMINF+1,XPOS(IXMINF),BUF(IXMINF),MARKER)
         CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C========Plot background
C
         IF(NBAK.GE.0)THEN
            NSELPK = -1
            CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
         ENDIF
C
C========Plot individual peaks
C
         IF(NPEAKS.GT.1)THEN
            DO 110 J=1,NPEAKS
               NSELPK = J
               CALL PLPEAK(IXMINF,IXMAXF,XPOS,MA,NSELPK,A,DYDA)
 110        CONTINUE
         ENDIF
C
C========Return to setup prompt having done a step
C
         IF(STEP)THEN
            ISTEP = ISTEP + 1
            GOTO 34
         ENDIF
C
C========Give user the option to try again
C
         IF(.NOT.AUTO)CALL ASK('706 Try again',RETRY,0)
         IF(RETRY)THEN
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            CALL ERASE
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CALL PGPAGE
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            XMIN = XMINF
            XMAX = XMAXF
            GOTO 5
         ENDIF
      ELSE
         XMINF = XMIN
         XMAXF = XMAX
      ENDIF
      IFLAG = 0
9999  RETURN
C
 1000 FORMAT(1X,'803',
     &       1X,'First and last channels [',I4,',',I4,']: ',$) 
 1005 FORMAT(1X,'804',
     &       1X,'Min. and max. Y values [',G12.5,',',G12.5,']: ',$)
 1007 FORMAT(/1X,'600'/
     &       1X,'Position the cursor at the limits of the region'/
     &       1X,'Click on any mouse button to mark a limit'/
     &       1X,'200',
     &       1X,'Waiting for region selection...')
 1010 FORMAT(/1X,'200',
     &       1X,'Region selected'/
     &       1X,'Channels  [',I4,',',I4,']    X  [',G12.5,',',G12.5,']')     
 1015 FORMAT(/1X,'600'/
     &       1X,'Press keys while focus is in the GHOST window'//
     &       1X,'Peak type selection'/
     &       1X,'Gaussian ...................... g'/
     &       1X,'Cauchy (Lorentzian) ........... c'/
     &       1X,'Pearson VII ................... p'/
     &       1X,'Voigt ......................... v'/
     &       1X,'Debye ......................... d'/
     &       1X,'Double exponential ............ x'//
     &       1X,'Background polynomial degree .. 0 - 4'/
     &       1X,'Exponential background ........ e'/)
 1016 FORMAT(1X,'200',
     &       1X,'Current peak type is ',A12)
 1017 FORMAT(1X,'200',
     &       1X,'Current background polynomial order is ',I2)
 1018 FORMAT(1X,'200',
     &       1X,'No exponential background component'/)
 1019 FORMAT(1X,'200',
     &       1X,'Exponential background selected')
 1020 FORMAT(1X,'600'/
     &       1X,'Button 1 - Select peak position and width'/
     &       1X,'Position = X position of cursor'/
     &       1X,'Width    = Y position of cursor'/
     &       1X,'Button 3 - End selection'/)
 1030 FORMAT(/1X,'200',
     &       1X,'Number of peaks selected ',I3)
 1040 FORMAT(1X,'400',
     &       1X,'FPLOT: Error - too many parameters')
 1041 FORMAT(1X,'Peak ',I3,4X,A12)
 1042 FORMAT(1X,'Parameter ',I3,3X,'Height    ',G12.5,4X,A40)
 1043 FORMAT(1X,'Parameter ',I3,3X,'Position  ',G12.5,4X,A40)
 1044 FORMAT(1X,'Parameter ',I3,3X,'Width     ',G12.5,4X,A40)
 1045 FORMAT(1X,'Parameter ',I3,3X,'Shape     ',G12.5,4X,A40)
 1046 FORMAT(1X,'200',
     &       1X,'Total number of parameters to fit ',I3)
 1050 FORMAT(/1X,'200',
     &       1X,'Convergence achieved after ',I3,' iterations')
 1060 FORMAT(1X,'200',
     &       1X,'No convergence after ',I3,' iterations')
 1065 FORMAT(1X,'200',
     &       1X,'Chi-squared = ',G12.5,4X,'Standard Error = ',G12.5/)
 1070 FORMAT(/1X,'Polynomial background degree = ',I2)
 1080 FORMAT(1X,'Parameter ',I3,3X,'a',I1,8X,G12.5,4X,A40)
 1090 FORMAT(/1X,'Exponential background component')
 1100 FORMAT(1X,'Parameter ',I3,3X,'Coeff     ',G12.5,4X,A40/
     &       1X,'Parameter ',I3,3X,'Decay     ',G12.5,4X,A40)
 1105 FORMAT(/1X,'Lattice constraints')
 1107 FORMAT(1X,'Parameter ',I3,3X,'Origin    ',G12.5,4X,A40)
 1110 FORMAT(/1X,'900',
     &       1X,'Set up parameter values/dependencies. Use keywords - '/
     &       1X,'TIE refinement of two parameters together',
     &       5X,'e.g. tie 6 3 or tie 5 2 hex 1 1'/
     &       1X,'SET the value of a parameter             ',
     &       5X,'e.g. set 2 50.0 or set origin 10.0'/
     &       1X,'INItialize the value of a parameter      ',
     &       5X,'e.g. ini 1 1000.0 or ini origin 10.0'/
     &       1X,'FREe a parameter for refinement          ',
     &       5X,'e.g. fre 2 or fre origin'/
     &       1X,'DELta sets range of a free parameter     ',
     &       5X,'e.g. del 2 0.5 or del origin 1.0'/
     &       1X,'PLOt to replot with current values'/
     &       1X,'STEp to perform one fitting iteration ',
     &       1X,'(hit return for subsequent steps)'/
     &       1X,'PRInt to print current parameters'/
     &       1X,'RUN or <CTRL-D> to exit set-up and run')
 2000 FORMAT(1X,'Enter background polynomial order [',I2,']: ',$)
 2010 FORMAT(1X,'400 Numeric input expected')
 2030 FORMAT(1X,'Unrecognised command')
 2040 FORMAT(1X,'300',
     &       1X,'Current Chi-squared > ',F5.1,2X,'times previous')
      END                  


      CHARACTER*40 FUNCTION STATUS(KDEP,K,LTAB,X1,X2)
      IMPLICIT NONE
      INTEGER KDEP,K,LTAB
      DOUBLE PRECISION X1,X2
      IF(KDEP.GT.0)THEN
         IF(KDEP.EQ.K)THEN
            IF(LTAB.EQ.0)THEN
               WRITE(STATUS,1000)
            ELSE
               WRITE(STATUS,1005)X1,X2
            ENDIF
         ELSE
            WRITE(STATUS,1010)KDEP
         ENDIF
      ELSE
         WRITE(STATUS,1020)
      ENDIF
      RETURN
 1000 FORMAT('Free      ',30X)
 1005 FORMAT('Range   ',G12.5,'   to   ',G12.5)
 1010 FORMAT('Tied to',I3,30X)
 1020 FORMAT('Set       ',30X)
      END


      SUBROUTINE PLPEAK(IXMINF,IXMAXF,XPOS,MA,NPK,A,DYDA)
      IMPLICIT NONE
      INCLUDE 'FIT.COM'
      INTEGER IXMINF,IXMAXF,MA,NPK
      DOUBLE PRECISION A(MA),DYDA(MA)
      INTEGER I
      DOUBLE PRECISION X,Y
      REAL XPOS(MAXDIM),YFIT(MAXDIM)
      DO 10 I=IXMINF,IXMAXF
         X = DBLE(XPOS(I))
         CALL FUNCS(X,A,Y,DYDA,MA)
         YFIT(I) = SNGL(Y)
 10   CONTINUE
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CALL PGBBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(NPK.GE.0)THEN
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL LINCOL(2)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         CALL PGSCI(2)
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         IF(NPK.EQ.0)THEN
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            CALL FULL
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CALL PGSLS(1)
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         ELSE
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            CALL BROKEN(4,15,4,15)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            CALL PGSLS(4)
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         ENDIF
      ELSE
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL LINCOL(4)
c         CALL BROKEN(10,10,10,10)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         CALL PGSCI(4)
         CALL PGSLS(2)
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ENDIF
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      CALL CURVEO(XPOS,YFIT,IXMINF,IXMAXF)
c      CALL PICNOW
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CALL PGLINE(IXMAXF-IXMINF+1,XPOS(IXMINF),YFIT(IXMINF))
      CALL PGEBUF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      RETURN
      END


      SUBROUTINE LOCATE(XX,N,JLO,JHI,X,J)
      IMPLICIT NONE
      INTEGER N
      REAL XX(N),X
      INTEGER JLO,JHI,J
      INTEGER JL,JU,JM
      JL = JLO - 1
      JU = JHI + 1
 10   IF(JU-JL.GT.1)THEN
         JM = (JU+JL)/2
         IF((XX(JHI).GT.XX(JLO)).EQV.(X.GT.XX(JM)))THEN
            JL = JM
         ELSE
            JU = JM
         ENDIF
         GOTO 10
      ENDIF
      J = JL
      IF(J.EQ.0)J = 1
      RETURN
      END













