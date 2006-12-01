
/*******************************************************************************
       ErrorMessage.h
       This header file is included by ErrorMessage.c

*******************************************************************************/

#ifndef	_ERRORMESSAGE_INCLUDED
#define	_ERRORMESSAGE_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef ErrorMessage_set
#define ErrorMessage_set( UxThis, pEnv, message ) \
	((void(*)())UxMethodLookup(UxThis, UxErrorMessage_set_Id,\
			UxErrorMessage_set_Name)) \
		( UxThis, pEnv, message )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxErrorMessage_set_Id;
extern char*	UxErrorMessage_set_Name;

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
	Widget	UxErrorMessage;
	Widget	Uxmlabel;
	swidget	UxUxParent;
} _UxCErrorMessage;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCErrorMessage        *UxErrorMessageContext;
#define ErrorMessage            UxErrorMessageContext->UxErrorMessage
#define mlabel                  UxErrorMessageContext->Uxmlabel
#define UxParent                UxErrorMessageContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_ErrorMessage( swidget _UxUxParent );

#endif	/* _ERRORMESSAGE_INCLUDED */
