########################################################################
# $Date: 1995/03/29 16:49:51 $		$Revision: 2.46.18.6.23.7 $
########################################################################
#             Copyright 1991, Visual Edge Software Ltd.
#
# ALL  RIGHTS  RESERVED.  Permission  to  use,  copy,  modify,  and
# distribute  this  software  and its documentation for any purpose
# and  without  fee  is  hereby  granted,  provided  that the above
# copyright  notice  appear  in  all  copies  and  that  both  that
# copyright  notice and this permission notice appear in supporting
# documentation,  and that  the name of Visual Edge Software not be
# used  in advertising  or publicity  pertaining to distribution of
# the software without specific, written prior permission. The year
# included in the notice is the year of the creation of the work.
########################################################################
#
#       MAKEFILE FOR STAND-ALONE XT CODE APPLICATION.  
#
#       EXECUTABLE      is the name of the executable to be created 
#       MAIN            is the .c file containing your main() function 
#       INTERFACES      is a list of the generated C code files
#       APP_OBJS        is a (possibly empty) list of the object code
#                       files that form the non-interface portion of
#                       your application
#
#       In the first three statements, the variables on the right 
#	of the equal sign will be replaced with their corresponding
#       values when the makefile is automatically generated.
#
#       This template is used for makefiles which do not reference 
#       the Ux runtime library.
#
########################################################################
# 
#	List of supported compiler(s):
#
#	gcc - Version 2.6.1
#	cc  - SPARCompiler Version 3.0.1
#	CC  - SPARCompiler Version 3.0.1  
#
########################################################################

EXECUTABLE	= ./xconv
MAIN		= xconv.cc
INTERFACES	= mainWS.cc \
	QuestionDialog.cc \
	FileSelection.cc \
	ErrorMessage.cc \
	InformationDialog.cc
MYCODE		= map.cc \
	file.cc \
	strng.cc \
	pck.cc \
	

LANGUAGE	= C++
APPL_OBJS	= UxXt.o UxCplus.o UxMethod.o 

SHELL		= /bin/sh

X_LIBS		=/usr/X11R6/lib/libXm.a  -lXmu -lXt -lXpm -lSM -lICE -lXext -lX11

X_LIBPATH	= -L/usr/X11R6/lib
MOTIF_LIBPATH	= -L/home/mws/motif
X_CFLAGS	= -I/usr/X11R6/include
MOTIF_CFLAGS	= -I/home/mws/motif -DMOTIF
#T_LIBPATH	= -L/usr/local/lib
T_LIB		= /usr/local/lib/libtiff.a -ltiff

# For GNU Ansi cc
ANSI_CC         = gcc
ANSI_CFLAGS     = -ansi -g


# For GNU c++
CPLUS_CC        = g++
CPLUS_CFLAGS    = -g

CFLAGS		= -DLINUX -DGNU -DUNIX -DXT_CODE -DXOPEN_CATALOG $(MOTIF_CFLAGS) \
		  $(X_CFLAGS)
UCB_LIBPATH     = /usr/ucblib

LIBPATH		= $(MOTIF_LIBPATH) $(X_LIBPATH) $(T_LIBPATH) 
LIBS            = $(X_LIBS) $(T_LIB) -lm 


OBJS = $(MAIN:.cc=.o) $(INTERFACES:.cc=.o) $(MYCODE:.cc=.o) $(APPL_OBJS)


$(EXECUTABLE): $(OBJS)
	@echo "Linking    $(EXECUTABLE)"
	$(LD) -static  $(OBJS) $(LIBPATH) $(LIBS)  -o $(EXECUTABLE)
	@echo "Done"


.SUFFIXES: 
.SUFFIXES: .o .cc .c

.c.o:
	@echo Compiling $< [$(LANGUAGE)] [XT-CODE]
	$(CC) -c $(CFLAGS) $< -o $@
.cc.o:
	@echo Compiling $< [$(LANGUAGE)] [XT-CODE]
	$(CC) -c $(CFLAGS) $< -o $@


#lean:
#	@echo "Cleaning xconv $(OBJS)" ; \
#	bin/rm -f xconv $(OBJS)

CC = \
@`if [ "$(LANGUAGE)" = "C++" ]; then echo $(CPLUS_CC) $(CPLUS_CFLAGS);fi` \
`if [ "$(LANGUAGE)" = "ANSI C" ]; then echo $(ANSI_CC) $(ANSI_CFLAGS); fi`\
`if [ "$(LANGUAGE)" = "KR-C" ]; then echo $(KR_CC) $(KR_CFLAGS); fi`

LD = \
@`if [ "$(LANGUAGE)" = "C++" ]; then echo $(CPLUS_CC);fi` \
`if [ "$(LANGUAGE)" = "ANSI C" ]; then echo $(ANSI_CC); fi`\
`if [ "$(LANGUAGE)" = "KR-C" ]; then echo $(KR_CC); fi`

LD_FLAGS = \
`if [ "$(LANGUAGE)" = "C++" ]; then echo $(CPLUS_LDFLAGS);fi`\
`if [ "$(LANGUAGE)" = "ANSI C" ]; then echo $(ANSI_LDFLAGS); fi`\
`if [ "$(LANGUAGE)" = "KR-C" ]; then echo $(KR_LDFLAGS); fi`
