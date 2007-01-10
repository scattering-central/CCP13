C     LAST UPDATE 08/04/88
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE PNT
C
C Purpose: Select points with the cursor and save in file
C
       INCLUDE 'COMMON.FOR'
C
C Calls   4: GETHDR , OPNFIL , APLOT  , DAWRT
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      INTEGER ICALL,IAXIS,IAUTO,IPLOT,IWINDO,ISYMB,jclo,iop
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,ICOL(8)
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,XFNAM
      CHARACTER*6  TITLE,XANOT,YANOT
      LOGICAL XAXIS
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
      DATA IMEM/1/
      DATA XANOT/'X-AXIS'/ , YANOT/'Y-AXIS'/, TITLE/' '/
C
C-----------------------------------------------------------------------
      xaxis=.false.
      WRITE (IPRINT,*) 'X-axis'
      CALL GETXAX (NCHANX,IRC)
      IF (IRC.NE.0) GOTO 10
      xaxis=.true.
10    ICLO=0
      JOP=0
      iop=0
      jclo=0
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
               if (.not.xaxis) then
                  DO 12 K=1,NCHAN
                     XAX(K)=REAL(K)
12                CONTINUE
               endif
               IF (ICALL.EQ.0.OR.IWINDO.NE.0) THEN
                  CALL INIPLO (ITERM,IPRINT,ICALL,IAXIS,IAUTO,IPLOT,
     1                         IWINDO,ISYMB,ICOL,XANOT,YANOT,TITLE,IRC)
                  IF (IRC.NE.0) GOTO 999
               ENDIF
               NPOINT=ICH2-ICH1+1
               CALL FRPLOT (ITERM,IPRINT,XAX(ICH1),SP1(ICH1),NPOINT,
     &         ICALL,IAXIS,IAUTO,IPLOT,IWINDO,ISYMB,ICOL,XANOT,
     &         YANOT,TITLE)
               ndata=0
20             CALL CURSOR (XPOS,YPOS,KCHAR)
               call plotnc (xpos,ypos,239)
               IF (KCHAR.NE.83.AND.KCHAR.NE.115.AND.KCHAR.NE.109) THEN
                  ndata=ndata+1
                  sp2(ndata)=xpos
                  GOTO 20
               ENDIF
               call trmode
               do 60 k=1,ndata
                  if (xaxis) then
                     xpos=sp2(k)
                     sp4(k)=xpos
                     do 70 l=ich1,ich2
                        if (xpos.eq.xax(l)) then
                           sp3(k)=sp1(l)
                           goto 55
                       elseif (xpos.gt.xax(l).and.xpos.lt.xax(l+1)) then
                          sp3(k)=((sp1(l+1)-sp1(l))*(xpos-xax(l))/
     &                               (xax(l+1)-xax(l)))+sp1(l)
                           goto 55
                        endif
70                   continue
                  else
                     xpos=sp2(k)
                     SP4(k)=REAL(NINT(XPOS))
                     SP3(k)=sp1(nint(xpos))
                  endif
 55               print *,'X = ',sp4(k),' Y = ',sp3(k)
60             continue
c
c========output files
c
               if (ndata.ne.1) then
                  IF (KREC.GE.IFRAME) ICLO=1
                  IF (KREC.GE.IFRAME) jCLO=1
                  IF (KREC.EQ.1) THEN
                     CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                     IF (IRC.NE.0) GOTO 50
                  ENDIF
                  XFNAM=OFNAM
                  XFNAM(10:10)='X'
                  CALL DAWRT (KUNIT,OFNAM,IMEM,NDATA,IFRAME,HEAD1,
     1                 HEAD2,SP3,KREC,IOP,ICLO,IRC)
                  IF (IRC.NE.0) GOTO 50
                  CALL DAWRT (LUNIT,XFNAM,IMEM,NDATA,IFRAME,HEAD1,
     1                     HEAD2,SP4,KREC,JOP,JCLO,IRC)
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

