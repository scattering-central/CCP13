
/*******************************************************************************
	confirmDialog.c

       Associated Header file: confirmDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/


void ConfirmDialogAsk (swidget, char *, void (*)(), void (*)(), char *);
static void (*ok_function) ();
static void (*cancel_function) ();


static	int _UxIfClassId;
/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "confirmDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Auxiliary code from the Declarations Editor:
*******************************************************************************/

void ConfirmDialogAsk (swidget wgt, char *msg, void (*yesfunc)(), void (*nofunc) (), char *helpptr)
{
    ok_function = yesfunc;
    cancel_function = nofunc;
    helpfile = helpptr;

    XtVaSetValues (UxGetWidget (wgt),
                   XmNmessageString,
                   XmStringCreateLtoR (msg, XmSTRING_DEFAULT_CHARSET),
		   NULL);

    if (helpfile)
      {
	XtSetSensitive (XmMessageBoxGetChild (UxGetWidget (wgt),
                         XmDIALOG_HELP_BUTTON), TRUE);
      }
    else
      {
	XtSetSensitive (XmMessageBoxGetChild (UxGetWidget (wgt),
                         XmDIALOG_HELP_BUTTON), FALSE);
      }

    UxPopupInterface (wgt, no_grab);

}

/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  okCallback_confirmDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCconfirmDialog       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxConfirmDialogContext;
	UxConfirmDialogContext = UxContext =
			(_UxCconfirmDialog *) UxGetContext( UxWidget );
	{
	    if (ok_function != NULL)
	        ok_function ();
	}
	UxConfirmDialogContext = UxSaveCtx;
}

static void  cancelCB_confirmDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCconfirmDialog       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxConfirmDialogContext;
	UxConfirmDialogContext = UxContext =
			(_UxCconfirmDialog *) UxGetContext( UxWidget );
	{
	    if (cancel_function != NULL)
	        cancel_function ();
	}
	UxConfirmDialogContext = UxSaveCtx;
}

static void  helpCB_confirmDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCconfirmDialog       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxConfirmDialogContext;
	UxConfirmDialogContext = UxContext =
			(_UxCconfirmDialog *) UxGetContext( UxWidget );
	{
	char helpstring[100] = "netscape -raise -remote 'openFile (";
	if (helpfile)
	{
	    strcat (helpstring, helpfile);
	    strcat (helpstring, ")'");
	    if ((system (helpstring) == -1))
	    {
	        printf ("Error opening netscape\n");
	    }
	}
	}
	UxConfirmDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_confirmDialog()
{
	Widget		_UxParent;


	/* Creation of confirmDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "confirmDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 421,
			XmNy, 394,
			XmNwidth, 350,
			XmNheight, 200,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "confirmDialog",
			NULL );

	confirmDialog = XtVaCreateWidget( "confirmDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNdialogType, XmDIALOG_QUESTION,
			XmNunitType, XmPIXELS,
			XmNwidth, 350,
			XmNheight, 200,
			RES_CONVERT( XmNdialogTitle, "Confirm Action" ),
			RES_CONVERT( XmNmessageString, "       \n          " ),
			RES_CONVERT( XmNhelpLabelString, "Help" ),
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			RES_CONVERT( XmNokLabelString, "Yes" ),
			RES_CONVERT( XmNcancelLabelString, "No" ),
			XmNshadowThickness, 2,
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			XmNtextFontList, UxConvertFontList("8x13bold" ),
			XmNdefaultButtonType, XmDIALOG_CANCEL_BUTTON,
			NULL );
	XtAddCallback( confirmDialog, XmNokCallback,
		(XtCallbackProc) okCallback_confirmDialog,
		(XtPointer) UxConfirmDialogContext );
	XtAddCallback( confirmDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_confirmDialog,
		(XtPointer) UxConfirmDialogContext );
	XtAddCallback( confirmDialog, XmNhelpCallback,
		(XtCallbackProc) helpCB_confirmDialog,
		(XtPointer) UxConfirmDialogContext );

	UxPutContext( confirmDialog, (char *) UxConfirmDialogContext );
	UxPutClassCode( confirmDialog, _UxIfClassId );


	XtAddCallback( confirmDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxConfirmDialogContext);


	return ( confirmDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_confirmDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCconfirmDialog       *UxContext;
	static int		_Uxinit = 0;

	UxConfirmDialogContext = UxContext =
		(_UxCconfirmDialog *) UxNewContext( sizeof(_UxCconfirmDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_confirmDialog();

	return (rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

