! UIMX ascii 2.9 key: 242                                                       

*CyclesParams.class: bulletinBoardDialog
*CyclesParams.classinc:
*CyclesParams.classspec:
*CyclesParams.classmembers:
*CyclesParams.classconstructor:
*CyclesParams.classdestructor:
*CyclesParams.gbldecl: #include <stdio.h>\
#include <string.h>\
#include <stdlib.h>\
\
#ifndef DESIGN_TIME\
#include "ErrorMessage.h"\
#include "FileSelection.h"\
#include "headerDialog.h"\
#include "mainWS.h"\
#endif\
\
extern void command(char *,...);\
\
extern swidget ErrMessage;\
extern swidget FileSelect;\
extern swidget header;\
extern swidget mainWS;
*CyclesParams.ispecdecl: int mcycles;\
char* sOutFile;\

*CyclesParams.ispeclist: mcycles, sOutFile
*CyclesParams.ispeclist.mcycles: "int", "%mcycles%"
*CyclesParams.ispeclist.sOutFile: "char", "*%sOutFile%"
*CyclesParams.funcdecl: swidget create_CyclesParams(swidget UxParent)
*CyclesParams.funcname: create_CyclesParams
*CyclesParams.funcdef: "swidget", "<create_CyclesParams>(%)"
*CyclesParams.argdecl: swidget UxParent;
*CyclesParams.arglist: UxParent
*CyclesParams.arglist.UxParent: "swidget", "%UxParent%"
*CyclesParams.icode:
*CyclesParams.fcode: sOutFile="";\
return(rtrn);\

*CyclesParams.auxdecl:
*CyclesParams_GetParams.class: method
*CyclesParams_GetParams.name: GetParams
*CyclesParams_GetParams.parent: CyclesParams
*CyclesParams_GetParams.methodType: int
*CyclesParams_GetParams.methodArgs: char *error;\

*CyclesParams_GetParams.methodBody: #ifndef DESIGN_TIME\
\
extern char *stripws(char*);\
char *strptr,*sptr,*pptr;\
int i,iflag;\
\
strptr=XmTextFieldGetString(cyclesField);\
sptr=stripws(strptr);\
\
mcycles=atoi(sptr);\
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
if(mcycles<=0)\
{\
  strcpy(error,"Invalid number of cycles");\
  XtFree(strptr);\
  return 0;\
}\
\
XtFree(strptr);\
\
/***** Check output BSL filename *****************************************/\
\
strptr=XmTextGetString(outfileField4);\
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
XmTextSetString(outfileField4,sptr);\
XmTextSetInsertionPosition(outfileField4,strlen(sptr));\
XtFree(strptr);\
\
/*************************************************************************/\
\
return 1;\
\
#endif
*CyclesParams_GetParams.methodSpec: virtual
*CyclesParams_GetParams.accessSpec: public
*CyclesParams_GetParams.arguments: error
*CyclesParams_GetParams.error.def: "char", "*%error%"

*CyclesParams_setOutFile.class: method
*CyclesParams_setOutFile.name: setOutFile
*CyclesParams_setOutFile.parent: CyclesParams
*CyclesParams_setOutFile.methodType: void
*CyclesParams_setOutFile.methodArgs: char *sFile;\

*CyclesParams_setOutFile.methodBody: sOutFile=sFile;\
XmTextSetString(outfileField4,sOutFile);\
XmTextSetInsertionPosition(outfileField4,strlen(sOutFile));
*CyclesParams_setOutFile.methodSpec: virtual
*CyclesParams_setOutFile.accessSpec: public
*CyclesParams_setOutFile.arguments: sFile
*CyclesParams_setOutFile.sFile.def: "char", "*%sFile%"

*CyclesParams.static: true
*CyclesParams.name: CyclesParams
*CyclesParams.parent: NO_PARENT
*CyclesParams.parentExpression: UxParent
*CyclesParams.defaultShell: topLevelShell
*CyclesParams.isCompound: "true"
*CyclesParams.compoundIcon: "bboardD.xpm"
*CyclesParams.compoundName: "bBoard_Dialog"
*CyclesParams.x: 150
*CyclesParams.y: 450
*CyclesParams.unitType: "pixels"
*CyclesParams.dialogTitle: "Smoothed background"
*CyclesParams.autoUnmanage: "false"

*label1.class: label
*label1.static: true
*label1.name: label1
*label1.parent: CyclesParams
*label1.isCompound: "true"
*label1.compoundIcon: "label.xpm"
*label1.compoundName: "label_"
*label1.x: 9
*label1.y: 23
*label1.labelString: "Number of extra cycles:"
*label1.fontList: "9x15"

*cyclesField.class: textField
*cyclesField.static: true
*cyclesField.name: cyclesField
*cyclesField.parent: CyclesParams
*cyclesField.width: 50
*cyclesField.isCompound: "true"
*cyclesField.compoundIcon: "textfield.xpm"
*cyclesField.compoundName: "text_Field"
*cyclesField.x: 236
*cyclesField.y: 18
*cyclesField.text: "1"
*cyclesField.fontList: "9x15"

*pushButton1.class: pushButton
*pushButton1.static: true
*pushButton1.name: pushButton1
*pushButton1.parent: CyclesParams
*pushButton1.isCompound: "true"
*pushButton1.compoundIcon: "push.xpm"
*pushButton1.compoundName: "push_Button"
*pushButton1.x: 10
*pushButton1.y: 209
*pushButton1.width: 70
*pushButton1.height: 35
*pushButton1.labelString: "Run"
*pushButton1.marginHeight: 5
*pushButton1.marginWidth: 5
*pushButton1.activateCallback: {\
char error[80];\
\
if(CyclesParams_GetParams(CyclesParams,&UxEnv,error))\
{\
  mainWS_setBackOutFile(mainWS,&UxEnv,sOutFile);\
  command("y\n");\
  command("%d\n",mcycles);\
  UxPopdownInterface(CyclesParams);\
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
*pushButton2.parent: CyclesParams
*pushButton2.isCompound: "true"
*pushButton2.compoundIcon: "push.xpm"
*pushButton2.compoundName: "push_Button"
*pushButton2.x: 294
*pushButton2.y: 209
*pushButton2.labelString: "Cancel"
*pushButton2.marginHeight: 5
*pushButton2.marginWidth: 5
*pushButton2.width: 70
*pushButton2.height: 35
*pushButton2.activateCallback: {\
command ("n\n");\
UxPopdownInterface(CyclesParams);\
}
*pushButton2.fontList: "9x15"

*label17.class: label
*label17.static: true
*label17.name: label17
*label17.parent: CyclesParams
*label17.isCompound: "true"
*label17.compoundIcon: "label.xpm"
*label17.compoundName: "label_"
*label17.x: 10
*label17.y: 89
*label17.labelString: "Output filename:"
*label17.fontList: "9x15"

*scrolledWindowText3.class: scrolledWindow
*scrolledWindowText3.static: true
*scrolledWindowText3.name: scrolledWindowText3
*scrolledWindowText3.parent: CyclesParams
*scrolledWindowText3.scrollingPolicy: "application_defined"
*scrolledWindowText3.visualPolicy: "variable"
*scrolledWindowText3.scrollBarDisplayPolicy: "static"
*scrolledWindowText3.isCompound: "true"
*scrolledWindowText3.compoundIcon: "scrltext.xpm"
*scrolledWindowText3.compoundName: "scrolled_Text"
*scrolledWindowText3.x: 168
*scrolledWindowText3.y: 85

*outfileField4.class: scrolledText
*outfileField4.name.source: public
*outfileField4.static: false
*outfileField4.name: outfileField4
*outfileField4.parent: scrolledWindowText3
*outfileField4.width: 110
*outfileField4.fontList: "9x15"

*pushButton7.class: pushButton
*pushButton7.static: true
*pushButton7.name: pushButton7
*pushButton7.parent: CyclesParams
*pushButton7.isCompound: "true"
*pushButton7.compoundIcon: "push.xpm"
*pushButton7.compoundName: "push_Button"
*pushButton7.x: 296
*pushButton7.y: 84
*pushButton7.labelString: "Browse"
*pushButton7.activateCallback: {\
FileSelection_set(FileSelect,&UxEnv,&outfileField4,"*000.*","Output file selection",0,1,0,0,1);\
UxPopupInterface(FileSelect,no_grab);\
}
*pushButton7.marginWidth: 5
*pushButton7.marginHeight: 5
*pushButton7.fontList: "9x15"

*pushButton8.class: pushButton
*pushButton8.static: true
*pushButton8.name: pushButton8
*pushButton8.parent: CyclesParams
*pushButton8.isCompound: "true"
*pushButton8.compoundIcon: "push.xpm"
*pushButton8.compoundName: "push_Button"
*pushButton8.x: 10
*pushButton8.y: 138
*pushButton8.labelString: "Write headers"
*pushButton8.marginWidth: 5
*pushButton8.marginHeight: 5
*pushButton8.activateCallback: {\
headerDialog_popup(header,&UxEnv,sOutFile);\
}
*pushButton8.fontList: "9x15"

*separator1.class: separator
*separator1.static: true
*separator1.name: separator1
*separator1.parent: CyclesParams
*separator1.width: 365
*separator1.height: 7
*separator1.isCompound: "true"
*separator1.compoundIcon: "sep.xpm"
*separator1.compoundName: "separator_"
*separator1.x: 10
*separator1.y: 64

*separator2.class: separator
*separator2.static: true
*separator2.name: separator2
*separator2.parent: CyclesParams
*separator2.width: 364
*separator2.height: 7
*separator2.isCompound: "true"
*separator2.compoundIcon: "sep.xpm"
*separator2.compoundName: "separator_"
*separator2.x: 10
*separator2.y: 182

