
/*******************************************************************************
       lineDialog.h
       This header file is included by lineDialog.c

*******************************************************************************/

#ifndef	_LINEDIALOG_INCLUDED
#define	_LINEDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef lineDialog_addItem
#define lineDialog_addItem( UxThis, pEnv, string ) \
	((int(*)())UxMethodLookup(UxThis, UxlineDialog_addItem_Id,\
			UxlineDialog_addItem_Name)) \
		( UxThis, pEnv, string )
#endif

#ifndef lineDialog_getSelPos
#define lineDialog_getSelPos( UxThis, pEnv, list, number ) \
	((int(*)())UxMethodLookup(UxThis, UxlineDialog_getSelPos_Id,\
			UxlineDialog_getSelPos_Name)) \
		( UxThis, pEnv, list, number )
#endif

#ifndef lineDialog_itemCount
#define lineDialog_itemCount( UxThis, pEnv ) \
	((int(*)())UxMethodLookup(UxThis, UxlineDialog_itemCount_Id,\
			UxlineDialog_itemCount_Name)) \
		( UxThis, pEnv )
#endif

#ifndef lineDialog_deleteAllItems
#define lineDialog_deleteAllItems( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxlineDialog_deleteAllItems_Id,\
			UxlineDialog_deleteAllItems_Name)) \
		( UxThis, pEnv )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxlineDialog_addItem_Id;
extern char*	UxlineDialog_addItem_Name;
extern int	UxlineDialog_getSelPos_Id;
extern char*	UxlineDialog_getSelPos_Name;
extern int	UxlineDialog_itemCount_Id;
extern char*	UxlineDialog_itemCount_Name;
extern int	UxlineDialog_deleteAllItems_Id;
extern char*	UxlineDialog_deleteAllItems_Name;

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
	Widget	UxlineDialog;
	Widget	UxscrolledWindowList2;
	Widget	UxlineList;
	swidget	UxUxParent;
} _UxClineDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxClineDialog          *UxLineDialogContext;
#define lineDialog              UxLineDialogContext->UxlineDialog
#define scrolledWindowList2     UxLineDialogContext->UxscrolledWindowList2
#define lineList                UxLineDialogContext->UxlineList
#define UxParent                UxLineDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_lineDialog( swidget _UxUxParent );

#endif	/* _LINEDIALOG_INCLUDED */
