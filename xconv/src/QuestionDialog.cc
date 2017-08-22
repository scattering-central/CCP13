
/*******************************************************************************
	QuestionDialog.cc

       Associated Header file: QuestionDialog.h
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

#include "QuestionDialog.h"


/*******************************************************************************
       The following are method functions.
*******************************************************************************/

void _UxCQuestionDialog::set( Environment * pEnv, char *message, char *title )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XmString xms1,xms2;
	xms1=XmStringCreateSimple(message);
	xms2=XmStringCreateSimple(title);
	XtVaSetValues(mlabel,XmNlabelString,xms1,NULL);
	XtVaSetValues(QuestionDialog,XmNdialogTitle,xms2,NULL);
	XmStringFree(xms1);
	XmStringFree(xms2);
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

void  _UxCQuestionDialog::okCallback_QuestionDialog(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
	exit(0);
	}
}

void  _UxCQuestionDialog::Wrap_okCallback_QuestionDialog(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCQuestionDialog      *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCQuestionDialog *) UxGetContext(UxWidget);
	UxContext->okCallback_QuestionDialog(UxWidget, UxClientData, UxCallbackArg);
}

/*******************************************************************************
       The following is the destroyContext callback function.
       It is needed to free the memory allocated by the context.
*******************************************************************************/

static void DelayedDelete( XtPointer obj, XtIntervalId *)
{
	delete ((_UxCQuestionDialog *) obj);
}
void  _UxCQuestionDialog::UxDestroyContextCB(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	((_UxCQuestionDialog *) UxClientData)->UxThis = NULL;
	XtAppAddTimeOut(UxAppContext, 0, DelayedDelete, UxClientData);
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

Widget _UxCQuestionDialog::_build()
{
	Widget		_UxParent;


	// Creation of QuestionDialog
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "QuestionDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "QuestionDialog",
			NULL );

	QuestionDialog = XtVaCreateWidget( "QuestionDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNdialogType, XmDIALOG_QUESTION,
			XmNunitType, XmPIXELS,
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			NULL );
	XtAddCallback( QuestionDialog, XmNokCallback,
		(XtCallbackProc) &_UxCQuestionDialog::Wrap_okCallback_QuestionDialog,
		(XtPointer) NULL );

	UxPutContext( QuestionDialog, (char *) this );
	UxThis = QuestionDialog;



	XtAddCallback( QuestionDialog, XmNdestroyCallback,
		(XtCallbackProc) &_UxCQuestionDialog::UxDestroyContextCB,
		(XtPointer) this);


	return ( QuestionDialog );
}

/*******************************************************************************
       The following function includes the code that was entered
       in the 'Initial Code' and 'Final Code' sections of the
       Declarations Editor. This function is called from the
       'Interface function' below.
*******************************************************************************/

swidget _UxCQuestionDialog::_create_QuestionDialog(void)
{
	Widget                  rtrn;
	UxThis = rtrn = _build();

	// Final Code from declarations editor
	mlabel=XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_MESSAGE_LABEL);
	
	XtUnmanageChild(XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_HELP_BUTTON));
	
	return(rtrn);
}

/*******************************************************************************
       The following is the destructor function.
*******************************************************************************/

_UxCQuestionDialog::~_UxCQuestionDialog()
{
	if (this->UxThis)
	{
		XtRemoveCallback( UxGetWidget(this->UxThis),
			XmNdestroyCallback,
			(XtCallbackProc) &_UxCQuestionDialog::UxDestroyContextCB,
			(XtPointer) this);
		UxDestroyInterface(this->UxThis);
	}
}

/*******************************************************************************
       The following is the constructor function.
*******************************************************************************/

_UxCQuestionDialog::_UxCQuestionDialog( swidget UxParent )
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

swidget create_QuestionDialog( swidget UxParent )
{
	_UxCQuestionDialog *theInterface = 
			new _UxCQuestionDialog( UxParent );
	return (theInterface->_create_QuestionDialog());
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

