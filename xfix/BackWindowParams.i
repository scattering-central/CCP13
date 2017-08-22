! UIMX ascii 2.9 key: 3609                                                      

*BackWindowParams.class: bulletinBoardDialog
*BackWindowParams.classinc:
*BackWindowParams.classspec:
*BackWindowParams.classmembers:
*BackWindowParams.classconstructor:
*BackWindowParams.classdestructor:
*BackWindowParams.gbldecl: #include <stdio.h>\
#include <string.h>\
#include <stdlib.h>\
#include <ctype.h>\
\
#ifndef DESIGN_TIME\
#include "ErrorMessage.h"\
#include "mainWS.h"\
#include "FileSelection.h"\
#include "headerDialog.h"\
#endif\
\
extern void command(char *, ...);\
extern swidget ErrMessage;\
extern swidget mainWS;\
extern swidget FileSelect;\
extern swidget header;
*BackWindowParams.ispecdecl: double xcentre,ycentre;\
float dmin,dmax,lowval;\
int iwid,jwid,isep,jsep,winlimit;\
float lpix,hpix;\
float smoo,tens;\
char* sOutFile;\
int npix,nrast;
*BackWindowParams.ispeclist: xcentre, ycentre, dmin, dmax, lowval, iwid, jwid, isep, jsep, winlimit, lpix, hpix, smoo, tens, sOutFile, npix, nrast
*BackWindowParams.ispeclist.xcentre: "double", "%xcentre%"
*BackWindowParams.ispeclist.ycentre: "double", "%ycentre%"
*BackWindowParams.ispeclist.dmin: "float", "%dmin%"
*BackWindowParams.ispeclist.dmax: "float", "%dmax%"
*BackWindowParams.ispeclist.lowval: "float", "%lowval%"
*BackWindowParams.ispeclist.iwid: "int", "%iwid%"
*BackWindowParams.ispeclist.jwid: "int", "%jwid%"
*BackWindowParams.ispeclist.isep: "int", "%isep%"
*BackWindowParams.ispeclist.jsep: "int", "%jsep%"
*BackWindowParams.ispeclist.winlimit: "int", "%winlimit%"
*BackWindowParams.ispeclist.lpix: "float", "%lpix%"
*BackWindowParams.ispeclist.hpix: "float", "%hpix%"
*BackWindowParams.ispeclist.smoo: "float", "%smoo%"
*BackWindowParams.ispeclist.tens: "float", "%tens%"
*BackWindowParams.ispeclist.sOutFile: "char", "*%sOutFile%"
*BackWindowParams.ispeclist.npix: "int", "%npix%"
*BackWindowParams.ispeclist.nrast: "int", "%nrast%"
*BackWindowParams.funcdecl: swidget create_BackWindowParams(swidget UxParent)
*BackWindowParams.funcname: create_BackWindowParams
*BackWindowParams.funcdef: "swidget", "<create_BackWindowParams>(%)"
*BackWindowParams.argdecl: swidget UxParent;
*BackWindowParams.arglist: UxParent
*BackWindowParams.arglist.UxParent: "swidget", "%UxParent%"
*BackWindowParams.icode:
*BackWindowParams.fcode: sOutFile="";\
return(rtrn);\

*BackWindowParams.auxdecl:
*BackWindowParams_getParams.class: method
*BackWindowParams_getParams.name: getParams
*BackWindowParams_getParams.parent: BackWindowParams
*BackWindowParams_getParams.methodType: int
*BackWindowParams_getParams.methodArgs: char *error;\

*BackWindowParams_getParams.methodBody: extern char *stripws(char*);\
char *strptr,*sptr;\
int i,iflag;\
char* pptr;\
\
strcpy(error,"");\
\
/***** Check X-coord of centre *******************************************/\
\
strptr=XmTextFieldGetString(xcentreField1);\
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
strptr=XmTextFieldGetString(ycentreField1);\
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
strptr=XmTextFieldGetString(rminField1);\
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
strptr=XmTextFieldGetString(rmaxField1);\
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
strptr=XmTextFieldGetString(lowvalField1);\
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
/***** Check window width ************************************************/\
\
strptr=XmTextFieldGetString(xwinField);\
sptr=stripws(strptr);\
\
iwid=atoi(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Window size in X not specified");\
  XtFree(strptr);\
  return 0;\
}\
\
if(iwid<=0)\
{\
  strcpy(error,"Invalid window size in X");\
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
    strcpy(error,"Invalid window size in X");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid window size in X");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
XtFree(strptr);\
\
/***** Check window height ***********************************************/\
\
strptr=XmTextFieldGetString(ywinField);\
sptr=stripws(strptr);\
\
jwid=atoi(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Window size in Y not specified");\
  XtFree(strptr);\
  return 0;\
}\
\
if(jwid<=0)\
{\
  strcpy(error,"Invalid window size in Y");\
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
    strcpy(error,"Invalid window size in Y");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid window size in Y");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
XtFree(strptr);\
\
if((iwid*2+1)*(jwid*2+1)>winlimit)\
{\
  sprintf(error,"Window size too large (maximum area = %d pixels)",winlimit);\
  XtFree(strptr);\
  return 0;\
}\
\
/***** Check window separation in X **************************************/\
\
strptr=XmTextFieldGetString(xsepField);\
sptr=stripws(strptr);\
\
isep=atoi(sptr);\
\
if(strlen(sptr)==0||isep<=0)\
{\
  isep=iwid;\
  sprintf(sptr,"%d",isep);\
  XmTextSetString(xsepField,sptr);\
  XmTextSetInsertionPosition(xsepField,strlen(sptr));\
}\
else\
{\
  iflag=0;\
  for(i=0;i<strlen(sptr);i++)\
  {\
    if(sptr[i]=='.'&&!iflag)\
    {\
      iflag++;\
    }\
    else if(sptr[i]=='.'&&iflag)\
    {\
      strcpy(error,"Invalid window separation in X");\
      XtFree(strptr);\
      return 0;\
    }\
    else if(!isdigit(sptr[i]))\
    {\
      strcpy(error,"Invalid window separation in X");\
      XtFree(strptr);\
      return 0;\
    }\
  }\
}\
\
XtFree(strptr);\
\
/***** Check window separation in Y **************************************/\
\
strptr=XmTextFieldGetString(ysepField);\
sptr=stripws(strptr);\
\
jsep=atoi(sptr);\
\
if(strlen(sptr)==0||jsep<=0)\
{\
  jsep=jwid;\
  sprintf(sptr,"%d",jsep);\
  XmTextSetString(ysepField,sptr);\
  XmTextSetInsertionPosition(ysepField,strlen(sptr));\
}\
else\
{\
  iflag=0;\
  for(i=0;i<strlen(sptr);i++)\
  {\
    if(sptr[i]=='.'&&!iflag)\
    {\
      iflag++;\
    }\
    else if(sptr[i]=='.'&&iflag)\
    {\
      strcpy(error,"Invalid window separation in Y");\
      XtFree(strptr);\
      return 0;\
    }\
    else if(!isdigit(sptr[i]))\
    {\
      strcpy(error,"Invalid window separation in Y");\
      XtFree(strptr);\
      return 0;\
    }\
  }\
}\
\
XtFree(strptr);\
\
/***** Check pixel range 1 ***********************************************/\
\
strptr=XmTextFieldGetString(lpixField1);\
sptr=stripws(strptr);\
\
lpix=atof(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Pixel range not fully specified");\
  XtFree(strptr);\
  return 0;\
}\
\
if(lpix<0||lpix>100)\
{\
    strcpy(error,"Invalid pixel range");\
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
    strcpy(error,"Invalid pixel range");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid pixel range");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
XtFree(strptr);\
\
/***** Check pixel range 2 ***********************************************/\
\
strptr=XmTextFieldGetString(hpixField1);\
sptr=stripws(strptr);\
\
hpix=atof(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Pixel range not fully specified");\
  XtFree(strptr);\
  return 0;\
}\
\
if(hpix<0||hpix>100||hpix==lpix)\
{\
    strcpy(error,"Invalid pixel range");\
    XtFree(strptr);\
    return 0;\
}\
\
iflag=0;\
\
for(i=0;i<strlen(sptr);i++)\
{\
  if(sptr[i]=='.'&&!iflag)\
  {\
    iflag++;\
  }\
  else if(sptr[i]=='.'&&iflag)\
  {\
    strcpy(error,"Invalid pixel range");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid pixel range");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
XtFree(strptr);\
\
if(hpix<lpix)\
{\
  i=lpix;\
  lpix=hpix;\
  hpix=i;\
}\
\
/***** Check smoothing factor ********************************************/\
\
strptr=XmTextFieldGetString(smoothField1);\
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
strptr=XmTextFieldGetString(tensionField1);\
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
/***** Check output BSL filename *****************************************/\
\
strptr=XmTextGetString(outfileField1);\
sptr=stripws(strptr);\
\
if(!mainWS_CheckOutFile(mainWS,&UxEnv,sptr,error,1))\
{\
  XtFree(strptr);\
  return 0;\
}\
\
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
XmTextSetString(outfileField1,sptr);\
XmTextSetInsertionPosition(outfileField1,strlen(sptr));\
XtFree(strptr);\
\
/*************************************************************************/\
\
return 1;
*BackWindowParams_getParams.methodSpec: virtual
*BackWindowParams_getParams.accessSpec: public
*BackWindowParams_getParams.arguments: error
*BackWindowParams_getParams.error.def: "char", "*%error%"

*BackWindowParams_setCentre.class: method
*BackWindowParams_setCentre.name: setCentre
*BackWindowParams_setCentre.parent: BackWindowParams
*BackWindowParams_setCentre.methodType: void
*BackWindowParams_setCentre.methodArgs: double xcen;\
double ycen;\

*BackWindowParams_setCentre.methodBody: char *xc,*yc;\
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
XtVaSetValues(xcentreField1,XmNvalue,xc,NULL);\
XtVaSetValues(ycentreField1,XmNvalue,yc,NULL);\
\
free(xc);\
free(yc);
*BackWindowParams_setCentre.methodSpec: virtual
*BackWindowParams_setCentre.accessSpec: public
*BackWindowParams_setCentre.arguments: xcen, ycen
*BackWindowParams_setCentre.xcen.def: "double", "%xcen%"
*BackWindowParams_setCentre.ycen.def: "double", "%ycen%"

*BackWindowParams_setSize.class: method
*BackWindowParams_setSize.name: setSize
*BackWindowParams_setSize.parent: BackWindowParams
*BackWindowParams_setSize.methodType: void
*BackWindowParams_setSize.methodArgs: int np;\
int nr;\

*BackWindowParams_setSize.methodBody: char *text1,*text2;\
\
text1=(char*) malloc(80*sizeof(char));\
text2=(char*) malloc(80*sizeof(char));\
\
winlimit=(np/2)*(nr/2);\
\
sprintf(text1,"%d",(int)((float)np/20.));\
sprintf(text2,"%d",(int)((float)nr/20.));\
\
XtVaSetValues(xwinField,XmNvalue,text1,NULL);\
XtVaSetValues(ywinField,XmNvalue,text2,NULL);\
XtVaSetValues(xsepField,XmNvalue,text1,NULL);\
XtVaSetValues(ysepField,XmNvalue,text2,NULL);\
\
free(text1);\
free(text2);\

*BackWindowParams_setSize.methodSpec: virtual
*BackWindowParams_setSize.accessSpec: public
*BackWindowParams_setSize.arguments: np, nr
*BackWindowParams_setSize.np.def: "int", "%np%"
*BackWindowParams_setSize.nr.def: "int", "%nr%"

*BackWindowParams.static: true
*BackWindowParams.name: BackWindowParams
*BackWindowParams.parent: NO_PARENT
*BackWindowParams.parentExpression: UxParent
*BackWindowParams.defaultShell: topLevelShell
*BackWindowParams.isCompound: "true"
*BackWindowParams.compoundIcon: "bboardD.xpm"
*BackWindowParams.compoundName: "bBoard_Dialog"
*BackWindowParams.x: 463
*BackWindowParams.y: 203
*BackWindowParams.unitType: "pixels"
*BackWindowParams.dialogStyle: "dialog_full_application_modal"
*BackWindowParams.dialogTitle: "Roving window background"
*BackWindowParams.autoUnmanage: "false"

*label2.class: label
*label2.static: true
*label2.name: label2
*label2.parent: BackWindowParams
*label2.isCompound: "true"
*label2.compoundIcon: "label.xpm"
*label2.compoundName: "label_"
*label2.x: 15
*label2.y: 216
*label2.labelString: "Window size :"
*label2.fontList: "9x15"

*label3.class: label
*label3.static: true
*label3.name: label3
*label3.parent: BackWindowParams
*label3.isCompound: "true"
*label3.compoundIcon: "label.xpm"
*label3.compoundName: "label_"
*label3.x: 15
*label3.y: 256
*label3.labelString: "Window separation :"
*label3.fontList: "9x15"

*label4.class: label
*label4.static: true
*label4.name: label4
*label4.parent: BackWindowParams
*label4.isCompound: "true"
*label4.compoundIcon: "label.xpm"
*label4.compoundName: "label_"
*label4.x: 15
*label4.y: 307
*label4.labelString: "Pixel range:"
*label4.fontList: "9x15"

*label6.class: label
*label6.static: true
*label6.name: label6
*label6.parent: BackWindowParams
*label6.isCompound: "true"
*label6.compoundIcon: "label.xpm"
*label6.compoundName: "label_"
*label6.x: 15
*label6.y: 372
*label6.labelString: "Smoothing factor:"
*label6.fontList: "9x15"

*label7.class: label
*label7.static: true
*label7.name: label7
*label7.parent: BackWindowParams
*label7.isCompound: "true"
*label7.compoundIcon: "label.xpm"
*label7.compoundName: "label_"
*label7.x: 15
*label7.y: 418
*label7.labelString: "Tension factor:"
*label7.fontList: "9x15"

*ywinField.class: textField
*ywinField.static: true
*ywinField.name: ywinField
*ywinField.parent: BackWindowParams
*ywinField.isCompound: "true"
*ywinField.compoundIcon: "textfield.xpm"
*ywinField.compoundName: "text_Field"
*ywinField.x: 272
*ywinField.y: 211
*ywinField.width: 50
*ywinField.fontList: "9x15"

*xwinField.class: textField
*xwinField.static: true
*xwinField.name: xwinField
*xwinField.parent: BackWindowParams
*xwinField.isCompound: "true"
*xwinField.compoundIcon: "textfield.xpm"
*xwinField.compoundName: "text_Field"
*xwinField.x: 196
*xwinField.y: 211
*xwinField.width: 50
*xwinField.fontList: "9x15"

*ysepField.class: textField
*ysepField.static: true
*ysepField.name: ysepField
*ysepField.parent: BackWindowParams
*ysepField.isCompound: "true"
*ysepField.compoundIcon: "textfield.xpm"
*ysepField.compoundName: "text_Field"
*ysepField.x: 272
*ysepField.y: 251
*ysepField.width: 50
*ysepField.fontList: "9x15"

*xsepField.class: textField
*xsepField.static: true
*xsepField.name: xsepField
*xsepField.parent: BackWindowParams
*xsepField.isCompound: "true"
*xsepField.compoundIcon: "textfield.xpm"
*xsepField.compoundName: "text_Field"
*xsepField.x: 196
*xsepField.y: 251
*xsepField.width: 50
*xsepField.fontList: "9x15"

*hpixField1.class: textField
*hpixField1.static: true
*hpixField1.name: hpixField1
*hpixField1.parent: BackWindowParams
*hpixField1.isCompound: "true"
*hpixField1.compoundIcon: "textfield.xpm"
*hpixField1.compoundName: "text_Field"
*hpixField1.x: 272
*hpixField1.y: 302
*hpixField1.width: 50
*hpixField1.text: "25"
*hpixField1.maxLength: 3
*hpixField1.fontList: "9x15"

*lpixField1.class: textField
*lpixField1.static: true
*lpixField1.name: lpixField1
*lpixField1.parent: BackWindowParams
*lpixField1.isCompound: "true"
*lpixField1.compoundIcon: "textfield.xpm"
*lpixField1.compoundName: "text_Field"
*lpixField1.x: 196
*lpixField1.y: 302
*lpixField1.text: "0"
*lpixField1.maxLength: 3
*lpixField1.width: 50
*lpixField1.fontList: "9x15"

*smoothField1.class: textField
*smoothField1.static: true
*smoothField1.name: smoothField1
*smoothField1.parent: BackWindowParams
*smoothField1.isCompound: "true"
*smoothField1.compoundIcon: "textfield.xpm"
*smoothField1.compoundName: "text_Field"
*smoothField1.x: 196
*smoothField1.y: 365
*smoothField1.width: 50
*smoothField1.text: "1.0"
*smoothField1.fontList: "9x15"

*tensionField1.class: textField
*tensionField1.static: true
*tensionField1.name: tensionField1
*tensionField1.parent: BackWindowParams
*tensionField1.isCompound: "true"
*tensionField1.compoundIcon: "textfield.xpm"
*tensionField1.compoundName: "text_Field"
*tensionField1.x: 196
*tensionField1.y: 411
*tensionField1.width: 50
*tensionField1.text: "1.0"
*tensionField1.fontList: "9x15"

*label9.class: label
*label9.static: true
*label9.name: label9
*label9.parent: BackWindowParams
*label9.isCompound: "true"
*label9.compoundIcon: "label.xpm"
*label9.compoundName: "label_"
*label9.x: 215
*label9.y: 191
*label9.labelString: "X"
*label9.fontList: "9x15"

*label10.class: label
*label10.static: true
*label10.name: label10
*label10.parent: BackWindowParams
*label10.isCompound: "true"
*label10.compoundIcon: "label.xpm"
*label10.compoundName: "label_"
*label10.x: 291
*label10.y: 191
*label10.labelString: "Y"
*label10.fontList: "9x15"

*label11.class: label
*label11.static: true
*label11.name: label11
*label11.parent: BackWindowParams
*label11.isCompound: "true"
*label11.compoundIcon: "label.xpm"
*label11.compoundName: "label_"
*label11.x: 247
*label11.y: 306
*label11.labelString: "%"
*label11.fontList: "9x15"

*label12.class: label
*label12.static: true
*label12.name: label12
*label12.parent: BackWindowParams
*label12.isCompound: "true"
*label12.compoundIcon: "label.xpm"
*label12.compoundName: "label_"
*label12.x: 323
*label12.y: 306
*label12.labelString: "%"
*label12.fontList: "9x15"

*pushButton1.class: pushButton
*pushButton1.static: true
*pushButton1.name: pushButton1
*pushButton1.parent: BackWindowParams
*pushButton1.isCompound: "true"
*pushButton1.compoundIcon: "push.xpm"
*pushButton1.compoundName: "push_Button"
*pushButton1.x: 15
*pushButton1.y: 617
*pushButton1.width: 91
*pushButton1.height: 33
*pushButton1.labelString: "Run"
*pushButton1.activateCallback: {\
char error[80];\
\
if(BackWindowParams_getParams(UxThisWidget,&UxEnv,error))\
{\
  mainWS_setBackOutFile(mainWS,&UxEnv,sOutFile);\
\
  command("back window %d %d %d %d %f %f %f %f %f %f %f %f %f\n",\
           iwid,jwid,isep,jsep,smoo,tens,lpix,hpix,dmin,dmax,xcentre,ycentre,lowval);\
\
  UxPopdownInterface(UxThisWidget);\
}\
else\
{\
  ErrorMessage_set(ErrMessage,&UxEnv,error);\
  UxPopupInterface(ErrMessage,no_grab);\
}\
}
*pushButton1.fontList: "9x15"

*pushButton2.class: pushButton
*pushButton2.static: true
*pushButton2.name: pushButton2
*pushButton2.parent: BackWindowParams
*pushButton2.isCompound: "true"
*pushButton2.compoundIcon: "push.xpm"
*pushButton2.compoundName: "push_Button"
*pushButton2.x: 254
*pushButton2.y: 617
*pushButton2.width: 91
*pushButton2.height: 33
*pushButton2.labelString: "Cancel"
*pushButton2.activateCallback: {\
UxPopdownInterface(UxThisWidget);\
}
*pushButton2.fontList: "9x15"

*label8.class: label
*label8.static: true
*label8.name: label8
*label8.parent: BackWindowParams
*label8.isCompound: "true"
*label8.compoundIcon: "label.xpm"
*label8.compoundName: "label_"
*label8.x: 15
*label8.y: 90
*label8.labelString: "Pattern limits :"
*label8.fontList: "9x15"

*rmaxField1.class: textField
*rmaxField1.static: true
*rmaxField1.name: rmaxField1
*rmaxField1.parent: BackWindowParams
*rmaxField1.isCompound: "true"
*rmaxField1.compoundIcon: "textfield.xpm"
*rmaxField1.compoundName: "text_Field"
*rmaxField1.x: 265
*rmaxField1.y: 85
*rmaxField1.width: 80
*rmaxField1.fontList: "9x15"

*label13.class: label
*label13.static: true
*label13.name: label13
*label13.parent: BackWindowParams
*label13.isCompound: "true"
*label13.compoundIcon: "label.xpm"
*label13.compoundName: "label_"
*label13.x: 280
*label13.y: 65
*label13.labelString: "R max"
*label13.fontList: "9x15"

*label14.class: label
*label14.static: true
*label14.name: label14
*label14.parent: BackWindowParams
*label14.isCompound: "true"
*label14.compoundIcon: "label.xpm"
*label14.compoundName: "label_"
*label14.x: 15
*label14.y: 34
*label14.labelString: "Centre :"
*label14.fontList: "9x15"

*label15.class: label
*label15.static: true
*label15.name: label15
*label15.parent: BackWindowParams
*label15.isCompound: "true"
*label15.compoundIcon: "label.xpm"
*label15.compoundName: "label_"
*label15.x: 189
*label15.y: 65
*label15.labelString: "R min"
*label15.fontList: "9x15"

*rminField1.class: textField
*rminField1.static: true
*rminField1.name: rminField1
*rminField1.parent: BackWindowParams
*rminField1.isCompound: "true"
*rminField1.compoundIcon: "textfield.xpm"
*rminField1.compoundName: "text_Field"
*rminField1.x: 172
*rminField1.y: 85
*rminField1.width: 80
*rminField1.fontList: "9x15"

*label43.class: label
*label43.static: true
*label43.name: label43
*label43.parent: BackWindowParams
*label43.isCompound: "true"
*label43.compoundIcon: "label.xpm"
*label43.compoundName: "label_"
*label43.x: 206
*label43.y: 9
*label43.labelString: "X"
*label43.fontList: "9x15"

*label44.class: label
*label44.static: true
*label44.name: label44
*label44.parent: BackWindowParams
*label44.isCompound: "true"
*label44.compoundIcon: "label.xpm"
*label44.compoundName: "label_"
*label44.x: 299
*label44.y: 9
*label44.labelString: "Y"
*label44.fontList: "9x15"

*separator8.class: separator
*separator8.static: true
*separator8.name: separator8
*separator8.parent: BackWindowParams
*separator8.width: 336
*separator8.height: 10
*separator8.isCompound: "true"
*separator8.compoundIcon: "sep.xpm"
*separator8.compoundName: "separator_"
*separator8.x: 10
*separator8.y: 180

*xcentreField1.class: textField
*xcentreField1.static: true
*xcentreField1.name: xcentreField1
*xcentreField1.parent: BackWindowParams
*xcentreField1.isCompound: "true"
*xcentreField1.compoundIcon: "textfield.xpm"
*xcentreField1.compoundName: "text_Field"
*xcentreField1.x: 172
*xcentreField1.y: 29
*xcentreField1.width: 80
*xcentreField1.cursorPositionVisible: "true"
*xcentreField1.editable: "true"
*xcentreField1.fontList: "9x15"

*ycentreField1.class: textField
*ycentreField1.static: true
*ycentreField1.name: ycentreField1
*ycentreField1.parent: BackWindowParams
*ycentreField1.isCompound: "true"
*ycentreField1.compoundIcon: "textfield.xpm"
*ycentreField1.compoundName: "text_Field"
*ycentreField1.x: 265
*ycentreField1.y: 29
*ycentreField1.width: 80
*ycentreField1.cursorPositionVisible: "true"
*ycentreField1.editable: "true"
*ycentreField1.fontList: "9x15"

*label16.class: label
*label16.static: true
*label16.name: label16
*label16.parent: BackWindowParams
*label16.isCompound: "true"
*label16.compoundIcon: "label.xpm"
*label16.compoundName: "label_"
*label16.x: 15
*label16.y: 479
*label16.labelString: "Output filename:"
*label16.fontList: "9x15"

*pushButton3.class: pushButton
*pushButton3.static: true
*pushButton3.name: pushButton3
*pushButton3.parent: BackWindowParams
*pushButton3.isCompound: "true"
*pushButton3.compoundIcon: "push.xpm"
*pushButton3.compoundName: "push_Button"
*pushButton3.x: 282
*pushButton3.y: 474
*pushButton3.labelString: "Browse"
*pushButton3.activateCallback: {\
FileSelection_set(FileSelect,&UxEnv,&outfileField1,"*000.*","Output file selection",0,1,0,0,1);\
UxPopupInterface(FileSelect,no_grab);\
}
*pushButton3.marginWidth: 5
*pushButton3.marginHeight: 5
*pushButton3.fontList: "9x15"

*scrolledWindowText2.class: scrolledWindow
*scrolledWindowText2.static: true
*scrolledWindowText2.name: scrolledWindowText2
*scrolledWindowText2.parent: BackWindowParams
*scrolledWindowText2.scrollingPolicy: "application_defined"
*scrolledWindowText2.visualPolicy: "variable"
*scrolledWindowText2.scrollBarDisplayPolicy: "static"
*scrolledWindowText2.isCompound: "true"
*scrolledWindowText2.compoundIcon: "scrltext.xpm"
*scrolledWindowText2.compoundName: "scrolled_Text"
*scrolledWindowText2.x: 166
*scrolledWindowText2.y: 473

*outfileField1.class: scrolledText
*outfileField1.name.source: public
*outfileField1.static: false
*outfileField1.name: outfileField1
*outfileField1.parent: scrolledWindowText2
*outfileField1.width: 110
*outfileField1.fontList: "9x15"

*pushButton4.class: pushButton
*pushButton4.static: true
*pushButton4.name: pushButton4
*pushButton4.parent: BackWindowParams
*pushButton4.isCompound: "true"
*pushButton4.compoundIcon: "push.xpm"
*pushButton4.compoundName: "push_Button"
*pushButton4.x: 15
*pushButton4.y: 535
*pushButton4.labelString: "Write headers"
*pushButton4.marginWidth: 5
*pushButton4.marginHeight: 5
*pushButton4.activateCallback: {\
headerDialog_popup(header,&UxEnv,sOutFile);\
}
*pushButton4.fontList: "9x15"

*label5.class: label
*label5.static: true
*label5.name: label5
*label5.parent: BackWindowParams
*label5.isCompound: "true"
*label5.compoundIcon: "label.xpm"
*label5.compoundName: "label_"
*label5.x: 15
*label5.y: 143
*label5.labelString: "Discard values less than :"
*label5.fontList: "9x15"

*lowvalField1.class: textField
*lowvalField1.static: true
*lowvalField1.name: lowvalField1
*lowvalField1.parent: BackWindowParams
*lowvalField1.isCompound: "true"
*lowvalField1.compoundIcon: "textfield.xpm"
*lowvalField1.compoundName: "text_Field"
*lowvalField1.x: 265
*lowvalField1.y: 138
*lowvalField1.text: "0.0"
*lowvalField1.width: 80
*lowvalField1.fontList: "9x15"

*separator1.class: separator
*separator1.static: true
*separator1.name: separator1
*separator1.width: 336
*separator1.height: 10
*separator1.isCompound: "true"
*separator1.compoundIcon: "sep.xpm"
*separator1.compoundName: "separator_"
*separator1.x: 10
*separator1.y: 344
*separator1.parent: BackWindowParams

*separator2.class: separator
*separator2.static: true
*separator2.name: separator2
*separator2.width: 336
*separator2.height: 10
*separator2.isCompound: "true"
*separator2.compoundIcon: "sep.xpm"
*separator2.compoundName: "separator_"
*separator2.x: 10
*separator2.y: 449
*separator2.parent: BackWindowParams

*separator3.class: separator
*separator3.static: true
*separator3.name: separator3
*separator3.width: 336
*separator3.height: 10
*separator3.isCompound: "true"
*separator3.compoundIcon: "sep.xpm"
*separator3.compoundName: "separator_"
*separator3.x: 9
*separator3.y: 582
*separator3.parent: BackWindowParams

