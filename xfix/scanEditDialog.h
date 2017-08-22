
/*******************************************************************************
       scanEditDialog.h
       This header file is included by scanEditDialog.c

*******************************************************************************/

#ifndef	_SCANEDITDIALOG_INCLUDED
#define	_SCANEDITDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#include "editDialog.h"
#ifndef scanEditDialog_deleteCommand
#define scanEditDialog_deleteCommand( UxThis, pEnv, n ) \
	((void(*)())UxMethodLookup(UxThis, UxscanEditDialog_deleteCommand_Id,\
			UxscanEditDialog_deleteCommand_Name)) \
		( UxThis, pEnv, n )
#endif

#ifndef scanEditDialog_markItems
#define scanEditDialog_markItems( UxThis, pEnv, item1, item2, flag ) \
	((void(*)())UxMethodLookup(UxThis, UxscanEditDialog_markItems_Id,\
			UxscanEditDialog_markItems_Name)) \
		( UxThis, pEnv, item1, item2, flag )
#endif

#ifndef scanEditDialog_drawItems
#define scanEditDialog_drawItems( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxscanEditDialog_drawItems_Id,\
			UxscanEditDialog_drawItems_Name)) \
		( UxThis, pEnv )
#endif

#ifndef scanEditDialog_renumber
#define scanEditDialog_renumber( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxscanEditDialog_renumber_Id,\
			UxscanEditDialog_renumber_Name)) \
		( UxThis, pEnv )
#endif

#ifndef scanEditDialog_destroyItemPos
#define scanEditDialog_destroyItemPos( UxThis, pEnv, n ) \
	((void(*)())UxMethodLookup(UxThis, UxscanEditDialog_destroyItemPos_Id,\
			UxscanEditDialog_destroyItemPos_Name)) \
		( UxThis, pEnv, n )
#endif

#ifndef scanEditDialog_repaintOverItemMarkers
#define scanEditDialog_repaintOverItemMarkers( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxscanEditDialog_repaintOverItemMarkers_Id,\
			UxscanEditDialog_repaintOverItemMarkers_Name)) \
		( UxThis, pEnv )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxscanEditDialog_deleteCommand_Id;
extern char*	UxscanEditDialog_deleteCommand_Name;
extern int	UxscanEditDialog_markItems_Id;
extern char*	UxscanEditDialog_markItems_Name;
extern int	UxscanEditDialog_drawItems_Id;
extern char*	UxscanEditDialog_drawItems_Name;
extern int	UxscanEditDialog_renumber_Id;
extern char*	UxscanEditDialog_renumber_Name;
extern int	UxscanEditDialog_destroyItemPos_Id;
extern char*	UxscanEditDialog_destroyItemPos_Name;
extern int	UxscanEditDialog_repaintOverItemMarkers_Id;
extern char*	UxscanEditDialog_repaintOverItemMarkers_Name;

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
	Widget	UxscanEditDialog;
	swidget	UxUxParent;
} _UxCscanEditDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCscanEditDialog      *UxScanEditDialogContext;
#define UxEditDialogContext     (&(UxScanEditDialogContext->UxeditDialogPart))
#define scanEditDialog          UxScanEditDialogContext->UxscanEditDialog
#ifdef UxParent               
#undef UxParent               
#endif 
#define UxParent                UxScanEditDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_scanEditDialog( swidget _UxUxParent );

#endif	/* _SCANEDITDIALOG_INCLUDED */
