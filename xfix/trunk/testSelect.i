! UIMX ascii 2.9 key: 9336                                                      

*testSelect.class: fileSelectionBoxDialog
*testSelect.classinc:
*testSelect.classspec:
*testSelect.classmembers:
*testSelect.classconstructor: false
*testSelect.classdestructor: false
*testSelect.gbldecl: #include <stdio.h>\
#include <string.h>\
#include <stdlib.h>\
#include <sys/stat.h>\
#include <X11/Xlib.h>\
\
#ifndef DESIGN_TIME\
typedef void (*vfptr)();\
#endif\
\
#define FILTER "*000.*"\
\
static void do_selection (Widget wgt,\
                     XtPointer cd, XtPointer cb);\
\

*testSelect.ispecdecl: Widget selection, filelist, filtertxt;\
int iffr, ilfr, ifinc;\
int filenum;\
int npix, nrast, nframe;\
vfptr ok_function;
*testSelect.ispeclist: selection, filelist, filtertxt, iffr, ilfr, ifinc, filenum, npix, nrast, nframe, ok_function
*testSelect.ispeclist.selection: "Widget", "%selection%"
*testSelect.ispeclist.filelist: "Widget", "%filelist%"
*testSelect.ispeclist.filtertxt: "Widget", "%filtertxt%"
*testSelect.ispeclist.iffr: "int", "%iffr%"
*testSelect.ispeclist.ilfr: "int", "%ilfr%"
*testSelect.ispeclist.ifinc: "int", "%ifinc%"
*testSelect.ispeclist.filenum: "int", "%filenum%"
*testSelect.ispeclist.npix: "int", "%npix%"
*testSelect.ispeclist.nrast: "int", "%nrast%"
*testSelect.ispeclist.nframe: "int", "%nframe%"
*testSelect.ispeclist.ok_function: "vfptr", "%ok_function%"
*testSelect.funcdecl: swidget create_testSelect(swidget UxParent)
*testSelect.funcname: create_testSelect
*testSelect.funcdef: "swidget", "<create_testSelect>(%)"
*testSelect.argdecl: swidget UxParent;
*testSelect.arglist: UxParent
*testSelect.arglist.UxParent: "swidget", "%UxParent%"
*testSelect.icode: filenum = 1;\
iffr = 1;\
ilfr = 1;\
ifinc = 1;\
nframe = 1;\

*testSelect.fcode: selection = XmFileSelectionBoxGetChild (UxGetWidget (rtrn), XmDIALOG_TEXT);\
filelist  = XmFileSelectionBoxGetChild (UxGetWidget (rtrn), XmDIALOG_LIST);\
filtertxt = XmFileSelectionBoxGetChild (UxGetWidget (rtrn), XmDIALOG_FILTER_TEXT);\
\
XtAddCallback (selection, XmNvalueChangedCallback,\
         (XtCallbackProc) do_selection,\
         (XtPointer) UxFileSelectContext );\
return(rtrn);\

*testSelect.auxdecl: /*\
 * Extra call backs for internal widgets.\
 */\
\
static void do_selection (Widget wgt, XtPointer cd, XtPointer cb)\
{\
    struct stat stbuf;\
    char *text;\
    int found;\
\
    text = XmTextFieldGetString (wgt);\
    if ((stat (text, &stbuf) != -1) &&\
        (stbuf.st_mode & S_IFMT) != S_IFDIR &&\
        ((found = testSelect_readHeader (XtParent (wgt), &UxEnv, text, filenum,\
         &npix, &nrast, &nframe)) > 0))\
    {\
	ilfr = nframe;\
	testSelect_show (XtParent(wgt), &UxEnv, found);\
    }\
    free (text);\
}\

*testSelect_readHeader.class: method
*testSelect_readHeader.name: readHeader
*testSelect_readHeader.parent: testSelect
*testSelect_readHeader.methodType: int
*testSelect_readHeader.methodArgs: char *file;\
int mem;\
int *np;\
int *nr;\
int *nf;\

*testSelect_readHeader.methodBody: 
*testSelect_readHeader.methodSpec: virtual
*testSelect_readHeader.accessSpec: public
*testSelect_readHeader.arguments: file, mem, np, nr, nf
*testSelect_readHeader.file.def: "char", "*%file%"
*testSelect_readHeader.mem.def: "int", "%mem%"
*testSelect_readHeader.np.def: "int", "*%np%"
*testSelect_readHeader.nr.def: "int", "*%nr%"
*testSelect_readHeader.nf.def: "int", "*%nf%"

*testSelect_show.class: method
*testSelect_show.name: show
*testSelect_show.parent: testSelect
*testSelect_show.methodType: void
*testSelect_show.methodArgs: int found;\

*testSelect_show.methodBody: char buff[10];\
\
if (ilfr != 1)\
{\
    XtSetSensitive (textField1, TRUE);\
    XtSetSensitive (textField2, TRUE);\
    XtSetSensitive (textField3, TRUE);\
}\
XtSetSensitive (menu1, TRUE);\
if (found < 3)\
    XtSetSensitive (menu1_p1_b2, FALSE);\
if (found < 2)\
    XtSetSensitive (menu1_p1_b3, FALSE);\
sprintf (buff, "%d", ilfr);\
XmTextFieldSetString (textField2, buff);\

*testSelect_show.accessSpec: private
*testSelect_show.arguments: found
*testSelect_show.found.def: "int", "%found%"

*testSelect_defaults.class: method
*testSelect_defaults.name: defaults
*testSelect_defaults.parent: testSelect
*testSelect_defaults.methodType: void
*testSelect_defaults.methodArgs: 
*testSelect_defaults.methodBody: XmTextFieldSetString (textField1, "1");\
XmTextFieldSetString (textField2, "1");\
XmTextFieldSetString (textField3, "1");\
XtVaSetValues (menu1, XmNmenuHistory, menu1_p1_b1, NULL);\
XtSetSensitive (textField1, FALSE);\
XtSetSensitive (textField2, FALSE);\
XtSetSensitive (textField3, FALSE);\
XtSetSensitive (menu1, FALSE);\

*testSelect_defaults.accessSpec: private

*testSelect_OKfunction.class: method
*testSelect_OKfunction.name: OKfunction
*testSelect_OKfunction.parent: testSelect
*testSelect_OKfunction.methodType: void
*testSelect_OKfunction.methodArgs: vfptr okfunc;\

*testSelect_OKfunction.methodBody: ok_function = okfunc;
*testSelect_OKfunction.accessSpec: public
*testSelect_OKfunction.arguments: okfunc
*testSelect_OKfunction.okfunc.def: "vfptr", "%okfunc%"

*testSelect.static: true
*testSelect.name: testSelect
*testSelect.parent: NO_PARENT
*testSelect.parentExpression: UxParent
*testSelect.defaultShell: topLevelShell
*testSelect.resizePolicy: "resize_none"
*testSelect.unitType: "pixels"
*testSelect.x: 245
*testSelect.y: 190
*testSelect.width: 400
*testSelect.height: 400
*testSelect.dialogType: "dialog_file_selection"
*testSelect.isCompound: "true"
*testSelect.compoundIcon: "fileboxD.xpm"
*testSelect.compoundName: "fileSBox_Dialog"
*testSelect.childPlacement: "place_below_selection"
*testSelect.dirMask: FILTER
*testSelect.dialogStyle: "dialog_full_application_modal"
*testSelect.dialogTitle: "File Selection"
*testSelect.autoUnmanage: "false"
*testSelect.mapCallback: {\
testSelect_defaults (UxWidget, &UxEnv);\
}
*testSelect.cancelCallback: {\
UxPopdownInterface (UxThisWidget);\
}
*testSelect.okCallback: {\
XEvent *event;\
event = (((XmFileSelectionBoxCallbackStruct *) UxCallbackArg)->event);\
\
if ((XtWindow (filelist) == event->xbutton.window) ||\
    (event->type == KeyPress))\
    testSelect_defaults (UxWidget, &UxEnv);\
\
if (((XmFileSelectionBoxCallbackStruct *) UxCallbackArg)->reason == XmCR_NO_MATCH)\
{\
    ok_function (UxWidget, npix, nrast);\
}\
}
*testSelect.createManaged: "false"
*testSelect.dirSpec: ""
*testSelect.directory: ""
*testSelect.applyCallback: {\
char *text, *cptr, dir[256];\
int len;\
 \
text = XmTextFieldGetString (filtertxt);\
cptr = strrchr (text, '/');\
if (strcmp (cptr+1, FILTER) != 0)\
{\
    len = cptr-text+1;\
    strncpy (dir, text, len);\
    dir[len] = '\0';\
    strcat (dir, FILTER);\
    XmFileSelectionDoSearch (UxWidget,\
                XmStringCreateLtoR (dir,\
                XmSTRING_DEFAULT_CHARSET));\
}\
free (text);\
}
*testSelect.mustMatch: "true"
*testSelect.noMatchCallback: {\
XBell (UxDisplay, 50);\
}

*form1.class: form
*form1.static: true
*form1.name: form1
*form1.parent: testSelect
*form1.resizePolicy: "resize_none"
*form1.unitType: "pixels"
*form1.width: 427
*form1.height: 65
*form1.createManaged: "true"

*label2.class: label
*label2.static: true
*label2.name: label2
*label2.parent: form1
*label2.x: 100
*label2.y: -3
*label2.width: 69
*label2.height: 30
*label2.labelString: "Last Frame"
*label2.alignment: "alignment_beginning"

*label3.class: label
*label3.static: true
*label3.name: label3
*label3.parent: form1
*label3.x: 183
*label3.y: -1
*label3.width: 68
*label3.height: 30
*label3.labelString: "Increment"
*label3.alignment: "alignment_beginning"

*label4.class: label
*label4.static: true
*label4.name: label4
*label4.parent: form1
*label4.x: 273
*label4.y: -1
*label4.width: 82
*label4.height: 30
*label4.labelString: "Binary Data"
*label4.alignment: "alignment_beginning"

*textField1.class: textField
*textField1.static: true
*textField1.name: textField1
*textField1.parent: form1
*textField1.x: 12
*textField1.y: 29
*textField1.width: 70
*textField1.height: 34
*textField1.text: "1"
*textField1.sensitive: "true"
*textField1.valueChangedCallback: {\
char *text, *text2, buff[10];\
\
text = XmTextFieldGetString (UxWidget);\
if (*text != '\0')\
{\
    sscanf (text, "%d", &iffr);\
    if (iffr < 1)\
        XmTextFieldSetString (UxWidget, "1");\
    else if (iffr > nframe)\
    {\
        sprintf (buff, "%d", nframe); \
        XmTextFieldSetString (UxWidget, buff);\
    }\
    if ((iffr > ilfr && ifinc > 0) ||\
        (iffr < ilfr && ifinc < 0))\
    {\
        text2 = XmTextFieldGetString (textField3);\
        if (*text2 != '\0')\
        {\
            sscanf (text2, "%d", &ifinc);\
            sprintf (buff, "%d", -ifinc);\
            XmTextFieldSetString (textField3, buff);\
        }\
        free (text2);\
    }\
}\
free (text);\
}

*textField2.class: textField
*textField2.static: true
*textField2.name: textField2
*textField2.parent: form1
*textField2.x: 98
*textField2.y: 29
*textField2.width: 70
*textField2.height: 34
*textField2.text: "1"
*textField2.valueChangedCallback: {\
char *text, *text2, buff[10];\
\
text = XmTextFieldGetString (UxWidget);\
if (*text != '\0')\
{\
    sscanf (text, "%d", &ilfr);\
    if (ilfr < 1)\
        XmTextFieldSetString (UxWidget, "1");\
    else if (ilfr > nframe)\
    {\
        sprintf (buff, "%d", nframe);\
        XmTextFieldSetString (UxWidget, buff);\
    }\
    if ((iffr > ilfr && ifinc > 0) ||\
        (iffr < ilfr && ifinc < 0))\
    {\
        text2 = XmTextFieldGetString (textField3);\
        if (*text2 != '\0')\
        {\
            sscanf (text2, "%d", &ifinc);\
            sprintf (buff, "%d", -ifinc);\
            XmTextFieldSetString (textField3, buff);\
        }\
        free (text2);\
    }\
}\
free (text);\
\
}

*textField3.class: textField
*textField3.static: true
*textField3.name: textField3
*textField3.parent: form1
*textField3.x: 181
*textField3.y: 28
*textField3.width: 70
*textField3.height: 34
*textField3.text: "1"
*textField3.valueChangedCallback: {\
char *text, buff[10];\
\
text = XmTextFieldGetString (UxWidget);\
if (*text != '\0')\
{\
    sscanf (text, "%d", &ifinc);\
    if (ifinc < -nframe)\
    {\
        sprintf (buff, "%d", -nframe);\
        XmTextFieldSetString (UxWidget, buff);\
    }\
    else if (ifinc > nframe)\
    {\
        sprintf (buff, "%d", nframe);\
        XmTextFieldSetString (UxWidget, buff);\
    }\
}\
free (text);\
\
}

*menu1.class: rowColumn
*menu1.static: true
*menu1.name: menu1
*menu1.parent: form1
*menu1.rowColumnType: "menu_option"
*menu1.subMenuId: "data1"
*menu1.x: 250
*menu1.y: 27

*data1.class: rowColumn
*data1.static: true
*data1.name: data1
*data1.parent: menu1
*data1.rowColumnType: "menu_pulldown"

*menu1_p1_b1.class: pushButton
*menu1_p1_b1.static: true
*menu1_p1_b1.name: menu1_p1_b1
*menu1_p1_b1.parent: data1
*menu1_p1_b1.labelString: "SAXS"
*menu1_p1_b1.armCallbackClientData: (XtPointer) 0x0
*menu1_p1_b1.activateCallback: {\
filenum = (int) UxClientData;\
do_selection (selection, NULL, NULL);\
\
}
*menu1_p1_b1.activateCallbackClientData: (XtPointer) 0x1

*menu1_p1_b2.class: pushButton
*menu1_p1_b2.static: true
*menu1_p1_b2.name: menu1_p1_b2
*menu1_p1_b2.parent: data1
*menu1_p1_b2.labelString: "WAXS"
*menu1_p1_b2.armCallbackClientData: (XtPointer) 0x0
*menu1_p1_b2.activateCallback: {\
filenum = (int) UxClientData;\
do_selection (selection, NULL, NULL);\
}
*menu1_p1_b2.activateCallbackClientData: (XtPointer) 0x3

*menu1_p1_b3.class: pushButton
*menu1_p1_b3.static: true
*menu1_p1_b3.name: menu1_p1_b3
*menu1_p1_b3.parent: data1
*menu1_p1_b3.labelString: "Calibration"
*menu1_p1_b3.armCallbackClientData: (XtPointer) 0x0
*menu1_p1_b3.activateCallback: {\
filenum = (int) UxClientData;\
do_selection (selection, NULL, NULL);\
\
}
*menu1_p1_b3.activateCallbackClientData: (XtPointer) 0x2

*label1.class: label
*label1.static: true
*label1.name: label1
*label1.parent: form1
*label1.x: 13
*label1.y: -1
*label1.width: 70
*label1.height: 30
*label1.labelString: "First Frame"
*label1.alignment: "alignment_beginning"
*label1.bottomAttachment: "attach_none"
*label1.bottomWidget: ""

