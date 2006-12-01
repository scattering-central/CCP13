
/*******************************************************************************
       yDialog.h
       This header file is included by yDialog.c

*******************************************************************************/

#ifndef	_YDIALOG_INCLUDED
#define	_YDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef yDialog_popup
#define yDialog_popup( UxThis, pEnv, string ) \
	((int(*)())UxMethodLookup(UxThis, UxyDialog_popup_Id,\
			UxyDialog_popup_Name)) \
		( UxThis, pEnv, string )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxyDialog_popup_Id;
extern char*	UxyDialog_popup_Name;

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
	Widget	UxyDialog;
	Widget	UxrowColumn1;
	Widget	UxtextField1;
	Widget	Uxlabel1;
	Widget	UxtextField2;
	Widget	Uxlabel2;
	swidget	UxUxParent;
} _UxCyDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCyDialog             *UxYDialogContext;
#define yDialog                 UxYDialogContext->UxyDialog
#define rowColumn1              UxYDialogContext->UxrowColumn1
#define textField1              UxYDialogContext->UxtextField1
#define label1                  UxYDialogContext->Uxlabel1
#define textField2              UxYDialogContext->UxtextField2
#define label2                  UxYDialogContext->Uxlabel2
#define UxParent                UxYDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_yDialog( swidget _UxUxParent );

#endif	/* _YDIALOG_INCLUDED */
