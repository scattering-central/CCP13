
/*******************************************************************************
       tieDialog.h
       This header file is included by tieDialog.c

*******************************************************************************/

#ifndef	_TIEDIALOG_INCLUDED
#define	_TIEDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef tieDialog_tput
#define tieDialog_tput( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxtieDialog_tput_Id,\
			UxtieDialog_tput_Name)) \
		( UxThis, pEnv )
#endif

#ifndef tieDialog_tshow
#define tieDialog_tshow( UxThis, pEnv, num ) \
	((void(*)())UxMethodLookup(UxThis, UxtieDialog_tshow_Id,\
			UxtieDialog_tshow_Name)) \
		( UxThis, pEnv, num )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxtieDialog_tput_Id;
extern char*	UxtieDialog_tput_Name;
extern int	UxtieDialog_tshow_Id;
extern char*	UxtieDialog_tshow_Name;

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
	Widget	UxtieDialog;
	Widget	Uxform2;
	Widget	Uxlabel1;
	Widget	Uxlabel2;
	Widget	UxtextTie_par;
	Widget	UxtieMenu_p1;
	Widget	UxtieMenu_equal;
	Widget	UxtieMenu_hex;
	Widget	UxtieMenu_tet;
	Widget	UxtieMenu_cub;
	Widget	UxtieMenu1;
	Widget	Uxlabel5;
	Widget	UxtextH;
	Widget	Uxlabel6;
	Widget	UxarrowButton2;
	Widget	UxtextK;
	Widget	Uxlabel7;
	Widget	UxtextL;
	Widget	UxtextPar;
	Widget	UxlabelPeak;
	Widget	UxlabelPeak2;
	Widget	UxarrowButton1;
	Widget	Uxlabel4;
	char	Uxconstraint[5];
	int	Uxistate;
	int	Uxcpar;
	int	Uxpar;
	int	Uxtiepar;
	int	Uxctype;
	int	Uxih;
	int	Uxik;
	int	Uxil;
	swidget	UxUxParent;
} _UxCtieDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCtieDialog           *UxTieDialogContext;
#define tieDialog               UxTieDialogContext->UxtieDialog
#define form2                   UxTieDialogContext->Uxform2
#define label1                  UxTieDialogContext->Uxlabel1
#define label2                  UxTieDialogContext->Uxlabel2
#define textTie_par             UxTieDialogContext->UxtextTie_par
#define tieMenu_p1              UxTieDialogContext->UxtieMenu_p1
#define tieMenu_equal           UxTieDialogContext->UxtieMenu_equal
#define tieMenu_hex             UxTieDialogContext->UxtieMenu_hex
#define tieMenu_tet             UxTieDialogContext->UxtieMenu_tet
#define tieMenu_cub             UxTieDialogContext->UxtieMenu_cub
#define tieMenu1                UxTieDialogContext->UxtieMenu1
#define label5                  UxTieDialogContext->Uxlabel5
#define textH                   UxTieDialogContext->UxtextH
#define label6                  UxTieDialogContext->Uxlabel6
#define arrowButton2            UxTieDialogContext->UxarrowButton2
#define textK                   UxTieDialogContext->UxtextK
#define label7                  UxTieDialogContext->Uxlabel7
#define textL                   UxTieDialogContext->UxtextL
#define textPar                 UxTieDialogContext->UxtextPar
#define labelPeak               UxTieDialogContext->UxlabelPeak
#define labelPeak2              UxTieDialogContext->UxlabelPeak2
#define arrowButton1            UxTieDialogContext->UxarrowButton1
#define label4                  UxTieDialogContext->Uxlabel4
#define constraint              UxTieDialogContext->Uxconstraint
#define istate                  UxTieDialogContext->Uxistate
#define cpar                    UxTieDialogContext->Uxcpar
#define par                     UxTieDialogContext->Uxpar
#define tiepar                  UxTieDialogContext->Uxtiepar
#define ctype                   UxTieDialogContext->Uxctype
#define ih                      UxTieDialogContext->Uxih
#define ik                      UxTieDialogContext->Uxik
#define il                      UxTieDialogContext->Uxil
#define UxParent                UxTieDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_tieDialog( swidget _UxUxParent );

#endif	/* _TIEDIALOG_INCLUDED */
