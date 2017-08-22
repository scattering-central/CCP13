! UIMX ascii 2.9 key: 1866                                                      

*workingDialog.class: workingDialog
*workingDialog.classinc:
*workingDialog.classspec:
*workingDialog.classmembers:
*workingDialog.classconstructor:
*workingDialog.classdestructor:
*workingDialog.gbldecl: #include <stdio.h>\

*workingDialog.ispecdecl:
*workingDialog.funcdecl: swidget create_workingDialog(swidget UxParent)
*workingDialog.funcname: create_workingDialog
*workingDialog.funcdef: "swidget", "<create_workingDialog>(%)"
*workingDialog.argdecl: swidget UxParent;
*workingDialog.arglist: UxParent
*workingDialog.arglist.UxParent: "swidget", "%UxParent%"
*workingDialog.icode:
*workingDialog.fcode: XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),\
                 XmDIALOG_OK_BUTTON));\
XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),\
                 XmDIALOG_CANCEL_BUTTON));\
XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),\
                 XmDIALOG_HELP_BUTTON));\
return(rtrn);\

*workingDialog.auxdecl:
*workingDialog_popup.class: method
*workingDialog_popup.name: popup
*workingDialog_popup.parent: workingDialog
*workingDialog_popup.methodType: void
*workingDialog_popup.methodArgs: char *msg;\

*workingDialog_popup.methodBody: XtVaSetValues (UxGetWidget (UxThis),\
                   XmNmessageString,\
                   XmStringCreateLtoR (msg, XmSTRING_DEFAULT_CHARSET),\
                   NULL);\
    UxPopupInterface (UxThis, nonexclusive_grab);\

*workingDialog_popup.methodSpec: virtual
*workingDialog_popup.accessSpec: public
*workingDialog_popup.arguments: msg
*workingDialog_popup.msg.def: "char", "*%msg%"

*workingDialog.static: true
*workingDialog.name: workingDialog
*workingDialog.parent: NO_PARENT
*workingDialog.parentExpression: UxParent
*workingDialog.defaultShell: topLevelShell
*workingDialog.msgDialogType: "dialog_working"
*workingDialog.isCompound: "true"
*workingDialog.compoundIcon: "workingD.xpm"
*workingDialog.compoundName: "working_Dialog"
*workingDialog.x: 680
*workingDialog.y: 450
*workingDialog.unitType: "pixels"
*workingDialog.cancelLabelString: ""
*workingDialog.dialogStyle: "dialog_full_application_modal"
*workingDialog.dialogTitle: "Working Dialog"
*workingDialog.helpLabelString: ""
*workingDialog.messageString: "Work in progress..."
*workingDialog.minimizeButtons: "true"
*workingDialog.okLabelString: ""

