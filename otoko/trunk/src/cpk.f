C     LAST UPDATE 16/03/89
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE CPK
      IMPLICIT NONE
C
C Purpose: Determine the major peak parameters, integral, width, position
C          skewness etc. 
C
      INCLUDE 'COMMON.FOR'
C
C Calls   5: APLOT  , DAWRT  , ERRMSG , GETHDR , GETVAL , OPNFIL
C            PEKDES
C Called by: OTOKO
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Local variables:
C
      REAL VALUE(10),SUM,SIGI,SPMAX,RMEAN,SKEW1,SKEW2
      INTEGER ICLO,JOP,IRC,IFRAME,IHFMAX,IFRMAX,IMEM,NCHAN,NFRAME
      INTEGER KREC,ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC,NVAL,NPOINT
      INTEGER L1,L2,L3,L4,IMAX,IMED,IMODE,IFWHM,IACF,IACL,I,J,K
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
C HEAD1  : Output header record 1
C HEAD2  : Output header record 2
C IMEM   : Output memory dataset
C NCHAN  : Nos. of data points in spectrum
C NFRAME : Nos. of time frames
C
      DATA  IMEM/1/ , KREC/12/
C
C-----------------------------------------------------------------------
10    ICLO=0
      JOP=0
      NPOINT=0
C
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     1             ILFR,IFINC,IHFMAX,IFRMAX,NCHAN,IRC)
      IF (IRC.NE.0) GOTO 999
      IFRAME=IHFMAX+IFRMAX-1
C
20    WRITE (IPRINT,1000)
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 10
      IF (IRC.EQ.2) GOTO 20
      IF (NVAL.LT.4) THEN 
         CALL ERRMSG ('Error: Insufficient input')
         GOTO 20
      ELSE
         L1=INT(VALUE(1))
         L2=INT(VALUE(2))
         L3=INT(VALUE(3))
         L4=INT(VALUE(4))
         IF ((L1.LT.1.OR.L1.GT.NCHAN).OR. 
     1       (L2.LT.1.OR.L2.GT.NCHAN).OR.
     2       (L3.LT.1.OR.L3.GT.NCHAN).OR.
     3       (L4.LT.1.OR.L4.GT.NCHAN)) THEN
            CALL ERRMSG ('Error: Value outside of range')
            GOTO 20
         ENDIF
      ENDIF
      DO 60 I=1,IHFMAX
C
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NCHAN,NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
            DO 50 J=1,IFRMAX
               READ (JUNIT,REC=IFFR) (SP1(K),K=1,NCHAN)
               IFFR=IFFR+IFINC
               NPOINT=NPOINT+1
C
               SUM=0.0
               DO 40 K=L2,L3
                  SUM=SUM+SP1(K)
40             CONTINUE
               CALL PEKDES (SP1,NCHAN,L1,L4,IACF,IACL,SPMAX,IMAX,RMEAN,
     1                      IMED,IMODE,SIGI,IFWHM,SKEW1,SKEW2,IRC)
               SP2(NPOINT)=SUM
               SP3(NPOINT)=SIGI
               SP4(NPOINT)=SPMAX
               SP5(NPOINT)=IMAX
               SP6(NPOINT)=RMEAN
               SP7(NPOINT)=IMED
               SP8(NPOINT)=IMODE
               SP9(NPOINT)=IFWHM
               SP10(NPOINT)=SKEW1
               SP11(NPOINT)=SKEW2
               SP12(NPOINT)=IACF
               SPW(NPOINT)=IACL
50          CONTINUE
            CLOSE (UNIT=JUNIT)
         ENDIF
60    CONTINUE
      IF (IFRAME.NE.1) THEN
         CALL APLOT (ITERM,IPRINT,SP2,IFRAME)
      ENDIF
      CALL OUTFIL (ITERM,IPRINT,OFNAM,HEAD1,HEAD2,IRC)
      IF (IRC.EQ.0) THEN
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP2,
     &                  1,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP3,
     &                  2,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP4,
     &                  3,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP5,
     &                  4,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP6,
     &                  5,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP7,
     &                  6,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP8,
     &                  7,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP9,
     &                  8,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP10,
     &                  9,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP11,
     &                  10,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SP12,
     &                  11,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
         ICLO=1
         CALL DAWRT (KUNIT,OFNAM,IMEM,IFRAME,12,HEAD1,HEAD2,SPW,
     &                  12,JOP,ICLO,IRC)
         IF (IRC.NE.0) GOTO 10
      ENDIF
      GOTO 10
999   RETURN
C
1000  FORMAT (' Enter range of points on either side of peak,',/
     1        ' low_min, low_max, high_min, high_max: ',$)
1010  FORMAT (' Frame',I4,' Pos of max',I5,' Max',G12.5,' Mean',G12.5,/,
     1        ' Median',I5,' Mode',I5,' Std Dev.',G12.5,' FWHM',I5,/,
     2        ' Skew 1',G12.5,' Skew 2',G12.5,' First channel',I5,/,
     3        ' Last channel',I5,' Integral',G12.5)
      END
