
/*******************************************************************************
	bslFileSelect.c

       Associated Header file: bslFileSelect.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/


#ifndef DESIGN_TIME
typedef void (*vfptr)();
#endif


static	int _UxIfClassId;
int	UxbslFileSelect_readHeader_Id = -1;
char*	UxbslFileSelect_readHeader_Name = "readHeader";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "bslFileSelect.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_bslFileSelect_readHeader( swidget UxThis, Environment * pEnv, char *file, int mem, int *npixel, int *nraster, int *nframes, int *fend, int *dtyp );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_readHeader( swidget UxThis, Environment * pEnv, char *file, int mem, int *npixel, int *nraster, int *nframes, int *fend, int *dtyp )
{
	char buff[128];
	int i = 0, irc = FALSE;
	FILE *fp, *fopen ();
	int np[3], nr[3], nf[3], ne[3], nd[3];
	
	fp = fopen (file, "r");
	if (fgets (buff, 128, fp) != NULL &&
	    fgets (buff, 128, fp) != NULL)
	{
	    do {
	        if ((fgets (buff, 128, fp)) == NULL)
	             break;
	        else if (sscanf (buff, "%8d%8d%8d%8d%8d", &np[i], &nr[i], &nf[i], &ne[i], &nd[i]) != 5)
	             break;
	        else if ((fgets (buff, 128, fp)) == NULL)
	             break;
	    }
	    while (++i < 4);
	    if (i > 0)
	    {
	        *npixel = np[mem-1];
	        *nraster = nr[mem-1];
	        *nframes = nf[mem-1];
	        *fend = ne[mem-1];
	        *dtyp = nd[mem-1];
	    }
	}
	fclose (fp);
	return i;
}

static int	_bslFileSelect_readHeader( swidget UxThis, Environment * pEnv, char *file, int mem, int *npixel, int *nraster, int *nframes, int *fend, int *dtyp )
{
	int			_Uxrtrn;
	_UxCbslFileSelect       *UxSaveCtx = UxBslFileSelectContext;

	UxBslFileSelectContext = (_UxCbslFileSelect *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_readHeader( UxThis, pEnv, file, mem, npixel, nraster, nframes, fend, dtyp );
	UxBslFileSelectContext = UxSaveCtx;

	return ( _Uxrtrn );
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_bslFileSelect()
{
	Widget		_UxParent;


	/* Creation of bslFileSelect */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(bslFileSelect,x,int,595);
#else
	UxPUT_PROPERTY(bslFileSelect,x,int,490);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(bslFileSelect,y,int,121);
#else
	UxPUT_PROPERTY(bslFileSelect,y,int,260);
#endif /* UX_USE_VALUES*/
	UxPUT_PROPERTY(bslFileSelect,width,int,400);
	UxPUT_PROPERTY(bslFileSelect,height,int,400);



	return ( bslFileSelect );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_bslFileSelect( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCbslFileSelect       *UxContext;
	static int		_Uxinit = 0;

	UxBslFileSelectContext = UxContext =
		(_UxCbslFileSelect *) UxNewContext( sizeof(_UxCbslFileSelect), True );

	UxParent = _UxUxParent;
	bslFileSelect = create_obFileSelect( UxParent);
	UxPutContext(bslFileSelect, UxBslFileSelectContext);

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewSubclassId(UxGetClassCode (bslFileSelect));
		UxbslFileSelect_readHeader_Id = UxMethodRegister( _UxIfClassId,
				UxbslFileSelect_readHeader_Name,
				(void (*)()) _bslFileSelect_readHeader );
		_Uxinit = 1;
	}

	UxPutClassCode( bslFileSelect, _UxIfClassId );
	rtrn = _Uxbuild_bslFileSelect();

	XtVaSetValues (rtrn, 
	               RES_CONVERT (XmNdialogTitle, "BSL File Selection"),
	               NULL);
	
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

