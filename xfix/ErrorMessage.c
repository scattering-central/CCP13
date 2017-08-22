
/*******************************************************************************
	ErrorMessage.c

       Associated Header file: ErrorMessage.h
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
int	UxErrorMessage_set_Id = -1;
char*	UxErrorMessage_set_Name = "set";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "ErrorMessage.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_ErrorMessage_set( swidget UxThis, Environment * pEnv, char *message );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_set( swidget UxThis, Environment * pEnv, char *message )
{
	XmString xms;
	xms=XmStringCreateSimple(message);
	XtVaSetValues(mlabel,XmNlabelString,xms,NULL);
	XmStringFree(xms);
}

static void	_ErrorMessage_set( swidget UxThis, Environment * pEnv, char *message )
{
	_UxCErrorMessage        *UxSaveCtx = UxErrorMessageContext;

	UxErrorMessageContext = (_UxCErrorMessage *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_set( UxThis, pEnv, message );
	UxErrorMessageContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_ErrorMessage()
{
	Widget		_UxParent;


	/* Creation of ErrorMessage */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "ErrorMessage_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "ErrorMessage",
			NULL );

	ErrorMessage = XtVaCreateWidget( "ErrorMessage",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNdialogType, XmDIALOG_ERROR,
			XmNunitType, XmPIXELS,
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			RES_CONVERT( XmNdialogTitle, "Error message" ),
			XmNmarginWidth, 20,
			NULL );
	UxPutContext( ErrorMessage, (char *) UxErrorMessageContext );
	UxPutClassCode( ErrorMessage, _UxIfClassId );


	XtAddCallback( ErrorMessage, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxErrorMessageContext);


	return ( ErrorMessage );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_ErrorMessage( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCErrorMessage        *UxContext;
	static int		_Uxinit = 0;

	UxErrorMessageContext = UxContext =
		(_UxCErrorMessage *) UxNewContext( sizeof(_UxCErrorMessage), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxErrorMessage_set_Id = UxMethodRegister( _UxIfClassId,
				UxErrorMessage_set_Name,
				(void (*)()) _ErrorMessage_set );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_ErrorMessage();

	mlabel=XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_MESSAGE_LABEL);
	
	XtUnmanageChild(XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_CANCEL_BUTTON));
	XtUnmanageChild(XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_HELP_BUTTON));
	
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

