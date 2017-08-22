! UIMX ascii 2.9 key: 9845                                                      

*infoDialog.class: informationDialog
*infoDialog.gbldecl: #include <stdio.h>\
\

*infoDialog.ispecdecl:
*infoDialog.funcdecl: swidget create_infoDialog(swidget UxParent)
*infoDialog.funcname: create_infoDialog
*infoDialog.funcdef: "swidget", "<create_infoDialog>(%)"
*infoDialog.argdecl: swidget UxParent;
*infoDialog.arglist: UxParent
*infoDialog.arglist.UxParent: "swidget", "%UxParent%"
*infoDialog.icode:
*infoDialog.fcode: XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),\
                 XmDIALOG_OK_BUTTON));\
XtUnmanageChild (XmMessageBoxGetChild (UxGetWidget (rtrn),\
                 XmDIALOG_HELP_BUTTON));\
return(rtrn);\

*infoDialog.auxdecl:
*infoDialog_popup.class: method
*infoDialog_popup.name: popup
*infoDialog_popup.parent: infoDialog
*infoDialog_popup.methodType: int
*infoDialog_popup.methodArgs: char *msg;\

*infoDialog_popup.methodBody: #include "infoDialog_show.c"
*infoDialog_popup.methodSpec: virtual
*infoDialog_popup.accessSpec: public
*infoDialog_popup.arguments: msg
*infoDialog_popup.msg.def: "char", "*%msg%"

*infoDialog.static: true
*infoDialog.name: infoDialog
*infoDialog.parent: NO_PARENT
*infoDialog.parentExpression: UxParent
*infoDialog.defaultShell: topLevelShell
*infoDialog.msgDialogType: "dialog_information"
*infoDialog.width: 420
*infoDialog.height: 300
*infoDialog.isCompound: "true"
*infoDialog.compoundIcon: "informD.xpm"
*infoDialog.compoundName: "info_Dialog"
*infoDialog.x: 420
*infoDialog.y: 30
*infoDialog.unitType: "pixels"
*infoDialog.buttonFontList: "8x13bold"
*infoDialog.labelFontList: "8x13bold"
*infoDialog.messageString: "Useful information\n"
*infoDialog.textFontList: "8x13bold"
*infoDialog.cancelCallback: {\
UxPopdownInterface (UxThisWidget);\
}
*infoDialog.okCallback: UxPopdownInterface (UxThisWidget);
*infoDialog.cancelLabelString: "Dismiss"
*infoDialog.okLabelString: ""
*infoDialog.defaultPosition: "true"
*infoDialog.defaultButtonType: "dialog_cancel_button"
*infoDialog.shadowThickness: 0
*infoDialog.minimizeButtons: "true"
*infoDialog.resizeRecursion: "up"
*infoDialog.dialogTitle: "Information"
*infoDialog.helpLabelString: ""

