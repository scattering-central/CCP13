! UIMX ascii 2.9 key: 6181                                                      

*limitDialog.class: templateDialog
*limitDialog.classinc:
*limitDialog.classspec:
*limitDialog.classmembers:
*limitDialog.classconstructor:
*limitDialog.classdestructor:
*limitDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
#ifndef DESIGN_TIME\
#include "setupDialog.h"\
#endif\
#include "mprintf.h"\
\
extern swidget setup;\
\

*limitDialog.ispecdecl: int lpar, cpar, cstate;\
double lim1, lim2;
*limitDialog.ispeclist: lpar, cpar, cstate, lim1, lim2
*limitDialog.ispeclist.lpar: "int", "%lpar%"
*limitDialog.ispeclist.cpar: "int", "%cpar%"
*limitDialog.ispeclist.cstate: "int", "%cstate%"
*limitDialog.ispeclist.lim1: "double", "%lim1%"
*limitDialog.ispeclist.lim2: "double", "%lim2%"
*limitDialog.funcdecl: swidget create_limitDialog(swidget UxParent)
*limitDialog.funcname: create_limitDialog
*limitDialog.funcdef: "swidget", "<create_limitDialog>(%)"
*limitDialog.argdecl: swidget UxParent;
*limitDialog.arglist: UxParent
*limitDialog.arglist.UxParent: "swidget", "%UxParent%"
*limitDialog.icode:
*limitDialog.fcode: return(rtrn);\

*limitDialog.auxdecl:
*limitDialog_lshow.class: method
*limitDialog_lshow.name: lshow
*limitDialog_lshow.parent: limitDialog
*limitDialog_lshow.methodType: void
*limitDialog_lshow.methodArgs: int num;\

*limitDialog_lshow.methodBody: cpar = lpar = num;\
setupDialog_getStateN (setup, &UxEnv, num, &cstate);\
limitDialog_lput (UxThis, pEnv);\
UxPopupInterface (UxThis, no_grab);
*limitDialog_lshow.methodSpec: virtual
*limitDialog_lshow.accessSpec: public
*limitDialog_lshow.arguments: num
*limitDialog_lshow.num.def: "int", "%num%"

*limitDialog_lput.class: method
*limitDialog_lput.name: lput
*limitDialog_lput.parent: limitDialog
*limitDialog_lput.methodType: void
*limitDialog_lput.methodArgs: 
*limitDialog_lput.methodBody: char *cptr, tmp[20];\
 \
cptr = (char *) setupDialog_getDescrN (setup, pEnv, lpar);\
if (cptr)\
{\
    XtSetSensitive (arrowB_limit2, TRUE);\
    XtSetSensitive (arrowB_limit1, TRUE);\
 \
    XtVaSetValues (labelPeak1,\
                   XmNlabelString, XmStringCreateLtoR (cptr, XmSTRING_DEFAULT_CHARSET),\
                   NULL);\
 \
    sprintf (tmp, "%d", lpar);\
    XmTextFieldSetString (textPar1, tmp);\
      \
    setupDialog_getLimitsN (setup, pEnv, lpar, &lim1, &lim2);\
 \
    sprintf (tmp,"%g", lim1);\
    XmTextFieldSetString (textLimit1_1, tmp);\
    sprintf (tmp,"%g", lim2);\
    XmTextFieldSetString (textLimit1_2, tmp);\
}\
else\
{\
    if (lpar == 0)\
    {\
        lpar = 1;\
        XtSetSensitive (arrowB_limit2, FALSE);\
        XtSetSensitive (arrowB_limit1, TRUE);\
    }\
    else\
    {\
        lpar--;\
        XtSetSensitive (arrowB_limit2, TRUE);\
        XtSetSensitive (arrowB_limit1, FALSE);\
    }\
 \
}
*limitDialog_lput.methodSpec: virtual
*limitDialog_lput.accessSpec: public

*limitDialog.static: true
*limitDialog.name: limitDialog
*limitDialog.parent: NO_PARENT
*limitDialog.parentExpression: UxParent
*limitDialog.defaultShell: topLevelShell
*limitDialog.width: 330
*limitDialog.height: 180
*limitDialog.msgDialogType: "dialog_template"
*limitDialog.isCompound: "true"
*limitDialog.compoundIcon: "templateD.xpm"
*limitDialog.compoundName: "template_Dialog"
*limitDialog.buttonFontList: "8x13bold"
*limitDialog.labelFontList: "8x13bold"
*limitDialog.okLabelString: "OK"
*limitDialog.dialogTitle: "Limit Dialog"
*limitDialog.textFontList: "8x13bold"
*limitDialog.cancelLabelString: "Apply"
*limitDialog.helpLabelString: "Cancel"
*limitDialog.cancelCallback: {\
#include "limitDialog_applyCB.c"\
\
\
\
\
\
\
}
*limitDialog.helpCallback: {\
setupDialog_setStateN (setup, &UxEnv, cpar, cstate);\
UxPopdownInterface (UxThisWidget);\
}
*limitDialog.okCallback: {\
#include "limitDialog_applyCB.c"\
UxPopdownInterface (UxThisWidget);\
\
}
*limitDialog.autoUnmanage: "false"

*form1.class: form
*form1.static: true
*form1.name: form1
*form1.parent: limitDialog
*form1.compoundIcon: "form.xpm"
*form1.compoundName: "form_"
*form1.marginHeight: 3
*form1.marginWidth: 3

*label4.class: label
*label4.static: true
*label4.name: label4
*label4.parent: form1
*label4.isCompound: "true"
*label4.compoundIcon: "label.xpm"
*label4.compoundName: "label_"
*label4.x: 8
*label4.y: 0
*label4.width: 90
*label4.height: 30
*label4.fontList: "8x13bold"
*label4.labelString: "Parameter"
*label4.leftAttachment: "attach_form"
*label4.leftOffset: 0
*label4.topAttachment: "attach_form"
*label4.topOffset: 5
*label4.alignment: "alignment_beginning"

*textPar1.class: textField
*textPar1.static: true
*textPar1.name: textPar1
*textPar1.parent: form1
*textPar1.width: 30
*textPar1.isCompound: "true"
*textPar1.compoundIcon: "textfield.xpm"
*textPar1.compoundName: "text_Field"
*textPar1.fontList: "8x13bold"
*textPar1.height: 30
*textPar1.columns: 2
*textPar1.text: "1"
*textPar1.cursorPositionVisible: "false"
*textPar1.editable: "false"
*textPar1.shadowThickness: 0
*textPar1.leftAttachment: "attach_form"
*textPar1.leftOffset: 90
*textPar1.topAttachment: "attach_form"
*textPar1.topOffset: 4

*labelPeak1.class: label
*labelPeak1.static: true
*labelPeak1.name: labelPeak1
*labelPeak1.parent: form1
*labelPeak1.isCompound: "true"
*labelPeak1.compoundIcon: "label.xpm"
*labelPeak1.compoundName: "label_"
*labelPeak1.width: 150
*labelPeak1.height: 30
*labelPeak1.fontList: "8x13bold"
*labelPeak1.labelString: "(Peak  1: position)"
*labelPeak1.leftAttachment: "attach_form"
*labelPeak1.leftOffset: 150
*labelPeak1.topAttachment: "attach_form"
*labelPeak1.topOffset: 5
*labelPeak1.alignment: "alignment_beginning"

*textLimit1_1.class: textField
*textLimit1_1.static: true
*textLimit1_1.name: textLimit1_1
*textLimit1_1.parent: form1
*textLimit1_1.width: 100
*textLimit1_1.isCompound: "true"
*textLimit1_1.compoundIcon: "textfield.xpm"
*textLimit1_1.compoundName: "text_Field"
*textLimit1_1.height: 30
*textLimit1_1.fontList: "8x13bold"
*textLimit1_1.columns: 10
*textLimit1_1.leftAttachment: "attach_form"
*textLimit1_1.leftOffset: 70
*textLimit1_1.topAttachment: "attach_form"
*textLimit1_1.topOffset: 48
*textLimit1_1.x: 98

*textLimit1_2.class: textField
*textLimit1_2.static: true
*textLimit1_2.name: textLimit1_2
*textLimit1_2.parent: form1
*textLimit1_2.width: 100
*textLimit1_2.isCompound: "true"
*textLimit1_2.compoundIcon: "textfield.xpm"
*textLimit1_2.compoundName: "text_Field"
*textLimit1_2.height: 30
*textLimit1_2.fontList: "8x13bold"
*textLimit1_2.columns: 10
*textLimit1_2.leftAttachment: "attach_form"
*textLimit1_2.leftOffset: 200
*textLimit1_2.topAttachment: "attach_form"
*textLimit1_2.topOffset: 48

*labelTo1.class: label
*labelTo1.static: true
*labelTo1.name: labelTo1
*labelTo1.parent: form1
*labelTo1.isCompound: "true"
*labelTo1.compoundIcon: "label.xpm"
*labelTo1.compoundName: "label_"
*labelTo1.width: 20
*labelTo1.height: 30
*labelTo1.labelString: "to"
*labelTo1.fontList: "8x13bold"
*labelTo1.leftAttachment: "attach_form"
*labelTo1.leftOffset: 175
*labelTo1.topAttachment: "attach_form"
*labelTo1.topOffset: 50

*label8.class: label
*label8.static: true
*label8.name: label8
*label8.parent: form1
*label8.isCompound: "true"
*label8.compoundIcon: "label.xpm"
*label8.compoundName: "label_"
*label8.width: 60
*label8.height: 30
*label8.fontList: "8x13bold"
*label8.labelString: "Limits:"
*label8.topAttachment: "attach_form"
*label8.topOffset: 50
*label8.alignment: "alignment_beginning"
*label8.leftAttachment: "attach_form"
*label8.leftOffset: 0

*arrowB_limit2.class: arrowButton
*arrowB_limit2.static: true
*arrowB_limit2.name: arrowB_limit2
*arrowB_limit2.parent: form1
*arrowB_limit2.isCompound: "true"
*arrowB_limit2.compoundIcon: "arrow.xpm"
*arrowB_limit2.compoundName: "arrow_Button"
*arrowB_limit2.width: 20
*arrowB_limit2.height: 20
*arrowB_limit2.arrowDirection: "arrow_down"
*arrowB_limit2.activateCallback: {\
#include "limitDialog_applyCB.c"\
lpar--;\
limitDialog_lput (UxThisWidget, &UxEnv);\
}
*arrowB_limit2.leftAttachment: "attach_form"
*arrowB_limit2.leftOffset: 125 
*arrowB_limit2.topAttachment: "attach_form"
*arrowB_limit2.topOffset: 20

*arrowB_limit1.class: arrowButton
*arrowB_limit1.static: true
*arrowB_limit1.name: arrowB_limit1
*arrowB_limit1.parent: form1
*arrowB_limit1.isCompound: "true"
*arrowB_limit1.compoundIcon: "arrow.xpm"
*arrowB_limit1.compoundName: "arrow_Button"
*arrowB_limit1.width: 20
*arrowB_limit1.height: 20
*arrowB_limit1.activateCallback: {\
#include "limitDialog_applyCB.c"\
lpar++;\
limitDialog_lput (UxThisWidget, &UxEnv);\
}
*arrowB_limit1.leftAttachment: "attach_form"
*arrowB_limit1.leftOffset: 125
*arrowB_limit1.topAttachment: "attach_form"
*arrowB_limit1.topOffset: 0

