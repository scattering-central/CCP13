! UIMX ascii 2.9 key: 8922                                                      

*warningDialog.class: warningDialog
*warningDialog.gbldecl: #include <stdio.h>\
\
extern void Continue ();\
\
\
\

*warningDialog.ispecdecl:
*warningDialog.funcdecl: swidget create_warningDialog(swidget UxParent)
*warningDialog.funcname: create_warningDialog
*warningDialog.funcdef: "swidget", "<create_warningDialog>(%)"
*warningDialog.argdecl: swidget UxParent;
*warningDialog.arglist: UxParent
*warningDialog.arglist.UxParent: "swidget", "%UxParent%"
*warningDialog.icode:
*warningDialog.fcode: XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),\
                 XmDIALOG_OK_BUTTON));\
XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),\
                 XmDIALOG_HELP_BUTTON));\
return(rtrn);\

*warningDialog.auxdecl:
*warningDialog_popup.class: method
*warningDialog_popup.name: popup
*warningDialog_popup.parent: warningDialog
*warningDialog_popup.methodType: int
*warningDialog_popup.methodArgs: char *msg;\

*warningDialog_popup.methodBody: #include "warningDialog_show.c"
*warningDialog_popup.methodSpec: virtual
*warningDialog_popup.accessSpec: public
*warningDialog_popup.arguments: msg
*warningDialog_popup.msg.def: "char", "*%msg%"

*warningDialog.static: true
*warningDialog.name: warningDialog
*warningDialog.parent: NO_PARENT
*warningDialog.parentExpression: UxParent
*warningDialog.defaultShell: topLevelShell
*warningDialog.msgDialogType: "dialog_warning"
*warningDialog.width: 350
*warningDialog.height: 200
*warningDialog.isCompound: "true"
*warningDialog.compoundIcon: "warningD.xpm"
*warningDialog.compoundName: "warning_Dialog"
*warningDialog.x: 360
*warningDialog.y: 100
*warningDialog.unitType: "pixels"
*warningDialog.labelFontList: "8x13bold"
*warningDialog.textFontList: "8x13bold"
*warningDialog.buttonFontList: "8x13bold"
*warningDialog.messageString: "Don't do it again \n "
*warningDialog.dialogTitle: "Warning Dialog"
*warningDialog.okCallback: {\
\
}
*warningDialog.cancelLabelString: "OK"
*warningDialog.defaultButtonType: "dialog_cancel_button"
*warningDialog.autoUnmanage: "false"
*warningDialog.cancelCallback: {\
Continue ();\
UxPopdownInterface (UxThisWidget);\
\
}
*warningDialog.dialogStyle: "dialog_full_application_modal"
*warningDialog.helpLabelString: ""
*warningDialog.minimizeButtons: "true"
*warningDialog.okLabelString: ""

