
###CCP13 DOCUMENTATION
###FDSCALE - Scaling and merging of LSQINT output files
###Last update 20/09/93

Introduction
------------
FDSCALE scales LSQINT intensity output files either by comparing common reflections
or by comparing the total intensities in resolution shells. Merging of the data is
optional. If scaling using more than one resolution bin, a relative temperature
factor is also fitted although this is unstable with low resolution data.

Input
-----
Input files are of the type output by LSQINT for indexed intensity measurements,
these are ASCII and the columns have the following meanings,

H,K,L,Reciprocal space radius,Multiplicity,Intensity,Estimated standard deviation

The output file has the same format.

Keywords 
--------
Keyworded input can be either upper or lower case. Only the first four
characters of the keyword are required (and read). When values are input,
they can take integer, real or exponent fields. Comments are signalled by
! and can occur anywhere on a line. Up to five continuation lines are allowed
using & at the end of the current line. Lines must be less than 132 characters.
Descriptions of the keywords recognised by FDSCALE are given below.
(Sub-keywords are indented on the line following the main keyword)

SUMS - the scaling will be done by comparing intensities summed in resolution bins.
       each file is scaled to the first file independently i.e.
       log(In) = B(d*^2)/2 + log(I1) + Kn.

COMMon - the scaling will be done by comparing common reflections. One scale factor
         is fitted using all files i.e.
         log(In) = (m-n)log(k) + log(Im).
        (default COMMON)

RSYM - an Rsym will be calculated before scaling.

FILEs - the program will then prompt for input filenames. If the data is to be 
        scaled as for a pack of three films using COMM, the file names should be
        in order e.g. A,B,C.
        (Maximum number of files = 20)

BINS - one value to follow, the number of resolution bins for use with SUMS
       (default BINS 1, maximum = 20)
   
RESOlution - two values to follow, the minimum and maximum resolution limits in
             reciprocal angstroms. 
             (defaults to zero and the maximum resolution of the data)

SIGMa - signals input of cutoff criteria for scaling and output on the ratios
        I/SIGMA(I)

   SCALe - one value to follow, the lowest ratio for reflections to be used in the
           scaling calculation
   
   OUTPut - one value to follow, the lowest ratio for reflections to be written to 
            the output file.
   (defaults SIGMA SCALE 3.0 OUTPUT 1.5)

MERGe - forces the data to be merged, the program will then prompt for the output
       filename

RUN - start processing 
