! UIMX ascii 2.9 key: 8983                                                      

*errorDialog.class: errorDialog
*errorDialog.gbldecl: #include <stdio.h>\
\
extern void Continue ();
*errorDialog.ispecdecl:
*errorDialog.funcdecl: swidget create_errorDialog(swidget UxParent)
*errorDialog.funcname: create_errorDialog
*errorDialog.funcdef: "swidget", "<create_errorDialog>(%)"
*errorDialog.argdecl: swidget UxParent;
*errorDialog.arglist: UxParent
*errorDialog.arglist.UxParent: "swidget", "%UxParent%"
*errorDialog.icode:
*errorDialog.fcode: XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),\
                 XmDIALOG_OK_BUTTON));\
XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),\
                 XmDIALOG_HELP_BUTTON));\
return(rtrn);\

*errorDialog.auxdecl:
*errorDialog_popup.class: method
*errorDialog_popup.name: popup
*errorDialog_popup.parent: errorDialog
*errorDialog_popup.methodType: int
*errorDialog_popup.methodArgs: char *msg;\

*errorDialog_popup.methodBody: #include "errorDialog_show.c"
*errorDialog_popup.methodSpec: virtual
*errorDialog_popup.accessSpec: public
*errorDialog_popup.arguments: msg
*errorDialog_popup.msg.def: "char", "*%msg%"

*errorDialog.static: true
*errorDialog.name: errorDialog
*errorDialog.parent: NO_PARENT
*errorDialog.parentExpression: UxParent
*errorDialog.defaultShell: topLevelShell
*errorDialog.msgDialogType: "dialog_error"
*errorDialog.isCompound: "true"
*errorDialog.compoundIcon: "errorD.xpm"
*errorDialog.compoundName: "error_Dialog"
*errorDialog.x: 950
*errorDialog.y: 630
*errorDialog.unitType: "pixels"
*errorDialog.buttonFontList: "8x13bold"
*errorDialog.dialogTitle: "Error Dialog"
*errorDialog.highlightColor: "white"
*errorDialog.labelFontList: "8x13bold"
*errorDialog.messageString: "Big mistake \n"
*errorDialog.cancelLabelString: "OK"
*errorDialog.dialogStyle: "dialog_full_application_modal"
*errorDialog.okCallback: {\
\
}
*errorDialog.defaultButtonType: "dialog_cancel_button"
*errorDialog.autoUnmanage: "false"
*errorDialog.cancelCallback: {\
Continue ();\
UxPopdownInterface (UxThisWidget);\
\
}

