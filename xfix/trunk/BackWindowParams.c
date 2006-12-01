
/*******************************************************************************
	BackWindowParams.c

       Associated Header file: BackWindowParams.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/Text.h>
#include <Xm/ScrolledW.h>
#include <Xm/Separator.h>
#include <Xm/PushB.h>
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/BulletinB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#ifndef DESIGN_TIME
#include "ErrorMessage.h"
#include "mainWS.h"
#include "FileSelection.h"
#include "headerDialog.h"
#endif

extern void command(char *, ...);
extern swidget ErrMessage;
extern swidget mainWS;
extern swidget FileSelect;
extern swidget header;


static	int _UxIfClassId;
int	UxBackWindowParams_getParams_Id = -1;
char*	UxBackWindowParams_getParams_Name = "getParams";
int	UxBackWindowParams_setCentre_Id = -1;
char*	UxBackWindowParams_setCentre_Name = "setCentre";
int	UxBackWindowParams_setSize_Id = -1;
char*	UxBackWindowParams_setSize_Name = "setSize";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "BackWindowParams.h"
#undef CONTEXT_MACRO_ACCESS

Widget	outfileField1;

/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_BackWindowParams_getParams( swidget UxThis, Environment * pEnv, char *error );
static void	_BackWindowParams_setCentre( swidget UxThis, Environment * pEnv, double xcen, double ycen );
static void	_BackWindowParams_setSize( swidget UxThis, Environment * pEnv, int np, int nr );

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
	
	strptr=XmTextFieldGetString(xcentreField1);
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
	
	strptr=XmTextFieldGetString(ycentreField1);
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
	
	strptr=XmTextFieldGetString(rminField1);
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
	
	strptr=XmTextFieldGetString(rmaxField1);
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
	
	strptr=XmTextFieldGetString(lowvalField1);
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
	
	/***** Check window width ************************************************/
	
	strptr=XmTextFieldGetString(xwinField);
	sptr=stripws(strptr);
	
	iwid=atoi(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Window size in X not specified");
	  XtFree(strptr);
	  return 0;
	}
	
	if(iwid<=0)
	{
	  strcpy(error,"Invalid window size in X");
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
	    strcpy(error,"Invalid window size in X");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid window size in X");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	XtFree(strptr);
	
	/***** Check window height ***********************************************/
	
	strptr=XmTextFieldGetString(ywinField);
	sptr=stripws(strptr);
	
	jwid=atoi(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Window size in Y not specified");
	  XtFree(strptr);
	  return 0;
	}
	
	if(jwid<=0)
	{
	  strcpy(error,"Invalid window size in Y");
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
	    strcpy(error,"Invalid window size in Y");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid window size in Y");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	XtFree(strptr);
	
	if((iwid*2+1)*(jwid*2+1)>winlimit)
	{
	  sprintf(error,"Window size too large (maximum area = %d pixels)",winlimit);
	  XtFree(strptr);
	  return 0;
	}
	
	/***** Check window separation in X **************************************/
	
	strptr=XmTextFieldGetString(xsepField);
	sptr=stripws(strptr);
	
	isep=atoi(sptr);
	
	if(strlen(sptr)==0||isep<=0)
	{
	  isep=iwid;
	  sprintf(sptr,"%d",isep);
	  XmTextSetString(xsepField,sptr);
	  XmTextSetInsertionPosition(xsepField,strlen(sptr));
	}
	else
	{
	  iflag=0;
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(sptr[i]=='.'&&!iflag)
	    {
	      iflag++;
	    }
	    else if(sptr[i]=='.'&&iflag)
	    {
	      strcpy(error,"Invalid window separation in X");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i]))
	    {
	      strcpy(error,"Invalid window separation in X");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	}
	
	XtFree(strptr);
	
	/***** Check window separation in Y **************************************/
	
	strptr=XmTextFieldGetString(ysepField);
	sptr=stripws(strptr);
	
	jsep=atoi(sptr);
	
	if(strlen(sptr)==0||jsep<=0)
	{
	  jsep=jwid;
	  sprintf(sptr,"%d",jsep);
	  XmTextSetString(ysepField,sptr);
	  XmTextSetInsertionPosition(ysepField,strlen(sptr));
	}
	else
	{
	  iflag=0;
	  for(i=0;i<strlen(sptr);i++)
	  {
	    if(sptr[i]=='.'&&!iflag)
	    {
	      iflag++;
	    }
	    else if(sptr[i]=='.'&&iflag)
	    {
	      strcpy(error,"Invalid window separation in Y");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i]))
	    {
	      strcpy(error,"Invalid window separation in Y");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	}
	
	XtFree(strptr);
	
	/***** Check pixel range 1 ***********************************************/
	
	strptr=XmTextFieldGetString(lpixField1);
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
	
	strptr=XmTextFieldGetString(hpixField1);
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
	
	strptr=XmTextFieldGetString(smoothField1);
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
	
	strptr=XmTextFieldGetString(tensionField1);
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
	
	strptr=XmTextGetString(outfileField1);
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
	XmTextSetString(outfileField1,sptr);
	XmTextSetInsertionPosition(outfileField1,strlen(sptr));
	XtFree(strptr);
	
	/*************************************************************************/
	
	return 1;
}

static int	_BackWindowParams_getParams( swidget UxThis, Environment * pEnv, char *error )
{
	int			_Uxrtrn;
	_UxCBackWindowParams    *UxSaveCtx = UxBackWindowParamsContext;

	UxBackWindowParamsContext = (_UxCBackWindowParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getParams( UxThis, pEnv, error );
	UxBackWindowParamsContext = UxSaveCtx;

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
	
	XtVaSetValues(xcentreField1,XmNvalue,xc,NULL);
	XtVaSetValues(ycentreField1,XmNvalue,yc,NULL);
	
	free(xc);
	free(yc);
}

static void	_BackWindowParams_setCentre( swidget UxThis, Environment * pEnv, double xcen, double ycen )
{
	_UxCBackWindowParams    *UxSaveCtx = UxBackWindowParamsContext;

	UxBackWindowParamsContext = (_UxCBackWindowParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setCentre( UxThis, pEnv, xcen, ycen );
	UxBackWindowParamsContext = UxSaveCtx;
}

static void	Ux_setSize( swidget UxThis, Environment * pEnv, int np, int nr )
{
	char *text1,*text2;
	
	text1=(char*) malloc(80*sizeof(char));
	text2=(char*) malloc(80*sizeof(char));
	
	winlimit=(np/2)*(nr/2);
	
	sprintf(text1,"%d",(int)((float)np/20.));
	sprintf(text2,"%d",(int)((float)nr/20.));
	
	XtVaSetValues(xwinField,XmNvalue,text1,NULL);
	XtVaSetValues(ywinField,XmNvalue,text2,NULL);
	XtVaSetValues(xsepField,XmNvalue,text1,NULL);
	XtVaSetValues(ysepField,XmNvalue,text2,NULL);
	
	free(text1);
	free(text2);
}

static void	_BackWindowParams_setSize( swidget UxThis, Environment * pEnv, int np, int nr )
{
	_UxCBackWindowParams    *UxSaveCtx = UxBackWindowParamsContext;

	UxBackWindowParamsContext = (_UxCBackWindowParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setSize( UxThis, pEnv, np, nr );
	UxBackWindowParamsContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  activateCB_pushButton1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackWindowParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackWindowParamsContext;
	UxBackWindowParamsContext = UxContext =
			(_UxCBackWindowParams *) UxGetContext( UxWidget );
	{
	char error[80];
	
	if(BackWindowParams_getParams(UxThisWidget,&UxEnv,error))
	{
	  mainWS_setBackOutFile(mainWS,&UxEnv,sOutFile);
	
	  command("back window %d %d %d %d %f %f %f %f %f %f %f %f %f\n",
	           iwid,jwid,isep,jsep,smoo,tens,lpix,hpix,dmin,dmax,xcentre,ycentre,lowval);
	
	  UxPopdownInterface(UxThisWidget);
	}
	else
	{
	  ErrorMessage_set(ErrMessage,&UxEnv,error);
	  UxPopupInterface(ErrMessage,no_grab);
	}
	}
	UxBackWindowParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackWindowParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackWindowParamsContext;
	UxBackWindowParamsContext = UxContext =
			(_UxCBackWindowParams *) UxGetContext( UxWidget );
	{
	UxPopdownInterface(UxThisWidget);
	}
	UxBackWindowParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton3(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackWindowParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackWindowParamsContext;
	UxBackWindowParamsContext = UxContext =
			(_UxCBackWindowParams *) UxGetContext( UxWidget );
	{
	FileSelection_set(FileSelect,&UxEnv,&outfileField1,"*000.*","Output file selection",0,1,0,0,1);
	UxPopupInterface(FileSelect,no_grab);
	}
	UxBackWindowParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton4(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackWindowParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackWindowParamsContext;
	UxBackWindowParamsContext = UxContext =
			(_UxCBackWindowParams *) UxGetContext( UxWidget );
	{
	headerDialog_popup(header,&UxEnv,sOutFile);
	}
	UxBackWindowParamsContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_BackWindowParams()
{
	Widget		_UxParent;


	/* Creation of BackWindowParams */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "BackWindowParams_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 463,
			XmNy, 203,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "BackWindowParams",
			NULL );

	BackWindowParams = XtVaCreateWidget( "BackWindowParams",
			xmBulletinBoardWidgetClass,
			_UxParent,
			XmNunitType, XmPIXELS,
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			RES_CONVERT( XmNdialogTitle, "Roving window background" ),
			XmNautoUnmanage, FALSE,
			NULL );
	UxPutContext( BackWindowParams, (char *) UxBackWindowParamsContext );
	UxPutClassCode( BackWindowParams, _UxIfClassId );


	/* Creation of label2 */
	label2 = XtVaCreateManagedWidget( "label2",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 216,
			RES_CONVERT( XmNlabelString, "Window size :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label2, (char *) UxBackWindowParamsContext );


	/* Creation of label3 */
	label3 = XtVaCreateManagedWidget( "label3",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 256,
			RES_CONVERT( XmNlabelString, "Window separation :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label3, (char *) UxBackWindowParamsContext );


	/* Creation of label4 */
	label4 = XtVaCreateManagedWidget( "label4",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 307,
			RES_CONVERT( XmNlabelString, "Pixel range:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label4, (char *) UxBackWindowParamsContext );


	/* Creation of label6 */
	label6 = XtVaCreateManagedWidget( "label6",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 372,
			RES_CONVERT( XmNlabelString, "Smoothing factor:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label6, (char *) UxBackWindowParamsContext );


	/* Creation of label7 */
	label7 = XtVaCreateManagedWidget( "label7",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 418,
			RES_CONVERT( XmNlabelString, "Tension factor:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label7, (char *) UxBackWindowParamsContext );


	/* Creation of ywinField */
	ywinField = XtVaCreateManagedWidget( "ywinField",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 272,
			XmNy, 211,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( ywinField, (char *) UxBackWindowParamsContext );


	/* Creation of xwinField */
	xwinField = XtVaCreateManagedWidget( "xwinField",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 196,
			XmNy, 211,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( xwinField, (char *) UxBackWindowParamsContext );


	/* Creation of ysepField */
	ysepField = XtVaCreateManagedWidget( "ysepField",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 272,
			XmNy, 251,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( ysepField, (char *) UxBackWindowParamsContext );


	/* Creation of xsepField */
	xsepField = XtVaCreateManagedWidget( "xsepField",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 196,
			XmNy, 251,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( xsepField, (char *) UxBackWindowParamsContext );


	/* Creation of hpixField1 */
	hpixField1 = XtVaCreateManagedWidget( "hpixField1",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 272,
			XmNy, 302,
			XmNwidth, 50,
			XmNvalue, "25",
			XmNmaxLength, 3,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( hpixField1, (char *) UxBackWindowParamsContext );


	/* Creation of lpixField1 */
	lpixField1 = XtVaCreateManagedWidget( "lpixField1",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 196,
			XmNy, 302,
			XmNvalue, "0",
			XmNmaxLength, 3,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( lpixField1, (char *) UxBackWindowParamsContext );


	/* Creation of smoothField1 */
	smoothField1 = XtVaCreateManagedWidget( "smoothField1",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 196,
			XmNy, 365,
			XmNwidth, 50,
			XmNvalue, "1.0",
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( smoothField1, (char *) UxBackWindowParamsContext );


	/* Creation of tensionField1 */
	tensionField1 = XtVaCreateManagedWidget( "tensionField1",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 196,
			XmNy, 411,
			XmNwidth, 50,
			XmNvalue, "1.0",
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( tensionField1, (char *) UxBackWindowParamsContext );


	/* Creation of label9 */
	label9 = XtVaCreateManagedWidget( "label9",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 215,
			XmNy, 191,
			RES_CONVERT( XmNlabelString, "X" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label9, (char *) UxBackWindowParamsContext );


	/* Creation of label10 */
	label10 = XtVaCreateManagedWidget( "label10",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 291,
			XmNy, 191,
			RES_CONVERT( XmNlabelString, "Y" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label10, (char *) UxBackWindowParamsContext );


	/* Creation of label11 */
	label11 = XtVaCreateManagedWidget( "label11",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 247,
			XmNy, 306,
			RES_CONVERT( XmNlabelString, "%" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label11, (char *) UxBackWindowParamsContext );


	/* Creation of label12 */
	label12 = XtVaCreateManagedWidget( "label12",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 323,
			XmNy, 306,
			RES_CONVERT( XmNlabelString, "%" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label12, (char *) UxBackWindowParamsContext );


	/* Creation of pushButton1 */
	pushButton1 = XtVaCreateManagedWidget( "pushButton1",
			xmPushButtonWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 617,
			XmNwidth, 91,
			XmNheight, 33,
			RES_CONVERT( XmNlabelString, "Run" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton1, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton1,
		(XtPointer) UxBackWindowParamsContext );

	UxPutContext( pushButton1, (char *) UxBackWindowParamsContext );


	/* Creation of pushButton2 */
	pushButton2 = XtVaCreateManagedWidget( "pushButton2",
			xmPushButtonWidgetClass,
			BackWindowParams,
			XmNx, 254,
			XmNy, 617,
			XmNwidth, 91,
			XmNheight, 33,
			RES_CONVERT( XmNlabelString, "Cancel" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton2, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton2,
		(XtPointer) UxBackWindowParamsContext );

	UxPutContext( pushButton2, (char *) UxBackWindowParamsContext );


	/* Creation of label8 */
	label8 = XtVaCreateManagedWidget( "label8",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 90,
			RES_CONVERT( XmNlabelString, "Pattern limits :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label8, (char *) UxBackWindowParamsContext );


	/* Creation of rmaxField1 */
	rmaxField1 = XtVaCreateManagedWidget( "rmaxField1",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 265,
			XmNy, 85,
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( rmaxField1, (char *) UxBackWindowParamsContext );


	/* Creation of label13 */
	label13 = XtVaCreateManagedWidget( "label13",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 280,
			XmNy, 65,
			RES_CONVERT( XmNlabelString, "R max" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label13, (char *) UxBackWindowParamsContext );


	/* Creation of label14 */
	label14 = XtVaCreateManagedWidget( "label14",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 34,
			RES_CONVERT( XmNlabelString, "Centre :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label14, (char *) UxBackWindowParamsContext );


	/* Creation of label15 */
	label15 = XtVaCreateManagedWidget( "label15",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 189,
			XmNy, 65,
			RES_CONVERT( XmNlabelString, "R min" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label15, (char *) UxBackWindowParamsContext );


	/* Creation of rminField1 */
	rminField1 = XtVaCreateManagedWidget( "rminField1",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 172,
			XmNy, 85,
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( rminField1, (char *) UxBackWindowParamsContext );


	/* Creation of label43 */
	label43 = XtVaCreateManagedWidget( "label43",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 206,
			XmNy, 9,
			RES_CONVERT( XmNlabelString, "X" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label43, (char *) UxBackWindowParamsContext );


	/* Creation of label44 */
	label44 = XtVaCreateManagedWidget( "label44",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 299,
			XmNy, 9,
			RES_CONVERT( XmNlabelString, "Y" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label44, (char *) UxBackWindowParamsContext );


	/* Creation of separator8 */
	separator8 = XtVaCreateManagedWidget( "separator8",
			xmSeparatorWidgetClass,
			BackWindowParams,
			XmNwidth, 336,
			XmNheight, 10,
			XmNx, 10,
			XmNy, 180,
			NULL );
	UxPutContext( separator8, (char *) UxBackWindowParamsContext );


	/* Creation of xcentreField1 */
	xcentreField1 = XtVaCreateManagedWidget( "xcentreField1",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 172,
			XmNy, 29,
			XmNwidth, 80,
			XmNcursorPositionVisible, TRUE,
			XmNeditable, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( xcentreField1, (char *) UxBackWindowParamsContext );


	/* Creation of ycentreField1 */
	ycentreField1 = XtVaCreateManagedWidget( "ycentreField1",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 265,
			XmNy, 29,
			XmNwidth, 80,
			XmNcursorPositionVisible, TRUE,
			XmNeditable, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( ycentreField1, (char *) UxBackWindowParamsContext );


	/* Creation of label16 */
	label16 = XtVaCreateManagedWidget( "label16",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 479,
			RES_CONVERT( XmNlabelString, "Output filename:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label16, (char *) UxBackWindowParamsContext );


	/* Creation of pushButton3 */
	pushButton3 = XtVaCreateManagedWidget( "pushButton3",
			xmPushButtonWidgetClass,
			BackWindowParams,
			XmNx, 282,
			XmNy, 474,
			RES_CONVERT( XmNlabelString, "Browse" ),
			XmNmarginWidth, 5,
			XmNmarginHeight, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton3, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton3,
		(XtPointer) UxBackWindowParamsContext );

	UxPutContext( pushButton3, (char *) UxBackWindowParamsContext );


	/* Creation of scrolledWindowText2 */
	scrolledWindowText2 = XtVaCreateManagedWidget( "scrolledWindowText2",
			xmScrolledWindowWidgetClass,
			BackWindowParams,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNx, 166,
			XmNy, 473,
			NULL );
	UxPutContext( scrolledWindowText2, (char *) UxBackWindowParamsContext );


	/* Creation of outfileField1 */
	outfileField1 = XtVaCreateManagedWidget( "outfileField1",
			xmTextWidgetClass,
			scrolledWindowText2,
			XmNwidth, 110,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( outfileField1, (char *) UxBackWindowParamsContext );


	/* Creation of pushButton4 */
	pushButton4 = XtVaCreateManagedWidget( "pushButton4",
			xmPushButtonWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 535,
			RES_CONVERT( XmNlabelString, "Write headers" ),
			XmNmarginWidth, 5,
			XmNmarginHeight, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton4, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton4,
		(XtPointer) UxBackWindowParamsContext );

	UxPutContext( pushButton4, (char *) UxBackWindowParamsContext );


	/* Creation of label5 */
	label5 = XtVaCreateManagedWidget( "label5",
			xmLabelWidgetClass,
			BackWindowParams,
			XmNx, 15,
			XmNy, 143,
			RES_CONVERT( XmNlabelString, "Discard values less than :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label5, (char *) UxBackWindowParamsContext );


	/* Creation of lowvalField1 */
	lowvalField1 = XtVaCreateManagedWidget( "lowvalField1",
			xmTextFieldWidgetClass,
			BackWindowParams,
			XmNx, 265,
			XmNy, 138,
			XmNvalue, "0.0",
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( lowvalField1, (char *) UxBackWindowParamsContext );


	/* Creation of separator1 */
	separator1 = XtVaCreateManagedWidget( "separator1",
			xmSeparatorWidgetClass,
			BackWindowParams,
			XmNwidth, 336,
			XmNheight, 10,
			XmNx, 10,
			XmNy, 344,
			NULL );
	UxPutContext( separator1, (char *) UxBackWindowParamsContext );


	/* Creation of separator2 */
	separator2 = XtVaCreateManagedWidget( "separator2",
			xmSeparatorWidgetClass,
			BackWindowParams,
			XmNwidth, 336,
			XmNheight, 10,
			XmNx, 10,
			XmNy, 449,
			NULL );
	UxPutContext( separator2, (char *) UxBackWindowParamsContext );


	/* Creation of separator3 */
	separator3 = XtVaCreateManagedWidget( "separator3",
			xmSeparatorWidgetClass,
			BackWindowParams,
			XmNwidth, 336,
			XmNheight, 10,
			XmNx, 9,
			XmNy, 582,
			NULL );
	UxPutContext( separator3, (char *) UxBackWindowParamsContext );


	XtAddCallback( BackWindowParams, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxBackWindowParamsContext);


	return ( BackWindowParams );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_BackWindowParams( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCBackWindowParams    *UxContext;
	static int		_Uxinit = 0;

	UxBackWindowParamsContext = UxContext =
		(_UxCBackWindowParams *) UxNewContext( sizeof(_UxCBackWindowParams), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxBackWindowParams_getParams_Id = UxMethodRegister( _UxIfClassId,
				UxBackWindowParams_getParams_Name,
				(void (*)()) _BackWindowParams_getParams );
		UxBackWindowParams_setCentre_Id = UxMethodRegister( _UxIfClassId,
				UxBackWindowParams_setCentre_Name,
				(void (*)()) _BackWindowParams_setCentre );
		UxBackWindowParams_setSize_Id = UxMethodRegister( _UxIfClassId,
				UxBackWindowParams_setSize_Name,
				(void (*)()) _BackWindowParams_setSize );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_BackWindowParams();

	sOutFile="";
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

