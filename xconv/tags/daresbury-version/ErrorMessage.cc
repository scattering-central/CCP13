
/*******************************************************************************
	ErrorMessage.cc

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



#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#include "ErrorMessage.h"


/*******************************************************************************
       The following are method functions.
*******************************************************************************/

void _UxCErrorMessage::set( Environment * pEnv, char *message )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XmString xms;
	xms=XmStringCreateSimple(message);
	XtVaSetValues(mlabel,XmNlabelString,xms,NULL);
	XmStringFree(xms);
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

/*******************************************************************************
       The following is the destroyContext callback function.
       It is needed to free the memory allocated by the context.
*******************************************************************************/

static void DelayedDelete( XtPointer obj, XtIntervalId *)
{
	delete ((_UxCErrorMessage *) obj);
}
void  _UxCErrorMessage::UxDestroyContextCB(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	((_UxCErrorMessage *) UxClientData)->UxThis = NULL;
	XtAppAddTimeOut(UxAppContext, 0, DelayedDelete, UxClientData);
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

Widget _UxCErrorMessage::_build()
{
	Widget		_UxParent;


	// Creation of ErrorMessage
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
	UxPutContext( ErrorMessage, (char *) this );
	UxThis = ErrorMessage;



	XtAddCallback( ErrorMessage, XmNdestroyCallback,
		(XtCallbackProc) &_UxCErrorMessage::UxDestroyContextCB,
		(XtPointer) this);


	return ( ErrorMessage );
}

/*******************************************************************************
       The following function includes the code that was entered
       in the 'Initial Code' and 'Final Code' sections of the
       Declarations Editor. This function is called from the
       'Interface function' below.
*******************************************************************************/

swidget _UxCErrorMessage::_create_ErrorMessage(void)
{
	Widget                  rtrn;
	UxThis = rtrn = _build();

	// Final Code from declarations editor
	mlabel=XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_MESSAGE_LABEL);
	
	XtUnmanageChild(XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_CANCEL_BUTTON));
	XtUnmanageChild(XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_HELP_BUTTON));
	
	return(rtrn);
}

/*******************************************************************************
       The following is the destructor function.
*******************************************************************************/

_UxCErrorMessage::~_UxCErrorMessage()
{
	if (this->UxThis)
	{
		XtRemoveCallback( UxGetWidget(this->UxThis),
			XmNdestroyCallback,
			(XtCallbackProc) &_UxCErrorMessage::UxDestroyContextCB,
			(XtPointer) this);
		UxDestroyInterface(this->UxThis);
	}
}

/*******************************************************************************
       The following is the constructor function.
*******************************************************************************/

_UxCErrorMessage::_UxCErrorMessage( swidget UxParent )
{
	this->UxParent = UxParent;

	// User Supplied Constructor Code
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

swidget create_ErrorMessage( swidget UxParent )
{
	_UxCErrorMessage *theInterface = 
			new _UxCErrorMessage( UxParent );
	return (theInterface->_create_ErrorMessage());
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

