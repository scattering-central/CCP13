! UIMX ascii 2.9 key: 7184                                                      

*peakRowColumn.class: rowColumn
*peakRowColumn.gbldecl: #include <stdio.h>\

*peakRowColumn.ispecdecl:
*peakRowColumn.funcdecl: swidget create_peakRowColumn(swidget UxParent, char *label1, char *label2)
*peakRowColumn.funcname: create_peakRowColumn
*peakRowColumn.funcdef: "swidget", "<create_peakRowColumn>(%)"
*peakRowColumn.argdecl: swidget UxParent;\
char *label1;\
char *label2;
*peakRowColumn.arglist: UxParent, label1, label2
*peakRowColumn.arglist.UxParent: "swidget", "%UxParent%"
*peakRowColumn.arglist.label1: "char", "*%label1%"
*peakRowColumn.arglist.label2: "char", "*%label2%"
*peakRowColumn.icode:
*peakRowColumn.fcode: XtVaSetValues (labelPeak,\
               XmNlabelString, XmStringCreateLtoR (label1, XmSTRING_DEFAULT_CHARSET),\
               NULL);\
XtVaSetValues (labelPeaktype,\
               XmNlabelString, XmStringCreateLtoR (label2, XmSTRING_DEFAULT_CHARSET),\
               NULL);\
\
return(rtrn);\

*peakRowColumn.auxdecl:
*peakRowColumn.static: true
*peakRowColumn.name: peakRowColumn
*peakRowColumn.parent: NO_PARENT
*peakRowColumn.parentExpression: UxParent
*peakRowColumn.defaultShell: topLevelShell
*peakRowColumn.width: 300
*peakRowColumn.height: 30
*peakRowColumn.createManaged: "false"
*peakRowColumn.marginHeight: 0
*peakRowColumn.marginWidth: 10
*peakRowColumn.x: 0
*peakRowColumn.y: 0

*peakForm.class: form
*peakForm.static: true
*peakForm.name: peakForm
*peakForm.parent: peakRowColumn
*peakForm.resizePolicy: "resize_none"

*labelPeak.class: label
*labelPeak.static: true
*labelPeak.name: labelPeak
*labelPeak.parent: peakForm
*labelPeak.compoundIcon: "label.xpm"
*labelPeak.compoundName: "label_"
*labelPeak.width: 100
*labelPeak.height: 30
*labelPeak.labelString: label1 ? label1 : "not set"
*labelPeak.fontList: "8x13bold"
*labelPeak.alignment: "alignment_beginning"
*labelPeak.leftAttachment: "attach_form"
*labelPeak.leftOffset: 0
*labelPeak.topAttachment: "attach_form"
*labelPeak.topOffset: 0
*labelPeak.recomputeSize: "false"

*labelPeaktype.class: label
*labelPeaktype.static: true
*labelPeaktype.name: labelPeaktype
*labelPeaktype.parent: peakForm
*labelPeaktype.isCompound: "true"
*labelPeaktype.compoundIcon: "label.xpm"
*labelPeaktype.compoundName: "label_"
*labelPeaktype.width: 100
*labelPeaktype.height: 30
*labelPeaktype.labelString: label2 ? label2 : "not set"
*labelPeaktype.fontList: "8x13bold"
*labelPeaktype.alignment: "alignment_beginning"
*labelPeaktype.leftAttachment: "attach_form"
*labelPeaktype.topAttachment: "attach_form"
*labelPeaktype.leftOffset: 130
*labelPeaktype.recomputeSize: "false"

