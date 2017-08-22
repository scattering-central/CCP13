
/*******************************************************************************
	setupDialog.c

       Associated Header file: setupDialog.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/Separator.h>
#include <Xm/PushB.h>
#include <Xm/Form.h>
#include <Xm/ScrolledW.h>
#include <Xm/Form.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>
#include <Xm/Separator.h>
#include <Xm/Label.h>
#ifndef DESIGN_TIME
#include "peakRowColumn.h"
#include "parRowColumn.h"
#include "tieDialog.h"
#include "limitDialog.h"
#else
extern swidget create_tieDialog ();
extern swidget create_limitDialog ();
#endif

#include "mprintf.h"

extern void SetBusyPointer (int);

swidget tieD;
swidget limitD;


static	int _UxIfClassId;
int	UxsetupDialog_setParRC_Id = -1;
char*	UxsetupDialog_setParRC_Name = "setParRC";
int	UxsetupDialog_sensitive_Id = -1;
char*	UxsetupDialog_sensitive_Name = "sensitive";
int	UxsetupDialog_getLimitsN_Id = -1;
char*	UxsetupDialog_getLimitsN_Name = "getLimitsN";
int	UxsetupDialog_setLimitsN_Id = -1;
char*	UxsetupDialog_setLimitsN_Name = "setLimitsN";
int	UxsetupDialog_quit_Id = -1;
char*	UxsetupDialog_quit_Name = "quit";
int	UxsetupDialog_reinit_Id = -1;
char*	UxsetupDialog_reinit_Name = "reinit";
int	UxsetupDialog_checkValN_Id = -1;
char*	UxsetupDialog_checkValN_Name = "checkValN";
int	UxsetupDialog_getTieN_Id = -1;
char*	UxsetupDialog_getTieN_Name = "getTieN";
int	UxsetupDialog_getDescrN_Id = -1;
char*	UxsetupDialog_getDescrN_Name = "getDescrN";
int	UxsetupDialog_setTieN_Id = -1;
char*	UxsetupDialog_setTieN_Name = "setTieN";
int	UxsetupDialog_getStateN_Id = -1;
char*	UxsetupDialog_getStateN_Name = "getStateN";
int	UxsetupDialog_setStateN_Id = -1;
char*	UxsetupDialog_setStateN_Name = "setStateN";
int	UxsetupDialog_set_Id = -1;
char*	UxsetupDialog_set_Name = "set";
int	UxsetupDialog_put_Id = -1;
char*	UxsetupDialog_put_Name = "put";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "setupDialog.h"
#undef CONTEXT_MACRO_ACCESS

Widget	setupDialog;

/*******************************************************************************
Declarations of methods
*******************************************************************************/

static void	_setupDialog_setParRC( swidget UxThis, Environment * pEnv, int n, char *string );
static int	_setupDialog_sensitive( swidget UxThis, Environment * pEnv, Boolean tf );
static void	_setupDialog_getLimitsN( swidget UxThis, Environment * pEnv, int n, double *lim1, double *lim2 );
static void	_setupDialog_setLimitsN( swidget UxThis, Environment * pEnv, int n, double lim1, double lim2 );
static int	_setupDialog_quit( swidget UxThis, Environment * pEnv );
static void	_setupDialog_reinit( swidget UxThis, Environment * pEnv );
static int	_setupDialog_checkValN( swidget UxThis, Environment * pEnv, int n, double *v );
static void	_setupDialog_getTieN( swidget UxThis, Environment * pEnv, int n, int *t_num, int *c_type, int *ih, int *ik, int *il );
static char*	_setupDialog_getDescrN( swidget UxThis, Environment * pEnv, int n );
static void	_setupDialog_setTieN( swidget UxThis, Environment * pEnv, int n, int t_num, int c_type, int ih, int ik, int il );
static void	_setupDialog_getStateN( swidget UxThis, Environment * pEnv, int n, int *istate );
static void	_setupDialog_setStateN( swidget UxThis, Environment * pEnv, int n, int istate );
static int	_setupDialog_set( swidget UxThis, Environment * pEnv, char *string );
static int	_setupDialog_put( swidget UxThis, Environment * pEnv, char *string );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static void	Ux_setParRC( swidget UxThis, Environment * pEnv, int n, char *string )
{
#include "setupDialog_setParRC.c"
}

static void	_setupDialog_setParRC( swidget UxThis, Environment * pEnv, int n, char *string )
{
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setParRC( UxThis, pEnv, n, string );
	UxSetupDialogContext = UxSaveCtx;
}

static int	Ux_sensitive( swidget UxThis, Environment * pEnv, Boolean tf )
{
#include "setupDialog_SetSensitive.c"
}

static int	_setupDialog_sensitive( swidget UxThis, Environment * pEnv, Boolean tf )
{
	int			_Uxrtrn;
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_sensitive( UxThis, pEnv, tf );
	UxSetupDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_getLimitsN( swidget UxThis, Environment * pEnv, int n, double *lim1, double *lim2 )
{
	parRowColumn_getLimits (par_rowColInstance[n], &UxEnv, lim1, lim2);
}

static void	_setupDialog_getLimitsN( swidget UxThis, Environment * pEnv, int n, double *lim1, double *lim2 )
{
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_getLimitsN( UxThis, pEnv, n, lim1, lim2 );
	UxSetupDialogContext = UxSaveCtx;
}

static void	Ux_setLimitsN( swidget UxThis, Environment * pEnv, int n, double lim1, double lim2 )
{
#include "setupDialog_setLimits.c"
}

static void	_setupDialog_setLimitsN( swidget UxThis, Environment * pEnv, int n, double lim1, double lim2 )
{
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setLimitsN( UxThis, pEnv, n, lim1, lim2 );
	UxSetupDialogContext = UxSaveCtx;
}

static int	Ux_quit( swidget UxThis, Environment * pEnv )
{
	int i;
	 
	  UxPopdownInterface (UxThis);
	 
	  for (i=1; i<=npeak; i++)
	    {
	      XtDestroyWidget (peak_rowColInstance[i]);
	    }
	 
	  for (i=1; i<=npar; i++)
	    {
	      XtDestroyWidget (par_rowColInstance[i]);
	    }
	 
	  XtDestroyWidget (separator);
	  XtDestroyWidget (labelBack_poly_degree);
	  if (fexp)
	    XtDestroyWidget (labelBack_exp_comp);
	 
	  npar = 0;
	  npeak = 0;
	  fexp = 0;
	  current_y = 10;
	 
	  XtVaSetValues (UxGetWidget (form3),
	                 XmNheight, 400,
	                 NULL);
	 
	  return;
}

static int	_setupDialog_quit( swidget UxThis, Environment * pEnv )
{
	int			_Uxrtrn;
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_quit( UxThis, pEnv );
	UxSetupDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_reinit( swidget UxThis, Environment * pEnv )
{
#include "setupDialog_reinit.c"
}

static void	_setupDialog_reinit( swidget UxThis, Environment * pEnv )
{
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_reinit( UxThis, pEnv );
	UxSetupDialogContext = UxSaveCtx;
}

static int	Ux_checkValN( swidget UxThis, Environment * pEnv, int n, double *v )
{
#include "setupDialog_checkVal.c"
}

static int	_setupDialog_checkValN( swidget UxThis, Environment * pEnv, int n, double *v )
{
	int			_Uxrtrn;
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_checkValN( UxThis, pEnv, n, v );
	UxSetupDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_getTieN( swidget UxThis, Environment * pEnv, int n, int *t_num, int *c_type, int *ih, int *ik, int *il )
{
	parRowColumn_getTie (par_rowColInstance[n], &UxEnv, t_num, c_type, ih, ik, il);
}

static void	_setupDialog_getTieN( swidget UxThis, Environment * pEnv, int n, int *t_num, int *c_type, int *ih, int *ik, int *il )
{
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_getTieN( UxThis, pEnv, n, t_num, c_type, ih, ik, il );
	UxSetupDialogContext = UxSaveCtx;
}

static char*	Ux_getDescrN( swidget UxThis, Environment * pEnv, int n )
{
	char *cptr = NULL;
	 
	if (n > 0 && n <= npar)
	    cptr = (char *) parRowColumn_getDescr (par_rowColInstance[n], &UxEnv);
	 
	return (cptr);
}

static char*	_setupDialog_getDescrN( swidget UxThis, Environment * pEnv, int n )
{
	char*			_Uxrtrn;
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getDescrN( UxThis, pEnv, n );
	UxSetupDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_setTieN( swidget UxThis, Environment * pEnv, int n, int t_num, int c_type, int ih, int ik, int il )
{
#include "setupDialog_setTie.c"
}

static void	_setupDialog_setTieN( swidget UxThis, Environment * pEnv, int n, int t_num, int c_type, int ih, int ik, int il )
{
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setTieN( UxThis, pEnv, n, t_num, c_type, ih, ik, il );
	UxSetupDialogContext = UxSaveCtx;
}

static void	Ux_getStateN( swidget UxThis, Environment * pEnv, int n, int *istate )
{
	parRowColumn_getState (par_rowColInstance[n], &UxEnv, istate);
}

static void	_setupDialog_getStateN( swidget UxThis, Environment * pEnv, int n, int *istate )
{
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_getStateN( UxThis, pEnv, n, istate );
	UxSetupDialogContext = UxSaveCtx;
}

static void	Ux_setStateN( swidget UxThis, Environment * pEnv, int n, int istate )
{
#include "setupDialog_setState.c"
}

static void	_setupDialog_setStateN( swidget UxThis, Environment * pEnv, int n, int istate )
{
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setStateN( UxThis, pEnv, n, istate );
	UxSetupDialogContext = UxSaveCtx;
}

static int	Ux_set( swidget UxThis, Environment * pEnv, char *string )
{
#include "setupDialog_set.c"
}

static int	_setupDialog_set( swidget UxThis, Environment * pEnv, char *string )
{
	int			_Uxrtrn;
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_set( UxThis, pEnv, string );
	UxSetupDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static int	Ux_put( swidget UxThis, Environment * pEnv, char *string )
{
	static char descr[20];
	  char peak_label[20], par_label[20], description[20], buf[80], *cptr;
	  static int lastpeak = 0;
	  int poly_degree, par_number;
	  double par_value;
	 
	  cptr = strtok (string, " \n");
	  if (!cptr)
	    {
	      return;
	    }
	 
#ifndef DESIGN_TIME
	   while (*cptr)
	     {
	       if (strcmp (cptr, "Peak") == 0)
	         {
	           cptr = strtok (NULL, " ");
	           lastpeak = atoi (cptr);
	           cptr = strtok (NULL, " ");
	           sprintf (descr, "Peak %2d", lastpeak);
	           
	           /* Creation of peak_rowColInstance(lastpeak) */
	           peak_rowColInstance[lastpeak] = create_peakRowColumn( form3, descr, cptr);
	           UxPUT_PROPERTY(peak_rowColInstance[lastpeak],x,int,0);
	           UxPUT_PROPERTY(peak_rowColInstance[lastpeak],y,int,current_y);
	           UxPUT_PROPERTY(peak_rowColInstance[lastpeak],width,int,300);
	           UxPUT_PROPERTY(peak_rowColInstance[lastpeak],height,int,30);
	           
	           Interface_UxManage(peak_rowColInstance[lastpeak], &UxEnv );  
	           npeak++;
	           break;
	         }
	       
	       else if (strcmp (cptr, "Polynomial") == 0)
	         {
	           cptr = strtok (NULL, "=");
	           cptr = strtok (NULL, " ");
	           poly_degree = atoi (cptr);
	           sprintf (buf, "Polynomial background degree  %d", poly_degree);
	           sprintf (descr, "Polynomial");
	           
	           /* Creation of separator */
	           separator = XtVaCreateManagedWidget( "separator",
	                                               xmSeparatorWidgetClass,
	                                               form3,
	                                               XmNwidth, 630,
	                                               XmNheight, 10,
	                                               XmNx, 0,
	                                               XmNy, current_y,
	                                               NULL );
	           UxPutContext( separator, (char *) UxSetupDialogContext ); 
	 
	           /* Creation of labelBack_poly_degree */
	           current_y += 20;
	           labelBack_poly_degree = XtVaCreateManagedWidget( "labelBack_poly_degree",
	                                                           xmLabelWidgetClass,
	                                                           form3,
	                                                           XmNx, 10,
	                                                           XmNy, current_y,
	                                                           XmNwidth, 250,
	                                                           XmNheight, 30,
	                                                           RES_CONVERT( XmNlabelString, buf ),
	                                                           XmNfontList, UxConvertFontList( "8x13bold" ),
	                                                           NULL );
	           UxPutContext( labelBack_poly_degree, (char *) UxSetupDialogContext );
	           break;
	         }
	 
	       else if (strcmp (cptr, "Exponential") == 0)
	         {
	           sprintf (descr, "Exponential");
	           /* Creation of labelBack_exp_comp */
	           labelBack_exp_comp = XtVaCreateManagedWidget( "labelBack_exp_comp",
	                                                        xmLabelWidgetClass,
	                                                        form3,
	                                                        XmNx, 10,
	                                                        XmNy, current_y,
	                                                        XmNwidth, 250,
	                                                        XmNheight, 30,
	                                                        RES_CONVERT( XmNlabelString, "Exponential background component" ),
	                                                        XmNfontList, UxConvertFontList( "8x13bold" ),
	                                                        NULL );
	           UxPutContext( labelBack_exp_comp, (char *) UxSetupDialogContext );  
	           fexp = 1;
	           break;
	         }
	       
	       else if (strcmp (cptr, "Parameter") == 0)
	         {
	           cptr = strtok (NULL, " ");
	           par_number = atoi (cptr);
	           cptr = strtok (NULL, " ");
	           (void) strcpy (par_label, cptr);
	           sprintf (description, "(%s: %s)", descr, par_label);
	           cptr = strtok (NULL, " ");
	           par_value = atof (cptr);
	           sprintf (buf, "%2d  %s:", par_number, par_label);
	           sprintf (par_label, "%g", par_value);
	           
	           /* Creation of par_rowColInstance */
	           par_rowColInstance[par_number] = create_parRowColumn( form3, buf, par_label, description);
	           UxPUT_PROPERTY(par_rowColInstance[par_number],x,int,0);
	           UxPUT_PROPERTY(par_rowColInstance[par_number],y,int,current_y);
	           UxPUT_PROPERTY(par_rowColInstance[par_number],width,int,630);
	           UxPUT_PROPERTY(par_rowColInstance[par_number],height,int,30);
	           
	           Interface_UxManage(par_rowColInstance[par_number], &UxEnv );  
	           npar++;
	           break;
	         }
	       else
	         {
	           cptr++;
	         }
	 
	     }
	   current_y += 40;
	   if (current_y > 400)
	     {
	       XtVaSetValues (UxGetWidget (form3),
	                      XmNheight, current_y,
	                      NULL);
	     }
#endif
}

static int	_setupDialog_put( swidget UxThis, Environment * pEnv, char *string )
{
	int			_Uxrtrn;
	_UxCsetupDialog         *UxSaveCtx = UxSetupDialogContext;

	UxSetupDialogContext = (_UxCsetupDialog *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_put( UxThis, pEnv, string );
	UxSetupDialogContext = UxSaveCtx;

	return ( _Uxrtrn );
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  mapCB_setupDialog(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCsetupDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxSetupDialogContext;
	UxSetupDialogContext = UxContext =
			(_UxCsetupDialog *) UxGetContext( UxWidget );
	{
	
	}
	UxSetupDialogContext = UxSaveCtx;
}

static void  createCB_form3(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCsetupDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxSetupDialogContext;
	UxContext = UxSetupDialogContext;
	{
	
	}
	UxSetupDialogContext = UxSaveCtx;
}

static void  activateCB_pushButton_plot(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCsetupDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxSetupDialogContext;
	UxSetupDialogContext = UxContext =
			(_UxCsetupDialog *) UxGetContext( UxWidget );
	{
	setupDialog_reinit (setupDialog, &UxEnv);
	command ("plot\n");
	}
	UxSetupDialogContext = UxSaveCtx;
}

static void  activateCB_pushButton_step(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCsetupDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxSetupDialogContext;
	UxSetupDialogContext = UxContext =
			(_UxCsetupDialog *) UxGetContext( UxWidget );
	{
	setupDialog_reinit (setupDialog, &UxEnv);
	command ("step\n");
	SetBusyPointer (TRUE);
	command ("print\n");
	}
	UxSetupDialogContext = UxSaveCtx;
}

static void  activateCB_pushButton_run(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCsetupDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxSetupDialogContext;
	UxSetupDialogContext = UxContext =
			(_UxCsetupDialog *) UxGetContext( UxWidget );
	{
	setupDialog_reinit (setupDialog, &UxEnv);
	command ("run\n");
	setupDialog_sensitive (setupDialog, &UxEnv, FALSE);
	SetBusyPointer (TRUE);
	/* UxPopdownInterface (setupDialog); */
	}
	UxSetupDialogContext = UxSaveCtx;
}

static void  valueChangedCB_stepText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCsetupDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxSetupDialogContext;
	UxSetupDialogContext = UxContext =
			(_UxCsetupDialog *) UxGetContext( UxWidget );
	{
	stepitsChanged = True;
	}
	UxSetupDialogContext = UxSaveCtx;
}

static void  valueChangedCB_runmaxText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCsetupDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxSetupDialogContext;
	UxSetupDialogContext = UxContext =
			(_UxCsetupDialog *) UxGetContext( UxWidget );
	{
	maxitsChanged = True;
	}
	UxSetupDialogContext = UxSaveCtx;
}

static void  valueChangedCB_chitestText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCsetupDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxSetupDialogContext;
	UxSetupDialogContext = UxContext =
			(_UxCsetupDialog *) UxGetContext( UxWidget );
	{
	chitestChanged = True;
	}
	UxSetupDialogContext = UxSaveCtx;
}

static void  valueChangedCB_autowarnText(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCsetupDialog         *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxSetupDialogContext;
	UxSetupDialogContext = UxContext =
			(_UxCsetupDialog *) UxGetContext( UxWidget );
	{
	autowarnChanged = True;
	}
	UxSetupDialogContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_setupDialog()
{
	Widget		_UxParent;


	/* Creation of setupDialog */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "setupDialog_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 277,
			XmNy, 222,
			XmNwidth, 640,
			XmNheight, 300,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "setupDialog",
			NULL );

	setupDialog = XtVaCreateWidget( "setupDialog",
			xmFormWidgetClass,
			_UxParent,
			XmNwidth, 640,
			XmNheight, 300,
			XmNunitType, XmPIXELS,
			RES_CONVERT( XmNdialogTitle, "Setup form" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			XmNlabelFontList, UxConvertFontList("8x13bold" ),
			XmNtextFontList, UxConvertFontList("8x13bold" ),
			XmNbuttonFontList, UxConvertFontList("8x13bold" ),
			XmNautoUnmanage, FALSE,
			NULL );
	XtAddCallback( setupDialog, XmNmapCallback,
		(XtCallbackProc) mapCB_setupDialog,
		(XtPointer) UxSetupDialogContext );

	UxPutContext( setupDialog, (char *) UxSetupDialogContext );
	UxPutClassCode( setupDialog, _UxIfClassId );


	/* Creation of scrolledWindow2 */
	scrolledWindow2 = XtVaCreateManagedWidget( "scrolledWindow2",
			xmScrolledWindowWidgetClass,
			setupDialog,
			XmNscrollingPolicy, XmAUTOMATIC,
			XmNwidth, 650,
			XmNheight, 390,
			XmNx, 0,
			XmNy, 40,
			XmNleftAttachment, XmATTACH_FORM,
			XmNrightAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNbottomAttachment, XmATTACH_FORM,
			XmNbottomOffset, 60,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrolledWindowMarginHeight, 5,
			XmNscrolledWindowMarginWidth, 5,
			XmNtopOffset, 40,
			NULL );
	UxPutContext( scrolledWindow2, (char *) UxSetupDialogContext );


	/* Creation of form3 */
	form3 = XtVaCreateManagedWidget( "form3",
			xmFormWidgetClass,
			scrolledWindow2,
			XmNresizePolicy, XmRESIZE_NONE,
			XmNwidth, 630,
			XmNheight, 400,
			NULL );
	UxPutContext( form3, (char *) UxSetupDialogContext );

	createCB_form3( form3,
			(XtPointer) UxSetupDialogContext, (XtPointer) NULL );


	/* Creation of pushButton_plot */
	pushButton_plot = XtVaCreateManagedWidget( "pushButton_plot",
			xmPushButtonWidgetClass,
			setupDialog,
			XmNx, 50,
			XmNy, 420,
			XmNwidth, 90,
			XmNheight, 40,
			XmNbottomAttachment, XmATTACH_FORM,
			XmNleftAttachment, XmATTACH_FORM,
			XmNbottomOffset, 6,
			XmNleftOffset, 50,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			RES_CONVERT( XmNlabelString, "PLOT" ),
			RES_CONVERT( XmNbackground, "rosybrown" ),
			NULL );
	XtAddCallback( pushButton_plot, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton_plot,
		(XtPointer) UxSetupDialogContext );

	UxPutContext( pushButton_plot, (char *) UxSetupDialogContext );


	/* Creation of pushButton_step */
	pushButton_step = XtVaCreateManagedWidget( "pushButton_step",
			xmPushButtonWidgetClass,
			setupDialog,
			XmNx, 274,
			XmNy, 254,
			XmNwidth, 90,
			XmNheight, 40,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			RES_CONVERT( XmNlabelString, "STEP" ),
			RES_CONVERT( XmNbackground, "rosybrown" ),
			XmNbottomAttachment, XmATTACH_FORM,
			XmNbottomOffset, 6,
			NULL );
	XtAddCallback( pushButton_step, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton_step,
		(XtPointer) UxSetupDialogContext );

	UxPutContext( pushButton_step, (char *) UxSetupDialogContext );


	/* Creation of pushButton_run */
	pushButton_run = XtVaCreateManagedWidget( "pushButton_run",
			xmPushButtonWidgetClass,
			setupDialog,
			XmNx, 508,
			XmNy, 255,
			XmNwidth, 90,
			XmNheight, 40,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNforeground, "white" ),
			RES_CONVERT( XmNhighlightColor, "white" ),
			RES_CONVERT( XmNlabelString, "RUN" ),
			RES_CONVERT( XmNbackground, "rosybrown" ),
			XmNbottomAttachment, XmATTACH_FORM,
			XmNbottomOffset, 6,
			NULL );
	XtAddCallback( pushButton_run, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton_run,
		(XtPointer) UxSetupDialogContext );

	UxPutContext( pushButton_run, (char *) UxSetupDialogContext );


	/* Creation of separator1 */
	separator1 = XtVaCreateManagedWidget( "separator1",
			xmSeparatorWidgetClass,
			setupDialog,
			XmNwidth, 660,
			XmNheight, 10,
			XmNx, 0,
			XmNy, 450,
			XmNleftAttachment, XmATTACH_FORM,
			XmNrightAttachment, XmATTACH_FORM,
			XmNbottomAttachment, XmATTACH_FORM,
			XmNbottomOffset, 50,
			NULL );
	UxPutContext( separator1, (char *) UxSetupDialogContext );


	/* Creation of stepLabel */
	stepLabel = XtVaCreateManagedWidget( "stepLabel",
			xmLabelWidgetClass,
			setupDialog,
			XmNwidth, 80,
			XmNheight, 30,
			XmNleftOffset, 10,
			XmNtopOffset, 10,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Step its.:" ),
			NULL );
	UxPutContext( stepLabel, (char *) UxSetupDialogContext );


	/* Creation of stepText */
	stepText = XtVaCreateManagedWidget( "stepText",
			xmTextFieldWidgetClass,
			setupDialog,
			XmNwidth, 60,
			XmNheight, 30,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 100,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			XmNfontList, UxConvertFontList("8x13" ),
			XmNvalue, "   1",
			XmNcolumns, 4,
			NULL );
	XtAddCallback( stepText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_stepText,
		(XtPointer) UxSetupDialogContext );

	UxPutContext( stepText, (char *) UxSetupDialogContext );


	/* Creation of runmaxLabel */
	runmaxLabel = XtVaCreateManagedWidget( "runmaxLabel",
			xmLabelWidgetClass,
			setupDialog,
			XmNwidth, 80,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "+Max its.:" ),
			XmNx, 160,
			XmNy, 10,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 165,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			NULL );
	UxPutContext( runmaxLabel, (char *) UxSetupDialogContext );


	/* Creation of runmaxText */
	runmaxText = XtVaCreateManagedWidget( "runmaxText",
			xmTextFieldWidgetClass,
			setupDialog,
			XmNwidth, 60,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13" ),
			XmNvalue, "  50",
			XmNcolumns, 4,
			XmNx, 249,
			XmNy, 10,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 245,
			NULL );
	XtAddCallback( runmaxText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_runmaxText,
		(XtPointer) UxSetupDialogContext );

	UxPutContext( runmaxText, (char *) UxSetupDialogContext );


	/* Creation of chitestLabel */
	chitestLabel = XtVaCreateManagedWidget( "chitestLabel",
			xmLabelWidgetClass,
			setupDialog,
			XmNwidth, 80,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Chi-test:" ),
			XmNx, 302,
			XmNy, 12,
			XmNleftOffset, 330,
			XmNleftAttachment, XmATTACH_FORM,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			NULL );
	UxPutContext( chitestLabel, (char *) UxSetupDialogContext );


	/* Creation of chitestText */
	chitestText = XtVaCreateManagedWidget( "chitestText",
			xmTextFieldWidgetClass,
			setupDialog,
			XmNwidth, 60,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13" ),
			XmNvalue, " 0.1",
			XmNcolumns, 4,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 410,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			NULL );
	XtAddCallback( chitestText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_chitestText,
		(XtPointer) UxSetupDialogContext );

	UxPutContext( chitestText, (char *) UxSetupDialogContext );


	/* Creation of autowarnLabel */
	autowarnLabel = XtVaCreateManagedWidget( "autowarnLabel",
			xmLabelWidgetClass,
			setupDialog,
			XmNwidth, 80,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13bold" ),
			RES_CONVERT( XmNlabelString, "Auto-warn:" ),
			XmNx, 441,
			XmNy, 9,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 480,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			NULL );
	UxPutContext( autowarnLabel, (char *) UxSetupDialogContext );


	/* Creation of autowarnText */
	autowarnText = XtVaCreateManagedWidget( "autowarnText",
			xmTextFieldWidgetClass,
			setupDialog,
			XmNwidth, 60,
			XmNheight, 30,
			XmNfontList, UxConvertFontList("8x13" ),
			XmNvalue, "10.0",
			XmNcolumns, 4,
			XmNx, 529,
			XmNy, 8,
			XmNleftAttachment, XmATTACH_FORM,
			XmNleftOffset, 565,
			XmNtopAttachment, XmATTACH_FORM,
			XmNtopOffset, 10,
			NULL );
	XtAddCallback( autowarnText, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_autowarnText,
		(XtPointer) UxSetupDialogContext );

	UxPutContext( autowarnText, (char *) UxSetupDialogContext );


	XtAddCallback( setupDialog, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxSetupDialogContext);


	return ( setupDialog );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_setupDialog( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCsetupDialog         *UxContext;
	static int		_Uxinit = 0;

	UxSetupDialogContext = UxContext =
		(_UxCsetupDialog *) UxNewContext( sizeof(_UxCsetupDialog), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxsetupDialog_setParRC_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_setParRC_Name,
				(void (*)()) _setupDialog_setParRC );
		UxsetupDialog_sensitive_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_sensitive_Name,
				(void (*)()) _setupDialog_sensitive );
		UxsetupDialog_getLimitsN_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_getLimitsN_Name,
				(void (*)()) _setupDialog_getLimitsN );
		UxsetupDialog_setLimitsN_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_setLimitsN_Name,
				(void (*)()) _setupDialog_setLimitsN );
		UxsetupDialog_quit_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_quit_Name,
				(void (*)()) _setupDialog_quit );
		UxsetupDialog_reinit_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_reinit_Name,
				(void (*)()) _setupDialog_reinit );
		UxsetupDialog_checkValN_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_checkValN_Name,
				(void (*)()) _setupDialog_checkValN );
		UxsetupDialog_getTieN_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_getTieN_Name,
				(void (*)()) _setupDialog_getTieN );
		UxsetupDialog_getDescrN_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_getDescrN_Name,
				(void (*)()) _setupDialog_getDescrN );
		UxsetupDialog_setTieN_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_setTieN_Name,
				(void (*)()) _setupDialog_setTieN );
		UxsetupDialog_getStateN_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_getStateN_Name,
				(void (*)()) _setupDialog_getStateN );
		UxsetupDialog_setStateN_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_setStateN_Name,
				(void (*)()) _setupDialog_setStateN );
		UxsetupDialog_set_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_set_Name,
				(void (*)()) _setupDialog_set );
		UxsetupDialog_put_Id = UxMethodRegister( _UxIfClassId,
				UxsetupDialog_put_Name,
				(void (*)()) _setupDialog_put );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_setupDialog();

	tieD = create_tieDialog (rtrn);
	limitD = create_limitDialog (rtrn);
	npar = 0;
	npeak = 0;
	fexp = 0;
	current_y = 0;
	stepitsChanged = maxitsChanged = chitestChanged = autowarnChanged = False;
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

