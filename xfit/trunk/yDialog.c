
/*******************************************************************************
	yDialog.c

       Associated Header file: yDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/Label.h>
#include <Xm/TextF.h>
#include <Xm/RowColumn.h>
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>
#include "mprintf.h"


static	int _UxIfClassId;
int	UxyDialog_popup_Id = -1;
char*	UxyDialog_popup_Name = "popup";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "yDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_yDialog_popup( swidget UxThis, Environment * pEnv, char *string );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_popup( swidget UxThis, Environment * pEnv, char *string )
{
#include "yDialog_show.c"
}

static int	_yDialog_popup( swidget UxThis, Environment * pEnv, char *string )
{
	int			_Uxrtrn;
	_UxCyDialog             *UxSaveCtx = UxYDialogContext;

	UxYDialogContext = (_UxCyDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_popup( UxThis, pEnv, string );
	UxYDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_yDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCyDialog             *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxYDialogContext;
	UxYDialogContext = UxContext =
			(_UxCyDialog *) UxGetContext( UxWidget );
	{
	char *cptr;
	double d1, d2;
	
	cptr  = XmTextFieldGetString (textField1);
	d1 = atof (cptr);
	free (cptr);
	
	cptr = XmTextFieldGetString (textField2);
	d2 = atof (cptr);
	free (cptr);
	
	command ("%g %g\n", d1, d2);
	}
	UxYDialogContext = UxSaveCtx;
}

static void  helpCB_yDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCyDialog             *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxYDialogContext;
	UxYDialogContext = UxContext =
			(_UxCyDialog *) UxGetContext( UxWidget );
	{
	command ("^d\n");
	UxPopdownInterface (UxThisWidget);
	}
	UxYDialogContext = UxSaveCtx;
}

static void  okCallback_yDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCyDialog             *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxYDialogContext;
	UxYDialogContext = UxContext =
			(_UxCyDialog *) UxGetContext( UxWidget );
	{
	char *cptr;
	double d1, d2;
	
	cptr  = XmTextFieldGetString (textField1);
	d1 = atof (cptr);
	free (cptr);
	
	cptr = XmTextFieldGetString (textField2);
	d2 = atof (cptr);
	free (cptr);
	
	command ("%g %g\n", d1, d2);
	command ("\n");
	
	UxPopdownInterface (UxThisWidget);
	}
	UxYDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_yDialog()
{
	Widget		_UxParent;


	/* Creation of yDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "yDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 53,
			XmNy, 534,
			XmNwidth, 290,
			XmNheight, 160,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "yDialog",
			NULL );

	yDialog = XtVaCreateWidget( "yDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 290,
			XmNheight, 160,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNunitType, XmPIXELS,
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNcancelLabelString, "Apply" ),
			RES_CONVERT( XmNdialogTitle, "Y Dialog" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			XmNresizePolicy, XmRESIZE_NONE,
			XmNtextFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNhelpLabelString, "Cancel" ),
			XmNdefaultButtonType, XmDIALOG_OK_BUTTON,
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			XmNautoUnmanage, FALSE,
			NULL );
	XtAddCallback( yDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_yDialog,
		(XtPointer) UxYDialogContext );
	XtAddCallback( yDialog, XmNhelpCallback,
		(XtCallbackProc) helpCB_yDialog,
		(XtPointer) UxYDialogContext );
	XtAddCallback( yDialog, XmNokCallback,
		(XtCallbackProc) okCallback_yDialog,
		(XtPointer) UxYDialogContext );

	UxPutContext( yDialog, (char *) UxYDialogContext );
	UxPutClassCode( yDialog, _UxIfClassId );


	/* Creation of rowColumn1 */
	rowColumn1 = XtVaCreateManagedWidget( "rowColumn1",
			xmRowColumnWidgetClass,
			yDialog,
			XmNwidth, 270,
			XmNheight, 130,
			XmNx, 0,
			XmNy, 0,
			XmNnumColumns, 2,
			XmNpacking, XmPACK_NONE,
			NULL );
	UxPutContext( rowColumn1, (char *) UxYDialogContext );


	/* Creation of textField1 */
	textField1 = XtVaCreateManagedWidget( "textField1",
			xmTextFieldWidgetClass,
			rowColumn1,
			XmNwidth, 70,
			XmNx, 130,
			XmNy, 5,
			XmNheight, 30,
			XmNvalue, "1",
			XmNcolumns, 14,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNsensitive, TRUE,
			NULL );
	UxPutContext( textField1, (char *) UxYDialogContext );


	/* Creation of label1 */
	label1 = XtVaCreateManagedWidget( "label1",
			xmLabelWidgetClass,
			rowColumn1,
			XmNx, 20,
			XmNy, 10,
			XmNwidth, 100,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Minimum Y " ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			NULL );
	UxPutContext( label1, (char *) UxYDialogContext );


	/* Creation of textField2 */
	textField2 = XtVaCreateManagedWidget( "textField2",
			xmTextFieldWidgetClass,
			rowColumn1,
			XmNwidth, 70,
			XmNx, 130,
			XmNy, 45,
			XmNheight, 30,
			XmNvalue, "1",
			XmNcolumns, 14,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNancestorSensitive, TRUE,
			NULL );
	UxPutContext( textField2, (char *) UxYDialogContext );


	/* Creation of label2 */
	label2 = XtVaCreateManagedWidget( "label2",
			xmLabelWidgetClass,
			rowColumn1,
			XmNx, 20,
			XmNy, 50,
			XmNwidth, 100,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Maximum Y" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			NULL );
	UxPutContext( label2, (char *) UxYDialogContext );


	XtAddCallback( yDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxYDialogContext);


	return ( yDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_yDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCyDialog             *UxContext;
	static int		_Uxinit = 0;

	UxYDialogContext = UxContext =
		(_UxCyDialog *) UxNewContext( sizeof(_UxCyDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxyDialog_popup_Id = UxMethodRegister( _UxIfClassId,
				UxyDialog_popup_Name,
				(void (*)()) _yDialog_popup );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_yDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

