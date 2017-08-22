
/*******************************************************************************
	parameterDialog.c

       Associated Header file: parameterDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/Form.h>
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>

#ifndef DESIGN_TIME
#include "mainWS.h"
#endif

#include "mprintf.h"

extern swidget mainWS;


static	int _UxIfClassId;
int	UxparameterDialog_setRotation_Id = -1;
char*	UxparameterDialog_setRotation_Name = "setRotation";
int	UxparameterDialog_setWave_Id = -1;
char*	UxparameterDialog_setWave_Name = "setWave";
int	UxparameterDialog_setCentre_Id = -1;
char*	UxparameterDialog_setCentre_Name = "setCentre";
int	UxparameterDialog_setDistance_Id = -1;
char*	UxparameterDialog_setDistance_Name = "setDistance";
int	UxparameterDialog_setTilt_Id = -1;
char*	UxparameterDialog_setTilt_Name = "setTilt";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "parameterDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_parameterDialog_setRotation( swidget UxThis, Environment * pEnv, double valueX, double valueY, double valueZ );
static void	_parameterDialog_setWave( swidget UxThis, Environment * pEnv, double value );
static void	_parameterDialog_setCentre( swidget UxThis, Environment * pEnv, double valX, double valY );
static void	_parameterDialog_setDistance( swidget UxThis, Environment * pEnv, double value );
static void	_parameterDialog_setTilt( swidget UxThis, Environment * pEnv, double value );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_setRotation( swidget UxThis, Environment * pEnv, double valueX, double valueY, double valueZ )
{
	sprintf (textBuf, "%8.2f", valueX);
	XmTextFieldSetString (UxGetWidget (detectorRotText), textBuf);
	sprintf (textBuf, "%8.2f", valueY);
	XmTextFieldSetString (UxGetWidget (detectorTwistText), textBuf);
	sprintf (textBuf, "%8.2f", valueZ);
	XmTextFieldSetString (UxGetWidget (detectorTiltText), textBuf);
}

static void	_parameterDialog_setRotation( swidget UxThis, Environment * pEnv, double valueX, double valueY, double valueZ )
{
	_UxCparameterDialog     *UxSaveCtx = UxParameterDialogContext;

	UxParameterDialogContext = (_UxCparameterDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setRotation( UxThis, pEnv, valueX, valueY, valueZ );
	UxParameterDialogContext = UxSaveCtx;
}

static void	Ux_setWave( swidget UxThis, Environment * pEnv, double value )
{
	sprintf (textBuf, "%6.4f", value);
	XmTextFieldSetString (UxGetWidget (waveText), textBuf);
}

static void	_parameterDialog_setWave( swidget UxThis, Environment * pEnv, double value )
{
	_UxCparameterDialog     *UxSaveCtx = UxParameterDialogContext;

	UxParameterDialogContext = (_UxCparameterDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setWave( UxThis, pEnv, value );
	UxParameterDialogContext = UxSaveCtx;
}

static void	Ux_setCentre( swidget UxThis, Environment * pEnv, double valX, double valY )
{
	sprintf (textBuf, "%6.1f", valX);
	XmTextFieldSetString (UxGetWidget (centreXText), textBuf);
	sprintf (textBuf, "%6.1f", valY);
	XmTextFieldSetString (UxGetWidget (centreYText), textBuf);
}

static void	_parameterDialog_setCentre( swidget UxThis, Environment * pEnv, double valX, double valY )
{
	_UxCparameterDialog     *UxSaveCtx = UxParameterDialogContext;

	UxParameterDialogContext = (_UxCparameterDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setCentre( UxThis, pEnv, valX, valY );
	UxParameterDialogContext = UxSaveCtx;
}

static void	Ux_setDistance( swidget UxThis, Environment * pEnv, double value )
{
	sprintf (textBuf, "%8.1f", value);
	XmTextFieldSetString (UxGetWidget (distanceText), textBuf);
}

static void	_parameterDialog_setDistance( swidget UxThis, Environment * pEnv, double value )
{
	_UxCparameterDialog     *UxSaveCtx = UxParameterDialogContext;

	UxParameterDialogContext = (_UxCparameterDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setDistance( UxThis, pEnv, value );
	UxParameterDialogContext = UxSaveCtx;
}

static void	Ux_setTilt( swidget UxThis, Environment * pEnv, double value )
{
	sprintf (textBuf, "%8.2f", value);
	XmTextFieldSetString (UxGetWidget (specimenTiltText), textBuf);
}

static void	_parameterDialog_setTilt( swidget UxThis, Environment * pEnv, double value )
{
	_UxCparameterDialog     *UxSaveCtx = UxParameterDialogContext;

	UxParameterDialogContext = (_UxCparameterDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setTilt( UxThis, pEnv, value );
	UxParameterDialogContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_parameterDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	{
#include "parameterDialog_applyCB.c"
	}
	UxParameterDialogContext = UxSaveCtx;
}

static void  helpCB_parameterDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	{
	waveChanged = distanceChanged = centreChanged = rotationChanged = tiltChanged = False;
	UxPopdownInterface (UxThisWidget);
	}
	UxParameterDialogContext = UxSaveCtx;
}

static void  okCallback_parameterDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	{
#include "parameterDialog_applyCB.c"
	UxPopdownInterface (UxThisWidget);
	}
	UxParameterDialogContext = UxSaveCtx;
}

static void  valueChangedCB_waveText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	{
	waveChanged = True;
	}
	UxParameterDialogContext = UxSaveCtx;
}

static void  valueChangedCB_distanceText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	distanceChanged = True;
	UxParameterDialogContext = UxSaveCtx;
}

static void  valueChangedCB_centreXText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	centreChanged = True;
	UxParameterDialogContext = UxSaveCtx;
}

static void  valueChangedCB_centreYText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	centreChanged = True;
	UxParameterDialogContext = UxSaveCtx;
}

static void  valueChangedCB_detectorRotText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	rotationChanged = True;
	UxParameterDialogContext = UxSaveCtx;
}

static void  valueChangedCB_detectorTwistText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	rotationChanged = True;
	UxParameterDialogContext = UxSaveCtx;
}

static void  valueChangedCB_detectorTiltText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	rotationChanged = True;
	UxParameterDialogContext = UxSaveCtx;
}

static void  valueChangedCB_specimenTiltText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	tiltChanged = True;
	UxParameterDialogContext = UxSaveCtx;
}

static void  valueChangedCB_calibrationText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparameterDialog     *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParameterDialogContext;
	UxParameterDialogContext = UxContext =
			(_UxCparameterDialog *) UxGetContext( UxWidget );
	calibrationChanged = True;
	UxParameterDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_parameterDialog()
{
	Widget		_UxParent;


	/* Creation of parameterDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "parameterDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNheight, 400,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "parameterDialog",
			NULL );

	parameterDialog = XtVaCreateWidget( "parameterDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNheight, 400,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNunitType, XmPIXELS,
			RES_CONVERT( XmNcancelLabelString, "Apply" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			RES_CONVERT( XmNdialogTitle, "Parameter Editor" ),
			RES_CONVERT( XmNhelpLabelString, "Cancel" ),
			XmNautoUnmanage, FALSE,
			XmNmarginHeight, 5,
			XmNmarginWidth, 5,
			NULL );
	XtAddCallback( parameterDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_parameterDialog,
		(XtPointer) UxParameterDialogContext );
	XtAddCallback( parameterDialog, XmNhelpCallback,
		(XtCallbackProc) helpCB_parameterDialog,
		(XtPointer) UxParameterDialogContext );
	XtAddCallback( parameterDialog, XmNokCallback,
		(XtCallbackProc) okCallback_parameterDialog,
		(XtPointer) UxParameterDialogContext );

	UxPutContext( parameterDialog, (char *) UxParameterDialogContext );
	UxPutClassCode( parameterDialog, _UxIfClassId );


	/* Creation of form2 */
	form2 = XtVaCreateManagedWidget( "form2",
			xmFormWidgetClass,
			parameterDialog,
			XmNheight, 339,
			NULL );
	UxPutContext( form2, (char *) UxParameterDialogContext );


	/* Creation of waveLabel */
	waveLabel = XtVaCreateManagedWidget( "waveLabel",
			xmLabelWidgetClass,
			form2,
			XmNx, 10,
			XmNy, 20,
			XmNwidth, 100,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Wavelength:" ),
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			XmNleftOffset, 0,
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( waveLabel, (char *) UxParameterDialogContext );


	/* Creation of waveText */
	waveText = XtVaCreateManagedWidget( "waveText",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 90,
			XmNx, 190,
			XmNy, 20,
			XmNheight, 30,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 100,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			XmNvalue, "1.5418",
			XmNfontList, UxConvertFontList("8x13" ),
			NULL );
	XtAddCallback( waveText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_waveText,
		(XtPointer) UxParameterDialogContext );

	UxPutContext( waveText, (char *) UxParameterDialogContext );


	/* Creation of distanceLabel */
	distanceLabel = XtVaCreateManagedWidget( "distanceLabel",
			xmLabelWidgetClass,
			form2,
			XmNx, 100,
			XmNy, 50,
			XmNwidth, 100,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Distance:" ),
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 0,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 50,
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( distanceLabel, (char *) UxParameterDialogContext );


	/* Creation of distanceText */
	distanceText = XtVaCreateManagedWidget( "distanceText",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 90,
			XmNx, 100,
			XmNy, 50,
			XmNheight, 30,
			XmNvalue, "",
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftOffset, 100,
			XmNtopOffset, 50,
			XmNfontList, UxConvertFontList("8x13" ),
			NULL );
	XtAddCallback( distanceText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_distanceText,
		(XtPointer) UxParameterDialogContext );

	UxPutContext( distanceText, (char *) UxParameterDialogContext );


	/* Creation of centreXLabel */
	centreXLabel = XtVaCreateManagedWidget( "centreXLabel",
			xmLabelWidgetClass,
			form2,
			XmNx, 10,
			XmNy, 60,
			XmNwidth, 170,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Detector centre:   X" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 90,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 0,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( centreXLabel, (char *) UxParameterDialogContext );


	/* Creation of centreXText */
	centreXText = XtVaCreateManagedWidget( "centreXText",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 90,
			XmNx, 150,
			XmNy, 90,
			XmNheight, 30,
			XmNvalue, "600",
			XmNleftOffset, 170,
			XmNleftAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("8x13" ),
			NULL );
	XtAddCallback( centreXText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_centreXText,
		(XtPointer) UxParameterDialogContext );

	UxPutContext( centreXText, (char *) UxParameterDialogContext );


	/* Creation of centreYLabel */
	centreYLabel = XtVaCreateManagedWidget( "centreYLabel",
			xmLabelWidgetClass,
			form2,
			XmNx, 250,
			XmNy, 90,
			XmNwidth, 15,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Y" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 258,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 90,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( centreYLabel, (char *) UxParameterDialogContext );


	/* Creation of centreYText */
	centreYText = XtVaCreateManagedWidget( "centreYText",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 90,
			XmNx, 270,
			XmNy, 90,
			XmNheight, 30,
			XmNvalue, "600",
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 275,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 90,
			XmNfontList, UxConvertFontList("8x13" ),
			NULL );
	XtAddCallback( centreYText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_centreYText,
		(XtPointer) UxParameterDialogContext );

	UxPutContext( centreYText, (char *) UxParameterDialogContext );


	/* Creation of detectorRotLabel */
	detectorRotLabel = XtVaCreateManagedWidget( "detectorRotLabel",
			xmLabelWidgetClass,
			form2,
			XmNx, 0,
			XmNy, 130,
			XmNwidth, 170,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Detector rotation:  " ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 130,
			XmNleftOffset, 0,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( detectorRotLabel, (char *) UxParameterDialogContext );


	/* Creation of detectorRotText */
	detectorRotText = XtVaCreateManagedWidget( "detectorRotText",
			xmTextFieldWidgetClass,
			form2,
			XmNx, 150,
			XmNy, 130,
			XmNheight, 30,
			XmNvalue, "600",
			XmNvalueWcs, UxConvertValueWcs("0.0" ),
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftOffset, 170,
			XmNtopOffset, 130,
			XmNfontList, UxConvertFontList("8x13" ),
			XmNwidth, 90,
			NULL );
	XtAddCallback( detectorRotText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_detectorRotText,
		(XtPointer) UxParameterDialogContext );

	UxPutContext( detectorRotText, (char *) UxParameterDialogContext );


	/* Creation of detectorTwistText */
	detectorTwistText = XtVaCreateManagedWidget( "detectorTwistText",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 90,
			XmNx, 150,
			XmNy, 160,
			XmNheight, 30,
			XmNvalue, "0.0",
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftOffset, 170,
			XmNtopOffset, 160,
			XmNfontList, UxConvertFontList("8x13" ),
			NULL );
	XtAddCallback( detectorTwistText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_detectorTwistText,
		(XtPointer) UxParameterDialogContext );

	UxPutContext( detectorTwistText, (char *) UxParameterDialogContext );


	/* Creation of detectorTwistLabel */
	detectorTwistLabel = XtVaCreateManagedWidget( "detectorTwistLabel",
			xmLabelWidgetClass,
			form2,
			XmNx, -220,
			XmNy, 160,
			XmNwidth, 170,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Detector twist:  " ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 160,
			XmNleftOffset, 0,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( detectorTwistLabel, (char *) UxParameterDialogContext );


	/* Creation of detectorTiltText */
	detectorTiltText = XtVaCreateManagedWidget( "detectorTiltText",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 90,
			XmNx, 150,
			XmNy, 190,
			XmNheight, 30,
			XmNvalue, "0.0",
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftOffset, 170,
			XmNtopOffset, 190,
			XmNfontList, UxConvertFontList("8x13" ),
			NULL );
	XtAddCallback( detectorTiltText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_detectorTiltText,
		(XtPointer) UxParameterDialogContext );

	UxPutContext( detectorTiltText, (char *) UxParameterDialogContext );


	/* Creation of detectorTiltLabel */
	detectorTiltLabel = XtVaCreateManagedWidget( "detectorTiltLabel",
			xmLabelWidgetClass,
			form2,
			XmNx, 0,
			XmNy, 190,
			XmNwidth, 127,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Detector tilt:  " ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftOffset, 0,
			XmNtopOffset, 190,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( detectorTiltLabel, (char *) UxParameterDialogContext );


	/* Creation of specimenTiltText */
	specimenTiltText = XtVaCreateManagedWidget( "specimenTiltText",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 90,
			XmNx, 150,
			XmNy, 230,
			XmNheight, 30,
			XmNvalue, "0.0",
			XmNleftOffset, 170,
			XmNleftAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("8x13" ),
			NULL );
	XtAddCallback( specimenTiltText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_specimenTiltText,
		(XtPointer) UxParameterDialogContext );

	UxPutContext( specimenTiltText, (char *) UxParameterDialogContext );


	/* Creation of specimenTiltLabel */
	specimenTiltLabel = XtVaCreateManagedWidget( "specimenTiltLabel",
			xmLabelWidgetClass,
			form2,
			XmNx, 0,
			XmNy, 230,
			XmNwidth, 170,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Specimen tilt:  " ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 230,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( specimenTiltLabel, (char *) UxParameterDialogContext );


	/* Creation of calibrationLabel */
	calibrationLabel = XtVaCreateManagedWidget( "calibrationLabel",
			xmLabelWidgetClass,
			form2,
			XmNx, 0,
			XmNy, 270,
			XmNwidth, 170,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Calibrant d-spacing:  " ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( calibrationLabel, (char *) UxParameterDialogContext );


	/* Creation of calibrationText */
	calibrationText = XtVaCreateManagedWidget( "calibrationText",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 90,
			XmNx, 150,
			XmNy, 270,
			XmNheight, 30,
			XmNvalue, "3.137",
			XmNleftOffset, 170,
			XmNleftAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("8x13" ),
			NULL );
	XtAddCallback( calibrationText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_calibrationText,
		(XtPointer) UxParameterDialogContext );

	UxPutContext( calibrationText, (char *) UxParameterDialogContext );


	XtAddCallback( parameterDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxParameterDialogContext);


	return ( parameterDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_parameterDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCparameterDialog     *UxContext;
	static int		_Uxinit = 0;

	UxParameterDialogContext = UxContext =
		(_UxCparameterDialog *) UxNewContext( sizeof(_UxCparameterDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxparameterDialog_setRotation_Id = UxMethodRegister( _UxIfClassId,
				UxparameterDialog_setRotation_Name,
				(void (*)()) _parameterDialog_setRotation );
		UxparameterDialog_setWave_Id = UxMethodRegister( _UxIfClassId,
				UxparameterDialog_setWave_Name,
				(void (*)()) _parameterDialog_setWave );
		UxparameterDialog_setCentre_Id = UxMethodRegister( _UxIfClassId,
				UxparameterDialog_setCentre_Name,
				(void (*)()) _parameterDialog_setCentre );
		UxparameterDialog_setDistance_Id = UxMethodRegister( _UxIfClassId,
				UxparameterDialog_setDistance_Name,
				(void (*)()) _parameterDialog_setDistance );
		UxparameterDialog_setTilt_Id = UxMethodRegister( _UxIfClassId,
				UxparameterDialog_setTilt_Name,
				(void (*)()) _parameterDialog_setTilt );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_parameterDialog();

	waveChanged = distanceChanged = centreChanged = rotationChanged = tiltChanged = calibrationChanged = False;
	firstLook = True;
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

