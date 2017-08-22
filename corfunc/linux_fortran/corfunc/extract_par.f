      PROGRAM extract_par
C     TMWN August 94
C     Program analyses correlation function and extracts information
C     based on a lamellar model.
C     Also outputs Porod and moments results.
C
C     Reference: Strobl und Schneider; J.Polymer Sci., polymer Phys. Ed.;
C     Vol. 18, 1343-1359, 1980
C
C     Updates: many attempts to get the position of the linear section
C     correct.
C     It's quite easy to write an algorithm that looks good on paper
C     and that works well most of the time. However, the big problem
C     is that the linear section occurs at low R values (high Q)
C     and so is greatly affected by the tail fitting. Of course,
C     tailfitting is a slightly dubious procedure, and any noise in
C     the tail can throw things completely.
C     Algorithms deciding where to place the linear section involve
C     polynomial interpolation of the data points, and differetiation
C     to determine some sort of gradient at each point.
C
C     8/8/94
C     Re-write linear section fit without interpolation or
C     differentiation. Algorithm has following form:
C     Loop through all possible start points for section.
C       Loop through all possible end points.
C         Lsqu fit to linear section.
C         Fit polynomials to curved sections at either end.
C         Calculate chisqu.
C       End loop.
C     End loop.
C
C     9/8/94 Update.
C     Handles channel limits for tailfit varying with frame no.
C
C     SMK Nov 05 Update.
C     Redimensioned data arrays from 512 to MaxDim.
C
      CHARACTER*80 dirname,filename,qaxname,filename2,resultname
      CHARACTER*40 title,ascii,sigmodel,user
      CHARACTER*80 prompt(25),fname,arbabs,graphics,stat
      CHARACTER*40 backex,retrans,text*60,idftoggle
      CHARACTER*80 cor1name,cor3name,cor1head,cor3head,dhead,dname
      CHARACTER*1 letter
      INTEGER qzero
      INTEGER realtime(4),realflag
      INTEGER MaxDim
      PARAMETER (MaxDim=4096)
      INTEGER datastart,channel(MaxDim,2),lword
      REAL moment(MaxDim,5),lp,intercept,volfrac
      DIMENSION notok(10),param(MaxDim,5),calc(MaxDim)
      DIMENSION gamma1(2048),xgamma(2048)
      DIMENSION reslam(MaxDim,11),resporod(MaxDim,7),nout(2)
      LOGICAL static

C     Array "param"
C     Parameter 1: Bonart background
C     Parameter 2: K (interface per unit volume)
C     Parameter 3: sigma (diffuse boundary thickness
C     Parameter 4: A or H1
C     Parameter 5: B or H2

1000  FORMAT(A1)
1010  FORMAT(A80)
1020  FORMAT(2x,I3)
1030  FORMAT(10I8)
1040  FORMAT(A40)
1050  FORMAT(2x,I3,2x,I3,2x,I3,2x,I3)
1060  FORMAT(E12.6,2x,E12.6,2x,E12.6,2x,E12.6,2x,E12.6)
1070  FORMAT(A10)
1080  FORMAT(/,1x,'100: Frame ',I3,'. Gammamin ',E12.6,'.')
1090  FORMAT(2x,I3,2x,I3)
1100  FORMAT(/,1x,'Limits for frame ',I3,':')

      prompt(1)='ERROR: Error reading extract.txt file: FATAL'
      prompt(2)='ERROR: Expecting static Q axis,'
     +//' received dynamic: FATAL'
      prompt(3)='All necessary files correctly loaded...'
      prompt(4)='ERROR: Software error with subroutine'
     +//' changeotok: FATAL'
      prompt(5)='ERROR: Error reading corfunc.txt file: FATAL'
      prompt(6)='ERROR: Error reading correlation function '
     +//'otoko files: FATAL'
      prompt(7)='ERROR: Software error with subroutine'
     +//' changeotok: FATAL'
      prompt(8)='ERROR: Error with number of data points in '
     +//'correlation function otoko files: FATAL'
      prompt(9)='Please wait: working...'
      prompt(10)='ERROR: Slope on correlation function '
     +//'positive: FATAL'
      prompt(11)='ERROR: Error writing results file: FATAL'
      prompt(12)='Results coming up...'
      prompt(13)='Writing results to disk...'
      prompt(14)='Analysis session over: terminating as normal...'
      prompt(15)='ERROR: Error with status file: FATAL'
      prompt(16)='ERROR: Problem with limits: FATAL'
      prompt(17)='Enter R at start of linear section'
      prompt(18)='Enter R at end of linear section'
      prompt(19)='ERROR: Error with limitinfo.txt: FATAL'
      prompt(20)='Finished extract'
      prompt(21)='Do you want user control of extraction '
     +//'process [y/n]'
      prompt(22)='100: EXTRACTING STRUCTURAL PARAMETERS...'
      prompt(23)='100:'
      prompt(24)='Enter estimate of volume fraction crystallinity'
      prompt(25)='ERROR: Invalid input: FATAL'

      CALL WRDLEN(LWORD)
      realflag=1
      if(static)then
        realflag=0
        realtime(1)=1
        realtime(2)=1
        realtime(3)=1
        realtime(4)=1
      endif

C      WRITE(6,*)
C      title='Extraction of information from corfunc'
C      CALL showtitle(title)
      CALL showprompt(prompt(23))
      CALL showprompt(prompt(22))

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
      DO i=realtime(1),realtime(2),realtime(3)
          read(9,1090,ERR=5000)channel(i,2),channel(i,1)
      END DO
      close(9)

C     Read extract.txt
      open(unit=9,file='extract.txt',STATUS='old',ERR=5010)
      read(9,*,ERR=5010)dmax
      read(9,*,ERR=5010)dstep
      DO i=realtime(1),realtime(2),realtime(3)
          read(9,1060,ERR=5010)moment(i,1),moment(i,2),moment(i,3),
     &                         moment(i,4),moment(i,5)
      END DO
      close(9)

      volfrac=0.5
C     Guess a volume fraction cryst.
2090  CALL defaultreal(prompt(24),volfrac)
      IF (volfrac .LT. 0. .OR. volfrac .GT. 1.) THEN
        CALL showprompt(prompt(15))
        GOTO 2090
      ENDIF

      letter='n'
      CALL defaultletter(prompt(21),letter)
      IF (letter .EQ. 'y' .OR. letter .EQ. 'Y') THEN
        user='user'
      ELSE
        user='auto'
      ENDIF

C     Calculate number of points in correlation functions
      numd=INT(dmax/dstep)+1

      CALL strippath(filename,fname)
      CALL getpath(filename,dirname)
      filename2=filename
      filename=fname

C     Read in D axis data.
C     Get filename.
      dhead=filename
      CALL swapexten(dhead,'RXA')
      fname=dhead
      OPEN(UNIT=10,FILE=fname,STATUS='old',ERR=5030)
      READ(10,1000,ERR=5030)letter
      READ(10,1000,ERR=5030)letter
      READ(10,1030,ERR=5030)notok
      READ(10,1040,ERR=5030)dname
      CLOSE(10)

C     Check static
      IF (notok(2) .NE. 1) THEN
        CALL showprompt(prompt(2))
        STOP
      ENDIF

C     Read D axis data
      nrecl=4*numd
      fname=dname
      OPEN(UNIT=9,FILE=fname,STATUS='old',
     +ACCESS='direct',RECL=nrecl/lword,ERR=5030)
      READ(9,REC=1,ERR=5030)(xgamma(i),i=1,numd)
2010  CLOSE(9)

C     Open corfunc files: read headers.
C     Deal with filenames.
      cor1head=filename
      cor3head=filename
      CALL swapexten(cor1head,'CF1')
      CALL swapexten(cor3head,'CF3')
      CALL changeotok(cor1head,cor1name,nerr)
      IF (nerr .EQ. 1) THEN
        CALL showprompt(prompt(7))
        STOP
      ENDIF
      CALL changeotok(cor3head,cor3name,nerr)
      IF (nerr .EQ. 1) THEN
        CALL showprompt(prompt(7))
        STOP
      ENDIF

C     1 dim.
      fname=cor1head
      OPEN(UNIT=9,FILE=fname,STATUS='old',ERR=5030)
      READ(9,1000,ERR=5030)letter
      READ(9,1000,ERR=5030)letter
      READ(9,1030,ERR=5030)notok
      READ(9,1000,ERR=5030)letter
      CLOSE(9)
C     1D header done
C     Check c. realtime
      IF (notok(1) .NE. numd .OR. notok(2) .NE. realtime(4)) THEN
        CALL showprompt(prompt(8))
        STOP
      ENDIF

C     3 dim.
C      fname=cor3head
C      OPEN(UNIT=9,FILE=fname,STATUS='old',ERR=5030)
C      READ(9,1000,ERR=5030)letter
C      READ(9,1000,ERR=5030)letter
C      READ(9,1030,ERR=5030)notok
C      READ(9,1000,ERR=5030)letter
C      CLOSE(9)
C     Check c. realtime
C      IF (notok(1) .NE. numd .OR. notok(2) .NE. realtime(4)) THEN
C        CALL showprompt(prompt(8))
C        STOP
C      ENDIF
C     3D header done

C     Open data files:
      nrecl=4*numd
      fname=cor1name
      OPEN(UNIT=9,FILE=fname,STATUS='old',
     +ACCESS='direct',RECL=nrecl/lword,ERR=5030)
C     At the moment gamma3 is not used in the analysis.
C      OPEN(UNIT=10,FILE=fname,STATUS='old',
C     +ACCESS='direct',RECL=nrecl/lword,ERR=5030)

C     Got all necessary data.
      CALL showprompt(prompt(3))


C     START PROCESSING
C     ~~~~~~~~~~~~~~~~

      CALL showprompt(prompt(9))

C     Loop through frames.
      nfr=0
      rstart=0.
      rend=0.
      DO nframe=realtime(1),realtime(2),realtime(3)
        nfr=nfr+1

C       Read in gamma1 data.
        READ(9,REC=nfr,ERR=5030)(gamma1(i),i=1,numd)

C       Search for the first minimum.
        DO i=2,numd-1
          IF ((gamma1(i) .LT. gamma1(i-1)) .AND.
     +    (gamma1(i) .LT. gamma1(i+1))) THEN
            IF (gamma1(i) .LT. 0.) THEN
              r3=xgamma(i)
              gammamin=-gamma1(i)
              minchannel=i
              lamflag=1
              GOTO 2020
            ENDIF
          ENDIF
        END DO

C       OK: we haven't found the first minimum
        lamflag=0
        minchannel=2

C       Search for local maxm.
2020    DO i=minchannel,(numd-1)
          IF ((gamma1(i) .GT. gamma1(i-1)) .AND.
     +     (gamma1(i) .GT. gamma1(i+1))) THEN
             IF (gamma1(i) .GT. 0.) THEN
               lp=xgamma(i)
               gammamax=gamma1(i)
               maxchannel=i
               lamflag=lamflag+1
               GOTO 2030
             ENDIF
           ENDIF
         END DO

C       OK: we haven't found the first maxm.
        lamflag=0
        maxchannel=2

C       Sort out flags
2030    IF (lamflag .NE. 2) THEN
          lamflag=0
        ELSE
          lamflag=1
        ENDIF

C       Check whether lammella information can be extracted.
        IF (lamflag .EQ. 1) THEN
C         Yes - we can go ahead.
C         Linear fit first.

C         8/8/94
C         New method for finding linear section.

C         Set up chisqu search
          oldchisqu=1.E+20
          linstart=1
          linend=minchannel
          grad=0.
          gammastar=0.

C         Loop through possible start points.
          DO i=2,minchannel-2

C           Loop through possible end points.
            DO j=i+1,minchannel-1

C             LSQ fit to linear section.
              sum1=0.
              sum2=0.
              sum3=0.
              sum4=0.
              ntemp=j-i+1
              DO k=i,j
                sum1=sum1+gamma1(k)
                sum2=sum2+xgamma(k)
                sum3=sum3+gamma1(k)*xgamma(k)
                sum4=sum4+xgamma(k)*xgamma(k)
              END DO
              gradient=(ntemp*sum3-sum1*sum2)/(ntemp*sum4-sum2*sum2)
              intercept=(sum1-gradient*sum2)/ntemp

C             Check whether polynom model applies:
              gr1=intercept+gradient*xgamma(i)
              gr2=intercept+gradient*xgamma(j)
              IF (intercept .GT. 1. .AND. gradient .LT. 0.
     +        .AND. gr1 .LT. 1. .AND. gr2 .GT. gammamin) THEN

C               Calculate polynomial parameters.
                r1=xgamma(i)
                r2=xgamma(j)
C               Low R end:
                p1=(-gradient*r1)/(1.-(gradient*r1)-intercept)
                a1=(1.-(gradient*r1)-intercept)/(r1**p1)
C               High R end:
                deltar=ABS(r2-xgamma(minchannel))
                p2=(-gradient*deltar)/(gammamin+intercept+(gradient*r2))
                a2=(gammamin+intercept+(gradient*r2))/(deltar**p2)

C               Fill array with calc. data
C               First low R curved section:
                DO k=1,i-1
                  x=xgamma(k)
                  calc(k)=1.-a1*(x**p1)
                END DO
C               Then linear section:
                DO k=i,j
                  x=xgamma(k)
                  calc(k)=intercept+gradient*x
                END DO
C               Then high R curved end:
                DO k=j+1,minchannel
                  x=ABS(xgamma(k)-xgamma(minchannel))
                  calc(k)=a2*(x**p2)-gammamin
                END DO

C               Calculate chisqu:
                chisqu=0.
                DO k=1,minchannel
                  chisqu=chisqu+(gamma1(k)-calc(k))**2
                END DO

C               Compare chisqu:
                IF (chisqu .LT. oldchisqu) THEN
                  oldchisqu=chisqu
                  linstart=i
                  linend=j
                  grad=gradient
                  gammastar=intercept
                ENDIF

C               Debug:
C                  write(6,*)gradient,intercept
C                 write(6,3000)i,j,a1,p1,a2,p2,chisqu
3000             FORMAT(I3,2x,I3,2x,E12.6,2x,E12.6,2x,
     +           E12.6,2x,E12.6,2x,E12.6)

              ENDIF

C           End loop through linear sections:
            END DO
          END DO

C         User control
          IF (user .EQ. 'user') THEN

C           Check whether first time
            IF (rstart .EQ. 0. .AND. rend .EQ. 0.) THEN
              rstart=xgamma(linstart)
              rend=xgamma(linend)
            ENDIF

C           Prompt user
2040        WRITE(6,1080)nframe,xgamma(minchannel)
            WRITE(6,1100)nframe
            CALL defaultreal(prompt(17),rstart)
            CALL defaultreal(prompt(18),rend)

C           Turn R values into channel no.s
            linstart=0
            DO i=1,minchannel
              IF (xgamma(i) .LE. rstart .AND.
     +        xgamma(i+1) .GT. rstart) THEN
                linstart=i
              ENDIF
            END DO
            linend=0
            DO i=linstart,minchannel
              IF (xgamma(i) .LE. rend .AND.
     +        xgamma(i+1) .GT. rend) THEN
                linend=i
              ENDIF
            END DO

C           Check channel no.s
            IF (linstart .EQ. 0 .OR. linend .EQ. 0) THEN
              CALL showprompt(prompt(16))
              GOTO 2040
            ENDIF

C           Perform linear fit
C           LSQ fit to linear section.
            sum1=0.
            sum2=0.
            sum3=0.
            sum4=0.
            ntemp=linend-linstart+1
            DO i=linstart,linend
              sum1=sum1+gamma1(i)
              sum2=sum2+xgamma(i)
              sum3=sum3+gamma1(i)*xgamma(i)
              sum4=sum4+xgamma(i)*xgamma(i)
            END DO
            grad=(ntemp*sum3-sum1*sum2)/(ntemp*sum4-sum2*sum2)
            gammastar=(sum1-grad*sum2)/ntemp

C         End user control
          ENDIF

C          Debug:
C          IF (rstart .EQ. 0. .AND. rend .EQ. 0.) THEN
C            rstart=xgamma(linstart)
C            rend=xgamma(linend)
C          ENDIF
C          Write(6,7114)nframe,rstart,rend

C         Debug:
C         WRITE(6,*)grad,gammastar

C         That's everything! All measurements complete.
C         Now fill arrays with results.
C         Array "reslam" holds lamella results.

C         reslam(nframe,1)=Long period
C         (D position of first maxm).
C         reslam(nframe,2)=Average hard block thickness.
C         (D position of Xn. of extended linear section and base line).
C         reslam(nframe,3)=Average soft block thickness
C         (long period - hard block thickness).
C         reslam(nframe,4)=Bulk volume cryst. (ie. volume fraction)
C         (= 1. - (D where linear section crosses D axis)/(av. hard block)).
C         reslam(nframe,5)=Local cryst.
C         (= av. hard block / long period).
C         reslam(nframe,6)=Average core thickness
C         (= D at end of linear section).
C         reslam(nframe,7)=Interface thickness
C         (=D at start of linear section).
C         reslam(nframe,8)=Polydispersity
C         (= gamma at first min / gamma at first max)
C         reslam(nframe,9)=Electron density contrast
C         (= SQRT { Q / (bulk cryst)(1. - bulk cryst) }
C         reslam(nframe,10)=Specific inner surface
C         (= 2 * bulk cryst / av. hard block) ????
C         reslam(nframe,11)="Non-ideality" I made this one up myself!
C         (= (D at max - 2. * D at min)**2 / long period**2 ).
C         Non ideality has changed. And then changed back to the original.

          reslam(nframe,1)=xgamma(maxchannel)

          reslam(nframe,2)=(-gammamin-gammastar)/grad

          reslam(nframe,3)=reslam(nframe,1)-reslam(nframe,2)

          reslam(nframe,4)=1.+(gammastar/(grad*reslam(nframe,2)))

          reslam(nframe,5)=reslam(nframe,2)/reslam(nframe,1)

          reslam(nframe,6)=xgamma(linend)

          reslam(nframe,7)=xgamma(linstart)

          reslam(nframe,8)=gammamin/gammamax

C         Electron density contrast is the only result affected by
C         Absolute units of intensity.
          IF (arbabs .EQ. 'ABS' .OR. arbabs .EQ. 'abs') THEN
C           We're in abs units: convert invariant to cm^-4.
            qtemp=moment(nframe,3)*1.E+24
            reslam(nframe,9)=
     +      SQRT(qtemp*gammastar/((reslam(nframe,4))*(1.-reslam
     +           (nframe,4))))
          ELSE
C           We're in arb units
            reslam(nframe,9)=SQRT(moment(nframe,3)*gammastar/
     +      ((reslam(nframe,4))*(1.-reslam(nframe,4))))
          ENDIF

          reslam(nframe,10)=2*reslam(nframe,4)/reslam(nframe,2)

          reslam(nframe,11)=((reslam(nframe,1)-2.*xgamma(minchannel)
     +    )**2)/(reslam(nframe,1)**2)

C         End lamella calculations.

C         Now do Porod calculations.
C         NB!
C         Porod results use volume fraction hard block found from
C         the correlation function analysis.
          cryst=reslam(nframe,4)

C         But remember to check which model was used for tail fitting.
          IF (sigmodel .EQ. 'on' .OR. sigmodel .EQ. 'ON') THEN
C           Sigmoid model used for tail.

C           "resporod" holds results.
C           resporod(nframe,1)=Porod const.
C           resporod(nfarme,2)=sigma
C           resporod(nframe,3)=-1 (indicates sigmoid model)
C           resporod(nframe,4)=-1             "
C           resporod(nframe,5)=-1             "
C           resporod(nframe,6)=-1             "
C           resporod(nframe,7)=-1 (indicates lamella measurements successful)

            resporod(nframe,1)=param(nframe,2)

C           Take care of abs units (assume cm^-1)
            IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
C             Convert to cm^-5
              resporod(nframe,1)=resporod(nframe,1)*1.E+32
            ENDIF
            resporod(nframe,2)=param(nframe,3)
            resporod(nframe,3)=-1.
            resporod(nframe,4)=-1.
            resporod(nframe,5)=-1.
            resporod(nframe,6)=-1.
            resporod(nframe,7)=-1.

          ELSE
C           Ordinary Porod fit to tail.
C           "resporod" holds results.
C           resporod(nframe,1)=Porod const.
C           resporod(nfarme,2)=-1 (indicates Porod fit not sigmoid)
C           resporod(nframe,3)=Characteristic chord length
C           resporod(nframe,4)=Hard block chord length
C           resporod(nframe,5)=Soft block chord length
C           resporod(nframe,6)=surface to volume ratio
C           resporod(nframe,7)=-1 (indicates lamella measurements successful)

            resporod(nframe,1)=param(nframe,2)
C           Take care of abs units (assume cm^-1)
            IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
C             Convert to cm^-5
              resporod(nframe,1)=resporod(nframe,1)*1.E+32
            ENDIF
            resporod(nframe,2)=-1.
C           Chord length = 4Q / (pi * Kp)
            resporod(nframe,3)=4.*moment(nframe,3)/
     +      (param(nframe,2)*3.14)
            resporod(nframe,5)=resporod(nframe,3)/cryst
            resporod(nframe,4)=resporod(nframe,3)/(1.-cryst)
            resporod(nframe,6)=4.*cryst*(1.-cryst)/
     +                         resporod(nframe,3)
            resporod(nframe,7)=-1.

C         End check on which model for tail.
          ENDIF

        ELSE
C         Lamella information can't be extracted:
C         Just do porod results based on user's estimate of crystallinity.
          cryst=volfrac

C         First toggle lamella results
          DO i=1,11
            reslam(nframe,i)=-1.
          END DO

C         Remember to check which model was used for tail fitting.
          IF (sigmodel .EQ. 'on' .OR. sigmodel .EQ. 'ON') THEN
C           Sigmoid model used for tail.

C           "resporod" holds results.
C           resporod(nframe,1)=Porod const.
C           resporod(nfarme,2)=sigma
C           resporod(nframe,3)=-1 (indicates sigmoid model)
C           resporod(nframe,4)=-1             "
C           resporod(nframe,5)=-1             "
C           resporod(nframe,6)=-1             "
C           resporod(nframe,7)=Electron density contrast based on
C                              user supplied crystallinity.

            resporod(nframe,1)=param(nframe,2)
C           Take care of abs units (assume cm^-1)
            IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
C             Convert to cm^-5
              resporod(nframe,1)=resporod(nframe,1)*1.E+32
            ENDIF
            resporod(nframe,2)=param(nframe,3)
            resporod(nframe,3)=-1.
            resporod(nframe,4)=-1.
            resporod(nframe,5)=-1.
            resporod(nframe,6)=-1.

C           Electron density contrast is affected by abs. units
            IF (arbabs .EQ. 'ABS' .OR. arbabs .EQ. 'abs') THEN
C             We're in abs units: convert invariant to cm^-4.
              qtemp=moment(nframe,3)*1.E+24
              resporod(nframe,7)=SQRT(qtemp/
     +        ((cryst)*(1.-cryst)))
            ELSE
C             We're in arb units
              resporod(nframe,7)=SQRT(moment(nframe,3)/
     +        ((cryst)*(1.-cryst)))
            ENDIF

          ELSE
C           Ordinary Porod fit to tail.
C           "resporod" holds results.
C           resporod(nframe,1)=Porod const.
C           resporod(nfarme,2)=-1 (indicates Porod fit not sigmoid)
C           resporod(nframe,3)=Characteristic chord length
C           resporod(nframe,4)=Hard block chord length
C           resporod(nframe,5)=Soft block chord length
C           resporod(nframe,6)=surface to volume ratio
C           resporod(nframe,7)=Electron density contrast based on
C                              user supplied crystallinity.

            resporod(nframe,1)=param(nframe,2)
C           Take care of abs units (assume cm^-1)
            IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
C             Convert to cm^-5
              resporod(nframe,1)=resporod(nframe,1)*1.E+32
            ENDIF
            resporod(nframe,2)=-1.
C           Chord length = 4Q / (pi * Kp)
            resporod(nframe,3)=4.*moment(nframe,3)/
     +      (param(nframe,2)*3.14)
            resporod(nframe,5)=resporod(nframe,3)/cryst
            resporod(nframe,4)=resporod(nframe,3)/(1.-cryst)


            resporod(nframe,6)=4.*cryst*(1.-cryst)/
     +                         resporod(nframe,3)

C           Electron density contrast is affected by abs. units
            IF (arbabs .EQ. 'ABS' .OR. arbabs .EQ. 'abs') THEN
C             We're in abs units: convert invariant to cm^-4.
              qtemp=moment(nframe,3)*1.E+24
              resporod(nframe,7)=SQRT(qtemp/
     +        ((cryst)*(1.-cryst)))
            ELSE
C             We're in arb units
              resporod(nframe,7)=SQRT(moment(nframe,3)/
     +        ((cryst)*(1.-cryst)))
            ENDIF


C         End check on which model for tail.
          ENDIF


C       End lamella results or just porod
        ENDIF


C     End loop through frames.
      END DO

      CLOSE(9)
C      CLOSE(10)


C     END EXTRACTING RESULTS
C     ~~~~~~~~~~~~~~~~~~~~~~


C     START DISPLAYING RESULTS
C     ~~~~~~~~~~~~~~~~~~~~~~~~

C     NB differences between single frame and realtime.
C     Results:-
C     1. Title, filename, frames.
C     2. Moments.
C     3. Lamella results (if there are any).
C     4. Porod results (depending on tail model).
C
C     nout(1) = 6 is screen; nout(2) = 10 is file.
C
C     Remember to keep checking for abs units.

      nout(1)=6
      nout(2)=10

C     Output file: get filename.
      resultname=filename
      CALL swapexten(resultname,'LIS')
      fname=resultname
C     Open file.
      OPEN(UNIT=nout(2),FILE=fname,STATUS='unknown',ERR=5040)

C     Loop through screen and file.
      DO l=1,2
        nunit=nout(l)
        IF (l.EQ.1) THEN
C         screen.
          CALL showprompt(prompt(12))
          WRITE(6,*)
        ELSE
C         file.
          CALL showprompt(prompt(13))
        ENDIF


C       OK: start output with a title.
        WRITE(nunit,7000,ERR=5040)
7000    FORMAT(1x,'CORRELATION FUNCTION ANALYSIS OUTPUT',/,
     +  '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',/)
C       Next directory and filename.
        IF(l.EQ.1)THEN
            WRITE(nunit,7010,ERR=5040)filename2
        ELSE
            WRITE(nunit,7011,ERR=5040)filename2
        ENDIF
7010    FORMAT(1x,'100: Analysis performed on ',/,
     +  1x,'100: Data file: ',A40)
7011    FORMAT(1x,'Analysis performed on ',/,
     +  1x,'Data file: ',A40)
C       Realtime info.
        IF (realflag .EQ. 0) THEN
          IF(l.EQ.1) THEN
            WRITE(nunit,7020,ERR=5040)
          ELSE
            WRITE(nunit,7021,ERR=5040)
          ENDIF
7020      FORMAT(/,1x,'100: Realtime status: Static.')
7021      FORMAT(/,1x,'Realtime status: Static.')
        ELSE
          IF(l.EQ.1) THEN
            WRITE(nunit,7030,ERR=5040)realtime(1),realtime(2),
     +                                realtime(3),realtime(4)
          ELSE
            WRITE(nunit,7031,ERR=5040)realtime(1),realtime(2),
     +                                realtime(3),realtime(4)
          ENDIF
7030      FORMAT(1x,'100: Start frame: ',I3,'.       End frame: '
     +,I3,'.',/,1x,'100: Frame increment: ',I3,'.   Total number '
     +,'of frames: ',I3,'.')
7031      FORMAT(1x,'Start frame: ',I3,'.       End frame: '
     +,I3,'.',/,1x,'Frame increment: ',I3,'.   Total number '
     +,'of frames: ',I3,'.')
        ENDIF
C       Arb or abs units?
        IF(l.EQ.1)THEN
          IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
            WRITE(nunit,7040,ERR=5040)'Absolute (cm^-1).'
          ELSE
            WRITE(nunit,7040,ERR=5040)'Arbitrary.       '
          ENDIF
        ELSE
          IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
            WRITE(nunit,7041,ERR=5040)'Absolute (cm^-1).'
          ELSE
            WRITE(nunit,7041,ERR=5040)'Arbitrary.       '
          ENDIF
        ENDIF
7040    FORMAT(1x,'100: Intensity units: ',A17)
7041    FORMAT(1x,'Intensity units: ',A17)
C       Q axis
        IF(l.EQ.1)THEN
          WRITE(nunit,7050,ERR=5040)qaxname
        ELSE
          WRITE(nunit,7051,ERR=5040)qaxname
        ENDIF
7050    FORMAT(1x,'100: Q axis filename: ',A40)
7051    FORMAT(1x,'Q axis filename: ',A40)
C       Information on the tailfit.
        IF(l.EQ.1)THEN
          WRITE(nunit,7060,ERR=5040)
        ELSE
          WRITE(nunit,7061,ERR=5040)
        ENDIF
7060    FORMAT(//,1x,'100: EXTRAPOLATION PARAMETERS:')
7061    FORMAT(//,1x,'EXTRAPOLATION PARAMETERS:')
        IF(l.EQ.1)THEN
          IF (sigmodel .EQ. 'on' .OR. sigmodel .EQ. 'ON') THEN
            WRITE(nunit,7070,ERR=5040)'Sigmoid.'
          ELSE
            WRITE(nunit,7070,ERR=5040)'Porod.  '
          ENDIF
        ELSE
          IF (sigmodel .EQ. 'on' .OR. sigmodel .EQ. 'ON') THEN
            WRITE(nunit,7071,ERR=5040)'Sigmoid.'
          ELSE
            WRITE(nunit,7071,ERR=5040)'Porod.  '
          ENDIF
        ENDIF
7070    FORMAT(1x,'100: Tail model applied: ',A8)
7071    FORMAT(1x,'Tail model applied: ',A8)
C       Update 9/8/94
C       Check realtime
        IF(l.EQ.1)THEN
          IF (realtime(4) .EQ. 1) THEN
            WRITE(nunit,7080,ERR=5040)
     +      channel(realtime(1),1),channel(realtime(1),2)
7080        FORMAT(1x,'100: Tailfit start channel ',I3,
     +      '.',/,1x,'100: End channel ',I3,'.')
          ELSE
C           Realtime data
            WRITE(nunit,7081,ERR=5040)
7081        FORMAT(/,1x,'100: Frame    Start Channel    End Channel',/,
     +  '---------------------------------------',/)
7082        FORMAT(1x,'100: ',2x,I3,10x,I3,13x,I3)
            DO i=realtime(1),realtime(2),realtime(3)
              WRITE(nunit,7082,ERR=5040)i,channel(i,1),channel(i,2)
            END DO
            WRITE(nunit,*,ERR=5040)
          ENDIF
        ELSE
          IF (realtime(4) .EQ. 1) THEN
            WRITE(nunit,7083,ERR=5040)
     +      channel(realtime(1),1),channel(realtime(1),2)
7083        FORMAT(1x,'Tailfit start channel ',I3,
     +      '.',/,1x,'End channel ',I3,'.')
          ELSE
C           Realtime data
            WRITE(nunit,7084,ERR=5040)
7084        FORMAT(/,1x,'Frame    Start Channel    End Channel',/,
     +  '---------------------------------------',/)
7085        FORMAT(2x,I3,10x,I3,13x,I3)
            DO i=realtime(1),realtime(2),realtime(3)
              WRITE(nunit,7085,ERR=5040)i,channel(i,1),channel(i,2)
            END DO
            WRITE(nunit,*,ERR=5040)
          ENDIF
        ENDIF
        IF(l.EQ.1)THEN
          IF (backex .EQ. 'vonk') THEN
            WRITE(nunit,7090,ERR=5040)'Vonk.   '
          ELSE
            WRITE(nunit,7090,ERR=5040)'Guinier.'
          ENDIF
        ELSE
          IF (backex .EQ. 'vonk') THEN
            WRITE(nunit,7091,ERR=5040)'Vonk.   '
          ELSE
            WRITE(nunit,7091,ERR=5040)'Guinier.'
          ENDIF
        ENDIF
7090    FORMAT(1x,'100: Back extrapolation model: ',A8)
7091    FORMAT(1x,'Back extrapolation model: ',A8)
C       Fourier transform information.
        IF(l.EQ.1)THEN
          WRITE(nunit,7100,ERR=5040)
        ELSE
          WRITE(nunit,7101,ERR=5040)
        ENDIF
7100    FORMAT(//,1x,'100: FOURIER TRANSFORM PARAMETERS:')
7101    FORMAT(//,1x,'FOURIER TRANSFORM PARAMETERS:')
        IF(l.EQ.1)THEN
          WRITE(nunit,7110,ERR=5040)dmax,dstep
        ELSE
          WRITE(nunit,7111,ERR=5040)dmax,dstep
        ENDIF
7110    FORMAT(1x,'100: Transform performed up to D = ',E12.6,
     +' Angstroms.',/,1x,'100: Steps of ',E12.6,' Angstroms.')
7111    FORMAT(1x,'Transform performed up to D = ',E12.6,
     +' Angstroms.',/,1x,'Steps of ',E12.6,' Angstroms.')
7114    FORMAT(/,1x,'100: Frame',1x,I3,1x,'Start',1x,E12.6,
     &1x,'End',1x,E12.6)

C       End writing all the crap. Now the results.
C       Different output for single image.

        IF (realtime(4) .EQ. 1) THEN

C         Single frame.
          nframe=realtime(1)

C         First moments results
          IF(l.EQ.1)THEN
            CALL showprompt(prompt(23))
            WRITE(nunit,7120,ERR=5040)
          ELSE
            WRITE(nunit,7121,ERR=5040)
          ENDIF
7120      FORMAT(//,1x,'100: 1. MOMENTS RESULTS.',/)
7121      FORMAT(//,1x,'1. MOMENTS RESULTS.',/)
          IF (arbabs .EQ. 'ABS' .OR. arbabs .EQ. 'abs') THEN
            temp1=moment(nframe,1)*1.E+8
            temp2=moment(nframe,3)*1.E+24
            IF(l.EQ.1)THEN
              WRITE(nunit,7130,ERR=5040)temp1
            ELSE
              WRITE(nunit,7131,ERR=5040)temp1
            ENDIF
7130        FORMAT(1x,'100: Zeroth moment: ',E12.6,' cm^-2.')
7131        FORMAT(1x,'Zeroth moment: ',E12.6,' cm^-2.')
            IF(l.EQ.1)THEN
              WRITE(nunit,7140,ERR=5040)temp2
            ELSE
              WRITE(nunit,7141,ERR=5040)temp2
            ENDIF
7140        FORMAT(1x,'100: Invariant: ',E12.6,' cm^-4.')
7141        FORMAT(1x,'Invariant: ',E12.6,' cm^-4.')
          ELSE
            IF(l.EQ.1)THEN
              WRITE(nunit,7150,ERR=5040)moment(nframe,1)
            ELSE
              WRITE(nunit,7151,ERR=5040)moment(nframe,1)
            ENDIF
7150        FORMAT(1x,'100: Zeroth moment: ',E12.6,' [Arb.].')
7151        FORMAT(1x,'Zeroth moment: ',E12.6,' [Arb.].')
            IF(l.EQ.1)THEN
              WRITE(nunit,7160,ERR=5040)moment(nframe,3)
            ELSE
              WRITE(nunit,7161,ERR=5040)moment(nframe,3)
            ENDIF
7160        FORMAT(1x,'100: Invariant: ',E12.6,' [Arb.].')
7161        FORMAT(1x,'Invariant: ',E12.6,' [Arb.].')
          ENDIF

C         Next lamella results (if there are any).
          IF(l.EQ.1)THEN
            CALL showprompt(prompt(23))
            WRITE(nunit,7170,ERR=5040)
          ELSE
            WRITE(nunit,7171,ERR=5040)
          ENDIF
7170      FORMAT(//,1x,'100: 2. LAMELLA MORPHOLOGY RESULTS.',/)
7171      FORMAT(//,1x,'2. LAMELLA MORPHOLOGY RESULTS.',/)
C         Check whether cor. func. analysis successful.
          IF (reslam(nframe,1) .LT. 0.) THEN
C           No lamella results.
            WRITE(nunit,7180,ERR=5040)
7180        FORMAT(1x,'ERROR: Analysis of correlation function failed!'
     +      ,': NON-FATAL')
          ELSE
C           Output the whole batch of results.
7190        FORMAT(1x,'100: ',A60,E12.6,'.')
7191        FORMAT(1x,A60,E12.6,'.')
            IF(l.EQ.1)THEN
              text='Long period [Angstroms]'
              WRITE(nunit,7190,ERR=5040)
     +        text,reslam(nframe,1)
              text='Average hard block thickness [Angstroms]'
              WRITE(nunit,7190,ERR=5040)
     +        text,reslam(nframe,2)
              text='Average soft block thickness [Angstroms]'
              WRITE(nunit,7190,ERR=5040)
     +        text,reslam(nframe,3)
              text='Bulk volume crystallinity [No units]'
              WRITE(nunit,7190,ERR=5040)
     +        text,reslam(nframe,4)
              text='Local crystallinity [No units]'
              WRITE(nunit,7190,ERR=5040)
     +        text,reslam(nframe,5)
              text='Average hard block core thickness [Angstroms]'
              WRITE(nunit,7190,ERR=5040)
     +        text,reslam(nframe,6)
              text='Average interface thickness [Angstroms]'
              WRITE(nunit,7190,ERR=5040)
     +        text,reslam(nframe,7)
              text='Polydispersity [No units]'
              WRITE(nunit,7190,ERR=5040)
     +        text,reslam(nframe,8)
C             Check for abs units
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                text='Electron density contrast [cm^-2]'
                WRITE(nunit,7190,ERR=5040)
     +          text,reslam(nframe,9)
              ELSE
                text='Electron density contrast [Arb.]'
                WRITE(nunit,7190,ERR=5040)
     +          text,reslam(nframe,9)
              ENDIF
              text='Specific inner surface [Angstroms^-1]'
              WRITE(nunit,7190,ERR=5040)
     +        text,reslam(nframe,10)
              text='Non-ideality [No units]'
              WRITE(nunit,7190,ERR=5040)
     +        text,reslam(nframe,11)
            ELSE
              text='Long period [Angstroms]'
              WRITE(nunit,7191,ERR=5040)
     +        text,reslam(nframe,1)
              text='Average hard block thickness [Angstroms]'
              WRITE(nunit,7191,ERR=5040)
     +        text,reslam(nframe,2)
              text='Average soft block thickness [Angstroms]'
              WRITE(nunit,7191,ERR=5040)
     +        text,reslam(nframe,3)
              text='Bulk volume crystallinity [No units]'
              WRITE(nunit,7191,ERR=5040)
     +        text,reslam(nframe,4)
              text='Local crystallinity [No units]'
              WRITE(nunit,7191,ERR=5040)
     +        text,reslam(nframe,5)
              text='Average hard block core thickness [Angstroms]'
              WRITE(nunit,7191,ERR=5040)
     +        text,reslam(nframe,6)
              text='Average interface thickness [Angstroms]'
              WRITE(nunit,7191,ERR=5040)
     +        text,reslam(nframe,7)
              text='Polydispersity [No units]'
              WRITE(nunit,7191,ERR=5040)
     +        text,reslam(nframe,8)
C             Check for abs units
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                text='Electron density contrast [cm^-2]'
                WRITE(nunit,7191,ERR=5040)
     +          text,reslam(nframe,9)
              ELSE
                text='Electron density contrast [Arb.]'
                WRITE(nunit,7191,ERR=5040)
     +          text,reslam(nframe,9)
              ENDIF
              text='Specific inner surface [Angstroms^-1]'
              WRITE(nunit,7191,ERR=5040)
     +        text,reslam(nframe,10)
              text='Non-ideality [No units]'
              WRITE(nunit,7191,ERR=5040)
     +        text,reslam(nframe,11)
            ENDIF
C         End lamella results.
          ENDIF

C         Then Porod results.
C         Check where the crystallinity is from and which tail model was used.
          IF(l.EQ.1)THEN
            CALL showprompt(prompt(23))
            WRITE(nunit,7200,ERR=5040)
          ELSE
            WRITE(nunit,7201,ERR=5040)
          ENDIF
7200      FORMAT(//,1x,'100: 3. POROD RESULTS.',/)
7201      FORMAT(//,1x,'3. POROD RESULTS.',/)

          IF(l.EQ.1)THEN
            IF (sigmodel .EQ. 'on' .OR. sigmodel .EQ. 'ON') THEN
C             Tailfit used sigmoid model.
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                text='Porod constant [cm^-5]'
                WRITE(nunit,7190,ERR=5040)
     +          text,resporod(nframe,1)
              ELSE
                text='Porod constant [Arb.]'
                WRITE(nunit,7190,ERR=5040)
     +          text,resporod(nframe,1)
              ENDIF
              text='Sigma [Angstroms]'
              WRITE(nunit,7190,ERR=5040)
     +        text,resporod(nframe,2)
              IF (resporod(nframe,7) .GT. 0.) THEN
C               lamella morphology failed:-
                WRITE(6,7210)resporod(nframe,7)
7210            FORMAT(/,1x,'WARNING: Lamella-based interpretation of '
     +  ,'correlation function failed',/,1x,'100: User-supplied '
     +  ,'crystallinity suggests electron density contrast: ',E12.6,$)
C               Check abs units
                IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                  WRITE(nunit,7220,ERR=5040)' (cm^-2).'
                ELSE
                  WRITE(nunit,7220,ERR=5040)' (arb.).'
                ENDIF
7220            FORMAT(1x,'100: ',A10)
              ELSE
C               Lamella morphology OK - so no further results.
              ENDIF
            ELSE
C             Tailfit used a Porod model.
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                text='Porod constant [cm^-5]'
                WRITE(nunit,7190,ERR=5040)
     +          text,resporod(nframe,1)
              ELSE
                text='Porod constant [Arb.]'
                WRITE(nunit,7190,ERR=5040)
     +          text,resporod(nframe,1)
              ENDIF
              text='Porod chord length [Angstroms]'
              WRITE(nunit,7190,ERR=5040)
     +        text,resporod(nframe,3)
              IF (resporod(nframe,7) .GT. 0.) THEN
C               lamella model failed: user supplied cryst. used.
                WRITE(nunit,7230,ERR=5040)
7230  FORMAT(/,1x,'WARNING: Lamella-based interpretation of correlation'
     +,' function failed',/,1x,'100: Following results are based '
     +,'on the users crystallinity estimate.',/)
              ENDIF
              text='Crystalline chord length [Angstroms]'
              WRITE(nunit,7190,ERR=5040)
     +        text,resporod(nframe,4)
              text='Amorphous chord length [Angstroms]'
              WRITE(nunit,7190,ERR=5040)
     +        text,resporod(nframe,5)
              text='Surface to volume [Angstroms^-1]'
              WRITE(nunit,7190,ERR=5040)
     +        text,resporod(nframe,6)


              IF (resporod(nframe,7) .GT. 0.) THEN
C               lamella morphology failed:-
C               Check abs units
                IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                  text='Electron density contrast [cm^-2]'
                  WRITE(nunit,7190,ERR=5040)
     +            text,resporod(nframe,7)
                ELSE
                  text='Electron density contrast [Arb.]'
                  WRITE(nunit,7190,ERR=5040)
     +            text,resporod(nframe,7)
                ENDIF
              ENDIF

C           End choice of tailfit models
            ENDIF

          ELSE

            IF (sigmodel .EQ. 'on' .OR. sigmodel .EQ. 'ON') THEN
C             Tailfit used sigmoid model.
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                text='Porod constant [cm^-5]'
                WRITE(nunit,7191,ERR=5040)
     +          text,resporod(nframe,1)
              ELSE
                text='Porod constant [Arb.]'
                WRITE(nunit,7191,ERR=5040)
     +          text,resporod(nframe,1)
              ENDIF
              text='Sigma [Angstroms]'
              WRITE(nunit,7191,ERR=5040)
     +        text,resporod(nframe,2)
              IF (resporod(nframe,7) .GT. 0.) THEN
C               lamella morphology failed:-
                WRITE(6,7211)resporod(nframe,7)
7211            FORMAT(/,1x,'WARNING: Lamella-based interpretation of '
     +  ,'correlation function failed',/,1x,'User-supplied '
     +  ,'crystallinity suggests electron density contrast: ',E12.6,$)
C               Check abs units
                IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                  WRITE(nunit,7221,ERR=5040)' (cm^-2).'
                ELSE
                  WRITE(nunit,7221,ERR=5040)' (arb.).'
                ENDIF
7221            FORMAT(1x,A10)
              ELSE
C               Lamella morphology OK - so no further results.
              ENDIF
            ELSE
C             Tailfit used a Porod model.
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                text='Porod constant [cm^-5]'
                WRITE(nunit,7191,ERR=5040)
     +          text,resporod(nframe,1)
              ELSE
                text='Porod constant [Arb.]'
                WRITE(nunit,7191,ERR=5040)
     +          text,resporod(nframe,1)
              ENDIF

              text='Porod chord length [Angstroms]'
              WRITE(nunit,7191,ERR=5040)
     +        text,resporod(nframe,3)
              IF (resporod(nframe,7) .GT. 0.) THEN
C               lamella model failed: user supplied cryst. used.
                WRITE(nunit,7231,ERR=5040)
7231  FORMAT(/,1x,'WARNING: Lamella-based interpretation of correlation'
     +,' function failed',/,1x,'Following results are based '
     +,'on the users crystallinity estimate.',/)
              ENDIF
              text='Crystalline chord length [Angstroms]'
              WRITE(nunit,7191,ERR=5040)
     +        text,resporod(nframe,4)
              text='Amorphous chord length [Angstroms]'
              WRITE(nunit,7191,ERR=5040)
     +        text,resporod(nframe,5)
              text='Surface to volume [Angstroms^-1]'
              WRITE(nunit,7191,ERR=5040)
     +        text,resporod(nframe,6)


              IF (resporod(nframe,7) .GT. 0.) THEN
C               lamella morphology failed:-
C               Check abs units
                IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                  text='Electron density contrast [cm^-2]'
                  WRITE(nunit,7191,ERR=5040)
     +            text,resporod(nframe,7)
                ELSE
                  text='Electron density contrast [Arb.]'
                  WRITE(nunit,7191,ERR=5040)
     +            text,resporod(nframe,7)
                ENDIF
              ENDIF

C           End choice of tailfit models
            ENDIF

          ENDIF
C       More than one frame.
        ELSE

C         First moments results
          IF(l.EQ.1)THEN
            CALL showprompt(prompt(23))
            WRITE(nunit,7120,ERR=5040)
          ELSE
            WRITE(nunit,7121,ERR=5040)
          ENDIF
C         Write column headings depending on arb/abs units
          IF (arbabs .EQ. 'ABS' .OR. arbabs .EQ. 'abs') THEN
            IF(l.EQ.1)THEN
              WRITE(nunit,7240,ERR=5040)
            ELSE
              WRITE(nunit,7241,ERR=5040)
            ENDIF
7240        FORMAT(1x,'100: Frame    Moment(0) [cm^-2]    Moment(2)'
     +,' [cm^-4]'
     +,/,'-------------------------------------------------',/)
7241        FORMAT(1x,'Frame    Moment(0) [cm^-2]    Moment(2)'
     +,' [cm^-4]'
     +,/,'-------------------------------------------------',/)
            DO nframe=realtime(1),realtime(2),realtime(3)
C             Scale up
              moment(nframe,1)=moment(nframe,1)*1.E+8
              moment(nframe,3)=moment(nframe,3)*1.E+24
            END DO
          ELSE
            IF(l.EQ.1)THEN
              WRITE(nunit,7250,ERR=5040)
            ELSE
              WRITE(nunit,7251,ERR=5040)
            ENDIF
7250        FORMAT(1x,'100: Frame        Moment(0)            Moment(2)'
     +      ,/,'-------------------------------------------------',/)
7251        FORMAT(1x,'Frame        Moment(0)            Moment(2)'
     +      ,/,'-------------------------------------------------',/)
          ENDIF

          DO nframe=realtime(1),realtime(2),realtime(3)
            IF(l.EQ.1)THEN
              WRITE(nunit,7260,ERR=5040)nframe,
     +        moment(nframe,1),moment(nframe,3)
            ELSE
              WRITE(nunit,7261,ERR=5040)nframe,
     +        moment(nframe,1),moment(nframe,3)
            ENDIF
          END DO
7260      FORMAT(1x,'100: ',2x,I3,7x,E12.6,9x,E12.6)
7261      FORMAT(2x,I3,7x,E12.6,9x,E12.6)


C         Next lamella results (if there are any).
          IF(l.EQ.1)THEN
            CALL showprompt(prompt(23))
            WRITE(nunit,7170,ERR=5040)
          ELSE
            WRITE(nunit,7171,ERR=5040)
          ENDIF

C         Do block thicknesses and local cryst first
          IF(l.EQ.1)THEN
            WRITE(nunit,7270,ERR=5040)
          ELSE
            WRITE(nunit,7271,ERR=5040)
          ENDIF
7270      FORMAT(1x,'100: Frame    Long period    Av.Hard Block [A]'
     +,'    Av.Soft Block [A]    Local Cryst.',/,'-------'
     +,'--------------------------------------'
     +,'----------------------------------',/)
7271      FORMAT(1x,'Frame    Long period    Av.Hard Block [A]'
     +,'    Av.Soft Block [A]    Local Cryst.',/,'-------'
     +,'--------------------------------------'
     +,'----------------------------------',/)
          DO nframe=realtime(1),realtime(2),realtime(3)
            IF (reslam(nframe,1) .GT. 0.) THEN
              IF(l.EQ.1)THEN
                WRITE(nunit,7280,ERR=5040)nframe,reslam(nframe,1),
     +          reslam(nframe,2),reslam(nframe,3),reslam(nframe,5)
              ELSE
                WRITE(nunit,7281,ERR=5040)nframe,reslam(nframe,1),
     +          reslam(nframe,2),reslam(nframe,3),reslam(nframe,5)
              ENDIF
            ELSE
              WRITE(nunit,7290,ERR=5040)nframe
            ENDIF
          END DO
7280      FORMAT(1x,'100: ',2x,I3,5x,E12.6,5x,E12.6,9x,E12.6,7x,E12.6)
7281      FORMAT(2x,I3,5x,E12.6,5x,E12.6,9x,E12.6,7x,E12.6)
7290      FORMAT(1x,'WARNING: ',2x,I3,5x,
     +'Lamella interpretation failed')

C         Then do interfaces and bulk cryst.
          IF(l.EQ.1)THEN
            CALL showprompt(prompt(23))
            WRITE(nunit,7300,ERR=5040)
          ELSE
            WRITE(nunit,7301,ERR=5040)
          ENDIF
7300      FORMAT(//,1x,'100: Frame    Bulk Cryst.    Av.Core '
     +,'Thickness [A]    Av.Interface '
     +,'Thickness [A]',/,'-----------------------------'
     +,'-----------------------------------------------',/)
7301      FORMAT(//,1x,'Frame    Bulk Cryst.    Av.Core '
     +,'Thickness [A]    Av.Interface '
     +,'Thickness [A]',/,'-----------------------------'
     +,'-----------------------------------------------',/)
          DO nframe=realtime(1),realtime(2),realtime(3)
            IF (reslam(nframe,1) .GT. 0.) THEN
              IF(l.EQ.1)THEN
                WRITE(nunit,7310,ERR=5040)nframe,reslam(nframe,4),
     +          reslam(nframe,6),reslam(nframe,7)
              ELSE
                WRITE(nunit,7311,ERR=5040)nframe,reslam(nframe,4),
     +          reslam(nframe,6),reslam(nframe,7)
              ENDIF
            ELSE
              WRITE(nunit,7290,ERR=5040)nframe
            ENDIF
          END DO
7310      FORMAT(1x,'100: ',2x,I3,5x,E12.6,7x,E12.6,16x,E12.6)
7311      FORMAT(2x,I3,5x,E12.6,7x,E12.6,16x,E12.6)

C         Finally do the other things
          IF(l.EQ.1)THEN
            CALL showprompt(prompt(23))
            IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
              WRITE(nunit,7330,ERR=5040)
            ELSE
              WRITE(nunit,7320,ERR=5040)
            ENDIF
          ELSE
            IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
              WRITE(nunit,7331,ERR=5040)
            ELSE
              WRITE(nunit,7321,ERR=5040)
            ENDIF
          ENDIF
7320  FORMAT(//,1x,'100: Frame    Polydisp.   Elec.Dens.Contr.[Arb.]'
     +,'  Spec.Inner.Surf.[1/A]  Non-ideal',/,'---------------'
     +,'------------------'
     +,'-----------------------------------------------',/)
7330  FORMAT(//,1x,'100: Frame    Polydisp.   Elec.Dens.Contr.[cm^-2]'
     +,' Spec.Inner.Surf.[1/A]  Non-ideal',/,'---------------'
     +,'------------------'
     +,'-----------------------------------------------',/)
7321  FORMAT(//,1x,'Frame    Polydisp.   Elec.Dens.Contr.[Arb.]'
     +,'  Spec.Inner.Surf.[1/A]  Non-ideal',/,'---------------'
     +,'------------------'
     +,'-----------------------------------------------',/)
7331  FORMAT(//,1x,'Frame    Polydisp.   Elec.Dens.Contr.[cm^-2]'
     +,' Spec.Inner.Surf.[1/A]  Non-ideal',/,'---------------'
     +,'------------------'
     +,'-----------------------------------------------',/)
          DO nframe=realtime(1),realtime(2),realtime(3)
            IF (reslam(nframe,1) .GT. 0.) THEN
              IF(l.EQ.1)THEN
                WRITE(nunit,7340,ERR=5040)nframe,reslam(nframe,8),
     +          reslam(nframe,9),reslam(nframe,10),reslam(nframe,11)
              ELSE
                WRITE(nunit,7341,ERR=5040)nframe,reslam(nframe,8),
     +          reslam(nframe,9),reslam(nframe,10),reslam(nframe,11)
              ENDIF
            ELSE
              WRITE(nunit,7290,ERR=5040)nframe
            ENDIF
          END DO
7340      FORMAT(1x,'100: ',2x,I3,3x,E12.6,7x,E12.6,11x,E12.6,6x,E12.6)
7341      FORMAT(2x,I3,3x,E12.6,7x,E12.6,11x,E12.6,6x,E12.6)

C         End lamella results.

C         Then the Porod results - a right old dog's dinner (sorry).
          IF(l.EQ.1)THEN
            CALL showprompt(prompt(23))
            WRITE(nunit,7200,ERR=5040)
          ELSE
            WRITE(nunit,7201,ERR=5040)
          ENDIF
C         Check which model.
          IF (sigmodel .EQ. 'on' .OR. sigmodel .EQ. 'ON') THEN
C           Tailfit used sigmoid model.
            IF(l.EQ.1)THEN
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                WRITE(nunit,7350,ERR=5040)
              ELSE
                WRITE(nunit,7360,ERR=5040)
              ENDIF
            ELSE
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                WRITE(nunit,7351,ERR=5040)
              ELSE
                WRITE(nunit,7361,ERR=5040)
              ENDIF
            ENDIF
7350  FORMAT(1x,'100: Frame    Porod const.[cm^-5]    Sigma [A]    '
     +,'Cryst.    Elec.Dens.Contr.[cm^-2]',/,
     +'---------------------------------------------'
     +,'----------------------------------',/)
7360  FORMAT(1x,'100: Frame    Porod const. [Arb.]    Sigma [A]    '
     +,'Cryst.    Elec.Dens.Contr. [Arb.]',/,
     +'---------------------------------------------'
     +,'----------------------------------',/)
7351  FORMAT(1x,'Frame    Porod const.[cm^-5]    Sigma [A]    '
     +,'Cryst.    Elec.Dens.Contr.[cm^-2]',/,
     +'---------------------------------------------'
     +,'----------------------------------',/)
7361  FORMAT(1x,'Frame    Porod const. [Arb.]    Sigma [A]    '
     +,'Cryst.    Elec.Dens.Contr. [Arb.]',/,
     +'---------------------------------------------'
     +,'----------------------------------',/)

            DO nframe=realtime(1),realtime(2),realtime(3)
              IF (resporod(nframe,7) .GT. 0.) THEN
C             lamella morphology failed:-
                IF(l.EQ.1)THEN
                  WRITE(nunit,7370,ERR=5040)nframe,resporod(nframe,1),
     +            resporod(nframe,2),'  USER ',resporod(nframe,7)
                ELSE
                  WRITE(nunit,7371,ERR=5040)nframe,resporod(nframe,1),
     +            resporod(nframe,2),'  USER ',resporod(nframe,7)
                ENDIF
7370  FORMAT(1x,'100: ',2x,I3,8x,E12.6,6x,E12.6,3x,A7,8x,E12.6)
7371  FORMAT(2x,I3,8x,E12.6,6x,E12.6,3x,A7,8x,E12.6)
              ELSE
                IF(l.EQ.1)THEN
                  WRITE(nunit,7380,ERR=5040)nframe,resporod(nframe,1),
     +            resporod(nframe,2),'LAMELLA'
                ELSE
                  WRITE(nunit,7381,ERR=5040)nframe,resporod(nframe,1),
     +            resporod(nframe,2),'LAMELLA'
                ENDIF
7380  FORMAT(1x,'100: ',2x,I3,8x,E12.6,6x,E12.6,2x,A7)
7381  FORMAT(2x,I3,8x,E12.6,6x,E12.6,2x,A7)
              ENDIF
            END DO

          ELSE
C           Porod model - more complicated results.

C           First output the things that don't depend on cryst.
            IF(l.EQ.1)THEN
              WRITE(nunit,7390,ERR=5040)
            ELSE
              WRITE(nunit,7391,ERR=5040)
            ENDIF
7390        FORMAT(1x,'100: Results independent of crystallinity:-')
7391        FORMAT(1x,'Results independent of crystallinity:-')
            IF(l.EQ.1)THEN
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                WRITE(nunit,7400,ERR=5040)
              ELSE
                WRITE(nunit,7410,ERR=5040)
              ENDIF
            ELSE
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                WRITE(nunit,7401,ERR=5040)
              ELSE
                WRITE(nunit,7411,ERR=5040)
              ENDIF
            ENDIF
7400  FORMAT(/,1x,'100: Frame    Porod const.[cm^-5]    '
     +,'Chord Length [A]',/,
     +'---------------------------'
     +,'---------------------',/)
7410  FORMAT(/,1x,'100: Frame    Porod const. [Arb.]    '
     +,'Chord Length [A]',/,
     +'---------------------------'
     +,'---------------------',/)
7401  FORMAT(/,1x,'Frame    Porod const.[cm^-5]    '
     +,'Chord Length [A]',/,
     +'---------------------------'
     +,'---------------------',/)
7411  FORMAT(/,1x,'Frame    Porod const. [Arb.]    '
     +,'Chord Length [A]',/,
     +'---------------------------'
     +,'---------------------',/)

            DO nframe=realtime(1),realtime(2),realtime(3)
              IF(l.EQ.1)THEN
                WRITE(nunit,7420,ERR=5040)nframe,resporod(nframe,1),
     +          resporod(nframe,3)
              ELSE
                WRITE(nunit,7421,ERR=5040)nframe,resporod(nframe,1),
     +          resporod(nframe,3)
              ENDIF
7420          FORMAT(1x,'100: ',1x,I3,8x,E12.6,11x,E12.6)
7421          FORMAT(1x,I3,8x,E12.6,11x,E12.6)
            END DO

C           Then output the things that do depend on crystallinity.
            IF(l.EQ.1)THEN
              CALL showprompt(prompt(23))
              WRITE(nunit,7430,ERR=5040)
            ELSE
              WRITE(nunit,7431,ERR=5040)
            ENDIF
7430        FORMAT(//,1x,'100: Results dependent on crystallinity:')
7431        FORMAT(//,1x,'Results dependent on crystallinity:')

C           Check abs units
            IF(l.EQ.1)THEN
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                WRITE(nunit,7440,ERR=5040)
              ELSE
                WRITE(nunit,7450,ERR=5040)
              ENDIF
            ELSE
              IF (arbabs .EQ. 'abs' .OR. arbabs .EQ. 'ABS') THEN
                WRITE(nunit,7441,ERR=5040)
              ELSE
                WRITE(nunit,7451,ERR=5040)
              ENDIF
            ENDIF
7440  FORMAT(/,1x,'100: Frame  Cryst  HardChord[A]  SoftChord[A]  '
     +,'Surf:Vol[1/A]  Elec.Dens.Contr.[cm^-2]',/,
     +'------------------------------------------------'
     +,'----------------------------------',/)
7450  FORMAT(/,1x,'100: Frame  Cryst  HardChord[A]  SoftChord[A]  '
     +,'Surf:Vol[1/A]  Elec.Dens.Contr.[Arb.]',/,
     +'------------------------------------------------'
     +,'----------------------------------',/)
7441  FORMAT(/,1x,'Frame  Cryst  HardChord[A]  SoftChord[A]  '
     +,'Surf:Vol[1/A]  Elec.Dens.Contr.[cm^-2]',/,
     +'------------------------------------------------'
     +,'----------------------------------',/)
7451  FORMAT(/,1x,'Frame  Cryst  HardChord[A]  SoftChord[A]  '
     +,'Surf:Vol[1/A]  Elec.Dens.Contr.[Arb.]',/,
     +'------------------------------------------------'
     +,'----------------------------------',/)

            DO nframe=realtime(1),realtime(2),realtime(3)
              IF (resporod(nframe,7) .GT. 0.) THEN
C               Lamella interpretation failed
                IF(l.EQ.1)THEN
                  WRITE(nunit,7460,ERR=5040)nframe,'USER',
     +            resporod(nframe,4),resporod(nframe,5),
     +            resporod(nframe,6),resporod(nframe,7)
                ELSE
                  WRITE(nunit,7461,ERR=5040)nframe,'USER',
     +            resporod(nframe,4),resporod(nframe,5),
     +            resporod(nframe,6),resporod(nframe,7)
                ENDIF
              ELSE
C               Lamella interpretation worked
                IF(l.EQ.1)THEN
                  WRITE(nunit,7470,ERR=5040)nframe,'LAMLA',
     +            resporod(nframe,4),resporod(nframe,5),
     +            resporod(nframe,6)
                ELSE
                  WRITE(nunit,7471,ERR=5040)nframe,'LAMLA',
     +            resporod(nframe,4),resporod(nframe,5),
     +            resporod(nframe,6)
                ENDIF
              ENDIF
            END DO
7460  FORMAT(1x,'100: ',I3,3x,A5,2x,E12.6,2x,E12.6,2x,E12.6,8x,E12.6)
7470  FORMAT(1x,'100: ',I3,3x,A5,2x,E12.6,2x,E12.6,2x,E12.6)
7461  FORMAT(1x,I3,3x,A5,2x,E12.6,2x,E12.6,2x,E12.6,8x,E12.6)
7471  FORMAT(1x,I3,3x,A5,2x,E12.6,2x,E12.6,2x,E12.6)

C         End choice of model
          ENDIF

C       End check on single frame or realtime.
        ENDIF

C       End results file.
        IF(l.EQ.1)THEN
          CALL showprompt(prompt(23))
          WRITE(nunit,7480,ERR=5040)
        ELSE
          WRITE(nunit,7481,ERR=5040)
        ENDIF

7480    FORMAT(//,1x,'100: END OF CORRELATION FUNCTION RESULTS.')
7481    FORMAT(//,1x,'END OF CORRELATION FUNCTION RESULTS.')

C     End loop through output units
      END DO

      CLOSE(nout(2))

C     The end of the entire session...
      CALL showprompt(prompt(14))
      WRITE(6,*)

C     End program.
      CALL showprompt(prompt(20))
      STOP


C     Error Catches:

C     Error reading corfunc.txt
5000  CALL showprompt(prompt(5))
      STOP

C     Error reading extract.txt
5010  CALL showprompt(prompt(1))
      STOP

C     Error reading in correlation function otoko files.
5030  CALL showprompt(prompt(6))
      STOP

C     Error writing result file.
5040  CALL showprompt(prompt(11))
      STOP

      STOP
      END



      SUBROUTINE diffpoly(polynom)
C     Differentiates the polynomial whose coefficients are stored in
C     the array "polynom" algebraically.
      INTEGER MaxDim
      PARAMETER (MaxDim=2048)
      DIMENSION polynom(MaxDim,5)

C     Loop through polynomials.
      DO i=1,MaxDim
C       Loop through coeffs
        DO j=1,4
C         Differentiate:
          polynom(i,j)=polynom(i,j+1)*FLOAT(j)
        END DO
        polynom(i,5)=0.
      END DO
      RETURN
      END



      SUBROUTINE evalpoly(polynom,x,y)
C     Evaluates the polynomial stored in the array "polynom"
C     at the point x.
      INTEGER MaxDim
      PARAMETER (MaxDim=2048)
      DIMENSION polynom(MaxDim,5),x(MaxDim),y(MaxDim)

C     Loop through points
      DO npoint=1,MaxDim
        xx=x(npoint)
C       Evaluate polynomial.
        sum=0.
C       Loop through powers of x
        DO i=1,5
          IF (polynom(npoint,i) .NE. 0.) THEN
            sum=sum+polynom(npoint,i)*(xx**(i-1))
          ENDIF
        END DO
        y(npoint)=sum
      END DO
      RETURN
      END



      SUBROUTINE laginterp(xdata,ydata,nstart,nend,polynom)
C     Fits a 4th degree polynomial to the data points
C     specified by nstart and nend. The coefficients of the
C     polynomial are placed in the array "polynom".
C     Traditional Lagrangian interpolation.
C     Reference: any book on numerical analysis.

      INTEGER MaxDim
      PARAMETER (MaxDim=2048)
      DIMENSION xdata(MaxDim),ydata(MaxDim),polynom(MaxDim,5),coeff(5)
      INTEGER nstart,nend

1000  FORMAT(/,1x,'ERROR: Error in subroutine laginterp: FATAL')

C     get number of points
      npts=nend-nstart+1

C     Check for errors
      IF (npts .LE. 0) THEN
        WRITE(6,1000)
        STOP
      ENDIF

C     Loop through points
      DO npoint=nstart,nend

C       Reset polynomial coefficients.
        DO i=1,5
          polynom(npoint,i)=0.
        END DO

C       Loop through the terms in the Lagrangian "formula".
        DO nterm=npoint-2,npoint+2

C         Get denominator.
          denom=1.
          DO i=npoint-2,npoint+2
            IF (i .NE. nterm) THEN
              factor=xdata(nterm)-xdata(i)
              denom=denom*factor
            ENDIF
          END DO

C         Reset  the array "coeff"
          DO i=1,5
            coeff(i)=0.
          END DO

C         Initialise "coeff"
          coeff(1)=1.

C         Loop through factors in the numerator, multiplying the polynomial
C         effectively stored in "coeff" by each factor.
          DO i=npoint-2,npoint+2
C           Check to see whether the current factor is actually in this term.
            IF (i .NE. nterm) THEN
C             Multiply by factor: update "coeff".
C             Multiply by x
              DO j=5,2,-1
                coeff(j)=coeff(j-1)
              END DO
              coeff(1)=0.
C             Multiply by constant term.
              DO j=1,4
                coeff(j)=coeff(j)-coeff(j+1)*xdata(i)
              END DO
            ENDIF
          END DO

C         Now add the polynomial stored in "coeff" onto "polynom".
          DO i=1,5
            polynom(npoint,i)=polynom(npoint,i)+
     +      coeff(i)*ydata(nterm)/denom
          END DO

C       End loop through terms in the formula.
        END DO

C     End loop through points.
      END DO

C     We're done!

      RETURN
      END
