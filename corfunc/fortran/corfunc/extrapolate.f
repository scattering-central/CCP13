      PROGRAM extrapolate
C     TMWN July 94
C     Gets information from user for tailfit and tailjoin subroutines.
C     SMK Nov 05
C     Redimensioned data arrays from 512 to MaxDim.

      CHARACTER*80 filename,qaxname,dirname,exptname
      CHARACTER*40 title,sigmodel,ascii,stat*80,user,idftoggle
      CHARACTER*80 prompt(44),fname,axisname,fname2,arbabs
      CHARACTER*10 filetype
      CHARACTER*1 letter,backex*40,retrans*40
      INTEGER MaxDim
	PARAMETER (MaxDim=4096)
      INTEGER lim1,lim2,qzero,realtime(5),datastart,lword,best(MaxDim)
      DIMENSION notok(10),xdata(MaxDim),ydata(MaxDim,MaxDim),param2(MaxDim,5)
      DIMENSION limit1(MaxDim),limit2(MaxDim),results(MaxDim,5),param(3)
      LOGICAL static
      INTEGER frames(4),bestchannel,channel2(MaxDim,2)
      REAL asciidata(MaxDim*MaxDim)
C     S King, July 2004
      character*3 asciitype
      character*80 tit1,tit2
      dimension c(MaxDim),e(MaxDim)

1000  FORMAT(A1)
1010  FORMAT(A80)
1020  FORMAT(2x,I3)
1030  FORMAT(10I8)
1040  FORMAT(A40)
1050  FORMAT(/,1x,'100: Q limits of tail: start ',E12.6,'.',/,
     +' 100: ',18x,'end   ',E12.6,'.')
1060  FORMAT(/,1x,'Data contains ',I3,' frames.')
1070  FORMAT(/,1x,'100: Analysis will be performed on ',I3,' frames.')
1080  FORMAT(2x,I3,2x,I3,2x,I3,2x,I3)
1090  FORMAT(E12.6)
1100  FORMAT(/,1x,'100: Limits for frame ',I3,':')
1110  FORMAT(1x,'100: Q start ',E12.6,'. Q end ',E12.6,'.')
1120  FORMAT(2x,I3,2x,I3)
1130  FORMAT(E12.6,2x,E12.6,2x,E12.6,2x,E12.6,2x,E12.6)
1140  FORMAT(2x,I3,2x,I3)

      title='Tail Fit User Input'
      CALL showtitle(title)
      prompt(1)='Enter data directory name'
      prompt(2)='Enter intensity data filename'
      prompt(3)='Enter Q axis filename'
      prompt(4)='ERROR: Error reading corfunc.txt: NON-FATAL'
      prompt(5)='ERROR: Problem with data: FATAL'
      prompt(6)='ERROR: X axis should be a static image, '
     +//'dynamic found: FATAL'
      prompt(7)='Data OK...'
      prompt(8)='Enter channel at start of tail'
      prompt(9)='Enter channel at end of tail'
      prompt(10)='Enter start channel optimisation range '
     +//'(type n for no opt.)'
      prompt(11)='Enter number of iterations for tailfit'
      prompt(12)='Do you want graphics [y/n]'
      prompt(13)='ERROR: Invalid input: FATAL'
      prompt(14)='Passing information to program tailfit...'
      prompt(15)='Data in arbitrary or absolute units [arb/abs]'
      prompt(16)='ERROR: Error writing corfunc.txt: FATAL'
      prompt(17)='ERROR: Error writing dummy file: FATAL'
      prompt(18)='CORFUNC.TXT: PARAMETER FILE USED BY '
     +//'CORRELATION PROGRAMS. AVOID DELETION.'
      prompt(19)='Enter start frame'
      prompt(20)='Enter end frame'
      prompt(21)='Enter increment'
      prompt(22)='static'
      prompt(23)='Vonk or Guinier model for back-extrapolation [v/g]'
      prompt(24)='Enter channel at start of genuine data'
      prompt(25)='Enter maximum D for Fourier transform [Angstroms]'
      prompt(26)='Enter step in D for Fourier transform [Angstroms]'
      prompt(27)='Re-transform correlation function [y/n]'
      prompt(28)='Apply sigmoid tail model (otherwise Porod) [y/n]'
      prompt(29)='Enter estimate of volume fraction crystallinity'
      prompt(30)='Do you want ascii output of '
     +//'correlation function [y/n]'
      prompt(31)='ERROR: Error with status file: FATAL'
      prompt(32)='Do you want to continue with this set-up [y/n]'
      prompt(33)='Do you want user control of extraction '
     +//'process [y/n]'
      prompt(34)='Same channel limits on each frame for tailfit [y/n]'
      prompt(35)='Enter tailfit start channel'
      prompt(36)='Enter tailfit end channel'
      prompt(37)='ERROR: Error writing limitinfo.txt: FATAL'
      prompt(38)='Calculate the interface distribution function [y/n]'
      prompt(39)='Start transform? [y/n]'
      prompt(40)='Start extraction? [y/n]'
C	Following added by S M King, July 2004
      prompt(41)='ERROR: READASCII_ returning IRC=0: FATAL'
      prompt(42)='ERROR: Error during file OPEN: FATAL'
      prompt(43)='ERROR: Error during file READ: FATAL'
      prompt(44)='ERROR: X axis has more/fewer points than data: FATAL'

      filename='A00000.XSH'
      qaxname='X00000.QAX'
      lim1=200
      lim2=400
      CALL WRDLEN(lword)

C     Got default info. Now quiz user.
      CALL defaultname(prompt(2),filename)
      CALL defaultname(prompt(3),qaxname)

C     Check files exist
      fname=filename
      axisname=qaxname

C     Open data
      CALL getfiletype(filetype,fname)
      IF(filetype.EQ."ascii")THEN
C	  S King, July 2004
        asciitype='sca'
C       Is it a LOQ 1D file...
        irc=0
        open(12,file=fname,form='formatted',status='old',err=10)
C SMK	    call loqread(tit1,tit2,512,ndata,xdata,c,e,12,irc)
	    call loqread(tit1,tit2,MaxDim,ndata,xdata,c,e,12,irc)
10      close(12)
        if(irc.eq.1)then
          notok(1)=ndata
          notok(2)=1
          nndata=ndata*4
C         Assume single frame only (ie, not realtime)
	    realtime(1)=notok(2)
          do i=1,ndata
            ydata(1,i)=c(i)
          end do
          asciitype='loq'
        else
C       ...or is it single column ascii (sca)?
          CALL readascii(fname,notok,asciidata,irc)
          IF(irc.EQ.0)THEN
              GOTO 5021
          ENDIF
          ndata=notok(1)
          nndata=ndata*4
          realtime(1)=notok(2)
          ij=1
          DO i=1,ndata
            DO nframe=1,realtime(1)
              ydata(nframe,i)=asciidata(ij)
              ij=ij+1
            END DO
          END DO
        endif
      ELSE
C SMK The program falls over at this next open under Cygwin... use MinGW instead!
C     The problem appears to be related to how the fname character string is handled in the different flavours
C     of Unix.
          OPEN(UNIT=9,FILE=fname,STATUS='old',ERR=5022)
          READ(9,1000,ERR=5023)letter
          READ(9,1000,ERR=5023)letter
          READ(9,1030,ERR=5023)notok
          READ(9,1040,ERR=5023)exptname
          CLOSE(9)
          ndata=notok(1)
          nndata=ndata*4

C         Check realtime
C         realtime(1)=number of frames
C         realtime(2, 3, and 4) are start,end,increm
C         realtime(5)=number of frames this setup uses
          realtime(1)=notok(2)

C         Check intensities
          CALL getpath(fname,dirname)
          CALL addstrings(dirname,exptname,fname2)
          OPEN(UNIT=9,FILE=fname2,STATUS='old',
     +    ACCESS='direct',RECL=nndata/lword,ERR=5022)
C         Loop through frames
          DO nframe=1,realtime(1)
            READ(9,REC=nframe,ERR=5023)(ydata(nframe,i),i=1,ndata)
          END DO
          CLOSE(9)
      ENDIF

      IF(filetype.NE."ascii")THEN
C SMK   CALL swap(ydata,notok(4),512*512,4)
        CALL swap(ydata,notok(4),MaxDim*MaxDim,4)
      ENDIF

C     reset frame counter
      nframe=1

C     Open Q axis
C     S King, July 2004
C     Don't need to do this if read a LOQ ASCII file
      if(asciitype.eq.'loq') goto 20

      CALL getfiletype(filetype,axisname)
      IF(filetype.EQ."ascii")THEN
          CALL readascii(axisname,notok,asciidata,irc)
          IF(irc.EQ.0)THEN
              GOTO 5021
          ENDIF
          IF (ndata .NE. notok(1)) THEN
C           x axis has more/fewer points than data
            GOTO 5024
          ENDIF
C         Check realtime
          IF (notok(2) .NE. 1) THEN
            CALL showprompt(prompt(6))
            STOP
          ENDIF
          DO i=1,ndata
            xdata(i)=asciidata(i)
          END DO
      ELSE
          OPEN(UNIT=9,FILE=axisname,STATUS='old',ERR=5022)
          READ(9,1000,ERR=5023)letter
          READ(9,1000,ERR=5023)letter
          READ(9,1030,ERR=5023)notok
          READ(9,1040,ERR=5023)exptname
          CLOSE(9)

          IF (ndata .NE. notok(1)) THEN
C           x axis has more/fewer points than data
            GOTO 5024
          ENDIF
C         Check realtime
          IF (notok(2) .NE. 1) THEN
            CALL showprompt(prompt(6))
            STOP
          ENDIF

C         check x axis data
          CALL getpath(fname,dirname)
          CALL addstrings(dirname,exptname,fname2)
          OPEN(UNIT=9,FILE=fname2,STATUS='old',
     +    ACCESS='direct',RECL=nndata/lword,ERR=5022)
          READ(9,REC=nframe,ERR=5023)(xdata(i),i=1,ndata)
2015      CLOSE(9)
      ENDIF

      IF(filetype.NE."ascii")THEN
C SMK   CALL swap(xdata,notok(4),512,4)
        CALL swap(xdata,notok(4),MaxDim,4)
      ENDIF

C     OK - the data's there
20    CALL showprompt(prompt(7))

C     Set up realtime defaults
      realtime(2)=1
      realtime(3)=realtime(1)
      realtime(4)=1
      realtime(5)=1
C     Get realtime info if necessary
2050  IF (realtime(1) .NE. 1) THEN
        WRITE(6,1060)realtime(1)
C       Get start of frames
        CALL defaultint(prompt(19),realtime(2))
C       check valid value
        IF (realtime(2) .LT. 1 .OR.
     +  realtime(2) .GT. realtime(1)) THEN
          CALL showprompt(prompt(13))
          GOTO 2050
        ENDIF
C       get end of frames
        CALL defaultint(prompt(20),realtime(3))
C       check valid
        IF (realtime(3) .LT. realtime(2) .OR.
     +  realtime(3) .GT. realtime(1)) THEN
          CALL showprompt(prompt(13))
          GOTO 2050
        ENDIF

C       get frame increment
        CALL defaultint(prompt(21),realtime(4))

C       work out number of frames this increment would use
        realtime(5)=0
        DO i=realtime(2),realtime(3),realtime(4)
          realtime(5)=realtime(5)+1
        END DO

C       check valid
        IF (realtime(5) .LT. 1 .OR.
     +  realtime(5) .GT. realtime(1)) THEN
          CALL showprompt(prompt(13))
          GOTO 2050
        ENDIF
        WRITE(6,1070)realtime(5)

      ENDIF
C     OK - realtime stuff over.


C     Find qzero
      qzero=1
      DO i=1,ndata
        IF (xdata(i-1) .LT. 0. .AND. xdata(i) .GE. 0.) THEN
          qzero=i
        ENDIF
      END DO

C     next get fit limits, no. iterations
C     altered 9/8/94
      numiteration=100
      arbabs='arb'
C     Is data arb or abs?
      CALL defaultname(prompt(15),arbabs)

C     Get tail limits
C     same for each frame
      letter='y'
      IF (realtime(5) .NE. 1) THEN
        CALL defaultletter(prompt(34),letter)
      ENDIF
      IF (letter .EQ. 'y' .OR. letter .EQ. 'Y') THEN
C       Same limits for every frame.
2020    CALL defaultint(prompt(8),lim1)
        CALL defaultint(prompt(9),lim2)
        IF (lim1 .LT. 1 .OR.
     +      lim1 .GT. lim2 .OR.
     +      lim2 .GT. MaxDim) THEN
          CALL showprompt(prompt(13))
          GOTO 2020
        ENDIF
C       write into array
        DO i=realtime(2),realtime(3),realtime(4)
          limit1(i)=lim1
          limit2(i)=lim2
        END DO
        WRITE(6,1050)xdata(lim1),xdata(lim2)

      ELSE
C       Different limits.
        DO i=realtime(2),realtime(3),realtime(4)
          WRITE(6,1100)i
2100      CALL defint(prompt(35),lim1)
          CALL defint(prompt(36),lim2)
          IF (lim1 .LT. 1 .OR.
     +      lim1 .GT. lim2 .OR.
     +      lim2 .GT. MaxDim) THEN
            CALL showprompt(prompt(13))
            GOTO 2100
          ENDIF
          limit1(i)=lim1
          limit2(i)=lim2
          WRITE(6,1110)xdata(lim1),xdata(lim2)
        END DO

      ENDIF

C     number of iterations?
2040  CALL defaultint(prompt(11),numiteration)
      IF (numiteration .LT. 1 .OR. numiteration .GT. 1000) THEN
        CALL showprompt(prompt(13))
        GOTO 2040
      ENDIF
C     Sigmoid model, or just straight Porod model?
      IF (sigmodel .EQ. 'off') THEN
        letter='n'
      ELSE
        letter='y'
      ENDIF
      CALL defaultletter(prompt(28),letter)
      IF (letter .EQ. 'n' .OR. letter .EQ. 'N') THEN
        sigmodel='off'
      ELSE
        sigmodel='on'
      ENDIF

C     Data for tailjoin.
C     back extrapolation model.
      IF (backex .EQ. 'vonk') THEN
        letter='v'
      ELSE
        letter='g'
      ENDIF
      CALL defaultletter(prompt(23),letter)
      IF (letter .EQ. 'V' .OR. letter .EQ. 'v') THEN
        backex='vonk'
      ELSE
        backex='guinier'
      ENDIF

C     Find start of genuine data.
C     Start of back extrap. is a point with intensity
C     greater than 10.*intensity at qzero and such that
C     intensity is decreasing with Q.
C     NB: will fail if semi transparent beamstop used - user must take over.
      compare=10.*ydata(realtime(2),qzero+1)
      DO i=qzero,qzero+50
        IF (ydata(realtime(2),i) .GT. compare .AND.
     +  ydata(realtime(2),i) .GT. ydata(realtime(2),i+1)) THEN
          GOTO 2060
        ENDIF
      END DO
      i=0
2060  datastart=i
      CALL defaultint(prompt(24),datastart)
      IF ((datastart .LT. qzero) .OR.
     +(datastart .GT. lim1)) THEN
        CALL showprompt(prompt(13))
        GOTO 2060
      ENDIF

C     User input over
      CALL showprompt(prompt(14))

C     Set up parameters for tailfit
      if(realtime(5).eq.1)then
        static=.true.
      else
        static=.false.
      endif

      frames(1)=realtime(2)
      frames(2)=realtime(3)
      frames(3)=realtime(4)
      frames(4)=realtime(5)

C     Call tailfit
      CALL tailfit(filename,qaxname,sigmodel,limit1,limit2,
     &             frames,ndata,numiteration,
     &             results,best,bestchannel,param,static)

C     Set up parameters for tailjoin
      if(frames(4).eq.1)then
        best(1)=bestchannel
        results(1,1)=param(1)
        results(1,2)=param(2)
        results(1,3)=param(3)
      endif

C     Call tailjoin
      CALL tailjoin(filename,qaxname,results,best,ndata,qzero,
     &              backex,datastart,frames,limit2,static)

C     Write corfunc.txt file
      open(unit=9,file='corfunc.txt',STATUS='unknown',ERR=5030)
      write(9,1010,ERR=5030)filename
      write(9,1010,ERR=5030)qaxname
      write(9,1080,ERR=5030)frames(1),frames(2),frames(3),
     &                     frames(4)
      write(9,1010,ERR=5030)arbabs
      write(9,1040,ERR=5030)sigmodel
      write(9,1040,ERR=5030)backex
      write(9,1020,ERR=5030)qzero
      DO i=frames(1),frames(2),frames(3)
          write(9,1130,ERR=5030)results(i,1),results(i,2),
     &                          results(i,3),results(i,4),
     &                          results(i,5)
      END DO
      DO i=frames(1),frames(2),frames(3)
          write(9,1140,ERR=5030)limit2(i),best(i)
      END DO
      close(9)

C     End program.
      STOP

C     Error statements

C     Error with data
5020  CALL showprompt(prompt(5))
      STOP
5021  CALL showprompt(prompt(41))
      STOP
5022  CALL showprompt(prompt(42))
      STOP
5023  CALL showprompt(prompt(43))
      STOP
5024  CALL showprompt(prompt(44))
      STOP

C     Error writing corfunc.dar
5030  CALL showprompt(prompt(16))
      STOP

      END

