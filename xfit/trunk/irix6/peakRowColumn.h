
/*******************************************************************************
       peakRowColumn.h
       This header file is included by peakRowColumn.c

*******************************************************************************/

#ifndef	_PEAKROWCOLUMN_INCLUDED
#define	_PEAKROWCOLUMN_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <X11/Shell.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

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
	Widget	UxpeakRowColumn;
	Widget	UxpeakForm;
	Widget	UxlabelPeak;
	Widget	UxlabelPeaktype;
	swidget	UxUxParent;
	char	*Uxlabel1;
	char	*Uxlabel2;
} _UxCpeakRowColumn;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCpeakRowColumn       *UxPeakRowColumnContext;
#define peakRowColumn           UxPeakRowColumnContext->UxpeakRowColumn
#define peakForm                UxPeakRowColumnContext->UxpeakForm
#define labelPeak               UxPeakRowColumnContext->UxlabelPeak
#define labelPeaktype           UxPeakRowColumnContext->UxlabelPeaktype
#define UxParent                UxPeakRowColumnContext->UxUxParent
#define label1                  UxPeakRowColumnContext->Uxlabel1
#define label2                  UxPeakRowColumnContext->Uxlabel2

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_peakRowColumn( swidget _UxUxParent, char *_Uxlabel1, char *_Uxlabel2 );

#endif	/* _PEAKROWCOLUMN_INCLUDED */
