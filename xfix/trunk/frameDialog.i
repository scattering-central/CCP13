! UIMX ascii 2.9 key: 4961                                                      

*frameDialog.class: bulletinBoardDialog
*frameDialog.classinc:
*frameDialog.classspec:
*frameDialog.classmembers:
*frameDialog.classconstructor:
*frameDialog.classdestructor:
*frameDialog.gbldecl: #include <stdio.h>\
\
#ifndef DESIGN_TIME\
#include "mainWS.h"\
#endif\
\
extern swidget mainWS;
*frameDialog.ispecdecl:
*frameDialog.funcdecl: swidget create_frameDialog(swidget UxParent)
*frameDialog.funcname: create_frameDialog
*frameDialog.funcdef: "swidget", "<create_frameDialog>(%)"
*frameDialog.argdecl: swidget UxParent;
*frameDialog.arglist: UxParent
*frameDialog.arglist.UxParent: "swidget", "%UxParent%"
*frameDialog.icode:
*frameDialog.fcode: return(rtrn);\

*frameDialog.auxdecl:
*frameDialog.static: true
*frameDialog.name: frameDialog
*frameDialog.parent: NO_PARENT
*frameDialog.parentExpression: UxParent
*frameDialog.defaultShell: topLevelShell
*frameDialog.isCompound: "true"
*frameDialog.compoundIcon: "bboardD.xpm"
*frameDialog.compoundName: "bBoard_Dialog"
*frameDialog.x: 430
*frameDialog.y: 360
*frameDialog.unitType: "pixels"
*frameDialog.dialogTitle: "Go to frame ..."
*frameDialog.autoUnmanage: "false"
*frameDialog.dialogStyle: "dialog_full_application_modal"

*label8.class: label
*label8.static: true
*label8.name: label8
*label8.parent: frameDialog
*label8.isCompound: "true"
*label8.compoundIcon: "label.xpm"
*label8.compoundName: "label_"
*label8.x: 11
*label8.y: 26
*label8.labelString: "Go to frame:"
*label8.fontList: "9x15"

*frameField.class: textField
*frameField.static: true
*frameField.name: frameField
*frameField.parent: frameDialog
*frameField.width: 60
*frameField.isCompound: "true"
*frameField.compoundIcon: "textfield.xpm"
*frameField.compoundName: "text_Field"
*frameField.x: 134
*frameField.y: 21
*frameField.fontList: "9x15"

*pushButton1.class: pushButton
*pushButton1.static: true
*pushButton1.name: pushButton1
*pushButton1.parent: frameDialog
*pushButton1.isCompound: "true"
*pushButton1.compoundIcon: "push.xpm"
*pushButton1.compoundName: "push_Button"
*pushButton1.x: 11
*pushButton1.y: 86
*pushButton1.labelString: "Go"
*pushButton1.width: 70
*pushButton1.marginHeight: 5
*pushButton1.marginWidth: 5
*pushButton1.activateCallback: {\
int frameno;\
\
frameno=atoi(XmTextFieldGetString(frameField));\
mainWS_gotoFrame(mainWS,&UxEnv,frameno);\
UxPopdownInterface(frameDialog);\
}
*pushButton1.fontList: "9x15"

*pushButton2.class: pushButton
*pushButton2.static: true
*pushButton2.name: pushButton2
*pushButton2.parent: frameDialog
*pushButton2.isCompound: "true"
*pushButton2.compoundIcon: "push.xpm"
*pushButton2.compoundName: "push_Button"
*pushButton2.x: 124
*pushButton2.y: 86
*pushButton2.width: 70
*pushButton2.labelString: "Cancel"
*pushButton2.marginHeight: 5
*pushButton2.marginWidth: 5
*pushButton2.activateCallback: {\
UxPopdownInterface(frameDialog);\
}
*pushButton2.fontList: "9x15"

