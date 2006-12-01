
/*******************************************************************************
	par_rowColumn.c

       Associated Header file: par_rowColumn.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <X11/Shell.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

#include <Xm/Label.h>
#include <Xm/PushB.h>
#include <Xm/TextF.h>
#include <Xm/RowColumn.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <string.h>
#include "par_rc.h"
#include "mprintf.h"

static void remove_limits ();
static void remove_tie ();


static	int _UxIfClassId;
/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "par_rowColumn.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Auxiliary code from the Declarations Editor:
*******************************************************************************/

#include "par_rowColumn_aux.c"


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  modifyVerifyCB_textVal(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCpar_rowColumn       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	char *cptr;

	UxSaveCtx = UxPar_rowColumnContext;
	UxPar_rowColumnContext = UxContext =
			(_UxCpar_rowColumn *) UxGetContext( UxWidget );
	{
	cptr = (char *) XmTextGetString (UxWidget);
	value = strcpy (value, cptr);
	free (cptr);
	}
	UxPar_rowColumnContext = UxSaveCtx;
}

static void  activateCB_stateMenu_free1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCpar_rowColumn       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxPar_rowColumnContext;
	UxPar_rowColumnContext = UxContext =
			(_UxCpar_rowColumn *) UxGetContext( UxWidget );
	command ("free %d\n", num);
	
	remove_limits (par_rowColumn);
	remove_tie (par_rowColumn);
	
	XtSetSensitive (UxGetWidget (textVal), TRUE);
	
	state = 0;
	UxPar_rowColumnContext = UxSaveCtx;
}

static void  activateCB_stateMenu_set1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCpar_rowColumn       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxPar_rowColumnContext;
	UxPar_rowColumnContext = UxContext =
			(_UxCpar_rowColumn *) UxGetContext( UxWidget );
	command ("free %d\n", num);
	command ("set %d %s\n", num, value);
	
	remove_limits (par_rowColumn);
	remove_tie (par_rowColumn);
	
	XtVaSetValues (UxGetWidget (textVal),
	               XmNsensitive, FALSE,
	               NULL);
	
	state = 1;
	UxPar_rowColumnContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_par_rowColumn()
{
	Widget		_UxParent;
	Widget		stateMenu1_shell;
	char		*UxTmp0;


	/* Creation of par_rowColumn */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = XtVaCreatePopupShell( "par_rowColumn_shell",
			topLevelShellWidgetClass, UxTopLevel,
			XmNx, 796,
			XmNy, 158,
			XmNwidth, 630,
			XmNheight, 30,
			XmNtitle, "par_rowColumn",
			XmNiconName, "par_rowColumn",
			NULL );

	}

	par_rowColumn = XtVaCreateWidget( "par_rowColumn",
			xmRowColumnWidgetClass,
			_UxParent,
			XmNwidth, 630,
			XmNheight, 30,
			XmNnumColumns, 5,
			XmNpacking, XmPACK_NONE,
			XmNorientation, XmVERTICAL,
			XmNmappedWhenManaged, TRUE,
			XmNisAligned, TRUE,
			XmNresizeWidth, FALSE,
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNresizeHeight, FALSE,
			NULL );
	UxPutContext( par_rowColumn, (char *) UxPar_rowColumnContext );


	/* Creation of textVal */
	textVal = XtVaCreateManagedWidget( "textVal",
			xmTextFieldWidgetClass,
			par_rowColumn,
			XmNwidth, 70,
			XmNx, 120,
			XmNy, 0,
			XmNheight, 30,
			XmNfontList, UxConvertFontList( "8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNhighlightOnEnter, FALSE,
			RES_CONVERT( XmNborderColor, "white" ),
			XmNancestorSensitive, TRUE,
			XmNmappedWhenManaged, TRUE,
			XmNsensitive, TRUE,
			XmNresizeWidth, FALSE,
			XmNcolumns, 14,
			XmNvalue, value ? value : "undefined",
			NULL );
	XtAddCallback( textVal, XmNmodifyVerifyCallback,
		(XtCallbackProc) modifyVerifyCB_textVal,
		(XtPointer) UxPar_rowColumnContext );

	UxPutContext( textVal, (char *) UxPar_rowColumnContext );


	/* Creation of stateMenu1 */
	stateMenu1_shell = XtVaCreatePopupShell ("stateMenu1_shell",
			xmMenuShellWidgetClass, par_rowColumn,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	stateMenu1 = XtVaCreateWidget( "stateMenu1",
			xmRowColumnWidgetClass,
			stateMenu1_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			NULL );
	UxPutContext( stateMenu1, (char *) UxPar_rowColumnContext );


	/* Creation of stateMenu_free1 */
	stateMenu_free1 = XtVaCreateManagedWidget( "stateMenu_free1",
			xmPushButtonWidgetClass,
			stateMenu1,
			RES_CONVERT( XmNlabelString, "Free" ),
			RES_CONVERT( XmNmnemonic, "F" ),
			XmNfontList, UxConvertFontList( "8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			NULL );
	XtAddCallback( stateMenu_free1, XmNactivateCallback,
		(XtCallbackProc) activateCB_stateMenu_free1,
		(XtPointer) UxPar_rowColumnContext );

	UxPutContext( stateMenu_free1, (char *) UxPar_rowColumnContext );


	/* Creation of stateMenu_set1 */
	stateMenu_set1 = XtVaCreateManagedWidget( "stateMenu_set1",
			xmPushButtonWidgetClass,
			stateMenu1,
			RES_CONVERT( XmNlabelString, "Set" ),
			RES_CONVERT( XmNmnemonic, "S" ),
			XmNfontList, UxConvertFontList( "8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			NULL );
	XtAddCallback( stateMenu_set1, XmNactivateCallback,
		(XtCallbackProc) activateCB_stateMenu_set1,
		(XtPointer) UxPar_rowColumnContext );

	UxPutContext( stateMenu_set1, (char *) UxPar_rowColumnContext );


	/* Creation of stateMenu_limited1 */
	stateMenu_limited1 = XtVaCreateManagedWidget( "stateMenu_limited1",
			xmPushButtonWidgetClass,
			stateMenu1,
			RES_CONVERT( XmNlabelString, "Limit..." ),
			RES_CONVERT( XmNmnemonic, "L" ),
			XmNfontList, UxConvertFontList( "8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			NULL );
	UxPutContext( stateMenu_limited1, (char *) UxPar_rowColumnContext );


	/* Creation of stateMenu_tied1 */
	stateMenu_tied1 = XtVaCreateManagedWidget( "stateMenu_tied1",
			xmPushButtonWidgetClass,
			stateMenu1,
			RES_CONVERT( XmNlabelString, "Tie..." ),
			RES_CONVERT( XmNmnemonic, "T" ),
			XmNfontList, UxConvertFontList( "8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			NULL );
	UxPutContext( stateMenu_tied1, (char *) UxPar_rowColumnContext );


	/* Creation of parMenu */
	parMenu = XtVaCreateManagedWidget( "parMenu",
			xmRowColumnWidgetClass,
			par_rowColumn,
			XmNrowColumnType, XmMENU_OPTION,
			XmNsubMenuId, stateMenu1,
			XmNx, 260,
			XmNy, -2,
			XmNwidth, 80,
			XmNheight, 30,
			RES_CONVERT( XmNforeground, "white" ),
			NULL );
	UxPutContext( parMenu, (char *) UxPar_rowColumnContext );


	/* Creation of textLimit1 */
	textLimit1 = XtVaCreateManagedWidget( "textLimit1",
			xmTextFieldWidgetClass,
			par_rowColumn,
			XmNwidth, 50,
			XmNx, 405,
			XmNy, 0,
			XmNheight, 30,
			XmNfontList, UxConvertFontList( "8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNhighlightOnEnter, FALSE,
			RES_CONVERT( XmNborderColor, "white" ),
			XmNcolumns, 10,
			XmNsensitive, TRUE,
			XmNmappedWhenManaged, FALSE,
			NULL );
	UxPutContext( textLimit1, (char *) UxPar_rowColumnContext );


	/* Creation of textLimit2 */
	textLimit2 = XtVaCreateManagedWidget( "textLimit2",
			xmTextFieldWidgetClass,
			par_rowColumn,
			XmNwidth, 50,
			XmNx, 535,
			XmNy, 0,
			XmNheight, 30,
			XmNfontList, UxConvertFontList( "8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNhighlightOnEnter, FALSE,
			RES_CONVERT( XmNborderColor, "white" ),
			XmNcolumns, 10,
			XmNsensitive, TRUE,
			XmNmappedWhenManaged, FALSE,
			NULL );
	UxPutContext( textLimit2, (char *) UxPar_rowColumnContext );


	/* Creation of labelLimto */
	labelLimto = XtVaCreateManagedWidget( "labelLimto",
			xmLabelWidgetClass,
			par_rowColumn,
			XmNy, 7,
			XmNwidth, 20,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "to" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNfontList, UxConvertFontList( "8x13bold" ),
			XmNx, 510,
			XmNsensitive, TRUE,
			XmNmappedWhenManaged, FALSE,
			NULL );
	UxPutContext( labelLimto, (char *) UxPar_rowColumnContext );

	UxTmp0 = label ? label : "undefined";

	/* Creation of labelPar */
	labelPar = XtVaCreateManagedWidget( "labelPar",
			xmLabelWidgetClass,
			par_rowColumn,
			XmNy, 7,
			XmNwidth, 90,
			XmNheight, 17,
			RES_CONVERT( XmNlabelString, UxTmp0 ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNfontList, UxConvertFontList( "8x13bold" ),
			NULL );
	UxPutContext( labelPar, (char *) UxPar_rowColumnContext );


	/* Creation of labelTieto */
	labelTieto = XtVaCreateManagedWidget( "labelTieto",
			xmLabelWidgetClass,
			par_rowColumn,
			XmNy, 7,
			XmNwidth, 20,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "to" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNfontList, UxConvertFontList( "8x13bold" ),
			XmNx, 375,
			XmNsensitive, TRUE,
			XmNmappedWhenManaged, FALSE,
			NULL );
	UxPutContext( labelTieto, (char *) UxPar_rowColumnContext );

	XtVaSetValues(parMenu,
			XmNmenuHistory, stateMenu_free1,
			NULL );


	XtAddCallback( par_rowColumn, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxPar_rowColumnContext);


	return ( par_rowColumn );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_par_rowColumn( swidget _UxUxParent, char *_Uxlabel, char *_Uxvalue, char *_Uxdescription )
{
	Widget                  rtrn;
	_UxCpar_rowColumn       *UxContext;
	static int		_Uxinit = 0;

	UxPar_rowColumnContext = UxContext =
		(_UxCpar_rowColumn *) UxNewContext( sizeof(_UxCpar_rowColumn), False );

	UxParent = _UxUxParent;
	label = _Uxlabel;
	value = _Uxvalue;
	description = _Uxdescription;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_par_rowColumn();
	UxPutClassCode( par_rowColumn, _UxIfClassId );

	tie_num = num = atoi (label);
	val = atof (value);
	state = 0;
	ch = ck = cl = 0;
	constraint_type = 0;
	limit1 = limit2 = 0.0;
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

