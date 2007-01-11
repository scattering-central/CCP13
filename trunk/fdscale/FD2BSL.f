C     LAST UPDATE 05/07/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PROGRAM FD2BSL
      IMPLICIT NONE
C
C Purpose: Convert CCP13 intensity output files to BSL format with one 
C          raster per layerline.
C
C Calls   4: RDCOMF , RECCEL , DCAL , CURV1 
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
       INTEGER NLLPX
       PARAMETER(NLLPX=4096)
C 
C Local arrays:
C
       REAL VALS(10),RINT(NLLPX),SIG(NLLPX),
     &      RL(2,NLLPX),CELL(6),X(512),Y(512),Y2(512),
     &      RCELL(6),D(NLLPX),BUF(1024*1024),WRK(512)
       INTEGER ITEM(20),HKM(3,NLLPX)
       CHARACTER*40 WORD(10)
C
C Local variables:
C
       REAL RESMIN,RESLIM,DMAX,DR,SIGO,XR,RMIN,RMAX,RINC,RLIM1,RLIM2,TEN
       INTEGER NW,NV,IRC,IREF,I,J,M,L,LMIN,LMAX,KLO,KHI
       INTEGER IFRAME,NPIX,NRAST,KPIC,KUNIT,IMEM 
       LOGICAL NEXT,BRAG,CONT,FEX,SIGMA
       CHARACTER*80 HEAD1,HEAD2
       CHARACTER*40 OFNAM,INFIL
C
C External functions:
C
       REAL DCAL,CURV2
       EXTERNAL DCAL,CURV2
C
       DATA IFRAME /1/, KPIC /1/, KUNIT /12/, IMEM /1/ , TEN /1.0/
C-----------------------------------------------------------------------
C
C========Open log file
C
      OPEN(UNIT=4,FILE='FD2BSL.LOG',STATUS='UNKNOWN')
      WRITE(6,1000)
      WRITE(4,1000)
C
C========Set up defaults
C
      NEXT = .TRUE.
      RESLIM = 0.0
      RESMIN = 0.0
      DMAX = 0.0
      SIGO = 1.5
      SIGMA = .FALSE.
      LMIN = 0
      LMAX = 0
      NPIX = 128
      NRAST = 0
      RMIN = 1.0
      RMAX = -1.0
      RLIM1 = 0.0
      RLIM2 = 0.0
C
C=======Read keyworded input
C
 10   WRITE(6,'(A8,$)')'FD2BSL> '
      CALL RDCOMF(5,WORD,NW,VALS,NV,ITEM,10,10,40,IRC)
      IF(IRC.EQ.2)GOTO 10
      IF(IRC.EQ.1)GOTO 9999
      CALL WRTLOG(4,WORD,NW,VALS,NV,ITEM,10,10,IRC)
      DO 20 I=1,NW
         CALL UPPER(WORD(I),40)
 20   CONTINUE
      IF(ITEM(1).EQ.0)GOTO 10
      IF(ITEM(1).NE.2)THEN
         WRITE(6,1010)
         WRITE(4,1010)
         GOTO 10
      ENDIF
C
      IF(WORD(1)(1:3).EQ.'RUN')THEN
         NEXT = .FALSE.
      ELSEIF(WORD(1)(1:4).EQ.'FILE')THEN
C
C========Read input filename
C
         WRITE(6,1030)
         WRITE(4,1030)
         READ(5,'(A)',END=9999)INFIL
         WRITE(4,'(A)')INFIL
         INQUIRE(FILE=INFIL,EXIST=FEX)
         IF(.NOT.FEX)THEN
            WRITE(6,1036)INFIL
            WRITE(4,1036)INFIL
            GOTO 10
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'PIXE')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            NPIX = NINT(VALS(1))
         ENDIF 
         IF(WORD(2)(1:4).EQ.'RAST')THEN
            IF(ITEM(4).NE.1)THEN
               WRITE(6,1020)
               WRITE(4,1020)
            ELSE
               NRAST = NINT(VALS(2))
            ENDIF 
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'RAST')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            NRAST = NINT(VALS(1))
         ENDIF 
         IF(WORD(2)(1:4).EQ.'PIXE')THEN
            IF(ITEM(4).NE.1)THEN
               WRITE(6,1020)
               WRITE(4,1020)
            ELSE
               NPIX = NINT(VALS(2))
            ENDIF 
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'RESO')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            RESMIN = VALS(1)
            RESLIM = VALS(2)
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'SIGM')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            SIGO = VALS(1)
         ENDIF
      ELSEIF(WORD(1)(1:3).EQ.'ESD')THEN
         SIGMA = .TRUE.
      ELSEIF(WORD(1)(1:4).EQ.'LIMI')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            IF(NV.GE.1)RLIM1 = VALS(1)
            IF(NV.GE.2)RLIM2 = VALS(2)
         ENDIF
      ELSE
         WRITE(6,1025)
         WRITE(4,1025)
      ENDIF
C
      IF(NEXT)GOTO 10
C
C========Open input file to determine Bragg/continuous etc  
C
      IREF = 0
      OPEN(UNIT=10,FILE=INFIL,STATUS='OLD',IOSTAT=IRC)
      IF(IRC.NE.0)THEN
         WRITE(6,1045)
         WRITE(4,1045)
         GOTO 9999 
      ENDIF
 30   CALL RDCOM(10,0,WORD,NW,VALS,NV,ITEM,0,IRC)
      IF(IRC.EQ.2)THEN
         WRITE(6,1050)
         WRITE(4,1050)
      ELSEIF(IRC.EQ.1)THEN
         GOTO 45 
      ENDIF
      IF(ITEM(1).EQ.2)THEN
         IF(WORD(1)(1:4).EQ.'BRAG')THEN
            BRAG = .TRUE.
            CONT = .FALSE.
         ELSEIF(WORD(1)(1:4).EQ.'CONT')THEN
            CONT = .TRUE.
            BRAG = .FALSE.
         ELSEIF(WORD(1)(1:4).EQ.'CELL')THEN
            DO 40 J=1,NV
               CELL(J) = VALS(J)
               IF(J.GT.3)CELL(J) = CELL(J)*ATAN(1.0)/45.0
 40         CONTINUE
         ELSEIF(WORD(1)(1:4).EQ.'DELT')THEN
            DR = VALS(1)
         ENDIF
      ELSEIF(ITEM(1).EQ.1)THEN
         IF(IREF.EQ.0.AND.BRAG)CALL RECCEL(CELL,RCELL)
         IREF = IREF + 1
         IF(IREF.GT.NLLPX)THEN
            WRITE(6,1055)NLLPX
            WRITE(4,1055)NLLPX
            GOTO 45
         ENDIF
         HKM(1,IREF) = NINT(VALS(1))
         HKM(2,IREF) = NINT(VALS(2))
         RL(2,IREF) = VALS(3) 
         RL(1,IREF) = VALS(4)
         HKM(3,IREF) = NINT(VALS(5))
         RINT(IREF) = VALS(6)
         SIG(IREF) = VALS(7)
         IF(BRAG)THEN
            D(IREF) = DCAL(RCELL,HKM(1,IREF),HKM(2,IREF),
     &                NINT(RL(2,IREF))) 
         ELSEIF(CONT)THEN
            D(IREF) = SQRT((RL(2,IREF)/CELL(1))**2
     &                      +RL(1,IREF)**2)
         ENDIF 
         IF(D(IREF).GT.DMAX)DMAX = D(IREF)
         IF(NINT(RL(2,IREF)).LT.LMIN)LMIN = NINT(RL(2,IREF))
         IF(NINT(RL(2,IREF)).GT.LMAX)LMAX = NINT(RL(2,IREF))
         IF(RL(1,IREF).LT.RMIN)RMIN = RL(1,IREF)
         IF(RL(1,IREF).GT.RMAX)RMAX = RL(1,IREF)
      ENDIF
      GOTO 30
 45   WRITE(6,1060)IREF
      WRITE(4,1060)IREF
      CLOSE(10)
      WRITE(6,1070)DMAX
      WRITE(4,1070)DMAX 
      IF(RESLIM.EQ.0.0)RESLIM = DMAX 
      IF(RMAX.GT.RESLIM)RMAX = RESLIM
      IF(NRAST.GT.0.AND.LMAX-LMIN+1.GT.NRAST)LMAX = LMIN + NRAST - 1
      IF(RLIM2.EQ.0.0)RLIM2 = RMAX
      RINC = (RLIM2-RLIM1)/FLOAT(NPIX-1)
      DO 70 L=LMIN,LMAX
         J = 0
         DO 50 I=1,IREF
            IF(NINT(RL(2,I)).EQ.L)THEN
               IF(SIG(I).GT.0.0.AND.RINT(I).GT.0.0)THEN
                  IF(RINT(I)/SIG(I).GT.SIGO.AND.
     &               D(I).LT.RESLIM.AND.D(I).GT.RESMIN)THEN
                     J = J + 1
                     X(J) = RL(1,I)
                     IF(SIGMA)THEN
                        Y(J) = SQRT(SIG(I)**2/HKM(3,I))
                     ELSE
                        Y(J) = RINT(I)/FLOAT(HKM(3,I))
                     ENDIF
                  ENDIF 
               ENDIF
            ENDIF
 50      CONTINUE
         CALL CURV1(J,X,Y,0.0,0.0,3,Y2,WRK,TEN,IRC)
c         CALL SPLINE(X,Y,J,1.0E30,1.0E30,Y2)
         KLO = 1
         KHI = J
         DO 60 I=1,NPIX 
            XR = FLOAT(I-1)*RINC + RLIM1
            M = (L-LMIN)*NPIX + I
            IF(XR.LT.X(1).OR.XR.GT.X(J))THEN
               BUF(M) = 0.0
            ELSE
               BUF(M) = CURV2(XR,J,X,Y,Y2,TEN)
c               CALL SPLINT(X,Y,Y2,J,XR,BUF(M),KLO,KHI)
c               IF(BUF(M).LT.0.0)THEN
c                  BUF(M) = ((XR-X(KLO))*Y(KLO)+(X(KHI)-XR)*Y(KHI))/
c     &                     (X(KHI)-X(KLO))
c               ENDIF
            ENDIF
 60      CONTINUE
 70   CONTINUE
      IF(NRAST.EQ.0)NRAST = LMAX - LMIN + 1
      CALL OUTFIL(5,6,OFNAM,HEAD1,HEAD2,IRC)
      IF(IRC.NE.0)GOTO 9999
      CALL OPNNEW(KUNIT,NPIX,NRAST,IFRAME,OFNAM,IMEM,HEAD1,HEAD2,IRC)
      IF(IRC.NE.0)GOTO 9999
      CALL WFRAME(KUNIT,KPIC,NPIX,NRAST,BUF,IRC)
      IF(IRC.NE.0)GOTO 9999
      STOP 'Normal stop'
 9999 STOP 'USER STOP'
C
 1000 FORMAT(1X,'FD2BSL: Fibre diffraction to BSL format'/
     &       1X,'Last update 05/07/96'/)
 1010 FORMAT(1X,'***Keyword expected')
 1020 FORMAT(1X,'***Value expected')
 1025 FORMAT(1X,'***Unrecognised keyword')
 1030 FORMAT(1X,'Enter input filename')
 1036 FORMAT(1X,'***Input file does not exist:   ',A40)
 1045 FORMAT(1X,'***Error opening input file:   ',A40)
 1050 FORMAT(1X,'FDSCALE: Error reading input file')
 1055 FORMAT(1X,'Number of reflections exceeds ',I4)
 1060 FORMAT(1X,'Number of reflections read from file:',I5) 
 1070 FORMAT(1X,'Maximum d*  ',F8.6)
 1140 FORMAT(1X,'Number of reflections written  ',I8)
      END                  
