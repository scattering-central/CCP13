
/*******************************************************************************
       ErrorMessage.h
       This header file is included by ErrorMessage.cc

*******************************************************************************/

#ifndef	_ERRORMESSAGE_INCLUDED
#define	_ERRORMESSAGE_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

/*******************************************************************************
       For C++, the method macros translate a method call on an interface
       swidget into a member function call on the interface object.
*******************************************************************************/

#ifndef ErrorMessage_set
#define ErrorMessage_set( UxThis, pEnv, message ) \
	(((_UxCErrorMessage *) UxGetContext(UxThis))->set( pEnv, message ))
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

/*******************************************************************************
       The definition of the interface class.
       If you create multiple copies of your interface, the class
       ensures that your callbacks use the variables for the
       correct copy.

       For each swidget in the interface, each argument to the Interface
       function, and each variable in the Interface Specific section of the
       Declarations Editor, there is an entry in the class protected section.
       Additionally, methods generated by the builder are declared as 
       virtual. Wrapper functions are generated for callbacks and actions
       to call the user defined callbacks or actions. A UxDestroyContextCB()
       is also generated to ensure a proper clean up of the class after
       the toplevel is destroyed.
*******************************************************************************/

class _UxCErrorMessage: public _UxCInterface
{

// Generated Class Members

public:

	// Constructor Function
	_UxCErrorMessage( swidget UxParent );

	// Destructor Function
	~_UxCErrorMessage();

	// Interface Function
	Widget	_create_ErrorMessage( void );


	// User Defined Methods
	virtual void set( Environment * pEnv, char *message );

protected:

	// Widgets in the interface
	Widget	ErrorMessage;

	// Interface Specific Variables
	Widget	mlabel;

	// Arg List of creation function
	swidget	UxParent;

	// Callbacks and their wrappers

	// Callback function to destroy the context
	static void  UxDestroyContextCB(Widget, XtPointer, XtPointer);


	// User Defined Methods

private:
	Widget _build();
	CPLUS_ADAPT_CONTEXT(_UxCErrorMessage)

	// User Defined Methods


// User Supplied Class Members

} ;


/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_ErrorMessage( swidget UxParent );

#endif	/* _ERRORMESSAGE_INCLUDED */
