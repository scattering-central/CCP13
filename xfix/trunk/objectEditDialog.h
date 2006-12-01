
/*******************************************************************************
       objectEditDialog.h
       This header file is included by objectEditDialog.c

*******************************************************************************/

#ifndef	_OBJECTEDITDIALOG_INCLUDED
#define	_OBJECTEDITDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#include "editDialog.h"
#ifndef objectEditDialog_deleteCommand
#define objectEditDialog_deleteCommand( UxThis, pEnv, n ) \
	((void(*)())UxMethodLookup(UxThis, UxobjectEditDialog_deleteCommand_Id,\
			UxobjectEditDialog_deleteCommand_Name)) \
		( UxThis, pEnv, n )
#endif

#ifndef objectEditDialog_markItems
#define objectEditDialog_markItems( UxThis, pEnv, item1, item2, flag ) \
	((void(*)())UxMethodLookup(UxThis, UxobjectEditDialog_markItems_Id,\
			UxobjectEditDialog_markItems_Name)) \
		( UxThis, pEnv, item1, item2, flag )
#endif

#ifndef objectEditDialog_drawItems
#define objectEditDialog_drawItems( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxobjectEditDialog_drawItems_Id,\
			UxobjectEditDialog_drawItems_Name)) \
		( UxThis, pEnv )
#endif

#ifndef objectEditDialog_renumber
#define objectEditDialog_renumber( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxobjectEditDialog_renumber_Id,\
			UxobjectEditDialog_renumber_Name)) \
		( UxThis, pEnv )
#endif

#ifndef objectEditDialog_destroyItemPos
#define objectEditDialog_destroyItemPos( UxThis, pEnv, n ) \
	((void(*)())UxMethodLookup(UxThis, UxobjectEditDialog_destroyItemPos_Id,\
			UxobjectEditDialog_destroyItemPos_Name)) \
		( UxThis, pEnv, n )
#endif

#ifndef objectEditDialog_repaintOverItemMarkers
#define objectEditDialog_repaintOverItemMarkers( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxobjectEditDialog_repaintOverItemMarkers_Id,\
			UxobjectEditDialog_repaintOverItemMarkers_Name)) \
		( UxThis, pEnv )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxobjectEditDialog_deleteCommand_Id;
extern char*	UxobjectEditDialog_deleteCommand_Name;
extern int	UxobjectEditDialog_markItems_Id;
extern char*	UxobjectEditDialog_markItems_Name;
extern int	UxobjectEditDialog_drawItems_Id;
extern char*	UxobjectEditDialog_drawItems_Name;
extern int	UxobjectEditDialog_renumber_Id;
extern char*	UxobjectEditDialog_renumber_Name;
extern int	UxobjectEditDialog_destroyItemPos_Id;
extern char*	UxobjectEditDialog_destroyItemPos_Name;
extern int	UxobjectEditDialog_repaintOverItemMarkers_Id;
extern char*	UxobjectEditDialog_repaintOverItemMarkers_Name;

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
	Widget	UxobjectEditDialog;
	swidget	UxUxParent;
} _UxCobjectEditDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCobjectEditDialog    *UxObjectEditDialogContext;
#define UxEditDialogContext     (&(UxObjectEditDialogContext->UxeditDialogPart))
#define objectEditDialog        UxObjectEditDialogContext->UxobjectEditDialog
#ifdef UxParent               
#undef UxParent               
#endif 
#define UxParent                UxObjectEditDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_objectEditDialog( swidget _UxUxParent );

#endif	/* _OBJECTEDITDIALOG_INCLUDED */
