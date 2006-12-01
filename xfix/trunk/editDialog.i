! UIMX ascii 2.9 key: 2813                                                      

*editDialog.class: templateDialog
*editDialog.classinc:
*editDialog.classspec:
*editDialog.classmembers:
*editDialog.classconstructor: div_t
*editDialog.classdestructor: 0
*editDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
\
#include "mprintf.h"
*editDialog.ispecdecl:
*editDialog.funcdecl: swidget create_editDialog(swidget UxParent)
*editDialog.funcname: create_editDialog
*editDialog.funcdef: "swidget", "<create_editDialog>(%)"
*editDialog.argdecl: swidget UxParent;
*editDialog.arglist: UxParent
*editDialog.arglist.UxParent: "swidget", "%UxParent%"
*editDialog.icode:
*editDialog.fcode: return(rtrn);\

*editDialog.auxdecl:
*editDialog_itemCount.class: method
*editDialog_itemCount.name: itemCount
*editDialog_itemCount.parent: editDialog
*editDialog_itemCount.methodType: int
*editDialog_itemCount.methodArgs: 
*editDialog_itemCount.methodBody: int n;\
XtVaGetValues (UxGetWidget (editScrolledList), XmNitemCount, &n, NULL);\
return (n);
*editDialog_itemCount.methodSpec: virtual
*editDialog_itemCount.accessSpec: public

*editDialog_addItem.class: method
*editDialog_addItem.name: addItem
*editDialog_addItem.parent: editDialog
*editDialog_addItem.methodType: int
*editDialog_addItem.methodArgs: char *string;\

*editDialog_addItem.methodBody: XmString item;\
int n;\
\
item = (XmString) XmStringCreateLtoR (string, XmSTRING_DEFAULT_CHARSET);\
XmListAddItem (UxGetWidget (editScrolledList), item, 0);\
XmStringFree (item);\
XtVaGetValues (UxGetWidget (editScrolledList), XmNitemCount, &n, NULL);\
return (n);
*editDialog_addItem.methodSpec: virtual
*editDialog_addItem.accessSpec: public
*editDialog_addItem.arguments: string
*editDialog_addItem.string.def: "char", "*%string%"

*editDialog_getSelPos.class: method
*editDialog_getSelPos.name: getSelPos
*editDialog_getSelPos.parent: editDialog
*editDialog_getSelPos.methodType: int
*editDialog_getSelPos.methodArgs: int **list;\
int *number;\

*editDialog_getSelPos.methodBody: if (XmListGetSelectedPos (UxGetWidget (editScrolledList), list, number)) \
   return (1);\
else\
   return (0);
*editDialog_getSelPos.methodSpec: virtual
*editDialog_getSelPos.accessSpec: public
*editDialog_getSelPos.arguments: list, number
*editDialog_getSelPos.list.def: "int", "**%list%"
*editDialog_getSelPos.number.def: "int", "*%number%"

*editDialog_deleteAllItems.class: method
*editDialog_deleteAllItems.name: deleteAllItems
*editDialog_deleteAllItems.parent: editDialog
*editDialog_deleteAllItems.methodType: int
*editDialog_deleteAllItems.methodArgs: 
*editDialog_deleteAllItems.methodBody: int i, n;\
\
XtVaGetValues (UxGetWidget (editScrolledList), XmNitemCount, &n, NULL);\
\
for (i = 1; i <= n; i++)\
{\
    XmListDeletePos (UxGetWidget (editScrolledList), 1);\
}
*editDialog_deleteAllItems.methodSpec: virtual
*editDialog_deleteAllItems.accessSpec: public

*editDialog_markItems.class: method
*editDialog_markItems.name: markItems
*editDialog_markItems.parent: editDialog
*editDialog_markItems.methodType: void
*editDialog_markItems.methodArgs: int item1;\
int item2;\
int flag;\

*editDialog_markItems.methodBody: 
*editDialog_markItems.methodSpec: virtual
*editDialog_markItems.accessSpec: protected
*editDialog_markItems.arguments: item1, item2, flag
*editDialog_markItems.item1.def: "int", "%item1%"
*editDialog_markItems.item2.def: "int", "%item2%"
*editDialog_markItems.flag.def: "int", "%flag%"

*editDialog_drawItems.class: method
*editDialog_drawItems.name: drawItems
*editDialog_drawItems.parent: editDialog
*editDialog_drawItems.methodType: void
*editDialog_drawItems.methodArgs: 
*editDialog_drawItems.methodBody: 
*editDialog_drawItems.methodSpec: virtual
*editDialog_drawItems.accessSpec: protected

*editDialog_destroyItemPos.class: method
*editDialog_destroyItemPos.name: destroyItemPos
*editDialog_destroyItemPos.parent: editDialog
*editDialog_destroyItemPos.methodType: void
*editDialog_destroyItemPos.methodArgs: int n;\

*editDialog_destroyItemPos.methodBody: 
*editDialog_destroyItemPos.methodSpec: virtual
*editDialog_destroyItemPos.accessSpec: public
*editDialog_destroyItemPos.arguments: n
*editDialog_destroyItemPos.n.def: "int", "%n%"

*editDialog_repaintOverItemMarkers.class: method
*editDialog_repaintOverItemMarkers.name: repaintOverItemMarkers
*editDialog_repaintOverItemMarkers.parent: editDialog
*editDialog_repaintOverItemMarkers.methodType: void
*editDialog_repaintOverItemMarkers.methodArgs: 
*editDialog_repaintOverItemMarkers.methodBody: 
*editDialog_repaintOverItemMarkers.methodSpec: virtual
*editDialog_repaintOverItemMarkers.accessSpec: public

*editDialog_deleteCommand.class: method
*editDialog_deleteCommand.name: deleteCommand
*editDialog_deleteCommand.parent: editDialog
*editDialog_deleteCommand.methodType: void
*editDialog_deleteCommand.methodArgs: int n;\

*editDialog_deleteCommand.methodBody: 
*editDialog_deleteCommand.methodSpec: virtual
*editDialog_deleteCommand.accessSpec: protected
*editDialog_deleteCommand.arguments: n
*editDialog_deleteCommand.n.def: "int", "%n%"

*editDialog_modifyItemPos.class: method
*editDialog_modifyItemPos.name: modifyItemPos
*editDialog_modifyItemPos.parent: editDialog
*editDialog_modifyItemPos.methodType: void
*editDialog_modifyItemPos.methodArgs: int nPos;\
char *pcString;\

*editDialog_modifyItemPos.methodBody: XmString item;\
\
item = (XmString) XmStringCreateLtoR (pcString, XmSTRING_DEFAULT_CHARSET);\
XmListReplaceItemsPos (editScrolledList, &item, 1, nPos);\
XmStringFree (item);\

*editDialog_modifyItemPos.methodSpec: virtual
*editDialog_modifyItemPos.accessSpec: public
*editDialog_modifyItemPos.arguments: nPos, pcString
*editDialog_modifyItemPos.nPos.def: "int", "%nPos%"
*editDialog_modifyItemPos.pcString.def: "char", "*%pcString%"

*editDialog_renumber.class: method
*editDialog_renumber.name: renumber
*editDialog_renumber.parent: editDialog
*editDialog_renumber.methodType: void
*editDialog_renumber.methodArgs: 
*editDialog_renumber.methodBody: 
*editDialog_renumber.methodSpec: virtual
*editDialog_renumber.accessSpec: public

*editDialog_setup.class: method
*editDialog_setup.name: setup
*editDialog_setup.parent: editDialog
*editDialog_setup.methodType: void
*editDialog_setup.methodArgs: int nWidth;\
char *pcTitle;\
char *pcLabel;\

*editDialog_setup.methodBody: XtVaSetValues (UxThis, \
               XmNwidth, nWidth,\
               RES_CONVERT (XmNdialogTitle, pcTitle),\
               NULL);\
\
XtVaSetValues (editLabel,\
               RES_CONVERT (XmNlabelString, pcLabel),\
               NULL);\

*editDialog_setup.methodSpec: virtual
*editDialog_setup.accessSpec: public
*editDialog_setup.arguments: nWidth, pcTitle, pcLabel
*editDialog_setup.nWidth.def: "int", "%nWidth%"
*editDialog_setup.pcTitle.def: "char", "*%pcTitle%"
*editDialog_setup.pcLabel.def: "char", "*%pcLabel%"

*editDialog.static: true
*editDialog.name: editDialog
*editDialog.parent: NO_PARENT
*editDialog.parentExpression: UxParent
*editDialog.defaultShell: topLevelShell
*editDialog.width: 600
*editDialog.height: 332
*editDialog.msgDialogType: "dialog_template"
*editDialog.isCompound: "true"
*editDialog.compoundIcon: "templateD.xpm"
*editDialog.compoundName: "template_Dialog"
*editDialog.x: 390
*editDialog.y: 550
*editDialog.unitType: "pixels"
*editDialog.autoUnmanage: "false"
*editDialog.cancelLabelString: "Delete"
*editDialog.dialogTitle: "Edit Dialog"
*editDialog.helpLabelString: "Cancel"
*editDialog.okLabelString: "OK"
*editDialog.okCallback: UxPopdownInterface (UxThisWidget);
*editDialog.createManaged: "false"
*editDialog.cancelCallback: {\
int *list, number;\
\
editDialog_repaintOverItemMarkers (UxThisWidget, &UxEnv);\
editDialog_drawItems (UxThisWidget, &UxEnv);\
\
while (XmListGetSelectedPos (UxGetWidget (editScrolledList), &list, &number))\
{ \
   XmListDeletePos (UxGetWidget (editScrolledList), list[0]);\
   editDialog_destroyItemPos (UxThisWidget, &UxEnv, list[0]);\
   editDialog_deleteCommand (UxThisWidget, &UxEnv, list[0]);\
   free (list);\
}\
\
editDialog_drawItems (UxThisWidget, &UxEnv);\
editDialog_markItems (UxThisWidget, &UxEnv, \
                      1, editDialog_itemCount (UxThisWidget, &UxEnv), -1);\
\
}
*editDialog.helpCallback: {\
editDialog_markItems (UxThisWidget, &UxEnv, \
                      1, editDialog_itemCount (UxThisWidget, &UxEnv), -1);\
XmListDeselectAllItems (UxGetWidget (editScrolledList));\
UxPopdownInterface (UxThisWidget);\
}
*editDialog.labelFontList.lock: true
*editDialog.labelFontList: "8x13"
*editDialog.textFontList.lock: true
*editDialog.textFontList: "8x13"
*editDialog.buttonFontList: "8x13"

*editForm.class: form
*editForm.static: true
*editForm.name: editForm
*editForm.parent: editDialog
*editForm.width: 300
*editForm.height: 200
*editForm.resizePolicy: "resize_none"
*editForm.isCompound: "true"
*editForm.compoundIcon: "form.xpm"
*editForm.compoundName: "form_"
*editForm.x: 0
*editForm.y: 0

*editScrolledWindowList.class: scrolledWindow
*editScrolledWindowList.static: true
*editScrolledWindowList.name: editScrolledWindowList
*editScrolledWindowList.parent: editForm
*editScrolledWindowList.scrollingPolicy: "application_defined"
*editScrolledWindowList.visualPolicy: "variable"
*editScrolledWindowList.scrollBarDisplayPolicy: "static"
*editScrolledWindowList.shadowThickness: 0
*editScrolledWindowList.isCompound: "true"
*editScrolledWindowList.compoundIcon: "scrllist.xpm"
*editScrolledWindowList.compoundName: "scrolled_List"
*editScrolledWindowList.bottomAttachment: "attach_form"
*editScrolledWindowList.leftOffset: 0
*editScrolledWindowList.rightAttachment: "attach_form"
*editScrolledWindowList.topOffset: 60
*editScrolledWindowList.topAttachment: "attach_form"
*editScrolledWindowList.leftAttachment: "attach_form"

*editScrolledList.class: scrolledList
*editScrolledList.static: true
*editScrolledList.name: editScrolledList
*editScrolledList.parent: editScrolledWindowList
*editScrolledList.width: 378
*editScrolledList.height: 217
*editScrolledList.selectionPolicy: "multiple_select"
*editScrolledList.multipleSelectionCallback: {\
int *list, number, i;\
\
XtVaGetValues (UxWidget, XmNitemCount, &number, NULL);\
editDialog_markItems (editDialog, &UxEnv, 1, number, -1);\
\
if (XmListGetSelectedPos (UxWidget, &list, &number))\
{\
    for (i=0; i<number; i++)\
    {\
        editDialog_markItems (editDialog, &UxEnv, list[i], list[i], 1);\
    }\
    free (list);\
}\
}
*editScrolledList.fontList.lock: true
*editScrolledList.fontList: "8x13"

*editLabel.class: label
*editLabel.static: true
*editLabel.name: editLabel
*editLabel.parent: editForm
*editLabel.isCompound: "true"
*editLabel.compoundIcon: "label.xpm"
*editLabel.compoundName: "label_"
*editLabel.x: 4
*editLabel.y: 10
*editLabel.height: 25
*editLabel.leftAttachment: "attach_form"
*editLabel.rightAttachment: "attach_form"
*editLabel.topAttachment: "attach_form"
*editLabel.fontList: "8x13bold"
*editLabel.labelString: "Base class for edit dialogs"
*editLabel.alignment: "alignment_beginning"
*editLabel.topOffset: 35

*renumberButton.class: pushButton
*renumberButton.static: true
*renumberButton.name: renumberButton
*renumberButton.parent: editForm
*renumberButton.isCompound: "true"
*renumberButton.compoundIcon: "push.xpm"
*renumberButton.compoundName: "push_Button"
*renumberButton.x: 195
*renumberButton.y: 1
*renumberButton.width: 150
*renumberButton.height: 30
*renumberButton.topAttachment: "attach_form"
*renumberButton.topOffset: 0
*renumberButton.rightAttachment: "attach_form"
*renumberButton.labelString: "Renumber"
*renumberButton.fontList: "8x13bold"
*renumberButton.activateCallback: {\
int n;\
\
XtVaGetValues (UxGetWidget (editScrolledList), XmNitemCount, &n, NULL);\
\
editDialog_renumber (editDialog, &UxEnv);\
editDialog_markItems (editDialog, &UxEnv, 1, n, -1);\
}

