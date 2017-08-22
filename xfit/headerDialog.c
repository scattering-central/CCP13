
/*******************************************************************************
	headerDialog.c

       Associated Header file: headerDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/RowColumn.h>
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <string.h>

#ifndef DESIGN_TIME
#include "fitShell.h"
#endif


static	int _UxIfClassId;
int	UxheaderDialog_popup_Id = -1;
char*	UxheaderDialog_popup_Name = "popup";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "headerDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_headerDialog_popup( swidget UxThis, Environment * pEnv, char *filename );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_popup( swidget UxThis, Environment * pEnv, char *filename )
{
#include "headerDialog_show.c"
}

static int	_headerDialog_popup( swidget UxThis, Environment * pEnv, char *filename )
{
	int			_Uxrtrn;
	_UxCheaderDialog        *UxSaveCtx = UxHeaderDialogContext;

	UxHeaderDialogContext = (_UxCheaderDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_popup( UxThis, pEnv, filename );
	UxHeaderDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_headerDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCheaderDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxHeaderDialogContext;
	UxHeaderDialogContext = UxContext =
			(_UxCheaderDialog *) UxGetContext( UxWidget );
	{
	fitShell_SetHeaders (UxParent, &UxEnv, NULL, NULL);
	fitShell_continue (UxParent, &UxEnv);
	UxPopdownInterface;
	
	}
	UxHeaderDialogContext = UxSaveCtx;
}

static void  okCallback_headerDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCheaderDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxHeaderDialogContext;
	UxHeaderDialogContext = UxContext =
			(_UxCheaderDialog *) UxGetContext( UxWidget );
	{
	char *h1 = NULL, *h2 = NULL;
	
	h1 = (char *) XmTextFieldGetString (textHead1);
	if (!h1) h1 = (char *) strdup ("");
	 
	h2 = (char *) XmTextFieldGetString (textHead2);
	if (!h2) h2 = (char *) strdup ("");
	
	fitShell_SetHeaders (UxParent, &UxEnv, h1, h2);
	fitShell_continue (UxParent, &UxEnv);
	UxPopdownInterface (UxThisWidget);
	}
	UxHeaderDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_headerDialog()
{
	Widget		_UxParent;


	/* Creation of headerDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "headerDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNwidth, 700,
			XmNheight, 230,
			XmNtitle, "headerDialog",
			NULL );

	headerDialog = XtVaCreateWidget( "headerDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 700,
			XmNheight, 230,
			XmNdialogType, XmDIALOG_TEMPLATE,
			RES_CONVERT( XmNcancelLabelString, "Cancel" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			RES_CONVERT( XmNdialogTitle, "Header Dialog" ),
			RES_CONVERT( XmNmessageString, "Header file information" ),
			XmNdialogStyle, XmDIALOG_PRIMARY_APPLICATION_MODAL,
			XmNautoUnmanage, FALSE,
			XmNmessageAlignment, XmALIGNMENT_CENTER,
			NULL );
	XtAddCallback( headerDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_headerDialog,
		(XtPointer) UxHeaderDialogContext );
	XtAddCallback( headerDialog, XmNokCallback,
		(XtCallbackProc) okCallback_headerDialog,
		(XtPointer) UxHeaderDialogContext );

	UxPutContext( headerDialog, (char *) UxHeaderDialogContext );
	UxPutClassCode( headerDialog, _UxIfClassId );


	/* Creation of rowColumn5 */
	rowColumn5 = XtVaCreateManagedWidget( "rowColumn5",
			xmRowColumnWidgetClass,
			headerDialog,
			XmNwidth, 340,
			XmNheight, 90,
			XmNx, 0,
			XmNy, 10,
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNnumColumns, 2,
			XmNpacking, XmPACK_NONE,
			RES_CONVERT( XmNlabelString, "Output file header information" ),
			NULL );
	UxPutContext( rowColumn5, (char *) UxHeaderDialogContext );


	/* Creation of label11 */
	label11 = XtVaCreateManagedWidget( "label11",
			xmLabelWidgetClass,
			rowColumn5,
			XmNx, 10,
			XmNy, 90,
			XmNwidth, 80,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "header 2" ),
			XmNsensitive, FALSE,
			NULL );
	UxPutContext( label11, (char *) UxHeaderDialogContext );


	/* Creation of label10 */
	label10 = XtVaCreateManagedWidget( "label10",
			xmLabelWidgetClass,
			rowColumn5,
			XmNx, 10,
			XmNy, 30,
			XmNwidth, 80,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "header 1" ),
			NULL );
	UxPutContext( label10, (char *) UxHeaderDialogContext );


	/* Creation of textHead1 */
	textHead1 = XtVaCreateManagedWidget( "textHead1",
			xmTextFieldWidgetClass,
			rowColumn5,
			XmNwidth, 550,
			XmNx, 100,
			XmNy, 20,
			XmNheight, 30,
			XmNcolumns, 80,
			NULL );
	UxPutContext( textHead1, (char *) UxHeaderDialogContext );


	/* Creation of textHead2 */
	textHead2 = XtVaCreateManagedWidget( "textHead2",
			xmTextFieldWidgetClass,
			rowColumn5,
			XmNwidth, 550,
			XmNx, 100,
			XmNy, 80,
			XmNheight, 30,
			XmNcolumns, 80,
			XmNvalue, "",
			XmNsensitive, FALSE,
			NULL );
	UxPutContext( textHead2, (char *) UxHeaderDialogContext );


	XtAddCallback( headerDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxHeaderDialogContext);


	return ( headerDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_headerDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCheaderDialog        *UxContext;
	static int		_Uxinit = 0;

	UxHeaderDialogContext = UxContext =
		(_UxCheaderDialog *) UxNewContext( sizeof(_UxCheaderDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxheaderDialog_popup_Id = UxMethodRegister( _UxIfClassId,
				UxheaderDialog_popup_Name,
				(void (*)()) _headerDialog_popup );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_headerDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

