! UIMX ascii 2.9 key: 4470                                                      

*confirmDialog.class: questionDialog
*confirmDialog.classinc:
*confirmDialog.classspec:
*confirmDialog.classmembers:
*confirmDialog.classconstructor:
*confirmDialog.classdestructor:
*confirmDialog.gbldecl: #include <stdio.h>\
\
void ConfirmDialogAsk (swidget, char *, void (*)(), void (*)(), char *);\
static void (*ok_function) ();\
static void (*cancel_function) ();\

*confirmDialog.ispecdecl: char *helpfile;
*confirmDialog.ispeclist: helpfile
*confirmDialog.ispeclist.helpfile: "char", "*%helpfile%"
*confirmDialog.funcdecl: swidget create_confirmDialog(UxParent)\
swidget UxParent;
*confirmDialog.funcname: create_confirmDialog
*confirmDialog.funcdef: "swidget", "<create_confirmDialog>(%)"
*confirmDialog.argdecl: swidget UxParent;
*confirmDialog.arglist: UxParent
*confirmDialog.arglist.UxParent: "swidget", "%UxParent%"
*confirmDialog.icode:
*confirmDialog.fcode: return (rtrn);\

*confirmDialog.auxdecl: void ConfirmDialogAsk (swidget wgt, char *msg, void (*yesfunc)(), void (*nofunc) (), char *helpptr)\
{\
    ok_function = yesfunc;\
    cancel_function = nofunc;\
    helpfile = helpptr;\
\
    XtVaSetValues (UxGetWidget (wgt),\
                   XmNmessageString,\
                   XmStringCreateLtoR (msg, XmSTRING_DEFAULT_CHARSET),\
		   NULL);\
\
    if (helpfile)\
      {\
	XtSetSensitive (XmMessageBoxGetChild (UxGetWidget (wgt),\
                         XmDIALOG_HELP_BUTTON), TRUE);\
      }\
    else\
      {\
	XtSetSensitive (XmMessageBoxGetChild (UxGetWidget (wgt),\
                         XmDIALOG_HELP_BUTTON), FALSE);\
      }\
\
    UxPopupInterface (wgt, no_grab);\
\
}\

*confirmDialog.static: true
*confirmDialog.name: confirmDialog
*confirmDialog.parent: NO_PARENT
*confirmDialog.parentExpression: UxParent
*confirmDialog.defaultShell: topLevelShell
*confirmDialog.msgDialogType: "dialog_question"
*confirmDialog.x: 421
*confirmDialog.y: 394
*confirmDialog.dialogTitle: "Confirm Action"
*confirmDialog.messageString: "       \n          "
*confirmDialog.helpLabelString: "Help"
*confirmDialog.okCallback: {\
    if (ok_function != NULL)\
        ok_function ();\
}
*confirmDialog.dialogStyle: "dialog_full_application_modal"
*confirmDialog.okLabelString: "Yes"
*confirmDialog.cancelLabelString: "No"
*confirmDialog.cancelCallback: {\
    if (cancel_function != NULL)\
        cancel_function ();\
}
*confirmDialog.shadowThickness: 2
*confirmDialog.textFontList: "8x13bold"
*confirmDialog.helpCallback: {\
char helpstring[100] = "netscape -raise -remote 'openFile (";\
if (helpfile)\
{\
    strcat (helpstring, helpfile);\
    strcat (helpstring, ")'");\
    if ((system (helpstring) == -1))\
    {\
        printf ("Error opening netscape\n");\
    }\
}\
}
*confirmDialog.defaultButtonType: "dialog_cancel_button"

