CORFUNC for Windows(TM)
Version 1.5


CCP13 - Collaborative Computational Project 13
for Fibre & Non-Crystalline Diffraction

Correlation Function & Volume Fraction Profile Analysis
for Small-Angle X-ray/Neutron Scattering


INSTALLATION NOTES

1. Download and install the Java2(TM) Runtime Environment
   (J2RE) from http://java.sun.com/j2se/
   (you do not require the Software Development Kit, SDK).

   CORFUNC Version 1.5 has been extensively tested with
   Java 2 Version 1.5.0.


2. Download and execute the CORFUNC for Windows(TM)
   distribution from:

   http://www.ccp13.ac.uk/software/windows.html

   Give a directory to install to.  The following folders
   and files will be installed:
 
   \corfunc_help    - subfolder with the CORFUNC online help

   \documents       - subfolder with CORFUNC documentation

   \examples        - subfolder with test data

   extract_par.exe     |
   extrapolate.exe     | - the CORFUNC
   ftransform.exe      | - executables
   tropus.exe          |

   corfunc.jar           - the CORFUNC Java GUI

   graph.jar           |
   jai_codec.jar       | - other Java
   jai_core.jar        | - files
   jh.jar              |

   corfunc.bat           - command file to run CORFUNC

   corfunc.ico           - icon file


3. Edit corfunc.bat and change the paths below to point to
   the locations of:

   - the *.jar files: set CORFUNC_JAVA_PATH="E:\Corfunc"
   - the *.exe files: set CORFUNC_FORT_PATH="E:\Corfunc"

   Enclosing the DOS paths in "" is essential if installing
   CORFUNC to a folder with white spaces in its name;
   e.g. Program Files !

   **Do not** make any other changes to this file unless
   you are sure you know what you are doing!


4. A category "CCP13" will have been created in the Start
   Menu.  The program may be run or uninstalled from the
   Start Menu icons inside.



Steve King, December 2005
s.m.king@rl.ac.uk