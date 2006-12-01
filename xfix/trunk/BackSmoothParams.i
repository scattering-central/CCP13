! UIMX ascii 2.9 key: 7153                                                      

*BackSmoothParams.class: bulletinBoardDialog
*BackSmoothParams.classinc:
*BackSmoothParams.classspec:
*BackSmoothParams.classmembers:
*BackSmoothParams.classconstructor:
*BackSmoothParams.classdestructor:
*BackSmoothParams.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
#include <string.h>\
\
#ifndef DESIGN_TIME\
#include "mainWS.h"\
#include "FileSelection.h"\
#include "headerDialog.h"\
#include "ErrorMessage.h"\
#include "CyclesParams.h" \
#endif\
\
extern swidget mainWS;\
extern swidget FileSelect;\
extern swidget header;\
extern swidget ErrMessage;\
extern swidget CycleParam;\
\
extern void command(char *,...);
*BackSmoothParams.ispecdecl: double xcentre,ycentre;\
float dmin,dmax,lowval;\
float smoo,tens,weight;\
int npix,nrast,maxfunc;\
char funcopt[7];\
int pwid,rwid,ncycles;\
char *sInFile, *sOutFile;\
Boolean doedge,merge;\
int frame, fendian, dtype;
*BackSmoothParams.ispeclist: xcentre, ycentre, dmin, dmax, lowval, smoo, tens, weight, npix, nrast, maxfunc, funcopt, pwid, rwid, ncycles, sInFile, sOutFile, doedge, merge, frame, fendian, dtype
*BackSmoothParams.ispeclist.xcentre: "double", "%xcentre%"
*BackSmoothParams.ispeclist.ycentre: "double", "%ycentre%"
*BackSmoothParams.ispeclist.dmin: "float", "%dmin%"
*BackSmoothParams.ispeclist.dmax: "float", "%dmax%"
*BackSmoothParams.ispeclist.lowval: "float", "%lowval%"
*BackSmoothParams.ispeclist.smoo: "float", "%smoo%"
*BackSmoothParams.ispeclist.tens: "float", "%tens%"
*BackSmoothParams.ispeclist.weight: "float", "%weight%"
*BackSmoothParams.ispeclist.npix: "int", "%npix%"
*BackSmoothParams.ispeclist.nrast: "int", "%nrast%"
*BackSmoothParams.ispeclist.maxfunc: "int", "%maxfunc%"
*BackSmoothParams.ispeclist.funcopt: "char", "%funcopt%[7]"
*BackSmoothParams.ispeclist.pwid: "int", "%pwid%"
*BackSmoothParams.ispeclist.rwid: "int", "%rwid%"
*BackSmoothParams.ispeclist.ncycles: "int", "%ncycles%"
*BackSmoothParams.ispeclist.sInFile: "char", "*%sInFile%"
*BackSmoothParams.ispeclist.sOutFile: "char", "*%sOutFile%"
*BackSmoothParams.ispeclist.doedge: "Boolean", "%doedge%"
*BackSmoothParams.ispeclist.merge: "Boolean", "%merge%"
*BackSmoothParams.ispeclist.frame: "int", "%frame%"
*BackSmoothParams.ispeclist.fendian: "int", "%fendian%"
*BackSmoothParams.ispeclist.dtype: "int", "%dtype%"
*BackSmoothParams.funcdecl: swidget create_BackSmoothParams(swidget UxParent)
*BackSmoothParams.funcname: create_BackSmoothParams
*BackSmoothParams.funcdef: "swidget", "<create_BackSmoothParams>(%)"
*BackSmoothParams.argdecl: swidget UxParent;
*BackSmoothParams.arglist: UxParent
*BackSmoothParams.arglist.UxParent: "swidget", "%UxParent%"
*BackSmoothParams.icode:
*BackSmoothParams.fcode: sOutFile="";\
sInFile="";\
strcpy(funcopt,"");\
doedge=True;\
merge=True;\
\
XtVaSetValues(functionMenu,XmNmenuHistory,BoxcarButton,NULL);\
XtCallCallbacks(BoxcarButton,XmNactivateCallback,0);\
XmToggleButtonSetState(edgeButton,True,True);\
return(rtrn);\

*BackSmoothParams.auxdecl: #ifndef DESIGN_TIME\
\
int readheader (char *filename, char *binary, int ispec, int filenum,\
                int *npixel, int *nraster, int *nframe, int *fend, int *dtyp)\
{\
#define MAXLIN 120\
\
    char buff[MAXLIN], *cptr;\
    register int i = 0;\
    register int j = 0;\
    FILE *fp, *fopen ();\
    char binpluspath[81];\
\
    for(j=strlen(filename);j>=0;j--)\
    {\
      if(filename[j]=='/')\
      {\
        break;\
      }\
    }\
    j++;\
\
    strcpy(binpluspath,"");\
\
    if (ispec > 0)\
    {\
        cptr =&filename[j];\
         *++cptr = (ispec / 10000) + '0';\
         *++cptr = ((ispec % 10000) / 1000) + '0';\
    }\
\
\
    if ((fp = fopen (filename, "r")) == NULL)\
        return (FALSE);\
    else\
    {\
        if ((fgets (buff, MAXLIN, fp)) == NULL)\
            return (FALSE);\
        else if ((fgets (buff, MAXLIN, fp)) == NULL)\
            return (FALSE);\
        else\
        {\
            do {\
               if ((fgets (buff, MAXLIN, fp)) == NULL)\
                   return (FALSE);\
               else if (sscanf (buff, "%8d%8d%8d%8d%8d", npixel, nraster, nframe,\
                                fend,dtyp) != 5)\
                   return (FALSE);\
               else if ((fgets (binary, MAXLIN, fp)) == NULL)\
                   return (FALSE);\
            }\
            while (++i < filenum);\
        }\
\
        *(binary+10) = '\0';    /* Remove new line character */\
\
        if(j)\
        {\
          strncpy(binpluspath,filename,j);\
          binpluspath[j]='\0';\
          strcat(binpluspath,binary);\
          strcpy(binary,binpluspath);\
        }\
\
        fclose (fp);\
        return (TRUE);\
    }\
}\
\
#endif
*BackSmoothParams_BoxcarSensitive.class: method
*BackSmoothParams_BoxcarSensitive.name: BoxcarSensitive
*BackSmoothParams_BoxcarSensitive.parent: BackSmoothParams
*BackSmoothParams_BoxcarSensitive.methodType: void
*BackSmoothParams_BoxcarSensitive.methodArgs: Boolean i;\

*BackSmoothParams_BoxcarSensitive.methodBody: XtVaSetValues(UxGetWidget(boxcarLabel),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(xboxcarLabel),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(yboxcarLabel),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(xboxcarField),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(yboxcarField),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(fwhmLabel),XmNsensitive,!i,NULL);\
XtVaSetValues(UxGetWidget(fwhmField),XmNsensitive,!i,NULL);\
XtVaSetValues(UxGetWidget(xboxcarField),XmNcursorPositionVisible,i,NULL);\
XtVaSetValues(UxGetWidget(yboxcarField),XmNcursorPositionVisible,i,NULL);\
XtVaSetValues(UxGetWidget(fwhmField),XmNcursorPositionVisible,!i,NULL);\

*BackSmoothParams_BoxcarSensitive.methodSpec: virtual
*BackSmoothParams_BoxcarSensitive.accessSpec: public
*BackSmoothParams_BoxcarSensitive.arguments: i
*BackSmoothParams_BoxcarSensitive.i.def: "Boolean", "%i%"

*BackSmoothParams_ImportSensitive.class: method
*BackSmoothParams_ImportSensitive.name: ImportSensitive
*BackSmoothParams_ImportSensitive.parent: BackSmoothParams
*BackSmoothParams_ImportSensitive.methodType: void
*BackSmoothParams_ImportSensitive.methodArgs: Boolean i;\

*BackSmoothParams_ImportSensitive.methodBody: XtVaSetValues(UxGetWidget(backgroundLabel),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(backgroundField),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(browseButton),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(frameLabel),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(frameField),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(backgroundField),XmNcursorPositionVisible,i,NULL);\
XmToggleButtonSetState(mergeButton,i,True);\
XtVaSetValues(UxGetWidget(mergeButton),XmNsensitive,i,NULL);
*BackSmoothParams_ImportSensitive.methodSpec: virtual
*BackSmoothParams_ImportSensitive.accessSpec: public
*BackSmoothParams_ImportSensitive.arguments: i
*BackSmoothParams_ImportSensitive.i.def: "Boolean", "%i%"

*BackSmoothParams_MergeSensitive.class: method
*BackSmoothParams_MergeSensitive.name: MergeSensitive
*BackSmoothParams_MergeSensitive.parent: BackSmoothParams
*BackSmoothParams_MergeSensitive.methodType: void
*BackSmoothParams_MergeSensitive.methodArgs: Boolean i;\

*BackSmoothParams_MergeSensitive.methodBody: XtVaSetValues(UxGetWidget(smoothLabel3),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(smoothField3),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(tensionLabel3),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(tensionField3),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(smoothField3),XmNcursorPositionVisible,i,NULL);\
XtVaSetValues(UxGetWidget(tensionField3),XmNcursorPositionVisible,i,NULL);\
XtVaSetValues(UxGetWidget(weightLabel),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(weightField),XmNsensitive,i,NULL);\
XtVaSetValues(UxGetWidget(weightField),XmNcursorPositionVisible,i,NULL);\

*BackSmoothParams_MergeSensitive.methodSpec: virtual
*BackSmoothParams_MergeSensitive.accessSpec: public
*BackSmoothParams_MergeSensitive.arguments: i
*BackSmoothParams_MergeSensitive.i.def: "Boolean", "%i%"

*BackSmoothParams_setCentre.class: method
*BackSmoothParams_setCentre.name: setCentre
*BackSmoothParams_setCentre.parent: BackSmoothParams
*BackSmoothParams_setCentre.methodType: void
*BackSmoothParams_setCentre.methodArgs: double xcen;\
double ycen;\

*BackSmoothParams_setCentre.methodBody: char *xc,*yc;\
\
xcentre=xcen;\
ycentre=ycen;\
\
xc=(char*)malloc(80*sizeof(char));\
yc=(char*)malloc(80*sizeof(char));\
\
sprintf(xc,"%.2f",xcen);\
sprintf(yc,"%.2f",ycen);\
\
XtVaSetValues(xcentreField3,XmNvalue,xc,NULL);\
XtVaSetValues(ycentreField3,XmNvalue,yc,NULL);\
\
free(xc);\
free(yc);
*BackSmoothParams_setCentre.methodSpec: virtual
*BackSmoothParams_setCentre.accessSpec: public
*BackSmoothParams_setCentre.arguments: xcen, ycen
*BackSmoothParams_setCentre.xcen.def: "double", "%xcen%"
*BackSmoothParams_setCentre.ycen.def: "double", "%ycen%"

*BackSmoothParams_setSize.class: method
*BackSmoothParams_setSize.name: setSize
*BackSmoothParams_setSize.parent: BackSmoothParams
*BackSmoothParams_setSize.methodType: void
*BackSmoothParams_setSize.methodArgs: int np;\
int nr;\

*BackSmoothParams_setSize.methodBody: char *text1,*text2;\
\
text1=(char*) malloc(80*sizeof(char));\
text2=(char*) malloc(80*sizeof(char));\
\
maxfunc=(np/2)*(nr/2);\
\
sprintf(text1,"%d",(int)((float)np/20.));\
sprintf(text2,"%d",(int)((float)nr/20.));\
\
XtVaSetValues(xboxcarField,XmNvalue,text1,NULL);\
XtVaSetValues(yboxcarField,XmNvalue,text2,NULL);\
XtVaSetValues(fwhmField,XmNvalue,text1,NULL);\
\
free(text1);\
free(text2);\

*BackSmoothParams_setSize.methodSpec: virtual
*BackSmoothParams_setSize.accessSpec: public
*BackSmoothParams_setSize.arguments: np, nr
*BackSmoothParams_setSize.np.def: "int", "%np%"
*BackSmoothParams_setSize.nr.def: "int", "%nr%"

*BackSmoothParams_getParams.class: method
*BackSmoothParams_getParams.name: getParams
*BackSmoothParams_getParams.parent: BackSmoothParams
*BackSmoothParams_getParams.methodType: int
*BackSmoothParams_getParams.methodArgs: char *error;\

*BackSmoothParams_getParams.methodBody: #ifndef DESIGN_TIME\
\
extern char *stripws(char*);\
char *strptr,*sptr;\
int i,iflag;\
char* pptr;\
int irc,npixel,nraster,nframes,filenum,ispec;\
char *binary;\
\
filenum=1;\
ispec=0;\
\
strcpy(error,"");\
\
/***** Check X-coord of centre *******************************************/\
\
strptr=XmTextFieldGetString(xcentreField3);\
sptr=stripws(strptr);\
\
xcentre=atof(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"X-coordinate of centre not specified");\
  XtFree(strptr);\
  return 0;\
}\
\
iflag=0;\
for(i=0;i<strlen(sptr);i++)\
{\
  if(sptr[i]=='.'&&!iflag)\
  {\
    iflag++;\
  }\
  else if(sptr[i]=='.'&&iflag)\
  {\
    strcpy(error,"Invalid X-coordinate for centre");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid X-coordinate for centre");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
XtFree(strptr);\
\
/***** Check Y-coord of centre *******************************************/\
\
strptr=XmTextFieldGetString(ycentreField3);\
sptr=stripws(strptr);\
\
ycentre=atof(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Y-coordinate of centre not specified");\
  XtFree(strptr);\
  return 0;\
}\
\
iflag=0;\
for(i=0;i<strlen(sptr);i++)\
{\
  if(sptr[i]=='.'&&!iflag)\
  {\
    iflag++;\
  }\
  else if(sptr[i]=='.'&&iflag)\
  {\
    strcpy(error,"Invalid Y-coordinate for centre");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid Y-coordinate for centre");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
XtFree(strptr);\
\
/***** Check Rmin ********************************************************/\
\
strptr=XmTextFieldGetString(rminField3);\
sptr=stripws(strptr);\
\
dmin=atof(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Minimum radius not specified");\
  XtFree(strptr);\
  return 0;\
}\
\
iflag=0;\
for(i=0;i<strlen(sptr);i++)\
{\
  if(sptr[i]=='.'&&!iflag)\
  {\
    iflag++;\
  }\
  else if(sptr[i]=='.'&&iflag)\
  {\
    strcpy(error,"Invalid minimum radius");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid minimum radius");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
if(dmin<0.)\
{\
  strcpy(error,"Invalid minimum radius");\
  XtFree(strptr);\
  return 0;\
}\
\
XtFree(strptr);\
\
/***** Check Rmax ********************************************************/\
\
strptr=XmTextFieldGetString(rmaxField3);\
sptr=stripws(strptr);\
\
dmax=atof(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Maximum radius not specified");\
  XtFree(strptr);\
  return 0;\
}\
\
iflag=0;\
for(i=0;i<strlen(sptr);i++)\
{\
  if(sptr[i]=='.'&&!iflag)\
  {\
    iflag++;\
  }\
  else if(sptr[i]=='.'&&iflag)\
  {\
    strcpy(error,"Invalid maximum radius");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid maximum radius");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
if(dmax<=dmin)\
{\
  strcpy(error,"Invalid maximum radius");\
  XtFree(strptr);\
  return 0;\
}\
\
XtFree(strptr);\
\
/***** Check lowest value ***************************************************/\
\
strptr=XmTextFieldGetString(lowvalField3);\
sptr=stripws(strptr);\
\
lowval=atof(sptr);\
\
if(strlen(sptr)==0)\
{\
  lowval=0.;\
}\
\
iflag=0;\
for(i=0;i<strlen(sptr);i++)\
{\
  if(sptr[i]=='.'&&!iflag)\
  {\
    iflag++;\
  }\
  else if(sptr[i]=='.'&&iflag)\
  {\
    strcpy(error,"Pixel value to discard is invalid");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Pixel value to discard is invalid");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
XtFree(strptr);\
\
/***** Check smoothing function size *************************************/\
\
if(!strncmp(funcopt,"boxca",5))\
{\
  strptr=XmTextFieldGetString(fwhmField);\
  sptr=stripws(strptr);\
\
  pwid=atoi(sptr);\
\
  if(strlen(sptr)==0)\
  {\
    strcpy(error,"Box car size in X not specified");\
    XtFree(strptr);\
    return 0;\
  }\
\
  iflag=0;\
  for(i=0;i<strlen(sptr);i++)\
  {\
    if(sptr[i]=='.'&&!iflag)\
    {\
      iflag++;\
    }\
    else if(sptr[i]=='.'&&iflag)\
    {\
      strcpy(error,"Invalid box car size in X");\
      XtFree(strptr);\
      return 0;\
    }\
    else if(!isdigit(sptr[i]))\
    {\
      strcpy(error,"Invalid box car size in X");\
      XtFree(strptr);\
      return 0;\
    }\
  }\
\
  if(pwid<=0)\
  {\
    strcpy(error,"Invalid box car size in X");\
    XtFree(strptr);\
    return 0;\
  }\
\
  XtFree(strptr);\
\
  strptr=XmTextFieldGetString(yboxcarField);\
  sptr=stripws(strptr);\
\
  rwid=atoi(sptr);\
\
  if(strlen(sptr)==0)\
  {\
    strcpy(error,"Box car size in Y not specified");\
    XtFree(strptr);\
    return 0;\
  }\
\
  iflag=0;\
  for(i=0;i<strlen(sptr);i++)\
  {\
    if(sptr[i]=='.'&&!iflag)\
    {\
      iflag++;\
    }\
    else if(sptr[i]=='.'&&iflag)\
    {\
      strcpy(error,"Invalid box car size in Y");\
      XtFree(strptr);\
      return 0;\
    }\
    else if(!isdigit(sptr[i]))\
    {\
      strcpy(error,"Invalid box car size in Y");\
      XtFree(strptr);\
      return 0;\
    }\
  }\
\
  if(rwid<=0)\
  {\
    strcpy(error,"Invalid box car size in Y");\
    XtFree(strptr);\
    return 0;\
  }\
\
  if(pwid*rwid>maxfunc)\
  {\
    sprintf(error,"Box car size too large (max %d)",maxfunc);\
    XtFree(strptr);\
    return 0;\
  }\
\
  XtFree(strptr);\
\
}\
else if(!strncmp(funcopt,"gauss",5))\
{\
  strptr=XmTextFieldGetString(fwhmField);\
  sptr=stripws(strptr);\
\
  pwid=atoi(sptr);\
\
  if(strlen(sptr)==0)\
  {\
    strcpy(error,"Gaussian FWHM not specified");\
    XtFree(strptr);\
    return 0;\
  }\
\
  iflag=0;\
  for(i=0;i<strlen(sptr);i++)\
  {\
    if(sptr[i]=='.'&&!iflag)\
    {\
      iflag++;\
    }\
    else if(sptr[i]=='.'&&iflag)\
    {\
      strcpy(error,"Invalid gaussian FWHM");\
      XtFree(strptr);\
      return 0;\
    }\
    else if(!isdigit(sptr[i]))\
    {\
      strcpy(error,"Invalid gaussian FWHM");\
      XtFree(strptr);\
      return 0;\
    }\
  }\
\
  if(pwid<=0)\
  {\
    strcpy(error,"Invalid gaussian FWHM");\
    XtFree(strptr);\
    return 0;\
  }\
\
  if(pwid*pwid>maxfunc)\
  {\
    sprintf(error,"Gaussian FWHM too large (max %d)",(int)(pow( (double) maxfunc, 0.5)));\
    XtFree(strptr);\
    return 0;\
  }\
\
  XtFree(strptr);\
}\
\
/***** Check number of cycles ********************************************/\
\
strptr=XmTextFieldGetString(cyclesField);\
sptr=stripws(strptr);\
\
ncycles=atoi(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Number of cycles not specified");\
  XtFree(strptr);\
  return 0;\
}\
\
iflag=0;\
for(i=0;i<strlen(sptr);i++)\
{\
  if(sptr[i]=='.'&&!iflag)\
  {\
    iflag++;\
  }\
  else if(sptr[i]=='.'&&iflag)\
  {\
    strcpy(error,"Invalid number of cycles");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid number of cycles");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
if(ncycles<=0)\
{\
  strcpy(error,"Invalid number of cycles");\
  XtFree(strptr);\
  return 0;\
}\
\
XtFree(strptr);\
\
/***** Check whether to smooth at edge ***********************************/\
\
if(XmToggleButtonGetState(edgeButton))\
  doedge=True;\
else\
  doedge=False;\
\
/***** If no smoothing at edge, check other options **********************/\
\
if(!doedge)\
{\
\
/***** Check input BSL filename ******************************************/\
\
  strptr=XmTextGetString(backgroundField);\
  sptr=stripws(strptr);\
\
  if(!mainWS_CheckInFile(mainWS,&UxEnv,sptr,error,False,True))\
  {\
    XtFree(strptr);\
    return 0;\
  }\
\
/***** Convert characters in output filename to uppercase ****************/\
\
  if((pptr=strrchr(sptr,(int)'/'))==NULL)\
    pptr=sptr;\
  else\
    pptr++;\
\
  for(i=0;i<=strlen(pptr);i++)\
  {\
    if(islower((int)pptr[i]))\
    pptr[i]=toupper((int)pptr[i]);\
  }\
\
  sInFile=(char*)strdup(sptr);\
  XmTextSetString(backgroundField,sptr);\
  XmTextSetInsertionPosition(backgroundField,strlen(sptr));\
  XtFree(strptr);\
\
/***** Check frame number ************************************************/\
\
strptr=XmTextFieldGetString(frameField);\
sptr=stripws(strptr);\
\
frame=atoi(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Frame of input file not specified");\
  XtFree(strptr);\
  return 0;\
}\
\
iflag=0;\
for(i=0;i<strlen(sptr);i++)\
{\
  if(sptr[i]=='.'&&!iflag)\
  {\
    iflag++;\
  }\
  else if(sptr[i]=='.'&&iflag)\
  {\
    strcpy(error,"Invalid input file frame");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid input file frame");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
if(frame<=0)\
{\
  strcpy(error,"Invalid input file frame");\
  XtFree(strptr);\
  return 0;\
}\
\
binary=(char*)malloc(120*sizeof(char));\
irc=readheader(sInFile,binary,ispec,filenum,&npixel,&nraster,&nframes,&fendian,&dtype);\
\
if(frame>nframes)\
{\
  strcpy(error,"Input file frame does not exist");\
  XtFree(strptr);\
  return 0;\
}\
\
free(binary);\
XtFree(strptr);\
\
/***** Check whether to merge with imported background *******************/\
\
  if(XmToggleButtonGetState(mergeButton))\
    merge=True;\
  else\
    merge=False;\
\
/***** If merging, check other options ***********************************/\
\
  if(merge)\
  {\
\
/****** Check smoothing factor *******************************************/\
\
    strptr=XmTextFieldGetString(smoothField3);\
    sptr=stripws(strptr);\
\
    smoo=atof(sptr);\
\
    if(strlen(sptr)==0)\
    {\
      strcpy(error,"Smoothing factor not specified");\
      XtFree(strptr);\
      return 0;\
    }\
\
    if(smoo<0.)\
    {\
      strcpy(error,"Invalid smoothing factor");\
      XtFree(strptr);\
      return 0;\
    }\
\
    iflag=0;\
    for(i=0;i<strlen(sptr);i++)\
    {\
      if(sptr[i]=='.'&&!iflag)\
      {\
        iflag++;\
      }\
      else if(sptr[i]=='.'&&iflag)\
      {\
        strcpy(error,"Invalid smoothing factor");\
        XtFree(strptr);\
        return 0;\
      }\
      else if(!isdigit(sptr[i]))\
      {\
        strcpy(error,"Invalid smoothing factor");\
        XtFree(strptr);\
        return 0;\
      }\
    }\
\
    XtFree(strptr);\
\
/***** Check tension factor **********************************************/\
\
    strptr=XmTextFieldGetString(tensionField3);\
    sptr=stripws(strptr);\
\
    tens=atof(sptr);\
\
    if(strlen(sptr)==0)\
    {\
      strcpy(error,"Tension factor not specified");\
      XtFree(strptr);\
      return 0;\
    }\
\
    if(tens<0.)\
    {\
      strcpy(error,"Invalid tension factor");\
      XtFree(strptr);\
      return 0;\
    }\
\
    iflag=0;\
    for(i=0;i<strlen(sptr);i++)\
    {\
      if(sptr[i]=='.'&&!iflag)\
      {\
        iflag++;\
      }\
      else if(sptr[i]=='.'&&iflag)\
      {\
        strcpy(error,"Invalid tension factor");\
        XtFree(strptr);\
        return 0;\
      }\
      else if(!isdigit(sptr[i]))\
      {\
        strcpy(error,"Invalid tension factor");\
        XtFree(strptr);\
        return 0;\
      }\
    }\
\
    XtFree(strptr);\
\
/***** Check weight of imported background **********************************/\
\
    strptr=XmTextFieldGetString(weightField);\
    sptr=stripws(strptr);\
\
    weight=atof(sptr);\
\
    if(strlen(sptr)==0)\
    {\
      strcpy(error,"Weight of imported background not specified");\
      XtFree(strptr);\
      return 0;\
    }\
\
    if(weight<0.)\
    {\
      strcpy(error,"Invalid weight for imported background");\
      XtFree(strptr);\
      return 0;\
    }\
\
    iflag=0;\
    for(i=0;i<strlen(sptr);i++)\
    {\
      if(sptr[i]=='.'&&!iflag)\
      {\
        iflag++;\
      }\
      else if(sptr[i]=='.'&&iflag)\
      {\
        strcpy(error,"Invalid weight for imported background");\
        XtFree(strptr);\
        return 0;\
      }\
      else if(!isdigit(sptr[i]))\
      {\
        strcpy(error,"Invalid weight for imported background");\
        XtFree(strptr);\
        return 0;\
      }\
    }\
\
    XtFree(strptr);\
\
  }\
}\
\
/***** Check output BSL filename *****************************************/\
\
strptr=XmTextGetString(outfileField3);\
sptr=stripws(strptr);\
\
if(!mainWS_CheckOutFile(mainWS,&UxEnv,sptr,error,1))\
{\
  XtFree(strptr);\
  return 0;\
}\
\
/***** Convert characters in output filename to uppercase ****************/\
\
if((pptr=strrchr(sptr,(int)'/'))==NULL)\
  pptr=sptr;\
else\
  pptr++;\
\
for(i=0;i<=strlen(pptr);i++)\
{\
  if(islower((int)pptr[i]))\
  pptr[i]=toupper((int)pptr[i]);\
}\
\
sOutFile=(char*)strdup(sptr);\
XmTextSetString(outfileField3,sptr);\
XmTextSetInsertionPosition(outfileField3,strlen(sptr));\
XtFree(strptr);\
\
CyclesParams_setOutFile(CycleParam,&UxEnv,sOutFile);\
\
/*************************************************************************/\
\
return 1;\
\
#endif
*BackSmoothParams_getParams.methodSpec: virtual
*BackSmoothParams_getParams.accessSpec: public
*BackSmoothParams_getParams.arguments: error
*BackSmoothParams_getParams.error.def: "char", "*%error%"

*BackSmoothParams.static: true
*BackSmoothParams.name: BackSmoothParams
*BackSmoothParams.parent: NO_PARENT
*BackSmoothParams.parentExpression: UxParent
*BackSmoothParams.defaultShell: topLevelShell
*BackSmoothParams.isCompound: "true"
*BackSmoothParams.compoundIcon: "bboardD.xpm"
*BackSmoothParams.compoundName: "bBoard_Dialog"
*BackSmoothParams.x: 393
*BackSmoothParams.y: 12
*BackSmoothParams.unitType: "pixels"
*BackSmoothParams.dialogStyle: "dialog_full_application_modal"
*BackSmoothParams.dialogTitle: "Smoothed background"
*BackSmoothParams.autoUnmanage: "false"

*label28.class: label
*label28.static: true
*label28.name: label28
*label28.parent: BackSmoothParams
*label28.isCompound: "true"
*label28.compoundIcon: "label.xpm"
*label28.compoundName: "label_"
*label28.x: 10
*label28.y: 90
*label28.labelString: "Pattern limits :"
*label28.fontList: "9x15"

*label29.class: label
*label29.static: true
*label29.name: label29
*label29.parent: BackSmoothParams
*label29.isCompound: "true"
*label29.compoundIcon: "label.xpm"
*label29.compoundName: "label_"
*label29.x: 10
*label29.y: 186
*label29.labelString: "Smoothing function :"
*label29.fontList: "9x15"

*smoothLabel3.class: label
*smoothLabel3.static: true
*smoothLabel3.name: smoothLabel3
*smoothLabel3.parent: BackSmoothParams
*smoothLabel3.isCompound: "true"
*smoothLabel3.compoundIcon: "label.xpm"
*smoothLabel3.compoundName: "label_"
*smoothLabel3.x: 10
*smoothLabel3.y: 579
*smoothLabel3.labelString: "Smoothing factor:"
*smoothLabel3.sensitive: "true"
*smoothLabel3.fontList: "9x15"

*tensionLabel3.class: label
*tensionLabel3.static: true
*tensionLabel3.name: tensionLabel3
*tensionLabel3.parent: BackSmoothParams
*tensionLabel3.isCompound: "true"
*tensionLabel3.compoundIcon: "label.xpm"
*tensionLabel3.compoundName: "label_"
*tensionLabel3.x: 10
*tensionLabel3.y: 621
*tensionLabel3.labelString: "Tension factor:"
*tensionLabel3.sensitive: "true"
*tensionLabel3.fontList: "9x15"

*rmaxField3.class: textField
*rmaxField3.static: true
*rmaxField3.name: rmaxField3
*rmaxField3.parent: BackSmoothParams
*rmaxField3.isCompound: "true"
*rmaxField3.compoundIcon: "textfield.xpm"
*rmaxField3.compoundName: "text_Field"
*rmaxField3.x: 268
*rmaxField3.y: 85
*rmaxField3.width: 80
*rmaxField3.fontList: "9x15"

*yboxcarField.class: textField
*yboxcarField.static: true
*yboxcarField.name: yboxcarField
*yboxcarField.parent: BackSmoothParams
*yboxcarField.isCompound: "true"
*yboxcarField.compoundIcon: "textfield.xpm"
*yboxcarField.compoundName: "text_Field"
*yboxcarField.x: 273
*yboxcarField.y: 241
*yboxcarField.width: 50
*yboxcarField.fontList: "9x15"

*xboxcarField.class: textField
*xboxcarField.static: true
*xboxcarField.name: xboxcarField
*xboxcarField.parent: BackSmoothParams
*xboxcarField.isCompound: "true"
*xboxcarField.compoundIcon: "textfield.xpm"
*xboxcarField.compoundName: "text_Field"
*xboxcarField.x: 197
*xboxcarField.y: 241
*xboxcarField.width: 50
*xboxcarField.fontList: "9x15"

*tensionField3.class: textField
*tensionField3.static: true
*tensionField3.name: tensionField3
*tensionField3.parent: BackSmoothParams
*tensionField3.isCompound: "true"
*tensionField3.compoundIcon: "textfield.xpm"
*tensionField3.compoundName: "text_Field"
*tensionField3.x: 197
*tensionField3.y: 617
*tensionField3.width: 50
*tensionField3.text: "1.0"
*tensionField3.sensitive: "true"
*tensionField3.cursorPositionVisible: "true"
*tensionField3.fontList: "9x15"

*smoothField3.class: textField
*smoothField3.static: true
*smoothField3.name: smoothField3
*smoothField3.parent: BackSmoothParams
*smoothField3.isCompound: "true"
*smoothField3.compoundIcon: "textfield.xpm"
*smoothField3.compoundName: "text_Field"
*smoothField3.x: 197
*smoothField3.y: 575
*smoothField3.width: 50
*smoothField3.text: "1.0"
*smoothField3.sensitive: "true"
*smoothField3.cursorPositionVisible: "true"
*smoothField3.fontList: "9x15"

*label35.class: label
*label35.static: true
*label35.name: label35
*label35.parent: BackSmoothParams
*label35.isCompound: "true"
*label35.compoundIcon: "label.xpm"
*label35.compoundName: "label_"
*label35.x: 284
*label35.y: 65
*label35.labelString: "R max"
*label35.fontList: "9x15"

*xboxcarLabel.class: label
*xboxcarLabel.static: true
*xboxcarLabel.name: xboxcarLabel
*xboxcarLabel.parent: BackSmoothParams
*xboxcarLabel.isCompound: "true"
*xboxcarLabel.compoundIcon: "label.xpm"
*xboxcarLabel.compoundName: "label_"
*xboxcarLabel.x: 216
*xboxcarLabel.y: 222
*xboxcarLabel.labelString: "X"
*xboxcarLabel.fontList: "9x15"

*yboxcarLabel.class: label
*yboxcarLabel.static: true
*yboxcarLabel.name: yboxcarLabel
*yboxcarLabel.parent: BackSmoothParams
*yboxcarLabel.isCompound: "true"
*yboxcarLabel.compoundIcon: "label.xpm"
*yboxcarLabel.compoundName: "label_"
*yboxcarLabel.x: 292
*yboxcarLabel.y: 222
*yboxcarLabel.labelString: "Y"
*yboxcarLabel.fontList: "9x15"

*pushButton5.class: pushButton
*pushButton5.static: true
*pushButton5.name: pushButton5
*pushButton5.parent: BackSmoothParams
*pushButton5.isCompound: "true"
*pushButton5.compoundIcon: "push.xpm"
*pushButton5.compoundName: "push_Button"
*pushButton5.x: 10
*pushButton5.y: 833
*pushButton5.width: 91
*pushButton5.height: 33
*pushButton5.labelString: "Run"
*pushButton5.activateCallback: {\
#ifndef DESIGN_TIME\
\
char error[80];\
\
if(BackSmoothParams_getParams(UxThisWidget,&UxEnv,error))\
{\
  mainWS_setBackOutFile(mainWS,&UxEnv,sOutFile);\
  mainWS_setBackInFile(mainWS,&UxEnv,sInFile,frame);\
\
  command("back smooth %s ",funcopt);\
\
  if(!strncmp(funcopt,"boxca",5))\
  {\
    command("%d %d %d %f %f %f %f %f ",\
            pwid,rwid,ncycles,dmin,dmax,xcentre,ycentre,lowval);\
  }\
  else if(!strncmp(funcopt,"gauss",5))\
  {\
    command("%d %d %f %f %f %f %f ",\
            pwid,ncycles,dmin,dmax,xcentre,ycentre,lowval);\
  }\
\
  if(doedge)\
  {\
    command("doedge\n");\
  }\
  else if(merge)\
  {\
    command("merge %f %f %f\n",smoo,tens,weight);\
  }\
  else\
  {\
    command("\n");\
  }\
\
  UxPopdownInterface(UxThisWidget);\
}\
else\
{\
  ErrorMessage_set(ErrMessage,&UxEnv,error);\
  UxPopupInterface(ErrMessage,no_grab);\
}\
\
#endif\
}
*pushButton5.fontList: "9x15"

*pushButton6.class: pushButton
*pushButton6.static: true
*pushButton6.name: pushButton6
*pushButton6.parent: BackSmoothParams
*pushButton6.isCompound: "true"
*pushButton6.compoundIcon: "push.xpm"
*pushButton6.compoundName: "push_Button"
*pushButton6.x: 293
*pushButton6.y: 833
*pushButton6.width: 91
*pushButton6.height: 33
*pushButton6.labelString: "Cancel"
*pushButton6.activateCallback: {\
UxPopdownInterface(UxThisWidget);\
}
*pushButton6.fontList: "9x15"

*label40.class: label
*label40.static: true
*label40.name: label40
*label40.parent: BackSmoothParams
*label40.isCompound: "true"
*label40.compoundIcon: "label.xpm"
*label40.compoundName: "label_"
*label40.x: 10
*label40.y: 36
*label40.labelString: "Pattern centre :"
*label40.fontList: "9x15"

*functionMenu.class: rowColumn
*functionMenu.static: true
*functionMenu.name: functionMenu
*functionMenu.parent: BackSmoothParams
*functionMenu.rowColumnType: "menu_option"
*functionMenu.subMenuId: "optionMenu_p1"
*functionMenu.isCompound: "true"
*functionMenu.compoundIcon: "optionM.xpm"
*functionMenu.compoundName: "option_Menu"
*functionMenu.x: 196
*functionMenu.y: 180
*functionMenu.width: 98
*functionMenu.height: 25

*optionMenu_p1.class: rowColumn
*optionMenu_p1.static: true
*optionMenu_p1.name: optionMenu_p1
*optionMenu_p1.parent: functionMenu
*optionMenu_p1.rowColumnType: "menu_pulldown"

*BoxcarButton.class: pushButton
*BoxcarButton.static: true
*BoxcarButton.name: BoxcarButton
*BoxcarButton.parent: optionMenu_p1
*BoxcarButton.labelString: "Box car"
*BoxcarButton.activateCallback: BackSmoothParams_BoxcarSensitive(BackSmoothParams,&UxEnv,1);\
strcpy(funcopt,"boxca");

*GaussButton.class: pushButton
*GaussButton.static: true
*GaussButton.name: GaussButton
*GaussButton.parent: optionMenu_p1
*GaussButton.labelString: "Gaussian"
*GaussButton.activateCallback: BackSmoothParams_BoxcarSensitive(BackSmoothParams,&UxEnv,0);\
strcpy(funcopt,"gauss");

*boxcarLabel.class: label
*boxcarLabel.static: true
*boxcarLabel.name: boxcarLabel
*boxcarLabel.parent: BackSmoothParams
*boxcarLabel.isCompound: "true"
*boxcarLabel.compoundIcon: "label.xpm"
*boxcarLabel.compoundName: "label_"
*boxcarLabel.x: 10
*boxcarLabel.y: 246
*boxcarLabel.labelString: "Box car size :"
*boxcarLabel.fontList: "9x15"

*fwhmLabel.class: label
*fwhmLabel.static: true
*fwhmLabel.name: fwhmLabel
*fwhmLabel.parent: BackSmoothParams
*fwhmLabel.isCompound: "true"
*fwhmLabel.compoundIcon: "label.xpm"
*fwhmLabel.compoundName: "label_"
*fwhmLabel.x: 10
*fwhmLabel.y: 285
*fwhmLabel.labelString: "Gaussian FWHM :"
*fwhmLabel.fontList: "9x15"

*fwhmField.class: textField
*fwhmField.static: true
*fwhmField.name: fwhmField
*fwhmField.parent: BackSmoothParams
*fwhmField.isCompound: "true"
*fwhmField.compoundIcon: "textfield.xpm"
*fwhmField.compoundName: "text_Field"
*fwhmField.x: 197
*fwhmField.y: 280
*fwhmField.width: 50
*fwhmField.fontList: "9x15"

*edgeButton.class: toggleButton
*edgeButton.static: true
*edgeButton.name: edgeButton
*edgeButton.parent: BackSmoothParams
*edgeButton.isCompound: "true"
*edgeButton.compoundIcon: "toggle.xpm"
*edgeButton.compoundName: "toggle_Button"
*edgeButton.x: 10
*edgeButton.y: 372
*edgeButton.labelString: "Apply smoothing at edge of pattern"
*edgeButton.valueChangedCallback: {\
BackSmoothParams_ImportSensitive(BackSmoothParams,&UxEnv,!XmToggleButtonGetState(UxThisWidget));\
}
*edgeButton.fontList: "9x15"

*backgroundLabel.class: label
*backgroundLabel.static: true
*backgroundLabel.name: backgroundLabel
*backgroundLabel.parent: BackSmoothParams
*backgroundLabel.isCompound: "true"
*backgroundLabel.compoundIcon: "label.xpm"
*backgroundLabel.compoundName: "label_"
*backgroundLabel.x: 10
*backgroundLabel.y: 433
*backgroundLabel.labelString: "Import background :"
*backgroundLabel.fontList: "9x15"

*browseButton.class: pushButton
*browseButton.static: true
*browseButton.name: browseButton
*browseButton.parent: BackSmoothParams
*browseButton.isCompound: "true"
*browseButton.compoundIcon: "push.xpm"
*browseButton.compoundName: "push_Button"
*browseButton.x: 316
*browseButton.y: 428
*browseButton.labelString: "Browse"
*browseButton.marginHeight: 5
*browseButton.marginWidth: 5
*browseButton.activateCallback: {\
FileSelection_set(FileSelect,&UxEnv,&backgroundField,"*000.*","Input file selection",1,1,1,0,1);\
UxPopupInterface(FileSelect,no_grab);\
}
*browseButton.fontList: "9x15"

*separator1.class: separator
*separator1.static: true
*separator1.name: separator1
*separator1.parent: BackSmoothParams
*separator1.width: 375
*separator1.height: 10
*separator1.isCompound: "true"
*separator1.compoundIcon: "sep.xpm"
*separator1.compoundName: "separator_"
*separator1.x: 10
*separator1.y: 162

*label34.class: label
*label34.static: true
*label34.name: label34
*label34.parent: BackSmoothParams
*label34.isCompound: "true"
*label34.compoundIcon: "label.xpm"
*label34.compoundName: "label_"
*label34.x: 185
*label34.y: 65
*label34.labelString: "R min"
*label34.fontList: "9x15"

*rminField3.class: textField
*rminField3.static: true
*rminField3.name: rminField3
*rminField3.parent: BackSmoothParams
*rminField3.isCompound: "true"
*rminField3.compoundIcon: "textfield.xpm"
*rminField3.compoundName: "text_Field"
*rminField3.x: 169
*rminField3.y: 85
*rminField3.width: 80
*rminField3.fontList: "9x15"

*xcentreField3.class: textField
*xcentreField3.static: true
*xcentreField3.name: xcentreField3
*xcentreField3.parent: BackSmoothParams
*xcentreField3.isCompound: "true"
*xcentreField3.compoundIcon: "textfield.xpm"
*xcentreField3.compoundName: "text_Field"
*xcentreField3.x: 169
*xcentreField3.y: 31
*xcentreField3.width: 80
*xcentreField3.fontList: "9x15"

*label39.class: label
*label39.static: true
*label39.name: label39
*label39.parent: BackSmoothParams
*label39.isCompound: "true"
*label39.compoundIcon: "label.xpm"
*label39.compoundName: "label_"
*label39.x: 203
*label39.y: 10
*label39.labelString: "X"
*label39.fontList: "9x15"

*ycentreField3.class: textField
*ycentreField3.static: true
*ycentreField3.name: ycentreField3
*ycentreField3.parent: BackSmoothParams
*ycentreField3.isCompound: "true"
*ycentreField3.compoundIcon: "textfield.xpm"
*ycentreField3.compoundName: "text_Field"
*ycentreField3.x: 268
*ycentreField3.y: 31
*ycentreField3.width: 80
*ycentreField3.fontList: "9x15"

*label41.class: label
*label41.static: true
*label41.name: label41
*label41.parent: BackSmoothParams
*label41.isCompound: "true"
*label41.compoundIcon: "label.xpm"
*label41.compoundName: "label_"
*label41.x: 302
*label41.y: 10
*label41.labelString: "Y"
*label41.fontList: "9x15"

*label42.class: label
*label42.static: true
*label42.name: label42
*label42.parent: BackSmoothParams
*label42.isCompound: "true"
*label42.compoundIcon: "label.xpm"
*label42.compoundName: "label_"
*label42.x: 10
*label42.y: 326
*label42.labelString: "Number of cycles :"
*label42.fontList: "9x15"

*cyclesField.class: textField
*cyclesField.static: true
*cyclesField.name: cyclesField
*cyclesField.parent: BackSmoothParams
*cyclesField.isCompound: "true"
*cyclesField.compoundIcon: "textfield.xpm"
*cyclesField.compoundName: "text_Field"
*cyclesField.x: 197
*cyclesField.y: 321
*cyclesField.width: 50
*cyclesField.text: "5"
*cyclesField.fontList: "9x15"

*weightLabel.class: label
*weightLabel.static: true
*weightLabel.name: weightLabel
*weightLabel.parent: BackSmoothParams
*weightLabel.isCompound: "true"
*weightLabel.compoundIcon: "label.xpm"
*weightLabel.compoundName: "label_"
*weightLabel.x: 10
*weightLabel.y: 664
*weightLabel.labelString: "Weight of imported background:"
*weightLabel.sensitive: "true"
*weightLabel.fontList: "9x15"

*weightField.class: textField
*weightField.static: true
*weightField.name: weightField
*weightField.parent: BackSmoothParams
*weightField.isCompound: "true"
*weightField.compoundIcon: "textfield.xpm"
*weightField.compoundName: "text_Field"
*weightField.x: 297
*weightField.y: 660
*weightField.width: 50
*weightField.text: "0.5"
*weightField.sensitive: "true"
*weightField.cursorPositionVisible: "true"
*weightField.fontList: "9x15"

*mergeButton.class: toggleButton
*mergeButton.static: true
*mergeButton.name: mergeButton
*mergeButton.parent: BackSmoothParams
*mergeButton.isCompound: "true"
*mergeButton.compoundIcon: "toggle.xpm"
*mergeButton.compoundName: "toggle_Button"
*mergeButton.x: 10
*mergeButton.y: 532
*mergeButton.labelString: "Merge backgrounds"
*mergeButton.valueChangedCallback: {\
BackSmoothParams_MergeSensitive(BackSmoothParams,&UxEnv,XmToggleButtonGetState(UxWidget));\
}
*mergeButton.set: "true"
*mergeButton.fontList: "9x15"

*scrolledWindowText1.class: scrolledWindow
*scrolledWindowText1.static: true
*scrolledWindowText1.name: scrolledWindowText1
*scrolledWindowText1.parent: BackSmoothParams
*scrolledWindowText1.scrollingPolicy: "application_defined"
*scrolledWindowText1.scrollBarDisplayPolicy: "static"
*scrolledWindowText1.isCompound: "true"
*scrolledWindowText1.compoundIcon: "scrltext.xpm"
*scrolledWindowText1.compoundName: "scrolled_Text"
*scrolledWindowText1.x: 191
*scrolledWindowText1.y: 429
*scrolledWindowText1.height: 49
*scrolledWindowText1.width: 110

*backgroundField.class: scrolledText
*backgroundField.name.source: public
*backgroundField.static: false
*backgroundField.name: backgroundField
*backgroundField.parent: scrolledWindowText1
*backgroundField.text: ""
*backgroundField.width: 110
*backgroundField.fontList: "9x15"
*backgroundField.height: 32

*label17.class: label
*label17.static: true
*label17.name: label17
*label17.parent: BackSmoothParams
*label17.isCompound: "true"
*label17.compoundIcon: "label.xpm"
*label17.compoundName: "label_"
*label17.x: 10
*label17.y: 719
*label17.labelString: "Output filename:"
*label17.fontList: "9x15"

*scrolledWindowText3.class: scrolledWindow
*scrolledWindowText3.static: true
*scrolledWindowText3.name: scrolledWindowText3
*scrolledWindowText3.parent: BackSmoothParams
*scrolledWindowText3.scrollingPolicy: "application_defined"
*scrolledWindowText3.visualPolicy: "variable"
*scrolledWindowText3.scrollBarDisplayPolicy: "static"
*scrolledWindowText3.isCompound: "true"
*scrolledWindowText3.compoundIcon: "scrltext.xpm"
*scrolledWindowText3.compoundName: "scrolled_Text"
*scrolledWindowText3.x: 191
*scrolledWindowText3.y: 715
*scrolledWindowText3.height: 49
*scrolledWindowText3.width: 110

*outfileField3.class: scrolledText
*outfileField3.name.source: public
*outfileField3.static: false
*outfileField3.name: outfileField3
*outfileField3.parent: scrolledWindowText3
*outfileField3.width: 110
*outfileField3.fontList: "9x15"
*outfileField3.height: 32

*pushButton7.class: pushButton
*pushButton7.static: true
*pushButton7.name: pushButton7
*pushButton7.parent: BackSmoothParams
*pushButton7.isCompound: "true"
*pushButton7.compoundIcon: "push.xpm"
*pushButton7.compoundName: "push_Button"
*pushButton7.x: 316
*pushButton7.y: 714
*pushButton7.labelString: "Browse"
*pushButton7.activateCallback: {\
FileSelection_set(FileSelect,&UxEnv,&outfileField3,"*000.*","Output file selection",0,1,0,0,1);\
UxPopupInterface(FileSelect,no_grab);\
}
*pushButton7.marginWidth: 5
*pushButton7.marginHeight: 5
*pushButton7.fontList: "9x15"

*pushButton8.class: pushButton
*pushButton8.static: true
*pushButton8.name: pushButton8
*pushButton8.parent: BackSmoothParams
*pushButton8.isCompound: "true"
*pushButton8.compoundIcon: "push.xpm"
*pushButton8.compoundName: "push_Button"
*pushButton8.x: 10
*pushButton8.y: 767
*pushButton8.labelString: "Write headers"
*pushButton8.marginWidth: 5
*pushButton8.marginHeight: 5
*pushButton8.activateCallback: {\
headerDialog_popup(header,&UxEnv,sOutFile);\
}
*pushButton8.fontList: "9x15"

*frameLabel.class: label
*frameLabel.static: true
*frameLabel.name: frameLabel
*frameLabel.parent: BackSmoothParams
*frameLabel.isCompound: "true"
*frameLabel.compoundIcon: "label.xpm"
*frameLabel.compoundName: "label_"
*frameLabel.x: 10
*frameLabel.y: 485
*frameLabel.labelString: "Frame number:"
*frameLabel.sensitive: "true"
*frameLabel.fontList: "9x15"

*frameField.class: textField
*frameField.static: true
*frameField.name: frameField
*frameField.parent: BackSmoothParams
*frameField.isCompound: "true"
*frameField.compoundIcon: "textfield.xpm"
*frameField.compoundName: "text_Field"
*frameField.x: 197
*frameField.y: 480
*frameField.width: 50
*frameField.text: "1"
*frameField.sensitive: "true"
*frameField.cursorPositionVisible: "true"
*frameField.fontList: "9x15"

*label1.class: label
*label1.static: true
*label1.name: label1
*label1.parent: BackSmoothParams
*label1.isCompound: "true"
*label1.compoundIcon: "label.xpm"
*label1.compoundName: "label_"
*label1.x: 10
*label1.y: 132
*label1.labelString: "Discard values less than :"
*label1.fontList: "9x15"

*lowvalField3.class: textField
*lowvalField3.static: true
*lowvalField3.name: lowvalField3
*lowvalField3.parent: BackSmoothParams
*lowvalField3.isCompound: "true"
*lowvalField3.compoundIcon: "textfield.xpm"
*lowvalField3.compoundName: "text_Field"
*lowvalField3.x: 268
*lowvalField3.y: 127
*lowvalField3.width: 80
*lowvalField3.text: "0.0"
*lowvalField3.fontList: "9x15"

*separator9.class: separator
*separator9.static: true
*separator9.name: separator9
*separator9.parent: BackSmoothParams
*separator9.width: 375
*separator9.height: 10
*separator9.isCompound: "true"
*separator9.compoundIcon: "sep.xpm"
*separator9.compoundName: "separator_"
*separator9.x: 10
*separator9.y: 518

*separator10.class: separator
*separator10.static: true
*separator10.name: separator10
*separator10.parent: BackSmoothParams
*separator10.width: 375
*separator10.height: 10
*separator10.isCompound: "true"
*separator10.compoundIcon: "sep.xpm"
*separator10.compoundName: "separator_"
*separator10.x: 10
*separator10.y: 696

*separator11.class: separator
*separator11.static: true
*separator11.name: separator11
*separator11.parent: BackSmoothParams
*separator11.width: 375
*separator11.height: 10
*separator11.isCompound: "true"
*separator11.compoundIcon: "sep.xpm"
*separator11.compoundName: "separator_"
*separator11.x: 8
*separator11.y: 809

*separator12.class: separator
*separator12.static: true
*separator12.name: separator12
*separator12.parent: BackSmoothParams
*separator12.width: 375
*separator12.height: 10
*separator12.isCompound: "true"
*separator12.compoundIcon: "sep.xpm"
*separator12.compoundName: "separator_"
*separator12.x: 10
*separator12.y: 405

