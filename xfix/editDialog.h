
/*******************************************************************************
       editDialog.h
       This header file is included by editDialog.c

*******************************************************************************/

#ifndef	_EDITDIALOG_INCLUDED
#define	_EDITDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef editDialog_repaintOverItemMarkers
#define editDialog_repaintOverItemMarkers( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxeditDialog_repaintOverItemMarkers_Id,\
			UxeditDialog_repaintOverItemMarkers_Name)) \
		( UxThis, pEnv )
#endif

#ifndef editDialog_addItem
#define editDialog_addItem( UxThis, pEnv, string ) \
	((int(*)())UxMethodLookup(UxThis, UxeditDialog_addItem_Id,\
			UxeditDialog_addItem_Name)) \
		( UxThis, pEnv, string )
#endif

#ifndef editDialog_getSelPos
#define editDialog_getSelPos( UxThis, pEnv, list, number ) \
	((int(*)())UxMethodLookup(UxThis, UxeditDialog_getSelPos_Id,\
			UxeditDialog_getSelPos_Name)) \
		( UxThis, pEnv, list, number )
#endif

#ifndef editDialog_deleteCommand
#define editDialog_deleteCommand( UxThis, pEnv, n ) \
	((void(*)())UxMethodLookup(UxThis, UxeditDialog_deleteCommand_Id,\
			UxeditDialog_deleteCommand_Name)) \
		( UxThis, pEnv, n )
#endif

#ifndef editDialog_markItems
#define editDialog_markItems( UxThis, pEnv, item1, item2, flag ) \
	((void(*)())UxMethodLookup(UxThis, UxeditDialog_markItems_Id,\
			UxeditDialog_markItems_Name)) \
		( UxThis, pEnv, item1, item2, flag )
#endif

#ifndef editDialog_drawItems
#define editDialog_drawItems( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxeditDialog_drawItems_Id,\
			UxeditDialog_drawItems_Name)) \
		( UxThis, pEnv )
#endif

#ifndef editDialog_itemCount
#define editDialog_itemCount( UxThis, pEnv ) \
	((int(*)())UxMethodLookup(UxThis, UxeditDialog_itemCount_Id,\
			UxeditDialog_itemCount_Name)) \
		( UxThis, pEnv )
#endif

#ifndef editDialog_modifyItemPos
#define editDialog_modifyItemPos( UxThis, pEnv, nPos, pcString ) \
	((void(*)())UxMethodLookup(UxThis, UxeditDialog_modifyItemPos_Id,\
			UxeditDialog_modifyItemPos_Name)) \
		( UxThis, pEnv, nPos, pcString )
#endif

#ifndef editDialog_setup
#define editDialog_setup( UxThis, pEnv, nWidth, pcTitle, pcLabel ) \
	((void(*)())UxMethodLookup(UxThis, UxeditDialog_setup_Id,\
			UxeditDialog_setup_Name)) \
		( UxThis, pEnv, nWidth, pcTitle, pcLabel )
#endif

#ifndef editDialog_deleteAllItems
#define editDialog_deleteAllItems( UxThis, pEnv ) \
	((int(*)())UxMethodLookup(UxThis, UxeditDialog_deleteAllItems_Id,\
			UxeditDialog_deleteAllItems_Name)) \
		( UxThis, pEnv )
#endif

#ifndef editDialog_renumber
#define editDialog_renumber( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxeditDialog_renumber_Id,\
			UxeditDialog_renumber_Name)) \
		( UxThis, pEnv )
#endif

#ifndef editDialog_destroyItemPos
#define editDialog_destroyItemPos( UxThis, pEnv, n ) \
	((void(*)())UxMethodLookup(UxThis, UxeditDialog_destroyItemPos_Id,\
			UxeditDialog_destroyItemPos_Name)) \
		( UxThis, pEnv, n )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxeditDialog_repaintOverItemMarkers_Id;
extern char*	UxeditDialog_repaintOverItemMarkers_Name;
extern int	UxeditDialog_addItem_Id;
extern char*	UxeditDialog_addItem_Name;
extern int	UxeditDialog_getSelPos_Id;
extern char*	UxeditDialog_getSelPos_Name;
extern int	UxeditDialog_deleteCommand_Id;
extern char*	UxeditDialog_deleteCommand_Name;
extern int	UxeditDialog_markItems_Id;
extern char*	UxeditDialog_markItems_Name;
extern int	UxeditDialog_drawItems_Id;
extern char*	UxeditDialog_drawItems_Name;
extern int	UxeditDialog_itemCount_Id;
extern char*	UxeditDialog_itemCount_Name;
extern int	UxeditDialog_modifyItemPos_Id;
extern char*	UxeditDialog_modifyItemPos_Name;
extern int	UxeditDialog_setup_Id;
extern char*	UxeditDialog_setup_Name;
extern int	UxeditDialog_deleteAllItems_Id;
extern char*	UxeditDialog_deleteAllItems_Name;
extern int	UxeditDialog_renumber_Id;
extern char*	UxeditDialog_renumber_Name;
extern int	UxeditDialog_destroyItemPos_Id;
extern char*	UxeditDialog_destroyItemPos_Name;

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
	Widget	UxeditDialog;
	Widget	UxeditForm;
	Widget	UxeditScrolledWindowList;
	Widget	UxeditScrolledList;
	Widget	UxeditLabel;
	Widget	UxrenumberButton;
	swidget	UxUxParent;
} _UxCeditDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCeditDialog          *UxEditDialogContext;
#define editDialog              UxEditDialogContext->UxeditDialog
#define editForm                UxEditDialogContext->UxeditForm
#define editScrolledWindowList  UxEditDialogContext->UxeditScrolledWindowList
#define editScrolledList        UxEditDialogContext->UxeditScrolledList
#define editLabel               UxEditDialogContext->UxeditLabel
#define renumberButton          UxEditDialogContext->UxrenumberButton
#define UxParent                UxEditDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_editDialog( swidget _UxUxParent );

#endif	/* _EDITDIALOG_INCLUDED */
