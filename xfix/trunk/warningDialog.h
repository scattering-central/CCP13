
/*******************************************************************************
       warningDialog.h
       This header file is included by warningDialog.c

*******************************************************************************/

#ifndef	_WARNINGDIALOG_INCLUDED
#define	_WARNINGDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef warningDialog_popup
#define warningDialog_popup( UxThis, pEnv, msg ) \
	((int(*)())UxMethodLookup(UxThis, UxwarningDialog_popup_Id,\
			UxwarningDialog_popup_Name)) \
		( UxThis, pEnv, msg )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxwarningDialog_popup_Id;
extern char*	UxwarningDialog_popup_Name;

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
	Widget	UxwarningDialog;
	swidget	UxUxParent;
} _UxCwarningDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCwarningDialog       *UxWarningDialogContext;
#define warningDialog           UxWarningDialogContext->UxwarningDialog
#define UxParent                UxWarningDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_warningDialog( swidget _UxUxParent );

#endif	/* _WARNINGDIALOG_INCLUDED */
