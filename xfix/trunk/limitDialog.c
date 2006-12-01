
/*******************************************************************************
	limitDialog.c

       Associated Header file: limitDialog.h
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


static	int _UxIfClassId;
int	UxlimitDialog_lput_Id = -1;
char*	UxlimitDialog_lput_Name = "lput";
int	UxlimitDialog_lshow_Id = -1;
char*	UxlimitDialog_lshow_Name = "lshow";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "limitDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_limitDialog_lput( swidget UxThis, Environment * pEnv );
static void	_limitDialog_lshow( swidget UxThis, Environment * pEnv, int num );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_lput( swidget UxThis, Environment * pEnv )
{
	char *cptr, tmp[20];
	 
	cptr = (char *) setupDialog_getDescrN (setup, pEnv, lpar);
	if (cptr)
	{
	    XtSetSensitive (arrowB_limit2, TRUE);
	    XtSetSensitive (arrowB_limit1, TRUE);
	 
	    XtVaSetValues (labelPeak1,
	                   XmNlabelString, XmStringCreateLtoR (cptr, XmSTRING_DEFAULT_CHARSET),
	                   NULL);
	 
	    sprintf (tmp, "%d", lpar);
	    XmTextFieldSetString (textPar1, tmp);
	      
	    setupDialog_getLimitsN (setup, pEnv, lpar, &lim1, &lim2);
	 
	    sprintf (tmp,"%g", lim1);
	    XmTextFieldSetString (textLimit1_1, tmp);
	    sprintf (tmp,"%g", lim2);
	    XmTextFieldSetString (textLimit1_2, tmp);
	}
	else
	{
	    if (lpar == 0)
	    {
	        lpar = 1;
	        XtSetSensitive (arrowB_limit2, FALSE);
	        XtSetSensitive (arrowB_limit1, TRUE);
	    }
	    else
	    {
	        lpar--;
	        XtSetSensitive (arrowB_limit2, TRUE);
	        XtSetSensitive (arrowB_limit1, FALSE);
	    }
	 
	}
}

static void	_limitDialog_lput( swidget UxThis, Environment * pEnv )
{
	_UxClimitDialog         *UxSaveCtx = UxLimitDialogContext;

	UxLimitDialogContext = (_UxClimitDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_lput( UxThis, pEnv );
	UxLimitDialogContext = UxSaveCtx;
}

static void	Ux_lshow( swidget UxThis, Environment * pEnv, int num )
{
	cpar = lpar = num;
	setupDialog_getStateN (setup, &UxEnv, num, &cstate);
	limitDialog_lput (UxThis, pEnv);
	UxPopupInterface (UxThis, no_grab);
}

static void	_limitDialog_lshow( swidget UxThis, Environment * pEnv, int num )
{
	_UxClimitDialog         *UxSaveCtx = UxLimitDialogContext;

	UxLimitDialogContext = (_UxClimitDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_lshow( UxThis, pEnv, num );
	UxLimitDialogContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_limitDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxClimitDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxLimitDialogContext;
	UxLimitDialogContext = UxContext =
			(_UxClimitDialog *) UxGetContext( UxWidget );
	{
#include "limitDialog_applyCB.c"
	
	
	
	
	
	
	}
	UxLimitDialogContext = UxSaveCtx;
}

static void  helpCB_limitDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxClimitDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxLimitDialogContext;
	UxLimitDialogContext = UxContext =
			(_UxClimitDialog *) UxGetContext( UxWidget );
	{
	setupDialog_setStateN (setup, &UxEnv, cpar, cstate);
	UxPopdownInterface (UxThisWidget);
	}
	UxLimitDialogContext = UxSaveCtx;
}

static void  okCallback_limitDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxClimitDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxLimitDialogContext;
	UxLimitDialogContext = UxContext =
			(_UxClimitDialog *) UxGetContext( UxWidget );
	{
#include "limitDialog_applyCB.c"
	UxPopdownInterface (UxThisWidget);
	
	}
	UxLimitDialogContext = UxSaveCtx;
}

static void  activateCB_arrowB_limit2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxClimitDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxLimitDialogContext;
	UxLimitDialogContext = UxContext =
			(_UxClimitDialog *) UxGetContext( UxWidget );
	{
#include "limitDialog_applyCB.c"
	lpar--;
	limitDialog_lput (UxThisWidget, &UxEnv);
	}
	UxLimitDialogContext = UxSaveCtx;
}

static void  activateCB_arrowB_limit1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxClimitDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxLimitDialogContext;
	UxLimitDialogContext = UxContext =
			(_UxClimitDialog *) UxGetContext( UxWidget );
	{
#include "limitDialog_applyCB.c"
	lpar++;
	limitDialog_lput (UxThisWidget, &UxEnv);
	}
	UxLimitDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_limitDialog()
{
	Widget		_UxParent;


	/* Creation of limitDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "limitDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNwidth, 330,
			XmNheight, 180,
			XmNtitle, "limitDialog",
			NULL );

	limitDialog = XtVaCreateWidget( "limitDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 330,
			XmNheight, 180,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			RES_CONVERT( XmNdialogTitle, "Limit Dialog" ),
			XmNtextFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNcancelLabelString, "Apply" ),
			RES_CONVERT( XmNhelpLabelString, "Cancel" ),
			XmNautoUnmanage, FALSE,
			NULL );
	XtAddCallback( limitDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_limitDialog,
		(XtPointer) UxLimitDialogContext );
	XtAddCallback( limitDialog, XmNhelpCallback,
		(XtCallbackProc) helpCB_limitDialog,
		(XtPointer) UxLimitDialogContext );
	XtAddCallback( limitDialog, XmNokCallback,
		(XtCallbackProc) okCallback_limitDialog,
		(XtPointer) UxLimitDialogContext );

	UxPutContext( limitDialog, (char *) UxLimitDialogContext );
	UxPutClassCode( limitDialog, _UxIfClassId );


	/* Creation of form1 */
	form1 = XtVaCreateManagedWidget( "form1",
			xmFormWidgetClass,
			limitDialog,
			XmNmarginHeight, 3,
			XmNmarginWidth, 3,
			NULL );
	UxPutContext( form1, (char *) UxLimitDialogContext );


	/* Creation of label4 */
	label4 = XtVaCreateManagedWidget( "label4",
			xmLabelWidgetClass,
			form1,
			XmNx, 8,
			XmNy, 0,
			XmNwidth, 90,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Parameter" ),
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 0,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 5,
			XmNalignment, XmALIGNMENT_BEGINNING,
			NULL );
	UxPutContext( label4, (char *) UxLimitDialogContext );


	/* Creation of textPar1 */
	textPar1 = XtVaCreateManagedWidget( "textPar1",
			xmTextFieldWidgetClass,
			form1,
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
	UxPutContext( textPar1, (char *) UxLimitDialogContext );


	/* Creation of labelPeak1 */
	labelPeak1 = XtVaCreateManagedWidget( "labelPeak1",
			xmLabelWidgetClass,
			form1,
			XmNwidth, 150,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "(Peak  1: position)" ),
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 150,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 5,
			XmNalignment, XmALIGNMENT_BEGINNING,
			NULL );
	UxPutContext( labelPeak1, (char *) UxLimitDialogContext );


	/* Creation of textLimit1_1 */
	textLimit1_1 = XtVaCreateManagedWidget( "textLimit1_1",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 100,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNcolumns, 10,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 70,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 48,
			XmNx, 98,
			NULL );
	UxPutContext( textLimit1_1, (char *) UxLimitDialogContext );


	/* Creation of textLimit1_2 */
	textLimit1_2 = XtVaCreateManagedWidget( "textLimit1_2",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 100,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNcolumns, 10,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 200,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 48,
			NULL );
	UxPutContext( textLimit1_2, (char *) UxLimitDialogContext );


	/* Creation of labelTo1 */
	labelTo1 = XtVaCreateManagedWidget( "labelTo1",
			xmLabelWidgetClass,
			form1,
			XmNwidth, 20,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "to" ),
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 175,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 50,
			NULL );
	UxPutContext( labelTo1, (char *) UxLimitDialogContext );


	/* Creation of label8 */
	label8 = XtVaCreateManagedWidget( "label8",
			xmLabelWidgetClass,
			form1,
			XmNwidth, 60,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Limits:" ),
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 50,
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 0,
			NULL );
	UxPutContext( label8, (char *) UxLimitDialogContext );


	/* Creation of arrowB_limit2 */
	arrowB_limit2 = XtVaCreateManagedWidget( "arrowB_limit2",
			xmArrowButtonWidgetClass,
			form1,
			XmNwidth, 20,
			XmNheight, 20,
			XmNarrowDirection, XmARROW_DOWN,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 125,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 20,
			NULL );
	XtAddCallback( arrowB_limit2, XmNactivateCallback,
		(XtCallbackProc) activateCB_arrowB_limit2,
		(XtPointer) UxLimitDialogContext );

	UxPutContext( arrowB_limit2, (char *) UxLimitDialogContext );


	/* Creation of arrowB_limit1 */
	arrowB_limit1 = XtVaCreateManagedWidget( "arrowB_limit1",
			xmArrowButtonWidgetClass,
			form1,
			XmNwidth, 20,
			XmNheight, 20,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 125,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			NULL );
	XtAddCallback( arrowB_limit1, XmNactivateCallback,
		(XtCallbackProc) activateCB_arrowB_limit1,
		(XtPointer) UxLimitDialogContext );

	UxPutContext( arrowB_limit1, (char *) UxLimitDialogContext );


	XtAddCallback( limitDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxLimitDialogContext);


	return ( limitDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_limitDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxClimitDialog         *UxContext;
	static int		_Uxinit = 0;

	UxLimitDialogContext = UxContext =
		(_UxClimitDialog *) UxNewContext( sizeof(_UxClimitDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxlimitDialog_lput_Id = UxMethodRegister( _UxIfClassId,
				UxlimitDialog_lput_Name,
				(void (*)()) _limitDialog_lput );
		UxlimitDialog_lshow_Id = UxMethodRegister( _UxIfClassId,
				UxlimitDialog_lshow_Name,
				(void (*)()) _limitDialog_lshow );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_limitDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

