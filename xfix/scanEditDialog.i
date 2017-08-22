! UIMX ascii 2.9 key: 710                                                       

*scanEditDialog.class: instance
*scanEditDialog.classinc:
*scanEditDialog.classspec:
*scanEditDialog.classmembers:
*scanEditDialog.classconstructor:
*scanEditDialog.classdestructor:
*scanEditDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
\
#include "mprintf.h"\
\
extern void DestroyScanPos ();\
extern void DrawScans ();\
extern void MarkScans (int, int, int);\
extern void RepaintOverScanMarkers ();\
extern void renumberScans ();
*scanEditDialog.ispecdecl:
*scanEditDialog.funcdecl: swidget create_scanEditDialog(swidget UxParent)
*scanEditDialog.funcname: create_scanEditDialog
*scanEditDialog.funcdef: "swidget", "<create_scanEditDialog>(%)"
*scanEditDialog.argdecl: swidget UxParent;
*scanEditDialog.arglist: UxParent
*scanEditDialog.arglist.UxParent: "swidget", "%UxParent%"
*scanEditDialog.icode:
*scanEditDialog.fcode: editDialog_setup (rtrn, &UxEnv, 630, "Scan Editor",\
"  No.     X centre   Y centre   Radius     Width    Phi start   Phi end");\
return(rtrn);\

*scanEditDialog.auxdecl:
*scanEditDialog_destroyItemPos.class: method
*scanEditDialog_destroyItemPos.name: destroyItemPos
*scanEditDialog_destroyItemPos.parent: scanEditDialog
*scanEditDialog_destroyItemPos.methodType: void
*scanEditDialog_destroyItemPos.methodArgs: int n;\

*scanEditDialog_destroyItemPos.methodBody: DestroyScanPos (n);
*scanEditDialog_destroyItemPos.methodSpec: virtual
*scanEditDialog_destroyItemPos.accessSpec: public
*scanEditDialog_destroyItemPos.arguments: n
*scanEditDialog_destroyItemPos.n.def: "int", "%n%"

*scanEditDialog_drawItems.class: method
*scanEditDialog_drawItems.name: drawItems
*scanEditDialog_drawItems.parent: scanEditDialog
*scanEditDialog_drawItems.methodType: void
*scanEditDialog_drawItems.methodArgs: 
*scanEditDialog_drawItems.methodBody: DrawScans ();
*scanEditDialog_drawItems.methodSpec: virtual
*scanEditDialog_drawItems.accessSpec: public

*scanEditDialog_markItems.class: method
*scanEditDialog_markItems.name: markItems
*scanEditDialog_markItems.parent: scanEditDialog
*scanEditDialog_markItems.methodType: void
*scanEditDialog_markItems.methodArgs: int item1;\
int item2;\
int flag;\

*scanEditDialog_markItems.methodBody: MarkScans (item1, item2, flag);
*scanEditDialog_markItems.methodSpec: virtual
*scanEditDialog_markItems.accessSpec: public
*scanEditDialog_markItems.arguments: item1, item2, flag
*scanEditDialog_markItems.item1.def: "int", "%item1%"
*scanEditDialog_markItems.item2.def: "int", "%item2%"
*scanEditDialog_markItems.flag.def: "int", "%flag%"

*scanEditDialog_repaintOverItemMarkers.class: method
*scanEditDialog_repaintOverItemMarkers.name: repaintOverItemMarkers
*scanEditDialog_repaintOverItemMarkers.parent: scanEditDialog
*scanEditDialog_repaintOverItemMarkers.methodType: void
*scanEditDialog_repaintOverItemMarkers.methodArgs: 
*scanEditDialog_repaintOverItemMarkers.methodBody: RepaintOverScanMarkers ();
*scanEditDialog_repaintOverItemMarkers.methodSpec: virtual
*scanEditDialog_repaintOverItemMarkers.accessSpec: public

*scanEditDialog_deleteCommand.class: method
*scanEditDialog_deleteCommand.name: deleteCommand
*scanEditDialog_deleteCommand.parent: scanEditDialog
*scanEditDialog_deleteCommand.methodType: void
*scanEditDialog_deleteCommand.methodArgs: int n;\

*scanEditDialog_deleteCommand.methodBody: command ("Delete scan %d\n", n);
*scanEditDialog_deleteCommand.methodSpec: virtual
*scanEditDialog_deleteCommand.accessSpec: public
*scanEditDialog_deleteCommand.arguments: n
*scanEditDialog_deleteCommand.n.def: "int", "%n%"

*scanEditDialog_renumber.class: method
*scanEditDialog_renumber.name: renumber
*scanEditDialog_renumber.parent: scanEditDialog
*scanEditDialog_renumber.methodType: void
*scanEditDialog_renumber.methodArgs: 
*scanEditDialog_renumber.methodBody: renumberScans ();
*scanEditDialog_renumber.methodSpec: virtual
*scanEditDialog_renumber.accessSpec: public

*scanEditDialog.static: true
*scanEditDialog.name: scanEditDialog
*scanEditDialog.parent: NO_PARENT
*scanEditDialog.parentExpression: UxParent
*scanEditDialog.defaultShell: topLevelShell
*scanEditDialog.uxfallback: ux_create_editDialog_ct

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

*scanEditDialog.unitType: "pixels"
*scanEditDialog.createManaged: "false"
*scanEditDialog.x.value: 281
*scanEditDialog.y.value: 308
*scanEditDialog.width.value: 600
*scanEditDialog.height.value: 332

