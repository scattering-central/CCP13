! UIMX ascii 2.9 key: 7161                                                      

*tieDialog.class: templateDialog
*tieDialog.classinc:
*tieDialog.classspec:
*tieDialog.classmembers:
*tieDialog.classconstructor:
*tieDialog.classdestructor:
*tieDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
#ifndef DESIGN_TIME\
#include "setupDialog.h"\
#endif\
\
#include "mprintf.h"\
\
extern swidget setup;\
\
static void setH (Boolean, int);\
static void setK (Boolean, int);\
static void setL (Boolean, int);
*tieDialog.ispecdecl: char constraint[5];\
int istate, cpar, par, tiepar, ctype, ih, ik, il;
*tieDialog.ispeclist: constraint, istate, cpar, par, tiepar, ctype, ih, ik, il
*tieDialog.ispeclist.constraint: "char", "%constraint%[5]"
*tieDialog.ispeclist.istate: "int", "%istate%"
*tieDialog.ispeclist.cpar: "int", "%cpar%"
*tieDialog.ispeclist.par: "int", "%par%"
*tieDialog.ispeclist.tiepar: "int", "%tiepar%"
*tieDialog.ispeclist.ctype: "int", "%ctype%"
*tieDialog.ispeclist.ih: "int", "%ih%"
*tieDialog.ispeclist.ik: "int", "%ik%"
*tieDialog.ispeclist.il: "int", "%il%"
*tieDialog.funcdecl: swidget create_tieDialog(swidget UxParent)
*tieDialog.funcname: create_tieDialog
*tieDialog.funcdef: "swidget", "<create_tieDialog>(%)"
*tieDialog.argdecl: swidget UxParent;
*tieDialog.arglist: UxParent
*tieDialog.arglist.UxParent: "swidget", "%UxParent%"
*tieDialog.icode:
*tieDialog.fcode: return(rtrn);\

*tieDialog.auxdecl: #include "tieDialog_aux.c"
*tieDialog_tput.class: method
*tieDialog_tput.name: tput
*tieDialog_tput.parent: tieDialog
*tieDialog_tput.methodType: void
*tieDialog_tput.methodArgs: 
*tieDialog_tput.methodBody: char *cptr, tmp[5];\
 \
cptr = (char *) setupDialog_getDescrN (setup, pEnv, par);\
if (cptr)\
{\
    XtVaSetValues (labelPeak,\
                   XmNlabelString, XmStringCreateLtoR (cptr, \
                   XmSTRING_DEFAULT_CHARSET),\
                   NULL);\
 \
    sprintf (tmp, "%d", par);\
    XmTextFieldSetString (textPar, tmp);\
      \
    setupDialog_getTieN (setup, pEnv, par, &tiepar, &ctype, &ih,\
                        &ik, &il);\
 \
    cptr = (char *) setupDialog_getDescrN (setup, pEnv, tiepar);\
 \
    if (cptr)\
    {\
        XtSetSensitive (arrowButton2, TRUE);\
        XtSetSensitive (arrowButton1, TRUE);\
 \
        XtVaSetValues (labelPeak2,\
                       XmNlabelString, XmStringCreateLtoR (cptr, \
                       XmSTRING_DEFAULT_CHARSET),\
                       NULL);\
 \
        sprintf (tmp, "%d", tiepar);\
        XmTextFieldSetString (textTie_par, tmp);\
 \
        switch (ctype)\
        {\
          case 0:\
              XtVaSetValues (tieMenu1,\
                             XmNmenuHistory, tieMenu_equal,\
                             NULL);\
              setH (FALSE, ih); setK (FALSE, ik); setL (FALSE, il);\
              break;\
              \
          case 1:\
              XtVaSetValues (tieMenu1,\
                             XmNmenuHistory, tieMenu_hex,\
                             NULL);\
              setH (TRUE, il); setK (TRUE, il);\
              break;\
          case 2:\
              XtVaSetValues (tieMenu1,\
                             XmNmenuHistory, tieMenu_tet,\
                             NULL);\
              setH (TRUE, il); setK (TRUE, il);\
              break;\
              \
         case 3:\
              XtVaSetValues (tieMenu1,\
                             XmNmenuHistory, tieMenu_cub,\
                             NULL);\
              setH (TRUE, il); setK (TRUE, il); setL (TRUE, il);\
         default:\
              break;\
        }\
    }\
    else\
    {\
          /* Error Dialog */\
    }\
}\
else\
{\
    if (par == 0)\
    {\
        par = 1;\
        XtSetSensitive (arrowButton2, FALSE);\
        XtSetSensitive (arrowButton1, TRUE);\
    }\
    else\
    {\
        par--;\
        XtSetSensitive (arrowButton2, TRUE);\
        XtSetSensitive (arrowButton1, FALSE);\
    }\
 \
}\

*tieDialog_tput.methodSpec: virtual
*tieDialog_tput.accessSpec: public

*tieDialog_tshow.class: method
*tieDialog_tshow.name: tshow
*tieDialog_tshow.parent: tieDialog
*tieDialog_tshow.methodType: void
*tieDialog_tshow.methodArgs: int num;\

*tieDialog_tshow.methodBody: cpar = par = num;\
setupDialog_getStateN (setup, &UxEnv, num, &istate);\
tieDialog_tput (UxThis, pEnv);\
UxPopupInterface (UxThis, no_grab);\

*tieDialog_tshow.methodSpec: virtual
*tieDialog_tshow.accessSpec: public
*tieDialog_tshow.arguments: num
*tieDialog_tshow.num.def: "int", "%num%"

*tieDialog.static: true
*tieDialog.name: tieDialog
*tieDialog.parent: NO_PARENT
*tieDialog.parentExpression: UxParent
*tieDialog.defaultShell: topLevelShell
*tieDialog.width: 365
*tieDialog.height: 270
*tieDialog.msgDialogType: "dialog_template"
*tieDialog.isCompound: "true"
*tieDialog.compoundIcon: "templateD.xpm"
*tieDialog.compoundName: "template_Dialog"
*tieDialog.x: 360
*tieDialog.y: 400
*tieDialog.unitType: "pixels"
*tieDialog.dialogTitle: "Tie Dialog"
*tieDialog.okLabelString: "OK"
*tieDialog.labelFontList: "8x13bold"
*tieDialog.buttonFontList: "8x13bold"
*tieDialog.textFontList: "8x13bold"
*tieDialog.resizePolicy: "resize_none"
*tieDialog.isResizable: "false"
*tieDialog.messageString: ""
*tieDialog.cancelCallback: {\
#include "tieDialog_applyCB.c"\
}
*tieDialog.helpCallback: {\
setupDialog_setStateN (setup, &UxEnv, cpar, istate);\
UxPopdownInterface (UxThisWidget);\
}
*tieDialog.okCallback: {\
#include "tieDialog_applyCB.c"\
setupDialog_getStateN (setup, &UxEnv, cpar, &istate);\
setupDialog_setStateN (setup, &UxEnv, cpar, istate);\
UxPopdownInterface (UxThisWidget);\
\
}
*tieDialog.marginHeight: 5
*tieDialog.minimizeButtons: "false"
*tieDialog.cancelLabelString: "Apply"
*tieDialog.helpLabelString: "Cancel"
*tieDialog.autoUnmanage: "false"

*form2.class: form
*form2.static: true
*form2.name: form2
*form2.parent: tieDialog
*form2.isCompound: "true"
*form2.compoundIcon: "form.xpm"
*form2.compoundName: "form_"

*label1.class: label
*label1.static: true
*label1.name: label1
*label1.parent: form2
*label1.isCompound: "true"
*label1.compoundIcon: "label.xpm"
*label1.compoundName: "label_"
*label1.width: 90
*label1.height: 30
*label1.fontList: "8x13bold"
*label1.labelString: "Parameter"
*label1.alignment: "alignment_beginning"
*label1.leftAttachment: "attach_form"
*label1.rightAttachment: "attach_none"
*label1.topOffset: 5
*label1.topAttachment: "attach_form"

*label2.class: label
*label2.static: true
*label2.name: label2
*label2.parent: form2
*label2.isCompound: "true"
*label2.compoundIcon: "label.xpm"
*label2.compoundName: "label_"
*label2.width: 140
*label2.height: 30
*label2.fontList: "8x13bold"
*label2.labelString: "Tie to parameter"
*label2.alignment: "alignment_beginning"
*label2.leftAttachment: "attach_form"
*label2.topAttachment: "attach_form"
*label2.topOffset: 50

*textTie_par.class: textField
*textTie_par.static: true
*textTie_par.name: textTie_par
*textTie_par.parent: form2
*textTie_par.width: 40
*textTie_par.isCompound: "true"
*textTie_par.compoundIcon: "textfield.xpm"
*textTie_par.compoundName: "text_Field"
*textTie_par.fontList: "8x13bold"
*textTie_par.height: 30
*textTie_par.columns: 2
*textTie_par.text: "1"
*textTie_par.leftAttachment: "attach_form"
*textTie_par.leftOffset: 140
*textTie_par.topAttachment: "attach_form"
*textTie_par.topOffset: 48
*textTie_par.x: 148

*tieMenu1.class: rowColumn
*tieMenu1.static: true
*tieMenu1.name: tieMenu1
*tieMenu1.parent: form2
*tieMenu1.rowColumnType: "menu_option"
*tieMenu1.subMenuId: "tieMenu_p1"
*tieMenu1.isCompound: "true"
*tieMenu1.compoundIcon: "optionM.xpm"
*tieMenu1.compoundName: "option_Menu"
*tieMenu1.compoundEditor: {\
extern swidget UxGUIMePopup UXPROTO((swidget, swidget, int, int));\
UxGUIMePopup(UxThisWidget, NULL, 2, 0);\
}
*tieMenu1.x: -44
*tieMenu1.y: 0
*tieMenu1.width: 100
*tieMenu1.height: 30
*tieMenu1.leftAttachment: "attach_form"
*tieMenu1.leftOffset: 145
*tieMenu1.topAttachment: "attach_form"
*tieMenu1.topOffset: 95

*tieMenu_p1.class: rowColumn
*tieMenu_p1.static: true
*tieMenu_p1.name: tieMenu_p1
*tieMenu_p1.parent: tieMenu1
*tieMenu_p1.rowColumnType: "menu_pulldown"

*tieMenu_equal.class: pushButton
*tieMenu_equal.static: true
*tieMenu_equal.name: tieMenu_equal
*tieMenu_equal.parent: tieMenu_p1
*tieMenu_equal.labelString: "Equality"
*tieMenu_equal.fontList: "8x13bold"
*tieMenu_equal.activateCallback: sprintf (constraint, "");\
setH (FALSE, 0); setK (FALSE, 0); setL (FALSE, 0);

*tieMenu_hex.class: pushButton
*tieMenu_hex.static: true
*tieMenu_hex.name: tieMenu_hex
*tieMenu_hex.parent: tieMenu_p1
*tieMenu_hex.labelString: "Hexagonal"
*tieMenu_hex.fontList: "8x13bold"
*tieMenu_hex.activateCallback: sprintf (constraint, "hex");\
setH (TRUE, ih); setK (TRUE, ik); setL (FALSE, 0);

*tieMenu_tet.class: pushButton
*tieMenu_tet.static: true
*tieMenu_tet.name: tieMenu_tet
*tieMenu_tet.parent: tieMenu_p1
*tieMenu_tet.labelString: "Tetragonal"
*tieMenu_tet.fontList: "8x13bold"
*tieMenu_tet.activateCallback: sprintf (constraint, "tet");\
setH (TRUE, ih); setK (TRUE, ik); setL (FALSE, 0);\


*tieMenu_cub.class: pushButton
*tieMenu_cub.static: true
*tieMenu_cub.name: tieMenu_cub
*tieMenu_cub.parent: tieMenu_p1
*tieMenu_cub.labelString: "Cubic"
*tieMenu_cub.fontList: "8x13bold"
*tieMenu_cub.activateCallback: sprintf (constraint, "cub");\
setH (TRUE, ih); setK (TRUE, ik); setL (TRUE, il);

*label5.class: label
*label5.static: true
*label5.name: label5
*label5.parent: form2
*label5.isCompound: "true"
*label5.compoundIcon: "label.xpm"
*label5.compoundName: "label_"
*label5.width: 50
*label5.height: 30
*label5.fontList: "8x13bold"
*label5.labelString: "h"
*label5.sensitive: "false"
*label5.topAttachment: "attach_form"
*label5.topOffset: 130
*label5.leftAttachment: "attach_form"
*label5.leftOffset: 20

*textH.class: textField
*textH.static: true
*textH.name: textH
*textH.parent: form2
*textH.width: 50
*textH.isCompound: "true"
*textH.compoundIcon: "textfield.xpm"
*textH.compoundName: "text_Field"
*textH.fontList: "8x13bold"
*textH.height: 30
*textH.columns: 4
*textH.text: "1"
*textH.sensitive: "false"
*textH.topAttachment: "attach_form"
*textH.topOffset: 160
*textH.leftAttachment: "attach_form"
*textH.leftOffset: 20

*label6.class: label
*label6.static: true
*label6.name: label6
*label6.parent: form2
*label6.isCompound: "true"
*label6.compoundIcon: "label.xpm"
*label6.compoundName: "label_"
*label6.width: 50
*label6.height: 30
*label6.fontList: "8x13bold"
*label6.labelString: "k"
*label6.sensitive: "false"
*label6.topAttachment: "attach_form"
*label6.topOffset: 130
*label6.leftAttachment: "attach_form"
*label6.leftOffset: 140

*arrowButton2.class: arrowButton
*arrowButton2.static: true
*arrowButton2.name: arrowButton2
*arrowButton2.parent: form2
*arrowButton2.isCompound: "true"
*arrowButton2.compoundIcon: "arrow.xpm"
*arrowButton2.compoundName: "arrow_Button"
*arrowButton2.width: 20
*arrowButton2.height: 20
*arrowButton2.arrowDirection: "arrow_down"
*arrowButton2.activateCallback: {\
#include "tieDialog_applyCB.c"\
par--;\
tieDialog_tput (UxThisWidget, &UxEnv);\
}
*arrowButton2.leftAttachment: "attach_form"
*arrowButton2.leftOffset: 130
*arrowButton2.topOffset: 20
*arrowButton2.topAttachment: "attach_form"

*textK.class: textField
*textK.static: true
*textK.name: textK
*textK.parent: form2
*textK.width: 50
*textK.isCompound: "true"
*textK.compoundIcon: "textfield.xpm"
*textK.compoundName: "text_Field"
*textK.fontList: "8x13bold"
*textK.height: 30
*textK.columns: 4
*textK.text: "1"
*textK.sensitive: "false"
*textK.topAttachment: "attach_form"
*textK.topOffset: 160
*textK.leftAttachment: "attach_form"
*textK.leftOffset: 140

*label7.class: label
*label7.static: true
*label7.name: label7
*label7.parent: form2
*label7.isCompound: "true"
*label7.compoundIcon: "label.xpm"
*label7.compoundName: "label_"
*label7.width: 50
*label7.height: 30
*label7.fontList: "8x13bold"
*label7.labelString: "l"
*label7.sensitive: "false"
*label7.topAttachment: "attach_form"
*label7.topOffset: 130
*label7.leftAttachment: "attach_form"
*label7.leftOffset: 260

*textL.class: textField
*textL.static: true
*textL.name: textL
*textL.parent: form2
*textL.width: 50
*textL.isCompound: "true"
*textL.compoundIcon: "textfield.xpm"
*textL.compoundName: "text_Field"
*textL.fontList: "8x13bold"
*textL.height: 30
*textL.columns: 4
*textL.text: "1"
*textL.sensitive: "false"
*textL.topAttachment: "attach_form"
*textL.topOffset: 160
*textL.leftAttachment: "attach_form"
*textL.leftOffset: 260

*textPar.class: textField
*textPar.static: true
*textPar.name: textPar
*textPar.parent: form2
*textPar.width: 30
*textPar.isCompound: "true"
*textPar.compoundIcon: "textfield.xpm"
*textPar.compoundName: "text_Field"
*textPar.fontList: "8x13bold"
*textPar.height: 30
*textPar.columns: 2
*textPar.text: "1"
*textPar.cursorPositionVisible: "false"
*textPar.editable: "false"
*textPar.shadowThickness: 0
*textPar.leftAttachment: "attach_form"
*textPar.leftOffset: 90
*textPar.topAttachment: "attach_form"
*textPar.topOffset: 4

*labelPeak.class: label
*labelPeak.static: true
*labelPeak.name: labelPeak
*labelPeak.parent: form2
*labelPeak.isCompound: "true"
*labelPeak.compoundIcon: "label.xpm"
*labelPeak.compoundName: "label_"
*labelPeak.width: 180
*labelPeak.height: 30
*labelPeak.fontList: "8x13bold"
*labelPeak.labelString: "(Peak  1: position)"
*labelPeak.leftAttachment: "attach_form"
*labelPeak.leftOffset: 160
*labelPeak.topAttachment: "attach_form"
*labelPeak.topOffset: 5
*labelPeak.alignment: "alignment_beginning"

*labelPeak2.class: label
*labelPeak2.static: true
*labelPeak2.name: labelPeak2
*labelPeak2.parent: form2
*labelPeak2.isCompound: "true"
*labelPeak2.compoundIcon: "label.xpm"
*labelPeak2.compoundName: "label_"
*labelPeak2.width: 150
*labelPeak2.height: 30
*labelPeak2.fontList: "8x13bold"
*labelPeak2.labelString: "(Peak  1: position)"
*labelPeak2.alignment: "alignment_beginning"
*labelPeak2.leftAttachment: "attach_form"
*labelPeak2.leftOffset: 190
*labelPeak2.topAttachment: "attach_form"
*labelPeak2.topOffset: 50

*arrowButton1.class: arrowButton
*arrowButton1.static: true
*arrowButton1.name: arrowButton1
*arrowButton1.parent: form2
*arrowButton1.isCompound: "true"
*arrowButton1.compoundIcon: "arrow.xpm"
*arrowButton1.compoundName: "arrow_Button"
*arrowButton1.width: 20
*arrowButton1.height: 20
*arrowButton1.activateCallback: {\
#include "tieDialog_applyCB.c"\
par++;\
tieDialog_tput (UxThisWidget, &UxEnv);\
}
*arrowButton1.leftAttachment: "attach_form"
*arrowButton1.leftOffset: 130
*arrowButton1.topAttachment: "attach_form"
*arrowButton1.topOffset: 0

*label4.class: label
*label4.static: true
*label4.name: label4
*label4.parent: form2
*label4.isCompound: "true"
*label4.compoundIcon: "label.xpm"
*label4.compoundName: "label_"
*label4.height: 20
*label4.width: 140
*label4.labelString: "Constraint type:"
*label4.fontList: "8x13bold"
*label4.alignment: "alignment_beginning"
*label4.leftAttachment: "attach_form"
*label4.topAttachment: "attach_form"
*label4.topOffset: 100

