
/*******************************************************************************
       headerDialog.h
       This header file is included by headerDialog.c

*******************************************************************************/

#ifndef	_HEADERDIALOG_INCLUDED
#define	_HEADERDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef headerDialog_popup
#define headerDialog_popup( UxThis, pEnv, filename ) \
	((int(*)())UxMethodLookup(UxThis, UxheaderDialog_popup_Id,\
			UxheaderDialog_popup_Name)) \
		( UxThis, pEnv, filename )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxheaderDialog_popup_Id;
extern char*	UxheaderDialog_popup_Name;

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
	Widget	UxheaderDialog;
	Widget	UxrowColumn5;
	Widget	Uxlabel11;
	Widget	Uxlabel10;
	Widget	UxtextHead1;
	Widget	UxtextHead2;
	swidget	UxUxParent;
} _UxCheaderDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCheaderDialog        *UxHeaderDialogContext;
#define headerDialog            UxHeaderDialogContext->UxheaderDialog
#define rowColumn5              UxHeaderDialogContext->UxrowColumn5
#define label11                 UxHeaderDialogContext->Uxlabel11
#define label10                 UxHeaderDialogContext->Uxlabel10
#define textHead1               UxHeaderDialogContext->UxtextHead1
#define textHead2               UxHeaderDialogContext->UxtextHead2
#define UxParent                UxHeaderDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_headerDialog( swidget _UxUxParent );

#endif	/* _HEADERDIALOG_INCLUDED */
