! UIMX ascii 2.9 key: 8393                                                      

*fitShell.class: applicationShell
*fitShell.classinc:
*fitShell.classspec:
*fitShell.classmembers:
*fitShell.classconstructor:
*fitShell.classdestructor:
*fitShell.gbldecl: #include <stdarg.h>\
#include <string.h>\
#include <sys/types.h>\
#include <sys/stat.h>\
#include <fcntl.h>\
#include <ctype.h>\
#ifndef DESIGN_TIME\
typedef void (*vfptr)();\
#endif\
\
#include <Xm/Protocols.h>\
#include <X11/cursorfont.h>\
#include "xfit.m.pm"\
\
extern void show_fileSelect (Widget, char *, void (*) (char *), void (*) ());\
extern void ConfirmDialogAsk (Widget, char *, void (*)(), void (*)(), char *);\
\
void Continue ();\
void update_messages (char *);\
void SetBusyPointer (int);\
void message_handler (XtPointer, int *, XtInputId *);\
void CreateWindowManagerProtocols (Widget, void (*)(Widget, XtPointer, \
                                   XtPointer));\
void ExitCB (Widget, XtPointer, XtPointer);\
void SetIconImage (Widget);\
\
#ifndef DESIGN_TIME\
\
#include "fileSelect.h"\
#include "confirmDialog.h"\
#include "continueDialog.h"\
#include "errorDialog.h"\
#include "infoDialog.h"\
#include "limitDialog.h"\
#include "parRowColumn.h"\
#include "peakRowColumn.h"\
#include "setupDialog.h"\
#include "tieDialog.h"\
#include "warningDialog.h"\
#include "yDialog.h"\
#include "headerDialog.h"\
#include "channelDialog.h"\
#include "otokoFileSelect.h"\
\
#else\
\
extern swidget create_fileSelect();\
extern swidget create_confirmDialog();\
extern swidget create_continueDialog();\
extern swidget create_errorDialog();\
extern swidget create_infoDialog();\
extern swidget create_limitDialog();\
extern swidget create_par_rowColumn();\
extern swidget create_peakRowColumn();\
extern swidget create_setupDialog();\
extern swidget create_tieDialog();\
extern swidget create_warningDialog();\
extern swidget create_yDialog();\
extern swidget create_headerDialog();\
extern swidget create_channelDialog();\
extern swidget create_otokoFileSelect ();\
\
#endif\
\
typedef struct {\
    char *ccp13Host;\
} ccp13_app_res;\
 \
extern ccp13_app_res ccp13_resource;\
\
swidget confirm;\
swidget setup;\
\
static swidget fileSelect;\
static swidget error;\
static swidget warning;\
static swidget info;\
static swidget channels;\
static swidget header;\
static swidget minmaxy;\
static swidget continueD;\
static swidget otokoSelect;\
\
Cursor watch;\
\
static int putfile (char *, char *);\
static int get_file (char *, char *);\
static void message_parser (char *);\
static void say_yes ();\
static void say_no ();\
static void save_pars ();\
static void retry ();\
static void quit ();\
static void get_yfile (char *, int, int, int, int, int, int);\
static void get_xfile (char *, int, int, int, int, int, int);\
static void get_initfile (char *, int, int, int, int, int, int);\
static void get_outfile (char *);\
static void get_hardfile (char *);\
static char *chopdir (char *);\
static char *checkstr (char *, int *);\
static char *findtok (char *, char *);\
static char *AddString (char *, char *);\
static char *firstnon (char *, char *);\
static void freelinks ();\
static void CancelSave ();\
\

*fitShell.ispecdecl: char *xfile, *yfile, *initfile, *outfile, *sfile;\
char *hardfile, *helpfile, *ccp13ptr;\
char *header1, *header2;\
char chartmp[100];\
int firstrun, file_input, file_ready, mode, inputPause;\
int iffr, ilfr, ifinc, filenum;\

*fitShell.ispeclist: xfile, yfile, initfile, outfile, sfile, hardfile, helpfile, ccp13ptr, header1, header2, chartmp, firstrun, file_input, file_ready, mode, inputPause, iffr, ilfr, ifinc, filenum
*fitShell.ispeclist.xfile: "char", "*%xfile%"
*fitShell.ispeclist.yfile: "char", "*%yfile%"
*fitShell.ispeclist.initfile: "char", "*%initfile%"
*fitShell.ispeclist.outfile: "char", "*%outfile%"
*fitShell.ispeclist.sfile: "char", "*%sfile%"
*fitShell.ispeclist.hardfile: "char", "*%hardfile%"
*fitShell.ispeclist.helpfile: "char", "*%helpfile%"
*fitShell.ispeclist.ccp13ptr: "char", "*%ccp13ptr%"
*fitShell.ispeclist.header1: "char", "*%header1%"
*fitShell.ispeclist.header2: "char", "*%header2%"
*fitShell.ispeclist.chartmp: "char", "%chartmp%[100]"
*fitShell.ispeclist.firstrun: "int", "%firstrun%"
*fitShell.ispeclist.file_input: "int", "%file_input%"
*fitShell.ispeclist.file_ready: "int", "%file_ready%"
*fitShell.ispeclist.mode: "int", "%mode%"
*fitShell.ispeclist.inputPause: "int", "%inputPause%"
*fitShell.ispeclist.iffr: "int", "%iffr%"
*fitShell.ispeclist.ilfr: "int", "%ilfr%"
*fitShell.ispeclist.ifinc: "int", "%ifinc%"
*fitShell.ispeclist.filenum: "int", "%filenum%"
*fitShell.funcdecl: swidget create_fitShell(swidget UxParent)
*fitShell.funcname: create_fitShell
*fitShell.funcdef: "swidget", "<create_fitShell>(%)"
*fitShell.argdecl: swidget UxParent;
*fitShell.arglist: UxParent
*fitShell.arglist.UxParent: "swidget", "%UxParent%"
*fitShell.icode:
*fitShell.fcode: CreateWindowManagerProtocols (UxGetWidget (rtrn), ExitCB);\
SetIconImage (UxGetWidget (fitShell));\
\
watch = XCreateFontCursor (UxDisplay, XC_watch);\
fileSelect = create_fileSelect (rtrn);\
confirm = create_confirmDialog (rtrn);\
setup = create_setupDialog (rtrn);\
error = create_errorDialog (rtrn);\
warning = create_warningDialog (rtrn);\
info = create_infoDialog (rtrn);\
channels = create_channelDialog (rtrn);\
header = create_headerDialog (rtrn);\
minmaxy = create_yDialog (rtrn);\
continueD = create_continueDialog (rtrn);\
otokoSelect = create_otokoFileSelect (rtrn);\
\
firstrun = 1;\
inputPause = 0;\
xfile = yfile = initfile = outfile = NULL;\
iffr = ilfr = filenum = 1; ifinc = 0;\
\
if ((ccp13ptr = (char *) getenv ("CCP13HOME")))\
{\
    helpfile = AddString (ccp13ptr, "/doc/xfit.html");\
}\
else\
{\
    helpfile = "http://www.dl.ac.uk/SRS/CCP13/program/xfit.html";\
}\
\
return(rtrn);\

*fitShell.auxdecl: #include "fitShell_aux.c"\
\
void CreateWindowManagerProtocols (Widget shell, void (*closeFunction) ())\
{\
    Atom xa_WM_DELETE_WINDOW;\
\
/* Intern the "delete window" atom. */\
    xa_WM_DELETE_WINDOW = XInternAtom (UxDisplay,\
    "WM_DELETE_WINDOW", False);\
\
/* Add the window manager protocol callback */\
    XmAddWMProtocolCallback (shell, xa_WM_DELETE_WINDOW,\
    closeFunction, NULL);\
}\
\
void ExitCB (Widget w, XtPointer client_data, XtPointer call_data)\
{\
    ConfirmDialogAsk (confirm, "Do you really want to quit?",\
                   quit, NULL, NULL);\
}\
\
/*\
 *  Create a nice icon image for xfit...\
 */\
void SetIconImage (Widget wgt)\
{\
    static Pixmap icon = None;\
    static unsigned int iconW = 1, iconH = 1;\
    Window iconWindow;\
    XWMHints wmHints;\
    Screen *screen = XtScreen(wgt);\
    Display *dpy = XtDisplay(wgt);\
/*\
 *  Build the icon\
 */\
    iconWindow = XCreateSimpleWindow(dpy, RootWindowOfScreen(screen),\
                                     0, 0, /* x, y */\
                                     iconW, iconH, 0,\
                                     BlackPixelOfScreen(screen),\
                                     BlackPixelOfScreen(screen));\
    if (icon == None)\
    {\
        Window          root;\
        int             x, y;\
        unsigned int    bw, depth;\
 \
        XpmCreatePixmapFromData(dpy, iconWindow,\
                                xfit_m_pm, &icon, NULL, NULL);\
 	if (icon != None)\
	{\
            XGetGeometry(dpy, icon, &root, &x, &y, &iconW, &iconH, &bw, &depth);\
            XResizeWindow(dpy, iconWindow, iconW, iconH); \
            XSetWindowBackgroundPixmap(dpy, iconWindow, icon);\
            XtVaSetValues (wgt, XtNiconWindow, iconWindow, NULL);\
	}\
    }\
}\
\
void Continue ()\
{\
    message_parser (NULL);\
}\

*fitShell_continue.class: method
*fitShell_continue.name: continue
*fitShell_continue.parent: fitShell
*fitShell_continue.methodType: void
*fitShell_continue.methodArgs: 
*fitShell_continue.methodBody: message_parser (NULL);
*fitShell_continue.methodSpec: virtual
*fitShell_continue.accessSpec: public

*fitShell_SetHeaders.class: method
*fitShell_SetHeaders.name: SetHeaders
*fitShell_SetHeaders.parent: fitShell
*fitShell_SetHeaders.methodType: void
*fitShell_SetHeaders.methodArgs: char *h1;\
char *h2;\

*fitShell_SetHeaders.methodBody: header1 = h1;\
header2 = h2;
*fitShell_SetHeaders.methodSpec: virtual
*fitShell_SetHeaders.accessSpec: public
*fitShell_SetHeaders.arguments: h1, h2
*fitShell_SetHeaders.h1.def: "char", "*%h1%"
*fitShell_SetHeaders.h2.def: "char", "*%h2%"

*fitShell_help.class: method
*fitShell_help.name: help
*fitShell_help.parent: fitShell
*fitShell_help.methodType: void
*fitShell_help.methodArgs: 
*fitShell_help.methodBody: char *helpstring;\
\
        helpstring = (char *) strdup ("netscape -raise -remote ");\
\
        if (ccp13ptr)\
        {\
            helpstring = AddString (helpstring, " 'openFile (");\
        }\
        else\
        {\
            helpstring = AddString (helpstring, " 'openURL (");\
        }\
\
        helpstring = AddString (helpstring, helpfile);\
        helpstring = AddString (helpstring, ")'");\
\
        if ((system (helpstring) == -1))\
        {\
            fprintf (stderr, "Error opening Netscape browser\n");\
        } \
\
        free (helpstring);
*fitShell_help.methodSpec: virtual
*fitShell_help.accessSpec: public

*fitShell.static: true
*fitShell.name: fitShell
*fitShell.parent: NO_PARENT
*fitShell.parentExpression: UxParent
*fitShell.width: 530
*fitShell.height: 350
*fitShell.isCompound: "true"
*fitShell.compoundIcon: "applS.xpm"
*fitShell.compoundName: "appl_Shell"
*fitShell.x: 430
*fitShell.y: 220
*fitShell.buttonFontList: "8x13bold"
*fitShell.labelFontList: "8x13bold"
*fitShell.textFontList: "8x13bold"
*fitShell.title: "xfit"
*fitShell.iconName: "xfit"
*fitShell.popupCallback: {\
\
\
}
*fitShell.deleteResponse: "do_nothing"

*panedWindow1.class: panedWindow
*panedWindow1.static: true
*panedWindow1.name: panedWindow1
*panedWindow1.parent: fitShell
*panedWindow1.width: 200
*panedWindow1.height: 200
*panedWindow1.isCompound: "true"
*panedWindow1.compoundIcon: "paned.xpm"
*panedWindow1.compoundName: "paned_Window"
*panedWindow1.x: 40
*panedWindow1.y: 40
*panedWindow1.unitType: "pixels"
*panedWindow1.separatorOn: "false"
*panedWindow1.refigureMode: "true"
*panedWindow1.sashWidth: 0
*panedWindow1.sashHeight: 0
*panedWindow1.sashShadowThickness: 0
*panedWindow1.sashIndent: 0
*panedWindow1.spacing: 4
*panedWindow1.foreground: "white"
*panedWindow1.highlightColor: "white"

*menuBar.class: rowColumn
*menuBar.static: true
*menuBar.name: menuBar
*menuBar.parent: panedWindow1
*menuBar.rowColumnType: "menu_bar"
*menuBar.isCompound: "true"
*menuBar.compoundIcon: "pulldownM.xpm"
*menuBar.compoundName: "menu_Bar"
*menuBar.compoundEditor: {\
extern swidget UxGUIMePopup UXPROTO((swidget, swidget, int, int));\
UxGUIMePopup(UxThisWidget, NULL, 1, 0);\
}
*menuBar.x: 0
*menuBar.y: 0
*menuBar.width: 350
*menuBar.height: 50
*menuBar.paneMaximum: 32
*menuBar.paneMinimum: 32
*menuBar.menuAccelerator: "<KeyUp>F10"
*menuBar.menuHelpWidget: "menuBar_top_b3"
*menuBar.labelString: ""
*menuBar.numColumns: 6

*menuBar_p1.class: rowColumn
*menuBar_p1.static: true
*menuBar_p1.name: menuBar_p1
*menuBar_p1.parent: menuBar
*menuBar_p1.rowColumnType: "menu_pulldown"

*menuBar_p1_b1.class: pushButton
*menuBar_p1_b1.static: true
*menuBar_p1_b1.name: menuBar_p1_b1
*menuBar_p1_b1.parent: menuBar_p1
*menuBar_p1_b1.labelString: "Load Y..."
*menuBar_p1_b1.activateCallback: message_parser (NULL);\
obFileSelect_OKfunction (otokoSelect, &UxEnv, get_yfile);\
UxPopupInterface (otokoSelect, nonexclusive_grab);

*menuBar_p1_b5.class: pushButton
*menuBar_p1_b5.static: true
*menuBar_p1_b5.name: menuBar_p1_b5
*menuBar_p1_b5.parent: menuBar_p1
*menuBar_p1_b5.labelString: "Load X..."
*menuBar_p1_b5.activateCallback: obFileSelect_OKfunction (otokoSelect, &UxEnv, get_xfile);\
UxPopupInterface (otokoSelect, nonexclusive_grab);

*menuBar_p1_b6.class: pushButton
*menuBar_p1_b6.static: true
*menuBar_p1_b6.name: menuBar_p1_b6
*menuBar_p1_b6.parent: menuBar_p1
*menuBar_p1_b6.labelString: "Load Parameters..."
*menuBar_p1_b6.activateCallback: obFileSelect_OKfunction (otokoSelect, &UxEnv, get_initfile);\
UxPopupInterface (otokoSelect, nonexclusive_grab);

*menuBar_p1_b8.class: pushButton
*menuBar_p1_b8.static: true
*menuBar_p1_b8.name: menuBar_p1_b8
*menuBar_p1_b8.parent: menuBar_p1
*menuBar_p1_b8.labelString: "Load SD's..."
*menuBar_p1_b8.activateCallback: obFileSelect_OKfunction (otokoSelect, &UxEnv, get_sfile);\
UxPopupInterface (otokoSelect, nonexclusive_grab);

*menuBar_p1_b2.class: pushButton
*menuBar_p1_b2.static: true
*menuBar_p1_b2.name: menuBar_p1_b2
*menuBar_p1_b2.parent: menuBar_p1
*menuBar_p1_b2.labelString: "Save Parameters..."
*menuBar_p1_b2.activateCallback: show_fileSelect (fileSelect, "*000.*", get_outfile, NULL);

*menuBar_p1_separator.class: separator
*menuBar_p1_separator.static: true
*menuBar_p1_separator.name: menuBar_p1_separator
*menuBar_p1_separator.parent: menuBar_p1

*menuBar_p1_b4.class: pushButton
*menuBar_p1_b4.static: true
*menuBar_p1_b4.name: menuBar_p1_b4
*menuBar_p1_b4.parent: menuBar_p1
*menuBar_p1_b4.labelString: "Quit"
*menuBar_p1_b4.activateCallback: ExitCB (UxGetWidget (fitShell), NULL, NULL);

*menuBar_p2.class: rowColumn
*menuBar_p2.static: true
*menuBar_p2.name: menuBar_p2
*menuBar_p2.parent: menuBar
*menuBar_p2.rowColumnType: "menu_pulldown"

*menuBar_p2_b1.class: pushButton
*menuBar_p2_b1.static: true
*menuBar_p2_b1.name: menuBar_p2_b1
*menuBar_p2_b1.parent: menuBar_p2
*menuBar_p2_b1.labelString: "Fit"
*menuBar_p2_b1.activateCallback: if (yfile)\
{\
    file_ready = 1;\
    mode = 1;\
    command ("%s\n", yfile);\
}\
else\
{\
    warningDialog_popup (warning, &UxEnv, "No data file has been selected");\
}
*menuBar_p2_b1.sensitive: "false"

*menuBar_p2_b2.class: pushButton
*menuBar_p2_b2.static: true
*menuBar_p2_b2.name: menuBar_p2_b2
*menuBar_p2_b2.parent: menuBar_p2
*menuBar_p2_b2.labelString: "Plot"
*menuBar_p2_b2.activateCallback: if (yfile)\
{\
    file_ready = 1;\
    mode = 0;\
    command ("%s\n", yfile);\
}\
else\
{\
    warningDialog_popup (warning, &UxEnv, "No data file has been selected");\
}
*menuBar_p2_b2.sensitive: "false"

*menuBar_p2_b3.class: pushButton
*menuBar_p2_b3.static: true
*menuBar_p2_b3.name: menuBar_p2_b3
*menuBar_p2_b3.parent: menuBar_p2
*menuBar_p2_b3.labelString: "Auto"
*menuBar_p2_b3.activateCallback: if (yfile)\
{\
    file_ready = 1;\
    mode = 2;\
    command ("%s\n", yfile);\
}\
else\
{\
    warningDialog_popup (warning, &UxEnv, "No data file has been selected");\
}
*menuBar_p2_b3.sensitive: "false"

*menuBar_p3.class: rowColumn
*menuBar_p3.static: true
*menuBar_p3.name: menuBar_p3
*menuBar_p3.parent: menuBar
*menuBar_p3.rowColumnType: "menu_pulldown"

*menuBar_p3_b1.class: pushButton
*menuBar_p3_b1.static: true
*menuBar_p3_b1.name: menuBar_p3_b1
*menuBar_p3_b1.parent: menuBar_p3
*menuBar_p3_b1.labelString: "Help"
*menuBar_p3_b1.activateCallback: fitShell_help (fitShell, &UxEnv); \


*menuBar_top_b1.class: cascadeButton
*menuBar_top_b1.static: true
*menuBar_top_b1.name: menuBar_top_b1
*menuBar_top_b1.parent: menuBar
*menuBar_top_b1.labelString: "File"
*menuBar_top_b1.subMenuId: "menuBar_p1"
*menuBar_top_b1.mnemonic: "F"
*menuBar_top_b1.activateCallback: {\
\
}
*menuBar_top_b1.cascadingCallback: {\
if (file_ready)\
{\
    XtSetSensitive (UxGetWidget (menuBar_p1_b1), FALSE);\
    XtSetSensitive (UxGetWidget (menuBar_p1_b5), FALSE);\
    XtSetSensitive (UxGetWidget (menuBar_p1_b6), FALSE);\
    XtSetSensitive (UxGetWidget (menuBar_p1_b8), FALSE);\
    XtSetSensitive (UxGetWidget (menuBar_p1_b2), FALSE);\
}\
else\
{\
    XtSetSensitive (UxGetWidget (menuBar_p1_b1), TRUE);\
    XtSetSensitive (UxGetWidget (menuBar_p1_b5), TRUE);\
    XtSetSensitive (UxGetWidget (menuBar_p1_b6), TRUE);\
    XtSetSensitive (UxGetWidget (menuBar_p1_b8), TRUE);\
    XtSetSensitive (UxGetWidget (menuBar_p1_b2), TRUE);\
}\
\
\
}

*menuBar_top_b2.class: cascadeButton
*menuBar_top_b2.static: true
*menuBar_top_b2.name: menuBar_top_b2
*menuBar_top_b2.parent: menuBar
*menuBar_top_b2.labelString: "Mode"
*menuBar_top_b2.subMenuId: "menuBar_p2"
*menuBar_top_b2.mnemonic: "M"
*menuBar_top_b2.activateCallback: {\
\
}
*menuBar_top_b2.cascadingCallback: {\
if (yfile && file_ready == 0)\
{\
    XtSetSensitive (UxGetWidget (menuBar_p2_b1), TRUE);\
    XtSetSensitive (UxGetWidget (menuBar_p2_b2), TRUE);\
    XtSetSensitive (UxGetWidget (menuBar_p2_b3), TRUE);\
}\
else\
{\
    XtSetSensitive (UxGetWidget (menuBar_p2_b1), FALSE);\
    XtSetSensitive (UxGetWidget (menuBar_p2_b2), FALSE);\
    XtSetSensitive (UxGetWidget (menuBar_p2_b3), FALSE);\
}\
}

*menuBar_top_b3.class: cascadeButtonGadget
*menuBar_top_b3.static: true
*menuBar_top_b3.name: menuBar_top_b3
*menuBar_top_b3.parent: menuBar
*menuBar_top_b3.labelString: "Help"
*menuBar_top_b3.mnemonic: "H"
*menuBar_top_b3.subMenuId: "menuBar_p3"
*menuBar_top_b3.x: 300
*menuBar_top_b3.positionIndex: 2
*menuBar_top_b3.activateCallback: {\
\
}
*menuBar_top_b3.cascadingCallback: {\
if (helpfile)\
{\
    XtSetSensitive (UxGetWidget (menuBar_p3_b1), TRUE);\
}\
else\
{\
    XtSetSensitive (UxGetWidget (menuBar_p3_b1), FALSE);\
}\
}

*form2.class: form
*form2.static: true
*form2.name: form2
*form2.parent: panedWindow1
*form2.resizePolicy: "resize_none"
*form2.x: 3
*form2.y: 39
*form2.width: 524
*form2.height: 100
*form2.paneMaximum: 30
*form2.paneMinimum: 30
*form2.foreground: "white"
*form2.highlightColor: "white"
*form2.labelFontList: "8x13bold"
*form2.allowResize: "false"
*form2.verticalSpacing: 0
*form2.rubberPositioning: "false"
*form2.skipAdjust: "true"

*label1.class: label
*label1.static: true
*label1.name: label1
*label1.parent: form2
*label1.isCompound: "true"
*label1.compoundIcon: "label.xpm"
*label1.compoundName: "label_"
*label1.x: 10
*label1.y: 0
*label1.width: 130
*label1.height: 15
*label1.labelString: "Message Window"
*label1.alignment: "alignment_beginning"
*label1.bottomAttachment: "attach_form"

*form1.class: form
*form1.static: true
*form1.name: form1
*form1.parent: panedWindow1
*form1.resizePolicy: "resize_none"
*form1.x: 0
*form1.y: 230
*form1.width: 350
*form1.height: 280
*form1.paneMaximum: 1000
*form1.paneMinimum: 1
*form1.buttonFontList: "8x13bold"
*form1.foreground: "white"
*form1.highlightColor: "white"
*form1.allowResize: "true"

*scrolledWindow1.class: scrolledWindow
*scrolledWindow1.static: true
*scrolledWindow1.name: scrolledWindow1
*scrolledWindow1.parent: form1
*scrolledWindow1.x: 7
*scrolledWindow1.y: 7
*scrolledWindow1.bottomAttachment: "attach_form"
*scrolledWindow1.leftAttachment: "attach_form"
*scrolledWindow1.rightAttachment: "attach_form"
*scrolledWindow1.topAttachment: "attach_form"
*scrolledWindow1.bottomOffset: 0
*scrolledWindow1.leftOffset: 0
*scrolledWindow1.rightOffset: 0
*scrolledWindow1.topOffset: 0

*scrolledText1.class: scrolledText
*scrolledText1.static: true
*scrolledText1.name: scrolledText1
*scrolledText1.parent: scrolledWindow1
*scrolledText1.width: 490
*scrolledText1.height: 67
*scrolledText1.fontList: "8x13"
*scrolledText1.editable: "false"
*scrolledText1.text: "xfit GUI: last update 11/12/96\nstarting fit program...\n"
*scrolledText1.createCallback: {\
\
}
*scrolledText1.isResizable: "true"
*scrolledText1.mappedWhenManaged: "true"
*scrolledText1.maxLength: 1000
*scrolledText1.createManaged: "true"
*scrolledText1.cursorPositionVisible: "false"
*scrolledText1.autoShowCursorPosition: "false"
*scrolledText1.columns: 80
*scrolledText1.editMode: "multi_line_edit"

