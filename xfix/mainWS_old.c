
/*******************************************************************************
	mainWS.c

       Associated Header file: mainWS.h
       Associated Resource file: mainWS.rf
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
#include <Xm/ArrowB.h>
#include <Xm/TextF.h>
#include <Xm/DrawingA.h>
#include <Xm/Frame.h>
#include <Xm/Label.h>
#include <Xm/Form.h>
#include <Xm/PanedW.h>
#include <Xm/ToggleBG.h>
#include <Xm/ToggleB.h>
#include <Xm/Separator.h>
#include <Xm/CascadeB.h>
#include <Xm/SeparatoG.h>
#include <Xm/PushB.h>
#include <Xm/PushBG.h>
#include <Xm/RowColumn.h>
#include <Xm/MainW.h>
#include <X11/Shell.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <string.h>
#include <Xm/Protocols.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdarg.h>
#include <sys/mman.h>
#include <sys/fcntl.h>
#include <errno.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>
#include <X11/cursorfont.h>
#include <math.h>

#ifndef DESIGN_TIME
typedef void (*vfptr)();
#endif

#include "xfix.x.pm"
#include "graphics.h"

static void CreateWindowManagerProtocols (Widget ,void (*)(Widget, XtPointer, XtPointer));
static void SetIconImage (Widget);
static void OpenFile (char *);
static void setupFile (char *, int, int, int, int, int, int);
static void NewFile (char *, int, int, int, int, int, int);
static void ReadFrame ();
static int putfile (char *, char *);
static int get_file (char *, char *);
static void message_parser (char *);
static void RefreshPalette ();
static void CommandHandler (char *);
static int optcmp (char *, char **);
static void say_yes ();
static void say_no ();
static void retry ();
static char *checkstr (char *, int *);
static char *AddString (char *, char *);
static char *findtok (char *, char *);
static char *firstnon (char *, char *);
static void quit ();
static void SaveData ();
static void CancelSave ();
static void get_outfile (char *);

void SetBusyPointer (int);
void command (char *, ...);
void update_messages (char *);
void message_handler (XtPointer, int *, XtInputId *);
void Continue ();
void ExitCB (Widget, XtPointer, XtPointer);

extern void show_fileSelect (Widget, char *, char *, void (*) (char *), void (*) ());
extern void ConfirmDialogAsk (Widget, char *, void (*)(), void (*)(), char *);

#ifndef DESIGN_TIME

#include "fileSelect.h"
#include "confirmDialog.h"
#include "parameterDialog.h"
#include "objectEditDialog.h"
#include "lineEditDialog.h"
#include "scanEditDialog.h"
#include "cellDialog.h"
#include "continueDialog.h"
#include "errorDialog.h"
#include "infoDialog.h"
#include "limitDialog.h"
#include "parRowColumn.h"
#include "peakRowColumn.h"
#include "setupDialog.h"
#include "tieDialog.h"
#include "warningDialog.h"
#include "workingDialog.h"
#include "yDialog.h"
#include "headerDialog.h"
#include "channelDialog.h"
#include "refineDialog.h"
#include "bslFileSelect.h"

#else

extern swidget create_fileSelect();
extern swidget create_confirmDialog();
extern swidget create_parameterDialog();
extern swidget create_objectEditDialog();
extern swidget create_lineEditDialog();
extern swidget create_scanEditDialog();
extern swidget create_cellDialog();
extern swidget create_continueDialog();
extern swidget create_errorDialog();
extern swidget create_infoDialog();
extern swidget create_limitDialog();
extern swidget create_par_rowColumn();
extern swidget create_peakRowColumn();
extern swidget create_setupDialog();
extern swidget create_tieDialog();
extern swidget create_warningDialog();
extern swidget create_workingDialog();
extern swidget create_yDialog();
extern swidget create_headerDialog();
extern swidget create_channelDialog();
extern swidget create_refineDialog();
extern swidget create_bslFileSelect();

#endif

static swidget drawFSD;
static swidget parameterD;
static swidget objectD;
static swidget lineD;
static swidget scanD;
static swidget cellD;
static swidget error;
static swidget warning;
static swidget working;
static swidget info;
static swidget channels;
static swidget header;
static swidget minmaxy;
static swidget continueD;
static swidget refineD;
static swidget bslSelect;

swidget setup;
swidget confirmD;

Cursor watch, currentCursor;

static float *data;
static char *mapAddress;
static int fileDescriptor;
static int npix, nrast, iffr, ilfr, ifinc, filenum;


static	int _UxIfClassId;
int	UxmainWS_getCentre_Id = -1;
char*	UxmainWS_getCentre_Name = "getCentre";
int	UxmainWS_setRotX_Id = -1;
char*	UxmainWS_setRotX_Name = "setRotX";
int	UxmainWS_setRefineRotX_Id = -1;
char*	UxmainWS_setRefineRotX_Name = "setRefineRotX";
int	UxmainWS_setRotY_Id = -1;
char*	UxmainWS_setRotY_Name = "setRotY";
int	UxmainWS_setRefineRotY_Id = -1;
char*	UxmainWS_setRefineRotY_Name = "setRefineRotY";
int	UxmainWS_setRotZ_Id = -1;
char*	UxmainWS_setRotZ_Name = "setRotZ";
int	UxmainWS_setRefineRotZ_Id = -1;
char*	UxmainWS_setRefineRotZ_Name = "setRefineRotZ";
int	UxmainWS_imageLimits_Id = -1;
char*	UxmainWS_imageLimits_Name = "imageLimits";
int	UxmainWS_setRefineCentre_Id = -1;
char*	UxmainWS_setRefineCentre_Name = "setRefineCentre";
int	UxmainWS_setDistance_Id = -1;
char*	UxmainWS_setDistance_Name = "setDistance";
int	UxmainWS_setTilt_Id = -1;
char*	UxmainWS_setTilt_Name = "setTilt";
int	UxmainWS_setRefineTilt_Id = -1;
char*	UxmainWS_setRefineTilt_Name = "setRefineTilt";
int	UxmainWS_removeLattice_Id = -1;
char*	UxmainWS_removeLattice_Name = "removeLattice";
int	UxmainWS_setWavelength_Id = -1;
char*	UxmainWS_setWavelength_Name = "setWavelength";
int	UxmainWS_SetHeaders_Id = -1;
char*	UxmainWS_SetHeaders_Name = "SetHeaders";
int	UxmainWS_setCal_Id = -1;
char*	UxmainWS_setCal_Name = "setCal";
int	UxmainWS_help_Id = -1;
char*	UxmainWS_help_Name = "help";
int	UxmainWS_setCentreX_Id = -1;
char*	UxmainWS_setCentreX_Name = "setCentreX";
int	UxmainWS_setCentreY_Id = -1;
char*	UxmainWS_setCentreY_Name = "setCentreY";
int	UxmainWS_continue_Id = -1;
char*	UxmainWS_continue_Name = "continue";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "mainWS.h"
#undef CONTEXT_MACRO_ACCESS

Widget	mainWS;

/*******************************************************************************
       The following are translation tables.
*******************************************************************************/

static char	*area1PointTable = "#override\n\
<Expose>:refresh_image1()\n\
<ButtonPress>:area1_point_handler()\n\
<MotionNotify>:area1_point_handler()\n";

static char	*area2PointTable = "#override\n\
<Expose>:refresh_image2()\n\
<ButtonPress>:area2_point_handler()\n\
<MotionNotify>:area2_point_handler()\n";

static char	*area1LineTable = "#override\n\
<Expose>:refresh_image1()\n\
<ButtonPress>:area1_line_handler()\n\
<Btn1Motion>:area1_line_handler()\n\
<Btn2Motion>:area1_line_handler()\n";

static char	*area1ThickTable = "#override\n\
<Expose>:refresh_image1()\n\
<ButtonPress>:area1_thick_handler()\n\
<Btn1Motion>:area1_thick_handler()\n\
<Btn2Motion>:area1_thick_handler()\n";

static char	*area1RectTable = "#override\n\
<Expose>:refresh_image1()\n\
<ButtonPress>:area1_rect_handler()\n\
<Btn1Motion>:area1_rect_handler()\n\
<Btn2Motion>:area1_rect_handler()\n";

static char	*area1PolyTable = "#override\n\
<Expose>:refresh_image1()\n\
<ButtonPress>:area1_poly_handler()\n\
<ButtonRelease>:area1_poly_handler()\n\
<Btn1Motion>:area1_poly_handler()\n";

static char	*area1ZoomTable = "#override\n\
<Expose>:refresh_image1()\n\
<ButtonPress>:area1_zoom_handler()\n\
<Btn1Motion>:area1_zoom_handler()\n\
<Btn2Motion>:area1_zoom_handler()\n";

static char	*area2LineTable = "#override\n\
<Expose>:refresh_image2()\n\
<ButtonPress>:area2_line_handler()\n\
<Btn1Motion>:area2_line_handler()\n\
<Btn2Motion>:area2_line_handler()\n";

static char	*area2ThickTable = "#override\n\
<Expose>:refresh_image2()\n\
<ButtonPress>:area2_thick_handler()\n\
<Btn1Motion>:area2_thick_handler()\n\
<Btn2Motion>:area2_thick_handler()\n";

static char	*area2RectTable = "#override\n\
<Expose>:refresh_image2()\n\
<ButtonPress>:area2_rect_handler()\n\
<Btn1Motion>:area2_rect_handler()\n\
<Btn2Motion>:area2_rect_handler()\n";

static char	*area2PolyTable = "#override\n\
<Expose>:refresh_image2()\n\
<ButtonPress>:area2_poly_handler()\n\
<ButtonRelease>:area2_poly_handler()\n\
<Btn1Motion>:area2_poly_handler()\n";

static char	*area1SectorTable = "#override\n\
<Expose>:refresh_image1()\n\
<ButtonPress>:area1_sector_handler()\n\
<Btn1Motion>:area1_sector_handler()\n\
<Btn2Motion>:area1_sector_handler()\n";

/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_mainWS_getCentre( swidget UxThis, Environment * pEnv, double *xc, double *yc );
static void	_mainWS_setRotX( swidget UxThis, Environment * pEnv, double value );
static void	_mainWS_setRefineRotX( swidget UxThis, Environment * pEnv, Boolean value );
static void	_mainWS_setRotY( swidget UxThis, Environment * pEnv, double value );
static void	_mainWS_setRefineRotY( swidget UxThis, Environment * pEnv, Boolean value );
static void	_mainWS_setRotZ( swidget UxThis, Environment * pEnv, double value );
static void	_mainWS_setRefineRotZ( swidget UxThis, Environment * pEnv, Boolean value );
static int	_mainWS_imageLimits( swidget UxThis, Environment * pEnv, int *x, int *y, int *width, int *height );
static void	_mainWS_setRefineCentre( swidget UxThis, Environment * pEnv, Boolean value );
static void	_mainWS_setDistance( swidget UxThis, Environment * pEnv, double value );
static void	_mainWS_setTilt( swidget UxThis, Environment * pEnv, double value );
static void	_mainWS_setRefineTilt( swidget UxThis, Environment * pEnv, Boolean value );
static void	_mainWS_removeLattice( swidget UxThis, Environment * pEnv );
static void	_mainWS_setWavelength( swidget UxThis, Environment * pEnv, double value );
static void	_mainWS_SetHeaders( swidget UxThis, Environment * pEnv, char *h1, char *h2 );
static void	_mainWS_setCal( swidget UxThis, Environment * pEnv, double value );
static void	_mainWS_help( swidget UxThis, Environment * pEnv, char *string );
static void	_mainWS_setCentreX( swidget UxThis, Environment * pEnv, double value );
static void	_mainWS_setCentreY( swidget UxThis, Environment * pEnv, double value );
static void	_mainWS_continue( swidget UxThis, Environment * pEnv );

/*******************************************************************************
Auxiliary code from the Declarations Editor:
*******************************************************************************/

/******************************************************************
   This function establishes a protocol callback that detects 
   the window manager Close command.  */

static void CreateWindowManagerProtocols(Widget shell, void (*CloseFunction) ())
{
  Atom  xa_WM_DELETE_WINDOW;

  xa_WM_DELETE_WINDOW = XInternAtom (UxDisplay, "WM_DELETE_WINDOW", False);
  XmAddWMProtocolCallback (shell, xa_WM_DELETE_WINDOW, CloseFunction, NULL);
}

/* This function pops up the Exit dialog box. */
void ExitCB(Widget w, XtPointer client_data, XtPointer call_data)
{
   ConfirmDialogAsk (confirmD, "Do you really want to exit?", quit, NULL, NULL);
}

static void ReadFrame ()
{

    int psize = sysconf (_SC_PAGESIZE);             /* System page size     */
    int nbytes = npix*nrast*sizeof (float);         /* Nos of bytes to read */
    long offset = (iffr - 1) * nbytes;             /* Offset from start    */
    off_t off;                                      /* Offset from map address */
 
    off = (off_t) (offset - offset % psize);
    nbytes += offset - off;

    if ((mapAddress = (char *) mmap ((void *) 0, (size_t) nbytes, PROT_READ, MAP_SHARED, 
                                     fileDescriptor, off)) == (caddr_t) -1)
    {
        perror ("mmap");
        return;
    }

    data = (float *) (mapAddress + offset - off);
}

static void OpenFile (char *fname)
{
    if (iffr <= ilfr - ifinc)
        XtSetSensitive (UxGetWidget (frameButton), True);
    else	
        XtSetSensitive (UxGetWidget (frameButton), False);

    if (currentDir)
    {
        free (currentDir);
        currentDir = NULL;
    }    
    if (fileName)
    {
        free (fileName);
        fileName = NULL;
    }
    if (yfile)
    {
        free (yfile);
        yfile = NULL;
    }
    psCounter = 0;

    currentDir = (char *) strdup (fname);
    *(currentDir + strlen (fname) - 10) = '\0';
    fileName = (char *) strdup (fname + strlen (fname) - 10);
    yfile = (char *) strdup (fileName);

    switch (filenum)
    {
    case 1:
      *(yfile + 5) = '1';
      break;
    case 2:
      *(yfile + 5) = '2';
      break;
    case 3:
      *(yfile + 5) = '3';
      break;
    default:
      break;
    }

    if ((fileDescriptor = open (yfile, O_RDONLY)) < 0)
    {
        fprintf (stderr, "Error opening binary file %s\n", yfile);
        return;
    }

    SetBusyPointer (1);
    ReadFrame ();
    sprintf (textBuf, "%10s", (fileName + strlen (fileName) - 10));
    XmTextFieldSetString (UxGetWidget (fileText), textBuf);
    sprintf (textBuf, "%4d", iffr);
    XmTextFieldSetString (UxGetWidget (frameText), textBuf);
    
    CloseAllImages ();
    DestroyAllObjects ();
    DestroyAllLines ();
    DestroyAllScans ();
    DestroyDrawnPoints ();
    totalImages = 1;
    currentImage = 0;
    xi[currentImage] = CreateFixImage (0, 0, npix, nrast);
    SetBusyPointer (0);

    if (xi[currentImage])
    {
       LoadImage (xi[currentImage]);
       XmTextFieldSetString (UxGetWidget (imageText), "0");
    }
    else
    {
       errorDialog_popup (error, &UxEnv, "Unable to create image");
       totalImages = 0;
       currentImage = -1;
    }

    XtSetSensitive (UxGetWidget (textHigh), True);
    XtSetSensitive (UxGetWidget (textLow), True);

    
    command ("File\n");
}

static void setupFile (char *fname, int np, int nr, int ff, int lf, int inc, int fnum)
{
   npix = np;
   nrast = nr;
   iffr = ff;
   ilfr = lf;
   ifinc = inc;
   filenum = fnum;
   OpenFile (fname);
}

static void NewFile (char *fname, int np, int nr, int ff, int lf, int inc, int fnum)
{
   char *argv[9], buf[10];
   int pid;

   SetBusyPointer (1);
   switch (pid = fork ())
   {
      case 0:
         argv[0] = "xfix";
         argv[1] = fname;
         sprintf (buf, "%d", np);
         argv[2] = (char *) strdup (buf);
         sprintf (buf, "%d", nr);
         argv[3] = (char *) strdup (buf);
         sprintf (buf, "%d", ff);
         argv[4] = (char *) strdup (buf);
         sprintf (buf, "%d", lf);
         argv[5] = (char *) strdup (buf);
         sprintf (buf, "%d", inc);
         argv[6] = (char *) strdup (buf);
         sprintf (buf, "%d", fnum);
         argv[7] = (char *) strdup (buf);
         argv[8] = (char *) NULL;

         execvp ("xfix", argv);
         perror ("fork");
         fprintf (stderr,"Could not exec new xfix\n");
         _exit (0);

      case -1:
         fprintf (stderr,"Could not fork xfix\n");
         exit (0);

      default:
         break;
   }
   SetBusyPointer (0);
}
static void SetIconImage (Widget wgt)
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
                                xfix_x_pm, &icon, NULL, NULL);
 
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

#include "mainWS_aux.c"
#include "graphics.c"

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_getCentre( swidget UxThis, Environment * pEnv, double *xc, double *yc )
{
	*xc = centreX;
	*yc = centreY;
}

static void	_mainWS_getCentre( swidget UxThis, Environment * pEnv, double *xc, double *yc )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_getCentre( UxThis, pEnv, xc, yc );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setRotX( swidget UxThis, Environment * pEnv, double value )
{
	rotX = value;
}

static void	_mainWS_setRotX( swidget UxThis, Environment * pEnv, double value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setRotX( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setRefineRotX( swidget UxThis, Environment * pEnv, Boolean value )
{
	refineRotX = value;
}

static void	_mainWS_setRefineRotX( swidget UxThis, Environment * pEnv, Boolean value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setRefineRotX( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setRotY( swidget UxThis, Environment * pEnv, double value )
{
	rotY = value;
}

static void	_mainWS_setRotY( swidget UxThis, Environment * pEnv, double value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setRotY( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setRefineRotY( swidget UxThis, Environment * pEnv, Boolean value )
{
	refineRotY = value;
}

static void	_mainWS_setRefineRotY( swidget UxThis, Environment * pEnv, Boolean value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setRefineRotY( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setRotZ( swidget UxThis, Environment * pEnv, double value )
{
	rotZ = value;
}

static void	_mainWS_setRotZ( swidget UxThis, Environment * pEnv, double value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setRotZ( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setRefineRotZ( swidget UxThis, Environment * pEnv, Boolean value )
{
	refineRotZ = value;
}

static void	_mainWS_setRefineRotZ( swidget UxThis, Environment * pEnv, Boolean value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setRefineRotZ( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static int	Ux_imageLimits( swidget UxThis, Environment * pEnv, int *x, int *y, int *width, int *height )
{
	if (currentImage >= 0)
	{
	   *x = xi[currentImage]->x;
	   *y = xi[currentImage]->y;
	   *width = xi[currentImage]->ipix;
	   *height = xi[currentImage]->irast;
	   return (0);
	}
	else
	{
	   return (1);
	}
}

static int	_mainWS_imageLimits( swidget UxThis, Environment * pEnv, int *x, int *y, int *width, int *height )
{
	int			_Uxrtrn;
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_imageLimits( UxThis, pEnv, x, y, width, height );
	UxMainWSContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_setRefineCentre( swidget UxThis, Environment * pEnv, Boolean value )
{
	refineCentre = value;
}

static void	_mainWS_setRefineCentre( swidget UxThis, Environment * pEnv, Boolean value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setRefineCentre( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setDistance( swidget UxThis, Environment * pEnv, double value )
{
	distance = value;
}

static void	_mainWS_setDistance( swidget UxThis, Environment * pEnv, double value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setDistance( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setTilt( swidget UxThis, Environment * pEnv, double value )
{
	tilt = value;
}

static void	_mainWS_setTilt( swidget UxThis, Environment * pEnv, double value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setTilt( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setRefineTilt( swidget UxThis, Environment * pEnv, Boolean value )
{
	refineTilt = value;
}

static void	_mainWS_setRefineTilt( swidget UxThis, Environment * pEnv, Boolean value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setRefineTilt( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_removeLattice( swidget UxThis, Environment * pEnv )
{
	RepaintOverDrawnPoints ();
	DestroyDrawnPoints ();
	
	RepaintOverDrawnRings ();
	DestroyDrawnRings ();
}

static void	_mainWS_removeLattice( swidget UxThis, Environment * pEnv )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_removeLattice( UxThis, pEnv );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setWavelength( swidget UxThis, Environment * pEnv, double value )
{
	wavelength = value;
}

static void	_mainWS_setWavelength( swidget UxThis, Environment * pEnv, double value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setWavelength( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_SetHeaders( swidget UxThis, Environment * pEnv, char *h1, char *h2 )
{
	header1 = h1;
	header2 = h2;
}

static void	_mainWS_SetHeaders( swidget UxThis, Environment * pEnv, char *h1, char *h2 )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_SetHeaders( UxThis, pEnv, h1, h2 );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setCal( swidget UxThis, Environment * pEnv, double value )
{
	dcal = value;
}

static void	_mainWS_setCal( swidget UxThis, Environment * pEnv, double value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setCal( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_help( swidget UxThis, Environment * pEnv, char *string )
{
	char *helpString, *tmp;
	
	helpString = (char *) strdup ("netscape -raise -remote ");
	
	if (ccp13ptr)
	{
	    tmp = AddString (helpString, " 'openFile (");
	}
	else
	{
	    tmp = AddString (helpString, " 'openURL (");
	}
	free (helpString);
	helpString = AddString (tmp, helpfile);
	free (tmp);
	tmp = AddString (helpString, string);
	free (helpString);
	helpString = AddString (tmp, ")'");
	free (tmp);
	
	if ((system (helpString) == -1))
	{
	    fprintf (stderr, "Error opening Netscape browser\n");
	} 
	
	free (helpString);
}

static void	_mainWS_help( swidget UxThis, Environment * pEnv, char *string )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_help( UxThis, pEnv, string );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setCentreX( swidget UxThis, Environment * pEnv, double value )
{
	centreX = value;
}

static void	_mainWS_setCentreX( swidget UxThis, Environment * pEnv, double value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setCentreX( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_setCentreY( swidget UxThis, Environment * pEnv, double value )
{
	centreY = value;
}

static void	_mainWS_setCentreY( swidget UxThis, Environment * pEnv, double value )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setCentreY( UxThis, pEnv, value );
	UxMainWSContext = UxSaveCtx;
}

static void	Ux_continue( swidget UxThis, Environment * pEnv )
{
	message_parser (NULL);
}

static void	_mainWS_continue( swidget UxThis, Environment * pEnv )
{
	_UxCmainWS              *UxSaveCtx = UxMainWSContext;

	UxMainWSContext = (_UxCmainWS *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_continue( UxThis, pEnv );
	UxMainWSContext = UxSaveCtx;
}


/*******************************************************************************
       The following are Action functions.
*******************************************************************************/

static void  action_area1_sector_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  int button, x, y;
	  double r, phi, dx, dy, xc, yc;
	  static int x1, y1, x2, y2, ixc, iyc;
	  static int call = 0;
	
	  if (currentImage < 0)
	    return;
	
	  if (call == 0)
	    {
	      mainWS_getCentre (mainWS, &UxEnv, &xc, &yc);
	      FileToImageCoords ((float) xc, (float) yc, xi[currentImage], &ixc, &iyc);
	      x1 = ixc + 2 * xi[currentImage]->width / 8;
	      y1 = iyc + xi[currentImage]->height / 8;
	      x2 = ixc + 3 * xi[currentImage]->width / 8;
	      y2 = iyc - xi[currentImage]->height / 8;
	    }
	
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      button = UxEvent->xbutton.button;
	      switch (button)
		{
		case 1:
		  if (UxEvent->xbutton.state & ShiftMask)
		    {
	              if (call)
	                {
		          DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, 
				      x1, y1, x2, y2);	
	                }      
		      dx = (double) (x2 - ixc);
		      dy = (double) (iyc - y2);	      
		      r = sqrt (dx * dx + dy * dy);
	              dx = (double) (x1 - ixc);
		      dy = (double) (iyc - y1);
		      phi = atan2 (dy, dx);
		      x2 = ixc + (int) (r * cos (phi) + sin (phi));
		      y2 = iyc - (int) (r * sin (phi) - cos (phi));
		      DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, 
				  x1, y1, x2, y2);
		    }
		  break;
		case 2:
		  if (UxEvent->xbutton.state & ShiftMask)
		    {
	              if (call)
	                {
		          DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, 
				      x1, y1, x2, y2);	
	                }      
	              dx = (double) (x1 - ixc);
		      dy = (double) (iyc - y1);
		      r = sqrt (dx * dx + dy * dy);
		      dx = (double) (x2 - ixc);
		      dy = (double) (iyc - y2);	      
		      phi = atan2 (dy, dx);
		      x1 = ixc + (int) (r * cos (phi) - sin (phi));
		      y1 = iyc - (int) (r * sin (phi) + cos (phi));
		      DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, 
				  x1, y1, x2, y2);
		    }
		  break;
		case 3:
		  if (call) 
		    {
		      DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, 
				  x1, y1, x2, y2);
		      ProcessSector1 (x1, y1, x2, y2);
		      call = 0;
		    }
		  return;
		default:
		  break;
		}
	
	    case MotionNotify:
	      do
		{
		  x = UxEvent->xmotion.x;
		  y = UxEvent->xmotion.y;
		}
	      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
					     UxEvent));
	
	      if (call)	DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, 
				    x1, y1, x2, y2);
	 
	      UpdateArea2 (UxWidget, UxEvent);
				   
	      if (!(UxEvent->xbutton.state & ShiftMask))
		{
		  switch (button)
		    {
		    case 1:
		      x1 = x;
		      y1 = y;
		      break;
		    case 2:
		      x2 = x;
		      y2 = y;
		      break;
		    default:
		      break;
		    }
		}
		  
	      DrawSector (UxDisplay, XtWindow (UxWidget), actionGC, ixc, iyc, x1, y1, x2, y2);  
	    }
	
	  call++; 
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area2_poly_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  int button, x, y;
	  static int xOld, yOld;
	  static int xv[MAXVERTS], yv[MAXVERTS];
	  static int motion = 0, press = 0, nv = 0;
	
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      button = UxEvent->xbutton.button;
	      switch (button)
		{
		case 2:
		  if (nv > 0)
		    {
		      nv--;
		      if (nv > 0)
			{
			  XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, 
				     xv[nv - 1], yv[nv - 1], xv[nv], yv[nv]);
			}
		      else
			{
			  XDrawPoint (UxDisplay, XtWindow (UxWidget), actionGC, xv[0], yv[0]);
			}
		    }
		  break;
	 
		case 3:
		  if (press)
		    XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, xv[0], yv[0],
			       xv[nv - 1], yv[nv - 1]);
	
		  if (nv > 2)ProcessPoly2 (xv, yv, nv);
		  nv = 0;
		  motion = 0;
		  press = 0;
		  return;
	
		default:
		  break;
		}
	      press++;
	      break;
	
	    case ButtonRelease:
	      button = UxEvent->xbutton.button;
	      switch (button)
		{
		case 1:
		  if (nv >= MAXVERTS)
		    {
		      printf ("Too many vertices!\n");
		      return;
		    }
	
		  x = UxEvent->xbutton.x;
		  y = UxEvent->xbutton.y;
		  
		  if (x >= 0 && x < MAGDIM && y >= 0 && y < MAGDIM)
		    {
		      if (nv == 0)
			XDrawPoint (UxDisplay, XtWindow (UxWidget), actionGC, x, y);
		      
		      if (nv > 0 && motion == 0)
			XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, 
				   xv[nv - 1], yv[nv - 1], x, y);
		  
		      xv[nv] = x;
		      yv[nv] = y;
		      nv++;  
		    }
		  break;
	
		default:
		  break;
		}
	      motion = 0;
	      break;
	
	    case MotionNotify:
	      do
		{
		  x = UxEvent->xmotion.x;
		  y = UxEvent->xmotion.y;
		}
	      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
					     UxEvent));
	
	      TrackArea2 (UxWidget, UxEvent);
	
	      switch (button)
		{
		case 1:
		  if (nv > 0)
		    {
		      if (motion) XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, 
					     xv[nv - 1], yv[nv - 1], xOld, yOld);
		  
		      xOld = x;
		      yOld = y;
		      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, 
				 xv[nv - 1], yv[nv - 1], x, y);
		  
		      motion++;
		    }
		  break;
	
		default:
		  break;
		}
	      break;
	
	    default:
	      break;
	    }
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area2_rect_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  int button, x, y;
	  static int ifp, ilp, ifr, ilr, itemp;
	  static unsigned int width, height;
	  static int call = 0;
	
	  if (call == 0)
	    {
	      ifp = 3 * MAGDIM / 8;
	      ifr = 3 * MAGDIM / 8;
	      ilp = 5 * MAGDIM / 8;
	      ilr = 5 * MAGDIM / 8;
	      width = ilp - ifp + 1;
	      height = ilr - ifr + 1;
	    }
	
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      button = UxEvent->xbutton.button;
	      switch (button)
		{
		case 3:
		  if (call) 
		    {
		      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, 
				      width, height);
		      ProcessRect2 (ifp, ilp, ifr, ilr);
		      call = 0;
		    }
		  return;
		default:
		  break;
		}
	
	    case MotionNotify:
	      do
		{
		  x = UxEvent->xmotion.x;
		  y = UxEvent->xmotion.y;
		}
	      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
					     UxEvent));
	
	      if (call) XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, 
					width, height);
	      TrackArea2 (UxWidget, UxEvent);
				   
	      switch (button)
		{
		case 1:
		  ifp = x;
		  ifr = y;  
		  break;
		case 2:
		  ilp = x;
		  ilr = y;
		  break;
		default:
		  break;
		}
	
	      if (ifp > ilp) SWAP (ifp, ilp);
	      if (ifr > ilr) SWAP (ifr, ilr);
	      width = ilp - ifp + 1;
	      height = ilr - ifr + 1;
	      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, width, height);
	    }
	  call++;
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area2_thick_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  int button, state, x, y;
	  static int ifp, ilp, ifr, ilr, width;
	  static XPoint points[5];
	  static int call = 0;
	
	  if (call == 0)
	    {
	      ifp = 2 * MAGDIM / 8;
	      ifr = 4 * MAGDIM / 8;
	      ilp = 6 * MAGDIM / 8;
	      ilr = 4 * MAGDIM / 8;
	      width = 10;
	    }
	
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      button = UxEvent->xbutton.button;
	      state = UxEvent->xbutton.state;
	      switch (button)
		{
		case 3:
		  if (call) 
		    {
		      XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, 
				  CoordModeOrigin);
		      ProcessLine2 (ifp, ilp, ifr, ilr, width);
		      call = 0;
		    }
		  return;
		default:
		  break;
		}
	
	    case MotionNotify:
	      do
		{
		  x = UxEvent->xmotion.x;
		  y = UxEvent->xmotion.y;
		}
	      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
					     UxEvent));
	
	      if (call) XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, 
				    CoordModeOrigin);
	      TrackArea2 (UxWidget, UxEvent);
				   
	      switch (button)
		{
		case 1:
		  if (state & ShiftMask)
		    {
		      width = fwidth (ifp, ilp, ifr, ilr, x, y);
		    }
		  else
		    {
		      ifp = x;
		      ifr = y;
		    }
		  break;
		case 2:
		  ilp = x;
		  ilr = y;
		  break;
		default:
		  break;
		}
	
	      fpoint (xi[currentImage]->width, xi[currentImage]->height, ifp, ilp, ifr, ilr, 
		      width, points);
	      XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, CoordModeOrigin);  
	    }
	  call++;
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area2_line_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  int button, x, y;
	  static int ifp, ilp, ifr, ilr;
	  static int call = 0;
	
	  if (call == 0)
	    {
	      ifp = 3 * MAGDIM / 8;
	      ifr = 4 * MAGDIM / 8;
	      ilp = 5 * MAGDIM / 8;
	      ilr = 4 * MAGDIM / 8;
	    }
	
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      button = UxEvent->xbutton.button;
	      switch (button)
		{
		case 3:
		  if (call) 
		    {
		      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);
		      ProcessLine2 (ifp, ilp, ifr, ilr, 0);
		      call = 0;
		    }
		  return;
		default:
		  break;
		}
	
	    case MotionNotify:
	      do
		{
		  x = UxEvent->xmotion.x;
		  y = UxEvent->xmotion.y;
		}
	      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
					     UxEvent));
	
	      if (call) XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);
	      TrackArea2 (UxWidget, UxEvent);
				   
	      switch (button)
		{
		case 1:
		  ifp = x;
		  ifr = y;
		  break;
		case 2:
		  ilp = x;
		  ilr = y;
		  break;
		default:
		  break;
		}
	
	      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);
	    }
	  call++;
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area1_zoom_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  int button, x, y;
	  static int ifp, ilp, ifr, ilr, itemp;
	  static unsigned int width, height;
	  static int call = 0;
	
	  if (currentImage < 0)
	    return;
	
	  if (call == 0)
	    {
	      ifp = 2 * xi[currentImage]->width / 8;
	      ifr = 2 * xi[currentImage]->height / 8;
	      ilp = 6 * xi[currentImage]->width / 8;
	      ilr = 6 * xi[currentImage]->height / 8;
	      width = ilp - ifp + 1;
	      height = ilr - ifr + 1;
	    }
	
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      button = UxEvent->xbutton.button;
	      switch (button)
		{
		case 3:
		  if (call) 
		    {
		      width = ilp - ifp + 1;
		      height = ilr - ifr + 1;
		      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr,
				      width, height);
		      ProcessBox1 (ifp, ifr, width, height);
		      call = 0;
		    }
		  return;
		default:
		  break;
		}
	
	    case MotionNotify:
	      do
		{
		  x = UxEvent->xmotion.x;
		  y = UxEvent->xmotion.y;
		}
	      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
					     UxEvent));
	
	      if (call) XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, 
					width, height);
	      UpdateArea2 (UxWidget, UxEvent);
				   
	      switch (button)
		{
		case 1:
		  ifp = x;
		  ifr = y;  
		  break;
		case 2:
		  ilp = x;
		  ilr = y;
		  break;
		default:
		  break;
		}
	      
	      if (ifp > ilp) SWAP (ifp, ilp);
	      if (ifr > ilr) SWAP (ifr, ilr);
	      width = ilp - ifp + 1;
	      height = ilr - ifr + 1;
	      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, width, height);
	    }
	  call++;
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area1_poly_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  int button, x, y;
	  static int xOld, yOld;
	  static int xv[MAXVERTS], yv[MAXVERTS];
	  static int motion = 0, press = 0, nv = 0;
	
	  if (currentImage < 0)
	    return;
	
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      button = UxEvent->xbutton.button;
	      switch (button)
		{
		case 2:
		  if (nv > 0)
		    {
		      nv--;
		      if (nv > 0)
			{
			  XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, 
				     xv[nv - 1], yv[nv - 1], xv[nv], yv[nv]);
			}
		      else
			{
			  XDrawPoint (UxDisplay, XtWindow (UxWidget), actionGC, xv[0], yv[0]);
			}
		    }
		  break;
	 
		case 3:
		  if (press)
		    XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, xv[0], yv[0],
			       xv[nv - 1], yv[nv - 1]);
	
		  if (nv > 2)ProcessPoly1 (xv, yv, nv);
		  nv = 0;
		  motion = 0;
		  press = -1;
		  return;
	
		default:
		  break;
		}
	      press++;
	      break;
	
	    case ButtonRelease:
	      button = UxEvent->xbutton.button;
	      switch (button)
		{
		case 1:
		  if (nv >= MAXVERTS)
		    {
		      printf ("Too many vertices!\n");
		      return;
		    }
	
		  x = UxEvent->xbutton.x;
		  y = UxEvent->xbutton.y;
		  
		  if (x >= 0 && x < xi[currentImage]->width && 
		      y >= 0 && y < xi[currentImage]->height)
		    {
		      if (nv == 0)
			XDrawPoint (UxDisplay, XtWindow (UxWidget), actionGC, x, y);
		      
		      if (nv > 0 && motion == 0)
			XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, 
				   xv[nv - 1], yv[nv - 1], x, y);
		  
		      xv[nv] = x;
		      yv[nv] = y;
		      nv++;  
		    }
		  break;
	
		default:
		  break;
		}
	      motion = 0;
	      break;
	
	    case MotionNotify:
	      do
		{
		  x = UxEvent->xmotion.x;
		  y = UxEvent->xmotion.y;
		}
	      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
					     UxEvent));
	
	      UpdateArea2 (UxWidget, UxEvent);
	
	      switch (button)
		{
		case 1:
		  if (nv > 0)
		    {
		      if (motion) XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, 
					     xv[nv - 1], yv[nv - 1], xOld, yOld);
		  
		      xOld = x;
		      yOld = y;
		      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, 
				 xv[nv - 1], yv[nv - 1], x, y);
		  
		      motion++;
		    }
		  break;
	
		default:
		  break;
		}
	      break;
	
	    default:
	      break;
	    }
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area1_rect_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  int button, x, y;
	  static int ifp, ilp, ifr, ilr, itemp;
	  static unsigned int width, height;
	  static int call = 0;
	
	  if (currentImage < 0)
	    return;
	
	  if (call == 0)
	    {
	      ifp = 3 * xi[currentImage]->width / 8;
	      ifr = 3 * xi[currentImage]->height / 8;
	      ilp = 5 * xi[currentImage]->width / 8;
	      ilr = 5 * xi[currentImage]->height / 8;
	      width = ilp - ifp + 1;
	      height = ilr - ifr + 1;
	    }
	
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      button = UxEvent->xbutton.button;
	      switch (button)
		{
		case 3:
		  if (call) 
		    {
		      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, 
				      width, height);
		      ProcessRect1 (ifp, ilp, ifr, ilr);
		      call = 0;
		    }
		  return;
		default:
		  break;
		}
	
	    case MotionNotify:
	      do
		{
		  x = UxEvent->xmotion.x;
		  y = UxEvent->xmotion.y;
		}
	      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
					     UxEvent));
	
	      if (call) XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, 
					width, height);
	      UpdateArea2 (UxWidget, UxEvent);
				   
	      switch (button)
		{
		case 1:
		  ifp = x;
		  ifr = y;  
		  break;
		case 2:
		  ilp = x;
		  ilr = y;
		  break;
		default:
		  break;
		}
		  
	      if (ifp > ilp) SWAP (ifp, ilp);
	      if (ifr > ilr) SWAP (ifr, ilr);
	      width = ilp - ifp + 1;
	      height = ilr - ifr + 1;
	      XDrawRectangle (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, width, height);
	    }
	  call++;
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area1_thick_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  int button, state, x, y;
	  static int ifp, ilp, ifr, ilr, width;
	  static XPoint points[5];
	  static int call = 0;
	
	  if (currentImage < 0)
	    return;
	
	  if (call == 0)
	    {
	      ifp = 2 * xi[currentImage]->width / 8;
	      ifr = 4 * xi[currentImage]->height / 8;
	      ilp = 6 * xi[currentImage]->width / 8;
	      ilr = 4 * xi[currentImage]->height / 8;
	      width = 10;
	    }
	
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      button = UxEvent->xbutton.button;
	      state = UxEvent->xbutton.state;
	      switch (button)
		{
		case 3:
		  if (call) 
		    {
		      XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, 
				  CoordModeOrigin);
		      ProcessLine1 (ifp, ilp, ifr, ilr, width);
		      call = 0;
		    }
		  return;
		default:
		  break;
		}
	
	    case MotionNotify:
	      do
		{
		  x = UxEvent->xmotion.x;
		  y = UxEvent->xmotion.y;
		}
	      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
					     UxEvent));
	
	      if (call) XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, 
				    CoordModeOrigin);
	      UpdateArea2 (UxWidget, UxEvent);
				   
	      switch (button)
		{
		case 1:
		  if (state & ShiftMask)
		    {
		      width = fwidth (ifp, ilp, ifr, ilr, x, y);
		    }
		  else
		    {
		      ifp = x;
		      ifr = y;
		    }
		  break;
		case 2:
		  ilp = x;
		  ilr = y;
		  break;
		default:
		  break;
		}
	
	      fpoint (xi[currentImage]->width, xi[currentImage]->height, ifp, ilp, ifr, ilr, 
		      width, points);
	      XDrawLines (UxDisplay, XtWindow (UxWidget), actionGC, points, 5, CoordModeOrigin);  
	    }
	  call++;
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area1_line_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  int button, x, y;
	  static int ifp, ilp, ifr, ilr;
	  static int call = 0;
	
	  if (currentImage < 0)
	    return;
	
	  if (call == 0)
	    {
	      ifp = 3 * xi[currentImage]->width / 8;
	      ifr = 4 * xi[currentImage]->height / 8;
	      ilp = 5 * xi[currentImage]->width / 8;
	      ilr = 4 * xi[currentImage]->height / 8;
	    }
	
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      button = UxEvent->xbutton.button;
	      switch (button)
		{
		case 3:
		  if (call) 
		    {
		      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);
		      ProcessLine1 (ifp, ilp, ifr, ilr, 0);
		      call = 0;
		    }
		  return;
		default:
		  break;
		}
	
	    case MotionNotify:
	      do
		{
		  x = UxEvent->xmotion.x;
		  y = UxEvent->xmotion.y;
		}
	      while (XCheckTypedWindowEvent (UxDisplay, XtWindow (UxWidget), MotionNotify, 
					     UxEvent));
	
	      if (call) XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);
	      UpdateArea2 (UxWidget, UxEvent);
				   
	      switch (button)
		{
		case 1:
		  ifp = x;
		  ifr = y;
		  break;
		case 2:
		  ilp = x;
		  ilr = y;
		  break;
		default:
		  break;
		}
	
	      XDrawLine (UxDisplay, XtWindow (UxWidget), actionGC, ifp, ifr, ilp, ilr);
	    }
	  call++;
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area2_point_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      switch (UxEvent->xbutton.button)
		{
		case 1:
		  if (setMagnify) ProcessPoint2 (UxWidget, UxEvent);
		  break;
		case 3:
		  setMagnify = False;
		  break;
		default:
	          break;
		}
	
	    case MotionNotify:
	      if (setMagnify) TrackArea2 (UxWidget, UxEvent);
	
	    default:
	      break;
	    }
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_refresh_image2(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{Refresh2 (UxWidget, UxEvent);}
	UxMainWSContext = UxSaveCtx;
}

static void  action_area1_point_handler(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  switch (UxEvent->type)
	    {
	    case ButtonPress:
	      switch (UxEvent->xbutton.button)
		{
		case 1:
		  ProcessPoint1 (UxWidget, UxEvent);
		  break;
		case 2:
		  setMagnify = True;
		  break;
		case 3:
		  setMagnify = False;
		  break;
		default:
	          break;
		}
	
	    case MotionNotify:
	      UpdateArea2 (UxWidget, UxEvent);
	
	    default:
	      break;
	    }
	}
	UxMainWSContext = UxSaveCtx;
}

static void  action_refresh_image1(
			Widget wgt, 
			XEvent *ev, 
			String *parm, 
			Cardinal *p_UxNumParams)
{
	Cardinal		UxNumParams = *p_UxNumParams;
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XEvent                  *UxEvent = ev;
	String                  *UxParams = parm;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{Refresh1 (UxWidget, UxEvent);}
	UxMainWSContext = UxSaveCtx;
}

/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  activateCB_newButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	   obFileSelect_OKfunction (bslSelect, &UxEnv, NewFile);
	   UxPopupInterface (bslSelect, nonexclusive_grab);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_openButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{   
	   obFileSelect_OKfunction (bslSelect, &UxEnv, setupFile);
	   UxPopupInterface (bslSelect, nonexclusive_grab);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_frameButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	    SetBusyPointer (1);
	    if (iffr <= ilfr - ifinc)
	       iffr += ifinc;
	
	    ReadFrame ();
	
	    sprintf (textBuf, "%4d", iffr);
	    XmTextFieldSetString (UxGetWidget (frameText), textBuf);
	    
	    CloseAllImages ();
	    if (!repeat)
	    {
	       DestroyAllObjects ();
	       DestroyAllLines ();
	    }
	
	    totalImages = 1;
	    currentImage = 0;
	    xi[currentImage] = CreateFixImage (0, 0, npix, nrast);
	    SetBusyPointer (0);
	
	    if (xi[currentImage])
	    {
	       LoadImage (xi[currentImage]);
	       XmTextFieldSetString (UxGetWidget (imageText), "0");
	    }
	    else
	    {
	       errorDialog_popup (error, &UxEnv, "Unable to create image");
	       totalImages = 0;
	       currentImage = -1;
	    }
	
	    XtSetSensitive (UxGetWidget (textHigh), True);
	    XtSetSensitive (UxGetWidget (textLow), True);
	    command ("Frame\n");
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_saveAsButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	   char count[8];
	   char *tmp, *pathName;
	   char *defName = (char *) strdup (fileName);
	
	   *(defName + 6) = '_';
	   *(defName + 7) = '\0';
	
	   psCounter++;
	   sprintf (count, "%d", psCounter);
	
	   tmp = AddString (defName, count);
	   free (defName);
	
	   defName = AddString (tmp, ".ps");
	   free (tmp);
	
	   pathName = AddString (currentDir, defName);
	   free (defName);
	
	   show_fileSelect (drawFSD, "*.ps", pathName, psout, CancelSave);
	
	   free (pathName);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_exitButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	   ConfirmDialogAsk (confirmD, "Do you really want to exit?", quit, NULL, NULL);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_parameterButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	  UxPopupInterface (parameterD, no_grab);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_objectButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	    UxPopupInterface (objectD, no_grab);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_lineButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	    UxPopupInterface (lineD, no_grab);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_scanButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	    UxPopupInterface (scanD, no_grab);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_cellButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	   UxPopupInterface (cellD, no_grab);   
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_centreButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	   command ("Centre fit  ");
	   ListRangesOfSelectedItems (objectD);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_rotationButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	   command ("Rotation fit  ");
	   ListSelectedItems (objectD);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_tiltButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	   command ("Tilt fit  ");
	   ListSelectedItems (objectD);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_listButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	    command ("List\n");
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_plotLineButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	   command ("Plot Lines  ");
	   ListRangesOfSelectedItems (lineD);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_plotScanButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	   command ("Plot Scans  ");
	   ListRangesOfSelectedItems (scanD);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_refineButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	    UxPopupInterface (refineD, no_grab);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_colour0Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	GreyScale ();
	invertedPalette = False;
	
	if (currentImage >= 0)
	    LoadImage (xi[currentImage]);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_colour1Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	ColourPalette1 ();
	invertedPalette = False;
	
	if (currentImage >= 0)
	    LoadImage (xi[currentImage]);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_colour2Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	ColourPalette2 ();
	invertedPalette = False;
	
	if (currentImage >= 0)
	    LoadImage (xi[currentImage]);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_colour3Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	ColourPalette3 ();
	invertedPalette = False;
	
	if (currentImage >= 0)
	    LoadImage (xi[currentImage]);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_colour4Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	ColourPalette4 ();
	invertedPalette = False;
	
	if (currentImage >= 0)
	    LoadImage (xi[currentImage]);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_colour5Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	ColourPalette5 ();
	invertedPalette = False;
	
	if (currentImage >= 0)
	    LoadImage (xi[currentImage]);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_x2Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{magnification = 2;}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_x4Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{magnification = 4;}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_x8Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{magnification = 8;}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_x16Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{magnification = 16;}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_x32Toggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{magnification = 32;}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_lineGreenToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, drawGC, green.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_lineRedToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, drawGC, red.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_lineBlueToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, drawGC, blue.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_lineYellowToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, drawGC, yellow.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_lineWhiteToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, drawGC, white.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_lineBlackToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, drawGC, black.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_greenToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, pointGC, green.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_redToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, pointGC, red.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_blueToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, pointGC, blue.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_yellowToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, pointGC, yellow.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_whiteToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, pointGC, white.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_blackToggle(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XSetForeground (UxDisplay, pointGC, black.pixel);
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_logButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	logarithmic = !logarithmic;
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_interpolateButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	interpolation = !interpolation;
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_lineFitButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	fitLines = !fitLines;
	
	if (fitLines)
	   mode = 1;
	else
	   mode = 0;
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_showPointsButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	showPoints = !showPoints;
	if (showPoints)
	{
	    DrawDrawnPoints (XtWindow (UxGetWidget (drawingArea1)));
	}
	else
	{
	    RepaintOverDrawnPoints ();
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_azimuthalButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XmToggleButtonSetState (UxGetWidget (azimuthalButton), True, False);
	XmToggleButtonSetState (UxGetWidget (radialButton), False, False);
	command ("Azimuthal\n");
	radialScan = False;
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_radialButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XmToggleButtonSetState (UxGetWidget (azimuthalButton), False, False);
	XmToggleButtonSetState (UxGetWidget (radialButton), True, False);
	command ("Radial\n");
	radialScan = True;
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_latticePointButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XmToggleButtonSetState (UxGetWidget (latticePointButton), True, False);
	XmToggleButtonSetState (UxGetWidget (latticeCircleButton), False, False);
	
	command ("spot\n");
	plotLatticePoints = True;
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_latticeCircleButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	XmToggleButtonSetState (UxGetWidget (latticePointButton), False, False);
	XmToggleButtonSetState (UxGetWidget (latticeCircleButton), True, False);
	
	command ("ring\n");
	plotLatticePoints = False;
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_introButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	mainWS_help (mainWS, &UxEnv, "#INTRO");
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_onFileButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	mainWS_help (mainWS, &UxEnv, "#MENU1");
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_onEditButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	mainWS_help (mainWS, &UxEnv, "#MENU2");
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_onEstimateButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	mainWS_help (mainWS, &UxEnv, "#MENU3");
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_onProcessButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	mainWS_help (mainWS, &UxEnv, "#MENU4");
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_onOptionsButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	mainWS_help (mainWS, &UxEnv, "#MENU5");
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_onToolsButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	mainWS_help (mainWS, &UxEnv, "#TOOLS");
	}
	UxMainWSContext = UxSaveCtx;
}

static void  createCB_drawingArea2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxContext = UxMainWSContext;
	{
	
	
	
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_togglePoint(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	if (XmToggleButtonGetState (UxWidget))
	{
	   XtVaSetValues (drawingArea1,
	                  XmNtranslations, XtParseTranslationTable (area1PointTable),
	                  NULL);
	
	   XtVaSetValues (drawingArea2,
	                  XmNtranslations, XtParseTranslationTable (area2PointTable),
	                  NULL);
	
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorPoint);
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorPoint);
	
	   if (lastToggle != UxWidget)
	   {
	      lastToggle = UxWidget;
	      update_messages ("\nPoints: Use the cursor to select points in the main window ");
	      update_messages ("or the magnification window\n\n");
	      update_messages ("Left mouse button selects point\n");
	      update_messages ("Middle mouse button freezes magnification window\n");
	      update_messages ("Right mouse button releases magnification window\n\n");
	   }
	}
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_toggleLine(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	if (XmToggleButtonGetState (UxWidget))
	{
	   XtVaSetValues (drawingArea1,
	                  XmNtranslations, XtParseTranslationTable (area1LineTable),
	                  NULL);
	
	   XtVaSetValues (drawingArea2,
	                  XmNtranslations, XtParseTranslationTable (area2LineTable),
	                  NULL); 
	
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorPoint);
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorPoint);
	
	   if (lastToggle != UxWidget)
	   {
	      lastToggle = UxWidget;
	      update_messages ("\nLines: Use the cursor to select lines in the main window ");
	      update_messages ("or the magnification window\n\n");
	      update_messages ("Left mouse button selects start point\n");
	      update_messages ("Middle mouse button selects end point\n");
	      update_messages ("Right mouse button ends selection of line\n\n");
	   }
	}
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_toggleThick(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	if (XmToggleButtonGetState (UxWidget))
	{
	   XtVaSetValues (drawingArea1,
	                  XmNtranslations, XtParseTranslationTable (area1ThickTable),
	                  NULL);
	
	   XtVaSetValues (drawingArea2,
	                  XmNtranslations, XtParseTranslationTable (area2ThickTable),
	                  NULL); 
	
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorPoint);
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorPoint);
	
	   if (lastToggle != UxWidget)
	   {
	      lastToggle = UxWidget;      
	      update_messages ("\nThick Lines: Use the cursor to select lines in the main window ");
	      update_messages ("or the magnification window\n\n");
	      update_messages ("Left mouse button selects start point\n");
	      update_messages ("Shift + left mouse button selects width\n");
	      update_messages ("Middle mouse button selects end point\n");
	      update_messages ("Right mouse button ends selection of line\n\n");
	   }
	}
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_toggleRect(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	if (XmToggleButtonGetState (UxWidget))
	{
	   XtVaSetValues (drawingArea1,
	                  XmNtranslations, XtParseTranslationTable (area1RectTable),
	                  NULL);
	
	   XtVaSetValues (drawingArea2,
	                  XmNtranslations, XtParseTranslationTable (area2RectTable),
	                  NULL); 
	
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorBox);
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorBox);
	
	   if (lastToggle != UxWidget)
	   {
	      lastToggle = UxWidget;      
	      update_messages ("\nRectangles: Use the cursor to select rectangles in the main window ");
	      update_messages ("or the magnification window\n\n");
	      update_messages ("Left mouse button selects top-left corner\n");
	      update_messages ("Middle mouse button selects bottom-right corner\n");
	      update_messages ("Right mouse button ends selection of rectangle\n\n");
	   }
	}
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_togglePoly(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	if (XmToggleButtonGetState (UxWidget))
	{
	   XtVaSetValues (drawingArea1,
	                  XmNtranslations, XtParseTranslationTable (area1PolyTable),
	                  NULL);
	
	   XtVaSetValues (drawingArea2,
	                  XmNtranslations, XtParseTranslationTable (area2PolyTable),
	                  NULL); 
	
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorPoly);
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea2)), cursorPoly);
	
	   if (lastToggle != UxWidget)
	   {
	      lastToggle = UxWidget;
	      update_messages ("\nPolygons: Use the cursor to select polygons in the main window ");
	      update_messages ("or the magnification window\n\n");
	      update_messages ("Left mouse button selects a vertex\n");
	      update_messages ("Middle mouse button deletes last vertex\n");
	      update_messages ("Right mouse button closes the polygon\n\n");
	   }
	}
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_toggleSector(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	if (XmToggleButtonGetState (UxWidget))
	{
	
	  XtVaSetValues (drawingArea1,
	                  XmNtranslations, XtParseTranslationTable (area1SectorTable),
	                  NULL);
	
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorBox);
	
	   if (lastToggle != UxWidget)
	   {
	      lastToggle = UxWidget;      
	      update_messages ("\nSectors: Use the cursor to select sectors in the main window\n\n");
	      update_messages ("Left mouse button selects start angle and radius\n");
	      update_messages ("Middle mouse button selects end angle and radius\n");
	      update_messages ("Right mouse button ends selection of sector\n\n");
	   }
	}
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_toggleScan(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	if (XmToggleButtonGetState (UxWidget))
	{
	   XtVaSetValues (drawingArea1,
	                  XmNtranslations, XtParseTranslationTable (area1SectorTable),
	                  NULL);
	
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorBox);
	
	   if (lastToggle != UxWidget)
	   {
	      lastToggle = UxWidget;      
	      update_messages ("\nScans: Use the cursor to select scans in the main window\n\n");
	      update_messages ("Left mouse button selects start angle and radius\n");
	      update_messages ("Middle mouse button selects end angle and radius\n");
	      update_messages ("Right mouse button ends selection of scan\n\n");
	   }
	
	  XtVaSetValues (UxGetWidget (rowColumn1), XmNmenuHistory, UxWidget, NULL);
	}
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_toggleZoom(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	if (XmToggleButtonGetState (UxWidget))
	{
	   XtVaSetValues (drawingArea1,
	                  XmNtranslations, XtParseTranslationTable (area1ZoomTable),
	                  NULL);
	
	   XDefineCursor (UxDisplay, XtWindow (UxGetWidget (drawingArea1)), cursorBox);
	
	   if (lastToggle != UxWidget)
	   {
	      lastToggle = UxWidget;      
	      update_messages ("\nZoom: Use the cursor to select zoom area in the main window\n\n");
	      update_messages ("Left mouse button selects top-left corner\n");
	      update_messages ("Middle mouse button selects bottom-right corner\n");
	      update_messages ("Right mouse button ends selection of zoom area\n\n");
	   }
	}
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_textHigh(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	char *cptr  = XmTextFieldGetString (UxWidget);
	xi[currentImage]->tmax = atof (cptr);
	free (cptr);
	
	cptr  = XmTextFieldGetString (UxGetWidget (textLow));
	xi[currentImage]->tmin = atof (cptr);
	free (cptr);
	
	SetBusyPointer (1);
	if (logarithmic)
	    ScaleLog (xi[currentImage]);
	else
	    ScaleLinear (xi[currentImage]);
	
	LoadImage (xi[currentImage]);
	SetBusyPointer (0);
	
	cptr = (char *) malloc (20 * sizeof (char));
	sprintf (cptr, "%9g", xi[currentImage]->tmax);
	XmTextFieldSetString (UxWidget, cptr);
	sprintf (cptr, "%9g", xi[currentImage]->tmin);
	XmTextFieldSetString (UxGetWidget (textLow), cptr);
	free (cptr);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_textLow(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	char *cptr  = XmTextFieldGetString (UxWidget);
	xi[currentImage]->tmin = atof (cptr);
	free (cptr);
	
	cptr  = XmTextFieldGetString (UxGetWidget (textHigh));
	xi[currentImage]->tmax = atof (cptr);
	free (cptr);
	
	SetBusyPointer (1);
	if (logarithmic)
	    ScaleLog (xi[currentImage]);
	else
	    ScaleLinear (xi[currentImage]);
	
	LoadImage (xi[currentImage]);
	SetBusyPointer (0);
	
	cptr = (char *) malloc (20 * sizeof (char));
	sprintf (cptr, "%9g", xi[currentImage]->tmin);
	XmTextFieldSetString (UxWidget, cptr);
	sprintf (cptr, "%9g", xi[currentImage]->tmax);
	XmTextFieldSetString (UxGetWidget (textHigh), cptr);
	free (cptr);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_arrowButton1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	currentImage++;
	sprintf (textBuf, "%1d", currentImage);
	XmTextFieldSetString (UxGetWidget (imageText), textBuf);
	LoadImage (xi[currentImage]);
	
	
	
	}
	UxMainWSContext = UxSaveCtx;
}

static void  valueChangedCB_imageText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	int value;
	char *cptr = XmTextFieldGetString (UxWidget);
	
	if (*cptr)
	{
	   value = atoi (cptr);
	   if (value > 0)
	   {
	      XtSetSensitive (UxGetWidget (arrowButton2), True);
	   }
	   else
	   {
	      XtSetSensitive (UxGetWidget (arrowButton2), False);
	   }
	
	
	   if (value < totalImages - 1)
	   {
	      XtSetSensitive (UxGetWidget (arrowButton1), True);
	   }
	   else
	   {
	      XtSetSensitive (UxGetWidget (arrowButton1), False);
	   }
	}
	else
	{
	   XtSetSensitive (UxGetWidget (arrowButton1), False);
	   XtSetSensitive (UxGetWidget (arrowButton2), False);
	}
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_arrowButton2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	currentImage--;
	sprintf (textBuf, "%1d", currentImage);
	XmTextFieldSetString (UxGetWidget (imageText), textBuf);
	LoadImage (xi[currentImage]);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  createCB_drawingArea1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxContext = UxMainWSContext;
	{
	
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_invertButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	InvertPalette ();
	invertedPalette = !invertedPalette;
	
	if (currentImage >= 0)
	    LoadImage (xi[currentImage]);
	}
	UxMainWSContext = UxSaveCtx;
}

static void  activateCB_refreshButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCmainWS              *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxMainWSContext;
	UxMainWSContext = UxContext =
			(_UxCmainWS *) UxGetContext( UxWidget );
	{
	RefreshPalette ();
	}
	UxMainWSContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_mainWS()
{
	Widget		filePane_shell;
	Widget		editPane_shell;
	Widget		findPane_shell;
	Widget		processPane_shell;
	Widget		optionsPane_shell;
	Widget		palettePane_shell;
	Widget		magPane_shell;
	Widget		lineColourPane_shell;
	Widget		pointColourPane_shell;
	Widget		helpPane_shell;


	/* Creation of mainWS */
	mainWS = XtVaCreatePopupShell( "mainWS",
			applicationShellWidgetClass,
			UxTopLevel,
			XmNx, 338,
			XmNy, 10,
			XmNwidth, 690,
			XmNheight, 800,
			XmNtitle, "xfix",
			XmNdeleteResponse, XmDO_NOTHING,
			XmNiconName, "xfix",
			NULL );
	UxPutContext( mainWS, (char *) UxMainWSContext );
	UxPutClassCode( mainWS, _UxIfClassId );


	/* Creation of mainWindow */
	mainWindow = XtVaCreateManagedWidget( "mainWindow",
			xmMainWindowWidgetClass,
			mainWS,
			XmNx, 200,
			XmNy, 180,
			XmNwidth, 700,
			XmNheight, 800,
			NULL );
	UxPutContext( mainWindow, (char *) UxMainWSContext );


	/* Creation of pullDownMenu */
	pullDownMenu = XtVaCreateManagedWidget( "pullDownMenu",
			xmRowColumnWidgetClass,
			mainWindow,
			XmNborderWidth, 0,
			XmNrowColumnType, XmMENU_BAR,
			XmNmenuAccelerator, "<KeyUp>F10",
			NULL );
	UxPutContext( pullDownMenu, (char *) UxMainWSContext );


	/* Creation of filePane */
	filePane_shell = XtVaCreatePopupShell ("filePane_shell",
			xmMenuShellWidgetClass, pullDownMenu,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	filePane = XtVaCreateWidget( "filePane",
			xmRowColumnWidgetClass,
			filePane_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( filePane, (char *) UxMainWSContext );


	/* Creation of newButton */
	newButton = XtVaCreateManagedWidget( "newButton",
			xmPushButtonGadgetClass,
			filePane,
			RES_CONVERT( XmNlabelString, "New ..." ),
			XmNaccelerator, "Ctrl<Key>N",
			RES_CONVERT( XmNacceleratorText, "Ctrl+N" ),
			NULL );
	XtAddCallback( newButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_newButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( newButton, (char *) UxMainWSContext );


	/* Creation of openButton */
	openButton = XtVaCreateManagedWidget( "openButton",
			xmPushButtonGadgetClass,
			filePane,
			RES_CONVERT( XmNlabelString, "Open ..." ),
			XmNaccelerator, "Ctrl<Key>O",
			RES_CONVERT( XmNacceleratorText, "Ctrl+O" ),
			NULL );
	XtAddCallback( openButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_openButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( openButton, (char *) UxMainWSContext );


	/* Creation of frameButton */
	frameButton = XtVaCreateManagedWidget( "frameButton",
			xmPushButtonWidgetClass,
			filePane,
			RES_CONVERT( XmNlabelString, "Next Frame" ),
			XmNaccelerator, "Ctrl<Key>X",
			RES_CONVERT( XmNacceleratorText, "Ctrl+X" ),
			XmNsensitive, FALSE,
			NULL );
	XtAddCallback( frameButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_frameButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( frameButton, (char *) UxMainWSContext );


	/* Creation of filePane_b7 */
	filePane_b7 = XtVaCreateManagedWidget( "filePane_b7",
			xmSeparatorGadgetClass,
			filePane,
			NULL );
	UxPutContext( filePane_b7, (char *) UxMainWSContext );


	/* Creation of saveAsButton */
	saveAsButton = XtVaCreateManagedWidget( "saveAsButton",
			xmPushButtonGadgetClass,
			filePane,
			RES_CONVERT( XmNlabelString, "Save As Postscript ..." ),
			XmNaccelerator, "Ctrl<Key>S",
			RES_CONVERT( XmNacceleratorText, "Ctrl+S" ),
			NULL );
	XtAddCallback( saveAsButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_saveAsButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( saveAsButton, (char *) UxMainWSContext );


	/* Creation of filePane_b9 */
	filePane_b9 = XtVaCreateManagedWidget( "filePane_b9",
			xmSeparatorGadgetClass,
			filePane,
			NULL );
	UxPutContext( filePane_b9, (char *) UxMainWSContext );


	/* Creation of exitButton */
	exitButton = XtVaCreateManagedWidget( "exitButton",
			xmPushButtonGadgetClass,
			filePane,
			RES_CONVERT( XmNlabelString, "Quit" ),
			XmNaccelerator, "Ctrl<Key>Q",
			RES_CONVERT( XmNacceleratorText, "Ctrl+Q" ),
			NULL );
	XtAddCallback( exitButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_exitButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( exitButton, (char *) UxMainWSContext );


	/* Creation of fileCascade */
	fileCascade = XtVaCreateManagedWidget( "fileCascade",
			xmCascadeButtonWidgetClass,
			pullDownMenu,
			RES_CONVERT( XmNlabelString, "File" ),
			XmNsubMenuId, filePane,
			XmNwidth, 40,
			NULL );
	UxPutContext( fileCascade, (char *) UxMainWSContext );


	/* Creation of editPane */
	editPane_shell = XtVaCreatePopupShell ("editPane_shell",
			xmMenuShellWidgetClass, pullDownMenu,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	editPane = XtVaCreateWidget( "editPane",
			xmRowColumnWidgetClass,
			editPane_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( editPane, (char *) UxMainWSContext );


	/* Creation of parameterButton */
	parameterButton = XtVaCreateManagedWidget( "parameterButton",
			xmPushButtonGadgetClass,
			editPane,
			RES_CONVERT( XmNlabelString, "Parameters ..." ),
			NULL );
	XtAddCallback( parameterButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_parameterButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( parameterButton, (char *) UxMainWSContext );


	/* Creation of objectButton */
	objectButton = XtVaCreateManagedWidget( "objectButton",
			xmPushButtonWidgetClass,
			editPane,
			RES_CONVERT( XmNlabelString, "Objects ..." ),
			NULL );
	XtAddCallback( objectButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_objectButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( objectButton, (char *) UxMainWSContext );


	/* Creation of lineButton */
	lineButton = XtVaCreateManagedWidget( "lineButton",
			xmPushButtonWidgetClass,
			editPane,
			RES_CONVERT( XmNlabelString, "Lines ..." ),
			NULL );
	XtAddCallback( lineButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_lineButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( lineButton, (char *) UxMainWSContext );


	/* Creation of scanButton */
	scanButton = XtVaCreateManagedWidget( "scanButton",
			xmPushButtonWidgetClass,
			editPane,
			RES_CONVERT( XmNlabelString, "Scans ..." ),
			NULL );
	XtAddCallback( scanButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_scanButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( scanButton, (char *) UxMainWSContext );


	/* Creation of cellButton */
	cellButton = XtVaCreateManagedWidget( "cellButton",
			xmPushButtonWidgetClass,
			editPane,
			RES_CONVERT( XmNlabelString, "Cell ..." ),
			NULL );
	XtAddCallback( cellButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_cellButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( cellButton, (char *) UxMainWSContext );


	/* Creation of editCascade */
	editCascade = XtVaCreateManagedWidget( "editCascade",
			xmCascadeButtonWidgetClass,
			pullDownMenu,
			RES_CONVERT( XmNlabelString, "Edit" ),
			XmNsubMenuId, editPane,
			XmNwidth, 40,
			NULL );
	UxPutContext( editCascade, (char *) UxMainWSContext );


	/* Creation of findPane */
	findPane_shell = XtVaCreatePopupShell ("findPane_shell",
			xmMenuShellWidgetClass, pullDownMenu,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	findPane = XtVaCreateWidget( "findPane",
			xmRowColumnWidgetClass,
			findPane_shell,
			XmNradioBehavior, FALSE,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( findPane, (char *) UxMainWSContext );


	/* Creation of centreButton */
	centreButton = XtVaCreateManagedWidget( "centreButton",
			xmPushButtonWidgetClass,
			findPane,
			RES_CONVERT( XmNlabelString, "Centre" ),
			XmNaccelerator, "Ctrl<Key>C",
			RES_CONVERT( XmNacceleratorText, "Ctrl+C" ),
			NULL );
	XtAddCallback( centreButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_centreButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( centreButton, (char *) UxMainWSContext );


	/* Creation of rotationButton */
	rotationButton = XtVaCreateManagedWidget( "rotationButton",
			xmPushButtonWidgetClass,
			findPane,
			RES_CONVERT( XmNlabelString, "Rotation" ),
			XmNaccelerator, "Ctrl<Key>R",
			RES_CONVERT( XmNacceleratorText, "Ctrl+R" ),
			NULL );
	XtAddCallback( rotationButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_rotationButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( rotationButton, (char *) UxMainWSContext );


	/* Creation of tiltButton */
	tiltButton = XtVaCreateManagedWidget( "tiltButton",
			xmPushButtonWidgetClass,
			findPane,
			RES_CONVERT( XmNlabelString, "Tilt" ),
			XmNaccelerator, "Ctrl<Key>T",
			RES_CONVERT( XmNacceleratorText, "Ctrl+T" ),
			NULL );
	XtAddCallback( tiltButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_tiltButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( tiltButton, (char *) UxMainWSContext );


	/* Creation of viewCascade */
	viewCascade = XtVaCreateManagedWidget( "viewCascade",
			xmCascadeButtonWidgetClass,
			pullDownMenu,
			RES_CONVERT( XmNlabelString, "Estimate" ),
			XmNsubMenuId, findPane,
			XmNwidth, 73,
			NULL );
	UxPutContext( viewCascade, (char *) UxMainWSContext );


	/* Creation of processPane */
	processPane_shell = XtVaCreatePopupShell ("processPane_shell",
			xmMenuShellWidgetClass, pullDownMenu,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	processPane = XtVaCreateWidget( "processPane",
			xmRowColumnWidgetClass,
			processPane_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( processPane, (char *) UxMainWSContext );


	/* Creation of listButton */
	listButton = XtVaCreateManagedWidget( "listButton",
			xmPushButtonWidgetClass,
			processPane,
			RES_CONVERT( XmNlabelString, "List Objects" ),
			XmNaccelerator, "Ctrl<Key>L",
			RES_CONVERT( XmNacceleratorText, "Ctrl+L" ),
			NULL );
	XtAddCallback( listButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_listButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( listButton, (char *) UxMainWSContext );


	/* Creation of plotLineButton */
	plotLineButton = XtVaCreateManagedWidget( "plotLineButton",
			xmPushButtonWidgetClass,
			processPane,
			RES_CONVERT( XmNlabelString, "Plot Lines ..." ),
			NULL );
	XtAddCallback( plotLineButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_plotLineButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( plotLineButton, (char *) UxMainWSContext );


	/* Creation of plotScanButton */
	plotScanButton = XtVaCreateManagedWidget( "plotScanButton",
			xmPushButtonWidgetClass,
			processPane,
			RES_CONVERT( XmNlabelString, "Plot Scans ..." ),
			NULL );
	XtAddCallback( plotScanButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_plotScanButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( plotScanButton, (char *) UxMainWSContext );


	/* Creation of refineButton */
	refineButton = XtVaCreateManagedWidget( "refineButton",
			xmPushButtonWidgetClass,
			processPane,
			RES_CONVERT( XmNlabelString, "Refine ..." ),
			XmNaccelerator, "Ctrl<Key>F",
			RES_CONVERT( XmNacceleratorText, "Ctrl+F" ),
			NULL );
	XtAddCallback( refineButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_refineButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( refineButton, (char *) UxMainWSContext );


	/* Creation of pullDownMenu_top_b1 */
	pullDownMenu_top_b1 = XtVaCreateManagedWidget( "pullDownMenu_top_b1",
			xmCascadeButtonWidgetClass,
			pullDownMenu,
			RES_CONVERT( XmNlabelString, "Process" ),
			XmNsubMenuId, processPane,
			XmNwidth, 65,
			NULL );
	UxPutContext( pullDownMenu_top_b1, (char *) UxMainWSContext );


	/* Creation of optionsPane */
	optionsPane_shell = XtVaCreatePopupShell ("optionsPane_shell",
			xmMenuShellWidgetClass, pullDownMenu,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	optionsPane = XtVaCreateWidget( "optionsPane",
			xmRowColumnWidgetClass,
			optionsPane_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( optionsPane, (char *) UxMainWSContext );


	/* Creation of palettePane */
	palettePane_shell = XtVaCreatePopupShell ("palettePane_shell",
			xmMenuShellWidgetClass, optionsPane,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	palettePane = XtVaCreateWidget( "palettePane",
			xmRowColumnWidgetClass,
			palettePane_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			XmNradioBehavior, TRUE,
			NULL );
	UxPutContext( palettePane, (char *) UxMainWSContext );


	/* Creation of colour0Toggle */
	colour0Toggle = XtVaCreateManagedWidget( "colour0Toggle",
			xmToggleButtonWidgetClass,
			palettePane,
			RES_CONVERT( XmNlabelString, "Gray scale" ),
			XmNaccelerator, "Ctrl<Key>G",
			RES_CONVERT( XmNacceleratorText, "Ctrl+G" ),
			XmNset, TRUE,
			NULL );
	XtAddCallback( colour0Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_colour0Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( colour0Toggle, (char *) UxMainWSContext );


	/* Creation of colour1Toggle */
	colour1Toggle = XtVaCreateManagedWidget( "colour1Toggle",
			xmToggleButtonWidgetClass,
			palettePane,
			RES_CONVERT( XmNlabelString, "Colour 1" ),
			XmNaccelerator, "Ctrl<Key>1",
			RES_CONVERT( XmNacceleratorText, "Ctrl+1" ),
			NULL );
	XtAddCallback( colour1Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_colour1Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( colour1Toggle, (char *) UxMainWSContext );


	/* Creation of colour2Toggle */
	colour2Toggle = XtVaCreateManagedWidget( "colour2Toggle",
			xmToggleButtonWidgetClass,
			palettePane,
			RES_CONVERT( XmNlabelString, "Colour 2" ),
			XmNaccelerator, "Ctrl<Key>2",
			RES_CONVERT( XmNacceleratorText, "Ctrl+2" ),
			NULL );
	XtAddCallback( colour2Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_colour2Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( colour2Toggle, (char *) UxMainWSContext );


	/* Creation of colour3Toggle */
	colour3Toggle = XtVaCreateManagedWidget( "colour3Toggle",
			xmToggleButtonWidgetClass,
			palettePane,
			RES_CONVERT( XmNlabelString, "Colour 3" ),
			XmNaccelerator, "Ctrl<Key>3",
			RES_CONVERT( XmNacceleratorText, "Ctrl+3" ),
			NULL );
	XtAddCallback( colour3Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_colour3Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( colour3Toggle, (char *) UxMainWSContext );


	/* Creation of colour4Toggle */
	colour4Toggle = XtVaCreateManagedWidget( "colour4Toggle",
			xmToggleButtonWidgetClass,
			palettePane,
			RES_CONVERT( XmNlabelString, "Colour 4" ),
			XmNaccelerator, "Ctrl<Key>4",
			RES_CONVERT( XmNacceleratorText, "Ctrl+4" ),
			NULL );
	XtAddCallback( colour4Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_colour4Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( colour4Toggle, (char *) UxMainWSContext );


	/* Creation of colour5Toggle */
	colour5Toggle = XtVaCreateManagedWidget( "colour5Toggle",
			xmToggleButtonWidgetClass,
			palettePane,
			RES_CONVERT( XmNlabelString, "Colour 5" ),
			XmNaccelerator, "Ctrl<Key>5",
			RES_CONVERT( XmNacceleratorText, "Ctrl+5" ),
			NULL );
	XtAddCallback( colour5Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_colour5Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( colour5Toggle, (char *) UxMainWSContext );


	/* Creation of paletteCascade */
	paletteCascade = XtVaCreateManagedWidget( "paletteCascade",
			xmCascadeButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Palette" ),
			XmNsubMenuId, palettePane,
			NULL );
	UxPutContext( paletteCascade, (char *) UxMainWSContext );


	/* Creation of magPane */
	magPane_shell = XtVaCreatePopupShell ("magPane_shell",
			xmMenuShellWidgetClass, optionsPane,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	magPane = XtVaCreateWidget( "magPane",
			xmRowColumnWidgetClass,
			magPane_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			XmNradioBehavior, TRUE,
			NULL );
	UxPutContext( magPane, (char *) UxMainWSContext );


	/* Creation of x2Toggle */
	x2Toggle = XtVaCreateManagedWidget( "x2Toggle",
			xmToggleButtonWidgetClass,
			magPane,
			RES_CONVERT( XmNlabelString, "x2" ),
			NULL );
	XtAddCallback( x2Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_x2Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( x2Toggle, (char *) UxMainWSContext );


	/* Creation of x4Toggle */
	x4Toggle = XtVaCreateManagedWidget( "x4Toggle",
			xmToggleButtonWidgetClass,
			magPane,
			RES_CONVERT( XmNlabelString, "x4" ),
			NULL );
	XtAddCallback( x4Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_x4Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( x4Toggle, (char *) UxMainWSContext );


	/* Creation of x8Toggle */
	x8Toggle = XtVaCreateManagedWidget( "x8Toggle",
			xmToggleButtonWidgetClass,
			magPane,
			RES_CONVERT( XmNlabelString, "x8" ),
			XmNset, TRUE,
			NULL );
	XtAddCallback( x8Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_x8Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( x8Toggle, (char *) UxMainWSContext );


	/* Creation of x16Toggle */
	x16Toggle = XtVaCreateManagedWidget( "x16Toggle",
			xmToggleButtonWidgetClass,
			magPane,
			RES_CONVERT( XmNlabelString, "x16" ),
			NULL );
	XtAddCallback( x16Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_x16Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( x16Toggle, (char *) UxMainWSContext );


	/* Creation of x32Toggle */
	x32Toggle = XtVaCreateManagedWidget( "x32Toggle",
			xmToggleButtonWidgetClass,
			magPane,
			RES_CONVERT( XmNlabelString, "x32" ),
			NULL );
	XtAddCallback( x32Toggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_x32Toggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( x32Toggle, (char *) UxMainWSContext );


	/* Creation of magCascade */
	magCascade = XtVaCreateManagedWidget( "magCascade",
			xmCascadeButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Magnification" ),
			XmNsubMenuId, magPane,
			NULL );
	UxPutContext( magCascade, (char *) UxMainWSContext );


	/* Creation of lineColourPane */
	lineColourPane_shell = XtVaCreatePopupShell ("lineColourPane_shell",
			xmMenuShellWidgetClass, optionsPane,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	lineColourPane = XtVaCreateWidget( "lineColourPane",
			xmRowColumnWidgetClass,
			lineColourPane_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			XmNradioBehavior, TRUE,
			NULL );
	UxPutContext( lineColourPane, (char *) UxMainWSContext );


	/* Creation of lineGreenToggle */
	lineGreenToggle = XtVaCreateManagedWidget( "lineGreenToggle",
			xmToggleButtonWidgetClass,
			lineColourPane,
			RES_CONVERT( XmNlabelString, "Green" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( lineGreenToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_lineGreenToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( lineGreenToggle, (char *) UxMainWSContext );


	/* Creation of lineRedToggle */
	lineRedToggle = XtVaCreateManagedWidget( "lineRedToggle",
			xmToggleButtonWidgetClass,
			lineColourPane,
			RES_CONVERT( XmNlabelString, "Red" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( lineRedToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_lineRedToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( lineRedToggle, (char *) UxMainWSContext );


	/* Creation of lineBlueToggle */
	lineBlueToggle = XtVaCreateManagedWidget( "lineBlueToggle",
			xmToggleButtonWidgetClass,
			lineColourPane,
			RES_CONVERT( XmNlabelString, "Blue" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( lineBlueToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_lineBlueToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( lineBlueToggle, (char *) UxMainWSContext );


	/* Creation of lineYellowToggle */
	lineYellowToggle = XtVaCreateManagedWidget( "lineYellowToggle",
			xmToggleButtonWidgetClass,
			lineColourPane,
			RES_CONVERT( XmNlabelString, "Yellow" ),
			XmNset, TRUE,
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( lineYellowToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_lineYellowToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( lineYellowToggle, (char *) UxMainWSContext );


	/* Creation of lineWhiteToggle */
	lineWhiteToggle = XtVaCreateManagedWidget( "lineWhiteToggle",
			xmToggleButtonWidgetClass,
			lineColourPane,
			RES_CONVERT( XmNlabelString, "White" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( lineWhiteToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_lineWhiteToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( lineWhiteToggle, (char *) UxMainWSContext );


	/* Creation of lineBlackToggle */
	lineBlackToggle = XtVaCreateManagedWidget( "lineBlackToggle",
			xmToggleButtonWidgetClass,
			lineColourPane,
			RES_CONVERT( XmNlabelString, "Black" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( lineBlackToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_lineBlackToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( lineBlackToggle, (char *) UxMainWSContext );


	/* Creation of lineColourCascade */
	lineColourCascade = XtVaCreateManagedWidget( "lineColourCascade",
			xmCascadeButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Line Colour" ),
			XmNsubMenuId, lineColourPane,
			NULL );
	UxPutContext( lineColourCascade, (char *) UxMainWSContext );


	/* Creation of pointColourPane */
	pointColourPane_shell = XtVaCreatePopupShell ("pointColourPane_shell",
			xmMenuShellWidgetClass, optionsPane,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	pointColourPane = XtVaCreateWidget( "pointColourPane",
			xmRowColumnWidgetClass,
			pointColourPane_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			XmNradioBehavior, TRUE,
			NULL );
	UxPutContext( pointColourPane, (char *) UxMainWSContext );


	/* Creation of greenToggle */
	greenToggle = XtVaCreateManagedWidget( "greenToggle",
			xmToggleButtonWidgetClass,
			pointColourPane,
			RES_CONVERT( XmNlabelString, "Green" ),
			XmNset, TRUE,
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( greenToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_greenToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( greenToggle, (char *) UxMainWSContext );


	/* Creation of redToggle */
	redToggle = XtVaCreateManagedWidget( "redToggle",
			xmToggleButtonWidgetClass,
			pointColourPane,
			RES_CONVERT( XmNlabelString, "Red" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( redToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_redToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( redToggle, (char *) UxMainWSContext );


	/* Creation of blueToggle */
	blueToggle = XtVaCreateManagedWidget( "blueToggle",
			xmToggleButtonWidgetClass,
			pointColourPane,
			RES_CONVERT( XmNlabelString, "Blue" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( blueToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_blueToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( blueToggle, (char *) UxMainWSContext );


	/* Creation of yellowToggle */
	yellowToggle = XtVaCreateManagedWidget( "yellowToggle",
			xmToggleButtonWidgetClass,
			pointColourPane,
			RES_CONVERT( XmNlabelString, "Yellow" ),
			NULL );
	XtAddCallback( yellowToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_yellowToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( yellowToggle, (char *) UxMainWSContext );


	/* Creation of whiteToggle */
	whiteToggle = XtVaCreateManagedWidget( "whiteToggle",
			xmToggleButtonWidgetClass,
			pointColourPane,
			RES_CONVERT( XmNlabelString, "White" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( whiteToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_whiteToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( whiteToggle, (char *) UxMainWSContext );


	/* Creation of blackToggle */
	blackToggle = XtVaCreateManagedWidget( "blackToggle",
			xmToggleButtonWidgetClass,
			pointColourPane,
			RES_CONVERT( XmNlabelString, "Black" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( blackToggle, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_blackToggle,
		(XtPointer) UxMainWSContext );

	UxPutContext( blackToggle, (char *) UxMainWSContext );


	/* Creation of pointColourCascade */
	pointColourCascade = XtVaCreateManagedWidget( "pointColourCascade",
			xmCascadeButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Lattice Point Colour" ),
			XmNsubMenuId, pointColourPane,
			NULL );
	UxPutContext( pointColourCascade, (char *) UxMainWSContext );


	/* Creation of optionsPane_b8 */
	optionsPane_b8 = XtVaCreateManagedWidget( "optionsPane_b8",
			xmSeparatorWidgetClass,
			optionsPane,
			NULL );
	UxPutContext( optionsPane_b8, (char *) UxMainWSContext );


	/* Creation of logButton */
	logButton = XtVaCreateManagedWidget( "logButton",
			xmToggleButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Log Scale" ),
			NULL );
	XtAddCallback( logButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_logButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( logButton, (char *) UxMainWSContext );


	/* Creation of interpolateButton */
	interpolateButton = XtVaCreateManagedWidget( "interpolateButton",
			xmToggleButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Interpolate" ),
			NULL );
	XtAddCallback( interpolateButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_interpolateButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( interpolateButton, (char *) UxMainWSContext );


	/* Creation of lineFitButton */
	lineFitButton = XtVaCreateManagedWidget( "lineFitButton",
			xmToggleButtonGadgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Fit Lines/Scans" ),
			NULL );
	XtAddCallback( lineFitButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_lineFitButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( lineFitButton, (char *) UxMainWSContext );


	/* Creation of showPointsButton */
	showPointsButton = XtVaCreateManagedWidget( "showPointsButton",
			xmToggleButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Show Lattice Points" ),
			XmNset, TRUE,
			NULL );
	XtAddCallback( showPointsButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_showPointsButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( showPointsButton, (char *) UxMainWSContext );


	/* Creation of optionsPane_b10 */
	optionsPane_b10 = XtVaCreateManagedWidget( "optionsPane_b10",
			xmSeparatorWidgetClass,
			optionsPane,
			NULL );
	UxPutContext( optionsPane_b10, (char *) UxMainWSContext );


	/* Creation of azimuthalButton */
	azimuthalButton = XtVaCreateManagedWidget( "azimuthalButton",
			xmToggleButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Azimuthal Scan" ),
			XmNset, TRUE,
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( azimuthalButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_azimuthalButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( azimuthalButton, (char *) UxMainWSContext );


	/* Creation of radialButton */
	radialButton = XtVaCreateManagedWidget( "radialButton",
			xmToggleButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Radial Scan" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( radialButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_radialButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( radialButton, (char *) UxMainWSContext );


	/* Creation of optionsPane_b12 */
	optionsPane_b12 = XtVaCreateManagedWidget( "optionsPane_b12",
			xmSeparatorWidgetClass,
			optionsPane,
			NULL );
	UxPutContext( optionsPane_b12, (char *) UxMainWSContext );


	/* Creation of latticePointButton */
	latticePointButton = XtVaCreateManagedWidget( "latticePointButton",
			xmToggleButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Generate lattice points" ),
			XmNindicatorType, XmONE_OF_MANY,
			XmNset, TRUE,
			NULL );
	XtAddCallback( latticePointButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_latticePointButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( latticePointButton, (char *) UxMainWSContext );


	/* Creation of latticeCircleButton */
	latticeCircleButton = XtVaCreateManagedWidget( "latticeCircleButton",
			xmToggleButtonWidgetClass,
			optionsPane,
			RES_CONVERT( XmNlabelString, "Generate lattice rings" ),
			XmNindicatorType, XmONE_OF_MANY,
			NULL );
	XtAddCallback( latticeCircleButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_latticeCircleButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( latticeCircleButton, (char *) UxMainWSContext );


	/* Creation of optionsCascade */
	optionsCascade = XtVaCreateManagedWidget( "optionsCascade",
			xmCascadeButtonWidgetClass,
			pullDownMenu,
			RES_CONVERT( XmNlabelString, "Options" ),
			XmNsubMenuId, optionsPane,
			XmNwidth, 65,
			NULL );
	UxPutContext( optionsCascade, (char *) UxMainWSContext );


	/* Creation of helpPane */
	helpPane_shell = XtVaCreatePopupShell ("helpPane_shell",
			xmMenuShellWidgetClass, pullDownMenu,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	helpPane = XtVaCreateWidget( "helpPane",
			xmRowColumnWidgetClass,
			helpPane_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( helpPane, (char *) UxMainWSContext );


	/* Creation of introButton */
	introButton = XtVaCreateManagedWidget( "introButton",
			xmPushButtonWidgetClass,
			helpPane,
			RES_CONVERT( XmNlabelString, "Introduction ..." ),
			NULL );
	XtAddCallback( introButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_introButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( introButton, (char *) UxMainWSContext );


	/* Creation of helpPane_b10 */
	helpPane_b10 = XtVaCreateManagedWidget( "helpPane_b10",
			xmSeparatorWidgetClass,
			helpPane,
			NULL );
	UxPutContext( helpPane_b10, (char *) UxMainWSContext );


	/* Creation of onFileButton */
	onFileButton = XtVaCreateManagedWidget( "onFileButton",
			xmPushButtonGadgetClass,
			helpPane,
			RES_CONVERT( XmNlabelString, "On File ..." ),
			RES_CONVERT( XmNmnemonic, "C" ),
			NULL );
	XtAddCallback( onFileButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_onFileButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( onFileButton, (char *) UxMainWSContext );


	/* Creation of onEditButton */
	onEditButton = XtVaCreateManagedWidget( "onEditButton",
			xmPushButtonGadgetClass,
			helpPane,
			RES_CONVERT( XmNlabelString, "On Edit ..." ),
			RES_CONVERT( XmNmnemonic, "W" ),
			NULL );
	XtAddCallback( onEditButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_onEditButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( onEditButton, (char *) UxMainWSContext );


	/* Creation of onEstimateButton */
	onEstimateButton = XtVaCreateManagedWidget( "onEstimateButton",
			xmPushButtonGadgetClass,
			helpPane,
			RES_CONVERT( XmNlabelString, "On Estimate ..." ),
			RES_CONVERT( XmNmnemonic, "K" ),
			NULL );
	XtAddCallback( onEstimateButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_onEstimateButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( onEstimateButton, (char *) UxMainWSContext );


	/* Creation of onProcessButton */
	onProcessButton = XtVaCreateManagedWidget( "onProcessButton",
			xmPushButtonGadgetClass,
			helpPane,
			RES_CONVERT( XmNlabelString, "On Process ..." ),
			RES_CONVERT( XmNmnemonic, "H" ),
			NULL );
	XtAddCallback( onProcessButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_onProcessButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( onProcessButton, (char *) UxMainWSContext );


	/* Creation of onOptionsButton */
	onOptionsButton = XtVaCreateManagedWidget( "onOptionsButton",
			xmPushButtonWidgetClass,
			helpPane,
			RES_CONVERT( XmNlabelString, "On Options ..." ),
			NULL );
	XtAddCallback( onOptionsButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_onOptionsButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( onOptionsButton, (char *) UxMainWSContext );


	/* Creation of onToolsButton */
	onToolsButton = XtVaCreateManagedWidget( "onToolsButton",
			xmPushButtonGadgetClass,
			helpPane,
			RES_CONVERT( XmNlabelString, "On Tools ..." ),
			NULL );
	XtAddCallback( onToolsButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_onToolsButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( onToolsButton, (char *) UxMainWSContext );


	/* Creation of helpCascade */
	helpCascade = XtVaCreateManagedWidget( "helpCascade",
			xmCascadeButtonWidgetClass,
			pullDownMenu,
			RES_CONVERT( XmNlabelString, "Help" ),
			XmNsubMenuId, helpPane,
			NULL );
	UxPutContext( helpCascade, (char *) UxMainWSContext );


	/* Creation of panedWindow1 */
	panedWindow1 = XtVaCreateManagedWidget( "panedWindow1",
			xmPanedWindowWidgetClass,
			mainWindow,
			XmNspacing, 10,
			NULL );
	UxPutContext( panedWindow1, (char *) UxMainWSContext );


	/* Creation of form1 */
	form1 = XtVaCreateManagedWidget( "form1",
			xmFormWidgetClass,
			panedWindow1,
			XmNresizePolicy, XmRESIZE_NONE,
			NULL );
	UxPutContext( form1, (char *) UxMainWSContext );


	/* Creation of label1 */
	label1 = XtVaCreateManagedWidget( "label1",
			xmLabelWidgetClass,
			form1,
			XmNx, 10,
			XmNy, 0,
			XmNwidth, 80,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Filename:" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNleftOffset, 10,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( label1, (char *) UxMainWSContext );


	/* Creation of label2 */
	label2 = XtVaCreateManagedWidget( "label2",
			xmLabelWidgetClass,
			form1,
			XmNx, 550,
			XmNy, 0,
			XmNwidth, 15,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "X:" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 300,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( label2, (char *) UxMainWSContext );


	/* Creation of label3 */
	label3 = XtVaCreateManagedWidget( "label3",
			xmLabelWidgetClass,
			form1,
			XmNx, 440,
			XmNy, 0,
			XmNwidth, 45,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Pixel:" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 450,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( label3, (char *) UxMainWSContext );


	/* Creation of frame1 */
	frame1 = XtVaCreateManagedWidget( "frame1",
			xmFrameWidgetClass,
			form1,
			XmNx, 530,
			XmNy, 10,
			XmNwidth, 128,
			XmNheight, 128,
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, 10,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 32,
			NULL );
	UxPutContext( frame1, (char *) UxMainWSContext );


	/* Creation of drawingArea2 */
	drawingArea2 = XtVaCreateManagedWidget( "drawingArea2",
			xmDrawingAreaWidgetClass,
			frame1,
			XmNresizePolicy, XmRESIZE_ANY,
			XmNwidth, 128,
			XmNheight, 128,
			RES_CONVERT( XmNbackground, "white" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNtranslations, area2PointTable ),
			NULL );
	UxPutContext( drawingArea2, (char *) UxMainWSContext );

	createCB_drawingArea2( drawingArea2,
			(XtPointer) UxMainWSContext, (XtPointer) NULL );


	/* Creation of label4 */
	label4 = XtVaCreateManagedWidget( "label4",
			xmLabelWidgetClass,
			form1,
			XmNx, 185,
			XmNy, 0,
			XmNwidth, 55,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Frame:" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 185,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( label4, (char *) UxMainWSContext );


	/* Creation of rowColumn1 */
	rowColumn1 = XtVaCreateManagedWidget( "rowColumn1",
			xmRowColumnWidgetClass,
			form1,
			XmNborderWidth, 1,
			XmNentryVerticalAlignment, XmALIGNMENT_CONTENTS_TOP,
			RES_CONVERT( XmNlabelString, "Tools" ),
			XmNpacking, XmPACK_TIGHT,
			XmNradioBehavior, TRUE,
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, 20,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 330,
			NULL );
	UxPutContext( rowColumn1, (char *) UxMainWSContext );


	/* Creation of togglePoint */
	togglePoint = XtVaCreateManagedWidget( "togglePoint",
			xmToggleButtonWidgetClass,
			rowColumn1,
			RES_CONVERT( XmNlabelString, "Points" ),
			XmNshadowThickness, 1,
			XmNset, TRUE,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNrecomputeSize, FALSE,
			XmNmarginHeight, 0,
			NULL );
	XtAddCallback( togglePoint, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_togglePoint,
		(XtPointer) 0x0 );

	UxPutContext( togglePoint, (char *) UxMainWSContext );


	/* Creation of toggleLine */
	toggleLine = XtVaCreateManagedWidget( "toggleLine",
			xmToggleButtonWidgetClass,
			rowColumn1,
			RES_CONVERT( XmNlabelString, "Lines" ),
			XmNshadowThickness, 1,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNrecomputeSize, FALSE,
			XmNmarginHeight, 0,
			NULL );
	XtAddCallback( toggleLine, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_toggleLine,
		(XtPointer) 0x0 );

	UxPutContext( toggleLine, (char *) UxMainWSContext );


	/* Creation of toggleThick */
	toggleThick = XtVaCreateManagedWidget( "toggleThick",
			xmToggleButtonWidgetClass,
			rowColumn1,
			RES_CONVERT( XmNlabelString, "Thick Lines" ),
			XmNshadowThickness, 1,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNrecomputeSize, FALSE,
			XmNmarginHeight, 0,
			NULL );
	XtAddCallback( toggleThick, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_toggleThick,
		(XtPointer) 0x0 );

	UxPutContext( toggleThick, (char *) UxMainWSContext );


	/* Creation of toggleRect */
	toggleRect = XtVaCreateManagedWidget( "toggleRect",
			xmToggleButtonWidgetClass,
			rowColumn1,
			RES_CONVERT( XmNlabelString, "Rectangles" ),
			XmNshadowThickness, 1,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNrecomputeSize, FALSE,
			XmNmarginHeight, 0,
			NULL );
	XtAddCallback( toggleRect, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_toggleRect,
		(XtPointer) 0x0 );

	UxPutContext( toggleRect, (char *) UxMainWSContext );


	/* Creation of togglePoly */
	togglePoly = XtVaCreateManagedWidget( "togglePoly",
			xmToggleButtonWidgetClass,
			rowColumn1,
			RES_CONVERT( XmNlabelString, "Polygons" ),
			XmNshadowThickness, 1,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNrecomputeSize, FALSE,
			XmNmarginHeight, 0,
			XmNx, -3,
			XmNy, 33,
			NULL );
	XtAddCallback( togglePoly, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_togglePoly,
		(XtPointer) 0x0 );

	UxPutContext( togglePoly, (char *) UxMainWSContext );


	/* Creation of toggleSector */
	toggleSector = XtVaCreateManagedWidget( "toggleSector",
			xmToggleButtonWidgetClass,
			rowColumn1,
			RES_CONVERT( XmNlabelString, "Sectors" ),
			XmNshadowThickness, 1,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNrecomputeSize, FALSE,
			XmNmarginHeight, 0,
			NULL );
	XtAddCallback( toggleSector, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_toggleSector,
		(XtPointer) 0x0 );

	UxPutContext( toggleSector, (char *) UxMainWSContext );


	/* Creation of toggleScan */
	toggleScan = XtVaCreateManagedWidget( "toggleScan",
			xmToggleButtonWidgetClass,
			rowColumn1,
			RES_CONVERT( XmNlabelString, "Scans" ),
			XmNshadowThickness, 1,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNrecomputeSize, FALSE,
			XmNmarginHeight, 0,
			NULL );
	XtAddCallback( toggleScan, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_toggleScan,
		(XtPointer) 0x0 );

	UxPutContext( toggleScan, (char *) UxMainWSContext );


	/* Creation of toggleZoom */
	toggleZoom = XtVaCreateManagedWidget( "toggleZoom",
			xmToggleButtonWidgetClass,
			rowColumn1,
			RES_CONVERT( XmNlabelString, "Zoom" ),
			XmNshadowThickness, 1,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNrecomputeSize, FALSE,
			XmNmarginHeight, 0,
			NULL );
	XtAddCallback( toggleZoom, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_toggleZoom,
		(XtPointer) 0x0 );

	UxPutContext( toggleZoom, (char *) UxMainWSContext );


	/* Creation of label5 */
	label5 = XtVaCreateManagedWidget( "label5",
			xmLabelWidgetClass,
			form1,
			XmNx, 640,
			XmNy, 160,
			XmNwidth, 15,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Y:" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 370,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( label5, (char *) UxMainWSContext );


	/* Creation of textHigh */
	textHigh = XtVaCreateManagedWidget( "textHigh",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 90,
			XmNheight, 30,
			XmNsensitive, FALSE,
			XmNvalue, "",
			XmNcolumns, 12,
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, 10,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 175,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNx, 582,
			XmNy, 176,
			NULL );
	XtAddCallback( textHigh, XmNactivateCallback,
		(XtCallbackProc) activateCB_textHigh,
		(XtPointer) UxMainWSContext );

	UxPutContext( textHigh, (char *) UxMainWSContext );


	/* Creation of textLow */
	textLow = XtVaCreateManagedWidget( "textLow",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 90,
			XmNheight, 30,
			XmNsensitive, FALSE,
			XmNvalue, "",
			XmNcolumns, 12,
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, 10,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 210,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNx, 582,
			XmNy, 211,
			NULL );
	XtAddCallback( textLow, XmNactivateCallback,
		(XtCallbackProc) activateCB_textLow,
		(XtPointer) UxMainWSContext );

	UxPutContext( textLow, (char *) UxMainWSContext );


	/* Creation of label6 */
	label6 = XtVaCreateManagedWidget( "label6",
			xmLabelWidgetClass,
			form1,
			XmNwidth, 45,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "High:" ),
			XmNalignment, XmALIGNMENT_BEGINNING,
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, 100,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 175,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNx, 537,
			XmNy, 176,
			NULL );
	UxPutContext( label6, (char *) UxMainWSContext );


	/* Creation of label7 */
	label7 = XtVaCreateManagedWidget( "label7",
			xmLabelWidgetClass,
			form1,
			XmNwidth, 45,
			XmNheight, 30,
			XmNalignment, XmALIGNMENT_BEGINNING,
			RES_CONVERT( XmNlabelString, "Low:" ),
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, 100,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 210,
			XmNfontList, UxConvertFontList("7x14" ),
			XmNx, 542,
			XmNy, 211,
			NULL );
	UxPutContext( label7, (char *) UxMainWSContext );


	/* Creation of textX */
	textX = XtVaCreateManagedWidget( "textX",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 50,
			XmNx, 580,
			XmNy, 170,
			XmNheight, 30,
			XmNcursorPositionVisible, FALSE,
			XmNeditable, FALSE,
			XmNvalue, "",
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 320,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( textX, (char *) UxMainWSContext );


	/* Creation of textY */
	textY = XtVaCreateManagedWidget( "textY",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 50,
			XmNx, 440,
			XmNy, 0,
			XmNheight, 30,
			XmNcursorPositionVisible, FALSE,
			XmNeditable, FALSE,
			XmNvalue, "",
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 390,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( textY, (char *) UxMainWSContext );


	/* Creation of textValue */
	textValue = XtVaCreateManagedWidget( "textValue",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 90,
			XmNx, -140,
			XmNy, 195,
			XmNheight, 30,
			XmNcursorPositionVisible, FALSE,
			XmNeditable, FALSE,
			XmNvalue, "",
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 495,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( textValue, (char *) UxMainWSContext );


	/* Creation of arrowButton1 */
	arrowButton1 = XtVaCreateManagedWidget( "arrowButton1",
			xmArrowButtonWidgetClass,
			form1,
			XmNx, 650,
			XmNy, 10,
			XmNwidth, 30,
			XmNheight, 30,
			XmNarrowDirection, XmARROW_RIGHT,
			XmNsensitive, FALSE,
			RES_CONVERT( XmNhighlightColor, "black" ),
			RES_CONVERT( XmNforeground, "green" ),
			RES_CONVERT( XmNtopShadowColor, "#a0a8a0" ),
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNleftOffset, 650,
			NULL );
	XtAddCallback( arrowButton1, XmNactivateCallback,
		(XtCallbackProc) activateCB_arrowButton1,
		(XtPointer) UxMainWSContext );

	UxPutContext( arrowButton1, (char *) UxMainWSContext );


	/* Creation of imageText */
	imageText = XtVaCreateManagedWidget( "imageText",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 30,
			XmNx, 620,
			XmNy, 10,
			XmNheight, 30,
			XmNcolumns, 2,
			XmNcursorPositionVisible, FALSE,
			XmNeditable, FALSE,
			XmNvalue, "",
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	XtAddCallback( imageText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_imageText,
		(XtPointer) UxMainWSContext );

	UxPutContext( imageText, (char *) UxMainWSContext );


	/* Creation of arrowButton2 */
	arrowButton2 = XtVaCreateManagedWidget( "arrowButton2",
			xmArrowButtonWidgetClass,
			form1,
			XmNx, 600,
			XmNy, 0,
			XmNwidth, 30,
			XmNheight, 30,
			XmNarrowDirection, XmARROW_LEFT,
			XmNsensitive, FALSE,
			RES_CONVERT( XmNhighlightColor, "black" ),
			RES_CONVERT( XmNforeground, "green" ),
			RES_CONVERT( XmNtopShadowColor, "#a0a8a0" ),
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 590,
			XmNtopAttachment, XmATTACH_FORM,
			NULL );
	XtAddCallback( arrowButton2, XmNactivateCallback,
		(XtCallbackProc) activateCB_arrowButton2,
		(XtPointer) UxMainWSContext );

	UxPutContext( arrowButton2, (char *) UxMainWSContext );


	/* Creation of fileText */
	fileText = XtVaCreateManagedWidget( "fileText",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 90,
			XmNx, 90,
			XmNy, 10,
			XmNheight, 30,
			XmNcursorPositionVisible, FALSE,
			XmNeditable, FALSE,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 90,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( fileText, (char *) UxMainWSContext );


	/* Creation of frameText */
	frameText = XtVaCreateManagedWidget( "frameText",
			xmTextFieldWidgetClass,
			form1,
			XmNwidth, 50,
			XmNx, 240,
			XmNy, 10,
			XmNheight, 30,
			XmNcursorPositionVisible, FALSE,
			XmNeditable, FALSE,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 0,
			XmNleftOffset, 240,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	UxPutContext( frameText, (char *) UxMainWSContext );


	/* Creation of scrolledWindow1 */
	scrolledWindow1 = XtVaCreateManagedWidget( "scrolledWindow1",
			xmScrolledWindowWidgetClass,
			form1,
			XmNscrollingPolicy, XmAUTOMATIC,
			XmNwidth, 530,
			XmNheight, 530,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNvisualPolicy, XmVARIABLE,
			XmNshadowThickness, 1,
			XmNborderWidth, 1,
			XmNspacing, 0,
			XmNbottomAttachment, XmATTACH_FORM,
			XmNleftAttachment, XmATTACH_FORM,
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, 152,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 32,
			NULL );
	UxPutContext( scrolledWindow1, (char *) UxMainWSContext );


	/* Creation of drawingArea1 */
	drawingArea1 = XtVaCreateManagedWidget( "drawingArea1",
			xmDrawingAreaWidgetClass,
			scrolledWindow1,
			XmNresizePolicy, XmRESIZE_ANY,
			XmNwidth, 512,
			XmNheight, 512,
			XmNx, 0,
			XmNy, 0,
			XmNmarginHeight, 0,
			XmNmarginWidth, 0,
			RES_CONVERT( XmNtranslations, area1PointTable ),
			RES_CONVERT( XmNbackground, "white" ),
			RES_CONVERT( XmNforeground, "white" ),
			NULL );
	UxPutContext( drawingArea1, (char *) UxMainWSContext );

	createCB_drawingArea1( drawingArea1,
			(XtPointer) UxMainWSContext, (XtPointer) NULL );


	/* Creation of invertButton */
	invertButton = XtVaCreateManagedWidget( "invertButton",
			xmPushButtonWidgetClass,
			form1,
			XmNwidth, 110,
			XmNheight, 30,
			XmNleftAttachment, XmATTACH_NONE,
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, 20,
			XmNtopOffset, 255,
			RES_CONVERT( XmNlabelString, "Invert Palette" ),
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	XtAddCallback( invertButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_invertButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( invertButton, (char *) UxMainWSContext );


	/* Creation of refreshButton */
	refreshButton = XtVaCreateManagedWidget( "refreshButton",
			xmPushButtonWidgetClass,
			form1,
			XmNwidth, 110,
			XmNheight, 30,
			RES_CONVERT( XmNlabelString, "Refresh" ),
			XmNtopOffset, 290,
			XmNleftAttachment, XmATTACH_NONE,
			XmNrightAttachment, XmATTACH_FORM,
			XmNrightOffset, 20,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("7x14" ),
			NULL );
	XtAddCallback( refreshButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_refreshButton,
		(XtPointer) UxMainWSContext );

	UxPutContext( refreshButton, (char *) UxMainWSContext );


	/* Creation of scrolledWindowText1 */
	scrolledWindowText1 = XtVaCreateManagedWidget( "scrolledWindowText1",
			xmScrolledWindowWidgetClass,
			panedWindow1,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNx, 15,
			XmNy, 595,
			XmNborderWidth, 1,
			XmNwidth, 680,
			XmNheight, 300,
			XmNallowResize, TRUE,
			NULL );
	UxPutContext( scrolledWindowText1, (char *) UxMainWSContext );


	/* Creation of scrolledText1 */
	scrolledText1 = XtVaCreateManagedWidget( "scrolledText1",
			xmTextWidgetClass,
			scrolledWindowText1,
			XmNwidth, 680,
			XmNheight, 200,
			XmNvalue, "xfix GUI: last update 09/09/97\n",
			XmNcursorPositionVisible, FALSE,
			XmNeditable, FALSE,
			XmNscrollHorizontal, TRUE,
			XmNscrollVertical, TRUE,
			XmNresizeHeight, TRUE,
			XmNresizeWidth, TRUE,
			XmNeditMode, XmMULTI_LINE_EDIT ,
			XmNrows, 24,
			NULL );
	UxPutContext( scrolledText1, (char *) UxMainWSContext );

	XtVaSetValues(pullDownMenu,
			XmNmenuHelpWidget, helpCascade,
			NULL );


	XtAddCallback( mainWS, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxMainWSContext);

	XmMainWindowSetAreas( mainWindow, pullDownMenu, (Widget) NULL,
			(Widget) NULL, (Widget) NULL, panedWindow1 );

	return ( mainWS );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_mainWS( swidget _Uxparent )
{
	Widget                  rtrn;
	_UxCmainWS              *UxContext;
	static int		_Uxinit = 0;

	UxMainWSContext = UxContext =
		(_UxCmainWS *) UxNewContext( sizeof(_UxCmainWS), False );

	parent = _Uxparent;

	if ( ! _Uxinit )
	{
		static XtActionsRec	_Uxactions[] = {
			{ "area1_sector_handler", (XtActionProc) action_area1_sector_handler },
			{ "area2_poly_handler", (XtActionProc) action_area2_poly_handler },
			{ "area2_rect_handler", (XtActionProc) action_area2_rect_handler },
			{ "area2_thick_handler", (XtActionProc) action_area2_thick_handler },
			{ "area2_line_handler", (XtActionProc) action_area2_line_handler },
			{ "area1_zoom_handler", (XtActionProc) action_area1_zoom_handler },
			{ "area1_poly_handler", (XtActionProc) action_area1_poly_handler },
			{ "area1_rect_handler", (XtActionProc) action_area1_rect_handler },
			{ "area1_thick_handler", (XtActionProc) action_area1_thick_handler },
			{ "area1_line_handler", (XtActionProc) action_area1_line_handler },
			{ "area2_point_handler", (XtActionProc) action_area2_point_handler },
			{ "refresh_image2", (XtActionProc) action_refresh_image2 },
			{ "area1_point_handler", (XtActionProc) action_area1_point_handler },
			{ "refresh_image1", (XtActionProc) action_refresh_image1 }};

		XtAppAddActions( UxAppContext,
				_Uxactions,
				XtNumber(_Uxactions) );

		_UxIfClassId = UxNewInterfaceClassId();
		UxmainWS_getCentre_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_getCentre_Name,
				(void (*)()) _mainWS_getCentre );
		UxmainWS_setRotX_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setRotX_Name,
				(void (*)()) _mainWS_setRotX );
		UxmainWS_setRefineRotX_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setRefineRotX_Name,
				(void (*)()) _mainWS_setRefineRotX );
		UxmainWS_setRotY_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setRotY_Name,
				(void (*)()) _mainWS_setRotY );
		UxmainWS_setRefineRotY_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setRefineRotY_Name,
				(void (*)()) _mainWS_setRefineRotY );
		UxmainWS_setRotZ_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setRotZ_Name,
				(void (*)()) _mainWS_setRotZ );
		UxmainWS_setRefineRotZ_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setRefineRotZ_Name,
				(void (*)()) _mainWS_setRefineRotZ );
		UxmainWS_imageLimits_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_imageLimits_Name,
				(void (*)()) _mainWS_imageLimits );
		UxmainWS_setRefineCentre_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setRefineCentre_Name,
				(void (*)()) _mainWS_setRefineCentre );
		UxmainWS_setDistance_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setDistance_Name,
				(void (*)()) _mainWS_setDistance );
		UxmainWS_setTilt_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setTilt_Name,
				(void (*)()) _mainWS_setTilt );
		UxmainWS_setRefineTilt_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setRefineTilt_Name,
				(void (*)()) _mainWS_setRefineTilt );
		UxmainWS_removeLattice_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_removeLattice_Name,
				(void (*)()) _mainWS_removeLattice );
		UxmainWS_setWavelength_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setWavelength_Name,
				(void (*)()) _mainWS_setWavelength );
		UxmainWS_SetHeaders_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_SetHeaders_Name,
				(void (*)()) _mainWS_SetHeaders );
		UxmainWS_setCal_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setCal_Name,
				(void (*)()) _mainWS_setCal );
		UxmainWS_help_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_help_Name,
				(void (*)()) _mainWS_help );
		UxmainWS_setCentreX_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setCentreX_Name,
				(void (*)()) _mainWS_setCentreX );
		UxmainWS_setCentreY_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_setCentreY_Name,
				(void (*)()) _mainWS_setCentreY );
		UxmainWS_continue_Id = UxMethodRegister( _UxIfClassId,
				UxmainWS_continue_Name,
				(void (*)()) _mainWS_continue );
		UxLoadResources( "mainWS.rf" );
		_Uxinit = 1;
	}

	{
		int argcMain;
		char **argvMain;
		rtrn = _Uxbuild_mainWS();

		drawFSD = create_fileSelect(rtrn);
		confirmD = create_confirmDialog(rtrn);
		parameterD = create_parameterDialog(rtrn);
		objectD = create_objectEditDialog(rtrn);
		lineD = create_lineEditDialog(rtrn);
		scanD = create_scanEditDialog(rtrn);
		cellD = create_cellDialog(rtrn);
		setup = create_setupDialog (rtrn);
		error = create_errorDialog (rtrn);
		warning = create_warningDialog (rtrn);
		working = create_workingDialog (rtrn);
		info = create_infoDialog (rtrn);
		channels = create_channelDialog (rtrn);
		minmaxy = create_yDialog (rtrn);
		continueD = create_continueDialog (rtrn);
		refineD = create_refineDialog(rtrn);
		bslSelect = create_bslFileSelect(rtrn);
		header = create_headerDialog(rtrn);
		
		CreateWindowManagerProtocols(UxGetWidget(rtrn), ExitCB);
		SetIconImage (UxGetWidget (mainWS));
		
		watch = XCreateFontCursor (UxDisplay, XC_watch);
		lastToggle = UxGetWidget (togglePoint);
		firstRun = 1;
		inputPause = 0;
		psCounter = 0;
		currentDir = NULL;
		fileName = NULL;
		yfile = NULL;
		outfile = NULL;
		iffr = 1;
		ilfr = 1;
		ifinc = 0;
		filenum = 1;
		
		if ((ccp13ptr = (char *) getenv ("CCP13HOME")))
		{
		    helpfile = AddString (ccp13ptr, "/doc/xfix.html");
		}
		else
		{
		    helpfile = "http://www.dl.ac.uk/SRS/CCP13/program/xfix.html";
		}
		
		fitLines = False;
		mode = 0;
		repeat = False;
		radialScan = False;
		invertedPalette = False;
		plotLatticePoints = True;
		wavelength = 1.5418;
		distance = 1000.0;
		centreX = centreY = 0.0;
		rotX = rotY = rotZ = 0.0;
		tilt = 0.0;
		
		refineCentre = refineRotX = True;
		refineRotY = refineRotZ = refineTilt = False;
		
		UxPopupInterface(rtrn, no_grab);
		InitGraphics ();
		update_messages ("\nPoints: Use the cursor to select points in the main window ");
		update_messages ("or the magnification window\n\n");
		update_messages ("Left mouse button selects point\n");
		update_messages ("Middle mouse button freezes magnification window\n");
		update_messages ("Right mouse button releases magnification window\n\n");
		update_messages ("\nStarting Fix program...\n");
		
		XtVaGetValues (UxTopLevel, XmNargc, &argcMain, XmNargv, &argvMain, NULL);
		switch (argcMain)
		{
		   case 8:
		      filenum = atoi (argvMain[7]);
		      ifinc = atoi (argvMain[6]);
		      ilfr = atoi (argvMain[5]);
		      iffr = atoi (argvMain[4]);
		   case 4:
		      nrast = atoi (argvMain[3]);
		      npix = atoi (argvMain[2]);
		      OpenFile (argvMain[1]);
		      break;
		   default:
		      break;
		}
		
		return(rtrn);
	}
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

