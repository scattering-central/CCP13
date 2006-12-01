
/*******************************************************************************
       parameterDialog.h
       This header file is included by parameterDialog.c

*******************************************************************************/

#ifndef	_PARAMETERDIALOG_INCLUDED
#define	_PARAMETERDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef parameterDialog_setRotation
#define parameterDialog_setRotation( UxThis, pEnv, valueX, valueY, valueZ ) \
	((void(*)())UxMethodLookup(UxThis, UxparameterDialog_setRotation_Id,\
			UxparameterDialog_setRotation_Name)) \
		( UxThis, pEnv, valueX, valueY, valueZ )
#endif

#ifndef parameterDialog_setWave
#define parameterDialog_setWave( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxparameterDialog_setWave_Id,\
			UxparameterDialog_setWave_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef parameterDialog_setCentre
#define parameterDialog_setCentre( UxThis, pEnv, valX, valY ) \
	((void(*)())UxMethodLookup(UxThis, UxparameterDialog_setCentre_Id,\
			UxparameterDialog_setCentre_Name)) \
		( UxThis, pEnv, valX, valY )
#endif

#ifndef parameterDialog_setDistance
#define parameterDialog_setDistance( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxparameterDialog_setDistance_Id,\
			UxparameterDialog_setDistance_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef parameterDialog_setTilt
#define parameterDialog_setTilt( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxparameterDialog_setTilt_Id,\
			UxparameterDialog_setTilt_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxparameterDialog_setRotation_Id;
extern char*	UxparameterDialog_setRotation_Name;
extern int	UxparameterDialog_setWave_Id;
extern char*	UxparameterDialog_setWave_Name;
extern int	UxparameterDialog_setCentre_Id;
extern char*	UxparameterDialog_setCentre_Name;
extern int	UxparameterDialog_setDistance_Id;
extern char*	UxparameterDialog_setDistance_Name;
extern int	UxparameterDialog_setTilt_Id;
extern char*	UxparameterDialog_setTilt_Name;

/*******************************************************************************
       The definition of the context structure:
       If you create multiple copies of your interface, the context
       structure ensures that your callbacks use the variables for the
       correct copy.

       For each swidget in the interface, each argument to the Interface
       function, and each variable in the Interface Specific section of the
       Declarations Editor, there is an entry in the context structure
       and a #define.  The #define makes the variable name refer to the
       corresponding entry in the context structure.
*******************************************************************************/

typedef	struct
{
	Widget	UxparameterDialog;
	Widget	Uxform2;
	Widget	UxwaveLabel;
	Widget	UxwaveText;
	Widget	UxdistanceLabel;
	Widget	UxdistanceText;
	Widget	UxcentreXLabel;
	Widget	UxcentreXText;
	Widget	UxcentreYLabel;
	Widget	UxcentreYText;
	Widget	UxdetectorRotLabel;
	Widget	UxdetectorRotText;
	Widget	UxdetectorTwistText;
	Widget	UxdetectorTwistLabel;
	Widget	UxdetectorTiltText;
	Widget	UxdetectorTiltLabel;
	Widget	UxspecimenTiltText;
	Widget	UxspecimenTiltLabel;
	Widget	UxcalibrationLabel;
	Widget	UxcalibrationText;
	Boolean	UxwaveChanged;
	Boolean	UxdistanceChanged;
	Boolean	UxcentreChanged;
	Boolean	UxrotationChanged;
	Boolean	UxtiltChanged;
	Boolean	UxcalibrationChanged;
	Boolean	UxfirstLook;
	char	UxtextBuf[80];
	swidget	UxUxParent;
} _UxCparameterDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCparameterDialog     *UxParameterDialogContext;
#define parameterDialog         UxParameterDialogContext->UxparameterDialog
#define form2                   UxParameterDialogContext->Uxform2
#define waveLabel               UxParameterDialogContext->UxwaveLabel
#define waveText                UxParameterDialogContext->UxwaveText
#define distanceLabel           UxParameterDialogContext->UxdistanceLabel
#define distanceText            UxParameterDialogContext->UxdistanceText
#define centreXLabel            UxParameterDialogContext->UxcentreXLabel
#define centreXText             UxParameterDialogContext->UxcentreXText
#define centreYLabel            UxParameterDialogContext->UxcentreYLabel
#define centreYText             UxParameterDialogContext->UxcentreYText
#define detectorRotLabel        UxParameterDialogContext->UxdetectorRotLabel
#define detectorRotText         UxParameterDialogContext->UxdetectorRotText
#define detectorTwistText       UxParameterDialogContext->UxdetectorTwistText
#define detectorTwistLabel      UxParameterDialogContext->UxdetectorTwistLabel
#define detectorTiltText        UxParameterDialogContext->UxdetectorTiltText
#define detectorTiltLabel       UxParameterDialogContext->UxdetectorTiltLabel
#define specimenTiltText        UxParameterDialogContext->UxspecimenTiltText
#define specimenTiltLabel       UxParameterDialogContext->UxspecimenTiltLabel
#define calibrationLabel        UxParameterDialogContext->UxcalibrationLabel
#define calibrationText         UxParameterDialogContext->UxcalibrationText
#define waveChanged             UxParameterDialogContext->UxwaveChanged
#define distanceChanged         UxParameterDialogContext->UxdistanceChanged
#define centreChanged           UxParameterDialogContext->UxcentreChanged
#define rotationChanged         UxParameterDialogContext->UxrotationChanged
#define tiltChanged             UxParameterDialogContext->UxtiltChanged
#define calibrationChanged      UxParameterDialogContext->UxcalibrationChanged
#define firstLook               UxParameterDialogContext->UxfirstLook
#define textBuf                 UxParameterDialogContext->UxtextBuf
#define UxParent                UxParameterDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_parameterDialog( swidget _UxUxParent );

#endif	/* _PARAMETERDIALOG_INCLUDED */
