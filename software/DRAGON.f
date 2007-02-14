C     LAST UPDATE 27/01/97
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SUBROUTINE DRAGON(CELL,CSTAR,PHIZ,PHIX,ISGP,DMAX,DELR,DELZ,
     &                  IHKL,DRZ,NMAX,NPTS)
      IMPLICIT NONE
C
C                                  ------
C                                  DRAGON
C                                  ------
C
C
C                               Introduction
C                               ------------
C
C     Dragon is a simple program to generate the h,k,l reflection lists
C     used in the refinement of powder diffraction data. The program 
C     requires the unit cell parameters, wavelength of the radiation  
C     used, and the spacegroup symbol. All the information needed to 
C     determine extinction conditions and the multiplicities of the  
C     reflections is determined solely from the spacegroup symbol. 
C     The program is fully interactive and allows great flexabilty in 
C     the choice and settings of the unit cell. Several choices of 
C     output are available.
C
C                           Unit cell parameters
C                           --------------------
C
C     The program can generate h,k,l reflection lists for any unit cell,
C     ie. for triclinic, monoclinic (any axis unique), orthorhombic, 
C     tetragonal, trigonal (including the use of either rhombohedral or
C     hexagonal unit cells for rhombohedral spacegroups), hexagonal, and
C     cubic systems. For tetragonal and hexagonal unit cells, the z-axis
C     must be unique.
C
C                  Interpretation of the spacegroup symbol
C                  ---------------------------------------
C
C     The first character of the spacegroup symbol is composed of a 
C     letter denoting the lattice type which must be one of the 
C     following :             
C                          P A B C F I R
C
C     indicating primitive, A-face centred, B-face centred, C-face 
C     centred, all face  centred, body centred, and rhombohedral 
C     lattices respectively. The remaining characters of the symbol
C     specify the point group and are composed of upto 3 symbols 
C     specifying the symmetry relative to particular directions within 
C     the spacegroup. The pointgroup symbols must consist of one (or a 
C     combination) of the following symbols:

C                1  2  2(1) 3 -3  3(n) 4 -4  4(n) 6 -6  6(n)
C
C     indicating the presence of rotation, rotation-inversion, and screw
C     axes, and
C                                m a b c n d
C
C     indicating mirror and glide planes. A symbol composed of an axis 
C     and a plane is written with a slash separating the axis from the 
C     plane eg. 2(1)/m. Spaces are not permitted within the spacegroup
C     symbol.
C
C                               Lattice type
C                               ------------
C
C     The lattice type is used in the determination of the general
C     extinction conditions.  These are as follows :
C                    P => h,k,l : no conditions
C                    A => h,k,l : k + l = 2n
C                    B => h,k,l : h + l = 2n
C                    C => h,k,l : h + k = 2n
C                    F => h,k,l : h + k = 2n, k + l = 2n
C                    I => h,k,l : h + k + l = 2n
C                    R => h,k,l : no conditions (rhombohedral cell)
C                                 - h + k + l = 3n (hexagonal cell)
C     Restraints are placed on the lattice type for certain crystal 
C     systems.
C
C                       Determination of crystal type
C                       -----------------------------
C
C     This is determined from the 3 symbols making up the remainder of 
C     the spacegroup symbol. In order to determine the crystal type, 
C     certain conventions have to be adhered to:
C
C     Triclinic : only a single monad axis is permitted.
C
C     Monoclinic : the unique axis must have a  diad  axis  and/or
C          plane.   Short  or full symbols may be used eg P2(1) or
C          P12(1)1.  Where the short symbol is  used,  the  unique
C          axis  is  determined from the unit cell parameters.  In
C          the full symbol, the symbols refer to the x, y,  and  z
C          axes respectively.
C
C     Orthorhombic : each symbol is composed of a diad axis and/or
C          plane  of  symmetry  with  reference to the x, y, and z
C          axes respectively.
C
C     Tetragonal : primary symbol must be at least a tetrad  axis.
C          The  remaining  symbols  may  either  be blank eg P4 or
C          consist of diad axes and/or planes  eg  P422.   Symbols
C          refer   to   [001],   [100],   and   [110]   directions
C          respectively.
C
C     Trigonal : primary symbol must be at  least  a  triad  axis.
C          The  remaining  symbols  may  be  either blank eg P3 or
C          consist of a diad axis or mirror  plane  with  a  monad
C          axis  eg P312 and P3m1.  Symbols refer to [001], [...],
C          and [110] directions respectively.
C
C     Hexagonal : primary symbol must be at least  a  hexad  axis.
C          The  remaining symbols may be blank eg P6(3) or consist
C          of diad axes and/or planes.  Symbols  refer  to  [001],
C          [...], and [...] directions respectively.
C
C     Cubic : primary symbol may be either  diad  or  tetrad  axis
C          and/or  plane  and  refers  to  the  [100]  and related
C          directions.  The secondary symbol must be a  triad  and
C          refers  to  the  [111]  direction.  The tertiary symbol
C          must be a diad axis and/or plane if the primary  symbol
C          is  at  least a tetrad axis and refers to the [110] and
C          related directions.
C
C     The crystal type deduced from  the  pointgroup  is  then  checked
C     against the cell parameters.
C
C          Special extinctions derived from the pointgroup symbols
C          -------------------------------------------------------
C
C     Only symmetry operations which generate translational  components
C     for  the  symmetry operator will cause extinction to occur.  Thus
C     the following symbols are ignored when searching for extinction :
C                     1 -1  2  m  3 -3  4 -4  6 and -6.
C     The remaining symmetry operators will always  result  in  one  or
C     more  extinction conditions as shown below.  Note that the actual
C     symmetry operators will vary depending upon  the  the  choice  of
C     origin.   Extinction  conditions  shown in brackets have symmetry
C     equivalents and are thus redundant in this program.
C
C     Monoclinic.
C
C         Primary symbol or symbol refering to the x-axis.
C            2(1) =>  1/2+x,    -y,    -z.  h00 : h = 2n.
C            b    =>     -x, 1/2+y,     z.  0kl : k = 2n.
C            c    =>     -x,     y, 1/2+z.  0kl : l = 2n.
C            n    =>     -x, 1/2+y, 1/2+z.  0kl : k + l = 2n.
C         Secondary symbol or symbol refering to the y-axis.
C            2(1) =>     -x, 1/2+y,    -z.  0k0 : k = 2n.
C            a    =>  1/2+x,    -y,     z.  h0l : h = 2n.
C            c    =>      x,    -y, 1/2+z.  h0l : l = 2n.
C            n    =>  1/2+x,    -y, 1/2+z.  h0l : h + l = 2n.
C         Tertiary symbol or symbol refering to the z-axis.
C            2(1) =>     -x,    -y, 1/2+z.  00l : l = 2n.
C            a    =>  1/2+x,     y,    -z.  hk0 : h = 2n.
C            b    =>      x, 1/2+y,    -z.  hk0 : k = 2n.
C            n    =>  1/2+x, 1/2+y,    -z.  hk0 : h + k = 2n.
C
C     Orthorhombic.
C
C         Primary symbol.
C            2(1) =>  1/2+x,    -y,    -z.  h00 : h = 2n.
C            b    =>     -x, 1/2+y,     z.  0kl : k = 2n.
C            c    =>     -x,     y, 1/2+z.  0kl : l = 2n.
C            n    =>     -x, 1/2+y, 1/2+z.  0kl : k + l = 2n.
C            d    =>     -x, 1/4+y, 1/4+z.  0kl : k + l = 4n.
C
C         Secondary symbol.
C            2(1) =>     -x, 1/2+y,    -z.  0k0 : k = 2n.
C            a    =>  1/2+x,    -y,     z.  h0l : h = 2n.
C            c    =>      x,    -y, 1/2+z.  h0l : l = 2n.
C            n    =>  1/2+x,    -y, 1/2+z.  h0l : h + l = 2n.
C            d    =>  1/4+x,    -y, 1/4+z.  h0l : h + l = 4n.
C
C         Tertiary symbol.
C            2(1) =>     -x,    -y, 1/2+z.  00l : l = 2n.
C            a    =>  1/2+x,     y,    -z.  hk0 : h = 2n.
C            b    =>      x, 1/2+y,    -z.  hk0 : k = 2n.
C            n    =>  1/2+x, 1/2+y,    -z.  hk0 : h + k = 2n.
C            d    =>  1/4+x, 1/4+y,    -z.  hk0 : h + k = 4n.
C
C     Tetragonal.
C
C         Primary symbol.
C            4(1) =>     -y,     x, 1/4+z.  00l : l = 4n.
C            4(2) =>     -y,     x, 1/2+z.  00l : l = 2n.
C            4(3) =>     -y,     x, 3/4+z.  00l : l = 4n.
C            a    =>  1/2+x,     y,    -z.  hk0 : h = 2n, k = 2n.
C            b = a
C            n    =>  1/2+x, 1/2+y,    -z.  hk0 : h + k = 2n.
C            d    =>  1/4+x, 1/4+y,    -z.  hk0 : h + k = 4n.
C
C         Secondary symbol.
C            2(1) =>  1/2+x,    -y,    -z.  h00 : h = 2n.
C                                          (0k0 : k = 2n.)
C            a    =>  1/2+x,    -y,     z.  h0l : h = 2n.
C                                          (0kl : k = 2n.)
C            b = a
C            c    =>      x,    -y, 1/2+z.  h0l : l = 2n.
C                                          (0kl : l = 2n.)
C            n    =>  1/2+x,    -y, 1/2+z.  h0l : h + l = 2n.
C                                          (0kl : k + l = 2n.)
C            d    =>  1/4+x,    -y, 1/4+z.  h0l : h + l = 4n.
C                                          (0kl : k + l = 4n.)
C
C         Tertiary symbol.
C            2(1) =>  1/4+y, 1/4+x,    -z.  hh0 : h = 2n.
C            a    =>  1/4+y, 1/4+x,     z.  hhl : h = 2n.
C            b = a
C            c    =>      y,     x, 1/2+z.  hhl : l = 2n.
C            n    =>  1/4+y, 1/4+x, 1/2+z.  hhl : h + l = 2n.
C            d    =>  1/8+y, 1/8+x, 1/2+z.  hhl : 2h + l = 2n.
C
C     Trigonal (rhombohedral)
C
C         Secondary symbol.
C            c    =>  1/2+y, 1/2+x, 1/2+z.  hhl : l = 2n.
C                                           hkk : h = 2n.
C
C     Trigonal (hexagonal)
C
C         Primary symbol.
C            3(1) =>     -y,   x-y, 1/3+z.  00l : l = 3n.
C            3(2) =>     -y,   x-y, 2/3+z.  00l : l = 3n.
C
C         Secondary symbol.
C            c    =>     -y,    -x, 1/2+z.  h0l : l = 2n.
C                                           0kl : l = 2n.
C
C         Tertiary symbol.
C            c    =>      y,     x, 1/2+z.  hhl : l = 2n.
C                                         2h-hl : l = 2n.
C
C     Hexagonal
C
C         Primary symbol.
C            6(1) =>    x-y,     x, 1/6+z.  00l : l = 6n.
C            6(2) =>    x-y,     x, 1/3+z.  00l : l = 3n.
C            6(3) =>    x-y,     x, 1/2+z.  00l : l = 2n.
C            6(4) =>    x-y,     x, 2/3+z.  00l : l = 3n.
C            6(5) =>    x-y,     x, 5/6+z.  00l : l = 6n.
C
C         Secondary symbol.
C            c    =>     -y,    -x, 1/2+z.  h0l : l = 2n.
C
C         Tertiary symbol.
C            c    =>      y,     x, 1/2+z.  hhl : l = 2n.
C
C     Cubic
C
C         Primary symbol.
C            2(1) =>  1/2+x,    -y,    -z.  h00 : h = 2n.
C                                          (0k0 : k = 2n.)
C                                          (00l : l = 2n.)
C            4(1) =>       ,      ,      .  h00 : h = 4n.
C                                          (0k0 : k = 4n.)
C                                          (00l : l = 4n.)
C            4(2) =>       ,      ,      .  h00 : h = 2n.
C                                          (0k0 : k = 2n.)
C                                          (00l : l = 2n.)
C            4(3) =>       ,      ,      .  h00 : h = 4n.
C                                          (0k0 : k = 4n.)
C                                          (00l : l = 4n.)
C            a    =>       ,      ,      .  hk0 : h = 2n.
C                                           h0l : l = 2n.
C                                          (0kl : k = 2n.)
C            b = a
C            c = a
C            n    =>       ,      ,      .  hk0 : h + k = 2n.
C                                           h0l : h + l = 2n.
C                                          (0kl : k + l = 2n.)
C            d    =>       ,      ,      .  hk0 : h + k = 4n.
C                                           h0l : h + l = 4n.
C                                          (0kl : k + l = 4n.)
C
C         Tertiary symbol.
C            a    =>       ,      ,      .  hhl : l = 2n.
C                                           hkk : h = 2n.
C                                          (hkh : k = 2n.)
C            b = a
C            c = a
C            n = a
C            d    =>       ,      ,      .  hhl : 2h + l = 4n.
C                                           hkk : h + 2k = 4n.
C                                           (kh : 2h + k = 4n.)
C
C                                Wavelength
C                                ----------
C
C     This determines the maximum values of h, k, and  l  used  in  the
C     generation of the reflection list.
C
C           Reflections generated for the different crystal types
C           -----------------------------------------------------
C
C     The following conditions are placed on the  generation  of  h,k,l
C     values for the different crystal types :
C
C           1 Triclinic      l > 0
C                         or k >= l = 0
C                         or h >= k = l = 0
C           2 Monoclinic     h >= 0 and k >= 0 and l >= 0
C                         or h >= 0 and k > 0 and l < 0
C           3                h >= 0 and k >= 0 and l >=0
C                         or k >= 0 and l > 0 and h < 0
C           4                h >= 0 and k >= 0 and l >=0
C                         or l >= 0 and h > 0 and k < 0
C           5 Orthorhombic   h >=0 and k >= 0 and l >= 0
C           6 Tetragonal     h > 0 and k = 0 and l >= 0
C                         or h >= k > 0 and l >= 0
C           7                h >= k >= 0 and l >= 0
C           8 Trigonal
C           9
C          10
C          11
C          12
C          13 Hexagonal      h >= 0 and k >= 0 and l >= 0
C          14                h >= k > = 0 and l >= 0
C          15 Cubic          h >= k >= 0 and h >= l >= 0
C          16                h >= k >= l >= 0
C
C         Multiplicities generated for the different crystal types
C         --------------------------------------------------------
C
C     The multiplicities assigned to a reflection are chosen  according
C     to the following table :
C
C           1 Triclinic    hkl =  2
C           2 Monoclinic   h00 =  2;  0kl =  2;  hkl =  4
C           3              0k0 =  2;  h0l =  2;  hkl =  4
C           4              00l =  2;  hk0 =  2;  hkl =  4
C           5 Orthorhombic h00 =  2;  0k0 =  2;  00l =  2;  hk0 =  4;
C                          h0l =  4;  0kl =  4;  hkl =  8
C           6 Tetragonal   00l =  2;  h00 =  4;  0k0 =  4;  hk0 =  4;
C                          hkl =  8
C           7              00l =  2;  h00 =  4;  hh0 =  4;  h0l =  8;
C                          hk0 =  8;  hhl =  8;  hkl = 16
C           8 Trigonal     hhh =  2;  hkl =  6
C           9              hhh =  2;  hhl =  6;  hkk =  6; -h0h =  6;
C                          hkl = 12
C          10              00l =  2;  hkl =  6
C          11              00l =  2;  h0l =  6;  0kl =  6;  hh0 =  6;
C                          hkl = 12
C          12              00l =  2;  h00 =  6;  hhl =  6;2h-hl =  6;
C                          hkl = 12
C          13 Hexagonal    00l =  2;  h00 =  6;  hh0 =  6;  hk0 =  6;
C                          hkl = 12
C          14              00l =  2;  h00 =  6;  hh0 =  6;  hk0 = 12;
C                          h0l = 12;  hhl = 12;  hkl = 24
C          15 Cubic        h00 =  6;  hhh =  8;  hh0 = 12;  hk0 = 12
C                          hkl = 24
C          16              h00 =  6;  hhh =  8;  hh0 = 12;  hk0 = 24;
C                          hhl = 24;  hkk = 24;  hkl = 48
C
C                            Running the program
C                            -------------------
C
C     a) Input
C
C     The program wil request the following information :
C       1. A title of up to 75 characters. If <CR> is given, a  default
C          title giving date and time will be used.
C       2. The cell constants a,  b,  c,  alpha,  beta,  &  gamma.   No
C          default  is available.  If any angle is unspecified or zero,
C          its value is set to 90 degrees.  If b is zero, its value  it
C          set  to a.  If b and c are unspecified or zero, both are set
C          equal to a.
C       3. The wavelength, maximum value of two-theta required, and the
C          zero-point  correction.   The  latter is applied as :  obs =
C          calc +  zero-point.   If  lambda  is  zero,  copper  K-alpha
C          radiation  is  assumed.   If two-theta maximum is zero, then
C          180 degrees is assumed.
C       4. The spacegroup in symbol form.   If  <CR>,  then  a  default
C          spacegroup  consistent  with  the lattice parameters will be
C          chosen.
C       5. Information relevant to output.
C
C     b) Output
C
C       1. The  reflections  may  be  sorted  in  order  of  decreasing
C          d-spacing.
C       2. Reflections may be written to lineprinter  output  or  to  a
C          file.   Two  formats  are  available  for  the  latter.  The
C          multipattern Rietveld program  may  require  more  than  one
C          reflection  listing,  so  the  program will loop back to the
C          start when more than one pattern is  requested.   Output  to
C          file  is  in  the  format  (5I8) for both options, where the
C          parameters are  codeword,  h,  k,  l,  &  multiplicity,  the
C          codeword   for   the   multi-pattern  containing  additional
C          information.
C
C                               Installation
C                               ------------
C
C     The program is written in simple Fortran and should  run  on  any
C     computor  with interactive facilities.  (It can be easily adapted
C     to run as a  batch  job.)  The  only  non-standard  features  are
C     Fortran  calls  to DATE and  TIME which  need to be supplied  but
C     may  be  omitted  if    unavailable.   The  program is  currently
C     dimensioned  for  3000  reflections.   To  change  this   number,
C     redimension  the  arrays IH, IK, IL, MUL, D, R, TH, ICD, and IND,
C     and set MAXHKL to the new array size.
C
C                                 Guarantee
C                                 ---------
C
C     This program has been  extensively  tested  for  all  spacegroups
C     using  the  symbols  given  in the International Tables for X-ray
C     Crystallography for the standard spacegroup  settings.   However,
C     it  is the user's own responsibilty to check that the information
C     generated by this program is consistent with the spacegroup under
C     consideration.    The   program  may  be  altered,  modified,  or
C     subsequently changed from any form other than  that  supplied  by
C     the  author,  at  the users own risk !  However, it is considered
C     extremely  unlikely  that   minor   changes   relating   to   the
C     input/output  sections  of  the  source  code  will result in any
C     errors in the generation of hkl reflection lists.
C
C
C
C          An earlier version of this program, written in Algol  68  by
C     J.W.Talbot,  has  existed  at Oxford university for several years
C     now.  The Fortran code for this version is  completely  original,
C     the  code  from  the  above  version  not  being available to the
C     author, and so only reflects some of the  concepts  envisaged  in
C     the earlier work.
C
C        Jeremy Karl Cockcroft. Institut Laue Langevin. August 1984.
C
C     Modifications for Fibre-Diffraction
C     Ian Clifton  S E R C  Daresbury  March 1987
C     1) Remove unwanted output options.
C     2) Produce standardised output on a file for all space groups.
C     3) Change multiplicity for fibre case.
C     Further modifications for FD
C     Richard Denny February 1993
C     4)Correct calculation of R and Z
C     5)Allow c* to be parallel to Z axis for monoclinic etc.
C     6)Add a column for the observed multiplicity in FD.
C     7)Change sorting to sort along layer lines first
C     8)Adapt as a subroutine to use in LSQINT
C     More changes March 1994 RCD
C     9)Added PHIZ,PHIX to input to allow general cell orientation in
C       fibres
C    10)Now use routines MATCAL for orientation matrix calculation
C       and RZDCAL for reciprocal space ccordinate calculation
C
C
C Calls   0:
C Called by: LSQINT
C
C-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
C Parameters:
C
      INTEGER NLLPX
      PARAMETER(NLLPX=4096)
C
C Scalar arguments:
C
      REAL PHIZ,PHIX,DMAX,DELR,DELZ
      INTEGER NPTS,NMAX
      LOGICAL CSTAR
C
C Array arguments:
C
      REAL CELL(6),DRZ(3,NMAX)
      INTEGER IHKL(3,NMAX)
      CHARACTER*1 ISGP(20)
C
C Local arrays:
C
      DIMENSION IH(NLLPX),IK(NLLPX),IL(NLLPX),MUL(NLLPX),MULFD(NLLPX),
     &          D(NLLPX),R(NLLPX),Z(NLLPX)
      DIMENSION TH(NLLPX),IND(NLLPX)
      DIMENSION IEX(32)
      REAL RCELL(6),AMAT(3,3)
      CHARACTER*1 ICH(24),IDEF(6),ISYM(6,3)
C
C Local scalars:
C
c      CHARACTER*20 DFILE
      CHARACTER*75 TEXT
      CHARACTER CTYPE*4
      REAL A,A1,ABR,AHE,AL,ALHE,ALR,ALRH,AR,AR2,ARH,B,B1,BCR,BE,BER,BR,
     &     BR2,C,C1
      REAL CALCTH,CAR,CHE,COSA,COSAR,COSB,COSBR,COSC,COSCR,CR,CR2,D,D0,
     &     DFWAV,DL,DMIN,DZP
      REAL GA,GAHE,GAR,PI,Q,QMAX,R,RADS,RADS2,S,SINA,SINB,SINC,SQ,TH,
     &     TMX,V,WAV
      REAL WAV2,Z,ZER
c      INTEGER IOUT
      INTEGER I,IC,ICST,ID,IDFTMX,IEX,IH,II,IK,IL,IND,IOR,IOW,IS,
     &        ISO,ISPHE,ITMP,J,K
      INTEGER LAU,LPT,LTP,MAXH,MAXHKL,MAXK,MAXL,MF,MFD,MH,MI,MINH,MINK,
     &        MINL,MK,ML,MUL,MULFD,N,NA
      INTEGER NB,NC,NCH,NEX,NF,NH,NK,NL,NOSWAP,NS,NSUM,NUN
C
C External function:
C
      INTEGER FIBMULT
      EXTERNAL FIBMULT
C
C Data:
C
      DATA MAXHKL/NLLPX/
C     Set character set used in spacegroup symbol.
      DATA ICH/'P','A','B','C','F','I','R','1','2','3','4','5','6','m',
     &     'a','b','c','n','d','-','/','(',')',' '/
C     Set Pi.
      DATA PI/3.1415927/
C     Set default wavelength to Cu K-alpha.
      DATA DFWAV/1.54178/
C     Set default maximum two-theta value.
      DATA IDFTMX/180/
C     Set default zero-point.
      DATA DZP/0.000/
C
C-----------------------------------------------------------------------
C
C     Start of section I of program.
C     -----------------------------
C
C     Define Fortran channel numbers.
C     Read TTY.
      IOR = 5
C     Write TTY.
      IOW = 6
C     LPT listing.
      LPT = 10
C     Channel for reflection list.
c      IOUT = 20
c      WRITE(DFILE,'(A10,I1)')'DRAGON.OUT',NLAT
c      OPEN(UNIT=IOUT,FILE=DFILE,STATUS='UNKNOWN')
      RADS = PI/180.0
      RADS2 = RADS/2.0
C     Version 1.0 started Easter Friday April 1983.
C     Updated at various times to versions 1.1, 1.2 etc ! and set
C     to version 2.0 in June 1984.
C     February 1985 - Gives hh+kk+ll for cubic systems.
C     Checking of extinction made more efficient April 85.
C      WRITE(IOW,1)
C    1 FORMAT(/1X,'DRAGON version 2.4 last update April 1985')
C      WRITE(LPT,1)
C
C     Start of section II of program.
C     ------------------------------
C
C     Read in input data from TTY.
C    3 WRITE(IOW,4)
C    4 FORMAT(/1X,'Give general title (<CR> = default)'/1X,'->  ',$)
C      READ(IOR,5,END=494) TEXT
C    5 FORMAT(75A1)
C     If blank, take default title.
 10   DO 20 I = 1,75
         IF(TEXT(I:I).NE.' ')GOTO 30
 20   CONTINUE
C     Machine dependant subroutines. (Could have any default title !).
C      CALL DATE(DAY)
C      CALL TIME(TIM)
C      WRITE(LPT,7) DAY,TIM
C    7 FORMAT(/1X,'No title given - output generated on ',3A4,' at ',2A4)
C      GOTO 10
C     Write out title to LPT.
C    8 WRITE(LPT,9) TEXT
C    9 FORMAT(/1X,75A1)
C
C     Start of section III of program.
C     -------------------------------
C
 30   A = CELL(1)
      B = CELL(2)
      C = CELL(3)
      AL = CELL(4)
      BE = CELL(5)
      GA = CELL(6)
C     Default lengths if zero to preceeding value.
      IF(B.LE.0.0)B = A
      IF(C.LE.0.0)C = B
C     Default angles if zero to preceding value (or 90.0).
      IF(AL.LE.0.0)AL = 90.0
      IF(BE.LE.0.0)BE = 90.0
      IF(GA.LE.0.0)GA = 90.0
C      IF(AL.EQ.90.0.AND.BE.EQ.90.0)THEN
C      CSTAR = .TRUE.
C      ELSE
C      CSTAR = .TRUE.
C      WRITE(IOW,'(1X,A,$)')'Enter 1 for c || Z,   2 for c* || Z [1]:'
C      CALL GETVAL(IOR,CONST,NVAL,IRC)
C      IF(IRC.NE.0)GOTO 10
C      IF(NINT(CONST(1)).EQ.1)THEN
C         CSTAR = .FALSE.
C         CST = 'C    '
C      ELSEIF(NINT(CONST(1)).EQ.2)THEN
C        CSTAR = .TRUE.
C         CST = 'CSTAR'
C      ELSEIF(NVAL.EQ.0)THEN
C         CSTAR = .FALSE.
C         CST = 'C    '
C      ELSE
C         GOTO 10
C      ENDIF
C      ENDIF
C     Determine reciprocal lattice parameters.
      A1 = AL*RADS
      B1 = BE*RADS
      C1 = GA*RADS
      S = (A1+B1+C1)/2.0
C     Give error message if S > 180.
      IF(S.GE.PI)GOTO 800
      SQ = SQRT(SIN(S)*SIN(S-A1)*SIN(S-B1)*SIN(S-C1))
      V = 2.0*A*B*C*SQ
C     Give error message if V is zero.
      IF(V.LE.0.0)GOTO 800
      WRITE(LPT,5010)A,B,C,AL,BE,GA
      WRITE(LPT,5020)V
      SINA = SIN(A1)
      SINB = SIN(B1)
      SINC = SIN(C1)
      AR = B*C*SINA/V
      BR = C*A*SINB/V
      CR = A*B*SINC/V
      COSA = COS(A1)
      COSB = COS(B1)
      COSC = COS(C1)
      COSAR = (COSB*COSC-COSA)/(SINB*SINC)
      COSBR = (COSC*COSA-COSB)/(SINC*SINA)
      COSCR = (COSA*COSB-COSC)/(SINA*SINB)
      AR2 = AR*AR
      BR2 = BR*BR
      CR2 = CR*CR
      BCR = 2.0*BR*CR*COSAR
      CAR = 2.0*CR*AR*COSBR
      ABR = 2.0*AR*BR*COSCR
      RCELL(1) = AR
      RCELL(2) = BR
      RCELL(3) = CR
      RCELL(4) = ACOS(COSAR)
      RCELL(5) = ACOS(COSBR)
      RCELL(6) = ACOS(COSCR)
      ICST = 0
      IF(CSTAR)ICST = 1
      CALL MATCAL(ICST,PHIZ,PHIX,RCELL,AMAT)
      ALR = RCELL(4)/RADS
      BER = RCELL(5)/RADS
      GAR = RCELL(6)/RADS
      WRITE(LPT,5030)AR,BR,CR,ALR,BER,GAR
C
C     Start of section IV of program.
C     ------------------------------
C
C     Set default spacegroup from the lattice parameters.
C     Default held in array IDEF.
      IDEF(1) = 'P'
      DO 40 I = 2,6
         IDEF(I) = ' '
 40   CONTINUE
C     Is gamma not 90 ?
      IF(GA.NE.90.0)THEN
C     Is a not equal to b ?
         IF(A.NE.B)THEN
C     Are alpha and beta both 90 ?
            IF(AL.NE.90.0 .OR. BE.NE.90.0)GOTO 50
C     Is alpha not equal to 90 or beta not equal to 90 ?
         ELSEIF(AL.NE.90.0 .OR. BE.NE.90.0)THEN
C     Is alpha not equal to gamma or beta not equal to gamma ?
C     Is a not equal to b or b not equal to c ?
            IF(AL.NE.GA .OR. BE.NE.GA .OR. A.NE.B .OR. B.NE.C)GOTO 50
C     Set to default rhombohedral spacegroup R-3m.
            IDEF(1) = 'R'
            IDEF(2) = '-'
            IDEF(3) = '3'
            IDEF(4) = 'm'
            GOTO 60
C     If gamma not equal to 120, monoclinic (z-axis unique).
         ELSEIF(GA.EQ.120.0)THEN
C     Set to default hexagonal spacegroup P6/mmm.
            IDEF(2) = '6'
            IDEF(3) = '/'
            IDEF(4) = 'm'
            IDEF(5) = 'm'
            IDEF(6) = 'm'
            GOTO 60
         ENDIF
C     Is alpha not 90 or beta not 90 ?
      ELSEIF(AL.NE.90.0 .OR. BE.NE.90.0)THEN
C     Is alpha equal to 90 or beta equal to 90 ?
         IF(AL.NE.90.0 .AND. BE.NE.90.0)GOTO 50
      ELSE
C     Is a not equal to b ?
         IF(A.NE.B)THEN
C     Set to default orthorhombic spacegroup Pmmm.
            IDEF(2) = 'm'
            IDEF(3) = 'm'
            IDEF(4) = 'm'
C     Is b not equal to c ?
         ELSEIF(B.NE.C)THEN
C     Set to default tetragonal spacegroup P4mm.
            IDEF(2) = '4'
            IDEF(3) = '/'
            IDEF(4) = 'm'
            IDEF(5) = 'm'
            IDEF(6) = 'm'
         ELSE
C     Set to general cubic spacegroup Pm3m.
            IDEF(2) = 'm'
            IDEF(3) = '3'
            IDEF(4) = 'm'
         ENDIF
         GOTO 60
      ENDIF
C     Set to default monoclinic spacegroup P2/m.
      IDEF(2) = '2'
      IDEF(3) = '/'
      IDEF(4) = 'm'
      GOTO 60
C     Set to default triclinic spacegroup P-1.
 50   IDEF(2) = '-'
      IDEF(3) = '1'
C
C     Start of section IV of program.
C     ------------------------------
C
C     Get wavelength and maximum two-theta limits.
C     For TOF diffaction, set the wavelength to twice the minimum
C     d-spacing required and set two-theta to default value.
C   26 WRITE(IOW,27) DFWAV,IDFTMX,DZP
C   27 FORMAT(/1X,'Give wavelength, maximum 2-theta, and zero-point,
C     + [REALS] '/1X,'(OBS = CALC + Z-P)'
C     +  /1X,'(<CR> = ',F8.5,' Angstroms, ',I3,' degrees, &',
C     +  1X,F7.3,' degrees)'
C     +  /1X,'->  ',$)
C   28 CALL GETVAL(IOR,CONST,NVAL,IRC)
C      IF(IRC.EQ.1)GOTO 494
C      IF(IRC.EQ.2)GOTO 471
C      IF(NVAL.GT.0)THEN
C         WAV = CONST(1)
C         TMX = CONST(2)
C         ZER = CONST(3)
C      ENDIF
C     Check wavelength and 2-theta max.
 60   WAV = 0.0
      TMX = 0.0
      ZER = 0.0
C 26   IF (WAV.LT.0.0) GOTO 471
C      IF (TMX.LT.0.0.OR.TMX.GT.180.0) GOTO 471
C      IF (ZER.LT.-500.0.OR.ZER.GT.500.0) GOTO 471
C     If <CR>, then set defaults.
C     These are usually set Cu K-alpha radiation for X-rays,
C     but may be set to the wavelength most frequently used.
      IF(WAV.EQ.0.0)WAV = DFWAV
C     Set default maximum two-theta value required.
      IF(TMX.EQ.0.0)TMX = ASIN(WAV*DMAX/2.0)/RADS2
C     Set default zero-point.
      IF(ZER.EQ.0.0)ZER = DZP
C     Store defaults.
      DFWAV = WAV
      IDFTMX = INT(TMX+0.5)
      DZP = ZER
C      WRITE(LPT,30) WAV,TMX,ZER
C   30 FORMAT(/1X,'Wavelength ',F8.5,' A   Maximum 2-theta ',F8.3,
C     +  1X,'deg   Zero-point ',F8.3,' deg')
C     Calculate minimum d-spacing.
      WAV2 = WAV/2.0
C     Take into account zero-point - only relevant when very large !
      DMIN = WAV2/SIN((TMX-ZER)*RADS2)
C     Check for blank line in input.
      DO 70 I = 1,20
         IF(ISGP(I).NE.' ')GOTO 90
 70   CONTINUE
C     If <CR>, then set to default.
      DO 80 I = 1,6
         ISGP(I) = IDEF(I)
 80   CONTINUE
C     Remove any spurious spaces from spacegroup symbol.
 90   NCH = 0
      DO 100 I = 1,20
         IF(ISGP(I).NE.' ')THEN
C     Increment number of characters.
            NCH = NCH + 1
            ISGP(NCH) = ISGP(I)
         ENDIF
 100  CONTINUE
C     NCH is number of characters in spacegroup symbol.
C     Set rest back to blank.
      IF(NCH.NE.20)THEN
         DO 102 I = (NCH+1),20
            ISGP(I) = ' '
 102     CONTINUE
      ENDIF
C     Some terminals only have upper-case.
C     - and some people are either bad typists or blind !
      IF(ISGP(1).EQ.'p')ISGP(1) = 'P'
      IF(ISGP(1).EQ.'a')ISGP(1) = 'A'
      IF(ISGP(1).EQ.'b')ISGP(1) = 'B'
      IF(ISGP(1).EQ.'c')ISGP(1) = 'C'
      IF(ISGP(1).EQ.'f')ISGP(1) = 'F'
      IF(ISGP(1).EQ.'i')ISGP(1) = 'I'
      IF(ISGP(1).EQ.'r')ISGP(1) = 'R'
      DO 110 I = 2,20
         IF(ISGP(I).EQ.'M')ISGP(I) = 'm'
         IF(ISGP(I).EQ.'A')ISGP(I) = 'a'
         IF(ISGP(I).EQ.'B')ISGP(I) = 'b'
         IF(ISGP(I).EQ.'C')ISGP(I) = 'c'
         IF(ISGP(I).EQ.'N')ISGP(I) = 'n'
         IF(ISGP(I).EQ.'D')ISGP(I) = 'd'
 110  CONTINUE
C     Determine symmetry constraints - decode spacegroup symbol.
C     IC is the pointer position in array ISGP.
      IC = 1
C     Lattice types : P A B C F I R.
      DO 120 I = 1,7
         LTP = I
         IF(ISGP(IC).EQ.ICH(I))GOTO 130
 120  CONTINUE
      GOTO 810
C     Rotation axes with or without screw or inversion : 1 -1 2 (-2 = m)
C     2(1) 3 -3 3(1) 3(2) 4 -4 4(1) 4(2) 4(3) 6 -6 6(1) 6(2) 6(3) 6(4)
C     6(5).
C     Mirror and glide planes : m a b c n d.
C     First character is digit 1 2 3 4 6 or - or m a b c n d.
C     Set symbol array to blanks.
 130  DO 140 J = 1,3
         DO 132 I = 1,6
            ISYM(I,J) = ' '
 132     CONTINUE
 140  CONTINUE
C     Extract primary, secondary, and tertiary symbols. Check syntax.
C     NS is the symbol number, IS is its start position in the
C     array ISGP, and ID is a syntax indicator. ID = 0 shows new
C     symbol, ID = 1,2,3,4,5,6 shows previous characters as
C     "/","-","n(","n(m","n(m)", and "n" respectively where n and
C     m are digits such that n > m.
      NS = 1
      IS = 2
      ID = 0
C     Get next character.
 150  IC = IC + 1
      DO 160 I = 8,24
         NC = I
         IF(ISGP(IC).EQ.ICH(I))GOTO 170
 160  CONTINUE
C     If spurious character, abort.
      GOTO 820
C     NC is the position of the character in the array ICH.
C     If digit, then jump.
 170  IF(NC.GT.13)THEN
C     If alphabetic, then jump.
         IF(NC.LE.19)THEN
C     Alphabetic found - abort if ID is 2, 3, or 4. End of symbol
C     if ID is 0 or 1 and start of next if ID is 5 or 6.
            IF(ID.LE.1)GOTO 180
            IF(ID.LE.4)GOTO 820
            IC = IC - 1
            GOTO 180
         ELSEIF(NC-19.EQ.1)THEN
C     "-" found - next character must be digit.
C     If ID is 5 or 6, then next symbol.
            IF(ID.GE.5)THEN
               IC = IC - 1
               GOTO 180
            ELSE
               IF(ID.NE.0)GOTO 820
               ID = 2
               GOTO 150
            ENDIF
         ELSEIF(NC-19.EQ.2)THEN
C     "/" found - next character must be alphabetic.
            IF(ID.LE.4)GOTO 820
            ID = 1
            GOTO 150
         ELSEIF(NC-19.EQ.3)THEN
C     "(" found - must proceed digit m and be proceeded by digit n
C     where n > m. If ID not 6, then abort.
            IF(ID.NE.6)GOTO 820
C     Check that n not proceeded by "-".
            IF(ISGP(IC-2).EQ.'-')GOTO 820
            ID = 3
            GOTO 150
         ELSEIF(NC-19.EQ.4)THEN
C     ")" found - If ID not 4, then abort.
            IF(ID.NE.4)GOTO 820
            ID = 5
            GOTO 150
         ELSEIF(NC-19.EQ.5)THEN
C     " " found. If ID is 0, then end of input. If ID is 1 to 4,
C     then abort.
            IF(ID.EQ.0)GOTO 200
            IF(ID.LE.4)GOTO 820
            IC = IC - 1
            GOTO 180
         ENDIF
      ENDIF
C     Digit found - abort if ID is 1 or 4.
      IF(ID.EQ.1 .OR. ID.EQ.4)GOTO 820
      IF(ID.EQ.3)THEN
C     ID is 3. Abort if m >= n.
         IF(ISGP(IC-2).LE.ISGP(IC))GOTO 820
         ID = 4
         GOTO 150
      ELSEIF(ID.EQ.5 .OR. ID.EQ.6)THEN
C     ID is 5 or 6 and start of next symbol is encountered.
         IC = IC - 1
      ELSE
C     ID is 0 or 2. Abort if digit is 5.
C     End of symbol if digit is 1.
         IF(NC.EQ.12)GOTO 820
C     Also abort if -2. Must use m.
         IF(ID.EQ.2 .AND. NC.EQ.9)GOTO 820
         IF(NC.NE.8)THEN
            ID = 6
            GOTO 150
         ENDIF
      ENDIF
C     Copy symbol into array ISYM.
 180  DO 190 I = IS,IC
         J = I + 1 - IS
         ISYM(J,NS) = ISGP(I)
 190  CONTINUE
C     If 3 symbols found, then quit parsing.
      IF(NS.NE.3)THEN
         NS = NS + 1
         IS = IC + 1
         ID = 0
C     Get next symbol.
         GOTO 150
      ENDIF
C     Check rest of line is blank.
 200  IF(IC.NE.20)THEN
         DO 202 I = IC + 1,20
            IC = I
            IF(ISGP(I).NE.' ')GOTO 820
 202     CONTINUE
      ENDIF
      WRITE(LPT,5050)ISGP
      WRITE(LPT,5060)ISGP(1),((ISYM(I,J),I=1,6),J=1,3)
C
C     Start of section VI of program.
C     ------------------------------
C
C     Determine Laue type.
C     Get first alphanumeric from primary, secondary, and tertiary
C     symbols.
      NS = 0
 210  NS = NS + 1
      DO 220 J = 1,6
         DO 212 I = 8,19
            N = I
            IF(ISYM(J,NS).EQ.ICH(I))GOTO 230
 212     CONTINUE
 220  CONTINUE
      N = 7
 230  IF(NS.EQ.2)THEN
         NB = N - 7
         GOTO 210
      ELSEIF(NS.EQ.3)THEN
         NC = N - 7
C     If first symbol is plane, jump.
         IF(NA.LE.6)THEN
C     Crystal has rotation axis of order NA.
            IF(NA.EQ.1)THEN
C     Triclinic or monoclinic cases - Laue type 1, 3, or 4.
C     If 2nd symbol is blank, then triclinic.
               IF(NB.EQ.0)THEN
C     Syntax check forces third symbol to be blank.
                  LAU = 1
                  GOTO 260
C     If 2nd symbol is monad axis, 3rd must be diad and/or plane.
               ELSEIF(NB.EQ.1)THEN
                  IF(NC.NE.2 .AND. NC.LT.7)GOTO 830
                  LAU = 4
                  GOTO 260
               ELSE
                  IF(.NOT.((NB.EQ.2.OR.NB.GE.7).AND.NC.EQ.1))GOTO 830
                  LAU = 3
                  GOTO 260
               ENDIF
            ELSEIF(NA.EQ.2)THEN
            ELSEIF(NA.EQ.3)THEN
C     Trigonal case - Laue type 8, 9, 10, 11, or 12.
C     If lattice type is P, then only hexagonal axes.
               IF(LTP.EQ.1)GOTO 240
C     Lattice type is R. Examine lattice parameters.
               IF(GA.EQ.120.0)GOTO 240
C     If 2nd symbol blank, then type 8.
               IF(NB.EQ.0)THEN
                  LAU = 8
                  GOTO 260
               ELSE
                  IF(NB.GT.2 .AND. NB.LT.7)GOTO 830
                  IF(NC.GT.2 .AND. NC.LT.7)GOTO 830
                  IF(NB.EQ.NC .OR. (NB+NC).EQ.1)GOTO 830
                  LAU = 9
                  GOTO 260
               ENDIF
            ELSEIF(NA.EQ.4)THEN
C     Tetragonal or cubic case - Laue type 6, 7, or 16.
C     If 2nd symbol is triad, then cubic.
               IF(NB.EQ.3)GOTO 250
C     2nd and 3rd symbols blank or diads and/or planes.
               IF(NB.NE.0)THEN
                  IF(NB.LT.7 .AND. NB.NE.2)GOTO 830
                  IF(NC.LT.7 .AND. NC.NE.2)GOTO 830
                  LAU = 7
                  GOTO 260
               ELSE
                  IF(NC.NE.0)GOTO 830
                  LAU = 6
                  GOTO 260
               ENDIF
C     Hexagonal case - Laue type 13 or 14.
C     Check 2nd and 3rd symbol for diads and/or planes.
            ELSEIF(NB.LT.7 .AND. NB.NE.2)THEN
C     2nd symbol must be blank.
               IF(NB.NE.0)GOTO 830
               LAU = 13
               GOTO 260
            ELSE
               IF(NC.LT.7 .AND. NC.NE.2)GOTO 830
               LAU = 14
               GOTO 260
            ENDIF
         ENDIF
C     Monoclinic, orthorhombic, or cubic cases -
C     Laue type 2, 3, 4, 5, 15, or 16.
C     If 2nd symbol is triad, then cubic.
         IF(NB.EQ.3)THEN
C     If 3rd symbol is blank, then type 15.
            IF(NC.NE.0)GOTO 250
            LAU = 15
            GOTO 260
C     If 2nd symbol diad or plane, then orthorhombic.
         ELSEIF(NB.LT.7 .AND. NB.NE.2)THEN
C     If 2nd symbol is not monad or blank, abort.
            IF(NB.GT.1)GOTO 830
C     If 2nd symbol is blank, need to examine lattice parameters.
            IF(NB.EQ.1)THEN
C     If 3rd symbol not monad, abort.
               IF(NC.NE.1)GOTO 830
               LAU = 2
               GOTO 260
            ELSEIF(AL.EQ.90.0)THEN
               IF(BE.EQ.90.0)THEN
C     If alpha = beta = gamma = 90, give error.
                  IF(GA.EQ.90.0)GOTO 850
                  LAU = 4
                  GOTO 260
               ELSE
                  LAU = 3
                  GOTO 260
               ENDIF
            ELSE
               LAU = 2
               GOTO 260
            ENDIF
         ELSE
C     Check that 3rd symbol is diad and/or plane.
            IF(NC.LT.7 .AND. NC.NE.2)GOTO 830
            LAU = 5
            GOTO 260
         ENDIF
      ELSE
         NA = N - 7
         GOTO 210
      ENDIF
C     If 2nd symbol blank, then type 10.
 240  IF(NB.EQ.0)THEN
         LAU = 10
         GOTO 260
      ELSE
         IF(NB.GT.2 .AND. NB.LT.7)GOTO 830
         IF(NB.EQ.1)THEN
            IF(NC.GT.2 .AND. NC.LT.7)GOTO 830
            LAU = 12
            GOTO 260
         ELSE
            IF(NC.GT.1)GOTO 830
            LAU = 11
            GOTO 260
         ENDIF
      ENDIF
C     Check that 3rd symbol is diad or plane.
 250  IF(NC.LT.7 .AND. NC.NE.2)GOTO 830
      LAU = 16
C
C     Start of section VII of program.
C     -------------------------------
C
C     Check that spacegroup and lattice constants are compatible.
C     No conditions for triclinic case.
 260  IF(LAU.EQ.1)GOTO 290
      IF(LAU.NE.2)THEN
C     Alpha = beta = gamma for rhombohedral axes.
         IF(LAU-7.EQ.1 .OR. LAU-7.EQ.2)THEN
            IF(AL.EQ.BE .AND. BE.EQ.GA)GOTO 280
            GOTO 840
         ELSE
            IF(AL.NE.90.0)GOTO 840
            IF(LAU.EQ.3)GOTO 270
         ENDIF
      ENDIF
      IF(BE.NE.90.0)GOTO 840
      IF(LAU.EQ.4)GOTO 290
C     Gamma = 120 for hexagonal axes.
      IF(LAU-9.EQ.1 .OR. LAU-9.EQ.2 .OR. LAU-9.EQ.3 .OR. LAU-9.EQ.4 .OR. 
     &   LAU-9.EQ.5)THEN
         IF(GA.EQ.120.0)GOTO 280
         GOTO 840
      ENDIF
 270  IF(GA.NE.90.0)GOTO 840
C     a, b, and c may all differ for monoclinic and orthorhombic axes.
      IF(LAU-1.EQ.1 .OR. LAU-1.EQ.2 .OR. LAU-1.EQ.3 .OR. LAU-1.EQ.4)
     &   GOTO 290
 280  IF(A.NE.B)GOTO 840
C     b and c may differ for tetragonal and hexagonal axes.
      IF(LAU-5.NE.1 .AND. LAU-5.NE.2 .AND. LAU-5.NE.5 .AND. 
     &   LAU-5.NE.6 .AND. LAU-5.NE.7 .AND. LAU-5.NE.8 .AND. LAU-5.NE.9)
     &   THEN
C     b = c for cubic and rhombohedral axes.
         IF(B.NE.C)GOTO 840
      ENDIF
C
C     Start of section VIII of program.
C     --------------------------------
C
C     If rhombohedral, calculate alternative cell constants.
C     (Not used, but frequently useful !)
 290  IF(LTP.EQ.7)THEN
         IF(LAU.EQ.8 .OR. LAU.EQ.9)THEN
C     Rhombohedral to hexagonal conversion.
            AHE = A*SQRT(2.0-2.0*COSA)
            CHE = A*SQRT(6.0*COSA+3.0)
            ALHE = 90.0
            GAHE = 120.0
            WRITE(LPT,5070)AHE,AHE,CHE,ALHE,ALHE,GAHE
         ELSE
C     Hexagonal to rhombohedral conversion.
            ARH = SQRT(3.0*A*A+C*C)/3.0
            ALRH = ACOS((2.0*C*C-3.0*A*A)/(2.0*C*C+6.0*A*A))*180.0/PI
            WRITE(LPT,5070)ARH,ARH,ARH,ALRH,ALRH,ALRH
         ENDIF
      ENDIF
C
C     Start of section IX of program.
C     ------------------------------
C
C     Work out general extinctions.
      NEX = 0
      IF(LTP.EQ.1)THEN
      ELSEIF(LTP.EQ.2)THEN
C     A-face centred. x,1/2+y,1/2+z. hkl : k + l = 2n.
         NEX = NEX + 1
         IEX(NEX) = 1
      ELSEIF(LTP.EQ.3)THEN
C     B-face centred. 1/2+x,y,1/2+z. hkl : h + l = 2n.
         NEX = NEX + 1
         IEX(NEX) = 2
      ELSEIF(LTP.EQ.4)THEN
C     C-face centred. 1/2+x,1/2+y,z. hkl : h + k = 2n.
         NEX = NEX + 1
         IEX(NEX) = 3
      ELSEIF(LTP.EQ.5)THEN
C     All (F) face centred. 1/2+x,1/2+y,z; 1/2+x,y,1/2+z;
C     x,1/2+y,1/2+z. hkl : h + k = 2n, h + l = 2n, (k + l = 2n).
         NEX = NEX + 1
         IEX(NEX) = 3
         NEX = NEX + 1
         IEX(NEX) = 2
      ELSEIF(LTP.EQ.6)THEN
C     Body (I) centred. 1/2+x,1/2+y,1/2+z. hkl : h + k + l = 2n.
         NEX = NEX + 1
         IEX(NEX) = 4
      ELSEIF(LTP.EQ.7)THEN
C     Rhombohedral with hexagonal axes, obverse setting chosen.
C     1/3+x,2/3+y,2/3+z; 2/3+x,1/3+y,1/3+z. hkl: - h + k + l = 3n.
C     Skip if rhombohedral axes used.
         IF(LAU-7.NE.1 .AND. LAU-7.NE.2)THEN
            NEX = NEX + 1
            IEX(NEX) = 5
         ENDIF
      ELSE
         GOTO 880
      ENDIF
C
C     Start of section X of program.
C     -----------------------------
C
C     Check lattice type against Laue type and work out special
C     extinctions in addition.
      IF(LAU.EQ.1)THEN
C     Spacegroups P1 and P-1.
C     Lattice type R is not allowed. If A, B, C, F, or I centrings
C     are present, then the unit cell is in need of reduction.
C     No point group extinctions possible.
         IF(LTP.NE.7)GOTO 750
         GOTO 860
      ELSEIF(LAU.EQ.2)THEN
C     Spacegroups (x-axis unique) P2, P2(1) etc.
C     Lattice type R is not allowed. If A or F centrings
C     are present, then the unit cell is in need of reduction.
         IF(LTP.EQ.7)GOTO 860
C     Search for screw axis 2(1).
         DO 292 I = 2,20
            IF(ISGP(I).EQ.ICH(22))GOTO 294
 292     CONTINUE
         GOTO 320
C     2(1) axis. 1/2+x,-y,-z. h00 : h = 2n.
 294     NEX = NEX + 1
         IEX(NEX) = 6
      ELSEIF(LAU.EQ.3)THEN
C     Spacegroups (y-axis unique) P2, P2(1) etc.
C     Lattice type R is not allowed. If B or F centrings
C     are present, then the unit cell is in need of reduction.
         IF(LTP.EQ.7)GOTO 860
C     Search for screw axis 2(1).
         DO 296 I = 2,20
            IF(ISGP(I).EQ.ICH(22))GOTO 370
 296     CONTINUE
         GOTO 380
      ELSEIF(LAU.EQ.4)THEN
C     Spacegroups (z-axis unique) P2, P2(1) etc.
C     Lattice type R is not allowed. If C or F centrings
C     are present, then the unit cell is in need of reduction.
         IF(LTP.EQ.7)GOTO 860
C     Search for screw axis 2(1).
         DO 298 I = 2,20
            IF(ISGP(I).EQ.ICH(22))GOTO 430
 298     CONTINUE
         GOTO 440
      ELSEIF(LAU.EQ.5)THEN
C     Spacegroups P222 etc.
C     Lattice type R is not allowed.
         IF(LTP.EQ.7)GOTO 860
C     Do for each symbol.
         DO 306 J = 1,3
C     Search for screw axis 2(1).
            DO 299 I = 1,6
               IF(ISYM(I,J).EQ.ICH(22))GOTO 300
 299        CONTINUE
            GOTO 301
C     2(1) axis along
C     x : 1/2+x,-y,-z. h00 : h = 2n.
C     y : -x,1/2+y,-z. 0k0 : k = 2n.
C     z : -x,-y,1/2+z. 00l : l = 2n.
 300        NEX = NEX + 1
            IEX(NEX) = J + 5
C     Search for glide planes. Reject if a, b, or c lies along axis.
C     Ignore if m.
 301        DO 302 I = 1,6
               K = I
               IF(ISYM(I,J).GE.'a' .AND. ISYM(I,J).LE.'z')GOTO 303
 302        CONTINUE
            GOTO 306
 303        DO 304 I = 14,19
               NA = I - 13
               IF(ISYM(K,J).EQ.ICH(I))GOTO 305
 304        CONTINUE
            GOTO 880
C     Refering to x, y, or z axes.
 305        IF(J.EQ.2)THEN
C     Refers to y axis.
C     Found m, a, b, c, n, or d.
               IF(NA.EQ.1)THEN
               ELSEIF(NA.EQ.2)THEN
C     a plane. 1/2+x,-y,z. h0l : h = 2n.
                  NEX = NEX + 1
                  IEX(NEX) = 12
               ELSEIF(NA.EQ.3)THEN
                  GOTO 830
               ELSEIF(NA.EQ.4)THEN
C     c plane. x,-y,1/2+z. h0l : l = 2n.
                  NEX = NEX + 1
                  IEX(NEX) = 11
               ELSEIF(NA.EQ.5)THEN
C     n plane. 1/2+x,-y,1/2+z. h0l : h + l = 2n.
                  NEX = NEX + 1
                  IEX(NEX) = 16
               ELSEIF(NA.EQ.6)THEN
C     d plane. 1/4+x,-y,1/4+z. h0l : h + l = 4n.
                  NEX = NEX + 1
                  IEX(NEX) = 19
               ELSE
                  GOTO 880
               ENDIF
            ELSEIF(J.EQ.3)THEN
C     Refers to z axis.
C     Found m, a, b, c, n, or d.
               IF(NA.EQ.1)THEN
               ELSEIF(NA.EQ.2)THEN
C     a plane. 1/2+x,y,-z. hk0 : h = 2n.
                  NEX = NEX + 1
                  IEX(NEX) = 9
               ELSEIF(NA.EQ.3)THEN
C     b plane. x,1/2+y,-z. hk0 : k = 2n.
                  NEX = NEX + 1
                  IEX(NEX) = 13
               ELSEIF(NA.EQ.4)THEN
                  GOTO 830
               ELSEIF(NA.EQ.5)THEN
C     n plane. 1/2+x,1/2+y,-z. hk0 : h + k = 2n.
                  NEX = NEX + 1
                  IEX(NEX) = 15
               ELSEIF(NA.EQ.6)THEN
C     d plane. 1/4+x,1/4+y,-z. hk0 : h + k = 4n.
                  NEX = NEX + 1
                  IEX(NEX) = 18
               ELSE
                  GOTO 880
               ENDIF
C     Refers to x axis.
C     Found m, a, b, c, n, or d.
            ELSEIF(NA.EQ.1)THEN
            ELSEIF(NA.EQ.2)THEN
               GOTO 830
            ELSEIF(NA.EQ.3)THEN
C     b plane. -x,1/2+y,z. 0kl : k = 2n.
               NEX = NEX + 1
               IEX(NEX) = 10
            ELSEIF(NA.EQ.4)THEN
C     c plane. -x,y,1/2+z. 0kl : l = 2n.
               NEX = NEX + 1
               IEX(NEX) = 14
            ELSEIF(NA.EQ.5)THEN
C     n plane. -x,1/2+y,1/2+z. 0kl : k + l = 2n.
               NEX = NEX + 1
               IEX(NEX) = 17
            ELSEIF(NA.EQ.6)THEN
C     d plane. -x,1/4+y,1/4+z. 0kl : k + l = 4n.
               NEX = NEX + 1
               IEX(NEX) = 20
            ELSE
               GOTO 880
            ENDIF
 306     CONTINUE
         GOTO 750
      ELSEIF(LAU.EQ.6 .OR. LAU.EQ.7)THEN
C     Spacegroups P4 etc. & P422 etc.
C     Lattice types A, B, & R are not allowed.
         IF(LTP.EQ.2 .OR. LTP.EQ.3 .OR. LTP.EQ.7)GOTO 860
C     Search for screw axes 4(1), 4(2), or 4(3).
         DO 308 I = 1,6
            K = I
            IF(ISYM(I,1).EQ.ICH(22))GOTO 490
 308     CONTINUE
         GOTO 520
      ELSEIF(LAU.EQ.8 .OR. LAU.EQ.9)THEN
C     Spacegroups R3 etc. & R32 etc.
C     Lattice type must be R.
         IF(LTP.NE.7)GOTO 860
C     Check that primary symbol has no screw axes or planes.
         DO 310 I = 1,6
            IF(ISYM(I,1).EQ.ICH(22) .OR. ISYM(I,1).EQ.'/')GOTO 830
 310     CONTINUE
C     No point group extinctions possible for R3 etc.
         IF(LAU.NE.8)THEN
C     Search secondary symbol for glide planes. Reject if a, b, n,
C     or d. Ignore if m.
            DO 311 I = 1,6
               K = I
               IF(ISYM(I,2).GE.'a' .AND. ISYM(I,2).LE.'z')GOTO 580
 311        CONTINUE
         ENDIF
         GOTO 750
      ELSEIF(LAU-9.EQ.1 .OR. LAU-9.EQ.2 .OR. LAU-9.EQ.3)THEN
C     Spacegroups P3 etc, P321 etc, & P312 etc.
C     or R3 & R32 with hexagonal axes.
C     Lattice type must be P or R.
         IF(LTP.NE.1 .AND. LTP.NE.7)GOTO 860
C     Search for screw axis 3(1) or 3(2).
         IF(ISYM(2,1).EQ.ICH(22))THEN
C     3(1) or 3(2) axis. 00l : l = 3n.
            NEX = NEX + 1
            IEX(NEX) = 27
         ENDIF
C     No point group extinctions possible for P3 etc. and R3 etc.
         IF(LAU.NE.10)THEN
C     Spacegroups P3c1, P31c, & R3c.
C     Search secondary or tertiary symbol for glide planes.
C     Reject if a, b, n, or d. Ignore if m.
            J = LAU - 9
            DO 312 I = 1,6
               K = I
               IF(ISYM(I,J).GE.'a' .AND. ISYM(I,J).LE.'z')GOTO 610
 312        CONTINUE
         ENDIF
         GOTO 750
      ELSEIF(LAU-9.EQ.4 .OR. LAU-9.EQ.5)THEN
C     Spacegroups P6 etc. & P622 etc.
C     Lattice type must be P.
         IF(LTP.NE.1)GOTO 860
C     Search for screw axis 6(1), 6(2), 6(3), 6(4), 6(5).
         DO 314 I = 1,6
            K = I
            IF(ISYM(I,1).EQ.ICH(22))GOTO 640
 314     CONTINUE
         GOTO 670
      ELSEIF(LAU-9.EQ.6 .OR. LAU-9.EQ.7)THEN
C     Spacegroups P23 etc. & P432 etc.
C     Lattice type must be P, F, or I.
         IF(LTP.NE.1 .AND. LTP.NE.5 .AND. LTP.NE.6)GOTO 860
C     First symbol. Is first character 2 or 4 ?
         IF(ISYM(1,1).EQ.'2')THEN
C     Check for screw axis 2(1).
            IF(ISYM(2,1).EQ.ICH(22))THEN
C     2(1) axis. 1/2+x,1/2+y,-z. h00 : h = 2n.
C     (Redundant 0k0 : k = 2n, 00l : l = 2n.)
               NEX = NEX + 1
               IEX(NEX) = 6
C     Skip if 2 axis found.
            ENDIF
         ELSEIF(ISYM(1,1).EQ.'4')THEN
C     Check for screw axes 4(1), 4(2), or 4(3).
            IF(ISYM(2,1).EQ.ICH(22))THEN
C     Look at next character to distinguish between 4(1), 4(2),
C     and 4(3).
               NEX = NEX + 1
               IF(ISYM(3,1).EQ.'2')THEN
C     4(2) axis. 1/2+x,-z,y. h00 : h = 2n.
C     (Redundant 0k0 : k = 2n, 00l : l = 2n.)
                  IEX(NEX) = 6
               ELSE
C     4(1) or 4(3) axis. 1/4+x,1/4-z,1/4+y. h00 : h = 4n.
C     (Redundant 0k0 : k = 4n, 00l : l = 4n.)
                  IEX(NEX) = 30
               ENDIF
C     Skip if 4 or -4 axes found.
            ENDIF
C     Skip if plane found.
         ENDIF
C     Search for glide planes.
         DO 316 I = 1,6
            K = I
            IF(ISYM(I,1).GE.'a' .AND. ISYM(I,1).LE.'z')GOTO 680
 316     CONTINUE
         GOTO 710
      ELSE
         GOTO 880
      ENDIF
C     Search for glide planes. Reject if a or d. Ignore if m.
 320  DO 330 I = 2,20
         J = I
         IF(ISGP(I).GE.'a' .AND. ISGP(I).LE.'z')GOTO 340
 330  CONTINUE
      GOTO 750
 340  DO 350 I = 14,19
         NA = I - 13
         IF(ISGP(J).EQ.ICH(I))GOTO 360
 350  CONTINUE
      GOTO 880
C     Found m, a, b, c, n, or d.
 360  IF(NA.EQ.1)THEN
      ELSEIF(NA.EQ.2 .OR. NA.EQ.6)THEN
         GOTO 830
      ELSEIF(NA.EQ.3)THEN
C     b plane. -x,1/2+y,z. 0kl : k = 2n.
         NEX = NEX + 1
         IEX(NEX) = 10
      ELSEIF(NA.EQ.4)THEN
C     c plane. -x,y,1/2+z. 0kl : l = 2n.
         NEX = NEX + 1
         IEX(NEX) = 14
      ELSEIF(NA.EQ.5)THEN
C     n plane. -x,1/2+y,1/2+z. 0kl : k + l = 2n.
         NEX = NEX + 1
         IEX(NEX) = 17
      ELSE
         GOTO 880
      ENDIF
      GOTO 750
C     2(1) axis. -x,1/2+y,-z. 0k0 : k = 2n.
 370  NEX = NEX + 1
      IEX(NEX) = 7
C     Search for glide planes. Reject if b or d. Ignore if m.
 380  DO 390 I = 2,20
         J = I
         IF(ISGP(I).GE.'a' .AND. ISGP(I).LE.'z')GOTO 400
 390  CONTINUE
      GOTO 750
 400  DO 410 I = 14,19
         NA = I - 13
         IF(ISGP(J).EQ.ICH(I))GOTO 420
 410  CONTINUE
      GOTO 880
C     Found m, a, b, c, n, or d.
 420  IF(NA.EQ.1)THEN
      ELSEIF(NA.EQ.2)THEN
C     a plane. 1/2+x,-y,z. h0l : h = 2n.
         NEX = NEX + 1
         IEX(NEX) = 12
      ELSEIF(NA.EQ.3 .OR. NA.EQ.6)THEN
         GOTO 830
      ELSEIF(NA.EQ.4)THEN
C     c plane. x,-y,1/2+z. h0l : l = 2n.
         NEX = NEX + 1
         IEX(NEX) = 11
      ELSEIF(NA.EQ.5)THEN
C     n plane. 1/2+x,-y,1/2+z. h0l : h + l = 2n.
         NEX = NEX + 1
         IEX(NEX) = 16
      ELSE
         GOTO 880
      ENDIF
      GOTO 750
C     2(1) axis. -x,-y,1/2+z. 00l : l = 2n.
 430  NEX = NEX + 1
      IEX(NEX) = 8
C     Search for glide planes. Reject if c or d. Ignore if m.
 440  DO 450 I = 2,20
         J = I
         IF(ISGP(I).GE.'a' .AND. ISGP(I).LE.'z')GOTO 460
 450  CONTINUE
      GOTO 750
 460  DO 470 I = 14,19
         NA = I - 13
         IF(ISGP(J).EQ.ICH(I))GOTO 480
 470  CONTINUE
      GOTO 880
C     Found m, a, b, c, n, or d.
 480  IF(NA.EQ.1)THEN
      ELSEIF(NA.EQ.2)THEN
C     a plane. 1/2+x,y,-z. hk0 : h = 2n.
         NEX = NEX + 1
         IEX(NEX) = 9
      ELSEIF(NA.EQ.3)THEN
C     b plane. x,1/2+y,-z. hk0 : k = 2n.
         NEX = NEX + 1
         IEX(NEX) = 13
      ELSEIF(NA.EQ.4 .OR. NA.EQ.6)THEN
         GOTO 830
      ELSEIF(NA.EQ.5)THEN
C     n plane. 1/2+x,1/2+y,-z. hk0 : h + k = 2n.
         NEX = NEX + 1
         IEX(NEX) = 15
      ELSE
         GOTO 880
      ENDIF
      GOTO 750
C     4(1), 4(2), or 4(3) axis along z.
 490  NEX = NEX + 1
      K = K + 1
C     Look at next character to distinguish between 4(1), 4(2),
C     and 4(3).
      DO 500 I = 8,10
         NA = I - 8
         IF(ISYM(K,1).EQ.ICH(I))GOTO 510
 500  CONTINUE
      GOTO 880
 510  IF(NA.EQ.1)THEN
C     4(2) axis. -y,x,1/2+z. 00l : l = 2n.
         IEX(NEX) = 8
      ELSE
C     4(1) or 4(3) axis. -y,x,1/4+z etc. 00l : l = 4n.
         IEX(NEX) = 21
      ENDIF
C     Search for glide planes. Reject if c, ignore if m.
 520  DO 530 I = 1,6
         K = I
         IF(ISYM(I,1).GE.'a' .AND. ISYM(I,1).LE.'z')GOTO 540
 530  CONTINUE
      GOTO 570
 540  DO 550 I = 14,19
         NA = I - 13
         IF(ISYM(K,1).EQ.ICH(I))GOTO 560
 550  CONTINUE
      GOTO 880
C     Refers to z axis.
C     Found m, a, b, c, n, or d.
 560  IF(NA.EQ.1)THEN
      ELSEIF(NA.EQ.2 .OR. NA.EQ.3)THEN
C     a & b planes. 1/2+x,y,-z. hk0 : h = 2n, k = 2n.
         NEX = NEX + 1
         IEX(NEX) = 9
         NEX = NEX + 1
         IEX(NEX) = 13
      ELSEIF(NA.EQ.4)THEN
         GOTO 830
      ELSEIF(NA.EQ.5)THEN
C     n plane. 1/2+x,1/2+y,-z. hk0 : h + k = 2n.
         NEX = NEX + 1
         IEX(NEX) = 15
      ELSEIF(NA.EQ.6)THEN
C     d plane. 1/4+x,1/4+y,1/4-z. hk0 : h + k = 4n.
         NEX = NEX + 1
         IEX(NEX) = 18
      ELSE
         GOTO 880
      ENDIF
 570  IF(LAU.NE.6)THEN
C     Spacegroups P422 etc.
C     Search secondary and tertiary symbols.
C     These apply to [100] and [110] directions respectively.
         DO 578 J = 2,3
C     Search for screw axis 2(1).
            DO 571 I = 1,6
               IF(ISYM(I,J).EQ.ICH(22))GOTO 572
 571        CONTINUE
            GOTO 573
 572        IF(J.EQ.3)THEN
C     2(1) axis along [110]. 1/4+y,1/4+x,-z. hh0 : h = 2n.
               NEX = NEX + 1
               IEX(NEX) = 24
            ELSE
C     2(1) axis along x. 1/2+x,-y,-z. h00 : h = 2n.
               NEX = NEX + 1
               IEX(NEX) = 6
            ENDIF
C     Search for glide planes. Ignore if m.
 573        DO 574 I = 1,6
               K = I
               IF(ISYM(I,J).GE.'a' .AND. ISYM(I,J).LE.'z')GOTO 575
 574        CONTINUE
            GOTO 578
 575        DO 576 I = 14,19
               NA = I - 13
               IF(ISYM(K,J).EQ.ICH(I))GOTO 577
 576        CONTINUE
            GOTO 880
 577        IF(J.EQ.3)THEN
C     Refers to [110] direction.
C     Found m, a, b, c, n, or d.
               IF(NA.EQ.1)THEN
               ELSEIF(NA.EQ.2 .OR. NA.EQ.3)THEN
C     a plane. 1/2+y,1/2+x,z. hhl : h = 2n.
                  NEX = NEX + 1
                  IEX(NEX) = 23
               ELSEIF(NA.EQ.4)THEN
C     c plane. y,x,1/2+z. hhl : l = 2n.
                  NEX = NEX + 1
                  IEX(NEX) = 22
               ELSEIF(NA.EQ.5)THEN
C     n plane.
                  NEX = NEX + 1
                  IEX(NEX) = 25
               ELSEIF(NA.EQ.6)THEN
C     d plane.
                  NEX = NEX + 1
                  IEX(NEX) = 26
               ELSE
                  GOTO 880
               ENDIF
C     Refers to x & y axes.
C     Found m, a, b, c, n, or d.
            ELSEIF(NA.EQ.1)THEN
            ELSEIF(NA.EQ.2 .OR. NA.EQ.3)THEN
C     a & b planes. 1/2+x,-y,z. h0l : h = 2n.
C     (Redundant 0kl : k = 2n.)
               NEX = NEX + 1
               IEX(NEX) = 12
            ELSEIF(NA.EQ.4)THEN
C     c plane. x,-y,1/2+z. h0l : l = 2n.
C     (Redundant 0kl : l = 2n.)
               NEX = NEX + 1
               IEX(NEX) = 11
            ELSEIF(NA.EQ.5)THEN
C     n plane. 1/2+x,-y,1/2+z. h0l : h + l = 2n.
C     (Redundant 0kl : k + l = 2n.)
               NEX = NEX + 1
               IEX(NEX) = 16
            ELSEIF(NA.EQ.6)THEN
C     d plane. 1/4+x,-y,1/4+z. h0l : h + l = 4n.
C     (Redundant 0kl : k + l = 4n.)
               NEX = NEX + 1
               IEX(NEX) = 19
            ELSE
               GOTO 880
            ENDIF
 578     CONTINUE
      ENDIF
      GOTO 750
 580  DO 590 I = 14,19
         NA = I - 13
         IF(ISYM(K,2).EQ.ICH(I))GOTO 600
 590  CONTINUE
      GOTO 880
C     Found m, a, b, c, n, or d.
 600  IF(NA.EQ.1)THEN
      ELSEIF(NA.EQ.2 .OR. NA.EQ.3 .OR. NA.EQ.5 .OR. NA.EQ.6)THEN
         GOTO 830
      ELSEIF(NA.EQ.4)THEN
C     c plane. 1/2+y,1/2+x,1/2+z. hhl : l = 2n, hkk : h = 2n.
         NEX = NEX + 1
         IEX(NEX) = 22
         NEX = NEX + 1
         IEX(NEX) = 29
      ELSE
         GOTO 880
      ENDIF
      GOTO 750
 610  DO 620 I = 14,19
         NA = I - 13
         IF(ISYM(K,J).EQ.ICH(I))GOTO 630
 620  CONTINUE
      GOTO 880
C     Found m, a, b, c, n, or d.
 630  IF(NA.EQ.1)THEN
      ELSEIF(NA.EQ.2 .OR. NA.EQ.3 .OR. NA.EQ.5 .OR. NA.EQ.6)THEN
         GOTO 830
      ELSEIF(NA.EQ.4)THEN
         IF(LAU.EQ.12)THEN
C     Tertiary symbol.
C     c plane. hhl : l = 2n & 2h-hl : l = 2n.
            NEX = NEX + 1
            IEX(NEX) = 22
            NEX = NEX + 1
            IEX(NEX) = 31
         ELSE
C     Secondary symbol.
C     c plane.  h0l : l = 2n & 0kl : l = 2n.
            NEX = NEX + 1
            IEX(NEX) = 11
            NEX = NEX + 1
            IEX(NEX) = 14
         ENDIF
      ELSE
         GOTO 880
      ENDIF
      GOTO 750
 640  NEX = NEX + 1
      K = K + 1
C     Look at next character to distinguish between 6(1), 6(2),
C     6(3), 6(4), and 6(5).
      DO 650 I = 8,12
         NA = I - 7
         IF(ISYM(K,1).EQ.ICH(I))GOTO 660
 650  CONTINUE
      GOTO 880
 660  IF(NA.EQ.1 .OR. NA.EQ.5)THEN
         IEX(NEX) = 28
      ELSEIF(NA.EQ.2 .OR. NA.EQ.4)THEN
         IEX(NEX) = 27
      ELSEIF(NA.EQ.3)THEN
         IEX(NEX) = 8
      ELSE
         GOTO 880
      ENDIF
 670  IF(LAU.NE.13)THEN
C     Spacegroups P622 etc.
C     Search secondary or tertiary symbol for glide planes.
C     Reject if a, b, n, or d. Ignore if m.
         DO 676 J = 2,3
            DO 671 I = 1,6
               K = I
               IF(ISYM(I,J).GE.'a' .AND. ISYM(I,J).LE.'z')GOTO 672
 671        CONTINUE
            GOTO 676
 672        DO 673 I = 14,19
               NA = I - 13
               IF(ISYM(K,J).EQ.ICH(I))GOTO 674
 673        CONTINUE
            GOTO 880
C     Found m, a, b, c, n, or d.
 674        IF(NA.EQ.1)THEN
            ELSEIF(NA.EQ.2 .OR. NA.EQ.3 .OR. NA.EQ.5 .OR. NA.EQ.6)THEN
               GOTO 830
            ELSEIF(NA.EQ.4)THEN
               IF(J.EQ.3)THEN
C     Tertiary symbol.
C     c plane. hhl : l = 2n.
                  NEX = NEX + 1
                  IEX(NEX) = 22
               ELSE
C     Secondary symbol.
C     c plane. h0l : l = 2n.
                  NEX = NEX + 1
                  IEX(NEX) = 11
               ENDIF
            ELSE
               GOTO 880
            ENDIF
 676     CONTINUE
      ENDIF
      GOTO 750
 680  DO 690 I = 14,19
         NA = I - 13
         IF(ISYM(K,1).EQ.ICH(I))GOTO 700
 690  CONTINUE
      GOTO 880
C     Found m, a, b, c, n, or d.
 700  IF(NA.EQ.1)THEN
      ELSEIF(NA.EQ.2 .OR. NA.EQ.3 .OR. NA.EQ.4)THEN
C     a (or b or c) plane. 1/2+x,y,-z. hk0 : h = 2n (cyc).
         NEX = NEX + 1
         IEX(NEX) = 9
         IF(LAU.NE.16)THEN
C     h0l : l = 2n (Spacegroups P23 etc. only)
            NEX = NEX + 1
            IEX(NEX) = 11
         ENDIF
      ELSEIF(NA.EQ.5)THEN
C     n plane. 1/2+x,1/2+y,1/2-z. hk0 : h + k = 2n (cyc).
         NEX = NEX + 1
         IEX(NEX) = 15
         IF(LAU.NE.16)THEN
C     h0l : h + l = 2n (Spacegroups P23 etc. only)
            NEX = NEX + 1
            IEX(NEX) = 16
         ENDIF
      ELSEIF(NA.EQ.6)THEN
C     d plane. 1/4+x,1/4+y,1/4-z. hk0 : h + k = 4n (cyc).
         NEX = NEX + 1
         IEX(NEX) = 18
         IF(LAU.NE.16)THEN
C     h0l : h + l = 4n (Spacegroups P23 etc. only)
            NEX = NEX + 1
            IEX(NEX) = 19
         ENDIF
      ELSE
         GOTO 880
      ENDIF
C     Spacegroups P432 etc.
 710  IF(LAU.NE.15)THEN
C     Tertiary symbol.
C     Search for glide planes.
         DO 712 I = 1,6
            K = I
            IF(ISYM(I,3).GE.'a' .AND. ISYM(I,3).LE.'z')GOTO 720
 712     CONTINUE
      ENDIF
      GOTO 750
 720  DO 730 I = 14,19
         NA = I - 13
         IF(ISYM(K,3).EQ.ICH(I))GOTO 740
 730  CONTINUE
      GOTO 880
 740  ISO = ISO + 1
C     Found m, a, b, c, n, or d.
      IF(NA.EQ.1)THEN
      ELSEIF(NA.EQ.2 .OR. NA.EQ.3 .OR. NA.EQ.4 .OR. NA.EQ.5)THEN
C     a, b, and c planes. y,x,1/2+z. hhl : l = 2n, hkk : h = 2n.
C     (Redundant hkh : k = 2n.)
C     Also n plane.
         NEX = NEX + 1
         IEX(NEX) = 22
         NEX = NEX + 1
         IEX(NEX) = 29
      ELSEIF(NA.EQ.6)THEN
C     d plane. hhl : 2h + l = 4n, hkk : h + 2k = 4n.
C     (Redundant hkh : 2h + k = 4n.)
         NEX = NEX + 1
         IEX(NEX) = 26
         NEX = NEX + 1
         IEX(NEX) = 32
      ELSE
         GOTO 880
      ENDIF
C
C     Start of section XI of program.
C     ------------------------------
C
C     Remove surplus extinction rules.
C     This is non-essential and is omitted from the current version.
C
C     Start of section XII of program.
C     -------------------------------
C
C     Write out extinctions conditions.
 750  IF(NEX.EQ.0)THEN
         WRITE(LPT,5080)
      ELSE
         WRITE(LPT,5090)
         DO 752 I = 1,NEX
            IF(IEX(I).EQ.1)THEN
               WRITE(LPT,5100)
            ELSEIF(IEX(I).EQ.2)THEN
               WRITE(LPT,5110)
            ELSEIF(IEX(I).EQ.3)THEN
               WRITE(LPT,5120)
            ELSEIF(IEX(I).EQ.4)THEN
               WRITE(LPT,5130)
            ELSEIF(IEX(I).EQ.5)THEN
               WRITE(LPT,5140)
            ELSEIF(IEX(I).EQ.6)THEN
               WRITE(LPT,5150)
            ELSEIF(IEX(I).EQ.7)THEN
               WRITE(LPT,5160)
            ELSEIF(IEX(I).EQ.8)THEN
               WRITE(LPT,5170)
            ELSEIF(IEX(I).EQ.9)THEN
               WRITE(LPT,5180)
            ELSEIF(IEX(I).EQ.10)THEN
               WRITE(LPT,5190)
            ELSEIF(IEX(I)-10.EQ.1)THEN
               WRITE(LPT,5200)
            ELSEIF(IEX(I)-10.EQ.2)THEN
               WRITE(LPT,5210)
            ELSEIF(IEX(I)-10.EQ.3)THEN
               WRITE(LPT,5220)
            ELSEIF(IEX(I)-10.EQ.4)THEN
               WRITE(LPT,5230)
            ELSEIF(IEX(I)-10.EQ.5)THEN
               WRITE(LPT,5240)
            ELSEIF(IEX(I)-10.EQ.6)THEN
               WRITE(LPT,5250)
            ELSEIF(IEX(I)-10.EQ.7)THEN
               WRITE(LPT,5260)
            ELSEIF(IEX(I)-10.EQ.8)THEN
               WRITE(LPT,5270)
            ELSEIF(IEX(I)-10.EQ.9)THEN
               WRITE(LPT,5280)
            ELSEIF(IEX(I)-10.EQ.10)THEN
               WRITE(LPT,5290)
            ELSEIF(IEX(I)-20.EQ.1)THEN
               WRITE(LPT,5300)
            ELSEIF(IEX(I)-20.EQ.2)THEN
               WRITE(LPT,5310)
            ELSEIF(IEX(I)-20.EQ.3)THEN
               WRITE(LPT,5320)
            ELSEIF(IEX(I)-20.EQ.4)THEN
               WRITE(LPT,5330)
            ELSEIF(IEX(I)-20.EQ.5)THEN
               WRITE(LPT,5340)
            ELSEIF(IEX(I)-20.EQ.6)THEN
               WRITE(LPT,5350)
            ELSEIF(IEX(I)-20.EQ.7)THEN
               WRITE(LPT,5360)
            ELSEIF(IEX(I)-20.EQ.8)THEN
               WRITE(LPT,5370)
            ELSEIF(IEX(I)-20.EQ.9)THEN
               WRITE(LPT,5380)
            ELSEIF(IEX(I)-20.EQ.10)THEN
               WRITE(LPT,5390)
            ELSEIF(IEX(I)-30.EQ.1)THEN
               WRITE(LPT,5400)
            ELSEIF(IEX(I)-30.EQ.2)THEN
               WRITE(LPT,5410)
            ELSE
               GOTO 880
            ENDIF
 752     CONTINUE
      ENDIF
C
C     Start of section XIII of program.
C     --------------------------------
C
C     Determine limits.
      DL = 1.0/DMIN
      QMAX = DL*DL
      MAXH = INT(A*DL) + 1
      MAXK = INT(B*DL) + 1
      MAXL = INT(C*DL) + 1
      WRITE(LPT,5420)MAXH,MAXK,MAXL
C     Loop through all reflections.
C     1 Triclinic l >= 0 exc. hk0, k < 0, and exc. h00 h <= 0
C     2 Monoclinic (a-unique) h >= 0, k >= 0 exc. h0l, l < 0
C     3            (b-unique) k >= 0, l >= 0 exc. hk0, h < 0
C     4            (c-unique) h >= 0, l >= 0 exc. 0kl, k < 0
C     5 Orthorhombic h >= 0, k >= 0, l >= 0
C     6 Tetragonal a) h >= 0, k >= 0, l >= 0 exc. 0kl
C     7            b) h >= k >= 0, l >= 0
C     8 Trigonal (Rhombohedral) a) h >= k >= 0 exc. 0kl, l < 0, and
C                                  exc. hkl, h <= l and k < l.
C     9                         b) h >= k >= 0 exc. 0kl, and
C                                  exc. hkl, k < l.
C     10         (Hexagonal) a) h > - k, k >= 0, l >= 0 exc. hk0, h < 0
C     11                     b) h >= 0, k >= 0, l >= 0 exc. hk0, h < k
C     12                     c) h >= 0, h >= - 2k, h >= k, l >= 0
C                               exc. hk0 k < 0
C     13 Hexagonal a) h >= 0, k >= 0, l >= 0 exc. 0kl
C     14           b) h >= k >= 0, l >= 0
C     15 Cubic a) h >= k >= 0, l >= 0 exc. hkl, h <= l and k < l
C     16       b) h >= k >= l >= 0
      IF(LAU.EQ.1)CTYPE = 'TRIC'
      IF(LAU.EQ.2)CTYPE = 'MON1'
      IF(LAU.EQ.3)CTYPE = 'MON2'
      IF(LAU.EQ.4)CTYPE = 'MON3'
      IF(LAU.EQ.5)CTYPE = 'ORTH'
      IF(LAU.EQ.6 .OR. LAU.EQ.7)CTYPE = 'TETR'
      IF(LAU.GE.10 .AND. LAU.LE.14)CTYPE = 'TRIG'
      IF(LAU.EQ.15 .OR. LAU.EQ.16)CTYPE = 'CUBI'
      N = 0
      MINL = 0
      IF(LAU.EQ.2 .OR. LAU.EQ.8 .OR. LAU.EQ.9)MINL = -MAXL
      DO 770 NL = MINL,MAXL
         IF(LAU.EQ.1)GOTO 754
         IF(LAU.EQ.2)THEN
            MINK = 0
            IF(NL.LT.0)MINK = 1
         ELSEIF(LAU.EQ.3 .OR. LAU.EQ.5 .OR. LAU.EQ.6 .OR. LAU.EQ.7 .OR. 
     &          LAU.EQ.8)THEN
            MINK = 0
         ELSEIF(LAU.EQ.4)THEN
            MINK = -MAXK
         ELSEIF(LAU.EQ.9)THEN
            MINK = MAX0(NL,0)
         ELSEIF(LAU-9.EQ.1 .OR. LAU-9.EQ.2 .OR. LAU-9.EQ.4 .OR. 
     &          LAU-9.EQ.5 .OR. LAU-9.EQ.6)THEN
            MINK = 0
         ELSEIF(LAU-9.EQ.7)THEN
            MINK = NL
         ELSE
            GOTO 754
         ENDIF
         GOTO 756
 754     MINK = -MAXK
         IF(NL.EQ.0)MINK = 0
 756     DO 764 NK = MINK,MAXK
            IF(LAU.EQ.1)GOTO 757
            IF(LAU.EQ.2 .OR. LAU.EQ.5)THEN
               MINH = 0
            ELSEIF(LAU.EQ.3)THEN
               MINH = -MAXH
               IF(NL.EQ.0)MINH = 0
            ELSEIF(LAU.EQ.4)THEN
               MINH = 0
               IF(NK.LT.0)MINH = 1
            ELSEIF(LAU.EQ.6)THEN
               MINH = MIN0(NK,1)
            ELSEIF(LAU.EQ.7)THEN
               MINH = NK
            ELSEIF(LAU.EQ.8)THEN
               MINH = NK
               IF(NL.LT.0)MINH = 1
               IF(NK.LT.NL)MINH = NL + 1
            ELSEIF(LAU.EQ.9)THEN
               MINH = MAX0(NK,1)
               IF(NK.EQ.0)MINH = -NL
            ELSEIF(LAU-9.EQ.1)THEN
               MINH = MIN0((1-NK),0)
               IF(NL.EQ.0)MINH = 1
            ELSEIF(LAU-9.EQ.2)THEN
               MINH = 0
               IF(NL.EQ.0)MINH = NK
            ELSEIF(LAU-9.EQ.3)THEN
               MINH = MAX0(NK,-(2*NK))
            ELSEIF(LAU-9.EQ.4)THEN
               MINH = MIN0(NK,1)
            ELSEIF(LAU-9.EQ.5 .OR. LAU-9.EQ.7)THEN
               MINH = NK
            ELSEIF(LAU-9.EQ.6)THEN
               MINH = NK
               IF(NK.LT.NL)MINH = NL + 1
            ELSE
               GOTO 757
            ENDIF
            GOTO 758
 757        MINH = -MAXH
            IF(NK.EQ.0 .AND. NL.EQ.0)MINH = 0
 758        DO 762 NH = MINH,MAXH
               Q = NH*NH*AR2 + NK*NK*BR2 + NL*NL*CR2 + NK*NL*BCR + 
     &             NL*NH*CAR + NH*NK*ABR
C     Reject 0,0,0 and h,k,l outside maximum 2-theta.
               IF(Q.EQ.0.0 .OR. Q.GE.QMAX)GOTO 762
C     Check extinctions.
               IF(NEX.NE.0)THEN
C     The following extinctions may occur.
C     (1)   hkl : k + l = 2n.
C     (2)   hkl : h + l = 2n.
C     (3)   hkl : h + k = 2n.
C     (4)   hkl : h + k + l = 2n.
C     (5)   hkl : - h + k + l = 3n.
C     (6)   h00 : h = 2n.
C     (7)   0k0 : k = 2n.
C     (8)   00l : l = 2n.
C     (9)   hk0 : h = 2n.
C     (10)  0kl : k = 2n.
C     (11)  h0l : l = 2n.
C     (12)  h0l : h = 2n.
C     (13)  hk0 : k = 2n.
C     (14)  0kl : l = 2n.
C     (15)  hk0 : h + k = 2n.
C     (16)  h0l : h + l = 2n.
C     (17)  0kl : k + l = 2n.
C     (18)  hk0 : h + k = 4n.
C     (19)  h0l : h + l = 4n.
C     (20)  0kl : k + l = 4n.
C     (21)  00l : l = 4n.
C     (22)  hhl : l = 2n.
C     (23)  hhl : h = 2n.
C     (24)  hh0 : h = 2n.
C     (25)  hhl : h + l = 2n.
C     (26)  hhl : 2h + l = 4n.
C     (27)  00l : l = 3n.
C     (28)  00l : l = 6n.
C     (29)  hkk : h = 2n.
C     (30)  h00 : h = 4n.
C     (31)  2h-hl : l = 2n.
C     (32)  hkk : h + 2k = 4n.
                  DO 759 I = 1,NEX
                     IF(IEX(I).EQ.1)THEN
                     ELSEIF(IEX(I).EQ.2)THEN
C     l + h = 2n for hkl.
                        IF(MOD((NL+NH),2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I).EQ.3)THEN
C     h + k = 2n for hkl.
                        IF(MOD((NH+NK),2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I).EQ.4)THEN
C     h + k + l = 2n for hkl.
                        IF(MOD((NH+NK+NL),2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I).EQ.5)THEN
C     - h + k + l = 3n for hkl.
                        IF(MOD((-NH+NK+NL),3).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I).EQ.6)THEN
C     Special extinctions.
C     h = 2n for h00.
                        IF(NK.NE.0 .OR. NL.NE.0)GOTO 759
                        IF(MOD(NH,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I).EQ.7)THEN
C     k = 2n for 0k0.
                        IF(NH.NE.0 .OR. NL.NE.0)GOTO 759
                        IF(MOD(NK,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I).EQ.8)THEN
C     l = 2n for 00l.
                        IF(NH.NE.0 .OR. NK.NE.0)GOTO 759
                        IF(MOD(NL,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I).EQ.9)THEN
C     h = 2n for hk0.
                        IF(NL.NE.0)GOTO 759
                        IF(MOD(NH,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I).EQ.10)THEN
C     k = 2n for 0kl.
                        IF(NH.NE.0)GOTO 759
                        IF(MOD(NK,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-10.EQ.1)THEN
C     l = 2n for h0l.
                        IF(NK.NE.0)GOTO 759
                        IF(MOD(NL,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-10.EQ.2)THEN
C     h = 2n for h0l.
                        IF(NK.NE.0)GOTO 759
                        IF(MOD(NH,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-10.EQ.3)THEN
C     k = 2n for hk0.
                        IF(NL.NE.0)GOTO 759
                        IF(MOD(NK,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-10.EQ.4)THEN
C     l = 2n for 0kl.
                        IF(NH.NE.0)GOTO 759
                        IF(MOD(NL,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-10.EQ.5)THEN
C     h + k = 2n for hk0.
                        IF(NL.NE.0)GOTO 759
                        IF(MOD((NH+NK),2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-10.EQ.6)THEN
C     h + l = 2n for h0l.
                        IF(NK.NE.0)GOTO 759
                        IF(MOD((NL+NH),2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-10.EQ.7)THEN
C     k + l = 2n for 0kl.
                        IF(NH.NE.0)GOTO 759
                        IF(MOD((NK+NL),2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-10.EQ.8)THEN
C     h + k = 4n for hk0.
                        IF(NL.NE.0)GOTO 759
                        IF(MOD((NH+NK),4).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-10.EQ.9)THEN
C     h + l = 4n for h0l.
                        IF(NK.NE.0)GOTO 759
                        IF(MOD((NL+NH),4).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-10.EQ.10)THEN
C     k + l = 4n for 0kl.
                        IF(NH.NE.0)GOTO 759
                        IF(MOD((NK+NL),4).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-20.EQ.1)THEN
C     l = 4n for 00l.
                        IF((NH+NK).NE.0)GOTO 759
                        IF(MOD(NL,4).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-20.EQ.2)THEN
C     l = 2n for hhl.
                        IF((NH-NK).NE.0)GOTO 759
                        IF(MOD(NL,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-20.EQ.3)THEN
C     h = 2n for hhl.
                        IF((NH-NK).NE.0)GOTO 759
                        IF(MOD(NH,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-20.EQ.4)THEN
C     h = 2n for hh0.
                        IF((NH-NK).NE.0 .OR. NL.NE.0)GOTO 759
                        IF(MOD(NH,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-20.EQ.5)THEN
C     h + l = 2n for hhl.
                        IF((NH-NK).NE.0)GOTO 759
                        IF(MOD((NH+NL),2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-20.EQ.6)THEN
C     2h + l = 4n for hhl.
                        IF((NH-NK).NE.0)GOTO 759
                        IF(MOD((NH+NH+NL),4).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-20.EQ.7)THEN
C     l = 3n for 00l.
                        IF(NH.NE.0 .OR. NK.NE.0)GOTO 759
                        IF(MOD(NL,3).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-20.EQ.8)THEN
C     l = 6n for 00l.
                        IF(NH.NE.0 .OR. NK.NE.0)GOTO 759
                        IF(MOD(NL,6).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-20.EQ.9)THEN
C     h = 2n for hkk.
                        IF(NK.NE.NL)GOTO 759
                        IF(MOD(NH,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-20.EQ.10)THEN
C     h = 4n for h00.
                        IF(NK.NE.0 .OR. NL.NE.0)GOTO 759
                        IF(MOD(NH,4).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-30.EQ.1)THEN
C     l = 2n for 2h-hl.
                        IF(NH.NE.-(NK+NK))GOTO 759
                        IF(MOD(NL,2).NE.0)GOTO 762
                        GOTO 759
                     ELSEIF(IEX(I)-30.EQ.2)THEN
C     h + 2k = 4n for hkk.
                        IF(NK.NE.NL)GOTO 759
                        IF(MOD((NH+NK+NK),4).NE.0)GOTO 762
                        GOTO 759
                     ENDIF
C     General extinctions.
C     k + l = 2n for hkl.
                     IF(MOD((NK+NL),2).NE.0)GOTO 762
 759              CONTINUE
               ENDIF
C     Calculate multiplicity.
C     1 Triclinic J = 2 all h,k,l.
C     2 Monoclinic (a-unique) J = 2 for 0kl or h00, others J = 4.
C     3            (b-unique) J = 2 for h0l or 0k0, others J = 4.
C     4            (c-unique) J = 2 for hk0 or 00l, others J = 4.
C     5 Orthorhombic J = 2 for h00, 0k0, or 00l, J = 4 for hk0, h0l,
C                    or 0kl, others J = 8.
C     6 Tetragonal a) J = 2 for 00l, J = 4 for h00, 0k0, or hk0,
C                     others J = 8.
C     7            b) J = 2 for 00l, J = 4 for h00 or hh0,
C                     J = 8 for h0l, hk0, or hhl, others J = 16.
C     8 Trigonal (Rhomohedral) a) J = 2 for hhh, others J = 6.
C     9                        b) J = 2 for hhh, J = 6 for hhl, hkk,
C                                 or h0-l, others J = 12.
C     10         (Hexagonal) a) J = 2 for 00l, others J = 6.
C     11                     b) J = 2 for 00l, J = 6 for h0l, 0kl,
C                               or hh0, others J = 12.
C     12                     c) J = 2 for 00l, J = 6 for h00, hhl,
C                               or 2h-hl, others J = 12.
C     13 Hexagonal a) J = 2 for 00l, J = 6 for h00, hh0, or hk0,
C                     others J = 12
C     14           b) J = 2 for 00l, J = 6 for h00 or hh0, J = 12 for
C                     hk0, h0l, or hhl, others J = 24
C     15 Cubic a) J = 6 for h00, J = 8 for hhh, J = 12 for hh0 or hk0,
C                 others J = 24
C     16       b) J = 6 for h00, J = 8 for hhh, J = 12 for hh0,
C                 J = 24 for hk0, hhl, or hkk, others J = 48
               IF(LAU.EQ.1)THEN
C     Set multiplicity factor to 2, 4, 6, 8, 12, 16, 24, or 48.
                  MF = 2
               ELSEIF(LAU.EQ.2)THEN
                  GOTO 760
               ELSEIF(LAU.EQ.3)THEN
                  IF(NK.EQ.0)THEN
                     MF = 2
                  ELSEIF(NL.EQ.0 .AND. NH.EQ.0)THEN
                     MF = 2
                  ELSE
                     MF = 4
                  ENDIF
               ELSEIF(LAU.EQ.4)THEN
                  IF(NL.EQ.0)THEN
                     MF = 2
                  ELSEIF(NH.EQ.0 .AND. NK.EQ.0)THEN
                     MF = 2
                  ELSE
                     MF = 4
                  ENDIF
               ELSEIF(LAU.EQ.5)THEN
                  IF((NH+NK).EQ.0)THEN
                     MF = 2
                  ELSEIF((NK+NL).EQ.0)THEN
                     MF = 2
                  ELSEIF((NL+NH).EQ.0)THEN
                     MF = 2
                  ELSEIF(NH.EQ.0)THEN
                     MF = 4
                  ELSEIF(NK.EQ.0)THEN
                     MF = 4
                  ELSEIF(NL.EQ.0)THEN
                     MF = 4
                  ELSE
                     MF = 8
                  ENDIF
               ELSEIF(LAU.EQ.6)THEN
                  IF((NH+NK).EQ.0)THEN
                     MF = 2
                  ELSEIF(NL.EQ.0)THEN
                     MF = 4
                  ELSE
                     MF = 8
                  ENDIF
               ELSEIF(LAU.EQ.7)THEN
                  IF((NH+NK).EQ.0)THEN
                     MF = 2
                  ELSEIF(NL.EQ.0 .AND. (NH.EQ.NK.OR.NK.EQ.0))THEN
                     MF = 4
                  ELSEIF(NL.EQ.0 .OR. NK.EQ.0 .OR. NH.EQ.NK)THEN
                     MF = 8
                  ELSE
                     MF = 16
                  ENDIF
               ELSEIF(LAU.EQ.8)THEN
                  IF(NH.EQ.NK .AND. NK.EQ.NL)THEN
                     MF = 2
                  ELSE
                     MF = 6
                  ENDIF
               ELSEIF(LAU.EQ.9)THEN
                  IF(NH.EQ.NK .AND. NK.EQ.NL)THEN
                     MF = 2
                  ELSEIF(NH.EQ.NK .OR. NK.EQ.NL .OR. 
     &                   ((NH+NL).EQ.0.AND.NK.EQ.0))THEN
                     MF = 6
                  ELSE
                     MF = 12
                  ENDIF
               ELSEIF(LAU-9.EQ.1)THEN
                  IF((NH+NK).EQ.0)THEN
                     MF = 2
                  ELSE
                     MF = 6
                  ENDIF
               ELSEIF(LAU-9.EQ.2)THEN
                  IF((NH+NK).EQ.0)THEN
                     MF = 2
                  ELSEIF(NH.EQ.0 .OR. NK.EQ.0 .OR. 
     &                   (NL.EQ.0.AND.NH.EQ.NK))THEN
                     MF = 6
                  ELSE
                     MF = 12
                  ENDIF
               ELSEIF(LAU-9.EQ.3)THEN
                  IF((NH+NK).EQ.0)THEN
                     MF = 2
                  ELSEIF(NH.EQ.NK .OR. NK.EQ.-(NH+NK) .OR. 
     &                   (NL.EQ.0.AND.NK.EQ.0))THEN
                     MF = 6
                  ELSE
                     MF = 12
                  ENDIF
               ELSEIF(LAU-9.EQ.4)THEN
                  IF((NH+NK).EQ.0)THEN
                     MF = 2
                  ELSEIF(NL.EQ.0)THEN
                     MF = 6
                  ELSE
                     MF = 12
                  ENDIF
               ELSEIF(LAU-9.EQ.5)THEN
                  IF((NH+NK).EQ.0)THEN
                     MF = 2
                  ELSEIF((NK+NL).EQ.0 .OR. (NH.EQ.NK.AND.NL.EQ.0))THEN
                     MF = 6
                  ELSEIF(NK.EQ.0 .OR. NL.EQ.0 .OR. NH.EQ.NK)THEN
                     MF = 12
                  ELSE
                     MF = 24
                  ENDIF
               ELSEIF(LAU-9.EQ.6)THEN
                  IF((NK+NL).EQ.0)THEN
                     MF = 6
                  ELSEIF(NH.EQ.NK .AND. NK.EQ.NL)THEN
                     MF = 8
                  ELSEIF(NK.EQ.0 .OR. NL.EQ.0)THEN
                     MF = 12
                  ELSE
                     MF = 24
                  ENDIF
               ELSEIF(LAU-9.EQ.7)THEN
                  IF((NK+NL).EQ.0)THEN
                     MF = 6
                  ELSEIF(NH.EQ.NK .AND. NK.EQ.NL)THEN
                     MF = 8
                  ELSEIF(NH.EQ.NK .AND. NL.EQ.0)THEN
                     MF = 12
                  ELSEIF(NH.EQ.NK .OR. NK.EQ.NL .OR. NL.EQ.0)THEN
                     MF = 24
                  ELSE
                     MF = 48
                  ENDIF
               ELSE
                  GOTO 760
               ENDIF
               GOTO 761
 760           IF(NH.EQ.0)THEN
                  MF = 2
               ELSEIF(NK.EQ.0 .AND. NL.EQ.0)THEN
                  MF = 2
               ELSE
                  MF = 4
               ENDIF
C     Store h,k,l, and J. Calculate d-spacing and 2-theta.
C     Increment reflection counter.
 761           N = N + 1
C     Check next N does not exceed array limits !
               IF(N-MAXHKL.EQ.1)GOTO 870
               IH(N) = NH
               IK(N) = NK
               IL(N) = NL
C     Calculate d*
               D(N) = SQRT(Q)
C     Calculate 2-theta (conventional diffraction).
               CALCTH = ASIN(WAV2*D(N))/RADS2
C     Obs(2-theta) = Calc(2-theta) + Zero-point error.
               TH(N) = CALCTH + ZER
               CALL RZDCAL(AMAT,IH(N),IK(N),IL(N),R(N),Z(N),D0)
               IF(ABS(D0-D(N)).GT.1.0E-05)THEN
                  WRITE(6,'(A)')' DRAGON: inconsistent D'
                  WRITE(6,*)D0,D(N)
               ENDIF
C     Convert to fibre-diffraction multiplicity.
               MUL(N) = FIBMULT(DELZ,Z(N),MF)
 
 762        CONTINUE
 764     CONTINUE
 770  CONTINUE
C
C     Start of section XIV of program.
C     -------------------------------
C
 780  NF = N
      WRITE(IOW,5430)NF
      WRITE(LPT,5430)NF
C     Re-input params if no reflections found.
      IF(NF.NE.0)THEN
C     Calculate number of reflections within the sphere of reflection.
         ISPHE = 0
         DO 782 I = 1,N
            ISPHE = ISPHE + MUL(I)
 782     CONTINUE
         WRITE(IOW,5440)ISPHE
         WRITE(LPT,5440)ISPHE
C     Keep tabs on each reflection.
         DO 784 I = 1,N
            IND(I) = I
 784     CONTINUE
C     In practice reflections are always required sorted. However
C     during testing of this type of program, it is often useful
C     to be able to list the reflections in the order generated.
C     Sort HKL values to go from low to high 2-theta, i.e. large
C     to small d-spacing or long to short T.O.F.
C     N.B. It is necessary to sort using 2-theta values since for
C     multipattern refinements using 2 or more wavelengths
C     (e.g. Cu K-alpha1 & Cu K-alpha2), the reflections are not
C     in order of d-spacing. For each single pattern, d-spacing
C     or 2-theta angle could be used.
         NOSWAP = 0
         DO 786 J = 1,(N-1)
            IF(NOSWAP.EQ.0)THEN
               NOSWAP = 1
               DO 785 I = 1,(N-J)
C     Test and skip if in correct order.
                  IF((Z(IND(I))-Z(IND(I+1)).GT.DELZ) .OR. 
     &               (ABS(Z(IND(I))-Z(IND(I+1))).LT.DELZ.AND.R(IND(I))
     &               .GT.R(IND(I+1))))THEN
C     Otherwise swop index array.
                     ITMP = IND(I)
                     IND(I) = IND(I+1)
                     IND(I+1) = ITMP
                     NOSWAP = 0
                  ENDIF
 785           CONTINUE
            ENDIF
 786     CONTINUE
C     Calculate number of unique reflections, i.e. those with
C     non-identical d-spacings. (Easily done when reflections have
C     been sorted).
c         WRITE(IOUT,5450)CTYPE,AR,BR,CR,ALR,BER,GAR
         NUN = 1
         MFD = MUL(IND(1))
         DO 788 I = 2,N
C     Is d-spacing same as previous reflection (within one pixel).
            IF(ABS(Z(IND(I))-Z(IND(I-1))).LT.DELZ .AND. 
     &         ABS(R(IND(I))-R(IND(I-1))).LT.DELR)THEN
               MULFD(IND(I-1)) = 0
               MFD = MFD + MUL(IND(I))
            ELSE
C     File output
               NUN = NUN + 1
               MULFD(IND(I-1)) = MFD
               MFD = MUL(IND(I))
            ENDIF
 788     CONTINUE
         MULFD(IND(N)) = MFD
         IF(N.GT.NMAX)THEN
            N = NMAX
         ENDIF
         NPTS = 0
         DO 790 I = 1,N
c           WRITE(IOUT,5460)IH(IND(I)),IK(IND(I)),IL(IND(I)),
c     &                      MUL(IND(I)),MULFD(IND(I)),
c     &                      D(IND(I)),R(IND(I)),Z(IND(I))
            IF(MULFD(IND(I)).GT.0)THEN
               NPTS = NPTS + 1
               IHKL(1,NPTS) = IH(IND(I))
               IHKL(2,NPTS) = IK(IND(I))
               IHKL(3,NPTS) = IL(IND(I))
               DRZ(1,NPTS) = D(IND(I))
               DRZ(2,NPTS) = R(IND(I))
               DRZ(3,NPTS) = Z(IND(I))
            ENDIF
 790     CONTINUE
C     Write to LPT file.
         WRITE(LPT,5470)NUN
         WRITE(IOW,5470)NUN
C     Write out list to LPT.
C     Special for rhombohedral systems. (Both sets of h,k,l given).
         IF(LTP.EQ.7)THEN
C     LPT output - rhombohedral systems.
            IF(LAU.EQ.8 .OR. LAU.EQ.9)THEN
C     Rhombohedral generated.
               WRITE(LPT,5500)
               DO 791 I = 1,N
C     h(H) = h(R) - k(R); k(H) = k(R) - l(R); i(H) = l(R) - h(R);
C     l(H) = h(R) + k(R) + l(R).
                  MH = IH(IND(I)) - IK(IND(I))
                  MK = IK(IND(I)) - IL(IND(I))
C     The extra index, i, is given by : i = - h - k.
                  MI = -MH - MK
                  ML = IH(IND(I)) + IK(IND(I)) + IL(IND(I))
                  IF(MULFD(IND(I)).GT.0)WRITE(LPT,5510)IH(IND(I)),
     &               IK(IND(I)),IL(IND(I)),MUL(IND(I)),MULFD(IND(I)),
     &               D(IND(I)),R(IND(I)),Z(IND(I)),MH,MK,MI,ML
 791           CONTINUE
            ELSE
C     Hexagonal generated.
               WRITE(LPT,5520)
               DO 792 I = 1,N
C     The extra index, i, is given by : i = - h - k.
                  II = -IH(IND(I)) - IK(IND(I))
C     h(R) = [2h(H) + k(H) + l(H)] / 3;
C     k(R) = [- h(H) + k(H) + l(H)] / 3;
C     l(R) = [- h(H) - 2k(H) + l(H)] / 3.
                  MH = (2*IH(IND(I))+IK(IND(I))+IL(IND(I)))/3
                  MK = (-IH(IND(I))+IK(IND(I))+IL(IND(I)))/3
                  ML = (-IH(IND(I))-2*IK(IND(I))+IL(IND(I)))/3
                  IF(MULFD(IND(I)).GT.0)WRITE(LPT,5530)IH(IND(I)),
     &               IK(IND(I)),II,IL(IND(I)),MUL(IND(I)),MULFD(IND(I)),
     &               D(IND(I)),R(IND(I)),Z(IND(I)),MH,MK,ML
 792           CONTINUE
            ENDIF
C     For hexagonal axes, give h,k,i,l.
         ELSEIF(LAU.GE.10 .AND. LAU.LE.14)THEN
C     LPT output - hexagonal.
            WRITE(LPT,5540)
            DO 793 I = 1,N
C     The extra index, i, is given by : i = - h - k.
               II = -IH(IND(I)) - IK(IND(I))
               IF(MULFD(IND(I)).GT.0)WRITE(LPT,5550)IH(IND(I)),
     &            IK(IND(I)),II,IL(IND(I)),MUL(IND(I)),MULFD(IND(I)),
     &            D(IND(I)),R(IND(I)),Z(IND(I))
 793        CONTINUE
C     For cubic axes, also list h*h+k*k+l*l.
         ELSEIF(LAU.EQ.15 .OR. LAU.EQ.16)THEN
C     LPT output - cubic.
            WRITE(LPT,5560)
            DO 794 I = 1,N
               NSUM = IH(IND(I))*IH(IND(I)) + IK(IND(I))*IK(IND(I))
     &                + IL(IND(I))*IL(IND(I))
               IF(MULFD(IND(I)).GT.0)WRITE(LPT,5570)IH(IND(I)),
     &            IK(IND(I)),IL(IND(I)),MUL(IND(I)),MULFD(IND(I)),
     &            D(IND(I)),R(IND(I)),Z(IND(I)),NSUM
 794        CONTINUE
         ELSE
C     LPT output - general.
            WRITE(LPT,5480)
            DO 795 I = 1,N
               IF(MULFD(IND(I)).GT.0)WRITE(LPT,5490)IH(IND(I)),
     &            IK(IND(I)),IL(IND(I)),MUL(IND(I)),MULFD(IND(I)),
     &            D(IND(I)),R(IND(I)),Z(IND(I))
 795        CONTINUE
         ENDIF
         WRITE(IOW,5580)
         WRITE(LPT,5580)
         CLOSE(UNIT=20)
C     Normal end of program.
         RETURN
      ELSE
         WRITE(IOW,5590)
         WRITE(LPT,5590)
         GOTO 10
      ENDIF
C      CALL EXIT(0)
C
C     Start of section XV of program.
C     ------------------------------
C
C     Give error message if error in wavelength.
C  471 WRITE(IOW,472)
C  472 FORMAT(/1X,'Error - impossible wavelength, two-theta limit, etc.')
C     Allow another attempt !
C      WRITE(IOW,473)
C  473 FORMAT(/1X,'Try again and type carefully'/1X,'->  ',$)
C      GOTO 28
C     Give error message if error in cell constants.
 800  WRITE(IOW,5600)
C     Allow another attempt !
C      WRITE(IOW,473)
C      GOTO 12
C     Give error message if unable to decode lattice type.
 810  WRITE(IOW,5610)ISGP(IC),ISGP
      WRITE(LPT,5610)ISGP(IC),ISGP
      RETURN
C     Give error message if unable to decode spacegroup symbols.
 820  WRITE(IOW,5620)ISGP(IC),ISGP(IC-1),ISGP
      WRITE(LPT,5620)ISGP(IC),ISGP(IC-1),ISGP
      RETURN
C     Give error message if impossible spacegroup.
 830  WRITE(IOW,5630)
      WRITE(LPT,5630)
      RETURN
C     Give error message if cell constants and spacegroup are not
C     compatible.
 840  WRITE(IOW,5640)
      WRITE(LPT,5640)
      RETURN
C     Give error message if unable to find unique axis in monoclinic
C     system.
 850  WRITE(IOW,5650)
      WRITE(LPT,5650)
      RETURN
C     Give error message if lattice and Laue type incompatible.
 860  WRITE(IOW,5660)
      WRITE(LPT,5660)
      RETURN
C     Give error message if N exceeds array size.
 870  WRITE(IOW,5670)MAXHKL
      WRITE(LPT,5670)MAXHKL
      WRITE(LPT,5680)NH,NK,NL
C     Allow program to continue after warning message.
C     (This may not be the best solution !)
      N = N - 1
      GOTO 780
C     EOF on input, abort to monitor !
C  494 WRITE(IOW,495)
C  495 FORMAT(/1X,'End of file encountered in input - program aborted'/)
C      WRITE(LPT,495)
C      RETURN
C     Give error message if error in program logic detected -
C     hopefully this should never occur !
 880  WRITE(IOW,5690)
      WRITE(LPT,5690)
      RETURN
 5010 FORMAT(/1X,'200 Cell constants (a b c alpha beta gamma) '/1X,3F9.4
     &       ,1X,3F8.3)
 5020 FORMAT(/1X,'200 Volume of unit cell is ',F10.1)
 5030 FORMAT(/1X,'200 Reciprocal lattice parameters'
     &       ,1X,'(a* b* c* alpha* beta* gamma*)'/1X,3F8.5,3F7.2)
C      WRITE(LPT,31) DMIN
C   31 FORMAT(/1X,'200 Minimum d-spacing is ',F8.5,' A')
C
C     Start of section V of program.
C     -----------------------------
C
C      WRITE(IOW,32) IDEF
C   32 FORMAT(/1X,'Give spacegroup (eg. P2(1)/m, Fm3m, P6(3)/mmc,',
C     +  1X,'P-4, P1 etc.)'
C     +  /1X,'(Default spacegroup is ',6A1,' <CR> = default)'
C     +  /1X,'->  ',$)
C      READ(IOR,33,END=494) ISGP
 5040 FORMAT(20A1)
 5050 FORMAT(/1X,'200 Spacegroup ',20A1)
 5060 FORMAT(/1X,'200 Lattice ',A1,' 1st symbol ',6A1,' 2nd symbol ',6A1
     &       ,1X,'3rd symbol ',6A1)
 5070 FORMAT(/1X,'200 Alternative cell constants for rhombohedral',1X,
     &       'systems'/1X,3F9.4,1X,3F8.3)
 5080 FORMAT(/1X,'200 There are no extinctions')
 5090 FORMAT(/1X,'200 Extinction rules')
 5100 FORMAT(1X,'200 hkl for k + l = 2n')
 5110 FORMAT(1X,'200 hkl for h + l = 2n')
 5120 FORMAT(1X,'200 hkl for h + k = 2n')
 5130 FORMAT(1X,'200 hkl for h + k + l = 2n')
 5140 FORMAT(1X,'200 hkl for - h + k + l = 3n')
 5150 FORMAT(1X,'200 h00 for h = 2n')
 5160 FORMAT(1X,'200 0k0 for k = 2n')
 5170 FORMAT(1X,'200 00l for l = 2n')
 5180 FORMAT(1X,'200 hk0 for h = 2n')
 5190 FORMAT(1X,'200 0kl for k = 2n')
 5200 FORMAT(1X,'200 h0l for l = 2n')
 5210 FORMAT(1X,'200 h0l for h = 2n')
 5220 FORMAT(1X,'200 hk0 for k = 2n')
 5230 FORMAT(1X,'200 0kl for l = 2n')
 5240 FORMAT(1X,'200 hk0 for h + k = 2n')
 5250 FORMAT(1X,'200 h0l for h + l = 2n')
 5260 FORMAT(1X,'200 0kl for k + l = 2n')
 5270 FORMAT(1X,'200 hk0 for h + k = 4n')
 5280 FORMAT(1X,'200 h0l for h + l = 4n')
 5290 FORMAT(1X,'200 0kl for k + l = 4n')
 5300 FORMAT(1X,'200 00l for l = 4n')
 5310 FORMAT(1X,'200 hhl for l = 2n')
 5320 FORMAT(1X,'200 hhl for h = 2n')
 5330 FORMAT(1X,'200 hh0 for h = 2n')
 5340 FORMAT(1X,'200 hhl for h + l = 2n')
 5350 FORMAT(1X,'200 hhl for 2h + l = 4n')
 5360 FORMAT(1X,'200 00l for l = 3n')
 5370 FORMAT(1X,'200 00l for l = 6n')
 5380 FORMAT(1X,'200 hkk for h = 2n')
 5390 FORMAT(1X,'200 h00 for h = 4n')
 5400 FORMAT(1X,'200 2h-hl for l = 2n')
 5410 FORMAT(1X,'200 hkk for h + 2k = 4n')
 5420 FORMAT(/1X,'200 Maximum indices are ',I3,' H ',I3,' K ',I3,' L ')
 5430 FORMAT(/1X,'200 Total number of reflections is ',I5)
 5440 FORMAT(/1X,'200 Sum of the multiplicities is ',I6)
 5450 FORMAT(A4,6X,6E10.4)
 5460 FORMAT(1X,3I4,2I5,1X,3E14.6)
 5470 FORMAT(/1X,'200 Number of unique reflections is ',I5)
C     TTY output.
C      WRITE(IOW,425)
 5480 FORMAT(/4X,'H',3X,'K',3X,'L',4X,'J',14X,'D',10X,'R',10X,'Z'/)
C      DO 426 I=1,MIN0(10,N)
C  426 WRITE(IOW,427) IH(IND(I)),IK(IND(I)),IL(IND(I)),MUL(IND(I)),
C     +  D(IND(I)),R(IND(I)),TH(IND(I))
 5490 FORMAT(1X,3I4,2I5,1X,3F12.6)
 5500 FORMAT(/4X,'H',3X,'K',3X,'L',4X,'J',13X,'D',9X,'R',9X,'Z',3X,
     &       '(Hexagonal indices h,k,i,l)'/)
 5510 FORMAT(1X,3I4,2I5,1X,2F10.4,1X,F8.2,8X,4I4)
 5520 FORMAT(/4X,'H',3X,'K',3X,'I',3X,'L',4X,'J',13X,'D',9X,'R',9X,'Z',
     &       3X,'(Rhombohedral indices h,k,l)'/)
 5530 FORMAT(1X,4I4,2I5,1X,3F10.4,11X,3I4)
 5540 FORMAT(/4X,'H',3X,'K',3X,'I',3X,'L',4X,'J',14X,'D',10X,'R',10X,
     &       'Z'/)
 5550 FORMAT(1X,4I4,2I5,1X,3F12.6)
 5560 FORMAT(/4X,'H',3X,'K',3X,'L',4X,'J',13X,'D',9X,'R',9X,'Z',5X,
     &       'H*H + K*K + L*L')
 5570 FORMAT(1X,3I4,2I5,1X,3F10.4,9X,I5)
 5580 FORMAT(/1X,'200 Lattice calculation completed'/)
 5590 FORMAT(/1X,'300 Preceeding set of parameters ignored')
 5600 FORMAT(/1X,'400 Error - impossible cell constants')
 5610 FORMAT(/1X,'400 Error - "',A1,'" found at start of spacegroup',1X,
     &       'symbol ',20A1/)
 5620 FORMAT(/1X,'400',
     &       1X,'Error - "',A1,'" found after "',A1,'" in spacegroup',
     &       1X,'symbol ',20A1/)
 5630 FORMAT(/1X,'400 Error - unacceptable spacegroup'/)
 5640 FORMAT(/1X,'400',
     &       1X,'Error - cell constants incompatible with spacegroup'/)
 5650 FORMAT(/1X,'400 Error - can not find unique axis for cell'/)
 5660 FORMAT(/1X,'400',
     &       1X,'Error - point group incompatible with lattice type'/)
 5670 FORMAT(/1X,'300',
     &       1X,'Warning - array limit reached, size set at ',I5)
 5680 FORMAT(/1X,'Generation of HKL''s stopped at',3I4)
 5690 FORMAT(/1X,'400 Error - internal program fault'/)
C     End of main program!
C     *******
      END
C###fibmult.spg  processed by SPAG 3.10Z  at 11:00 on  9 Sep 1994
C---------------------------------------------------------------------
      INTEGER FUNCTION FIBMULT(DELZ,Z,MULT)
      IMPLICIT NONE
C Convert the crystallographic multiplicity used for powder diffraction
C to multiplicity suitable for fibre diff. This entails dividing by two
C except on the equator.
      REAL Z,DELZ
      INTEGER MULT
C NB mult should always be even.
      IF(ABS(Z).LT.0.5*DELZ)THEN
         FIBMULT = MULT
      ELSE
         FIBMULT = MULT/2
      ENDIF
      RETURN
      END
