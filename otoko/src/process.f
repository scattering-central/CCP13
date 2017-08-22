C     LAST UPDATE Nov 20th 1991 J.F.DIAZ 
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE process
      IMPLICIT NONE
C
C Purpose: divide & normalise data & buffer, subtract buffer from data
C          divide by detector response and shift to remove TAC.
C
C
      INCLUDE 'COMMON.FOR'
C
C Calls   7: APLOT  , DAWRT  , ERRMSG , FILL   , GETCHN , GETHDR
C            OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),WEIGHT(10),BUFFER(10),TEMP
      INTEGER ICLO,JOP,IRC,IMEM,KREC,IFRAME
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER ISPEC3,LSPEC3,MEM3,IFFR3,ILFR3,INCR3,IFINC3
      INTEGER ISPEC4,LSPEC4,MEM4,IFFR4,ILFR4,INCR4,IFINC4
      INTEGER ISPEC5,LSPEC5,MEM5,IFFR5,ILFR5,INCR5,IFINC5
      INTEGER IHFMX1,IFRMX1,NCHAN1,NFRAM1
      INTEGER IHFMX2,IFRMX2,NCHAN2,NFRAM2
      INTEGER IHFMX3,IFRMX3,NCHAN3,NFRAM3
      INTEGER IHFMX4,IFRMX4,NCHAN4,NFRAM4
      INTEGER IHFMX5,IFRMX5,NCHAN5,NFRAM5
      INTEGER NVAL,JCH1,JCH2,I,J,K,L,ISHIFT,IFIRST,ILAST
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM1,HFNAM2,HFNAM3,HFNAM4,HFNAM5,OFNAM
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMX1 : Nos. of frames in sequence
C IHFMX1 : Nos. of header file in sequence
C ISPEC1 : First header file in sequence
C LSPEC1 : Last header file in sequence
C MEM1   : Positional or calibration data indicator
C IFFR1  : First frame in sequence
C ILFR1  : Last frame in sequence
C INCR1  : Header file increment
C IFINC1 : Frame increment
C HFNAM1 : Header filename
C IFRMX2 : Nos. of frames in sequence
C IHFMX2 : Nos. of header file in sequence
C ISPEC2 : First header file in sequence
C LSPEC2 : Last header file in sequence
C MEM2   : Positional or calibration data indicator
C IFFR2  : First frame in sequence
C ILFR2  : Last frame in sequence
C INCR2  : Header file increment
C IFINC2 : Frame increment
C HFNAM2 : Header filename
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C KREC   : Output file record
C IMEM   : Output memory dataset
C NCHAN  : Nos of data points in spectrum 1
C NCHAN2 : Nos of data points in spectrum 2
C NFRAME : Nos of time frames
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      KREC=0
C
      WRITE (IPRINT,*) 'Detector response file'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     &             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NCHAN1,IRC)
      IF (IRC.NE.0) GOTO 999
C 
      WRITE (IPRINT,*) 'Buffer calibration file'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,INCR2,MEM2,
     &             IFFR2,ILFR2,IFINC2,IHFMX2,IFRMX2,NCHAN2,IRC)
      IF (IRC.NE.0) GOTO 10

      WRITE (IPRINT,*) 'Buffer file'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM3,ISPEC3,LSPEC3,INCR3,MEM3,
     &             IFFR3,ILFR3,IFINC3,IHFMX3,IFRMX3,NCHAN3,IRC)
      IF (IRC.NE.0) GOTO 10
C 
      WRITE (IPRINT,*) 'Data calibration file'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM4,ISPEC4,LSPEC4,INCR4,MEM4,
     &             IFFR4,ILFR4,IFINC4,IHFMX4,IFRMX4,NCHAN4,IRC)
      IF (IRC.NE.0) GOTO 10
C
      WRITE (IPRINT,*) 'Data file'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM5,ISPEC5,LSPEC5,INCR5,MEM5,
     &             IFFR5,ILFR5,IFINC5,IHFMX5,IFRMX5,NCHAN5,IRC)
      IF (IRC.NE.0) GOTO 10
      IFRAME=IHFMX5+IFRMX5-1
C
      CALL GETCHN (ITERM,IPRINT,NCHAN5,JCH1,JCH2,IRC)
      IF (IRC.NE.0) GOTO 10
C
15    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,WEIGHT,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 50
      IF (IRC.EQ.2) GOTO 15
      IF (NVAL.LT.2) WEIGHT(2)=1.0
      IF (NVAL.LT.1) WEIGHT(1)=1.0
C
16    WRITE (IPRINT,1010)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 50
      IF (IRC.EQ.2) GOTO 16
      IF (NVAL.LT.2) GOTO 16
      IFIRST=INT(VALUE(1))
      ILAST=INT(VALUE(2))
C
17    WRITE (IPRINT,1020) 
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 50
      IF (IRC.EQ.2) GOTO 17
      IF (NVAL.EQ.0) GOTO 17
      ISHIFT=INT(VALUE(1))
      IF (ISHIFT.EQ.0) GOTO 50
C
18    WRITE (IPRINT,1030)
      CALL GETVAL (ITERM,BUFFER,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 50
      IF (IRC.EQ.2) GOTO 18
      IF (NVAL.LT.2) BUFFER(2)=1.0
      IF (NVAL.LT.1) BUFFER(1)=1.0
C
C========READ THE DETECTOR RESPONSE
C
      CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NCHAN1,
     &             NFRAM1,IRC)
      IF (IRC.NE.0) GOTO 50
      READ (JUNIT,REC=IFFR1) (SP1(K),K=1,NCHAN1)
      CLOSE (UNIT=JUNIT)
C
      DO 40 I=1,IHFMX5
C
C========OPEN CALIBRATION AND DATA FILES FOR BUFFER
C
         CALL OPNFIL (JUNIT,HFNAM2,ISPEC2,MEM2,IFFR2,ILFR2,NCHAN2,
     &                NFRAM2,IRC)
         IF (IRC.NE.0) GOTO 50
         ISPEC2=ISPEC2+INCR2
         CALL OPNFIL (KUNIT,HFNAM3,ISPEC3,MEM3,IFFR3,ILFR3,NCHAN3,
     &                NFRAM3,IRC)
         IF (IRC.NE.0) GOTO 50
         ISPEC3=ISPEC3+INCR3
C
C========OPEN CALIBRATION & DATA FILES FOR DATA FILE
C
         CALL OPNFIL (LUNIT,HFNAM4,ISPEC4,MEM4,IFFR4,ILFR4,NCHAN4,
     &                NFRAM4,IRC)
         IF (IRC.NE.0) GOTO 50
         ISPEC4=ISPEC4+INCR4
         CALL OPNFIL (MUNIT,HFNAM5,ISPEC5,MEM5,IFFR5,ILFR5,NCHAN5,
     &                NFRAM5,IRC)
         IF (IRC.NE.0) GOTO 50
         ISPEC5=ISPEC5+INCR5
C
C========READ CALIBRATION FILES FOR BUFFER AND DATA
C
         READ (JUNIT,REC=IFFR2) (SP2(K),K=1,NCHAN2)
         READ (LUNIT,REC=IFFR4) (SP3(K),K=1,NCHAN4)
C
         DO 30 J=1,IFRMX5
C
C========PROCESS THE DATA
C
            READ (KUNIT,REC=IFFR3) (SP4(K),K=1,NCHAN3)
            READ (MUNIT,REC=IFFR5) (SP5(K),K=1,NCHAN5)
            KREC=KREC+1
C
            CALL FILL (SP6,NCHAN5,0.0)
            CALL FILL (SP7,NCHAN5,0.0)
            DO 20 K=JCH1,JCH2
               IF (SP2(IFFR2).LT.0.00000001) THEN
                  SP4(K)=0.0
               ELSE
                  SP4(K)=SP4(K)/SP2(IFFR2)
               ENDIF
C
               IF (SP3(IFFR4).LT.0.00000001) THEN
                  SP5(K)=0.0
               ELSE
                  SP5(K)=SP5(K)/SP3(IFFR4)
               ENDIF
C
C    J.Fernando Diaz Nov 91 allows to choose buffer weight
C
               SP6(K)=BUFFER(1)*SP5(K)-BUFFER(2)*SP4(K)
               TEMP=SP1(K)*WEIGHT(2)
               IF (ABS(TEMP).LT.0.00000001) THEN
                  SP6(K)=0.0
               ELSE
                  SP6(K)=SP6(K)*WEIGHT(1)/TEMP
               ENDIF
20          CONTINUE
C
C========RIGHT SHIFT
C
            IF (ISHIFT.GT.0) THEN
               DO 21 L=1,IFIRST-1
                  SP7(L)=SP6(L)
21             CONTINUE
               DO 22 L=IFIRST+ISHIFT,ILAST
                  SP7(L)=SP6(L-ISHIFT)
22             CONTINUE
               DO 23 L=ILAST+1,NCHAN5
                  SP7(L)=SP6(L)
23             CONTINUE
C
C========LEFT SHIFT
C
            ELSE
               DO 24 L=NCHAN5,ILAST+1,-1
                  SP7(L)=SP6(L)
24             CONTINUE
               DO 25 L=ILAST+ISHIFT,IFIRST,-1
                  SP7(L)=SP6(L-ISHIFT)
25             CONTINUE
               DO 26 L=IFIRST-1,1,-1
                  SP7(L)=SP6(L)
26             CONTINUE
            ENDIF
            IFFR3=IFFR3+IFINC3
            IFFR5=IFFR5+IFINC5

            IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP7,NCHAN5)
            IF (KREC.GE.IFRAME) ICLO=1
            IF (KREC.EQ.1) THEN
               CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
               IF (IRC.NE.0) GOTO 50
            ENDIF
            CALL DAWRT (NUNIT,OFNAM,IMEM,NCHAN5,IFRAME,HEAD1,HEAD2,
     1                  SP7,KREC,JOP,ICLO,IRC)
            IF (IRC.NE.0) GOTO 50
 30      CONTINUE
         CLOSE (UNIT=JUNIT)
         CLOSE (UNIT=KUNIT)
         CLOSE (UNIT=LUNIT)
         CLOSE (UNIT=MUNIT)
 40   CONTINUE
 50   CLOSE (UNIT=JUNIT)
      CLOSE (UNIT=KUNIT)
      CLOSE (UNIT=LUNIT)
      CLOSE (UNIT=MUNIT)
      CLOSE (UNIT=NUNIT)
      GOTO 10
999   RETURN
1000  FORMAT (' Enter weights for detector division [1.0,1.0]: ',$)
1010  FORMAT (' Enter first & last channels to shift: ',$)
1020  FORMAT (' Enter shift +ve for right -ve for left: ',$)
1030  FORMAT (' Enter weights for buffer substraction [1.0,1.0]: ',$)  
      END
