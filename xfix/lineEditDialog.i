! UIMX ascii 2.9 key: 391                                                       

*lineEditDialog.class: instance
*lineEditDialog.classinc:
*lineEditDialog.classspec:
*lineEditDialog.classmembers:
*lineEditDialog.classconstructor:
*lineEditDialog.classdestructor:
*lineEditDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
\
#include "mprintf.h"\
\
extern void DestroyLinePos ();\
extern void DrawLines ();\
extern void MarkLines (int, int, int);\
extern void RepaintOverLineMarkers ();\
extern void renumberLines ();
*lineEditDialog.ispecdecl:
*lineEditDialog.funcdecl: swidget create_lineEditDialog(swidget UxParent)
*lineEditDialog.funcname: create_lineEditDialog
*lineEditDialog.funcdef: "swidget", "<create_lineEditDialog>(%)"
*lineEditDialog.argdecl: swidget UxParent;
*lineEditDialog.arglist: UxParent
*lineEditDialog.arglist.UxParent: "swidget", "%UxParent%"
*lineEditDialog.icode:
*lineEditDialog.fcode: editDialog_setup (rtrn, &UxEnv, 550, "Line Editor",\
"  No.    X start    Y start     X end      Y end       Width");\
return(rtrn);\

*lineEditDialog.auxdecl:
*lineEditDialog_destroyItemPos.class: method
*lineEditDialog_destroyItemPos.name: destroyItemPos
*lineEditDialog_destroyItemPos.parent: lineEditDialog
*lineEditDialog_destroyItemPos.methodType: void
*lineEditDialog_destroyItemPos.methodArgs: int n;\

*lineEditDialog_destroyItemPos.methodBody: DestroyLinePos (n);
*lineEditDialog_destroyItemPos.methodSpec: virtual
*lineEditDialog_destroyItemPos.accessSpec: public
*lineEditDialog_destroyItemPos.arguments: n
*lineEditDialog_destroyItemPos.n.def: "int", "%n%"

*lineEditDialog_drawItems.class: method
*lineEditDialog_drawItems.name: drawItems
*lineEditDialog_drawItems.parent: lineEditDialog
*lineEditDialog_drawItems.methodType: void
*lineEditDialog_drawItems.methodArgs: 
*lineEditDialog_drawItems.methodBody: DrawLines ();
*lineEditDialog_drawItems.methodSpec: virtual
*lineEditDialog_drawItems.accessSpec: public

*lineEditDialog_markItems.class: method
*lineEditDialog_markItems.name: markItems
*lineEditDialog_markItems.parent: lineEditDialog
*lineEditDialog_markItems.methodType: void
*lineEditDialog_markItems.methodArgs: int item1;\
int item2;\
int flag;\

*lineEditDialog_markItems.methodBody: MarkLines (item1, item2, flag);
*lineEditDialog_markItems.methodSpec: virtual
*lineEditDialog_markItems.accessSpec: public
*lineEditDialog_markItems.arguments: item1, item2, flag
*lineEditDialog_markItems.item1.def: "int", "%item1%"
*lineEditDialog_markItems.item2.def: "int", "%item2%"
*lineEditDialog_markItems.flag.def: "int", "%flag%"

*lineEditDialog_repaintOverItemMarkers.class: method
*lineEditDialog_repaintOverItemMarkers.name: repaintOverItemMarkers
*lineEditDialog_repaintOverItemMarkers.parent: lineEditDialog
*lineEditDialog_repaintOverItemMarkers.methodType: void
*lineEditDialog_repaintOverItemMarkers.methodArgs: 
*lineEditDialog_repaintOverItemMarkers.methodBody: RepaintOverLineMarkers ();
*lineEditDialog_repaintOverItemMarkers.methodSpec: virtual
*lineEditDialog_repaintOverItemMarkers.accessSpec: public

*lineEditDialog_deleteCommand.class: method
*lineEditDialog_deleteCommand.name: deleteCommand
*lineEditDialog_deleteCommand.parent: lineEditDialog
*lineEditDialog_deleteCommand.methodType: void
*lineEditDialog_deleteCommand.methodArgs: int n;\

*lineEditDialog_deleteCommand.methodBody: command ("Delete line %d\n", n);
*lineEditDialog_deleteCommand.methodSpec: virtual
*lineEditDialog_deleteCommand.accessSpec: public
*lineEditDialog_deleteCommand.arguments: n
*lineEditDialog_deleteCommand.n.def: "int", "%n%"

*lineEditDialog_renumber.class: method
*lineEditDialog_renumber.name: renumber
*lineEditDialog_renumber.parent: lineEditDialog
*lineEditDialog_renumber.methodType: void
*lineEditDialog_renumber.methodArgs: 
*lineEditDialog_renumber.methodBody: renumberLines ();
*lineEditDialog_renumber.methodSpec: virtual
*lineEditDialog_renumber.accessSpec: public

*lineEditDialog.static: true
*lineEditDialog.name: lineEditDialog
*lineEditDialog.parent: NO_PARENT
*lineEditDialog.parentExpression: UxParent
*lineEditDialog.defaultShell: topLevelShell
*lineEditDialog.uxfallback: ux_create_editDialog_ct

*ux_create_editDialog_ct.class: uxfallback
*ux_create_editDialog_ct.constructor: "create_editDialog"
*ux_create_editDialog_ct.constructor.def: "swidget", <create_editDialog>(%)
*ux_create_editDialog_ct.component: "editDialog"
*ux_create_editDialog_ct.headerFile: "editDialog.h"
*ux_create_editDialog_ct.argDefinition: "swidget UxParent;\\
"
*ux_create_editDialog_ct.constructorArgs: UxParent
*ux_create_editDialog_ct.UxParent.def: "swidget", "%UxParent%"
*ux_create_editDialog_ct.propDefinition: "int x; int y; int width; int height;"
*ux_create_editDialog_ct.propertyDefs: x, y, width, height
*ux_create_editDialog_ct.x.def: "int", "%x%"
*ux_create_editDialog_ct.y.def: "int", "%y%"
*ux_create_editDialog_ct.width.def: "int", "%width%"
*ux_create_editDialog_ct.height.def: "int", "%height%"

*lineEditDialog.unitType: "pixels"
*lineEditDialog.createManaged: "false"
*lineEditDialog.x.value: 281
*lineEditDialog.y.value: 308
*lineEditDialog.width.value: 600
*lineEditDialog.height.value: 332

