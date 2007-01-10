C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE GENITP
      IMPLICIT NONE
C
C Purpose: Generate a frame of data using interpolation
C
      INCLUDE 'COMMON.FOR'
C
C Calls   3: APLOT , DAWRT  , ERRMSG , GETVAL 
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),SLOPE,CONST
      INTEGER NCHAN,IMEM,IFRAME,KREC,JOP,ICLO,IRC,NVAL
      INTEGER I,L,KVAL,ICHAN,JCH1,JCH2,K1,K2
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 OFNAM
C
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C IFRAME : Total nos. of frames
C KREC   : Output file record
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C VALUE  : Values entered at the terminal
C NVAL   : Nos. of values entered at terminal
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C
      DATA KREC/1/ , IFRAME/1/ , IMEM/1/
C
C-----------------------------------------------------------------------
      KVAL=0
      JOP=0
      ICLO=1
      NCHAN=512
      CALL GETCHN (ITERM,IPRINT,NCHAN,JCH1,JCH2,IRC)
      IF (IRC.EQ.0) THEN
         CALL FILL (SP2,NCHAN,0.0)
         NCHAN=JCH2-JCH1+1
10       WRITE (IPRINT,1000)
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 20
         IF (IRC.EQ.2) GOTO 10
         IF (NVAL.LT.2) THEN
            CALL ERRMSG ('Error: Two values required')
            GOTO 10
         ELSE
            KVAL=KVAL+1
            SP1(KVAL)=VALUE(1)
            ICHAN=INT(VALUE(1))
            SP2(ICHAN)=VALUE(2)
         ENDIF
         GOTO 10
C
C======INTERPOLATE BETWEEN CHANNELS
C
20       DO 40 I=1,KVAL-1
            K1=INT(SP1(I))
            K2=INT(SP1(I+1))
            SLOPE=(SP2(K2)-SP2(K1))/(SP1(I+1)-SP1(I))
            CONST=(SP1(I)*SP2(K2)-SP1(I+1)*SP2(K1))/(SP1(I)-SP1(I+1))
            DO 30 L=K1+1,K2-1
               SP2(L)=SLOPE*REAL(L)+CONST
30          CONTINUE
40       CONTINUE
C
         CALL APLOT (ITERM,IPRINT,SP2,NCHAN)
         CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
         IF (IRC.EQ.0) THEN
            CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     &               SP2,KREC,JOP,ICLO,IRC)
         ENDIF
      ENDIF
      RETURN
C
1000  FORMAT (' Enter channel & value or <CTRL-Z>: ',$)
      END
