
/*******************************************************************************
	peakRowColumn.c

       Associated Header file: peakRowColumn.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <X11/Shell.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/Label.h>
#include <Xm/Form.h>
#include <Xm/RowColumn.h>



static	int _UxIfClassId;
/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "peakRowColumn.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_peakRowColumn()
{
	Widget		_UxParent;
	char		*UxTmp0;


	/* Creation of peakRowColumn */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = XtVaCreatePopupShell( "peakRowColumn_shell",
			topLevelShellWidgetClass, UxTopLevel,
			XmNx, 0,
			XmNy, 0,
			XmNwidth, 300,
			XmNheight, 30,
			XmNtitle, "peakRowColumn",
			XmNiconName, "peakRowColumn",
			NULL );

	}

	peakRowColumn = XtVaCreateWidget( "peakRowColumn",
			xmRowColumnWidgetClass,
			_UxParent,
			XmNwidth, 300,
			XmNheight, 30,
			XmNmarginHeight, 0,
			XmNmarginWidth, 10,
			NULL );
	UxPutContext( peakRowColumn, (char *) UxPeakRowColumnContext );
	UxPutClassCode( peakRowColumn, _UxIfClassId );


	/* Creation of peakForm */
	peakForm = XtVaCreateManagedWidget( "peakForm",
			xmFormWidgetClass,
			peakRowColumn,
			XmNresizePolicy, XmRESIZE_NONE,
			NULL );
	UxPutContext( peakForm, (char *) UxPeakRowColumnContext );

	UxTmp0 = label1 ? label1 : "not set";

	/* Creation of labelPeak */
	labelPeak = XtVaCreateManagedWidget( "labelPeak",
			xmLabelWidgetClass,
			peakForm,
			XmNwidth, 100,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, UxTmp0 ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 0,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNrecomputeSize, FALSE,
			NULL );
	UxPutContext( labelPeak, (char *) UxPeakRowColumnContext );

	UxTmp0 = label2 ? label2 : "not set";

	/* Creation of labelPeaktype */
	labelPeaktype = XtVaCreateManagedWidget( "labelPeaktype",
			xmLabelWidgetClass,
			peakForm,
			XmNwidth, 100,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, UxTmp0 ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftOffset, 130,
			XmNrecomputeSize, FALSE,
			NULL );
	UxPutContext( labelPeaktype, (char *) UxPeakRowColumnContext );


	XtAddCallback( peakRowColumn, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxPeakRowColumnContext);


	return ( peakRowColumn );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_peakRowColumn( swidget _UxUxParent, char *_Uxlabel1, char *_Uxlabel2 )
{
	Widget                  rtrn;
	_UxCpeakRowColumn       *UxContext;
	static int		_Uxinit = 0;

	UxPeakRowColumnContext = UxContext =
		(_UxCpeakRowColumn *) UxNewContext( sizeof(_UxCpeakRowColumn), False );

	UxParent = _UxUxParent;
	label1 = _Uxlabel1;
	label2 = _Uxlabel2;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_peakRowColumn();

	XtVaSetValues (labelPeak,
	               XmNlabelString, XmStringCreateLtoR (label1, XmSTRING_DEFAULT_CHARSET),
	               NULL);
	XtVaSetValues (labelPeaktype,
	               XmNlabelString, XmStringCreateLtoR (label2, XmSTRING_DEFAULT_CHARSET),
	               NULL);
	
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

