
/*******************************************************************************
	continueDialog.c

       Associated Header file: continueDialog.h
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

#include "mprintf.h"


static	int _UxIfClassId;
/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "continueDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_continueDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCcontinueDialog      *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxContinueDialogContext;
	UxContinueDialogContext = UxContext =
			(_UxCcontinueDialog *) UxGetContext( UxWidget );
	{
	command ("\n");
	}
	UxContinueDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_continueDialog()
{
	Widget		_UxParent;


	/* Creation of continueDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "continueDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 390,
			XmNy, 40,
			XmNwidth, 300,
			XmNheight, 120,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "continueDialog",
			NULL );

	continueDialog = XtVaCreateWidget( "continueDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 300,
			XmNheight, 120,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNunitType, XmPIXELS,
			RES_CONVERT( XmNcancelLabelString, "Continue" ),
			XmNdefaultButtonType, XmDIALOG_CANCEL_BUTTON,
			RES_CONVERT( XmNmessageString, "Plot next frame of data" ),
			XmNmessageAlignment, XmALIGNMENT_CENTER,
			RES_CONVERT( XmNdialogTitle, "Continue" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			NULL );
	XtAddCallback( continueDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_continueDialog,
		(XtPointer) UxContinueDialogContext );

	UxPutContext( continueDialog, (char *) UxContinueDialogContext );
	UxPutClassCode( continueDialog, _UxIfClassId );


	XtAddCallback( continueDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxContinueDialogContext);


	return ( continueDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_continueDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCcontinueDialog      *UxContext;
	static int		_Uxinit = 0;

	UxContinueDialogContext = UxContext =
		(_UxCcontinueDialog *) UxNewContext( sizeof(_UxCcontinueDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_continueDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

