C     LAST UPDATE 06/08/93
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE RDINT(INFIL,RCELL,ALLINE,SIG) 
      IMPLICIT NONE
C
C Purpose: Read CCP13 intensity output files for LSQINT 
C
C Calls   2: RDCOMF , DCAL
C Called by: LSQINT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
       INTEGER NLLPX,MAXLAT
       PARAMETER(NLLPX=10000,MAXLAT=3)
C
C Common arrays:
C
       REAL SNORM(MAXLAT),SSCALE(NLLPX)
       INTEGER IHKL(4,NLLPX),INFO(3)
C
C Common variables:
C
       REAL DELR,RMIN,DELZ,ZMIN,DMIN,DMAX,SN,RADM
       INTEGER NLLP,NPRD,L1,L2,NR1,NR2,NLDIV,NBESS
       LOGICAL POLAR
C
C Array arguments:
C
       REAL RCELL(6),ALLINE(NLLPX),SIG(NLLPX)
C
C Variable arguments:
C
       CHARACTER*80 INFIL
C 
C Local arrays:
C
       REAL VALS(10),RINT(NLLPX),RSG(NLLPX),RL(2,NLLPX),D(NLLPX) 
       INTEGER ITEM(20),HKM(3,NLLPX),IH(128),IK(128),IL(128)
       CHARACTER*40 WORD(10)
C
C Local variables:
C
       REAL DX,DR,R,Z
       INTEGER NW,NV,IRC,IREF,I,J,M,IR,IP,IM,IO,JM,MFD,NH,NRD,NL,NR
       INTEGER LMIN,LMAX
       LOGICAL BRAG
       CHARACTER*80 LINE
C
C Common blocks:
C
      COMMON /INSPEC/ DELR,RMIN,DELZ,ZMIN,POLAR
      COMMON /POINTS/ NLLP,NPRD,INFO,IHKL
      COMMON /DLIMIT/ DMIN,DMAX,L1,L2,NR1,NR2,SN,NLDIV,NBESS,RADM
      COMMON /SCALES/ SNORM,SSCALE
C
C External function:
C
      REAL DCAL
      EXTERNAL DCAL
C
C-----------------------------------------------------------------------
      BRAG = INFO(1).EQ.1
C
C========Read input intensity file
C
      DX = 0.0
      LMIN = 100000
      LMAX = 0
      IREF = 0
      CALL FILEOPEN(10,INFIL,80,IRC)
      IF(IRC.NE.0)THEN
         WRITE(6,1045)
         WRITE(4,1045)
         GOTO 9999 
      ENDIF
 10   CALL RDCOMF(10,WORD,NW,VALS,NV,ITEM,10,10,40,IRC)
      IF(IRC.EQ.2)THEN
         WRITE(6,1050)
         WRITE(4,1050)
      ELSEIF(IRC.EQ.1)THEN
         GOTO 20 
      ENDIF
      IF(ITEM(1).EQ.1)THEN
         IREF = IREF + 1
         IF(IREF.GT.NLLPX)THEN
            WRITE(6,1055)NLLPX
            WRITE(4,1055)NLLPX
            GOTO 20 
         ENDIF
         HKM(1,IREF) = NINT(VALS(1))
         HKM(2,IREF) = NINT(VALS(2))
         RL(2,IREF) = VALS(3) 
         IF(NV.LT.7)THEN
            RINT(IREF) = VALS(NV)
            RSG(IREF) = 0.0
         ELSE
            RL(1,IREF) = VALS(4)
            HKM(3,IREF) = NINT(VALS(5))
            RINT(IREF) = VALS(6)
            RSG(IREF) = VALS(7)
         ENDIF
         IF(BRAG)THEN
            D(IREF) = DCAL(RCELL,HKM(1,IREF),HKM(2,IREF),
     &                NINT(RL(2,IREF))) 
         ELSE
            D(IREF) = SQRT((RL(2,IREF)*RCELL(3))**2
     &                      +RL(1,IREF)**2)
         ENDIF 
         IF(D(IREF).GT.DX)DX = D(IREF)
         IF(NINT(RL(2,IREF)).LT.LMIN)LMIN = NINT(RL(2,IREF))
         IF(NINT(RL(2,IREF)).GT.LMAX)LMAX = NINT(RL(2,IREF))
      ENDIF
      GOTO 10
 20   WRITE(6,1060)IREF
      WRITE(4,1060)IREF
      CALL FILECLOSE(10)
      WRITE(6,1070)DX
      WRITE(4,1070)DX 
C
C========Search through reflection list to fill intensity array
C
      IF(BRAG)THEN
         OPEN(UNIT=20,FILE='DRAGON.OUT1',STATUS='OLD')
         READ(20,'(A80)')LINE
         IR = 0
         IP = 0
         IO = 0
         IM = 0
 30      CONTINUE
            IR = IR + 1
            IM = IM + 1
            READ(20,1000,END=60)IH(IM),IK(IM),IL(IM),JM,MFD,DR,R,Z
            IF(MFD.GT.0)THEN
               IP = IP + 1
               IF(IHKL(4,IP).EQ.1)THEN
                  IO = IO + 1
                  ALLINE(IO) = 0.0
                  SIG(IO) = 0.0
                  DO 50 J=1,IREF
                     IF(NINT(RL(2,J)).EQ.IL(IM))THEN
                        DO 40 M=1,IM
                           IF(HKM(1,J).EQ.IH(M).AND.
     &                        HKM(2,J).EQ.IK(M))THEN
                              ALLINE(IO) = ALLINE(IO) + 
     &                                     RINT(J)/(SSCALE(IO)*SN)
                              SIG(IO) = SIG(IO) + 
     &                                  (RSG(J)/(SSCALE(IO)*SN))**2
                           ENDIF
 40                     CONTINUE
                     ENDIF
 50               CONTINUE
                  SIG(IO) = SQRT(SIG(IO))
               ENDIF
               IM = 0
            ENDIF
         GOTO 30
 60      CLOSE(20)
      ELSE
         IO = 0
         DO 80 I=1,NPRD
            NH = MOD(I-1,4) + 1
            NRD = (I-1)/4 + 1
            NL = (I-1)/(NR2-NR1+1) + L1
C Changed 10/01/00 +(NR-1) term added
C            NR = I - (NL-L1)*(NR2-NR1+1)
            NR = I - (NL-L1)*(NR2-NR1+1) +(NR1-1)
            IF(IHKL(NH,NRD).EQ.1)THEN
               IO = IO + 1
               ALLINE(IO) = 0.0
               SIG(IO) = 0.0
               R = FLOAT(NR)*DELR + RMIN
               DO 70 J=1,IREF 
                  IF(NINT(RL(2,J)).EQ.NL)THEN
                     IF(ABS(RL(1,J)-R).LT.DELR/2.0)THEN
                        ALLINE(IO) = RINT(J)/(SSCALE(IO)*SN)
                        SIG(IO) = RSG(J)/(SSCALE(IO)*SN)
                     ENDIF
                  ENDIF          
 70            CONTINUE
            ENDIF
 80      CONTINUE
      ENDIF
      RETURN
 9999 STOP 'USER STOP' 
C
 1000 FORMAT(1X,3I4,2I5,1X,3E14.6)
 1045 FORMAT(1X,'***Error opening input file:   ',A40)
 1050 FORMAT(1X,'RDINT: Error reading input file')
 1055 FORMAT(1X,'Number of reflections exceeds ',I5)
 1060 FORMAT(1X,'Number of reflections read from file:',I5) 
 1070 FORMAT(1X,'Maximum d*  ',F8.6)
      END                  
