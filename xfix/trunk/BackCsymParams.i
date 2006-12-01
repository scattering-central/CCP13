! UIMX ascii 2.9 key: 977                                                       

*BackCsymParams.class: bulletinBoardDialog
*BackCsymParams.classinc:
*BackCsymParams.classspec:
*BackCsymParams.classmembers:
*BackCsymParams.classconstructor:
*BackCsymParams.classdestructor:
*BackCsymParams.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
#include <math.h>\
#include <string.h>\
\
#ifndef DESIGN_TIME\
#include "ErrorMessage.h"\
#include "mainWS.h"\
#include "FileSelection.h"\
#include "headerDialog.h"\
#endif\
\
extern void command(char*,...);\
extern swidget ErrMessage;\
extern swidget FileSelect;\
extern swidget header;\
extern swidget mainWS;
*BackCsymParams.ispecdecl: double xcentre,ycentre;\
float dmin,dmax,dinc,lowval;\
float lpix,hpix;\
float smoo,tens;\
char* sOutFile;\
int npix,nrast;\

*BackCsymParams.ispeclist: xcentre, ycentre, dmin, dmax, dinc, lowval, lpix, hpix, smoo, tens, sOutFile, npix, nrast
*BackCsymParams.ispeclist.xcentre: "double", "%xcentre%"
*BackCsymParams.ispeclist.ycentre: "double", "%ycentre%"
*BackCsymParams.ispeclist.dmin: "float", "%dmin%"
*BackCsymParams.ispeclist.dmax: "float", "%dmax%"
*BackCsymParams.ispeclist.dinc: "float", "%dinc%"
*BackCsymParams.ispeclist.lowval: "float", "%lowval%"
*BackCsymParams.ispeclist.lpix: "float", "%lpix%"
*BackCsymParams.ispeclist.hpix: "float", "%hpix%"
*BackCsymParams.ispeclist.smoo: "float", "%smoo%"
*BackCsymParams.ispeclist.tens: "float", "%tens%"
*BackCsymParams.ispeclist.sOutFile: "char", "*%sOutFile%"
*BackCsymParams.ispeclist.npix: "int", "%npix%"
*BackCsymParams.ispeclist.nrast: "int", "%nrast%"
*BackCsymParams.funcdecl: swidget create_BackCsymParams(swidget UxParent)
*BackCsymParams.funcname: create_BackCsymParams
*BackCsymParams.funcdef: "swidget", "<create_BackCsymParams>(%)"
*BackCsymParams.argdecl: swidget UxParent;
*BackCsymParams.arglist: UxParent
*BackCsymParams.arglist.UxParent: "swidget", "%UxParent%"
*BackCsymParams.icode:
*BackCsymParams.fcode: sOutFile="";\
return(rtrn);\

*BackCsymParams.auxdecl:
*BackCsymParams_setCentre.class: method
*BackCsymParams_setCentre.name: setCentre
*BackCsymParams_setCentre.parent: BackCsymParams
*BackCsymParams_setCentre.methodType: void
*BackCsymParams_setCentre.methodArgs: double xcen;\
double ycen;\

*BackCsymParams_setCentre.methodBody: char *xc,*yc;\
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
XtVaSetValues(xcentreField2,XmNvalue,xc,NULL);\
XtVaSetValues(ycentreField2,XmNvalue,yc,NULL);\
\
free(xc);\
free(yc);
*BackCsymParams_setCentre.methodSpec: virtual
*BackCsymParams_setCentre.accessSpec: public
*BackCsymParams_setCentre.arguments: xcen, ycen
*BackCsymParams_setCentre.xcen.def: "double", "%xcen%"
*BackCsymParams_setCentre.ycen.def: "double", "%ycen%"

*BackCsymParams_setSize.class: method
*BackCsymParams_setSize.name: setSize
*BackCsymParams_setSize.parent: BackCsymParams
*BackCsymParams_setSize.methodType: void
*BackCsymParams_setSize.methodArgs: int np;\
int nr;\

*BackCsymParams_setSize.methodBody: npix=np;\
nrast=nr;\

*BackCsymParams_setSize.methodSpec: virtual
*BackCsymParams_setSize.accessSpec: public
*BackCsymParams_setSize.arguments: np, nr
*BackCsymParams_setSize.np.def: "int", "%np%"
*BackCsymParams_setSize.nr.def: "int", "%nr%"

*BackCsymParams_getParams.class: method
*BackCsymParams_getParams.name: getParams
*BackCsymParams_getParams.parent: BackCsymParams
*BackCsymParams_getParams.methodType: int
*BackCsymParams_getParams.methodArgs: char *error;\

*BackCsymParams_getParams.methodBody: extern char *stripws(char*);\
char *strptr,*sptr;\
int i,iflag;\
char* pptr;\
\
strcpy(error,"");\
\
/***** Check X-coord of centre *******************************************/\
\
strptr=XmTextFieldGetString(xcentreField2);\
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
strptr=XmTextFieldGetString(ycentreField2);\
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
strptr=XmTextFieldGetString(rminField2);\
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
strptr=XmTextFieldGetString(rmaxField2);\
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
strptr=XmTextFieldGetString(lowvalField2);\
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
/***** Check binning increment ***************************************/\
\
strptr=XmTextFieldGetString(incField);\
sptr=stripws(strptr);\
\
dinc=atof(sptr);\
\
if(strlen(sptr)==0)\
{\
  strcpy(error,"Binning increment not specified");\
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
    strcpy(error,"Invalid binning increment");\
    XtFree(strptr);\
    return 0;\
  }\
  else if(!isdigit(sptr[i]))\
  {\
    strcpy(error,"Invalid binning increment");\
    XtFree(strptr);\
    return 0;\
  }\
}\
\
if(dinc<=0.)\
{\
    strcpy(error,"Invalid binning increment");\
    XtFree(strptr);\
    return 0;\
}\
\
XtFree(strptr);\
\
/***** Check pixel range 1 ***********************************************/\
\
strptr=XmTextFieldGetString(lpixField2);\
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
strptr=XmTextFieldGetString(hpixField2);\
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
strptr=XmTextFieldGetString(smoothField2);\
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
strptr=XmTextFieldGetString(tensionField2);\
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
strptr=XmTextGetString(outfileField2);\
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
XtFree(strptr);\
\
/*************************************************************************/\
\
return 1;
*BackCsymParams_getParams.methodSpec: virtual
*BackCsymParams_getParams.accessSpec: public
*BackCsymParams_getParams.arguments: error
*BackCsymParams_getParams.error.def: "char", "*%error%"

*BackCsymParams.static: true
*BackCsymParams.name: BackCsymParams
*BackCsymParams.parent: NO_PARENT
*BackCsymParams.parentExpression: UxParent
*BackCsymParams.defaultShell: topLevelShell
*BackCsymParams.isCompound: "true"
*BackCsymParams.compoundIcon: "bboardD.xpm"
*BackCsymParams.compoundName: "bBoard_Dialog"
*BackCsymParams.x: 580
*BackCsymParams.y: 170
*BackCsymParams.unitType: "pixels"
*BackCsymParams.dialogStyle: "dialog_full_application_modal"
*BackCsymParams.dialogTitle: "Circularly symmetric background"
*BackCsymParams.autoUnmanage: "false"

*label22.class: label
*label22.static: true
*label22.name: label22
*label22.parent: BackCsymParams
*label22.isCompound: "true"
*label22.compoundIcon: "label.xpm"
*label22.compoundName: "label_"
*label22.x: 13
*label22.y: 248
*label22.labelString: "Pixel range:"
*label22.fontList: "9x15"

*lpixField2.class: textField
*lpixField2.static: true
*lpixField2.name: lpixField2
*lpixField2.parent: BackCsymParams
*lpixField2.isCompound: "true"
*lpixField2.compoundIcon: "textfield.xpm"
*lpixField2.compoundName: "text_Field"
*lpixField2.x: 214
*lpixField2.y: 243
*lpixField2.text: "0"
*lpixField2.maxLength: 3
*lpixField2.width: 50
*lpixField2.fontList: "9x15"

*label23.class: label
*label23.static: true
*label23.name: label23
*label23.parent: BackCsymParams
*label23.isCompound: "true"
*label23.compoundIcon: "label.xpm"
*label23.compoundName: "label_"
*label23.x: 265
*label23.y: 247
*label23.labelString: "%"
*label23.fontList: "9x15"

*hpixField2.class: textField
*hpixField2.static: true
*hpixField2.name: hpixField2
*hpixField2.parent: BackCsymParams
*hpixField2.isCompound: "true"
*hpixField2.compoundIcon: "textfield.xpm"
*hpixField2.compoundName: "text_Field"
*hpixField2.x: 285
*hpixField2.y: 243
*hpixField2.width: 50
*hpixField2.text: "25"
*hpixField2.maxLength: 3
*hpixField2.fontList: "9x15"

*label24.class: label
*label24.static: true
*label24.name: label24
*label24.parent: BackCsymParams
*label24.isCompound: "true"
*label24.compoundIcon: "label.xpm"
*label24.compoundName: "label_"
*label24.x: 336
*label24.y: 247
*label24.labelString: "%"
*label24.fontList: "9x15"

*label25.class: label
*label25.static: true
*label25.name: label25
*label25.parent: BackCsymParams
*label25.isCompound: "true"
*label25.compoundIcon: "label.xpm"
*label25.compoundName: "label_"
*label25.x: 13
*label25.y: 320
*label25.labelString: "Smoothing factor:"
*label25.fontList: "9x15"

*smoothField2.class: textField
*smoothField2.static: true
*smoothField2.name: smoothField2
*smoothField2.parent: BackCsymParams
*smoothField2.isCompound: "true"
*smoothField2.compoundIcon: "textfield.xpm"
*smoothField2.compoundName: "text_Field"
*smoothField2.x: 214
*smoothField2.y: 314
*smoothField2.width: 50
*smoothField2.text: "1.0"
*smoothField2.fontList: "9x15"

*label26.class: label
*label26.static: true
*label26.name: label26
*label26.parent: BackCsymParams
*label26.isCompound: "true"
*label26.compoundIcon: "label.xpm"
*label26.compoundName: "label_"
*label26.x: 13
*label26.y: 361
*label26.labelString: "Tension factor:"
*label26.fontList: "9x15"

*tensionField2.class: textField
*tensionField2.static: true
*tensionField2.name: tensionField2
*tensionField2.parent: BackCsymParams
*tensionField2.isCompound: "true"
*tensionField2.compoundIcon: "textfield.xpm"
*tensionField2.compoundName: "text_Field"
*tensionField2.x: 214
*tensionField2.y: 356
*tensionField2.width: 50
*tensionField2.text: "1.0"
*tensionField2.fontList: "9x15"

*label27.class: label
*label27.static: true
*label27.name: label27
*label27.parent: BackCsymParams
*label27.isCompound: "true"
*label27.compoundIcon: "label.xpm"
*label27.compoundName: "label_"
*label27.x: 13
*label27.y: 205
*label27.labelString: "Binning increment:"
*label27.fontList: "9x15"

*incField.class: textField
*incField.static: true
*incField.name: incField
*incField.parent: BackCsymParams
*incField.isCompound: "true"
*incField.compoundIcon: "textfield.xpm"
*incField.compoundName: "text_Field"
*incField.x: 214
*incField.y: 201
*incField.width: 50
*incField.text: "1.0"
*incField.fontList: "9x15"

*label16.class: label
*label16.static: true
*label16.name: label16
*label16.parent: BackCsymParams
*label16.isCompound: "true"
*label16.compoundIcon: "label.xpm"
*label16.compoundName: "label_"
*label16.x: 13
*label16.y: 89
*label16.labelString: "Pattern limits :"
*label16.fontList: "9x15"

*rmaxField2.class: textField
*rmaxField2.static: true
*rmaxField2.name: rmaxField2
*rmaxField2.parent: BackCsymParams
*rmaxField2.isCompound: "true"
*rmaxField2.compoundIcon: "textfield.xpm"
*rmaxField2.compoundName: "text_Field"
*rmaxField2.x: 266
*rmaxField2.y: 84
*rmaxField2.width: 80
*rmaxField2.fontList: "9x15"

*label17.class: label
*label17.static: true
*label17.name: label17
*label17.parent: BackCsymParams
*label17.isCompound: "true"
*label17.compoundIcon: "label.xpm"
*label17.compoundName: "label_"
*label17.x: 282
*label17.y: 64
*label17.labelString: "R max"
*label17.fontList: "9x15"

*label18.class: label
*label18.static: true
*label18.name: label18
*label18.parent: BackCsymParams
*label18.isCompound: "true"
*label18.compoundIcon: "label.xpm"
*label18.compoundName: "label_"
*label18.x: 13
*label18.y: 34
*label18.labelString: "Centre :"
*label18.fontList: "9x15"

*label19.class: label
*label19.static: true
*label19.name: label19
*label19.parent: BackCsymParams
*label19.isCompound: "true"
*label19.compoundIcon: "label.xpm"
*label19.compoundName: "label_"
*label19.x: 186
*label19.y: 64
*label19.labelString: "R min"
*label19.fontList: "9x15"

*rminField2.class: textField
*rminField2.static: true
*rminField2.name: rminField2
*rminField2.parent: BackCsymParams
*rminField2.isCompound: "true"
*rminField2.compoundIcon: "textfield.xpm"
*rminField2.compoundName: "text_Field"
*rminField2.x: 170
*rminField2.y: 84
*rminField2.width: 80
*rminField2.fontList: "9x15"

*xcentreField2.class: textField
*xcentreField2.static: true
*xcentreField2.name: xcentreField2
*xcentreField2.parent: BackCsymParams
*xcentreField2.isCompound: "true"
*xcentreField2.compoundIcon: "textfield.xpm"
*xcentreField2.compoundName: "text_Field"
*xcentreField2.x: 170
*xcentreField2.y: 29
*xcentreField2.width: 80
*xcentreField2.fontList: "9x15"

*label20.class: label
*label20.static: true
*label20.name: label20
*label20.parent: BackCsymParams
*label20.isCompound: "true"
*label20.compoundIcon: "label.xpm"
*label20.compoundName: "label_"
*label20.x: 204
*label20.y: 9
*label20.labelString: "X"
*label20.fontList: "9x15"

*ycentreField2.class: textField
*ycentreField2.static: true
*ycentreField2.name: ycentreField2
*ycentreField2.parent: BackCsymParams
*ycentreField2.isCompound: "true"
*ycentreField2.compoundIcon: "textfield.xpm"
*ycentreField2.compoundName: "text_Field"
*ycentreField2.x: 266
*ycentreField2.y: 29
*ycentreField2.width: 80
*ycentreField2.fontList: "9x15"

*label21.class: label
*label21.static: true
*label21.name: label21
*label21.parent: BackCsymParams
*label21.isCompound: "true"
*label21.compoundIcon: "label.xpm"
*label21.compoundName: "label_"
*label21.x: 300
*label21.y: 10
*label21.labelString: "Y"
*label21.fontList: "9x15"

*separator4.class: separator
*separator4.static: true
*separator4.name: separator4
*separator4.parent: BackCsymParams
*separator4.width: 339
*separator4.height: 12
*separator4.isCompound: "true"
*separator4.compoundIcon: "sep.xpm"
*separator4.compoundName: "separator_"
*separator4.x: 11
*separator4.y: 175

*label1.class: label
*label1.static: true
*label1.name: label1
*label1.parent: BackCsymParams
*label1.isCompound: "true"
*label1.compoundIcon: "label.xpm"
*label1.compoundName: "label_"
*label1.x: 13
*label1.y: 426
*label1.labelString: "Output filename:"
*label1.fontList: "9x15"

*scrolledWindowText1.class: scrolledWindow
*scrolledWindowText1.static: true
*scrolledWindowText1.name: scrolledWindowText1
*scrolledWindowText1.parent: BackCsymParams
*scrolledWindowText1.scrollingPolicy: "application_defined"
*scrolledWindowText1.visualPolicy: "variable"
*scrolledWindowText1.scrollBarDisplayPolicy: "static"
*scrolledWindowText1.isCompound: "true"
*scrolledWindowText1.compoundIcon: "scrltext.xpm"
*scrolledWindowText1.compoundName: "scrolled_Text"
*scrolledWindowText1.x: 163
*scrolledWindowText1.y: 422

*outfileField2.class: scrolledText
*outfileField2.name.source: public
*outfileField2.static: false
*outfileField2.name: outfileField2
*outfileField2.parent: scrolledWindowText1
*outfileField2.width: 110
*outfileField2.fontList: "9x15"

*pushButton5.class: pushButton
*pushButton5.static: true
*pushButton5.name: pushButton5
*pushButton5.parent: BackCsymParams
*pushButton5.isCompound: "true"
*pushButton5.compoundIcon: "push.xpm"
*pushButton5.compoundName: "push_Button"
*pushButton5.x: 278
*pushButton5.y: 421
*pushButton5.labelString: "Browse"
*pushButton5.activateCallback: {\
FileSelection_set(FileSelect,&UxEnv,&outfileField2,"*000.*","Output file selection",0,1,0,0,1);\
UxPopupInterface(FileSelect,no_grab);\
}
*pushButton5.marginWidth: 5
*pushButton5.marginHeight: 5
*pushButton5.fontList: "9x15"

*pushButton6.class: pushButton
*pushButton6.static: true
*pushButton6.name: pushButton6
*pushButton6.parent: BackCsymParams
*pushButton6.isCompound: "true"
*pushButton6.compoundIcon: "push.xpm"
*pushButton6.compoundName: "push_Button"
*pushButton6.x: 13
*pushButton6.y: 482
*pushButton6.labelString: "Write headers"
*pushButton6.marginWidth: 5
*pushButton6.marginHeight: 5
*pushButton6.activateCallback: {\
headerDialog_popup(header,&UxEnv,sOutFile);\
}
*pushButton6.fontList: "9x15"

*pushButton7.class: pushButton
*pushButton7.static: true
*pushButton7.name: pushButton7
*pushButton7.parent: BackCsymParams
*pushButton7.isCompound: "true"
*pushButton7.compoundIcon: "push.xpm"
*pushButton7.compoundName: "push_Button"
*pushButton7.x: 13
*pushButton7.y: 558
*pushButton7.width: 91
*pushButton7.height: 33
*pushButton7.labelString: "Run"
*pushButton7.activateCallback: {\
char error[80];\
\
if(BackCsymParams_getParams(UxThisWidget,&UxEnv,error))\
{\
  mainWS_setBackOutFile(mainWS,&UxEnv,sOutFile);\
\
  command("back csym %f %f %f %f %f %f %f %f %f %f\n",\
           dmin,dmax,lpix,hpix,dinc,smoo,tens,xcentre,ycentre,lowval);\
\
  UxPopdownInterface(UxThisWidget);\
}\
else\
{\
  ErrorMessage_set(ErrMessage,&UxEnv,error);\
  UxPopupInterface(ErrMessage,no_grab);\
}\
}
*pushButton7.fontList: "9x15"

*pushButton8.class: pushButton
*pushButton8.static: true
*pushButton8.name: pushButton8
*pushButton8.parent: BackCsymParams
*pushButton8.isCompound: "true"
*pushButton8.compoundIcon: "push.xpm"
*pushButton8.compoundName: "push_Button"
*pushButton8.x: 255
*pushButton8.y: 557
*pushButton8.width: 91
*pushButton8.height: 33
*pushButton8.labelString: "Cancel"
*pushButton8.activateCallback: {\
UxPopdownInterface(UxThisWidget);\
}
*pushButton8.fontList: "9x15"

*label2.class: label
*label2.static: true
*label2.name: label2
*label2.parent: BackCsymParams
*label2.isCompound: "true"
*label2.compoundIcon: "label.xpm"
*label2.compoundName: "label_"
*label2.x: 13
*label2.y: 139
*label2.labelString: "Discard values less than :"
*label2.fontList: "9x15"

*lowvalField2.class: textField
*lowvalField2.static: true
*lowvalField2.name: lowvalField2
*lowvalField2.parent: BackCsymParams
*lowvalField2.isCompound: "true"
*lowvalField2.compoundIcon: "textfield.xpm"
*lowvalField2.compoundName: "text_Field"
*lowvalField2.x: 266
*lowvalField2.y: 134
*lowvalField2.width: 80
*lowvalField2.text: "0.0"
*lowvalField2.fontList: "9x15"

*separator5.class: separator
*separator5.static: true
*separator5.name: separator5
*separator5.width: 339
*separator5.height: 12
*separator5.isCompound: "true"
*separator5.compoundIcon: "sep.xpm"
*separator5.compoundName: "separator_"
*separator5.x: 11
*separator5.y: 289
*separator5.parent: BackCsymParams

*separator6.class: separator
*separator6.static: true
*separator6.name: separator6
*separator6.width: 339
*separator6.height: 12
*separator6.isCompound: "true"
*separator6.compoundIcon: "sep.xpm"
*separator6.compoundName: "separator_"
*separator6.x: 11
*separator6.y: 395
*separator6.parent: BackCsymParams

*separator7.class: separator
*separator7.static: true
*separator7.name: separator7
*separator7.width: 339
*separator7.height: 12
*separator7.isCompound: "true"
*separator7.compoundIcon: "sep.xpm"
*separator7.compoundName: "separator_"
*separator7.x: 11
*separator7.y: 527
*separator7.parent: BackCsymParams

