! UIMX ascii 2.9 key: 1381                                                      

*obFileSelect.class: fileSelectionBoxDialog
*obFileSelect.classinc:
*obFileSelect.classspec:
*obFileSelect.classmembers:
*obFileSelect.classconstructor: false
*obFileSelect.classdestructor: false
*obFileSelect.gbldecl: #include <stdio.h>\
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

*obFileSelect.ispecdecl: Widget selection, filelist, filtertxt;\
char *filename;\
int iffr, ilfr, ifinc;\
int filenum;\
int npix, nrast, nframe;\
vfptr ok_function;
*obFileSelect.ispeclist: selection, filelist, filtertxt, filename, iffr, ilfr, ifinc, filenum, npix, nrast, nframe, ok_function
*obFileSelect.ispeclist.selection: "Widget", "%selection%"
*obFileSelect.ispeclist.filelist: "Widget", "%filelist%"
*obFileSelect.ispeclist.filtertxt: "Widget", "%filtertxt%"
*obFileSelect.ispeclist.filename: "char", "*%filename%"
*obFileSelect.ispeclist.iffr: "int", "%iffr%"
*obFileSelect.ispeclist.ilfr: "int", "%ilfr%"
*obFileSelect.ispeclist.ifinc: "int", "%ifinc%"
*obFileSelect.ispeclist.filenum: "int", "%filenum%"
*obFileSelect.ispeclist.npix: "int", "%npix%"
*obFileSelect.ispeclist.nrast: "int", "%nrast%"
*obFileSelect.ispeclist.nframe: "int", "%nframe%"
*obFileSelect.ispeclist.ok_function: "vfptr", "%ok_function%"
*obFileSelect.funcdecl: swidget create_obFileSelect(swidget UxParent)
*obFileSelect.funcname: create_obFileSelect
*obFileSelect.funcdef: "swidget", "<create_obFileSelect>(%)"
*obFileSelect.argdecl: swidget UxParent;
*obFileSelect.arglist: UxParent
*obFileSelect.arglist.UxParent: "swidget", "%UxParent%"
*obFileSelect.icode: filename = (char *) NULL;\
filenum = 1;\
iffr = 1;\
ilfr = 1;\
ifinc = 1;\
nframe = 1;\

*obFileSelect.fcode: selection = XmFileSelectionBoxGetChild (UxGetWidget (rtrn), XmDIALOG_TEXT);\
filelist  = XmFileSelectionBoxGetChild (UxGetWidget (rtrn), XmDIALOG_LIST);\
filtertxt = XmFileSelectionBoxGetChild (UxGetWidget (rtrn), XmDIALOG_FILTER_TEXT);\
\
XtAddCallback (selection, XmNvalueChangedCallback,\
         (XtCallbackProc) do_selection,\
         (XtPointer) UxObFileSelectContext );\
return(rtrn);\

*obFileSelect.auxdecl: /*\
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
        ((found = obFileSelect_readHeader (XtParent (wgt), &UxEnv, text, filenum,\
         &npix, &nrast, &nframe)) > 0))\
    {\
	ilfr = nframe;\
        if (filename)\
          free (filename);\
        filename = (char *) strdup (text);\
	obFileSelect_show (XtParent(wgt), &UxEnv, found);\
    }\
    else\
    {\
        filename = (char *) NULL;\
    }\
	\
    free (text);\
}\

*obFileSelect_readHeader.class: method
*obFileSelect_readHeader.name: readHeader
*obFileSelect_readHeader.parent: obFileSelect
*obFileSelect_readHeader.methodType: int
*obFileSelect_readHeader.methodArgs: char *file;\
int mem;\
int *np;\
int *nr;\
int *nf;\

*obFileSelect_readHeader.methodBody: 
*obFileSelect_readHeader.methodSpec: virtual
*obFileSelect_readHeader.accessSpec: public
*obFileSelect_readHeader.arguments: file, mem, np, nr, nf
*obFileSelect_readHeader.file.def: "char", "*%file%"
*obFileSelect_readHeader.mem.def: "int", "%mem%"
*obFileSelect_readHeader.np.def: "int", "*%np%"
*obFileSelect_readHeader.nr.def: "int", "*%nr%"
*obFileSelect_readHeader.nf.def: "int", "*%nf%"

*obFileSelect_show.class: method
*obFileSelect_show.name: show
*obFileSelect_show.parent: obFileSelect
*obFileSelect_show.methodType: void
*obFileSelect_show.methodArgs: int found;\

*obFileSelect_show.methodBody: char buff[10];\
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

*obFileSelect_show.accessSpec: private
*obFileSelect_show.arguments: found
*obFileSelect_show.found.def: "int", "%found%"

*obFileSelect_defaults.class: method
*obFileSelect_defaults.name: defaults
*obFileSelect_defaults.parent: obFileSelect
*obFileSelect_defaults.methodType: void
*obFileSelect_defaults.methodArgs: 
*obFileSelect_defaults.methodBody: XmTextFieldSetString (textField1, "1");\
XmTextFieldSetString (textField2, "1");\
XmTextFieldSetString (textField3, "1");\
filenum = 1;\
XtVaSetValues (menu1, XmNmenuHistory, menu1_p1_b1, NULL);\
XtSetSensitive (textField1, FALSE);\
XtSetSensitive (textField2, FALSE);\
XtSetSensitive (textField3, FALSE);\
XtSetSensitive (menu1, FALSE);\

*obFileSelect_defaults.accessSpec: private

*obFileSelect_OKfunction.class: method
*obFileSelect_OKfunction.name: OKfunction
*obFileSelect_OKfunction.parent: obFileSelect
*obFileSelect_OKfunction.methodType: void
*obFileSelect_OKfunction.methodArgs: vfptr okfunc;\

*obFileSelect_OKfunction.methodBody: ok_function = okfunc;
*obFileSelect_OKfunction.methodSpec: virtual
*obFileSelect_OKfunction.accessSpec: public
*obFileSelect_OKfunction.arguments: okfunc
*obFileSelect_OKfunction.okfunc.def: "vfptr", "%okfunc%"

*obFileSelect.static: true
*obFileSelect.name: obFileSelect
*obFileSelect.parent: NO_PARENT
*obFileSelect.parentExpression: UxParent
*obFileSelect.defaultShell: topLevelShell
*obFileSelect.resizePolicy: "resize_none"
*obFileSelect.unitType: "pixels"
*obFileSelect.x: 245
*obFileSelect.y: 190
*obFileSelect.width: 400
*obFileSelect.height: 400
*obFileSelect.dialogType: "dialog_file_selection"
*obFileSelect.isCompound: "true"
*obFileSelect.compoundIcon: "fileboxD.xpm"
*obFileSelect.compoundName: "fileSBox_Dialog"
*obFileSelect.childPlacement: "place_below_selection"
*obFileSelect.dirMask: FILTER
*obFileSelect.dialogStyle: "dialog_full_application_modal"
*obFileSelect.dialogTitle: "File Selection"
*obFileSelect.autoUnmanage: "false"
*obFileSelect.mapCallback: {\
obFileSelect_defaults (UxWidget, &UxEnv);\
}
*obFileSelect.cancelCallback: {\
UxPopdownInterface (UxThisWidget);\
}
*obFileSelect.okCallback: {\
XEvent *event;\
event = (((XmFileSelectionBoxCallbackStruct *) UxCallbackArg)->event);\
\
if ((XtWindow (filelist) == event->xbutton.window) ||\
    (event->type == KeyPress))\
    obFileSelect_defaults (UxWidget, &UxEnv);\
\
if (((XmFileSelectionBoxCallbackStruct *) UxCallbackArg)->reason != XmCR_NO_MATCH)\
{\
    UxPopdownInterface (UxThisWidget);\
    ok_function (filename, npix, nrast, iffr, ilfr, ifinc, filenum);\
}\
}
*obFileSelect.createManaged: "false"
*obFileSelect.dirSpec: ""
*obFileSelect.directory: ""
*obFileSelect.applyCallback: {\
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
*obFileSelect.mustMatch: "true"
*obFileSelect.noMatchCallback: {\
XBell (UxDisplay, 50);\
}

*form1.class: form
*form1.static: true
*form1.name: form1
*form1.parent: obFileSelect
*form1.resizePolicy: "resize_none"
*form1.unitType: "pixels"
*form1.width: 427
*form1.height: 65
*form1.createManaged: "true"

*label2.class: label
*label2.static: true
*label2.name: label2
*label2.parent: form1
*label2.x: -350
*label2.y: -1
*label2.width: 90
*label2.height: 25
*label2.labelString: "Last Frame"
*label2.alignment: "alignment_beginning"
*label2.leftOffset: 90
*label2.leftAttachment: "attach_form"
*label2.topOffset: 10
*label2.fontList: "7x14"

*label3.class: label
*label3.static: true
*label3.name: label3
*label3.parent: form1
*label3.x: -3
*label3.y: -1
*label3.width: 90
*label3.height: 25
*label3.labelString: "Increment"
*label3.alignment: "alignment_beginning"
*label3.leftOffset: 180
*label3.leftAttachment: "attach_form"
*label3.topOffset: 10
*label3.fontList: "7x14"

*label4.class: label
*label4.static: true
*label4.name: label4
*label4.parent: form1
*label4.x: 365
*label4.y: -1
*label4.width: 90
*label4.height: 25
*label4.labelString: "Binary Data"
*label4.alignment: "alignment_beginning"
*label4.topOffset: 10
*label4.leftAttachment: "attach_none"
*label4.rightAttachment: "attach_form"
*label4.rightOffset: 14
*label4.fontList: "7x14"

*textField1.class: textField
*textField1.static: true
*textField1.name: textField1
*textField1.parent: form1
*textField1.width: 70
*textField1.height: 30
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
*textField1.leftOffset: 0
*textField1.leftAttachment: "attach_form"
*textField1.topOffset: 28
*textField1.topAttachment: "attach_form"
*textField1.fontList: "7x14"

*textField2.class: textField
*textField2.static: true
*textField2.name: textField2
*textField2.parent: form1
*textField2.width: 70
*textField2.height: 30
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
*textField2.leftOffset: 90
*textField2.leftAttachment: "attach_form"
*textField2.topOffset: 28
*textField2.topAttachment: "attach_form"
*textField2.fontList: "7x14"

*textField3.class: textField
*textField3.static: true
*textField3.name: textField3
*textField3.parent: form1
*textField3.width: 70
*textField3.height: 30
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
*textField3.leftOffset: 180
*textField3.leftAttachment: "attach_form"
*textField3.topOffset: 28
*textField3.topAttachment: "attach_form"
*textField3.fontList: "7x14"

*menu1.class: rowColumn
*menu1.static: true
*menu1.name: menu1
*menu1.parent: form1
*menu1.rowColumnType: "menu_option"
*menu1.subMenuId: "data1"
*menu1.leftAttachment: "attach_none"
*menu1.topOffset: 25
*menu1.resizeHeight: "true"
*menu1.resizeWidth: "true"
*menu1.colormap.lock: true
*menu1.packing: "pack_tight"
*menu1.rightAttachment: "attach_form"
*menu1.rightOffset: -2
*menu1.topAttachment: "attach_form"
*menu1.height: 30
*menu1.width: 130
*menu1.resizable: "false"

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
*menu1_p1_b1.fontList: "7x14"

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
*menu1_p1_b2.fontList: "7x14"

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
*menu1_p1_b3.fontList: "7x14"

*label1.class: label
*label1.static: true
*label1.name: label1
*label1.parent: form1
*label1.x: 224
*label1.y: -1
*label1.width: 90
*label1.height: 25
*label1.labelString: "First Frame"
*label1.alignment: "alignment_beginning"
*label1.bottomAttachment: "attach_none"
*label1.bottomWidget: ""
*label1.leftOffset: 0
*label1.leftAttachment: "attach_form"
*label1.topOffset: 10
*label1.fontList: "7x14"

