! UIMX ascii 2.9 key: 3872                                                      

*cellDialog.class: templateDialog
*cellDialog.classinc:
*cellDialog.classspec:
*cellDialog.classmembers:
*cellDialog.classconstructor:
*cellDialog.classdestructor:
*cellDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
\
#ifndef DESIGN_TIME\
#include "mainWS.h"\
#endif\
\
#include "mprintf.h"\
\
extern swidget mainWS;\
extern void SetBusyPointer (int);\

*cellDialog.ispecdecl:
*cellDialog.funcdecl: swidget create_cellDialog(swidget UxParent)
*cellDialog.funcname: create_cellDialog
*cellDialog.funcdef: "swidget", "<create_cellDialog>(%)"
*cellDialog.argdecl: swidget UxParent;
*cellDialog.arglist: UxParent
*cellDialog.arglist.UxParent: "swidget", "%UxParent%"
*cellDialog.icode:
*cellDialog.fcode: return(rtrn);\

*cellDialog.auxdecl:
*cellDialog.static: true
*cellDialog.name: cellDialog
*cellDialog.parent: NO_PARENT
*cellDialog.parentExpression: UxParent
*cellDialog.defaultShell: topLevelShell
*cellDialog.width: 370
*cellDialog.height: 400
*cellDialog.msgDialogType: "dialog_template"
*cellDialog.isCompound: "true"
*cellDialog.compoundIcon: "templateD.xpm"
*cellDialog.compoundName: "template_Dialog"
*cellDialog.unitType: "pixels"
*cellDialog.cancelLabelString: "Generate"
*cellDialog.okLabelString: "OK"
*cellDialog.dialogTitle: "Cell Dialog"
*cellDialog.helpLabelString: "Cancel"
*cellDialog.autoUnmanage: "false"
*cellDialog.cancelCallback: {\
char *cptr;\
double a, b, c, alpha, beta, gamma, phix, phiz, dmin, dmax;\
\
cptr = (char *) XmTextFieldGetString (UxGetWidget (spaceGroupText));\
command ("Space %s\n", cptr);\
free (cptr);\
\
cptr = (char *) XmTextFieldGetString (UxGetWidget (aCellText));\
a = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (bCellText));\
b = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (cCellText));\
c = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (alphaCellText));\
alpha = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (betaCellText));\
beta = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (gammaCellText));\
gamma = atof (cptr);\
free (cptr);\
\
command ("Cell %f %f %f %f %f %f\n", a, b, c, alpha, beta, gamma);\
\
\
cptr = (char *) XmTextFieldGetString (UxGetWidget (phiXCellText));\
phix = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (phiZCellText));\
phiz= atof (cptr);\
free (cptr);\
\
command ("Missetting %f %f\n", phix, phiz);\
\
cptr = (char *) XmTextFieldGetString (UxGetWidget (minDCellText));\
dmin = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (maxDCellText));\
dmax = atof (cptr);\
free (cptr);\
\
command ("Generate %f %f\n", dmin, dmax);\
}
*cellDialog.okCallback: {\
char *cptr;\
double a, b, c, alpha, beta, gamma, phix, phiz;\
\
cptr = (char *) XmTextFieldGetString (UxGetWidget (spaceGroupText));\
command ("Space %s\n", cptr);\
free (cptr);\
\
cptr = (char *) XmTextFieldGetString (UxGetWidget (aCellText));\
a = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (bCellText));\
b = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (cCellText));\
c = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (alphaCellText));\
alpha = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (betaCellText));\
beta = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (gammaCellText));\
gamma = atof (cptr);\
free (cptr);\
\
command ("Cell %f %f %f %f %f %f\n", a, b, c, alpha, beta, gamma);\
\
\
cptr = (char *) XmTextFieldGetString (UxGetWidget (phiXCellText));\
phix = atof (cptr);\
free (cptr);\
cptr = (char *) XmTextFieldGetString (UxGetWidget (phiZCellText));\
phiz= atof (cptr);\
free (cptr);\
\
command ("Missetting %f %f\n", phix, phiz);\
\
UxPopdownInterface (UxThisWidget);\
\
}
*cellDialog.helpCallback: {\
UxPopdownInterface (UxThisWidget);\
SetBusyPointer (1);\
mainWS_removeLattice (mainWS, &UxEnv);\
SetBusyPointer (0);\
\
}
*cellDialog.marginHeight: 5
*cellDialog.marginWidth: 5

*cellForm.class: form
*cellForm.static: true
*cellForm.name: cellForm
*cellForm.parent: cellDialog
*cellForm.width: 370
*cellForm.height: 330
*cellForm.isCompound: "true"
*cellForm.compoundIcon: "form.xpm"
*cellForm.compoundName: "form_"

*aCellLabel.class: label
*aCellLabel.static: true
*aCellLabel.name: aCellLabel
*aCellLabel.parent: cellForm
*aCellLabel.isCompound: "true"
*aCellLabel.compoundIcon: "label.xpm"
*aCellLabel.compoundName: "label_"
*aCellLabel.x: 13
*aCellLabel.y: 13
*aCellLabel.width: 30
*aCellLabel.height: 30
*aCellLabel.labelString: "a"
*aCellLabel.fontList: "-adobe-helvetica-medium-r-normal--20-140-100-100-p-100-iso8859-1"
*aCellLabel.leftOffset: 20
*aCellLabel.topOffset: 70
*aCellLabel.topAttachment: "attach_form"

*aCellText.class: textField
*aCellText.static: true
*aCellText.name: aCellText
*aCellText.parent: cellForm
*aCellText.width: 100
*aCellText.isCompound: "true"
*aCellText.compoundIcon: "textfield.xpm"
*aCellText.compoundName: "text_Field"
*aCellText.x: 50
*aCellText.y: 13
*aCellText.height: 30
*aCellText.topOffset: 70
*aCellText.topAttachment: "attach_form"
*aCellText.fontList: "7x14"

*bCellLabel.class: label
*bCellLabel.static: true
*bCellLabel.name: bCellLabel
*bCellLabel.parent: cellForm
*bCellLabel.isCompound: "true"
*bCellLabel.compoundIcon: "label.xpm"
*bCellLabel.compoundName: "label_"
*bCellLabel.x: 12
*bCellLabel.y: 60
*bCellLabel.width: 30
*bCellLabel.height: 30
*bCellLabel.labelString: "b"
*bCellLabel.fontList: "-adobe-helvetica-medium-r-normal--20-140-100-100-p-100-iso8859-1"
*bCellLabel.leftOffset: 20
*bCellLabel.topOffset: 115
*bCellLabel.topAttachment: "attach_form"

*bCellText.class: textField
*bCellText.static: true
*bCellText.name: bCellText
*bCellText.parent: cellForm
*bCellText.width: 100
*bCellText.isCompound: "true"
*bCellText.compoundIcon: "textfield.xpm"
*bCellText.compoundName: "text_Field"
*bCellText.x: 50
*bCellText.y: 60
*bCellText.height: 30
*bCellText.topOffset: 115
*bCellText.topAttachment: "attach_form"
*bCellText.fontList: "7x14"

*cCellLabel.class: label
*cCellLabel.static: true
*cCellLabel.name: cCellLabel
*cCellLabel.parent: cellForm
*cCellLabel.isCompound: "true"
*cCellLabel.compoundIcon: "label.xpm"
*cCellLabel.compoundName: "label_"
*cCellLabel.x: 12
*cCellLabel.y: 107
*cCellLabel.width: 30
*cCellLabel.height: 30
*cCellLabel.labelString: "c"
*cCellLabel.fontList: "-adobe-helvetica-medium-r-normal--20-140-100-100-p-100-iso8859-1"
*cCellLabel.leftOffset: 20
*cCellLabel.topOffset: 160
*cCellLabel.topAttachment: "attach_form"

*cCellText.class: textField
*cCellText.static: true
*cCellText.name: cCellText
*cCellText.parent: cellForm
*cCellText.width: 100
*cCellText.isCompound: "true"
*cCellText.compoundIcon: "textfield.xpm"
*cCellText.compoundName: "text_Field"
*cCellText.x: 50
*cCellText.y: 107
*cCellText.height: 30
*cCellText.topOffset: 160
*cCellText.topAttachment: "attach_form"
*cCellText.fontList: "7x14"

*alphaCellText.class: textField
*alphaCellText.static: true
*alphaCellText.name: alphaCellText
*alphaCellText.parent: cellForm
*alphaCellText.width: 100
*alphaCellText.isCompound: "true"
*alphaCellText.compoundIcon: "textfield.xpm"
*alphaCellText.compoundName: "text_Field"
*alphaCellText.x: 240
*alphaCellText.y: 14
*alphaCellText.height: 30
*alphaCellText.topOffset: 70
*alphaCellText.text: "    90.0"
*alphaCellText.topAttachment: "attach_form"
*alphaCellText.fontList: "7x14"

*alphaCellLabel.class: label
*alphaCellLabel.static: true
*alphaCellLabel.name: alphaCellLabel
*alphaCellLabel.parent: cellForm
*alphaCellLabel.isCompound: "true"
*alphaCellLabel.compoundIcon: "label.xpm"
*alphaCellLabel.compoundName: "label_"
*alphaCellLabel.x: 200
*alphaCellLabel.y: 14
*alphaCellLabel.width: 30
*alphaCellLabel.height: 30
*alphaCellLabel.labelString: "a"
*alphaCellLabel.fontList: "-adobe-symbol-medium-r-normal--18-180-75-75-p-107-adobe-fontspecific"
*alphaCellLabel.topOffset: 70
*alphaCellLabel.topAttachment: "attach_form"

*betaCellLabel.class: label
*betaCellLabel.static: true
*betaCellLabel.name: betaCellLabel
*betaCellLabel.parent: cellForm
*betaCellLabel.isCompound: "true"
*betaCellLabel.compoundIcon: "label.xpm"
*betaCellLabel.compoundName: "label_"
*betaCellLabel.x: 200
*betaCellLabel.y: 63
*betaCellLabel.width: 30
*betaCellLabel.height: 30
*betaCellLabel.labelString: "b"
*betaCellLabel.fontList: "-adobe-symbol-medium-r-normal--18-180-75-75-p-107-adobe-fontspecific"
*betaCellLabel.topOffset: 115
*betaCellLabel.topAttachment: "attach_form"

*betaCellText.class: textField
*betaCellText.static: true
*betaCellText.name: betaCellText
*betaCellText.parent: cellForm
*betaCellText.width: 100
*betaCellText.isCompound: "true"
*betaCellText.compoundIcon: "textfield.xpm"
*betaCellText.compoundName: "text_Field"
*betaCellText.x: 240
*betaCellText.y: 63
*betaCellText.height: 30
*betaCellText.topOffset: 115
*betaCellText.text: "    90.0"
*betaCellText.topAttachment: "attach_form"
*betaCellText.fontList: "7x14"

*gammaCellLabel.class: label
*gammaCellLabel.static: true
*gammaCellLabel.name: gammaCellLabel
*gammaCellLabel.parent: cellForm
*gammaCellLabel.isCompound: "true"
*gammaCellLabel.compoundIcon: "label.xpm"
*gammaCellLabel.compoundName: "label_"
*gammaCellLabel.x: 200
*gammaCellLabel.y: 109
*gammaCellLabel.width: 30
*gammaCellLabel.height: 30
*gammaCellLabel.labelString: "g"
*gammaCellLabel.fontList: "-adobe-symbol-medium-r-normal--18-180-75-75-p-107-adobe-fontspecific"
*gammaCellLabel.topOffset: 160
*gammaCellLabel.topAttachment: "attach_form"

*gammaCellText.class: textField
*gammaCellText.static: true
*gammaCellText.name: gammaCellText
*gammaCellText.parent: cellForm
*gammaCellText.width: 100
*gammaCellText.isCompound: "true"
*gammaCellText.compoundIcon: "textfield.xpm"
*gammaCellText.compoundName: "text_Field"
*gammaCellText.x: 240
*gammaCellText.y: 109
*gammaCellText.height: 30
*gammaCellText.topOffset: 160
*gammaCellText.text: "    90.0"
*gammaCellText.topAttachment: "attach_form"
*gammaCellText.fontList: "7x14"

*phiXCellLabel.class: label
*phiXCellLabel.static: true
*phiXCellLabel.name: phiXCellLabel
*phiXCellLabel.parent: cellForm
*phiXCellLabel.isCompound: "true"
*phiXCellLabel.compoundIcon: "label.xpm"
*phiXCellLabel.compoundName: "label_"
*phiXCellLabel.x: 10
*phiXCellLabel.y: 240
*phiXCellLabel.width: 50
*phiXCellLabel.height: 30
*phiXCellLabel.labelString: "Phi X"
*phiXCellLabel.leftOffset: 0
*phiXCellLabel.leftAttachment: "attach_form"
*phiXCellLabel.topOffset: 220
*phiXCellLabel.topAttachment: "attach_form"
*phiXCellLabel.fontList: "8x13bold"

*phiXCellText.class: textField
*phiXCellText.static: true
*phiXCellText.name: phiXCellText
*phiXCellText.parent: cellForm
*phiXCellText.width: 100
*phiXCellText.isCompound: "true"
*phiXCellText.compoundIcon: "textfield.xpm"
*phiXCellText.compoundName: "text_Field"
*phiXCellText.x: 70
*phiXCellText.y: 240
*phiXCellText.height: 30
*phiXCellText.leftOffset: 60
*phiXCellText.leftAttachment: "attach_form"
*phiXCellText.text: "    0.0"
*phiXCellText.topOffset: 220
*phiXCellText.topAttachment: "attach_form"
*phiXCellText.fontList: "7x14"

*phiZCellLabel.class: label
*phiZCellLabel.static: true
*phiZCellLabel.name: phiZCellLabel
*phiZCellLabel.parent: cellForm
*phiZCellLabel.isCompound: "true"
*phiZCellLabel.compoundIcon: "label.xpm"
*phiZCellLabel.compoundName: "label_"
*phiZCellLabel.x: 10
*phiZCellLabel.y: 220
*phiZCellLabel.width: 50
*phiZCellLabel.height: 30
*phiZCellLabel.labelString: "Phi Z"
*phiZCellLabel.leftOffset: 0
*phiZCellLabel.leftAttachment: "attach_form"
*phiZCellLabel.topOffset: 270
*phiZCellLabel.topAttachment: "attach_form"
*phiZCellLabel.fontList: "8x13bold"

*phiZCellText.class: textField
*phiZCellText.static: true
*phiZCellText.name: phiZCellText
*phiZCellText.parent: cellForm
*phiZCellText.width: 100
*phiZCellText.isCompound: "true"
*phiZCellText.compoundIcon: "textfield.xpm"
*phiZCellText.compoundName: "text_Field"
*phiZCellText.x: 70
*phiZCellText.y: 220
*phiZCellText.height: 30
*phiZCellText.leftOffset: 60
*phiZCellText.leftAttachment: "attach_form"
*phiZCellText.topOffset: 270
*phiZCellText.topAttachment: "attach_form"
*phiZCellText.text: "    0.0"
*phiZCellText.fontList: "7x14"

*minDCellLabel.class: label
*minDCellLabel.static: true
*minDCellLabel.name: minDCellLabel
*minDCellLabel.parent: cellForm
*minDCellLabel.isCompound: "true"
*minDCellLabel.compoundIcon: "label.xpm"
*minDCellLabel.compoundName: "label_"
*minDCellLabel.x: 150
*minDCellLabel.y: 240
*minDCellLabel.width: 60
*minDCellLabel.height: 30
*minDCellLabel.labelString: "D min"
*minDCellLabel.leftOffset: 180
*minDCellLabel.leftAttachment: "attach_form"
*minDCellLabel.topOffset: 220
*minDCellLabel.topAttachment: "attach_form"
*minDCellLabel.fontList: "8x13bold"

*minDCellText.class: textField
*minDCellText.static: true
*minDCellText.name: minDCellText
*minDCellText.parent: cellForm
*minDCellText.width: 100
*minDCellText.isCompound: "true"
*minDCellText.compoundIcon: "textfield.xpm"
*minDCellText.compoundName: "text_Field"
*minDCellText.x: 220
*minDCellText.y: 240
*minDCellText.height: 30
*minDCellText.leftOffset: 240
*minDCellText.leftAttachment: "attach_form"
*minDCellText.text: "    0.0"
*minDCellText.topOffset: 220
*minDCellText.topAttachment: "attach_form"
*minDCellText.fontList: "7x14"

*maxDCellLabel.class: label
*maxDCellLabel.static: true
*maxDCellLabel.name: maxDCellLabel
*maxDCellLabel.parent: cellForm
*maxDCellLabel.isCompound: "true"
*maxDCellLabel.compoundIcon: "label.xpm"
*maxDCellLabel.compoundName: "label_"
*maxDCellLabel.x: 150
*maxDCellLabel.y: 220
*maxDCellLabel.width: 60
*maxDCellLabel.height: 30
*maxDCellLabel.labelString: "D max"
*maxDCellLabel.leftOffset: 180
*maxDCellLabel.leftAttachment: "attach_form"
*maxDCellLabel.topOffset: 270
*maxDCellLabel.topAttachment: "attach_form"
*maxDCellLabel.fontList: "8x13bold"

*maxDCellText.class: textField
*maxDCellText.static: true
*maxDCellText.name: maxDCellText
*maxDCellText.parent: cellForm
*maxDCellText.width: 100
*maxDCellText.isCompound: "true"
*maxDCellText.compoundIcon: "textfield.xpm"
*maxDCellText.compoundName: "text_Field"
*maxDCellText.x: 220
*maxDCellText.y: 220
*maxDCellText.height: 30
*maxDCellText.leftOffset: 240
*maxDCellText.leftAttachment: "attach_form"
*maxDCellText.topOffset: 270
*maxDCellText.topAttachment: "attach_form"
*maxDCellText.text: "    0.5"
*maxDCellText.fontList: "7x14"

*separator2.class: separator
*separator2.static: true
*separator2.name: separator2
*separator2.parent: cellForm
*separator2.width: 374
*separator2.height: 10
*separator2.isCompound: "true"
*separator2.compoundIcon: "sep.xpm"
*separator2.compoundName: "separator_"
*separator2.x: -9
*separator2.y: 200

*spaceGroupLabel.class: label
*spaceGroupLabel.static: true
*spaceGroupLabel.name: spaceGroupLabel
*spaceGroupLabel.parent: cellForm
*spaceGroupLabel.isCompound: "true"
*spaceGroupLabel.compoundIcon: "label.xpm"
*spaceGroupLabel.compoundName: "label_"
*spaceGroupLabel.x: 18
*spaceGroupLabel.y: 10
*spaceGroupLabel.width: 100
*spaceGroupLabel.height: 30
*spaceGroupLabel.leftOffset: 10
*spaceGroupLabel.topOffset: 10
*spaceGroupLabel.labelString: "Space group"
*spaceGroupLabel.topAttachment: "attach_form"
*spaceGroupLabel.fontList: "8x13bold"

*spaceGroupText.class: textField
*spaceGroupText.static: true
*spaceGroupText.name: spaceGroupText
*spaceGroupText.parent: cellForm
*spaceGroupText.width: 100
*spaceGroupText.isCompound: "true"
*spaceGroupText.compoundIcon: "textfield.xpm"
*spaceGroupText.compoundName: "text_Field"
*spaceGroupText.x: 120
*spaceGroupText.y: 10
*spaceGroupText.height: 30
*spaceGroupText.text: "P1"
*spaceGroupText.topOffset: 10
*spaceGroupText.topAttachment: "attach_form"
*spaceGroupText.fontList: "7x14"

