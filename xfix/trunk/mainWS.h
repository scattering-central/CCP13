
/*******************************************************************************
       mainWS.h
       This header file is included by mainWS.c

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

#ifndef mainWS_getCentre
#define mainWS_getCentre( UxThis, pEnv, xc, yc ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_getCentre_Id,\
			UxmainWS_getCentre_Name)) \
		( UxThis, pEnv, xc, yc )
#endif

#ifndef mainWS_setRotX
#define mainWS_setRotX( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setRotX_Id,\
			UxmainWS_setRotX_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_setRefineRotX
#define mainWS_setRefineRotX( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setRefineRotX_Id,\
			UxmainWS_setRefineRotX_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_setRotY
#define mainWS_setRotY( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setRotY_Id,\
			UxmainWS_setRotY_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_setRefineRotY
#define mainWS_setRefineRotY( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setRefineRotY_Id,\
			UxmainWS_setRefineRotY_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_setRotZ
#define mainWS_setRotZ( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setRotZ_Id,\
			UxmainWS_setRotZ_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_gotoFrame
#define mainWS_gotoFrame( UxThis, pEnv, frameno ) \
	((int(*)())UxMethodLookup(UxThis, UxmainWS_gotoFrame_Id,\
			UxmainWS_gotoFrame_Name)) \
		( UxThis, pEnv, frameno )
#endif

#ifndef mainWS_setRefineRotZ
#define mainWS_setRefineRotZ( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setRefineRotZ_Id,\
			UxmainWS_setRefineRotZ_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_imageLimits
#define mainWS_imageLimits( UxThis, pEnv, x, y, width, height ) \
	((int(*)())UxMethodLookup(UxThis, UxmainWS_imageLimits_Id,\
			UxmainWS_imageLimits_Name)) \
		( UxThis, pEnv, x, y, width, height )
#endif

#ifndef mainWS_setRefineCentre
#define mainWS_setRefineCentre( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setRefineCentre_Id,\
			UxmainWS_setRefineCentre_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_setDistance
#define mainWS_setDistance( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setDistance_Id,\
			UxmainWS_setDistance_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_setTilt
#define mainWS_setTilt( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setTilt_Id,\
			UxmainWS_setTilt_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_setRefineTilt
#define mainWS_setRefineTilt( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setRefineTilt_Id,\
			UxmainWS_setRefineTilt_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_removeLattice
#define mainWS_removeLattice( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_removeLattice_Id,\
			UxmainWS_removeLattice_Name)) \
		( UxThis, pEnv )
#endif

#ifndef mainWS_CheckOutFile
#define mainWS_CheckOutFile( UxThis, pEnv, sptr, error, bsl ) \
	((int(*)())UxMethodLookup(UxThis, UxmainWS_CheckOutFile_Id,\
			UxmainWS_CheckOutFile_Name)) \
		( UxThis, pEnv, sptr, error, bsl )
#endif

#ifndef mainWS_setWavelength
#define mainWS_setWavelength( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setWavelength_Id,\
			UxmainWS_setWavelength_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_setBackOutFile
#define mainWS_setBackOutFile( UxThis, pEnv, sFile ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setBackOutFile_Id,\
			UxmainWS_setBackOutFile_Name)) \
		( UxThis, pEnv, sFile )
#endif

#ifndef mainWS_SetHeaders
#define mainWS_SetHeaders( UxThis, pEnv, h1, h2 ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_SetHeaders_Id,\
			UxmainWS_SetHeaders_Name)) \
		( UxThis, pEnv, h1, h2 )
#endif

#ifndef mainWS_setCal
#define mainWS_setCal( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setCal_Id,\
			UxmainWS_setCal_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_Legalbslname
#define mainWS_Legalbslname( UxThis, pEnv, fptr ) \
	((int(*)())UxMethodLookup(UxThis, UxmainWS_Legalbslname_Id,\
			UxmainWS_Legalbslname_Name)) \
		( UxThis, pEnv, fptr )
#endif

#ifndef mainWS_help
#define mainWS_help( UxThis, pEnv, string ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_help_Id,\
			UxmainWS_help_Name)) \
		( UxThis, pEnv, string )
#endif

#ifndef mainWS_setCentreX
#define mainWS_setCentreX( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setCentreX_Id,\
			UxmainWS_setCentreX_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_setCentreY
#define mainWS_setCentreY( UxThis, pEnv, value ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setCentreY_Id,\
			UxmainWS_setCentreY_Name)) \
		( UxThis, pEnv, value )
#endif

#ifndef mainWS_CheckInFile
#define mainWS_CheckInFile( UxThis, pEnv, sptr, error, mult, bsl ) \
	((int(*)())UxMethodLookup(UxThis, UxmainWS_CheckInFile_Id,\
			UxmainWS_CheckInFile_Name)) \
		( UxThis, pEnv, sptr, error, mult, bsl )
#endif

#ifndef mainWS_setBackInFile
#define mainWS_setBackInFile( UxThis, pEnv, fnam, frame ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_setBackInFile_Id,\
			UxmainWS_setBackInFile_Name)) \
		( UxThis, pEnv, fnam, frame )
#endif

#ifndef mainWS_continue
#define mainWS_continue( UxThis, pEnv ) \
	((void(*)())UxMethodLookup(UxThis, UxmainWS_continue_Id,\
			UxmainWS_continue_Name)) \
		( UxThis, pEnv )
#endif

#ifndef mainWS_FileSelectionOK
#define mainWS_FileSelectionOK( UxThis, pEnv, sptr, sw ) \
	((int(*)())UxMethodLookup(UxThis, UxmainWS_FileSelectionOK_Id,\
			UxmainWS_FileSelectionOK_Name)) \
		( UxThis, pEnv, sptr, sw )
#endif

#ifndef XKLOADDS
#define XKLOADDS
#endif /* XKLOADDS */

extern int	UxmainWS_getCentre_Id;
extern char*	UxmainWS_getCentre_Name;
extern int	UxmainWS_setRotX_Id;
extern char*	UxmainWS_setRotX_Name;
extern int	UxmainWS_setRefineRotX_Id;
extern char*	UxmainWS_setRefineRotX_Name;
extern int	UxmainWS_setRotY_Id;
extern char*	UxmainWS_setRotY_Name;
extern int	UxmainWS_setRefineRotY_Id;
extern char*	UxmainWS_setRefineRotY_Name;
extern int	UxmainWS_setRotZ_Id;
extern char*	UxmainWS_setRotZ_Name;
extern int	UxmainWS_gotoFrame_Id;
extern char*	UxmainWS_gotoFrame_Name;
extern int	UxmainWS_setRefineRotZ_Id;
extern char*	UxmainWS_setRefineRotZ_Name;
extern int	UxmainWS_imageLimits_Id;
extern char*	UxmainWS_imageLimits_Name;
extern int	UxmainWS_setRefineCentre_Id;
extern char*	UxmainWS_setRefineCentre_Name;
extern int	UxmainWS_setDistance_Id;
extern char*	UxmainWS_setDistance_Name;
extern int	UxmainWS_setTilt_Id;
extern char*	UxmainWS_setTilt_Name;
extern int	UxmainWS_setRefineTilt_Id;
extern char*	UxmainWS_setRefineTilt_Name;
extern int	UxmainWS_removeLattice_Id;
extern char*	UxmainWS_removeLattice_Name;
extern int	UxmainWS_CheckOutFile_Id;
extern char*	UxmainWS_CheckOutFile_Name;
extern int	UxmainWS_setWavelength_Id;
extern char*	UxmainWS_setWavelength_Name;
extern int	UxmainWS_setBackOutFile_Id;
extern char*	UxmainWS_setBackOutFile_Name;
extern int	UxmainWS_SetHeaders_Id;
extern char*	UxmainWS_SetHeaders_Name;
extern int	UxmainWS_setCal_Id;
extern char*	UxmainWS_setCal_Name;
extern int	UxmainWS_Legalbslname_Id;
extern char*	UxmainWS_Legalbslname_Name;
extern int	UxmainWS_help_Id;
extern char*	UxmainWS_help_Name;
extern int	UxmainWS_setCentreX_Id;
extern char*	UxmainWS_setCentreX_Name;
extern int	UxmainWS_setCentreY_Id;
extern char*	UxmainWS_setCentreY_Name;
extern int	UxmainWS_CheckInFile_Id;
extern char*	UxmainWS_CheckInFile_Name;
extern int	UxmainWS_setBackInFile_Id;
extern char*	UxmainWS_setBackInFile_Name;
extern int	UxmainWS_continue_Id;
extern char*	UxmainWS_continue_Name;
extern int	UxmainWS_FileSelectionOK_Id;
extern char*	UxmainWS_FileSelectionOK_Name;

/*******************************************************************************
       The definition of the context structure:
       If you create multiple copies of your interface, the context
       structure ensures that your callbacks use the variables for the
       correct copy.

       For each swidget in the interface, each argument to the Interface
       function, and each variable in the Interface Specific section of the
       Declarations Editor, there is an entry in the context structure
       and a #define.  The #define makes the variable name refer to the
       corresponding entry in the context structure.
*******************************************************************************/

typedef	struct
{
	Widget	UxmainWindow;
	Widget	UxpullDownMenu;
	Widget	UxfilePane;
	Widget	UxnewButton;
	Widget	UxopenButton;
	Widget	UxframeButton;
	Widget	UxgotoButton;
	Widget	UxfilePane_b7;
	Widget	UxsaveAsButton;
	Widget	UxfilePane_b9;
	Widget	UxexitButton;
	Widget	UxfileCascade;
	Widget	UxeditPane;
	Widget	UxparameterButton;
	Widget	UxobjectButton;
	Widget	UxlineButton;
	Widget	UxscanButton;
	Widget	UxcellButton;
	Widget	UxeditCascade;
	Widget	UxfindPane;
	Widget	UxcentreButton;
	Widget	UxrotationButton;
	Widget	UxtiltButton;
	Widget	UxviewCascade;
	Widget	UxprocessPane;
	Widget	UxlistButton;
	Widget	UxplotLineButton;
	Widget	UxplotScanButton;
	Widget	UxrefineButton;
	Widget	UxbackgroundPane;
	Widget	UxwindowButton;
	Widget	UxcsymButton;
	Widget	UxsmoothButton;
	Widget	UxbackgroundPane1;
	Widget	UxpullDownMenu_top_b1;
	Widget	UxoptionsPane;
	Widget	UxpalettePane;
	Widget	Uxcolour0Toggle;
	Widget	Uxcolour1Toggle;
	Widget	Uxcolour2Toggle;
	Widget	Uxcolour3Toggle;
	Widget	Uxcolour4Toggle;
	Widget	Uxcolour5Toggle;
	Widget	UxpaletteCascade;
	Widget	UxmagPane;
	Widget	Uxx2Toggle;
	Widget	Uxx4Toggle;
	Widget	Uxx8Toggle;
	Widget	Uxx16Toggle;
	Widget	Uxx32Toggle;
	Widget	UxmagCascade;
	Widget	UxlineColourPane;
	Widget	UxlineGreenToggle;
	Widget	UxlineRedToggle;
	Widget	UxlineBlueToggle;
	Widget	UxlineYellowToggle;
	Widget	UxlineWhiteToggle;
	Widget	UxlineBlackToggle;
	Widget	UxlineColourCascade;
	Widget	UxpointColourPane;
	Widget	UxgreenToggle;
	Widget	UxredToggle;
	Widget	UxblueToggle;
	Widget	UxyellowToggle;
	Widget	UxwhiteToggle;
	Widget	UxblackToggle;
	Widget	UxpointColourCascade;
	Widget	UxoptionsPane_b8;
	Widget	UxlogButton;
	Widget	UxinterpolateButton;
	Widget	UxlineFitButton;
	Widget	UxshowPointsButton;
	Widget	UxoptionsPane_b10;
	Widget	UxazimuthalButton;
	Widget	UxradialButton;
	Widget	UxoptionsPane_b12;
	Widget	UxlatticePointButton;
	Widget	UxlatticeCircleButton;
	Widget	UxoptionsCascade;
	Widget	UxhelpPane;
	Widget	UxintroButton;
	Widget	UxhelpPane_b10;
	Widget	UxonFileButton;
	Widget	UxonEditButton;
	Widget	UxonEstimateButton;
	Widget	UxonProcessButton;
	Widget	UxonOptionsButton;
	Widget	UxonToolsButton;
	Widget	UxhelpCascade;
	Widget	UxpanedWindow1;
	Widget	Uxform1;
	Widget	Uxlabel1;
	Widget	Uxlabel2;
	Widget	Uxlabel3;
	Widget	Uxframe1;
	Widget	UxdrawingArea2;
	Widget	Uxlabel4;
	Widget	UxrowColumn1;
	Widget	UxtogglePoint;
	Widget	UxtoggleLine;
	Widget	UxtoggleThick;
	Widget	UxtoggleRect;
	Widget	UxtogglePoly;
	Widget	UxtoggleSector;
	Widget	UxtoggleScan;
	Widget	UxtoggleZoom;
	Widget	Uxlabel5;
	Widget	UxtextHigh;
	Widget	UxtextLow;
	Widget	Uxlabel6;
	Widget	Uxlabel7;
	Widget	UxtextX;
	Widget	UxtextY;
	Widget	UxtextValue;
	Widget	UxarrowButton1;
	Widget	UximageText;
	Widget	UxarrowButton2;
	Widget	UxfileText;
	Widget	UxframeText;
	Widget	UxscrolledWindow1;
	Widget	UxdrawingArea1;
	Widget	UxinvertButton;
	Widget	UxrefreshButton;
	Widget	UxscrolledWindowText1;
	Widget	UxscrolledText1;
	Boolean	UxfitLines;
	Boolean	Uxrepeat;
	Boolean	UxradialScan;
	Boolean	UxinvertedPalette;
	Boolean	UxplotLatticePoints;
	Boolean	UxgotcentreX;
	Boolean	UxgotcentreY;
	double	Uxwavelength;
	double	Uxdistance;
	double	UxcentreX;
	double	UxcentreY;
	double	UxrotX;
	double	UxrotY;
	double	UxrotZ;
	double	Uxtilt;
	double	Uxdcal;
	Boolean	UxrefineCentre;
	Boolean	UxrefineRotX;
	Boolean	UxrefineRotY;
	Boolean	UxrefineRotZ;
	Boolean	UxrefineTilt;
	char	*UxcurrentDir;
	char	*UxfileName;
	char	*Uxyfile;
	char	*Uxhelpfile;
	char	*Uxccp13ptr;
	char	*Uxoutfile;
	char	*Uxheader1;
	char	*Uxheader2;
	int	Uxfile_input;
	int	Uxfile_ready;
	int	Uxmode;
	int	UxfirstRun;
	int	UxinputPause;
	int	UxpsCounter;
	Widget	UxlastToggle;
	char	*UxsBackOutFile;
	char	*UxsBackInFile;
	int	Uxbinfram;
	swidget	Uxparent;
} _UxCmainWS;

#ifdef CONTEXT_MACRO_ACCESS
static _UxCmainWS              *UxMainWSContext;
#define mainWindow              UxMainWSContext->UxmainWindow
#define pullDownMenu            UxMainWSContext->UxpullDownMenu
#define filePane                UxMainWSContext->UxfilePane
#define newButton               UxMainWSContext->UxnewButton
#define openButton              UxMainWSContext->UxopenButton
#define frameButton             UxMainWSContext->UxframeButton
#define gotoButton              UxMainWSContext->UxgotoButton
#define filePane_b7             UxMainWSContext->UxfilePane_b7
#define saveAsButton            UxMainWSContext->UxsaveAsButton
#define filePane_b9             UxMainWSContext->UxfilePane_b9
#define exitButton              UxMainWSContext->UxexitButton
#define fileCascade             UxMainWSContext->UxfileCascade
#define editPane                UxMainWSContext->UxeditPane
#define parameterButton         UxMainWSContext->UxparameterButton
#define objectButton            UxMainWSContext->UxobjectButton
#define lineButton              UxMainWSContext->UxlineButton
#define scanButton              UxMainWSContext->UxscanButton
#define cellButton              UxMainWSContext->UxcellButton
#define editCascade             UxMainWSContext->UxeditCascade
#define findPane                UxMainWSContext->UxfindPane
#define centreButton            UxMainWSContext->UxcentreButton
#define rotationButton          UxMainWSContext->UxrotationButton
#define tiltButton              UxMainWSContext->UxtiltButton
#define viewCascade             UxMainWSContext->UxviewCascade
#define processPane             UxMainWSContext->UxprocessPane
#define listButton              UxMainWSContext->UxlistButton
#define plotLineButton          UxMainWSContext->UxplotLineButton
#define plotScanButton          UxMainWSContext->UxplotScanButton
#define refineButton            UxMainWSContext->UxrefineButton
#define backgroundPane          UxMainWSContext->UxbackgroundPane
#define windowButton            UxMainWSContext->UxwindowButton
#define csymButton              UxMainWSContext->UxcsymButton
#define smoothButton            UxMainWSContext->UxsmoothButton
#define backgroundPane1         UxMainWSContext->UxbackgroundPane1
#define pullDownMenu_top_b1     UxMainWSContext->UxpullDownMenu_top_b1
#define optionsPane             UxMainWSContext->UxoptionsPane
#define palettePane             UxMainWSContext->UxpalettePane
#define colour0Toggle           UxMainWSContext->Uxcolour0Toggle
#define colour1Toggle           UxMainWSContext->Uxcolour1Toggle
#define colour2Toggle           UxMainWSContext->Uxcolour2Toggle
#define colour3Toggle           UxMainWSContext->Uxcolour3Toggle
#define colour4Toggle           UxMainWSContext->Uxcolour4Toggle
#define colour5Toggle           UxMainWSContext->Uxcolour5Toggle
#define paletteCascade          UxMainWSContext->UxpaletteCascade
#define magPane                 UxMainWSContext->UxmagPane
#define x2Toggle                UxMainWSContext->Uxx2Toggle
#define x4Toggle                UxMainWSContext->Uxx4Toggle
#define x8Toggle                UxMainWSContext->Uxx8Toggle
#define x16Toggle               UxMainWSContext->Uxx16Toggle
#define x32Toggle               UxMainWSContext->Uxx32Toggle
#define magCascade              UxMainWSContext->UxmagCascade
#define lineColourPane          UxMainWSContext->UxlineColourPane
#define lineGreenToggle         UxMainWSContext->UxlineGreenToggle
#define lineRedToggle           UxMainWSContext->UxlineRedToggle
#define lineBlueToggle          UxMainWSContext->UxlineBlueToggle
#define lineYellowToggle        UxMainWSContext->UxlineYellowToggle
#define lineWhiteToggle         UxMainWSContext->UxlineWhiteToggle
#define lineBlackToggle         UxMainWSContext->UxlineBlackToggle
#define lineColourCascade       UxMainWSContext->UxlineColourCascade
#define pointColourPane         UxMainWSContext->UxpointColourPane
#define greenToggle             UxMainWSContext->UxgreenToggle
#define redToggle               UxMainWSContext->UxredToggle
#define blueToggle              UxMainWSContext->UxblueToggle
#define yellowToggle            UxMainWSContext->UxyellowToggle
#define whiteToggle             UxMainWSContext->UxwhiteToggle
#define blackToggle             UxMainWSContext->UxblackToggle
#define pointColourCascade      UxMainWSContext->UxpointColourCascade
#define optionsPane_b8          UxMainWSContext->UxoptionsPane_b8
#define logButton               UxMainWSContext->UxlogButton
#define interpolateButton       UxMainWSContext->UxinterpolateButton
#define lineFitButton           UxMainWSContext->UxlineFitButton
#define showPointsButton        UxMainWSContext->UxshowPointsButton
#define optionsPane_b10         UxMainWSContext->UxoptionsPane_b10
#define azimuthalButton         UxMainWSContext->UxazimuthalButton
#define radialButton            UxMainWSContext->UxradialButton
#define optionsPane_b12         UxMainWSContext->UxoptionsPane_b12
#define latticePointButton      UxMainWSContext->UxlatticePointButton
#define latticeCircleButton     UxMainWSContext->UxlatticeCircleButton
#define optionsCascade          UxMainWSContext->UxoptionsCascade
#define helpPane                UxMainWSContext->UxhelpPane
#define introButton             UxMainWSContext->UxintroButton
#define helpPane_b10            UxMainWSContext->UxhelpPane_b10
#define onFileButton            UxMainWSContext->UxonFileButton
#define onEditButton            UxMainWSContext->UxonEditButton
#define onEstimateButton        UxMainWSContext->UxonEstimateButton
#define onProcessButton         UxMainWSContext->UxonProcessButton
#define onOptionsButton         UxMainWSContext->UxonOptionsButton
#define onToolsButton           UxMainWSContext->UxonToolsButton
#define helpCascade             UxMainWSContext->UxhelpCascade
#define panedWindow1            UxMainWSContext->UxpanedWindow1
#define form1                   UxMainWSContext->Uxform1
#define label1                  UxMainWSContext->Uxlabel1
#define label2                  UxMainWSContext->Uxlabel2
#define label3                  UxMainWSContext->Uxlabel3
#define frame1                  UxMainWSContext->Uxframe1
#define drawingArea2            UxMainWSContext->UxdrawingArea2
#define label4                  UxMainWSContext->Uxlabel4
#define rowColumn1              UxMainWSContext->UxrowColumn1
#define togglePoint             UxMainWSContext->UxtogglePoint
#define toggleLine              UxMainWSContext->UxtoggleLine
#define toggleThick             UxMainWSContext->UxtoggleThick
#define toggleRect              UxMainWSContext->UxtoggleRect
#define togglePoly              UxMainWSContext->UxtogglePoly
#define toggleSector            UxMainWSContext->UxtoggleSector
#define toggleScan              UxMainWSContext->UxtoggleScan
#define toggleZoom              UxMainWSContext->UxtoggleZoom
#define label5                  UxMainWSContext->Uxlabel5
#define textHigh                UxMainWSContext->UxtextHigh
#define textLow                 UxMainWSContext->UxtextLow
#define label6                  UxMainWSContext->Uxlabel6
#define label7                  UxMainWSContext->Uxlabel7
#define textX                   UxMainWSContext->UxtextX
#define textY                   UxMainWSContext->UxtextY
#define textValue               UxMainWSContext->UxtextValue
#define arrowButton1            UxMainWSContext->UxarrowButton1
#define imageText               UxMainWSContext->UximageText
#define arrowButton2            UxMainWSContext->UxarrowButton2
#define fileText                UxMainWSContext->UxfileText
#define frameText               UxMainWSContext->UxframeText
#define scrolledWindow1         UxMainWSContext->UxscrolledWindow1
#define drawingArea1            UxMainWSContext->UxdrawingArea1
#define invertButton            UxMainWSContext->UxinvertButton
#define refreshButton           UxMainWSContext->UxrefreshButton
#define scrolledWindowText1     UxMainWSContext->UxscrolledWindowText1
#define scrolledText1           UxMainWSContext->UxscrolledText1
#define fitLines                UxMainWSContext->UxfitLines
#define repeat                  UxMainWSContext->Uxrepeat
#define radialScan              UxMainWSContext->UxradialScan
#define invertedPalette         UxMainWSContext->UxinvertedPalette
#define plotLatticePoints       UxMainWSContext->UxplotLatticePoints
#define gotcentreX              UxMainWSContext->UxgotcentreX
#define gotcentreY              UxMainWSContext->UxgotcentreY
#define wavelength              UxMainWSContext->Uxwavelength
#define distance                UxMainWSContext->Uxdistance
#define centreX                 UxMainWSContext->UxcentreX
#define centreY                 UxMainWSContext->UxcentreY
#define rotX                    UxMainWSContext->UxrotX
#define rotY                    UxMainWSContext->UxrotY
#define rotZ                    UxMainWSContext->UxrotZ
#define tilt                    UxMainWSContext->Uxtilt
#define dcal                    UxMainWSContext->Uxdcal
#define refineCentre            UxMainWSContext->UxrefineCentre
#define refineRotX              UxMainWSContext->UxrefineRotX
#define refineRotY              UxMainWSContext->UxrefineRotY
#define refineRotZ              UxMainWSContext->UxrefineRotZ
#define refineTilt              UxMainWSContext->UxrefineTilt
#define currentDir              UxMainWSContext->UxcurrentDir
#define fileName                UxMainWSContext->UxfileName
#define yfile                   UxMainWSContext->Uxyfile
#define helpfile                UxMainWSContext->Uxhelpfile
#define ccp13ptr                UxMainWSContext->Uxccp13ptr
#define outfile                 UxMainWSContext->Uxoutfile
#define header1                 UxMainWSContext->Uxheader1
#define header2                 UxMainWSContext->Uxheader2
#define file_input              UxMainWSContext->Uxfile_input
#define file_ready              UxMainWSContext->Uxfile_ready
#define mode                    UxMainWSContext->Uxmode
#define firstRun                UxMainWSContext->UxfirstRun
#define inputPause              UxMainWSContext->UxinputPause
#define psCounter               UxMainWSContext->UxpsCounter
#define lastToggle              UxMainWSContext->UxlastToggle
#define sBackOutFile            UxMainWSContext->UxsBackOutFile
#define sBackInFile             UxMainWSContext->UxsBackInFile
#define binfram                 UxMainWSContext->Uxbinfram
#define parent                  UxMainWSContext->Uxparent

#endif /* CONTEXT_MACRO_ACCESS */

extern Widget	mainWS;

/*******************************************************************************
       Declarations of global functions.
*******************************************************************************/

Widget	create_mainWS( swidget _Uxparent );

#endif	/* _MAINWS_INCLUDED */
