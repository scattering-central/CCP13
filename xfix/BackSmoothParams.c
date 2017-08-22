
/*******************************************************************************
	BackSmoothParams.c

       Associated Header file: BackSmoothParams.h
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
#include <Xm/ToggleB.h>
#include <Xm/RowColumn.h>
#include <Xm/PushB.h>
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/BulletinB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <stdlib.h>
#include <string.h>

#ifndef DESIGN_TIME
#include "mainWS.h"
#include "FileSelection.h"
#include "headerDialog.h"
#include "ErrorMessage.h"
#include "CyclesParams.h" 
#endif

extern swidget mainWS;
extern swidget FileSelect;
extern swidget header;
extern swidget ErrMessage;
extern swidget CycleParam;

extern void command(char *,...);


static	int _UxIfClassId;
int	UxBackSmoothParams_getParams_Id = -1;
char*	UxBackSmoothParams_getParams_Name = "getParams";
int	UxBackSmoothParams_setCentre_Id = -1;
char*	UxBackSmoothParams_setCentre_Name = "setCentre";
int	UxBackSmoothParams_setSize_Id = -1;
char*	UxBackSmoothParams_setSize_Name = "setSize";
int	UxBackSmoothParams_BoxcarSensitive_Id = -1;
char*	UxBackSmoothParams_BoxcarSensitive_Name = "BoxcarSensitive";
int	UxBackSmoothParams_ImportSensitive_Id = -1;
char*	UxBackSmoothParams_ImportSensitive_Name = "ImportSensitive";
int	UxBackSmoothParams_MergeSensitive_Id = -1;
char*	UxBackSmoothParams_MergeSensitive_Name = "MergeSensitive";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "BackSmoothParams.h"
#undef CONTEXT_MACRO_ACCESS

Widget	backgroundField;
Widget	outfileField3;

/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_BackSmoothParams_getParams( swidget UxThis, Environment * pEnv, char *error );
static void	_BackSmoothParams_setCentre( swidget UxThis, Environment * pEnv, double xcen, double ycen );
static void	_BackSmoothParams_setSize( swidget UxThis, Environment * pEnv, int np, int nr );
static void	_BackSmoothParams_BoxcarSensitive( swidget UxThis, Environment * pEnv, Boolean i );
static void	_BackSmoothParams_ImportSensitive( swidget UxThis, Environment * pEnv, Boolean i );
static void	_BackSmoothParams_MergeSensitive( swidget UxThis, Environment * pEnv, Boolean i );

/*******************************************************************************
Auxiliary code from the Declarations Editor:
*******************************************************************************/

#ifndef DESIGN_TIME

int readheader (char *filename, char *binary, int ispec, int filenum,
                int *npixel, int *nraster, int *nframe, int *fend, int *dtyp)
{
#define MAXLIN 120

    char buff[MAXLIN], *cptr;
    register int i = 0;
    register int j = 0;
    FILE *fp, *fopen ();
    char binpluspath[81];

    for(j=strlen(filename);j>=0;j--)
    {
      if(filename[j]=='/')
      {
        break;
      }
    }
    j++;

    strcpy(binpluspath,"");

    if (ispec > 0)
    {
        cptr =&filename[j];
         *++cptr = (ispec / 10000) + '0';
         *++cptr = ((ispec % 10000) / 1000) + '0';
    }


    if ((fp = fopen (filename, "r")) == NULL)
        return (FALSE);
    else
    {
        if ((fgets (buff, MAXLIN, fp)) == NULL)
            return (FALSE);
        else if ((fgets (buff, MAXLIN, fp)) == NULL)
            return (FALSE);
        else
        {
            do {
               if ((fgets (buff, MAXLIN, fp)) == NULL)
                   return (FALSE);
               else if (sscanf (buff, "%8d%8d%8d%8d%8d", npixel, nraster, nframe,
                                fend,dtyp) != 5)
                   return (FALSE);
               else if ((fgets (binary, MAXLIN, fp)) == NULL)
                   return (FALSE);
            }
            while (++i < filenum);
        }

        *(binary+10) = '\0';    /* Remove new line character */

        if(j)
        {
          strncpy(binpluspath,filename,j);
          binpluspath[j]='\0';
          strcat(binpluspath,binary);
          strcpy(binary,binpluspath);
        }

        fclose (fp);
        return (TRUE);
    }
}

#endif

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_getParams( swidget UxThis, Environment * pEnv, char *error )
{
#ifndef DESIGN_TIME
	
	extern char *stripws(char*);
	char *strptr,*sptr;
	int i,iflag;
	char* pptr;
	int irc,npixel,nraster,nframes,filenum,ispec;
	char *binary;
	
	filenum=1;
	ispec=0;
	
	strcpy(error,"");
	
	/***** Check X-coord of centre *******************************************/
	
	strptr=XmTextFieldGetString(xcentreField3);
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
	
	strptr=XmTextFieldGetString(ycentreField3);
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
	
	strptr=XmTextFieldGetString(rminField3);
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
	
	strptr=XmTextFieldGetString(rmaxField3);
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
	
	strptr=XmTextFieldGetString(lowvalField3);
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
	
	/***** Check smoothing function size *************************************/
	
	if(!strncmp(funcopt,"boxca",5))
	{
	  strptr=XmTextFieldGetString(fwhmField);
	  sptr=stripws(strptr);
	
	  pwid=atoi(sptr);
	
	  if(strlen(sptr)==0)
	  {
	    strcpy(error,"Box car size in X not specified");
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
	      strcpy(error,"Invalid box car size in X");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i]))
	    {
	      strcpy(error,"Invalid box car size in X");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	
	  if(pwid<=0)
	  {
	    strcpy(error,"Invalid box car size in X");
	    XtFree(strptr);
	    return 0;
	  }
	
	  XtFree(strptr);
	
	  strptr=XmTextFieldGetString(yboxcarField);
	  sptr=stripws(strptr);
	
	  rwid=atoi(sptr);
	
	  if(strlen(sptr)==0)
	  {
	    strcpy(error,"Box car size in Y not specified");
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
	      strcpy(error,"Invalid box car size in Y");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i]))
	    {
	      strcpy(error,"Invalid box car size in Y");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	
	  if(rwid<=0)
	  {
	    strcpy(error,"Invalid box car size in Y");
	    XtFree(strptr);
	    return 0;
	  }
	
	  if(pwid*rwid>maxfunc)
	  {
	    sprintf(error,"Box car size too large (max %d)",maxfunc);
	    XtFree(strptr);
	    return 0;
	  }
	
	  XtFree(strptr);
	
	}
	else if(!strncmp(funcopt,"gauss",5))
	{
	  strptr=XmTextFieldGetString(fwhmField);
	  sptr=stripws(strptr);
	
	  pwid=atoi(sptr);
	
	  if(strlen(sptr)==0)
	  {
	    strcpy(error,"Gaussian FWHM not specified");
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
	      strcpy(error,"Invalid gaussian FWHM");
	      XtFree(strptr);
	      return 0;
	    }
	    else if(!isdigit(sptr[i]))
	    {
	      strcpy(error,"Invalid gaussian FWHM");
	      XtFree(strptr);
	      return 0;
	    }
	  }
	
	  if(pwid<=0)
	  {
	    strcpy(error,"Invalid gaussian FWHM");
	    XtFree(strptr);
	    return 0;
	  }
	
	  if(pwid*pwid>maxfunc)
	  {
	    sprintf(error,"Gaussian FWHM too large (max %d)",(int)(pow( (double) maxfunc, 0.5)));
	    XtFree(strptr);
	    return 0;
	  }
	
	  XtFree(strptr);
	}
	
	/***** Check number of cycles ********************************************/
	
	strptr=XmTextFieldGetString(cyclesField);
	sptr=stripws(strptr);
	
	ncycles=atoi(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Number of cycles not specified");
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
	    strcpy(error,"Invalid number of cycles");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid number of cycles");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	if(ncycles<=0)
	{
	  strcpy(error,"Invalid number of cycles");
	  XtFree(strptr);
	  return 0;
	}
	
	XtFree(strptr);
	
	/***** Check whether to smooth at edge ***********************************/
	
	if(XmToggleButtonGetState(edgeButton))
	  doedge=True;
	else
	  doedge=False;
	
	/***** If no smoothing at edge, check other options **********************/
	
	if(!doedge)
	{
	
	/***** Check input BSL filename ******************************************/
	
	  strptr=XmTextGetString(backgroundField);
	  sptr=stripws(strptr);
	
	  if(!mainWS_CheckInFile(mainWS,&UxEnv,sptr,error,False,True))
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
	
	  sInFile=(char*)strdup(sptr);
	  XmTextSetString(backgroundField,sptr);
	  XmTextSetInsertionPosition(backgroundField,strlen(sptr));
	  XtFree(strptr);
	
	/***** Check frame number ************************************************/
	
	strptr=XmTextFieldGetString(frameField);
	sptr=stripws(strptr);
	
	frame=atoi(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Frame of input file not specified");
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
	    strcpy(error,"Invalid input file frame");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid input file frame");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	if(frame<=0)
	{
	  strcpy(error,"Invalid input file frame");
	  XtFree(strptr);
	  return 0;
	}
	
	binary=(char*)malloc(120*sizeof(char));
	irc=readheader(sInFile,binary,ispec,filenum,&npixel,&nraster,&nframes,&fendian,&dtype);
	
	if(frame>nframes)
	{
	  strcpy(error,"Input file frame does not exist");
	  XtFree(strptr);
	  return 0;
	}
	
	free(binary);
	XtFree(strptr);
	
	/***** Check whether to merge with imported background *******************/
	
	  if(XmToggleButtonGetState(mergeButton))
	    merge=True;
	  else
	    merge=False;
	
	/***** If merging, check other options ***********************************/
	
	  if(merge)
	  {
	
	/****** Check smoothing factor *******************************************/
	
	    strptr=XmTextFieldGetString(smoothField3);
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
	
	    strptr=XmTextFieldGetString(tensionField3);
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
	
	/***** Check weight of imported background **********************************/
	
	    strptr=XmTextFieldGetString(weightField);
	    sptr=stripws(strptr);
	
	    weight=atof(sptr);
	
	    if(strlen(sptr)==0)
	    {
	      strcpy(error,"Weight of imported background not specified");
	      XtFree(strptr);
	      return 0;
	    }
	
	    if(weight<0.)
	    {
	      strcpy(error,"Invalid weight for imported background");
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
	        strcpy(error,"Invalid weight for imported background");
	        XtFree(strptr);
	        return 0;
	      }
	      else if(!isdigit(sptr[i]))
	      {
	        strcpy(error,"Invalid weight for imported background");
	        XtFree(strptr);
	        return 0;
	      }
	    }
	
	    XtFree(strptr);
	
	  }
	}
	
	/***** Check output BSL filename *****************************************/
	
	strptr=XmTextGetString(outfileField3);
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
	XmTextSetString(outfileField3,sptr);
	XmTextSetInsertionPosition(outfileField3,strlen(sptr));
	XtFree(strptr);
	
	CyclesParams_setOutFile(CycleParam,&UxEnv,sOutFile);
	
	/*************************************************************************/
	
	return 1;
	
#endif
}

static int	_BackSmoothParams_getParams( swidget UxThis, Environment * pEnv, char *error )
{
	int			_Uxrtrn;
	_UxCBackSmoothParams    *UxSaveCtx = UxBackSmoothParamsContext;

	UxBackSmoothParamsContext = (_UxCBackSmoothParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_getParams( UxThis, pEnv, error );
	UxBackSmoothParamsContext = UxSaveCtx;

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
	
	XtVaSetValues(xcentreField3,XmNvalue,xc,NULL);
	XtVaSetValues(ycentreField3,XmNvalue,yc,NULL);
	
	free(xc);
	free(yc);
}

static void	_BackSmoothParams_setCentre( swidget UxThis, Environment * pEnv, double xcen, double ycen )
{
	_UxCBackSmoothParams    *UxSaveCtx = UxBackSmoothParamsContext;

	UxBackSmoothParamsContext = (_UxCBackSmoothParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setCentre( UxThis, pEnv, xcen, ycen );
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void	Ux_setSize( swidget UxThis, Environment * pEnv, int np, int nr )
{
	char *text1,*text2;
	
	text1=(char*) malloc(80*sizeof(char));
	text2=(char*) malloc(80*sizeof(char));
	
	maxfunc=(np/2)*(nr/2);
	
	sprintf(text1,"%d",(int)((float)np/20.));
	sprintf(text2,"%d",(int)((float)nr/20.));
	
	XtVaSetValues(xboxcarField,XmNvalue,text1,NULL);
	XtVaSetValues(yboxcarField,XmNvalue,text2,NULL);
	XtVaSetValues(fwhmField,XmNvalue,text1,NULL);
	
	free(text1);
	free(text2);
}

static void	_BackSmoothParams_setSize( swidget UxThis, Environment * pEnv, int np, int nr )
{
	_UxCBackSmoothParams    *UxSaveCtx = UxBackSmoothParamsContext;

	UxBackSmoothParamsContext = (_UxCBackSmoothParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setSize( UxThis, pEnv, np, nr );
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void	Ux_BoxcarSensitive( swidget UxThis, Environment * pEnv, Boolean i )
{
	XtVaSetValues(UxGetWidget(boxcarLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(xboxcarLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(yboxcarLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(xboxcarField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(yboxcarField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(fwhmLabel),XmNsensitive,!i,NULL);
	XtVaSetValues(UxGetWidget(fwhmField),XmNsensitive,!i,NULL);
	XtVaSetValues(UxGetWidget(xboxcarField),XmNcursorPositionVisible,i,NULL);
	XtVaSetValues(UxGetWidget(yboxcarField),XmNcursorPositionVisible,i,NULL);
	XtVaSetValues(UxGetWidget(fwhmField),XmNcursorPositionVisible,!i,NULL);
}

static void	_BackSmoothParams_BoxcarSensitive( swidget UxThis, Environment * pEnv, Boolean i )
{
	_UxCBackSmoothParams    *UxSaveCtx = UxBackSmoothParamsContext;

	UxBackSmoothParamsContext = (_UxCBackSmoothParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_BoxcarSensitive( UxThis, pEnv, i );
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void	Ux_ImportSensitive( swidget UxThis, Environment * pEnv, Boolean i )
{
	XtVaSetValues(UxGetWidget(backgroundLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(backgroundField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(browseButton),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(frameLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(frameField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(backgroundField),XmNcursorPositionVisible,i,NULL);
	XmToggleButtonSetState(mergeButton,i,True);
	XtVaSetValues(UxGetWidget(mergeButton),XmNsensitive,i,NULL);
}

static void	_BackSmoothParams_ImportSensitive( swidget UxThis, Environment * pEnv, Boolean i )
{
	_UxCBackSmoothParams    *UxSaveCtx = UxBackSmoothParamsContext;

	UxBackSmoothParamsContext = (_UxCBackSmoothParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_ImportSensitive( UxThis, pEnv, i );
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void	Ux_MergeSensitive( swidget UxThis, Environment * pEnv, Boolean i )
{
	XtVaSetValues(UxGetWidget(smoothLabel3),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(smoothField3),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(tensionLabel3),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(tensionField3),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(smoothField3),XmNcursorPositionVisible,i,NULL);
	XtVaSetValues(UxGetWidget(tensionField3),XmNcursorPositionVisible,i,NULL);
	XtVaSetValues(UxGetWidget(weightLabel),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(weightField),XmNsensitive,i,NULL);
	XtVaSetValues(UxGetWidget(weightField),XmNcursorPositionVisible,i,NULL);
}

static void	_BackSmoothParams_MergeSensitive( swidget UxThis, Environment * pEnv, Boolean i )
{
	_UxCBackSmoothParams    *UxSaveCtx = UxBackSmoothParamsContext;

	UxBackSmoothParamsContext = (_UxCBackSmoothParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_MergeSensitive( UxThis, pEnv, i );
	UxBackSmoothParamsContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  activateCB_pushButton5(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackSmoothParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackSmoothParamsContext;
	UxBackSmoothParamsContext = UxContext =
			(_UxCBackSmoothParams *) UxGetContext( UxWidget );
	{
#ifndef DESIGN_TIME
	
	char error[80];
	
	if(BackSmoothParams_getParams(UxThisWidget,&UxEnv,error))
	{
	  mainWS_setBackOutFile(mainWS,&UxEnv,sOutFile);
	  mainWS_setBackInFile(mainWS,&UxEnv,sInFile,frame);
	
	  command("back smooth %s ",funcopt);
	
	  if(!strncmp(funcopt,"boxca",5))
	  {
	    command("%d %d %d %f %f %f %f %f ",
	            pwid,rwid,ncycles,dmin,dmax,xcentre,ycentre,lowval);
	  }
	  else if(!strncmp(funcopt,"gauss",5))
	  {
	    command("%d %d %f %f %f %f %f ",
	            pwid,ncycles,dmin,dmax,xcentre,ycentre,lowval);
	  }
	
	  if(doedge)
	  {
	    command("doedge\n");
	  }
	  else if(merge)
	  {
	    command("merge %f %f %f\n",smoo,tens,weight);
	  }
	  else
	  {
	    command("\n");
	  }
	
	  UxPopdownInterface(UxThisWidget);
	}
	else
	{
	  ErrorMessage_set(ErrMessage,&UxEnv,error);
	  UxPopupInterface(ErrMessage,no_grab);
	}
	
#endif
	}
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton6(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackSmoothParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackSmoothParamsContext;
	UxBackSmoothParamsContext = UxContext =
			(_UxCBackSmoothParams *) UxGetContext( UxWidget );
	{
	UxPopdownInterface(UxThisWidget);
	}
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void  activateCB_BoxcarButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackSmoothParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackSmoothParamsContext;
	UxBackSmoothParamsContext = UxContext =
			(_UxCBackSmoothParams *) UxGetContext( UxWidget );
	BackSmoothParams_BoxcarSensitive(BackSmoothParams,&UxEnv,1);
	strcpy(funcopt,"boxca");
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void  activateCB_GaussButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackSmoothParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackSmoothParamsContext;
	UxBackSmoothParamsContext = UxContext =
			(_UxCBackSmoothParams *) UxGetContext( UxWidget );
	BackSmoothParams_BoxcarSensitive(BackSmoothParams,&UxEnv,0);
	strcpy(funcopt,"gauss");
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void  valueChangedCB_edgeButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackSmoothParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackSmoothParamsContext;
	UxBackSmoothParamsContext = UxContext =
			(_UxCBackSmoothParams *) UxGetContext( UxWidget );
	{
	BackSmoothParams_ImportSensitive(BackSmoothParams,&UxEnv,!XmToggleButtonGetState(UxThisWidget));
	}
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void  activateCB_browseButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackSmoothParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackSmoothParamsContext;
	UxBackSmoothParamsContext = UxContext =
			(_UxCBackSmoothParams *) UxGetContext( UxWidget );
	{
	FileSelection_set(FileSelect,&UxEnv,&backgroundField,"*000.*","Input file selection",1,1,1,0,1);
	UxPopupInterface(FileSelect,no_grab);
	}
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void  valueChangedCB_mergeButton(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackSmoothParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackSmoothParamsContext;
	UxBackSmoothParamsContext = UxContext =
			(_UxCBackSmoothParams *) UxGetContext( UxWidget );
	{
	BackSmoothParams_MergeSensitive(BackSmoothParams,&UxEnv,XmToggleButtonGetState(UxWidget));
	}
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton7(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackSmoothParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackSmoothParamsContext;
	UxBackSmoothParamsContext = UxContext =
			(_UxCBackSmoothParams *) UxGetContext( UxWidget );
	{
	FileSelection_set(FileSelect,&UxEnv,&outfileField3,"*000.*","Output file selection",0,1,0,0,1);
	UxPopupInterface(FileSelect,no_grab);
	}
	UxBackSmoothParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton8(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCBackSmoothParams    *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxBackSmoothParamsContext;
	UxBackSmoothParamsContext = UxContext =
			(_UxCBackSmoothParams *) UxGetContext( UxWidget );
	{
	headerDialog_popup(header,&UxEnv,sOutFile);
	}
	UxBackSmoothParamsContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_BackSmoothParams()
{
	Widget		_UxParent;
	Widget		optionMenu_p1_shell;


	/* Creation of BackSmoothParams */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "BackSmoothParams_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 393,
			XmNy, 12,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "BackSmoothParams",
			NULL );

	BackSmoothParams = XtVaCreateWidget( "BackSmoothParams",
			xmBulletinBoardWidgetClass,
			_UxParent,
			XmNunitType, XmPIXELS,
			XmNdialogStyle, XmDIALOG_FULL_APPLICATION_MODAL,
			RES_CONVERT( XmNdialogTitle, "Smoothed background" ),
			XmNautoUnmanage, FALSE,
			NULL );
	UxPutContext( BackSmoothParams, (char *) UxBackSmoothParamsContext );
	UxPutClassCode( BackSmoothParams, _UxIfClassId );


	/* Creation of label28 */
	label28 = XtVaCreateManagedWidget( "label28",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 90,
			RES_CONVERT( XmNlabelString, "Pattern limits :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label28, (char *) UxBackSmoothParamsContext );


	/* Creation of label29 */
	label29 = XtVaCreateManagedWidget( "label29",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 186,
			RES_CONVERT( XmNlabelString, "Smoothing function :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label29, (char *) UxBackSmoothParamsContext );


	/* Creation of smoothLabel3 */
	smoothLabel3 = XtVaCreateManagedWidget( "smoothLabel3",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 579,
			RES_CONVERT( XmNlabelString, "Smoothing factor:" ),
			XmNsensitive, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( smoothLabel3, (char *) UxBackSmoothParamsContext );


	/* Creation of tensionLabel3 */
	tensionLabel3 = XtVaCreateManagedWidget( "tensionLabel3",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 621,
			RES_CONVERT( XmNlabelString, "Tension factor:" ),
			XmNsensitive, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( tensionLabel3, (char *) UxBackSmoothParamsContext );


	/* Creation of rmaxField3 */
	rmaxField3 = XtVaCreateManagedWidget( "rmaxField3",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 268,
			XmNy, 85,
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( rmaxField3, (char *) UxBackSmoothParamsContext );


	/* Creation of yboxcarField */
	yboxcarField = XtVaCreateManagedWidget( "yboxcarField",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 273,
			XmNy, 241,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( yboxcarField, (char *) UxBackSmoothParamsContext );


	/* Creation of xboxcarField */
	xboxcarField = XtVaCreateManagedWidget( "xboxcarField",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 197,
			XmNy, 241,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( xboxcarField, (char *) UxBackSmoothParamsContext );


	/* Creation of tensionField3 */
	tensionField3 = XtVaCreateManagedWidget( "tensionField3",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 197,
			XmNy, 617,
			XmNwidth, 50,
			XmNvalue, "1.0",
			XmNsensitive, TRUE,
			XmNcursorPositionVisible, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( tensionField3, (char *) UxBackSmoothParamsContext );


	/* Creation of smoothField3 */
	smoothField3 = XtVaCreateManagedWidget( "smoothField3",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 197,
			XmNy, 575,
			XmNwidth, 50,
			XmNvalue, "1.0",
			XmNsensitive, TRUE,
			XmNcursorPositionVisible, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( smoothField3, (char *) UxBackSmoothParamsContext );


	/* Creation of label35 */
	label35 = XtVaCreateManagedWidget( "label35",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 284,
			XmNy, 65,
			RES_CONVERT( XmNlabelString, "R max" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label35, (char *) UxBackSmoothParamsContext );


	/* Creation of xboxcarLabel */
	xboxcarLabel = XtVaCreateManagedWidget( "xboxcarLabel",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 216,
			XmNy, 222,
			RES_CONVERT( XmNlabelString, "X" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( xboxcarLabel, (char *) UxBackSmoothParamsContext );


	/* Creation of yboxcarLabel */
	yboxcarLabel = XtVaCreateManagedWidget( "yboxcarLabel",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 292,
			XmNy, 222,
			RES_CONVERT( XmNlabelString, "Y" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( yboxcarLabel, (char *) UxBackSmoothParamsContext );


	/* Creation of pushButton5 */
	pushButton5 = XtVaCreateManagedWidget( "pushButton5",
			xmPushButtonWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 833,
			XmNwidth, 91,
			XmNheight, 33,
			RES_CONVERT( XmNlabelString, "Run" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton5, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton5,
		(XtPointer) UxBackSmoothParamsContext );

	UxPutContext( pushButton5, (char *) UxBackSmoothParamsContext );


	/* Creation of pushButton6 */
	pushButton6 = XtVaCreateManagedWidget( "pushButton6",
			xmPushButtonWidgetClass,
			BackSmoothParams,
			XmNx, 293,
			XmNy, 833,
			XmNwidth, 91,
			XmNheight, 33,
			RES_CONVERT( XmNlabelString, "Cancel" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton6, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton6,
		(XtPointer) UxBackSmoothParamsContext );

	UxPutContext( pushButton6, (char *) UxBackSmoothParamsContext );


	/* Creation of label40 */
	label40 = XtVaCreateManagedWidget( "label40",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 36,
			RES_CONVERT( XmNlabelString, "Pattern centre :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label40, (char *) UxBackSmoothParamsContext );


	/* Creation of optionMenu_p1 */
	optionMenu_p1_shell = XtVaCreatePopupShell ("optionMenu_p1_shell",
			xmMenuShellWidgetClass, BackSmoothParams,
			XmNwidth, 1,
			XmNheight, 1,
			XmNallowShellResize, TRUE,
			XmNoverrideRedirect, TRUE,
			NULL );

	optionMenu_p1 = XtVaCreateWidget( "optionMenu_p1",
			xmRowColumnWidgetClass,
			optionMenu_p1_shell,
			XmNrowColumnType, XmMENU_PULLDOWN,
			NULL );
	UxPutContext( optionMenu_p1, (char *) UxBackSmoothParamsContext );


	/* Creation of BoxcarButton */
	BoxcarButton = XtVaCreateManagedWidget( "BoxcarButton",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "Box car" ),
			NULL );
	XtAddCallback( BoxcarButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_BoxcarButton,
		(XtPointer) UxBackSmoothParamsContext );

	UxPutContext( BoxcarButton, (char *) UxBackSmoothParamsContext );


	/* Creation of GaussButton */
	GaussButton = XtVaCreateManagedWidget( "GaussButton",
			xmPushButtonWidgetClass,
			optionMenu_p1,
			RES_CONVERT( XmNlabelString, "Gaussian" ),
			NULL );
	XtAddCallback( GaussButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_GaussButton,
		(XtPointer) UxBackSmoothParamsContext );

	UxPutContext( GaussButton, (char *) UxBackSmoothParamsContext );


	/* Creation of functionMenu */
	functionMenu = XtVaCreateManagedWidget( "functionMenu",
			xmRowColumnWidgetClass,
			BackSmoothParams,
			XmNrowColumnType, XmMENU_OPTION,
			XmNsubMenuId, optionMenu_p1,
			XmNx, 196,
			XmNy, 180,
			XmNwidth, 98,
			XmNheight, 25,
			NULL );
	UxPutContext( functionMenu, (char *) UxBackSmoothParamsContext );


	/* Creation of boxcarLabel */
	boxcarLabel = XtVaCreateManagedWidget( "boxcarLabel",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 246,
			RES_CONVERT( XmNlabelString, "Box car size :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( boxcarLabel, (char *) UxBackSmoothParamsContext );


	/* Creation of fwhmLabel */
	fwhmLabel = XtVaCreateManagedWidget( "fwhmLabel",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 285,
			RES_CONVERT( XmNlabelString, "Gaussian FWHM :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( fwhmLabel, (char *) UxBackSmoothParamsContext );


	/* Creation of fwhmField */
	fwhmField = XtVaCreateManagedWidget( "fwhmField",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 197,
			XmNy, 280,
			XmNwidth, 50,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( fwhmField, (char *) UxBackSmoothParamsContext );


	/* Creation of edgeButton */
	edgeButton = XtVaCreateManagedWidget( "edgeButton",
			xmToggleButtonWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 372,
			RES_CONVERT( XmNlabelString, "Apply smoothing at edge of pattern" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( edgeButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_edgeButton,
		(XtPointer) UxBackSmoothParamsContext );

	UxPutContext( edgeButton, (char *) UxBackSmoothParamsContext );


	/* Creation of backgroundLabel */
	backgroundLabel = XtVaCreateManagedWidget( "backgroundLabel",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 433,
			RES_CONVERT( XmNlabelString, "Import background :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( backgroundLabel, (char *) UxBackSmoothParamsContext );


	/* Creation of browseButton */
	browseButton = XtVaCreateManagedWidget( "browseButton",
			xmPushButtonWidgetClass,
			BackSmoothParams,
			XmNx, 316,
			XmNy, 428,
			RES_CONVERT( XmNlabelString, "Browse" ),
			XmNmarginHeight, 5,
			XmNmarginWidth, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( browseButton, XmNactivateCallback,
		(XtCallbackProc) activateCB_browseButton,
		(XtPointer) UxBackSmoothParamsContext );

	UxPutContext( browseButton, (char *) UxBackSmoothParamsContext );


	/* Creation of separator1 */
	separator1 = XtVaCreateManagedWidget( "separator1",
			xmSeparatorWidgetClass,
			BackSmoothParams,
			XmNwidth, 375,
			XmNheight, 10,
			XmNx, 10,
			XmNy, 162,
			NULL );
	UxPutContext( separator1, (char *) UxBackSmoothParamsContext );


	/* Creation of label34 */
	label34 = XtVaCreateManagedWidget( "label34",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 185,
			XmNy, 65,
			RES_CONVERT( XmNlabelString, "R min" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label34, (char *) UxBackSmoothParamsContext );


	/* Creation of rminField3 */
	rminField3 = XtVaCreateManagedWidget( "rminField3",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 169,
			XmNy, 85,
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( rminField3, (char *) UxBackSmoothParamsContext );


	/* Creation of xcentreField3 */
	xcentreField3 = XtVaCreateManagedWidget( "xcentreField3",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 169,
			XmNy, 31,
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( xcentreField3, (char *) UxBackSmoothParamsContext );


	/* Creation of label39 */
	label39 = XtVaCreateManagedWidget( "label39",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 203,
			XmNy, 10,
			RES_CONVERT( XmNlabelString, "X" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label39, (char *) UxBackSmoothParamsContext );


	/* Creation of ycentreField3 */
	ycentreField3 = XtVaCreateManagedWidget( "ycentreField3",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 268,
			XmNy, 31,
			XmNwidth, 80,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( ycentreField3, (char *) UxBackSmoothParamsContext );


	/* Creation of label41 */
	label41 = XtVaCreateManagedWidget( "label41",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 302,
			XmNy, 10,
			RES_CONVERT( XmNlabelString, "Y" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label41, (char *) UxBackSmoothParamsContext );


	/* Creation of label42 */
	label42 = XtVaCreateManagedWidget( "label42",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 326,
			RES_CONVERT( XmNlabelString, "Number of cycles :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label42, (char *) UxBackSmoothParamsContext );


	/* Creation of cyclesField */
	cyclesField = XtVaCreateManagedWidget( "cyclesField",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 197,
			XmNy, 321,
			XmNwidth, 50,
			XmNvalue, "5",
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( cyclesField, (char *) UxBackSmoothParamsContext );


	/* Creation of weightLabel */
	weightLabel = XtVaCreateManagedWidget( "weightLabel",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 664,
			RES_CONVERT( XmNlabelString, "Weight of imported background:" ),
			XmNsensitive, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( weightLabel, (char *) UxBackSmoothParamsContext );


	/* Creation of weightField */
	weightField = XtVaCreateManagedWidget( "weightField",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 297,
			XmNy, 660,
			XmNwidth, 50,
			XmNvalue, "0.5",
			XmNsensitive, TRUE,
			XmNcursorPositionVisible, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( weightField, (char *) UxBackSmoothParamsContext );


	/* Creation of mergeButton */
	mergeButton = XtVaCreateManagedWidget( "mergeButton",
			xmToggleButtonWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 532,
			RES_CONVERT( XmNlabelString, "Merge backgrounds" ),
			XmNset, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( mergeButton, XmNvalueChangedCallback,
		(XtCallbackProc) valueChangedCB_mergeButton,
		(XtPointer) UxBackSmoothParamsContext );

	UxPutContext( mergeButton, (char *) UxBackSmoothParamsContext );


	/* Creation of scrolledWindowText1 */
	scrolledWindowText1 = XtVaCreateManagedWidget( "scrolledWindowText1",
			xmScrolledWindowWidgetClass,
			BackSmoothParams,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNx, 191,
			XmNy, 429,
			XmNheight, 49,
			XmNwidth, 110,
			NULL );
	UxPutContext( scrolledWindowText1, (char *) UxBackSmoothParamsContext );


	/* Creation of backgroundField */
	backgroundField = XtVaCreateManagedWidget( "backgroundField",
			xmTextWidgetClass,
			scrolledWindowText1,
			XmNvalue, "",
			XmNwidth, 110,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNheight, 32,
			NULL );
	UxPutContext( backgroundField, (char *) UxBackSmoothParamsContext );


	/* Creation of label17 */
	label17 = XtVaCreateManagedWidget( "label17",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 719,
			RES_CONVERT( XmNlabelString, "Output filename:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label17, (char *) UxBackSmoothParamsContext );


	/* Creation of scrolledWindowText3 */
	scrolledWindowText3 = XtVaCreateManagedWidget( "scrolledWindowText3",
			xmScrolledWindowWidgetClass,
			BackSmoothParams,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNx, 191,
			XmNy, 715,
			XmNheight, 49,
			XmNwidth, 110,
			NULL );
	UxPutContext( scrolledWindowText3, (char *) UxBackSmoothParamsContext );


	/* Creation of outfileField3 */
	outfileField3 = XtVaCreateManagedWidget( "outfileField3",
			xmTextWidgetClass,
			scrolledWindowText3,
			XmNwidth, 110,
			XmNfontList, UxConvertFontList("9x15" ),
			XmNheight, 32,
			NULL );
	UxPutContext( outfileField3, (char *) UxBackSmoothParamsContext );


	/* Creation of pushButton7 */
	pushButton7 = XtVaCreateManagedWidget( "pushButton7",
			xmPushButtonWidgetClass,
			BackSmoothParams,
			XmNx, 316,
			XmNy, 714,
			RES_CONVERT( XmNlabelString, "Browse" ),
			XmNmarginWidth, 5,
			XmNmarginHeight, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton7, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton7,
		(XtPointer) UxBackSmoothParamsContext );

	UxPutContext( pushButton7, (char *) UxBackSmoothParamsContext );


	/* Creation of pushButton8 */
	pushButton8 = XtVaCreateManagedWidget( "pushButton8",
			xmPushButtonWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 767,
			RES_CONVERT( XmNlabelString, "Write headers" ),
			XmNmarginWidth, 5,
			XmNmarginHeight, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton8, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton8,
		(XtPointer) UxBackSmoothParamsContext );

	UxPutContext( pushButton8, (char *) UxBackSmoothParamsContext );


	/* Creation of frameLabel */
	frameLabel = XtVaCreateManagedWidget( "frameLabel",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 485,
			RES_CONVERT( XmNlabelString, "Frame number:" ),
			XmNsensitive, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( frameLabel, (char *) UxBackSmoothParamsContext );


	/* Creation of frameField */
	frameField = XtVaCreateManagedWidget( "frameField",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 197,
			XmNy, 480,
			XmNwidth, 50,
			XmNvalue, "1",
			XmNsensitive, TRUE,
			XmNcursorPositionVisible, TRUE,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( frameField, (char *) UxBackSmoothParamsContext );


	/* Creation of label1 */
	label1 = XtVaCreateManagedWidget( "label1",
			xmLabelWidgetClass,
			BackSmoothParams,
			XmNx, 10,
			XmNy, 132,
			RES_CONVERT( XmNlabelString, "Discard values less than :" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label1, (char *) UxBackSmoothParamsContext );


	/* Creation of lowvalField3 */
	lowvalField3 = XtVaCreateManagedWidget( "lowvalField3",
			xmTextFieldWidgetClass,
			BackSmoothParams,
			XmNx, 268,
			XmNy, 127,
			XmNwidth, 80,
			XmNvalue, "0.0",
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( lowvalField3, (char *) UxBackSmoothParamsContext );


	/* Creation of separator9 */
	separator9 = XtVaCreateManagedWidget( "separator9",
			xmSeparatorWidgetClass,
			BackSmoothParams,
			XmNwidth, 375,
			XmNheight, 10,
			XmNx, 10,
			XmNy, 518,
			NULL );
	UxPutContext( separator9, (char *) UxBackSmoothParamsContext );


	/* Creation of separator10 */
	separator10 = XtVaCreateManagedWidget( "separator10",
			xmSeparatorWidgetClass,
			BackSmoothParams,
			XmNwidth, 375,
			XmNheight, 10,
			XmNx, 10,
			XmNy, 696,
			NULL );
	UxPutContext( separator10, (char *) UxBackSmoothParamsContext );


	/* Creation of separator11 */
	separator11 = XtVaCreateManagedWidget( "separator11",
			xmSeparatorWidgetClass,
			BackSmoothParams,
			XmNwidth, 375,
			XmNheight, 10,
			XmNx, 8,
			XmNy, 809,
			NULL );
	UxPutContext( separator11, (char *) UxBackSmoothParamsContext );


	/* Creation of separator12 */
	separator12 = XtVaCreateManagedWidget( "separator12",
			xmSeparatorWidgetClass,
			BackSmoothParams,
			XmNwidth, 375,
			XmNheight, 10,
			XmNx, 10,
			XmNy, 405,
			NULL );
	UxPutContext( separator12, (char *) UxBackSmoothParamsContext );


	XtAddCallback( BackSmoothParams, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxBackSmoothParamsContext);


	return ( BackSmoothParams );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_BackSmoothParams( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCBackSmoothParams    *UxContext;
	static int		_Uxinit = 0;

	UxBackSmoothParamsContext = UxContext =
		(_UxCBackSmoothParams *) UxNewContext( sizeof(_UxCBackSmoothParams), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxBackSmoothParams_getParams_Id = UxMethodRegister( _UxIfClassId,
				UxBackSmoothParams_getParams_Name,
				(void (*)()) _BackSmoothParams_getParams );
		UxBackSmoothParams_setCentre_Id = UxMethodRegister( _UxIfClassId,
				UxBackSmoothParams_setCentre_Name,
				(void (*)()) _BackSmoothParams_setCentre );
		UxBackSmoothParams_setSize_Id = UxMethodRegister( _UxIfClassId,
				UxBackSmoothParams_setSize_Name,
				(void (*)()) _BackSmoothParams_setSize );
		UxBackSmoothParams_BoxcarSensitive_Id = UxMethodRegister( _UxIfClassId,
				UxBackSmoothParams_BoxcarSensitive_Name,
				(void (*)()) _BackSmoothParams_BoxcarSensitive );
		UxBackSmoothParams_ImportSensitive_Id = UxMethodRegister( _UxIfClassId,
				UxBackSmoothParams_ImportSensitive_Name,
				(void (*)()) _BackSmoothParams_ImportSensitive );
		UxBackSmoothParams_MergeSensitive_Id = UxMethodRegister( _UxIfClassId,
				UxBackSmoothParams_MergeSensitive_Name,
				(void (*)()) _BackSmoothParams_MergeSensitive );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_BackSmoothParams();

	sOutFile="";
	sInFile="";
	strcpy(funcopt,"");
	doedge=True;
	merge=True;
	
	XtVaSetValues(functionMenu,XmNmenuHistory,BoxcarButton,NULL);
	XtCallCallbacks(BoxcarButton,XmNactivateCallback,0);
	XmToggleButtonSetState(edgeButton,True,True);
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

