C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE PEAK
      IMPLICIT NONE
C
C Purpose: Fit background under a peak.
C
      INCLUDE 'COMMON.FOR'
C
C Calls   8: CURSOR , GETHDR , GETCHN , FRPLOT , OPNFIL , APLOT  , DAWRT
C            OUTFIL
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    XPOS,YPOS,SLOPE,CONST
      INTEGER ICALL,IAXIS,IAUTO,IPLOT,IWINDO,ISYMB,ICOL(8)
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER ICH1,ICH2,JCH1,JCH2,NPOINT,NDATA,KCHAR,I,J,K,L
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM
      CHARACTER*6  TITLE,XANOT,YANOT
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
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C ISYMB  : GHOST symbol
C
      DATA IMEM/1/ , ICOL/0,0,0,0,0,0,0,0/
      DATA IAXIS/1/ , IAUTO/0/ , IPLOT/2/ , IWINDO/0/
      DATA XANOT/'X-AXIS'/ , YANOT/'Y-AXIS'/, TITLE/' '/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      KREC=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
      IF (IRC.NE.0) GOTO 10
      IFRAME=IHFMAX+IFRMAX-1
      DO 40 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 30 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               ICALL=0
               DO 12 K=1,NCHAN
                  XAX(K)=REAL(K)
12             CONTINUE
               NPOINT=ICH2-ICH1+1
               CALL FRPLOT (ITERM,IPRINT,XAX(ICH1),SP1(ICH1),NPOINT,
     &                     ICALL,IAXIS,IAUTO,IPLOT,IWINDO,ISYMB,ICOL,
     &                     XANOT,YANOT,TITLE)
               NDATA=0
20             CALL CURSOR (XPOS,YPOS,KCHAR)
               IF (KCHAR.NE.83.AND.KCHAR.NE.115.AND.KCHAR.NE.109) THEN
                  NDATA=NDATA+1
                  SP3(NDATA)=YPOS
                  SP4(NDATA)=REAL(INT(XPOS))
                  GOTO 20
               ENDIF
               call trmode
               IF (NDATA.GE.2) THEN
                     CALL FILL (SP2,NCHAN,0.0)
                     CALL FILL (SP6,NCHAN,0.0)
                     DO 70 K=1,NDATA-1,2
                        SLOPE=(SP3(K)-SP3(K+1))/(SP4(K)-SP4(K+1))
                        CONST=(SP4(K)*SP3(K+1)-SP4(K+1)*SP3(K))/
     1                        (SP4(K)-SP4(K+1))
                        JCH1=INT(SP4(K))
                        JCH2=INT(SP4(K+1))
                        DO 80 L=JCH1,JCH2
                           SP2(L)=SLOPE*REAL(L)+CONST
                           SP6(L)=SP1(L)-SP2(L)
80                      CONTINUE
70                   CONTINUE
                     IF (IFRAME.EQ.1) CALL APLOT (ITERM,IPRINT,SP6,
     1                                            NCHAN)
                     IF (KREC.GE.IFRAME) ICLO=1
                     IF (KREC.EQ.1) THEN
                        CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                        IF (IRC.NE.0) GOTO 50
                     ENDIF
                     CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,
     1                           HEAD2,SP6,KREC,JOP,ICLO,IRC)
                     IF (IRC.NE.0) GOTO 50
               ENDIF
30          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
40    CONTINUE
50    CLOSE (UNIT=JUNIT)
      GOTO 10
999   RETURN
C
      END
