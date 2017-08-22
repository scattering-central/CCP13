
/*******************************************************************************
       FileSelection.h
       This header file is included by FileSelection.c

*******************************************************************************/

#ifndef	_FILESELECTION_INCLUDED
#define	_FILESELECTION_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef FileSelection_set
#define FileSelection_set( UxThis, pEnv, sw1, Filter1, title1, mustmatch, editable, type1, mult1, bsl1 ) \
	((void(*)())UxMethodLookup(UxThis, UxFileSelection_set_Id,\
			UxFileSelection_set_Name)) \
		( UxThis, pEnv, sw1, Filter1, title1, mustmatch, editable, type1, mult1, bsl1 )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxFileSelection_set_Id;
extern char*	UxFileSelection_set_Name;

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
	Widget	UxFileSelection;
	Widget	Uxselection;
	Widget	Uxfilelist;
	Widget	Uxfiltertxt;
	swidget	*Uxsw;
	int	Uxtype;
	int	Uxmult;
	int	Uxbsl;
	swidget	UxUxParent;
} _UxCFileSelection;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCFileSelection       *UxFileSelectionContext;
#define FileSelection           UxFileSelectionContext->UxFileSelection
#define selection               UxFileSelectionContext->Uxselection
#define filelist                UxFileSelectionContext->Uxfilelist
#define filtertxt               UxFileSelectionContext->Uxfiltertxt
#define sw                      UxFileSelectionContext->Uxsw
#define type                    UxFileSelectionContext->Uxtype
#define mult                    UxFileSelectionContext->Uxmult
#define bsl                     UxFileSelectionContext->Uxbsl
#define UxParent                UxFileSelectionContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_FileSelection( swidget _UxUxParent );

#endif	/* _FILESELECTION_INCLUDED */
