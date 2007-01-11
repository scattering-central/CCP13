C     LAST UPDATE 28/11/95
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PROGRAM FDSCALE
      IMPLICIT NONE
C
C Purpose: Scales intensity output from LSQINT, either for common
C          reflections or just on the weighted sums of the intensities. 
C
C Calls   6: RDCOMF , RECCEL , DCAL , SVDCMP , SVBKSB , SVDVAR 
C Called by:
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
       INTEGER NLLPX,MAXBIN,MAXFIL,NPARS
       PARAMETER(NLLPX=2048,MAXBIN=20,MAXFIL=20,NPARS=2)
C 
C Local arrays:
C
       REAL VALS(10),RINT(MAXFIL,NLLPX),SIG(MAXFIL,NLLPX),
     &      RL(2,NLLPX,MAXFIL),CELL(6),RS(NLLPX),
     &      RCELL(6),DELR(MAXFIL),D(MAXFIL,NLLPX),SUM(MAXFIL,MAXBIN),
     &      SSG(MAXFIL,MAXBIN),K(MAXFIL),
     &      B(MAXFIL),A(MAXBIN,NPARS),W(NPARS),V(NPARS,NPARS),P(MAXBIN),
     &      X(NPARS),CVM(NPARS,NPARS),SK(MAXFIL),SB(MAXFIL)
       INTEGER ITEM(MAXBIN),HKM(3,NLLPX,MAXFIL),NR(MAXFIL,MAXBIN),
     &         NREF(MAXFIL),ITAG(MAXFIL,NLLPX),NI(NLLPX,2),IND(NLLPX)
       CHARACTER*40 WORD(10),FILES(MAXFIL)
C
C Local variables:
C
       REAL RESMIN,RESLIM,DMAX,COMSUM,COMDEN,DR,SI,SSI,SIGS,SIGO,DFM,TMP
       INTEGER NW,NV,IRC,NFILE,NBIN,IREF,I,J,IB,N,M,L,LMIN,LMAX,IL,NS,IS
       INTEGER NRG,KG,NRT,IW
       REAL AV(MAXFIL),AVS,RSNUM,RSDEN,RSYM
       LOGICAL NEXT,SUMS,COMM,BRAG,CONT,MERG,FEX,SYMM
       CHARACTER*40 OUTFIL
       INTEGER IJUNK,IUNIQ,ISCAL,IOUTP,IRESO,IMERG,NLAST
C
C External functions:
C
       REAL DCAL
       EXTERNAL DCAL 
C
C-----------------------------------------------------------------------
C
C========Open log file
C
      OPEN(UNIT=4,FILE='FDSCALE.LOG',STATUS='UNKNOWN')
      WRITE(6,1000)
      WRITE(4,1000)
C
C========Set up defaults
C
      NEXT = .TRUE.
      COMM = .TRUE.
      SUMS = .FALSE.
      BRAG = .FALSE.
      CONT = .FALSE.
      MERG = .FALSE. 
      NBIN = 1
      NFILE = 0
      RESLIM = 0.0
      RESMIN = 0.0
      DMAX = 0.0
      SIGS = 3.0 
      SIGO = 1.5
C
C=======Read keyworded input
C
 10   WRITE(6,'(A9,$)')'FDSCALE> '
      CALL RDCOMF(5,WORD,NW,VALS,NV,ITEM,10,10,40,IRC) 
      IF(IRC.EQ.2)GOTO 10
      IF(IRC.EQ.1)GOTO 9999
      CALL WRTLOG(4,WORD,NW,VALS,NV,ITEM,10,10,IRC)
      IF(ITEM(1).EQ.0)GOTO 10
      IF(ITEM(1).NE.2)THEN
         WRITE(6,1010)
         WRITE(4,1010)
         GOTO 10
      ENDIF
      DO 15 IW=1,NW
         CALL UPPER(WORD(IW),40)
 15   CONTINUE
C
      IF(WORD(1)(1:3).EQ.'RUN')THEN
         NEXT = .FALSE.
      ELSEIF(WORD(1)(1:4).EQ.'SUMS')THEN
         SUMS = .TRUE.
         COMM = .FALSE.
      ELSEIF(WORD(1)(1:4).EQ.'COMM')THEN
         COMM = .TRUE.
      ELSEIF(WORD(1)(1:4).EQ.'RSYM')THEN
         SYMM = .TRUE.
         COMM = .FALSE.
      ELSEIF(WORD(1)(1:4).EQ.'MERG')THEN
         MERG = .TRUE.
C
C========Read output filename
C
         WRITE(6,1040)
         WRITE(4,1040)
         READ(5,'(A)',END=9999)OUTFIL
         WRITE(4,'(A)')OUTFIL
      ELSEIF(WORD(1)(1:4).EQ.'BINS')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            NBIN = NINT(VALS(1))
            IF(NBIN.GT.20)THEN
               WRITE(6,1026)MAXBIN
               WRITE(4,1026)MAXBIN
               NBIN = MAXBIN
            ENDIF 
         ENDIF 
      ELSEIF(WORD(1)(1:4).EQ.'FILE')THEN
C
C========Read input filenames
C
         WRITE(6,1030)
         WRITE(4,1030)
         NFILE = 1 
 20      CONTINUE
            IF(NFILE.GT.MAXFIL)THEN
               WRITE(6,1035)MAXFIL
               WRITE(4,1035)MAXFIL
               GOTO 10
            ENDIF
            CALL RDCOMF(5,WORD,NW,VALS,NV,ITEM,10,10,40,IRC) 
            IF(IRC.EQ.2)GOTO 10
            IF(IRC.EQ.1)GOTO 10
            CALL WRTLOG(4,WORD,NW,VALS,NV,ITEM,10,10,IRC)
            IF(ITEM(1).EQ.0)GOTO 10
            IF(ITEM(1).NE.2)THEN
               WRITE(6,1010)
               WRITE(4,1010)
               GOTO 10
            ENDIF
            FILES(NFILE) = WORD(1)
            INQUIRE(FILE=FILES(NFILE),EXIST=FEX)
            IF(.NOT.FEX)THEN
               WRITE(6,1036)FILES(NFILE)
               WRITE(4,1036)FILES(NFILE)
            ELSE
               NFILE = NFILE + 1
            ENDIF
         GOTO 20
      ELSEIF(WORD(1)(1:4).EQ.'RESO')THEN
         IF(ITEM(2).NE.1)THEN
            WRITE(6,1020)
            WRITE(4,1020)
         ELSE
            RESMIN = VALS(1)
            RESLIM = VALS(2)
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'SIGM')THEN
         IF(ITEM(2).NE.2)THEN
            WRITE(6,1010)
            WRITE(4,1010)
         ELSE
            DO 25 I=2,NW
               IF(WORD(I)(1:4).EQ.'SCAL')THEN
                  IF(ITEM(2*I-1).NE.1)THEN
                     WRITE(6,1020)
                     WRITE(4,1020)
                  ELSE
                     SIGS = VALS(I-1)
                  ENDIF
               ELSEIF(WORD(I)(1:4).EQ.'OUTP')THEN
                  IF(ITEM(2*I-1).NE.1)THEN
                     WRITE(6,1020)
                     WRITE(4,1020)
                  ELSE
                     SIGO = VALS(I-1)
                  ENDIF
               ELSE
                  WRITE(6,1025)
                  WRITE(4,1025)
               ENDIF
 25         CONTINUE
         ENDIF
      ELSE
         WRITE(6,1025)
         WRITE(4,1025)
      ENDIF
C
      IF(NEXT)GOTO 10
C
C========Loop over input files to determine Bragg/continuous etc  
C
      NFILE = NFILE - 1
      DO 50 I=1,NFILE
         IREF = 0
         DFM = 0.0
         CALL FILEOPEN(10,FILES(I),40,IRC)
         IF(IRC.NE.0)THEN
            WRITE(6,1045)
            WRITE(4,1045)
            GOTO 50
         ENDIF
 30      CALL RDCOMF(10,WORD,NW,VALS,NV,ITEM,10,10,40,IRC)
         IF(IRC.EQ.2)THEN
            WRITE(6,1050)
            WRITE(4,1050)
         ELSEIF(IRC.EQ.1)THEN
            GOTO 45 
         ENDIF
         DO 35 IW=1,NW
            CALL UPPER(WORD(IW),40)
 35      CONTINUE
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
 40            CONTINUE
               write(6,*)' Cell: ',cell
               DO 41 J=4,6
                  CELL(J) = CELL(J)*ATAN(1.0)/45.0
 41            CONTINUE
            ELSEIF(WORD(1)(1:4).EQ.'DELT')THEN
               DELR(I) = VALS(1)
            ENDIF
         ELSEIF(ITEM(1).EQ.1)THEN
            IF(IREF.EQ.0.AND.BRAG)then
               CALL RECCEL(CELL,RCELL)
               write(6,*)' Reciprocal cell: ',rcell
            endif
            IREF = IREF + 1
            IF(IREF.GT.NLLPX)THEN
               WRITE(6,1055)I,NLLPX
               WRITE(4,1055)I,NLLPX
               GOTO 45
            ENDIF
            HKM(1,IREF,I) = NINT(VALS(1))
            HKM(2,IREF,I) = NINT(VALS(2))
            RL(2,IREF,I) = VALS(3) 
            RL(1,IREF,I) = VALS(4)
            HKM(3,IREF,I) = NINT(VALS(5))
            RINT(I,IREF) = VALS(6)
            SIG(I,IREF) = VALS(7)
            IF(BRAG)THEN
               D(I,IREF) = DCAL(RCELL,HKM(1,IREF,I),HKM(2,IREF,I),
     &                     NINT(RL(2,IREF,I))) 
            ELSEIF(CONT)THEN
               D(I,IREF) = SQRT((RL(2,IREF,I)/CELL(1))**2
     &                          +RL(1,IREF,I)**2)
            ENDIF 
            IF(D(I,IREF).GT.DFM)DFM = D(I,IREF)
            IF(D(I,IREF).GT.DMAX)DMAX = D(I,IREF)
            ITAG(I,IREF) = 0
         ENDIF
         GOTO 30
 45      NREF(I) = IREF 
         WRITE(6,1060)I,NREF(I),DFM
         WRITE(4,1060)I,NREF(I),DFM
         CALL FILECLOSE(10)
 50   CONTINUE 
      WRITE(6,1070)DMAX
      WRITE(4,1070)DMAX 
      IF(RESLIM.EQ.0.0)RESLIM = DMAX 
C
C========Calculate weights and average intensities if required
C
      DO 70 I=1,NFILE
         DO 55 IB=1,NBIN
            SSG(I,IB) = 0.0
            SUM(I,IB) = 0.0
            NR(I,IB) = 0
 55      CONTINUE 
         DO 60 N=1,NREF(I)
            IF(SIG(I,N).EQ.0.0)THEN 
               ITAG(I,N) = 16
            ENDIF
            IF(D(I,N).LT.RESMIN.OR.D(I,N).GT.RESLIM)THEN
               ITAG(I,N) = ITAG(I,N) + 8 
            ENDIF
            IF(MOD(ITAG(I,N)/16,2).EQ.0)THEN
               IF(RINT(I,N)/SIG(I,N).LT.SIGO)THEN
                  ITAG(I,N) = ITAG(I,N) + 4
               ENDIF
               IF(RINT(I,N)/SIG(I,N).LT.SIGS)THEN
                  ITAG(I,N) = ITAG(I,N) + 2
               ENDIF
            ENDIF
            IF(ITAG(I,N).LT.7)THEN
               IF(MOD(ITAG(I,N)/2,2).EQ.0)THEN
                  IB = INT(FLOAT(NBIN-1)*
     &                 (D(I,N)-RESMIN)/(RESLIM-RESMIN)) + 1
                  NR(I,IB) = NR(I,IB) + 1
                  SUM(I,IB) = SUM(I,IB) + RINT(I,N)
                  SSG(I,IB) = SSG(I,IB) + SIG(I,N)*SIG(I,N)
               ENDIF
            ENDIF
 60      CONTINUE 
         WRITE(6,1080)I
         WRITE(4,1080)I
         DO 65 IB=1,NBIN
            IF(NR(I,IB).GT.0)THEN
               SUM(I,IB) = SUM(I,IB)/FLOAT(NR(I,IB))
               SSG(I,IB) = SSG(I,IB)/FLOAT(NR(I,IB))
               SSG(I,IB) = SQRT(SSG(I,IB))
            ENDIF 
            WRITE(6,1090)IB,NR(I,IB),SUM(I,IB),SSG(I,IB)
            WRITE(4,1090)IB,NR(I,IB),SUM(I,IB),SSG(I,IB)
 65      CONTINUE  
 70   CONTINUE 
C
C========Calculate scale factors and relative temperature factors
C
      IF(SUMS)THEN
         I = 1
         K(1) = 1.0
         B(1) = 0.0
         SK(I) = 0.0
         SB(I) = 0.0
         WRITE(6,1100)
         WRITE(4,1100)
         WRITE(6,1110)I,K(I),B(I),SK(I),SB(I)
         WRITE(4,1110)I,K(I),B(I),SK(I),SB(I)
         IF(NBIN.GT.1)THEN
            DO 90 I=2,NFILE 
               IB = 0
               DO 80 M=1,NBIN
                  IF(NR(1,M).GT.0.AND.NR(I,M).GT.0)THEN
                     IF(SSG(I,M).GT.0.0.AND.SUM(I,M).GT.0.0.AND.
     &                  SSG(1,M).GT.0.0.AND.SUM(1,M).GT.0.0)THEN
                        IB = IB + 1
                        TMP = SSG(I,M)/SUM(I,M) + SSG(1,M)/SUM(1,M)
                        A(IB,1) = 1.0/TMP
                        A(IB,2) = 0.5*(RESMIN+(FLOAT(M)-0.5)
     &                            *(RESLIM-RESMIN)/FLOAT(NBIN))**2 
     &                            /TMP
                        P(IB) = LOG(SUM(1,M)/SUM(I,M))/TMP
                     ENDIF
                  ENDIF
 80            CONTINUE
               CALL SVDCMP(A,IB,2,MAXBIN,NPARS,W,V)
               IF(1.0E+05*ABS(W(2)).LT.ABS(W(1)))THEN
                  W(2) = 0.0
               ELSEIF(1.0E+05*ABS(W(1)).LT.ABS(W(2)))THEN
                  W(1) = 0.0
               ENDIF  
               CALL SVBKSB(A,W,V,IB,2,MAXBIN,NPARS,P,X)
               K(I) = EXP(X(1))
               B(I) = X(2) 
               CALL SVDVAR(V,2,2,W,CVM,NPARS)
               SK(I) = K(I)*SQRT(CVM(1,1))
               SB(I) = SQRT(CVM(2,2))
               WRITE(6,1110)I,K(I),B(I),SK(I),SB(I)
               WRITE(4,1110)I,K(I),B(I),SK(I),SB(I)
 90         CONTINUE
         ELSE
            DO 100 I=2,NFILE
               K(I) = SUM(1,1)/SUM(I,1)
               B(I) = 0.0
               SK(I) = K(I)*(SSG(1,1)/SUM(1,1)+SSG(I,1)/SUM(I,1))
               SB(I) = 0.0
               WRITE(6,1110)I,K(I),B(I),SK(I),SB(I)
               WRITE(4,1110)I,K(I),B(I),SK(I),SB(I)
 100        CONTINUE
         ENDIF
      ENDIF
C
C========Calculate a scale factor on common reflections if required
C
      COMSUM = 0.0
      COMDEN = 0.0
      RSNUM = 0.0
      RSDEN = 0.0
      NRT = 0
      DO 150 I=1,NFILE
         DO 140 N=1,NREF(I)
            NRG = 0
            IF(ITAG(I,N).GT.7)GOTO 140
            IF(MOD(ITAG(I,N),2).EQ.0)THEN
               IF(SYMM)THEN
                  IF(MOD(ITAG(I,N)/2,2).EQ.0)THEN
                     AV(1) = RINT(I,N)
                     AVS = RINT(I,N)
                     NRG = 1
                  ENDIF
               ENDIF
            ENDIF
            DO 130 J=I+1,NFILE
               IF(BRAG)THEN
                  DR = AMAX1(DELR(I),DELR(J))/2.0
               ELSE
                  DR = AMIN1(DELR(I),DELR(J))/2.0
               ENDIF
               DO 120 M=1,NREF(J)
                  IF(NINT(RL(2,N,I)).EQ.NINT(RL(2,M,J)))THEN
                     IF(ABS(RL(1,N,I)-RL(1,M,J)).LT.DR)THEN
                        IF(MOD(ITAG(J,M),2).EQ.0)THEN
                           ITAG(J,M) = ITAG(J,M) + 1
                        ENDIF      
                        IF(ITAG(J,M).LT.7.AND.(COMM.OR.SYMM))THEN
                           IF(MOD(ITAG(I,N)/2,2).EQ.0.AND.
     &                        MOD(ITAG(J,M)/2,2).EQ.0)THEN
                              COMSUM = COMSUM + FLOAT(J-I)*
     &                                 LOG(RINT(I,N)/RINT(J,M))/
     &                                 (SIG(I,N)/RINT(I,N)+SIG(J,M)/
     &                                  RINT(J,M))**2
                              COMDEN = COMDEN + (FLOAT(J-I)/
     &                                 (SIG(I,N)/RINT(I,N)+SIG(J,M)/
     &                                  RINT(J,M)))**2
                              IF(SYMM)THEN
                                 IF(MOD(ITAG(I,N),2).EQ.0)THEN
                                    NRG = NRG + 1
                                    AV(NRG) = RINT(J,M)
                                    AVS = AVS + RINT(J,M)
                                 ENDIF
                              ENDIF
                           ENDIF 
                        ENDIF
                     ENDIF
                  ENDIF
 120           CONTINUE
 130        CONTINUE 
            IF(SYMM)THEN
               IF(MOD(ITAG(I,N),2).EQ.0.AND.
     &              MOD(ITAG(I,N)/2,2).EQ.0)THEN
                  AVS = AVS/FLOAT(NRG)
                  DO 135 KG=1,NRG
                     RSNUM = RSNUM + ABS(AV(KG)-AVS)
                     RSDEN = RSDEN + AV(KG)
                     NRT = NRT + 1
 135              CONTINUE
               ENDIF
            ENDIF
 140     CONTINUE
C
C========See what's what
C
         IJUNK = 0
         IRESO = 0
         IOUTP = 0
         ISCAL = 0
         IUNIQ = 0
         DO 145 N=1,NREF(I)
            IF(ITAG(I,N).GE.16)THEN
               IJUNK = IJUNK + 1
            ELSE
               IF(MOD(ITAG(I,N)/8,2).EQ.0)THEN
                  IRESO = IRESO + 1
               ENDIF
               IF(MOD(ITAG(I,N)/4,2).EQ.0)THEN
                  IOUTP = IOUTP + 1
               ENDIF
               IF(MOD(ITAG(I,N)/2,2).EQ.0)THEN
                  ISCAL = ISCAL + 1
               ENDIF
               IF(MOD(ITAG(I,N),2).EQ.0)THEN
                  IUNIQ = IUNIQ + 1
               ENDIF
            ENDIF
 145     CONTINUE
         WRITE(6,1150)I,NREF(I),IJUNK,IRESO,RESMIN,RESLIM,IUNIQ,ISCAL,
     &                SIGS,IOUTP,SIGO
         WRITE(4,1150)I,NREF(I),IJUNK,IRESO,RESMIN,RESLIM,IUNIQ,ISCAL,
     &                SIGS,IOUTP,SIGO
 150  CONTINUE
      IF(COMM)THEN
         K(1) = EXP(COMSUM/COMDEN)
         B(1) = 0.0
         SK(1) = K(1)/SQRT(COMDEN)
         SB(1) = 0.0
         WRITE(6,1120)K(1),SK(1)
         WRITE(4,1120)K(1),SK(1)
         DO 160 I=2,NFILE
            K(I) = K(I-1)*K(1) 
            B(I) = 0.0
 160     CONTINUE
      ELSEIF(SYMM)THEN
         RSYM = RSNUM/RSDEN
         WRITE(6,1125)RSYM,NRT
         DO 165 I=1,NFILE
            K(I) = 1.0
            B(I) = 0.0
 165     CONTINUE
      ENDIF
C
C========Merge data if required
C  
      IF(MERG)THEN
         IMERG = 0
         DO 200 I=1,NFILE
            DO 190 N=1,NREF(I)
               IF(MOD(ITAG(I,N),2).EQ.0.AND.
     &            MOD(ITAG(I,N)/4,2).EQ.0)THEN
                  IMERG = IMERG + 1
                  SI = K(I)*RINT(I,N)*EXP(B(I)*D(I,N)**2/2.0)
                  SSI = (SK(I)+K(I))*(SIG(I,N)+RINT(I,N))
     &                  *EXP((SB(I)+B(I))*D(I,N)*D(I,N)/2.0)
                  SSI = SSI - SI
                  COMSUM = SI/(SSI*SSI) 
                  COMDEN = 1.0/(SSI*SSI) 
                  SIG(I,N) = SSI 
                  DO 180 J=I+1,NFILE
                     IF(BRAG)THEN
                        DR = AMAX1(DELR(I),DELR(J))/2.0
                     ELSE
                        DR = AMIN1(DELR(I),DELR(J))/2.0
                     ENDIF
                     DO 170 M=1,NREF(J)
                        IF(NINT(RL(2,N,I)).EQ.NINT(RL(2,M,J)))THEN
                           IF(ABS(RL(1,N,I)-RL(1,M,J)).LT.DR)THEN
                              IF(MOD(ITAG(J,M)/4,2).EQ.0)THEN
                                 SI = K(J)*RINT(J,M)*EXP(B(J)*
     &                                D(J,M)**2/2.0)
                                 SSI = (SK(J)+K(J))*(SIG(J,M)+
     &                                 RINT(J,M))*EXP((SB(J)+B(J))
     &                                 *D(J,M)*D(J,M)/2.0)
                                 SSI = SSI - SI
                                 COMSUM = COMSUM + SI/(SSI*SSI) 
                                 COMDEN = COMDEN + 1.0/(SSI*SSI) 
                              ENDIF
                           ENDIF
                        ENDIF
 170                 CONTINUE
                     IF(J.EQ.NFILE)THEN
                        RINT(I,N) = COMSUM/COMDEN
                        SIG(I,N) = 1.0/SQRT(COMDEN)
                     ENDIF 
 180              CONTINUE
               ENDIF
 190        CONTINUE
 200     CONTINUE
         WRITE(6,1180)IMERG
C
C========Write header information
C
         OPEN(UNIT=10,FILE=OUTFIL,STATUS='UNKNOWN')
         IF(BRAG)THEN
            DO 205 I=4,6
               CELL(I) = CELL(I)*45.0/ATAN(1.0)
 205        CONTINUE
            WRITE(10,2000)CELL
            LMIN = NINT(RESMIN/RCELL(3))
            LMAX = NINT(RESLIM/RCELL(3))
         ELSE
            WRITE(10,2010)CELL(1)
            LMIN = NINT(RESMIN*CELL(1))
            LMAX = NINT(RESLIM*CELL(1))
         ENDIF
C
C========Sort output
C
         IREF = 0
         DO 240 L=LMIN,LMAX
            IL = 0
            DO 220 I=1,NFILE
               DO 210 N=1,NREF(I)
                  IF(MOD(ITAG(I,N)/8,2).EQ.0)THEN
                     IF(NINT(RL(2,N,I)).EQ.L)THEN
                        IL = IL + 1
                        RS(IL) = RL(1,N,I)
                        NI(IL,1) = N 
                        NI(IL,2) = I 
                     ENDIF 
                  ENDIF
 210           CONTINUE
 220        CONTINUE
            IF(IL.GT.0)CALL SORT(RS,IL,IND)
            NLAST = 1
            DO 230 N=1,IL
               NS = NI(IND(N),1)
               IS = NI(IND(N),2)
               DR = DELR(IS)/2.0
               DO 225 M=NLAST,NS-1
                  IF(NINT(RL(2,M,IS)).EQ.L.AND.
     &               HKM(3,M,IS).EQ.0.AND.
     &               ABS(RL(1,NS,IS)-RL(1,M,IS)).LT.DR)THEN
                     WRITE(10,1130)HKM(1,M,IS),HKM(2,M,IS),
     &                             NINT(RL(2,M,IS)),RL(1,M,IS),
     &                             HKM(3,M,IS),RINT(IS,M),SIG(IS,M)
                     IREF = IREF + 1
                  ENDIF
 225           CONTINUE
               NLAST = NS + 1
               WRITE(10,1130)HKM(1,NS,IS),HKM(2,NS,IS),
     &                       NINT(RL(2,NS,IS)),RL(1,NS,IS),
     &                       HKM(3,NS,IS),RINT(IS,NS),SIG(IS,NS)
               IREF = IREF + 1
 230        CONTINUE
 240     CONTINUE
         CLOSE(10)
         WRITE(6,1140)IREF
         WRITE(4,1140)IREF
      ENDIF
      STOP 'Normal stop'
 9999 STOP 'USER STOP'
C
 1000 FORMAT(1X,'FDSCALE: Fibre diffraction intensity scaling program'/
     &       1X,'Last update 28/11/95'/)
 1010 FORMAT(1X,'***Keyword expected')
 1020 FORMAT(1X,'***Value expected')
 1025 FORMAT(1X,'***Unrecognised keyword')
 1026 FORMAT(1X,'Too many bins, resetting to ',I3)
 1030 FORMAT(1X,'Enter input filenames')
 1035 FORMAT(1X,'Maximum number of input files = ',I3)
 1036 FORMAT(1X,'***Input file does not exist:   ',A40)
 1040 FORMAT(1X,'Enter output filename ')
 1045 FORMAT(1X,'***Error opening input file:   ',A40)
 1050 FORMAT(1X,'FDSCALE: Error reading input file')
 1055 FORMAT(1X,'Number of reflections in file ',I2,' exceeds ',I4)
 1060 FORMAT(1X,'Number of reflections read from file ',I2,':',I5/
     &       1X,'d*max = ',F8.6) 
 1070 FORMAT(1X,'Maximum d*  ',F8.6)
 1080 FORMAT(/1X,'File number ',I2
     &       /1X,'Bin       No. Refs.        <I>          Sigma(<I>)')
 1090 FORMAT(1X,I2,10X,I6,4X,G12.5,4X,G12.5)
 1100 FORMAT(/1X,'File            Scale factor        Temp factor')
 1110 FORMAT(1X,I3,10X,2(E12.4,8X)/14X,2(E12.4,8X))
 1120 FORMAT(1X,'Film pack scale factor  ',F8.4,2X,'std ',F8.4)
 1125 FORMAT(/1X,'Rsym = ', G12.5, '  from ',I6,' reflections')
 1130 FORMAT(1X,3I4,E12.4,I4,2E12.4)
 1140 FORMAT(1X,'Number of reflections written = ',I8)
 1150 FORMAT(/1X,'File ',I2,3X,I8,' reflections'/
     &       11X,I8,' unmeasured'/
     &       11X,I8,' inside resolution limits',
     &       5X,'(',F7.5,' < d* < ',F7.5,')'/
     &       11X,I8,' unique to this dataset'/
     &       11X,I8,' used for scaling',5X,'(I/sigma(I) > ',F5.1,')'/
     &       11X,I8,' used for output ',5X,'(I/sigma(I) > ',F5.1,')')
 1180 FORMAT(/1X,'Total number of reflections merged = ',I8)
 2000 FORMAT('BRAGG'/'CELL ',6F8.3)
 2010 FORMAT('CONTINUOUS'/'CELL ',F8.3)
      END                  
