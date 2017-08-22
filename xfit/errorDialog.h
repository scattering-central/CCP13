
/*******************************************************************************
       errorDialog.h
       This header file is included by errorDialog.c

*******************************************************************************/

#ifndef	_ERRORDIALOG_INCLUDED
#define	_ERRORDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef errorDialog_popup
#define errorDialog_popup( UxThis, pEnv, msg ) \
	((int(*)())UxMethodLookup(UxThis, UxerrorDialog_popup_Id,\
			UxerrorDialog_popup_Name)) \
		( UxThis, pEnv, msg )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxerrorDialog_popup_Id;
extern char*	UxerrorDialog_popup_Name;

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
	Widget	UxerrorDialog;
	swidget	UxUxParent;
} _UxCerrorDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCerrorDialog         *UxErrorDialogContext;
#define errorDialog             UxErrorDialogContext->UxerrorDialog
#define UxParent                UxErrorDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_errorDialog( swidget _UxUxParent );

#endif	/* _ERRORDIALOG_INCLUDED */
