C      LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE MERGE (XAXIS)
      IMPLICIT NONE
C
C Purpose: Merge a series of time frames of data into one frame.
C          Dataset input sequence is terminated by <ctrl-Z> for VMS
C          <ctrl-D> for unix.
C          Maximum final frame size should not exceed 8192.
C
      LOGICAL XAXIS
C
C XAXIS  : X AXIS TYPE MERGE
C
      INCLUDE 'COMMON.FOR'
C
C Calls   4: APLOT  , ASKYES , DAWRT  , GETHDR , OPNFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER ICLO,JOP,IRC,IMEM,KREC,IFRAME,NCHAN1,NFRAM1
      INTEGER ISPEC1,LSPEC1,MEM1,IFFR1,ILFR1,INCR1,IFINC1
      INTEGER ISPEC2,LSPEC2,MEM2,IFFR2,ILFR2,INCR2,IFINC2
      INTEGER IHFMX1,IFRMX1,IHFMX2,IFRMX2,NCHAN2
      INTEGER MFRAME,NPOINT,NFRAM2,NSAME,I,J,K
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM1,HFNAM2,OFNAM,XFNAM
      LOGICAL AVE,ASKYES
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
C NCHAN1 : Nos of data points in spectrum 1
C NCHAN2 : Nos of data points in spectrum 2
C NFRAME : Nos of time frames
C NPOINT : Nos. of channels in output frame
C MFRAME : Nos. of frames to be output
C
      DATA  IMEM/1/ , KREC/1/ , MFRAME/1/ , ICLO/1/
C
C-----------------------------------------------------------------------
10    NPOINT=0
C
20    CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM1,ISPEC1,LSPEC1,INCR1,MEM1,
     1             IFFR1,ILFR1,IFINC1,IHFMX1,IFRMX1,NCHAN1,IRC)
      IF (IRC.EQ.0) THEN
         IF (XAXIS) THEN
            WRITE (IPRINT,*) 'X-axis'
            CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM2,ISPEC2,LSPEC2,INCR2,
     1               MEM2,IFFR2,ILFR2,IFINC2,IHFMX2,IFRMX2,NCHAN2,IRC)
            IF (IRC.NE.0) GOTO 20
         ENDIF
C
         IFRAME=IHFMX1+IFRMX1-1
         DO 40 I=1,IFRAME
C
            IF (I.EQ.1.OR.INCR1.NE.0) THEN
               CALL OPNFIL (JUNIT,HFNAM1,ISPEC1,MEM1,IFFR1,ILFR1,NCHAN1,
     1                      NFRAM1,IRC)
               IF (IRC.NE.0) GOTO 50
               ISPEC1=ISPEC1+INCR1
            ENDIF
            READ (JUNIT,REC=IFFR1) (SP1(K),K=1,NCHAN1)
            IFFR1=IFFR1+IFINC1
            IF (INCR1.NE.0) CLOSE (UNIT=JUNIT)
C
            IF (XAXIS) THEN
               IF (I.EQ.1.OR.INCR2.NE.0) THEN
                  CALL OPNFIL (LUNIT,HFNAM2,ISPEC2,MEM2,IFFR2,ILFR2,
     1                         NCHAN2,NFRAM2,IRC)
                  IF (IRC.NE.0) GOTO 50
                  ISPEC2=ISPEC2+INCR2
               ENDIF
               READ (LUNIT,REC=IFFR2) (SP2(K),K=1,NCHAN2)
               IFFR2=IFFR2+IFINC2
               IF (INCR2.NE.0) CLOSE (UNIT=LUNIT)
            ENDIF
C
            DO 30 K=1,NCHAN1
               NPOINT=NPOINT+1
               SPW(NPOINT)=SP1(K)
               IF (XAXIS) SP10(NPOINT)=SP2(K)
30          CONTINUE
40       CONTINUE
50    CLOSE (UNIT=JUNIT)
      CLOSE (UNIT=LUNIT)
      ELSE
         IF (NPOINT.NE.0) THEN
            IF (XAXIS) THEN
               WRITE (IPRINT,1000)
               AVE=ASKYES (ITERM,IRC)
               IF (IRC.NE.0) GOTO 10
               CALL BSORT (SP10,SPW,NPOINT)
               I=1
               J=1
60             SP10(J)=SP10(I)
               SPW(J)=SPW(I)
               I=I+1
               NSAME=I
70             IF (I.LE.NPOINT) THEN
                  IF (SP10(I).EQ.SP10(J)) THEN
                     I=I+1
                     GOTO 70
                  ENDIF
               ENDIF
               IF ((AVE).AND.(I.NE.NSAME)) THEN
                  DO 80 K=NSAME,I-1
                     SPW(J)=SPW(J)+SPW(K)
80                CONTINUE
                  SPW(J)=SPW(J)/(I+1-NSAME)
               ENDIF
               J=J+1
               IF (I.LE.NPOINT) GOTO 60
               NPOINT=J-1
            ENDIF
            CALL APLOT (ITERM,IPRINT,SPW,NPOINT)
            CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
            IF (IRC.EQ.0) THEN
               JOP=0
               CALL DAWRT (KUNIT,OFNAM,IMEM,NPOINT,MFRAME,HEAD1,HEAD2,
     1                     SPW,KREC,JOP,ICLO,IRC)
               IF (IRC.EQ.0.AND.XAXIS) THEN
                  WRITE (IPRINT,*) 'X-axis'
                  CALL OUTFIL (ITERM,IPRINT,XFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.EQ.0) THEN
                    JOP=0
                     CALL DAWRT (IUNIT,XFNAM,IMEM,NPOINT,MFRAME,HEAD1,
     1                           HEAD2,SP10,KREC,JOP,ICLO,IRC)
                  ENDIF
               ENDIF
            ENDIF
            GOTO 10
         ELSE
            GOTO 999
         ENDIF
      ENDIF
      GOTO 20
999   RETURN
C
1000  FORMAT (' Do you want equivalent points averaged [Y/N] [Y]: ',$)
      END
