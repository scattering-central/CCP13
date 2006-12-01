
/*******************************************************************************
       BackWindowParams.h
       This header file is included by BackWindowParams.c

*******************************************************************************/

#ifndef	_BACKWINDOWPARAMS_INCLUDED
#define	_BACKWINDOWPARAMS_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef BackWindowParams_getParams
#define BackWindowParams_getParams( UxThis, pEnv, error ) \
	((int(*)())UxMethodLookup(UxThis, UxBackWindowParams_getParams_Id,\
			UxBackWindowParams_getParams_Name)) \
		( UxThis, pEnv, error )
#endif

#ifndef BackWindowParams_setCentre
#define BackWindowParams_setCentre( UxThis, pEnv, xcen, ycen ) \
	((void(*)())UxMethodLookup(UxThis, UxBackWindowParams_setCentre_Id,\
			UxBackWindowParams_setCentre_Name)) \
		( UxThis, pEnv, xcen, ycen )
#endif

#ifndef BackWindowParams_setSize
#define BackWindowParams_setSize( UxThis, pEnv, np, nr ) \
	((void(*)())UxMethodLookup(UxThis, UxBackWindowParams_setSize_Id,\
			UxBackWindowParams_setSize_Name)) \
		( UxThis, pEnv, np, nr )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxBackWindowParams_getParams_Id;
extern char*	UxBackWindowParams_getParams_Name;
extern int	UxBackWindowParams_setCentre_Id;
extern char*	UxBackWindowParams_setCentre_Name;
extern int	UxBackWindowParams_setSize_Id;
extern char*	UxBackWindowParams_setSize_Name;

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
	Widget	UxBackWindowParams;
	Widget	Uxlabel2;
	Widget	Uxlabel3;
	Widget	Uxlabel4;
	Widget	Uxlabel6;
	Widget	Uxlabel7;
	Widget	UxywinField;
	Widget	UxxwinField;
	Widget	UxysepField;
	Widget	UxxsepField;
	Widget	UxhpixField1;
	Widget	UxlpixField1;
	Widget	UxsmoothField1;
	Widget	UxtensionField1;
	Widget	Uxlabel9;
	Widget	Uxlabel10;
	Widget	Uxlabel11;
	Widget	Uxlabel12;
	Widget	UxpushButton1;
	Widget	UxpushButton2;
	Widget	Uxlabel8;
	Widget	UxrmaxField1;
	Widget	Uxlabel13;
	Widget	Uxlabel14;
	Widget	Uxlabel15;
	Widget	UxrminField1;
	Widget	Uxlabel43;
	Widget	Uxlabel44;
	Widget	Uxseparator8;
	Widget	UxxcentreField1;
	Widget	UxycentreField1;
	Widget	Uxlabel16;
	Widget	UxpushButton3;
	Widget	UxscrolledWindowText2;
	Widget	UxpushButton4;
	Widget	Uxlabel5;
	Widget	UxlowvalField1;
	Widget	Uxseparator1;
	Widget	Uxseparator2;
	Widget	Uxseparator3;
	double	Uxxcentre;
	double	Uxycentre;
	float	Uxdmin;
	float	Uxdmax;
	float	Uxlowval;
	int	Uxiwid;
	int	Uxjwid;
	int	Uxisep;
	int	Uxjsep;
	int	Uxwinlimit;
	float	Uxlpix;
	float	Uxhpix;
	float	Uxsmoo;
	float	Uxtens;
	char	*UxsOutFile;
	int	Uxnpix;
	int	Uxnrast;
	swidget	UxUxParent;
} _UxCBackWindowParams;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCBackWindowParams    *UxBackWindowParamsContext;
#define BackWindowParams        UxBackWindowParamsContext->UxBackWindowParams
#define label2                  UxBackWindowParamsContext->Uxlabel2
#define label3                  UxBackWindowParamsContext->Uxlabel3
#define label4                  UxBackWindowParamsContext->Uxlabel4
#define label6                  UxBackWindowParamsContext->Uxlabel6
#define label7                  UxBackWindowParamsContext->Uxlabel7
#define ywinField               UxBackWindowParamsContext->UxywinField
#define xwinField               UxBackWindowParamsContext->UxxwinField
#define ysepField               UxBackWindowParamsContext->UxysepField
#define xsepField               UxBackWindowParamsContext->UxxsepField
#define hpixField1              UxBackWindowParamsContext->UxhpixField1
#define lpixField1              UxBackWindowParamsContext->UxlpixField1
#define smoothField1            UxBackWindowParamsContext->UxsmoothField1
#define tensionField1           UxBackWindowParamsContext->UxtensionField1
#define label9                  UxBackWindowParamsContext->Uxlabel9
#define label10                 UxBackWindowParamsContext->Uxlabel10
#define label11                 UxBackWindowParamsContext->Uxlabel11
#define label12                 UxBackWindowParamsContext->Uxlabel12
#define pushButton1             UxBackWindowParamsContext->UxpushButton1
#define pushButton2             UxBackWindowParamsContext->UxpushButton2
#define label8                  UxBackWindowParamsContext->Uxlabel8
#define rmaxField1              UxBackWindowParamsContext->UxrmaxField1
#define label13                 UxBackWindowParamsContext->Uxlabel13
#define label14                 UxBackWindowParamsContext->Uxlabel14
#define label15                 UxBackWindowParamsContext->Uxlabel15
#define rminField1              UxBackWindowParamsContext->UxrminField1
#define label43                 UxBackWindowParamsContext->Uxlabel43
#define label44                 UxBackWindowParamsContext->Uxlabel44
#define separator8              UxBackWindowParamsContext->Uxseparator8
#define xcentreField1           UxBackWindowParamsContext->UxxcentreField1
#define ycentreField1           UxBackWindowParamsContext->UxycentreField1
#define label16                 UxBackWindowParamsContext->Uxlabel16
#define pushButton3             UxBackWindowParamsContext->UxpushButton3
#define scrolledWindowText2     UxBackWindowParamsContext->UxscrolledWindowText2
#define pushButton4             UxBackWindowParamsContext->UxpushButton4
#define label5                  UxBackWindowParamsContext->Uxlabel5
#define lowvalField1            UxBackWindowParamsContext->UxlowvalField1
#define separator1              UxBackWindowParamsContext->Uxseparator1
#define separator2              UxBackWindowParamsContext->Uxseparator2
#define separator3              UxBackWindowParamsContext->Uxseparator3
#define xcentre                 UxBackWindowParamsContext->Uxxcentre
#define ycentre                 UxBackWindowParamsContext->Uxycentre
#define dmin                    UxBackWindowParamsContext->Uxdmin
#define dmax                    UxBackWindowParamsContext->Uxdmax
#define lowval                  UxBackWindowParamsContext->Uxlowval
#define iwid                    UxBackWindowParamsContext->Uxiwid
#define jwid                    UxBackWindowParamsContext->Uxjwid
#define isep                    UxBackWindowParamsContext->Uxisep
#define jsep                    UxBackWindowParamsContext->Uxjsep
#define winlimit                UxBackWindowParamsContext->Uxwinlimit
#define lpix                    UxBackWindowParamsContext->Uxlpix
#define hpix                    UxBackWindowParamsContext->Uxhpix
#define smoo                    UxBackWindowParamsContext->Uxsmoo
#define tens                    UxBackWindowParamsContext->Uxtens
#define sOutFile                UxBackWindowParamsContext->UxsOutFile
#define npix                    UxBackWindowParamsContext->Uxnpix
#define nrast                   UxBackWindowParamsContext->Uxnrast
#define UxParent                UxBackWindowParamsContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */

extern Widget	outfileField1;

/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_BackWindowParams( swidget _UxUxParent );

#endif	/* _BACKWINDOWPARAMS_INCLUDED */
