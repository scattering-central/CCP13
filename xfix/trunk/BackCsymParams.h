
/*******************************************************************************
       BackCsymParams.h
       This header file is included by BackCsymParams.c

*******************************************************************************/

#ifndef	_BACKCSYMPARAMS_INCLUDED
#define	_BACKCSYMPARAMS_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef BackCsymParams_getParams
#define BackCsymParams_getParams( UxThis, pEnv, error ) \
	((int(*)())UxMethodLookup(UxThis, UxBackCsymParams_getParams_Id,\
			UxBackCsymParams_getParams_Name)) \
		( UxThis, pEnv, error )
#endif

#ifndef BackCsymParams_setCentre
#define BackCsymParams_setCentre( UxThis, pEnv, xcen, ycen ) \
	((void(*)())UxMethodLookup(UxThis, UxBackCsymParams_setCentre_Id,\
			UxBackCsymParams_setCentre_Name)) \
		( UxThis, pEnv, xcen, ycen )
#endif

#ifndef BackCsymParams_setSize
#define BackCsymParams_setSize( UxThis, pEnv, np, nr ) \
	((void(*)())UxMethodLookup(UxThis, UxBackCsymParams_setSize_Id,\
			UxBackCsymParams_setSize_Name)) \
		( UxThis, pEnv, np, nr )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxBackCsymParams_getParams_Id;
extern char*	UxBackCsymParams_getParams_Name;
extern int	UxBackCsymParams_setCentre_Id;
extern char*	UxBackCsymParams_setCentre_Name;
extern int	UxBackCsymParams_setSize_Id;
extern char*	UxBackCsymParams_setSize_Name;

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
	Widget	UxBackCsymParams;
	Widget	Uxlabel22;
	Widget	UxlpixField2;
	Widget	Uxlabel23;
	Widget	UxhpixField2;
	Widget	Uxlabel24;
	Widget	Uxlabel25;
	Widget	UxsmoothField2;
	Widget	Uxlabel26;
	Widget	UxtensionField2;
	Widget	Uxlabel27;
	Widget	UxincField;
	Widget	Uxlabel16;
	Widget	UxrmaxField2;
	Widget	Uxlabel17;
	Widget	Uxlabel18;
	Widget	Uxlabel19;
	Widget	UxrminField2;
	Widget	UxxcentreField2;
	Widget	Uxlabel20;
	Widget	UxycentreField2;
	Widget	Uxlabel21;
	Widget	Uxseparator4;
	Widget	Uxlabel1;
	Widget	UxscrolledWindowText1;
	Widget	UxpushButton5;
	Widget	UxpushButton6;
	Widget	UxpushButton7;
	Widget	UxpushButton8;
	Widget	Uxlabel2;
	Widget	UxlowvalField2;
	Widget	Uxseparator5;
	Widget	Uxseparator6;
	Widget	Uxseparator7;
	double	Uxxcentre;
	double	Uxycentre;
	float	Uxdmin;
	float	Uxdmax;
	float	Uxdinc;
	float	Uxlowval;
	float	Uxlpix;
	float	Uxhpix;
	float	Uxsmoo;
	float	Uxtens;
	char	*UxsOutFile;
	int	Uxnpix;
	int	Uxnrast;
	swidget	UxUxParent;
} _UxCBackCsymParams;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCBackCsymParams      *UxBackCsymParamsContext;
#define BackCsymParams          UxBackCsymParamsContext->UxBackCsymParams
#define label22                 UxBackCsymParamsContext->Uxlabel22
#define lpixField2              UxBackCsymParamsContext->UxlpixField2
#define label23                 UxBackCsymParamsContext->Uxlabel23
#define hpixField2              UxBackCsymParamsContext->UxhpixField2
#define label24                 UxBackCsymParamsContext->Uxlabel24
#define label25                 UxBackCsymParamsContext->Uxlabel25
#define smoothField2            UxBackCsymParamsContext->UxsmoothField2
#define label26                 UxBackCsymParamsContext->Uxlabel26
#define tensionField2           UxBackCsymParamsContext->UxtensionField2
#define label27                 UxBackCsymParamsContext->Uxlabel27
#define incField                UxBackCsymParamsContext->UxincField
#define label16                 UxBackCsymParamsContext->Uxlabel16
#define rmaxField2              UxBackCsymParamsContext->UxrmaxField2
#define label17                 UxBackCsymParamsContext->Uxlabel17
#define label18                 UxBackCsymParamsContext->Uxlabel18
#define label19                 UxBackCsymParamsContext->Uxlabel19
#define rminField2              UxBackCsymParamsContext->UxrminField2
#define xcentreField2           UxBackCsymParamsContext->UxxcentreField2
#define label20                 UxBackCsymParamsContext->Uxlabel20
#define ycentreField2           UxBackCsymParamsContext->UxycentreField2
#define label21                 UxBackCsymParamsContext->Uxlabel21
#define separator4              UxBackCsymParamsContext->Uxseparator4
#define label1                  UxBackCsymParamsContext->Uxlabel1
#define scrolledWindowText1     UxBackCsymParamsContext->UxscrolledWindowText1
#define pushButton5             UxBackCsymParamsContext->UxpushButton5
#define pushButton6             UxBackCsymParamsContext->UxpushButton6
#define pushButton7             UxBackCsymParamsContext->UxpushButton7
#define pushButton8             UxBackCsymParamsContext->UxpushButton8
#define label2                  UxBackCsymParamsContext->Uxlabel2
#define lowvalField2            UxBackCsymParamsContext->UxlowvalField2
#define separator5              UxBackCsymParamsContext->Uxseparator5
#define separator6              UxBackCsymParamsContext->Uxseparator6
#define separator7              UxBackCsymParamsContext->Uxseparator7
#define xcentre                 UxBackCsymParamsContext->Uxxcentre
#define ycentre                 UxBackCsymParamsContext->Uxycentre
#define dmin                    UxBackCsymParamsContext->Uxdmin
#define dmax                    UxBackCsymParamsContext->Uxdmax
#define dinc                    UxBackCsymParamsContext->Uxdinc
#define lowval                  UxBackCsymParamsContext->Uxlowval
#define lpix                    UxBackCsymParamsContext->Uxlpix
#define hpix                    UxBackCsymParamsContext->Uxhpix
#define smoo                    UxBackCsymParamsContext->Uxsmoo
#define tens                    UxBackCsymParamsContext->Uxtens
#define sOutFile                UxBackCsymParamsContext->UxsOutFile
#define npix                    UxBackCsymParamsContext->Uxnpix
#define nrast                   UxBackCsymParamsContext->Uxnrast
#define UxParent                UxBackCsymParamsContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */

extern Widget	outfileField2;

/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_BackCsymParams( swidget _UxUxParent );

#endif	/* _BACKCSYMPARAMS_INCLUDED */
