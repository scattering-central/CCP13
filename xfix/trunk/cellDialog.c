
/*******************************************************************************
	cellDialog.c

       Associated Header file: cellDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/Separator.h>
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/Form.h>
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>

#ifndef DESIGN_TIME
#include "mainWS.h"
#endif

#include "mprintf.h"

extern swidget mainWS;
extern void SetBusyPointer (int);


static	int _UxIfClassId;
/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "cellDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_cellDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCcellDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxCellDialogContext;
	UxCellDialogContext = UxContext =
			(_UxCcellDialog *) UxGetContext( UxWidget );
	{
	char *cptr;
	double a, b, c, alpha, beta, gamma, phix, phiz, dmin, dmax;
	
	cptr = (char *) XmTextFieldGetString (UxGetWidget (spaceGroupText));
	command ("Space %s\n", cptr);
	free (cptr);
	
	cptr = (char *) XmTextFieldGetString (UxGetWidget (aCellText));
	a = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (bCellText));
	b = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (cCellText));
	c = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (alphaCellText));
	alpha = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (betaCellText));
	beta = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (gammaCellText));
	gamma = atof (cptr);
	free (cptr);
	
	command ("Cell %f %f %f %f %f %f\n", a, b, c, alpha, beta, gamma);
	
	
	cptr = (char *) XmTextFieldGetString (UxGetWidget (phiXCellText));
	phix = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (phiZCellText));
	phiz= atof (cptr);
	free (cptr);
	
	command ("Missetting %f %f\n", phix, phiz);
	
	cptr = (char *) XmTextFieldGetString (UxGetWidget (minDCellText));
	dmin = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (maxDCellText));
	dmax = atof (cptr);
	free (cptr);
	
	command ("Generate %f %f\n", dmin, dmax);
	}
	UxCellDialogContext = UxSaveCtx;
}

static void  okCallback_cellDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCcellDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxCellDialogContext;
	UxCellDialogContext = UxContext =
			(_UxCcellDialog *) UxGetContext( UxWidget );
	{
	char *cptr;
	double a, b, c, alpha, beta, gamma, phix, phiz;
	
	cptr = (char *) XmTextFieldGetString (UxGetWidget (spaceGroupText));
	command ("Space %s\n", cptr);
	free (cptr);
	
	cptr = (char *) XmTextFieldGetString (UxGetWidget (aCellText));
	a = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (bCellText));
	b = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (cCellText));
	c = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (alphaCellText));
	alpha = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (betaCellText));
	beta = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (gammaCellText));
	gamma = atof (cptr);
	free (cptr);
	
	command ("Cell %f %f %f %f %f %f\n", a, b, c, alpha, beta, gamma);
	
	
	cptr = (char *) XmTextFieldGetString (UxGetWidget (phiXCellText));
	phix = atof (cptr);
	free (cptr);
	cptr = (char *) XmTextFieldGetString (UxGetWidget (phiZCellText));
	phiz= atof (cptr);
	free (cptr);
	
	command ("Missetting %f %f\n", phix, phiz);
	
	UxPopdownInterface (UxThisWidget);
	
	}
	UxCellDialogContext = UxSaveCtx;
}

static void  helpCB_cellDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCcellDialog          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxCellDialogContext;
	UxCellDialogContext = UxContext =
			(_UxCcellDialog *) UxGetContext( UxWidget );
	{
	UxPopdownInterface (UxThisWidget);
	SetBusyPointer (1);
	mainWS_removeLattice (mainWS, &UxEnv);
	SetBusyPointer (0);
	
	}
	UxCellDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_cellDialog()
{
	Widget		_UxParent;


	/* Creation of cellDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "cellDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNwidth, 370,
			XmNheight, 400,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "cellDialog",
			NULL );

	cellDialog = XtVaCreateWidget( "cellDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 370,
			XmNheight, 400,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNunitType, XmPIXELS,
			RES_CONVERT( XmNcancelLabelString, "Generate" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			RES_CONVERT( XmNdialogTitle, "Cell Dialog" ),
			RES_CONVERT( XmNhelpLabelString, "Cancel" ),
			XmNautoUnmanage, FALSE,
			XmNmarginHeight, 5,
			XmNmarginWidth, 5,
			NULL );
	XtAddCallback( cellDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_cellDialog,
		(XtPointer) UxCellDialogContext );
	XtAddCallback( cellDialog, XmNokCallback,
		(XtCallbackProc) okCallback_cellDialog,
		(XtPointer) UxCellDialogContext );
	XtAddCallback( cellDialog, XmNhelpCallback,
		(XtCallbackProc) helpCB_cellDialog,
		(XtPointer) UxCellDialogContext );

	UxPutContext( cellDialog, (char *) UxCellDialogContext );
	UxPutClassCode( cellDialog, _UxIfClassId );


	/* Creation of cellForm */
	cellForm = XtVaCreateManagedWidget( "cellForm",
			xmFormWidgetClass,
			cellDialog,
			XmNwidth, 370,
			XmNheight, 330,
			NULL );
	UxPutContext( cellForm, (char *) UxCellDialogContext );


	/* Creation of aCellLabel */
	aCellLabel = XtVaCreateManagedWidget( "aCellLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 13,
			XmNy, 13,
			XmNwidth, 30,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "a" ),
			XmNfontList, UxConvertFontList("-adobe-helvetica-medium-r-normal--20-140-100-100-p-100-iso8859-1" ),
			XmNleftOffset, 20,
			XmNtopOffset, 70,
			XmNtopAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( aCellLabel, (char *) UxCellDialogContext );


	/* Creation of aCellText */
	aCellText = XtVaCreateManagedWidget( "aCellText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 50,
			XmNy, 13,
			XmNheight, 30,
			XmNtopOffset, 70,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( aCellText, (char *) UxCellDialogContext );


	/* Creation of bCellLabel */
	bCellLabel = XtVaCreateManagedWidget( "bCellLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 12,
			XmNy, 60,
			XmNwidth, 30,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "b" ),
			XmNfontList, UxConvertFontList("-adobe-helvetica-medium-r-normal--20-140-100-100-p-100-iso8859-1" ),
			XmNleftOffset, 20,
			XmNtopOffset, 115,
			XmNtopAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( bCellLabel, (char *) UxCellDialogContext );


	/* Creation of bCellText */
	bCellText = XtVaCreateManagedWidget( "bCellText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 50,
			XmNy, 60,
			XmNheight, 30,
			XmNtopOffset, 115,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( bCellText, (char *) UxCellDialogContext );


	/* Creation of cCellLabel */
	cCellLabel = XtVaCreateManagedWidget( "cCellLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 12,
			XmNy, 107,
			XmNwidth, 30,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "c" ),
			XmNfontList, UxConvertFontList("-adobe-helvetica-medium-r-normal--20-140-100-100-p-100-iso8859-1" ),
			XmNleftOffset, 20,
			XmNtopOffset, 160,
			XmNtopAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( cCellLabel, (char *) UxCellDialogContext );


	/* Creation of cCellText */
	cCellText = XtVaCreateManagedWidget( "cCellText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 50,
			XmNy, 107,
			XmNheight, 30,
			XmNtopOffset, 160,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( cCellText, (char *) UxCellDialogContext );


	/* Creation of alphaCellText */
	alphaCellText = XtVaCreateManagedWidget( "alphaCellText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 240,
			XmNy, 14,
			XmNheight, 30,
			XmNtopOffset, 70,
			XmNvalue, "    90.0",
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( alphaCellText, (char *) UxCellDialogContext );


	/* Creation of alphaCellLabel */
	alphaCellLabel = XtVaCreateManagedWidget( "alphaCellLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 200,
			XmNy, 14,
			XmNwidth, 30,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "a" ),
			XmNfontList, UxConvertFontList("-adobe-symbol-medium-r-normal--18-180-75-75-p-107-adobe-fontspecific" ),
			XmNtopOffset, 70,
			XmNtopAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( alphaCellLabel, (char *) UxCellDialogContext );


	/* Creation of betaCellLabel */
	betaCellLabel = XtVaCreateManagedWidget( "betaCellLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 200,
			XmNy, 63,
			XmNwidth, 30,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "b" ),
			XmNfontList, UxConvertFontList("-adobe-symbol-medium-r-normal--18-180-75-75-p-107-adobe-fontspecific" ),
			XmNtopOffset, 115,
			XmNtopAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( betaCellLabel, (char *) UxCellDialogContext );


	/* Creation of betaCellText */
	betaCellText = XtVaCreateManagedWidget( "betaCellText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 240,
			XmNy, 63,
			XmNheight, 30,
			XmNtopOffset, 115,
			XmNvalue, "    90.0",
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( betaCellText, (char *) UxCellDialogContext );


	/* Creation of gammaCellLabel */
	gammaCellLabel = XtVaCreateManagedWidget( "gammaCellLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 200,
			XmNy, 109,
			XmNwidth, 30,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "g" ),
			XmNfontList, UxConvertFontList("-adobe-symbol-medium-r-normal--18-180-75-75-p-107-adobe-fontspecific" ),
			XmNtopOffset, 160,
			XmNtopAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( gammaCellLabel, (char *) UxCellDialogContext );


	/* Creation of gammaCellText */
	gammaCellText = XtVaCreateManagedWidget( "gammaCellText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 240,
			XmNy, 109,
			XmNheight, 30,
			XmNtopOffset, 160,
			XmNvalue, "    90.0",
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( gammaCellText, (char *) UxCellDialogContext );


	/* Creation of phiXCellLabel */
	phiXCellLabel = XtVaCreateManagedWidget( "phiXCellLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 10,
			XmNy, 240,
			XmNwidth, 50,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Phi X" ),
			XmNleftOffset, 0,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 220,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( phiXCellLabel, (char *) UxCellDialogContext );


	/* Creation of phiXCellText */
	phiXCellText = XtVaCreateManagedWidget( "phiXCellText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 70,
			XmNy, 240,
			XmNheight, 30,
			XmNleftOffset, 60,
			XmNleftAttachment, XmATTACH_FORM,
			XmNvalue, "    0.0",
			XmNtopOffset, 220,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( phiXCellText, (char *) UxCellDialogContext );


	/* Creation of phiZCellLabel */
	phiZCellLabel = XtVaCreateManagedWidget( "phiZCellLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 10,
			XmNy, 220,
			XmNwidth, 50,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Phi Z" ),
			XmNleftOffset, 0,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 270,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( phiZCellLabel, (char *) UxCellDialogContext );


	/* Creation of phiZCellText */
	phiZCellText = XtVaCreateManagedWidget( "phiZCellText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 70,
			XmNy, 220,
			XmNheight, 30,
			XmNleftOffset, 60,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 270,
			XmNtopAttachment, XmATTACH_FORM,
			XmNvalue, "    0.0",
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( phiZCellText, (char *) UxCellDialogContext );


	/* Creation of minDCellLabel */
	minDCellLabel = XtVaCreateManagedWidget( "minDCellLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 150,
			XmNy, 240,
			XmNwidth, 60,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "D min" ),
			XmNleftOffset, 180,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 220,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( minDCellLabel, (char *) UxCellDialogContext );


	/* Creation of minDCellText */
	minDCellText = XtVaCreateManagedWidget( "minDCellText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 220,
			XmNy, 240,
			XmNheight, 30,
			XmNleftOffset, 240,
			XmNleftAttachment, XmATTACH_FORM,
			XmNvalue, "    0.0",
			XmNtopOffset, 220,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( minDCellText, (char *) UxCellDialogContext );


	/* Creation of maxDCellLabel */
	maxDCellLabel = XtVaCreateManagedWidget( "maxDCellLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 150,
			XmNy, 220,
			XmNwidth, 60,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "D max" ),
			XmNleftOffset, 180,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 270,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( maxDCellLabel, (char *) UxCellDialogContext );


	/* Creation of maxDCellText */
	maxDCellText = XtVaCreateManagedWidget( "maxDCellText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 220,
			XmNy, 220,
			XmNheight, 30,
			XmNleftOffset, 240,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 270,
			XmNtopAttachment, XmATTACH_FORM,
			XmNvalue, "    0.5",
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( maxDCellText, (char *) UxCellDialogContext );


	/* Creation of separator2 */
	separator2 = XtVaCreateManagedWidget( "separator2",
			xmSeparatorWidgetClass,
			cellForm,
			XmNwidth, 374,
			XmNheight, 10,
			XmNx, -9,
			XmNy, 200,
			NULL );
	UxPutContext( separator2, (char *) UxCellDialogContext );


	/* Creation of spaceGroupLabel */
	spaceGroupLabel = XtVaCreateManagedWidget( "spaceGroupLabel",
			xmLabelWidgetClass,
			cellForm,
			XmNx, 18,
			XmNy, 10,
			XmNwidth, 100,
			XmNheight, 30,
			XmNleftOffset, 10,
			XmNtopOffset, 10,
			RES_CONVERT( XmNlabelString, "Space group" ),
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("8x13bold" ),
			NULL );
	UxPutContext( spaceGroupLabel, (char *) UxCellDialogContext );


	/* Creation of spaceGroupText */
	spaceGroupText = XtVaCreateManagedWidget( "spaceGroupText",
			xmTextFieldWidgetClass,
			cellForm,
			XmNwidth, 100,
			XmNx, 120,
			XmNy, 10,
			XmNheight, 30,
			XmNvalue, "P1",
			XmNtopOffset, 10,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( spaceGroupText, (char *) UxCellDialogContext );


	XtAddCallback( cellDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxCellDialogContext);


	return ( cellDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_cellDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCcellDialog          *UxContext;
	static int		_Uxinit = 0;

	UxCellDialogContext = UxContext =
		(_UxCcellDialog *) UxNewContext( sizeof(_UxCcellDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_cellDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

