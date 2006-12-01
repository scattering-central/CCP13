! UIMX ascii 2.9 key: 6687                                                      

*setupDialog.class: formDialog
*setupDialog.classinc:
*setupDialog.classspec:
*setupDialog.classmembers:
*setupDialog.classconstructor:
*setupDialog.classdestructor:
*setupDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
#include <Xm/Separator.h>\
#include <Xm/Label.h>\
#ifndef DESIGN_TIME\
#include "peakRowColumn.h"\
#include "parRowColumn.h"\
#include "tieDialog.h"\
#include "limitDialog.h"\
#else\
extern swidget create_tieDialog ();\
extern swidget create_limitDialog ();\
#endif\
\
#include "mprintf.h"\
\
extern void SetBusyPointer (int);\
\
swidget tieD;\
swidget limitD;\
\
\
\

*setupDialog.ispecdecl: int npar, npeak, fexp, current_y;\
swidget peak_rowColInstance[20];\
swidget separator;\
swidget labelBack_poly_degree;\
swidget labelBack_exp_comp;\
swidget par_rowColInstance[51];\
Boolean stepitsChanged, maxitsChanged, chitestChanged, autowarnChanged;
*setupDialog.ispeclist: npar, npeak, fexp, current_y, peak_rowColInstance, separator, labelBack_poly_degree, labelBack_exp_comp, par_rowColInstance, stepitsChanged, maxitsChanged, chitestChanged, autowarnChanged
*setupDialog.ispeclist.npar: "int", "%npar%"
*setupDialog.ispeclist.npeak: "int", "%npeak%"
*setupDialog.ispeclist.fexp: "int", "%fexp%"
*setupDialog.ispeclist.current_y: "int", "%current_y%"
*setupDialog.ispeclist.peak_rowColInstance: "swidget", "%peak_rowColInstance%[20]"
*setupDialog.ispeclist.separator: "swidget", "%separator%"
*setupDialog.ispeclist.labelBack_poly_degree: "swidget", "%labelBack_poly_degree%"
*setupDialog.ispeclist.labelBack_exp_comp: "swidget", "%labelBack_exp_comp%"
*setupDialog.ispeclist.par_rowColInstance: "swidget", "%par_rowColInstance%[51]"
*setupDialog.ispeclist.stepitsChanged: "Boolean", "%stepitsChanged%"
*setupDialog.ispeclist.maxitsChanged: "Boolean", "%maxitsChanged%"
*setupDialog.ispeclist.chitestChanged: "Boolean", "%chitestChanged%"
*setupDialog.ispeclist.autowarnChanged: "Boolean", "%autowarnChanged%"
*setupDialog.funcdecl: swidget create_setupDialog(swidget UxParent)
*setupDialog.funcname: create_setupDialog
*setupDialog.funcdef: "swidget", "<create_setupDialog>(%)"
*setupDialog.argdecl: swidget UxParent;
*setupDialog.arglist: UxParent
*setupDialog.arglist.UxParent: "swidget", "%UxParent%"
*setupDialog.icode:
*setupDialog.fcode: tieD = create_tieDialog (rtrn);\
limitD = create_limitDialog (rtrn);\
npar = 0;\
npeak = 0;\
fexp = 0;\
current_y = 0;\
stepitsChanged = maxitsChanged = chitestChanged = autowarnChanged = False;\
return(rtrn);\

*setupDialog.auxdecl:
*setupDialog_setParRC.class: method
*setupDialog_setParRC.name: setParRC
*setupDialog_setParRC.parent: setupDialog
*setupDialog_setParRC.methodType: void
*setupDialog_setParRC.methodArgs: int n;\
char *string;\

*setupDialog_setParRC.methodBody: #include "setupDialog_setParRC.c"
*setupDialog_setParRC.methodSpec: virtual
*setupDialog_setParRC.accessSpec: public
*setupDialog_setParRC.arguments: n, string
*setupDialog_setParRC.n.def: "int", "%n%"
*setupDialog_setParRC.string.def: "char", "*%string%"

*setupDialog_setTieN.class: method
*setupDialog_setTieN.name: setTieN
*setupDialog_setTieN.parent: setupDialog
*setupDialog_setTieN.methodType: void
*setupDialog_setTieN.methodArgs: int n;\
int t_num;\
int c_type;\
int ih;\
int ik;\
int il;\

*setupDialog_setTieN.methodBody: #include "setupDialog_setTie.c"
*setupDialog_setTieN.methodSpec: virtual
*setupDialog_setTieN.accessSpec: public
*setupDialog_setTieN.arguments: n, t_num, c_type, ih, ik, il
*setupDialog_setTieN.n.def: "int", "%n%"
*setupDialog_setTieN.t_num.def: "int", "%t_num%"
*setupDialog_setTieN.c_type.def: "int", "%c_type%"
*setupDialog_setTieN.ih.def: "int", "%ih%"
*setupDialog_setTieN.ik.def: "int", "%ik%"
*setupDialog_setTieN.il.def: "int", "%il%"

*setupDialog_getTieN.class: method
*setupDialog_getTieN.name: getTieN
*setupDialog_getTieN.parent: setupDialog
*setupDialog_getTieN.methodType: void
*setupDialog_getTieN.methodArgs: int n;\
int *t_num;\
int *c_type;\
int *ih;\
int *ik;\
int *il;\

*setupDialog_getTieN.methodBody: parRowColumn_getTie (par_rowColInstance[n], &UxEnv, t_num, c_type, ih, ik, il);
*setupDialog_getTieN.methodSpec: virtual
*setupDialog_getTieN.accessSpec: public
*setupDialog_getTieN.arguments: n, t_num, c_type, ih, ik, il
*setupDialog_getTieN.n.def: "int", "%n%"
*setupDialog_getTieN.t_num.def: "int", "*%t_num%"
*setupDialog_getTieN.c_type.def: "int", "*%c_type%"
*setupDialog_getTieN.ih.def: "int", "*%ih%"
*setupDialog_getTieN.ik.def: "int", "*%ik%"
*setupDialog_getTieN.il.def: "int", "*%il%"

*setupDialog_checkValN.class: method
*setupDialog_checkValN.name: checkValN
*setupDialog_checkValN.parent: setupDialog
*setupDialog_checkValN.methodType: int
*setupDialog_checkValN.methodArgs: int n;\
double *v;\

*setupDialog_checkValN.methodBody: #include "setupDialog_checkVal.c"
*setupDialog_checkValN.methodSpec: virtual
*setupDialog_checkValN.accessSpec: public
*setupDialog_checkValN.arguments: n, v
*setupDialog_checkValN.n.def: "int", "%n%"
*setupDialog_checkValN.v.def: "double", "*%v%"

*setupDialog_reinit.class: method
*setupDialog_reinit.name: reinit
*setupDialog_reinit.parent: setupDialog
*setupDialog_reinit.methodType: void
*setupDialog_reinit.methodArgs: 
*setupDialog_reinit.methodBody: #include "setupDialog_reinit.c"
*setupDialog_reinit.methodSpec: virtual
*setupDialog_reinit.accessSpec: public

*setupDialog_put.class: method
*setupDialog_put.name: put
*setupDialog_put.parent: setupDialog
*setupDialog_put.methodType: int
*setupDialog_put.methodArgs: char *string;\

*setupDialog_put.methodBody: static char descr[20];\
  char peak_label[20], par_label[20], description[20], buf[80], *cptr;\
  static int lastpeak = 0;\
  int poly_degree, par_number;\
  double par_value;\
 \
  cptr = strtok (string, " \n");\
  if (!cptr)\
    {\
      return;\
    }\
 \
#ifndef DESIGN_TIME\
   while (*cptr)\
     {\
       if (strcmp (cptr, "Peak") == 0)\
         {\
           cptr = strtok (NULL, " ");\
           lastpeak = atoi (cptr);\
           cptr = strtok (NULL, " ");\
           sprintf (descr, "Peak %2d", lastpeak);\
           \
           /* Creation of peak_rowColInstance(lastpeak) */\
           peak_rowColInstance[lastpeak] = create_peakRowColumn( form3, descr, cptr);\
           UxPUT_PROPERTY(peak_rowColInstance[lastpeak],x,int,0);\
           UxPUT_PROPERTY(peak_rowColInstance[lastpeak],y,int,current_y);\
           UxPUT_PROPERTY(peak_rowColInstance[lastpeak],width,int,300);\
           UxPUT_PROPERTY(peak_rowColInstance[lastpeak],height,int,30);\
           \
           Interface_UxManage(peak_rowColInstance[lastpeak], &UxEnv );  \
           npeak++;\
           break;\
         }\
       \
       else if (strcmp (cptr, "Polynomial") == 0)\
         {\
           cptr = strtok (NULL, "=");\
           cptr = strtok (NULL, " ");\
           poly_degree = atoi (cptr);\
           sprintf (buf, "Polynomial background degree  %d", poly_degree);\
           sprintf (descr, "Polynomial");\
           \
           /* Creation of separator */\
           separator = XtVaCreateManagedWidget( "separator",\
                                               xmSeparatorWidgetClass,\
                                               form3,\
                                               XmNwidth, 630,\
                                               XmNheight, 10,\
                                               XmNx, 0,\
                                               XmNy, current_y,\
                                               NULL );\
           UxPutContext( separator, (char *) UxSetupDialogContext ); \
 \
           /* Creation of labelBack_poly_degree */\
           current_y += 20;\
           labelBack_poly_degree = XtVaCreateManagedWidget( "labelBack_poly_degree",\
                                                           xmLabelWidgetClass,\
                                                           form3,\
                                                           XmNx, 10,\
                                                           XmNy, current_y,\
                                                           XmNwidth, 250,\
                                                           XmNheight, 30,\
                                                           RES_CONVERT( XmNlabelString, buf ),\
                                                           XmNfontList, UxConvertFontList( "8x13bold" ),\
                                                           NULL );\
           UxPutContext( labelBack_poly_degree, (char *) UxSetupDialogContext );\
           break;\
         }\
 \
       else if (strcmp (cptr, "Exponential") == 0)\
         {\
           sprintf (descr, "Exponential");\
           /* Creation of labelBack_exp_comp */\
           labelBack_exp_comp = XtVaCreateManagedWidget( "labelBack_exp_comp",\
                                                        xmLabelWidgetClass,\
                                                        form3,\
                                                        XmNx, 10,\
                                                        XmNy, current_y,\
                                                        XmNwidth, 250,\
                                                        XmNheight, 30,\
                                                        RES_CONVERT( XmNlabelString, "Exponential background component" ),\
                                                        XmNfontList, UxConvertFontList( "8x13bold" ),\
                                                        NULL );\
           UxPutContext( labelBack_exp_comp, (char *) UxSetupDialogContext );  \
           fexp = 1;\
           break;\
         }\
       \
       else if (strcmp (cptr, "Parameter") == 0)\
         {\
           cptr = strtok (NULL, " ");\
           par_number = atoi (cptr);\
           cptr = strtok (NULL, " ");\
           (void) strcpy (par_label, cptr);\
           sprintf (description, "(%s: %s)", descr, par_label);\
           cptr = strtok (NULL, " ");\
           par_value = atof (cptr);\
           sprintf (buf, "%2d  %s:", par_number, par_label);\
           sprintf (par_label, "%g", par_value);\
           \
           /* Creation of par_rowColInstance */\
           par_rowColInstance[par_number] = create_parRowColumn( form3, buf, par_label, description);\
           UxPUT_PROPERTY(par_rowColInstance[par_number],x,int,0);\
           UxPUT_PROPERTY(par_rowColInstance[par_number],y,int,current_y);\
           UxPUT_PROPERTY(par_rowColInstance[par_number],width,int,630);\
           UxPUT_PROPERTY(par_rowColInstance[par_number],height,int,30);\
           \
           Interface_UxManage(par_rowColInstance[par_number], &UxEnv );  \
           npar++;\
           break;\
         }\
       else\
         {\
           cptr++;\
         }\
 \
     }\
   current_y += 40;\
   if (current_y > 400)\
     {\
       XtVaSetValues (UxGetWidget (form3),\
                      XmNheight, current_y,\
                      NULL);\
     }\
#endif\

*setupDialog_put.methodSpec: virtual
*setupDialog_put.accessSpec: public
*setupDialog_put.arguments: string
*setupDialog_put.string.def: "char", "*%string%"

*setupDialog_set.class: method
*setupDialog_set.name: set
*setupDialog_set.parent: setupDialog
*setupDialog_set.methodType: int
*setupDialog_set.methodArgs: char *string;\

*setupDialog_set.methodBody: #include "setupDialog_set.c"
*setupDialog_set.methodSpec: virtual
*setupDialog_set.accessSpec: public
*setupDialog_set.arguments: string
*setupDialog_set.string.def: "char", "*%string%"

*setupDialog_quit.class: method
*setupDialog_quit.name: quit
*setupDialog_quit.parent: setupDialog
*setupDialog_quit.methodType: int
*setupDialog_quit.methodArgs: 
*setupDialog_quit.methodBody: int i;\
 \
  UxPopdownInterface (UxThis);\
 \
  for (i=1; i<=npeak; i++)\
    {\
      XtDestroyWidget (peak_rowColInstance[i]);\
    }\
 \
  for (i=1; i<=npar; i++)\
    {\
      XtDestroyWidget (par_rowColInstance[i]);\
    }\
 \
  XtDestroyWidget (separator);\
  XtDestroyWidget (labelBack_poly_degree);\
  if (fexp)\
    XtDestroyWidget (labelBack_exp_comp);\
 \
  npar = 0;\
  npeak = 0;\
  fexp = 0;\
  current_y = 10;\
 \
  XtVaSetValues (UxGetWidget (form3),\
                 XmNheight, 400,\
                 NULL);\
 \
  return;\

*setupDialog_quit.methodSpec: virtual
*setupDialog_quit.accessSpec: public

*setupDialog_sensitive.class: method
*setupDialog_sensitive.name: sensitive
*setupDialog_sensitive.parent: setupDialog
*setupDialog_sensitive.methodType: int
*setupDialog_sensitive.methodArgs: Boolean tf;\

*setupDialog_sensitive.methodBody: #include "setupDialog_SetSensitive.c"
*setupDialog_sensitive.methodSpec: virtual
*setupDialog_sensitive.accessSpec: public
*setupDialog_sensitive.arguments: tf
*setupDialog_sensitive.tf.def: "Boolean", "%tf%"

*setupDialog_setLimitsN.class: method
*setupDialog_setLimitsN.name: setLimitsN
*setupDialog_setLimitsN.parent: setupDialog
*setupDialog_setLimitsN.methodType: void
*setupDialog_setLimitsN.methodArgs: int n;\
double lim1;\
double lim2;\

*setupDialog_setLimitsN.methodBody: #include "setupDialog_setLimits.c"
*setupDialog_setLimitsN.methodSpec: virtual
*setupDialog_setLimitsN.accessSpec: public
*setupDialog_setLimitsN.arguments: n, lim1, lim2
*setupDialog_setLimitsN.n.def: "int", "%n%"
*setupDialog_setLimitsN.lim1.def: "double", "%lim1%"
*setupDialog_setLimitsN.lim2.def: "double", "%lim2%"

*setupDialog_setStateN.class: method
*setupDialog_setStateN.name: setStateN
*setupDialog_setStateN.parent: setupDialog
*setupDialog_setStateN.methodType: void
*setupDialog_setStateN.methodArgs: int n;\
int istate;\

*setupDialog_setStateN.methodBody: #include "setupDialog_setState.c"
*setupDialog_setStateN.methodSpec: virtual
*setupDialog_setStateN.accessSpec: public
*setupDialog_setStateN.arguments: n, istate
*setupDialog_setStateN.n.def: "int", "%n%"
*setupDialog_setStateN.istate.def: "int", "%istate%"

*setupDialog_getLimitsN.class: method
*setupDialog_getLimitsN.name: getLimitsN
*setupDialog_getLimitsN.parent: setupDialog
*setupDialog_getLimitsN.methodType: void
*setupDialog_getLimitsN.methodArgs: int n;\
double *lim1;\
double *lim2;\

*setupDialog_getLimitsN.methodBody: parRowColumn_getLimits (par_rowColInstance[n], &UxEnv, lim1, lim2);
*setupDialog_getLimitsN.methodSpec: virtual
*setupDialog_getLimitsN.accessSpec: public
*setupDialog_getLimitsN.arguments: n, lim1, lim2
*setupDialog_getLimitsN.n.def: "int", "%n%"
*setupDialog_getLimitsN.lim1.def: "double", "*%lim1%"
*setupDialog_getLimitsN.lim2.def: "double", "*%lim2%"

*setupDialog_getDescrN.class: method
*setupDialog_getDescrN.name: getDescrN
*setupDialog_getDescrN.parent: setupDialog
*setupDialog_getDescrN.methodType: char*
*setupDialog_getDescrN.methodArgs: int n;\

*setupDialog_getDescrN.methodBody: char *cptr = NULL;\
 \
if (n > 0 && n <= npar)\
    cptr = (char *) parRowColumn_getDescr (par_rowColInstance[n], &UxEnv);\
 \
return (cptr);\

*setupDialog_getDescrN.methodSpec: virtual
*setupDialog_getDescrN.accessSpec: public
*setupDialog_getDescrN.arguments: n
*setupDialog_getDescrN.n.def: "int", "%n%"

*setupDialog_getStateN.class: method
*setupDialog_getStateN.name: getStateN
*setupDialog_getStateN.parent: setupDialog
*setupDialog_getStateN.methodType: void
*setupDialog_getStateN.methodArgs: int n;\
int *istate;\

*setupDialog_getStateN.methodBody: parRowColumn_getState (par_rowColInstance[n], &UxEnv, istate);\

*setupDialog_getStateN.methodSpec: virtual
*setupDialog_getStateN.accessSpec: public
*setupDialog_getStateN.arguments: n, istate
*setupDialog_getStateN.n.def: "int", "%n%"
*setupDialog_getStateN.istate.def: "int", "*%istate%"

*setupDialog.name.source: public
*setupDialog.static: false
*setupDialog.name: setupDialog
*setupDialog.parent: NO_PARENT
*setupDialog.parentExpression: UxParent
*setupDialog.defaultShell: topLevelShell
*setupDialog.width: 640
*setupDialog.height: 300
*setupDialog.isCompound: "true"
*setupDialog.compoundIcon: "formD.xpm"
*setupDialog.compoundName: "form_Dialog"
*setupDialog.x: 277
*setupDialog.y: 222
*setupDialog.unitType: "pixels"
*setupDialog.dialogTitle: "Setup form"
*setupDialog.foreground: "white"
*setupDialog.highlightColor: "white"
*setupDialog.labelFontList: "8x13bold"
*setupDialog.textFontList: "8x13bold"
*setupDialog.buttonFontList: "8x13bold"
*setupDialog.createManaged: "false"
*setupDialog.autoUnmanage: "false"
*setupDialog.mapCallback: {\
\
}

*scrolledWindow2.class: scrolledWindow
*scrolledWindow2.static: true
*scrolledWindow2.name: scrolledWindow2
*scrolledWindow2.parent: setupDialog
*scrolledWindow2.scrollingPolicy: "automatic"
*scrolledWindow2.width: 650
*scrolledWindow2.height: 390
*scrolledWindow2.isCompound: "true"
*scrolledWindow2.compoundIcon: "scrlwnd.xpm"
*scrolledWindow2.compoundName: "scrolled_Window"
*scrolledWindow2.x: 0
*scrolledWindow2.y: 40
*scrolledWindow2.leftAttachment: "attach_form"
*scrolledWindow2.rightAttachment: "attach_form"
*scrolledWindow2.topAttachment: "attach_form"
*scrolledWindow2.bottomAttachment: "attach_form"
*scrolledWindow2.bottomOffset: 60
*scrolledWindow2.scrollBarDisplayPolicy: "static"
*scrolledWindow2.visualPolicy: "variable"
*scrolledWindow2.scrolledWindowMarginHeight: 5
*scrolledWindow2.scrolledWindowMarginWidth: 5
*scrolledWindow2.topOffset: 40

*form3.class: form
*form3.static: true
*form3.name: form3
*form3.parent: scrolledWindow2
*form3.resizePolicy: "resize_none"
*form3.width: 630
*form3.height: 400
*form3.createCallback: {\
\
}

*pushButton_plot.class: pushButton
*pushButton_plot.static: true
*pushButton_plot.name: pushButton_plot
*pushButton_plot.parent: setupDialog
*pushButton_plot.isCompound: "true"
*pushButton_plot.compoundIcon: "push.xpm"
*pushButton_plot.compoundName: "push_Button"
*pushButton_plot.x: 50
*pushButton_plot.y: 420
*pushButton_plot.width: 90
*pushButton_plot.height: 40
*pushButton_plot.bottomAttachment: "attach_form"
*pushButton_plot.leftAttachment: "attach_form"
*pushButton_plot.bottomOffset: 6
*pushButton_plot.leftOffset: 50
*pushButton_plot.fontList: "8x13bold"
*pushButton_plot.foreground: "white"
*pushButton_plot.highlightColor: "white"
*pushButton_plot.labelString: "PLOT"
*pushButton_plot.background: "rosybrown"
*pushButton_plot.activateCallback: {\
setupDialog_reinit (setupDialog, &UxEnv);\
command ("plot\n");\
}

*pushButton_step.class: pushButton
*pushButton_step.static: true
*pushButton_step.name: pushButton_step
*pushButton_step.parent: setupDialog
*pushButton_step.isCompound: "true"
*pushButton_step.compoundIcon: "push.xpm"
*pushButton_step.compoundName: "push_Button"
*pushButton_step.x: 274
*pushButton_step.y: 254
*pushButton_step.width: 90
*pushButton_step.height: 40
*pushButton_step.fontList: "8x13bold"
*pushButton_step.foreground: "white"
*pushButton_step.highlightColor: "white"
*pushButton_step.labelString: "STEP"
*pushButton_step.background: "rosybrown"
*pushButton_step.bottomAttachment: "attach_form"
*pushButton_step.bottomOffset: 6
*pushButton_step.activateCallback: {\
setupDialog_reinit (setupDialog, &UxEnv);\
command ("step\n");\
SetBusyPointer (TRUE);\
command ("print\n");\
}

*pushButton_run.class: pushButton
*pushButton_run.static: true
*pushButton_run.name: pushButton_run
*pushButton_run.parent: setupDialog
*pushButton_run.isCompound: "true"
*pushButton_run.compoundIcon: "push.xpm"
*pushButton_run.compoundName: "push_Button"
*pushButton_run.x: 508
*pushButton_run.y: 255
*pushButton_run.width: 90
*pushButton_run.height: 40
*pushButton_run.fontList: "8x13bold"
*pushButton_run.foreground: "white"
*pushButton_run.highlightColor: "white"
*pushButton_run.labelString: "RUN"
*pushButton_run.background: "rosybrown"
*pushButton_run.bottomAttachment: "attach_form"
*pushButton_run.bottomOffset: 6
*pushButton_run.activateCallback: {\
setupDialog_reinit (setupDialog, &UxEnv);\
command ("run\n");\
setupDialog_sensitive (setupDialog, &UxEnv, FALSE);\
SetBusyPointer (TRUE);\
/* UxPopdownInterface (setupDialog); */\
}

*separator1.class: separator
*separator1.static: true
*separator1.name: separator1
*separator1.parent: setupDialog
*separator1.width: 660
*separator1.height: 10
*separator1.isCompound: "true"
*separator1.compoundIcon: "sep.xpm"
*separator1.compoundName: "separator_"
*separator1.x: 0
*separator1.y: 450
*separator1.leftAttachment: "attach_form"
*separator1.rightAttachment: "attach_form"
*separator1.bottomAttachment: "attach_form"
*separator1.bottomOffset: 50

*stepLabel.class: label
*stepLabel.static: true
*stepLabel.name: stepLabel
*stepLabel.parent: setupDialog
*stepLabel.isCompound: "true"
*stepLabel.compoundIcon: "label.xpm"
*stepLabel.compoundName: "label_"
*stepLabel.width: 80
*stepLabel.height: 30
*stepLabel.leftOffset: 10
*stepLabel.topOffset: 10
*stepLabel.leftAttachment: "attach_form"
*stepLabel.topAttachment: "attach_form"
*stepLabel.fontList: "8x13bold"
*stepLabel.labelString: "Step its.:"

*stepText.class: textField
*stepText.static: true
*stepText.name: stepText
*stepText.parent: setupDialog
*stepText.width: 60
*stepText.isCompound: "true"
*stepText.compoundIcon: "textfield.xpm"
*stepText.compoundName: "text_Field"
*stepText.height: 30
*stepText.leftAttachment: "attach_form"
*stepText.leftOffset: 100
*stepText.topAttachment: "attach_form"
*stepText.topOffset: 10
*stepText.fontList: "8x13"
*stepText.text: "   1"
*stepText.columns: 4
*stepText.valueChangedCallback: {\
stepitsChanged = True;\
}

*runmaxLabel.class: label
*runmaxLabel.static: true
*runmaxLabel.name: runmaxLabel
*runmaxLabel.parent: setupDialog
*runmaxLabel.isCompound: "true"
*runmaxLabel.compoundIcon: "label.xpm"
*runmaxLabel.compoundName: "label_"
*runmaxLabel.width: 80
*runmaxLabel.height: 30
*runmaxLabel.fontList: "8x13bold"
*runmaxLabel.labelString: "+Max its.:"
*runmaxLabel.x: 160
*runmaxLabel.y: 10
*runmaxLabel.leftAttachment: "attach_form"
*runmaxLabel.leftOffset: 165
*runmaxLabel.topAttachment: "attach_form"
*runmaxLabel.topOffset: 10

*runmaxText.class: textField
*runmaxText.static: true
*runmaxText.name: runmaxText
*runmaxText.parent: setupDialog
*runmaxText.width: 60
*runmaxText.isCompound: "true"
*runmaxText.compoundIcon: "textfield.xpm"
*runmaxText.compoundName: "text_Field"
*runmaxText.height: 30
*runmaxText.fontList: "8x13"
*runmaxText.text: "  50"
*runmaxText.columns: 4
*runmaxText.x: 249
*runmaxText.y: 10
*runmaxText.topAttachment: "attach_form"
*runmaxText.topOffset: 10
*runmaxText.leftAttachment: "attach_form"
*runmaxText.leftOffset: 245
*runmaxText.valueChangedCallback: {\
maxitsChanged = True;\
}

*chitestLabel.class: label
*chitestLabel.static: true
*chitestLabel.name: chitestLabel
*chitestLabel.parent: setupDialog
*chitestLabel.isCompound: "true"
*chitestLabel.compoundIcon: "label.xpm"
*chitestLabel.compoundName: "label_"
*chitestLabel.width: 80
*chitestLabel.height: 30
*chitestLabel.fontList: "8x13bold"
*chitestLabel.labelString: "Chi-test:"
*chitestLabel.x: 302
*chitestLabel.y: 12
*chitestLabel.leftOffset: 330
*chitestLabel.leftAttachment: "attach_form"
*chitestLabel.topAttachment: "attach_form"
*chitestLabel.topOffset: 10

*chitestText.class: textField
*chitestText.static: true
*chitestText.name: chitestText
*chitestText.parent: setupDialog
*chitestText.width: 60
*chitestText.isCompound: "true"
*chitestText.compoundIcon: "textfield.xpm"
*chitestText.compoundName: "text_Field"
*chitestText.height: 30
*chitestText.fontList: "8x13"
*chitestText.text: " 0.1"
*chitestText.columns: 4
*chitestText.leftAttachment: "attach_form"
*chitestText.leftOffset: 410
*chitestText.topAttachment: "attach_form"
*chitestText.topOffset: 10
*chitestText.valueChangedCallback: {\
chitestChanged = True;\
}

*autowarnLabel.class: label
*autowarnLabel.static: true
*autowarnLabel.name: autowarnLabel
*autowarnLabel.parent: setupDialog
*autowarnLabel.isCompound: "true"
*autowarnLabel.compoundIcon: "label.xpm"
*autowarnLabel.compoundName: "label_"
*autowarnLabel.width: 80
*autowarnLabel.height: 30
*autowarnLabel.fontList: "8x13bold"
*autowarnLabel.labelString: "Auto-warn:"
*autowarnLabel.x: 441
*autowarnLabel.y: 9
*autowarnLabel.leftAttachment: "attach_form"
*autowarnLabel.leftOffset: 480
*autowarnLabel.topAttachment: "attach_form"
*autowarnLabel.topOffset: 10

*autowarnText.class: textField
*autowarnText.static: true
*autowarnText.name: autowarnText
*autowarnText.parent: setupDialog
*autowarnText.width: 60
*autowarnText.isCompound: "true"
*autowarnText.compoundIcon: "textfield.xpm"
*autowarnText.compoundName: "text_Field"
*autowarnText.height: 30
*autowarnText.fontList: "8x13"
*autowarnText.text: "10.0"
*autowarnText.columns: 4
*autowarnText.x: 529
*autowarnText.y: 8
*autowarnText.leftAttachment: "attach_form"
*autowarnText.leftOffset: 565
*autowarnText.topAttachment: "attach_form"
*autowarnText.topOffset: 10
*autowarnText.valueChangedCallback: {\
autowarnChanged = True;\
}

