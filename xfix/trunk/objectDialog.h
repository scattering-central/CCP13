
/*******************************************************************************
       objectDialog.h
       This header file is included by objectDialog.c

*******************************************************************************/

#ifndef	_OBJECTDIALOG_INCLUDED
#define	_OBJECTDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef objectDialog_addItem
#define objectDialog_addItem( UxThis, pEnv, string ) \
	((int(*)())UxMethodLookup(UxThis, UxobjectDialog_addItem_Id,\
			UxobjectDialog_addItem_Name)) \
		( UxThis, pEnv, string )
#endif

#ifndef objectDialog_getSelPos
#define objectDialog_getSelPos( UxThis, pEnv, list, number ) \
	((int(*)())UxMethodLookup(UxThis, UxobjectDialog_getSelPos_Id,\
			UxobjectDialog_getSelPos_Name)) \
		( UxThis, pEnv, list, number )
#endif

#ifndef objectDialog_itemCount
#define objectDialog_itemCount( UxThis, pEnv ) \
	((int(*)())UxMethodLookup(UxThis, UxobjectDialog_itemCount_Id,\
			UxobjectDialog_itemCount_Name)) \
		( UxThis, pEnv )
#endif

#ifndef objectDialog_deleteAllItems
#define objectDialog_deleteAllItems( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxobjectDialog_deleteAllItems_Id,\
			UxobjectDialog_deleteAllItems_Name)) \
		( UxThis, pEnv )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxobjectDialog_addItem_Id;
extern char*	UxobjectDialog_addItem_Name;
extern int	UxobjectDialog_getSelPos_Id;
extern char*	UxobjectDialog_getSelPos_Name;
extern int	UxobjectDialog_itemCount_Id;
extern char*	UxobjectDialog_itemCount_Name;
extern int	UxobjectDialog_deleteAllItems_Id;
extern char*	UxobjectDialog_deleteAllItems_Name;

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
	Widget	UxobjectDialog;
	Widget	UxscrolledWindowList1;
	Widget	UxobjectList;
	swidget	UxUxParent;
} _UxCobjectDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCobjectDialog        *UxObjectDialogContext;
#define objectDialog            UxObjectDialogContext->UxobjectDialog
#define scrolledWindowList1     UxObjectDialogContext->UxscrolledWindowList1
#define objectList              UxObjectDialogContext->UxobjectList
#define UxParent                UxObjectDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_objectDialog( swidget _UxUxParent );

#endif	/* _OBJECTDIALOG_INCLUDED */
