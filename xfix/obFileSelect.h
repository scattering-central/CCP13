
/*******************************************************************************
       obFileSelect.h
       This header file is included by obFileSelect.c

*******************************************************************************/

#ifndef	_OBFILESELECT_INCLUDED
#define	_OBFILESELECT_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef obFileSelect_readHeader
#define obFileSelect_readHeader( UxThis, pEnv, file, mem, np, nr, nf, ne, nd ) \
	((int(*)())UxMethodLookup(UxThis, UxobFileSelect_readHeader_Id,\
			UxobFileSelect_readHeader_Name)) \
		( UxThis, pEnv, file, mem, np, nr, nf, ne, nd )
#endif

#ifndef obFileSelect_OKfunction
#define obFileSelect_OKfunction( UxThis, pEnv, okfunc ) \
	((void(*)())UxMethodLookup(UxThis, UxobFileSelect_OKfunction_Id,\
			UxobFileSelect_OKfunction_Name)) \
		( UxThis, pEnv, okfunc )
#endif

#ifndef obFileSelect_show
#define obFileSelect_show( UxThis, pEnv, found ) \
	((void(*)())UxMethodLookup(UxThis, UxobFileSelect_show_Id,\
			UxobFileSelect_show_Name)) \
		( UxThis, pEnv, found )
#endif

#ifndef obFileSelect_defaults
#define obFileSelect_defaults( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxobFileSelect_defaults_Id,\
			UxobFileSelect_defaults_Name)) \
		( UxThis, pEnv )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxobFileSelect_readHeader_Id;
extern char*	UxobFileSelect_readHeader_Name;
extern int	UxobFileSelect_OKfunction_Id;
extern char*	UxobFileSelect_OKfunction_Name;
extern int	UxobFileSelect_show_Id;
extern char*	UxobFileSelect_show_Name;
extern int	UxobFileSelect_defaults_Id;
extern char*	UxobFileSelect_defaults_Name;

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
	Widget	UxobFileSelect;
	Widget	Uxform1;
	Widget	Uxlabel2;
	Widget	Uxlabel3;
	Widget	Uxlabel4;
	Widget	UxtextField1;
	Widget	UxtextField2;
	Widget	UxtextField3;
	Widget	Uxdata1;
	Widget	Uxmenu1_p1_b1;
	Widget	Uxmenu1_p1_b2;
	Widget	Uxmenu1_p1_b3;
	Widget	Uxmenu1;
	Widget	Uxlabel1;
	Widget	Uxselection;
	Widget	Uxfilelist;
	Widget	Uxfiltertxt;
	char	*Uxfilename;
	int	Uxiffr;
	int	Uxilfr;
	int	Uxifinc;
	int	Uxfilenum;
	int	Uxnpix;
	int	Uxnrast;
	int	Uxnframe;
	int	Uxfendian;
	int	Uxdtype;
	vfptr	Uxok_function;
	swidget	UxUxParent;
} _UxCobFileSelect;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCobFileSelect        *UxObFileSelectContext;
#define obFileSelect            UxObFileSelectContext->UxobFileSelect
#define form1                   UxObFileSelectContext->Uxform1
#define label2                  UxObFileSelectContext->Uxlabel2
#define label3                  UxObFileSelectContext->Uxlabel3
#define label4                  UxObFileSelectContext->Uxlabel4
#define textField1              UxObFileSelectContext->UxtextField1
#define textField2              UxObFileSelectContext->UxtextField2
#define textField3              UxObFileSelectContext->UxtextField3
#define data1                   UxObFileSelectContext->Uxdata1
#define menu1_p1_b1             UxObFileSelectContext->Uxmenu1_p1_b1
#define menu1_p1_b2             UxObFileSelectContext->Uxmenu1_p1_b2
#define menu1_p1_b3             UxObFileSelectContext->Uxmenu1_p1_b3
#define menu1                   UxObFileSelectContext->Uxmenu1
#define label1                  UxObFileSelectContext->Uxlabel1
#define selection               UxObFileSelectContext->Uxselection
#define filelist                UxObFileSelectContext->Uxfilelist
#define filtertxt               UxObFileSelectContext->Uxfiltertxt
#define filename                UxObFileSelectContext->Uxfilename
#define iffr                    UxObFileSelectContext->Uxiffr
#define ilfr                    UxObFileSelectContext->Uxilfr
#define ifinc                   UxObFileSelectContext->Uxifinc
#define filenum                 UxObFileSelectContext->Uxfilenum
#define npix                    UxObFileSelectContext->Uxnpix
#define nrast                   UxObFileSelectContext->Uxnrast
#define nframe                  UxObFileSelectContext->Uxnframe
#define fendian                 UxObFileSelectContext->Uxfendian
#define dtype                   UxObFileSelectContext->Uxdtype
#define ok_function             UxObFileSelectContext->Uxok_function
#define UxParent                UxObFileSelectContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_obFileSelect( swidget _UxUxParent );

#endif	/* _OBFILESELECT_INCLUDED */
