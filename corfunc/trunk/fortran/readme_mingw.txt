MinGW


A collection of freely available and freely distributable Windows specific header files and import libraries combined with GNU toolsets that allow one to produce native Windows programs that do not rely on any 3rd-party C runtime DLLs.


MinGW - History

Mingw32 was created by Colin Peters. The oldest preserved release currently available may also be found at Colin Peters' GCC website and is dated July 1, 1998. Colin used a very early release of the Cygwin suite to compile this version of the Mingw compiler code. 

The very first native mingw32 compiler was provided by Jan-Jaap van der Heijden. Besides GCC 2.8.1, Meister van der Heijdens' contributions included GNU binutils, GNU make and just about everything else needed to develop your own software using Mingw32 (Minimalist Gnu-Windows32).

Mumit Khan took the baton and over a couple of following years has been doing great work of maintanance and development of Mingw32. He did many developments for supporting Windows32-specific features in GCC and Binutils (which is of course of great value for entire GNU/Windows32), provided binary releases of them (with each new release of GCC and often before one was available for Cygwin) and developed more comprehensive bindings for runtime libraries. Significant addition to Mingw32 was Anders Norlander's w32api headers, which brought more comprehensive bindings for Windows32 API than what were previously available. 

To the second half of 1999, user base of Mingw32 became large enough to split off Cygwin mailing list and set up list specifically for Mingw32. Earnie Boyd and Dale Handerson moderated it. 

At the beginning of Y2K, there was exposed public interest in development of Mingw, as well as offers for public services helping with OpenSource development, such as SourceForge, were made. It was decided to set up such a project for Mingw32 and call for maintainers and developers. 


MinGW - Licensing Terms

Various pieces distributed with MinGW come with its own copyright and license:

Basic MinGW runtime 
MinGW base runtime package is uncopyrighted and placed in the public domain. This basically means that you can do what you want with the code.

w32api 
You are free to use, modify and copy this package. No restrictions are imposed on programs or object files compiled with this library. You may not restrict the the usage of this library. You may distribute this library as part of another package or as a modified package if and only if you do not restrict the usage of the portions consisting of this (optionally modified) library. If distributed as a modified package then this file must be included. 

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 

MinGW profiling code 
MinGW profiling code is distributed under the GNU General Public License. 
The development tools such as GCC, GDB, GNU Make, etc all covered by GNU General Public License.


