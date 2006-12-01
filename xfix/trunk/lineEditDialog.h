
/*******************************************************************************
       lineEditDialog.h
       This header file is included by lineEditDialog.c

*******************************************************************************/

#ifndef	_LINEEDITDIALOG_INCLUDED
#define	_LINEEDITDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#include "editDialog.h"
#ifndef lineEditDialog_deleteCommand
#define lineEditDialog_deleteCommand( UxThis, pEnv, n ) \
	((void(*)())UxMethodLookup(UxThis, UxlineEditDialog_deleteCommand_Id,\
			UxlineEditDialog_deleteCommand_Name)) \
		( UxThis, pEnv, n )
#endif

#ifndef lineEditDialog_markItems
#define lineEditDialog_markItems( UxThis, pEnv, item1, item2, flag ) \
	((void(*)())UxMethodLookup(UxThis, UxlineEditDialog_markItems_Id,\
			UxlineEditDialog_markItems_Name)) \
		( UxThis, pEnv, item1, item2, flag )
#endif

#ifndef lineEditDialog_drawItems
#define lineEditDialog_drawItems( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxlineEditDialog_drawItems_Id,\
			UxlineEditDialog_drawItems_Name)) \
		( UxThis, pEnv )
#endif

#ifndef lineEditDialog_renumber
#define lineEditDialog_renumber( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxlineEditDialog_renumber_Id,\
			UxlineEditDialog_renumber_Name)) \
		( UxThis, pEnv )
#endif

#ifndef lineEditDialog_destroyItemPos
#define lineEditDialog_destroyItemPos( UxThis, pEnv, n ) \
	((void(*)())UxMethodLookup(UxThis, UxlineEditDialog_destroyItemPos_Id,\
			UxlineEditDialog_destroyItemPos_Name)) \
		( UxThis, pEnv, n )
#endif

#ifndef lineEditDialog_repaintOverItemMarkers
#define lineEditDialog_repaintOverItemMarkers( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxlineEditDialog_repaintOverItemMarkers_Id,\
			UxlineEditDialog_repaintOverItemMarkers_Name)) \
		( UxThis, pEnv )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxlineEditDialog_deleteCommand_Id;
extern char*	UxlineEditDialog_deleteCommand_Name;
extern int	UxlineEditDialog_markItems_Id;
extern char*	UxlineEditDialog_markItems_Name;
extern int	UxlineEditDialog_drawItems_Id;
extern char*	UxlineEditDialog_drawItems_Name;
extern int	UxlineEditDialog_renumber_Id;
extern char*	UxlineEditDialog_renumber_Name;
extern int	UxlineEditDialog_destroyItemPos_Id;
extern char*	UxlineEditDialog_destroyItemPos_Name;
extern int	UxlineEditDialog_repaintOverItemMarkers_Id;
extern char*	UxlineEditDialog_repaintOverItemMarkers_Name;

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
	_UxCeditDialog UxeditDialogPart;
	Widget	UxlineEditDialog;
	swidget	UxUxParent;
} _UxClineEditDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxClineEditDialog      *UxLineEditDialogContext;
#define UxEditDialogContext     (&(UxLineEditDialogContext->UxeditDialogPart))
#define lineEditDialog          UxLineEditDialogContext->UxlineEditDialog
#ifdef UxParent               
#undef UxParent               
#endif 
#define UxParent                UxLineEditDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_lineEditDialog( swidget _UxUxParent );

#endif	/* _LINEEDITDIALOG_INCLUDED */
