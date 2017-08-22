
/*******************************************************************************
	fileSelect.c

       Associated Header file: fileSelect.h
*******************************************************************************/

#include <stdio.h>
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#include "UxXt.h"

#include <Xm/FileSB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/
void show_fileSelect (Widget, char *, char *, void (*)(char *), void (*)());

static void (*fileFunction) (char *);
static void (*cancelFunction) ();
static void nullFunc ();

extern void SetBusyPointer (int);

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#define CONTEXT_MACRO_ACCESS 1
#include "fileSelect.h"
#undef CONTEXT_MACRO_ACCESS

/******************************************************************************
  Auxiliary code from the Declarations Editor:
*******************************************************************************/
void show_fileSelect (Widget wgt, char *filter, char *defname, 
		      void (*fileFunc) (char *), void (*cancelFunc) ())
{
    SetBusyPointer (1);

    if (fileFunc) 
      fileFunction = fileFunc;
    else
      fileFunction = nullFunc;

    if (cancelFunc)
      cancelFunction = cancelFunc;
    else
      cancelFunction = nullFunc;

    printf ("Default file name: %s\n", defname);
    XtVaSetValues (wgt,
                   XmNpattern,
                   XmStringCreateLtoR (filter, XmSTRING_DEFAULT_CHARSET),
		   XmNdirSpec,
                   XmStringCreateLtoR (defname, XmSTRING_DEFAULT_CHARSET),
                   NULL);
    UxPopupInterface (wgt, no_grab);
    SetBusyPointer (0);
}

static void nullFunc ()
{
  char a = '\0';
}

/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static	void	okCallback_fileSelect(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{

	_UxCfileSelect          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFileSelectContext;
	UxFileSelectContext = UxContext =
			(_UxCfileSelect *) UxGetContext( UxWidget );
	{
	    char *filename;

	    XmStringGetLtoR (((XmFileSelectionBoxCallbackStruct *) cb)->value,
			     XmSTRING_DEFAULT_CHARSET, &filename);
	    UxPopdownInterface (wgt);
	    SetBusyPointer (TRUE);
	    fileFunction (filename);
	    SetBusyPointer (FALSE);
	}
	UxFileSelectContext = UxSaveCtx;
}

static	void	cancelCB_fileSelect(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfileSelect          *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFileSelectContext;
	UxFileSelectContext = UxContext =
			(_UxCfileSelect *) UxGetContext( UxWidget );
	{
	    UxPopdownInterface (wgt);
	    cancelFunction ();
	}
	UxFileSelectContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_fileSelect()
{
	Widget		_UxParent;


	/* Creation of fileSelect */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "fileSelect_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 341,
			XmNy, 119,
			XmNwidth, 350,
			XmNheight, 400,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "fileSelect",
			NULL );

	fileSelect = XtVaCreateWidget( "fileSelect",
			xmFileSelectionBoxWidgetClass,
			_UxParent,
			XmNwidth, 350,
			XmNheight, 400,
			XmNdialogType, XmDIALOG_FILE_SELECTION,
			XmNunitType, XmPIXELS,
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			RES_CONVERT( XmNdialogTitle, "File Selection" ),
			RES_CONVERT( XmNforeground, "white" ),
			XmNbuttonFontList, UxConvertFontList( "8x13bold" ),
			XmNlabelFontList, UxConvertFontList( "8x13bold" ),
			XmNtextFontList, UxConvertFontList( "8x13bold" ),
			NULL );
	XtAddCallback( fileSelect, XmNokCallback,
		(XtCallbackProc) okCallback_fileSelect,
		(XtPointer) UxFileSelectContext );
	XtAddCallback( fileSelect, XmNcancelCallback,
		(XtCallbackProc) cancelCB_fileSelect,
		(XtPointer) UxFileSelectContext );

	UxPutContext( fileSelect, (char *) UxFileSelectContext );


	XtAddCallback( fileSelect, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxFileSelectContext);


	return ( fileSelect );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_fileSelect( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCfileSelect          *UxContext;

	UxFileSelectContext = UxContext =
		(_UxCfileSelect *) UxNewContext( sizeof(_UxCfileSelect), False );

	UxParent = _UxUxParent;

	rtrn = _Uxbuild_fileSelect();
        XtUnmanageChild (XmFileSelectionBoxGetChild (rtrn, XmDIALOG_HELP_BUTTON));

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/
