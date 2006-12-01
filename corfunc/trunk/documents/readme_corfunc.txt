CORFUNC for Windows(TM)
Version 1.5

Correlation Function & Volume Fraction Profile Analysis for Small-Angle X-ray/Neutron Scattering



This 32-bit Microsoft Windows(TM)-compatible version of CORFUNC offers the same functionality as the UNIX versions available for download from the CCP13 website (http://www.ccp13.ac.uk), **but also** incorporates a new routine (Tropus) to generate Volume Fraction Profiles from the scattering from layers of surfactant/polymer adsorbed at an interface.

The UNIX versions of CORFUNC are actually a suite of programs: Tailfit and Tailjoin (now incorporated into Extrapolate) to extend the dataset to low and high angles (Q vectors), Ftransform to Fourier transform the extrapolated and smoothed dataset, and Extract_par to "analyse" the resulting density correlation function.  In this Windows(TM)-compatible version of the suite, Extrapolate, Ftransform and Extract_par are "called" by a user-friendly Java(TM) Graphical User Interface.

Therefore, to use CORFUNC for Windows(TM) it is also necessary to download and install the Java2 Runtime Environment (JRE or J2RE) from http://java.sun.com/j2se/ (you do not require the Software Development Kit, SDK).

CORFUNC Version 1.3 has been extensively tested with Java 2 Version 1.3.1. though at the time of writing the current release is Version 1.4.2.

 

RELEASE NOTES
-------------
Version Beta 1.0 - by M Shotton & R Denny.  Minor changes to GUI by M Rodman.

Version Beta 1.1 - Changes to readascii.c (compilation warning), extrapolate.f (improved error reporting), and
                   corfunc.jar (GUI version identification) by S King.  Created corfunc.ico.  Changed parameter files
                   from *.dat to *.txt as most PC's automatically associate *.dat with system configuration files!

Version Beta 1.2 - Added subroutine to input **single frame** LOQ 1D data files (as *.loq) & modified corfuncgui.java
                   and asciifilefilter.java accordingly - BUT THIS IS NOT YET WORKING PROPERLY (see Help Bugs).
                   Modified tailjoin.f to set negative intensities to 1.0E-08 rather than just stop the program with an
                   error message.  Modified tailjoin.f to also output ASCII files of the extrapolated data and q-axis
                   (needed as inputs to tropus).  Converted tropus.f from existing VAX/VMS source and added post-volume
                   fraction profile data extraction.

Version Beta 1.3 - Tropus integrated with Corfunc Java GUI. Entire Help pages overhauled and updated.

Version Beta 1.4 - Number of channels (data points) increased from 512 to 4096.  Number of frames (time slices) increased
                   from 512 to 4096.  All correlation functions are now output in both BSL/OTOKO and ASCII formats.  The
                   3D correlation function is now output (previously it was computed but not written to file).  A small
                   bug in the rescaling of the volume fraction profile has been corrected.

Version Beta 1.5 - Java compiled under JRE 1.5.0 Update 6.



Steve King, December 2005
s.m.king@rl.ac.uk