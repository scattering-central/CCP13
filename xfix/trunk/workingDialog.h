
/*******************************************************************************
       workingDialog.h
       This header file is included by workingDialog.c

*******************************************************************************/

#ifndef	_WORKINGDIALOG_INCLUDED
#define	_WORKINGDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef workingDialog_popup
#define workingDialog_popup( UxThis, pEnv, msg ) \
	((void(*)())UxMethodLookup(UxThis, UxworkingDialog_popup_Id,\
			UxworkingDialog_popup_Name)) \
		( UxThis, pEnv, msg )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxworkingDialog_popup_Id;
extern char*	UxworkingDialog_popup_Name;

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
	Widget	UxworkingDialog;
	swidget	UxUxParent;
} _UxCworkingDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCworkingDialog       *UxWorkingDialogContext;
#define workingDialog           UxWorkingDialogContext->UxworkingDialog
#define UxParent                UxWorkingDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_workingDialog( swidget _UxUxParent );

#endif	/* _WORKINGDIALOG_INCLUDED */
