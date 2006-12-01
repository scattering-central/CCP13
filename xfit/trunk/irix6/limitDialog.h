
/*******************************************************************************
       limitDialog.h
       This header file is included by limitDialog.c

*******************************************************************************/

#ifndef	_LIMITDIALOG_INCLUDED
#define	_LIMITDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef limitDialog_lput
#define limitDialog_lput( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxlimitDialog_lput_Id,\
			UxlimitDialog_lput_Name)) \
		( UxThis, pEnv )
#endif

#ifndef limitDialog_lshow
#define limitDialog_lshow( UxThis, pEnv, num ) \
	((void(*)())UxMethodLookup(UxThis, UxlimitDialog_lshow_Id,\
			UxlimitDialog_lshow_Name)) \
		( UxThis, pEnv, num )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxlimitDialog_lput_Id;
extern char*	UxlimitDialog_lput_Name;
extern int	UxlimitDialog_lshow_Id;
extern char*	UxlimitDialog_lshow_Name;

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
	Widget	UxlimitDialog;
	Widget	Uxform1;
	Widget	Uxlabel4;
	Widget	UxtextPar1;
	Widget	UxlabelPeak1;
	Widget	UxtextLimit1_1;
	Widget	UxtextLimit1_2;
	Widget	UxlabelTo1;
	Widget	Uxlabel8;
	Widget	UxarrowB_limit2;
	Widget	UxarrowB_limit1;
	int	Uxlpar;
	int	Uxcpar;
	int	Uxcstate;
	double	Uxlim1;
	double	Uxlim2;
	swidget	UxUxParent;
} _UxClimitDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxClimitDialog         *UxLimitDialogContext;
#define limitDialog             UxLimitDialogContext->UxlimitDialog
#define form1                   UxLimitDialogContext->Uxform1
#define label4                  UxLimitDialogContext->Uxlabel4
#define textPar1                UxLimitDialogContext->UxtextPar1
#define labelPeak1              UxLimitDialogContext->UxlabelPeak1
#define textLimit1_1            UxLimitDialogContext->UxtextLimit1_1
#define textLimit1_2            UxLimitDialogContext->UxtextLimit1_2
#define labelTo1                UxLimitDialogContext->UxlabelTo1
#define label8                  UxLimitDialogContext->Uxlabel8
#define arrowB_limit2           UxLimitDialogContext->UxarrowB_limit2
#define arrowB_limit1           UxLimitDialogContext->UxarrowB_limit1
#define lpar                    UxLimitDialogContext->Uxlpar
#define cpar                    UxLimitDialogContext->Uxcpar
#define cstate                  UxLimitDialogContext->Uxcstate
#define lim1                    UxLimitDialogContext->Uxlim1
#define lim2                    UxLimitDialogContext->Uxlim2
#define UxParent                UxLimitDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_limitDialog( swidget _UxUxParent );

#endif	/* _LIMITDIALOG_INCLUDED */
