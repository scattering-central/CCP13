! UIMX ascii 2.9 key: 8060                                                      

*bslFileSelect.class: instance
*bslFileSelect.classinc:
*bslFileSelect.classspec:
*bslFileSelect.classmembers:
*bslFileSelect.classconstructor:
*bslFileSelect.classdestructor:
*bslFileSelect.gbldecl: #include <stdio.h>\
\
#ifndef DESIGN_TIME\
typedef void (*vfptr)();\
#endif\

*bslFileSelect.ispecdecl:
*bslFileSelect.funcdecl: swidget create_bslFileSelect(swidget UxParent)
*bslFileSelect.funcname: create_bslFileSelect
*bslFileSelect.funcdef: "swidget", "<create_bslFileSelect>(%)"
*bslFileSelect.argdecl: swidget UxParent;
*bslFileSelect.arglist: UxParent
*bslFileSelect.arglist.UxParent: "swidget", "%UxParent%"
*bslFileSelect.icode:
*bslFileSelect.fcode: XtVaSetValues (rtrn, \
               RES_CONVERT (XmNdialogTitle, "BSL File Selection"),\
               NULL);\
\
return(rtrn);\

*bslFileSelect.auxdecl:
*bslFileSelect_readHeader.class: method
*bslFileSelect_readHeader.name: readHeader
*bslFileSelect_readHeader.parent: bslFileSelect
*bslFileSelect_readHeader.methodType: int
*bslFileSelect_readHeader.methodArgs: char *file;\
int mem;\
int *npixel;\
int *nraster;\
int *nframes;\

*bslFileSelect_readHeader.methodBody: char buff[128];\
int i = 0, irc = FALSE;\
FILE *fp, *fopen ();\
int np[3], nr[3], nf[3];\
\
fp = fopen (file, "r");\
if (fgets (buff, 128, fp) != NULL &&\
    fgets (buff, 128, fp) != NULL)\
{\
    do {\
        if ((fgets (buff, 128, fp)) == NULL)\
             break;\
        else if (sscanf (buff, "%8d%8d%8d", &np[i], &nr[i], &nf[i]) != 3)\
             break;\
        else if ((fgets (buff, 128, fp)) == NULL)\
             break;\
    }\
    while (++i < 4);\
    if (i > 0)\
    {\
        *npixel = np[mem-1];\
        *nraster = nr[mem-1];\
        *nframes = nf[mem-1];\
    }\
}\
fclose (fp);\
return i;\

*bslFileSelect_readHeader.accessSpec: private
*bslFileSelect_readHeader.arguments: file, mem, npixel, nraster, nframes
*bslFileSelect_readHeader.file.def: "char", "*%file%"
*bslFileSelect_readHeader.mem.def: "int", "%mem%"
*bslFileSelect_readHeader.npixel.def: "int", "*%npixel%"
*bslFileSelect_readHeader.nraster.def: "int", "*%nraster%"
*bslFileSelect_readHeader.nframes.def: "int", "*%nframes%"

*bslFileSelect.static: true
*bslFileSelect.name: bslFileSelect
*bslFileSelect.parent: NO_PARENT
*bslFileSelect.parentExpression: UxParent
*bslFileSelect.defaultShell: topLevelShell
*bslFileSelect.uxfallback: ux_create_obFileSelect_ct

*ux_create_obFileSelect_ct.class: uxfallback
*ux_create_obFileSelect_ct.constructor: "create_obFileSelect"
*ux_create_obFileSelect_ct.constructor.def: "swidget", <create_obFileSelect>(%)
*ux_create_obFileSelect_ct.component: "obFileSelect"
*ux_create_obFileSelect_ct.headerFile: "obFileSelect.h"
*ux_create_obFileSelect_ct.argDefinition: "swidget UxParent;\\
"
*ux_create_obFileSelect_ct.constructorArgs: UxParent
*ux_create_obFileSelect_ct.UxParent.def: "swidget", "%UxParent%"
*ux_create_obFileSelect_ct.propDefinition: "int x; int y; int width; int height;"
*ux_create_obFileSelect_ct.propertyDefs: x, y, width, height
*ux_create_obFileSelect_ct.x.def: "int", "%x%"
*ux_create_obFileSelect_ct.y.def: "int", "%y%"
*ux_create_obFileSelect_ct.width.def: "int", "%width%"
*ux_create_obFileSelect_ct.height.def: "int", "%height%"

*bslFileSelect.unitType: "pixels"
*bslFileSelect.x: 490
*bslFileSelect.y: 260
*bslFileSelect.width: 400
*bslFileSelect.height: 400
*bslFileSelect.createManaged: "false"
*bslFileSelect.x.value: 577
*bslFileSelect.y.value: 485

