! UIMX ascii 2.9 key: 8041                                                      

*channelDialog.class: templateDialog
*channelDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
#include "mprintf.h"\

*channelDialog.ispecdecl:
*channelDialog.funcdecl: swidget create_channelDialog(swidget UxParent)
*channelDialog.funcname: create_channelDialog
*channelDialog.funcdef: "swidget", "<create_channelDialog>(%)"
*channelDialog.argdecl: swidget UxParent;
*channelDialog.arglist: UxParent
*channelDialog.arglist.UxParent: "swidget", "%UxParent%"
*channelDialog.icode:
*channelDialog.fcode: return(rtrn);\

*channelDialog.auxdecl:
*channelDialog_popup.class: method
*channelDialog_popup.name: popup
*channelDialog_popup.parent: channelDialog
*channelDialog_popup.methodType: int
*channelDialog_popup.methodArgs: char *string;\

*channelDialog_popup.methodBody: #include "channelDialog_show.c"
*channelDialog_popup.methodSpec: virtual
*channelDialog_popup.accessSpec: public
*channelDialog_popup.arguments: string
*channelDialog_popup.string.def: "char", "*%string%"

*channelDialog.static: true
*channelDialog.name: channelDialog
*channelDialog.parent: NO_PARENT
*channelDialog.parentExpression: UxParent
*channelDialog.defaultShell: topLevelShell
*channelDialog.width: 290
*channelDialog.height: 160
*channelDialog.msgDialogType: "dialog_template"
*channelDialog.isCompound: "true"
*channelDialog.compoundIcon: "templateD.xpm"
*channelDialog.compoundName: "template_Dialog"
*channelDialog.x: 340
*channelDialog.y: 118
*channelDialog.unitType: "pixels"
*channelDialog.buttonFontList: "8x13bold"
*channelDialog.cancelLabelString: "Cancel"
*channelDialog.dialogTitle: "Channel Dialog"
*channelDialog.labelFontList: "8x13bold"
*channelDialog.okLabelString: "OK"
*channelDialog.resizePolicy: "resize_none"
*channelDialog.textFontList: "8x13bold"
*channelDialog.isResizable: "false"
*channelDialog.cancelCallback: {\
command ("^d\n");\
UxPopdownInterface (UxThisWidget);\
}
*channelDialog.okCallback: {\
char *cptr;\
int i1, i2;\
\
cptr = (char *) XmTextFieldGetString (textChann1);\
i1 = atoi (cptr);\
free (cptr);\
\
cptr = (char *) XmTextFieldGetString (textChann2);\
i2 = atoi (cptr);\
free (cptr);\
\
command ("%d %d\n", i1, i2);\
\
UxPopdownInterface (UxThisWidget);\
}
*channelDialog.dialogStyle: "dialog_full_application_modal"
*channelDialog.autoUnmanage: "false"

*rowColumn1.class: rowColumn
*rowColumn1.static: true
*rowColumn1.name: rowColumn1
*rowColumn1.parent: channelDialog
*rowColumn1.width: 270
*rowColumn1.height: 130
*rowColumn1.isCompound: "true"
*rowColumn1.compoundIcon: "row.xpm"
*rowColumn1.compoundName: "row_Column"
*rowColumn1.x: 0
*rowColumn1.y: 0
*rowColumn1.numColumns: 2
*rowColumn1.packing: "pack_none"

*textChann1.class: textField
*textChann1.static: true
*textChann1.name: textChann1
*textChann1.parent: rowColumn1
*textChann1.width: 70
*textChann1.isCompound: "true"
*textChann1.compoundIcon: "textfield.xpm"
*textChann1.compoundName: "text_Field"
*textChann1.x: 150
*textChann1.y: 5
*textChann1.height: 30
*textChann1.text: " "
*textChann1.columns: 10
*textChann1.fontList: "8x13bold"
*textChann1.isResizable: "false"
*textChann1.sensitive: "true"

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
*label1.labelString: "First channel"
*label1.isResizable: "false"
*label1.alignment: "alignment_beginning"

*textChann2.class: textField
*textChann2.static: true
*textChann2.name: textChann2
*textChann2.parent: rowColumn1
*textChann2.width: 70
*textChann2.isCompound: "true"
*textChann2.compoundIcon: "textfield.xpm"
*textChann2.compoundName: "text_Field"
*textChann2.x: 150
*textChann2.y: 45
*textChann2.height: 30
*textChann2.text: " "
*textChann2.columns: 10
*textChann2.fontList: "8x13bold"
*textChann2.isResizable: "false"
*textChann2.ancestorSensitive: "true"

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
*label2.labelString: "Last channel"
*label2.isResizable: "false"
*label2.alignment: "alignment_beginning"

