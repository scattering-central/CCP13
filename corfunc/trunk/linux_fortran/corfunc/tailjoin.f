      SUBROUTINE tailjoin(filename,qaxname,param,channel,ndata,qzero,
     &                    backex,datastart,realtime,limit2,static)

C     TMW NYE July 94
C     Correlation function analysis module.
C     Extrapolates experimental scattering data to "Q infinity",
C     actually an arbitrarily large Q value, according to the
C     parameters found in program tailfit
C
C     Then applies a Savitsky-Golay smoothing filter to the
C     transition between experimental and calculated data,
C     to ensure higher moments - and hence the region D ~ 2PI/(Qjoin) -
C     are not biased by the joining process.
C     REF: Numerical Recipes, Flannery and Press, p.646
C
C     Also performs back-extrapolation to Q=0 by least squares fitting
C     according to one of two models:
C     Vonk:    I(Q) = h1-h2*Q^2
C     Guinier: I(Q) = A * EXP(B*Q^2)
C     REF? No ref for vonk, but Guinier is standard:
C     X-ray scattering of synth. polymers; Balta-Calleja & Vonk.
C
C     6/8/94 Update:
C     Smoothing takes place in a Log(I) Q world, so problems arise
C     when tails are noisey and the background exceeds expt. data
C     points (attempted log of negative no.). Until now attempts
C     to remedy this have been poor so to simplify the situation
C     smoothing will take place on non backgr. subtracted data,
C     after which a backgr. will be subtracted.
C     Also testing effect at high R on gamma1(R).
C
C     9/8/94 Update:
C     Varible tailfit limits cf. frame no.
C
C     7/7/04 Update: S King
C	Added ASCII output of extrapolated data.
C
C     28/11/05 Update: S King
C	Redimensioned data arrays from 512 to MaxDim.
C     Added ASCII output of multi-frame data
C
      CHARACTER*80 dirname,filename,qaxname,othername,xheader,yheader,
     +             yheader2
      CHARACTER*40 title,retrans,ascii,sigmodel
      CHARACTER*80 prompt(28),fname,axisname,arbabs,graphics
      CHARACTER*80 fname2,outname,stat,radname,radax
      CHARACTER*40 backex,status*4,user,idftoggle
      CHARACTER*1 letter
      CHARACTER*40 xlabel,ylabel
      INTEGER lim1,lim2,qzero,datastart
      INTEGER realtime(4),realflag,start,chanend
      INTEGER MaxDim
	PARAMETER (MaxDim=4096)
      INTEGER channel(MaxDim),bestend,plotflag,lowerlim,upperlim,lword
      DIMENSION notok(10),xdata(MaxDim),ydata(MaxDim),data(MaxDim,MaxDim)
      DIMENSION param(MaxDim,5),coeff(61),smooth(MaxDim),smoothed(MaxDim,MaxDim)
      DIMENSION yout(2048),xout(2048),radgyr(MaxDim)
      DIMENSION limit1(MaxDim),limit2(MaxDim)
      LOGICAL static
      CHARACTER*10 filetype
      REAL asciidata(MaxDim*MaxDim)

C     Array "param"
C     Param(frame no., param no.)
C     Param 1 ~ Backgr.
C     Param 2 ~ porod
C     Param 3 ~ sigma
C     Param 4 ~ A/H1
C     Param 5 ~ B/H2

1000  FORMAT(A1)
1010  FORMAT(A80)
1020  FORMAT(2x,I3)
1030  FORMAT(10I8)
1040  FORMAT(A40)
1050  FORMAT(2x,I3,2x,I3,2x,I3,2x,I3)
1060  FORMAT(E12.6,2x,E12.6,2x,E12.6,2x,I3)
1070  FORMAT(/,1x,'100: Back extrap. results:')
1080  FORMAT(1x,'100: Frame: ',I3,'. Start: '
     +,I3,'. End: ',I3,'. A = ',E12.6,'. B = ',E12.6,'.')
1090  FORMAT(1x,'100: Start channel: ',I3,'. End channel: ',
     +I3,'. A = ',E12.6,'. B = ',E12.6,'.')
1100  FORMAT(1x,'100: Frame: ',I3,'. Start: ',I3,'. End: '
     +,I3,'. H1 = ',E12.6,'. H2 = ',E12.6,'.')
1110  FORMAT(1x,'100: Start channel: ',I3,'. End channel: ',
     +I3,'. H1 = ',E12.6,'. H2 = ',E12.6,'.')
1120  FORMAT(/,1x,'100: Smoothing to frame: ',I3,'.',//,1x,
     +'   Q value      Intensity   Smoothed Int  Data',/)
1130  FORMAT(1x,'100: ',E12.6,2x,E12.6,2x,E12.6,2x,A4)
1140  FORMAT(1x,'100: ',E12.6,2x,E12.6,2x,12x,2x,A4)
1150  FORMAT(10I8)
1160  FORMAT(A10)
1170  FORMAT(E12.6,2x,E12.6,2x,E12.6,2x,E12.6,2x,E12.6)
1180  FORMAT(1x,'ERROR: Guinier back extrapolation failed'
     +//' on frame ',I3,': FATAL')
1190  FORMAT(1x,'100: Frame ',I3,': Guinier radius of gyration = ',
     +E12.6,' Angstroms.')
1200  FORMAT(/,1x,'ERROR: Guinier back extrapolation failed!: FATAL')
1210  FORMAT(/,1x,'100: Guinier radius of gyration = '
     +,E12.6,' Angstroms.')
1220  FORMAT(A10)
1230  FORMAT(/,1x,'WARNING: Problem smoothing! Background exceeded ',
     +'experimental intensity for ',I3,' points.')
1240  FORMAT(2x,I3,2x,I3,2x,I3)
1250  FORMAT(2x,I3,2x,I3)
1260  FORMAT(1x,"100: Written extrapolated data: ",A10)
1270  FORMAT(1x,"100: Written extrapolated data q-axis: ",A10)
1280  FORMAT(1x,"100: Written Guinier radius of gyration v frame: ",A10)
1285  FORMAT(1x,"100: Written ASCII Guinier radius of gyration v frame: ",A10)
1290  FORMAT(1x,"100:")
C     S King, July 2004
1300  FORMAT(1x,"100: Written extrapolated ASCII q-axis data: ",A10)
1310  FORMAT(1x,"100: Written extrapolated ASCII data: ",A10)

C     Set up prompts, titles...
      prompt(1)='ERROR: Error reading parameter files: FATAL'
      prompt(2)='ERROR: Error reading otoko data files: FATAL'
      prompt(3)='ERROR: Expecting static Q axis,'
     +//' received dynamic: FATAL'
      prompt(4)='All necessary files correctly loaded...'
      prompt(5)='ERROR: Back extrapolate algorithm has failed '
     +//'to find start of genuine data: FATAL'
      prompt(6)='ERROR: Back extrapolate channel optimisation '
     +//'has failed: FATAL'
      prompt(7)='ERROR: Problem with lower tail limit: FATAL'
      prompt(8)='WARNING: Problem smoothing: background intensity '
     +//'greater than an expt. data point.'
      prompt(9)='Smoothing data: please wait...'
      prompt(10)='Smoothing complete...'
      prompt(11)='Creating extrapolated data files...'
      prompt(12)='ERROR: Software error with subroutine'
     +//' changeotok: FATAL'
      prompt(13)='ERROR: Error writing otoko format extrapolated '
     +//'data files: FATAL'
      prompt(14)='ERROR: Error with Q axis: FATAL'
      prompt(15)='Sorry: no graphics for realtime data...'
      prompt(16)='DISPLAYING GRAPHICS: PRESS MIDDLE MOUSE BUTTON '
     +//'TO CONTINUE...'
      prompt(17)='ERROR: Error writing file tailinfo.dat: FATAL'
      prompt(18)='100: Guinier radii of gyration [Angstroms]:'
      prompt(19)='ERROR: Software error with subroutine'
     +//' changeotok: FATAL'
      prompt(20)='ERROR: Error writing otoko file for graphics '
     +//'output: FATAL'
      prompt(21)='ERROR: Error with status file: FATAL'
      prompt(22)='ERROR: Data contains negative intensities: FATAL'
      prompt(23)='ERROR: Error with limitinfo.dat: FATAL'
      prompt(24)='Finished tailjoin'
      prompt(25)='100: EXTRAPOLATING TO ZERO AND INFINITY...'
C     S King, Jul 2004
      prompt(26)='WARNING: Problem writing the extrapolation in ASCII'
      prompt(27)=
     +'WARNING: Found negative intensities'
      prompt(28)='WARNING: Error writing ascii output'


      CALL WRDLEN(LWORD)
      realflag=1
      if(static)then
        realflag=0
        realtime(1)=1
        realtime(2)=1
        realtime(3)=1
        realtime(4)=1
      endif

C     Initialise
      DO i=1,MaxDim
        radgyr(i)=0.
      END DO

C      WRITE(6,*)
C      title='Tailjoin: extrapolation to zero and infinity'
C      CALL showtitle(title)
      WRITE(6,1290)
      CALL showprompt(prompt(25))

      fname=filename
      axisname=qaxname
      CALL getpath(fname,dirname)

c     Read the data
      CALL getfiletype(filetype,fname)
      IF(filetype.EQ."ascii")THEN
          CALL readascii(fname,notok,asciidata,irc)
          IF(irc.EQ.0)THEN
              GOTO 5020
          ENDIF
          nndata=ndata*4
          ij=1
          DO nframe=realtime(1),realtime(2),realtime(3)
            DO i=1,ndata
              data(nframe,i)=asciidata(ij)
              ij=ij+1
            END DO
          END DO
      ELSE
C         First read intensity header.
          OPEN(UNIT=9,FILE=fname,STATUS='old',ERR=5020)
          READ(9,1000,ERR=5020)letter
          READ(9,1000,ERR=5020)letter
          READ(9,1030,ERR=5020)notok
          READ(9,1040,ERR=5020)othername
          CLOSE(9)

          nndata=4*ndata

C         READ intensities
          CALL addstrings(dirname,othername,fname2)
          OPEN(UNIT=9,FILE=fname2,STATUS='old',
     +    ACCESS='direct',RECL=nndata/lword,ERR=5020)
          DO nframe=realtime(1),realtime(2),realtime(3)
            READ(9,REC=nframe,ERR=5020)(data(nframe,i),i=1,ndata)
          END DO
          CLOSE(9)
      ENDIF

      IF(filetype.NE."ascii")THEN
C SMK   CALL swap(data,notok(4),512*512,4)
        CALL swap(data,notok(4),MaxDim*MaxDim,4)
      ENDIF

      nframe=1

C     BACKGROUND SUBTRACT!
      DO nframe=realtime(1),realtime(2),realtime(3)
        DO i=1,MaxDim
          data(nframe,i)=data(nframe,i)-param(nframe,1)
        END DO
      END DO

C     Open Q axis
      CALL getfiletype(filetype,axisname)
      IF(filetype.EQ."ascii")THEN
          CALL readascii(axisname,notok,asciidata,irc)
          IF(irc.EQ.0)THEN
              GOTO 5020
          ENDIF
C         Check static
          IF (notok(2) .NE. 1) THEN
            CALL showprompt(prompt(3))
            STOP
          ENDIF
          DO i=1,ndata
            xdata(i)=asciidata(i)
          END DO
      ELSE
          OPEN(UNIT=9,FILE=axisname,STATUS='old',ERR=5020)
          READ(9,1000,ERR=5020)letter
          READ(9,1000,ERR=5020)letter
          READ(9,1030,ERR=5020)notok
          READ(9,1040,ERR=5020)othername
          CLOSE(9)

C         Check static
          IF (notok(2) .NE. 1) THEN
            CALL showprompt(prompt(3))
            STOP
          ENDIF

C         Read x axis data
          CALL addstrings(dirname,othername,fname2)
          OPEN(UNIT=9,FILE=fname2,STATUS='old',
     +    ACCESS='direct',RECL=nndata/lword,ERR=5020)
          READ(9,REC=1,ERR=5020)(xdata(i),i=1,ndata)
2010      CLOSE(9)
      ENDIF

      IF(filetype.NE."ascii")THEN
C SMK   CALL swap(xdata,notok(4),512,4)
        CALL swap(xdata,notok(4),MaxDim,4)
      ENDIF

C     Ok - data fine
      CALL showprompt(prompt(4))


C     START NUMBER CRUNCH


C     Loop through frames
      WRITE(6,1070)
      DO nframe=realtime(1),realtime(2),realtime(3)

C       Load up data
        DO i=1,MaxDim
          ydata(i)=data(nframe,i)
        END DO

C       Back extrapolate.
C       Got our starting point from corfunc.dat.
C       Skip three points ~ beamstop scatter?
C       No points skipped! Beam up-turn is too small.
2020    start=datastart

C       Optimise end point.
C       Set up initial situation
        oldchisqu=1.0E+20
        h1store=0.
        h2store=0.
        astore=0.
        bstore=0.
        bestend=0

C       Loop through end points
        DO chanend=start+4,start+15

          IF (backex .EQ. 'vonk' .OR.
     +    backex .EQ. 'VONK') THEN
C           Vonk model
            sigy=0.
            sigxsqu=0.
            sigxsquy=0.
            sigx4=0.

            DO j=start,chanend
C             Get sums
              temp=xdata(j)**2
              sigy=sigy+ydata(j)
              sigxsqu=sigxsqu+temp
              sigxsquy=sigxsquy+temp*ydata(j)
              sigx4=sigx4+temp*temp
            END DO

C           Calculate parameters
            npts=(chanend-start+1)
            h2=(sigxsqu*sigy-npts*sigxsquy)/(npts*sigx4-(sigxsqu**2))
            h1=(sigy+h2*sigxsqu)/npts

C           Get chi squ.
            chisqu=0.
            DO j=start,chanend
              chisqu=chisqu+(ydata(j)-h1+h2*xdata(j)*xdata(j))**2
            END DO
            chisqu=chisqu/npts

          ELSE
C           Guinier model
            siglgy=0.
            sigxsqu=0.
            sigxsqulgy=0.
            sigx4=0.

            DO j=start,chanend
C             Get sums
              temp1=LOG(ydata(j))
              temp2=xdata(j)**2
              siglgy=siglgy+temp1
              sigxsqu=sigxsqu+temp2
              sigxsqulgy=sigxsqulgy+temp1*temp2
              sigx4=sigx4+temp2*temp2
            END DO

C           Calculate parameters
            npts=(chanend-start+1)
            b=(sigxsqu*siglgy-npts*sigxsqulgy)/((sigxsqu**2)-npts*sigx4)
            alg=(siglgy-b*sigxsqu)/npts

C           Get chi squ.
            a=EXP(alg)
            chisqu=0.
            DO j=start,chanend
              chisqu=chisqu+(ydata(j)-a*EXP(b*xdata(j)*xdata(j)))**2
            END DO
            chisqu=chisqu/npts
          ENDIF

C         Debug:
C           write(6,*)start,chanend,a,b,chisqu

C         Now compare chi squareds.
          IF (chisqu .LT. oldchisqu) THEN
            oldchisqu=chisqu
            h1store=h1
            h2store=h2
            astore=EXP(alg)
            bstore=b
            bestend=chanend
          ENDIF

C       End of "chanend" optimisation loop.
        END DO

C       Check it's worked
        IF (bestend .EQ. 0) THEN
          CALL showprompt(prompt(6))
          STOP
        ENDIF

C       Restore params.
        a=astore
        b=bstore
        h1=h1store
        h2=h2store

C       Output results.
        IF (backex .EQ. 'VONK' .OR.
     +  backex .EQ. 'vonk') THEN
          IF (realflag .EQ. 1) THEN
            WRITE(6,1100)nframe,start,bestend,h1,h2
          ELSE
            WRITE(6,1110)start,bestend,h1,h2
          ENDIF
          param(nframe,4)=h1
          param(nframe,5)=h2
        ELSE
          IF (realflag .EQ. 1) THEN
            WRITE(6,1080)nframe,start,bestend,a,b
          ELSE
            WRITE(6,1090)start,bestend,a,b
          ENDIF
          param(nframe,4)=a
          param(nframe,5)=b
        ENDIF

C       Back extrapolate over.

C     End loop through frames
      END DO

C     Output radii of gyration.
      IF (backex .EQ. 'guinier' .OR. backex .EQ. 'GUINIER') THEN
C       check realtime
        IF (realtime(4) .EQ. 1) THEN
C         Single frame
          nframe=realtime(1)
          IF (param(nframe,5) .GT. 0.) THEN
            WRITE(6,1200)
          ELSE
            rad=SQRT(-3.*param(nframe,5))
            WRITE(6,1210)rad
          ENDIF

        ELSE
C         More than one frame
          WRITE(6,*)
          CALL showprompt(prompt(18))
          WRITE(6,*)
          DO nframe=realtime(1),realtime(2),realtime(3)
            IF (param(nframe,5) .GT. 0.) THEN
              WRITE(6,1180)nframe
              radgyr(nframe)=0.
            ELSE
              rad=SQRT(-3.*param(nframe,5))
              WRITE(6,1190)nframe,rad
              radgyr(nframe)=rad
            ENDIF
          END DO
        ENDIF
      ENDIF


C     Start Savitsky Golay Smoothing.
C     The subroutines savgol ludcmp and lubksb are from numerical
C     recipes and simply calculate a set of numbers indept of the data.
C     Hence, once debugging is over, the smoothing routine will not
C     call these subroutines, but use a permament set of values.
C
C     Of course, once preliminary debugging is over, the only way
C     of telling whether the smoothing has "worked" is to perform
C     the Fourier transform and inspect that.
C
C     Subroutines debugged using results provided by Numerical Recipes.
C
C     Present Sav-Gol setup: 4th order polynomial,
C     10 points either side of window.
C
C     Smoothing performed in LOG(intensity-background) world.
C     ALTERATION!!!
C     Smoothing performed in LOG(intensity) world.

C     Tell user we're smoothing
      CALL showprompt(prompt(9))

      norder=4
      nsize=10
C     norder and nsize control all aspects of smoothing.
C     Max nsize=30.
      nl=nsize
      nr=nsize
      np=61
      CALL savgol(coeff,np,nl,nr,0,norder)
C     Debug: textoutput of coefficients and check sum
C      sum=0.
C      DO i=1,11
C        WRITE(6,*)coeff(i)
C        sum=sum+coeff(i)
C      END DO
C      sum=2.*(sum-coeff(1))+coeff(1)
C      write(6,*)sum


C     Loop through frames
      DO nframe=realtime(1),realtime(2),realtime(3)

C       Set up join channel limits
        lim1=channel(nframe)
        join=lim1+nsize
        IF ((lim1 .LT. qzero+nsize+1) .OR.
     +  (lim1 .GT. ndata+3*nsize)) THEN
          CALL showprompt(prompt(7))
          STOP
        ENDIF

C       Load expt. intensities
        DO i=lim1-nsize,lim1+nsize-1
C         Add on backgr.
          smooth(i)=data(nframe,i)+param(nframe,1)
C         Check for -ve log
          IF (smooth(i) .GT. 0.) THEN
            smooth(i)=LOG(smooth(i))
          ELSE
C           Fatal error: we can't be having negative intensities can we?
C           S King, July 2004
C            CALL showprompt(prompt(22))
C            STOP
            call showprompt(prompt(27))
C SMK           smooth(i)=LOG(1.0E-08)
            if (i.eq.1) then
              smooth(i)=-18.4
            else
              smooth(i)=smooth(i-1)
            end if
          ENDIF
        END DO

C       Load calc. intensities.
        DO i=lim1+nsize,lim1+(3*nsize)-1
          x=xdata(i)
          smooth(i)=((param(nframe,2)/(x**4))*
     +    EXP(-(param(nframe,3)**2)*(x**2)))
          smooth(i)=LOG(smooth(i)+param(nframe,1))
        END DO

C       Now smooth according to coefficients in "coeff".
        DO i=lim1,lim1+(2*nsize)-1
          sum=0.
          DO j=-nl,nr,1
            IF (j .LE. 0) THEN
              wt=coeff(1-j)
            ELSE
              wt=coeff(np+1-j)
            ENDIF
            sum=sum+wt*smooth(i+j)
          END DO
          smoothed(nframe,i)=EXP(sum)-param(nframe,1)
        END DO

C       Debug: text output
        noutflag=0
        IF (noutflag .EQ. 1) THEN
          WRITE(6,1120)nframe
          status='Expt'
          DO i=lim1-nsize,lim1-1
            y=data(nframe,i)
            WRITE(6,1140)xdata(i),y,status
          END DO
          DO i=lim1,lim1+(2*nsize)-1
            IF (i .LT. join) THEN
              status='Expt'
            ELSE
              status='Calc'
            ENDIF
            y=data(nframe,i)
            WRITE(6,1130)xdata(i),y,
     +      smoothed(nframe,i),status
          END DO
          status='Calc'
          DO i=lim1+(2*nsize),lim1+(3*nsize)-1
            x=xdata(i)
            y=((param(nframe,2)/(x**4))*
     +      EXP(-(param(nframe,3)**2)*(x**2)))
            WRITE(6,1140)x,y,status
          END DO
        ENDIF

C       Update data
        DO i=lim1,lim1+(2*nsize)-1
          data(nframe,i)=smoothed(nframe,i)
        END DO

C     End loop through frames
      END DO



C     END NUMBER CRUNCH


C     Tell user it's over
      CALL showprompt(prompt(10))

C     Rebuild: output extrapolated data to otoko file.
      CALL showprompt(prompt(11))

C     First build an x axis.
      DO i=1,ndata-qzero+1
        xout(i)=xdata(qzero+i-1)
      END DO
      IF(xdata(ndata).GE. 10.0)THEN
          CALL showprompt(prompt(14))
          STOP
      ENDIF
      deltaq=( (10.0 - xdata(ndata)) / FLOAT(2048-ndata+qzero-1) )
      DO i=ndata-qzero+2,2048
        xout(i)=xout(i-1)+deltaq
      END DO

C     Not sure what the record length should be: try -
      nrecl=8192

C     Open x axis otoko header.
      call strippath(qaxname,xheader)
      CALL swapexten(xheader,'FLX')
C     Change header name to give data filename
      CALL changeotok(xheader,othername,nerr)
      IF (nerr .EQ. 1) THEN
        CALL showprompt(prompt(12))
        STOP
      ENDIF
      fname=xheader
      OPEN(UNIT=9,FILE=fname,STATUS='unknown',ERR=5030)
      WRITE(9,*,ERR=5030)
      WRITE(9,*,ERR=5030)
      notok(1)=2048
      notok(2)=1
      notok(3)=1
      CALL endian(notok(4))
      DO i=5,10
        notok(i)=0
      END DO
      WRITE(9,1150,ERR=5030)notok
      WRITE(9,1160,ERR=5030)othername(1:10)
      CLOSE(9)
C     X header done

C     Now do x data
C     Is RECL correct?
      fname=othername
      OPEN(UNIT=10,FILE=fname,STATUS='unknown',
     +ACCESS='direct',RECL=nrecl/lword,ERR=5030)
      WRITE(10,REC=1,ERR=5030)
     +(xout(i),i=1,2048)
      CLOSE(10)


C     Rebuild y data.
C     First open header.
      CALL strippath(filename,yheader)
      CALL swapexten(yheader,'FUL')
C     Change header name to give data filename
      CALL changeotok(yheader,othername,nerr)
      IF (nerr .EQ. 1) THEN
        CALL showprompt(prompt(12))
        STOP
      ENDIF
      fname=yheader
      yheader2=yheader(1:9)//'2'
      fname2=yheader2
      OPEN(UNIT=9,FILE=fname,STATUS='unknown',ERR=5030)
      OPEN(UNIT=11,FILE=fname2,STATUS='unknown',ERR=5030)
      WRITE(9,*,ERR=5030)
      WRITE(11,*,ERR=5030)
      WRITE(9,*,ERR=5030)
      WRITE(11,*,ERR=5030)
      notok(2)=realtime(4)
      notok(1)=2048
      notok(3)=1
      CALL endian(notok(4))
      DO i=5,10
        notok(i)=0
      END DO
      WRITE(9,1150,ERR=5030)notok
      WRITE(11,1150,ERR=5030)notok
      WRITE(9,1160,ERR=5030)othername(1:10)
      WRITE(11,1160,ERR=5030)othername(1:9)//'2'
      CLOSE(9)
      CLOSE(11)
C     Y header done

C     Calculate and output Y data.
      fname=othername
      fname2=fname(1:9)//'2'
      OPEN(UNIT=10,FILE=fname,STATUS='unknown',
     +ACCESS='direct',RECL=nrecl/lword,ERR=5030)
      OPEN(UNIT=11,FILE=fname2,STATUS='unknown',
     +ACCESS='direct',RECL=nrecl/lword,ERR=5030)
      nframe=0
      DO nfr=realtime(1),realtime(2),realtime(3)
        lim1=channel(nfr)
        nframe=nframe+1
C       Calculate y data depending on region.
        DO i=1,2048
          x=xout(i)
C         Regions -
          IF (i .LE. (datastart-qzero)) THEN

C           Build data using back extrapolate.
            IF (backex .EQ. 'VONK' .OR.
     +      backex .EQ. 'vonk') THEN
C             Vonk model
              y=param(nfr,4)-param(nfr,5)*x*x
            ELSE
C             Guinier model
              y=param(nfr,4)*EXP(param(nfr,5)*x*x)
            ENDIF

C           Debug test for F transform
C           y=0.

          ELSEIF (i .GT. lim1+20-qzero) THEN

C           Build data using sigmoid tail
            y=((param(nfr,2)/(x**4))*
     +      EXP(-(param(nfr,3)**2)*(x**2)))

          ELSE

C           Output expt. or smoothed data.
            y=data(nfr,i-1+qzero)

          ENDIF

C         Store:
          yout(i)=y
C         End rebuilding a frame
        END DO

C       Write to file
        WRITE(10,REC=nframe,ERR=5030)(yout(i),i=1,2048)
        WRITE(11,REC=nframe,ERR=5030)(yout(i)+param(nframe,1),i=1,2048)

C     End realtime loop.
      END DO
      CLOSE(10)
      CLOSE(11)

C     Otoko file output complete.

      WRITE(6,1260)yheader
      WRITE(6,1260)yheader2
      WRITE(6,1270)xheader

C     Change tailinfo.dat to include backextrap. params
C      OPEN(UNIT=9,FILE='tailinfo.dat',STATUS='unknown',ERR=5040)
C      DO nframe=realtime(1),realtime(2),realtime(3)
C        WRITE(9,1170,ERR=5040)param(nframe,1),param(nframe,2),
C     +  param(nframe,3),param(nframe,4),param(nframe,5)
C      END DO
C      CLOSE(9)

C     Also pass info to limitinfo.dat
C      OPEN(UNIT=9,FILE='limitinfo.dat',STATUS='unknown',ERR=5070)
C      DO nframe=realtime(1),realtime(2),realtime(3)
C        WRITE(9,1240,ERR=5070)limit1(nframe),limit2(nframe),
C     +  channel(nframe)
C      END DO
C      CLOSE(9)

C       Realtime output.
C       If guinier model create an otoko file containing radii of gyration.

      IF(realtime(4).NE.1) THEN
        IF (backex .EQ. 'guinier' .OR. backex .EQ. 'GUINIER') THEN
C         Get filename.
          CALL strippath(filename,radname)
          radax=radname
          CALL swapexten(radname,'RAD')
          CALL swapexten(radax,'FAX')
C         x-axis should already exist

C         Create otoko header
C         Change header name to give data filename
          CALL changeotok(radname,othername,nerr)
          IF (nerr .EQ. 1) THEN
            CALL showprompt(prompt(19))
          STOP
          ENDIF
          fname=radname
          OPEN(UNIT=9,FILE=fname,STATUS='unknown',ERR=5050)
          WRITE(9,*,ERR=5050)
          WRITE(9,*,ERR=5050)
          notok(1)=realtime(4)
          notok(2)=1
          notok(3)=1
          CALL endian(notok(4))
          DO i=5,10
            notok(i)=0
          END DO
          WRITE(9,1030,ERR=5050)notok
          WRITE(9,1220,ERR=5050)othername(1:10)
          CLOSE(9)
C         Header done

          nrecl=4*realtime(4)
          outname=othername
          OPEN(UNIT=10,FILE=outname,STATUS='unknown',
     +    ACCESS='direct',RECL=nrecl/lword,ERR=5050)
          WRITE(10,REC=1,ERR=5050)
     +    (radgyr(i),i=realtime(1),realtime(2),realtime(3))
          CLOSE(10)

          write(6,1280)fname

C         Output the radius of gyration data in ASCII format
          CALL writeascii(fname(1:3)//"RAD."//"TXT",notok,radgyr,
     +                  irc,1)
          IF(irc.EQ.0)THEN
            CALL showprompt(prompt(28))
          ELSE
            WRITE(6,1285)fname(1:3)//"RAD."//"TXT"
          ENDIF

        ENDIF
      ENDIF


C	S King, July 2004
C     Output in ASCII format
      open(12,file=fname(1:3)//'FLX.TXT',form='formatted',
     &status='unknown',err=5060)
        write(12,'(f12.5)',ERR=5060)(xout(i),i=1,2048)
      close(12)
      write(6,1300)fname(1:3)//'FLX.TXT'

      open(12,file=fname(1:3)//'FUL.TXT',form='formatted',
     &status='unknown',err=5060)
        write(12,'(e12.5)',ERR=5060)(yout(i),i=1,2048)
      close(12)
      write(6,1310)fname(1:3)//'FUL.TXT'

      open(12,file=fname(1:3)//'FU2.TXT',form='formatted',
     &status='unknown',err=5060)
        write(12,'(e12.5)',ERR=5060)(yout(i)+param(nframe,1),i=1,2048)
      close(12)
      write(6,1310)fname(1:3)//'FU2.TXT'

C     End program.
      CALL showprompt(prompt(24))
      RETURN
      STOP


C     Error messages

C     Static data.
5010  realflag=0
      realtime(1)=1
      realtime(2)=1
      realtime(3)=1
      realtime(4)=1

C     Error reading otoko intensity or q data.
5020  CALL showprompt(prompt(2))
      STOP

C     Error writing otoko format rebuild files.
5030  CALL showprompt(prompt(13))
      STOP

C     Error writing radius of gyration output
5050  CALL showprompt(prompt(20))
      STOP

C     Error writing ASCII intensity or q data.
5060  CALL showprompt(prompt(26))

      RETURN
      END



      SUBROUTINE savgol(c,np,nl,nr,ld,m)
C     Savitsky Golay smoothing.
C     Taken from Numerical Recipes, Flannery and Press.
C     Calculates coefficients for linear smoothing,
C     such that higher moments are preserved.
C     Re. correlation function analysis, smoothing used
C     to ease the join between calc. and expt. data.
      INTEGER ld,m,nl,np,nr,mmax
      REAL c(np)
      PARAMETER (mmax=6)
      INTEGER imj,ipj,j,k,kk,mm,indx(mmax+1)
      REAL d,fac,sum,a(mmax+1,mmax+1),b(mmax+1)


      IF (np.LT.nl+nr+1.OR.nl.LT.0.OR.nr.LT.0.OR.ld.GT.m.OR.m.GT.mmax
     +.OR.nl+nr.LT.m) PAUSE 'Bad arguments passed to subroutine savgol'

      DO ipj=0,2*m
        sum=0.
        IF (ipj .EQ. 0) sum=1.

        DO k=1,nr
          sum=sum+FLOAT(k)**ipj
        END DO

        DO k=1,nl
          sum=sum+FLOAT(-k)**ipj
        END DO

        mm=MIN(ipj,2*m-ipj)
        DO imj=-mm,mm,2
          a(1+(ipj+imj)/2,1+(ipj-imj)/2)=sum
        END DO
      END DO

      CALL ludcmp(a,m+1,mmax+1,indx,d)

      DO j=1,m+1
        b(j)=0.
      END DO
      b(ld+1)=1

      CALL lubksb(a,m+1,mmax+1,indx,b)

      DO kk=1,np
        c(kk)=0.
      END DO

      DO k=-nl,nr
        sum=b(1)
        fac=1.
        DO mm=1,m
          fac=fac*k
          sum=sum+b(mm+1)*fac
        END DO
        kk=MOD(np-k,np)+1
        c(kk)=sum
      END DO

      RETURN
      END



      SUBROUTINE ludcmp(a,n,np,indx,d)
C     LU decomposition.
C     Taken from Numerical Recipes, Flannery and Press.
C     Used by subroutine savgol.
      INTEGER n,np,indx(n),nmax
      REAL d,a(np,np),tiny
      PARAMETER (nmax=500,tiny=1.E-8)
      INTEGER i,imax,j,k
      REAL aamax,dum,sum,vv(nmax)

      d=1.
      DO i=1,n
        aamax=0.
        DO j=1,n
          IF (ABS(a(i,j)) .GT. aamax) aamax=ABS(a(i,j))
        END DO
        IF (aamax .EQ. 0.) PAUSE 'Singular matrix in subroutine ludcmp'
        vv(i)=1./aamax
      END DO

      DO j=1,n
        DO i=1,j-1
          sum=a(i,j)
          DO k=1,i-1
            sum=sum-a(i,k)*a(k,j)
          END DO
          a(i,j)=sum
        END DO
        aamax=0.
        DO i=j,n
          sum=a(i,j)
          DO k=1,j-1
            sum=sum-a(i,k)*a(k,j)
          END DO
          a(i,j)=sum
          dum=vv(i)*ABS(sum)
          IF (dum .GE. aamax) THEN
            imax=i
            aamax=dum
          ENDIF
        END DO
        IF (j .NE. imax) THEN
          DO k=1,n
            dum=a(imax,k)
            a(imax,k)=a(j,k)
            a(j,k)=dum
          END DO
          d=-d
          vv(imax)=vv(j)
        ENDIF
        indx(j)=imax
        IF (a(j,j) .EQ. 0.) a(j,j)=tiny
        IF (j .NE. n) THEN
          dum=1./a(j,j)
          DO i=j+1,n
            a(i,j)=a(i,j)*dum
          END DO
        ENDIF
      END DO

      RETURN
      END



      SUBROUTINE lubksb(a,n,np,indx,b)
C     Subroutine associated with LU decomposition.
C     Taken from "Numerical Recipes" Flannery and Press.
C     Used in Savitsky Golay smoothing.
      INTEGER n,np,indx(n)
      REAL a(np,np),b(n)
      INTEGER i,ii,j,ll
      REAL sum
      ii=0
      DO i=1,n
        ll=indx(i)
        sum=b(ll)
        b(ll)=b(i)
        IF (ii .NE. 0) THEN
          DO j=ii,i-1
            sum=sum-a(i,j)*b(j)
          END DO
        ELSEIF (sum .NE. 0.) THEN
          ii=i
        ENDIF
        b(i)=sum
      END DO
      DO i=n,1,-1
        sum=b(i)
        DO j=i+1,n
          sum=sum-a(i,j)*b(j)
        END DO
        b(i)=sum/a(i,i)
      END DO

      RETURN
      END
