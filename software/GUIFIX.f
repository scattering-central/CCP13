C     LAST UPDATE 10/12/96
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      PROGRAM PGFIX 
      IMPLICIT NONE
C
C Purpose: Fibre diffraction analysis program with X-Windows graphics.
C          Useful for finding centre, rotation, tilt. 
C
C Calls  20: GETHDR , OPNFIL , RFRAME , OUTFIL , OPNNEW , WFRAME ,
C            FCLOSE , IMAGE  , REDUCE , RDCOMF , LIST   , FLIST  ,
C            ASK    , CENTRE , ROTATE , FTOSTD , CTILT  , STOREC ,
C            DELPNT , REPLACE
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C FIX include file:
C
      INCLUDE 'FIXPAR.COM'
C
C Local variables for BSL file input:
C
      INTEGER*4 IBUF
      INTEGER IRC,IFRAME,IHFMAX,IFRMAX,NFRAME
      INTEGER ISPEC,LSPEC,MEM,IFFR,ILFR,INCR,IFINC
      INTEGER I,J
      INTEGER ITERM,IPRINT,IUNIT,JUNIT,KUNIT
      CHARACTER*13 HFNAM
C
C IRC    : Return code
C IFRAME : Total nos. of frames
C IFRMAX : Nos. of frames in sequence
C IHFMAX : Nos. of header file in sequence
C ISPEC  : First header file of sequence
C LSPEC  : First header file of sequence
C MEM    : Positional or calibration data indicator
C IFFR   : First frame in sequence
C ILFR   : Last frame in sequence
C INCR   : Header file increment
C IFINC  : Frame increment
C HFNAM  : Header filename
C NPIX   : Nos. of pixels in image (stored in common)
C NRAST  : Nos. of rasters in image (stored in common)
C NFRAME : Nos. of frames in dataset
C ITERM  : Unit number for reading from terminal
C IPRINT : Unit number for writing to terminal
C IUNIT  : Unit for reading header file
C JUNIT  : Unit for reading data file
C IBUF   : Buffer pointer for frame of input     
C
C Arrays for image interface:
C
      INTEGER NPOINTS
      REAL WIDTH
      REAL XPTS(MAXVERT),YPTS(MAXVERT)
C
C RDCOMF declarations:
C
      INTEGER ITEM(20)
      INTEGER NW,NV,N
      REAL VALS(10)
      CHARACTER*10 WORD(10)
C
C LINES declarations:
C
      LOGICAL GSTOPN
C
C Degree to radians conversion
C
      REAL DTOR
      PARAMETER(DTOR=0.017453293)
C
C Initialize logicals:
C
      DATA GOTWAV /.FALSE./, GOTSDD /.FALSE./, GOTCEN /.FALSE./,
     &     GOTROT /.FALSE./, GOTTIL /.FALSE./, RADIAL /.FALSE./
      DATA  ITERM/5/ , IPRINT/6/ , IUNIT/10/ , JUNIT/11/ , KUNIT/12/
C
C-----------------------------------------------------------------------
C
      WRITE(6,1000)
      CALL FLUSH(6)
C
C========Open FIX.OUT file
C
      OPEN(UNIT=KUNIT,STATUS='UNKNOWN',FILE='FIX.OUT')
      GSTOPN = .FALSE.
C
C========Now get pre-file keyworded input
C              
 5    WRITE(6,1010)
      CALL FLUSH(6)
      CALL RDCOMF(ITERM,WORD,NW,VALS,NV,ITEM,10,10,10,IRC)
      IF(IRC.NE.0)GOTO 9999
      IF(NV.GT.0.AND.NW.EQ.0)THEN
         WRITE(6,2020)
         CALL FLUSH(6)
         GOTO 5
      ENDIF
      IF(NW.EQ.0)GOTO 5
      IF(WORD(1)(1:2).EQ.'^D')GOTO 9999
      CALL UPPER(WORD(1),10)
      IF(WORD(1)(1:4).EQ.'WAVE')THEN
         IF(NV.EQ.0)THEN
            WRITE(6,2000)
            CALL FLUSH(6)
         ELSE
            WAVE = VALS(1)
            GOTWAV = .TRUE.
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'DIST')THEN
         IF(NV.EQ.0)THEN
            WRITE(6,2000)
            CALL FLUSH(6)
         ELSE
            SDD = VALS(1)
            GOTSDD = .TRUE.
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'CENT')THEN 
         IF(NV.EQ.2)THEN
            XC = VALS(1)
            YC = VALS(2)
            GOTCEN = .TRUE.
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'ROTA')THEN
         IF(NV.GE.1)THEN
            ROTX = DTOR*VALS(1)
         ELSE
            ROTX = 0.0
         ENDIF
         IF(NV.GE.2)THEN
            ROTY = DTOR*VALS(2)
         ELSE
            ROTY = 0.0
         ENDIF
         IF(NV.GE.3)THEN
            ROTZ = DTOR*VALS(3)
         ELSE
            ROTZ = 0.0
         ENDIF
         GOTROT = .TRUE.
      ELSEIF(WORD(1)(1:4).EQ.'TILT')THEN
         IF(NV.EQ.1)THEN
            TILT = -DTOR*VALS(1)
            GOTTIL = .TRUE.
         ENDIF
      ELSEIF(WORD(1)(1:4).EQ.'RADI')THEN
         RADIAL = .TRUE.
      ELSEIF(WORD(1)(1:4).EQ.'AZIM')THEN
         RADIAL = .FALSE.
      ELSEIF(WORD(1)(1:4).EQ.'FILE')THEN
         GOTO 10
      ELSEIF(WORD(1)(1:4).EQ.'QUIT')THEN
         GOTO 9999
      ELSE
         WRITE(6,2010)
         CALL FLUSH(6)
      ENDIF
      GOTO 5
C
C========Prompt for input file details
C
 10   WRITE(6,1005)
      CALL FLUSH(6)
      CALL GETHDR (ITERM,IPRINT,IUNIT,HFNAM,ISPEC,LSPEC,INCR,MEM,IFFR,
     &             ILFR,IFINC,IHFMAX,IFRMAX,NPIX,NRAST,IRC)
      IF (IRC.NE.0)GOTO 9999
      IFRAME = IHFMAX + IFRMAX - 1
      WRITE(KUNIT,1020)HFNAM
      WRITE(KUNIT,1030)IFFR,ILFR,IFINC 
C
C========Loop over specified header files
C
      DO 50 I=1,IHFMAX
         CALL OPNFIL (JUNIT,HFNAM,ISPEC,MEM,IFFR,ILFR,NPIX,NRAST,
     &                NFRAME,IRC)
         IF (IRC.EQ.0) THEN
C
            ISPEC=ISPEC+INCR
C
C========Loop over specified frames
C
            DO 40 J=1,IFRMAX
C
C========Read frames sequentially
C
               WRITE(KUNIT,1040)IFFR 
               CALL RFRAME (JUNIT,IFFR,NPIX,NRAST,IBUF,IRC)
               IF (IRC.NE.0) GOTO 60
               IFFR=IFFR+IFINC
C
C========Initialization point and line counters
C
               NPTS = 0
               NLIN = 0
C
C========Now get keyworded input
C              
 35             WRITE(6,1010)
                CALL FLUSH(6)
                CALL RDCOMF(ITERM,WORD,NW,VALS,NV,ITEM,10,10,10,IRC)
                IF(IRC.NE.0)GOTO 9999
                IF(NV.GT.0.AND.NW.EQ.0)THEN
                   WRITE(6,2020)
                   CALL FLUSH(6)
                   GOTO 35
                ENDIF
                IF(NW.EQ.0)GOTO 35
                IF(WORD(1)(1:2).EQ.'^D')GOTO 9999
                CALL UPPER(WORD(1),10)
                IF(WORD(1)(1:4).EQ.'WAVE')THEN
                   IF(NV.EQ.0)THEN
                      WRITE(6,2000)
                      CALL FLUSH(6)
                   ELSE
                      WAVE = VALS(1)
                      GOTWAV = .TRUE.
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'DIST')THEN
                   IF(NV.EQ.0)THEN
                      WRITE(6,2000)
                      CALL FLUSH(6)
                   ELSE
                      SDD = VALS(1)
                      GOTSDD = .TRUE.
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'CENT')THEN 
                   IF(NV.LT.2)THEN
                      IF(NPTS.GT.0)THEN
                         CALL CENTRE
                      ELSE
                         WRITE(6,2030)
                         CALL FLUSH(6)
                      ENDIF
                   ELSE
                      XC = VALS(1)
                      YC = VALS(2)
                      GOTCEN = .TRUE.
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'ROTA')THEN
                   IF(NV.EQ.0)THEN
                      IF(NPTS.GT.0)THEN
                         CALL ROTATE 
                      ELSE
                         WRITE(6,2030)
                         CALL FLUSH(6)
                      ENDIF
                   ELSE
                      ROTX = DTOR*VALS(1)
                      IF(NV.GE.2)THEN
                         ROTY = DTOR*VALS(2)
                      ELSE
                         ROTY = 0.0
                      ENDIF
                      IF(NV.GE.3)THEN
                         ROTZ = DTOR*VALS(3)
                      ELSE
                         ROTZ = 0.0
                      ENDIF
                      GOTROT = .TRUE.
                      IF(GOTCEN)CALL FTOSTD
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'TILT')THEN
                   IF(NV.EQ.0)THEN
                      IF(NPTS.GT.1)THEN
                         CALL CTILT 
                      ELSE
                         WRITE(6,1030)
                         CALL FLUSH(6)
                      ENDIF
                   ELSE
                      TILT = -DTOR*VALS(1)
                      GOTTIL = .TRUE.
                      IF(GOTCEN.AND.GOTROT.AND.
     &                   GOTWAV.AND.GOTSDD)CALL STOREC
                   ENDIF
                ELSEIF(WORD(1)(1:4).EQ.'REFI')THEN
                   XPTS(1) = VALS(1)
                   YPTS(1) = VALS(2)
                   XPTS(2) = VALS(1) + VALS(3)
                   YPTS(2) = YPTS(1)
                   XPTS(3) = XPTS(2)
                   YPTS(3) = VALS(2) + VALS(4)
                   XPTS(4) = XPTS(1)
                   YPTS(4) = YPTS(3)
                   CALL REFALL(IBUF,XPTS,YPTS)
                ELSEIF(WORD(1)(1:4).EQ.'LIST')THEN
                   CALL LIST
                   CALL FLIST(KUNIT)
                ELSEIF(WORD(1)(1:4).EQ.'PLOT')THEN
                   CALL LINES (%val(IBUF),GSTOPN,VALS,NV)
                ELSEIF(WORD(1)(1:4).EQ.'POIN')THEN
                   NPOINTS = 1
                   XPTS(1) = VALS(1)
                   YPTS(1) = VALS(2)
                   CALL REDUCE(%val(IBUF),NPOINTS,XPTS,YPTS,0)
                ELSEIF(WORD(1)(1:4).EQ.'POLY')THEN
                   NPOINTS = NINT(VALS(1))
                   DO N=1,NPOINTS
                      XPTS(N) = VALS(2*N)
                      YPTS(N) = VALS(2*N+1)
                   ENDDO
                   CALL REDUCE(%val(IBUF),NPOINTS,XPTS,YPTS,0)
                ELSEIF(WORD(1)(1:4).EQ.'SECT')THEN
                   CALL REDSEC(%val(IBUF),VALS(1),VALS(2),VALS(3),
     &                         VALS(4),VALS(5),VALS(6))
                ELSEIF(WORD(1)(1:4).EQ.'SCAN')THEN
                   CALL REDSCN(VALS(1),VALS(2),VALS(3),VALS(4),VALS(5),
     &                         VALS(6))
                ELSEIF(WORD(1)(1:4).EQ.'LINE')THEN
                   NPOINTS = 2
                   XPTS(1) = VALS(1)
                   YPTS(1) = VALS(2)
                   XPTS(2) = VALS(3)
                   YPTS(2) = VALS(4)
                   WIDTH = VALS(5)
                   CALL REDUCE(%val(IBUF),NPOINTS,XPTS,YPTS,WIDTH)
                ELSEIF(WORD(1)(1:4).EQ.'DELE')THEN
                   IF(WORD(2)(1:4).EQ.'POIN')CALL DELPNT(VALS,NV)
                   IF(WORD(2)(1:4).EQ.'LINE')CALL DELLIN(VALS,NV)
                   IF(WORD(2)(1:4).EQ.'SCAN')CALL DELSCN(VALS,NV)
                ELSEIF(WORD(1)(1:4).EQ.'RADI')THEN
                   RADIAL = .TRUE.
                ELSEIF(WORD(1)(1:4).EQ.'AZIM')THEN
                   RADIAL = .FALSE.
                ELSEIF(WORD(1)(1:4).EQ.'FRAM')THEN
                   GOTO 40
                ELSEIF(WORD(1)(1:4).EQ.'FILE')THEN
                   GOTO 60
                ELSEIF(WORD(1)(1:4).EQ.'QUIT')THEN
                   GOTO 9999
                ELSE
                   WRITE(6,2010)
                   CALL FLUSH(6)
                ENDIF
                GOTO 35
 40         CONTINUE
            CALL FCLOSE (JUNIT)
         ENDIF
 50   CONTINUE
 60   CALL FCLOSE (JUNIT)
      GOTO 10
 9999 CLOSE(KUNIT)
c++++++++GHOST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IF(GSTOPN)CALL GREND
c++++++++PGPLOT+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c      IF(GSTOPN)CALL PGEND
c++++++++END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      STOP 'Normal stop' 
C
C-----------------------------------------------------------------------
 1000 FORMAT(/1X,'200',
     &       1X,'FIX - Fibre diffraction analysis program'/
     &       1X,'Last update 12/11/98'/)
 1005 FORMAT(1X,'201 New input file')
 1010 FORMAT(1X,'Fix: ',$)
 1020 FORMAT(1X,'Header filename: ',A30)
 1030 FORMAT(1X,'First frame ',I4,'  Last frame ',I4,'  Incr. ',I4)
 1040 FORMAT(1X,'Reading frame ',I4)
 2000 FORMAT(1X,'***Numeric input expected')
 2010 FORMAT(1X,'***Unrecognized keyword')
 2020 FORMAT(1X,'***Keyword expected')
 2030 FORMAT(1X,'***Buffer empty')
C-----------------------------------------------------------------------
      END                  
