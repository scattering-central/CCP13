
/*******************************************************************************
	otokoFileSelect.c

       Associated Header file: otokoFileSelect.h
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
int	UxotokoFileSelect_readHeader_Id = -1;
char*	UxotokoFileSelect_readHeader_Name = "readHeader";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "otokoFileSelect.h"
#undef CONTEXT_MACRO_ACCESS


/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_otokoFileSelect_readHeader( swidget UxThis, Environment * pEnv, char *file, int mem, int *npixel, int *nraster, int *nframes );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_readHeader( swidget UxThis, Environment * pEnv, char *file, int mem, int *npixel, int *nraster, int *nframes )
{
	char buff[128];
	int i = 0, irc = FALSE;
	FILE *fp, *fopen ();
	int np[3], nf[3];
	
	fp = fopen (file, "r");
	if (fgets (buff, 128, fp) != NULL &&
	    fgets (buff, 128, fp) != NULL)
	{
	    do {
	        if ((fgets (buff, 128, fp)) == NULL)
	             break;
	        else if (sscanf (buff, "%8d%8d", &np[i], &nf[i]) != 2)
	             break;
	        else if ((fgets (buff, 128, fp)) == NULL)
	             break;
	    }
	    while (++i < mem);
	    if (i > 0)
	    {
	        *npixel = np[mem-1];
	        *nraster = 1;
	        *nframes = nf[mem-1];
	    }
	}
	fclose (fp);
	return i;
}

static int	_otokoFileSelect_readHeader( swidget UxThis, Environment * pEnv, char *file, int mem, int *npixel, int *nraster, int *nframes )
{
	int			_Uxrtrn;
	_UxCotokoFileSelect     *UxSaveCtx = UxOtokoFileSelectContext;

	UxOtokoFileSelectContext = (_UxCotokoFileSelect *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_readHeader( UxThis, pEnv, file, mem, npixel, nraster, nframes );
	UxOtokoFileSelectContext = UxSaveCtx;

	return ( _Uxrtrn );
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_otokoFileSelect()
{
	Widget		_UxParent;


	/* Creation of otokoFileSelect */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(otokoFileSelect,x,int,709);
#else
	UxPUT_PROPERTY(otokoFileSelect,x,int,376);
#endif /* UX_USE_VALUES*/
#ifdef UX_USE_VALUES
	UxPUT_PROPERTY(otokoFileSelect,y,int,368);
#else
	UxPUT_PROPERTY(otokoFileSelect,y,int,215);
#endif /* UX_USE_VALUES*/
	UxPUT_PROPERTY(otokoFileSelect,width,int,400);
	UxPUT_PROPERTY(otokoFileSelect,height,int,435);



	return ( otokoFileSelect );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_otokoFileSelect( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCotokoFileSelect     *UxContext;
	static int		_Uxinit = 0;

	UxOtokoFileSelectContext = UxContext =
		(_UxCotokoFileSelect *) UxNewContext( sizeof(_UxCotokoFileSelect), True );

	UxParent = _UxUxParent;
	otokoFileSelect = create_obFileSelect( UxParent);
	UxPutContext(otokoFileSelect, UxOtokoFileSelectContext);

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewSubclassId(UxGetClassCode (otokoFileSelect));
		UxotokoFileSelect_readHeader_Id = UxMethodRegister( _UxIfClassId,
				UxotokoFileSelect_readHeader_Name,
				(void (*)()) _otokoFileSelect_readHeader );
		_Uxinit = 1;
	}

	UxPutClassCode( otokoFileSelect, _UxIfClassId );
	rtrn = _Uxbuild_otokoFileSelect();

	XtVaSetValues (rtrn, 
	               RES_CONVERT (XmNdialogTitle, "Otoko File Selection"),
	               NULL);
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

