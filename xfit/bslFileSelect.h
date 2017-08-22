
/*******************************************************************************
       bslFileSelect.h
       This header file is included by bslFileSelect.c

*******************************************************************************/

#ifndef	_BSLFILESELECT_INCLUDED
#define	_BSLFILESELECT_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#include "obFileSelect.h"
#ifndef bslFileSelect_readHeader
#define bslFileSelect_readHeader( UxThis, pEnv, file, mem, npixel, nraster, nframes ) \
	((int(*)())UxMethodLookup(UxThis, UxbslFileSelect_readHeader_Id,\
			UxbslFileSelect_readHeader_Name)) \
		( UxThis, pEnv, file, mem, npixel, nraster, nframes )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxbslFileSelect_readHeader_Id;
extern char*	UxbslFileSelect_readHeader_Name;

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
	_UxCobFileSelect UxobFileSelectPart;
	Widget	UxbslFileSelect;
	swidget	UxUxParent;
} _UxCbslFileSelect;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCbslFileSelect       *UxBslFileSelectContext;
#define UxObFileSelectContext   (&(UxBslFileSelectContext->UxobFileSelectPart))
#define bslFileSelect           UxBslFileSelectContext->UxbslFileSelect
#ifdef UxParent               
#undef UxParent               
#endif 
#define UxParent                UxBslFileSelectContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_bslFileSelect( swidget _UxUxParent );

#endif	/* _BSLFILESELECT_INCLUDED */
