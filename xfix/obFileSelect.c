
/*******************************************************************************
	obFileSelect.c

       Associated Header file: obFileSelect.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/Form.h>
#include <Xm/FileSB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <X11/Xlib.h>

#ifndef DESIGN_TIME
typedef void (*vfptr)();
#endif

#define FILTER "*000.*"

static void do_selection (Widget wgt,
                     XtPointer cd, XtPointer cb);


static	int _UxIfClassId;
int	UxobFileSelect_readHeader_Id = -1;
char*	UxobFileSelect_readHeader_Name = "readHeader";
int	UxobFileSelect_OKfunction_Id = -1;
char*	UxobFileSelect_OKfunction_Name = "OKfunction";
int	UxobFileSelect_show_Id = -1;
char*	UxobFileSelect_show_Name = "show";
int	UxobFileSelect_defaults_Id = -1;
char*	UxobFileSelect_defaults_Name = "defaults";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "obFileSelect.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_obFileSelect_readHeader( swidget UxThis, Environment * pEnv, char *file, int mem, int *np, int *nr, int *nf, int *ne, int *nd );
static void	_obFileSelect_OKfunction( swidget UxThis, Environment * pEnv, vfptr okfunc );
static void	_obFileSelect_show( swidget UxThis, Environment * pEnv, int found );
static void	_obFileSelect_defaults( swidget UxThis, Environment * pEnv );

/*******************************************************************************
Auxiliary code from the Declarations Editor:
*******************************************************************************/

/*
 * Extra call backs for internal widgets.
 */

static void do_selection (Widget wgt, XtPointer cd, XtPointer cb)
{
    struct stat stbuf;
    char *text;
    int found;

    text = XmTextFieldGetString (wgt);
    if ((stat (text, &stbuf) != -1) &&
        (stbuf.st_mode & S_IFMT) != S_IFDIR &&
        ((found = obFileSelect_readHeader (XtParent (wgt), &UxEnv, text, filenum,
         &npix, &nrast, &nframe, &fendian, &dtype)) > 0))
    {
	ilfr = nframe;
        if (filename)
          free (filename);
        filename = (char *) strdup (text);
	obFileSelect_show (XtParent(wgt), &UxEnv, found);
    }
    else
    {
        filename = (char *) NULL;
    }
	
    free (text);
}

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_readHeader( swidget UxThis, Environment * pEnv, char *file, int mem, int *np, int *nr, int *nf, int *ne, int *nd )
{
}

static int	_obFileSelect_readHeader( swidget UxThis, Environment * pEnv, char *file, int mem, int *np, int *nr, int *nf, int *ne, int *nd )
{
	int			_Uxrtrn;
	_UxCobFileSelect        *UxSaveCtx = UxObFileSelectContext;

	UxObFileSelectContext = (_UxCobFileSelect *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_readHeader( UxThis, pEnv, file, mem, np, nr, nf, ne, nd );
	UxObFileSelectContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_OKfunction( swidget UxThis, Environment * pEnv, vfptr okfunc )
{
	ok_function = okfunc;
}

static void	_obFileSelect_OKfunction( swidget UxThis, Environment * pEnv, vfptr okfunc )
{
	_UxCobFileSelect        *UxSaveCtx = UxObFileSelectContext;

	UxObFileSelectContext = (_UxCobFileSelect *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_OKfunction( UxThis, pEnv, okfunc );
	UxObFileSelectContext = UxSaveCtx;
}

static void	Ux_show( swidget UxThis, Environment * pEnv, int found )
{
	char buff[10];
	
	if (ilfr != 1)
	{
	    XtSetSensitive (textField1, TRUE);
	    XtSetSensitive (textField2, TRUE);
	    XtSetSensitive (textField3, TRUE);
	}
	XtSetSensitive (menu1, TRUE);
	if (found < 3)
	    XtSetSensitive (menu1_p1_b2, FALSE);
	if (found < 2)
	    XtSetSensitive (menu1_p1_b3, FALSE);
	sprintf (buff, "%d", ilfr);
	XmTextFieldSetString (textField2, buff);
}

static void	_obFileSelect_show( swidget UxThis, Environment * pEnv, int found )
{
	_UxCobFileSelect        *UxSaveCtx = UxObFileSelectContext;

	UxObFileSelectContext = (_UxCobFileSelect *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_show( UxThis, pEnv, found );
	UxObFileSelectContext = UxSaveCtx;
}

static void	Ux_defaults( swidget UxThis, Environment * pEnv )
{
	XmTextFieldSetString (textField1, "1");
	XmTextFieldSetString (textField2, "1");
	XmTextFieldSetString (textField3, "1");
	filenum = 1;
	XtVaSetValues (menu1, XmNmenuHistory, menu1_p1_b1, NULL);
	XtSetSensitive (textField1, FALSE);
	XtSetSensitive (textField2, FALSE);
	XtSetSensitive (textField3, FALSE);
	XtSetSensitive (menu1, FALSE);
}

static void	_obFileSelect_defaults( swidget UxThis, Environment * pEnv )
{
	_UxCobFileSelect        *UxSaveCtx = UxObFileSelectContext;

	UxObFileSelectContext = (_UxCobFileSelect *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_defaults( UxThis, pEnv );
	UxObFileSelectContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  mapCB_obFileSelect(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	obFileSelect_defaults (UxWidget, &UxEnv);
	}
	UxObFileSelectContext = UxSaveCtx;
}

static void  cancelCB_obFileSelect(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	UxPopdownInterface (UxThisWidget);
	}
	UxObFileSelectContext = UxSaveCtx;
}

static void  okCallback_obFileSelect(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	XEvent *event;
	event = (((XmFileSelectionBoxCallbackStruct *) UxCallbackArg)->event);
	
	if ((XtWindow (filelist) == event->xbutton.window) ||
	    (event->type == KeyPress))
	    obFileSelect_defaults (UxWidget, &UxEnv);
	
	if (((XmFileSelectionBoxCallbackStruct *) UxCallbackArg)->reason != XmCR_NO_MATCH)
	{
	    UxPopdownInterface (UxThisWidget);
	    ok_function (filename, npix, nrast, iffr, ilfr, ifinc, filenum, fendian, dtype);
	}
	}
	UxObFileSelectContext = UxSaveCtx;
}

static void  applyCB_obFileSelect(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	char *text, *cptr, dir[256];
	int len;
	 
	text = XmTextFieldGetString (filtertxt);
	cptr = strrchr (text, '/');
	if (strcmp (cptr+1, FILTER) != 0)
	{
	    len = cptr-text+1;
	    strncpy (dir, text, len);
	    dir[len] = '\0';
	    strcat (dir, FILTER);
	    XmFileSelectionDoSearch (UxWidget,
	                XmStringCreateLtoR (dir,
	                XmSTRING_DEFAULT_CHARSET));
	}
	free (text);
	}
	UxObFileSelectContext = UxSaveCtx;
}

static void  noMatchCB_obFileSelect(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	XBell (UxDisplay, 50);
	}
	UxObFileSelectContext = UxSaveCtx;
}

static void  valueChangedCB_textField1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	char *text, *text2, buff[10];
	
	text = XmTextFieldGetString (UxWidget);
	if (*text != '\0')
	{
	    sscanf (text, "%d", &iffr);
	    if (iffr < 1)
	        XmTextFieldSetString (UxWidget, "1");
	    else if (iffr > nframe)
	    {
	        sprintf (buff, "%d", nframe); 
	        XmTextFieldSetString (UxWidget, buff);
	    }
	    if ((iffr > ilfr && ifinc > 0) ||
	        (iffr < ilfr && ifinc < 0))
	    {
	        text2 = XmTextFieldGetString (textField3);
	        if (*text2 != '\0')
	        {
	            sscanf (text2, "%d", &ifinc);
	            sprintf (buff, "%d", -ifinc);
	            XmTextFieldSetString (textField3, buff);
	        }
	        free (text2);
	    }
	}
	free (text);
	}
	UxObFileSelectContext = UxSaveCtx;
}

static void  valueChangedCB_textField2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	char *text, *text2, buff[10];
	
	text = XmTextFieldGetString (UxWidget);
	if (*text != '\0')
	{
	    sscanf (text, "%d", &ilfr);
	    if (ilfr < 1)
	        XmTextFieldSetString (UxWidget, "1");
	    else if (ilfr > nframe)
	    {
	        sprintf (buff, "%d", nframe);
	        XmTextFieldSetString (UxWidget, buff);
	    }
	    if ((iffr > ilfr && ifinc > 0) ||
	        (iffr < ilfr && ifinc < 0))
	    {
	        text2 = XmTextFieldGetString (textField3);
	        if (*text2 != '\0')
	        {
	            sscanf (text2, "%d", &ifinc);
	            sprintf (buff, "%d", -ifinc);
	            XmTextFieldSetString (textField3, buff);
	        }
	        free (text2);
	    }
	}
	free (text);
	
	}
	UxObFileSelectContext = UxSaveCtx;
}

static void  valueChangedCB_textField3(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	char *text, buff[10];
	
	text = XmTextFieldGetString (UxWidget);
	if (*text != '\0')
	{
	    sscanf (text, "%d", &ifinc);
	    if (ifinc < -nframe)
	    {
	        sprintf (buff, "%d", -nframe);
	        XmTextFieldSetString (UxWidget, buff);
	    }
	    else if (ifinc > nframe)
	    {
	        sprintf (buff, "%d", nframe);
	        XmTextFieldSetString (UxWidget, buff);
	    }
	}
	free (text);
	
	}
	UxObFileSelectContext = UxSaveCtx;
}

static void  activateCB_menu1_p1_b1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	filenum = (int) UxClientData;
	do_selection (selection, NULL, NULL);
	
	}
	UxObFileSelectContext = UxSaveCtx;
}

static void  activateCB_menu1_p1_b2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	filenum = (int) UxClientData;
	do_selection (selection, NULL, NULL);
	}
	UxObFileSelectContext = UxSaveCtx;
}

static void  activateCB_menu1_p1_b3(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCobFileSelect        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxObFileSelectContext;
	UxObFileSelectContext = UxContext =
			(_UxCobFileSelect *) UxGetContext( UxWidget );
	{
	filenum = (int) UxClientData;
	do_selection (selection, NULL, NULL);
	
	}
	UxObFileSelectContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_obFileSelect()
{
	Widget		_UxParent;
	Widget		data1_shell;


	/* Creation of obFileSelect */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "obFileSelect_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 245,
			XmNy, 190,
			XmNwidth, 400,
			XmNheight, 400,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "obFileSelect",
			NULL );

	obFileSelect = XtVaCreateWidget( "obFileSelect",
			xmFileSelectionBoxWidgetClass,
			_UxParent,
			XmNresizePolicy, XmRESIZE_NONE,
			XmNunitType, XmPIXELS,
			XmNwidth, 400,
			XmNheight, 400,
			XmNdialogType, XmDIALOG_FILE_SELECTION,
			RES_CONVERT( XmNchildPlacement, "place_below_selection" ),
			RES_CONVERT( XmNdirMask, FILTER ),
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			RES_CONVERT( XmNdialogTitle, "File Selection" ),
			XmNautoUnmanage, FALSE,
			RES_CONVERT( XmNdirSpec, "" ),
			RES_CONVERT( XmNdirectory, "" ),
			XmNmustMatch, TRUE,
			NULL );
	XtAddCallback( obFileSelect, XmNmapCallback,
		(XtCallbackProc) mapCB_obFileSelect,
		(XtPointer) UxObFileSelectContext );
	XtAddCallback( obFileSelect, XmNcancelCallback,
		(XtCallbackProc) cancelCB_obFileSelect,
		(XtPointer) UxObFileSelectContext );
	XtAddCallback( obFileSelect, XmNokCallback,
		(XtCallbackProc) okCallback_obFileSelect,
		(XtPointer) UxObFileSelectContext );
	XtAddCallback( obFileSelect, XmNapplyCallback,
		(XtCallbackProc) applyCB_obFileSelect,
		(XtPointer) UxObFileSelectContext );
	XtAddCallback( obFileSelect, XmNnoMatchCallback,
		(XtCallbackProc) noMatchCB_obFileSelect,
		(XtPointer) UxObFileSelectContext );

	UxPutContext( obFileSelect, (char *) UxObFileSelectContext );
	UxPutClassCode( obFileSelect, _UxIfClassId );


	/* Creation of form1 */
	form1 = XtVaCreateManagedWidget( "form1",
			xmFormWidgetClass,
			obFileSelect,
			XmNresizePolicy, XmRESIZE_NONE,
			XmNunitType, XmPIXELS,
			XmNwidth, 427,
			XmNheight, 65,
			NULL );
	UxPutContext( form1, (char *) UxObFileSelectContext );


	/* Creation of label2 */
	label2 = XtVaCreateManagedWidget( "label2",
			xmLabelWidgetClass,
			form1,
			XmNx, -350,
			XmNy, -1,
			XmNwidth, 90,
			XmNheight, 25,
			RES_CONVERT( XmNlabelString, "Last Frame" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftOffset, 90,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( label2, (char *) UxObFileSelectContext );


	/* Creation of label3 */
	label3 = XtVaCreateManagedWidget( "label3",
			xmLabelWidgetClass,
			form1,
			XmNx, -3,
			XmNy, -1,
			XmNwidth, 90,
			XmNheight, 25,
			RES_CONVERT( XmNlabelString, "Increment" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftOffset, 180,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( label3, (char *) UxObFileSelectContext );


	/* Creation of label4 */
	label4 = XtVaCreateManagedWidget( "label4",
			xmLabelWidgetClass,
			form1,
			XmNx, 365,
			XmNy, -1,
			XmNwidth, 90,
			XmNheight, 25,
			RES_CONVERT( XmNlabelString, "Binary Data" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNtopOffset, 10,
			XmNleftAttachment, XmATTACH_NONE,
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, 14,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( label4, (char *) UxObFileSelectContext );


	/* Creation of textField1 */
	textField1 = XtVaCreateManagedWidget( "textField1",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 70,
			XmNheight, 30,
			XmNvalue, "1",
			XmNsensitive, TRUE,
			XmNleftOffset, 0,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 28,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	XtAddCallback( textField1, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_textField1,
		(XtPointer) UxObFileSelectContext );

	UxPutContext( textField1, (char *) UxObFileSelectContext );


	/* Creation of textField2 */
	textField2 = XtVaCreateManagedWidget( "textField2",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 70,
			XmNheight, 30,
			XmNvalue, "1",
			XmNleftOffset, 90,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 28,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	XtAddCallback( textField2, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_textField2,
		(XtPointer) UxObFileSelectContext );

	UxPutContext( textField2, (char *) UxObFileSelectContext );


	/* Creation of textField3 */
	textField3 = XtVaCreateManagedWidget( "textField3",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 70,
			XmNheight, 30,
			XmNvalue, "1",
			XmNleftOffset, 180,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 28,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	XtAddCallback( textField3, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_textField3,
		(XtPointer) UxObFileSelectContext );

	UxPutContext( textField3, (char *) UxObFileSelectContext );


	/* Creation of data1 */
	data1_shell = XtVaCreatePopupShell ("data1_shell",
			xmMenuShellWidgetClass, form1,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	data1 = XtVaCreateWidget( "data1",
			xmRowColumnWidgetClass,
			data1_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( data1, (char *) UxObFileSelectContext );


	/* Creation of menu1_p1_b1 */
	menu1_p1_b1 = XtVaCreateManagedWidget( "menu1_p1_b1",
			xmPushButtonWidgetClass,
			data1,
			RES_CONVERT( XmNlabelString, "SAXS" ),
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	XtAddCallback( menu1_p1_b1, XmNactivateCallback,
		(XtCallbackProc) activateCB_menu1_p1_b1,
		(XtPointer) 0x1 );

	UxPutContext( menu1_p1_b1, (char *) UxObFileSelectContext );


	/* Creation of menu1_p1_b2 */
	menu1_p1_b2 = XtVaCreateManagedWidget( "menu1_p1_b2",
			xmPushButtonWidgetClass,
			data1,
			RES_CONVERT( XmNlabelString, "WAXS" ),
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	XtAddCallback( menu1_p1_b2, XmNactivateCallback,
		(XtCallbackProc) activateCB_menu1_p1_b2,
		(XtPointer) 0x3 );

	UxPutContext( menu1_p1_b2, (char *) UxObFileSelectContext );


	/* Creation of menu1_p1_b3 */
	menu1_p1_b3 = XtVaCreateManagedWidget( "menu1_p1_b3",
			xmPushButtonWidgetClass,
			data1,
			RES_CONVERT( XmNlabelString, "Calibration" ),
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	XtAddCallback( menu1_p1_b3, XmNactivateCallback,
		(XtCallbackProc) activateCB_menu1_p1_b3,
		(XtPointer) 0x2 );

	UxPutContext( menu1_p1_b3, (char *) UxObFileSelectContext );


	/* Creation of menu1 */
	menu1 = XtVaCreateManagedWidget( "menu1",
			xmRowColumnWidgetClass,
			form1,
			XmNrowColumnType, XmMENU_OPTION,
			XmNsubMenuId, data1,
			XmNleftAttachment, XmATTACH_NONE,
			XmNtopOffset, 25,
			XmNresizeHeight, TRUE,
			XmNresizeWidth, TRUE,
			XmNpacking, XmPACK_TIGHT,
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, -2,
			XmNtopAttachment, XmATTACH_FORM,
			XmNheight, 30,
			XmNwidth, 130,
			XmNresizable, FALSE,
			NULL );
	UxPutContext( menu1, (char *) UxObFileSelectContext );


	/* Creation of label1 */
	label1 = XtVaCreateManagedWidget( "label1",
			xmLabelWidgetClass,
			form1,
			XmNx, 224,
			XmNy, -1,
			XmNwidth, 90,
			XmNheight, 25,
			RES_CONVERT( XmNlabelString, "First Frame" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNbottomAttachment, XmATTACH_NONE,
			XmNbottomWidget, NULL,
			XmNleftOffset, 0,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( label1, (char *) UxObFileSelectContext );


	XtAddCallback( obFileSelect, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxObFileSelectContext);


	return ( obFileSelect );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_obFileSelect( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCobFileSelect        *UxContext;
	static int		_Uxinit = 0;

	UxObFileSelectContext = UxContext =
		(_UxCobFileSelect *) UxNewContext( sizeof(_UxCobFileSelect), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxobFileSelect_readHeader_Id = UxMethodRegister( _UxIfClassId,
				UxobFileSelect_readHeader_Name,
				(void (*)()) _obFileSelect_readHeader );
		UxobFileSelect_OKfunction_Id = UxMethodRegister( _UxIfClassId,
				UxobFileSelect_OKfunction_Name,
				(void (*)()) _obFileSelect_OKfunction );
		UxobFileSelect_show_Id = UxMethodRegister( _UxIfClassId,
				UxobFileSelect_show_Name,
				(void (*)()) _obFileSelect_show );
		UxobFileSelect_defaults_Id = UxMethodRegister( _UxIfClassId,
				UxobFileSelect_defaults_Name,
				(void (*)()) _obFileSelect_defaults );
		_Uxinit = 1;
	}

	{
		filename = (char *) NULL;
		filenum = 1;
		iffr = 1;
		ilfr = 1;
		ifinc = 1;
		nframe = 1;
		rtrn = _Uxbuild_obFileSelect();

		selection = XmFileSelectionBoxGetChild (UxGetWidget (rtrn), XmDIALOG_TEXT);
		filelist  = XmFileSelectionBoxGetChild (UxGetWidget (rtrn), XmDIALOG_LIST);
		filtertxt = XmFileSelectionBoxGetChild (UxGetWidget (rtrn), XmDIALOG_FILTER_TEXT);
		
		XtAddCallback (selection, XmNvalueChangedCallback,
		         (XtCallbackProc) do_selection,
		         (XtPointer) UxObFileSelectContext );
		return(rtrn);
	}
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

