! UIMX ascii 2.9 key: 1322                                                      

*lineDialog.class: templateDialog
*lineDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
\
#include "mprintf.h"\
\
extern void DestroyLinePos ();\
extern void DrawLines ();\
extern void MarkLines (int, int, int);\
extern void RepaintOverLineMarkers ();
*lineDialog.ispecdecl:
*lineDialog.funcdecl: swidget create_lineDialog(swidget UxParent)
*lineDialog.funcname: create_lineDialog
*lineDialog.funcdef: "swidget", "<create_lineDialog>(%)"
*lineDialog.argdecl: swidget UxParent;
*lineDialog.arglist: UxParent
*lineDialog.arglist.UxParent: "swidget", "%UxParent%"
*lineDialog.icode:
*lineDialog.fcode: return(rtrn);\

*lineDialog.auxdecl:
*lineDialog_itemCount.class: method
*lineDialog_itemCount.name: itemCount
*lineDialog_itemCount.parent: lineDialog
*lineDialog_itemCount.methodType: int
*lineDialog_itemCount.methodArgs: 
*lineDialog_itemCount.methodBody: int n;\
XtVaGetValues (UxGetWidget (lineList), XmNitemCount, &n, NULL);\
return (n);
*lineDialog_itemCount.methodSpec: virtual
*lineDialog_itemCount.accessSpec: public

*lineDialog_addItem.class: method
*lineDialog_addItem.name: addItem
*lineDialog_addItem.parent: lineDialog
*lineDialog_addItem.methodType: int
*lineDialog_addItem.methodArgs: char *string;\

*lineDialog_addItem.methodBody: XmString item;\
int n;\
\
item = (XmString) XmStringCreateLtoR (string, XmSTRING_DEFAULT_CHARSET);\
XmListAddItem (UxGetWidget (lineList), item, 0);\
XmStringFree (item);\
XtVaGetValues (UxGetWidget (lineList), XmNitemCount, &n, NULL);\
return (n);
*lineDialog_addItem.methodSpec: virtual
*lineDialog_addItem.accessSpec: public
*lineDialog_addItem.arguments: string
*lineDialog_addItem.string.def: "char", "*%string%"

*lineDialog_getSelPos.class: method
*lineDialog_getSelPos.name: getSelPos
*lineDialog_getSelPos.parent: lineDialog
*lineDialog_getSelPos.methodType: int
*lineDialog_getSelPos.methodArgs: int **list;\
int *number;\

*lineDialog_getSelPos.methodBody: if (XmListGetSelectedPos (UxGetWidget (lineList), list, number)) \
   return (1);\
else\
   return (0);
*lineDialog_getSelPos.methodSpec: virtual
*lineDialog_getSelPos.accessSpec: public
*lineDialog_getSelPos.arguments: list, number
*lineDialog_getSelPos.list.def: "int", "**%list%"
*lineDialog_getSelPos.number.def: "int", "*%number%"

*lineDialog_deleteAllItems.class: method
*lineDialog_deleteAllItems.name: deleteAllItems
*lineDialog_deleteAllItems.parent: lineDialog
*lineDialog_deleteAllItems.methodType: void
*lineDialog_deleteAllItems.methodArgs: 
*lineDialog_deleteAllItems.methodBody: int i, n;\
\
XtVaGetValues (UxGetWidget (lineList), XmNitemCount, &n, NULL);\
\
for (i = 1; i <= n; i++)\
{\
    XmListDeletePos (UxGetWidget (lineList), 1);\
}
*lineDialog_deleteAllItems.methodSpec: virtual
*lineDialog_deleteAllItems.accessSpec: public

*lineDialog.static: true
*lineDialog.name: lineDialog
*lineDialog.parent: NO_PARENT
*lineDialog.parentExpression: UxParent
*lineDialog.defaultShell: transientShell
*lineDialog.width: 450
*lineDialog.height: 320
*lineDialog.msgDialogType: "dialog_template"
*lineDialog.isCompound: "true"
*lineDialog.compoundIcon: "templateD.xpm"
*lineDialog.compoundName: "template_Dialog"
*lineDialog.x: 400
*lineDialog.y: 20
*lineDialog.unitType: "pixels"
*lineDialog.autoUnmanage: "false"
*lineDialog.cancelLabelString: "Delete"
*lineDialog.dialogTitle: "Line Editor"
*lineDialog.helpLabelString: "Cancel"
*lineDialog.messageString: "     X start        Y start           X end          Y end            Width"
*lineDialog.okLabelString: "OK"
*lineDialog.cancelCallback: {\
int *list, number;\
\
RepaintOverLineMarkers ();\
DrawLines ();\
\
while (XmListGetSelectedPos (UxGetWidget (lineList), &list, &number))\
{ \
   XmListDeletePos (UxGetWidget (lineList), list[0]);\
   DestroyLinePos (list[0]);\
   command ("Delete line %d\n", list[0]);\
   free (list);\
}\
\
DrawLines ();\
MarkLines (1, lineDialog_itemCount (UxThisWidget, &UxEnv), -1);\
\
}
*lineDialog.helpCallback: {\
MarkLines (1, lineDialog_itemCount (UxWidget, &UxEnv), -1);\
XmListDeselectAllItems (UxGetWidget (lineList));\
UxPopdownInterface (UxThisWidget);\
}
*lineDialog.okCallback: {\
UxPopdownInterface (UxThisWidget);\
}

*scrolledWindowList2.class: scrolledWindow
*scrolledWindowList2.static: true
*scrolledWindowList2.name: scrolledWindowList2
*scrolledWindowList2.parent: lineDialog
*scrolledWindowList2.scrollingPolicy: "application_defined"
*scrolledWindowList2.visualPolicy: "variable"
*scrolledWindowList2.scrollBarDisplayPolicy: "static"
*scrolledWindowList2.shadowThickness: 0
*scrolledWindowList2.isCompound: "true"
*scrolledWindowList2.compoundIcon: "scrllist.xpm"
*scrolledWindowList2.compoundName: "scrolled_List"
*scrolledWindowList2.x: 0
*scrolledWindowList2.y: 0

*lineList.class: scrolledList
*lineList.static: true
*lineList.name: lineList
*lineList.parent: scrolledWindowList2
*lineList.width: 380
*lineList.height: 160
*lineList.multipleSelectionCallback: {\
int *list, number, i;\
\
XtVaGetValues (UxWidget, XmNitemCount, &number, NULL);\
MarkLines (1, number, -1);\
\
if (XmListGetSelectedPos (UxWidget, &list, &number))\
{\
    for (i=0; i<number; i++)\
    {\
        MarkLines (list[i], list[i], 1);\
    }\
    free (list);\
}\
}
*lineList.selectionPolicy: "multiple_select"

