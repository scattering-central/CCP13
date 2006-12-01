! UIMX ascii 2.9 key: 5971                                                      

*otokoFileSelect.class: instance
*otokoFileSelect.classinc:
*otokoFileSelect.classspec:
*otokoFileSelect.classmembers:
*otokoFileSelect.classconstructor:
*otokoFileSelect.classdestructor:
*otokoFileSelect.gbldecl: #include <stdio.h>\
\
#ifndef DESIGN_TIME\
typedef void (*vfptr)();\
#endif\

*otokoFileSelect.ispecdecl:
*otokoFileSelect.funcdecl: swidget create_otokoFileSelect(swidget UxParent)
*otokoFileSelect.funcname: create_otokoFileSelect
*otokoFileSelect.funcdef: "swidget", "<create_otokoFileSelect>(%)"
*otokoFileSelect.argdecl: swidget UxParent;
*otokoFileSelect.arglist: UxParent
*otokoFileSelect.arglist.UxParent: "swidget", "%UxParent%"
*otokoFileSelect.icode:
*otokoFileSelect.fcode: XtVaSetValues (rtrn, \
               RES_CONVERT (XmNdialogTitle, "Otoko File Selection"),\
               NULL);\
return(rtrn);\

*otokoFileSelect.auxdecl:
*otokoFileSelect_readHeader.class: method
*otokoFileSelect_readHeader.name: readHeader
*otokoFileSelect_readHeader.parent: otokoFileSelect
*otokoFileSelect_readHeader.methodType: int
*otokoFileSelect_readHeader.methodArgs: char *file;\
int mem;\
int *npixel;\
int *nraster;\
int *nframes;\

*otokoFileSelect_readHeader.methodBody: char buff[128];\
int i = 0, irc = FALSE;\
FILE *fp, *fopen ();\
int np[3], nf[3];\
\
fp = fopen (file, "r");\
if (fgets (buff, 128, fp) != NULL &&\
    fgets (buff, 128, fp) != NULL)\
{\
    do {\
        if ((fgets (buff, 128, fp)) == NULL)\
             break;\
        else if (sscanf (buff, "%8d%8d", &np[i], &nf[i]) != 2)\
             break;\
        else if ((fgets (buff, 128, fp)) == NULL)\
             break;\
    }\
    while (++i < mem);\
    if (i > 0)\
    {\
        *npixel = np[mem-1];\
        *nraster = 1;\
        *nframes = nf[mem-1];\
    }\
}\
fclose (fp);\
return i;\

*otokoFileSelect_readHeader.accessSpec: private
*otokoFileSelect_readHeader.arguments: file, mem, npixel, nraster, nframes
*otokoFileSelect_readHeader.file.def: "char", "*%file%"
*otokoFileSelect_readHeader.mem.def: "int", "%mem%"
*otokoFileSelect_readHeader.npixel.def: "int", "*%npixel%"
*otokoFileSelect_readHeader.nraster.def: "int", "*%nraster%"
*otokoFileSelect_readHeader.nframes.def: "int", "*%nframes%"

*otokoFileSelect.static: true
*otokoFileSelect.name: otokoFileSelect
*otokoFileSelect.parent: NO_PARENT
*otokoFileSelect.parentExpression: UxParent
*otokoFileSelect.defaultShell: topLevelShell
*otokoFileSelect.uxfallback: ux_create_obFileSelect_ct

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

*otokoFileSelect.unitType: "pixels"
*otokoFileSelect.x: 376
*otokoFileSelect.y: 215
*otokoFileSelect.width: 400
*otokoFileSelect.height: 435
*otokoFileSelect.createManaged: "false"
*otokoFileSelect.x.value: 709
*otokoFileSelect.y.value: 368

