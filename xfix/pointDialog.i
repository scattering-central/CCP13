! UIMX ascii 2.9 key: 8897                                                      

*objectDialog.class: templateDialog
*objectDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
\
#include "mprintf.h"\
\
extern void DestroyObjectPos (int);\
extern void DrawObjects ();\
extern void MarkObjects (int, int, int);\
extern void RepaintOverObjectMarkers ();
*objectDialog.ispecdecl:
*objectDialog.funcdecl: swidget create_objectDialog(swidget UxParent)
*objectDialog.funcname: create_objectDialog
*objectDialog.funcdef: "swidget", "<create_objectDialog>(%)"
*objectDialog.argdecl: swidget UxParent;
*objectDialog.arglist: UxParent
*objectDialog.arglist.UxParent: "swidget", "%UxParent%"
*objectDialog.icode:
*objectDialog.fcode: return(rtrn);\

*objectDialog.auxdecl:
*objectDialog_itemCount.class: method
*objectDialog_itemCount.name: itemCount
*objectDialog_itemCount.parent: objectDialog
*objectDialog_itemCount.methodType: int
*objectDialog_itemCount.methodArgs: 
*objectDialog_itemCount.methodBody: int n;\
XtVaGetValues (UxGetWidget (objectList), XmNitemCount, &n, NULL);\
return (n);
*objectDialog_itemCount.methodSpec: virtual
*objectDialog_itemCount.accessSpec: public

*objectDialog_addItem.class: method
*objectDialog_addItem.name: addItem
*objectDialog_addItem.parent: objectDialog
*objectDialog_addItem.methodType: int
*objectDialog_addItem.methodArgs: char *string;\

*objectDialog_addItem.methodBody: XmString item;\
int n;\
\
item = (XmString) XmStringCreateLtoR (string, XmSTRING_DEFAULT_CHARSET);\
XmListAddItem (UxGetWidget (objectList), item, 0);\
XmStringFree (item);\
XtVaGetValues (UxGetWidget (objectList), XmNitemCount, &n, NULL);\
return (n);
*objectDialog_addItem.methodSpec: virtual
*objectDialog_addItem.accessSpec: public
*objectDialog_addItem.arguments: string
*objectDialog_addItem.string.def: "char", "*%string%"

*objectDialog_getSelPos.class: method
*objectDialog_getSelPos.name: getSelPos
*objectDialog_getSelPos.parent: objectDialog
*objectDialog_getSelPos.methodType: int
*objectDialog_getSelPos.methodArgs: int **list;\
int *number;\

*objectDialog_getSelPos.methodBody: if (XmListGetSelectedPos (UxGetWidget (objectList), list, number)) \
   return (1);\
else\
   return (0);
*objectDialog_getSelPos.methodSpec: virtual
*objectDialog_getSelPos.accessSpec: public
*objectDialog_getSelPos.arguments: list, number
*objectDialog_getSelPos.list.def: "int", "**%list%"
*objectDialog_getSelPos.number.def: "int", "*%number%"

*objectDialog_deleteAllItems.class: method
*objectDialog_deleteAllItems.name: deleteAllItems
*objectDialog_deleteAllItems.parent: objectDialog
*objectDialog_deleteAllItems.methodType: void
*objectDialog_deleteAllItems.methodArgs: 
*objectDialog_deleteAllItems.methodBody: int i, n;\
\
XtVaGetValues (UxGetWidget (objectList), XmNitemCount, &n, NULL);\
\
for (i = 1; i <= n; i++)\
{\
    XmListDeletePos (UxGetWidget (objectList), 1);\
}
*objectDialog_deleteAllItems.methodSpec: virtual
*objectDialog_deleteAllItems.accessSpec: public

*objectDialog.static: true
*objectDialog.name: objectDialog
*objectDialog.parent: NO_PARENT
*objectDialog.parentExpression: UxParent
*objectDialog.defaultShell: transientShell
*objectDialog.width: 400
*objectDialog.height: 350
*objectDialog.msgDialogType: "dialog_template"
*objectDialog.isCompound: "true"
*objectDialog.compoundIcon: "templateD.xpm"
*objectDialog.compoundName: "template_Dialog"
*objectDialog.x: 340
*objectDialog.y: 230
*objectDialog.unitType: "pixels"
*objectDialog.cancelLabelString: "Delete"
*objectDialog.dialogTitle: "Object Editor"
*objectDialog.autoUnmanage: "false"
*objectDialog.helpLabelString: "Cancel"
*objectDialog.okLabelString: "OK"
*objectDialog.messageString: "         X                     Y                   Type                  Points"
*objectDialog.cancelCallback: {\
int *list, number;\
\
RepaintOverObjectMarkers ();\
DrawObjects ();\
\
while (XmListGetSelectedPos (UxGetWidget (objectList), &list, &number))\
{ \
   XmListDeletePos (UxGetWidget (objectList), list[0]);\
   DestroyObjectPos (list[0]);\
   command ("Delete point %d\n", list[0]);\
   free (list);\
}\
\
DrawObjects ();\
MarkObjects (1, objectDialog_itemCount (UxThisWidget, &UxEnv), -1);\
\
}
*objectDialog.okCallback: {\
UxPopdownInterface (UxThisWidget);\
}
*objectDialog.helpCallback: {\
MarkObjects (1, objectDialog_itemCount (UxWidget, &UxEnv), -1);\
XmListDeselectAllItems (UxGetWidget (objectList));\
UxPopdownInterface (UxThisWidget);\
}

*scrolledWindowList1.class: scrolledWindow
*scrolledWindowList1.static: true
*scrolledWindowList1.name: scrolledWindowList1
*scrolledWindowList1.parent: objectDialog
*scrolledWindowList1.scrollingPolicy: "application_defined"
*scrolledWindowList1.visualPolicy: "variable"
*scrolledWindowList1.scrollBarDisplayPolicy: "static"
*scrolledWindowList1.shadowThickness: 0
*scrolledWindowList1.isCompound: "true"
*scrolledWindowList1.compoundIcon: "scrllist.xpm"
*scrolledWindowList1.compoundName: "scrolled_List"
*scrolledWindowList1.x: 20
*scrolledWindowList1.y: 10

*objectList.class: scrolledList
*objectList.static: true
*objectList.name: objectList
*objectList.parent: scrolledWindowList1
*objectList.width: 400
*objectList.height: 180
*objectList.selectionPolicy: "multiple_select"
*objectList.multipleSelectionCallback: {\
int *list, number, i;\
\
XtVaGetValues (UxWidget, XmNitemCount, &number, NULL);\
MarkObjects (1, number, -1);\
\
if (XmListGetSelectedPos (UxWidget, &list, &number))\
{\
    for (i=0; i<number; i++)\
    {\
        MarkObjects (list[i], list[i], 1);\
    }\
    free (list);\
}\
}
*objectList.automaticSelection: "false"

