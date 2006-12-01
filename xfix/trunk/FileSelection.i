! UIMX ascii 2.9 key: 8536                                                      

*FileSelection.class: fileSelectionBoxDialog
*FileSelection.classinc:
*FileSelection.classspec:
*FileSelection.classmembers:
*FileSelection.classconstructor:
*FileSelection.classdestructor:
*FileSelection.gbldecl: #include <stdio.h>\
#include <string.h>\
#include <stdlib.h>\
#include <unistd.h>\
#include <errno.h>\
#include <Xm/TextF.h>\
#include <Xm/Text.h>\
\
#ifndef DESIGN_TIME\
#include "mainWS.h"\
#include "ErrorMessage.h"\
#endif\
\
extern swidget mainWS;\
extern swidget ErrMessage;\
extern char* stripws(char*);
*FileSelection.ispecdecl: Widget selection,filelist,filtertxt;\
swidget *sw;\
int type,mult,bsl;
*FileSelection.ispeclist: selection, filelist, filtertxt, sw, type, mult, bsl
*FileSelection.ispeclist.selection: "Widget", "%selection%"
*FileSelection.ispeclist.filelist: "Widget", "%filelist%"
*FileSelection.ispeclist.filtertxt: "Widget", "%filtertxt%"
*FileSelection.ispeclist.sw: "swidget", "*%sw%"
*FileSelection.ispeclist.type: "int", "%type%"
*FileSelection.ispeclist.mult: "int", "%mult%"
*FileSelection.ispeclist.bsl: "int", "%bsl%"
*FileSelection.funcdecl: swidget create_FileSelection(swidget UxParent)
*FileSelection.funcname: create_FileSelection
*FileSelection.funcdef: "swidget", "<create_FileSelection>(%)"
*FileSelection.argdecl: swidget UxParent;
*FileSelection.arglist: UxParent
*FileSelection.arglist.UxParent: "swidget", "%UxParent%"
*FileSelection.icode:
*FileSelection.fcode: selection = XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_TEXT);\
filelist  = XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_LIST);\
filtertxt = XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_FILTER_TEXT);\
\
XtUnmanageChild(XmFileSelectionBoxGetChild (UxGetWidget(rtrn),XmDIALOG_HELP_BUTTON));\
\
return(rtrn);\

*FileSelection.auxdecl:
*FileSelection_set.class: method
*FileSelection_set.name: set
*FileSelection_set.parent: FileSelection
*FileSelection_set.methodType: void
*FileSelection_set.methodArgs: swidget *sw1;\
char *Filter1;\
char *title1;\
int mustmatch;\
int editable;\
int type1;\
int mult1;\
int bsl1;\

*FileSelection_set.methodBody: XmString Filter,xms;\
sw=sw1;\
Filter=XmStringCreateSimple(Filter1);\
xms=XmStringCreateSimple(title1);\
type=type1;\
mult=mult1;\
bsl=bsl1;\
\
XtVaSetValues(UxGetWidget(FileSelection),XmNmustMatch,mustmatch,NULL);\
XtVaSetValues(selection,XmNeditable,editable,NULL);\
XtVaSetValues(UxGetWidget(FileSelection),XmNdialogTitle,xms,NULL);\
XtVaSetValues(UxGetWidget(FileSelection),XmNdirMask,Filter,NULL);\
XmStringFree(Filter);\
XmStringFree(xms);
*FileSelection_set.methodSpec: virtual
*FileSelection_set.accessSpec: public
*FileSelection_set.arguments: sw1, Filter1, title1, mustmatch, editable, type1, mult1, bsl1
*FileSelection_set.sw1.def: "swidget", "*%sw1%"
*FileSelection_set.Filter1.def: "char", "*%Filter1%"
*FileSelection_set.title1.def: "char", "*%title1%"
*FileSelection_set.mustmatch.def: "int", "%mustmatch%"
*FileSelection_set.editable.def: "int", "%editable%"
*FileSelection_set.type1.def: "int", "%type1%"
*FileSelection_set.mult1.def: "int", "%mult1%"
*FileSelection_set.bsl1.def: "int", "%bsl1%"

*FileSelection.static: true
*FileSelection.name: FileSelection
*FileSelection.parent: NO_PARENT
*FileSelection.parentExpression: UxParent
*FileSelection.defaultShell: topLevelShell
*FileSelection.dialogType: "dialog_file_selection"
*FileSelection.isCompound: "true"
*FileSelection.compoundIcon: "fileboxD.xpm"
*FileSelection.compoundName: "fileSBox_Dialog"
*FileSelection.unitType: "pixels"
*FileSelection.okCallback: {\
#ifndef DESIGN_TIME\
\
char *sptr,*strptr;\
char error[80];\
int iflag;\
\
iflag=0;\
strcpy(error,"");\
\
strptr=XmTextFieldGetString(selection);\
sptr=stripws(strptr);\
\
if(type==1)\
{\
  if(mainWS_CheckInFile(mainWS,&UxEnv,sptr,error,mult,bsl))\
    iflag=1;\
  else\
    iflag=0;\
}\
else if(type==0)\
{\
  if(mainWS_CheckOutFile(mainWS,&UxEnv,sptr,error,bsl))\
    iflag=1;\
  else\
    iflag=0;\
}\
\
if(iflag)\
{\
  mainWS_FileSelectionOK(mainWS,&UxEnv,sptr,sw);\
  UxPopdownInterface(UxThisWidget);  \
}\
else\
{\
  ErrorMessage_set(ErrMessage,&UxEnv,error);\
  UxPopupInterface(ErrMessage,no_grab);\
}\
 \
XtFree(strptr);\
\
#endif\
}
*FileSelection.dialogStyle: "dialog_primary_application_modal"
*FileSelection.width: 400
*FileSelection.height: 500
*FileSelection.resizePolicy: "resize_none"
*FileSelection.cancelCallback: {\
UxPopdownInterface(UxThisWidget);\
}
*FileSelection.noMatchCallback: {\
ErrorMessage_set(ErrMessage,&UxEnv,"File not found");\
UxPopupInterface(ErrMessage,no_grab);\
\
}

