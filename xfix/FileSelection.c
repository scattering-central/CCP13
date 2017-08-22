
/*******************************************************************************
	FileSelection.c

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


static	int _UxIfClassId;
int	UxFileSelection_set_Id = -1;
char*	UxFileSelection_set_Name = "set";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "FileSelection.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_FileSelection_set( swidget UxThis, Environment * pEnv, swidget *sw1, char *Filter1, char *title1, int mustmatch, int editable, int type1, int mult1, int bsl1 );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_set( swidget UxThis, Environment * pEnv, swidget *sw1, char *Filter1, char *title1, int mustmatch, int editable, int type1, int mult1, int bsl1 )
{
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

static void	_FileSelection_set( swidget UxThis, Environment * pEnv, swidget *sw1, char *Filter1, char *title1, int mustmatch, int editable, int type1, int mult1, int bsl1 )
{
	_UxCFileSelection       *UxSaveCtx = UxFileSelectionContext;

	UxFileSelectionContext = (_UxCFileSelection *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_set( UxThis, pEnv, sw1, Filter1, title1, mustmatch, editable, type1, mult1, bsl1 );
	UxFileSelectionContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  okCallback_FileSelection(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCFileSelection       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFileSelectionContext;
	UxFileSelectionContext = UxContext =
			(_UxCFileSelection *) UxGetContext( UxWidget );
	{
#ifndef DESIGN_TIME
	
	char *sptr,*strptr;
	char error[80];
	int iflag;
	
	iflag=0;
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
	  mainWS_FileSelectionOK(mainWS,&UxEnv,sptr,sw);
	  UxPopdownInterface(UxThisWidget);  
	}
	else
	{
	  ErrorMessage_set(ErrMessage,&UxEnv,error);
	  UxPopupInterface(ErrMessage,no_grab);
	}
	 
	XtFree(strptr);
	
#endif
	}
	UxFileSelectionContext = UxSaveCtx;
}

static void  cancelCB_FileSelection(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCFileSelection       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFileSelectionContext;
	UxFileSelectionContext = UxContext =
			(_UxCFileSelection *) UxGetContext( UxWidget );
	{
	UxPopdownInterface(UxThisWidget);
	}
	UxFileSelectionContext = UxSaveCtx;
}

static void  noMatchCB_FileSelection(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCFileSelection       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFileSelectionContext;
	UxFileSelectionContext = UxContext =
			(_UxCFileSelection *) UxGetContext( UxWidget );
	{
	ErrorMessage_set(ErrMessage,&UxEnv,"File not found");
	UxPopupInterface(ErrMessage,no_grab);
	
	}
	UxFileSelectionContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_FileSelection()
{
	Widget		_UxParent;


	/* Creation of FileSelection */
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
		(XtCallbackProc) okCallback_FileSelection,
		(XtPointer) UxFileSelectionContext );
	XtAddCallback( FileSelection, XmNcancelCallback,
		(XtCallbackProc) cancelCB_FileSelection,
		(XtPointer) UxFileSelectionContext );
	XtAddCallback( FileSelection, XmNnoMatchCallback,
		(XtCallbackProc) noMatchCB_FileSelection,
		(XtPointer) UxFileSelectionContext );

	UxPutContext( FileSelection, (char *) UxFileSelectionContext );
	UxPutClassCode( FileSelection, _UxIfClassId );


	XtAddCallback( FileSelection, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxFileSelectionContext);


	return ( FileSelection );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_FileSelection( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCFileSelection       *UxContext;
	static int		_Uxinit = 0;

	UxFileSelectionContext = UxContext =
		(_UxCFileSelection *) UxNewContext( sizeof(_UxCFileSelection), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxFileSelection_set_Id = UxMethodRegister( _UxIfClassId,
				UxFileSelection_set_Name,
				(void (*)()) _FileSelection_set );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_FileSelection();

	selection = XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_TEXT);
	filelist  = XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_LIST);
	filtertxt = XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_FILTER_TEXT);
	
	XtUnmanageChild(XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_HELP_BUTTON));
	
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

