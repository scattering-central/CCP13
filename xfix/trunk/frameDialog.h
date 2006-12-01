
/*******************************************************************************
       frameDialog.h
       This header file is included by frameDialog.c

*******************************************************************************/

#ifndef	_FRAMEDIALOG_INCLUDED
#define	_FRAMEDIALOG_INCLUDED

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
	Widget	UxframeDialog;
	Widget	Uxlabel8;
	Widget	UxframeField;
	Widget	UxpushButton1;
	Widget	UxpushButton2;
	swidget	UxUxParent;
} _UxCframeDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCframeDialog         *UxFrameDialogContext;
#define frameDialog             UxFrameDialogContext->UxframeDialog
#define label8                  UxFrameDialogContext->Uxlabel8
#define frameField              UxFrameDialogContext->UxframeField
#define pushButton1             UxFrameDialogContext->UxpushButton1
#define pushButton2             UxFrameDialogContext->UxpushButton2
#define UxParent                UxFrameDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_frameDialog( swidget _UxUxParent );

#endif	/* _FRAMEDIALOG_INCLUDED */
