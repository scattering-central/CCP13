
/*******************************************************************************
	FileSelection.cc

       Associated Header file: FileSelection.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/FileSB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <Xm/TextF.h>
#include <Xm/Text.h>

#ifndef DESIGN_TIME
  #include "mainWS.h"
  #include "ErrorMessage.h"
#endif

extern swidget mainWS;
extern swidget ErrMessage;
extern char* stripws(char*);


#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#include "FileSelection.h"


/*******************************************************************************
       The following are method functions.
*******************************************************************************/

void _UxCFileSelection::set( Environment * pEnv, swidget *sw1, char *Filter1, char *title1, Boolean mustmatch, Boolean editable, int type1, int mult1, int bsl1 )
{
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	XmString Filter,xms;
	sw=sw1;
	Filter=XmStringCreateSimple(Filter1);
	xms=XmStringCreateSimple(title1);
	type=type1;
	mult=mult1;
	bsl=bsl1;
	
	XtVaSetValues(UxGetWidget(FileSelection),XmNmustMatch,mustmatch,NULL);
	XtVaSetValues(selection,XmNeditable,editable,NULL);
	XtVaSetValues(UxGetWidget(FileSelection),XmNdialogTitle,xms,NULL);
	XtVaSetValues(UxGetWidget(FileSelection),XmNdirMask,Filter,NULL);
	XmStringFree(Filter);
	XmStringFree(xms);
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

void  _UxCFileSelection::okCallback_FileSelection(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
#ifndef DESIGN_TIME
	
	char *sptr,*strptr,*error;
	int iflag;
	
	iflag=0;
	error=new char[80];
	strcpy(error,"");
	
	strptr=XmTextFieldGetString(selection);
	sptr=stripws(strptr);
	
	if(type==1)
	{
	  if(mainWS_CheckInFile(mainWS,&UxEnv,sptr,error,mult,bsl))
	    iflag=1;
	  else
	    iflag=0;
	}
	else if(type==0)
	{
	  if(mainWS_CheckOutFile(mainWS,&UxEnv,sptr,error,bsl))
	    iflag=1;
	  else
	    iflag=0;
	}
	
	if(iflag)
	{
	  if(mainWS_FileSelectionOK(mainWS,&UxEnv,1,sptr,sw,error))
	    UxPopdownInterface(UxThisWidget);
	  else
	  {
	    ErrorMessage_set(ErrMessage,&UxEnv,error);
	    UxPopupInterface(ErrMessage,no_grab);
	  }  
	}
	else
	{
	  ErrorMessage_set(ErrMessage,&UxEnv,error);
	  UxPopupInterface(ErrMessage,no_grab);
	}
	 
	XtFree(strptr);
	delete[] error;
	
#endif
	}
}

void  _UxCFileSelection::Wrap_okCallback_FileSelection(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCFileSelection       *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCFileSelection *) UxGetContext(UxWidget);
	UxContext->okCallback_FileSelection(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCFileSelection::cancelCB_FileSelection(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
#ifndef DESIGN_TIME
	
	char* error;
	error=new char[80];
	
	mainWS_FileSelectionOK(mainWS,&UxEnv,0,"",sw,error);
	UxPopdownInterface(UxThisWidget);
	
	delete[] error;
	
#endif
	}
}

void  _UxCFileSelection::Wrap_cancelCB_FileSelection(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCFileSelection       *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCFileSelection *) UxGetContext(UxWidget);
	UxContext->cancelCB_FileSelection(UxWidget, UxClientData, UxCallbackArg);
}

void  _UxCFileSelection::noMatchCB_FileSelection(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	{
	ErrorMessage_set(ErrMessage,&UxEnv,"File not found");
	UxPopupInterface(ErrMessage,no_grab);
	
	}
}

void  _UxCFileSelection::Wrap_noMatchCB_FileSelection(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	_UxCFileSelection       *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;
	UxContext = (_UxCFileSelection *) UxGetContext(UxWidget);
	UxContext->noMatchCB_FileSelection(UxWidget, UxClientData, UxCallbackArg);
}

/*******************************************************************************
       The following is the destroyContext callback function.
       It is needed to free the memory allocated by the context.
*******************************************************************************/

static void DelayedDelete( XtPointer obj, XtIntervalId *)
{
	delete ((_UxCFileSelection *) obj);
}
void  _UxCFileSelection::UxDestroyContextCB(
					Widget wgt, 
					XtPointer cd, 
					XtPointer cb)
{
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	((_UxCFileSelection *) UxClientData)->UxThis = NULL;
	XtAppAddTimeOut(UxAppContext, 0, DelayedDelete, UxClientData);
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

Widget _UxCFileSelection::_build()
{
	Widget		_UxParent;


	// Creation of FileSelection
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "FileSelection_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNwidth, 400,
			XmNheight, 500,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "FileSelection",
			NULL );

	FileSelection = XtVaCreateWidget( "FileSelection",
			xmFileSelectionBoxWidgetClass,
			_UxParent,
			XmNdialogType, XmDIALOG_FILE_SELECTION,
			XmNunitType, XmPIXELS,
			XmNdialogStyle, XmDIALOG_PRIMARY_APPLICATION_MODAL,
			XmNwidth, 400,
			XmNheight, 500,
			XmNresizePolicy, XmRESIZE_NONE,
			NULL );
	XtAddCallback( FileSelection, XmNokCallback,
		(XtCallbackProc) &_UxCFileSelection::Wrap_okCallback_FileSelection,
		(XtPointer) NULL );
	XtAddCallback( FileSelection, XmNcancelCallback,
		(XtCallbackProc) &_UxCFileSelection::Wrap_cancelCB_FileSelection,
		(XtPointer) NULL );
	XtAddCallback( FileSelection, XmNnoMatchCallback,
		(XtCallbackProc) &_UxCFileSelection::Wrap_noMatchCB_FileSelection,
		(XtPointer) NULL );

	UxPutContext( FileSelection, (char *) this );
	UxThis = FileSelection;



	XtAddCallback( FileSelection, XmNdestroyCallback,
		(XtCallbackProc) &_UxCFileSelection::UxDestroyContextCB,
		(XtPointer) this);


	return ( FileSelection );
}

/*******************************************************************************
       The following function includes the code that was entered
       in the 'Initial Code' and 'Final Code' sections of the
       Declarations Editor. This function is called from the
       'Interface function' below.
*******************************************************************************/

swidget _UxCFileSelection::_create_FileSelection(void)
{
	Widget                  rtrn;
	UxThis = rtrn = _build();

	// Final Code from declarations editor
	selection = XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_TEXT);
	filelist  = XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_LIST);
	filtertxt = XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_FILTER_TEXT);
	
	XtUnmanageChild(XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_HELP_BUTTON));
	
	return(rtrn);
}

/*******************************************************************************
       The following is the destructor function.
*******************************************************************************/

_UxCFileSelection::~_UxCFileSelection()
{
	if (this->UxThis)
	{
		XtRemoveCallback( UxGetWidget(this->UxThis),
			XmNdestroyCallback,
			(XtCallbackProc) &_UxCFileSelection::UxDestroyContextCB,
			(XtPointer) this);
		UxDestroyInterface(this->UxThis);
	}
}

/*******************************************************************************
       The following is the constructor function.
*******************************************************************************/

_UxCFileSelection::_UxCFileSelection( swidget UxParent )
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

swidget create_FileSelection( swidget UxParent )
{
	_UxCFileSelection *theInterface = 
			new _UxCFileSelection( UxParent );
	return (theInterface->_create_FileSelection());
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

