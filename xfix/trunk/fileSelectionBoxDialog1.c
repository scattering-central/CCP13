
/*******************************************************************************
	fileSelectionBoxDialog1.c

       Associated Header file: fileSelectionBoxDialog1.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/FileSB.h>



static	int _UxIfClassId;
/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "fileSelectionBoxDialog1.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_fileSelectionBoxDialog1()
{
	Widget		_UxParent;


	/* Creation of fileSelectionBoxDialog1 */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "fileSelectionBoxDialog1_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 210,
			XmNy, 390,
			XmNwidth, 350,
			XmNheight, 350,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "fileSelectionBoxDialog1",
			NULL );

	fileSelectionBoxDialog1 = XtVaCreateWidget( "fileSelectionBoxDialog1",
			xmFileSelectionBoxWidgetClass,
			_UxParent,
			XmNwidth, 350,
			XmNheight, 350,
			XmNdialogType, XmDIALOG_FILE_SELECTION,
			XmNunitType, XmPIXELS,
			RES_CONVERT( XmNtextString, "bollocks" ),
			NULL );
	UxPutContext( fileSelectionBoxDialog1, (char *) UxFileSelectionBoxDialog1Context );
	UxPutClassCode( fileSelectionBoxDialog1, _UxIfClassId );


	XtAddCallback( fileSelectionBoxDialog1, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxFileSelectionBoxDialog1Context);


	return ( fileSelectionBoxDialog1 );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_fileSelectionBoxDialog1( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCfileSelectionBoxDialog1 *UxContext;
	static int		_Uxinit = 0;

	UxFileSelectionBoxDialog1Context = UxContext =
		(_UxCfileSelectionBoxDialog1 *) UxNewContext( sizeof(_UxCfileSelectionBoxDialog1), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_fileSelectionBoxDialog1();

	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

