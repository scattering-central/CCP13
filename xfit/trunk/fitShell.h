
/*******************************************************************************
       fitShell.h
       This header file is included by fitShell.c

*******************************************************************************/

#ifndef	_FITSHELL_INCLUDED
#define	_FITSHELL_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef fitShell_SetHeaders
#define fitShell_SetHeaders( UxThis, pEnv, h1, h2 ) \
	((void(*)())UxMethodLookup(UxThis, UxfitShell_SetHeaders_Id,\
			UxfitShell_SetHeaders_Name)) \
		( UxThis, pEnv, h1, h2 )
#endif

#ifndef fitShell_help
#define fitShell_help( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxfitShell_help_Id,\
			UxfitShell_help_Name)) \
		( UxThis, pEnv )
#endif

#ifndef fitShell_continue
#define fitShell_continue( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxfitShell_continue_Id,\
			UxfitShell_continue_Name)) \
		( UxThis, pEnv )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxfitShell_SetHeaders_Id;
extern char*	UxfitShell_SetHeaders_Name;
extern int	UxfitShell_help_Id;
extern char*	UxfitShell_help_Name;
extern int	UxfitShell_continue_Id;
extern char*	UxfitShell_continue_Name;

/*******************************************************************************
       The definition of the context structure:
       If you create multiple copies of your interface, the context
       structure ensures that your callbacks use the variables for the
       correct copy.

       For each swidget in the interface, each argument to the Interface
       function, and each variable in the Interface Specific section of the
       Declarations Editor, there is an entry in the context structure
       and a #define.  The #define makes the variable name refer to the
       corresponding entry in the context structure.
*******************************************************************************/

typedef	struct
{
	Widget	UxfitShell;
	Widget	UxpanedWindow1;
	Widget	UxmenuBar;
	Widget	UxmenuBar_p1;
	Widget	UxmenuBar_p1_b1;
	Widget	UxmenuBar_p1_b5;
	Widget	UxmenuBar_p1_b6;
	Widget	UxmenuBar_p1_b8;
	Widget	UxmenuBar_p1_b2;
	Widget	UxmenuBar_p1_separator;
	Widget	UxmenuBar_p1_b4;
	Widget	UxmenuBar_top_b1;
	Widget	UxmenuBar_p2;
	Widget	UxmenuBar_p2_b1;
	Widget	UxmenuBar_p2_b2;
	Widget	UxmenuBar_p2_b3;
	Widget	UxmenuBar_top_b2;
	Widget	UxmenuBar_p3;
	Widget	UxmenuBar_p3_b1;
	Widget	UxmenuBar_top_b3;
	Widget	Uxform2;
	Widget	Uxlabel1;
	Widget	Uxform1;
	Widget	UxscrolledWindow1;
	Widget	UxscrolledText1;
	char	*Uxxfile;
	char	*Uxyfile;
	char	*Uxinitfile;
	char	*Uxoutfile;
	char	*Uxsfile;
	char	*Uxhardfile;
	char	*Uxhelpfile;
	char	*Uxccp13ptr;
	char	*Uxheader1;
	char	*Uxheader2;
	char	Uxchartmp[100];
	int	Uxfirstrun;
	int	Uxfile_input;
	int	Uxfile_ready;
	int	Uxmode;
	int	UxinputPause;
	int	Uxiffr;
	int	Uxilfr;
	int	Uxifinc;
	int	Uxfilenum;
	int	Uxyiffr;
	int	Uxyilfr;
	int	Uxyifinc;
	int	Uxyfilenum;
	int	Uxxiffr;
	int	Uxxilfr;
	int	Uxxifinc;
	int	Uxxfilenum;
	int	Uxinitiffr;
	int	Uxinitilfr;
	int	Uxinitifinc;
	int	Uxinitfilenum;
	int	Uxsiffr;
	int	Uxsilfr;
	int	Uxsifinc;
	int	Uxsfilenum;
	swidget	UxUxParent;
} _UxCfitShell;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCfitShell            *UxFitShellContext;
#define fitShell                UxFitShellContext->UxfitShell
#define panedWindow1            UxFitShellContext->UxpanedWindow1
#define menuBar                 UxFitShellContext->UxmenuBar
#define menuBar_p1              UxFitShellContext->UxmenuBar_p1
#define menuBar_p1_b1           UxFitShellContext->UxmenuBar_p1_b1
#define menuBar_p1_b5           UxFitShellContext->UxmenuBar_p1_b5
#define menuBar_p1_b6           UxFitShellContext->UxmenuBar_p1_b6
#define menuBar_p1_b8           UxFitShellContext->UxmenuBar_p1_b8
#define menuBar_p1_b2           UxFitShellContext->UxmenuBar_p1_b2
#define menuBar_p1_separator    UxFitShellContext->UxmenuBar_p1_separator
#define menuBar_p1_b4           UxFitShellContext->UxmenuBar_p1_b4
#define menuBar_top_b1          UxFitShellContext->UxmenuBar_top_b1
#define menuBar_p2              UxFitShellContext->UxmenuBar_p2
#define menuBar_p2_b1           UxFitShellContext->UxmenuBar_p2_b1
#define menuBar_p2_b2           UxFitShellContext->UxmenuBar_p2_b2
#define menuBar_p2_b3           UxFitShellContext->UxmenuBar_p2_b3
#define menuBar_top_b2          UxFitShellContext->UxmenuBar_top_b2
#define menuBar_p3              UxFitShellContext->UxmenuBar_p3
#define menuBar_p3_b1           UxFitShellContext->UxmenuBar_p3_b1
#define menuBar_top_b3          UxFitShellContext->UxmenuBar_top_b3
#define form2                   UxFitShellContext->Uxform2
#define label1                  UxFitShellContext->Uxlabel1
#define form1                   UxFitShellContext->Uxform1
#define scrolledWindow1         UxFitShellContext->UxscrolledWindow1
#define scrolledText1           UxFitShellContext->UxscrolledText1
#define xfile                   UxFitShellContext->Uxxfile
#define yfile                   UxFitShellContext->Uxyfile
#define initfile                UxFitShellContext->Uxinitfile
#define outfile                 UxFitShellContext->Uxoutfile
#define sfile                   UxFitShellContext->Uxsfile
#define hardfile                UxFitShellContext->Uxhardfile
#define helpfile                UxFitShellContext->Uxhelpfile
#define ccp13ptr                UxFitShellContext->Uxccp13ptr
#define header1                 UxFitShellContext->Uxheader1
#define header2                 UxFitShellContext->Uxheader2
#define chartmp                 UxFitShellContext->Uxchartmp
#define firstrun                UxFitShellContext->Uxfirstrun
#define file_input              UxFitShellContext->Uxfile_input
#define file_ready              UxFitShellContext->Uxfile_ready
#define mode                    UxFitShellContext->Uxmode
#define inputPause              UxFitShellContext->UxinputPause
#define iffr                    UxFitShellContext->Uxiffr
#define ilfr                    UxFitShellContext->Uxilfr
#define ifinc                   UxFitShellContext->Uxifinc
#define filenum                 UxFitShellContext->Uxfilenum
#define yiffr                   UxFitShellContext->Uxyiffr
#define yilfr                   UxFitShellContext->Uxyilfr
#define yifinc                  UxFitShellContext->Uxyifinc
#define yfilenum                UxFitShellContext->Uxyfilenum
#define xiffr                   UxFitShellContext->Uxxiffr
#define xilfr                   UxFitShellContext->Uxxilfr
#define xifinc                  UxFitShellContext->Uxxifinc
#define xfilenum                UxFitShellContext->Uxxfilenum
#define initiffr                UxFitShellContext->Uxinitiffr
#define initilfr                UxFitShellContext->Uxinitilfr
#define initifinc               UxFitShellContext->Uxinitifinc
#define initfilenum             UxFitShellContext->Uxinitfilenum
#define siffr                   UxFitShellContext->Uxsiffr
#define silfr                   UxFitShellContext->Uxsilfr
#define sifinc                  UxFitShellContext->Uxsifinc
#define sfilenum                UxFitShellContext->Uxsfilenum
#define UxParent                UxFitShellContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_fitShell( swidget _UxUxParent );

#endif	/* _FITSHELL_INCLUDED */
