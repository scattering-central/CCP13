C     LAST UPDATE 28/03/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE PARINP
      IMPLICIT NONE
C
C Purpose: Get keyworded input for FTOREC
C
C Calls   0:
C Called by: FTOREC
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C
C Common arrays:
C
      REAL RDAT(2500*2500),RECSPA(1250*1250),STDEV(1250*1250)
      INTEGER NPOINT(1250*1250)
C
C Common scalars:
C
      REAL DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      REAL DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,RBAK,ZBAK
      REAL DELR,DELZ,DELSIG,DELD      
      REAL RMAXOPT
      REAL ABSBAS,ABSEML,ABSPAP,C0,PAPN,FILN
      INTEGER NFBEFR,NPBEFR
      INTEGER NXMIN,NXMAX,NYMIN,NYMAX,NRD,NZSIG
      INTEGER INTERM,OUTTERM,INDATA,OUTDATA
      LOGICAL DODSIG,NSTDEV,OTINP,INTERP
C
C Local variables:
C
      REAL CONST(10)
      INTEGER ITEM(20)
      CHARACTER*10 WORD(10)
      REAL STEP1,STEP2
      INTEGER NVAL,IRC,NWORD,I
      LOGICAL NEXT
C
C Common blocks:
C
      COMMON /ARRAYS/ RDAT,RECSPA,STDEV,NPOINT
      COMMON /TRANSF/ DIST,XC,YC,ROTX,ROTY,ROTZ,TILT,WAVE,XYRAT
      COMMON /RLIMIT/ DMIN,DMAX,SIGMIN,SIGMAX,RMIN,RMAX,ZMIN,ZMAX,
     &                RBAK,ZBAK
      COMMON /DELTAS/ DELR,DELZ,DELSIG,DELD
      COMMON /MAXOPT/ RMAXOPT
      COMMON /FILMAB/ ABSBAS,ABSEML,ABSPAP,NFBEFR,NPBEFR,C0,PAPN,FILN
      COMMON /ILIMIT/ NXMIN,NXMAX,NYMIN,NYMAX,NRD,NZSIG
      COMMON /STREAM/ INTERM,OUTTERM,INDATA,OUTDATA
      COMMON /LOGICS/ DODSIG,NSTDEV,OTINP,INTERP
C
C-----------------------------------------------------------------------
C
C========Open log file on unit 8
C
      OPEN(UNIT=8,FILE='FTOREC.LOG',STATUS='UNKNOWN')
C
C========Set up defaults for keyworded input
C
      OTINP = .FALSE.
      INTERP = .TRUE.
      DODSIG = .FALSE.
      WAVE = 1.5418
      DMIN = 0.0
      DMAX = 0.5
      RMIN = 0.0
      ZMIN = 0.0
      SIGMIN = 0.0
      SIGMAX = 90.0
      RBAK = 0.0
      ZBAK = 0.0
      STEP1 = 0.0
      STEP2 = 0.0
      NRD = 256
      NZSIG = 256
      XC = 256.0
      YC = 256.0
      RMAXOPT = 0.0
      DIST = 0.0
      XYRAT = 1.0
      TILT = 0.0
      ROTX = 0.0
      ROTY = 0.0
      ROTZ = 0.0
      NEXT = .TRUE.
C
C========Read keywords
C
      WRITE(8,'(1X,A)')'Start keyworded input'
 10   WRITE(6,'(1X,A,$)')'FTOREC> ' 
      WRITE(8,'(1X,A,$)')'FTOREC> ' 
      CALL RDCOMF(5,WORD,NWORD,CONST,NVAL,ITEM,10,10,10,IRC)
      IF(IRC.EQ.1)GOTO 9999
      IF(IRC.EQ.2)GOTO 10
      CALL WRTLOG(8,WORD,NWORD,CONST,NVAL,ITEM,10,10,IRC)
      IF(ITEM(1).EQ.0)GOTO 10
      IF(ITEM(1).EQ.1)THEN
         WRITE(6,2000)
         WRITE(8,2000)
         GOTO 10
      ENDIF
      DO 25 I=1,NWORD
         CALL UPPER(WORD(I),10)
 25   CONTINUE
      IF(WORD(1)(1:3).EQ.'RUN')THEN
         NEXT = .FALSE. 
      ELSEIF(WORD(1)(1:4).EQ.'POLA')THEN
         DODSIG = .TRUE.
      ELSEIF(WORD(1)(1:4).EQ.'CART')THEN
         DODSIG = .FALSE.
      ELSEIF(WORD(1)(1:4).EQ.'FILM')THEN
         OTINP = .TRUE. 
      ELSEIF(WORD(1)(1:4).EQ.'AVER')THEN
         INTERP = .FALSE. 
      ELSEIF(WORD(1)(1:4).EQ.'WAVE')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,2010)
            WRITE(8,2010)
            GOTO 10
         ENDIF
         WAVE = CONST(1)
      ELSEIF(WORD(1)(1:4).EQ.'LIMI')THEN
         DO 11 I=2,NWORD
            IF(ITEM(2*I-1).NE.1)THEN
               WRITE(6,2010)
               WRITE(8,2010)
               GOTO 10
            ENDIF
            IF(WORD(I)(1:4).EQ.'DMIN')THEN
               DMIN = CONST(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'DMAX')THEN
               DMAX = CONST(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'ZMIN')THEN
               ZMIN = CONST(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'RMIN')THEN
               RMIN = CONST(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'SMIN')THEN
               SIGMIN = CONST(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'SMAX')THEN
               SIGMAX = CONST(I-1)
            ELSE
               WRITE(6,2020)
               WRITE(8,2020)
            ENDIF
 11      CONTINUE
      ELSEIF(WORD(1)(1:4).EQ.'MAXO')THEN
         RMAXOPT = CONST(1)
      ELSEIF(WORD(1)(1:4).EQ.'BINS')THEN
         NRD = NINT(CONST(1))
         NZSIG = NINT(CONST(2))
      ELSEIF(WORD(1)(1:4).EQ.'DIST')THEN
         DIST = CONST(1)
      ELSEIF(WORD(1)(1:4).EQ.'CENT')THEN
         XC = CONST(1)
         YC = CONST(2)
      ELSEIF(WORD(1)(1:4).EQ.'RATI')THEN
         XYRAT = CONST(1)
      ELSEIF(WORD(1)(1:4).EQ.'STEP')THEN
         STEP1 = CONST(1)
         STEP2 = CONST(2)
      ELSEIF(WORD(1)(1:4).EQ.'BACK')THEN
         RBAK = CONST(1)
         ZBAK = CONST(2) 
      ELSEIF(WORD(1)(1:4).EQ.'ABSO')THEN
         DO 12 I=2,NWORD
            IF(ITEM(I+1).NE.1)THEN
               WRITE(6,2010)
               WRITE(8,2010)
               GOTO 10
            ENDIF
            IF(WORD(I)(1:4).EQ.'EMUL')THEN
               ABSEML = CONST(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'BASE')THEN
               ABSBAS = CONST(I-1)
            ELSEIF(WORD(I)(1:4).EQ.'PAPE')THEN
               ABSPAP = CONST(I-1)
            ELSE
               WRITE(6,2020)
               WRITE(8,2020)
            ENDIF
 12      CONTINUE
      ELSEIF(WORD(1)(1:4).EQ.'PREC')THEN
         DO 13 I=2,NWORD
            IF(ITEM(I+1).NE.1)THEN
               WRITE(6,2010)
               WRITE(8,2010)
               GOTO 10
            ENDIF
            IF(WORD(I)(1:4).EQ.'PAPE')THEN
               NPBEFR = NINT(CONST(I-1))
            ELSEIF(WORD(I)(1:4).EQ.'FILM')THEN
               NFBEFR = NINT(CONST(I-1))
            ELSE
               WRITE(6,2020)
               WRITE(8,2020)
            ENDIF
 13      CONTINUE
      ELSEIF(WORD(1)(1:4).EQ.'TILT')THEN
         TILT = CONST(1)
      ELSEIF(WORD(1)(1:4).EQ.'ROTA')THEN
         IF(NVAL.GE.1)ROTX = CONST(1)
         IF(NVAL.GE.2)ROTY = CONST(2)
         IF(NVAL.GE.3)ROTZ = CONST(3)
      ELSEIF(WORD(1)(1:4).EQ.'SIGM')THEN
         NSTDEV = .TRUE.
      ELSE
         WRITE(6,2020)
         WRITE(8,2020)
      ENDIF
      IF(NEXT)GOTO 10
C
C========Report consequences of input and work out remaining parameters
C
      IF(NRD.GT.1250.OR.NZSIG.GT.1250)THEN
         WRITE(OUTTERM,'(A)')'PARINP: Error - no. of bins > 1250  '
         WRITE(8,'(A)')'PARINP: Error - no. of bins > 1250  '
         STOP
      ENDIF
      IF(DODSIG)THEN 
         WRITE(6,1000)NRD,NZSIG
         WRITE(8,1000)NRD,NZSIG
         IF(STEP1.EQ.0.0)THEN
            DELD = DMAX/FLOAT(NRD)
         ELSE
            DELD = STEP1
         ENDIF
         IF(STEP2.EQ.0.0)THEN
            DELSIG = (SIGMAX-SIGMIN)/FLOAT(NZSIG)
         ELSE
            DELSIG = STEP2
         ENDIF
         WRITE(6,1010)DMIN,DMAX,DELD,SIGMIN,DELSIG
         WRITE(8,1010)DMIN,DMAX,DELD,SIGMIN,DELSIG
      ELSE
         WRITE(6,1020)NRD,NZSIG
         WRITE(8,1020)NRD,NZSIG
         IF(STEP1.EQ.0.0)THEN
            DELR = DMAX/FLOAT(MAX(NRD,NZSIG))
         ELSE
            DELR = STEP1
         ENDIF
         IF(STEP2.EQ.0.0)THEN
            DELZ = DMAX/FLOAT(MAX(NRD,NZSIG))
         ELSE
            DELZ = STEP2
         ENDIF
         WRITE(6,1030)DMIN,DMAX,RMIN,DELR,ZMIN,DELZ
         WRITE(8,1030)DMIN,DMAX,RMIN,DELR,ZMIN,DELZ
      ENDIF
      IF(OTINP)THEN
         WRITE(6,1040)
         WRITE(8,1040)
         WRITE(6,1050)ABSEML,ABSBAS,ABSPAP,NPBEFR,NFBEFR
         WRITE(8,1050)ABSEML,ABSBAS,ABSPAP,NPBEFR,NFBEFR
         IF(RMAXOPT.EQ.0.0)RMAXOPT = 255.0
      ELSE
         WRITE(6,1060)
         WRITE(8,1060) 
         IF(RMAXOPT.EQ.0.0)RMAXOPT = 1.0E+16 
      ENDIF
      IF(INTERP)THEN
         WRITE(6,1065)
         WRITE(8,1065)
      ELSE
         WRITE(6,1045)
         WRITE(8,1045)
      ENDIF
      IF(DIST.EQ.0.0)THEN
         WRITE(6,'(1X,A)')'PARINP: Warning - must use keyword DISTANCE'
         WRITE(8,'(1X,A)')'PARINP: Warning - must use keyword DISTANCE'
         GOTO 10 
      ENDIF
      WRITE(6,1070)RMAXOPT
      WRITE(8,1070)RMAXOPT
      WRITE(6,1080)WAVE,DIST,XC,YC
      WRITE(8,1080)WAVE,DIST,XC,YC
      WRITE(6,1090)XYRAT
      WRITE(8,1090)XYRAT
      WRITE(6,1100)ROTX,ROTY,ROTZ,TILT
      WRITE(8,1100)ROTX,ROTY,ROTZ,TILT
      IF(NSTDEV)THEN
         WRITE(6,1120)
         WRITE(8,1120)
      ELSE
         WRITE(6,1130)
         WRITE(8,1130)
      ENDIF
C
      RETURN
 9999 STOP ' USER STOP'
C
 1000 FORMAT(/1X,'Transforming to [D,Sigma] space'/
     &       1X,'No. of D bins:     ',I4/
     &       1X,'No. of Sigma bins: ',I4)
 1010 FORMAT(1X,'D min. ',F8.6,10X,'D max. ',F8.6,10X,'delta D ',F8.6/
     &       1X,'Sigma min. ',F10.6,10X,'delta Sigma ',F10.6)
 1020 FORMAT(/1X,'Transforming to [R,Z] space'/
     &       1X,'No. of R bins: ',I4/
     &       1X,'No. of Z bins: ',I4)
 1030 FORMAT(1X,'D min. ',F8.6,10X,'D max.  ',F8.6/
     &       1X,'R min. ',F8.6,10X,'delta R ',F8.6/
     &       1X,'Z min. ',F8.6,10X,'delta Z ',F8.6)
 1040 FORMAT(1X,'Processing film data') 
 1045 FORMAT(1X,'Image space pixels will be averaged into reciprocal',
     &       1X,'space bins')
 1050 FORMAT(1X,'Film absorption coefficients'/
     &       1X,'emulsion ',F8.6,5X,'base ',F8.6,5X,'paper ',F8.6/
     &       1X,'Number of preceding papers ',I2,5X,'film ',I2)
 1060 FORMAT(1X,'Processing area detector or image plate data') 
 1065 FORMAT(1X,'Reciprocal space bins will be interpolated from image',
     &       1X,'space pixels')
 1070 FORMAT(1X,'Maximum pixel value for conversion: ',G12.4)
 1080 FORMAT(1X,'Wavelength: ',F8.6,8X,'Specimen to detector distance:',
     &       1X,F10.3/1X,'Centre   X ',F8.2,5X,'Y ',F8.2)
 1090 FORMAT(1X,'Y:X ratio of pixel dimensions: ',F8.6)
 1100 FORMAT(1X,'Detector rotation ',F8.4/
     &       1X,'         twist    ',F8.4/
     &       1X,'         tilt     ',F8.4/
     &       1X,'Specimen tilt     ',F8.4)
 1120 FORMAT(1X,'Image containing standard deviations will be output')
 1130 FORMAT(1X,'No standard deviation image will be output')
 2000 FORMAT(1X,'***Keyword expected')
 2010 FORMAT(1X,'***Value expected')
 2020 FORMAT(1X,'***Unrecognised keyword')
      END
