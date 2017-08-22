
/*******************************************************************************
       CyclesParams.h
       This header file is included by CyclesParams.c

*******************************************************************************/

#ifndef	_CYCLESPARAMS_INCLUDED
#define	_CYCLESPARAMS_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef CyclesParams_GetParams
#define CyclesParams_GetParams( UxThis, pEnv, error ) \
	((int(*)())UxMethodLookup(UxThis, UxCyclesParams_GetParams_Id,\
			UxCyclesParams_GetParams_Name)) \
		( UxThis, pEnv, error )
#endif

#ifndef CyclesParams_setOutFile
#define CyclesParams_setOutFile( UxThis, pEnv, sFile ) \
	((void(*)())UxMethodLookup(UxThis, UxCyclesParams_setOutFile_Id,\
			UxCyclesParams_setOutFile_Name)) \
		( UxThis, pEnv, sFile )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxCyclesParams_GetParams_Id;
extern char*	UxCyclesParams_GetParams_Name;
extern int	UxCyclesParams_setOutFile_Id;
extern char*	UxCyclesParams_setOutFile_Name;

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
	Widget	UxCyclesParams;
	Widget	Uxlabel1;
	Widget	UxcyclesField;
	Widget	UxpushButton1;
	Widget	UxpushButton2;
	Widget	Uxlabel17;
	Widget	UxscrolledWindowText3;
	Widget	UxpushButton7;
	Widget	UxpushButton8;
	Widget	Uxseparator1;
	Widget	Uxseparator2;
	int	Uxmcycles;
	char	*UxsOutFile;
	swidget	UxUxParent;
} _UxCCyclesParams;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCCyclesParams        *UxCyclesParamsContext;
#define CyclesParams            UxCyclesParamsContext->UxCyclesParams
#define label1                  UxCyclesParamsContext->Uxlabel1
#define cyclesField             UxCyclesParamsContext->UxcyclesField
#define pushButton1             UxCyclesParamsContext->UxpushButton1
#define pushButton2             UxCyclesParamsContext->UxpushButton2
#define label17                 UxCyclesParamsContext->Uxlabel17
#define scrolledWindowText3     UxCyclesParamsContext->UxscrolledWindowText3
#define pushButton7             UxCyclesParamsContext->UxpushButton7
#define pushButton8             UxCyclesParamsContext->UxpushButton8
#define separator1              UxCyclesParamsContext->Uxseparator1
#define separator2              UxCyclesParamsContext->Uxseparator2
#define mcycles                 UxCyclesParamsContext->Uxmcycles
#define sOutFile                UxCyclesParamsContext->UxsOutFile
#define UxParent                UxCyclesParamsContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */

extern Widget	outfileField4;

/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_CyclesParams( swidget _UxUxParent );

#endif	/* _CYCLESPARAMS_INCLUDED */
