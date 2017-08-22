
/*******************************************************************************
	frameDialog.c

       Associated Header file: frameDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/PushB.h>
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/BulletinB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/


#ifndef DESIGN_TIME
#include "mainWS.h"
#endif

extern swidget mainWS;


static	int _UxIfClassId;
/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "frameDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  activateCB_pushButton1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCframeDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFrameDialogContext;
	UxFrameDialogContext = UxContext =
			(_UxCframeDialog *) UxGetContext( UxWidget );
	{
	int frameno;
	
	frameno=atoi(XmTextFieldGetString(frameField));
	mainWS_gotoFrame(mainWS,&UxEnv,frameno);
	UxPopdownInterface(frameDialog);
	}
	UxFrameDialogContext = UxSaveCtx;
}

static void  activateCB_pushButton2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCframeDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFrameDialogContext;
	UxFrameDialogContext = UxContext =
			(_UxCframeDialog *) UxGetContext( UxWidget );
	{
	UxPopdownInterface(frameDialog);
	}
	UxFrameDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_frameDialog()
{
	Widget		_UxParent;


	/* Creation of frameDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "frameDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 430,
			XmNy, 360,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "frameDialog",
			NULL );

	frameDialog = XtVaCreateWidget( "frameDialog",
			xmBulletinBoardWidgetClass,
			_UxParent,
			XmNunitType, XmPIXELS,
			RES_CONVERT( XmNdialogTitle, "Go to frame ..." ),
			XmNautoUnmanage, FALSE,
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			NULL );
	UxPutContext( frameDialog, (char *) UxFrameDialogContext );
	UxPutClassCode( frameDialog, _UxIfClassId );


	/* Creation of label8 */
	label8 = XtVaCreateManagedWidget( "label8",
			xmLabelWidgetClass,
			frameDialog,
			XmNx, 11,
			XmNy, 26,
			RES_CONVERT( XmNlabelString, "Go to frame:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label8, (char *) UxFrameDialogContext );


	/* Creation of frameField */
	frameField = XtVaCreateManagedWidget( "frameField",
			xmTextFieldWidgetClass,
			frameDialog,
			XmNwidth, 60,
			XmNx, 134,
			XmNy, 21,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( frameField, (char *) UxFrameDialogContext );


	/* Creation of pushButton1 */
	pushButton1 = XtVaCreateManagedWidget( "pushButton1",
			xmPushButtonWidgetClass,
			frameDialog,
			XmNx, 11,
			XmNy, 86,
			RES_CONVERT( XmNlabelString, "Go" ),
			XmNwidth, 70,
			XmNmarginHeight, 5,
			XmNmarginWidth, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton1, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton1,
		(XtPointer) UxFrameDialogContext );

	UxPutContext( pushButton1, (char *) UxFrameDialogContext );


	/* Creation of pushButton2 */
	pushButton2 = XtVaCreateManagedWidget( "pushButton2",
			xmPushButtonWidgetClass,
			frameDialog,
			XmNx, 124,
			XmNy, 86,
			XmNwidth, 70,
			RES_CONVERT( XmNlabelString, "Cancel" ),
			XmNmarginHeight, 5,
			XmNmarginWidth, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton2, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton2,
		(XtPointer) UxFrameDialogContext );

	UxPutContext( pushButton2, (char *) UxFrameDialogContext );


	XtAddCallback( frameDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxFrameDialogContext);


	return ( frameDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_frameDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCframeDialog         *UxContext;
	static int		_Uxinit = 0;

	UxFrameDialogContext = UxContext =
		(_UxCframeDialog *) UxNewContext( sizeof(_UxCframeDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_frameDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

