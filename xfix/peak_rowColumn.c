
/*******************************************************************************
	peak_rowColumn.c

       Associated Header file: peak_rowColumn.h
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
#include <Xm/RowColumn.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#define CONTEXT_MACRO_ACCESS 1
#include "peak_rc.h"
#undef CONTEXT_MACRO_ACCESS


static	int _UxIfClassId;
/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "peak_rowColumn.h"
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
			XmNx, 810,
			XmNy, 130,
			XmNwidth, 300,
			XmNheight, 30,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "peakRowColumn",
			XmNiconName, "peakRowColumn",
			NULL );

	}

	peakRowColumn = XtVaCreateWidget( "peakRowColumn",
			xmRowColumnWidgetClass,
			_UxParent,
			XmNunitType, XmPIXELS,
			XmNwidth, 300,
			XmNheight, 30,
			XmNpacking, XmPACK_NONE,
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			NULL );
	UxPutContext( peakRowColumn, (char *) UxPeakRowColumnContext );

	UxTmp0 = label1 ? label1 : "not set";

	/* Creation of labelPeak */
	labelPeak = XtVaCreateManagedWidget( "labelPeak",
			xmLabelWidgetClass,
			peakRowColumn,
			XmNx, 10,
			XmNy, 0,
			XmNwidth, 100,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, UxTmp0 ),
			XmNmarginTop, 0,
			XmNrecomputeSize, FALSE,
			XmNfontList, UxConvertFontList( "8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			NULL );
	UxPutContext( labelPeak, (char *) UxPeakRowColumnContext );

	UxTmp0 = label2 ? label2 : "not set";

	/* Creation of labelPeaktype */
	labelPeaktype = XtVaCreateManagedWidget( "labelPeaktype",
			xmLabelWidgetClass,
			peakRowColumn,
			XmNx, 130,
			XmNy, 0,
			XmNwidth, 100,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, UxTmp0 ),
			XmNmarginTop, 0,
			XmNrecomputeSize, FALSE,
			XmNfontList, UxConvertFontList( "8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
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
	UxPutClassCode( peakRowColumn, _UxIfClassId );

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

