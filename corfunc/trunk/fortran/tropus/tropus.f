      PROGRAM TROPUS4

*********************************************************************************
*                                                                               *
*     PROGRAM TO INVERT I0(Q) TERM FROM SMALL-ANGLE NEUTRON SCATTERING DATA     *
*                                                                               *
*********************************************************************************
*                                                                               *
*     Based on program TLPHAS originally written for PDP/TSX                    *
*     (C)1984 Trevor Crowley, University of Bristol, UK                         *
*                                                                               *
*     Modified for use on VAX/VMS (Program TROPUS)                              *
*     (C)Terry Cosgrove, University of Bristol, UK                              *
*     Modified for use on IBM PCs (Program PCPHASE)                             *
*     (C)Terry Cosgrove, University of Bristol, UK                              *
*     PCPHASE revised for VAX/VMS (Program TROPUS2)                             *
*     (C)Steve King, ISIS Facility, Rutherford Appleton Laboratory, UK          *
*     TROPUS2 made a GENIE function (Program TROPUS3)                           *
*     (C)Steve King, ISIS Facility, Rutherford Appleton Laboratory, UK          *
*     TROPUS3 made a CORFUNC subroutine (Program TROPUS4)                       *
*     (C)Steve King, ISIS Facility, Rutherford Appleton Laboratory, UK          *
*                                                                               *
*********************************************************************************
*
*     S King, July 2004
*	Array bounds raised from 2048 --> 4096 because CORFUNC extrapolations have
*	2048 points and program falls over when filling yvec otherwise!
*
*********************************************************************************

	real*4	 work(4096)
	real*4       rescale2z,density,gamma,norm,atx,xstep,yis,dyis
	real*4	 integral,rescale,delta,change
	real*4       spanint,span,boundfrac,z1,z2,rms,sigma
	integer*4    n,nqdata,spanchan,npower,j,limitq
	character*1  qisang
	character*3  ident
	character*80 prompt(7),fname

	real*4       x(4096),y(4096),e(4096),xx(4096),yy(4096)
	real*8       yvec(2,4096)
	real*8       dx,dk,rotx,rotk,ri

	common/fft/yvec,n0,m0

      prompt(1)='ERROR: Files have different numbers of channels: FATAL'
      prompt(2)='ERROR: More than 2048 channels in extrapolation: FATAL'
      prompt(3)='ERROR: 0.5 < density < 2.0: FATAL'
      prompt(4)='ERROR: 0 < adsorbed amount < 100: FATAL'
      prompt(5)='ERROR: 0.0 < difference < 1.0: FATAL'
	prompt(6)='ERROR: Axis units not specified.  Cannot normalise: FATAL'
	prompt(7)='WARNING: Unusual normalisation value.  Will use 1.0'

*	OPEN JOURNAL FILE
	open(1,file='tropus.txt',form='formatted',status='unknown')

*==============================================================================
*	GET DATA & PARAMETERS
*==============================================================================

*1000	format(' Extrapolated DATA filename [???FU2.TXT - enter first 3 characters]? ',$)
1000	format(' Extrapolated DATA filename [???FUL.TXT - enter first 3 characters]? ',$)
1001	format(a3,$)
1002	format(' Reading file: ',a10)
1003	format(' Data has',i5,' channels')
1004	format(' Is the Q-axis in units of PER ANGSTROM ........................[y]? ',$)
1005	format(a1,$)
1006	format(' Bulk density of adsorbed polymer .........................[g/cm^3]? ',$)
1007	format(' Adsorbed amount ..........................................[mg/m^2]? ',$)
1008	format(f12.5,$)
1009	format(' Normalisation factor is',f8.3)
1010	format(' Profile can differ from normalisation by what amount .............? ',$)
1015	format(' Integral is: ',f12.5,'      Difference from Normalisation factor: ',f12.5)
1016	format(' (NORM-INTEGRAL): ',f12.5,' RESCALE: ',f12.5,' CHANGE: ',f12.5)
1020	format(' Writing file: ',a10)

10	write(6,1000)
	read(5,1001,err=10)ident
C	SMK, 19/08/04
C	The CORFUNC FU2 file has a background added to it, the FUL file doesn't
*	fname=ident//'FU2.TXT'
	fname=ident//'FUL.TXT'
	write(6,1002)fname
	write(1,1002)fname
	call load_data(fname,n,y)

	fname=ident//'FLX.TXT'
	write(6,1002)fname
	write(1,1002)fname
	call load_data(fname,nqdata,x)

20	qisang='y'
	write(6,1004)
	read(5,1005,err=20)qisang
	if ((qisang.eq.' ').or.(qisang.eq.'y').or.(qisang.eq.'Y')) then
	   rescale2z=10.0
	else if ((qisang.eq.'n').or.(qisang.eq.'N')) then
	   rescale2z=1.0
	else
	   rescale2z=0.0
	end if
	if (rescale2z.eq.0.0) call showprompt(prompt(6))
	if (rescale2z.eq.0.0) goto 9999
	write(1,'(a2)')qisang

30	write(6,1006)
	read(5,1008,err=30)density
	if ((density.gt.0.5).and.(density.lt.2.0)) goto 40
	call showprompt(prompt(3))
	goto 9999

40	write(6,1007)
	read(5,1008,err=40)gamma
	if ((gamma.gt.0.0).and.(gamma.lt.100.0)) goto 50
	call showprompt(prompt(4))
	goto 9999

*	DENSITY IS INPUT IN G/CM^3, GAMMA IS INPUT IN MG/M^2
*	WHICH MEANS THAT NORM=(GAMMA/DENSITY) IS A LENGTH; x10^-7 CM
*	SO HAVE TO SCALE BY x10 IF Z-AXIS IS ANGSTROMS
50	if ((qisang.eq.' ').or.(qisang.eq.'y').or.(qisang.eq.'Y')) then
	   norm=10.0*gamma/density
	else if ((qisang.eq.'n').or.(qisang.eq.'N')) then
	   norm=gamma/density
	else
	   norm=1.0
	   call showprompt(prompt(7))
	end if
	write(6,1009)norm
	write(1,'(f12.5)')density
	write(1,'(f12.5)')gamma
	write(1,1009)norm

60	write(6,1010)
	read(5,1008,err=60)delta
	if ((delta.gt.0.0).and.(delta.lt.1.0)) goto 70
	call showprompt(prompt(5))
	goto 9999

70	write(1,'(f12.5)')delta
	continue

*==============================================================================
*	PREPROCESSING OF DATA
*==============================================================================

1	if (nqdata.ne.n) goto 8001
	if (n.gt.2048) goto 8002
*	LET'S MAKE THINGS MORE MANAGEABLE!
	n=n/2
	if (mod(n,2).ne.0) n=n+1
	write(6,1003)n
	write(1,1003)n
	write(6,*)'Interpolating for equally-spaced q-intervals...'
*	INTERPOLATE THE DATA SET
*	S King, August 2004
*
*	Tropus requires that the input data has a q-axis with equally-spaced
*	points.  The data just read in though is only equally-spaced in each
*	of the low-q, original, and tail-fitted data ranges.  So need to run
*	an interpolation function through them all in one go.
*
*	But can't use the Savitsky-Golay routine as Corfunc does because
*	it is designed for equally-spaced X-data!  So here we use a generic
*	polynomial interpolation from Numerical Recipies.
*	Thanks to Richard Heenan for this suggestion.
*
*	XSTEP IS EQUALLY-SPACED X INCREMENT
      xstep=(x(n)-x(1))/float(n-1)
      atx=x(1)
*	NPOWER=4 FITS A CUBIC THROUGH 4 POINTS
*	NPOWER SHOULD BE AN EVEN NUMBER
      npower=4
      j=1
      do i=1,n
         do while ((j.lt.(n-npower+1)).and.(atx.gt.x(j+npower/2)))
            j=j+1
         end do
         yis=0.
         dyis=0.
	   e(i)=0.
*	   POLINT USES NPOWER CONSECUTIVE POINTS OF X()
*	   I.E. X(J) TO X(J+NPOWER-1)
*	   X() IS ASSUMED INCREASING BUT NOT IN EQUAL INTERVALS
*	   ATX SHOULD BE BETWEEN THE MIDDLE TWO POINTS, **EXCEPT**
*	   AT THE START AND END OF X()
         call polint(x(j),y(j),npower,atx,yis,dyis)
         xx(i)=atx
         yy(i)=yis
         e(i)=dyis
         atx=atx+xstep
      end do
*	NOW WRITE THE INTERPOLATED VALUES BACK INTO THE INITIAL DATA ARRAYS
	do i=1,n
	   x(i)=xx(i)
	   y(i)=yy(i)
	   xx(i)=0.
	   yy(i)=0.
	end do
*	WRITE INTERPOLATED DATA
	fname=ident//'INT.TXT'
	write(6,1020)fname
	write(1,1020)fname
	call save_data(fname,n,x,y)
*	SET ANY NEGATIVE OR ZERO INTENSITIES TO A VERY SMALL POSITIVE VALUE
	do i=1,n
	   if (y(i).le.0.) y(i)=1.0e-08
         if (y(i).le.0.) write(6,*)'Setting negative and zero intensities to 0.00000001...'
	end do
	write(6,*)'Multiplying intensities by Q-squared...'
*	MULTIPLY INTENSITES BY Q-SQUARED
	do i=1,n
	   y(i)=y(i)*(x(i)*x(i))
	end do

*==============================================================================
*	MAIN PROGRAM
*==============================================================================

*	SHIFT FACTOR ROTX SET EQUAL TO ZERO FOR HALF POINT FORMAT
1030	n0=2*n
	n2=n-1
	rotk=0.d0
	rotx=-0.5d0
**	write(6,*)'Setting up function parameters...'
*	SET UP FUNCTION PARAMETERS
*	READ FTC ZERO PT.
	dk=dble((x(n)-x(1))/dfloat(n-1))
*     M Rodman, April 2004
*	INITIALISE YVEC ARRAY  
      do 1035 ll=1,2048
	   yvec(1,ll)=0d0
	   yvec(2,ll)=0d0
1035  continue
*	CENTRAL POINT IN YVEC(N0/2+1) FROM Y(1), IE WHERE Q=0
	yvec(1,n+1)=dble(y(1))
	yvec(2,n+1)=0.d0
*	FIRST POINT YVEC(1) LEFT OVER.  TRY PUTTING EQUAL TO YVEC(2), 0.0, etc
	yvec(1,1)=dble(y(n))
	yvec(2,1)=0.d0
*	REST OF YVEC FILLED FROM Y BY REFLECTION ABOUT Q=0
	do 1040 ll=2,n
	   yvec(1,n+ll)=dble(y(ll))
	   yvec(2,n+ll)=0.d0
	   yvec(1,n-ll+2)=dble(y(ll))
	   yvec(2,n-ll+2)=0.d0
1040	continue
**	write(6,*)'Calling rephase...'
	call rephase(dk,dx,rotx)
	do 1050 ll=1,n
	   xx(ll)=sngl(float(ll-1)*dx-rotx*dx)
*	   yy(ll)=sngl(yvec(1,ll+n))
	   yy(ll)=abs(sngl(yvec(1,ll+n)))
1050	continue

*==============================================================================
*	POST PROCESSING OF TRANSFORMED DATA
*==============================================================================

*	RESCALE SEGMENT DENSITY TO THE Z-AXIS UNITS
*	x10 IF PER ANGSTROM
*	 x1 IF PER NANOMETRE
	write(6,*)'Rescaling segment density to the z-axis units...'
	do 1060 ll=1,n
	   yy(ll)=yy(ll)*rescale2z
1060	continue
*	OUTPUT SEGMENT DENSITY PROFILE
	fname=ident//'SDP.TXT'
	write(6,1020)fname
	write(1,1020)fname
	call save_data(fname,n,xx,yy)
*	THEN RESCALE SO THAT THE AREA UNDER THE DISTRIBUTION
*	MATCHES THE KNOWN ADSORBED AMOUNT
	write(6,*)'Integrating under distribution...'
	rescale=1.0
	change=1.0
1070	integral=0.0
	call trapiz(xx,yy,n,1,integral)
*	write(1,1016)norm-integral,rescale,change
	if (abs(norm-integral).lt.delta) goto 1090
	if ((norm-integral).gt.delta) then
	   rescale=rescale*(1+change)
	   change=rescale/1.61803399
	else if ((norm-integral).lt.delta) then
	   rescale=rescale/(1+change)
	   change=rescale*3.14159265
	else
	   rescale=-1.0
	end if
	if (rescale.eq.-1.0) goto 1090
	do 1080 ll=1,n
	   yy(ll)=yy(ll)*rescale
1080	continue
	goto 1070
1090	write(6,*)'Normalised integral to adsorbed amount...'
	write(1,1015)integral,(norm-integral)

*==============================================================================
*	EXTRACT PARAMETERS
*==============================================================================

*	EXTENT OF PROFILE
	span=0.0
	spanchan=n
1100	spantint=0.0
	call trapiz(xx,yy,spanchan,1,spanint)
	if (spanint.le.(0.95*integral)) goto 1110
	spanchan=spanchan-1
	goto 1100
1110	span=xx(spanchan)

*	BOUND FRACTION
	if ((qisang.eq.'y').or.(qisang.eq.'Y').or.(qisang.eq.' ')) then
	   ll=1
1120	   if (xx(ll).gt.10.0) goto 1140
	   ll=ll+1
	   goto 1120
	else if ((qisang.eq.'n').or.(qisang.eq.'n')) then
	   ll=1
1130	   if (xx(ll).gt.1.0) goto 1140
	   ll=ll+1
	   goto 1130
	end if
1140	boundfrac=0.0
	call trapiz(xx,yy,ll,1,boundfrac)
	boundfrac=boundfrac/integral

*	MOMENT-WEIGHTED DISTRIBUTIONS
*	FOR <z^1>
	do ll=1,n
	   work(ll)=yy(ll)*xx(ll)
	end do
	z1=0.0
	call trapiz(xx,work,spanchan,1,z1)
	z1=z1/integral
*	FOR <z^2>
	do ll=1,n
	   work(ll)=yy(ll)*xx(ll)*xx(ll)
	end do
	z2=0.0
	call trapiz(xx,work,spanchan,1,z2)
	z2=z2/integral
	rms=sqrt(z2)
	sigma=sqrt(z2-(z1*z1))

7000	format(' Bound fraction ..........: ',f12.5)
7010	format(' Span .........[Angstroms]: ',f12.5)
7020	format(' Span ................[nm]: ',f12.5)
7030	format(' RMS thickness [Angstroms]: ',f12.5)
7040	format(' RMS thickness .......[nm]: ',f12.5)
7050	format(' Second moment [Angstroms]: ',f12.5)
7060	format(' Second moment .......[nm]: ',f12.5)

	write(6,7000)boundfrac
	write(1,*)' '
	write(1,7000)boundfrac
	if ((qisang.eq.'y').or.(qisang.eq.'Y').or.(qisang.eq.' ')) then
	   write(6,7010)span
	   write(6,7030)rms
	   write(6,7050)sigma
	   write(1,7010)span
	   write(1,7030)rms
	   write(1,7050)sigma
	else if ((qisang.eq.'n').or.(qisang.eq.'n')) then
	   write(6,7020)span
	   write(6,7040)rms
	   write(6,7060)sigma
	   write(1,7020)span
	   write(1,7040)rms
	   write(1,7060)sigma
	end if

*==============================================================================
*	WRITE DATA
*==============================================================================

*	DIFFERENCE BETWEEN INTERPOLATION ERROR ESTIMATE
	fname=ident//'ERR.TXT'
	write(6,1020)fname
	write(1,1020)fname
	call save_data(fname,n,x,e)

*	VOLUME FRACTION PROFILE
	fname=ident//'VFR.TXT'
	write(6,1020)fname
	write(1,1020)fname
	call save_data(fname,n,xx,yy)

	write(6,*)' '
	write(1,*)' '
	write(6,*)'END OF VOLUME FRACTION PROFILE ANALYSIS'
	write(1,*)'END OF VOLUME FRACTION PROFILE ANALYSIS'

	goto 9999

*==============================================================================
*	ERROR MESSAGES
*==============================================================================

8001  call showprompt(prompt(1))
      goto 9999

8002  call showprompt(prompt(2))
      goto 9999


9999	close(1)
	end


*==============================================================================
*	SUBROUTINES FOR PHASE RECOVERY
*==============================================================================


	subroutine rephase(dk,dx,rotx)
*	CARRIES OUT INVERSION FOR INTENSITY IN REAL PART OF YVEC
*	IN 0 PT. FORMAT (SHOULD BE SYMMETRICAL)
*	RETURNS DENSITY IN REAL PART OF YVEC
*	IN FORMAT SPECIFIED BY ROTX E.G. ROTX=-0.6,0.
*	REQUIRES INPUT OF DK,OUTPUTS DX
	common/fft/yvec,n0,m0
	real*8 yvec(2,4096)
	real*8 rst0,rotx,dk,dx

	rst0=yvec(1,n0/2+1)
c	write(6,*)'Calling tlz...'
	call tlz(1)
c	write(6,*)'Calling vlog...'
	call vlog
c	write(6,*)'Calling diff...'
	call diff
c	write(6,*)'Calling disp...'
	call disp
	rst0=0.5d0*dlog(rst0)
c	write(6,*)'Calling integ...'
	call integ(rst0)
c	write(6,*)'Calling vexp...'
	call vexp
c	write(6,*)'Calling tlfft0...'
	call tlfft0(-1.d0,dk,dx,0.0d0,rotx)
	return
	end


	subroutine diff
*	IN SITU DIFFERENTIATION(I.P.0 PT TO HALF PT)
*	ONLY NECESSARY TO DIFF. REAL PART AS IMAG PART ZEROED
	common/fft/yvec,n0,m0
	real*8 yvec(2,4096)
	real*8 yst

	yst=yvec(1,1)
	do 100 ll=1,n0-1
	   yvec(1,ll)=yvec(1,ll+1)-yvec(1,ll)
100	continue
	yvec(1,n0)=yst-yvec(1,n0)
	return
	end


	subroutine integ(y0)
*	IN SITU INTEGRATION ROUTINE(I.P. HALF PT TO 0 PT)
*	INPUT Y0 AS VALUE AT ZERO
	common/fft/yvec,n0,m0
	real*8 yvec(2,4096)
	real*8 yst(2),yst1(2),y0

	n2=n0/2
	yst(1)=yvec(1,n2+1)
	yst(2)=yvec(2,n2+1)
*	SET INITIAL VALUE
	yvec(1,n2+1)=y0
	yvec(2,n2+1)=0.d0
*	INTEGRATE IN POSITIVE DIRECTION
*	TAKING CARE NOT TO OVERWRITE ARRAY
	do 100 ll=n2+2,n0
	   do 101 ire=1,2
	      yst1(ire)=yst(ire)
	      yst(ire)=yvec(ire,ll)
	      yvec(ire,ll)=yvec(ire,ll-1)+yst1(ire)
101	   continue
100	continue
*	INTEGRATE IN NEGATIVE DIRECTION
	do 120 ll=n2,1,-1
	   do 121 ire=1,2
	      yvec(ire,ll)=yvec(ire,ll+1)-yvec(ire,ll)
121	   continue
120	continue
	return
	end


	subroutine disp
*	DISPERSION INTEGRAL ROUTINE
*	HALF POINT I/O
	common/fft/yvec,n0,m0
	real*8 yvec(2,4096)
	real*8 risfl,dx1,dx2,rotx,rotk

	dx1=1.d0
*	DX1 ARBITRARY
	risfl=-1.d0
	rotx=-0.5d0
	rotk=rotx
*	INVERSE HALF-PT TRANSFORM
	call tlfft0(risfl,dx1,dx2,rotk,rotx)
*	MULTIPLY BY 2*HEAVISIDE STEP FUNCTION
	do 100 ll=1,n0/2
	   yvec(1,ll)=0.0d0
	   yvec(2,ll)=0.0d0
100	continue
	do 110 ll=n0/2+1,n0
	   yvec(1,ll)=2.0d0*yvec(1,ll)
	   yvec(2,ll)=2.0d0*yvec(2,ll)
110	continue
	risfl=-risfl
*	DIRECT HALF-PT. TRANSFORM
	call tlfft0(risfl,dx2,dx1,rotx,rotk)
	return 
	end


	subroutine tlz(iz)
*	TO ZERO REAL OR IMAG PART OF YVEC
*	IZ=0 FOR REAL,IZ=1 FOR IMAG
	common/fft/yvec,n0,m0
	real*8 yvec(2,4096)

	ire=iz+1
	do 100 ll=1,n0
	   yvec(ire,ll)=0.d0
100	continue
	return
	end


	subroutine vlog
*	NEED ONLY OPERATE ON REAL PART
*	FACTOR OF 0.5 TO TAKE SQUARE ROOT OF INTENSITY
*	TO GIVE MODULUS OF FT
	common/fft/yvec,n0,m0
	real*8 yvec(2,4096)

	do 100 ll=1,n0
	yvec(1,ll)=0.5d0*dlog(yvec(1,ll))
100	continue
	return
	end


	subroutine vexp
*	COMPLEX EXPONENTIAL
	common/fft/yvec,n0,m0
	real*8 yvec(2,4096)
	real*8 yr,yi

	do 100 ll=1,n0
	   yr=yvec(1,ll)
	   yi=yvec(2,ll)
	   yr=dexp(yr)
	   yvec(1,ll)=yr*dcos(yi)
	   yvec(2,ll)=yr*dsin(yi)
100	continue
	return
	end


	subroutine tlfft0(risfl,dx1,dx2,rot1,rot2)
	common/fft/y2,n0,m0
	real*8 y2(2,4096)
	real*8 rn0,risfl,dx1,dx2,rot1,rot2
	real*8 pi2,frac,gam

	pi2=6.28318530718002d0
	ialt=1
	m0=il2(n0)
	rn0=dble(float(n0))
	frac=-risfl*rot2/rn0
	call vphas0(frac,ialt)
	call tldft0(risfl)
	frac=-risfl*rot1/rn0
	call vphas0(frac,ialt)
	frac=risfl*((rot1*rot2)/rn0+0.5d0*(rot1+rot2))
	if(risfl.gt.0.d0)gam=dx1
	if(risfl.lt.0.d0)gam=dx1/pi2
	call vphc0(frac,gam)
	dx2=pi2/(rn0*dx1)
	return
	end


	subroutine tldft0(risfl)
*	HOME MADE FFT ROUTINE,USING COMPLEX ARITMETIC
*	INPUT COMPLEX YVEC(1-N0) ,N0,M0
*	WHERE M=2**N
	common/fft/y2,n0,m0
	real*8 y2(2,4096)
	real*8 yst1(2),ph(2),ph1(2),ph0(2),phs(2),dd(2)
	real*8 pi,one,zero,half,theta,risfl

	pi=3.1415926544d0
	one=1.0d0
	zero=0.0d0
	half=0.5d0
	call scr0
	ph0(1)=-one
	ph0(2)=zero
	ph1(1)=-one
	ph1(2)=zero
	theta=pi
	inc=1
	nbl2=n0
	do 100 nu=1,m0
	   ph(1)=one
	   ph(2)=zero
	   nbl2=nbl2/2
	   do 110 l1=1,inc
	      lb1=l1
	      lb2=lb1+inc
	      do 120 l2=1,nbl2
	         yst1(1)=y2(1,lb1)
	         yst1(2)=y2(2,lb1)
	         dd(1)=ph(1)*y2(1,lb2)-ph(2)*y2(2,lb2)
	         dd(2)=ph(1)*y2(2,lb2)+ph(2)*y2(1,lb2)
	         y2(1,lb1)=yst1(1)+dd(1)
	         y2(2,lb1)=yst1(2)+dd(2)
	         y2(1,lb2)=yst1(1)-dd(1)
	         y2(2,lb2)=yst1(2)-dd(2)
	         lb1=lb2+inc
	         lb2=lb1+inc
120	      continue
	      phs(1)=ph(1)
	      phs(2)=ph(2)
	      ph(1)=ph0(1)*phs(1)-ph0(2)*phs(2)
	      ph(2)=ph0(1)*phs(2)+ph0(2)*phs(1)
110	   continue
	   theta=half*theta
	   ph1(1)=dcos(theta)
	   ph1(2)=dsin(theta)
	   ph0(1)=ph1(1)
	   ph0(2)=risfl*ph1(2)
	   inc=inc+inc
100	continue
	return
	end


	subroutine scr0
*	BITWISE SCRAMBLING OF YVEC -USED IN TLDFT0
	common/fft/y2,ns,ms
	real*8 y2(2,4096)
	real*8 yst(2)

	do 100 ll=1,ns
	   j=ll-1
	   ibitr=0
	   do 200 i=1,ms
	      j2=j/2
	      ibitr=ibitr+ibitr+j-j2-j2
	      j=j2
200	   continue
	   i=ibitr+1
	   if(i.le.ll)goto 100
	   yst(1)=y2(1,ll)
	   yst(2)=y2(2,ll)
	   y2(1,ll)=y2(1,i)
	   y2(2,ll)=y2(2,i)
	   y2(1,i)=yst(1)
	   y2(2,i)=yst(2)
100	continue
	return
	end


	function il2(n0)
*	LOG2 OF N0
	il2=0
	n1=1
50	n1=n1+n1
	if (n1.gt.n0) return
	il2=il2+1
	goto 50
	end


	subroutine vphc0(frac,gam)
*	MULTIPLIES Y2 BY CONST GAM AND VPHASE(FRAC)
	common/fft/y2,ns,ms
	real*8 y2(2,4096)
	real*8 theta,pi2,frac,gam,ph(2),yst(2),deps

	deps=1.d-10
	pi2=6.28318530718002d0
	if (dabs(frac).lt.deps) goto 200
	theta=pi2*frac
	ph(1)=dcos(theta)
	ph(2)=dsin(theta)
	do 100 ll=1,ns
	   yst(1)=y2(1,ll)
	   yst(2)=y2(2,ll)
	   y2(1,ll)=gam*(ph(1)*yst(1)-ph(2)*yst(2))
	   y2(2,ll)=gam*(ph(1)*yst(2)+ph(2)*yst(1))
100	continue
	return
200	do 210 ll=1,ns
	   y2(1,ll)=gam*y2(1,ll)
	   y2(2,ll)=gam*y2(2,ll)
210	continue
	return
	end


	subroutine vphas0(frac,ialt)
*	MULTIPLIES Y2(LL) BY EXP(2*PI*FRAC*LL)
*	ALTERNATES SIGN IF IALT=1
	common/fft/y2,ns,ms
	real*8 y2(2,4096)
	real*8 theta,pi2,frac,ph(2),yst(2),ph0(2),phst(2),deps

	deps=1.d-10
	if(dabs(frac).lt.deps)goto 200
	pi2=6.28318530718002
	theta=pi2*frac
	ph0(1)=dcos(theta)
	ph0(2)=dsin(theta)
	ph(1)=1.
	ph(2)=0.
	do 100 ll=2,ns
	   yst(1)=y2(1,ll)
	   yst(2)=y2(2,ll)
	   phst(1)=ph(1)
	   phst(2)=ph(2)
	   ph(1)=ph0(1)*phst(1)-ph0(2)*phst(2)
	   ph(2)=ph0(1)*phst(2)+ph0(2)*phst(1)
	   y2(1,ll)=ph(1)*yst(1)-ph(2)*yst(2)
	   y2(2,ll)=ph(1)*yst(2)+ph(2)*yst(1)
100	continue
200	if (.not.ialt.eq.1) return
	do 1010 ll=2,ns,2
	   y2(1,ll)=-y2(1,ll)
	   y2(2,ll)=-y2(2,ll)
1010	continue
	return
	end


	subroutine xft0(xx,ll,dx,rot,n0)
	common/ln/icln,k0
	real*8 dx,rot,xx,k0

	xx=(dble(float(ll-n0/2-1))-rot)*dx
	if (icln.eq.1) xx=k0*dexp(xx)
	return
	end


*==============================================================================
*	SUBROUTINE FOR INTEGRATION
*==============================================================================


	subroutine trapiz(x_data_array,y_data_array,channels,start,sum)
	real*4 x_data_array(4096),y_data_array(4096)
	real*4 sum
	integer*4 channels,start

	h=0.0
	sum=0.0

	h=(x_data_array(channels)-x_data_array(start))/(channels-start)

	do 1000 ll=start+1,channels-1
	   sum=sum+2*y_data_array(ll)
1000	end do

	sum=0.5*h*(y_data_array(start)+sum+y_data_array(channels))

	return
	end