C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE POE
      IMPLICIT NONE
C
C Purpose: 
C
      INCLUDE 'COMMON.FOR'
C
C CALLS   3: GETHDR , OPNFIL , DAWRT
C CALLED BY: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL    VALUE(10)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NFRAME,I,J,K,L
      INTEGER NCHANX,NCHAN,NVAL,ICH1,ICH2,IOCH1,IOCH2,NPTS,MDEG,MFRAME
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
C ISPEC  : Frame nos. part of filename
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
      WRITE (IPRINT,*) 'X-axis'
      CALL GETXAX (NCHANX,IRC)
      IF (IRC.NE.0) GOTO 999
10    ICLO=0
      JOP=0
      KREC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IFRAME=IHFMAX+IFRMAX-1
C
20    WRITE (IPRINT,1000) NCHAN
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.GE.1) ICH1=INT(VALUE(1))
      IF (NVAL.GE.2) ICH2=INT(VALUE(2))
      IF (ICH2.LE.ICH1) THEN
         CALL ERRMSG ('Error: Invalid channel range')
         GOTO 20
      ENDIF
      IF (ICH1.LT.0.OR.ICH2.LT.0) THEN
         CALL ERRMSG ('Error: Invalid channel range')
         GOTO 20
      ENDIF
      NPTS=ICH2-ICH1+1
C
      CALL GETCHN (ITERM,IPRINT,NCHAN,IOCH1,IOCH2,IRC)
30    WRITE (IPRINT,1010)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 30
      IF (NVAL.EQ.0) THEN
         MDEG=1
      ELSE
         MDEG=INT(VALUE(1))
      ENDIF
C
      DO 60 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 50 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               CALL FILL (SP2,NPTS,1.0)
               CALL VC01A(XAX(ICH1),SP1(ICH1),SP2,SP5,NPTS,SP6,SP7,SP8,
     1                    SP9,SP10,SP11,MDEG,SPW)
               NPTS=IOCH2-IOCH1+1
               DO 40 K=1,NPTS
                  L=IOCH1-1+K
                  SP1(L)=REAL(K)
40             CONTINUE
               CALL POLCAL(SP3,SP1(ICH1),SP6,SP7,SP8,MDEG,1,NPTS)
               CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
               IF (IRC.NE.0) GOTO 70
               CALL DAWRT (KUNIT,OFNAM,IMEM,NPTS,MFRAME,HEAD1,HEAD2,
     1                     SP3,1,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 70
               CALL DAWRT (KUNIT,OFNAM,IMEM,NPTS,MFRAME,HEAD1,HEAD2,
     1                     SP1(ICH1),2,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 70
50          CONTINUE
            CLOSE(UNIT=JUNIT)
         ENDIF
60    CONTINUE
70    CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter first and last channels of output [1,',
     &        I4,']: ',$)
1010  FORMAT (' Enter degree of polynomial [1]: ',$)
      END
