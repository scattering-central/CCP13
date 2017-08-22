
/*******************************************************************************
	lineDialog.c

       Associated Header file: lineDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/List.h>
#include <Xm/ScrolledW.h>
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>

#include "mprintf.h"

extern void DestroyLinePos ();
extern void DrawLines ();
extern void MarkLines (int, int, int);
extern void RepaintOverLineMarkers ();


static	int _UxIfClassId;
int	UxlineDialog_addItem_Id = -1;
char*	UxlineDialog_addItem_Name = "addItem";
int	UxlineDialog_getSelPos_Id = -1;
char*	UxlineDialog_getSelPos_Name = "getSelPos";
int	UxlineDialog_itemCount_Id = -1;
char*	UxlineDialog_itemCount_Name = "itemCount";
int	UxlineDialog_deleteAllItems_Id = -1;
char*	UxlineDialog_deleteAllItems_Name = "deleteAllItems";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "lineDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_lineDialog_addItem( swidget UxThis, Environment * pEnv, char *string );
static int	_lineDialog_getSelPos( swidget UxThis, Environment * pEnv, int **list, int *number );
static int	_lineDialog_itemCount( swidget UxThis, Environment * pEnv );
static void	_lineDialog_deleteAllItems( swidget UxThis, Environment * pEnv );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_addItem( swidget UxThis, Environment * pEnv, char *string )
{
	XmString item;
	int n;
	
	item = (XmString) XmStringCreateLtoR (string, XmSTRING_DEFAULT_CHARSET);
	XmListAddItem (UxGetWidget (lineList), item, 0);
	XmStringFree (item);
	XtVaGetValues (UxGetWidget (lineList), XmNitemCount, &n, NULL);
	return (n);
}

static int	_lineDialog_addItem( swidget UxThis, Environment * pEnv, char *string )
{
	int			_Uxrtrn;
	_UxClineDialog          *UxSaveCtx = UxLineDialogContext;

	UxLineDialogContext = (_UxClineDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_addItem( UxThis, pEnv, string );
	UxLineDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_getSelPos( swidget UxThis, Environment * pEnv, int **list, int *number )
{
	if (XmListGetSelectedPos (UxGetWidget (lineList), list, number)) 
	   return (1);
	else
	   return (0);
}

static int	_lineDialog_getSelPos( swidget UxThis, Environment * pEnv, int **list, int *number )
{
	int			_Uxrtrn;
	_UxClineDialog          *UxSaveCtx = UxLineDialogContext;

	UxLineDialogContext = (_UxClineDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getSelPos( UxThis, pEnv, list, number );
	UxLineDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_itemCount( swidget UxThis, Environment * pEnv )
{
	int n;
	XtVaGetValues (UxGetWidget (lineList), XmNitemCount, &n, NULL);
	return (n);
}

static int	_lineDialog_itemCount( swidget UxThis, Environment * pEnv )
{
	int			_Uxrtrn;
	_UxClineDialog          *UxSaveCtx = UxLineDialogContext;

	UxLineDialogContext = (_UxClineDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_itemCount( UxThis, pEnv );
	UxLineDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_deleteAllItems( swidget UxThis, Environment * pEnv )
{
	int i, n;
	
	XtVaGetValues (UxGetWidget (lineList), XmNitemCount, &n, NULL);
	
	for (i = 1; i <= n; i++)
	{
	    XmListDeletePos (UxGetWidget (lineList), 1);
	}
}

static void	_lineDialog_deleteAllItems( swidget UxThis, Environment * pEnv )
{
	_UxClineDialog          *UxSaveCtx = UxLineDialogContext;

	UxLineDialogContext = (_UxClineDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_deleteAllItems( UxThis, pEnv );
	UxLineDialogContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_lineDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxClineDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxLineDialogContext;
	UxLineDialogContext = UxContext =
			(_UxClineDialog *) UxGetContext( UxWidget );
	{
	int *list, number;
	
	RepaintOverLineMarkers ();
	DrawLines ();
	
	while (XmListGetSelectedPos (UxGetWidget (lineList), &list, &number))
	{ 
	   XmListDeletePos (UxGetWidget (lineList), list[0]);
	   DestroyLinePos (list[0]);
	   command ("Delete line %d\n", list[0]);
	   free (list);
	}
	
	DrawLines ();
	MarkLines (1, lineDialog_itemCount (UxThisWidget, &UxEnv), -1);
	
	}
	UxLineDialogContext = UxSaveCtx;
}

static void  helpCB_lineDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxClineDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxLineDialogContext;
	UxLineDialogContext = UxContext =
			(_UxClineDialog *) UxGetContext( UxWidget );
	{
	MarkLines (1, lineDialog_itemCount (UxWidget, &UxEnv), -1);
	XmListDeselectAllItems (UxGetWidget (lineList));
	UxPopdownInterface (UxThisWidget);
	}
	UxLineDialogContext = UxSaveCtx;
}

static void  okCallback_lineDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxClineDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxLineDialogContext;
	UxLineDialogContext = UxContext =
			(_UxClineDialog *) UxGetContext( UxWidget );
	{
	UxPopdownInterface (UxThisWidget);
	}
	UxLineDialogContext = UxSaveCtx;
}

static void  multipleSelectionCB_lineList(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxClineDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxLineDialogContext;
	UxLineDialogContext = UxContext =
			(_UxClineDialog *) UxGetContext( UxWidget );
	{
	int *list, number, i;
	
	XtVaGetValues (UxWidget, XmNitemCount, &number, NULL);
	MarkLines (1, number, -1);
	
	if (XmListGetSelectedPos (UxWidget, &list, &number))
	{
	    for (i=0; i<number; i++)
	    {
	        MarkLines (list[i], list[i], 1);
	    }
	    free (list);
	}
	}
	UxLineDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_lineDialog()
{
	Widget		_UxParent;


	/* Creation of lineDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "lineDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 400,
			XmNy, 20,
			XmNwidth, 450,
			XmNheight, 320,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "lineDialog",
			NULL );

	lineDialog = XtVaCreateWidget( "lineDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 450,
			XmNheight, 320,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNunitType, XmPIXELS,
			XmNautoUnmanage, FALSE,
			RES_CONVERT( XmNcancelLabelString, "Delete" ),
			RES_CONVERT( XmNdialogTitle, "Line Editor" ),
			RES_CONVERT( XmNhelpLabelString, "Cancel" ),
			RES_CONVERT( XmNmessageString, "     X start        Y start           X end          Y end            Width" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			NULL );
	XtAddCallback( lineDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_lineDialog,
		(XtPointer) UxLineDialogContext );
	XtAddCallback( lineDialog, XmNhelpCallback,
		(XtCallbackProc) helpCB_lineDialog,
		(XtPointer) UxLineDialogContext );
	XtAddCallback( lineDialog, XmNokCallback,
		(XtCallbackProc) okCallback_lineDialog,
		(XtPointer) UxLineDialogContext );

	UxPutContext( lineDialog, (char *) UxLineDialogContext );
	UxPutClassCode( lineDialog, _UxIfClassId );


	/* Creation of scrolledWindowList2 */
	scrolledWindowList2 = XtVaCreateManagedWidget( "scrolledWindowList2",
			xmScrolledWindowWidgetClass,
			lineDialog,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNshadowThickness, 0,
			XmNx, 0,
			XmNy, 0,
			NULL );
	UxPutContext( scrolledWindowList2, (char *) UxLineDialogContext );


	/* Creation of lineList */
	lineList = XtVaCreateManagedWidget( "lineList",
			xmListWidgetClass,
			scrolledWindowList2,
			XmNwidth, 380,
			XmNheight, 160,
			XmNselectionPolicy, XmMULTIPLE_SELECT,
			NULL );
	XtAddCallback( lineList, XmNmultipleSelectionCallback,
		(XtCallbackProc) multipleSelectionCB_lineList,
		(XtPointer) UxLineDialogContext );

	UxPutContext( lineList, (char *) UxLineDialogContext );


	XtAddCallback( lineDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxLineDialogContext);


	return ( lineDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_lineDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxClineDialog          *UxContext;
	static int		_Uxinit = 0;

	UxLineDialogContext = UxContext =
		(_UxClineDialog *) UxNewContext( sizeof(_UxClineDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxlineDialog_addItem_Id = UxMethodRegister( _UxIfClassId,
				UxlineDialog_addItem_Name,
				(void (*)()) _lineDialog_addItem );
		UxlineDialog_getSelPos_Id = UxMethodRegister( _UxIfClassId,
				UxlineDialog_getSelPos_Name,
				(void (*)()) _lineDialog_getSelPos );
		UxlineDialog_itemCount_Id = UxMethodRegister( _UxIfClassId,
				UxlineDialog_itemCount_Name,
				(void (*)()) _lineDialog_itemCount );
		UxlineDialog_deleteAllItems_Id = UxMethodRegister( _UxIfClassId,
				UxlineDialog_deleteAllItems_Name,
				(void (*)()) _lineDialog_deleteAllItems );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_lineDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

