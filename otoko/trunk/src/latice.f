C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE LATICE
      IMPLICIT NONE
C
C Purpose: Calculate electron densities from amplitudes.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   9: DAWRT  , ERRMSG , GETHDR , GETXAX , OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    RDIST,ZMIN,ZMAX,DZ,VALUE(10),TWOPI,TEMP
      INTEGER ICLO,JOP,IRC,IMEM,KREC,IFRAME,NCHAN
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER IHFMX1,IFRMX1,IHFMX2,IFRMX2,NCHAN1,NVAL
      INTEGER NZ,NFRAM1,NFRAM2,I,J,K
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM1,HFNAM2,OFNAM
      LOGICAL ZFACT,ASKNO
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
C NCHAN1 : Nos of data points in spectrum 2
C NFRAME : Nos of time frames
C RDIST  : REPEAT DISTANCE
C ZMIN   : 
C DZ     :
C NZ     :
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      KREC=0
C
      WRITE (IPRINT,*) 'Modulus data'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     1             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
      WRITE (IPRINT,*) 'Phase data'
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,INCR2,MEM2,
     1             IFFR2,ILFR2,IFINC2,IHFMX2,IFRMX2,NCHAN1,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IF (NCHAN1.NE.NCHAN) THEN
         CALL ERRMSG ('Error: Incompatible number of channels')
         GOTO 10
      ENDIF
      IF (IHFMX1.LT.IHFMX2) IHFMX1=IHFMX2
      IF (IFRMX1.LT.IFRMX2) IFRMX1=IFRMX2
      IFRAME=IHFMX1+IFRMX1-1
C
20    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.LT.3) GOTO 20
      ZMIN=VALUE(1)
      ZMAX=VALUE(2)
      NZ=INT(VALUE(3))
      DZ=(ZMAX-ZMIN)/(NZ-1)
30    WRITE (IPRINT,1010)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 30
      IF (NVAL.NE.1) GOTO 30
      RDIST=VALUE(1)
      WRITE (IPRINT,1020)
      ZFACT=ASKNO(ITERM,IRC)
      IF (IRC.NE.0) GOTO 10
C
      TWOPI=ACOS (-1.0)
      DO 50 I=1,IFRAME
C
         IF (I.EQ.1.OR.INCR1.NE.0) THEN
            CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NCHAN,
     1                   NFRAM1,IRC)
            IF (IRC.NE.0) GOTO 60
            ISPEC1=ISPEC1+INCR1
         ENDIF
         IF (I.EQ.1.OR.INCR2.NE.0) THEN
            CALL OPNFIL (LUNIT,HFNAM2,ISPEC2,MEM2,IFFR2,ILFR2,NCHAN1,
     1                   NFRAM2,IRC)
            IF (IRC.NE.0) GOTO 60
            ISPEC2=ISPEC2+INCR2
         ENDIF
C
         READ (JUNIT,REC=IFFR1) (SP1(K),K=1,NCHAN)
         READ (LUNIT,REC=IFFR2) (SP2(K),K=1,NCHAN)
         IFFR1=IFFR1+IFINC1
         IFFR2=IFFR2+IFINC2
         KREC=KREC+1
         IF (INCR1.NE.0) CLOSE (UNIT=JUNIT)
         IF (INCR2.NE.0) CLOSE (UNIT=LUNIT)
C
         DO 35 J=1,NZ
            XAX(J)=ZMIN
            IF (ZFACT) THEN
               SP3(J)=0.0
               DO 45 K=1,NCHAN
                  TEMP=TWOPI*REAL(K)*ZMIN/RDIST
                  SP3(J)=SP3(J)+(2.0*(SP1(K)*COS(SP2(K))*COS(TEMP)
     1                   +SP1(K)*SIN(SP2(K))*SIN(TEMP))/RDIST)
45             CONTINUE
            ELSE
               SP3(J)=SP1(1)*COS(SP2(1))/RDIST
               DO 40 K=2,NCHAN
                  TEMP=TWOPI*REAL(K-1)*ZMIN/RDIST
                  SP3(J)=SP3(J)+(2.0*(SP1(K)*COS(SP2(K))*COS(TEMP)
     1                   +SP1(K)*SIN(SP2(K))*SIN(TEMP))/RDIST)
40             CONTINUE
            ENDIF
            ZMIN=ZMIN+DZ
35       CONTINUE
C
         IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP3,NZ)
         IF (KREC.GE.IFRAME) ICLO=1
         IF (KREC.EQ.1) THEN
            CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF (IRC.NE.0) GOTO 60
         ENDIF
         CALL DAWRT (KUNIT,OFNAM,IMEM,NZ,IFRAME,HEAD1,HEAD2,
     1               SP3,KREC,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 60
50    CONTINUE
60    CLOSE (UNIT=JUNIT)
      CLOSE (UNIT=LUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter Zmin,Zmax and nZ: ',$)
1010  FORMAT (' Enter repeat distance: ',$)
1020  FORMAT (' Do you want to include the zero factor [Y/N] [N]: ',$)
      END
