C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE MPLOT (XAXIS)
      IMPLICIT NONE
C
C Purpose: Multiple plotting of spectra
C
      LOGICAL XAXIS
C
C XAXIS  : Set true if user defined axis required
C
      INCLUDE 'COMMON.FOR'
C
C Calls   4: GETHDR , OPNFIL , APLOT , PLOTON
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL    VALUE(10),DIFFM,XMIN,XMAX,FMIN,FMAX,GMAX,XTEMP,YTEMP
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NCHANX
      INTEGER ISAVE1,ISAVE2,IMIN,IMAX,INUM,ICH1,ICH2,NVAL,I,J,K
      CHARACTER*13 HFNAM
      CHARACTER EOFCHAR
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
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C NCHANX :
C
      DATA  IMEM/1/
C
C-----------------------------------------------------------------------
      IF (XAXIS) THEN
         WRITE (IPRINT,*) 'X-axis'
         CALL GETXAX (NCHANX,IRC)
         IF (IRC.NE.0) GOTO 999
      ENDIF
10    ICLO=0
      JOP=0
      KREC=0
      DIFFM=0.0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
C
      IFRAME=IHFMAX+IFRMAX-1
      ISAVE1=ISPEC
      ISAVE2=IFFR
C
      CALL GETCHN (ITERM,IPRINT,NCHAN,ICH1,ICH2,IRC)
      IF (IRC.NE.0) GOTO 10
      CALL FILL (SP3,NCHAN,0.0)
      IF (.NOT.XAXIS) THEN
         DO 15 I=1,NCHAN
            XAX(I)=REAL(I)
15       CONTINUE
      ENDIF
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
               DO 20 K=ICH1,ICH2
                  IF (KREC.EQ.1) THEN
                     SP3(K)=SP1(K)
                  ELSE
                     IF ((SP3(K)-SP1(K)).GT.DIFFM) DIFFM=SP3(K)-SP1(K)
                  ENDIF
20             CONTINUE
C
               CALL MINMAX (SP1,NCHAN,ICH1,ICH2,IMIN,IMAX,XMIN,XMAX)
               IF (KREC.EQ.1) THEN
                  FMIN=XMIN
                  FMAX=XMAX
               ENDIF
               IF (XMIN.LT.FMIN) FMIN=XMIN
               IF (XMAX.GT.FMAX) FMAX=XMAX
30          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
40    CONTINUE
C
      IF (IFRAME.NE.1) THEN
         IF (DIFFM.LT.(FMAX-FMIN)/(2*KREC)) THEN
            DIFFM=(FMAX-FMIN)/(2*KREC)
         ENDIF
      ENDIF
31    WRITE (IPRINT,1000) FMIN,FMAX,DIFFM,EOFCHAR ()
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 41
      IF (IRC.EQ.2) GOTO 31
      IF (NVAL.GT.0) FMIN=VALUE(1)
      IF (NVAL.GT.1) FMAX=VALUE(2)
      IF (NVAL.GT.2) DIFFM=VALUE(3)
41    CALL GRMODE
cx      CALL PAPER (1)
cx      CALL FILON
      call ploton
      CALL PSPACE (0.25,1.1,0.175,0.9)
      CALL ERASE
      CALL CTRMAG (20)
      GMAX=(DIFFM*REAL(KREC-1))+FMAX-FMIN
      CALL MAP (XAX(ICH1),XAX(ICH2),FMIN,GMAX)
      CALL XAXISI (0.0)
      CALL POSITN (XAX(ICH2),FMIN)
      CALL JOIN   (XAX(ICH2),GMAX)
      CALL JOIN   (XAX(ICH1),GMAX)
      CALL JOIN   (XAX(ICH1),FMIN)
      IF (FMIN.LT.0.0) CALL JOIN (XAX(ICH2),FMIN)
C
      ISPEC=ISAVE1
      IFFR=ISAVE2
      KREC=0
      DO 42 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 32 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
C
               YTEMP=KREC*DIFFM-FMIN
               XTEMP=XAX(ICH1)-(XAX(ICH2)-XAX(ICH1)+1)*0.025/0.85
               INUM=ISPEC-INCR+IFFR-IFINC
               CALL PLOTNI (XTEMP,YTEMP+SP1(ICH1),INUM)
               CALL POSITN (XAX(ICH1),YTEMP+SP1(ICH1))
               DO 22 K=ICH1+1,ICH2
                  CALL JOIN (XAX(K),YTEMP+SP1(K))
22             CONTINUE
C
               KREC=KREC+1
32          CONTINUE
            CLOSE(UNIT=JUNIT)
         ENDIF
42    CONTINUE
      CALL PICNOW
      CALL TRMODE
      CALL SAVPLO (ITERM,IPRINT)
cx      CALL GREND
      GOTO 10
999   RETURN
C
1000  FORMAT (' Minimum = ',G12.5,' Maximum = ',G12.5,/,
     1        ' Greatest overlap = ',G12.5,/,
     2        ' Enter new values or <ctrl-',a1,'>: ',$)
      END

