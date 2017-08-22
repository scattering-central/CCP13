! UIMX ascii 2.9 key: 3938                                                      

*continueDialog.class: templateDialog
*continueDialog.gbldecl: #include <stdio.h>\
#include "mprintf.h"\

*continueDialog.ispecdecl:
*continueDialog.funcdecl: swidget create_continueDialog(swidget UxParent)
*continueDialog.funcname: create_continueDialog
*continueDialog.funcdef: "swidget", "<create_continueDialog>(%)"
*continueDialog.argdecl: swidget UxParent;
*continueDialog.arglist: UxParent
*continueDialog.arglist.UxParent: "swidget", "%UxParent%"
*continueDialog.icode:
*continueDialog.fcode: return(rtrn);\

*continueDialog.auxdecl:
*continueDialog.static: true
*continueDialog.name: continueDialog
*continueDialog.parent: NO_PARENT
*continueDialog.parentExpression: UxParent
*continueDialog.defaultShell: topLevelShell
*continueDialog.width: 300
*continueDialog.height: 120
*continueDialog.msgDialogType: "dialog_template"
*continueDialog.isCompound: "true"
*continueDialog.compoundIcon: "templateD.xpm"
*continueDialog.compoundName: "template_Dialog"
*continueDialog.x: 390
*continueDialog.y: 40
*continueDialog.unitType: "pixels"
*continueDialog.cancelLabelString: "Continue"
*continueDialog.defaultButtonType: "dialog_cancel_button"
*continueDialog.messageString: "Plot next frame of data"
*continueDialog.messageAlignment: "alignment_center"
*continueDialog.dialogTitle: "Continue"
*continueDialog.cancelCallback: {\
command ("\n");\
}
*continueDialog.highlightColor: "white"
*continueDialog.dialogStyle: "dialog_full_application_modal"

