C     LAST UPDATE 30/01/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE LAYERS(BUF,GSTOPN,VALS,NV)
      IMPLICIT NONE
C
C Purpose: Does line plots and peak fits.
C
C Calls   8: ASK    , PAPER  , PSPACE , FILNAM , FPLOT  , ERASE  ,
C            GREND  , RDCOMF
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
      INCLUDE 'FIT.COM'
C
C Arguments:
C
      REAL BUF(NPIX*NRAST)
      LOGICAL GSTOPN
      REAL VALS(10)
      INTEGER NV
C
C Local variables:
C
      REAL LBUF(MAXDIM)
      REAL*8 ASTDER(MAXPAR)
      REAL AREA,PI,X,Y,DX,DY,VECX,VECY,DIST,SHAPE,X0,Y0,VECXN,VECYN,
     &     DISTN
      INTEGER IVAL(10),ITEM(1)
      INTEGER I,J,K,L,M,IX,IY,IRC,KUNIT,NCHAN,N,NW
      CHARACTER*10 WORD
C
C FPLOT declarations:
C
      REAL*8 A(MAXPAR)
      REAL XPOS(MAXDIM)
      INTEGER NFRAMI,IFLAG
      LOGICAL REPT,FIT,HCOPY,INIT,XAXIS,AUTO
      CHARACTER*12 CTYPE(5)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      CHARACTER*80 NAMFIL
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C External function:
C
      REAL PSNINT,VGTINT
      EXTERNAL PSNINT,VGTINT
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      INTEGER PGBEG
      EXTERNAL PGBEG
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C Common block:
C
      INTEGER NPEAKS,NBAK,FEXP,NSELPK,KORIG
      LOGICAL LATCON
      DOUBLE PRECISION XORIG
      INTEGER FTYPE(20),VTABLE(MAXPAR)
      COMMON /FCOM  /NPEAKS,NBAK,FEXP,FTYPE,VTABLE,NSELPK
      COMMON /FCOM2 /XORIG,KORIG,LATCON
C
C Data:
C
      DATA  KUNIT/12/ , NFRAMI /0/
      DATA  PI /3.1415927/
      DATA  CTYPE /'Gaussian    ' , 'Lorentzian  ' , 'Pearson VII ' , 
     &             'Voigt       ' , 'Debye       '/
      DATA INIT /.FALSE./ , REPT /.FALSE./ , XAXIS /.FALSE./ , 
     &     AUTO /.FALSE./
C
C-----------------------------------------------------------------------
      IF(NLIN.EQ.0)RETURN
C
C========Initialize graphics
C
      IF(.NOT.GSTOPN)THEN
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c         CALL PAPER(1)
c         CALL PSPACE(0.1,0.9,0.1,0.9)
c         CALL GPSTOP(0)
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         IRC = PGBEG(0,'/XWINDOW',1,1)
         IF(IRC.NE.1)GOTO 9999
         CALL PGPAP(6.0,0.7)
         CALL PGASK(.FALSE.)
         CALL PGSCIR(1,15)
         CALL PGSVP(0.1,0.9,0.1,0.9)
         CALL PGPAGE
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         GSTOPN = .TRUE.
      ENDIF
      IF(NV.EQ.0)THEN
         IVAL(1) = 1
         IVAL(2) = NLIN
         NV = 2
      ELSE
         DO 25 I=1,NV
            IVAL(I) = NINT(VALS(I))
 25      CONTINUE
      ENDIF
C
C========Prompt for peak fitting
C
      FIT = .FALSE.
      CALL ASK('702 Do you want to fit the data',FIT,0) 
C
C========Prompt for hardcopy output
C
      HCOPY = .FALSE.
c++++++++GHOST+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      CALL ASK('Do you require hardcopy output',HCOPY,0)
c      IF(HCOPY)THEN
c         WRITE(6,1000)
c         READ(5,'(A80)',ERR=9999,END=9999)NAMFIL
c         CALL FILNAM(NAMFIL)
c      ENDIF
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C========No hardcopy at present
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      WRITE(6,'(/)')
C
C========Start main loop
C
      DO 60 I=1,NV,2
         IF(I+1.GT.NV)IVAL(I+1) = IVAL(I)
         DO 50 J=IVAL(I),IVAL(I+1)
C
C========Interpolate between end points
C
            VECX = XLINE(2,J) - XLINE(1,J)
            VECY = YLINE(2,J) - YLINE(1,J)
            DIST = SQRT(VECX*VECX+VECY*VECY)
            IF(INT(DIST).GT.MAXDIM)THEN
               NCHAN = MAXDIM
               DIST = FLOAT(NCHAN)
            ELSE
               NCHAN = INT(DIST)
            ENDIF
            IF(NCHAN.GT.0)THEN
               VECX = VECX/DIST
               VECY = VECY/DIST
            ELSE
               GOTO 50
            ENDIF
            IF(ABS(VECY).GT.0.0)THEN
               VECXN = 1.0
               VECYN = -VECX/VECY
               DISTN = SQRT(VECXN*VECXN+VECYN*VECYN)
               VECXN = VECXN/DISTN
               VECYN = VECYN/DISTN
            ELSE
               VECYN = 1.0
               VECXN = 0.0
            ENDIF
            DO 30 K=1,NCHAN
               X0 = XLINE(1,J) + FLOAT(K)*VECX
               Y0 = YLINE(1,J) + FLOAT(K)*VECY
               LBUF(K) = 0.0
               DO 27 L=-LWIDTH(J),LWIDTH(J)
                  X = X0 + FLOAT(L)*VECXN
                  Y = Y0 + FLOAT(L)*VECYN
                  IX = INT(X)
                  IY = INT(Y)
                  IF(IX.GE.1.AND.IX.LT.NPIX.AND.
     &               IY.GE.1.AND.IY.LT.NRAST)THEN
                     M = (IY-1)*NPIX + IX
                     DX = X - FLOAT(IX)
                     DY = Y - FLOAT(IY)
                     LBUF(K) = LBUF(K) + (1.0-DX)*(1.0-DY)*BUF(M)
     &                                 +       DX*(1.0-DY)*BUF(M+1)
     &                                 +       (1.0-DX)*DY*BUF(M+NPIX)
     &                                 +             DX*DY*BUF(M+NPIX+1)
                  ENDIF
 27            CONTINUE
 30         CONTINUE
C
C========Do plotting and fitting                   
C
            CALL FPLOT(LBUF,NCHAN,REPT,FIT,A,ASTDER,INIT,NFRAMI,
     &                 XPOS,XAXIS,AUTO,IFLAG)
C
C========Exit if GUI demands it (i.e. ^D received)
C
            IF(IFLAG.EQ.-2)GOTO 60
C
C========Interpret A and write out parameters
C
            IF(FIT.AND.IFLAG.EQ.0)THEN
               WRITE(KUNIT,1040)J,XLINE(1,J),YLINE(1,J),
     &                          XLINE(2,J),YLINE(2,J)
               WRITE(6,1040)J,XLINE(1,J),YLINE(1,J),
     &                      XLINE(2,J),YLINE(2,J)
               CALL FLUSH(6)
               M = 0
               DO 40 L=1,NPEAKS
                  IF(FTYPE(L).EQ.1.OR.FTYPE(L).EQ.2)THEN
                     A(M+3) = ABS(A(M+3))
                     IF(FTYPE(L).EQ.1)THEN
                        AREA = A(M+1)*A(M+3)*SQRT(PI)
                     ELSE
                        AREA = A(M+1)*A(M+3)*PI
                     ENDIF
                     SHAPE = 0.0
                     N = 3
                  ELSEIF(FTYPE(L).EQ.3.OR.FTYPE(L).EQ.4)THEN
                     IF(FTYPE(L).EQ.3)THEN
                        AREA = PSNINT(A(M+1),A(M+3),A(M+4))
                     ELSE
                        AREA = VGTINT(A(M+1),A(M+3),A(M+4))
                     ENDIF
                     SHAPE = A(M+4)
                     N = 4
                  ELSEIF(FTYPE(L).EQ.5)THEN
                     AREA = A(M+1)*A(M+3)*SQRT(PI)*8.0/3.0
                     SHAPE = 0.0
                     N = 3
                  ENDIF
                  WRITE(KUNIT,1050)L,(A(M+K),K=1,3),SHAPE,AREA,
     &                 CTYPE(FTYPE(L))
                  WRITE(6,1050)L,(A(M+K),K=1,3),SHAPE,AREA,
     &                 CTYPE(FTYPE(L))
                  WRITE(KUNIT,1055)(ASTDER(M+K),K=1,N)
                  WRITE(6,1055)(ASTDER(M+K),K=1,N)
                  CALL FLUSH(6)
                  M = M + N
 40            CONTINUE
C
C========Write out background polynomial coefficients
C
               WRITE(6,1060)NBAK,(K,K=0,4)
               WRITE(KUNIT,1060)NBAK,(K,K=0,4)
               WRITE(6,1070)(A(M+K),K=NBAK+1,1,-1)
               WRITE(KUNIT,1070)(A(M+K),K=NBAK+1,1,-1)
               WRITE(6,1075)(ASTDER(M+K),K=NBAK+1,1,-1)
               WRITE(KUNIT,1075)(ASTDER(M+K),K=NBAK+1,1,-1)
               IF(FEXP.GT.0)THEN
                  WRITE(6,1080)A(M+NBAK+2),A(M+NBAK+3)
                  WRITE(KUNIT,1080)A(M+NBAK+2),A(M+NBAK+3)
                  WRITE(6,1085)ASTDER(M+NBAK+2),ASTDER(M+NBAK+3)
                  WRITE(KUNIT,1085)ASTDER(M+NBAK+2),ASTDER(M+NBAK+3)
               ENDIF
               IF(LATCON)THEN
                  WRITE(6,1090)XORIG
                  WRITE(KUNIT,1090)XORIG
                  IF(KORIG.GT.0)THEN
                     WRITE(6,1095)ASTDER(KORIG)
                     WRITE(KUNIT,1095)ASTDER(KORIG)
                  ENDIF
               ENDIF
               CALL FLUSH(6)
               WRITE(6,1110)J
               CALL FLUSH(6)
            ENDIF
C
C========Wait until ready for next plot
C
            IF(.NOT.FIT)THEN
               WRITE(6,1100)
               CALL FLUSH(6)
               CALL RDCOMF(5,WORD,NW,VALS,NV,ITEM,1,1,10,IRC)
               CALL PGPAGE
               IF(IRC.NE.0)THEN
                  IFLAG = -2
                  GOTO 60
               ELSEIF(NW.GT.0)THEN
                  IF(WORD(1:2).EQ.'^D')THEN
                     IFLAG = -2
                     GOTO 60
                  ENDIF
               ENDIF
            ENDIF
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c            IF(HCOPY)CALL FILEND
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C========No hardcopy at present
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 50      CONTINUE
 60   CONTINUE
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(GSTOPN)THEN
         CALL PGEND
         GSTOPN = .FALSE.
      ENDIF
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      WRITE(6,1120)
      CALL FLUSH(6)
 9999 RETURN  
C
 1000 FORMAT(1X,'900',
     &       1X,'Enter gridfile name: ',$)
 1040 FORMAT(/1X,'200'/
     &       1X,'Line ',I3,':  (',F6.1,',',F6.1,')    to    (',
     &       F6.1,',',F6.1,')'/1X,8('-'),
     &       3X,'Height      Position     Width      Shape   '
     &       4X,'Integrated      Type')
 1050 FORMAT(/1X,'Peak ',I3,1X,5G12.5,4X,A12)
 1055 FORMAT(1X,'Std Err',2X,5G12.5)
 1060 FORMAT(/1X,'Background polynomial degree ',I3/
     &       1X,'200',6X,5(4X,'a',I1,6X))
 1070 FORMAT(1X,'Coeff',4X,5G12.5)
 1075 FORMAT(1X,'Std Err',2X,5G12.5)
 1080 FORMAT(/1X,'Exponential background'/
     &       10X,G12.5,' * exp(',G12.5,' * x)')
 1085 FORMAT(1X,'Std Err',2X,G12.5,7X,G12.5)
 1090 FORMAT(/1X,'Origin for lattice constraints = ',G12.5)
 1095 FORMAT(1X,'                       Std Err = ',G12.5)
 1100 FORMAT(1X,'806',
     &       1X,'Hit return for next frame or <ctrl-D> to exit'/
     &       1X,'200',
     &       1X,'Waiting to continue...')
 1110 FORMAT(1X,'202',
     &       1X,'Finished fitting line ',I3)
 1120 FORMAT(1X,'205',
     &       1X,'Closing plot window')
 2000 FORMAT(1X,'400 Numeric input expected')
      END                  
