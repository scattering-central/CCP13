
/*******************************************************************************
	InformationDialog.cc

       Associated Header file: InformationDialog.h
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

#include "InformationDialog.h"


/*******************************************************************************
       The following are method functions.
*******************************************************************************/

void _UxCInformationDialog::set( Environment * pEnv, char *message, char *title )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XmString xms1,xms2;
	xms1=XmStringCreateSimple(message);
	xms2=XmStringCreateSimple(title);
	XtVaSetValues(mlabel,XmNlabelString,xms1,NULL);
	XtVaSetValues(InformationDialog,XmNdialogTitle,xms2,NULL);
	XmStringFree(xms1);
	XmStringFree(xms2);
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
	delete ((_UxCInformationDialog *) obj);
}
void  _UxCInformationDialog::UxDestroyContextCB(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	((_UxCInformationDialog *) UxClientData)->UxThis = NULL;
	XtAppAddTimeOut(UxAppContext, 0, DelayedDelete, UxClientData);
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

Widget _UxCInformationDialog::_build()
{
	Widget		_UxParent;


	// Creation of InformationDialog
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "InformationDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "InformationDialog",
			NULL );

	InformationDialog = XtVaCreateWidget( "InformationDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNdialogType, XmDIALOG_INFORMATION,
			XmNunitType, XmPIXELS,
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			NULL );
	UxPutContext( InformationDialog, (char *) this );
	UxThis = InformationDialog;



	XtAddCallback( InformationDialog, XmNdestroyCallback,
		(XtCallbackProc) &_UxCInformationDialog::UxDestroyContextCB,
		(XtPointer) this);


	return ( InformationDialog );
}

/*******************************************************************************
       The following function includes the code that was entered
       in the 'Initial Code' and 'Final Code' sections of the
       Declarations Editor. This function is called from the
       'Interface function' below.
*******************************************************************************/

swidget _UxCInformationDialog::_create_InformationDialog(void)
{
	Widget                  rtrn;
	UxThis = rtrn = _build();

	// Final Code from declarations editor
	mlabel=XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_MESSAGE_LABEL);
	
	XtUnmanageChild(XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_HELP_BUTTON));
	XtUnmanageChild(XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_CANCEL_BUTTON));
	
	return(rtrn);
}

/*******************************************************************************
       The following is the destructor function.
*******************************************************************************/

_UxCInformationDialog::~_UxCInformationDialog()
{
	if (this->UxThis)
	{
		XtRemoveCallback( UxGetWidget(this->UxThis),
			XmNdestroyCallback,
			(XtCallbackProc) &_UxCInformationDialog::UxDestroyContextCB,
			(XtPointer) this);
		UxDestroyInterface(this->UxThis);
	}
}

/*******************************************************************************
       The following is the constructor function.
*******************************************************************************/

_UxCInformationDialog::_UxCInformationDialog( swidget UxParent )
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

swidget create_InformationDialog( swidget UxParent )
{
	_UxCInformationDialog *theInterface = 
			new _UxCInformationDialog( UxParent );
	return (theInterface->_create_InformationDialog());
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

