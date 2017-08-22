
/*******************************************************************************
	errorDialog.c

       Associated Header file: errorDialog.h
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
int	UxerrorDialog_popup_Id = -1;
char*	UxerrorDialog_popup_Name = "popup";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "errorDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_errorDialog_popup( swidget UxThis, Environment * pEnv, char *msg );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_popup( swidget UxThis, Environment * pEnv, char *msg )
{
#include "errorDialog_show.c"
}

static int	_errorDialog_popup( swidget UxThis, Environment * pEnv, char *msg )
{
	int			_Uxrtrn;
	_UxCerrorDialog         *UxSaveCtx = UxErrorDialogContext;

	UxErrorDialogContext = (_UxCerrorDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_popup( UxThis, pEnv, msg );
	UxErrorDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  okCallback_errorDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCerrorDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxErrorDialogContext;
	UxErrorDialogContext = UxContext =
			(_UxCerrorDialog *) UxGetContext( UxWidget );
	{
	
	}
	UxErrorDialogContext = UxSaveCtx;
}

static void  cancelCB_errorDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCerrorDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxErrorDialogContext;
	UxErrorDialogContext = UxContext =
			(_UxCerrorDialog *) UxGetContext( UxWidget );
	{
	Continue ();
	UxPopdownInterface (UxThisWidget);
	
	}
	UxErrorDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_errorDialog()
{
	Widget		_UxParent;


	/* Creation of errorDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "errorDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 950,
			XmNy, 630,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "errorDialog",
			NULL );

	errorDialog = XtVaCreateWidget( "errorDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNdialogType, XmDIALOG_ERROR,
			XmNunitType, XmPIXELS,
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNdialogTitle, "Error Dialog" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNmessageString, "Big mistake \n" ),
			RES_CONVERT( XmNcancelLabelString, "OK" ),
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			XmNdefaultButtonType, XmDIALOG_CANCEL_BUTTON,
			XmNautoUnmanage, FALSE,
			NULL );
	XtAddCallback( errorDialog, XmNokCallback,
		(XtCallbackProc) okCallback_errorDialog,
		(XtPointer) UxErrorDialogContext );
	XtAddCallback( errorDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_errorDialog,
		(XtPointer) UxErrorDialogContext );

	UxPutContext( errorDialog, (char *) UxErrorDialogContext );
	UxPutClassCode( errorDialog, _UxIfClassId );


	XtAddCallback( errorDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxErrorDialogContext);


	return ( errorDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_errorDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCerrorDialog         *UxContext;
	static int		_Uxinit = 0;

	UxErrorDialogContext = UxContext =
		(_UxCerrorDialog *) UxNewContext( sizeof(_UxCerrorDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxerrorDialog_popup_Id = UxMethodRegister( _UxIfClassId,
				UxerrorDialog_popup_Name,
				(void (*)()) _errorDialog_popup );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_errorDialog();

	XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),
	                 XmDIALOG_OK_BUTTON));
	XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),
	                 XmDIALOG_HELP_BUTTON));
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

