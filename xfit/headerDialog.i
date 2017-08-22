! UIMX ascii 2.9 key: 4503                                                      

*headerDialog.class: templateDialog
*headerDialog.classinc:
*headerDialog.classspec:
*headerDialog.classmembers:
*headerDialog.classconstructor:
*headerDialog.classdestructor:
*headerDialog.gbldecl: #include <stdio.h>\
#include <string.h>\
\
#ifndef DESIGN_TIME\
#include "fitShell.h"\
#endif\

*headerDialog.ispecdecl:
*headerDialog.funcdecl: swidget create_headerDialog(swidget UxParent)
*headerDialog.funcname: create_headerDialog
*headerDialog.funcdef: "swidget", "<create_headerDialog>(%)"
*headerDialog.argdecl: swidget UxParent;
*headerDialog.arglist: UxParent
*headerDialog.arglist.UxParent: "swidget", "%UxParent%"
*headerDialog.icode:
*headerDialog.fcode: return(rtrn);\

*headerDialog.auxdecl:
*headerDialog_popup.class: method
*headerDialog_popup.name: popup
*headerDialog_popup.parent: headerDialog
*headerDialog_popup.methodType: int
*headerDialog_popup.methodArgs: char *filename;\

*headerDialog_popup.methodBody: #include "headerDialog_show.c"
*headerDialog_popup.methodSpec: virtual
*headerDialog_popup.accessSpec: public
*headerDialog_popup.arguments: filename
*headerDialog_popup.filename.def: "char", "*%filename%"

*headerDialog.static: true
*headerDialog.name: headerDialog
*headerDialog.parent: NO_PARENT
*headerDialog.parentExpression: UxParent
*headerDialog.defaultShell: topLevelShell
*headerDialog.width: 700
*headerDialog.height: 230
*headerDialog.msgDialogType: "dialog_template"
*headerDialog.isCompound: "true"
*headerDialog.compoundIcon: "templateD.xpm"
*headerDialog.compoundName: "template_Dialog"
*headerDialog.cancelLabelString: "Cancel"
*headerDialog.labelFontList: "8x13bold"
*headerDialog.okLabelString: "OK"
*headerDialog.dialogTitle: "Header Dialog"
*headerDialog.messageString: "Header file information"
*headerDialog.cancelCallback: {\
fitShell_SetHeaders (UxParent, &UxEnv, NULL, NULL);\
fitShell_continue (UxParent, &UxEnv);\
UxPopdownInterface;\
\
}
*headerDialog.okCallback: {\
char *h1 = NULL, *h2 = NULL;\
\
h1 = (char *) XmTextFieldGetString (textHead1);\
if (!h1) h1 = (char *) strdup ("");\
 \
h2 = (char *) XmTextFieldGetString (textHead2);\
if (!h2) h2 = (char *) strdup ("");\
\
fitShell_SetHeaders (UxParent, &UxEnv, h1, h2);\
fitShell_continue (UxParent, &UxEnv);\
UxPopdownInterface (UxThisWidget);\
}
*headerDialog.dialogStyle: "dialog_primary_application_modal"
*headerDialog.autoUnmanage: "false"
*headerDialog.messageAlignment: "alignment_center"

*rowColumn5.class: rowColumn
*rowColumn5.static: true
*rowColumn5.name: rowColumn5
*rowColumn5.parent: headerDialog
*rowColumn5.width: 340
*rowColumn5.height: 90
*rowColumn5.isCompound: "true"
*rowColumn5.compoundIcon: "row.xpm"
*rowColumn5.compoundName: "row_Column"
*rowColumn5.x: 0
*rowColumn5.y: 10
*rowColumn5.foreground: "white"
*rowColumn5.highlightColor: "white"
*rowColumn5.numColumns: 2
*rowColumn5.packing: "pack_none"
*rowColumn5.labelString: "Output file header information"

*label11.class: label
*label11.static: true
*label11.name: label11
*label11.parent: rowColumn5
*label11.isCompound: "true"
*label11.compoundIcon: "label.xpm"
*label11.compoundName: "label_"
*label11.x: 10
*label11.y: 90
*label11.width: 80
*label11.height: 30
*label11.fontList: "8x13bold"
*label11.labelString: "header 2"
*label11.sensitive: "false"

*label10.class: label
*label10.static: true
*label10.name: label10
*label10.parent: rowColumn5
*label10.isCompound: "true"
*label10.compoundIcon: "label.xpm"
*label10.compoundName: "label_"
*label10.x: 10
*label10.y: 30
*label10.width: 80
*label10.height: 30
*label10.fontList: "8x13bold"
*label10.labelString: "header 1"

*textHead1.class: textField
*textHead1.static: true
*textHead1.name: textHead1
*textHead1.parent: rowColumn5
*textHead1.width: 550
*textHead1.isCompound: "true"
*textHead1.compoundIcon: "textfield.xpm"
*textHead1.compoundName: "text_Field"
*textHead1.x: 100
*textHead1.y: 20
*textHead1.height: 30
*textHead1.columns: 80
*textHead1.isResizable: "false"

*textHead2.class: textField
*textHead2.static: true
*textHead2.name: textHead2
*textHead2.parent: rowColumn5
*textHead2.width: 550
*textHead2.isCompound: "true"
*textHead2.compoundIcon: "textfield.xpm"
*textHead2.compoundName: "text_Field"
*textHead2.x: 100
*textHead2.y: 80
*textHead2.height: 30
*textHead2.columns: 80
*textHead2.isResizable: "false"
*textHead2.text: ""
*textHead2.sensitive: "false"

