
/*******************************************************************************
       BackSmoothParams.h
       This header file is included by BackSmoothParams.c

*******************************************************************************/

#ifndef	_BACKSMOOTHPARAMS_INCLUDED
#define	_BACKSMOOTHPARAMS_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef BackSmoothParams_getParams
#define BackSmoothParams_getParams( UxThis, pEnv, error ) \
	((int(*)())UxMethodLookup(UxThis, UxBackSmoothParams_getParams_Id,\
			UxBackSmoothParams_getParams_Name)) \
		( UxThis, pEnv, error )
#endif

#ifndef BackSmoothParams_setCentre
#define BackSmoothParams_setCentre( UxThis, pEnv, xcen, ycen ) \
	((void(*)())UxMethodLookup(UxThis, UxBackSmoothParams_setCentre_Id,\
			UxBackSmoothParams_setCentre_Name)) \
		( UxThis, pEnv, xcen, ycen )
#endif

#ifndef BackSmoothParams_setSize
#define BackSmoothParams_setSize( UxThis, pEnv, np, nr ) \
	((void(*)())UxMethodLookup(UxThis, UxBackSmoothParams_setSize_Id,\
			UxBackSmoothParams_setSize_Name)) \
		( UxThis, pEnv, np, nr )
#endif

#ifndef BackSmoothParams_BoxcarSensitive
#define BackSmoothParams_BoxcarSensitive( UxThis, pEnv, i ) \
	((void(*)())UxMethodLookup(UxThis, UxBackSmoothParams_BoxcarSensitive_Id,\
			UxBackSmoothParams_BoxcarSensitive_Name)) \
		( UxThis, pEnv, i )
#endif

#ifndef BackSmoothParams_ImportSensitive
#define BackSmoothParams_ImportSensitive( UxThis, pEnv, i ) \
	((void(*)())UxMethodLookup(UxThis, UxBackSmoothParams_ImportSensitive_Id,\
			UxBackSmoothParams_ImportSensitive_Name)) \
		( UxThis, pEnv, i )
#endif

#ifndef BackSmoothParams_MergeSensitive
#define BackSmoothParams_MergeSensitive( UxThis, pEnv, i ) \
	((void(*)())UxMethodLookup(UxThis, UxBackSmoothParams_MergeSensitive_Id,\
			UxBackSmoothParams_MergeSensitive_Name)) \
		( UxThis, pEnv, i )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxBackSmoothParams_getParams_Id;
extern char*	UxBackSmoothParams_getParams_Name;
extern int	UxBackSmoothParams_setCentre_Id;
extern char*	UxBackSmoothParams_setCentre_Name;
extern int	UxBackSmoothParams_setSize_Id;
extern char*	UxBackSmoothParams_setSize_Name;
extern int	UxBackSmoothParams_BoxcarSensitive_Id;
extern char*	UxBackSmoothParams_BoxcarSensitive_Name;
extern int	UxBackSmoothParams_ImportSensitive_Id;
extern char*	UxBackSmoothParams_ImportSensitive_Name;
extern int	UxBackSmoothParams_MergeSensitive_Id;
extern char*	UxBackSmoothParams_MergeSensitive_Name;

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
	Widget	UxBackSmoothParams;
	Widget	Uxlabel28;
	Widget	Uxlabel29;
	Widget	UxsmoothLabel3;
	Widget	UxtensionLabel3;
	Widget	UxrmaxField3;
	Widget	UxyboxcarField;
	Widget	UxxboxcarField;
	Widget	UxtensionField3;
	Widget	UxsmoothField3;
	Widget	Uxlabel35;
	Widget	UxxboxcarLabel;
	Widget	UxyboxcarLabel;
	Widget	UxpushButton5;
	Widget	UxpushButton6;
	Widget	Uxlabel40;
	Widget	UxoptionMenu_p1;
	Widget	UxBoxcarButton;
	Widget	UxGaussButton;
	Widget	UxfunctionMenu;
	Widget	UxboxcarLabel;
	Widget	UxfwhmLabel;
	Widget	UxfwhmField;
	Widget	UxedgeButton;
	Widget	UxbackgroundLabel;
	Widget	UxbrowseButton;
	Widget	Uxseparator1;
	Widget	Uxlabel34;
	Widget	UxrminField3;
	Widget	UxxcentreField3;
	Widget	Uxlabel39;
	Widget	UxycentreField3;
	Widget	Uxlabel41;
	Widget	Uxlabel42;
	Widget	UxcyclesField;
	Widget	UxweightLabel;
	Widget	UxweightField;
	Widget	UxmergeButton;
	Widget	UxscrolledWindowText1;
	Widget	Uxlabel17;
	Widget	UxscrolledWindowText3;
	Widget	UxpushButton7;
	Widget	UxpushButton8;
	Widget	UxframeLabel;
	Widget	UxframeField;
	Widget	Uxlabel1;
	Widget	UxlowvalField3;
	Widget	Uxseparator9;
	Widget	Uxseparator10;
	Widget	Uxseparator11;
	Widget	Uxseparator12;
	double	Uxxcentre;
	double	Uxycentre;
	float	Uxdmin;
	float	Uxdmax;
	float	Uxlowval;
	float	Uxsmoo;
	float	Uxtens;
	float	Uxweight;
	int	Uxnpix;
	int	Uxnrast;
	int	Uxmaxfunc;
	char	Uxfuncopt[7];
	int	Uxpwid;
	int	Uxrwid;
	int	Uxncycles;
	char	*UxsInFile;
	char	*UxsOutFile;
	Boolean	Uxdoedge;
	Boolean	Uxmerge;
	int	Uxframe;
	int	Uxfendian;
	int	Uxdtype;
	swidget	UxUxParent;
} _UxCBackSmoothParams;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCBackSmoothParams    *UxBackSmoothParamsContext;
#define BackSmoothParams        UxBackSmoothParamsContext->UxBackSmoothParams
#define label28                 UxBackSmoothParamsContext->Uxlabel28
#define label29                 UxBackSmoothParamsContext->Uxlabel29
#define smoothLabel3            UxBackSmoothParamsContext->UxsmoothLabel3
#define tensionLabel3           UxBackSmoothParamsContext->UxtensionLabel3
#define rmaxField3              UxBackSmoothParamsContext->UxrmaxField3
#define yboxcarField            UxBackSmoothParamsContext->UxyboxcarField
#define xboxcarField            UxBackSmoothParamsContext->UxxboxcarField
#define tensionField3           UxBackSmoothParamsContext->UxtensionField3
#define smoothField3            UxBackSmoothParamsContext->UxsmoothField3
#define label35                 UxBackSmoothParamsContext->Uxlabel35
#define xboxcarLabel            UxBackSmoothParamsContext->UxxboxcarLabel
#define yboxcarLabel            UxBackSmoothParamsContext->UxyboxcarLabel
#define pushButton5             UxBackSmoothParamsContext->UxpushButton5
#define pushButton6             UxBackSmoothParamsContext->UxpushButton6
#define label40                 UxBackSmoothParamsContext->Uxlabel40
#define optionMenu_p1           UxBackSmoothParamsContext->UxoptionMenu_p1
#define BoxcarButton            UxBackSmoothParamsContext->UxBoxcarButton
#define GaussButton             UxBackSmoothParamsContext->UxGaussButton
#define functionMenu            UxBackSmoothParamsContext->UxfunctionMenu
#define boxcarLabel             UxBackSmoothParamsContext->UxboxcarLabel
#define fwhmLabel               UxBackSmoothParamsContext->UxfwhmLabel
#define fwhmField               UxBackSmoothParamsContext->UxfwhmField
#define edgeButton              UxBackSmoothParamsContext->UxedgeButton
#define backgroundLabel         UxBackSmoothParamsContext->UxbackgroundLabel
#define browseButton            UxBackSmoothParamsContext->UxbrowseButton
#define separator1              UxBackSmoothParamsContext->Uxseparator1
#define label34                 UxBackSmoothParamsContext->Uxlabel34
#define rminField3              UxBackSmoothParamsContext->UxrminField3
#define xcentreField3           UxBackSmoothParamsContext->UxxcentreField3
#define label39                 UxBackSmoothParamsContext->Uxlabel39
#define ycentreField3           UxBackSmoothParamsContext->UxycentreField3
#define label41                 UxBackSmoothParamsContext->Uxlabel41
#define label42                 UxBackSmoothParamsContext->Uxlabel42
#define cyclesField             UxBackSmoothParamsContext->UxcyclesField
#define weightLabel             UxBackSmoothParamsContext->UxweightLabel
#define weightField             UxBackSmoothParamsContext->UxweightField
#define mergeButton             UxBackSmoothParamsContext->UxmergeButton
#define scrolledWindowText1     UxBackSmoothParamsContext->UxscrolledWindowText1
#define label17                 UxBackSmoothParamsContext->Uxlabel17
#define scrolledWindowText3     UxBackSmoothParamsContext->UxscrolledWindowText3
#define pushButton7             UxBackSmoothParamsContext->UxpushButton7
#define pushButton8             UxBackSmoothParamsContext->UxpushButton8
#define frameLabel              UxBackSmoothParamsContext->UxframeLabel
#define frameField              UxBackSmoothParamsContext->UxframeField
#define label1                  UxBackSmoothParamsContext->Uxlabel1
#define lowvalField3            UxBackSmoothParamsContext->UxlowvalField3
#define separator9              UxBackSmoothParamsContext->Uxseparator9
#define separator10             UxBackSmoothParamsContext->Uxseparator10
#define separator11             UxBackSmoothParamsContext->Uxseparator11
#define separator12             UxBackSmoothParamsContext->Uxseparator12
#define xcentre                 UxBackSmoothParamsContext->Uxxcentre
#define ycentre                 UxBackSmoothParamsContext->Uxycentre
#define dmin                    UxBackSmoothParamsContext->Uxdmin
#define dmax                    UxBackSmoothParamsContext->Uxdmax
#define lowval                  UxBackSmoothParamsContext->Uxlowval
#define smoo                    UxBackSmoothParamsContext->Uxsmoo
#define tens                    UxBackSmoothParamsContext->Uxtens
#define weight                  UxBackSmoothParamsContext->Uxweight
#define npix                    UxBackSmoothParamsContext->Uxnpix
#define nrast                   UxBackSmoothParamsContext->Uxnrast
#define maxfunc                 UxBackSmoothParamsContext->Uxmaxfunc
#define funcopt                 UxBackSmoothParamsContext->Uxfuncopt
#define pwid                    UxBackSmoothParamsContext->Uxpwid
#define rwid                    UxBackSmoothParamsContext->Uxrwid
#define ncycles                 UxBackSmoothParamsContext->Uxncycles
#define sInFile                 UxBackSmoothParamsContext->UxsInFile
#define sOutFile                UxBackSmoothParamsContext->UxsOutFile
#define doedge                  UxBackSmoothParamsContext->Uxdoedge
#define merge                   UxBackSmoothParamsContext->Uxmerge
#define frame                   UxBackSmoothParamsContext->Uxframe
#define fendian                 UxBackSmoothParamsContext->Uxfendian
#define dtype                   UxBackSmoothParamsContext->Uxdtype
#define UxParent                UxBackSmoothParamsContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */

extern Widget	backgroundField;
extern Widget	outfileField3;

/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_BackSmoothParams( swidget _UxUxParent );

#endif	/* _BACKSMOOTHPARAMS_INCLUDED */
