
/*******************************************************************************
	objectDialog.c

       Associated Header file: objectDialog.h
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

extern void DestroyObjectPos (int);
extern void DrawObjects ();
extern void MarkObjects (int, int, int);
extern void RepaintOverObjectMarkers ();


static	int _UxIfClassId;
int	UxobjectDialog_addItem_Id = -1;
char*	UxobjectDialog_addItem_Name = "addItem";
int	UxobjectDialog_getSelPos_Id = -1;
char*	UxobjectDialog_getSelPos_Name = "getSelPos";
int	UxobjectDialog_itemCount_Id = -1;
char*	UxobjectDialog_itemCount_Name = "itemCount";
int	UxobjectDialog_deleteAllItems_Id = -1;
char*	UxobjectDialog_deleteAllItems_Name = "deleteAllItems";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "objectDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_objectDialog_addItem( swidget UxThis, Environment * pEnv, char *string );
static int	_objectDialog_getSelPos( swidget UxThis, Environment * pEnv, int **list, int *number );
static int	_objectDialog_itemCount( swidget UxThis, Environment * pEnv );
static void	_objectDialog_deleteAllItems( swidget UxThis, Environment * pEnv );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_addItem( swidget UxThis, Environment * pEnv, char *string )
{
	XmString item;
	int n;
	
	item = (XmString) XmStringCreateLtoR (string, XmSTRING_DEFAULT_CHARSET);
	XmListAddItem (UxGetWidget (objectList), item, 0);
	XmStringFree (item);
	XtVaGetValues (UxGetWidget (objectList), XmNitemCount, &n, NULL);
	return (n);
}

static int	_objectDialog_addItem( swidget UxThis, Environment * pEnv, char *string )
{
	int			_Uxrtrn;
	_UxCobjectDialog        *UxSaveCtx = UxObjectDialogContext;

	UxObjectDialogContext = (_UxCobjectDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_addItem( UxThis, pEnv, string );
	UxObjectDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_getSelPos( swidget UxThis, Environment * pEnv, int **list, int *number )
{
	if (XmListGetSelectedPos (UxGetWidget (objectList), list, number)) 
	   return (1);
	else
	   return (0);
}

static int	_objectDialog_getSelPos( swidget UxThis, Environment * pEnv, int **list, int *number )
{
	int			_Uxrtrn;
	_UxCobjectDialog        *UxSaveCtx = UxObjectDialogContext;

	UxObjectDialogContext = (_UxCobjectDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getSelPos( UxThis, pEnv, list, number );
	UxObjectDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_itemCount( swidget UxThis, Environment * pEnv )
{
	int n;
	XtVaGetValues (UxGetWidget (objectList), XmNitemCount, &n, NULL);
	return (n);
}

static int	_objectDialog_itemCount( swidget UxThis, Environment * pEnv )
{
	int			_Uxrtrn;
	_UxCobjectDialog        *UxSaveCtx = UxObjectDialogContext;

	UxObjectDialogContext = (_UxCobjectDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_itemCount( UxThis, pEnv );
	UxObjectDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_deleteAllItems( swidget UxThis, Environment * pEnv )
{
	int i, n;
	
	XtVaGetValues (UxGetWidget (objectList), XmNitemCount, &n, NULL);
	
	for (i = 1; i <= n; i++)
	{
	    XmListDeletePos (UxGetWidget (objectList), 1);
	}
}

static void	_objectDialog_deleteAllItems( swidget UxThis, Environment * pEnv )
{
	_UxCobjectDialog        *UxSaveCtx = UxObjectDialogContext;

	UxObjectDialogContext = (_UxCobjectDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_deleteAllItems( UxThis, pEnv );
	UxObjectDialogContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_objectDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobjectDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObjectDialogContext;
	UxObjectDialogContext = UxContext =
			(_UxCobjectDialog *) UxGetContext( UxWidget );
	{
	int *list, number;
	
	RepaintOverObjectMarkers ();
	DrawObjects ();
	
	while (XmListGetSelectedPos (UxGetWidget (objectList), &list, &number))
	{ 
	   XmListDeletePos (UxGetWidget (objectList), list[0]);
	   DestroyObjectPos (list[0]);
	   command ("Delete point %d\n", list[0]);
	   free (list);
	}
	
	DrawObjects ();
	MarkObjects (1, objectDialog_itemCount (UxThisWidget, &UxEnv), -1);
	
	}
	UxObjectDialogContext = UxSaveCtx;
}

static void  okCallback_objectDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobjectDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObjectDialogContext;
	UxObjectDialogContext = UxContext =
			(_UxCobjectDialog *) UxGetContext( UxWidget );
	{
	UxPopdownInterface (UxThisWidget);
	}
	UxObjectDialogContext = UxSaveCtx;
}

static void  helpCB_objectDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobjectDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObjectDialogContext;
	UxObjectDialogContext = UxContext =
			(_UxCobjectDialog *) UxGetContext( UxWidget );
	{
	MarkObjects (1, objectDialog_itemCount (UxWidget, &UxEnv), -1);
	XmListDeselectAllItems (UxGetWidget (objectList));
	UxPopdownInterface (UxThisWidget);
	}
	UxObjectDialogContext = UxSaveCtx;
}

static void  multipleSelectionCB_objectList(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobjectDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObjectDialogContext;
	UxObjectDialogContext = UxContext =
			(_UxCobjectDialog *) UxGetContext( UxWidget );
	{
	int *list, number, i;
	
	XtVaGetValues (UxWidget, XmNitemCount, &number, NULL);
	MarkObjects (1, number, -1);
	
	if (XmListGetSelectedPos (UxWidget, &list, &number))
	{
	    for (i=0; i<number; i++)
	    {
	        MarkObjects (list[i], list[i], 1);
	    }
	    free (list);
	}
	}
	UxObjectDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_objectDialog()
{
	Widget		_UxParent;


	/* Creation of objectDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "objectDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 340,
			XmNy, 230,
			XmNwidth, 400,
			XmNheight, 350,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "objectDialog",
			NULL );

	objectDialog = XtVaCreateWidget( "objectDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 400,
			XmNheight, 350,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNunitType, XmPIXELS,
			RES_CONVERT( XmNcancelLabelString, "Delete" ),
			RES_CONVERT( XmNdialogTitle, "Object Editor" ),
			XmNautoUnmanage, FALSE,
			RES_CONVERT( XmNhelpLabelString, "Cancel" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			RES_CONVERT( XmNmessageString, "         X                     Y                   Type                  Points" ),
			NULL );
	XtAddCallback( objectDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_objectDialog,
		(XtPointer) UxObjectDialogContext );
	XtAddCallback( objectDialog, XmNokCallback,
		(XtCallbackProc) okCallback_objectDialog,
		(XtPointer) UxObjectDialogContext );
	XtAddCallback( objectDialog, XmNhelpCallback,
		(XtCallbackProc) helpCB_objectDialog,
		(XtPointer) UxObjectDialogContext );

	UxPutContext( objectDialog, (char *) UxObjectDialogContext );
	UxPutClassCode( objectDialog, _UxIfClassId );


	/* Creation of scrolledWindowList1 */
	scrolledWindowList1 = XtVaCreateManagedWidget( "scrolledWindowList1",
			xmScrolledWindowWidgetClass,
			objectDialog,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNshadowThickness, 0,
			XmNx, 20,
			XmNy, 10,
			NULL );
	UxPutContext( scrolledWindowList1, (char *) UxObjectDialogContext );


	/* Creation of objectList */
	objectList = XtVaCreateManagedWidget( "objectList",
			xmListWidgetClass,
			scrolledWindowList1,
			XmNwidth, 400,
			XmNheight, 180,
			XmNselectionPolicy, XmMULTIPLE_SELECT,
			XmNautomaticSelection, FALSE,
			NULL );
	XtAddCallback( objectList, XmNmultipleSelectionCallback,
		(XtCallbackProc) multipleSelectionCB_objectList,
		(XtPointer) UxObjectDialogContext );

	UxPutContext( objectList, (char *) UxObjectDialogContext );


	XtAddCallback( objectDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxObjectDialogContext);


	return ( objectDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_objectDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCobjectDialog        *UxContext;
	static int		_Uxinit = 0;

	UxObjectDialogContext = UxContext =
		(_UxCobjectDialog *) UxNewContext( sizeof(_UxCobjectDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxobjectDialog_addItem_Id = UxMethodRegister( _UxIfClassId,
				UxobjectDialog_addItem_Name,
				(void (*)()) _objectDialog_addItem );
		UxobjectDialog_getSelPos_Id = UxMethodRegister( _UxIfClassId,
				UxobjectDialog_getSelPos_Name,
				(void (*)()) _objectDialog_getSelPos );
		UxobjectDialog_itemCount_Id = UxMethodRegister( _UxIfClassId,
				UxobjectDialog_itemCount_Name,
				(void (*)()) _objectDialog_itemCount );
		UxobjectDialog_deleteAllItems_Id = UxMethodRegister( _UxIfClassId,
				UxobjectDialog_deleteAllItems_Name,
				(void (*)()) _objectDialog_deleteAllItems );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_objectDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

