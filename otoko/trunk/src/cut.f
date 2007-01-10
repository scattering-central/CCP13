C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE CUT
      IMPLICIT NONE
C
C Purpose: Cut a frame into a series of frames such that the number of 
C          channels in all output frames corresponds to the maximum 
C          number of channels requested. All channels between requested
C          number and the maximum number are set to zero.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   7: DAWRT , ERRMSG , FILL , GETHDR , GETVAL , OPNFIL , OUTFIL 
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    CUTLIM(20)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER ISAVE1,ISAVE2,I,J,K,L,ICUT,NVAL,MCHAN,ICH1,ICH2
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C KREC   : Output file record
C ISPEC  : First header file of sequence
C LSPEC  : Last header file in sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C OFNAM  : Output header filename
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C CUTLIM : Limits for frame cutting
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
10    KREC=0
      JOP=0
      ICLO=0
      ICUT=1
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IFRAME=IHFMAX+IFRMAX-1
20    DO 50 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISAVE1=ISPEC
            ISAVE2=IFFR
            ISPEC=ISPEC+INCR
            DO 40 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               IF (ICUT.EQ.1.AND.KREC.EQ.1) THEN
30                WRITE (IPRINT,1000)
                  CALL GETVAL (ITERM,CUTLIM,NVAL,IRC)
                  IF (IRC.EQ.1) GOTO 60
                  IF (IRC.EQ.2) GOTO 30
                  IF (NVAL.GT.10) THEN
                     CALL ERRMSG ('Error: Too many portions cut')
                     GOTO 30
                  ENDIF
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 60
                  MCHAN=0
                  DO 19 K=1,NVAL-1
                     ICH1=INT(CUTLIM(K))
                     ICH2=INT(CUTLIM(K+1))-1
                     IF (ICH2.GT.NCHAN) ICH2=NCHAN
                     IF ((ICH2-ICH1+1).GT.MCHAN) MCHAN=ICH2-ICH1+1
19                CONTINUE
               ENDIF
               ICH1=INT(CUTLIM(ICUT))
               ICH2=INT(CUTLIM(ICUT+1))-1
               IF (ICH1.GT.0) THEN
                  IF (ICH2.LT.0.OR.ICH2.GT.NCHAN) ICH2=NCHAN
                  CALL FILL (SP2,MCHAN,0.0)
                  DO 15 L=ICH1,ICH2
                     SP2(L-ICH1+1)=SP1(L)
15                CONTINUE
                  IF (KREC.GE.IFRAME) ICLO=1
                  CALL DAWRT (KUNIT,OFNAM,IMEM,MCHAN,IFRAME,HEAD1,
     1                        HEAD2,SP2,KREC,JOP,ICLO,IRC)
                  IF (IRC.NE.0) GOTO 60
               ENDIF
40          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
50    CONTINUE
60    CLOSE (UNIT=JUNIT)
      ICUT=ICUT+1
      IF (ICUT.LE.NVAL-1) THEN
         OFNAM(4:4)='0'
         OFNAM(5:5)='0'
         OFNAM(6:6)='0'
         OFNAM(10:10)=CHAR(48+ICUT-1)
         KREC=0
         ICLO=0
         JOP=0
         ISPEC=ISAVE1
         IFFR=ISAVE2
         GOTO 20
      ENDIF
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter channels to be cut (max 10): ',$)
      END
