      PROGRAM ftransform
C     T.M.W. Nye July 94.
C     Performs correlation function Fourier transform on given data.
C     Calculates 1D and 3D correlation functions and writes them
C     to files X??000.CF1 and X??000.CF3.
C
C     Reference: Strobl und Schneider; J.Polymer Sci., polymer Phys. Ed.;
C     Vol. 18, 1343-1359, 1980
C
C     Update 9/8/94
C     Tailfit channel limits vary with channel no.
C
C     Update 11/8/94
C     Interface distribution function added.
C
C     Update 2005
C     ASCII output added.
C     Gamma3All added.  Fdi added.  Notokidf added.
C
C     Update Nov 2005
C     Redimensioned data arrays from 512 to MaxDim.
C     Added ASCII output of multi-frame data & array asciiresults

      CHARACTER*80 dirname,filename,qaxname,othername,momname,momax,ascname
      CHARACTER*40 title,ascii,sigmodel,user
      CHARACTER*80 prompt(25),fname,axisname,fname2,arbabs,graphics
      CHARACTER*40 backex,retrans
      CHARACTER*80 fully,fullx,transhead,transname
      CHARACTER*80 cor1name,cor3name,cor1head,cor3head,dhead,dname
      CHARACTER*80 idfhead,idfname
      CHARACTER*80 storename,outname,stat,idftoggle*40
      CHARACTER*1 letter
      INTEGER qzero,plotflag,retransflag
      INTEGER realtime(4),realflag
      INTEGER datastart,count,upperlim,lword
      INTEGER MaxDim
      PARAMETER (MaxDim=4096)
      REAL moment(MaxDim,5),idf(MaxDim,MaxDim),fdi(MaxDim,MaxDim)
      DIMENSION notok(10),notokcf1(10),xdata(2048),ydata(2048)
      DIMENSION param(MaxDim,5),trans2(MaxDim),trans3(MaxDim),notokidf(10)
      DIMENSION gamma1(2048),gamma1all(MaxDim*2048),gamma3(2048),
     &          gamma3all(MaxDim*2048),xgamma(2048)
      DIMENSION asciiresults(MaxDim)

C     Array "param"
C     Parameter 1: Bonart background
C     Parameter 2: K (interface per unit volume)
C     Parameter 3: sigma (diffuse boundary thickness
C     Parameter 4: A or H1
C     Parameter 5: B or H2

C     There are lots of arrays:
C     however, realtime data is not all stored in memory
C     at the same time. Instead, each frame is read in and
C     handled individually, eg. gamma1 instead of being
C     gamma1(nframe,channel) is simply gamma1(channel).


1000  FORMAT(A1)
1010  FORMAT(A80)
1020  FORMAT(2x,I3)
1030  FORMAT(10I8)
1040  FORMAT(A40)
1050  FORMAT(2x,I3,2x,I3,2x,I3,2x,I3)
1060  FORMAT(E12.6,2x,E12.6,2x,E12.6,2x,E12.6,2x,E12.6)
1070  FORMAT(A10)
1080  FORMAT(/,1x,'Working...')
1090  FORMAT(/,1x,'100: Transforming frame ',I3,'...')
1100  FORMAT(1x,'100: Re-transforming...')
1110  FORMAT(1x,'Correlation function analysis ',
     +'output file from program transform.f.')
1120  FORMAT(1x,'File: ',A40,' Frame: ',I3,'.')
1130  FORMAT(1x,'R [Angstroms]    Gamma1        Gamma3')
1140  FORMAT(1x,'----------------------------------------')
1150  FORMAT(1x,E12.6,2x,E12.6,2x,E12.6)
1160  FORMAT(2x,I3,2x,I3,2x,I3)
1170  FORMAT(1x,'100: Calculating interface distribution function...')
1180  FORMAT(1x,"100: Written Gamma1: ",A10)
1185  FORMAT(1x,"100: Written ASCII Gamma1: ",A10)
1190  FORMAT(1x,"100: Written Gamma3: ",A10)
1195  FORMAT(1x,"100: Written ASCII Gamma3: ",A10)
1200  FORMAT(1x,"100: Written x-axis: ",A10)
1205  FORMAT(1x,"100: Written ASCII x-axis: ",A10)
1210  FORMAT(1x,"100: Written re-transform: ",A10)
1215  FORMAT(1x,"100: Written ASCII re-transform: ",A10)
1220  FORMAT(1x,"100: Written second moment v frame: ",A10)
1225  FORMAT(1x,"100: Written ASCII second moment v frame: ",A10)
1230  FORMAT(1x,"100: Written interface distribution func: ",A10)
1235  FORMAT(1x,"100: Written ASCII interface distribution func: ",A10)
1240  FORMAT(E12.6)

      prompt(1)='ERROR: Error reading corfunc.txt file: FATAL'
      prompt(2)='ERROR: Error reading data file: FATAL'
      prompt(3)='ERROR: Expecting static Q axis,'
     +//' received dynamic: FATAL'
      prompt(4)='All necessary files correctly loaded...'
      prompt(5)='ERROR: Extrapolated Q data does not '
     +//'reach Q=0.6: FATAL'
      prompt(6)='ERROR: Software error with subroutine'
     +//' changeotok: FATAL'
      prompt(7)='ERROR: Error creating otoko output files: FATAL'
      prompt(8)='Transforms completed...'
      prompt(9)='Sorry: no graphics for realtime data...'
      prompt(10)='DISPLAYING GRAPHICS: PRESS MIDDLE MOUSE BUTTON '
     +//'TO CONTINUE...'
      prompt(11)='ERROR: Error reading cor. func. otoko files '
     +//'while preparing ascii output: FATAL'
      prompt(12)='WARNING: Error writing ascii output'
      prompt(13)='Preparing ascii output...'
      prompt(14)='Creating moments output file...'
      prompt(15)='ERROR: Error writing extract.txt file: FATAL'
      prompt(16)='ERROR: Error with status file: FATAL'
      prompt(17)='Finished transform'
      prompt(18)='ERROR: Exceeded maximum number of steps for F.T. '
     +//'= 511: FATAL'
      prompt(19)='Enter maximum D for Fourier transform [Angstroms]'
      prompt(20)='Enter step in D for Fourier transform [Angstroms]'
      prompt(21)='Re-transform correlation function [y/n]'
      prompt(22)='Enter estimate of volume fraction crystallinity'
      prompt(23)='Calculate the interface distribution function [y/n]'
      prompt(24)='100: TRANSFORMING...'
      prompt(25)='100:'

      dmax=200.
      dstep=1.
      retrans='off'
      idftoggle='off'
      CALL WRDLEN(lword)

C      WRITE(6,*)
C      title='Correlation Function Calculation'
C      CALL showtitle(title)
      CALL showprompt(prompt(25))
      CALL showprompt(prompt(24))

C     Read corfunc.txt
      open(unit=9,file='corfunc.txt',STATUS='old',ERR=5000)
      read(9,1010,ERR=5000)filename
      read(9,1010,ERR=5000)qaxname
      read(9,1050,ERR=5000)realtime(1),realtime(2),realtime(3),
     &                     realtime(4)
      read(9,1010,ERR=5000)arbabs
      read(9,1040,ERR=5000)sigmodel
      read(9,1040,ERR=5000)backex
      read(9,1020,ERR=5000)qzero
      DO i=realtime(1),realtime(2),realtime(3)
          read(9,1060,ERR=5000)param(i,1),param(i,2),param(i,3),
     &                         param(i,4),param(i,5)
      END DO
      close(9)

C     Input Fourier transform data
C     Maximum D
2070  CALL defaultreal(prompt(19),dmax)
C      IF (dmax .LT. 100. .OR. dmax .GT. 1000.) THEN
C        CALL showprompt(prompt(18))
C        GOTO 2070
C      ENDIF
C     Step in D
2080  CALL defaultreal(prompt(20),dstep)
C      IF (dstep .LT. 0.25 .OR. dstep .GT. 4.) THEN
C        CALL showprompt(prompt(18))
C        GOTO 2080
C      ENDIF
      IF ((dmax/dstep) .GT. 511.) THEN
C     too many steps
        CALL showprompt(prompt(18))
        GOTO 2070
      ENDIF
C     Re-transform data?
      letter='n'
      CALL defaultletter(prompt(21),letter)
      IF (letter .EQ. 'y' .OR. letter .EQ. 'Y') THEN
        retrans='on'
      ELSE
        retrans='off'
      ENDIF
C     interface distribution function?
      letter='n'
      CALL defaultletter(prompt(23),letter)
      IF (letter .EQ. 'y' .OR. letter .EQ. 'Y') THEN
        idftoggle='on'
      ELSE
        idftoggle='off'
      ENDIF

C     Calculate number of points in correlation functions
      numd=INT(dmax/dstep)+1

      CALL getpath(filename,dirname)
      CALL strippath(filename,fname2)
      filename=fname2

C     Change filenames to extrapolated data filenames
      fully=filename
      CALL swapexten(fully,'FUL')
      fullx=qaxname
      CALL swapexten(fullx,'FLX')

C     Read intensity header
      fname=fully
      axisname=fullx
      OPEN(UNIT=9,FILE=fname,STATUS='old',ERR=5020)
      
      READ(9,1000,ERR=5020)letter
      READ(9,1000,ERR=5020)letter
      READ(9,1030,ERR=5020)notok
      READ(9,1040,ERR=5020)othername
      CLOSE(9)

      nndata=4*2048

C     READ intensities
      fname2=othername
      OPEN(UNIT=9,FILE=fname2,STATUS='old',
     +ACCESS='direct',RECL=nndata/lword,ERR=5020)
      DO nframe=1,realtime(4)
C       NB: this is just to check the data exists.
        READ(9,REC=nframe,ERR=5020)(ydata(i),i=1,2048)
      END DO
      CLOSE(9)

C     Save name of intensity file for later
      storename=fname2

C     Open Q axis header
      OPEN(UNIT=9,FILE=axisname,STATUS='old',ERR=5020)
      READ(9,1000,ERR=5020)letter
      READ(9,1000,ERR=5020)letter
      READ(9,1030,ERR=5020)notok
      READ(9,1040,ERR=5020)othername
      CLOSE(9)

C     Check static
      IF (notok(2) .NE. 1) THEN
        CALL showprompt(prompt(3))
        STOP
      ENDIF

C     Read x axis data
      fname2=othername
      OPEN(UNIT=9,FILE=fname2,STATUS='old',
     +ACCESS='direct',RECL=nndata/lword,ERR=5020)
      READ(9,REC=1,ERR=5020)(xdata(i),i=1,2048)
2010  CLOSE(9)

C     Ok - data fine
      CALL showprompt(prompt(4))

      WRITE(6,1080)

C     Limit on all calculations: integrate out this far.
      qmax=0.6
C     Qmax=0.6 correspond to fluctuations in cor. func. at D ~ 10 Angst.

C     Calculate x axis for transforms: ie. real space coordinate.
      DO i=1,2048
        xgamma(i)=dstep*(i-1)
      END DO

C     get outputname for 1D and 3D cor. func.s
      cor1head=filename
      cor3head=filename
      CALL swapexten(cor1head,'CF1')
      CALL swapexten(cor3head,'CF3')
      CALL changeotok(cor1head,cor1name,nerr)
      IF (nerr .EQ. 1) THEN
        CALL showprompt(prompt(6))
        STOP
      ENDIF
      CALL changeotok(cor3head,cor3name,nerr)
      IF (nerr .EQ. 1) THEN
        CALL showprompt(prompt(6))
        STOP
      ENDIF

C     Also prepare real~space axis filenames
      dhead=cor1head
      CALL swapexten(dhead,'RXA')
      CALL changeotok(dhead,dname,nerr)
      IF (nerr .EQ. 1) THEN
        CALL showprompt(prompt(6))
        STOP
      ENDIF

C     Write otoko file headers.
C     First do the real space axis.
      fname=dhead
      OPEN(UNIT=9,FILE=fname,STATUS='unknown',ERR=5030)
      WRITE(9,*,ERR=5030)
      WRITE(9,*,ERR=5030)
      notok(1)=numd
      notok(2)=1
      notok(3)=1
      CALL endian(notok(4))
      DO i=5,10
        notok(i)=0
      END DO
      WRITE(9,1030,ERR=5030)notok
      WRITE(9,1070,ERR=5030)dname(1:10)
      CLOSE(9)
C     X header done

C     Now do x data
      nrecl=4*MaxDim
      fname=dname
      OPEN(UNIT=10,FILE=fname,STATUS='unknown',
     +ACCESS='direct',RECL=nrecl/lword,ERR=5030)
      WRITE(10,REC=1,ERR=5030)
     +(xgamma(i),i=1,numd)
      CLOSE(10)

      write(6,1200)dhead

C     Output the real axis in ASCII format
      CALL writeascii(fname(1:3)//"RXA."//"TXT",notok,xgamma,irc,1)
      IF(irc.EQ.0)THEN
        CALL showprompt(prompt(12))
      ELSE
        WRITE(6,1205)fname(1:3)//"RXA."//"TXT"
      ENDIF

C     Now create headers for 1D and 3D cor. func.s.
C     1 dim.
      fname=cor1head
      OPEN(UNIT=9,FILE=fname,STATUS='unknown',ERR=5030)
      WRITE(9,*,ERR=5030)
      WRITE(9,*,ERR=5030)
      notok(1)=numd
      notok(2)=realtime(4)
      notok(3)=1
      CALL endian(notok(4))
      DO i=5,10
        notok(i)=0
      END DO
      WRITE(9,1030,ERR=5030)notok
      WRITE(9,1070,ERR=5030)cor1name(1:10)
      CLOSE(9)

C	For the correlation functions
      notokcf1(1)=notok(1)
      notokcf1(2)=notok(2)
      DO i=3,10
        notokcf1(i)=0
      END DO

C	For the interface distribution function
C	(Also see the comment below where the IDF is written out)
C     notokidf(1)=MaxDim
      notokidf(1)=notok(1)
      notokidf(2)=notok(2)
      DO i=3,10
        notokidf(i)=0
      END DO

C     1D header done
C     3 dim.
      fname=cor3head
      OPEN(UNIT=9,FILE=fname,STATUS='unknown',ERR=5030)
      WRITE(9,*,ERR=5030)
      WRITE(9,*,ERR=5030)
      notok(1)=numd
      notok(2)=realtime(4)
      notok(3)=1
      CALL endian(notok(4))
      DO i=5,10
        notok(i)=0
      END DO
      WRITE(9,1030,ERR=5030)notok
      WRITE(9,1070,ERR=5030)cor3name(1:10)
      CLOSE(9)
C     3D header done

C     Also open data files
      nrecl=numd*4
      fname=cor1name
      OPEN(UNIT=9,FILE=fname,STATUS='unknown',
     +ACCESS='direct',RECL=nrecl/lword,ERR=5030)
      fname=cor3name
      OPEN(UNIT=10,FILE=fname,STATUS='unknown',
     +ACCESS='direct',RECL=nrecl/lword,ERR=5030)

C     Finally create header and open file for re-transformed data.
      IF (retrans .EQ. 'on' .OR. retrans .EQ. 'ON') THEN

        npts=MaxDim-qzero+1

C       get filenames
        transhead=filename
        CALL swapexten(transhead,'SMO')
        CALL changeotok(transhead,transname,nerr)
        IF (nerr .EQ. 1) THEN
          CALL showprompt(prompt(6))
          STOP
        ENDIF
C       Create header
        fname=transhead
        fname2=transhead(1:9)//'2'
        OPEN(UNIT=8,FILE=fname,STATUS='unknown',ERR=5030)
        OPEN(UNIT=11,FILE=fname2,STATUS='unknown',ERR=5030)
        WRITE(8,*,ERR=5030)
        WRITE(11,*,ERR=5030)
        WRITE(8,*,ERR=5030)
        WRITE(11,*,ERR=5030)
        notok(1)=npts+qzero-1
        notok(2)=realtime(4)
        notok(3)=1
        CALL endian(notok(4))
        DO i=5,10
          notok(i)=0
        END DO
        WRITE(8,1030,ERR=5030)notok
        WRITE(11,1030,ERR=5030)notok
        WRITE(8,1070,ERR=5030)transname(1:10)
        WRITE(11,1070,ERR=5030)transname(1:9)//'2'
        CLOSE(8)
        CLOSE(11)

C       Open file
        nrecl=(npts+qzero-1)*4
        fname=transname
        fname2=transname(1:9)//'2'
        OPEN(UNIT=8,FILE=fname,STATUS='unknown',
     +  ACCESS='direct',RECL=nrecl/lword,ERR=5030)
        OPEN(UNIT=11,FILE=fname2,STATUS='unknown',
     +  ACCESS='direct',RECL=nrecl/lword,ERR=5030)
C       All done
      ENDIF

C     START NUMBER CRUNCH
C     ~~~~~~~~~~~~~~~~~~~

C     LOOP THROUGH FRAMES
      nfr=0
      DO nframe=realtime(1),realtime(2),realtime(3)
        nfr=nfr+1

        WRITE(6,1090)nframe

C       Get data.
        OPEN(UNIT=7,FILE=storename,STATUS='old',
     +  ACCESS='direct',RECL=8192/lword,ERR=5020)
          READ(7,REC=nfr,ERR=5020)(ydata(i),i=1,2048)
        CLOSE(7)

C       Calculate moments.
C       ~~~~~~~~~~~~~~~~~~
        DO j=1,5
          moment(nframe,j)=0.
        END DO
C       xdata(1) is not necessarily zero: take care of first point.
        x1=xdata(1)
        y1=ydata(1)
        DO j=1,5
          moment(nframe,j)=moment(nframe,j)+
     +    x1*0.5*y1*(x1**(j-1))
        END DO
        count=1

C       Then int. wrt. Q, summing at each Q value.
2020    count=count+1
        x2=xdata(count)
        y2=ydata(count)
        DO j=1,5
          moment(nframe,j)=moment(nframe,j)+
     +    (x2-x1)*0.5*(y1*(x1**(j-1))+y2*(x2**(j-1)))
        END DO
        x1=x2
        y1=y2

C       Check to see whether we've gone out far enough in Q
        IF (x1 .LT. qmax .AND. count .LT. 2048) THEN
          GOTO 2020
        ELSEIF (x1 .LT. qmax .AND. count .EQ. 2048) THEN
          CALL showprompt(prompt(5))
          STOP
        ENDIF

C       End calculating moments


C       Calculate transforms.
C       ~~~~~~~~~~~~~~~~~~~~~
C       Reset cor. func.s
        DO i=1,MaxDim
          gamma1(i)=0.
          gamma3(i)=0.
        END DO

C       Value at the ordinate is defined as 1.0
        gamma1(1)=1.
        gamma3(1)=1.

C       Check whether we are going to retransform data:
C       calculate correlation function as far out as this requires.
        IF (retrans .EQ. 'on' .OR. retrans .EQ. 'ON') THEN
          nend=2048
        ELSE
          nend=numd
        ENDIF

C       Loop through the values of d
        DO i=2,nend
          d=xgamma(i)

C         Evaluate integral for this value of d
          x1=xdata(1)
          y1=ydata(1)
          gamma1(i)=0.5*x1*(x1*x1*y1*COS(d*x1))
          gamma3(i)=0.5*x1*(x1*y1*SIN(d*x1)/d)
          count=1

2030      count=count+1
          x2=xdata(count)
          y2=ydata(count)

C         One dimensional correlation function:
          temp1=(x1*x1*y1*COS(d*x1))
          temp2=(x2*x2*y2*COS(d*x2))
          gamma1(i)=gamma1(i)+0.5*(x2-x1)*(temp1+temp2)

C         Three dimensional cor. func.:
          temp1=(x1*y1*SIN(d*x1))/d
          temp2=(x2*y2*SIN(d*x2))/d
          gamma3(i)=gamma3(i)+0.5*(x2-x1)*(temp1+temp2)

C         Update values:
          x1=x2
          y1=y2

C         Check to see whether we've looked sufficiently far out in Q.
          IF (x1 .LT. qmax .AND. count .LT. 2048) THEN
            GOTO 2030
          ELSEIF (x1 .LT. qmax .AND. count .EQ. 2048) THEN
            CALL showprompt(prompt(5))
            STOP
          ENDIF

C         Calculation for one value of D is complete.
C         Normalise to the second moment:
          gamma1(i)=gamma1(i)/moment(nframe,3)
          gamma3(i)=gamma3(i)/moment(nframe,3)

C       End loop through D
        END DO

C       Output cor. func.s into otoko files.
C       1 dim.
        WRITE(9,REC=nfr,ERR=5030)(gamma1(i),i=1,numd)
C       3 dim.
        WRITE(10,REC=nfr,ERR=5030)(gamma3(i),i=1,numd)

        DO i=1,numd
          gamma1all(((nfr-1)*notokcf1(1))+i)=gamma1(i)
          gamma3all(((nfr-1)*notokcf1(1))+i)=gamma3(i)
        END DO

C       Interface distribution function.
C       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        IF (idftoggle .EQ. 'on' .OR. idftoggle .EQ. 'ON') THEN
          WRITE(6,1170)

C         Reset array
          DO i=1,MaxDim
            idf(nframe,i)=0.
          END DO

C         Value at the ordinate is given by moments
          idf(nframe,1)=-moment(nframe,5)/moment(nframe,3)

C         Number of points
          nend=numd

C         Loop through the values of d
          DO i=2,nend
            d=xgamma(i)

C           Evaluate integral for this value of d
            x1=xdata(1)
            y1=ydata(1)
            idf(nframe,i)=0.5*x1*(-(x1**4)*y1*COS(d*x1))
            count=1

2050        count=count+1
            x2=xdata(count)
            y2=ydata(count)

C           One dimensional correlation function:
            temp1=(-(x1**4)*y1*COS(d*x1))
            temp2=(-(x2**4)*y2*COS(d*x2))
            idf(nframe,i)=idf(nframe,i)+0.5*(x2-x1)*(temp1+temp2)

C           Update values:
            x1=x2
            y1=y2

C           Check to see whether we've looked sufficiently far out in Q.
            IF (x1 .LT. qmax .AND. count .LT. 2048) THEN
              GOTO 2050
            ELSEIF (x1 .LT. qmax .AND. count .EQ. 2048) THEN
              CALL showprompt(prompt(5))
              STOP
            ENDIF

C           Calculation for one value of D is complete.
C           Normalise to the second moment:
            idf(nframe,i)=idf(nframe,i)/moment(nframe,3)

C         End loop through D
          END DO

C       Calc. idf?
        ENDIF


C       Re-transform if necessary
C       ~~~~~~~~~~~~

        IF (retrans .EQ. 'on' .OR. retrans .EQ. 'ON') THEN

          WRITE(6,1100)

C         Reset re-transform data
          DO i=1,MaxDim
            trans2(i)=0.
          END DO

C         Calculate number of points required

C         Loop through the values of Q
C         Ignore the first point - artefacts?
          DO i=2,npts
            q=xdata(i)

C           Evaluate integral for this value of Q
            x1=xgamma(1)
            y1=gamma1(1)
            trans2(i)=0.5*x1*(y1*COS(q*x1))
            count=1

2040        count=count+1
            x2=xgamma(count)
            y2=gamma1(count)

            temp1=(y1*COS(q*x1))
            temp2=(y2*COS(q*x2))
            trans2(i)=trans2(i)+0.5*(x2-x1)*(temp1+temp2)

C           Update values:
            x1=x2
            y1=y2

C           Check to see whether we've looked sufficiently far out in D.
C           Change these conditions later.
            IF (count .LT. 2048) THEN
              GOTO 2040
            ENDIF

C           Calculation for one value of Q is complete.
C           Normalise to the second moment:

            trans2(i)=trans2(i)*moment(nframe,3)/(3.1416*0.5)

C           I think that there is also a factor of pi/2 in there.
C           We transformed IQQ originally, so we must now divide
C           by Q**2 to get back to the original data.
            trans2(i)=trans2(i)/(q*q)

C         End loop through Q
          END DO

C         Shift transformed data according to qzero, so that the
C         original x-ray data x axis can be use for displaying
C         the retransformed data.
          DO i=MaxDim,qzero,-1
            trans2(i)=trans2(i-qzero+1)
            trans3(i)=trans2(i)+param(nframe,1)
          END DO
          DO i=qzero-1,1,-1
            trans2(i)=0.
            trans3(i)=0.
          END DO

C         Output retrans. data
          WRITE(8,REC=nfr,ERR=5030)(trans2(i),i=1,npts+qzero-1)
          WRITE(11,REC=nfr,ERR=5030)(trans3(i),i=1,npts+qzero-1)

C       Output the retrans data in ASCII format
        CALL writeascii(cor1head(1:3)//"SMO."//"TXT",notokcf1,trans2,
     +                  irc,1)

        IF(irc.EQ.0)THEN
          CALL showprompt(prompt(12))
        ELSE
          WRITE(6,1215)cor1head(1:3)//"SMO."//"TXT"
        ENDIF
        CALL writeascii(cor1head(1:3)//"SM2."//"TXT",notokcf1,trans3,
     +                  irc,1)

        IF(irc.EQ.0)THEN
          CALL showprompt(prompt(12))
        ELSE
          WRITE(6,1215)cor1head(1:3)//"SM2."//"TXT"
        ENDIF

C       End check whether retrans needed
        ENDIF


C     End Loop through frames
      END DO
      write(6,1180)cor1head
      write(6,1190)cor3head
      IF(retrans.eq."on".or.retrans.eq."ON")then
        write(6,1210)transhead(1:10)
        write(6,1210)transhead(1:9)//'2'
        CLOSE(11)
      ENDIF
      CLOSE(8)
      CLOSE(9)
      CLOSE(10)


C       Output the 1-D Correlation function in ASCII format
        CALL writeascii(cor1head(1:3)//"CF1."//"TXT",notokcf1,gamma1all,
     +                  irc,1)

        IF(irc.EQ.0)THEN
          CALL showprompt(prompt(12))
        ELSE
          WRITE(6,1185)cor1head(1:3)//"CF1."//"TXT"
        ENDIF

C       Output the 3-D Correlation function in ASCII format
        CALL writeascii(cor3head(1:3)//"CF3."//"TXT",notokcf1,gamma3all,
     +                  irc,1)

        IF(irc.EQ.0)THEN
          CALL showprompt(prompt(12))
        ELSE
          WRITE(6,1195)cor3head(1:3)//"CF3."//"TXT"
        ENDIF

C     Output interface distribution function if necessary.
      IF (idftoggle .EQ. 'on' .OR. idftoggle .EQ. 'ON') THEN

C       get filenames
        idfhead=filename
        CALL swapexten(idfhead,'IDF')
        CALL changeotok(idfhead,idfname,nerr)
        IF (nerr .EQ. 1) THEN
          CALL showprompt(prompt(6))
          STOP
        ENDIF

C       Write otoko header
        fname=idfhead
        OPEN(UNIT=9,FILE=fname,STATUS='unknown',ERR=5030)
        WRITE(9,*,ERR=5030)
        WRITE(9,*,ERR=5030)
        notok(1)=numd
        notok(2)=realtime(4)
        notok(3)=1
        CALL endian(notok(4))
        DO i=5,10
          notok(i)=0
        END DO
        WRITE(9,1030,ERR=5030)notok
        WRITE(9,1070,ERR=5030)idfname(1:10)
        CLOSE(9)
C       Header done

C       Now do idf data
        nrecl=4*numd
        fname=idfname
        OPEN(UNIT=10,FILE=fname,STATUS='unknown',
     +  ACCESS='direct',RECL=nrecl/lword,ERR=5030)
        nfr=0
        DO nframe=realtime(1),realtime(2),realtime(3)
          nfr=nfr+1
          WRITE(10,REC=nfr,ERR=5030)
     +    (idf(nframe,i),i=1,numd)
        END DO
        CLOSE(10)

      WRITE(6,1230)idfhead
C     End idf output
      ENDIF

C	FORTRAN and C store their 2D arrays in a different order, so
C	need to resequqnce idf() in order to use WRITEASCII.C to output
C	the IDF in ASCII!
C	Note that as this stands, WRITEASCII.C will ouput trailing zeroes
C	from the maximum channel number plus 1, upto the array dimension.
C	If the array dimension is increased it would be smarter to introduce
C	a step equal to the maximum channel dimension each frame.
	do i=1,MaxDim
	   do j=1,MaxDim
	      fdi(j,i)=0.
	   end do
	end do
C	Loop over channels
	do i=1,notokidf(1)
C	Loop over frames
	   do j=1,notokidf(2)
	      fdi(i,j)=idf(j,i)
	   end do
	end do

C       Output the idf in ASCII format
        CALL writeascii(idfhead(1:3)//"IDF."//"TXT",notokidf,fdi,
     +                  irc,1)

        IF(irc.EQ.0)THEN
          CALL showprompt(prompt(12))
        ELSE
          WRITE(6,1235)idfhead(1:3)//"IDF."//"TXT"
        ENDIF


C     END NUMBER CRUNCH
C     ~~~~~~~~~~~~~~~~~

      CALL showprompt(prompt(8))

C     Also consider re-transformed data
      IF (retrans .EQ. 'on' .OR. retrans .EQ. 'ON') THEN
        retransflag=1
      ELSE
        retransflag=0
      ENDIF

C     Check whether realtime or static output.
      IF (realtime(4) .NE. 1) THEN

C       Realtime.
C       Create an otoko file containing the second moment and plot.

C       Get filename.
        momname=filename
        momax=filename
        CALL swapexten(momname,'MO2')
        CALL swapexten(momax,'FAX')
C       x-axis should already exist

C       Create otoko header
C       Change header name to give data filename
        CALL changeotok(momname,othername,nerr)
        IF (nerr .EQ. 1) THEN
          CALL showprompt(prompt(6))
          STOP
        ENDIF
        fname=momname
        OPEN(UNIT=9,FILE=fname,STATUS='unknown',ERR=5030)
        WRITE(9,*,ERR=5030)
        WRITE(9,*,ERR=5030)
        notok(1)=realtime(4)
        notok(2)=1
        notok(3)=1
        CALL endian(notok(4))
        DO i=5,10
          notok(i)=0
        END DO
        WRITE(9,1030,ERR=5030)notok
        WRITE(9,1070,ERR=5030)othername(1:10)
        CLOSE(9)
C       Header done

        nrecl=4*realtime(4)
        outname=othername
        OPEN(UNIT=10,FILE=outname,STATUS='unknown',
     +  ACCESS='direct',RECL=nrecl/lword,ERR=5030)
        WRITE(10,REC=1,ERR=5030)
     +  (moment(i,3),i=realtime(1),realtime(2),realtime(3))
        CLOSE(10)

        write(6,1220)fname

C       Output the second moment data in ASCII format
	  do i=realtime(1),realtime(2),realtime(3)	  
           asciiresults(i)=moment(i,3)
        end do
        CALL writeascii(fname(1:3)//"MO2."//"TXT",notok,asciiresults,
     +                  irc,1)
        IF(irc.EQ.0)THEN
          CALL showprompt(prompt(12))
        ELSE
          WRITE(6,1225)fname(1:3)//"MO2."//"TXT"
        ENDIF

C     End realtime or static
      ENDIF

C     Write extract.txt
      open(unit=9,file='extract.txt',STATUS='unknown',ERR=5010)
      write(9,1240,ERR=5010)dmax
      write(9,1240,ERR=5010)dstep
      DO i=realtime(1),realtime(2),realtime(3)
          write(9,1060,ERR=5010)moment(i,1),moment(i,2),moment(i,3),
     &                          moment(i,4),moment(i,5)
      END DO
      close(9)

C     End Program.
      CALL showprompt(prompt(17))
      STOP


C     Error Catches:

C     Error reading corfunc.txt
5000  CALL showprompt(prompt(1))
      STOP

C     Error writing extract.txt
5010  CALL showprompt(prompt(15))
      STOP

C     Error reading in intensities or x data
5020  CALL showprompt(prompt(2))
      STOP

C     Error writing otoko output.
5030  CALL showprompt(prompt(7))
      STOP

C     Error reading in correlation function otoko files.
5040  CALL showprompt(prompt(11))
      STOP

      END



      SUBROUTINE convertname(fname,num)
C     Alters a file name X??000.* to X??nnn.*
C     where nnn is a frame number specified by "num".
      CHARACTER*80 fname
      CHARACTER*1 letter(3),chunk*4
      INTEGER digit(3)

1000  FORMAT(/,1x,'ERROR: Software error in subroutine convertname: ',
     +'problem with filename: FATAL')

C     Get num as a string
      n=num
      DO i=0,9
        IF (n .LT. 100) THEN
          digit(1)=i
          GOTO 10
        ELSE
          n=n-100
        ENDIF
      END DO

10    DO i=0,9
       IF (n .LT. 10) THEN
          digit(2)=i
          GOTO 20
        ELSE
          n=n-10
        ENDIF
      END DO

20    DO i=0,9
       IF (n .LT. 1) THEN
          digit(3)=i
          GOTO 30
        ELSE
          n=n-1
        ENDIF
      END DO

C     Convert single figure integers to strings
30    DO i=1,3
        IF (digit(i) .EQ. 0) letter(i)='0'
        IF (digit(i) .EQ. 1) letter(i)='1'
        IF (digit(i) .EQ. 2) letter(i)='2'
        IF (digit(i) .EQ. 3) letter(i)='3'
        IF (digit(i) .EQ. 4) letter(i)='4'
        IF (digit(i) .EQ. 5) letter(i)='5'
        IF (digit(i) .EQ. 6) letter(i)='6'
        IF (digit(i) .EQ. 7) letter(i)='7'
        IF (digit(i) .EQ. 8) letter(i)='8'
        IF (digit(i) .EQ. 9) letter(i)='9'
      END DO

C     Finally, change the filename.
      DO i=2,77
        chunk=fname(i:i+3)
        IF (chunk .EQ. '000.') THEN
          fname=fname(1:i-1)//letter(1)//letter(2)//
     +    letter(3)//'.ASC'
          GOTO 40
        ENDIF
      END DO

C     Error message:
      WRITE(6,1000)
      STOP

40    RETURN
      END
