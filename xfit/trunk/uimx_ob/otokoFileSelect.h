
/*******************************************************************************
       otokoFileSelect.h
       This header file is included by otokoFileSelect.c

*******************************************************************************/

#ifndef	_OTOKOFILESELECT_INCLUDED
#define	_OTOKOFILESELECT_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#include "obFileSelect.h"
#ifndef otokoFileSelect_readHeader
#define otokoFileSelect_readHeader( UxThis, pEnv, file, mem, npixel, nraster, nframes ) \
	((int(*)())UxMethodLookup(UxThis, UxotokoFileSelect_readHeader_Id,\
			UxotokoFileSelect_readHeader_Name)) \
		( UxThis, pEnv, file, mem, npixel, nraster, nframes )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxotokoFileSelect_readHeader_Id;
extern char*	UxotokoFileSelect_readHeader_Name;

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
	Widget	UxotokoFileSelect;
	swidget	UxUxParent;
} _UxCotokoFileSelect;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCotokoFileSelect     *UxOtokoFileSelectContext;
#define UxObFileSelectContext   (&(UxOtokoFileSelectContext->UxobFileSelectPart))
#define otokoFileSelect         UxOtokoFileSelectContext->UxotokoFileSelect
#ifdef UxParent               
#undef UxParent               
#endif 
#define UxParent                UxOtokoFileSelectContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_otokoFileSelect( swidget _UxUxParent );

#endif	/* _OTOKOFILESELECT_INCLUDED */
