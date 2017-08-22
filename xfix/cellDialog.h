
/*******************************************************************************
       cellDialog.h
       This header file is included by cellDialog.c

*******************************************************************************/

#ifndef	_CELLDIALOG_INCLUDED
#define	_CELLDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
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
	Widget	UxcellDialog;
	Widget	UxcellForm;
	Widget	UxaCellLabel;
	Widget	UxaCellText;
	Widget	UxbCellLabel;
	Widget	UxbCellText;
	Widget	UxcCellLabel;
	Widget	UxcCellText;
	Widget	UxalphaCellText;
	Widget	UxalphaCellLabel;
	Widget	UxbetaCellLabel;
	Widget	UxbetaCellText;
	Widget	UxgammaCellLabel;
	Widget	UxgammaCellText;
	Widget	UxphiXCellLabel;
	Widget	UxphiXCellText;
	Widget	UxphiZCellLabel;
	Widget	UxphiZCellText;
	Widget	UxminDCellLabel;
	Widget	UxminDCellText;
	Widget	UxmaxDCellLabel;
	Widget	UxmaxDCellText;
	Widget	Uxseparator2;
	Widget	UxspaceGroupLabel;
	Widget	UxspaceGroupText;
	swidget	UxUxParent;
} _UxCcellDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCcellDialog          *UxCellDialogContext;
#define cellDialog              UxCellDialogContext->UxcellDialog
#define cellForm                UxCellDialogContext->UxcellForm
#define aCellLabel              UxCellDialogContext->UxaCellLabel
#define aCellText               UxCellDialogContext->UxaCellText
#define bCellLabel              UxCellDialogContext->UxbCellLabel
#define bCellText               UxCellDialogContext->UxbCellText
#define cCellLabel              UxCellDialogContext->UxcCellLabel
#define cCellText               UxCellDialogContext->UxcCellText
#define alphaCellText           UxCellDialogContext->UxalphaCellText
#define alphaCellLabel          UxCellDialogContext->UxalphaCellLabel
#define betaCellLabel           UxCellDialogContext->UxbetaCellLabel
#define betaCellText            UxCellDialogContext->UxbetaCellText
#define gammaCellLabel          UxCellDialogContext->UxgammaCellLabel
#define gammaCellText           UxCellDialogContext->UxgammaCellText
#define phiXCellLabel           UxCellDialogContext->UxphiXCellLabel
#define phiXCellText            UxCellDialogContext->UxphiXCellText
#define phiZCellLabel           UxCellDialogContext->UxphiZCellLabel
#define phiZCellText            UxCellDialogContext->UxphiZCellText
#define minDCellLabel           UxCellDialogContext->UxminDCellLabel
#define minDCellText            UxCellDialogContext->UxminDCellText
#define maxDCellLabel           UxCellDialogContext->UxmaxDCellLabel
#define maxDCellText            UxCellDialogContext->UxmaxDCellText
#define separator2              UxCellDialogContext->Uxseparator2
#define spaceGroupLabel         UxCellDialogContext->UxspaceGroupLabel
#define spaceGroupText          UxCellDialogContext->UxspaceGroupText
#define UxParent                UxCellDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_cellDialog( swidget _UxUxParent );

#endif	/* _CELLDIALOG_INCLUDED */
