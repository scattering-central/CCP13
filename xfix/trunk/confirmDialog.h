
/*******************************************************************************
       confirmDialog.h
       This header file is included by confirmDialog.c

*******************************************************************************/

#ifndef	_CONFIRMDIALOG_INCLUDED
#define	_CONFIRMDIALOG_INCLUDED

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
	Widget	UxconfirmDialog;
	char	*Uxhelpfile;
	swidget	UxUxParent;
} _UxCconfirmDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCconfirmDialog       *UxConfirmDialogContext;
#define confirmDialog           UxConfirmDialogContext->UxconfirmDialog
#define helpfile                UxConfirmDialogContext->Uxhelpfile
#define UxParent                UxConfirmDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_confirmDialog( swidget _UxUxParent );

#endif	/* _CONFIRMDIALOG_INCLUDED */
