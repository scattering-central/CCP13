! UIMX ascii 2.9 key: 3684                                                      

*ErrorMessage.class: errorDialog
*ErrorMessage.classinc:
*ErrorMessage.classspec:
*ErrorMessage.classmembers:
*ErrorMessage.classconstructor:
*ErrorMessage.classdestructor:
*ErrorMessage.gbldecl: #include <stdio.h>\

*ErrorMessage.ispecdecl: Widget mlabel;
*ErrorMessage.ispeclist: mlabel
*ErrorMessage.ispeclist.mlabel: "Widget", "%mlabel%"
*ErrorMessage.funcdecl: swidget create_ErrorMessage(swidget UxParent)
*ErrorMessage.funcname: create_ErrorMessage
*ErrorMessage.funcdef: "swidget", "<create_ErrorMessage>(%)"
*ErrorMessage.argdecl: swidget UxParent;
*ErrorMessage.arglist: UxParent
*ErrorMessage.arglist.UxParent: "swidget", "%UxParent%"
*ErrorMessage.icode:
*ErrorMessage.fcode: mlabel=XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_MESSAGE_LABEL);\
\
XtUnmanageChild(XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_CANCEL_BUTTON));\
XtUnmanageChild(XmMessageBoxGetChild(UxGetWidget(rtrn),XmDIALOG_HELP_BUTTON));\
\
return(rtrn);\

*ErrorMessage.auxdecl:
*ErrorMessage_set.class: method
*ErrorMessage_set.name: set
*ErrorMessage_set.parent: ErrorMessage
*ErrorMessage_set.methodType: void
*ErrorMessage_set.methodArgs: char *message;\

*ErrorMessage_set.methodBody: XmString xms;\
xms=XmStringCreateSimple(message);\
XtVaSetValues(mlabel,XmNlabelString,xms,NULL);\
XmStringFree(xms);\

*ErrorMessage_set.methodSpec: virtual
*ErrorMessage_set.accessSpec: public
*ErrorMessage_set.arguments: message
*ErrorMessage_set.message.def: "char", "*%message%"

*ErrorMessage.static: true
*ErrorMessage.name: ErrorMessage
*ErrorMessage.parent: NO_PARENT
*ErrorMessage.parentExpression: UxParent
*ErrorMessage.defaultShell: topLevelShell
*ErrorMessage.msgDialogType: "dialog_error"
*ErrorMessage.isCompound: "true"
*ErrorMessage.compoundIcon: "errorD.xpm"
*ErrorMessage.compoundName: "error_Dialog"
*ErrorMessage.unitType: "pixels"
*ErrorMessage.dialogStyle: "dialog_full_application_modal"
*ErrorMessage.dialogTitle: "Error message"
*ErrorMessage.marginWidth: 20

