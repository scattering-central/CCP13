! UIMX ascii 2.9 key: 715                                                       

*objectEditDialog.class: instance
*objectEditDialog.classinc:
*objectEditDialog.classspec:
*objectEditDialog.classmembers:
*objectEditDialog.classconstructor:
*objectEditDialog.classdestructor:
*objectEditDialog.gbldecl: #include <stdio.h>\
#include <stdlib.h>\
\
#include "mprintf.h"\
\
extern void DestroyObjectPos (int);\
extern void DrawObjects ();\
extern void MarkObjects (int, int, int);\
extern void RepaintOverObjectMarkers ();\
extern void renumberObjects ();
*objectEditDialog.ispecdecl:
*objectEditDialog.funcdecl: swidget create_objectEditDialog(swidget UxParent)
*objectEditDialog.funcname: create_objectEditDialog
*objectEditDialog.funcdef: "swidget", "<create_objectEditDialog>(%)"
*objectEditDialog.argdecl: swidget UxParent;
*objectEditDialog.arglist: UxParent
*objectEditDialog.arglist.UxParent: "swidget", "%UxParent%"
*objectEditDialog.icode:
*objectEditDialog.fcode: editDialog_setup (rtrn, &UxEnv, 500, "Object Editor",\
"  No.        X          Y          Type        Vertices");\
\
return(rtrn);\

*objectEditDialog.auxdecl:
*objectEditDialog_markItems.class: method
*objectEditDialog_markItems.name: markItems
*objectEditDialog_markItems.parent: objectEditDialog
*objectEditDialog_markItems.methodType: void
*objectEditDialog_markItems.methodArgs: int item1;\
int item2;\
int flag;\

*objectEditDialog_markItems.methodBody: MarkObjects (item1, item2, flag);
*objectEditDialog_markItems.methodSpec: virtual
*objectEditDialog_markItems.accessSpec: public
*objectEditDialog_markItems.arguments: item1, item2, flag
*objectEditDialog_markItems.item1.def: "int", "%item1%"
*objectEditDialog_markItems.item2.def: "int", "%item2%"
*objectEditDialog_markItems.flag.def: "int", "%flag%"

*objectEditDialog_destroyItemPos.class: method
*objectEditDialog_destroyItemPos.name: destroyItemPos
*objectEditDialog_destroyItemPos.parent: objectEditDialog
*objectEditDialog_destroyItemPos.methodType: void
*objectEditDialog_destroyItemPos.methodArgs: int n;\

*objectEditDialog_destroyItemPos.methodBody: DestroyObjectPos (n);
*objectEditDialog_destroyItemPos.methodSpec: virtual
*objectEditDialog_destroyItemPos.accessSpec: public
*objectEditDialog_destroyItemPos.arguments: n
*objectEditDialog_destroyItemPos.n.def: "int", "%n%"

*objectEditDialog_drawItems.class: method
*objectEditDialog_drawItems.name: drawItems
*objectEditDialog_drawItems.parent: objectEditDialog
*objectEditDialog_drawItems.methodType: void
*objectEditDialog_drawItems.methodArgs: 
*objectEditDialog_drawItems.methodBody: DrawObjects ();
*objectEditDialog_drawItems.methodSpec: virtual
*objectEditDialog_drawItems.accessSpec: public

*objectEditDialog_repaintOverItemMarkers.class: method
*objectEditDialog_repaintOverItemMarkers.name: repaintOverItemMarkers
*objectEditDialog_repaintOverItemMarkers.parent: objectEditDialog
*objectEditDialog_repaintOverItemMarkers.methodType: void
*objectEditDialog_repaintOverItemMarkers.methodArgs: 
*objectEditDialog_repaintOverItemMarkers.methodBody: RepaintOverObjectMarkers ();
*objectEditDialog_repaintOverItemMarkers.methodSpec: virtual
*objectEditDialog_repaintOverItemMarkers.accessSpec: public

*objectEditDialog_deleteCommand.class: method
*objectEditDialog_deleteCommand.name: deleteCommand
*objectEditDialog_deleteCommand.parent: objectEditDialog
*objectEditDialog_deleteCommand.methodType: void
*objectEditDialog_deleteCommand.methodArgs: int n;\

*objectEditDialog_deleteCommand.methodBody: command ("Delete point %d\n", n);
*objectEditDialog_deleteCommand.methodSpec: virtual
*objectEditDialog_deleteCommand.accessSpec: public
*objectEditDialog_deleteCommand.arguments: n
*objectEditDialog_deleteCommand.n.def: "int", "%n%"

*objectEditDialog_renumber.class: method
*objectEditDialog_renumber.name: renumber
*objectEditDialog_renumber.parent: objectEditDialog
*objectEditDialog_renumber.methodType: void
*objectEditDialog_renumber.methodArgs: 
*objectEditDialog_renumber.methodBody: renumberObjects ();
*objectEditDialog_renumber.methodSpec: virtual
*objectEditDialog_renumber.accessSpec: public

*objectEditDialog.static: true
*objectEditDialog.name: objectEditDialog
*objectEditDialog.parent: NO_PARENT
*objectEditDialog.parentExpression: UxParent
*objectEditDialog.defaultShell: topLevelShell
*objectEditDialog.uxfallback: ux_create_editDialog_ct

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

*objectEditDialog.unitType: "pixels"
*objectEditDialog.createManaged: "false"
*objectEditDialog.x.value: 281
*objectEditDialog.y.value: 308
*objectEditDialog.width.value: 600
*objectEditDialog.height.value: 332

