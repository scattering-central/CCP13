
###CCP13 DOCUMENTATION
###FTOREC - Image space to reciprocal space transformation program
###Last update 17/05/93

Introduction
------------
FTOREC is designed to take all or part of a diffraction image and transform
this portion of the image into reciprocal space, given knowledge of the
specimen to film distance, rotation of the image, wavelength and tilt of
the specimen. Either polar or cartesian reciprocal space output is available,
the cartesian option being used by the program LSQINT for data reduction.
Currently, the program will accept data either in standard BSL format or
scanned film images renamed to BSL type filenames and given a BSL header.
Absorption corrections are available for film data. Any pixels on the input
image containing a negative  will be rejected from the transformation and
any pixels on the output image for which there is no information will be 
flagged with the number -1.0E+30. This allows for easy masking of unwanted
portions of the image using a combination of the .MSK and .ADD options in
BSL.

Input
-----
Area detector data should be corrected for non-uniformity of response,
spatial distortion and the tack lines should have been removed.
Scanned film images should be renamed to a suitable BSL style filename,
e.g. A01001.IMG
and a header file created suitable for the number of pixels and rasters
in the image. For a header file A01000.IMG, corresponding to the above 
binary file, the header might read as follows:

Header 1: Example header file for scanned film image for input into FTOREC 
Header 2: FTOREC documentation 17/05/93
    2400    2400       1       0       0       0       0       0       0       1
A01001.IMG

The input header filename will be prompted for after keyworded input.

Keywords 
--------
Keyworded input can be either upper or lower case. Only the first four
characters of the keyword are required (and read). When values are input,
they can take integer, real or exponent fields. Comments are signalled by
! and can occur anywhere on a line. Up to five continuation lines are allowed
using & at the end of the current line. Lines must be less than 132 characters.
Descriptions of the keywords recognised by FTOREC are given below.
(Sub-keywords are indented on the line following the main keyword)
All angular values are input in degrees, all distances are in reciprocal
Angstroems unless otherwise stated.

POLAr - Transform image to reciprocal polar coordinates
CARTesian - Transform image to reciprocal cartesian coordinates
(Default CARTESIAN)
WAVElength - One value to follow 
(Default WAVELENGTH 1.5418)
FILM - Sets input data type to scanned film. Currently this affects the 
       way information from image space is binned into reciprocal space.
ABSOrption - Signals the following absortion coefficients for film data
   PAPEr - One value to follow, the absortion coefficient for black paper
   EMULsion - One value to follow, the absorption coefficient for film emulsion
   BASE - One value to follow, the absorption coefficient for the film base
   (PAPER 0.0  EMULSION 0.4  BASE 0.2  ! If FILM has been set)
PRECeding - Signals the following numbers for the preceding films and paper
   PAPEr - One value to follow, the number of papers in front of this film
   FILM - One value to follow, the number of films in front of this one
   (Defaults PAPER 0  FILM 0)
LIMIts - Signal the following keywords for the reciprocal space limits 
   DMIN - One value to follow, the minimum d* in the transformed image
   DMAX - One value to follow, the maximum d* in the transformed image 
   RMIN - One value to follow, the minimum R in the transformed image
   ZMIN - One value to follow, the minimum Z in the transformed image
   SIGMin - One value to follow, the minimum Sigma in the transformed image
   (Defaults DMIN 0.0  DMAX 0.5  RMIN 0.0  ZMIN 0.0  SIGMIN 0.0)
MAXOpt - One value to follow, the maximum pixel value to be transformed
(Defaults for film data MAXOpts 255.0, for area detector data MAXOpts 1.0E16)
BINS - Two values to follow, the number of [R,Z] bins or the number of
       [D,Sigma] bins
(Default BINS 256 256)
DISTance - One value to follow, the specimen to detector distance in Y pixel
           units
(No default - compulsory keyword)
CENTre - Two values to follow, the X,Y position of the centre in pixel units
(Default CENTRE 256.0 256.0)
RATIo - One value to follow, the Y:X ratio of the pixel dimensions
(Default RATIO 1.0)
STEP - Two values to follow, the step values for [R,Z] or [D,Sigma]
(Default STEP dmax/max(bins(1),bins(2)) dmax/max(bins(2),bins(2)) for [R,Z],
STEP dmax/bins(1) 90.0/bins(2) for [D,Sigma])
BACKstop - Two values to follow, the maximum R,Z values for a rectangular 
           backstop
(Default BACKSTOP 0.0 0.0)
TILT - One value to follow, the tilt of the specimen
(Default TILT 0.0)
ROTAtion - One value to follow, the rotation angle of the image
(Default ROTATION 0.0)
SCALe - One value to follow, scale factor for pixel values
(Default SCALE 1.0)
SIGMas - Forces output of an image corresponding to the standard deviations
         of the values in the reciprocal space bins
RUN - End of keyworded input

Output
------
The output file will be in standard BSL format except that the second header
record will be used for storing information regarding the starting points
and increments of the reciprocal space image. Pixels which are outside of the
resolution range, off-sphere or saturated will be flagged with the value
-1.0E+30. 

Errors and warnings
-------------------
The following errors may occur running FTOREC:
FTOREC: Error - opening binary file
PARINP: Error - no. of bins > 512 
        Any of the number of R,Z,D or Sigma bins exceeds 512, the current
        maximum - this will cause the program to stop.
ARRFIL: Error - reading binary file

The following warning may occur:
PARINP: Warning - must use keyword DISTANCE
        The specimen to detector distance is required by the program for
        calculating the reciprocal space image. After this warning the 
        prompt 'FTOREC> ' will appear for further input.

Example command file
--------------------

#!/bin/csh -f
/usr/usersa/denny/cnnew/bin/ftorec.exe << EOF 
!Start keyworded input (! indicates a comment)
!
! Transform to cartesian reciprocal space
cartesian
!
! Set wavelength
wave 1.488
!
! Set reciprocal space limits
limit dmin 0.0005 dmax 0.014
!
! Set backstop limits
back 0.001 0.0006
!
! Set centre
centre 242.5 251.0
!
! Set specimen to detector distance
distance 6000
!
! Start transformation
run
A16000.RT1
1
1 512 1 512 
A16000.RZ1
header 1: 

EOF
