
/*******************************************************************************
       mainWS.h
       This header file is included by mainWS.cc

*******************************************************************************/

#ifndef	_MAINWS_INCLUDED
#define	_MAINWS_INCLUDED

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"

/*******************************************************************************
       For C++, the method macros translate a method call on an interface
       swidget into a member function call on the interface object.
*******************************************************************************/

#ifndef mainWS_SaveProfile
#define mainWS_SaveProfile( UxThis, pEnv, error ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->SaveProfile( pEnv, error ))
#endif

#ifndef mainWS_UpdateRun
#define mainWS_UpdateRun( UxThis, pEnv ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->UpdateRun( pEnv ))
#endif

#ifndef mainWS_UpdateOutFields
#define mainWS_UpdateOutFields( UxThis, pEnv ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->UpdateOutFields( pEnv ))
#endif

#ifndef mainWS_Convert
#define mainWS_Convert( UxThis, pEnv, error ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->Convert( pEnv, error ))
#endif

#ifndef mainWS_CheckOutFile
#define mainWS_CheckOutFile( UxThis, pEnv, sptr, error, bsl ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->CheckOutFile( pEnv, sptr, error, bsl ))
#endif

#ifndef mainWS_UpdateData
#define mainWS_UpdateData( UxThis, pEnv ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->UpdateData( pEnv ))
#endif

#ifndef mainWS_Help
#define mainWS_Help( UxThis, pEnv ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->Help( pEnv ))
#endif

#ifndef mainWS_FieldsEditable
#define mainWS_FieldsEditable( UxThis, pEnv, i ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->FieldsEditable( pEnv, i ))
#endif
#ifndef mainWS_FieldsEditable_out
#define mainWS_FieldsEditable_out( UxThis, pEnv, i ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->FieldsEditable_out( pEnv, i ))
#endif
#ifndef mainWS_GetProfile
#define mainWS_GetProfile( UxThis, pEnv, error ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->GetProfile( pEnv, error ))
#endif

#ifndef mainWS_UpdateFields
#define mainWS_UpdateFields( UxThis, pEnv ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->UpdateFields( pEnv ))
#endif

#ifndef mainWS_Legalbslname
#define mainWS_Legalbslname( UxThis, pEnv, fptr ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->Legalbslname( pEnv, fptr ))
#endif

#ifndef mainWS_CheckInFile
#define mainWS_CheckInFile( UxThis, pEnv, sptr, error, multiple, bsl ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->CheckInFile( pEnv, sptr, error, multiple, bsl ))
#endif

#ifndef mainWS_RangeSensitive
#define mainWS_RangeSensitive( UxThis, pEnv, i ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->RangeSensitive( pEnv, i ))
#endif

#ifndef mainWS_RunSensitive
#define mainWS_RunSensitive( UxThis, pEnv, i ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->RunSensitive( pEnv, i ))
#endif

#ifndef mainWS_FileSelectionOK
#define mainWS_FileSelectionOK( UxThis, pEnv, fok, sptr, sw, error ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->FileSelectionOK( pEnv, fok, sptr, sw, error ))
#endif

#ifndef mainWS_CheckSize
#define mainWS_CheckSize( UxThis, pEnv, nrec, nrast, nsize ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->CheckSize( pEnv, nrec, nrast, nsize ))
#endif

#ifndef mainWS_GetParams
#define mainWS_GetParams( UxThis, pEnv, error ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->GetParams( pEnv, error ))
#endif

#ifndef mainWS_UpdateRange
#define mainWS_UpdateRange( UxThis, pEnv ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->UpdateRange( pEnv ))
#endif

#ifndef mainWS_LoadProfile
#define mainWS_LoadProfile( UxThis, pEnv, error ) \
	(((_UxCmainWS *) UxGetContext(UxThis))->LoadProfile( pEnv, error ))
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

class _UxCmainWS: public _UxCInterface
{

// Generated Class Members

public:

	// Constructor Function
	_UxCmainWS( swidget UxParent );

	// Destructor Function
	~_UxCmainWS();

	// Interface Function
	Widget	_create_mainWS( void );


	// User Defined Methods
	virtual int SaveProfile( Environment * pEnv, char *error );
	virtual int Convert( Environment * pEnv, char *error );
	virtual int CheckOutFile( Environment * pEnv, char *sptr, char *error, Boolean bsl );
	virtual void Help( Environment * pEnv );
	virtual int GetProfile( Environment * pEnv, char *error );
	virtual Boolean Legalbslname( Environment * pEnv, char *fptr );
	virtual int CheckInFile( Environment * pEnv, char *sptr, char *error, Boolean multiple, Boolean bsl );
	virtual int FileSelectionOK( Environment * pEnv, int fok, char *sptr, swidget *sw, char *error );
	virtual int CheckSize( Environment * pEnv, int nrec, int nrast, int nsize );
	virtual int GetParams( Environment * pEnv, char *error );
	virtual int LoadProfile( Environment * pEnv, char *error );

protected:

	// Widgets in the interface
	Widget	bulletinBoard1;
	Widget	separatorGadget1;
	Widget	label1;
	Widget	label2;
	Widget	label3;
	Widget	pushButton1;
	Widget	label4;
	Widget	firstLabel;
	Widget	lastLabel;
	Widget	incLabel;
	Widget	firstField;
	Widget	textField4;
	Widget	runLabel;
	Widget	scrolledWindowText1;
	Widget	infileText;
	Widget	lastField;
	Widget	label10;
	Widget	optionMenu_p1;
	Widget	optionMenu_p1_float;
	Widget	optionMenu_p1_int;
	Widget	optionMenu_p1_short;
	Widget	optionMenu_p1_char;
	Widget	optionMenu_p1_smar;
	Widget	optionMenu_p1_bmar;
	Widget	optionMenu_p1_fuji;
	Widget	optionMenu_p1_fuji2500;
	Widget	optionMenu_p1_rax2;
	Widget	optionMenu_p1_rax4;
	Widget	optionMenu_p1_psci;
	Widget	optionMenu_p1_riso;
	Widget	optionMenu_p1_tiff;
	Widget	optionMenu_p1_id2;
	Widget	optionMenu_p1_id3;
	Widget	optionMenu_p1_loq_1d;
	Widget	optionMenu_p1_loq_2d;
	Widget	optionMenu_p1_sans;
	Widget	optionMenu_p1_smv;
	Widget	optionMenu_p1_bruker_gfrm;
	Widget	optionMenu_p1_bruker_asc;
	Widget	optionMenu_p1_bruker_plosto;
	Widget	optionMenu_p1_mar345;
	Widget	optionMenu_p1_bsl;
	Widget	optionMenu1;
	Widget	inpixlabel;
	Widget	inrastlabel;
	Widget	inpixField;
	Widget	inrastField;
	Widget	skiplabel;
	Widget	aspectlabel;
	Widget	rangeLabel;
	Widget	toggleButton1;
	Widget	skipField;
	Widget	aspectField;
	Widget	rangeField;
	Widget	separator1;
	Widget	label16;
	Widget	label17;
	Widget	outpixField;
	Widget	outrastField;
	Widget	label18;
	Widget	label19;
	Widget	label20;
	Widget	scrolledWindowText2;
	Widget	header1Text;
	Widget	scrolledWindowText3;
	Widget	header2Text;
	Widget	pushButton2;
	Widget	pushButton3;
	Widget	pushButton4;
	Widget	saveButton;
	Widget	loadButton;
	Widget	incField;
	Widget	scrolledWindowText4;
	Widget	outfileText;
	Widget	pushButton7;
	Widget	label5;
	Widget	datalabel;
	Widget	label6;
	Widget	optionMenu_p2;
	Widget	optionMenu_p1_float32;
	Widget	optionMenu_p1_float64;
	Widget	optionMenu_p1_int16;
	Widget	optionMenu_p1_uint16;
	Widget	optionMenu_p1_int32;
	Widget	optionMenu_p1_uint32;
	Widget	optionMenu_p1_int64;
	Widget	optionMenu_p1_uint64;
	Widget	optionMenu_p1_char8;
	Widget	optionMenu_p1_uchar8;
	Widget	optionMenu2;

	Widget	optionMenu_p1_BSL_out;
	Widget	optionMenu_p1_tiff_8out;
	Widget	optionMenu_p1_tiff_16out;
	Widget	optionMenu_p1_txt_out;
	Widget	optionMenu3;
	Widget	optionMenu_p3;



	// Interface Specific Variables
	char	*infileptr;
	char	*outfileptr;
	char	*dataptr;
	char	*outdataptr;

	char	*inpixptr;
	char	*inrastptr;
	char	*outpixptr;
	char	*outrastptr;
	char	*skptr;
	char	*asptr;
	char	*rangeptr;
	char	*firstptr;
	char	*lastptr;
	char	*incptr;
	char	*h1ptr;
	char	*h2ptr;
	int	SaveInPix;
	int	SaveInRast;
	int	SaveOutPix;
	int	SaveOutRast;
	int	SaveSkip;
	int	SaveAspect;
	int	SaveRange;
	int	dtype;
	char	helpfile[80];
	char	*ccp13ptr;

	// Arg List of creation function
	swidget	UxParent;

	// Callbacks and their wrappers
	virtual void  activateCB_pushButton1(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_pushButton1(Widget, XtPointer, XtPointer);
	virtual void  valueChangedCB_infileText(Widget, XtPointer, XtPointer);
	static void  Wrap_valueChangedCB_infileText(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_float(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_float(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_int(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_int(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_short(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_short(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_char(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_char(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_smar(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_smar(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_bmar(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_bmar(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_fuji(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_fuji(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_fuji2500(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_fuji2500(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_rax2(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_rax4(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_rax4(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_rax2(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_psci(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_psci(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_riso(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_riso(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_tiff(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_tiff(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_id2(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_id2(Widget, XtPointer, XtPointer);

	virtual void  activateCB_optionMenu_p1_id3(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_id3(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_loq_1d(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_loq_1d(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_loq_2d(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_loq_2d(Widget, XtPointer, XtPointer);
virtual void  activateCB_optionMenu_p1_sans(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_sans(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_smv(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_smv(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_bruker_gfrm(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_bruker_gfrm(Widget, XtPointer, XtPointer);
        virtual void  activateCB_optionMenu_p1_bruker_asc(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_bruker_asc(Widget, XtPointer, XtPointer);
        virtual void  activateCB_optionMenu_p1_bruker_plosto(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_bruker_plosto(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_bsl(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_bsl(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_mar345(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_mar345(Widget, XtPointer, XtPointer);
	virtual void  valueChangedCB_inpixField(Widget, XtPointer, XtPointer);
	static void  Wrap_valueChangedCB_inpixField(Widget, XtPointer, XtPointer);
	virtual void  valueChangedCB_inrastField(Widget, XtPointer, XtPointer);
	static void  Wrap_valueChangedCB_inrastField(Widget, XtPointer, XtPointer);
	virtual void  activateCB_pushButton2(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_pushButton2(Widget, XtPointer, XtPointer);
	virtual void  activateCB_pushButton3(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_pushButton3(Widget, XtPointer, XtPointer);
	virtual void  activateCB_pushButton4(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_pushButton4(Widget, XtPointer, XtPointer);
	virtual void  activateCB_saveButton(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_saveButton(Widget, XtPointer, XtPointer);
	virtual void  activateCB_loadButton(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_loadButton(Widget, XtPointer, XtPointer);
	virtual void  activateCB_pushButton7(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_pushButton7(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_float32(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_float32(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_float64(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_float64(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_int16(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_int16(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_uint16(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_uint16(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_int32(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_int32(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_uint32(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_uint32(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_int64(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_int64(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_uint64(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_uint64(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_char8(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_char8(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_uchar8(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_uchar8(Widget, XtPointer, XtPointer);

	virtual void  activateCB_optionMenu_p1_BSL_out(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_BSL_out(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_tiff_8out(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_tiff_8out(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_tiff_16out(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_tiff_16out(Widget, XtPointer, XtPointer);
	virtual void  activateCB_optionMenu_p1_txt_out(Widget, XtPointer, XtPointer);
	static void  Wrap_activateCB_optionMenu_p1_txt_out(Widget, XtPointer, XtPointer);
	// Callback function to destroy the context
	static void  UxDestroyContextCB(Widget, XtPointer, XtPointer);


	// User Defined Methods
	virtual void UpdateRun( Environment * pEnv );
	virtual void UpdateOutFields( Environment * pEnv );
	virtual void UpdateData( Environment * pEnv );
	virtual void FieldsEditable( Environment * pEnv, int i );
	virtual void FieldsEditable_out( Environment * pEnv, int i );
	virtual void UpdateFields( Environment * pEnv );
	virtual void RangeSensitive( Environment * pEnv, int i );
	virtual void RunSensitive( Environment * pEnv, int i );
	virtual void UpdateRange( Environment * pEnv );

private:
	Widget _build();
	CPLUS_ADAPT_CONTEXT(_UxCmainWS)

	// User Defined Methods


// User Supplied Class Members

} ;

extern Widget	mainWS;

/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_mainWS( swidget UxParent );

#endif	/* _MAINWS_INCLUDED */
