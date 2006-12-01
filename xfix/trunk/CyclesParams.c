
/*******************************************************************************
	CyclesParams.c

       Associated Header file: CyclesParams.h
*******************************************************************************/

#include <stdio.h>

#ifdef MOTIF
#include <Xm/Xm.h>
#include <Xm/MwmUtil.h>
#include <Xm/DialogS.h>
#include <Xm/MenuShell.h>
#endif /* MOTIF */

#include "UxXt.h"
#include <Xm/Separator.h>
#include <Xm/Text.h>
#include <Xm/ScrolledW.h>
#include <Xm/PushB.h>
#include <Xm/TextF.h>
#include <Xm/Label.h>
#include <Xm/BulletinB.h>

/*******************************************************************************
       Includes, Defines, and Global variables from the Declarations Editor:
*******************************************************************************/

#include <string.h>
#include <stdlib.h>

#ifndef DESIGN_TIME
#include "ErrorMessage.h"
#include "FileSelection.h"
#include "headerDialog.h"
#include "mainWS.h"
#endif

extern void command(char *,...);

extern swidget ErrMessage;
extern swidget FileSelect;
extern swidget header;
extern swidget mainWS;


static	int _UxIfClassId;
int	UxCyclesParams_GetParams_Id = -1;
char*	UxCyclesParams_GetParams_Name = "GetParams";
int	UxCyclesParams_setOutFile_Id = -1;
char*	UxCyclesParams_setOutFile_Name = "setOutFile";

/*******************************************************************************
       The following header file defines the context structure.
*******************************************************************************/

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

#define CONTEXT_MACRO_ACCESS 1
#include "CyclesParams.h"
#undef CONTEXT_MACRO_ACCESS

Widget	outfileField4;

/*******************************************************************************
Declarations of methods
*******************************************************************************/

static int	_CyclesParams_GetParams( swidget UxThis, Environment * pEnv, char *error );
static void	_CyclesParams_setOutFile( swidget UxThis, Environment * pEnv, char *sFile );

/*******************************************************************************
       The following are method functions.
*******************************************************************************/

static int	Ux_GetParams( swidget UxThis, Environment * pEnv, char *error )
{
#ifndef DESIGN_TIME
	
	extern char *stripws(char*);
	char *strptr,*sptr,*pptr;
	int i,iflag;
	
	strptr=XmTextFieldGetString(cyclesField);
	sptr=stripws(strptr);
	
	mcycles=atoi(sptr);
	
	if(strlen(sptr)==0)
	{
	  strcpy(error,"Number of cycles not specified");
	  XtFree(strptr);
	  return 0;
	}
	
	iflag=0;
	for(i=0;i<strlen(sptr);i++)
	{
	  if(sptr[i]=='.'&&!iflag)
	  {
	    iflag++;
	  }
	  else if(sptr[i]=='.'&&iflag)
	  {
	    strcpy(error,"Invalid number of cycles");
	    XtFree(strptr);
	    return 0;
	  }
	  else if(!isdigit(sptr[i]))
	  {
	    strcpy(error,"Invalid number of cycles");
	    XtFree(strptr);
	    return 0;
	  }
	}
	
	if(mcycles<=0)
	{
	  strcpy(error,"Invalid number of cycles");
	  XtFree(strptr);
	  return 0;
	}
	
	XtFree(strptr);
	
	/***** Check output BSL filename *****************************************/
	
	strptr=XmTextGetString(outfileField4);
	sptr=stripws(strptr);
	
	if(!mainWS_CheckOutFile(mainWS,&UxEnv,sptr,error,1))
	{
	  XtFree(strptr);
	  return 0;
	}
	
	/***** Convert characters in output filename to uppercase ****************/
	
	if((pptr=strrchr(sptr,(int)'/'))==NULL)
	  pptr=sptr;
	else
	  pptr++;
	
	for(i=0;i<=strlen(pptr);i++)
	{
	  if(islower((int)pptr[i]))
	  pptr[i]=toupper((int)pptr[i]);
	}
	
	sOutFile=(char*)strdup(sptr);
	XmTextSetString(outfileField4,sptr);
	XmTextSetInsertionPosition(outfileField4,strlen(sptr));
	XtFree(strptr);
	
	/*************************************************************************/
	
	return 1;
	
#endif
}

static int	_CyclesParams_GetParams( swidget UxThis, Environment * pEnv, char *error )
{
	int			_Uxrtrn;
	_UxCCyclesParams        *UxSaveCtx = UxCyclesParamsContext;

	UxCyclesParamsContext = (_UxCCyclesParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	_Uxrtrn = Ux_GetParams( UxThis, pEnv, error );
	UxCyclesParamsContext = UxSaveCtx;

	return ( _Uxrtrn );
}

static void	Ux_setOutFile( swidget UxThis, Environment * pEnv, char *sFile )
{
	sOutFile=sFile;
	XmTextSetString(outfileField4,sOutFile);
	XmTextSetInsertionPosition(outfileField4,strlen(sOutFile));
}

static void	_CyclesParams_setOutFile( swidget UxThis, Environment * pEnv, char *sFile )
{
	_UxCCyclesParams        *UxSaveCtx = UxCyclesParamsContext;

	UxCyclesParamsContext = (_UxCCyclesParams *) UxGetContext( UxThis );
	if (pEnv)
		pEnv->_major = NO_EXCEPTION;
	Ux_setOutFile( UxThis, pEnv, sFile );
	UxCyclesParamsContext = UxSaveCtx;
}


/*******************************************************************************
       The following are callback functions.
*******************************************************************************/

static void  activateCB_pushButton1(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCCyclesParams        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxCyclesParamsContext;
	UxCyclesParamsContext = UxContext =
			(_UxCCyclesParams *) UxGetContext( UxWidget );
	{
	char error[80];
	
	if(CyclesParams_GetParams(CyclesParams,&UxEnv,error))
	{
	  mainWS_setBackOutFile(mainWS,&UxEnv,sOutFile);
	  command("y\n");
	  command("%d\n",mcycles);
	  UxPopdownInterface(CyclesParams);
	}
	else
	{
	  ErrorMessage_set(ErrMessage,&UxEnv,error);
	  UxPopupInterface(ErrMessage,no_grab);
	}
	}
	UxCyclesParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton2(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCCyclesParams        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxCyclesParamsContext;
	UxCyclesParamsContext = UxContext =
			(_UxCCyclesParams *) UxGetContext( UxWidget );
	{
	command ("n\n");
	UxPopdownInterface(CyclesParams);
	}
	UxCyclesParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton7(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCCyclesParams        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxCyclesParamsContext;
	UxCyclesParamsContext = UxContext =
			(_UxCCyclesParams *) UxGetContext( UxWidget );
	{
	FileSelection_set(FileSelect,&UxEnv,&outfileField4,"*000.*","Output file selection",0,1,0,0,1);
	UxPopupInterface(FileSelect,no_grab);
	}
	UxCyclesParamsContext = UxSaveCtx;
}

static void  activateCB_pushButton8(
			Widget wgt, 
			XtPointer cd, 
			XtPointer cb)
{
	_UxCCyclesParams        *UxSaveCtx, *UxContext;
	Widget                  UxWidget = wgt;
	XtPointer               UxClientData = cd;
	XtPointer               UxCallbackArg = cb;

	UxSaveCtx = UxCyclesParamsContext;
	UxCyclesParamsContext = UxContext =
			(_UxCCyclesParams *) UxGetContext( UxWidget );
	{
	headerDialog_popup(header,&UxEnv,sOutFile);
	}
	UxCyclesParamsContext = UxSaveCtx;
}

/*******************************************************************************
       The 'build_' function creates all the widgets
       using the resource values specified in the Property Editor.
*******************************************************************************/

static Widget	_Uxbuild_CyclesParams()
{
	Widget		_UxParent;


	/* Creation of CyclesParams */
	_UxParent = UxParent;
	if ( _UxParent == NULL )
	{
		_UxParent = UxTopLevel;
	}

	_UxParent = XtVaCreatePopupShell( "CyclesParams_shell",
			xmDialogShellWidgetClass, _UxParent,
			XmNx, 150,
			XmNy, 450,
			XmNshellUnitType, XmPIXELS,
			XmNtitle, "CyclesParams",
			NULL );

	CyclesParams = XtVaCreateWidget( "CyclesParams",
			xmBulletinBoardWidgetClass,
			_UxParent,
			XmNunitType, XmPIXELS,
			RES_CONVERT( XmNdialogTitle, "Smoothed background" ),
			XmNautoUnmanage, FALSE,
			NULL );
	UxPutContext( CyclesParams, (char *) UxCyclesParamsContext );
	UxPutClassCode( CyclesParams, _UxIfClassId );


	/* Creation of label1 */
	label1 = XtVaCreateManagedWidget( "label1",
			xmLabelWidgetClass,
			CyclesParams,
			XmNx, 9,
			XmNy, 23,
			RES_CONVERT( XmNlabelString, "Number of extra cycles:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label1, (char *) UxCyclesParamsContext );


	/* Creation of cyclesField */
	cyclesField = XtVaCreateManagedWidget( "cyclesField",
			xmTextFieldWidgetClass,
			CyclesParams,
			XmNwidth, 50,
			XmNx, 236,
			XmNy, 18,
			XmNvalue, "1",
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( cyclesField, (char *) UxCyclesParamsContext );


	/* Creation of pushButton1 */
	pushButton1 = XtVaCreateManagedWidget( "pushButton1",
			xmPushButtonWidgetClass,
			CyclesParams,
			XmNx, 10,
			XmNy, 209,
			XmNwidth, 70,
			XmNheight, 35,
			RES_CONVERT( XmNlabelString, "Run" ),
			XmNmarginHeight, 5,
			XmNmarginWidth, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton1, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton1,
		(XtPointer) UxCyclesParamsContext );

	UxPutContext( pushButton1, (char *) UxCyclesParamsContext );


	/* Creation of pushButton2 */
	pushButton2 = XtVaCreateManagedWidget( "pushButton2",
			xmPushButtonWidgetClass,
			CyclesParams,
			XmNx, 294,
			XmNy, 209,
			RES_CONVERT( XmNlabelString, "Cancel" ),
			XmNmarginHeight, 5,
			XmNmarginWidth, 5,
			XmNwidth, 70,
			XmNheight, 35,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton2, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton2,
		(XtPointer) UxCyclesParamsContext );

	UxPutContext( pushButton2, (char *) UxCyclesParamsContext );


	/* Creation of label17 */
	label17 = XtVaCreateManagedWidget( "label17",
			xmLabelWidgetClass,
			CyclesParams,
			XmNx, 10,
			XmNy, 89,
			RES_CONVERT( XmNlabelString, "Output filename:" ),
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( label17, (char *) UxCyclesParamsContext );


	/* Creation of scrolledWindowText3 */
	scrolledWindowText3 = XtVaCreateManagedWidget( "scrolledWindowText3",
			xmScrolledWindowWidgetClass,
			CyclesParams,
			XmNscrollingPolicy, XmAPPLICATION_DEFINED,
			XmNvisualPolicy, XmVARIABLE,
			XmNscrollBarDisplayPolicy, XmSTATIC,
			XmNx, 168,
			XmNy, 85,
			NULL );
	UxPutContext( scrolledWindowText3, (char *) UxCyclesParamsContext );


	/* Creation of outfileField4 */
	outfileField4 = XtVaCreateManagedWidget( "outfileField4",
			xmTextWidgetClass,
			scrolledWindowText3,
			XmNwidth, 110,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	UxPutContext( outfileField4, (char *) UxCyclesParamsContext );


	/* Creation of pushButton7 */
	pushButton7 = XtVaCreateManagedWidget( "pushButton7",
			xmPushButtonWidgetClass,
			CyclesParams,
			XmNx, 296,
			XmNy, 84,
			RES_CONVERT( XmNlabelString, "Browse" ),
			XmNmarginWidth, 5,
			XmNmarginHeight, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton7, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton7,
		(XtPointer) UxCyclesParamsContext );

	UxPutContext( pushButton7, (char *) UxCyclesParamsContext );


	/* Creation of pushButton8 */
	pushButton8 = XtVaCreateManagedWidget( "pushButton8",
			xmPushButtonWidgetClass,
			CyclesParams,
			XmNx, 10,
			XmNy, 138,
			RES_CONVERT( XmNlabelString, "Write headers" ),
			XmNmarginWidth, 5,
			XmNmarginHeight, 5,
			XmNfontList, UxConvertFontList("9x15" ),
			NULL );
	XtAddCallback( pushButton8, XmNactivateCallback,
		(XtCallbackProc) activateCB_pushButton8,
		(XtPointer) UxCyclesParamsContext );

	UxPutContext( pushButton8, (char *) UxCyclesParamsContext );


	/* Creation of separator1 */
	separator1 = XtVaCreateManagedWidget( "separator1",
			xmSeparatorWidgetClass,
			CyclesParams,
			XmNwidth, 365,
			XmNheight, 7,
			XmNx, 10,
			XmNy, 64,
			NULL );
	UxPutContext( separator1, (char *) UxCyclesParamsContext );


	/* Creation of separator2 */
	separator2 = XtVaCreateManagedWidget( "separator2",
			xmSeparatorWidgetClass,
			CyclesParams,
			XmNwidth, 364,
			XmNheight, 7,
			XmNx, 10,
			XmNy, 182,
			NULL );
	UxPutContext( separator2, (char *) UxCyclesParamsContext );


	XtAddCallback( CyclesParams, XmNdestroyCallback,
		(XtCallbackProc) UxDestroyContextCB,
		(XtPointer) UxCyclesParamsContext);


	return ( CyclesParams );
}

/*******************************************************************************
       The following is the 'Interface function' which is the
       external entry point for creating this interface.
       This function should be called from your application or from
       a callback function.
*******************************************************************************/

Widget	create_CyclesParams( swidget _UxUxParent )
{
	Widget                  rtrn;
	_UxCCyclesParams        *UxContext;
	static int		_Uxinit = 0;

	UxCyclesParamsContext = UxContext =
		(_UxCCyclesParams *) UxNewContext( sizeof(_UxCCyclesParams), False );

	UxParent = _UxUxParent;

	if ( ! _Uxinit )
	{
		_UxIfClassId = UxNewInterfaceClassId();
		UxCyclesParams_GetParams_Id = UxMethodRegister( _UxIfClassId,
				UxCyclesParams_GetParams_Name,
				(void (*)()) _CyclesParams_GetParams );
		UxCyclesParams_setOutFile_Id = UxMethodRegister( _UxIfClassId,
				UxCyclesParams_setOutFile_Name,
				(void (*)()) _CyclesParams_setOutFile );
		_Uxinit = 1;
	}

	rtrn = _Uxbuild_CyclesParams();

	sOutFile="";
	return(rtrn);
}

/*******************************************************************************
       END OF FILE
*******************************************************************************/

