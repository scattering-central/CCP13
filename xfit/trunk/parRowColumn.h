
/*******************************************************************************
       parRowColumn.h
       This header file is included by parRowColumn.c

*******************************************************************************/

#ifndef	_PARROWCOLUMN_INCLUDED
#define	_PARROWCOLUMN_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <X11/Shell.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef parRowColumn_set
#define parRowColumn_set( UxThis, pEnv, string ) \
	((int(*)())UxMethodLookup(UxThis, UxparRowColumn_set_Id,\
			UxparRowColumn_set_Name)) \
		( UxThis, pEnv, string )
#endif

#ifndef parRowColumn_getLimits
#define parRowColumn_getLimits( UxThis, pEnv, lim1, lim2 ) \
	((int(*)())UxMethodLookup(UxThis, UxparRowColumn_getLimits_Id,\
			UxparRowColumn_getLimits_Name)) \
		( UxThis, pEnv, lim1, lim2 )
#endif

#ifndef parRowColumn_remLimits
#define parRowColumn_remLimits( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxparRowColumn_remLimits_Id,\
			UxparRowColumn_remLimits_Name)) \
		( UxThis, pEnv )
#endif

#ifndef parRowColumn_setLimits
#define parRowColumn_setLimits( UxThis, pEnv, lim1, lim2 ) \
	((int(*)())UxMethodLookup(UxThis, UxparRowColumn_setLimits_Id,\
			UxparRowColumn_setLimits_Name)) \
		( UxThis, pEnv, lim1, lim2 )
#endif

#ifndef parRowColumn_sensitive
#define parRowColumn_sensitive( UxThis, pEnv, tf ) \
	((int(*)())UxMethodLookup(UxThis, UxparRowColumn_sensitive_Id,\
			UxparRowColumn_sensitive_Name)) \
		( UxThis, pEnv, tf )
#endif

#ifndef parRowColumn_checkVal
#define parRowColumn_checkVal( UxThis, pEnv, v ) \
	((int(*)())UxMethodLookup(UxThis, UxparRowColumn_checkVal_Id,\
			UxparRowColumn_checkVal_Name)) \
		( UxThis, pEnv, v )
#endif

#ifndef parRowColumn_getTie
#define parRowColumn_getTie( UxThis, pEnv, t_num, c_type, ih, ik, il ) \
	((int(*)())UxMethodLookup(UxThis, UxparRowColumn_getTie_Id,\
			UxparRowColumn_getTie_Name)) \
		( UxThis, pEnv, t_num, c_type, ih, ik, il )
#endif

#ifndef parRowColumn_remTie
#define parRowColumn_remTie( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxparRowColumn_remTie_Id,\
			UxparRowColumn_remTie_Name)) \
		( UxThis, pEnv )
#endif

#ifndef parRowColumn_getDescr
#define parRowColumn_getDescr( UxThis, pEnv ) \
	((char *(*)())UxMethodLookup(UxThis, UxparRowColumn_getDescr_Id,\
			UxparRowColumn_getDescr_Name)) \
		( UxThis, pEnv )
#endif

#ifndef parRowColumn_setTie
#define parRowColumn_setTie( UxThis, pEnv, t_num, c_type, ih, ik, il ) \
	((int(*)())UxMethodLookup(UxThis, UxparRowColumn_setTie_Id,\
			UxparRowColumn_setTie_Name)) \
		( UxThis, pEnv, t_num, c_type, ih, ik, il )
#endif

#ifndef parRowColumn_getState
#define parRowColumn_getState( UxThis, pEnv, istate ) \
	((int(*)())UxMethodLookup(UxThis, UxparRowColumn_getState_Id,\
			UxparRowColumn_getState_Name)) \
		( UxThis, pEnv, istate )
#endif

#ifndef parRowColumn_setState
#define parRowColumn_setState( UxThis, pEnv, istate ) \
	((int(*)())UxMethodLookup(UxThis, UxparRowColumn_setState_Id,\
			UxparRowColumn_setState_Name)) \
		( UxThis, pEnv, istate )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxparRowColumn_set_Id;
extern char*	UxparRowColumn_set_Name;
extern int	UxparRowColumn_getLimits_Id;
extern char*	UxparRowColumn_getLimits_Name;
extern int	UxparRowColumn_remLimits_Id;
extern char*	UxparRowColumn_remLimits_Name;
extern int	UxparRowColumn_setLimits_Id;
extern char*	UxparRowColumn_setLimits_Name;
extern int	UxparRowColumn_sensitive_Id;
extern char*	UxparRowColumn_sensitive_Name;
extern int	UxparRowColumn_checkVal_Id;
extern char*	UxparRowColumn_checkVal_Name;
extern int	UxparRowColumn_getTie_Id;
extern char*	UxparRowColumn_getTie_Name;
extern int	UxparRowColumn_remTie_Id;
extern char*	UxparRowColumn_remTie_Name;
extern int	UxparRowColumn_getDescr_Id;
extern char*	UxparRowColumn_getDescr_Name;
extern int	UxparRowColumn_setTie_Id;
extern char*	UxparRowColumn_setTie_Name;
extern int	UxparRowColumn_getState_Id;
extern char*	UxparRowColumn_getState_Name;
extern int	UxparRowColumn_setState_Id;
extern char*	UxparRowColumn_setState_Name;

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
	Widget	UxparRowColumn;
	Widget	UxparForm;
	Widget	UxlabelPar;
	Widget	UxtextVal;
	Widget	UxstateMenu;
	Widget	UxstateMenu_free1;
	Widget	UxstateMenu_set1;
	Widget	UxstateMenu_limited1;
	Widget	UxstateMenu_tied1;
	Widget	UxparMenu;
	Widget	UxlabelTieto;
	Widget	UxtextLimit1;
	Widget	UxlabelLimto;
	Widget	UxtextLimit2;
	int	Uxnum;
	int	Uxstate;
	int	Uxch;
	int	Uxck;
	int	Uxcl;
	int	Uxconstraint_type;
	int	Uxtie_num;
	double	Uxval;
	double	Uxlimit1;
	double	Uxlimit2;
	char	Uxdescription[20];
	swidget	UxUxParent;
	char	*Uxlabel;
	char	*Uxvalue;
	char	*Uxdescr;
} _UxCparRowColumn;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCparRowColumn        *UxParRowColumnContext;
#define parRowColumn            UxParRowColumnContext->UxparRowColumn
#define parForm                 UxParRowColumnContext->UxparForm
#define labelPar                UxParRowColumnContext->UxlabelPar
#define textVal                 UxParRowColumnContext->UxtextVal
#define stateMenu               UxParRowColumnContext->UxstateMenu
#define stateMenu_free1         UxParRowColumnContext->UxstateMenu_free1
#define stateMenu_set1          UxParRowColumnContext->UxstateMenu_set1
#define stateMenu_limited1      UxParRowColumnContext->UxstateMenu_limited1
#define stateMenu_tied1         UxParRowColumnContext->UxstateMenu_tied1
#define parMenu                 UxParRowColumnContext->UxparMenu
#define labelTieto              UxParRowColumnContext->UxlabelTieto
#define textLimit1              UxParRowColumnContext->UxtextLimit1
#define labelLimto              UxParRowColumnContext->UxlabelLimto
#define textLimit2              UxParRowColumnContext->UxtextLimit2
#define num                     UxParRowColumnContext->Uxnum
#define state                   UxParRowColumnContext->Uxstate
#define ch                      UxParRowColumnContext->Uxch
#define ck                      UxParRowColumnContext->Uxck
#define cl                      UxParRowColumnContext->Uxcl
#define constraint_type         UxParRowColumnContext->Uxconstraint_type
#define tie_num                 UxParRowColumnContext->Uxtie_num
#define val                     UxParRowColumnContext->Uxval
#define limit1                  UxParRowColumnContext->Uxlimit1
#define limit2                  UxParRowColumnContext->Uxlimit2
#define description             UxParRowColumnContext->Uxdescription
#define UxParent                UxParRowColumnContext->UxUxParent
#define label                   UxParRowColumnContext->Uxlabel
#define value                   UxParRowColumnContext->Uxvalue
#define descr                   UxParRowColumnContext->Uxdescr

#endif /* CONTEXT_MACRO_ACCESS */


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_parRowColumn( swidget _UxUxParent, char *_Uxlabel, char *_Uxvalue, char *_Uxdescr );

#endif	/* _PARROWCOLUMN_INCLUDED */
