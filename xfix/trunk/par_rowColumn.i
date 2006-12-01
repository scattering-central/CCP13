! UIMX ascii 2.6 key: 238                                                       

*parRowColumn.class: rowColumn
*parRowColumn.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
#include "tie.h"\
#include "limit.h"\
\
extern void command (char *, ...);\
\
extern swidget tieD;\
extern swidget limitD;
*parRowColumn.ispecdecl: int num, state, ch, ck, cl, constraint_type, tie_num;\
double val, limit1, limit2;\
char description[20];\

*parRowColumn.ispeclist: num, state, ch, ck, cl, constraint_type, tie_num, val, limit1, limit2, description
*parRowColumn.ispeclist.num: "int", "%num%"
*parRowColumn.ispeclist.state: "int", "%state%"
*parRowColumn.ispeclist.ch: "int", "%ch%"
*parRowColumn.ispeclist.ck: "int", "%ck%"
*parRowColumn.ispeclist.cl: "int", "%cl%"
*parRowColumn.ispeclist.constraint_type: "int", "%constraint_type%"
*parRowColumn.ispeclist.tie_num: "int", "%tie_num%"
*parRowColumn.ispeclist.val: "double", "%val%"
*parRowColumn.ispeclist.limit1: "double", "%limit1%"
*parRowColumn.ispeclist.limit2: "double", "%limit2%"
*parRowColumn.ispeclist.description: "char", "%description%[20]"
*parRowColumn.funcdecl: swidget create_parRowColumn(swidget UxParent, char *label, char *value, char *descr)
*parRowColumn.funcname: create_parRowColumn
*parRowColumn.funcdef: "swidget", "<create_parRowColumn>(%)"
*parRowColumn.argdecl: swidget UxParent;\
char *label;\
char *value;\
char *descr;
*parRowColumn.arglist: UxParent, label, value, descr
*parRowColumn.arglist.UxParent: "swidget", "%UxParent%"
*parRowColumn.arglist.label: "char", "*%label%"
*parRowColumn.arglist.value: "char", "*%value%"
*parRowColumn.arglist.descr: "char", "*%descr%"
*parRowColumn.icode:
*parRowColumn.fcode: XmTextFieldSetString (textVal, value);\
XtVaSetValues (labelPar,\
               XmNlabelString, XmStringCreateLtoR (label, XmSTRING_DEFAULT_CHARSET),\
               NULL);\
\
(void) strtok (label, " ");\
sscanf (label, "%d", &num);\
tie_num = num;\
val = atof (value);\
\
state = 0;\
ch = ck = cl = 0;\
constraint_type = 0;\
limit1 = limit2 = 0.0;\
(void) strcpy (description, descr);\
return(rtrn);\

*parRowColumn.auxdecl:
*parRowColumn_remLimits.class: method
*parRowColumn_remLimits.name: remLimits
*parRowColumn_remLimits.parent: parRowColumn
*parRowColumn_remLimits.methodType: void
*parRowColumn_remLimits.methodArgs: 
*parRowColumn_remLimits.methodBody: #include "par_rowColumn_remLimits.c"

*parRowColumn_remTie.class: method
*parRowColumn_remTie.name: remTie
*parRowColumn_remTie.parent: parRowColumn
*parRowColumn_remTie.methodType: void
*parRowColumn_remTie.methodArgs: 
*parRowColumn_remTie.methodBody: #include "par_rowColumn_remTie.c"

*parRowColumn_checkVal.class: method
*parRowColumn_checkVal.name: checkVal
*parRowColumn_checkVal.parent: parRowColumn
*parRowColumn_checkVal.methodType: int
*parRowColumn_checkVal.methodArgs: double *v;\

*parRowColumn_checkVal.methodBody: #include "par_rowColumn_checkVal.c"
*parRowColumn_checkVal.arguments: v
*parRowColumn_checkVal.v.def: "double", "*%v%"

*parRowColumn_set.class: method
*parRowColumn_set.name: set
*parRowColumn_set.parent: parRowColumn
*parRowColumn_set.methodType: int
*parRowColumn_set.methodArgs: char *string;\

*parRowColumn_set.methodBody: #include "par_rowColumn_set.c"
*parRowColumn_set.arguments: string
*parRowColumn_set.string.def: "char", "*%string%"

*parRowColumn_getLimits.class: method
*parRowColumn_getLimits.name: getLimits
*parRowColumn_getLimits.parent: parRowColumn
*parRowColumn_getLimits.methodType: int
*parRowColumn_getLimits.methodArgs: double *lim1;\
double *lim2;\

*parRowColumn_getLimits.methodBody: #include "par_rowColumn_getLimits.c"
*parRowColumn_getLimits.arguments: lim1, lim2
*parRowColumn_getLimits.lim1.def: "double", "*%lim1%"
*parRowColumn_getLimits.lim2.def: "double", "*%lim2%"

*parRowColumn_getState.class: method
*parRowColumn_getState.name: getState
*parRowColumn_getState.parent: parRowColumn
*parRowColumn_getState.methodType: int
*parRowColumn_getState.methodArgs: int *istate;\

*parRowColumn_getState.methodBody: #include "par_rowColumn_getState.c"
*parRowColumn_getState.arguments: istate
*parRowColumn_getState.istate.def: "int", "*%istate%"

*parRowColumn_getTie.class: method
*parRowColumn_getTie.name: getTie
*parRowColumn_getTie.parent: parRowColumn
*parRowColumn_getTie.methodType: int
*parRowColumn_getTie.methodArgs: int *t_num;\
int *c_type;\
int *ih;\
int *ik;\
int *il;\

*parRowColumn_getTie.methodBody: #include "par_rowColumn_getTie.c"
*parRowColumn_getTie.arguments: t_num, c_type, ih, ik, il
*parRowColumn_getTie.t_num.def: "int", "*%t_num%"
*parRowColumn_getTie.c_type.def: "int", "*%c_type%"
*parRowColumn_getTie.ih.def: "int", "*%ih%"
*parRowColumn_getTie.ik.def: "int", "*%ik%"
*parRowColumn_getTie.il.def: "int", "*%il%"

*parRowColumn_setLimits.class: method
*parRowColumn_setLimits.name: setLimits
*parRowColumn_setLimits.parent: parRowColumn
*parRowColumn_setLimits.methodType: int
*parRowColumn_setLimits.methodArgs: double lim1;\
double lim2;\

*parRowColumn_setLimits.methodBody: #include "par_rowColumn_setLimits.c"
*parRowColumn_setLimits.arguments: lim1, lim2
*parRowColumn_setLimits.lim1.def: "double", "%lim1%"
*parRowColumn_setLimits.lim2.def: "double", "%lim2%"

*parRowColumn_setState.class: method
*parRowColumn_setState.name: setState
*parRowColumn_setState.parent: parRowColumn
*parRowColumn_setState.methodType: int
*parRowColumn_setState.methodArgs: int istate;\

*parRowColumn_setState.methodBody: #include "par_rowColumn_setState.c"
*parRowColumn_setState.arguments: istate
*parRowColumn_setState.istate.def: "int", "%istate%"

*parRowColumn_setTie.class: method
*parRowColumn_setTie.name: setTie
*parRowColumn_setTie.parent: parRowColumn
*parRowColumn_setTie.methodType: int
*parRowColumn_setTie.methodArgs: int t_num;\
int c_type;\
int ih;\
int ik;\
int il;\

*parRowColumn_setTie.methodBody: #include "par_rowColumn_setTie.c"
*parRowColumn_setTie.arguments: t_num, c_type, ih, ik, il
*parRowColumn_setTie.t_num.def: "int", "%t_num%"
*parRowColumn_setTie.c_type.def: "int", "%c_type%"
*parRowColumn_setTie.ih.def: "int", "%ih%"
*parRowColumn_setTie.ik.def: "int", "%ik%"
*parRowColumn_setTie.il.def: "int", "%il%"

*parRowColumn_sensitive.class: method
*parRowColumn_sensitive.name: sensitive
*parRowColumn_sensitive.parent: parRowColumn
*parRowColumn_sensitive.methodType: int
*parRowColumn_sensitive.methodArgs: Boolean tf;\

*parRowColumn_sensitive.methodBody: #include "par_rowColumn_SetSensitive.c"
*parRowColumn_sensitive.arguments: tf
*parRowColumn_sensitive.tf.def: "Boolean", "%tf%"

*parRowColumn_getDes.class: method
*parRowColumn_getDes.name: getDes
*parRowColumn_getDes.parent: parRowColumn
*parRowColumn_getDes.methodType: char *
*parRowColumn_getDes.methodArgs: 
*parRowColumn_getDes.methodBody: #include "par_rowColumn_getDescr.c"

*parRowColumn.static: true
*parRowColumn.name: parRowColumn
*parRowColumn.parent: NO_PARENT
*parRowColumn.parentExpression: UxParent
*parRowColumn.defaultShell: topLevelShell
*parRowColumn.width: 630
*parRowColumn.height: 30
*parRowColumn.isCompound: "true"
*parRowColumn.compoundIcon: "row.xpm"
*parRowColumn.compoundName: "row_Column"
*parRowColumn.x: 310
*parRowColumn.y: 493
*parRowColumn.unitType: "pixels"
*parRowColumn.packing: "pack_none"
*parRowColumn.createManaged: "false"

*labelPar.class: label
*labelPar.static: true
*labelPar.name: labelPar
*labelPar.parent: parRowColumn
*labelPar.isCompound: "true"
*labelPar.compoundIcon: "label.xpm"
*labelPar.compoundName: "label_"
*labelPar.x: 10
*labelPar.y: 5
*labelPar.width: 100
*labelPar.height: 20
*labelPar.recomputeSize: "false"
*labelPar.alignment: "alignment_beginning"

*textVal.class: textField
*textVal.static: true
*textVal.name: textVal
*textVal.parent: parRowColumn
*textVal.width: 70
*textVal.isCompound: "true"
*textVal.compoundIcon: "textfield.xpm"
*textVal.compoundName: "text_Field"
*textVal.x: 110
*textVal.y: 0
*textVal.height: 30
*textVal.columns: 15

*parMenu.class: rowColumn
*parMenu.static: true
*parMenu.name: parMenu
*parMenu.parent: parRowColumn
*parMenu.rowColumnType: "menu_option"
*parMenu.subMenuId: "stateMenu1"
*parMenu.isCompound: "true"
*parMenu.compoundIcon: "optionM.xpm"
*parMenu.compoundName: "option_Menu"
*parMenu.compoundEditor: {\
extern swidget UxGUIMePopup UXPROTO((swidget, swidget, int, int));\
UxGUIMePopup(UxThisWidget, NULL, 2, 0);\
}
*parMenu.x: 240
*parMenu.y: -2
*parMenu.width: 80
*parMenu.height: 30
*parMenu.mapCallback: {\
\
}

*stateMenu1.class: rowColumn
*stateMenu1.static: true
*stateMenu1.name: stateMenu1
*stateMenu1.parent: parMenu
*stateMenu1.rowColumnType: "menu_pulldown"
*stateMenu1.createCallback: {\
\
}

*stateMenu_free1.class: pushButton
*stateMenu_free1.static: true
*stateMenu_free1.name: stateMenu_free1
*stateMenu_free1.parent: stateMenu1
*stateMenu_free1.labelString: "Free"
*stateMenu_free1.activateCallback: {\
command ("free %d\n", num);\
 \
parRowColumn_remLimits (UxThisWidget, &UxEnv);\
parRowColumn_remTie (UxThisWidget, &UxEnv);\
XtSetSensitive (UxGetWidget (textVal), TRUE);\
parRowColumn_setState (UxThisWidget, &UxEnv, 0);\
}
*stateMenu_free1.createCallback: {\
\
}

*stateMenu_set1.class: pushButton
*stateMenu_set1.static: true
*stateMenu_set1.name: stateMenu_set1
*stateMenu_set1.parent: stateMenu1
*stateMenu_set1.labelString: "Set"
*stateMenu_set1.activateCallback: {\
	double v;\
\
        command ("free %d\n", num);\
	if (parRowColumn_checkVal (UxThisWidget, &UxEnv, &v))\
            command ("set %d %g\n", num, v);\
	else\
	    command ("set %d\n", num);\
 \
        parRowColumn_remLimits (UxThisWidget, &UxEnv);\
        parRowColumn_remTie (UxThisWidget, &UxEnv);\
 \
        XtVaSetValues (UxGetWidget (textVal),\
                       XmNsensitive, FALSE,\
                       NULL);\
 	parRowColumn_setState (UxThisWidget, &UxEnv, 1);\
}
*stateMenu_set1.createCallback: {\
\
}

*stateMenu_limited1.class: pushButton
*stateMenu_limited1.static: true
*stateMenu_limited1.name: stateMenu_limited1
*stateMenu_limited1.parent: stateMenu1
*stateMenu_limited1.labelString: "Limit..."
*stateMenu_limited1.activateCallback: limitDialog_show (limitD, &UxEnv, num);
*stateMenu_limited1.createCallback: {\
\
}

*stateMenu_tied1.class: pushButton
*stateMenu_tied1.static: true
*stateMenu_tied1.name: stateMenu_tied1
*stateMenu_tied1.parent: stateMenu1
*stateMenu_tied1.labelString: "Tie..."
*stateMenu_tied1.activateCallback: tieDialog_sho (tieD, &UxEnv, num);
*stateMenu_tied1.createCallback: {\
\
}

*labelTieto.class: label
*labelTieto.static: true
*labelTieto.name: labelTieto
*labelTieto.parent: parRowColumn
*labelTieto.isCompound: "true"
*labelTieto.compoundIcon: "label.xpm"
*labelTieto.compoundName: "label_"
*labelTieto.x: 340
*labelTieto.y: 5
*labelTieto.width: 20
*labelTieto.height: 20
*labelTieto.recomputeSize: "false"
*labelTieto.labelString: "to"
*labelTieto.mappedWhenManaged: "false"

*textLimit1.class: textField
*textLimit1.static: true
*textLimit1.name: textLimit1
*textLimit1.parent: parRowColumn
*textLimit1.width: 50
*textLimit1.isCompound: "true"
*textLimit1.compoundIcon: "textfield.xpm"
*textLimit1.compoundName: "text_Field"
*textLimit1.x: 370
*textLimit1.y: 0
*textLimit1.height: 30
*textLimit1.mappedWhenManaged: "false"
*textLimit1.columns: 12

*labelLimto.class: label
*labelLimto.static: true
*labelLimto.name: labelLimto
*labelLimto.parent: parRowColumn
*labelLimto.isCompound: "true"
*labelLimto.compoundIcon: "label.xpm"
*labelLimto.compoundName: "label_"
*labelLimto.x: 480
*labelLimto.y: 5
*labelLimto.width: 20
*labelLimto.height: 20
*labelLimto.recomputeSize: "false"
*labelLimto.labelString: "to"
*labelLimto.mappedWhenManaged: "false"

*textLimit2.class: textField
*textLimit2.static: true
*textLimit2.name: textLimit2
*textLimit2.parent: parRowColumn
*textLimit2.width: 50
*textLimit2.isCompound: "true"
*textLimit2.compoundIcon: "textfield.xpm"
*textLimit2.compoundName: "text_Field"
*textLimit2.x: 510
*textLimit2.y: 0
*textLimit2.height: 30
*textLimit2.mappedWhenManaged: "false"
*textLimit2.columns: 12

