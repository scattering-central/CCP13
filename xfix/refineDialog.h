
/*******************************************************************************
       refineDialog.h
       This header file is included by refineDialog.c

*******************************************************************************/

#ifndef	_REFINEDIALOG_INCLUDED
#define	_REFINEDIALOG_INCLUDED

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
	Widget	UxrefineDialog;
	Widget	Uxform4;
	Widget	UxrowColumn2;
	Widget	UxcentreButton;
	Widget	UxrotXButton;
	Widget	UxrotYButton;
	Widget	UxrotZButton;
	Widget	UxtiltButton;
	Boolean	UxrefineCentre;
	Boolean	UxrefineRotX;
	Boolean	UxrefineRotY;
	Boolean	UxrefineRotZ;
	Boolean	UxrefineTilt;
	swidget	UxUxParent;
} _UxCrefineDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCrefineDialog        *UxRefineDialogContext;
#define refineDialog            UxRefineDialogContext->UxrefineDialog
#define form4                   UxRefineDialogContext->Uxform4
#define rowColumn2              UxRefineDialogContext->UxrowColumn2
#define centreButton            UxRefineDialogContext->UxcentreButton
#define rotXButton              UxRefineDialogContext->UxrotXButton
#define rotYButton              UxRefineDialogContext->UxrotYButton
#define rotZButton              UxRefineDialogContext->UxrotZButton
#define tiltButton              UxRefineDialogContext->UxtiltButton
#define refineCentre            UxRefineDialogContext->UxrefineCentre
#define refineRotX              UxRefineDialogContext->UxrefineRotX
#define refineRotY              UxRefineDialogContext->UxrefineRotY
#define refineRotZ              UxRefineDialogContext->UxrefineRotZ
#define refineTilt              UxRefineDialogContext->UxrefineTilt
#define UxParent                UxRefineDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_refineDialog( swidget _UxUxParent );

#endif	/* _REFINEDIALOG_INCLUDED */
