
/*******************************************************************************
	tieDialog.c

       Associated Header file: tieDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/ArrowB.h>
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/Form.h>
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>
#ifndef DESIGN_TIME
#include "setupDialog.h"
#endif

#include "mprintf.h"

extern swidget setup;

static void setH (Boolean, int);
static void setK (Boolean, int);
static void setL (Boolean, int);


static	int _UxIfClassId;
int	UxtieDialog_tput_Id = -1;
char*	UxtieDialog_tput_Name = "tput";
int	UxtieDialog_tshow_Id = -1;
char*	UxtieDialog_tshow_Name = "tshow";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "tieDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_tieDialog_tput( swidget UxThis, Environment * pEnv );
static void	_tieDialog_tshow( swidget UxThis, Environment * pEnv, int num );

/*******************************************************************************
Auxiliary code from the Declarations Editor:
*******************************************************************************/

#include "tieDialog_aux.c"

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_tput( swidget UxThis, Environment * pEnv )
{
	char *cptr, tmp[5];
	 
	cptr = (char *) setupDialog_getDescrN (setup, pEnv, par);
	if (cptr)
	{
	    XtVaSetValues (labelPeak,
	                   XmNlabelString, XmStringCreateLtoR (cptr, 
	                   XmSTRING_DEFAULT_CHARSET),
	                   NULL);
	 
	    sprintf (tmp, "%d", par);
	    XmTextFieldSetString (textPar, tmp);
	      
	    setupDialog_getTieN (setup, pEnv, par, &tiepar, &ctype, &ih,
	                        &ik, &il);
	 
	    cptr = (char *) setupDialog_getDescrN (setup, pEnv, tiepar);
	 
	    if (cptr)
	    {
	        XtSetSensitive (arrowButton2, TRUE);
	        XtSetSensitive (arrowButton1, TRUE);
	 
	        XtVaSetValues (labelPeak2,
	                       XmNlabelString, XmStringCreateLtoR (cptr, 
	                       XmSTRING_DEFAULT_CHARSET),
	                       NULL);
	 
	        sprintf (tmp, "%d", tiepar);
	        XmTextFieldSetString (textTie_par, tmp);
	 
	        switch (ctype)
	        {
	          case 0:
	              XtVaSetValues (tieMenu1,
	                             XmNmenuHistory, tieMenu_equal,
	                             NULL);
	              setH (FALSE, ih); setK (FALSE, ik); setL (FALSE, il);
	              break;
	              
	          case 1:
	              XtVaSetValues (tieMenu1,
	                             XmNmenuHistory, tieMenu_hex,
	                             NULL);
	              setH (TRUE, il); setK (TRUE, il);
	              break;
	          case 2:
	              XtVaSetValues (tieMenu1,
	                             XmNmenuHistory, tieMenu_tet,
	                             NULL);
	              setH (TRUE, il); setK (TRUE, il);
	              break;
	              
	         case 3:
	              XtVaSetValues (tieMenu1,
	                             XmNmenuHistory, tieMenu_cub,
	                             NULL);
	              setH (TRUE, il); setK (TRUE, il); setL (TRUE, il);
	         default:
	              break;
	        }
	    }
	    else
	    {
	          /* Error Dialog */
	    }
	}
	else
	{
	    if (par == 0)
	    {
	        par = 1;
	        XtSetSensitive (arrowButton2, FALSE);
	        XtSetSensitive (arrowButton1, TRUE);
	    }
	    else
	    {
	        par--;
	        XtSetSensitive (arrowButton2, TRUE);
	        XtSetSensitive (arrowButton1, FALSE);
	    }
	 
	}
}

static void	_tieDialog_tput( swidget UxThis, Environment * pEnv )
{
	_UxCtieDialog           *UxSaveCtx = UxTieDialogContext;

	UxTieDialogContext = (_UxCtieDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_tput( UxThis, pEnv );
	UxTieDialogContext = UxSaveCtx;
}

static void	Ux_tshow( swidget UxThis, Environment * pEnv, int num )
{
	cpar = par = num;
	setupDialog_getStateN (setup, &UxEnv, num, &istate);
	tieDialog_tput (UxThis, pEnv);
	UxPopupInterface (UxThis, no_grab);
}

static void	_tieDialog_tshow( swidget UxThis, Environment * pEnv, int num )
{
	_UxCtieDialog           *UxSaveCtx = UxTieDialogContext;

	UxTieDialogContext = (_UxCtieDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_tshow( UxThis, pEnv, num );
	UxTieDialogContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_tieDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCtieDialog           *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxTieDialogContext;
	UxTieDialogContext = UxContext =
			(_UxCtieDialog *) UxGetContext( UxWidget );
	{
#include "tieDialog_applyCB.c"
	}
	UxTieDialogContext = UxSaveCtx;
}

static void  helpCB_tieDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCtieDialog           *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxTieDialogContext;
	UxTieDialogContext = UxContext =
			(_UxCtieDialog *) UxGetContext( UxWidget );
	{
	setupDialog_setStateN (setup, &UxEnv, cpar, istate);
	UxPopdownInterface (UxThisWidget);
	}
	UxTieDialogContext = UxSaveCtx;
}

static void  okCallback_tieDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCtieDialog           *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxTieDialogContext;
	UxTieDialogContext = UxContext =
			(_UxCtieDialog *) UxGetContext( UxWidget );
	{
#include "tieDialog_applyCB.c"
	setupDialog_getStateN (setup, &UxEnv, cpar, &istate);
	setupDialog_setStateN (setup, &UxEnv, cpar, istate);
	UxPopdownInterface (UxThisWidget);
	
	}
	UxTieDialogContext = UxSaveCtx;
}

static void  activateCB_tieMenu_equal(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCtieDialog           *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxTieDialogContext;
	UxTieDialogContext = UxContext =
			(_UxCtieDialog *) UxGetContext( UxWidget );
	sprintf (constraint, "");
	setH (FALSE, 0); setK (FALSE, 0); setL (FALSE, 0);
	UxTieDialogContext = UxSaveCtx;
}

static void  activateCB_tieMenu_hex(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCtieDialog           *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxTieDialogContext;
	UxTieDialogContext = UxContext =
			(_UxCtieDialog *) UxGetContext( UxWidget );
	sprintf (constraint, "hex");
	setH (TRUE, ih); setK (TRUE, ik); setL (FALSE, 0);
	UxTieDialogContext = UxSaveCtx;
}

static void  activateCB_tieMenu_tet(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCtieDialog           *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxTieDialogContext;
	UxTieDialogContext = UxContext =
			(_UxCtieDialog *) UxGetContext( UxWidget );
	sprintf (constraint, "tet");
	setH (TRUE, ih); setK (TRUE, ik); setL (FALSE, 0);
	UxTieDialogContext = UxSaveCtx;
}

static void  activateCB_tieMenu_cub(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCtieDialog           *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxTieDialogContext;
	UxTieDialogContext = UxContext =
			(_UxCtieDialog *) UxGetContext( UxWidget );
	sprintf (constraint, "cub");
	setH (TRUE, ih); setK (TRUE, ik); setL (TRUE, il);
	UxTieDialogContext = UxSaveCtx;
}

static void  activateCB_arrowButton2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCtieDialog           *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxTieDialogContext;
	UxTieDialogContext = UxContext =
			(_UxCtieDialog *) UxGetContext( UxWidget );
	{
#include "tieDialog_applyCB.c"
	par--;
	tieDialog_tput (UxThisWidget, &UxEnv);
	}
	UxTieDialogContext = UxSaveCtx;
}

static void  activateCB_arrowButton1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCtieDialog           *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxTieDialogContext;
	UxTieDialogContext = UxContext =
			(_UxCtieDialog *) UxGetContext( UxWidget );
	{
#include "tieDialog_applyCB.c"
	par++;
	tieDialog_tput (UxThisWidget, &UxEnv);
	}
	UxTieDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_tieDialog()
{
	Widget		_UxParent;
	Widget		tieMenu_p1_shell;


	/* Creation of tieDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "tieDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 360,
			XmNy, 400,
			XmNwidth, 365,
			XmNheight, 270,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "tieDialog",
			NULL );

	tieDialog = XtVaCreateWidget( "tieDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 365,
			XmNheight, 270,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNunitType, XmPIXELS,
			RES_CONVERT( XmNdialogTitle, "Tie Dialog" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			XmNtextFontList, UxConvertFontList("8x13bold" ),
			XmNresizePolicy, XmRESIZE_NONE,
			RES_CONVERT( XmNmessageString, "" ),
			XmNmarginHeight, 5,
			XmNminimizeButtons, FALSE,
			RES_CONVERT( XmNcancelLabelString, "Apply" ),
			RES_CONVERT( XmNhelpLabelString, "Cancel" ),
			XmNautoUnmanage, FALSE,
			NULL );
	XtAddCallback( tieDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_tieDialog,
		(XtPointer) UxTieDialogContext );
	XtAddCallback( tieDialog, XmNhelpCallback,
		(XtCallbackProc) helpCB_tieDialog,
		(XtPointer) UxTieDialogContext );
	XtAddCallback( tieDialog, XmNokCallback,
		(XtCallbackProc) okCallback_tieDialog,
		(XtPointer) UxTieDialogContext );

	UxPutContext( tieDialog, (char *) UxTieDialogContext );
	UxPutClassCode( tieDialog, _UxIfClassId );


	/* Creation of form2 */
	form2 = XtVaCreateManagedWidget( "form2",
			xmFormWidgetClass,
			tieDialog,
			NULL );
	UxPutContext( form2, (char *) UxTieDialogContext );


	/* Creation of label1 */
	label1 = XtVaCreateManagedWidget( "label1",
			xmLabelWidgetClass,
			form2,
			XmNwidth, 90,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Parameter" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNrightAttachment, XmATTACH_NONE,
			XmNtopOffset, 5,
			XmNtopAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( label1, (char *) UxTieDialogContext );


	/* Creation of label2 */
	label2 = XtVaCreateManagedWidget( "label2",
			xmLabelWidgetClass,
			form2,
			XmNwidth, 140,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Tie to parameter" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 50,
			NULL );
	UxPutContext( label2, (char *) UxTieDialogContext );


	/* Creation of textTie_par */
	textTie_par = XtVaCreateManagedWidget( "textTie_par",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 40,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNheight, 30,
			XmNcolumns, 2,
			XmNvalue, "1",
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 140,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 48,
			XmNx, 148,
			NULL );
	UxPutContext( textTie_par, (char *) UxTieDialogContext );


	/* Creation of tieMenu_p1 */
	tieMenu_p1_shell = XtVaCreatePopupShell ("tieMenu_p1_shell",
			xmMenuShellWidgetClass, form2,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	tieMenu_p1 = XtVaCreateWidget( "tieMenu_p1",
			xmRowColumnWidgetClass,
			tieMenu_p1_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( tieMenu_p1, (char *) UxTieDialogContext );


	/* Creation of tieMenu_equal */
	tieMenu_equal = XtVaCreateManagedWidget( "tieMenu_equal",
			xmPushButtonWidgetClass,
			tieMenu_p1,
			RES_CONVERT( XmNlabelString, "Equality" ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	XtAddCallback( tieMenu_equal, XmNactivateCallback,
		(XtCallbackProc) activateCB_tieMenu_equal,
		(XtPointer) UxTieDialogContext );

	UxPutContext( tieMenu_equal, (char *) UxTieDialogContext );


	/* Creation of tieMenu_hex */
	tieMenu_hex = XtVaCreateManagedWidget( "tieMenu_hex",
			xmPushButtonWidgetClass,
			tieMenu_p1,
			RES_CONVERT( XmNlabelString, "Hexagonal" ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	XtAddCallback( tieMenu_hex, XmNactivateCallback,
		(XtCallbackProc) activateCB_tieMenu_hex,
		(XtPointer) UxTieDialogContext );

	UxPutContext( tieMenu_hex, (char *) UxTieDialogContext );


	/* Creation of tieMenu_tet */
	tieMenu_tet = XtVaCreateManagedWidget( "tieMenu_tet",
			xmPushButtonWidgetClass,
			tieMenu_p1,
			RES_CONVERT( XmNlabelString, "Tetragonal" ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	XtAddCallback( tieMenu_tet, XmNactivateCallback,
		(XtCallbackProc) activateCB_tieMenu_tet,
		(XtPointer) UxTieDialogContext );

	UxPutContext( tieMenu_tet, (char *) UxTieDialogContext );


	/* Creation of tieMenu_cub */
	tieMenu_cub = XtVaCreateManagedWidget( "tieMenu_cub",
			xmPushButtonWidgetClass,
			tieMenu_p1,
			RES_CONVERT( XmNlabelString, "Cubic" ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	XtAddCallback( tieMenu_cub, XmNactivateCallback,
		(XtCallbackProc) activateCB_tieMenu_cub,
		(XtPointer) UxTieDialogContext );

	UxPutContext( tieMenu_cub, (char *) UxTieDialogContext );


	/* Creation of tieMenu1 */
	tieMenu1 = XtVaCreateManagedWidget( "tieMenu1",
			xmRowColumnWidgetClass,
			form2,
			XmNrowColumnType, XmMENU_OPTION,
			XmNsubMenuId, tieMenu_p1,
			XmNx, -44,
			XmNy, 0,
			XmNwidth, 100,
			XmNheight, 30,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 145,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 95,
			NULL );
	UxPutContext( tieMenu1, (char *) UxTieDialogContext );


	/* Creation of label5 */
	label5 = XtVaCreateManagedWidget( "label5",
			xmLabelWidgetClass,
			form2,
			XmNwidth, 50,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "h" ),
			XmNsensitive, FALSE,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 130,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 20,
			NULL );
	UxPutContext( label5, (char *) UxTieDialogContext );


	/* Creation of textH */
	textH = XtVaCreateManagedWidget( "textH",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNheight, 30,
			XmNcolumns, 4,
			XmNvalue, "1",
			XmNsensitive, FALSE,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 160,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 20,
			NULL );
	UxPutContext( textH, (char *) UxTieDialogContext );


	/* Creation of label6 */
	label6 = XtVaCreateManagedWidget( "label6",
			xmLabelWidgetClass,
			form2,
			XmNwidth, 50,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "k" ),
			XmNsensitive, FALSE,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 130,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 140,
			NULL );
	UxPutContext( label6, (char *) UxTieDialogContext );


	/* Creation of arrowButton2 */
	arrowButton2 = XtVaCreateManagedWidget( "arrowButton2",
			xmArrowButtonWidgetClass,
			form2,
			XmNwidth, 20,
			XmNheight, 20,
			XmNarrowDirection, XmARROW_DOWN,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 130,
			XmNtopOffset, 20,
			XmNtopAttachment, XmATTACH_FORM,
			NULL );
	XtAddCallback( arrowButton2, XmNactivateCallback,
		(XtCallbackProc) activateCB_arrowButton2,
		(XtPointer) UxTieDialogContext );

	UxPutContext( arrowButton2, (char *) UxTieDialogContext );


	/* Creation of textK */
	textK = XtVaCreateManagedWidget( "textK",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNheight, 30,
			XmNcolumns, 4,
			XmNvalue, "1",
			XmNsensitive, FALSE,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 160,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 140,
			NULL );
	UxPutContext( textK, (char *) UxTieDialogContext );


	/* Creation of label7 */
	label7 = XtVaCreateManagedWidget( "label7",
			xmLabelWidgetClass,
			form2,
			XmNwidth, 50,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "l" ),
			XmNsensitive, FALSE,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 130,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 260,
			NULL );
	UxPutContext( label7, (char *) UxTieDialogContext );


	/* Creation of textL */
	textL = XtVaCreateManagedWidget( "textL",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNheight, 30,
			XmNcolumns, 4,
			XmNvalue, "1",
			XmNsensitive, FALSE,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 160,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 260,
			NULL );
	UxPutContext( textL, (char *) UxTieDialogContext );


	/* Creation of textPar */
	textPar = XtVaCreateManagedWidget( "textPar",
			xmTextFieldWidgetClass,
			form2,
			XmNwidth, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNheight, 30,
			XmNcolumns, 2,
			XmNvalue, "1",
			XmNcursorPositionVisible, FALSE,
			XmNeditable, FALSE,
			XmNshadowThickness, 0,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 90,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 4,
			NULL );
	UxPutContext( textPar, (char *) UxTieDialogContext );


	/* Creation of labelPeak */
	labelPeak = XtVaCreateManagedWidget( "labelPeak",
			xmLabelWidgetClass,
			form2,
			XmNwidth, 180,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "(Peak  1: position)" ),
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 160,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 5,
			XmNalignment, XmALIGNMENT_BEGINNING,
			NULL );
	UxPutContext( labelPeak, (char *) UxTieDialogContext );


	/* Creation of labelPeak2 */
	labelPeak2 = XtVaCreateManagedWidget( "labelPeak2",
			xmLabelWidgetClass,
			form2,
			XmNwidth, 150,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "(Peak  1: position)" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 190,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 50,
			NULL );
	UxPutContext( labelPeak2, (char *) UxTieDialogContext );


	/* Creation of arrowButton1 */
	arrowButton1 = XtVaCreateManagedWidget( "arrowButton1",
			xmArrowButtonWidgetClass,
			form2,
			XmNwidth, 20,
			XmNheight, 20,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 130,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			NULL );
	XtAddCallback( arrowButton1, XmNactivateCallback,
		(XtCallbackProc) activateCB_arrowButton1,
		(XtPointer) UxTieDialogContext );

	UxPutContext( arrowButton1, (char *) UxTieDialogContext );


	/* Creation of label4 */
	label4 = XtVaCreateManagedWidget( "label4",
			xmLabelWidgetClass,
			form2,
			XmNheight, 20,
			XmNwidth, 140,
			RES_CONVERT( XmNlabelString, "Constraint type:" ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 100,
			NULL );
	UxPutContext( label4, (char *) UxTieDialogContext );


	XtAddCallback( tieDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxTieDialogContext);


	return ( tieDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_tieDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCtieDialog           *UxContext;
	static int		_Uxinit = 0;

	UxTieDialogContext = UxContext =
		(_UxCtieDialog *) UxNewContext( sizeof(_UxCtieDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxtieDialog_tput_Id = UxMethodRegister( _UxIfClassId,
				UxtieDialog_tput_Name,
				(void (*)()) _tieDialog_tput );
		UxtieDialog_tshow_Id = UxMethodRegister( _UxIfClassId,
				UxtieDialog_tshow_Name,
				(void (*)()) _tieDialog_tshow );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_tieDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

