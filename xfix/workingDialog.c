
/*******************************************************************************
	workingDialog.c

       Associated Header file: workingDialog.h
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
int	UxworkingDialog_popup_Id = -1;
char*	UxworkingDialog_popup_Name = "popup";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "workingDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_workingDialog_popup( swidget UxThis, Environment * pEnv, char *msg );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_popup( swidget UxThis, Environment * pEnv, char *msg )
{
	XtVaSetValues (UxGetWidget (UxThis),
	                   XmNmessageString,
	                   XmStringCreateLtoR (msg, XmSTRING_DEFAULT_CHARSET),
	                   NULL);
	    UxPopupInterface (UxThis, nonexclusive_grab);
}

static void	_workingDialog_popup( swidget UxThis, Environment * pEnv, char *msg )
{
	_UxCworkingDialog       *UxSaveCtx = UxWorkingDialogContext;

	UxWorkingDialogContext = (_UxCworkingDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_popup( UxThis, pEnv, msg );
	UxWorkingDialogContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_workingDialog()
{
	Widget		_UxParent;


	/* Creation of workingDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "workingDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 680,
			XmNy, 450,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "workingDialog",
			NULL );

	workingDialog = XtVaCreateWidget( "workingDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNdialogType, XmDIALOG_WORKING,
			XmNunitType, XmPIXELS,
			RES_CONVERT( XmNcancelLabelString, "" ),
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			RES_CONVERT( XmNdialogTitle, "Working Dialog" ),
			RES_CONVERT( XmNhelpLabelString, "" ),
			RES_CONVERT( XmNmessageString, "Work in progress..." ),
			XmNminimizeButtons, TRUE,
			RES_CONVERT( XmNokLabelString, "" ),
			NULL );
	UxPutContext( workingDialog, (char *) UxWorkingDialogContext );
	UxPutClassCode( workingDialog, _UxIfClassId );


	XtAddCallback( workingDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxWorkingDialogContext);


	return ( workingDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_workingDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCworkingDialog       *UxContext;
	static int		_Uxinit = 0;

	UxWorkingDialogContext = UxContext =
		(_UxCworkingDialog *) UxNewContext( sizeof(_UxCworkingDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxworkingDialog_popup_Id = UxMethodRegister( _UxIfClassId,
				UxworkingDialog_popup_Name,
				(void (*)()) _workingDialog_popup );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_workingDialog();

	XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),
	                 XmDIALOG_OK_BUTTON));
	XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),
	                 XmDIALOG_CANCEL_BUTTON));
	XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),
	                 XmDIALOG_HELP_BUTTON));
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

