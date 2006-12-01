
/*******************************************************************************
	parRowColumn.c

       Associated Header file: parRowColumn.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <X11/Shell.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/PushB.h>
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/Form.h>
#include <Xm/RowColumn.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>
#ifndef DESIGN_TIME
#include "tieDialog.h"
#include "limitDialog.h"
#endif

extern void command (char *, ...);

extern swidget tieD;
extern swidget limitD;


static	int _UxIfClassId;
int	UxparRowColumn_set_Id = -1;
char*	UxparRowColumn_set_Name = "set";
int	UxparRowColumn_getLimits_Id = -1;
char*	UxparRowColumn_getLimits_Name = "getLimits";
int	UxparRowColumn_remLimits_Id = -1;
char*	UxparRowColumn_remLimits_Name = "remLimits";
int	UxparRowColumn_setLimits_Id = -1;
char*	UxparRowColumn_setLimits_Name = "setLimits";
int	UxparRowColumn_sensitive_Id = -1;
char*	UxparRowColumn_sensitive_Name = "sensitive";
int	UxparRowColumn_checkVal_Id = -1;
char*	UxparRowColumn_checkVal_Name = "checkVal";
int	UxparRowColumn_getTie_Id = -1;
char*	UxparRowColumn_getTie_Name = "getTie";
int	UxparRowColumn_remTie_Id = -1;
char*	UxparRowColumn_remTie_Name = "remTie";
int	UxparRowColumn_getDescr_Id = -1;
char*	UxparRowColumn_getDescr_Name = "getDescr";
int	UxparRowColumn_setTie_Id = -1;
char*	UxparRowColumn_setTie_Name = "setTie";
int	UxparRowColumn_getState_Id = -1;
char*	UxparRowColumn_getState_Name = "getState";
int	UxparRowColumn_setState_Id = -1;
char*	UxparRowColumn_setState_Name = "setState";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "parRowColumn.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_parRowColumn_set( swidget UxThis, Environment * pEnv, char *string );
static int	_parRowColumn_getLimits( swidget UxThis, Environment * pEnv, double *lim1, double *lim2 );
static void	_parRowColumn_remLimits( swidget UxThis, Environment * pEnv );
static int	_parRowColumn_setLimits( swidget UxThis, Environment * pEnv, double lim1, double lim2 );
static int	_parRowColumn_sensitive( swidget UxThis, Environment * pEnv, Boolean tf );
static int	_parRowColumn_checkVal( swidget UxThis, Environment * pEnv, double *v );
static int	_parRowColumn_getTie( swidget UxThis, Environment * pEnv, int *t_num, int *c_type, int *ih, int *ik, int *il );
static void	_parRowColumn_remTie( swidget UxThis, Environment * pEnv );
static char *	_parRowColumn_getDescr( swidget UxThis, Environment * pEnv );
static int	_parRowColumn_setTie( swidget UxThis, Environment * pEnv, int t_num, int c_type, int ih, int ik, int il );
static int	_parRowColumn_getState( swidget UxThis, Environment * pEnv, int *istate );
static int	_parRowColumn_setState( swidget UxThis, Environment * pEnv, int istate );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_set( swidget UxThis, Environment * pEnv, char *string )
{
#include "par_rowColumn_set.c"
}

static int	_parRowColumn_set( swidget UxThis, Environment * pEnv, char *string )
{
	int			_Uxrtrn;
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_set( UxThis, pEnv, string );
	UxParRowColumnContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_getLimits( swidget UxThis, Environment * pEnv, double *lim1, double *lim2 )
{
#include "par_rowColumn_getLimits.c"
}

static int	_parRowColumn_getLimits( swidget UxThis, Environment * pEnv, double *lim1, double *lim2 )
{
	int			_Uxrtrn;
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getLimits( UxThis, pEnv, lim1, lim2 );
	UxParRowColumnContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_remLimits( swidget UxThis, Environment * pEnv )
{
#include "par_rowColumn_remLimits.c"
}

static void	_parRowColumn_remLimits( swidget UxThis, Environment * pEnv )
{
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_remLimits( UxThis, pEnv );
	UxParRowColumnContext = UxSaveCtx;
}

static int	Ux_setLimits( swidget UxThis, Environment * pEnv, double lim1, double lim2 )
{
#include "par_rowColumn_setLimits.c"
}

static int	_parRowColumn_setLimits( swidget UxThis, Environment * pEnv, double lim1, double lim2 )
{
	int			_Uxrtrn;
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_setLimits( UxThis, pEnv, lim1, lim2 );
	UxParRowColumnContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_sensitive( swidget UxThis, Environment * pEnv, Boolean tf )
{
#include "par_rowColumn_SetSensitive.c"
}

static int	_parRowColumn_sensitive( swidget UxThis, Environment * pEnv, Boolean tf )
{
	int			_Uxrtrn;
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_sensitive( UxThis, pEnv, tf );
	UxParRowColumnContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_checkVal( swidget UxThis, Environment * pEnv, double *v )
{
#include "par_rowColumn_checkVal.c"
}

static int	_parRowColumn_checkVal( swidget UxThis, Environment * pEnv, double *v )
{
	int			_Uxrtrn;
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_checkVal( UxThis, pEnv, v );
	UxParRowColumnContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_getTie( swidget UxThis, Environment * pEnv, int *t_num, int *c_type, int *ih, int *ik, int *il )
{
#include "par_rowColumn_getTie.c"
}

static int	_parRowColumn_getTie( swidget UxThis, Environment * pEnv, int *t_num, int *c_type, int *ih, int *ik, int *il )
{
	int			_Uxrtrn;
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getTie( UxThis, pEnv, t_num, c_type, ih, ik, il );
	UxParRowColumnContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_remTie( swidget UxThis, Environment * pEnv )
{
#include "par_rowColumn_remTie.c"
}

static void	_parRowColumn_remTie( swidget UxThis, Environment * pEnv )
{
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_remTie( UxThis, pEnv );
	UxParRowColumnContext = UxSaveCtx;
}

static char *	Ux_getDescr( swidget UxThis, Environment * pEnv )
{
#include "par_rowColumn_getDescr.c"
}

static char *	_parRowColumn_getDescr( swidget UxThis, Environment * pEnv )
{
	char *			_Uxrtrn;
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getDescr( UxThis, pEnv );
	UxParRowColumnContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_setTie( swidget UxThis, Environment * pEnv, int t_num, int c_type, int ih, int ik, int il )
{
#include "par_rowColumn_setTie.c"
}

static int	_parRowColumn_setTie( swidget UxThis, Environment * pEnv, int t_num, int c_type, int ih, int ik, int il )
{
	int			_Uxrtrn;
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_setTie( UxThis, pEnv, t_num, c_type, ih, ik, il );
	UxParRowColumnContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_getState( swidget UxThis, Environment * pEnv, int *istate )
{
#include "par_rowColumn_getState.c"
}

static int	_parRowColumn_getState( swidget UxThis, Environment * pEnv, int *istate )
{
	int			_Uxrtrn;
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getState( UxThis, pEnv, istate );
	UxParRowColumnContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_setState( swidget UxThis, Environment * pEnv, int istate )
{
#include "par_rowColumn_setState.c"
}

static int	_parRowColumn_setState( swidget UxThis, Environment * pEnv, int istate )
{
	int			_Uxrtrn;
	_UxCparRowColumn        *UxSaveCtx = UxParRowColumnContext;

	UxParRowColumnContext = (_UxCparRowColumn *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_setState( UxThis, pEnv, istate );
	UxParRowColumnContext = UxSaveCtx;

	return ( _Uxrtrn );
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  createCB_stateMenu(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparRowColumn        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParRowColumnContext;
	UxContext = UxParRowColumnContext;
	{
	
	}
	UxParRowColumnContext = UxSaveCtx;
}

static void  activateCB_stateMenu_free1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparRowColumn        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParRowColumnContext;
	UxParRowColumnContext = UxContext =
			(_UxCparRowColumn *) UxGetContext( UxWidget );
	{
	command ("free %d\n", num);
	 
	parRowColumn_remLimits (UxThisWidget, &UxEnv);
	parRowColumn_remTie (UxThisWidget, &UxEnv);
	XtSetSensitive (UxGetWidget (textVal), TRUE);
	parRowColumn_setState (UxThisWidget, &UxEnv, 0);
	}
	UxParRowColumnContext = UxSaveCtx;
}

static void  createCB_stateMenu_free1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparRowColumn        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParRowColumnContext;
	UxContext = UxParRowColumnContext;
	{
	
	}
	UxParRowColumnContext = UxSaveCtx;
}

static void  activateCB_stateMenu_set1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparRowColumn        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParRowColumnContext;
	UxParRowColumnContext = UxContext =
			(_UxCparRowColumn *) UxGetContext( UxWidget );
	{
		double v;
	
	        command ("free %d\n", num);
		if (parRowColumn_checkVal (UxThisWidget, &UxEnv, &v))
	            command ("set %d %g\n", num, v);
		else
		    command ("set %d\n", num);
	 
	        parRowColumn_remLimits (UxThisWidget, &UxEnv);
	        parRowColumn_remTie (UxThisWidget, &UxEnv);
	 
	        XtVaSetValues (UxGetWidget (textVal),
	                       XmNsensitive, FALSE,
	                       NULL);
	 	parRowColumn_setState (UxThisWidget, &UxEnv, 1);
	}
	UxParRowColumnContext = UxSaveCtx;
}

static void  createCB_stateMenu_set1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparRowColumn        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParRowColumnContext;
	UxContext = UxParRowColumnContext;
	{
	
	}
	UxParRowColumnContext = UxSaveCtx;
}

static void  activateCB_stateMenu_limited1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparRowColumn        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParRowColumnContext;
	UxParRowColumnContext = UxContext =
			(_UxCparRowColumn *) UxGetContext( UxWidget );
	limitDialog_lshow (limitD, &UxEnv, num);
	UxParRowColumnContext = UxSaveCtx;
}

static void  createCB_stateMenu_limited1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparRowColumn        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParRowColumnContext;
	UxContext = UxParRowColumnContext;
	{
	
	}
	UxParRowColumnContext = UxSaveCtx;
}

static void  activateCB_stateMenu_tied1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparRowColumn        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParRowColumnContext;
	UxParRowColumnContext = UxContext =
			(_UxCparRowColumn *) UxGetContext( UxWidget );
	tieDialog_tshow (tieD, &UxEnv, num);
	UxParRowColumnContext = UxSaveCtx;
}

static void  createCB_stateMenu_tied1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparRowColumn        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParRowColumnContext;
	UxContext = UxParRowColumnContext;
	{
	
	}
	UxParRowColumnContext = UxSaveCtx;
}

static void  mapCB_parMenu(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCparRowColumn        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxParRowColumnContext;
	UxParRowColumnContext = UxContext =
			(_UxCparRowColumn *) UxGetContext( UxWidget );
	{
	
	}
	UxParRowColumnContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_parRowColumn()
{
	Widget		_UxParent;
	Widget		stateMenu_shell;


	/* Creation of parRowColumn */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = XtVaCreatePopupShell( "parRowColumn_shell",
			topLevelShellWidgetClass, UxTopLevel,
			XmNx, 0,
			XmNy, 0,
			XmNwidth, 630,
			XmNheight, 30,
			XmNtitle, "parRowColumn",
			XmNiconName, "parRowColumn",
			NULL );

	}

	parRowColumn = XtVaCreateWidget( "parRowColumn",
			xmRowColumnWidgetClass,
			_UxParent,
			XmNwidth, 630,
			XmNheight, 30,
			XmNmarginHeight, 0,
			XmNmarginWidth, 0,
			NULL );
	UxPutContext( parRowColumn, (char *) UxParRowColumnContext );
	UxPutClassCode( parRowColumn, _UxIfClassId );


	/* Creation of parForm */
	parForm = XtVaCreateManagedWidget( "parForm",
			xmFormWidgetClass,
			parRowColumn,
			XmNresizePolicy, XmRESIZE_NONE,
			XmNx, -2,
			XmNy, -1,
			NULL );
	UxPutContext( parForm, (char *) UxParRowColumnContext );


	/* Creation of labelPar */
	labelPar = XtVaCreateManagedWidget( "labelPar",
			xmLabelWidgetClass,
			parForm,
			XmNwidth, 110,
			XmNheight, 20,
			XmNrecomputeSize, FALSE,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNleftOffset, 5,
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNtopOffset, 5,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( labelPar, (char *) UxParRowColumnContext );


	/* Creation of textVal */
	textVal = XtVaCreateManagedWidget( "textVal",
			xmTextFieldWidgetClass,
			parForm,
			XmNwidth, 100,
			XmNheight, 30,
			XmNcolumns, 12,
			XmNfontList, UxConvertFontList("8x13" ),
			XmNleftOffset, 120,
			XmNleftAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( textVal, (char *) UxParRowColumnContext );


	/* Creation of stateMenu */
	stateMenu_shell = XtVaCreatePopupShell ("stateMenu_shell",
			xmMenuShellWidgetClass, parForm,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	stateMenu = XtVaCreateWidget( "stateMenu",
			xmRowColumnWidgetClass,
			stateMenu_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( stateMenu, (char *) UxParRowColumnContext );

	createCB_stateMenu( stateMenu,
			(XtPointer) UxParRowColumnContext, (XtPointer) NULL );


	/* Creation of stateMenu_free1 */
	stateMenu_free1 = XtVaCreateManagedWidget( "stateMenu_free1",
			xmPushButtonWidgetClass,
			stateMenu,
			RES_CONVERT( XmNlabelString, "Free" ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	XtAddCallback( stateMenu_free1, XmNactivateCallback,
		(XtCallbackProc) activateCB_stateMenu_free1,
		(XtPointer) UxParRowColumnContext );

	UxPutContext( stateMenu_free1, (char *) UxParRowColumnContext );

	createCB_stateMenu_free1( stateMenu_free1,
			(XtPointer) UxParRowColumnContext, (XtPointer) NULL );


	/* Creation of stateMenu_set1 */
	stateMenu_set1 = XtVaCreateManagedWidget( "stateMenu_set1",
			xmPushButtonWidgetClass,
			stateMenu,
			RES_CONVERT( XmNlabelString, "Set" ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	XtAddCallback( stateMenu_set1, XmNactivateCallback,
		(XtCallbackProc) activateCB_stateMenu_set1,
		(XtPointer) UxParRowColumnContext );

	UxPutContext( stateMenu_set1, (char *) UxParRowColumnContext );

	createCB_stateMenu_set1( stateMenu_set1,
			(XtPointer) UxParRowColumnContext, (XtPointer) NULL );


	/* Creation of stateMenu_limited1 */
	stateMenu_limited1 = XtVaCreateManagedWidget( "stateMenu_limited1",
			xmPushButtonWidgetClass,
			stateMenu,
			RES_CONVERT( XmNlabelString, "Limit..." ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	XtAddCallback( stateMenu_limited1, XmNactivateCallback,
		(XtCallbackProc) activateCB_stateMenu_limited1,
		(XtPointer) UxParRowColumnContext );

	UxPutContext( stateMenu_limited1, (char *) UxParRowColumnContext );

	createCB_stateMenu_limited1( stateMenu_limited1,
			(XtPointer) UxParRowColumnContext, (XtPointer) NULL );


	/* Creation of stateMenu_tied1 */
	stateMenu_tied1 = XtVaCreateManagedWidget( "stateMenu_tied1",
			xmPushButtonWidgetClass,
			stateMenu,
			RES_CONVERT( XmNlabelString, "Tie..." ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	XtAddCallback( stateMenu_tied1, XmNactivateCallback,
		(XtCallbackProc) activateCB_stateMenu_tied1,
		(XtPointer) UxParRowColumnContext );

	UxPutContext( stateMenu_tied1, (char *) UxParRowColumnContext );

	createCB_stateMenu_tied1( stateMenu_tied1,
			(XtPointer) UxParRowColumnContext, (XtPointer) NULL );


	/* Creation of parMenu */
	parMenu = XtVaCreateManagedWidget( "parMenu",
			xmRowColumnWidgetClass,
			parForm,
			XmNrowColumnType, XmMENU_OPTION,
			XmNsubMenuId, stateMenu,
			XmNtopOffset, 0,
			XmNleftOffset, 220,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftAttachment, XmATTACH_FORM,
			NULL );
	XtAddCallback( parMenu, XmNmapCallback,
		(XtCallbackProc) mapCB_parMenu,
		(XtPointer) UxParRowColumnContext );

	UxPutContext( parMenu, (char *) UxParRowColumnContext );


	/* Creation of labelTieto */
	labelTieto = XtVaCreateManagedWidget( "labelTieto",
			xmLabelWidgetClass,
			parForm,
			RES_CONVERT( XmNlabelString, "to" ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNtopOffset, 5,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 350,
			XmNmappedWhenManaged, FALSE,
			NULL );
	UxPutContext( labelTieto, (char *) UxParRowColumnContext );


	/* Creation of textLimit1 */
	textLimit1 = XtVaCreateManagedWidget( "textLimit1",
			xmTextFieldWidgetClass,
			parForm,
			XmNmappedWhenManaged, FALSE,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNleftOffset, 380,
			XmNleftAttachment, XmATTACH_FORM,
			XmNwidth, 100,
			NULL );
	UxPutContext( textLimit1, (char *) UxParRowColumnContext );


	/* Creation of labelLimto */
	labelLimto = XtVaCreateManagedWidget( "labelLimto",
			xmLabelWidgetClass,
			parForm,
			RES_CONVERT( XmNlabelString, "to" ),
			XmNmappedWhenManaged, FALSE,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNleftOffset, 500,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 5,
			NULL );
	UxPutContext( labelLimto, (char *) UxParRowColumnContext );


	/* Creation of textLimit2 */
	textLimit2 = XtVaCreateManagedWidget( "textLimit2",
			xmTextFieldWidgetClass,
			parForm,
			XmNwidth, 100,
			XmNmappedWhenManaged, FALSE,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNleftOffset, 530,
			XmNleftAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( textLimit2, (char *) UxParRowColumnContext );


	XtAddCallback( parRowColumn, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxParRowColumnContext);


	return ( parRowColumn );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_parRowColumn( swidget _UxUxParent, char *_Uxlabel, char *_Uxvalue, char *_Uxdescr )
{
	Widget                  rtrn;
	_UxCparRowColumn        *UxContext;
	static int		_Uxinit = 0;

	UxParRowColumnContext = UxContext =
		(_UxCparRowColumn *) UxNewContext( sizeof(_UxCparRowColumn), False );

	UxParent = _UxUxParent;
	label = _Uxlabel;
	value = _Uxvalue;
	descr = _Uxdescr;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxparRowColumn_set_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_set_Name,
				(void (*)()) _parRowColumn_set );
		UxparRowColumn_getLimits_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_getLimits_Name,
				(void (*)()) _parRowColumn_getLimits );
		UxparRowColumn_remLimits_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_remLimits_Name,
				(void (*)()) _parRowColumn_remLimits );
		UxparRowColumn_setLimits_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_setLimits_Name,
				(void (*)()) _parRowColumn_setLimits );
		UxparRowColumn_sensitive_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_sensitive_Name,
				(void (*)()) _parRowColumn_sensitive );
		UxparRowColumn_checkVal_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_checkVal_Name,
				(void (*)()) _parRowColumn_checkVal );
		UxparRowColumn_getTie_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_getTie_Name,
				(void (*)()) _parRowColumn_getTie );
		UxparRowColumn_remTie_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_remTie_Name,
				(void (*)()) _parRowColumn_remTie );
		UxparRowColumn_getDescr_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_getDescr_Name,
				(void (*)()) _parRowColumn_getDescr );
		UxparRowColumn_setTie_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_setTie_Name,
				(void (*)()) _parRowColumn_setTie );
		UxparRowColumn_getState_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_getState_Name,
				(void (*)()) _parRowColumn_getState );
		UxparRowColumn_setState_Id = UxMethodRegister( _UxIfClassId,
				UxparRowColumn_setState_Name,
				(void (*)()) _parRowColumn_setState );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_parRowColumn();

	XmTextFieldSetString (textVal, value);
	XtVaSetValues (labelPar,
	               XmNlabelString, XmStringCreateLtoR (label, XmSTRING_DEFAULT_CHARSET),
	               NULL);
	
	(void) strtok (label, " ");
	sscanf (label, "%d", &num);
	tie_num = num;
	val = atof (value);
	
	state = 0;
	ch = ck = cl = 0;
	constraint_type = 0;
	limit1 = limit2 = 0.0;
	(void) strcpy (description, descr);
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

