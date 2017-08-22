
/*******************************************************************************
	BackCsymParams.c

       Associated Header file: BackCsymParams.h
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
#include <Xm/Text.h>
#include <Xm/ScrolledW.h>
#include <Xm/Separator.h>
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/BulletinB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>
#include <math.h>
#include <string.h>

#ifndef DESIGN_TIME
#include "ErrorMessage.h"
#include "mainWS.h"
#include "FileSelection.h"
#include "headerDialog.h"
#endif

extern void command(char*,...);
extern swidget ErrMessage;
extern swidget FileSelect;
extern swidget header;
extern swidget mainWS;


static	int _UxIfClassId;
int	UxBackCsymParams_getParams_Id = -1;
char*	UxBackCsymParams_getParams_Name = "getParams";
int	UxBackCsymParams_setCentre_Id = -1;
char*	UxBackCsymParams_setCentre_Name = "setCentre";
int	UxBackCsymParams_setSize_Id = -1;
char*	UxBackCsymParams_setSize_Name = "setSize";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "BackCsymParams.h"
#undef CONTEXT_MACRO_ACCESS

Widget	outfileField2;

/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_BackCsymParams_getParams( swidget UxThis, Environment * pEnv, char *error );
static void	_BackCsymParams_setCentre( swidget UxThis, Environment * pEnv, double xcen, double ycen );
static void	_BackCsymParams_setSize( swidget UxThis, Environment * pEnv, int np, int nr );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_getParams( swidget UxThis, Environment * pEnv, char *error )
{
	extern char *stripws(char*);
	char *strptr,*sptr;
	int i,iflag;
	char* pptr;
	
	strcpy(error,"");
	
	/***** Check X-coord of centre *******************************************/
	
	strptr=XmTextFieldGetString(xcentreField2);
	sptr=stripws(strptr);
	
	xcentre=atof(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"X-coordinate of centre not specified");
	  XtFree(strptr);
	  return 0;
	}
	
	iflag=0;
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Invalid X-coordinate for centre");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid X-coordinate for centre");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	XtFree(strptr);
	
	/***** Check Y-coord of centre *******************************************/
	
	strptr=XmTextFieldGetString(ycentreField2);
	sptr=stripws(strptr);
	
	ycentre=atof(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Y-coordinate of centre not specified");
	  XtFree(strptr);
	  return 0;
	}
	
	iflag=0;
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Invalid Y-coordinate for centre");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid Y-coordinate for centre");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	XtFree(strptr);
	
	/***** Check Rmin ********************************************************/
	
	strptr=XmTextFieldGetString(rminField2);
	sptr=stripws(strptr);
	
	dmin=atof(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Minimum radius not specified");
	  XtFree(strptr);
	  return 0;
	}
	
	iflag=0;
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Invalid minimum radius");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid minimum radius");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	if(dmin<0.)
	{
	  strcpy(error,"Invalid minimum radius");
	  XtFree(strptr);
	  return 0;
	}
	
	XtFree(strptr);
	
	/***** Check Rmax ********************************************************/
	
	strptr=XmTextFieldGetString(rmaxField2);
	sptr=stripws(strptr);
	
	dmax=atof(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Maximum radius not specified");
	  XtFree(strptr);
	  return 0;
	}
	
	iflag=0;
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Invalid maximum radius");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid maximum radius");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	if(dmax<=dmin)
	{
	  strcpy(error,"Invalid maximum radius");
	  XtFree(strptr);
	  return 0;
	}
	
	XtFree(strptr);
	
	/***** Check lowest value ***************************************************/
	
	strptr=XmTextFieldGetString(lowvalField2);
	sptr=stripws(strptr);
	
	lowval=atof(sptr);
	
	if(strlen(sptr)==0)
	{
	  lowval=0.;
	}
	
	iflag=0;
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Pixel value to discard is invalid");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Pixel value to discard is invalid");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	XtFree(strptr);
	
	/***** Check binning increment ***************************************/
	
	strptr=XmTextFieldGetString(incField);
	sptr=stripws(strptr);
	
	dinc=atof(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Binning increment not specified");
	  XtFree(strptr);
	  return 0;
	}
	
	iflag=0;
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Invalid binning increment");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid binning increment");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	if(dinc<=0.)
	{
	    strcpy(error,"Invalid binning increment");
	    XtFree(strptr);
	    return 0;
	}
	
	XtFree(strptr);
	
	/***** Check pixel range 1 ***********************************************/
	
	strptr=XmTextFieldGetString(lpixField2);
	sptr=stripws(strptr);
	
	lpix=atof(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Pixel range not fully specified");
	  XtFree(strptr);
	  return 0;
	}
	
	if(lpix<0||lpix>100)
	{
	    strcpy(error,"Invalid pixel range");
	    XtFree(strptr);
	    return 0;
	}
	
	iflag=0;
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Invalid pixel range");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid pixel range");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	XtFree(strptr);
	
	/***** Check pixel range 2 ***********************************************/
	
	strptr=XmTextFieldGetString(hpixField2);
	sptr=stripws(strptr);
	
	hpix=atof(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Pixel range not fully specified");
	  XtFree(strptr);
	  return 0;
	}
	
	if(hpix<0||hpix>100||hpix==lpix)
	{
	    strcpy(error,"Invalid pixel range");
	    XtFree(strptr);
	    return 0;
	}
	
	iflag=0;
	
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Invalid pixel range");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid pixel range");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	XtFree(strptr);
	
	if(hpix<lpix)
	{
	  i=lpix;
	  lpix=hpix;
	  hpix=i;
	}
	
	/***** Check smoothing factor ********************************************/
	
	strptr=XmTextFieldGetString(smoothField2);
	sptr=stripws(strptr);
	
	smoo=atof(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Smoothing factor not specified");
	  XtFree(strptr);
	  return 0;
	}
	
	if(smoo<0.)
	{
	  strcpy(error,"Invalid smoothing factor");
	  XtFree(strptr);
	  return 0;
	}
	
	iflag=0;
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Invalid smoothing factor");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid smoothing factor");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	XtFree(strptr);
	
	/***** Check tension factor **********************************************/
	
	strptr=XmTextFieldGetString(tensionField2);
	sptr=stripws(strptr);
	
	tens=atof(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Tension factor not specified");
	  XtFree(strptr);
	  return 0;
	}
	
	if(tens<0.)
	{
	  strcpy(error,"Invalid tension factor");
	  XtFree(strptr);
	  return 0;
	}
	
	iflag=0;
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Invalid tension factor");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid tension factor");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	XtFree(strptr);
	
	/***** Check output BSL filename *****************************************/
	
	strptr=XmTextGetString(outfileField2);
	sptr=stripws(strptr);
	
	if(!mainWS_CheckOutFile(mainWS,&UxEnv,sptr,error,1))
	{
	  XtFree(strptr);
	  return 0;
	}
	
	/***** Convert characters in output filename to uppercase ****************/
	
	if((pptr=strrchr(sptr,(int)'/'))==NULL)
	  pptr=sptr;
	else
	  pptr++;
	
	for(i=0;i<=strlen(pptr);i++)
	{
	  if(islower((int)pptr[i]))
	  pptr[i]=toupper((int)pptr[i]);
	}
	
	sOutFile=(char*)strdup(sptr);
	XtFree(strptr);
	
	/*************************************************************************/
	
	return 1;
}

static int	_BackCsymParams_getParams( swidget UxThis, Environment * pEnv, char *error )
{
	int			_Uxrtrn;
	_UxCBackCsymParams      *UxSaveCtx = UxBackCsymParamsContext;

	UxBackCsymParamsContext = (_UxCBackCsymParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getParams( UxThis, pEnv, error );
	UxBackCsymParamsContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_setCentre( swidget UxThis, Environment * pEnv, double xcen, double ycen )
{
	char *xc,*yc;
	
	xcentre=xcen;
	ycentre=ycen;
	
	xc=(char*)malloc(80*sizeof(char));
	yc=(char*)malloc(80*sizeof(char));
	
	sprintf(xc,"%.2f",xcen);
	sprintf(yc,"%.2f",ycen);
	
	XtVaSetValues(xcentreField2,XmNvalue,xc,NULL);
	XtVaSetValues(ycentreField2,XmNvalue,yc,NULL);
	
	free(xc);
	free(yc);
}

static void	_BackCsymParams_setCentre( swidget UxThis, Environment * pEnv, double xcen, double ycen )
{
	_UxCBackCsymParams      *UxSaveCtx = UxBackCsymParamsContext;

	UxBackCsymParamsContext = (_UxCBackCsymParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setCentre( UxThis, pEnv, xcen, ycen );
	UxBackCsymParamsContext = UxSaveCtx;
}

static void	Ux_setSize( swidget UxThis, Environment * pEnv, int np, int nr )
{
	npix=np;
	nrast=nr;
}

static void	_BackCsymParams_setSize( swidget UxThis, Environment * pEnv, int np, int nr )
{
	_UxCBackCsymParams      *UxSaveCtx = UxBackCsymParamsContext;

	UxBackCsymParamsContext = (_UxCBackCsymParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setSize( UxThis, pEnv, np, nr );
	UxBackCsymParamsContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  activateCB_pushButton5(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackCsymParams      *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackCsymParamsContext;
	UxBackCsymParamsContext = UxContext =
			(_UxCBackCsymParams *) UxGetContext( UxWidget );
	{
	FileSelection_set(FileSelect,&UxEnv,&outfileField2,"*000.*","Output file selection",0,1,0,0,1);
	UxPopupInterface(FileSelect,no_grab);
	}
	UxBackCsymParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton6(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackCsymParams      *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackCsymParamsContext;
	UxBackCsymParamsContext = UxContext =
			(_UxCBackCsymParams *) UxGetContext( UxWidget );
	{
	headerDialog_popup(header,&UxEnv,sOutFile);
	}
	UxBackCsymParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton7(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackCsymParams      *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackCsymParamsContext;
	UxBackCsymParamsContext = UxContext =
			(_UxCBackCsymParams *) UxGetContext( UxWidget );
	{
	char error[80];
	
	if(BackCsymParams_getParams(UxThisWidget,&UxEnv,error))
	{
	  mainWS_setBackOutFile(mainWS,&UxEnv,sOutFile);
	
	  command("back csym %f %f %f %f %f %f %f %f %f %f\n",
	           dmin,dmax,lpix,hpix,dinc,smoo,tens,xcentre,ycentre,lowval);
	
	  UxPopdownInterface(UxThisWidget);
	}
	else
	{
	  ErrorMessage_set(ErrMessage,&UxEnv,error);
	  UxPopupInterface(ErrMessage,no_grab);
	}
	}
	UxBackCsymParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton8(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackCsymParams      *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackCsymParamsContext;
	UxBackCsymParamsContext = UxContext =
			(_UxCBackCsymParams *) UxGetContext( UxWidget );
	{
	UxPopdownInterface(UxThisWidget);
	}
	UxBackCsymParamsContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_BackCsymParams()
{
	Widget		_UxParent;


	/* Creation of BackCsymParams */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "BackCsymParams_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 580,
			XmNy, 170,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "BackCsymParams",
			NULL );

	BackCsymParams = XtVaCreateWidget( "BackCsymParams",
			xmBulletinBoardWidgetClass,
			_UxParent,
			XmNunitType, XmPIXELS,
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			RES_CONVERT( XmNdialogTitle, "Circularly symmetric background" ),
			XmNautoUnmanage, FALSE,
			NULL );
	UxPutContext( BackCsymParams, (char *) UxBackCsymParamsContext );
	UxPutClassCode( BackCsymParams, _UxIfClassId );


	/* Creation of label22 */
	label22 = XtVaCreateManagedWidget( "label22",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 13,
			XmNy, 248,
			RES_CONVERT( XmNlabelString, "Pixel range:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label22, (char *) UxBackCsymParamsContext );


	/* Creation of lpixField2 */
	lpixField2 = XtVaCreateManagedWidget( "lpixField2",
			xmTextFieldWidgetClass,
			BackCsymParams,
			XmNx, 214,
			XmNy, 243,
			XmNvalue, "0",
			XmNmaxLength, 3,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( lpixField2, (char *) UxBackCsymParamsContext );


	/* Creation of label23 */
	label23 = XtVaCreateManagedWidget( "label23",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 265,
			XmNy, 247,
			RES_CONVERT( XmNlabelString, "%" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label23, (char *) UxBackCsymParamsContext );


	/* Creation of hpixField2 */
	hpixField2 = XtVaCreateManagedWidget( "hpixField2",
			xmTextFieldWidgetClass,
			BackCsymParams,
			XmNx, 285,
			XmNy, 243,
			XmNwidth, 50,
			XmNvalue, "25",
			XmNmaxLength, 3,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( hpixField2, (char *) UxBackCsymParamsContext );


	/* Creation of label24 */
	label24 = XtVaCreateManagedWidget( "label24",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 336,
			XmNy, 247,
			RES_CONVERT( XmNlabelString, "%" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label24, (char *) UxBackCsymParamsContext );


	/* Creation of label25 */
	label25 = XtVaCreateManagedWidget( "label25",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 13,
			XmNy, 320,
			RES_CONVERT( XmNlabelString, "Smoothing factor:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label25, (char *) UxBackCsymParamsContext );


	/* Creation of smoothField2 */
	smoothField2 = XtVaCreateManagedWidget( "smoothField2",
			xmTextFieldWidgetClass,
			BackCsymParams,
			XmNx, 214,
			XmNy, 314,
			XmNwidth, 50,
			XmNvalue, "1.0",
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( smoothField2, (char *) UxBackCsymParamsContext );


	/* Creation of label26 */
	label26 = XtVaCreateManagedWidget( "label26",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 13,
			XmNy, 361,
			RES_CONVERT( XmNlabelString, "Tension factor:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label26, (char *) UxBackCsymParamsContext );


	/* Creation of tensionField2 */
	tensionField2 = XtVaCreateManagedWidget( "tensionField2",
			xmTextFieldWidgetClass,
			BackCsymParams,
			XmNx, 214,
			XmNy, 356,
			XmNwidth, 50,
			XmNvalue, "1.0",
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( tensionField2, (char *) UxBackCsymParamsContext );


	/* Creation of label27 */
	label27 = XtVaCreateManagedWidget( "label27",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 13,
			XmNy, 205,
			RES_CONVERT( XmNlabelString, "Binning increment:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label27, (char *) UxBackCsymParamsContext );


	/* Creation of incField */
	incField = XtVaCreateManagedWidget( "incField",
			xmTextFieldWidgetClass,
			BackCsymParams,
			XmNx, 214,
			XmNy, 201,
			XmNwidth, 50,
			XmNvalue, "1.0",
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( incField, (char *) UxBackCsymParamsContext );


	/* Creation of label16 */
	label16 = XtVaCreateManagedWidget( "label16",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 13,
			XmNy, 89,
			RES_CONVERT( XmNlabelString, "Pattern limits :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label16, (char *) UxBackCsymParamsContext );


	/* Creation of rmaxField2 */
	rmaxField2 = XtVaCreateManagedWidget( "rmaxField2",
			xmTextFieldWidgetClass,
			BackCsymParams,
			XmNx, 266,
			XmNy, 84,
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( rmaxField2, (char *) UxBackCsymParamsContext );


	/* Creation of label17 */
	label17 = XtVaCreateManagedWidget( "label17",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 282,
			XmNy, 64,
			RES_CONVERT( XmNlabelString, "R max" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label17, (char *) UxBackCsymParamsContext );


	/* Creation of label18 */
	label18 = XtVaCreateManagedWidget( "label18",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 13,
			XmNy, 34,
			RES_CONVERT( XmNlabelString, "Centre :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label18, (char *) UxBackCsymParamsContext );


	/* Creation of label19 */
	label19 = XtVaCreateManagedWidget( "label19",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 186,
			XmNy, 64,
			RES_CONVERT( XmNlabelString, "R min" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label19, (char *) UxBackCsymParamsContext );


	/* Creation of rminField2 */
	rminField2 = XtVaCreateManagedWidget( "rminField2",
			xmTextFieldWidgetClass,
			BackCsymParams,
			XmNx, 170,
			XmNy, 84,
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( rminField2, (char *) UxBackCsymParamsContext );


	/* Creation of xcentreField2 */
	xcentreField2 = XtVaCreateManagedWidget( "xcentreField2",
			xmTextFieldWidgetClass,
			BackCsymParams,
			XmNx, 170,
			XmNy, 29,
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( xcentreField2, (char *) UxBackCsymParamsContext );


	/* Creation of label20 */
	label20 = XtVaCreateManagedWidget( "label20",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 204,
			XmNy, 9,
			RES_CONVERT( XmNlabelString, "X" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label20, (char *) UxBackCsymParamsContext );


	/* Creation of ycentreField2 */
	ycentreField2 = XtVaCreateManagedWidget( "ycentreField2",
			xmTextFieldWidgetClass,
			BackCsymParams,
			XmNx, 266,
			XmNy, 29,
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( ycentreField2, (char *) UxBackCsymParamsContext );


	/* Creation of label21 */
	label21 = XtVaCreateManagedWidget( "label21",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 300,
			XmNy, 10,
			RES_CONVERT( XmNlabelString, "Y" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label21, (char *) UxBackCsymParamsContext );


	/* Creation of separator4 */
	separator4 = XtVaCreateManagedWidget( "separator4",
			xmSeparatorWidgetClass,
			BackCsymParams,
			XmNwidth, 339,
			XmNheight, 12,
			XmNx, 11,
			XmNy, 175,
			NULL );
	UxPutContext( separator4, (char *) UxBackCsymParamsContext );


	/* Creation of label1 */
	label1 = XtVaCreateManagedWidget( "label1",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 13,
			XmNy, 426,
			RES_CONVERT( XmNlabelString, "Output filename:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label1, (char *) UxBackCsymParamsContext );


	/* Creation of scrolledWindowText1 */
	scrolledWindowText1 = XtVaCreateManagedWidget( "scrolledWindowText1",
			xmScrolledWindowWidgetClass,
			BackCsymParams,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNx, 163,
			XmNy, 422,
			NULL );
	UxPutContext( scrolledWindowText1, (char *) UxBackCsymParamsContext );


	/* Creation of outfileField2 */
	outfileField2 = XtVaCreateManagedWidget( "outfileField2",
			xmTextWidgetClass,
			scrolledWindowText1,
			XmNwidth, 110,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( outfileField2, (char *) UxBackCsymParamsContext );


	/* Creation of pushButton5 */
	pushButton5 = XtVaCreateManagedWidget( "pushButton5",
			xmPushButtonWidgetClass,
			BackCsymParams,
			XmNx, 278,
			XmNy, 421,
			RES_CONVERT( XmNlabelString, "Browse" ),
			XmNmarginWidth, 5,
			XmNmarginHeight, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton5, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton5,
		(XtPointer) UxBackCsymParamsContext );

	UxPutContext( pushButton5, (char *) UxBackCsymParamsContext );


	/* Creation of pushButton6 */
	pushButton6 = XtVaCreateManagedWidget( "pushButton6",
			xmPushButtonWidgetClass,
			BackCsymParams,
			XmNx, 13,
			XmNy, 482,
			RES_CONVERT( XmNlabelString, "Write headers" ),
			XmNmarginWidth, 5,
			XmNmarginHeight, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton6, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton6,
		(XtPointer) UxBackCsymParamsContext );

	UxPutContext( pushButton6, (char *) UxBackCsymParamsContext );


	/* Creation of pushButton7 */
	pushButton7 = XtVaCreateManagedWidget( "pushButton7",
			xmPushButtonWidgetClass,
			BackCsymParams,
			XmNx, 13,
			XmNy, 558,
			XmNwidth, 91,
			XmNheight, 33,
			RES_CONVERT( XmNlabelString, "Run" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton7, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton7,
		(XtPointer) UxBackCsymParamsContext );

	UxPutContext( pushButton7, (char *) UxBackCsymParamsContext );


	/* Creation of pushButton8 */
	pushButton8 = XtVaCreateManagedWidget( "pushButton8",
			xmPushButtonWidgetClass,
			BackCsymParams,
			XmNx, 255,
			XmNy, 557,
			XmNwidth, 91,
			XmNheight, 33,
			RES_CONVERT( XmNlabelString, "Cancel" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton8, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton8,
		(XtPointer) UxBackCsymParamsContext );

	UxPutContext( pushButton8, (char *) UxBackCsymParamsContext );


	/* Creation of label2 */
	label2 = XtVaCreateManagedWidget( "label2",
			xmLabelWidgetClass,
			BackCsymParams,
			XmNx, 13,
			XmNy, 139,
			RES_CONVERT( XmNlabelString, "Discard values less than :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label2, (char *) UxBackCsymParamsContext );


	/* Creation of lowvalField2 */
	lowvalField2 = XtVaCreateManagedWidget( "lowvalField2",
			xmTextFieldWidgetClass,
			BackCsymParams,
			XmNx, 266,
			XmNy, 134,
			XmNwidth, 80,
			XmNvalue, "0.0",
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( lowvalField2, (char *) UxBackCsymParamsContext );


	/* Creation of separator5 */
	separator5 = XtVaCreateManagedWidget( "separator5",
			xmSeparatorWidgetClass,
			BackCsymParams,
			XmNwidth, 339,
			XmNheight, 12,
			XmNx, 11,
			XmNy, 289,
			NULL );
	UxPutContext( separator5, (char *) UxBackCsymParamsContext );


	/* Creation of separator6 */
	separator6 = XtVaCreateManagedWidget( "separator6",
			xmSeparatorWidgetClass,
			BackCsymParams,
			XmNwidth, 339,
			XmNheight, 12,
			XmNx, 11,
			XmNy, 395,
			NULL );
	UxPutContext( separator6, (char *) UxBackCsymParamsContext );


	/* Creation of separator7 */
	separator7 = XtVaCreateManagedWidget( "separator7",
			xmSeparatorWidgetClass,
			BackCsymParams,
			XmNwidth, 339,
			XmNheight, 12,
			XmNx, 11,
			XmNy, 527,
			NULL );
	UxPutContext( separator7, (char *) UxBackCsymParamsContext );


	XtAddCallback( BackCsymParams, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxBackCsymParamsContext);


	return ( BackCsymParams );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_BackCsymParams( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCBackCsymParams      *UxContext;
	static int		_Uxinit = 0;

	UxBackCsymParamsContext = UxContext =
		(_UxCBackCsymParams *) UxNewContext( sizeof(_UxCBackCsymParams), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxBackCsymParams_getParams_Id = UxMethodRegister( _UxIfClassId,
				UxBackCsymParams_getParams_Name,
				(void (*)()) _BackCsymParams_getParams );
		UxBackCsymParams_setCentre_Id = UxMethodRegister( _UxIfClassId,
				UxBackCsymParams_setCentre_Name,
				(void (*)()) _BackCsymParams_setCentre );
		UxBackCsymParams_setSize_Id = UxMethodRegister( _UxIfClassId,
				UxBackCsymParams_setSize_Name,
				(void (*)()) _BackCsymParams_setSize );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_BackCsymParams();

	sOutFile="";
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

