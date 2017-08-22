! UIMX ascii 2.9 key: 8383                                                      

*parameterDialog.class: templateDialog
*parameterDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
\
#ifndef DESIGN_TIME\
#include "mainWS.h"\
#endif\
\
#include "mprintf.h"\
\
extern swidget mainWS;
*parameterDialog.ispecdecl: Boolean waveChanged, distanceChanged, centreChanged, rotationChanged, tiltChanged, calibrationChanged;\
Boolean firstLook;\
char textBuf[80];
*parameterDialog.ispeclist: waveChanged, distanceChanged, centreChanged, rotationChanged, tiltChanged, calibrationChanged, firstLook, textBuf
*parameterDialog.ispeclist.waveChanged: "Boolean", "%waveChanged%"
*parameterDialog.ispeclist.distanceChanged: "Boolean", "%distanceChanged%"
*parameterDialog.ispeclist.centreChanged: "Boolean", "%centreChanged%"
*parameterDialog.ispeclist.rotationChanged: "Boolean", "%rotationChanged%"
*parameterDialog.ispeclist.tiltChanged: "Boolean", "%tiltChanged%"
*parameterDialog.ispeclist.calibrationChanged: "Boolean", "%calibrationChanged%"
*parameterDialog.ispeclist.firstLook: "Boolean", "%firstLook%"
*parameterDialog.ispeclist.textBuf: "char", "%textBuf%[80]"
*parameterDialog.funcdecl: swidget create_parameterDialog(swidget UxParent)
*parameterDialog.funcname: create_parameterDialog
*parameterDialog.funcdef: "swidget", "<create_parameterDialog>(%)"
*parameterDialog.argdecl: swidget UxParent;
*parameterDialog.arglist: UxParent
*parameterDialog.arglist.UxParent: "swidget", "%UxParent%"
*parameterDialog.icode:
*parameterDialog.fcode: waveChanged = distanceChanged = centreChanged = rotationChanged = tiltChanged = calibrationChanged = False;\
firstLook = True;\
return(rtrn);\

*parameterDialog.auxdecl:
*parameterDialog_setWave.class: method
*parameterDialog_setWave.name: setWave
*parameterDialog_setWave.parent: parameterDialog
*parameterDialog_setWave.methodType: void
*parameterDialog_setWave.methodArgs: double value;\

*parameterDialog_setWave.methodBody: sprintf (textBuf, "%6.4f", value);\
XmTextFieldSetString (UxGetWidget (waveText), textBuf);
*parameterDialog_setWave.methodSpec: virtual
*parameterDialog_setWave.accessSpec: public
*parameterDialog_setWave.arguments: value
*parameterDialog_setWave.value.def: "double", "%value%"

*parameterDialog_setCentre.class: method
*parameterDialog_setCentre.name: setCentre
*parameterDialog_setCentre.parent: parameterDialog
*parameterDialog_setCentre.methodType: void
*parameterDialog_setCentre.methodArgs: double valX;\
double valY;\

*parameterDialog_setCentre.methodBody: sprintf (textBuf, "%6.1f", valX);\
XmTextFieldSetString (UxGetWidget (centreXText), textBuf);\
sprintf (textBuf, "%6.1f", valY);\
XmTextFieldSetString (UxGetWidget (centreYText), textBuf);\

*parameterDialog_setCentre.methodSpec: virtual
*parameterDialog_setCentre.accessSpec: public
*parameterDialog_setCentre.arguments: valX, valY
*parameterDialog_setCentre.valX.def: "double", "%valX%"
*parameterDialog_setCentre.valY.def: "double", "%valY%"

*parameterDialog_setDistance.class: method
*parameterDialog_setDistance.name: setDistance
*parameterDialog_setDistance.parent: parameterDialog
*parameterDialog_setDistance.methodType: void
*parameterDialog_setDistance.methodArgs: double value;\

*parameterDialog_setDistance.methodBody: sprintf (textBuf, "%8.1f", value);\
XmTextFieldSetString (UxGetWidget (distanceText), textBuf);\

*parameterDialog_setDistance.methodSpec: virtual
*parameterDialog_setDistance.accessSpec: public
*parameterDialog_setDistance.arguments: value
*parameterDialog_setDistance.value.def: "double", "%value%"

*parameterDialog_setTilt.class: method
*parameterDialog_setTilt.name: setTilt
*parameterDialog_setTilt.parent: parameterDialog
*parameterDialog_setTilt.methodType: void
*parameterDialog_setTilt.methodArgs: double value;\

*parameterDialog_setTilt.methodBody: sprintf (textBuf, "%8.2f", value);\
XmTextFieldSetString (UxGetWidget (specimenTiltText), textBuf);\

*parameterDialog_setTilt.methodSpec: virtual
*parameterDialog_setTilt.accessSpec: public
*parameterDialog_setTilt.arguments: value
*parameterDialog_setTilt.value.def: "double", "%value%"

*parameterDialog_setRotation.class: method
*parameterDialog_setRotation.name: setRotation
*parameterDialog_setRotation.parent: parameterDialog
*parameterDialog_setRotation.methodType: void
*parameterDialog_setRotation.methodArgs: double valueX;\
double valueY;\
double valueZ;\

*parameterDialog_setRotation.methodBody: sprintf (textBuf, "%8.2f", valueX);\
XmTextFieldSetString (UxGetWidget (detectorRotText), textBuf);\
sprintf (textBuf, "%8.2f", valueY);\
XmTextFieldSetString (UxGetWidget (detectorTwistText), textBuf);\
sprintf (textBuf, "%8.2f", valueZ);\
XmTextFieldSetString (UxGetWidget (detectorTiltText), textBuf);\

*parameterDialog_setRotation.methodSpec: virtual
*parameterDialog_setRotation.accessSpec: public
*parameterDialog_setRotation.arguments: valueX, valueY, valueZ
*parameterDialog_setRotation.valueX.def: "double", "%valueX%"
*parameterDialog_setRotation.valueY.def: "double", "%valueY%"
*parameterDialog_setRotation.valueZ.def: "double", "%valueZ%"

*parameterDialog.static: true
*parameterDialog.name: parameterDialog
*parameterDialog.parent: NO_PARENT
*parameterDialog.parentExpression: UxParent
*parameterDialog.defaultShell: transientShell
*parameterDialog.height: 400
*parameterDialog.msgDialogType: "dialog_template"
*parameterDialog.isCompound: "true"
*parameterDialog.compoundIcon: "templateD.xpm"
*parameterDialog.compoundName: "template_Dialog"
*parameterDialog.unitType: "pixels"
*parameterDialog.cancelLabelString: "Apply"
*parameterDialog.okLabelString: "OK"
*parameterDialog.dialogTitle: "Parameter Editor"
*parameterDialog.helpLabelString: "Cancel"
*parameterDialog.autoUnmanage: "false"
*parameterDialog.cancelCallback: {\
#include "parameterDialog_applyCB.c"\
}
*parameterDialog.helpCallback: {\
waveChanged = distanceChanged = centreChanged = rotationChanged = tiltChanged = False;\
UxPopdownInterface (UxThisWidget);\
}
*parameterDialog.okCallback: {\
#include "parameterDialog_applyCB.c"\
UxPopdownInterface (UxThisWidget);\
}
*parameterDialog.marginHeight: 5
*parameterDialog.marginWidth: 5

*form2.class: form
*form2.static: true
*form2.name: form2
*form2.parent: parameterDialog
*form2.height: 339
*form2.isCompound: "true"
*form2.compoundIcon: "form.xpm"
*form2.compoundName: "form_"

*waveLabel.class: label
*waveLabel.static: true
*waveLabel.name: waveLabel
*waveLabel.parent: form2
*waveLabel.isCompound: "true"
*waveLabel.compoundIcon: "label.xpm"
*waveLabel.compoundName: "label_"
*waveLabel.x: 10
*waveLabel.y: 20
*waveLabel.width: 100
*waveLabel.height: 30
*waveLabel.labelString: "Wavelength:"
*waveLabel.leftAttachment: "attach_form"
*waveLabel.topAttachment: "attach_form"
*waveLabel.topOffset: 10
*waveLabel.leftOffset: 0
*waveLabel.alignment: "alignment_beginning"
*waveLabel.fontList: "8x13bold"

*waveText.class: textField
*waveText.static: true
*waveText.name: waveText
*waveText.parent: form2
*waveText.width: 90
*waveText.isCompound: "true"
*waveText.compoundIcon: "textfield.xpm"
*waveText.compoundName: "text_Field"
*waveText.x: 190
*waveText.y: 20
*waveText.height: 30
*waveText.leftAttachment: "attach_form"
*waveText.leftOffset: 100
*waveText.topAttachment: "attach_form"
*waveText.topOffset: 10
*waveText.text: "1.5418"
*waveText.valueChangedCallback: {\
waveChanged = True;\
}
*waveText.fontList: "8x13"

*distanceLabel.class: label
*distanceLabel.static: true
*distanceLabel.name: distanceLabel
*distanceLabel.parent: form2
*distanceLabel.isCompound: "true"
*distanceLabel.compoundIcon: "label.xpm"
*distanceLabel.compoundName: "label_"
*distanceLabel.x: 100
*distanceLabel.y: 50
*distanceLabel.width: 100
*distanceLabel.height: 30
*distanceLabel.labelString: "Distance:"
*distanceLabel.leftAttachment: "attach_form"
*distanceLabel.leftOffset: 0
*distanceLabel.topAttachment: "attach_form"
*distanceLabel.topOffset: 50
*distanceLabel.alignment: "alignment_beginning"
*distanceLabel.fontList: "8x13bold"

*distanceText.class: textField
*distanceText.static: true
*distanceText.name: distanceText
*distanceText.parent: form2
*distanceText.width: 90
*distanceText.isCompound: "true"
*distanceText.compoundIcon: "textfield.xpm"
*distanceText.compoundName: "text_Field"
*distanceText.x: 100
*distanceText.y: 50
*distanceText.height: 30
*distanceText.text: ""
*distanceText.leftAttachment: "attach_form"
*distanceText.topAttachment: "attach_form"
*distanceText.leftOffset: 100
*distanceText.topOffset: 50
*distanceText.valueChangedCallback: distanceChanged = True;
*distanceText.fontList: "8x13"

*centreXLabel.class: label
*centreXLabel.static: true
*centreXLabel.name: centreXLabel
*centreXLabel.parent: form2
*centreXLabel.isCompound: "true"
*centreXLabel.compoundIcon: "label.xpm"
*centreXLabel.compoundName: "label_"
*centreXLabel.x: 10
*centreXLabel.y: 60
*centreXLabel.width: 170
*centreXLabel.height: 30
*centreXLabel.labelString: "Detector centre:   X"
*centreXLabel.alignment: "alignment_beginning"
*centreXLabel.topAttachment: "attach_form"
*centreXLabel.topOffset: 90
*centreXLabel.leftAttachment: "attach_form"
*centreXLabel.leftOffset: 0
*centreXLabel.fontList: "8x13bold"

*centreXText.class: textField
*centreXText.static: true
*centreXText.name: centreXText
*centreXText.parent: form2
*centreXText.width: 90
*centreXText.isCompound: "true"
*centreXText.compoundIcon: "textfield.xpm"
*centreXText.compoundName: "text_Field"
*centreXText.x: 150
*centreXText.y: 90
*centreXText.height: 30
*centreXText.text: "600"
*centreXText.valueChangedCallback: centreChanged = True;
*centreXText.leftOffset: 170
*centreXText.leftAttachment: "attach_form"
*centreXText.fontList: "8x13"

*centreYLabel.class: label
*centreYLabel.static: true
*centreYLabel.name: centreYLabel
*centreYLabel.parent: form2
*centreYLabel.isCompound: "true"
*centreYLabel.compoundIcon: "label.xpm"
*centreYLabel.compoundName: "label_"
*centreYLabel.x: 250
*centreYLabel.y: 90
*centreYLabel.width: 15
*centreYLabel.height: 30
*centreYLabel.labelString: "Y"
*centreYLabel.alignment: "alignment_beginning"
*centreYLabel.leftAttachment: "attach_form"
*centreYLabel.leftOffset: 258
*centreYLabel.topAttachment: "attach_form"
*centreYLabel.topOffset: 90
*centreYLabel.fontList: "8x13bold"

*centreYText.class: textField
*centreYText.static: true
*centreYText.name: centreYText
*centreYText.parent: form2
*centreYText.width: 90
*centreYText.isCompound: "true"
*centreYText.compoundIcon: "textfield.xpm"
*centreYText.compoundName: "text_Field"
*centreYText.x: 270
*centreYText.y: 90
*centreYText.height: 30
*centreYText.text: "600"
*centreYText.leftAttachment: "attach_form"
*centreYText.leftOffset: 275
*centreYText.topAttachment: "attach_form"
*centreYText.topOffset: 90
*centreYText.valueChangedCallback: centreChanged = True;
*centreYText.fontList: "8x13"

*detectorRotLabel.class: label
*detectorRotLabel.static: true
*detectorRotLabel.name: detectorRotLabel
*detectorRotLabel.parent: form2
*detectorRotLabel.isCompound: "true"
*detectorRotLabel.compoundIcon: "label.xpm"
*detectorRotLabel.compoundName: "label_"
*detectorRotLabel.x: 0
*detectorRotLabel.y: 130
*detectorRotLabel.width: 170
*detectorRotLabel.height: 30
*detectorRotLabel.labelString: "Detector rotation:  "
*detectorRotLabel.alignment: "alignment_beginning"
*detectorRotLabel.leftAttachment: "attach_form"
*detectorRotLabel.topAttachment: "attach_form"
*detectorRotLabel.topOffset: 130
*detectorRotLabel.leftOffset: 0
*detectorRotLabel.fontList: "8x13bold"

*detectorRotText.class: textField
*detectorRotText.static: true
*detectorRotText.name: detectorRotText
*detectorRotText.parent: form2
*detectorRotText.isCompound: "true"
*detectorRotText.compoundIcon: "textfield.xpm"
*detectorRotText.compoundName: "text_Field"
*detectorRotText.x: 150
*detectorRotText.y: 130
*detectorRotText.height: 30
*detectorRotText.text: "600"
*detectorRotText.valueWcs: "0.0"
*detectorRotText.leftAttachment: "attach_form"
*detectorRotText.topAttachment: "attach_form"
*detectorRotText.leftOffset: 170
*detectorRotText.topOffset: 130
*detectorRotText.valueChangedCallback: rotationChanged = True;
*detectorRotText.fontList: "8x13"
*detectorRotText.width: 90

*detectorTwistText.class: textField
*detectorTwistText.static: true
*detectorTwistText.name: detectorTwistText
*detectorTwistText.parent: form2
*detectorTwistText.width: 90
*detectorTwistText.isCompound: "true"
*detectorTwistText.compoundIcon: "textfield.xpm"
*detectorTwistText.compoundName: "text_Field"
*detectorTwistText.x: 150
*detectorTwistText.y: 160
*detectorTwistText.height: 30
*detectorTwistText.text: "0.0"
*detectorTwistText.leftAttachment: "attach_form"
*detectorTwistText.topAttachment: "attach_form"
*detectorTwistText.leftOffset: 170
*detectorTwistText.topOffset: 160
*detectorTwistText.valueChangedCallback: rotationChanged = True;
*detectorTwistText.fontList: "8x13"

*detectorTwistLabel.class: label
*detectorTwistLabel.static: true
*detectorTwistLabel.name: detectorTwistLabel
*detectorTwistLabel.parent: form2
*detectorTwistLabel.isCompound: "true"
*detectorTwistLabel.compoundIcon: "label.xpm"
*detectorTwistLabel.compoundName: "label_"
*detectorTwistLabel.x: -220
*detectorTwistLabel.y: 160
*detectorTwistLabel.width: 170
*detectorTwistLabel.height: 30
*detectorTwistLabel.labelString: "Detector twist:  "
*detectorTwistLabel.alignment: "alignment_beginning"
*detectorTwistLabel.leftAttachment: "attach_form"
*detectorTwistLabel.topAttachment: "attach_form"
*detectorTwistLabel.topOffset: 160
*detectorTwistLabel.leftOffset: 0
*detectorTwistLabel.fontList: "8x13bold"

*detectorTiltText.class: textField
*detectorTiltText.static: true
*detectorTiltText.name: detectorTiltText
*detectorTiltText.parent: form2
*detectorTiltText.width: 90
*detectorTiltText.isCompound: "true"
*detectorTiltText.compoundIcon: "textfield.xpm"
*detectorTiltText.compoundName: "text_Field"
*detectorTiltText.x: 150
*detectorTiltText.y: 190
*detectorTiltText.height: 30
*detectorTiltText.text: "0.0"
*detectorTiltText.leftAttachment: "attach_form"
*detectorTiltText.topAttachment: "attach_form"
*detectorTiltText.leftOffset: 170
*detectorTiltText.topOffset: 190
*detectorTiltText.valueChangedCallback: rotationChanged = True;
*detectorTiltText.fontList: "8x13"

*detectorTiltLabel.class: label
*detectorTiltLabel.static: true
*detectorTiltLabel.name: detectorTiltLabel
*detectorTiltLabel.parent: form2
*detectorTiltLabel.isCompound: "true"
*detectorTiltLabel.compoundIcon: "label.xpm"
*detectorTiltLabel.compoundName: "label_"
*detectorTiltLabel.x: 0
*detectorTiltLabel.y: 190
*detectorTiltLabel.width: 127
*detectorTiltLabel.height: 30
*detectorTiltLabel.labelString: "Detector tilt:  "
*detectorTiltLabel.alignment: "alignment_beginning"
*detectorTiltLabel.leftAttachment: "attach_form"
*detectorTiltLabel.topAttachment: "attach_form"
*detectorTiltLabel.leftOffset: 0
*detectorTiltLabel.topOffset: 190
*detectorTiltLabel.fontList: "8x13bold"

*specimenTiltText.class: textField
*specimenTiltText.static: true
*specimenTiltText.name: specimenTiltText
*specimenTiltText.parent: form2
*specimenTiltText.width: 90
*specimenTiltText.isCompound: "true"
*specimenTiltText.compoundIcon: "textfield.xpm"
*specimenTiltText.compoundName: "text_Field"
*specimenTiltText.x: 150
*specimenTiltText.y: 230
*specimenTiltText.height: 30
*specimenTiltText.text: "0.0"
*specimenTiltText.valueChangedCallback: tiltChanged = True;
*specimenTiltText.leftOffset: 170
*specimenTiltText.leftAttachment: "attach_form"
*specimenTiltText.fontList: "8x13"

*specimenTiltLabel.class: label
*specimenTiltLabel.static: true
*specimenTiltLabel.name: specimenTiltLabel
*specimenTiltLabel.parent: form2
*specimenTiltLabel.isCompound: "true"
*specimenTiltLabel.compoundIcon: "label.xpm"
*specimenTiltLabel.compoundName: "label_"
*specimenTiltLabel.x: 0
*specimenTiltLabel.y: 230
*specimenTiltLabel.width: 170
*specimenTiltLabel.height: 30
*specimenTiltLabel.labelString: "Specimen tilt:  "
*specimenTiltLabel.alignment: "alignment_beginning"
*specimenTiltLabel.leftAttachment: "attach_form"
*specimenTiltLabel.topAttachment: "attach_form"
*specimenTiltLabel.topOffset: 230
*specimenTiltLabel.fontList: "8x13bold"

*calibrationLabel.class: label
*calibrationLabel.static: true
*calibrationLabel.name: calibrationLabel
*calibrationLabel.parent: form2
*calibrationLabel.isCompound: "true"
*calibrationLabel.compoundIcon: "label.xpm"
*calibrationLabel.compoundName: "label_"
*calibrationLabel.x: 0
*calibrationLabel.y: 270
*calibrationLabel.width: 170
*calibrationLabel.height: 30
*calibrationLabel.labelString: "Calibrant d-spacing:  "
*calibrationLabel.alignment: "alignment_beginning"
*calibrationLabel.fontList: "8x13bold"

*calibrationText.class: textField
*calibrationText.static: true
*calibrationText.name: calibrationText
*calibrationText.parent: form2
*calibrationText.width: 90
*calibrationText.isCompound: "true"
*calibrationText.compoundIcon: "textfield.xpm"
*calibrationText.compoundName: "text_Field"
*calibrationText.x: 150
*calibrationText.y: 270
*calibrationText.height: 30
*calibrationText.text: "3.137"
*calibrationText.valueChangedCallback: calibrationChanged = True;
*calibrationText.leftOffset: 170
*calibrationText.leftAttachment: "attach_form"
*calibrationText.fontList: "8x13"

