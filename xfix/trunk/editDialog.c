
/*******************************************************************************
	editDialog.c

       Associated Header file: editDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/PushB.h>
#include <Xm/Label.h>
#include <Xm/List.h>
#include <Xm/ScrolledW.h>
#include <Xm/Form.h>
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>

#include "mprintf.h"


static	int _UxIfClassId;
int	UxeditDialog_repaintOverItemMarkers_Id = -1;
char*	UxeditDialog_repaintOverItemMarkers_Name = "repaintOverItemMarkers";
int	UxeditDialog_addItem_Id = -1;
char*	UxeditDialog_addItem_Name = "addItem";
int	UxeditDialog_getSelPos_Id = -1;
char*	UxeditDialog_getSelPos_Name = "getSelPos";
int	UxeditDialog_deleteCommand_Id = -1;
char*	UxeditDialog_deleteCommand_Name = "deleteCommand";
int	UxeditDialog_markItems_Id = -1;
char*	UxeditDialog_markItems_Name = "markItems";
int	UxeditDialog_drawItems_Id = -1;
char*	UxeditDialog_drawItems_Name = "drawItems";
int	UxeditDialog_itemCount_Id = -1;
char*	UxeditDialog_itemCount_Name = "itemCount";
int	UxeditDialog_modifyItemPos_Id = -1;
char*	UxeditDialog_modifyItemPos_Name = "modifyItemPos";
int	UxeditDialog_setup_Id = -1;
char*	UxeditDialog_setup_Name = "setup";
int	UxeditDialog_deleteAllItems_Id = -1;
char*	UxeditDialog_deleteAllItems_Name = "deleteAllItems";
int	UxeditDialog_renumber_Id = -1;
char*	UxeditDialog_renumber_Name = "renumber";
int	UxeditDialog_destroyItemPos_Id = -1;
char*	UxeditDialog_destroyItemPos_Name = "destroyItemPos";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "editDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_editDialog_repaintOverItemMarkers( swidget UxThis, Environment * pEnv );
static int	_editDialog_addItem( swidget UxThis, Environment * pEnv, char *string );
static int	_editDialog_getSelPos( swidget UxThis, Environment * pEnv, int **list, int *number );
static void	_editDialog_deleteCommand( swidget UxThis, Environment * pEnv, int n );
static void	_editDialog_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag );
static void	_editDialog_drawItems( swidget UxThis, Environment * pEnv );
static int	_editDialog_itemCount( swidget UxThis, Environment * pEnv );
static void	_editDialog_modifyItemPos( swidget UxThis, Environment * pEnv, int nPos, char *pcString );
static void	_editDialog_setup( swidget UxThis, Environment * pEnv, int nWidth, char *pcTitle, char *pcLabel );
static int	_editDialog_deleteAllItems( swidget UxThis, Environment * pEnv );
static void	_editDialog_renumber( swidget UxThis, Environment * pEnv );
static void	_editDialog_destroyItemPos( swidget UxThis, Environment * pEnv, int n );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_repaintOverItemMarkers( swidget UxThis, Environment * pEnv )
{
}

static void	_editDialog_repaintOverItemMarkers( swidget UxThis, Environment * pEnv )
{
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_repaintOverItemMarkers( UxThis, pEnv );
	UxEditDialogContext = UxSaveCtx;
}

static int	Ux_addItem( swidget UxThis, Environment * pEnv, char *string )
{
	XmString item;
	int n;
	
	item = (XmString) XmStringCreateLtoR (string, XmSTRING_DEFAULT_CHARSET);
	XmListAddItem (UxGetWidget (editScrolledList), item, 0);
	XmStringFree (item);
	XtVaGetValues (UxGetWidget (editScrolledList), XmNitemCount, &n, NULL);
	return (n);
}

static int	_editDialog_addItem( swidget UxThis, Environment * pEnv, char *string )
{
	int			_Uxrtrn;
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_addItem( UxThis, pEnv, string );
	UxEditDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_getSelPos( swidget UxThis, Environment * pEnv, int **list, int *number )
{
	if (XmListGetSelectedPos (UxGetWidget (editScrolledList), list, number)) 
	   return (1);
	else
	   return (0);
}

static int	_editDialog_getSelPos( swidget UxThis, Environment * pEnv, int **list, int *number )
{
	int			_Uxrtrn;
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getSelPos( UxThis, pEnv, list, number );
	UxEditDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_deleteCommand( swidget UxThis, Environment * pEnv, int n )
{
}

static void	_editDialog_deleteCommand( swidget UxThis, Environment * pEnv, int n )
{
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_deleteCommand( UxThis, pEnv, n );
	UxEditDialogContext = UxSaveCtx;
}

static void	Ux_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag )
{
}

static void	_editDialog_markItems( swidget UxThis, Environment * pEnv, int item1, int item2, int flag )
{
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_markItems( UxThis, pEnv, item1, item2, flag );
	UxEditDialogContext = UxSaveCtx;
}

static void	Ux_drawItems( swidget UxThis, Environment * pEnv )
{
}

static void	_editDialog_drawItems( swidget UxThis, Environment * pEnv )
{
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_drawItems( UxThis, pEnv );
	UxEditDialogContext = UxSaveCtx;
}

static int	Ux_itemCount( swidget UxThis, Environment * pEnv )
{
	int n;
	XtVaGetValues (UxGetWidget (editScrolledList), XmNitemCount, &n, NULL);
	return (n);
}

static int	_editDialog_itemCount( swidget UxThis, Environment * pEnv )
{
	int			_Uxrtrn;
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_itemCount( UxThis, pEnv );
	UxEditDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_modifyItemPos( swidget UxThis, Environment * pEnv, int nPos, char *pcString )
{
	XmString item;
	
	item = (XmString) XmStringCreateLtoR (pcString, XmSTRING_DEFAULT_CHARSET);
	XmListReplaceItemsPos (editScrolledList, &item, 1, nPos);
	XmStringFree (item);
}

static void	_editDialog_modifyItemPos( swidget UxThis, Environment * pEnv, int nPos, char *pcString )
{
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_modifyItemPos( UxThis, pEnv, nPos, pcString );
	UxEditDialogContext = UxSaveCtx;
}

static void	Ux_setup( swidget UxThis, Environment * pEnv, int nWidth, char *pcTitle, char *pcLabel )
{
	XtVaSetValues (UxThis, 
	               XmNwidth, nWidth,
	               RES_CONVERT (XmNdialogTitle, pcTitle),
	               NULL);
	
	XtVaSetValues (editLabel,
	               RES_CONVERT (XmNlabelString, pcLabel),
	               NULL);
}

static void	_editDialog_setup( swidget UxThis, Environment * pEnv, int nWidth, char *pcTitle, char *pcLabel )
{
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setup( UxThis, pEnv, nWidth, pcTitle, pcLabel );
	UxEditDialogContext = UxSaveCtx;
}

static int	Ux_deleteAllItems( swidget UxThis, Environment * pEnv )
{
	int i, n;
	
	XtVaGetValues (UxGetWidget (editScrolledList), XmNitemCount, &n, NULL);
	
	for (i = 1; i <= n; i++)
	{
	    XmListDeletePos (UxGetWidget (editScrolledList), 1);
	}
}

static int	_editDialog_deleteAllItems( swidget UxThis, Environment * pEnv )
{
	int			_Uxrtrn;
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_deleteAllItems( UxThis, pEnv );
	UxEditDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_renumber( swidget UxThis, Environment * pEnv )
{
}

static void	_editDialog_renumber( swidget UxThis, Environment * pEnv )
{
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_renumber( UxThis, pEnv );
	UxEditDialogContext = UxSaveCtx;
}

static void	Ux_destroyItemPos( swidget UxThis, Environment * pEnv, int n )
{
}

static void	_editDialog_destroyItemPos( swidget UxThis, Environment * pEnv, int n )
{
	_UxCeditDialog          *UxSaveCtx = UxEditDialogContext;

	UxEditDialogContext = (_UxCeditDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_destroyItemPos( UxThis, pEnv, n );
	UxEditDialogContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  okCallback_editDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCeditDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxEditDialogContext;
	UxEditDialogContext = UxContext =
			(_UxCeditDialog *) UxGetContext( UxWidget );
	UxPopdownInterface (UxThisWidget);
	UxEditDialogContext = UxSaveCtx;
}

static void  cancelCB_editDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCeditDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxEditDialogContext;
	UxEditDialogContext = UxContext =
			(_UxCeditDialog *) UxGetContext( UxWidget );
	{
	int *list, number;
	
	editDialog_repaintOverItemMarkers (UxThisWidget, &UxEnv);
	editDialog_drawItems (UxThisWidget, &UxEnv);
	
	while (XmListGetSelectedPos (UxGetWidget (editScrolledList), &list, &number))
	{ 
	   XmListDeletePos (UxGetWidget (editScrolledList), list[0]);
	   editDialog_destroyItemPos (UxThisWidget, &UxEnv, list[0]);
	   editDialog_deleteCommand (UxThisWidget, &UxEnv, list[0]);
	   free (list);
	}
	
	editDialog_drawItems (UxThisWidget, &UxEnv);
	editDialog_markItems (UxThisWidget, &UxEnv, 
	                      1, editDialog_itemCount (UxThisWidget, &UxEnv), -1);
	
	}
	UxEditDialogContext = UxSaveCtx;
}

static void  helpCB_editDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCeditDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxEditDialogContext;
	UxEditDialogContext = UxContext =
			(_UxCeditDialog *) UxGetContext( UxWidget );
	{
	editDialog_markItems (UxThisWidget, &UxEnv, 
	                      1, editDialog_itemCount (UxThisWidget, &UxEnv), -1);
	XmListDeselectAllItems (UxGetWidget (editScrolledList));
	UxPopdownInterface (UxThisWidget);
	}
	UxEditDialogContext = UxSaveCtx;
}

static void  multipleSelectionCB_editScrolledList(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCeditDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxEditDialogContext;
	UxEditDialogContext = UxContext =
			(_UxCeditDialog *) UxGetContext( UxWidget );
	{
	int *list, number, i;
	
	XtVaGetValues (UxWidget, XmNitemCount, &number, NULL);
	editDialog_markItems (editDialog, &UxEnv, 1, number, -1);
	
	if (XmListGetSelectedPos (UxWidget, &list, &number))
	{
	    for (i=0; i<number; i++)
	    {
	        editDialog_markItems (editDialog, &UxEnv, list[i], list[i], 1);
	    }
	    free (list);
	}
	}
	UxEditDialogContext = UxSaveCtx;
}

static void  activateCB_renumberButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCeditDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxEditDialogContext;
	UxEditDialogContext = UxContext =
			(_UxCeditDialog *) UxGetContext( UxWidget );
	{
	int n;
	
	XtVaGetValues (UxGetWidget (editScrolledList), XmNitemCount, &n, NULL);
	
	editDialog_renumber (editDialog, &UxEnv);
	editDialog_markItems (editDialog, &UxEnv, 1, n, -1);
	}
	UxEditDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_editDialog()
{
	Widget		_UxParent;


	/* Creation of editDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "editDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 390,
			XmNy, 550,
			XmNwidth, 600,
			XmNheight, 332,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "editDialog",
			NULL );

	editDialog = XtVaCreateWidget( "editDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 600,
			XmNheight, 332,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNunitType, XmPIXELS,
			XmNautoUnmanage, FALSE,
			RES_CONVERT( XmNcancelLabelString, "Delete" ),
			RES_CONVERT( XmNdialogTitle, "Edit Dialog" ),
			RES_CONVERT( XmNhelpLabelString, "Cancel" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			XmNlabelFontList, UxConvertFontList("8x13" ),
			XmNtextFontList, UxConvertFontList("8x13" ),
			XmNbuttonFontList, UxConvertFontList("8x13" ),
			NULL );
	XtAddCallback( editDialog, XmNokCallback,
		(XtCallbackProc) okCallback_editDialog,
		(XtPointer) UxEditDialogContext );
	XtAddCallback( editDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_editDialog,
		(XtPointer) UxEditDialogContext );
	XtAddCallback( editDialog, XmNhelpCallback,
		(XtCallbackProc) helpCB_editDialog,
		(XtPointer) UxEditDialogContext );

	UxPutContext( editDialog, (char *) UxEditDialogContext );
	UxPutClassCode( editDialog, _UxIfClassId );


	/* Creation of editForm */
	editForm = XtVaCreateManagedWidget( "editForm",
			xmFormWidgetClass,
			editDialog,
			XmNwidth, 300,
			XmNheight, 200,
			XmNresizePolicy, XmRESIZE_NONE,
			XmNx, 0,
			XmNy, 0,
			NULL );
	UxPutContext( editForm, (char *) UxEditDialogContext );


	/* Creation of editScrolledWindowList */
	editScrolledWindowList = XtVaCreateManagedWidget( "editScrolledWindowList",
			xmScrolledWindowWidgetClass,
			editForm,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNshadowThickness, 0,
			XmNbottomAttachment, XmATTACH_FORM,
			XmNleftOffset, 0,
			XmNrightAttachment, XmATTACH_FORM,
			XmNtopOffset, 60,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( editScrolledWindowList, (char *) UxEditDialogContext );


	/* Creation of editScrolledList */
	editScrolledList = XtVaCreateManagedWidget( "editScrolledList",
			xmListWidgetClass,
			editScrolledWindowList,
			XmNwidth, 378,
			XmNheight, 217,
			XmNselectionPolicy, XmMULTIPLE_SELECT,
			XmNfontList, UxConvertFontList("8x13" ),
			NULL );
	XtAddCallback( editScrolledList, XmNmultipleSelectionCallback,
		(XtCallbackProc) multipleSelectionCB_editScrolledList,
		(XtPointer) UxEditDialogContext );

	UxPutContext( editScrolledList, (char *) UxEditDialogContext );


	/* Creation of editLabel */
	editLabel = XtVaCreateManagedWidget( "editLabel",
			xmLabelWidgetClass,
			editForm,
			XmNx, 4,
			XmNy, 10,
			XmNheight, 25,
			XmNleftAttachment, XmATTACH_FORM,
			XmNrightAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Base class for edit dialogs" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNtopOffset, 35,
			NULL );
	UxPutContext( editLabel, (char *) UxEditDialogContext );


	/* Creation of renumberButton */
	renumberButton = XtVaCreateManagedWidget( "renumberButton",
			xmPushButtonWidgetClass,
			editForm,
			XmNx, 195,
			XmNy, 1,
			XmNwidth, 150,
			XmNheight, 30,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNrightAttachment, XmATTACH_FORM,
			RES_CONVERT( XmNlabelString, "Renumber" ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	XtAddCallback( renumberButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_renumberButton,
		(XtPointer) UxEditDialogContext );

	UxPutContext( renumberButton, (char *) UxEditDialogContext );


	XtAddCallback( editDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxEditDialogContext);


	return ( editDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_editDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCeditDialog          *UxContext;
	static int		_Uxinit = 0;

	UxEditDialogContext = UxContext =
		(_UxCeditDialog *) UxNewContext( sizeof(_UxCeditDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxeditDialog_repaintOverItemMarkers_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_repaintOverItemMarkers_Name,
				(void (*)()) _editDialog_repaintOverItemMarkers );
		UxeditDialog_addItem_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_addItem_Name,
				(void (*)()) _editDialog_addItem );
		UxeditDialog_getSelPos_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_getSelPos_Name,
				(void (*)()) _editDialog_getSelPos );
		UxeditDialog_deleteCommand_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_deleteCommand_Name,
				(void (*)()) _editDialog_deleteCommand );
		UxeditDialog_markItems_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_markItems_Name,
				(void (*)()) _editDialog_markItems );
		UxeditDialog_drawItems_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_drawItems_Name,
				(void (*)()) _editDialog_drawItems );
		UxeditDialog_itemCount_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_itemCount_Name,
				(void (*)()) _editDialog_itemCount );
		UxeditDialog_modifyItemPos_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_modifyItemPos_Name,
				(void (*)()) _editDialog_modifyItemPos );
		UxeditDialog_setup_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_setup_Name,
				(void (*)()) _editDialog_setup );
		UxeditDialog_deleteAllItems_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_deleteAllItems_Name,
				(void (*)()) _editDialog_deleteAllItems );
		UxeditDialog_renumber_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_renumber_Name,
				(void (*)()) _editDialog_renumber );
		UxeditDialog_destroyItemPos_Id = UxMethodRegister( _UxIfClassId,
				UxeditDialog_destroyItemPos_Name,
				(void (*)()) _editDialog_destroyItemPos );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_editDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

