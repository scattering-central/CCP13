
/*******************************************************************************
	infoDialog.c

       Associated Header file: infoDialog.h
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



static	int _UxIfClassId;
int	UxinfoDialog_popup_Id = -1;
char*	UxinfoDialog_popup_Name = "popup";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "infoDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_infoDialog_popup( swidget UxThis, Environment * pEnv, char *msg );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_popup( swidget UxThis, Environment * pEnv, char *msg )
{
#include "infoDialog_show.c"
}

static int	_infoDialog_popup( swidget UxThis, Environment * pEnv, char *msg )
{
	int			_Uxrtrn;
	_UxCinfoDialog          *UxSaveCtx = UxInfoDialogContext;

	UxInfoDialogContext = (_UxCinfoDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_popup( UxThis, pEnv, msg );
	UxInfoDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_infoDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCinfoDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxInfoDialogContext;
	UxInfoDialogContext = UxContext =
			(_UxCinfoDialog *) UxGetContext( UxWidget );
	{
	UxPopdownInterface (UxThisWidget);
	}
	UxInfoDialogContext = UxSaveCtx;
}

static void  okCallback_infoDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCinfoDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxInfoDialogContext;
	UxInfoDialogContext = UxContext =
			(_UxCinfoDialog *) UxGetContext( UxWidget );
	UxPopdownInterface (UxThisWidget);
	UxInfoDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_infoDialog()
{
	Widget		_UxParent;


	/* Creation of infoDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "infoDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 420,
			XmNy, 30,
			XmNwidth, 420,
			XmNheight, 300,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "infoDialog",
			NULL );

	infoDialog = XtVaCreateWidget( "infoDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNdialogType, XmDIALOG_INFORMATION,
			XmNwidth, 420,
			XmNheight, 300,
			XmNunitType, XmPIXELS,
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNmessageString, "Useful information\n" ),
			XmNtextFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNcancelLabelString, "Dismiss" ),
			RES_CONVERT( XmNokLabelString, "" ),
			XmNdefaultPosition, TRUE,
			XmNdefaultButtonType, XmDIALOG_CANCEL_BUTTON,
			XmNshadowThickness, 0,
			XmNminimizeButtons, TRUE,
			RES_CONVERT( XmNdialogTitle, "Information" ),
			RES_CONVERT( XmNhelpLabelString, "" ),
			NULL );
	XtAddCallback( infoDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_infoDialog,
		(XtPointer) UxInfoDialogContext );
	XtAddCallback( infoDialog, XmNokCallback,
		(XtCallbackProc) okCallback_infoDialog,
		(XtPointer) UxInfoDialogContext );

	UxPutContext( infoDialog, (char *) UxInfoDialogContext );
	UxPutClassCode( infoDialog, _UxIfClassId );


	XtAddCallback( infoDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxInfoDialogContext);


	return ( infoDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_infoDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCinfoDialog          *UxContext;
	static int		_Uxinit = 0;

	UxInfoDialogContext = UxContext =
		(_UxCinfoDialog *) UxNewContext( sizeof(_UxCinfoDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxinfoDialog_popup_Id = UxMethodRegister( _UxIfClassId,
				UxinfoDialog_popup_Name,
				(void (*)()) _infoDialog_popup );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_infoDialog();

	XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),
	                 XmDIALOG_OK_BUTTON));
	XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),
	                 XmDIALOG_HELP_BUTTON));
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

