C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE rback (XAXIS)
      IMPLICIT NONE
C
C PURPOSE: background subtraction
C
      LOGICAL XAXIS
      INCLUDE 'COMMON.FOR'
C
C CALLED BY: MAIN
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      real         const,slope
      REAL         VALUE(10),XPOS,YPOS,SP0(5000),PCENT(25)
      INTEGER      ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,NCHAN,NFRAME,IMEM
      INTEGER      KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,I,J,K
      INTEGER      IMIN(25),IMAX(25),JMIN,JMAX,NSTART,NTOT(25)
      INTEGER      NPOINT,NDATA,ICH1,ICH2,ICOL(8)
      INTEGER      ICALL,IPLOT,IAUTO,ISYMB,IAXIS,IWINDO,KCHAR,IXPOS
      INTEGER      NREG,M,N,L,jch1,jch2,jclo,iop,nchanx
      CHARACTER*80 HEAD1,HEAD2
      CHARACTER*13 HFNAM,OFNAM,PFNAM
      CHARACTER*6  TITLE,XANOT,YANOT
      LOGICAL      REPEAT,ASKNO,SAME,ASKYES,SAVE
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
C HEAD1  : Output header rcoerd 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C
      DATA IMEM/1/ , ICOL/0,0,0,0,0,0,0,0/
      DATA IAXIS/1/ , IAUTO/1/ , IWINDO/0/
      DATA XANOT/'X-AXIS'/ , YANOT/'Y-AXIS'/, TITLE/' '/
C
C-----------------------------------------------------------------------
      IF (XAXIS) THEN
         WRITE (IPRINT,*) 'Background point file'
         CALL GETXAX (NCHANX,IRC)
         IF (IRC.NE.0) GOTO 999
         do 15 i=1,nchanx
            sp1(i)=xax(i)
 15      continue
         nreg=1
         ntot(1)=nchanx
         imin(1)=sp1(1)
         imax(1)=sp1(nchanx)
      ENDIF
 10   ICLO=0
      JOP=0
      KREC=0
      JCLO=0
      IOP=0
      save=.FALSE.
C     
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &     ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C     
      DO 20 J=1,NCHAN
         SP6(J)=REAL(J)
 20   CONTINUE
C     
      if (xaxis) then
         PCENT(NREG)=1.0
 25      WRITE (IPRINT,1040) 
         CALL GETVAL (ITERM,VALUE,NVAL,IRC)
         IF (IRC.EQ.1) GOTO 160
         IF (IRC.EQ.2) GOTO 25
         IF (NVAL.GE.1) PCENT(NREG)=VALUE(1)
         IF (PCENT(NREG).LE.0.0.OR.
     &        PCENT(NREG).GT.100.0) GOTO 25
         PCENT(NREG)=PCENT(NREG)/100.
      else
         print *,' '
         print *,'Select points with any key or   left mouse button'
         print *,'Finish selection with  S,s or middle mouse button'
         print *,'Repeat selection with  R,r or  right mouse button'
         print *,' '
      endif
      DO 150 I=1,IHFMAX
C     
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
            ISPEC=ISPEC+INCR
C     
            SAME=.FALSE.
            if (xaxis) same=.TRUE.
            DO 140 J=1,IFRMAX
C     
 30            IF (.NOT.SAME) NREG=1
 40            IF (SAME) THEN
                  READ (JUNIT,REC=IFFR) (SP12(K),K=1,NCHAN)
                  NSTART=1
                  DO 60 M=1,NREG
                     DO 50 K=1,NTOT(M)
                        N=NSTART+K-1
                        IXPOS=INT(SP1(N))
                        SP2(N)=SP12(IXPOS)
                        SP2(N)=SP2(N)-PCENT(M)*SP2(N)
 50                  CONTINUE
C     
                     NPOINT=NTOT(M)-NSTART+1
                     JMIN=IMIN(M)
                     JMAX=IMAX(M)
                     IF (M.EQ.1) CALL FILL (SP0,NCHAN,0.0)
                     IF (Npoint.GE.2) THEN
                        DO 71 K=1,npoint-1
                           SLOPE=(SP2(K)-SP2(K+1))/(SP1(K)-SP1(K+1))
                           CONST=(SP1(K)*SP2(K+1)-SP1(K+1)*SP2(K))/
     1                          (SP1(K)-SP1(K+1))
                           jmin=INT(SP1(K))
                           jmax=INT(SP1(K+1))
                           DO 81 L=jmin,jmax
                              SP0(L)=SLOPE*REAL(L)+CONST
 81                        CONTINUE
 71                     CONTINUE
                     endif
                     NSTART=NSTART+NTOT(M)-1
 60               CONTINUE
C     
               ELSE
                  IF (NREG.EQ.1) THEN
                     IMIN(1)=NCHAN
                     IMAX(1)=1
                     NDATA=0
                     NTOT(NREG)=0
                     NSTART=1
                  ELSE
                     IMIN(NREG)=IMAX(NREG-1)
                     IMAX(NREG)=IMAX(NREG-1)
                     NSTART=NDATA
                     NTOT(NREG)=1
                  ENDIF
                  PCENT(NREG)=1.0
 70               WRITE (IPRINT,1040) 
                  CALL GETVAL (ITERM,VALUE,NVAL,IRC)
                  IF (IRC.EQ.1) GOTO 160
                  IF (IRC.EQ.2) GOTO 70
                  IF (NVAL.GE.1) PCENT(NREG)=VALUE(1)
                  IF (PCENT(NREG).LE.0.0.OR.
     &                 PCENT(NREG).GT.100.0) GOTO 70
                  PCENT(NREG)=PCENT(NREG)/100.
                  IRC=0
                  IF (NREG.NE.1) GOTO 90
 80               CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
 90               IF (IRC.EQ.0) THEN
                     IF (NREG.EQ.1) THEN
                        READ (JUNIT,REC=IFFR) (SP12(K),K=1,NCHAN)
                        JCH1=ICH1
                        JCH2=ICH2
                     ENDIF
C     
                     ICALL=0
                     IPLOT=3
                     NPOINT=JCH2-JCH1+1
                     CALL FRPLOT (ITERM,IPRINT,SP6(JCH1),SP12(JCH1),
     &                    NPOINT,ICALL,IAXIS,IAUTO,IPLOT,
     &                    IWINDO,ISYMB,ICOL,XANOT,YANOT,TITLE)
C     
 100                 CALL CURSOR (XPOS,YPOS,KCHAR)
                     IF (KCHAR.NE.83.AND.KCHAR.NE.115.AND.
     &                    KCHAR.NE.82.AND.KCHAR.NE.114.AND.
     &                    KCHAR.NE.109) THEN
                        IXPOS=INT(XPOS)
                        IF (NDATA.GT.1.AND.XPOS.EQ.SP1(NDATA)) GOTO 100
                        IF (IXPOS.LT.ICH1.AND.IXPOS.GT.ICH2) GOTO 100
                        IF(NREG.GT.1.AND.IXPOS.LT.IMIN(NREG-1)) GOTO 100
                        IF (IXPOS.GT.IMAX(NREG)) IMAX(NREG)=IXPOS
                        IF (IXPOS.LT.IMIN(NREG)) IMIN(NREG)=IXPOS
                        NTOT(NREG)=NTOT(NREG)+1
                        NDATA=NDATA+1
                        SP1(NDATA)=REAL(IXPOS)
                        SP2(NDATA)=SP12(IXPOS)
                        SP2(NDATA)=SP2(NDATA)-PCENT(NREG)*SP2(NDATA)
                        CALL PLOTNC (REAL(IXPOS),SP2(NDATA),228)
                        if (ndata.gt.1) then
                           call positn (sp1(ndata-1),sp2(ndata-1))
                           call join (sp1(ndata),sp2(ndata))
                        endif
                        GOTO 100
                     ENDIF
                     call trmode
                     GOTO 80
                  ENDIF
C     
                  JMIN=IMIN(NREG)
                  JMAX=IMAX(NREG)
                  NPOINT=ndata-nstart+1
c     
                  IF (NREG.EQ.0) CALL FILL (SP0,NCHAN,0.0)
                  IF (Npoint.GE.2) THEN
                     DO 72 K=1,npoint-1
                        SLOPE=(SP2(K)-SP2(K+1))/(SP1(K)-SP1(K+1))
                        CONST=(SP1(K)*SP2(K+1)-SP1(K+1)*SP2(K))/
     1                       (SP1(K)-SP1(K+1))
                        jmin=INT(SP1(K))
                        jmax=INT(SP1(K+1))
                        DO 82 L=Jmin,jmax
                           SP0(L)=SLOPE*REAL(L)+CONST
 82                     CONTINUE
 72                  CONTINUE
                  endif
               ENDIF
C     
               ICALL=0
               IPLOT=3
               JMIN=IMIN(1)
               JMAX=IMAX(NREG)
               NPOINT=JMAX-JMIN+1
               CALL FRPLOT (ITERM,IPRINT,SP6(JMIN),
     &              SP12(JMIN),NPOINT,ICALL,IAXIS,
     &              IAUTO,IPLOT,IWINDO,ISYMB,ICOL,XANOT,YANOT,TITLE)
               IPLOT=2
               CALL FRPLOT (ITERM,IPRINT,SP6(JMIN),SP0(JMIN),NPOINT,
     &              ICALL,IAXIS,IAUTO,IPLOT,IWINDO,ISYMB,ICOL,
     &              XANOT,YANOT,TITLE)
               call trmode
C     
               if (.not.xaxis) then
                  IF (KCHAR.EQ.82.OR.KCHAR.EQ.114) THEN
                     NREG=NREG+1
                     GOTO 40
                  ENDIF
C     
                  WRITE (IPRINT,1030)
                  REPEAT=ASKNO (ITERM,IRC)
                  IF (IRC.NE.0) GOTO 120
                  IF (.NOT.REPEAT) THEN
                     SAME=.FALSE.
                     GOTO 30
                  ENDIF
C     
                  CALL FILL (SP12,NCHAN,0.0)
 120              DO 130 K=IMIN(1),IMAX(NREG)
                     SP12(K)=SP0(K)
 130              CONTINUE
C     
                  IF (KREC.NE.IFRAME) THEN
                     WRITE (IPRINT,1050)
                     SAME=ASKYES (ITERM,IRC)
                     IF (IRC.NE.0) GOTO 160
                  ENDIF
               endif
               IFFR=IFFR+IFINC
               KREC=KREC+1
C
               if ((krec.eq.1).and.(.not.xaxis)) then
                  WRITE (IPRINT,1060)
                  SAVE=ASKYES (ITERM,IRC)
                  IF (IRC.NE.0) GOTO 135
                  if (save) then
                     print *,'Saving selected points'
                     CALL OUTFIL (ITERM,IPRINT,PFNAM,HEAD1,HEAD2,IRC)
                     IF (IRC.NE.0) GOTO 135
                  endif
               endif
               if (save) then
                  if (krec.ge.iframe) jclo=1
                  CALL DAWRT (LUNIT,PFNAM,IMEM,NDATA,IFRAME,HEAD1,
     1                           HEAD2,SP1,KREC,IOP,JCLO,IRC)
                  IF (IRC.NE.0) GOTO 135
               endif
C
 135           IF (KREC.GE.IFRAME) ICLO=1
               IF (KREC.EQ.1) THEN
                  CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
                  IF (IRC.NE.0) GOTO 160
               ENDIF
               CALL DAWRT (KUNIT,OFNAM,IMEM,NCHAN,IFRAME,HEAD1,HEAD2,
     1              SP12,KREC,JOP,ICLO,IRC)
               IF (IRC.NE.0) GOTO 160
 140        CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
 150  CONTINUE
 160  CLOSE (UNIT=JUNIT)
      GOTO 10
 999  RETURN
 1000 FORMAT (' Enter degree of polynomial [1]: ',$)
 1030 FORMAT (' Do you want to repeat the fitting [Y/N] [N]: ',$)
 1040 FORMAT (' Enter percentage drop from real data [1.0]: ',$)
 1050 FORMAT (' Do you want to the same x positions [Y/N] [Y]: ',$)
1060  FORMAT (' Do you want to save the selected points [Y/N] [Y]: ',$)
      END
 

