
/*******************************************************************************
       setupDialog.h
       This header file is included by setupDialog.c

*******************************************************************************/

#ifndef	_SETUPDIALOG_INCLUDED
#define	_SETUPDIALOG_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#ifndef setupDialog_setParRC
#define setupDialog_setParRC( UxThis, pEnv, n, string ) \
	((void(*)())UxMethodLookup(UxThis, UxsetupDialog_setParRC_Id,\
			UxsetupDialog_setParRC_Name)) \
		( UxThis, pEnv, n, string )
#endif

#ifndef setupDialog_sensitive
#define setupDialog_sensitive( UxThis, pEnv, tf ) \
	((int(*)())UxMethodLookup(UxThis, UxsetupDialog_sensitive_Id,\
			UxsetupDialog_sensitive_Name)) \
		( UxThis, pEnv, tf )
#endif

#ifndef setupDialog_getLimitsN
#define setupDialog_getLimitsN( UxThis, pEnv, n, lim1, lim2 ) \
	((void(*)())UxMethodLookup(UxThis, UxsetupDialog_getLimitsN_Id,\
			UxsetupDialog_getLimitsN_Name)) \
		( UxThis, pEnv, n, lim1, lim2 )
#endif

#ifndef setupDialog_setLimitsN
#define setupDialog_setLimitsN( UxThis, pEnv, n, lim1, lim2 ) \
	((void(*)())UxMethodLookup(UxThis, UxsetupDialog_setLimitsN_Id,\
			UxsetupDialog_setLimitsN_Name)) \
		( UxThis, pEnv, n, lim1, lim2 )
#endif

#ifndef setupDialog_quit
#define setupDialog_quit( UxThis, pEnv ) \
	((int(*)())UxMethodLookup(UxThis, UxsetupDialog_quit_Id,\
			UxsetupDialog_quit_Name)) \
		( UxThis, pEnv )
#endif

#ifndef setupDialog_reinit
#define setupDialog_reinit( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxsetupDialog_reinit_Id,\
			UxsetupDialog_reinit_Name)) \
		( UxThis, pEnv )
#endif

#ifndef setupDialog_checkValN
#define setupDialog_checkValN( UxThis, pEnv, n, v ) \
	((int(*)())UxMethodLookup(UxThis, UxsetupDialog_checkValN_Id,\
			UxsetupDialog_checkValN_Name)) \
		( UxThis, pEnv, n, v )
#endif

#ifndef setupDialog_getTieN
#define setupDialog_getTieN( UxThis, pEnv, n, t_num, c_type, ih, ik, il ) \
	((void(*)())UxMethodLookup(UxThis, UxsetupDialog_getTieN_Id,\
			UxsetupDialog_getTieN_Name)) \
		( UxThis, pEnv, n, t_num, c_type, ih, ik, il )
#endif

#ifndef setupDialog_getDescrN
#define setupDialog_getDescrN( UxThis, pEnv, n ) \
	((char*(*)())UxMethodLookup(UxThis, UxsetupDialog_getDescrN_Id,\
			UxsetupDialog_getDescrN_Name)) \
		( UxThis, pEnv, n )
#endif

#ifndef setupDialog_setTieN
#define setupDialog_setTieN( UxThis, pEnv, n, t_num, c_type, ih, ik, il ) \
	((void(*)())UxMethodLookup(UxThis, UxsetupDialog_setTieN_Id,\
			UxsetupDialog_setTieN_Name)) \
		( UxThis, pEnv, n, t_num, c_type, ih, ik, il )
#endif

#ifndef setupDialog_getStateN
#define setupDialog_getStateN( UxThis, pEnv, n, istate ) \
	((void(*)())UxMethodLookup(UxThis, UxsetupDialog_getStateN_Id,\
			UxsetupDialog_getStateN_Name)) \
		( UxThis, pEnv, n, istate )
#endif

#ifndef setupDialog_setStateN
#define setupDialog_setStateN( UxThis, pEnv, n, istate ) \
	((void(*)())UxMethodLookup(UxThis, UxsetupDialog_setStateN_Id,\
			UxsetupDialog_setStateN_Name)) \
		( UxThis, pEnv, n, istate )
#endif

#ifndef setupDialog_set
#define setupDialog_set( UxThis, pEnv, string ) \
	((int(*)())UxMethodLookup(UxThis, UxsetupDialog_set_Id,\
			UxsetupDialog_set_Name)) \
		( UxThis, pEnv, string )
#endif

#ifndef setupDialog_put
#define setupDialog_put( UxThis, pEnv, string ) \
	((int(*)())UxMethodLookup(UxThis, UxsetupDialog_put_Id,\
			UxsetupDialog_put_Name)) \
		( UxThis, pEnv, string )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxsetupDialog_setParRC_Id;
extern char*	UxsetupDialog_setParRC_Name;
extern int	UxsetupDialog_sensitive_Id;
extern char*	UxsetupDialog_sensitive_Name;
extern int	UxsetupDialog_getLimitsN_Id;
extern char*	UxsetupDialog_getLimitsN_Name;
extern int	UxsetupDialog_setLimitsN_Id;
extern char*	UxsetupDialog_setLimitsN_Name;
extern int	UxsetupDialog_quit_Id;
extern char*	UxsetupDialog_quit_Name;
extern int	UxsetupDialog_reinit_Id;
extern char*	UxsetupDialog_reinit_Name;
extern int	UxsetupDialog_checkValN_Id;
extern char*	UxsetupDialog_checkValN_Name;
extern int	UxsetupDialog_getTieN_Id;
extern char*	UxsetupDialog_getTieN_Name;
extern int	UxsetupDialog_getDescrN_Id;
extern char*	UxsetupDialog_getDescrN_Name;
extern int	UxsetupDialog_setTieN_Id;
extern char*	UxsetupDialog_setTieN_Name;
extern int	UxsetupDialog_getStateN_Id;
extern char*	UxsetupDialog_getStateN_Name;
extern int	UxsetupDialog_setStateN_Id;
extern char*	UxsetupDialog_setStateN_Name;
extern int	UxsetupDialog_set_Id;
extern char*	UxsetupDialog_set_Name;
extern int	UxsetupDialog_put_Id;
extern char*	UxsetupDialog_put_Name;

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
	Widget	UxscrolledWindow2;
	Widget	Uxform3;
	Widget	UxpushButton_plot;
	Widget	UxpushButton_step;
	Widget	UxpushButton_run;
	Widget	Uxseparator1;
	Widget	UxstepLabel;
	Widget	UxstepText;
	Widget	UxrunmaxLabel;
	Widget	UxrunmaxText;
	Widget	UxchitestLabel;
	Widget	UxchitestText;
	Widget	UxautowarnLabel;
	Widget	UxautowarnText;
	int	Uxnpar;
	int	Uxnpeak;
	int	Uxfexp;
	int	Uxcurrent_y;
	swidget	Uxpeak_rowColInstance[20];
	swidget	Uxseparator;
	swidget	UxlabelBack_poly_degree;
	swidget	UxlabelBack_exp_comp;
	swidget	Uxpar_rowColInstance[51];
	Boolean	UxstepitsChanged;
	Boolean	UxmaxitsChanged;
	Boolean	UxchitestChanged;
	Boolean	UxautowarnChanged;
	swidget	UxUxParent;
} _UxCsetupDialog;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCsetupDialog         *UxSetupDialogContext;
#define scrolledWindow2         UxSetupDialogContext->UxscrolledWindow2
#define form3                   UxSetupDialogContext->Uxform3
#define pushButton_plot         UxSetupDialogContext->UxpushButton_plot
#define pushButton_step         UxSetupDialogContext->UxpushButton_step
#define pushButton_run          UxSetupDialogContext->UxpushButton_run
#define separator1              UxSetupDialogContext->Uxseparator1
#define stepLabel               UxSetupDialogContext->UxstepLabel
#define stepText                UxSetupDialogContext->UxstepText
#define runmaxLabel             UxSetupDialogContext->UxrunmaxLabel
#define runmaxText              UxSetupDialogContext->UxrunmaxText
#define chitestLabel            UxSetupDialogContext->UxchitestLabel
#define chitestText             UxSetupDialogContext->UxchitestText
#define autowarnLabel           UxSetupDialogContext->UxautowarnLabel
#define autowarnText            UxSetupDialogContext->UxautowarnText
#define npar                    UxSetupDialogContext->Uxnpar
#define npeak                   UxSetupDialogContext->Uxnpeak
#define fexp                    UxSetupDialogContext->Uxfexp
#define current_y               UxSetupDialogContext->Uxcurrent_y
#define peak_rowColInstance     UxSetupDialogContext->Uxpeak_rowColInstance
#define separator               UxSetupDialogContext->Uxseparator
#define labelBack_poly_degree   UxSetupDialogContext->UxlabelBack_poly_degree
#define labelBack_exp_comp      UxSetupDialogContext->UxlabelBack_exp_comp
#define par_rowColInstance      UxSetupDialogContext->Uxpar_rowColInstance
#define stepitsChanged          UxSetupDialogContext->UxstepitsChanged
#define maxitsChanged           UxSetupDialogContext->UxmaxitsChanged
#define chitestChanged          UxSetupDialogContext->UxchitestChanged
#define autowarnChanged         UxSetupDialogContext->UxautowarnChanged
#define UxParent                UxSetupDialogContext->UxUxParent

#endif /* CONTEXT_MACRO_ACCESS */

extern Widget	setupDialog;

/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_setupDialog( swidget _UxUxParent );

#endif	/* _SETUPDIALOG_INCLUDED */
