
###CCP13 DOCUMENTATION
###LSQINT - Fibre diffraction integration program
###Last update 20/09/96

Introduction
------------
The purpose of LSQINT is to provide an automatic method for the integration
of intensities for fibre diffraction data. The program will handle patterns
which are largely crystalline in nature, or patterns which have continuous
layerlines, sampling only occurring parallel to the Z axis. More than one lattice
can be fitted in a single pattern.
The approach used is to generate profiles and then to fit these profiles
to the observed pixel intensities by a robust linear least-squares method or 
using the maximum entropy algorithm of Skilling and Bryan, Mon. Not. R. astr. 
Soc. (1984)..
Four background subtraction options are available: 
a global background can be fitted simultaneously with the intensities,
a "roving-aperture" method can be used to estimate the background; 
background can be fitted locally by a least-squares method, the
process being iterated so that the shape of the background can evolve.
Alternatively, background can be removed by a specialist program before 
LSQINT is run and no background fitting will be done.
Refinement of the cell and profile parameters is also available by a downhill
simplex method. This can be cycled with the intensity fitting procedure in order
to provide an overall refinement procedure.

Input
-----
Input to LSQINT is provided by the program FTOREC which maps flat area detector
data into reciprocal space coordinates, either cartesian or polar. The remapped 
image is in standard BSL format with the addition of the second header record 
being used to store extra image information. Optionally, FTOREC produces an image
of the standard deviation of pixel values between the four quadrants of the 
original pattern. If desired, LSQINT can use this image to weight pixel values.
Program function is determined by keyworded input which is prompted for
after the input file specifications have been read. After the keyworded input
the output file name and headers are read. Optionally, a filename for
the calculated image is read after the output file name.

Keywords 
--------
Keyworded input can be either upper or lower case. Only the first four
characters of the keyword are required (and read). When values are input,
they can take integer, real or exponent fields. Comments are signalled by
! and can occur anywhere on a line. Up to five continuation lines are allowed
using & at the end of the current line. Lines must be less than 132 characters.
Descriptions of the keywords recognised by LSQINT are given below.
(Sub-keywords are indented on the line following the main keyword)


BRAGg - Fitting will be performed for Bragg data

CONTinuous - Fitting will be performed for continuous layerline intensity

CELL - followed by 6 input cell parameters for Bragg data, 1 for continuous
       If 3 parameters are given, alpha = beta = gamma = 90

CSTAr - Defines the initial cell orientation with c* as the axis parallel to Z 
        (for monoclinic cells, etc). By default, the initial orientation has c
	parallel to Z. a* always starts in the Z-X plane.

MISSetting - allows the user to specify the following misetting angles
   PHIZ - one value to follow, rotation of the initial orientation around the 
          reciprocal space Z axis.
   PHIX - one value to follow, rotation (after application of PHIZ) of the cell 
          around the reciprocal space X axis
          (defaults PHIZ 0.0  PHIX 0.0)

SPACegroup - Space group symbol for Bragg data (default P1)

LIMIts - determines limits for profile calculation
   LAYErlines - requires two values to follow, the first and last layerlines
   RADIi - requires two values to follow, the min. and max. radii (image units)
   DLIMits - requires two values to follow, the min. and max. d* values
   (defaults DLIMITS 0.0 MAX(d*)  LAYERLINES 0 (DMAX/c*)  RADII first pixel 
    last pixel)

SELEct - allows user to select layer lines using the following keywords

   HELIx - signals use of helical selection rule for Bessel function orders
      TURN - one value to follow, the number of turns in the c repeat
      UNIT - one value to follow, the number of subunits in the c repeat
      STARt - one value to follow, the rotational symmetry of the structure
      STACk - one value to follow, the number of vertically stacked helices
      BESSel - one value to follow, the maximum bessel function order to be 
               considered in invoking the selection rule
      RADI - one value to follow, the maximum radius of the structure
      (defaults: TURN 1, UNIT 1, STAR 1, STAC 1, BESS 10)

   MIXTure - up to five values to follow, corresponding to the c/P(i) where
             P(i) is the pitch of the i'th component of a multi-component
             system. The layerline is allowed if any of the c/P(i) = an integer
(default behaviour - no selection rules, all layerlines allowed)

MAXBuf - one value to follow, the maximum memory workspace (in bytes) to be
         allocated for least-squares or ME fitting.
	 (default 64000000)

NOCAlculate - by default, LSQINT calculates and outputs the calculated image 
              and background. This keyword prevents this behaviour.
              Background will be in the first frame corresponding to the
              current image, the total calculated image will be in the second.

NOFIt - force output of equally weighted profiles in the calculated image

   FILE - signals that the next line contains the name of a file which
          contains input intensity values (the format of this file should be
          similar to the LSQINT output file)
       
SETZero - set negative intensities to zero between least-squares fitting 
          and R-factor calculation 

BACK - Determines type of background fitting performed

   NONE - no background fitting

   GLOBal - 8 parameters defining a global background function will be fitted

   WINDow - Paul Langan's roving window background subtraction method
      XWIDth - one value to follow, the window will be 2*XWID + 1 in R
      YWIDth - one value to follow, the window will be 2*YWID + 1 in Z
               (values in pixel units)
      NPASs - one value to follow, the number of passes for radial averaging
      NSIG - one value to follow, the number of standard deviations above
             the radially-averaged background for rejection of points from
             background calculation
      LPIX - one value to follow, the starting position in the sorted pixel
             list for selecting pixels for the background, expressed as a
             percentage of the total number of pixels in the window
      HPIX - one value to follow, the final position in the sorted pixel
             list for selecting pixels for the background, expressed as a
             percentage of the total number of pixels in the window
      (defaults: XWID 10, YWID 10, NPASS 2, NSIG 1.5, LPIX 0, HPIX 25)

   LFIT - Initial horizontal plane local least-squares background fitting and 
          spline fitting
      XWIDth - one value to follow, the window will be 2*XWID + 1 in R
      YWIDth - one value to follow, the window will be 2*YWID + 1 in Z
               (values in pixel units)
      NPASs - one value to follow, the number of passes for least-squares 
              fitting to evolve away from the horizontal plane
      SMOO - one value to follow, the smoothing factor for the spline fitting
      TENS - one value to follow, the tension factor for the spline fitting

   INCL - Similar to LFIT but with only one pass fitting an inclined plane
      (defaults: XWID 10, YWID 10, NPASS 2, SMOO 1.0, TENS 1.0)

   (default NONE)

REFIne - Switches on cell and profile refinement 
   ITMAx - one value to follow, number of iterations for refinement
   IFIT - one value to follow, number of cycles with intensity fitting 
   TOLErance - one value to follow, R-factor shift tolerance 
   (defaults ITMAX 20, IFIT 2, TOLERANCE 0.01)

SPREad - signals the following keywords for the profile parameters
   AWIDth - one value to follow, the width of the orientation distribution function
   SHAPe - one value to follow, the shape of the orientation distribution function
   ZWIDth - one value to follow, 1/particle length
   R0WIdth - one value to follow, 1/particle width
   R1WIdth - one value to follow, distribution of a*,b* 
   R2WIdth - one value to follow, paracrystallinity
   (N.B.  RWIDTH = R0WI + R1WI*R + R2WI*(R**2))
   (defaults AWID 0.001, SHAP 3.0, ZWID 0.001, R0WI 0.001, R1WI 0.0, R2WI 0.0)

SHIFts - signals the following keywords for the initial shifts for cell and
         profile parameter refinement
   AWIDth - one value to follow, shift for AWIDth 
   SHAPe - one value to follow, shift for SHAPe
   ZWIDth - one value to follow, shift for ZWIDth 
   R0WIdth - one value to follow, shift for R0WIdth 
   R1WIdth - one value to follow, shift for R1WIdth 
   R2WIdth - one value to follow, shift for R2WIdth 
   ASTAr - one value to follow, shift in a*
   BSTAr - one value to follow, shift in b*
   CSTAr - one value to follow, shift in c*
   ALPHastar - one value to follow, shift in alpha*
   BETAstar - one value to follow, shift in beta* 
   GAMMastar - one value to follow, shift in gamma*
   PHIZ - one value to follow, shift in PHIZ
   PHIX - one value to follow, shift in PHIX
   (N.B. Parameters with initial shifts equal to zero will not be refined)

SIGMa - signals the following keywords for calculating the standard deviations
        of pixel values
   MINImum - one value to follow, the base standard deviation for every pixel
   FACTor - one value to follow, the coefficient of SQRT(I)
   (Defaults MINIMUM 0.0, FACTOR 0.0)
(N.B. SD(I) = MINIMUM + FACTOR*SQRT(I) )
 
MAXEnt - signals fitting of intensities by maximum entropy
   DEFAult - one value to folow, fixed default pixel value for entropy 
             calculation
   RATE - one value to follow, the maximum step size for each iteration
   CYCLes - one value to follow, the maximum number of iterations
   TEST - one value to follow, convergence criterion for fit
   CHIFactor - one value to follow, factor determining target chi-squared
   (defaults DEFAULT 1.0, RATE 0.3, CYCL 100, TEST 0.1, CHIF 3.29)

NEXT - causes calculation of the current lattice positions and profiles
       and signals that another lattice is to be specified.

RUN  - Signals end of keyworded input and causes the final lattice positions 
       and profiles to be calculated.


Output
------
A log file, LSQINT.LOG, is opened when the program is executed.
This contains information about the input file, consequences of the
keyworded input, the parameters for which the profiles are calculated,
R-factors and any error messages or warnings. The R-factors which are
reported are calculated by the formula,

         R'' = sqrt(sum(Po-Pc)**2/sum(Po**2))

where the Po are the observed pixel values minus background and the Pc
are the calculated pixel values.
Output is in the form of an ascii file containing 7 columns.
The first three columns contain integers defining h,k,l, the 
fourth column gives the reciprocal space radius, R of the sampling point
and the fifth, the fibre multiplicity of the reflection. A non-zero fibre
multiplicity is assigned only to the last reflection in the list
constituting a multiplet. A reflection is considered to be part of a
multiplet with the previous reflection if their positions fall within
the same pixel on the input image. The last two columns contain real
numbers describing the integrated intensity of the spot and its standard
deviation. The standard deviation is calculated directly from the
differences between the calculated and observed pixel values over the
predicted profile of the peak. A file, DRAGON.OUT, is also created
containing a full list of the reflections and their reciprocal space
coordinates.


Errors and Warnings
-------------------
The occurence of errors is reported and the program should then
terminate. Warnings are given for occurences which may affect the
usefulness of the run, but the program execution will continue.
The possible error messages are as follows:
 
 1)BCKFIT: Error - window size too big
   BCKWIN: Error - window size too large for array
      The window size given by the keywords XWID,YWID exceeds the array
      dimension (current maximum area = 1681 pixels)
 2)CONOUT: Error writing frame  KPIC =  
      Error writing picture number KPIC for the file containing
      collapsed layer lines
 3)Error - impossible wavelength, two-theta limit, etc.
   Error - impossible cell constants
   Error - "',A1,'" found at start of spacegroup
   Error - "',A1,'" found after "',A1,'" in spacegroup
   Error - unacceptable spacegroup
   Error - cell constants incompatible with spacegroup
   Error - can not find unique axis for cell
   Error - point group incompatible with lattice type
      These are all errors in the routine DRAGON for calculating the
      reciprocal space coordinates of Bragg spots and are fairly
      self-explanatory
 4)FBRAG: Error - nllp too big
   FBRAG: Error - ipoint too big 
   FBRAG: Error - mpoint too big 
   FCONT: Error - nllp too big
   FCONT: Error - ipoint too big 
   FCONT: Error - mpoint too big 
      The functions FBRAG and FCONT calculate and store the profiles for
      Bragg and continuous patterns respectively. NLLP is the number  
      of peaks, IPOINT is the NLLP times the expected average
      width in Z and MPOINT is IPOINT times the expected average width
      (current maxima NLLP 10000, IPOINT 500000, MPOINT 150000000)
 5)IMGCAL: Error writing calculated file
 6)Error allocating memory
   Error deallocating memory
      The memory for the normal least-squares memory is allocated at run
      time 
 7)RZDCAL: Error - unknown cell type
      RZDCAL calculates the reciprocal space coordinates for each Bragg
      point given the cell type. This may occur for cubic cells. 
 8)SETSPLODGE: Error - J2 > NZS
   SETSPLODGE: Error - J1 < -NZS
   SETSPLODGE: Error - I1 < -NRS
   SETSPLODGE: Error - I2 > NRS
      SETSPLODGE calculates the profile for an individual peak. If the
      profile of the peak exceeds the limits NRS or NZS an error occurs
      (current limits NRS 512 pixels, NZS 512 pixels)

The following warnings may appear:

 1)BCKFIT: Warning - too many peaks, resetting
      Too many peaks contribute to this window for background fitting
      for the dimension of the normal matrix. The last peaks encountered which
      cause the number to exceed the maximum are left out of the fit. This
      will affect the ability of the routine to fit the background well.
      (current maximum number of peaks per window = 100)
 2)BRGOUT: Warning - IO .ne. NLLP
   CONOUT: Warning - IO .ne. NLLP
      The number of peaks being output does not equal the number
      expected, this shouldn't occur
 3)CONOUT: Warning NPRD exceeds 5000 
      The number of points to be output for continuous data exceeds the
      maximum 
 4)Warning - core limit reached : array size set at 4096
      Limit for number of reflections in DRAGON 
 5)FBRAG: Warning - value out of range 
   FCONT: Warning - value out of range
      The value calculated for a profile exceeds 32767 for integer*2
      storage

Example command file
--------------------
Shown below is a command file used for measuring diffraction patterns
from bony fish muscle:

#!/bin/csh -f
lsqint << EOF >& lsqint.out &
A16000.RZ1
1
1 256 1 256
A16000.SD1
1
1 256 1 256
!Start keyworded input (! indicates a comment)
!
!Flag for Bragg fitting 
brag
!
!Input cell parameters 
cell 413.87 413.87 408.16  90 90 120 
!
!Input profile parameters
spre awid 0.01 zwid 0.00083 r0wi 0.00082 r1wi 0.00022 r2wi 0.90224
!
!Space group
spac p3
!
!Flag for outputting generated profiles only
!nofit
!
!Set up refinement of cell and profiles
!refine ifit 5 tole 0.01 itmax 10
!
!Set limits on min. and max. d*
limits dlim 0.0005 0.014
!
!Set shifts for cell and profile refinement 
!shifts asta 0.0001 csta 0.0001 r0wi 0.00005 r1wi 0.00005 r2wi 0.1
!
!Set background fitting option 
back lfit xwid 20 ywid 20 npass 1
!
!Set negative intensities to zero before R-factor calculation
!setz
!
!Start fitting 
run
A16000.RF2
header 1:
header 2: 
ref2.hkl
EOF
