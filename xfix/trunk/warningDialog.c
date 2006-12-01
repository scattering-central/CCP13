
/*******************************************************************************
	warningDialog.c

       Associated Header file: warningDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/


extern void Continue ();


static	int _UxIfClassId;
int	UxwarningDialog_popup_Id = -1;
char*	UxwarningDialog_popup_Name = "popup";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "warningDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_warningDialog_popup( swidget UxThis, Environment * pEnv, char *msg );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_popup( swidget UxThis, Environment * pEnv, char *msg )
{
#include "warningDialog_show.c"
}

static int	_warningDialog_popup( swidget UxThis, Environment * pEnv, char *msg )
{
	int			_Uxrtrn;
	_UxCwarningDialog       *UxSaveCtx = UxWarningDialogContext;

	UxWarningDialogContext = (_UxCwarningDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_popup( UxThis, pEnv, msg );
	UxWarningDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  okCallback_warningDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCwarningDialog       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxWarningDialogContext;
	UxWarningDialogContext = UxContext =
			(_UxCwarningDialog *) UxGetContext( UxWidget );
	{
	
	}
	UxWarningDialogContext = UxSaveCtx;
}

static void  cancelCB_warningDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCwarningDialog       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxWarningDialogContext;
	UxWarningDialogContext = UxContext =
			(_UxCwarningDialog *) UxGetContext( UxWidget );
	{
	Continue ();
	UxPopdownInterface (UxThisWidget);
	
	}
	UxWarningDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_warningDialog()
{
	Widget		_UxParent;


	/* Creation of warningDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "warningDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 360,
			XmNy, 100,
			XmNwidth, 350,
			XmNheight, 200,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "warningDialog",
			NULL );

	warningDialog = XtVaCreateWidget( "warningDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNdialogType, XmDIALOG_WARNING,
			XmNwidth, 350,
			XmNheight, 200,
			XmNunitType, XmPIXELS,
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			XmNtextFontList, UxConvertFontList("8x13bold" ),
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNmessageString, "Don't do it again \n " ),
			RES_CONVERT( XmNdialogTitle, "Warning Dialog" ),
			RES_CONVERT( XmNcancelLabelString, "OK" ),
			XmNdefaultButtonType, XmDIALOG_CANCEL_BUTTON,
			XmNautoUnmanage, FALSE,
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			RES_CONVERT( XmNhelpLabelString, "" ),
			XmNminimizeButtons, TRUE,
			RES_CONVERT( XmNokLabelString, "" ),
			NULL );
	XtAddCallback( warningDialog, XmNokCallback,
		(XtCallbackProc) okCallback_warningDialog,
		(XtPointer) UxWarningDialogContext );
	XtAddCallback( warningDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_warningDialog,
		(XtPointer) UxWarningDialogContext );

	UxPutContext( warningDialog, (char *) UxWarningDialogContext );
	UxPutClassCode( warningDialog, _UxIfClassId );


	XtAddCallback( warningDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxWarningDialogContext);


	return ( warningDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_warningDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCwarningDialog       *UxContext;
	static int		_Uxinit = 0;

	UxWarningDialogContext = UxContext =
		(_UxCwarningDialog *) UxNewContext( sizeof(_UxCwarningDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxwarningDialog_popup_Id = UxMethodRegister( _UxIfClassId,
				UxwarningDialog_popup_Name,
				(void (*)()) _warningDialog_popup );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_warningDialog();

	XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),
	                 XmDIALOG_OK_BUTTON));
	XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),
	                 XmDIALOG_HELP_BUTTON));
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

