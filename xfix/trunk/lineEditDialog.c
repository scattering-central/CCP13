
/*******************************************************************************
	lineEditDialog.c

       Associated Header file: lineEditDialog.h
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

extern void DestroyLinePos ();
extern void DrawLines ();
extern void MarkLines (int, int, int);
extern void RepaintOverLineMarkers ();
extern void renumberLines ();


static	int _UxIfClassId;
int	UxlineEditDialog_deleteCommand_Id = -1;
char*	UxlineEditDialog_deleteCommand_Name = "deleteCommand";
int	UxlineEditDialog_markItems_Id = -1;
char*	UxlineEditDialog_markItems_Name = "markItems";
int	UxlineEditDialog_drawItems_Id = -1;
char*	UxlineEditDialog_drawItems_Name = "drawItems";
int	UxlineEditDialog_renumber_Id = -1;
char*	UxlineEditDialog_renumber_Name = "renumber";
int	UxlineEditDialog_destroyItemPos_Id = -1;
char*	UxlineEditDialog_destroyItemPos_Name = "destroyItemPos";
int	UxlineEditDialog_repaintOverItemMarkers_Id = -1;
char*	UxlineEditDialog_repaintOverItemMarkers_Name = "repaintOverItemMarkers";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "lineEditDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_lineEditDialog_deleteCommand( swidget UxThis, Environment * pEnv, int n );
static void	_lineEditDialog_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag );
static void	_lineEditDialog_drawItems( swidget UxThis, Environment * pEnv );
static void	_lineEditDialog_renumber( swidget UxThis, Environment * pEnv );
static void	_lineEditDialog_destroyItemPos( swidget UxThis, Environment * pEnv, int n );
static void	_lineEditDialog_repaintOverItemMarkers( swidget UxThis, Environment * pEnv );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_deleteCommand( swidget UxThis, Environment * pEnv, int n )
{
	command ("Delete line %d\n", n);
}

static void	_lineEditDialog_deleteCommand( swidget UxThis, Environment * pEnv, int n )
{
	_UxClineEditDialog      *UxSaveCtx = UxLineEditDialogContext;

	UxLineEditDialogContext = (_UxClineEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_deleteCommand( UxThis, pEnv, n );
	UxLineEditDialogContext = UxSaveCtx;
}

static void	Ux_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag )
{
	MarkLines (item1, item2, flag);
}

static void	_lineEditDialog_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag )
{
	_UxClineEditDialog      *UxSaveCtx = UxLineEditDialogContext;

	UxLineEditDialogContext = (_UxClineEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_markItems( UxThis, pEnv, item1, item2, flag );
	UxLineEditDialogContext = UxSaveCtx;
}

static void	Ux_drawItems( swidget UxThis, Environment * pEnv )
{
	DrawLines ();
}

static void	_lineEditDialog_drawItems( swidget UxThis, Environment * pEnv )
{
	_UxClineEditDialog      *UxSaveCtx = UxLineEditDialogContext;

	UxLineEditDialogContext = (_UxClineEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_drawItems( UxThis, pEnv );
	UxLineEditDialogContext = UxSaveCtx;
}

static void	Ux_renumber( swidget UxThis, Environment * pEnv )
{
	renumberLines ();
}

static void	_lineEditDialog_renumber( swidget UxThis, Environment * pEnv )
{
	_UxClineEditDialog      *UxSaveCtx = UxLineEditDialogContext;

	UxLineEditDialogContext = (_UxClineEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_renumber( UxThis, pEnv );
	UxLineEditDialogContext = UxSaveCtx;
}

static void	Ux_destroyItemPos( swidget UxThis, Environment * pEnv, int n )
{
	DestroyLinePos (n);
}

static void	_lineEditDialog_destroyItemPos( swidget UxThis, Environment * pEnv, int n )
{
	_UxClineEditDialog      *UxSaveCtx = UxLineEditDialogContext;

	UxLineEditDialogContext = (_UxClineEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_destroyItemPos( UxThis, pEnv, n );
	UxLineEditDialogContext = UxSaveCtx;
}

static void	Ux_repaintOverItemMarkers( swidget UxThis, Environment * pEnv )
{
	RepaintOverLineMarkers ();
}

static void	_lineEditDialog_repaintOverItemMarkers( swidget UxThis, Environment * pEnv )
{
	_UxClineEditDialog      *UxSaveCtx = UxLineEditDialogContext;

	UxLineEditDialogContext = (_UxClineEditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_repaintOverItemMarkers( UxThis, pEnv );
	UxLineEditDialogContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_lineEditDialog()
{
	Widget		_UxParent;


	/* Creation of lineEditDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(lineEditDialog,x,int,281);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(lineEditDialog,y,int,308);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(lineEditDialog,width,int,600);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(lineEditDialog,height,int,332);
#endif /* UX_USE_VALUES*/



	return ( lineEditDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_lineEditDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxClineEditDialog      *UxContext;
	static int		_Uxinit = 0;

	UxLineEditDialogContext = UxContext =
		(_UxClineEditDialog *) UxNewContext( sizeof(_UxClineEditDialog), True );

	UxParent = _UxUxParent;
	lineEditDialog = create_editDialog( UxParent);
	UxPutContext(lineEditDialog, UxLineEditDialogContext);

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewSubclassId(UxGetClassCode (lineEditDialog));
		UxlineEditDialog_deleteCommand_Id = UxMethodRegister( _UxIfClassId,
				UxlineEditDialog_deleteCommand_Name,
				(void (*)()) _lineEditDialog_deleteCommand );
		UxlineEditDialog_markItems_Id = UxMethodRegister( _UxIfClassId,
				UxlineEditDialog_markItems_Name,
				(void (*)()) _lineEditDialog_markItems );
		UxlineEditDialog_drawItems_Id = UxMethodRegister( _UxIfClassId,
				UxlineEditDialog_drawItems_Name,
				(void (*)()) _lineEditDialog_drawItems );
		UxlineEditDialog_renumber_Id = UxMethodRegister( _UxIfClassId,
				UxlineEditDialog_renumber_Name,
				(void (*)()) _lineEditDialog_renumber );
		UxlineEditDialog_destroyItemPos_Id = UxMethodRegister( _UxIfClassId,
				UxlineEditDialog_destroyItemPos_Name,
				(void (*)()) _lineEditDialog_destroyItemPos );
		UxlineEditDialog_repaintOverItemMarkers_Id = UxMethodRegister( _UxIfClassId,
				UxlineEditDialog_repaintOverItemMarkers_Name,
				(void (*)()) _lineEditDialog_repaintOverItemMarkers );
		_Uxinit = 1;
	}

	UxPutClassCode( lineEditDialog, _UxIfClassId );
	rtrn = _Uxbuild_lineEditDialog();

	editDialog_setup (rtrn, &UxEnv, 550, "Line Editor",
	"  No.    X start    Y start     X end      Y end       Width");
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

