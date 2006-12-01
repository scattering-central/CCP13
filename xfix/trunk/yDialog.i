! UIMX ascii 2.9 key: 8640                                                      

*yDialog.class: templateDialog
*yDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
#include "mprintf.h"\

*yDialog.ispecdecl:
*yDialog.funcdecl: swidget create_yDialog(swidget UxParent)
*yDialog.funcname: create_yDialog
*yDialog.funcdef: "swidget", "<create_yDialog>(%)"
*yDialog.argdecl: swidget UxParent;
*yDialog.arglist: UxParent
*yDialog.arglist.UxParent: "swidget", "%UxParent%"
*yDialog.icode:
*yDialog.fcode: return(rtrn);\

*yDialog.auxdecl:
*yDialog_popup.class: method
*yDialog_popup.name: popup
*yDialog_popup.parent: yDialog
*yDialog_popup.methodType: int
*yDialog_popup.methodArgs: char *string;\

*yDialog_popup.methodBody: #include "yDialog_show.c"
*yDialog_popup.methodSpec: virtual
*yDialog_popup.accessSpec: public
*yDialog_popup.arguments: string
*yDialog_popup.string.def: "char", "*%string%"

*yDialog.static: true
*yDialog.name: yDialog
*yDialog.parent: NO_PARENT
*yDialog.parentExpression: UxParent
*yDialog.defaultShell: topLevelShell
*yDialog.width: 290
*yDialog.height: 160
*yDialog.msgDialogType: "dialog_template"
*yDialog.isCompound: "true"
*yDialog.compoundIcon: "templateD.xpm"
*yDialog.compoundName: "template_Dialog"
*yDialog.x: 53
*yDialog.y: 534
*yDialog.unitType: "pixels"
*yDialog.buttonFontList: "8x13bold"
*yDialog.cancelLabelString: "Apply"
*yDialog.dialogTitle: "Y Dialog"
*yDialog.labelFontList: "8x13bold"
*yDialog.okLabelString: "OK"
*yDialog.resizePolicy: "resize_none"
*yDialog.textFontList: "8x13bold"
*yDialog.isResizable: "false"
*yDialog.helpLabelString: "Cancel"
*yDialog.cancelCallback: {\
char *cptr;\
double d1, d2;\
\
cptr  = XmTextFieldGetString (textField1);\
d1 = atof (cptr);\
free (cptr);\
\
cptr = XmTextFieldGetString (textField2);\
d2 = atof (cptr);\
free (cptr);\
\
command ("%g %g\n", d1, d2);\
}
*yDialog.helpCallback: {\
command ("^d\n");\
UxPopdownInterface (UxThisWidget);\
}
*yDialog.okCallback: {\
char *cptr;\
double d1, d2;\
\
cptr  = XmTextFieldGetString (textField1);\
d1 = atof (cptr);\
free (cptr);\
\
cptr = XmTextFieldGetString (textField2);\
d2 = atof (cptr);\
free (cptr);\
\
command ("%g %g\n", d1, d2);\
command ("\n");\
\
UxPopdownInterface (UxThisWidget);\
}
*yDialog.defaultButtonType: "dialog_ok_button"
*yDialog.dialogStyle: "dialog_full_application_modal"
*yDialog.autoUnmanage: "false"

*rowColumn1.class: rowColumn
*rowColumn1.static: true
*rowColumn1.name: rowColumn1
*rowColumn1.parent: yDialog
*rowColumn1.width: 270
*rowColumn1.height: 130
*rowColumn1.isCompound: "true"
*rowColumn1.compoundIcon: "row.xpm"
*rowColumn1.compoundName: "row_Column"
*rowColumn1.x: 0
*rowColumn1.y: 0
*rowColumn1.numColumns: 2
*rowColumn1.packing: "pack_none"

*textField1.class: textField
*textField1.static: true
*textField1.name: textField1
*textField1.parent: rowColumn1
*textField1.width: 70
*textField1.isCompound: "true"
*textField1.compoundIcon: "textfield.xpm"
*textField1.compoundName: "text_Field"
*textField1.x: 130
*textField1.y: 5
*textField1.height: 30
*textField1.text: "1"
*textField1.columns: 14
*textField1.fontList: "8x13bold"
*textField1.isResizable: "false"
*textField1.sensitive: "true"

*label1.class: label
*label1.static: true
*label1.name: label1
*label1.parent: rowColumn1
*label1.isCompound: "true"
*label1.compoundIcon: "label.xpm"
*label1.compoundName: "label_"
*label1.x: 20
*label1.y: 10
*label1.width: 100
*label1.height: 30
*label1.fontList: "8x13bold"
*label1.labelString: "Minimum Y "
*label1.isResizable: "false"
*label1.alignment: "alignment_beginning"

*textField2.class: textField
*textField2.static: true
*textField2.name: textField2
*textField2.parent: rowColumn1
*textField2.width: 70
*textField2.isCompound: "true"
*textField2.compoundIcon: "textfield.xpm"
*textField2.compoundName: "text_Field"
*textField2.x: 130
*textField2.y: 45
*textField2.height: 30
*textField2.text: "1"
*textField2.columns: 14
*textField2.fontList: "8x13bold"
*textField2.isResizable: "false"
*textField2.ancestorSensitive: "true"

*label2.class: label
*label2.static: true
*label2.name: label2
*label2.parent: rowColumn1
*label2.isCompound: "true"
*label2.compoundIcon: "label.xpm"
*label2.compoundName: "label_"
*label2.x: 20
*label2.y: 50
*label2.width: 100
*label2.height: 30
*label2.fontList: "8x13bold"
*label2.labelString: "Maximum Y"
*label2.isResizable: "false"
*label2.alignment: "alignment_beginning"

