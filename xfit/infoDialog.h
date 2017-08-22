
/*******************************************************************************
       infoDialog.h
       This header file is included by infoDialog.c

*******************************************************************************/

#ifndef	_INFODIALOG_INCLUDED
#define	_INFODIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef infoDialog_popup
#define infoDialog_popup( UxThis, pEnv, msg ) \
	((int(*)())UxMethodLookup(UxThis, UxinfoDialog_popup_Id,\
			UxinfoDialog_popup_Name)) \
		( UxThis, pEnv, msg )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxinfoDialog_popup_Id;
extern char*	UxinfoDialog_popup_Name;

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
	Widget	UxinfoDialog;
	swidget	UxUxParent;
} _UxCinfoDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCinfoDialog          *UxInfoDialogContext;
#define infoDialog              UxInfoDialogContext->UxinfoDialog
#define UxParent                UxInfoDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_infoDialog( swidget _UxUxParent );

#endif	/* _INFODIALOG_INCLUDED */
