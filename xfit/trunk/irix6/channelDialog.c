
/*******************************************************************************
	channelDialog.c

       Associated Header file: channelDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/Label.h>
#include <Xm/TextF.h>
#include <Xm/RowColumn.h>
#include <Xm/MessageB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>
#include "mprintf.h"


static	int _UxIfClassId;
int	UxchannelDialog_popup_Id = -1;
char*	UxchannelDialog_popup_Name = "popup";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "channelDialog.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_channelDialog_popup( swidget UxThis, Environment * pEnv, char *string );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_popup( swidget UxThis, Environment * pEnv, char *string )
{
#include "channelDialog_show.c"
}

static int	_channelDialog_popup( swidget UxThis, Environment * pEnv, char *string )
{
	int			_Uxrtrn;
	_UxCchannelDialog       *UxSaveCtx = UxChannelDialogContext;

	UxChannelDialogContext = (_UxCchannelDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_popup( UxThis, pEnv, string );
	UxChannelDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  cancelCB_channelDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCchannelDialog       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxChannelDialogContext;
	UxChannelDialogContext = UxContext =
			(_UxCchannelDialog *) UxGetContext( UxWidget );
	{
	command ("^d\n");
	UxPopdownInterface (UxThisWidget);
	}
	UxChannelDialogContext = UxSaveCtx;
}

static void  okCallback_channelDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCchannelDialog       *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxChannelDialogContext;
	UxChannelDialogContext = UxContext =
			(_UxCchannelDialog *) UxGetContext( UxWidget );
	{
	char *cptr;
	int i1, i2;
	
	cptr = (char *) XmTextFieldGetString (textChann1);
	i1 = atoi (cptr);
	free (cptr);
	
	cptr = (char *) XmTextFieldGetString (textChann2);
	i2 = atoi (cptr);
	free (cptr);
	
	command ("%d %d\n", i1, i2);
	
	UxPopdownInterface (UxThisWidget);
	}
	UxChannelDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_channelDialog()
{
	Widget		_UxParent;


	/* Creation of channelDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "channelDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 340,
			XmNy, 118,
			XmNwidth, 290,
			XmNheight, 160,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "channelDialog",
			NULL );

	channelDialog = XtVaCreateWidget( "channelDialog",
			xmMessageBoxWidgetClass,
			_UxParent,
			XmNwidth, 290,
			XmNheight, 160,
			XmNdialogType, XmDIALOG_TEMPLATE,
			XmNunitType, XmPIXELS,
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNcancelLabelString, "Cancel" ),
			RES_CONVERT( XmNdialogTitle, "Channel Dialog" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNokLabelString, "OK" ),
			XmNresizePolicy, XmRESIZE_NONE,
			XmNtextFontList, UxConvertFontList("8x13bold" ),
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			XmNautoUnmanage, FALSE,
			NULL );
	XtAddCallback( channelDialog, XmNcancelCallback,
		(XtCallbackProc) cancelCB_channelDialog,
		(XtPointer) UxChannelDialogContext );
	XtAddCallback( channelDialog, XmNokCallback,
		(XtCallbackProc) okCallback_channelDialog,
		(XtPointer) UxChannelDialogContext );

	UxPutContext( channelDialog, (char *) UxChannelDialogContext );
	UxPutClassCode( channelDialog, _UxIfClassId );


	/* Creation of rowColumn1 */
	rowColumn1 = XtVaCreateManagedWidget( "rowColumn1",
			xmRowColumnWidgetClass,
			channelDialog,
			XmNwidth, 270,
			XmNheight, 130,
			XmNx, 0,
			XmNy, 0,
			XmNnumColumns, 2,
			XmNpacking, XmPACK_NONE,
			NULL );
	UxPutContext( rowColumn1, (char *) UxChannelDialogContext );


	/* Creation of textChann1 */
	textChann1 = XtVaCreateManagedWidget( "textChann1",
			xmTextFieldWidgetClass,
			rowColumn1,
			XmNwidth, 70,
			XmNx, 150,
			XmNy, 5,
			XmNheight, 30,
			XmNvalue, " ",
			XmNcolumns, 10,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNsensitive, TRUE,
			NULL );
	UxPutContext( textChann1, (char *) UxChannelDialogContext );


	/* Creation of label1 */
	label1 = XtVaCreateManagedWidget( "label1",
			xmLabelWidgetClass,
			rowColumn1,
			XmNx, 20,
			XmNy, 10,
			XmNwidth, 100,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "First channel" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			NULL );
	UxPutContext( label1, (char *) UxChannelDialogContext );


	/* Creation of textChann2 */
	textChann2 = XtVaCreateManagedWidget( "textChann2",
			xmTextFieldWidgetClass,
			rowColumn1,
			XmNwidth, 70,
			XmNx, 150,
			XmNy, 45,
			XmNheight, 30,
			XmNvalue, " ",
			XmNcolumns, 10,
			XmNfontList, UxConvertFontList("8x13bold" ),
			XmNancestorSensitive, TRUE,
			NULL );
	UxPutContext( textChann2, (char *) UxChannelDialogContext );


	/* Creation of label2 */
	label2 = XtVaCreateManagedWidget( "label2",
			xmLabelWidgetClass,
			rowColumn1,
			XmNx, 20,
			XmNy, 50,
			XmNwidth, 100,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Last channel" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			NULL );
	UxPutContext( label2, (char *) UxChannelDialogContext );


	XtAddCallback( channelDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxChannelDialogContext);


	return ( channelDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_channelDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCchannelDialog       *UxContext;
	static int		_Uxinit = 0;

	UxChannelDialogContext = UxContext =
		(_UxCchannelDialog *) UxNewContext( sizeof(_UxCchannelDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxchannelDialog_popup_Id = UxMethodRegister( _UxIfClassId,
				UxchannelDialog_popup_Name,
				(void (*)()) _channelDialog_popup );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_channelDialog();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

