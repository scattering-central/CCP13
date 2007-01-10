C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE WINDO
      IMPLICIT NONE
C
C Purpose: Create a TUKEY window function for FFT's.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   5: APLOT  , DAWRT  ,  GETCHN , GETVAL , OUTFIL , FILL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),PI,YPOS
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL
      INTEGER ISIDE,IEDGE1,IEDGE2,KCHAR,IMEM,JCH1,JCH2,NPOINT,I,J,K
      INTEGER ICALL,IAXIS,IAUTO,IPLOT,IWINDO,ISYMB,ICOL(8)
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,TFNAM
      CHARACTER*6  TITLE,XANOT,YANOT
C
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C ISPEC  : First header file of sequence
C LSPEC  : Last header file in sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C NFRAME : Nos. of time frames
C ICLO   : Close file indicator
C JOP    : Open file indicator
C IRC    : Return code
C KREC   : Output file record
C HFNAM  : Header filename
C OFNAM  : Output header filename
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NVAL   : Nos. of values entered at terminal
C ISYMB  : GHOST symbol
C
      DATA IAXIS/1/ , IAUTO/0/ , IPLOT/2/ , IWINDO/0/
      DATA XANOT/'X-AXIS'/ , YANOT/'Y-AXIS'/, TITLE/' '/
      DATA  IMEM/1/ , ICOL/0,0,0,0,0,0,0,0/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      KREC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
      DO 90 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 80 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               CALL GETCHN (ITERM,IPRINT,NCHAN,JCH1,JCH2,IRC)
               IF (IRC.NE.0) GOTO 999
               IF (JCH1.EQ.0) JCH1=1
               IF (JCH2.EQ.0) JCH2=NCHAN
               NPOINT=JCH2-JCH1+1
20             WRITE (IPRINT,1000)
               CALL GETVAL (ITERM,VALUE,NVAL,IRC)
               IF (IRC.EQ.1) THEN
                  ICALL=0
                  DO 30 K=1,NCHAN
                     XAX(K)=REAL(K)
30                CONTINUE
                  CALL FRPLOT (ITERM,IPRINT,XAX(JCH1),SP1(JCH1),NPOINT,
     &                         ICALL,IAXIS,IAUTO,IPLOT,IWINDO,ISYMB,
     &                         ICOL,XANOT,YANOT,TITLE)
                  CALL CURSOR (VALUE(1),YPOS,KCHAR)
                  CALL PLOTNC (VALUE(1),YPOS,231)
                  CALL CURSOR (VALUE(2),YPOS,KCHAR)
                  CALL PLOTNC (VALUE(2),YPOS,231)
                  IEDGE1=INT(VALUE(1))
                  IEDGE2=INT(VALUE(2))
                  call trmode
               ELSE
                  IF (IRC.EQ.2) GOTO 20
                  IF (NVAL.LT.2) GOTO 20
                  IEDGE1=INT(VALUE(1))
                  IEDGE2=INT(VALUE(2))
               ENDIF
40             WRITE (IPRINT,1010)
               CALL GETVAL (ITERM,VALUE,NVAL,IRC)
               IF (IRC.EQ.1) GOTO 999
               IF (IRC.EQ.2) GOTO 40
               IF (NVAL.EQ.0) GOTO 40
               ISIDE=INT(VALUE(1))
C
               CALL FILL (SP2,NCHAN,0.0)
               PI=ACOS(-1.0)
               DO 50 K=IEDGE1-ISIDE,IEDGE1
                  SP2(K)=0.5*(1.0+COS(PI*(K-IEDGE1)/ISIDE))
50             CONTINUE
               DO 60 K=IEDGE1,IEDGE2
                  SP2(K)=1.0
60             CONTINUE
               DO 70 K=IEDGE2,IEDGE2+ISIDE
                  SP2(K)=0.5*(1.0+COS(PI*(K-IEDGE2)/ISIDE))
70             CONTINUE
               DO 75 K=1,NCHAN
                  SP1(K)=SP1(K)*SP2(K)
75             CONTINUE
C
               IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP1,NCHAN)
               IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  WRITE (IPRINT,*) 'Windowed function'
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
               ENDIF
               CALL DAWRT (LUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP1,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 100
               IF (KREC.EQ.1) THEN
                  JOP=0
                  WRITE (IPRINT,*) 'Tukey window'
                  CALL OUTFIL (ITERM,IPRINT,TFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 100
               ENDIF
               CALL DAWRT (KUNIT,TFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1                     SP2,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 100
80          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
90    CONTINUE
100   CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter start & end of flat top or <CTRL Z> for cursor',
     1        ' selection: ',$)
1010  FORMAT (' Enter width of side lobe: ',$)
      END
