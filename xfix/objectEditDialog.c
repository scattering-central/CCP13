
/*******************************************************************************
	objectEditDialog.c

       Associated Header file: objectEditDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>

#include "mprintf.h"

extern void DestroyObjectPos (int);
extern void DrawObjects ();
extern void MarkObjects (int, int, int);
extern void RepaintOverObjectMarkers ();
extern void renumberObjects ();


static	int _UxIfClassId;
int	UxobjectEditDialog_deleteCommand_Id = -1;
char*	UxobjectEditDialog_deleteCommand_Name = "deleteCommand";
int	UxobjectEditDialog_markItems_Id = -1;
char*	UxobjectEditDialog_markItems_Name = "markItems";
int	UxobjectEditDialog_drawItems_Id = -1;
char*	UxobjectEditDialog_drawItems_Name = "drawItems";
int	UxobjectEditDialog_renumber_Id = -1;
char*	UxobjectEditDialog_renumber_Name = "renumber";
int	UxobjectEditDialog_destroyItemPos_Id = -1;
char*	UxobjectEditDialog_destroyItemPos_Name = "destroyItemPos";
int	UxobjectEditDialog_repaintOverItemMarkers_Id = -1;
char*	UxobjectEditDialog_repaintOverItemMarkers_Name = "repaintOverItemMarkers";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "objectEditDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_objectEditDialog_deleteCommand( swidget UxThis, Environment * pEnv, int n );
static void	_objectEditDialog_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag );
static void	_objectEditDialog_drawItems( swidget UxThis, Environment * pEnv );
static void	_objectEditDialog_renumber( swidget UxThis, Environment * pEnv );
static void	_objectEditDialog_destroyItemPos( swidget UxThis, Environment * pEnv, int n );
static void	_objectEditDialog_repaintOverItemMarkers( swidget UxThis, Environment * pEnv );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_deleteCommand( swidget UxThis, Environment * pEnv, int n )
{
	command ("Delete point %d\n", n);
}

static void	_objectEditDialog_deleteCommand( swidget UxThis, Environment * pEnv, int n )
{
	_UxCobjectEditDialog    *UxSaveCtx = UxObjectEditDialogContext;

	UxObjectEditDialogContext = (_UxCobjectEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_deleteCommand( UxThis, pEnv, n );
	UxObjectEditDialogContext = UxSaveCtx;
}

static void	Ux_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag )
{
	MarkObjects (item1, item2, flag);
}

static void	_objectEditDialog_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag )
{
	_UxCobjectEditDialog    *UxSaveCtx = UxObjectEditDialogContext;

	UxObjectEditDialogContext = (_UxCobjectEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_markItems( UxThis, pEnv, item1, item2, flag );
	UxObjectEditDialogContext = UxSaveCtx;
}

static void	Ux_drawItems( swidget UxThis, Environment * pEnv )
{
	DrawObjects ();
}

static void	_objectEditDialog_drawItems( swidget UxThis, Environment * pEnv )
{
	_UxCobjectEditDialog    *UxSaveCtx = UxObjectEditDialogContext;

	UxObjectEditDialogContext = (_UxCobjectEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_drawItems( UxThis, pEnv );
	UxObjectEditDialogContext = UxSaveCtx;
}

static void	Ux_renumber( swidget UxThis, Environment * pEnv )
{
	renumberObjects ();
}

static void	_objectEditDialog_renumber( swidget UxThis, Environment * pEnv )
{
	_UxCobjectEditDialog    *UxSaveCtx = UxObjectEditDialogContext;

	UxObjectEditDialogContext = (_UxCobjectEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_renumber( UxThis, pEnv );
	UxObjectEditDialogContext = UxSaveCtx;
}

static void	Ux_destroyItemPos( swidget UxThis, Environment * pEnv, int n )
{
	DestroyObjectPos (n);
}

static void	_objectEditDialog_destroyItemPos( swidget UxThis, Environment * pEnv, int n )
{
	_UxCobjectEditDialog    *UxSaveCtx = UxObjectEditDialogContext;

	UxObjectEditDialogContext = (_UxCobjectEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_destroyItemPos( UxThis, pEnv, n );
	UxObjectEditDialogContext = UxSaveCtx;
}

static void	Ux_repaintOverItemMarkers( swidget UxThis, Environment * pEnv )
{
	RepaintOverObjectMarkers ();
}

static void	_objectEditDialog_repaintOverItemMarkers( swidget UxThis, Environment * pEnv )
{
	_UxCobjectEditDialog    *UxSaveCtx = UxObjectEditDialogContext;

	UxObjectEditDialogContext = (_UxCobjectEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_repaintOverItemMarkers( UxThis, pEnv );
	UxObjectEditDialogContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_objectEditDialog()
{
	Widget		_UxParent;


	/* Creation of objectEditDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(objectEditDialog,x,int,281);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(objectEditDialog,y,int,308);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(objectEditDialog,width,int,600);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(objectEditDialog,height,int,332);
#endif /* UX_USE_VALUES*/



	return ( objectEditDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_objectEditDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCobjectEditDialog    *UxContext;
	static int		_Uxinit = 0;

	UxObjectEditDialogContext = UxContext =
		(_UxCobjectEditDialog *) UxNewContext( sizeof(_UxCobjectEditDialog), True );

	UxParent = _UxUxParent;
	objectEditDialog = create_editDialog( UxParent);
	UxPutContext(objectEditDialog, UxObjectEditDialogContext);

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewSubclassId(UxGetClassCode (objectEditDialog));
		UxobjectEditDialog_deleteCommand_Id = UxMethodRegister( _UxIfClassId,
				UxobjectEditDialog_deleteCommand_Name,
				(void (*)()) _objectEditDialog_deleteCommand );
		UxobjectEditDialog_markItems_Id = UxMethodRegister( _UxIfClassId,
				UxobjectEditDialog_markItems_Name,
				(void (*)()) _objectEditDialog_markItems );
		UxobjectEditDialog_drawItems_Id = UxMethodRegister( _UxIfClassId,
				UxobjectEditDialog_drawItems_Name,
				(void (*)()) _objectEditDialog_drawItems );
		UxobjectEditDialog_renumber_Id = UxMethodRegister( _UxIfClassId,
				UxobjectEditDialog_renumber_Name,
				(void (*)()) _objectEditDialog_renumber );
		UxobjectEditDialog_destroyItemPos_Id = UxMethodRegister( _UxIfClassId,
				UxobjectEditDialog_destroyItemPos_Name,
				(void (*)()) _objectEditDialog_destroyItemPos );
		UxobjectEditDialog_repaintOverItemMarkers_Id = UxMethodRegister( _UxIfClassId,
				UxobjectEditDialog_repaintOverItemMarkers_Name,
				(void (*)()) _objectEditDialog_repaintOverItemMarkers );
		_Uxinit = 1;
	}

	UxPutClassCode( objectEditDialog, _UxIfClassId );
	rtrn = _Uxbuild_objectEditDialog();

	editDialog_setup (rtrn, &UxEnv, 500, "Object Editor",
	"  No.        X          Y          Type        Vertices");
	
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

