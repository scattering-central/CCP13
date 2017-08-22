      SUBROUTINE tailfit(filename,qaxname,sigmodel,limit1,limit2,
     &                   realtime,ndata,numiteration,
     &                   results,best,bestchannel,param,static)
C     TMWN July 94
C     Performs tailfit
C
C     Background is Bonart, and tail sigmoidal.
C     See Koberstein and Stein, J.polymer.sci,phys.ed.,vol21,pp.2181
C
C     Non-linear fitting via Levenburg Marquart algorithm.
C     See Numerical Recipes by Flannery and Press, pp.679
C
C     Updated to handle realtime data.
C
C     30/7/94 Update.
C     Now choice of either sigmoid model or simple Porod.
C
C     5/8/94 Update
C     Singular matrix handling.
C
C     9/8/94 Update
C     Variable channel limits for tailfit.
C
C     Nov 05 Update
C     Redimensioned data arrays from 512 to MaxDim.
C	Added ASCII output of multi-frame data & array asciiresults

      CHARACTER*80 filename,qaxname,othername,dirname
      CHARACTER*40 title,retrans,ascii,sigmodel,user,idftoggle
      CHARACTER*80 prompt(23),fname,axisname,fname2,arbabs,graphics
      CHARACTER*80 outname,grlong(4),backex*40,stat,grname(4)
      CHARACTER*1 letter
      INTEGER lim1,lim2,qzero,lower,upper,ij,i,npoints,ncof
      INTEGER plotflag,lorentzflag,lowerlim,upperlim
      INTEGER bestchannel,realtime(4),realflag
      INTEGER MaxDim
      PARAMETER (MaxDim=4096)
      INTEGER best(MaxDim),datastart,lword
      CHARACTER*40 graphdir,graphname,graphqax,graphtitle
      CHARACTER*40 xlabel,ylabel
      DIMENSION notok(10),xdata(MaxDim),ydata(MaxDim)
      REAL xtemp(MaxDim),ytemp(MaxDim),stdev(MaxDim),temp
      DIMENSION deltaparam(3)
      DIMENSION beta(3)
      REAL covar(3,3),alpha(3,3),param(3),newparam(3)
      DOUBLE PRECISION dcovar(3,3),dalpha(3,3),dparam(3)
      DIMENSION data(MaxDim,MaxDim),results(MaxDim,5)
	DIMENSION asciiresults(MaxDim)
      DIMENSION limit1(MaxDim),limit2(MaxDim)
      REAL asciidata(MaxDim*MaxDim)
      REAL gradient,intercept,lamda,oldchisqu,kp
      REAL chitst,estd,chisqu
      INTEGER lista(3),OPTION
      LOGICAL static,good
      CHARACTER*10 filetype

      EXTERNAL sigmoid

C     Array "param"
C     Parameter 1: Bonart background
C     Parameter 2: K (interface per unit volume)
C     Parameter 3: sigma (diffuse boundary thickness

C     Array "data"
C     Stores intensities. data(frame no.,channel).
C     Added during realtime update.

C     "sigmodel" controls which model is applied.
C     If sigmodel='off' a straight forward Porod plot is done.

1000  FORMAT(A1)
1010  FORMAT(A80)
1020  FORMAT(2x,I3)
1030  FORMAT(10I8)
1040  FORMAT(A40)
1050  FORMAT(/,1x,'100: Initial guess at background: IQ^4 ',
     +'vs. Q^4 ',E12.6,'.',/,
     +1x,'100: Simple measurement ',E12.6,'.')
1060  FORMAT(/,1x,'100: Initial guess at sigmoid parameters:',
     +/,1x,'100: K ',E12.6,'.',/,1x,'100: Sigma ',E12.6,'.')
1070  FORMAT(10I8)
1080  FORMAT(A10)
1090  FORMAT(/,1x,'100: Parameter            Value',/,
     +     '----------------------------',/)
1100  FORMAT(1x,'100: ',A10,11x,E12.6,3x,E12.6)
1110  FORMAT(/,1x,'100: Chi squared          ',E12.6)
1120  FORMAT(/,1x,'Optimum channel for tail start = ',I3)
1130  FORMAT(E12.6)
1140  FORMAT(2x,I3,2x,I3,2x,I3,2x,I3)
1150  FORMAT(/,1x,'100: Frame  Stage    Background    ',
     +'K Porod       Sigma         Chisq ',
     +'        Std. Error    Reduced Chisq',/,
     +'----------------------------------------',
     +'----------------------------------------')
1160  FORMAT(1x,'100: ',I3,4x,A7,2x,E12.6,2x,E12.6,2x,E12.6,
     +2x,E12.6,2x,E12.6,2x,E12.6)
1170  FORMAT(1x,'100: ',I3,4x,A7,2x,E12.6,2x,E12.6,2x,E12.6)
1180  FORMAT(E12.6,2x,E12.6,2x,E12.6,2x,I3)
1190  FORMAT(/,1x,'WARNING: Fitting problem: Singular alpha matrix',/)
1200  FORMAT(2x,I3,2x,I3)
1210  FORMAT(1x,"100: Written thermal background v frame: ",A10)
1215  FORMAT(1x,"100: Written ASCII thermal background v frame: ",A10)
1220  FORMAT(1x,"100: Written Porod constant v frame: ",A10)
1225  FORMAT(1x,"100: Written ASCII Porod constant v frame: ",A10)
1230  FORMAT(1x,"100: Written sigma v frame: ",A10)
1235  FORMAT(1x,"100: Written ASCII sigma v frame: ",A10)
1240  FORMAT(1x,"100: Written x-axis: ",A10)
1241  FORMAT(1x,"100: Written ASCII x-axis: ",A10)
1245  FORMAT(1x,"100: Covergence achieved after ",I3," iterations")
1247  FORMAT(1x,"100: Standard error       ",E12.6)

      prompt(1)='ERROR: Error reading transfer parameter file: FATAL'
      prompt(2)='ERROR: Error reading data file: FATAL'
      prompt(3)='ERROR: Expecting static Q axis,'
     +//' received dynamic: FATAL'
      prompt(4)='All necessary files correctly loaded...'
      prompt(5)='ERROR: Error writing output otoko files: FATAL'
      prompt(6)='WARNING: Positive gradient during '
     +//'estimate of sigma...'
      prompt(7)='ERROR: Software error with subroutine'
     +//' changeotok: FATAL'
      prompt(8)='100: Using IQ^4 vs. Q^4 least squares background...'
      prompt(9)='WARNING: Ran out of iterations before convergence...'
      prompt(10)='NON-LINEAR FITTING OVER!'
      prompt(11)='100: Final parameter values:'
      prompt(12)='Updating parameter files...'
      prompt(13)='ERROR: Error writing file tailinfo.txt: FATAL'
      prompt(14)='Creating files for graphics output...'
      prompt(15)='100: Applying sigmoid tail model...'
      prompt(16)='100: Applying Porod tail model...'
      prompt(17)='ERROR: Error with status file: FATAL'
      prompt(18)='ERROR: Error reading limitinfo.txt: FATAL'
      prompt(19)='Started tailfitting'
      prompt(20)='Finished tailfitting'
      prompt(21)='100: TAIL-FITTING...'
      prompt(22)='100:'
C	Added by SMK, Nov 05
      prompt(23)='WARNING: Error writing ascii output'

      CALL WRDLEN(LWORD)
      limopt=0
      realflag=1
      if(static)then
        realflag=0
        realtime(1)=1
        realtime(2)=1
        realtime(3)=1
        realtime(4)=1
      endif

      WRITE(6,*)
      WRITE(6,*)
C      title='TAIL-FITTING'
C      CALL showtitle(title)
      CALL showprompt(prompt(22))
      CALL showprompt(prompt(21))

      fname=filename
      axisname=qaxname
      CALL getpath(fname,dirname)

c     Read the data
      CALL getfiletype(filetype,fname)
      IF(filetype.EQ."ascii")THEN
          CALL readascii(fname,notok,asciidata,irc)
          IF(irc.EQ.0)THEN
              GOTO 5010
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
          OPEN(UNIT=9,FILE=fname,STATUS='old',ERR=5010)
          READ(9,1000,ERR=5010)letter
          READ(9,1000,ERR=5010)letter
          READ(9,1030,ERR=5010)notok
          READ(9,1040,ERR=5010)othername
          CLOSE(9)

          nndata=4*ndata

C         READ intensities
          CALL addstrings(dirname,othername,fname2)
          OPEN(UNIT=9,FILE=fname2,STATUS='old',
     +    ACCESS='direct',RECL=nndata/lword,ERR=5010)
          DO nframe=realtime(1),realtime(2),realtime(3)
            READ(9,REC=nframe,ERR=5010)(data(nframe,i),i=1,ndata)
          END DO
          CLOSE(9)
      ENDIF

      IF(filetype.NE."ascii")THEN
C SMK   CALL swap(data,notok(4),512*512,4)
        CALL swap(data,notok(4),MaxDim*MaxDim,4)
      ENDIF

      nframe=1

C     Open Q axis
      CALL getfiletype(filetype,axisname)
      IF(filetype.EQ."ascii")THEN
          CALL readascii(axisname,notok,asciidata,irc)
          IF(irc.EQ.0)THEN
              GOTO 5010
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
          OPEN(UNIT=9,FILE=axisname,STATUS='old',ERR=5010)
          READ(9,1000,ERR=5010)letter
          READ(9,1000,ERR=5010)letter
          READ(9,1030,ERR=5010)notok
          READ(9,1040,ERR=5010)othername
          CLOSE(9)

C         Check static
          IF (notok(2) .NE. 1) THEN
            CALL showprompt(prompt(3))
            STOP
          ENDIF

C         Read x axis data
          CALL addstrings(dirname,othername,fname2)
          OPEN(UNIT=9,FILE=fname2,STATUS='old',
     +    ACCESS='direct',RECL=nndata/lword,ERR=5010)
          READ(9,REC=nframe,ERR=5010)(xdata(i),i=1,ndata)
2020      CLOSE(9)
      ENDIF

      IF(filetype.NE."ascii")THEN
C SMK   CALL swap(xdata,notok(4),512,4)
        CALL swap(xdata,notok(4),MaxDim,4)
      ENDIF

C     Ok - data fine
      CALL showprompt(prompt(4))


C     START NUMBER CRUNCHING
C     ~~~~~~~~~~~~~~~~~~~~~

      IF (sigmodel .EQ. 'off' .OR. sigmodel .EQ. 'OFF') THEN
        CALL showprompt(prompt(16))
      ELSE
        CALL showprompt(prompt(15))
      ENDIF

C     Titles for text output
      IF (realflag .EQ. 1 .AND. realtime(4) .NE. 1) THEN
        WRITE(6,1150)
      ENDIF

C     Realtime update: loop through original static routine.
      DO nframe=realtime(1),realtime(2),realtime(3)

C     Load up data
      DO i=1,MaxDim
        ydata(i)=data(nframe,i)
      END DO

C     Set limits
      lim1=limit1(nframe)
      lim2=limit2(nframe)


C     Which model?
      IF (sigmodel .EQ. 'off' .OR. sigmodel .EQ. 'OFF') THEN

C       POROD MODEL!
C       Do an LSQ fit in I vs. 1/Q^4 world, with channel optimisation.
        DO i=1,3
          param(i)=0.
        END DO
        oldchisqu=1.E+20

C       optimise channel
        bestchannel=lim1-limopt
        DO newlim1=lim1-limopt,lim1+limopt

C         Load up data.
          npts=lim2-newlim1+1
          DO i=1,npts
            xtemp(i)=(1./(xdata(newlim1+i-1))**4)
            ytemp(i)=ydata(newlim1+i-1)
          END DO
C         LSQ fit
          CALL lsqfit(xtemp,ytemp,npts,intercept,gradient)

C         Get chisqu
          chisqu=0.
          DO i=newlim1,lim2
            xp4=xdata(i)**4
            chisqu=chisqu+(ydata(i)-intercept-(gradient/xp4))**2
          END DO
          chisqu=chisqu/npts

C         Improved?
          IF (chisqu .LT. oldchisqu) THEN
            oldchisqu=chisqu
            param(1)=intercept
            param(2)=gradient
            param(3)=0.
            bestchannel=newlim1
          ENDIF

C         Debug:
C          write(6,*)bestchannel,chisqu

C       End channel optimisation
        END DO

C       Output results.
        IF (realflag .EQ. 0 .OR. realtime(4) .EQ. 1) THEN
C         single frame
          WRITE(6,*)
          CALL showprompt(prompt(11))

          WRITE(6,1090)
          WRITE(6,1100)'Background',param(1)
          WRITE(6,1100)'K',param(2)
          WRITE(6,1110)chisqu
          WRITE(6,1120)bestchannel
          best(nframe)=bestchannel

        ELSE
C         More than one frame.
          best(nframe)=bestchannel
          DO i=1,3
            results(nframe,i)=param(i)
          END DO
          results(nframe,4)=chisqu
          WRITE(6,1160)nframe,'Final',param(1),param(2),
     +    param(3),chisqu

        ENDIF

      ELSE

C       SIGMOID MODEL!

C       Get initial guess for parameters
C       First: plot IQ^4 vs Q^4 and measure slope as guess for backgr.
C       This might not work very well: if not, change to a direct
C       measurement of intensity at high Q.
        npts=lim2-lim1+1
        DO i=1,npts
          xtemp(i)=(xdata(lim1+i-1))**4
          ytemp(i)=ydata(lim1+i-1)*xtemp(i)
        END DO
        CALL lsqfit(xtemp,ytemp,npts,intercept,gradient)
        guess1=gradient

C       Or use a simple measurement:
        guess2=0.
        DO i=lim2-15,lim2
          guess2=guess2+ydata(i)
        END DO
        guess2=guess2/16.0

C       More may be added here re. two methods of finding backgr.
        param(1)=guess1

C       Next guess at sigma and Kp.
C       Plot ln{[Iobs-Ib]q^4} vs q^2
C       Slope=-sigma**2, intercept=ln Kp
        nptstemp=0
        DO i=1,npts
          temp1=(ydata(i+lim1-1)-param(1))
          IF (temp1 .GT. 0.) THEN
            nptstemp=nptstemp+1
            temp2=xdata(i+lim1-1)**2
            xtemp(nptstemp)=temp2
            ytemp(nptstemp)=LOG(temp1*temp2*temp2)
C            debug:
C            write(6,*)(i+lim1-1),xtemp(nptstemp),ytemp(nptstemp)
          ENDIF
        END DO

        CALL lsqfit(xtemp,ytemp,nptstemp,intercept,gradient)

        param(2)=EXP(intercept)
        IF (gradient .GT. 0.) THEN
C         param(3)=0.   ???
C         Not really sure what to do: but a start of 0.0 always
C         leads to end of 0.0 so use:-
          param(3)=SQRT(ABS(gradient))
        ELSE
          param(3)=SQRT(-gradient)
        ENDIF

C       Debug
C        param(1)=0.2
C        param(2)=0.5E-3
C        param(3)=2.0


C       DEBUG
C       ~~~~~
C       Loop through values of sigma from 0 to 10.
C       For each value do an LSQ to determine backgr. and Porod.
C       Then calculate a chi squared for comparison with
C       final result.
C       Ignores channel optimisation for simplicity.
        ndebug=0
        IF (ndebug .EQ. 1) THEN
          WRITE(6,*)
          num=lim2-lim1+1
          DO k=0,10
            sig=FLOAT(k)
            sigsqu=sig*sig
            sum1=0.
            sum2=0.
            sum3=0.
            sum4=0.
            DO i=lim1,lim2
              x=xdata(i)
              y=ydata(i)
              temp=(EXP(-x*x*sigsqu))/(x**4)
              sum1=sum1+y
              sum2=sum2+temp
              sum3=sum3+y*temp
              sum4=sum4+temp*temp
            END DO
C           Evaluate B and Kp
            kp=(sum1*sum2-num*sum3)/(sum2*sum2-num*sum4)
            b=(sum1-kp*sum2)/num
C           Get chisqu
            chisqu=0.
            DO i=lim1,lim2
              x=xdata(i)
              y=ydata(i)
              chisqu=chisqu+(y-b-(kp/(x**4))*(EXP(-sigsqu*x*x)))**2
            END DO
            chisqu=chisqu/num
C           Output
7000        FORMAT(1x,'100: Sigma=',E12.6,'. K=',E12.6,
     +      '. B=',E12.6,'. Chisqu=',E12.6,'.')
            WRITE(6,7000)sig,kp,b,chisqu
          END DO
        ENDIF

C       END DEBUG
C       ~~~~~~~~~



C       Text output for single frame
        IF (realflag .EQ. 0 .OR. realtime(4) .EQ. 1) THEN
          WRITE(6,1050)guess1,guess2
          CALL showprompt(prompt(8))
          IF (gradient .GT. 0.) THEN
            CALL showprompt(prompt(6))
          ENDIF
          WRITE(6,1060)param(2),param(3)

        ELSE
C         text output for more than one frame
          WRITE(6,*)
          WRITE(6,1170)nframe,'Initial',param(1),param(2),param(3)

        ENDIF

      OPTION=2

      IF(OPTION.EQ.1)THEN

C       START LEVENBURG MARQUART FIT
C       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

C       This is the equivalent of the Numerical Recipes subroutine
C       mrqmin, together with an external program.

C       Optimise position of tail start: search through all
C       possible starting points according to the user supplied
C       variable limopt.
        bestchannel=lim1
        DO newlim1=lim1-limopt,lim1+limopt

C         Initialise
C         Debug: may need changing
          lamda=0.001
C         The larger lamda is, the smaller the fitting steps.
C         This initial value may need changing later on.
          iteration=0

C         Do contents of mrqmin when lamda=-ve
C         Fill matrix alpha and vector beta; get chisqu for
C         initial parameter set.
          CALL mrqcof2(xdata,ydata,newlim1,lim2,param,
     +    alpha,beta,oldchisqu)


C         Start one iteration
2030      iteration=iteration+1

C         Show location.
C         Debug: replace display of information eventually.
C          CALL showpos(newlim1,iteration,param,alpha,
C     +    beta,lamda,oldchisqu)

C         Augment diagonal of linearized fitting matrix
          DO j=1,3
            DO k=1,3
              covar(j,k)=alpha(j,k)
            END DO
            covar(j,j)=alpha(j,j)*(1.+lamda)
C           Copy beta into array deltaparam for gaussj
            deltaparam(j)=beta(j)
          END DO

C         solve linear equns.
          CALL gaussj(covar,deltaparam,nerr)
          IF (nerr .EQ. 1) THEN
C           Singular matrix occurred!
C           Default to porod profile
C           Load up data.
            npts=lim2-newlim1+1
            DO i=1,npts
              xtemp(i)=(1./(xdata(newlim1+i-1))**4)
              ytemp(i)=ydata(newlim1+i-1)
            END DO
C           LSQ fit
            CALL lsqfit(xtemp,ytemp,npts,intercept,gradient)
            param(1)=intercept
            param(2)=gradient
            param(3)=0.
C           Ouput message and exit loop
            WRITE(6,1190)
            bestchannel=lim1
            GOTO 2050
          ENDIF

C         Increment params
          DO j=1,3
            newparam(j)=param(j)+deltaparam(j)
          END DO

C         Redo chisqu calculation.
C         Uncertainty: call mrqcov with covar or alpha?
C         I think covar is correct.
          CALL mrqcof2(xdata,ydata,newlim1,lim2,newparam,
     +    covar,deltaparam,chisqu)

C         Test the new solution
          IF (newparam(1) .LT. 0. .OR.
     +        newparam(2) .LT. 0. .OR.
     +        newparam(3) .LT. 0.) THEN
            chisqu=1.E+20
          ENDIF

          IF (chisqu .LT. oldchisqu) THEN
C           Reduce lamda for decreased sensitivity
C           Debug added:
C           cap lamda from getting too small.
            IF (lamda .GT. 0.001) THEN
              lamda=lamda*0.1
            ENDIF
            oldchisqu=chisqu
C           record which channel is best
            bestchannel=newlim1

C           update alpha, beta, and parameters
            DO j=1,3
              DO k=1,3
                alpha(j,k)=covar(j,k)
              END DO
              beta(j)=deltaparam(j)
              param(j)=newparam(j)
            END DO

          ELSE

C           chisqu has increased
            chisqu=oldchisqu
C           Increase lamda for increased sensitivity
            lamda=10.*lamda

          ENDIF

C         Now test for convergance or too many iterations
          IF (iteration .EQ. numiteration) THEN
            CALL showprompt(prompt(9))
            WRITE(6,*)
          ENDIF

C         lamda=1.E+8 is an arbitrary measure of convergence.
C         May need changing.
          IF ((iteration .LT. numiteration) .AND.
     +    (lamda .LT. 1.0E+8)) THEN
             GOTO 2030
          ENDIF

C         Then onto next channel for optimisation
        END DO


C       END LEVENBURG MARQUART FIT
C       ~~~~~~~~~~~~~~~~~~~~~~~~~~

 2050 chisqu=oldchisqu

        ELSE

C Set parameters to refined parameters from last fit
        dparam(1)=param(1)
        dparam(2)=param(2)
        dparam(3)=param(3)

C ***********************************************************************************
C Implement a different Levenburg-Marquart fitting routine of R. Denny: M.W. Shotton
C ***********************************************************************************

C On first call set lamda<0 (which then sets lamda=0.001: see subroutine mrqmin)
      lamda = -1.0
C Number of coefficients (param) for sigmoid is 3
      ncof=3
C Set target chi
      chitst=0.1
C Set up lista that flags values to be adjusted
      lista(1)=1
      lista(2)=2
      lista(3)=3

C Set up data arrays xtemp and ytemp containing points between lim1 and lim2

      i=1
      DO 2040 ij=lim1,lim2
          xtemp(i)=xdata(ij)
          ytemp(i)=ydata(ij)
          stdev(i)=1.0
          i=i+1
 2040 CONTINUE
      npoints=i-1

      good=.FALSE.

C Loop over maximum number of iterations and do fitting
      DO 2045 ij=1,numiteration

      CALL mrqmin(xtemp,ytemp,stdev,npoints,dparam,ncof,lista,ncof,
     +            dcovar,dalpha,ncof,chisqu,sigmoid,lamda)

C Convergence Test
      IF(ij.GT.1)THEN
        IF(lamda.LT.0.0)THEN
          good=.TRUE.
          temp = (oldchisqu-chisqu)*FLOAT(lim2-lim1)/chisqu
C          chisqu = oldchisqu
          lamda=-lamda
          IF(ABS(temp).lt.chitst)THEN
            WRITE(6,1245)ij
            GOTO 2046
          ENDIF
        ENDIF
      ENDIF

      oldchisqu = chisqu

 2045 CONTINUE

C Not reached convergence
      CALL showprompt(prompt(9))

 2046 CONTINUE

C Calculate standard error
      IF(npoints.GT.ncof)THEN
        estd = SQRT(chisqu/FLOAT(npoints-ncof))
      ELSE
        estd=0.0
      ENDIF

      bestchannel=lim1

      param(1)=dparam(1)
      param(2)=dparam(2)
      param(3)=dparam(3)
      if(param(3).lt.0)then
        param(3)=-param(3)
      endif

C ***********************************************************************************
C End of Levenburg-Marquart fitting
C ***********************************************************************************

      ENDIF

C       Output results to screen.
        IF (realflag .EQ. 0 .OR. realtime(4) .EQ. 1) THEN
C         single frame
          WRITE(6,*)
          CALL showprompt(prompt(10))
          CALL showprompt(prompt(11))

          WRITE(6,1090)
          WRITE(6,1100)'Background',param(1)
          WRITE(6,1100)'K',param(2)
          WRITE(6,1100)'Sigma',param(3)
          WRITE(6,1110)chisqu
          WRITE(6,1247)estd
          if(good)then
            WRITE(6,2047)temp
          endif
          WRITE(6,1120)bestchannel
 2047 format(" 100: Reduced Chi squared  ",E12.6)

        ELSE
C         More than one frame.
          best(nframe)=bestchannel
          DO i=1,3
            results(nframe,i)=param(i)
          END DO
          results(nframe,4)=chisqu
          WRITE(6,1160)nframe,'Final',param(1),param(2),
     +    param(3),chisqu,estd,temp

        ENDIF

C     End choice of models
      ENDIF

C     End loop through frames
      END DO


C     END NUMBER CRUNCHING
C     ~~~~~~~~~~~~~~~~~~~~

      IF (realflag .NE. 0 .OR. realtime(4) .NE. 1) THEN
C       Create graphs of backgr. vs. frame, K vs. frame,
C       and sigma vs. frame

C       Get filenames.
        DO i=1,4
          CALL strippath(filename,grname(i))
        END DO
        CALL swapexten(grname(1),'BAK')
        CALL swapexten(grname(2),'POR')
        CALL swapexten(grname(3),'SIG')
        CALL swapexten(grname(4),'FAX')


C       Create otoko header - xdata
C       Change header name to give data filename
        CALL changeotok(grname(4),othername,nerr)
        IF (nerr .EQ. 1) THEN
          CALL showprompt(prompt(7))
        STOP
        ENDIF
        grlong(4)=grname(4)
        OPEN(UNIT=9,FILE=grlong(4),STATUS='unknown',ERR=5020)
        WRITE(9,*,ERR=5020)
        WRITE(9,*,ERR=5020)
        notok(1)=realtime(4)
        notok(2)=1
        notok(3)=1
        CALL endian(notok(4))
        DO i=5,10
          notok(i)=0
        END DO
        WRITE(9,1070,ERR=5020)notok
        WRITE(9,1080,ERR=5020)othername(1:10)
        CLOSE(9)
C       Header done

C       Now do x data
C       Is RECL correct? For 512 .XAX it was 2048
        nrecl=2048
        outname=othername
        OPEN(UNIT=10,FILE=outname,STATUS='unknown',
     +  ACCESS='direct',RECL=nrecl/lword,ERR=5020)
        WRITE(10,REC=1,ERR=5020)
     +  (FLOAT(i),i=realtime(1),realtime(2),realtime(3))
        CLOSE(10)

        write(6,1240)grlong(4)

C       create otoko header files - ydata
        IF (sigmodel .EQ. 'off' .OR. sigmodel .EQ. 'OFF') THEN
          nend=2
        ELSE
          nend=3
        ENDIF
        DO n=1,nend
C         n=1 ~ backgr
C         n=2 ~ Kporod
C         n=3 ~ sigma

C         Change header name to give data filename
          CALL changeotok(grname(n),othername,nerr)
          IF (nerr .EQ. 1) THEN
            CALL showprompt(prompt(7))
            STOP
          ENDIF
          grlong(n)=grname(n)
          OPEN(UNIT=9,FILE=grlong(n),STATUS='unknown',ERR=5020)
          WRITE(9,*,ERR=5020)
          WRITE(9,*,ERR=5020)
          WRITE(9,1070,ERR=5020)notok
          WRITE(9,1080,ERR=5020)othername(1:10)
          CLOSE(9)
C         Header done

C         Now do y data
          outname=othername
          OPEN(UNIT=10,FILE=outname,STATUS='unknown',
     +    ACCESS='direct',RECL=nrecl/lword,ERR=5020)
          WRITE(10,REC=1,ERR=5020)
     +    (results(i,n),i=realtime(1),realtime(2),realtime(3))
          CLOSE(10)

          if(n.eq.1)then
            write(6,1210)grlong(n)
          else if(n.eq.2) then
            write(6,1220)grlong(n)
          else if(n.eq.3)then
            write(6,1230)grlong(n)
          endif
        END DO

      ENDIF

      IF (realflag .NE. 0 .OR. realtime(4) .NE. 1) THEN

C       Output the thermal background data in ASCII format
	  do i=realtime(1),realtime(2),realtime(3)	  
           asciiresults(i)=results(i,1)
        end do
        CALL writeascii(grname(1)(1:3)//"BAK."//"TXT",notok,asciiresults,
     +                  irc,1)
        IF(irc.EQ.0)THEN
          CALL showprompt(prompt(23))
        ELSE
          WRITE(6,1215)grname(1)(1:3)//"BAK."//"TXT"
        ENDIF

C       Output the Porod background data in ASCII format
	  do i=realtime(1),realtime(2),realtime(3)	  
           asciiresults(i)=results(i,2)
        end do
        CALL writeascii(grname(2)(1:3)//"POR."//"TXT",notok,asciiresults,
     +                  irc,1)
        IF(irc.EQ.0)THEN
          CALL showprompt(prompt(23))
        ELSE
          WRITE(6,1225)grname(2)(1:3)//"POR."//"TXT"
        ENDIF

C       Output the second moment data in ASCII format
	  do i=realtime(1),realtime(2),realtime(3)	  
           asciiresults(i)=results(i,3)
        end do
        CALL writeascii(grname(3)(1:3)//"SIG."//"TXT",notok,asciiresults,
     +                  irc,1)
        IF(irc.EQ.0)THEN
          CALL showprompt(prompt(23))
        ELSE
          WRITE(6,1235)grname(3)(1:3)//"SIG."//"TXT"
        ENDIF

C       Output the frame axis in ASCII format
	  do i=realtime(1),realtime(2),realtime(3)	  
           asciiresults(i)=i
        end do
        CALL writeascii(grname(4)(1:3)//"FAX."//"TXT",notok,asciiresults,
     +                  irc,1)
        IF(irc.EQ.0)THEN
          CALL showprompt(prompt(23))
        ELSE
          WRITE(6,1241)grname(4)(1:3)//"FAX."//"TXT"
        ENDIF

      endif

      CALL showprompt(prompt(20))
      RETURN
      STOP


C     Error messages

C     Error reading in intensities or x data
5010  CALL showprompt(prompt(2))
      STOP

C     Error writing output otoko files
5020  CALL showprompt(prompt(5))
      STOP

C     Static image - can't get realtime info
5040  realflag=0
      realtime(1)=1
      realtime(2)=1
      realtime(3)=1
      realtime(4)=1

      RETURN
      END



      SUBROUTINE mrqcof2(xdata,ydata,lim1,lim2,param,
     +alpha,beta,chisqu)
C     Subroutine involved in Levenburg Marquart non linear fitting.
C     Adapted from Numerical Recipes, Flannery and Press.
C     Fills the matrix "alpha" with values. Alpha is symmetric.
C     Also fills vector beta.
C     Finally returns a chi squared value for the current fit.
      INTEGER MaxDim
	PARAMETER (MaxDim=2048)
      DIMENSION xdata(MaxDim),ydata(MaxDim)
      DIMENSION alpha(3,3),beta(3),dyda(3),param(3)
      INTEGER lim1,lim2

      DO j=1,3
        DO k=1,j
          alpha(j,k)=0.
        END DO
        beta(j)=0.
      END DO

C     calc chisqu
      chisqu=0.

C     loop over data points
      DO i=lim1,lim2
        CALL sigmoid2(xdata(i),y,dyda,param)
        dy=ydata(i)-y
        DO j=1,3
          wt=dyda(j)
          DO k=1,j
            alpha(j,k)=alpha(j,k)+wt*dyda(k)
          END DO
          beta(j)=beta(j)+dy*wt
        END DO
        chisqu=chisqu+dy*dy
      END DO
C     Normalise chisqu to no. of data points
      chisqu=chisqu/(1.*(lim2-lim1+1))

C     Fill remaining places in alpha by symmetry.
C     At the moment alpha is small so just do it 'by hand'.
      alpha(1,2)=alpha(2,1)
      alpha(1,3)=alpha(3,1)
      alpha(2,3)=alpha(3,2)

      RETURN
      END



      SUBROUTINE sigmoid(x,param,y,dyda,ma)
C     Levenburg Marquart subroutine.
C     Returns y and grad y (wrt fitting parameters)
C     at a point x, according to the sigmoid function
C     Iobs=B + (K/Q^4)*EXP(-sigma^2*Q^2)
C
C     Often leads to "IEEE" errors.
C     Debug in progress.
C

      DOUBLE PRECISION x,y,param(3),dyda(3)
      INTEGER ma

      dyda(1)=1.
      y=param(1)+(param(2)/(x**4))*EXP(-(param(3)**2)*(x**2))
      dyda(2)=EXP(-(param(3)**2)*(x**2))/(x**4)
      dyda(3)=-2.*param(3)*param(2)*EXP(-(param(3)**2)*(x**2))/(x**2)

      RETURN
      END



      SUBROUTINE sigmoid2(x,y,dyda,param)
C     Levenburg Marquart subroutine.
C     Returns y and grad y (wrt fitting parameters)
C     at a point x, according to the sigmoid function
C     Iobs=B + (K/Q^4)*EXP(-sigma^2*Q^2)
C
C     Often leads to "IEEE" errors.
C     Debug in progress.
C
      DIMENSION dyda(3),param(3)

      dyda(1)=1.
      y=param(1)+(param(2)/(x**4))*EXP(-(param(3)**2)*(x**2))
      dyda(2)=EXP(-(param(3)**2)*(x**2))/(x**4)
      dyda(3)=-2.*param(3)*param(2)*EXP(-(param(3)**2)*(x**2))/(x**2)


      RETURN
      END


      SUBROUTINE gaussj(a,b,nerr)
C     Gauss-Jordan elimination algorithm
C     Solves linear equations.
C     From Numerical Recipes (Flannery and Press), pp.27
C     a is an n*n matrix, b an n-vector.
C     Gaussj inverts a and places soln. to equn. in b.
C     Max dimension of a is three.
C
C     There many be faster ways of solving linear equns. in 3
C     variables, but for a more complex background (eg. Vonk
C     instead of Bonart) the number of variables would increase.
C     Hence, for the moment, use gauss elimination.
C
C     5/8/94 Problems with singular matrices encountered:
C     Now when a sing. matrix is found, gaussj sets the output
C     vector b to zero ie. no chabge in parameters.
C     Hence chisqu won't change, and the program will behave as
C     if there was an increase in chisqu ie. new params discarded.
C
C     After experimentation it was decided that when sing.
C     matrices occur the user should be advised to re-run that frame
C     with a Porod approach.
C
C     Finally: built in auto default to sig=0. on failure.

      DIMENSION a(3,3),b(3),ipiv(3),indxr(3),indxc(3)

1000  FORMAT(/,1x,'100: Fitting error: singular alpha matrix!',/,1x,
     +'Re-run this frame using a Porod profile instead of',
     +' the sigmoid tail.',/,1x,'Error fatal (sorry)...',/)

C     Error handling:
      nerr=0

C     Three variables
      n=3

C     Initialise pivot array
      DO j=1,n
        ipiv(j)=0
      END DO

C     Find pivot elt.
      DO i=1,n
        big=0.
        DO j=1,n
          IF (ipiv(j) .NE. 1) THEN
            DO k=1,n
              IF (ipiv(k) .EQ. 0) THEN
                IF (ABS(a(j,k)) .GE. big) THEN
                  big=ABS(a(j,k))
                  irow=j
                  icol=k
                ENDIF

              ELSEIF (ipiv(k) .GT. 1) THEN
C               MTX is singular
C               PAUSE 'Singular matrix in subroutine gaussj'
C               WRITE(6,1000)
C               STOP
                nerr=1
                GOTO 2000
              ENDIF

            END DO
          ENDIF
        END DO
        ipiv(icol)=ipiv(icol)+1

C       We've got the pivot elt. so swap rows if nec. such that
C       pivot elt. on diagonal. Performed via column relabelling.
C       indxc(i) is the column of the ith pivotal elt. and is
C       ith to be reduced. indxr(i) is row of ith pivotal elt..
        IF (irow .NE. icol) THEN
          DO l=1,n
            dum=a(irow,l)
            a(irow,l)=a(icol,l)
            a(icol,l)=dum
          END DO
          dum=b(irow)
          b(irow)=b(icol)
          b(icol)=dum
        ENDIF

C       Now divide pivot row by pivot elt.
        indxr(i)=irow
        indxc(i)=icol
C       Check pivot elt. non-zero
        IF (a(icol,icol) .EQ. 0.) THEN
C         Singular MTX
C         PAUSE 'Singular matrix in subroutine gaussj'
C         WRITE(6,1000)
C         STOP
          nerr=1
          GOTO 2000
C         a(icol,icol)=1.E-8
        ENDIF
        pivinv=1./a(icol,icol)
        a(icol,icol)=1.
        DO l=1,n
          a(icol,l)=a(icol,l)*pivinv
        END DO
        b(icol)=b(icol)*pivinv

C       Division complete.
C       Now reduce rows, subtracting row of pivot elt.
C       Remember not to change pivot
        DO ll=1,n
          IF (ll .NE. icol) THEN
C           Skip pivot
            dum=a(ll,icol)
            a(ll,icol)=0.
            DO l=1,n
              a(ll,l)=a(ll,l)-a(icol,l)*dum
            END DO
            b(ll)=b(ll)-b(icol)*dum
          ENDIF
        END DO

      END DO
C     End of main loop.
C     Now unscramble solution from column interchanges.
C     ie. swap in reverse order.
      DO l=n,1,-1
        IF (indxr(l) .NE. indxc(l)) THEN
          DO k=1,n
            dum=a(k,indxr(l))
            a(k,indxr(l))=a(k,indxc(l))
            a(k,indxc(l))=dum
          END DO
        ENDIF
      END DO

2000  RETURN
      END



      SUBROUTINE showpos(newlim1,iteration,param,alpha,
     +beta,lamda,chisqu)
C     Outputs current fit location to screen.
      DIMENSION param(3),alpha(3,3),beta(3)
      REAL lamda

1000  FORMAT(///,1x,'CURRENT FIT LOCATION: iteration ',I3,
     +'. Tail starts at channel ',I3,'.')
1010  FORMAT(/,2x,'Parameter       Value        Gradient',/,
     +          '------------------------------------------',/)
1020  FORMAT(1x,A10,3x,E12.6,3x,E12.6)
1030  FORMAT(/,1x,'Alpha Matrix:')
1040  FORMAT(1x,E12.6,4x,E12.6,4x,E12.6)
1050  FORMAT(/,1x,'Lamda = ',E12.6,'.')
1060  FORMAT(/,1x,'Chi squared = ',E12.6,'.')

      WRITE(6,1000)iteration,newlim1
      WRITE(6,1060)chisqu
      WRITE(6,1010)
      WRITE(6,1020)'Background',param(1),beta(1)
      WRITE(6,1020)'K',param(2),beta(2)
      WRITE(6,1020)'Sigma',param(3),beta(3)
      WRITE(6,1030)
      DO i=1,3
        WRITE(6,1040)alpha(i,1),alpha(i,2),alpha(i,3)
      END DO
      WRITE(6,1050)lamda

      RETURN
      END



      SUBROUTINE lsqfit(x,y,n,a,b)
C     Linear least squares fit to y=a+bx
C     No chisquared or statistical errors given.
      INTEGER MaxDim
	PARAMETER (MaxDim=2048)
      DIMENSION x(MaxDim),y(MaxDim)

      sx=0.
      sy=0.
      st2=0.
      b=0.
      ss=float(n)

C     sigma x and sigma y
      DO i=1,n
        sx=sx+x(i)
        sy=sy+y(i)
      END DO
      sxoss=sx/ss

      DO i=1,n
        t=x(i)-sxoss
        st2=st2+t*t
        b=b+t*y(i)
      END DO

      b=b/st2
      a=(sy-sx*b)/ss

      RETURN
      END
