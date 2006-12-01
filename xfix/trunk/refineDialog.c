
/*******************************************************************************
	refineDialog.c

       Associated Header file: refineDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/ToggleB.h>
#include <Xm/RowColumn.h>
#include <Xm/Form.h>
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/


#ifndef DESIGN_TIME
#include "mainWS.h"
#endif

#include"mprintf.h"

extern swidget mainWS;


static	int _UxIfClassId;
/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "refineDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  okCallback_refineDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCrefineDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxRefineDialogContext;
	UxRefineDialogContext = UxContext =
			(_UxCrefineDialog *) UxGetContext( UxWidget );
	{
	int x, y, width, height;
	
	if (mainWS_imageLimits (mainWS, &UxEnv, &x, &y, &width, &height) == 0)
	{
	   command ("Refine %d %d %d %d\n", x, y, width, height);
	}  
	
	}
	UxRefineDialogContext = UxSaveCtx;
}

static void  valueChangedCB_centreButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCrefineDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxRefineDialogContext;
	UxRefineDialogContext = UxContext =
			(_UxCrefineDialog *) UxGetContext( UxWidget );
	{
	refineCentre = !refineCentre;
	mainWS_setRefineCentre (mainWS, &UxEnv, refineCentre);
	}
	UxRefineDialogContext = UxSaveCtx;
}

static void  valueChangedCB_rotXButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCrefineDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxRefineDialogContext;
	UxRefineDialogContext = UxContext =
			(_UxCrefineDialog *) UxGetContext( UxWidget );
	{
	refineRotX = !refineRotX;
	mainWS_setRefineRotX (mainWS, &UxEnv, refineRotX);
	}
	UxRefineDialogContext = UxSaveCtx;
}

static void  valueChangedCB_rotYButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCrefineDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxRefineDialogContext;
	UxRefineDialogContext = UxContext =
			(_UxCrefineDialog *) UxGetContext( UxWidget );
	{
	refineRotY = !refineRotY;
	mainWS_setRefineRotY (mainWS, &UxEnv, refineRotY);
	}
	UxRefineDialogContext = UxSaveCtx;
}

static void  valueChangedCB_rotZButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCrefineDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxRefineDialogContext;
	UxRefineDialogContext = UxContext =
			(_UxCrefineDialog *) UxGetContext( UxWidget );
	{
	refineRotZ = !refineRotZ;
	mainWS_setRefineRotZ (mainWS, &UxEnv, refineRotZ);
	}
	UxRefineDialogContext = UxSaveCtx;
}

static void  valueChangedCB_tiltButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCrefineDialog        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxRefineDialogContext;
	UxRefineDialogContext = UxContext =
			(_UxCrefineDialog *) UxGetContext( UxWidget );
	{
	refineTilt = !refineTilt;
	mainWS_setRefineTilt (mainWS, &UxEnv, refineTilt);
	}
	UxRefineDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_refineDialog()
{
	Widget		_UxParent;


	/* Creation of refineDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "refineDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 380,
			XmNy, 70,
			XmNwidth, 300,
			XmNheight, 300,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "refineDialog",
			NULL );

	refineDialog = XtVaCreateWidget( "refineDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 300,
			XmNheight, 300,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNunitType, XmPIXELS,
			XmNautoUnmanage, TRUE,
			RES_CONVERT( XmNcancelLabelString, "Cancel" ),
			RES_CONVERT( XmNdialogTitle, "Refine Dialog" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			NULL );
	XtAddCallback( refineDialog, XmNokCallback,
		(XtCallbackProc) okCallback_refineDialog,
		(XtPointer) UxRefineDialogContext );

	UxPutContext( refineDialog, (char *) UxRefineDialogContext );
	UxPutClassCode( refineDialog, _UxIfClassId );


	/* Creation of form4 */
	form4 = XtVaCreateManagedWidget( "form4",
			xmFormWidgetClass,
			refineDialog,
			XmNwidth, 280,
			XmNheight, 160,
			XmNresizePolicy, XmRESIZE_NONE,
			XmNx, 10,
			XmNy, 10,
			NULL );
	UxPutContext( form4, (char *) UxRefineDialogContext );


	/* Creation of rowColumn2 */
	rowColumn2 = XtVaCreateManagedWidget( "rowColumn2",
			xmRowColumnWidgetClass,
			form4,
			XmNwidth, 200,
			XmNheight, 200,
			XmNx, 10,
			XmNy, 20,
			NULL );
	UxPutContext( rowColumn2, (char *) UxRefineDialogContext );


	/* Creation of centreButton */
	centreButton = XtVaCreateManagedWidget( "centreButton",
			xmToggleButtonWidgetClass,
			rowColumn2,
			XmNx, 20,
			XmNy, 20,
			XmNwidth, 130,
			XmNheight, 10,
			RES_CONVERT( XmNlabelString, "Centre" ),
			XmNset, TRUE,
			NULL );
	XtAddCallback( centreButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_centreButton,
		(XtPointer) UxRefineDialogContext );

	UxPutContext( centreButton, (char *) UxRefineDialogContext );


	/* Creation of rotXButton */
	rotXButton = XtVaCreateManagedWidget( "rotXButton",
			xmToggleButtonWidgetClass,
			rowColumn2,
			XmNx, 13,
			XmNy, 13,
			XmNwidth, 130,
			XmNheight, 10,
			RES_CONVERT( XmNlabelString, "Detector rotation" ),
			XmNset, TRUE,
			NULL );
	XtAddCallback( rotXButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_rotXButton,
		(XtPointer) UxRefineDialogContext );

	UxPutContext( rotXButton, (char *) UxRefineDialogContext );


	/* Creation of rotYButton */
	rotYButton = XtVaCreateManagedWidget( "rotYButton",
			xmToggleButtonWidgetClass,
			rowColumn2,
			XmNx, 13,
			XmNy, 38,
			XmNwidth, 130,
			XmNheight, 10,
			RES_CONVERT( XmNlabelString, "Detector twist" ),
			NULL );
	XtAddCallback( rotYButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_rotYButton,
		(XtPointer) UxRefineDialogContext );

	UxPutContext( rotYButton, (char *) UxRefineDialogContext );


	/* Creation of rotZButton */
	rotZButton = XtVaCreateManagedWidget( "rotZButton",
			xmToggleButtonWidgetClass,
			rowColumn2,
			XmNx, 13,
			XmNy, 64,
			XmNwidth, 130,
			XmNheight, 10,
			RES_CONVERT( XmNlabelString, "Detector tilt" ),
			NULL );
	XtAddCallback( rotZButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_rotZButton,
		(XtPointer) UxRefineDialogContext );

	UxPutContext( rotZButton, (char *) UxRefineDialogContext );


	/* Creation of tiltButton */
	tiltButton = XtVaCreateManagedWidget( "tiltButton",
			xmToggleButtonWidgetClass,
			rowColumn2,
			XmNx, 13,
			XmNy, 90,
			XmNwidth, 130,
			XmNheight, 10,
			RES_CONVERT( XmNlabelString, "Specimen tilt" ),
			NULL );
	XtAddCallback( tiltButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_tiltButton,
		(XtPointer) UxRefineDialogContext );

	UxPutContext( tiltButton, (char *) UxRefineDialogContext );


	XtAddCallback( refineDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxRefineDialogContext);


	return ( refineDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_refineDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCrefineDialog        *UxContext;
	static int		_Uxinit = 0;

	UxRefineDialogContext = UxContext =
		(_UxCrefineDialog *) UxNewContext( sizeof(_UxCrefineDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_refineDialog();

	refineCentre = refineRotX = True;
	refineRotY = refineRotZ = refineTilt = False;
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

