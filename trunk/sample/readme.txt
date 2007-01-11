
###CCP13 DOCUMENTATION
###SAMPLE - Fourier-Bessel smoothing of continuous intensity.
###LAST UPDATE: 15/05/95

Introduction
------------
SAMPLE is a program for performing Fourier-Bessel smoothing on continuous
layer line data as output by LSQINT, using the formula described by Makowski
(1982). The data are fitted using singular value decomposition to give
intensity values at the specified number of knot points.

Input
-----
The input file data is read from ASCII intensity files output by LSQINT.

Keywords 
--------
Keyworded input can be either upper or lower case. Only the first four
characters of the keyword are required (and read). When values are input,
they can take integer, real or exponent fields. Comments are signalled by
! and can occur anywhere on a line. Up to five continuation lines are allowed
using & at the end of the current line. Lines must be less than 132 characters.
Descriptions of the keywords recognised by CONV are given below.
(Sub-keywords are indented on the line following the main keyword)

FILE - SAMPLE will then prompt for the input file name

RESOlution - two values to follow, the minimum and maximum resolution in 
             reciprocal angstroems
(Defaults: d* minimum = 0.0, d* maximum = maximum resolution in dataset)

SIGMA - one value to follow, the minimum ratio of I/sigma(I) for I to be
        included in the fit
(Default: SIGMA = 0.0)

EXTRa - one value to follow, the number of roots past the maximum reciprocal
        radius on a layer line to be used in fitting the data
Default: EXTRA = 5)

HELIx - two values to follow, the number of subunits and the number of turns
        defining the helical symmetry
(Default: SUBUNITS = 1, TURNS = 1)

STARt - one value to follow, the rotational symmetry of the structure.
(Default: START = 1)

STACk - one value to follow, the number of stacked helices.
(Default: STACK = 1)

RADIus - one value to follow, the maximum radius of the structure.
(Default: RADIUS = 100.0A)

SCALe - one value to follow, the scale factor relating the actual layer line
        numbers to those recorded in the LSQINT output file i.e.
        Lactual = Llsqint * SCALE
(Default: SCALE = 1)

RUN - Start smoothing

Output
------
The output file is in the same format as the LSQINT output file.


Reference
---------

Makowski, L. (1982). J. Appl. Cryst. 15 546-557
                                     --        
