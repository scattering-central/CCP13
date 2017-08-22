C     LAST UPDATE 06/10/86
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE IMPIC (ITERM,IPRINT,BUFF,BUFOUT,NPIX,NRAST)
C
C PURPOSE: 
C
      REAL    BUFF(1)
      INTEGER BUFOUT(1),NPIX,NRAST,ITERM,IPRINT
C
C BUFF   : IMAGE ARRAY
C NPIX   : NOS. OF PIXELS IN IMAGE
C NRAST  : NOS. OF RASTERS IN IMAGE
C ARGBUF : PACKED ARGS ARRAY
C ITERM  : TERMINAL INPUT
C IPRINT : TERMINAL OUTPUT
C
C CALLS   4: BORDER , COMPRESS , FILBYT , GETVAL
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C LOCAL VARIABLES:
C
      REAL    RMIN,RMAX,TMIN,TMAX,VALUE(10)
      INTEGER ITEMP,NVAL,IRC
      INTEGER IFPIX,ILPIX,IFRAST,ILRAST
      CHARACTER*80 PLOFIL
      LOGICAL IGETS
C
C RMIN   : MINIMUM VALUE OF IMAGE
C RMAX   : MAXIMUM VALUE OF IMAGE
C TMIN   : THRESHOLD MINIMUM
C TMAX   : THRESHOLD MAXIMUM
C VALUE  : VALUES ENTERED AT TERMINAL
C ITEMP  : TEMPORY VARIABLE
C NVAL   : NUMBER OF VALUES ENTERED AT TERMINAL
C IRC    : RETURN
C
      DATA KUNIT/15/
C
C-----------------------------------------------------------------------
C
C========PART OF AN IMAGE TO DISPLAY?
C
5     WRITE (IPRINT,1000) NPIX,NRAST
      IFPIX=1
      ILPIX=NPIX
      IFRAST=1
      ILRAST=NRAST
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 999
      IF (IRC.EQ.2) GOTO 5
      IF (NVAL.GT.0) IFPIX=INT(VALUE(1))
      IF (NVAL.GT.1) ILPIX=INT(VALUE(2))
      IF (NVAL.GT.2) IFRAST=INT(VALUE(3))
      IF (NVAL.GT.3) ILRAST=INT(VALUE(4))
C
C========FIND THE MINIMUM & MAXIMUM VALUES OF THE BUFFER
C
      INDEX=NPIX*(IFRAST-1)+IFPIX
      RMIN=BUFF(INDEX)
      RMAX=BUFF(INDEX)
      DO 40 I=IFRAST,ILRAST
         DO 30 J=IFPIX,ILPIX
            IF (BUFF(INDEX).LE.RMIN) RMIN=BUFF(INDEX)
            IF (BUFF(INDEX).GT.RMAX) RMAX=BUFF(INDEX)
            INDEX=INDEX+1
30       CONTINUE
         INDEX=INDEX+NPIX-(ILPIX-IFPIX)-1
40    CONTINUE
C
C========SELECT THRESHOLD VALUES OR <CTRL-Z> TO QUIT
C
      TMIN=RMIN
      TMAX=RMAX
50    WRITE (IPRINT,1030) TMIN,TMAX
      CALL GETVAL (ITERM,VALUE,NVAL,IRC)
      IF (IRC.EQ.1) GOTO 999
      IF (IRC.EQ.2) GOTO 50
      IF (NVAL.GT.0) TMIN=VALUE(1)
      IF (NVAL.GT.1) TMAX=VALUE(2)
C
C========PACK DATA INTO SUITABLE BUFFER FOR THE ARGS
C
      index=npix*(ifrast-1)+ifpix
      index2=1
      DO 70 I=IFRAST,ILRAST
         DO 60 J=IFPIX,ILPIX
            ITEMP=INT(0.0+255.0*(BUFF(INDEX)-TMIN)/(TMAX-TMIN))
            IF (ITEMP.GT.255) ITEMP=255
            IF (ITEMP.LT.0) ITEMP=0
            BUFOUT(INDEX2)=itemp
            INDEX=INDEX+1
            INDEX2=INDEX2+1
60       CONTINUE
         INDEX=INDEX+NPIX-(ILPIX-IFPIX)-1
70    CONTINUE
      IPIX=ILPIX-IFPIX+1
      IRAST=ILRAST-IFRAST+1
      WRITE (IPRINT,1040)
      IF (IGETS (ITERM,PLOFIL)) THEN
         open (unit=kunit,file=plofil,status='new')
         WRITE (KUNIT,1050) 36+IPIX-1,36+IRAST-1
         WRITE (KUNIT,1060) MAX(IPIX,IRAST),IRAST,IPIX
         write (KUNIT,'(32z2.2,1x)') (bufout(j),j=1,index2-1)
         call fclose (kunit)
      endif
999   RETURN
1000  FORMAT (' Enter first & last pixels/rasters [1,',
     1        I3,',1,',I3,'] : ',$)
1020  FORMAT (' Image is too large for the selected quadrant',/,
     1        ' Do you want to compress [0] or truncate [1]  [0]: ',$)
1030  FORMAT (' Enter threshold values [',G10.4,',',G10.4,'] : ',$)
1040  FORMAT (' Enter postscript file name: ',$)
1050  FORMAT ('%!PS-Adobe-2.0',/,
     1        '%%Creator: BSL',/,
     1        '%%Pages: 1',/,
     1        '%%BoundingBox: 36 36 ',I4,' ',I4,/,
     1        '%%EndComments',/, 
     1        '/inch {72 mul} def',/,
     1        '/showimage { /cols exch def /rows exch def /size ',
     1        'exch def/',/,'/buffer 32 string def',/,
     1        'cols rows 8 [size 0 0 size neg 0 size] {currentfile ',
     1        'buffer readhexstring pop}',/,'image showpage } def')
1060  FORMAT ('0.5 inch 0.5 inch translate 7 inch dup scale ',
     1         3(I4,1X),'showimage')
      END
