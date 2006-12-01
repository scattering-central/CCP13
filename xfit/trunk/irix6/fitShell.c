
/*******************************************************************************
	fitShell.c

       Associated Header file: fitShell.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/Text.h>
#include <Xm/ScrolledW.h>
#include <Xm/Label.h>
#include <Xm/Form.h>
#include <Xm/CascadeBG.h>
#include <Xm/CascadeB.h>
#include <Xm/Separator.h>
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/PanedW.h>
#include <X11/Shell.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdarg.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <ctype.h>
#ifndef DESIGN_TIME
typedef void (*vfptr)();
#endif

#include <Xm/Protocols.h>
#include <X11/cursorfont.h>
#include "xfit.m.pm"

extern void show_fileSelect (Widget, char *, void (*) (char *), void (*) ());
extern void ConfirmDialogAsk (Widget, char *, void (*)(), void (*)(), char *);

void Continue ();
void update_messages (char *);
void SetBusyPointer (int);
void message_handler (XtPointer, int *, XtInputId *);
void CreateWindowManagerProtocols (Widget, void (*)(Widget, XtPointer, 
                                   XtPointer));
void ExitCB (Widget, XtPointer, XtPointer);
void SetIconImage (Widget);

#ifndef DESIGN_TIME

#include "fileSelect.h"
#include "confirmDialog.h"
#include "continueDialog.h"
#include "errorDialog.h"
#include "infoDialog.h"
#include "limitDialog.h"
#include "parRowColumn.h"
#include "peakRowColumn.h"
#include "setupDialog.h"
#include "tieDialog.h"
#include "warningDialog.h"
#include "yDialog.h"
#include "headerDialog.h"
#include "channelDialog.h"
#include "otokoFileSelect.h"

#else

extern swidget create_fileSelect();
extern swidget create_confirmDialog();
extern swidget create_continueDialog();
extern swidget create_errorDialog();
extern swidget create_infoDialog();
extern swidget create_limitDialog();
extern swidget create_par_rowColumn();
extern swidget create_peakRowColumn();
extern swidget create_setupDialog();
extern swidget create_tieDialog();
extern swidget create_warningDialog();
extern swidget create_yDialog();
extern swidget create_headerDialog();
extern swidget create_channelDialog();
extern swidget create_otokoFileSelect ();

#endif

typedef struct {
    char *ccp13Host;
} ccp13_app_res;
 
extern ccp13_app_res ccp13_resource;

swidget confirm;
swidget setup;

static swidget fileSelect;
static swidget error;
static swidget warning;
static swidget info;
static swidget channels;
static swidget header;
static swidget minmaxy;
static swidget continueD;
static swidget otokoSelect;

Cursor watch;

static int putfile (char *, char *);
static int get_file (char *, char *);
static void message_parser (char *);
static void say_yes ();
static void say_no ();
static void save_pars ();
static void retry ();
static void quit ();
static void get_yfile (char *, int, int, int, int, int, int);
static void get_xfile (char *, int, int, int, int, int, int);
static void get_initfile (char *, int, int, int, int, int, int);
static void get_outfile (char *);
static void get_hardfile (char *);
static char *chopdir (char *);
static char *checkstr (char *, int *);
static char *findtok (char *, char *);
static char *AddString (char *, char *);
static char *firstnon (char *, char *);
static void freelinks ();
static void CancelSave ();


static	int _UxIfClassId;
int	UxfitShell_SetHeaders_Id = -1;
char*	UxfitShell_SetHeaders_Name = "SetHeaders";
int	UxfitShell_help_Id = -1;
char*	UxfitShell_help_Name = "help";
int	UxfitShell_continue_Id = -1;
char*	UxfitShell_continue_Name = "continue";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "fitShell.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_fitShell_SetHeaders( swidget UxThis, Environment * pEnv, char *h1, char *h2 );
static void	_fitShell_help( swidget UxThis, Environment * pEnv );
static void	_fitShell_continue( swidget UxThis, Environment * pEnv );

/*******************************************************************************
Auxiliary code from the Declarations Editor:
*******************************************************************************/

#include "fitShell_aux.c"

void CreateWindowManagerProtocols (Widget shell, void (*closeFunction) ())
{
    Atom xa_WM_DELETE_WINDOW;

/* Intern the "delete window" atom. */
    xa_WM_DELETE_WINDOW = XInternAtom (UxDisplay,
    "WM_DELETE_WINDOW", False);

/* Add the window manager protocol callback */
    XmAddWMProtocolCallback (shell, xa_WM_DELETE_WINDOW,
    closeFunction, NULL);
}

void ExitCB (Widget w, XtPointer client_data, XtPointer call_data)
{
    ConfirmDialogAsk (confirm, "Do you really want to quit?",
                   quit, NULL, NULL);
}

/*
 *  Create a nice icon image for xfit...
 */
void SetIconImage (Widget wgt)
{
    static Pixmap icon = None;
    static unsigned int iconW = 1, iconH = 1;
    Window iconWindow;
    XWMHints wmHints;
    Screen *screen = XtScreen(wgt);
    Display *dpy = XtDisplay(wgt);
/*
 *  Build the icon
 */
    iconWindow = XCreateSimpleWindow(dpy, RootWindowOfScreen(screen),
                                     0, 0, /* x, y */
                                     iconW, iconH, 0,
                                     BlackPixelOfScreen(screen),
                                     BlackPixelOfScreen(screen));
    if (icon == None)
    {
        Window          root;
        int             x, y;
        unsigned int    bw, depth;
 
        XpmCreatePixmapFromData(dpy, iconWindow,
                                xfit_m_pm, &icon, NULL, NULL);
 	if (icon != None)
	{
            XGetGeometry(dpy, icon, &root, &x, &y, &iconW, &iconH, &bw, &depth);
            XResizeWindow(dpy, iconWindow, iconW, iconH); 
            XSetWindowBackgroundPixmap(dpy, iconWindow, icon);
            XtVaSetValues (wgt, XtNiconWindow, iconWindow, NULL);
	}
    }
}

void Continue ()
{
    message_parser (NULL);
}

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_SetHeaders( swidget UxThis, Environment * pEnv, char *h1, char *h2 )
{
	header1 = h1;
	header2 = h2;
}

static void	_fitShell_SetHeaders( swidget UxThis, Environment * pEnv, char *h1, char *h2 )
{
	_UxCfitShell            *UxSaveCtx = UxFitShellContext;

	UxFitShellContext = (_UxCfitShell *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_SetHeaders( UxThis, pEnv, h1, h2 );
	UxFitShellContext = UxSaveCtx;
}

static void	Ux_help( swidget UxThis, Environment * pEnv )
{
	char *helpstring;
	
	        helpstring = (char *) strdup ("netscape -raise -remote ");
	
	        if (ccp13ptr)
	        {
	            helpstring = AddString (helpstring, " 'openFile (");
	        }
	        else
	        {
	            helpstring = AddString (helpstring, " 'openURL (");
	        }
	
	        helpstring = AddString (helpstring, helpfile);
	        helpstring = AddString (helpstring, ")'");
	
	        if ((system (helpstring) == -1))
	        {
	            fprintf (stderr, "Error opening Netscape browser\n");
	        } 
	
	        free (helpstring);
}

static void	_fitShell_help( swidget UxThis, Environment * pEnv )
{
	_UxCfitShell            *UxSaveCtx = UxFitShellContext;

	UxFitShellContext = (_UxCfitShell *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_help( UxThis, pEnv );
	UxFitShellContext = UxSaveCtx;
}

static void	Ux_continue( swidget UxThis, Environment * pEnv )
{
	message_parser (NULL);
}

static void	_fitShell_continue( swidget UxThis, Environment * pEnv )
{
	_UxCfitShell            *UxSaveCtx = UxFitShellContext;

	UxFitShellContext = (_UxCfitShell *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_continue( UxThis, pEnv );
	UxFitShellContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  popupCB_fitShell(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	{
	
	
	}
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_p1_b1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	message_parser (NULL);
	obFileSelect_OKfunction (otokoSelect, &UxEnv, get_yfile);
	UxPopupInterface (otokoSelect, nonexclusive_grab);
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_p1_b5(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	obFileSelect_OKfunction (otokoSelect, &UxEnv, get_xfile);
	UxPopupInterface (otokoSelect, nonexclusive_grab);
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_p1_b6(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	obFileSelect_OKfunction (otokoSelect, &UxEnv, get_initfile);
	UxPopupInterface (otokoSelect, nonexclusive_grab);
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_p1_b8(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	obFileSelect_OKfunction (otokoSelect, &UxEnv, get_sfile);
	UxPopupInterface (otokoSelect, nonexclusive_grab);
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_p1_b2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	show_fileSelect (fileSelect, "*000.*", get_outfile, NULL);
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_p1_b4(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	ExitCB (UxGetWidget (fitShell), NULL, NULL);
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_top_b1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	{
	
	}
	UxFitShellContext = UxSaveCtx;
}

static void  cascadingCB_menuBar_top_b1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	{
	if (file_ready)
	{
	    XtSetSensitive (UxGetWidget (menuBar_p1_b1), FALSE);
	    XtSetSensitive (UxGetWidget (menuBar_p1_b5), FALSE);
	    XtSetSensitive (UxGetWidget (menuBar_p1_b6), FALSE);
	    XtSetSensitive (UxGetWidget (menuBar_p1_b8), FALSE);
	    XtSetSensitive (UxGetWidget (menuBar_p1_b2), FALSE);
	}
	else
	{
	    XtSetSensitive (UxGetWidget (menuBar_p1_b1), TRUE);
	    XtSetSensitive (UxGetWidget (menuBar_p1_b5), TRUE);
	    XtSetSensitive (UxGetWidget (menuBar_p1_b6), TRUE);
	    XtSetSensitive (UxGetWidget (menuBar_p1_b8), TRUE);
	    XtSetSensitive (UxGetWidget (menuBar_p1_b2), TRUE);
	}
	
	
	}
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_p2_b1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	if (yfile)
	{
	    file_ready = 1;
	    mode = 1;
	    command ("%s\n", yfile);
	}
	else
	{
	    warningDialog_popup (warning, &UxEnv, "No data file has been selected");
	}
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_p2_b2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	if (yfile)
	{
	    file_ready = 1;
	    mode = 0;
	    command ("%s\n", yfile);
	}
	else
	{
	    warningDialog_popup (warning, &UxEnv, "No data file has been selected");
	}
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_p2_b3(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	if (yfile)
	{
	    file_ready = 1;
	    mode = 2;
	    command ("%s\n", yfile);
	}
	else
	{
	    warningDialog_popup (warning, &UxEnv, "No data file has been selected");
	}
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_top_b2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	{
	
	}
	UxFitShellContext = UxSaveCtx;
}

static void  cascadingCB_menuBar_top_b2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	{
	if (yfile && file_ready == 0)
	{
	    XtSetSensitive (UxGetWidget (menuBar_p2_b1), TRUE);
	    XtSetSensitive (UxGetWidget (menuBar_p2_b2), TRUE);
	    XtSetSensitive (UxGetWidget (menuBar_p2_b3), TRUE);
	}
	else
	{
	    XtSetSensitive (UxGetWidget (menuBar_p2_b1), FALSE);
	    XtSetSensitive (UxGetWidget (menuBar_p2_b2), FALSE);
	    XtSetSensitive (UxGetWidget (menuBar_p2_b3), FALSE);
	}
	}
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_p3_b1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	fitShell_help (fitShell, &UxEnv);
	UxFitShellContext = UxSaveCtx;
}

static void  activateCB_menuBar_top_b3(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	{
	
	}
	UxFitShellContext = UxSaveCtx;
}

static void  cascadingCB_menuBar_top_b3(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxFitShellContext = UxContext =
			(_UxCfitShell *) UxGetContext( UxWidget );
	{
	if (helpfile)
	{
	    XtSetSensitive (UxGetWidget (menuBar_p3_b1), TRUE);
	}
	else
	{
	    XtSetSensitive (UxGetWidget (menuBar_p3_b1), FALSE);
	}
	}
	UxFitShellContext = UxSaveCtx;
}

static void  createCB_scrolledText1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCfitShell            *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxFitShellContext;
	UxContext = UxFitShellContext;
	{
	
	}
	UxFitShellContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_fitShell()
{
	Widget		_UxParent;
	Widget		menuBar_p1_shell;
	Widget		menuBar_p2_shell;
	Widget		menuBar_p3_shell;


	/* Creation of fitShell */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	fitShell = XtVaCreatePopupShell( "fitShell",
			applicationShellWidgetClass,
			_UxParent,
			XmNwidth, 530,
			XmNheight, 350,
			XmNx, 430,
			XmNy, 220,
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			XmNtextFontList, UxConvertFontList("8x13bold" ),
			XmNtitle, "xfit",
			XmNiconName, "xfit",
			XmNdeleteResponse, XmDO_NOTHING,
			NULL );
	XtAddCallback( fitShell, XmNpopupCallback,
		(XtCallbackProc) popupCB_fitShell,
		(XtPointer) UxFitShellContext );

	UxPutContext( fitShell, (char *) UxFitShellContext );
	UxPutClassCode( fitShell, _UxIfClassId );


	/* Creation of panedWindow1 */
	panedWindow1 = XtVaCreateManagedWidget( "panedWindow1",
			xmPanedWindowWidgetClass,
			fitShell,
			XmNwidth, 200,
			XmNheight, 200,
			XmNx, 40,
			XmNy, 40,
			XmNunitType, XmPIXELS,
			XmNseparatorOn, FALSE,
			XmNrefigureMode, TRUE,
			XmNsashWidth, 0,
			XmNsashHeight, 0,
			XmNsashShadowThickness, 0,
			XmNsashIndent, 0,
			XmNspacing, 4,
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			NULL );
	UxPutContext( panedWindow1, (char *) UxFitShellContext );


	/* Creation of menuBar */
	menuBar = XtVaCreateManagedWidget( "menuBar",
			xmRowColumnWidgetClass,
			panedWindow1,
			XmNrowColumnType, XmMENU_BAR,
			XmNx, 0,
			XmNy, 0,
			XmNwidth, 350,
			XmNheight, 50,
			XmNpaneMaximum, 32,
			XmNpaneMinimum, 32,
			XmNmenuAccelerator, "<KeyUp>F10",
			RES_CONVERT( XmNlabelString, "" ),
			XmNnumColumns, 6,
			NULL );
	UxPutContext( menuBar, (char *) UxFitShellContext );


	/* Creation of menuBar_p1 */
	menuBar_p1_shell = XtVaCreatePopupShell ("menuBar_p1_shell",
			xmMenuShellWidgetClass, menuBar,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	menuBar_p1 = XtVaCreateWidget( "menuBar_p1",
			xmRowColumnWidgetClass,
			menuBar_p1_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( menuBar_p1, (char *) UxFitShellContext );


	/* Creation of menuBar_p1_b1 */
	menuBar_p1_b1 = XtVaCreateManagedWidget( "menuBar_p1_b1",
			xmPushButtonWidgetClass,
			menuBar_p1,
			RES_CONVERT( XmNlabelString, "Load Y..." ),
			NULL );
	XtAddCallback( menuBar_p1_b1, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_p1_b1,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_p1_b1, (char *) UxFitShellContext );


	/* Creation of menuBar_p1_b5 */
	menuBar_p1_b5 = XtVaCreateManagedWidget( "menuBar_p1_b5",
			xmPushButtonWidgetClass,
			menuBar_p1,
			RES_CONVERT( XmNlabelString, "Load X..." ),
			NULL );
	XtAddCallback( menuBar_p1_b5, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_p1_b5,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_p1_b5, (char *) UxFitShellContext );


	/* Creation of menuBar_p1_b6 */
	menuBar_p1_b6 = XtVaCreateManagedWidget( "menuBar_p1_b6",
			xmPushButtonWidgetClass,
			menuBar_p1,
			RES_CONVERT( XmNlabelString, "Load Parameters..." ),
			NULL );
	XtAddCallback( menuBar_p1_b6, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_p1_b6,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_p1_b6, (char *) UxFitShellContext );


	/* Creation of menuBar_p1_b8 */
	menuBar_p1_b8 = XtVaCreateManagedWidget( "menuBar_p1_b8",
			xmPushButtonWidgetClass,
			menuBar_p1,
			RES_CONVERT( XmNlabelString, "Load SD's..." ),
			NULL );
	XtAddCallback( menuBar_p1_b8, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_p1_b8,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_p1_b8, (char *) UxFitShellContext );


	/* Creation of menuBar_p1_b2 */
	menuBar_p1_b2 = XtVaCreateManagedWidget( "menuBar_p1_b2",
			xmPushButtonWidgetClass,
			menuBar_p1,
			RES_CONVERT( XmNlabelString, "Save Parameters..." ),
			NULL );
	XtAddCallback( menuBar_p1_b2, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_p1_b2,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_p1_b2, (char *) UxFitShellContext );


	/* Creation of menuBar_p1_separator */
	menuBar_p1_separator = XtVaCreateManagedWidget( "menuBar_p1_separator",
			xmSeparatorWidgetClass,
			menuBar_p1,
			NULL );
	UxPutContext( menuBar_p1_separator, (char *) UxFitShellContext );


	/* Creation of menuBar_p1_b4 */
	menuBar_p1_b4 = XtVaCreateManagedWidget( "menuBar_p1_b4",
			xmPushButtonWidgetClass,
			menuBar_p1,
			RES_CONVERT( XmNlabelString, "Quit" ),
			NULL );
	XtAddCallback( menuBar_p1_b4, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_p1_b4,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_p1_b4, (char *) UxFitShellContext );


	/* Creation of menuBar_top_b1 */
	menuBar_top_b1 = XtVaCreateManagedWidget( "menuBar_top_b1",
			xmCascadeButtonWidgetClass,
			menuBar,
			RES_CONVERT( XmNlabelString, "File" ),
			XmNsubMenuId, menuBar_p1,
			RES_CONVERT( XmNmnemonic, "F" ),
			NULL );
	XtAddCallback( menuBar_top_b1, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_top_b1,
		(XtPointer) UxFitShellContext );
	XtAddCallback( menuBar_top_b1, XmNcascadingCallback,
		(XtCallbackProc) cascadingCB_menuBar_top_b1,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_top_b1, (char *) UxFitShellContext );


	/* Creation of menuBar_p2 */
	menuBar_p2_shell = XtVaCreatePopupShell ("menuBar_p2_shell",
			xmMenuShellWidgetClass, menuBar,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	menuBar_p2 = XtVaCreateWidget( "menuBar_p2",
			xmRowColumnWidgetClass,
			menuBar_p2_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( menuBar_p2, (char *) UxFitShellContext );


	/* Creation of menuBar_p2_b1 */
	menuBar_p2_b1 = XtVaCreateManagedWidget( "menuBar_p2_b1",
			xmPushButtonWidgetClass,
			menuBar_p2,
			RES_CONVERT( XmNlabelString, "Fit" ),
			XmNsensitive, FALSE,
			NULL );
	XtAddCallback( menuBar_p2_b1, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_p2_b1,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_p2_b1, (char *) UxFitShellContext );


	/* Creation of menuBar_p2_b2 */
	menuBar_p2_b2 = XtVaCreateManagedWidget( "menuBar_p2_b2",
			xmPushButtonWidgetClass,
			menuBar_p2,
			RES_CONVERT( XmNlabelString, "Plot" ),
			XmNsensitive, FALSE,
			NULL );
	XtAddCallback( menuBar_p2_b2, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_p2_b2,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_p2_b2, (char *) UxFitShellContext );


	/* Creation of menuBar_p2_b3 */
	menuBar_p2_b3 = XtVaCreateManagedWidget( "menuBar_p2_b3",
			xmPushButtonWidgetClass,
			menuBar_p2,
			RES_CONVERT( XmNlabelString, "Auto" ),
			XmNsensitive, FALSE,
			NULL );
	XtAddCallback( menuBar_p2_b3, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_p2_b3,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_p2_b3, (char *) UxFitShellContext );


	/* Creation of menuBar_top_b2 */
	menuBar_top_b2 = XtVaCreateManagedWidget( "menuBar_top_b2",
			xmCascadeButtonWidgetClass,
			menuBar,
			RES_CONVERT( XmNlabelString, "Mode" ),
			XmNsubMenuId, menuBar_p2,
			RES_CONVERT( XmNmnemonic, "M" ),
			NULL );
	XtAddCallback( menuBar_top_b2, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_top_b2,
		(XtPointer) UxFitShellContext );
	XtAddCallback( menuBar_top_b2, XmNcascadingCallback,
		(XtCallbackProc) cascadingCB_menuBar_top_b2,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_top_b2, (char *) UxFitShellContext );


	/* Creation of menuBar_p3 */
	menuBar_p3_shell = XtVaCreatePopupShell ("menuBar_p3_shell",
			xmMenuShellWidgetClass, menuBar,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	menuBar_p3 = XtVaCreateWidget( "menuBar_p3",
			xmRowColumnWidgetClass,
			menuBar_p3_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( menuBar_p3, (char *) UxFitShellContext );


	/* Creation of menuBar_p3_b1 */
	menuBar_p3_b1 = XtVaCreateManagedWidget( "menuBar_p3_b1",
			xmPushButtonWidgetClass,
			menuBar_p3,
			RES_CONVERT( XmNlabelString, "Help" ),
			NULL );
	XtAddCallback( menuBar_p3_b1, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_p3_b1,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_p3_b1, (char *) UxFitShellContext );


	/* Creation of menuBar_top_b3 */
	menuBar_top_b3 = XtVaCreateManagedWidget( "menuBar_top_b3",
			xmCascadeButtonGadgetClass,
			menuBar,
			RES_CONVERT( XmNlabelString, "Help" ),
			RES_CONVERT( XmNmnemonic, "H" ),
			XmNsubMenuId, menuBar_p3,
			XmNx, 300,
			NULL );
	XtAddCallback( menuBar_top_b3, XmNactivateCallback,
		(XtCallbackProc) activateCB_menuBar_top_b3,
		(XtPointer) UxFitShellContext );
	XtAddCallback( menuBar_top_b3, XmNcascadingCallback,
		(XtCallbackProc) cascadingCB_menuBar_top_b3,
		(XtPointer) UxFitShellContext );

	UxPutContext( menuBar_top_b3, (char *) UxFitShellContext );


	/* Creation of form2 */
	form2 = XtVaCreateManagedWidget( "form2",
			xmFormWidgetClass,
			panedWindow1,
			XmNresizePolicy, XmRESIZE_NONE,
			XmNx, 3,
			XmNy, 39,
			XmNwidth, 524,
			XmNheight, 100,
			XmNpaneMaximum, 30,
			XmNpaneMinimum, 30,
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			XmNallowResize, FALSE,
			XmNverticalSpacing, 0,
			XmNrubberPositioning, FALSE,
			XmNskipAdjust, TRUE,
			NULL );
	UxPutContext( form2, (char *) UxFitShellContext );


	/* Creation of label1 */
	label1 = XtVaCreateManagedWidget( "label1",
			xmLabelWidgetClass,
			form2,
			XmNx, 10,
			XmNy, 0,
			XmNwidth, 130,
			XmNheight, 15,
			RES_CONVERT( XmNlabelString, "Message Window" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNbottomAttachment, XmATTACH_FORM,
			NULL );
	UxPutContext( label1, (char *) UxFitShellContext );


	/* Creation of form1 */
	form1 = XtVaCreateManagedWidget( "form1",
			xmFormWidgetClass,
			panedWindow1,
			XmNresizePolicy, XmRESIZE_NONE,
			XmNx, 0,
			XmNy, 230,
			XmNwidth, 350,
			XmNheight, 280,
			XmNpaneMaximum, 1000,
			XmNpaneMinimum, 1,
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNallowResize, TRUE,
			NULL );
	UxPutContext( form1, (char *) UxFitShellContext );


	/* Creation of scrolledWindow1 */
	scrolledWindow1 = XtVaCreateManagedWidget( "scrolledWindow1",
			xmScrolledWindowWidgetClass,
			form1,
			XmNx, 7,
			XmNy, 7,
			XmNbottomAttachment, XmATTACH_FORM,
			XmNleftAttachment, XmATTACH_FORM,
			XmNrightAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNbottomOffset, 0,
			XmNleftOffset, 0,
			XmNrightOffset, 0,
			XmNtopOffset, 0,
			NULL );
	UxPutContext( scrolledWindow1, (char *) UxFitShellContext );


	/* Creation of scrolledText1 */
	scrolledText1 = XtVaCreateManagedWidget( "scrolledText1",
			xmTextWidgetClass,
			scrolledWindow1,
			XmNwidth, 490,
			XmNheight, 67,
			XmNfontList, UxConvertFontList("8x13" ),
			XmNeditable, FALSE,
			XmNvalue, "xfit GUI: last update 11/12/96\nstarting fit program...\n",
			XmNmappedWhenManaged, TRUE,
			XmNmaxLength, 1000,
			XmNcursorPositionVisible, FALSE,
			XmNautoShowCursorPosition, FALSE,
			XmNcolumns, 80,
			XmNeditMode, XmMULTI_LINE_EDIT ,
			NULL );
	UxPutContext( scrolledText1, (char *) UxFitShellContext );

	createCB_scrolledText1( scrolledText1,
			(XtPointer) UxFitShellContext, (XtPointer) NULL );

	XtVaSetValues(menuBar,
			XmNmenuHelpWidget, menuBar_top_b3,
			NULL );

	XtVaSetValues(menuBar_top_b3,
			XmNpositionIndex, 2,
			NULL );


	XtAddCallback( fitShell, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxFitShellContext);


	return ( fitShell );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_fitShell( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCfitShell            *UxContext;
	static int		_Uxinit = 0;

	UxFitShellContext = UxContext =
		(_UxCfitShell *) UxNewContext( sizeof(_UxCfitShell), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxfitShell_SetHeaders_Id = UxMethodRegister( _UxIfClassId,
				UxfitShell_SetHeaders_Name,
				(void (*)()) _fitShell_SetHeaders );
		UxfitShell_help_Id = UxMethodRegister( _UxIfClassId,
				UxfitShell_help_Name,
				(void (*)()) _fitShell_help );
		UxfitShell_continue_Id = UxMethodRegister( _UxIfClassId,
				UxfitShell_continue_Name,
				(void (*)()) _fitShell_continue );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_fitShell();

	CreateWindowManagerProtocols (UxGetWidget (rtrn), ExitCB);
	SetIconImage (UxGetWidget (fitShell));
	
	watch = XCreateFontCursor (UxDisplay, XC_watch);
	fileSelect = create_fileSelect (rtrn);
	confirm = create_confirmDialog (rtrn);
	setup = create_setupDialog (rtrn);
	error = create_errorDialog (rtrn);
	warning = create_warningDialog (rtrn);
	info = create_infoDialog (rtrn);
	channels = create_channelDialog (rtrn);
	header = create_headerDialog (rtrn);
	minmaxy = create_yDialog (rtrn);
	continueD = create_continueDialog (rtrn);
	otokoSelect = create_otokoFileSelect (rtrn);
	
	firstrun = 1;
	inputPause = 0;
	xfile = yfile = initfile = outfile = NULL;
	iffr = ilfr = filenum = 1; ifinc = 0;
	
	if ((ccp13ptr = (char *) getenv ("CCP13HOME")))
	{
	    helpfile = AddString (ccp13ptr, "/doc/xfit.html");
	}
	else
	{
	    helpfile = "http://www.dl.ac.uk/SRS/CCP13/program/xfit.html";
	}
	
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

