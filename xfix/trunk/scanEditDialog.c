
/*******************************************************************************
	scanEditDialog.c

       Associated Header file: scanEditDialog.h
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

extern void DestroyScanPos ();
extern void DrawScans ();
extern void MarkScans (int, int, int);
extern void RepaintOverScanMarkers ();
extern void renumberScans ();


static	int _UxIfClassId;
int	UxscanEditDialog_deleteCommand_Id = -1;
char*	UxscanEditDialog_deleteCommand_Name = "deleteCommand";
int	UxscanEditDialog_markItems_Id = -1;
char*	UxscanEditDialog_markItems_Name = "markItems";
int	UxscanEditDialog_drawItems_Id = -1;
char*	UxscanEditDialog_drawItems_Name = "drawItems";
int	UxscanEditDialog_renumber_Id = -1;
char*	UxscanEditDialog_renumber_Name = "renumber";
int	UxscanEditDialog_destroyItemPos_Id = -1;
char*	UxscanEditDialog_destroyItemPos_Name = "destroyItemPos";
int	UxscanEditDialog_repaintOverItemMarkers_Id = -1;
char*	UxscanEditDialog_repaintOverItemMarkers_Name = "repaintOverItemMarkers";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "scanEditDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_scanEditDialog_deleteCommand( swidget UxThis, Environment * pEnv, int n );
static void	_scanEditDialog_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag );
static void	_scanEditDialog_drawItems( swidget UxThis, Environment * pEnv );
static void	_scanEditDialog_renumber( swidget UxThis, Environment * pEnv );
static void	_scanEditDialog_destroyItemPos( swidget UxThis, Environment * pEnv, int n );
static void	_scanEditDialog_repaintOverItemMarkers( swidget UxThis, Environment * pEnv );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_deleteCommand( swidget UxThis, Environment * pEnv, int n )
{
	command ("Delete scan %d\n", n);
}

static void	_scanEditDialog_deleteCommand( swidget UxThis, Environment * pEnv, int n )
{
	_UxCscanEditDialog      *UxSaveCtx = UxScanEditDialogContext;

	UxScanEditDialogContext = (_UxCscanEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_deleteCommand( UxThis, pEnv, n );
	UxScanEditDialogContext = UxSaveCtx;
}

static void	Ux_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag )
{
	MarkScans (item1, item2, flag);
}

static void	_scanEditDialog_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag )
{
	_UxCscanEditDialog      *UxSaveCtx = UxScanEditDialogContext;

	UxScanEditDialogContext = (_UxCscanEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_markItems( UxThis, pEnv, item1, item2, flag );
	UxScanEditDialogContext = UxSaveCtx;
}

static void	Ux_drawItems( swidget UxThis, Environment * pEnv )
{
	DrawScans ();
}

static void	_scanEditDialog_drawItems( swidget UxThis, Environment * pEnv )
{
	_UxCscanEditDialog      *UxSaveCtx = UxScanEditDialogContext;

	UxScanEditDialogContext = (_UxCscanEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_drawItems( UxThis, pEnv );
	UxScanEditDialogContext = UxSaveCtx;
}

static void	Ux_renumber( swidget UxThis, Environment * pEnv )
{
	renumberScans ();
}

static void	_scanEditDialog_renumber( swidget UxThis, Environment * pEnv )
{
	_UxCscanEditDialog      *UxSaveCtx = UxScanEditDialogContext;

	UxScanEditDialogContext = (_UxCscanEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_renumber( UxThis, pEnv );
	UxScanEditDialogContext = UxSaveCtx;
}

static void	Ux_destroyItemPos( swidget UxThis, Environment * pEnv, int n )
{
	DestroyScanPos (n);
}

static void	_scanEditDialog_destroyItemPos( swidget UxThis, Environment * pEnv, int n )
{
	_UxCscanEditDialog      *UxSaveCtx = UxScanEditDialogContext;

	UxScanEditDialogContext = (_UxCscanEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_destroyItemPos( UxThis, pEnv, n );
	UxScanEditDialogContext = UxSaveCtx;
}

static void	Ux_repaintOverItemMarkers( swidget UxThis, Environment * pEnv )
{
	RepaintOverScanMarkers ();
}

static void	_scanEditDialog_repaintOverItemMarkers( swidget UxThis, Environment * pEnv )
{
	_UxCscanEditDialog      *UxSaveCtx = UxScanEditDialogContext;

	UxScanEditDialogContext = (_UxCscanEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_repaintOverItemMarkers( UxThis, pEnv );
	UxScanEditDialogContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_scanEditDialog()
{
	Widget		_UxParent;


	/* Creation of scanEditDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(scanEditDialog,x,int,281);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(scanEditDialog,y,int,308);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(scanEditDialog,width,int,600);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(scanEditDialog,height,int,332);
#endif /* UX_USE_VALUES*/



	return ( scanEditDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_scanEditDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCscanEditDialog      *UxContext;
	static int		_Uxinit = 0;

	UxScanEditDialogContext = UxContext =
		(_UxCscanEditDialog *) UxNewContext( sizeof(_UxCscanEditDialog), True );

	UxParent = _UxUxParent;
	scanEditDialog = create_editDialog( UxParent);
	UxPutContext(scanEditDialog, UxScanEditDialogContext);

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewSubclassId(UxGetClassCode (scanEditDialog));
		UxscanEditDialog_deleteCommand_Id = UxMethodRegister( _UxIfClassId,
				UxscanEditDialog_deleteCommand_Name,
				(void (*)()) _scanEditDialog_deleteCommand );
		UxscanEditDialog_markItems_Id = UxMethodRegister( _UxIfClassId,
				UxscanEditDialog_markItems_Name,
				(void (*)()) _scanEditDialog_markItems );
		UxscanEditDialog_drawItems_Id = UxMethodRegister( _UxIfClassId,
				UxscanEditDialog_drawItems_Name,
				(void (*)()) _scanEditDialog_drawItems );
		UxscanEditDialog_renumber_Id = UxMethodRegister( _UxIfClassId,
				UxscanEditDialog_renumber_Name,
				(void (*)()) _scanEditDialog_renumber );
		UxscanEditDialog_destroyItemPos_Id = UxMethodRegister( _UxIfClassId,
				UxscanEditDialog_destroyItemPos_Name,
				(void (*)()) _scanEditDialog_destroyItemPos );
		UxscanEditDialog_repaintOverItemMarkers_Id = UxMethodRegister( _UxIfClassId,
				UxscanEditDialog_repaintOverItemMarkers_Name,
				(void (*)()) _scanEditDialog_repaintOverItemMarkers );
		_Uxinit = 1;
	}

	UxPutClassCode( scanEditDialog, _UxIfClassId );
	rtrn = _Uxbuild_scanEditDialog();

	editDialog_setup (rtrn, &UxEnv, 630, "Scan Editor",
	"  No.     X centre   Y centre   Radius     Width    Phi start   Phi end");
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

