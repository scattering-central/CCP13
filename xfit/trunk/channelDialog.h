
/*******************************************************************************
       channelDialog.h
       This header file is included by channelDialog.c

*******************************************************************************/

#ifndef	_CHANNELDIALOG_INCLUDED
#define	_CHANNELDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef channelDialog_popup
#define channelDialog_popup( UxThis, pEnv, string ) \
	((int(*)())UxMethodLookup(UxThis, UxchannelDialog_popup_Id,\
			UxchannelDialog_popup_Name)) \
		( UxThis, pEnv, string )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxchannelDialog_popup_Id;
extern char*	UxchannelDialog_popup_Name;

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
	Widget	UxchannelDialog;
	Widget	UxrowColumn1;
	Widget	UxtextChann1;
	Widget	Uxlabel1;
	Widget	UxtextChann2;
	Widget	Uxlabel2;
	swidget	UxUxParent;
} _UxCchannelDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCchannelDialog       *UxChannelDialogContext;
#define channelDialog           UxChannelDialogContext->UxchannelDialog
#define rowColumn1              UxChannelDialogContext->UxrowColumn1
#define textChann1              UxChannelDialogContext->UxtextChann1
#define label1                  UxChannelDialogContext->Uxlabel1
#define textChann2              UxChannelDialogContext->UxtextChann2
#define label2                  UxChannelDialogContext->Uxlabel2
#define UxParent                UxChannelDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_channelDialog( swidget _UxUxParent );

#endif	/* _CHANNELDIALOG_INCLUDED */
