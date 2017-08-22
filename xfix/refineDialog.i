! UIMX ascii 2.9 key: 8686                                                      

*refineDialog.class: templateDialog
*refineDialog.classinc:
*refineDialog.classspec:
*refineDialog.classmembers:
*refineDialog.classconstructor:
*refineDialog.classdestructor:
*refineDialog.gbldecl: #include <stdio.h>\
\
#ifndef DESIGN_TIME\
#include "mainWS.h"\
#endif\
\
#include"mprintf.h"\
\
extern swidget mainWS;
*refineDialog.ispecdecl: Boolean refineCentre, refineRotX, refineRotY, refineRotZ, refineTilt;
*refineDialog.ispeclist: refineCentre, refineRotX, refineRotY, refineRotZ, refineTilt
*refineDialog.ispeclist.refineCentre: "Boolean", "%refineCentre%"
*refineDialog.ispeclist.refineRotX: "Boolean", "%refineRotX%"
*refineDialog.ispeclist.refineRotY: "Boolean", "%refineRotY%"
*refineDialog.ispeclist.refineRotZ: "Boolean", "%refineRotZ%"
*refineDialog.ispeclist.refineTilt: "Boolean", "%refineTilt%"
*refineDialog.funcdecl: swidget create_refineDialog(swidget UxParent)
*refineDialog.funcname: create_refineDialog
*refineDialog.funcdef: "swidget", "<create_refineDialog>(%)"
*refineDialog.argdecl: swidget UxParent;
*refineDialog.arglist: UxParent
*refineDialog.arglist.UxParent: "swidget", "%UxParent%"
*refineDialog.icode:
*refineDialog.fcode: refineCentre = refineRotX = True;\
refineRotY = refineRotZ = refineTilt = False;\
return(rtrn);\

*refineDialog.auxdecl:
*refineDialog.static: true
*refineDialog.name: refineDialog
*refineDialog.parent: NO_PARENT
*refineDialog.parentExpression: UxParent
*refineDialog.defaultShell: transientShell
*refineDialog.width: 300
*refineDialog.height: 300
*refineDialog.msgDialogType: "dialog_template"
*refineDialog.isCompound: "true"
*refineDialog.compoundIcon: "templateD.xpm"
*refineDialog.compoundName: "template_Dialog"
*refineDialog.x: 380
*refineDialog.y: 70
*refineDialog.unitType: "pixels"
*refineDialog.autoUnmanage: "true"
*refineDialog.cancelLabelString: "Cancel"
*refineDialog.dialogTitle: "Refine Dialog"
*refineDialog.okLabelString: "OK"
*refineDialog.okCallback: {\
int x, y, width, height;\
\
if (mainWS_imageLimits (mainWS, &UxEnv, &x, &y, &width, &height) == 0)\
{\
   command ("Refine %d %d %d %d\n", x, y, width, height);\
}  \
\
}

*form4.class: form
*form4.static: true
*form4.name: form4
*form4.parent: refineDialog
*form4.width: 280
*form4.height: 160
*form4.resizePolicy: "resize_none"
*form4.isCompound: "true"
*form4.compoundIcon: "form.xpm"
*form4.compoundName: "form_"
*form4.x: 10
*form4.y: 10

*rowColumn2.class: rowColumn
*rowColumn2.static: true
*rowColumn2.name: rowColumn2
*rowColumn2.parent: form4
*rowColumn2.width: 200
*rowColumn2.height: 200
*rowColumn2.isCompound: "true"
*rowColumn2.compoundIcon: "row.xpm"
*rowColumn2.compoundName: "row_Column"
*rowColumn2.x: 10
*rowColumn2.y: 20

*centreButton.class: toggleButton
*centreButton.static: true
*centreButton.name: centreButton
*centreButton.parent: rowColumn2
*centreButton.isCompound: "true"
*centreButton.compoundIcon: "toggle.xpm"
*centreButton.compoundName: "toggle_Button"
*centreButton.x: 20
*centreButton.y: 20
*centreButton.width: 130
*centreButton.height: 10
*centreButton.labelString: "Centre"
*centreButton.set: "true"
*centreButton.valueChangedCallback: {\
refineCentre = !refineCentre;\
mainWS_setRefineCentre (mainWS, &UxEnv, refineCentre);\
}

*rotXButton.class: toggleButton
*rotXButton.static: true
*rotXButton.name: rotXButton
*rotXButton.parent: rowColumn2
*rotXButton.isCompound: "true"
*rotXButton.compoundIcon: "toggle.xpm"
*rotXButton.compoundName: "toggle_Button"
*rotXButton.x: 13
*rotXButton.y: 13
*rotXButton.width: 130
*rotXButton.height: 10
*rotXButton.labelString: "Detector rotation"
*rotXButton.set: "true"
*rotXButton.valueChangedCallback: {\
refineRotX = !refineRotX;\
mainWS_setRefineRotX (mainWS, &UxEnv, refineRotX);\
}

*rotYButton.class: toggleButton
*rotYButton.static: true
*rotYButton.name: rotYButton
*rotYButton.parent: rowColumn2
*rotYButton.isCompound: "true"
*rotYButton.compoundIcon: "toggle.xpm"
*rotYButton.compoundName: "toggle_Button"
*rotYButton.x: 13
*rotYButton.y: 38
*rotYButton.width: 130
*rotYButton.height: 10
*rotYButton.labelString: "Detector twist"
*rotYButton.valueChangedCallback: {\
refineRotY = !refineRotY;\
mainWS_setRefineRotY (mainWS, &UxEnv, refineRotY);\
}

*rotZButton.class: toggleButton
*rotZButton.static: true
*rotZButton.name: rotZButton
*rotZButton.parent: rowColumn2
*rotZButton.isCompound: "true"
*rotZButton.compoundIcon: "toggle.xpm"
*rotZButton.compoundName: "toggle_Button"
*rotZButton.x: 13
*rotZButton.y: 64
*rotZButton.width: 130
*rotZButton.height: 10
*rotZButton.labelString: "Detector tilt"
*rotZButton.valueChangedCallback: {\
refineRotZ = !refineRotZ;\
mainWS_setRefineRotZ (mainWS, &UxEnv, refineRotZ);\
}

*tiltButton.class: toggleButton
*tiltButton.static: true
*tiltButton.name: tiltButton
*tiltButton.parent: rowColumn2
*tiltButton.isCompound: "true"
*tiltButton.compoundIcon: "toggle.xpm"
*tiltButton.compoundName: "toggle_Button"
*tiltButton.x: 13
*tiltButton.y: 90
*tiltButton.width: 130
*tiltButton.height: 10
*tiltButton.labelString: "Specimen tilt"
*tiltButton.valueChangedCallback: {\
refineTilt = !refineTilt;\
mainWS_setRefineTilt (mainWS, &UxEnv, refineTilt);\
}

