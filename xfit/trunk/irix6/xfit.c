/*-----------------------------------------------------------
 * This is the project main program file for Xt generated 
 * code. You may add application dependent source code 
 * at the appropriate places. 
 * 			     
 * Do not modify the statements preceded by the dollar
 * sign ($), these statements will be replaced with
 * the appropriate source code when the main program is  
 * generated.  
 *
 * $Date$  		$Revision$ 
 *-----------------------------------------------------------*/ 

#ifdef XOPEN_CATALOG
#include <locale.h>
#endif

#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Xlib.h>

#include <Xm/Xm.h>

/*---------------------------------------------------- 
 * UxXt.h needs to be included only when compiling a 
 * stand-alone application. 
 *---------------------------------------------------*/
#ifndef DESIGN_TIME
#include "UxXt.h"
#endif /* DESIGN_TIME */

XtAppContext	UxAppContext;
Widget		UxTopLevel;
Display		*UxDisplay;
int		UxScreen;

#if	defined(SOLARIS_FORM_PATCH)
extern	
#if	defined(__cplusplus)
"C"
#endif
void	UxInstallFormPatch();
#endif

/*----------------------------------------------
 * Insert application global declarations here
 *---------------------------------------------*/
extern int XGint (char *);
extern void message_handler (XtPointer, int *, XtInputId *);
typedef struct {
    char *ccp13Host;
} ccp13_app_res;
 
static XtResource resources[] = {
    {
        "ccp13Host", XtCString, XtRString, sizeof (String),
                     XtOffsetOf (ccp13_app_res, ccp13Host),
                     XmRString, NULL
    }
};
 
ccp13_app_res ccp13_resource;


#ifdef _NO_PROTO
main(argc,argv)
        int     argc;
        char    *argv[];
#else
main( int argc, char *argv[])
#endif /* _NO_PROTO */
{
	/*-----------------------------------------------------------
	 * Declarations.
         * The default identifier - mainIface will only be declared 
	 * if the interface function is global and of type swidget.
	 * To change the identifier to a different name, modify the
	 * string mainIface in the file "xtmain.dat". If "mainIface"
         * is declared, it will be used below where the return value
	 * of  PJ_INTERFACE_FUNCTION_CALL will be assigned to it.
         *----------------------------------------------------------*/ 

  	Widget mainIface;

	/*---------------------------------
	 * Interface function declaration
	 *--------------------------------*/	

 	Widget  create_fitShell(swidget);

	swidget UxParent = NULL;


	/*---------------------
	 * Initialize program
	 *--------------------*/

         int fdin;

#ifdef XOPEN_CATALOG
	setlocale(LC_ALL,"");
	if (XSupportsLocale()) {
		XtSetLanguageProc(NULL,(XtLanguageProc)NULL,NULL);
	}
#endif

  	UxTopLevel = XtAppInitialize(&UxAppContext, "XFit",
				     NULL, 0, &argc, argv, NULL, NULL, 0);

	UxDisplay = XtDisplay(UxTopLevel);
	UxScreen = XDefaultScreen(UxDisplay);

	/* We set the geometry of UxTopLevel so that dialogShells
	   that are parented on it will get centered on the screen
	   (if defaultPosition is true). */

	XtVaSetValues(UxTopLevel,
			XtNx, 0,
			XtNy, 0,
			XtNwidth, DisplayWidth(UxDisplay, UxScreen),
			XtNheight, DisplayHeight(UxDisplay, UxScreen),
			NULL);

#if	defined(SOLARIS_FORM_PATCH)
	UxInstallFormPatch();
#endif
	/*-------------------------------------------------------
	 * Insert initialization code for your application here 
	 *------------------------------------------------------*/

        fdin = XGinit ("lfit");
        XtAppAddInput (UxAppContext, fdin, (XtPointer) XtInputReadMask, 
                       message_handler, NULL);

	/*----------------------------------------------------------------
	 * Create and popup the first window of the interface.  The 	 
	 * return value can be used in the popdown or destroy functions.
         * The Widget return value of  PJ_INTERFACE_FUNCTION_CALL will 
         * be assigned to "mainIface" from  PJ_INTERFACE_RETVAL_TYPE. 
	 *---------------------------------------------------------------*/
 
	mainIface = create_fitShell(UxParent);

	Interface_UxManage(mainIface, &UxEnv);

	/*-----------------------
	 * Enter the event loop 
	 *----------------------*/

  	XtAppMainLoop(UxAppContext);

}
