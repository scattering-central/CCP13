C     LAST UPDATE 16/10/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PROGRAM SAMPLE
      IMPLICIT NONE
C
C Purpose: Re-sample CCP13  intensity output data by fitting either to
C          the Shannon sampling points or (more efficiently) to the
C          Fourier-Bessel sampling positions. 
C
C Calls   2: RDCOM  , ROOTJ
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
       INTEGER NLLPX,MAXRTS,MAXLPT
       PARAMETER(NLLPX=4096,MAXRTS=128,MAXLPT=512)
       REAL PI,TOL
       PARAMETER(PI=3.141592654,TOL=1.0E-05)
C 
C Local arrays:
C
       REAL VALS(10),RINT(NLLPX),SIG(NLLPX),RL(2,NLLPX),D(NLLPX),
     &      ROOTS(MAXRTS),Y(MAXLPT),FB(MAXLPT,MAXRTS),V(MAXRTS,MAXRTS),
     &      W(MAXRTS),CVM(MAXRTS,MAXRTS),X(MAXRTS)
       INTEGER ITEM(20),INDEX(MAXLPT)
       CHARACTER*40 WORD(10)
C
C Local variables:
C
       REAL RESMIN,RESLIM,DMAX,DR,SIGO,RMIN,RMAX,CELL,A,SIGTMP,
     &      TMP,CHISQ,WMAX,THRESH,XMAX,XSCALE
       INTEGER NW,NV,IRC,IREF,I,J,M,L,LMIN,LMAX,NDATA,NSVREJ,NSTART,NMAX
       INTEGER KUNIT,N,K,NR,UHELIX,THELIX,LACTUAL,LSCALE,NSTACK
       LOGICAL NEXT,FEX 
       CHARACTER*40 OFNAM,INFIL
C
C External functions:
C
       INTEGER NMIN
       REAL KCOF
       EXTERNAL NMIN,KCOF
C
C Data:
C
       DATA KUNIT /12/
C-----------------------------------------------------------------------
C
C========Open log file
C
      OPEN(UNIT=4,FILE='SAMPLE.LOG',STATUS='UNKNOWN')
      WRITE(6,1000)
      WRITE(4,1000)
C
C========Set up defaults
C
      NEXT = .TRUE.
      RESLIM = 0.0
      RESMIN = 0.0
      DMAX = 0.0
      SIGO = 0.0
      LMIN = 0
      LMAX = 0
      UHELIX = 1
      THELIX = 1
      NSTART = 1
      NSTACK = 1
      LSCALE = 1
      XSCALE = 5.0
      A = 100.0
C
C=======Read keyworded input
C
 10   WRITE(6,'(A8,$)')'SAMPLE> '
      CALL RDCOM(5,6,WORD,NW,VALS,NV,ITEM,4,IRC) 
      IF(IRC.EQ.2)GOTO 10
      IF(IRC.EQ.1)GOTO 9999
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
         WRITE(6,1035)
         WRITE(4,1035)
         READ(5,'(A)',END=9999)OFNAM
         WRITE(4,'(A)')OFNAM
         OPEN(UNIT=KUNIT,FILE=OFNAM,STATUS='UNKNOWN',IOSTAT=IRC)
         IF(IRC.NE.0)THEN
            WRITE(6,1046)OFNAM
            WRITE(4,1046)OFNAM
            GOTO 9999
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
      ELSEIF(WORD(1)(1:4).EQ.'EXTR')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            XSCALE = VALS(1)
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'HELI')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            IF(NV.GE.1)UHELIX = NINT(VALS(1))
            IF(NV.GE.2)THELIX = NINT(VALS(2))
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'STAR')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            NSTART = NINT(VALS(1))
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'STAC')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            NSTACK = NINT(VALS(1))
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'RADI')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            A = VALS(1)
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'SCAL')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            LSCALE = NINT(VALS(1))
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
         WRITE(6,1045)INFIL
         WRITE(4,1045)INFIL
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
            WRITE(6,2000)
            WRITE(4,2000)
            STOP
         ELSEIF(WORD(1)(1:4).EQ.'CELL')THEN
            CELL = VALS(1)
            WRITE(KUNIT,1047)CELL
         ELSEIF(WORD(1)(1:4).EQ.'DELT')THEN
            DR = VALS(1)
         ENDIF
      ELSEIF(ITEM(1).EQ.1)THEN
         IREF = IREF + 1
         IF(IREF.GT.NLLPX)THEN
            WRITE(6,1055)NLLPX
            WRITE(4,1055)NLLPX
            GOTO 45
         ENDIF
         RL(2,IREF) = VALS(3) 
         RL(1,IREF) = VALS(4)
         RINT(IREF) = VALS(6)
         SIG(IREF) = VALS(7)
         D(IREF) = SQRT((RL(2,IREF)/CELL)**2
     &                  +RL(1,IREF)**2)
         IF(D(IREF).GT.DMAX)DMAX = D(IREF)
         IF(NINT(RL(2,IREF)).LT.LMIN)LMIN = NINT(RL(2,IREF))
         IF(NINT(RL(2,IREF)).GT.LMAX)LMAX = NINT(RL(2,IREF))
      ENDIF
      GOTO 30
 45   WRITE(6,1060)IREF
      WRITE(4,1060)IREF
      CLOSE(10)
      WRITE(6,1070)DMAX
      WRITE(4,1070)DMAX 
      IF(RESLIM.EQ.0.0)RESLIM = DMAX
      DO 140 L=LMIN,LMAX
         J = 0
         RMIN = 1.0
         RMAX = -1.0
         DO 50 I=1,IREF
            IF(NINT(RL(2,I)).EQ.L)THEN
               IF(SIG(I).GT.0.0.AND.RINT(I).GT.0.0)THEN
                  IF(RINT(I)/SIG(I).GT.SIGO.AND.
     &               D(I).LT.RESLIM.AND.D(I).GT.RESMIN)THEN
                     J = J + 1
                     IF(RL(1,I).LT.RMIN)RMIN = RL(1,I)
                     IF(RL(1,I).GT.RMAX)RMAX = RL(1,I)
                     INDEX(J) = I
                  ENDIF 
               ENDIF
            ENDIF
 50      CONTINUE
         NMAX = NINT(2.0*PI*A*RMAX+2.0)
         WRITE(6,1080)L,J,RMIN,RMAX,NMAX
         WRITE(4,1080)L,J,RMIN,RMAX,NMAX
C
C========Find minimum bessel function order contributing to this 
C========layerline
C     
         LACTUAL = LSCALE*L
         N = NMIN(LACTUAL,UHELIX,THELIX,NSTART,NSTACK,NMAX)
         IF(N.LT.0)THEN
            WRITE(6,1085)NMAX
            WRITE(4,1085)NMAX
            GOTO 140
         ENDIF
C
C========Determine the largest root required and find roots
C
         XMAX = PI*(XSCALE+4.0*A*RMAX)
         CALL ROOTJ(2*N,XMAX,ROOTS,MAXRTS,NR)
         WRITE(6,1090)N,NR
         WRITE(4,1090)N,NR
C
C========Warn user about under-sampling
C
         IF(J.LT.NR)THEN
            WRITE(6,2010)
            WRITE(4,2010)
         ENDIF
C
C========Form design matrix for Fourier-Bessel smoothing
C
         NDATA = MAX(NR,J)
         DO 65 K=1,NDATA
            IF(K.LE.J)THEN
               M = INDEX(K)
               TMP = RL(1,M)*4.0*PI*A
               SIGTMP = SIG(M)
               DO 55 I=1,NR
                  FB(K,I) = KCOF(TMP,ROOTS(I),N)/SIGTMP
 55            CONTINUE
               Y(K) = RINT(M)/SIGTMP
            ELSE
               DO 60 I=1,NR
                  FB(K,I) = 0.0
 60            CONTINUE
               Y(K) = 0.0
            ENDIF
 65      CONTINUE
C
C========Decompose design matrix
C
         CALL SVDCMP(FB,NDATA,NR,MAXLPT,MAXRTS,W,V)
C
C========Filter singular values
C
         WMAX = 0.0
         DO 70 I=1,NR
            IF(W(I).GT.WMAX)WMAX = W(J)
 70      CONTINUE
         THRESH = TOL*WMAX
         NSVREJ = 0
         DO 80 I=1,NR
            IF(W(I).LT.THRESH)THEN
               W(I) = 0.0
               NSVREJ = NSVREJ + 1
            ENDIF
 80      CONTINUE
         WRITE(6,1100)NSVREJ
         WRITE(4,1100)NSVREJ
C
C========Back-substitute to get least-squares solution
C
         CALL SVBKSB(FB,W,V,NDATA,NR,MAXLPT,MAXRTS,Y,X)
C
C========Form covariance matrix
C
         CALL SVDVAR(V,NR,MAXRTS,W,CVM,MAXRTS)
C
C========Write out reduced data
C
         DO 90 I=1,NR
            TMP = ROOTS(I)/(4.0*PI*A)
            IF(TMP.GE.RMIN.AND.TMP.LE.RMAX)
     &         WRITE(KUNIT,2000,ERR=9999)L,TMP,X(I),SQRT(CVM(I,I))
 90      CONTINUE
C
C========Compute chi-squared
C
         CHISQ = 0.0
         DO 130 K=1,NDATA
            IF(K.LE.J)THEN
               M = INDEX(K)
               TMP = RL(1,M)*4.0*PI*A
               SIGTMP = SIG(M)
               DO 100 I=1,NR
                  FB(K,I) = KCOF(TMP,ROOTS(I),N)/SIGTMP
 100           CONTINUE
            ELSE
               DO 110 I=1,NR
                  FB(K,I) = 0.0
 110           CONTINUE
            ENDIF
            TMP = 0.0
            DO 120 I=1,NR
               TMP = TMP + FB(K,I)*X(I)
 120        CONTINUE
            TMP = TMP - Y(K)
            CHISQ = CHISQ + TMP*TMP
 130     CONTINUE
         WRITE(6,1110)CHISQ
         WRITE(4,1110)CHISQ
 140  CONTINUE
      CLOSE(KUNIT)
      STOP 'Normal stop'
 9999 STOP 'USER STOP'
C
 1000 FORMAT(1X,'SAMPLE: Re-sampling of continuous layer-line',
     &       1X,'intensity'/
     &       1X,'Last update 16/10/96'/)
 1010 FORMAT(1X,'***Keyword expected')
 1020 FORMAT(1X,'***Value expected')
 1025 FORMAT(1X,'***Unrecognised keyword')
 1030 FORMAT(1X,'Enter input filename')
 1035 FORMAT(1X,'Enter output filename')
 1036 FORMAT(1X,'***Input file does not exist:  ',A40)
 1045 FORMAT(1X,'***Error opening input file:   ',A40)
 1046 FORMAT(1X,'***Error opening output file:  ',A40)
 1047 FORMAT(1X,'CONTINUOUS'/1X,'CELL ',F10.4)
 1050 FORMAT(1X,'SAMPLE: Error reading input file')
 1055 FORMAT(1X,'Number of reflections exceeds ',I4)
 1060 FORMAT(1X,'Number of reflections read from file:',I5)
 1070 FORMAT(1X,'Maximum d*  ',F8.6)
 1080 FORMAT(/1X,'Layer line ',I3,5X,'No. of intensities read ', I4/
     &       1X,'Min. rec. radius ',F8.6,5X,'Max. rec. radius ',F8.6/
     &       1X,'Maximum possible |n| ',I4)
 1085 FORMAT(1X,'Warning: No orders contribute for |n| <=',I3/
     &       1X,'=== Skipping layerline ===')
 1090 FORMAT(1X,'Minimum |n| ',I3/
     &       1X,'No. of roots of 2|n| determined ',I4)
 1100 FORMAT(1X,'No. of singular values filtered ',I4)
 1110 FORMAT(1X,'Chi-squared for this layerline = ',E12.4)
 2000 FORMAT(2(1X,'999'),I4,E12.4,3X,'1',2E12.4)
 2010 FORMAT(1X,'Warning: No. of roots > No. of intensities')
 1140 FORMAT(1X,'Number of reflections written  ',I8)
      END                  

