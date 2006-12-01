! UIMX ascii 2.9 key: 970                                                       

*BubbleAndFootnote.class: overrideShell
*BubbleAndFootnote.classinc:
*BubbleAndFootnote.classspec:
*BubbleAndFootnote.classmembers:
*BubbleAndFootnote.classconstructor:
*BubbleAndFootnote.classdestructor:
*BubbleAndFootnote.gbldecl: #include <stdio.h>\
\
static Boolean created = False;\
static Boolean switchedon = False;\
static int delaytime = 0;\
static XtIntervalId delayid = 0;\
static Boolean FootnoteOn = False;\
static Widget FootnoteHelpWidget = NULL;\
\
static int numberregistered = 0;\
\
typedef struct {\
                 Widget widget;\
                 char   *helpstring;\
               } HelpPair;\
\
static HelpPair *RegisteredPairs = NULL;\
\
static void GoAway( Widget, XtPointer, XEvent *, Boolean * );\
\
#include "BubbleAndFootnotePublic.h"\

*BubbleAndFootnote.ispecdecl:
*BubbleAndFootnote.funcdecl: swidget create_BubbleAndFootnote(swidget UxParent)
*BubbleAndFootnote.funcname: create_BubbleAndFootnote
*BubbleAndFootnote.funcdef: "swidget", "<create_BubbleAndFootnote>(%)"
*BubbleAndFootnote.argdecl: swidget UxParent;
*BubbleAndFootnote.arglist: UxParent
*BubbleAndFootnote.arglist.UxParent: "swidget", "%UxParent%"
*BubbleAndFootnote.icode:
*BubbleAndFootnote.fcode: created = True;\
\
/* under strange combinations of timing and events the window can get stuck */\
/* up, this makes it go away */\
\
XtAddEventHandler( UxGetWidget( rtrn ), LeaveWindowMask, False,\
                   GoAway, (XtPointer)rtrn );\
\
return(rtrn);\

*BubbleAndFootnote.auxdecl: /*****************************************************************************/\
/*                                                                           */\
/* Private Functions                                                         */\
/* =================                                                         */\
/*                                                                           */\
/*****************************************************************************/\
\
/*****************************************************************************/\
/*                                                                           */\
/* ReallyPopItU                                                              */\
/* =============                                                             */\
/*                                                                           */\
/* set as the TimeOut callback if there is a time delay - really pops up the */\
/* popup window                                                              */\
/*                                                                           */\
/*****************************************************************************/\
\
static void ReallyPopItUp( XtPointer clientData, XtIntervalId *id )\
{\
\
/* clientData is the address of delayid, set it to zero  */\
/* so that the popdown function can tell whether a timer */\
/* is still running                                      */\
\
 *( (int *) clientData ) = 0;\
 UxPopupInterface( BubbleAndFootnote, no_grab );\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* PositionBubble                                                            */\
/* ==============                                                            */\
/*                                                                           */\
/*****************************************************************************/\
\
static void PositionBubble( Widget popupfor )\
{\
 Position x, y;\
 Dimension height;\
 Dimension bubbleheight, bubblewidth;\
\
 XtVaGetValues( UxGetWidget(BubbleAndFootnoteLabel), \
                XmNheight, &bubbleheight,\
                XmNwidth,  &bubblewidth,\
                NULL );\
\
 XtVaGetValues( popupfor,\
                XmNheight, &height,\
                NULL );\
\
 XtTranslateCoords( popupfor, 0, 0, &x, &y );\
\
/* if y + height + bubbleheight is off the screen put it above the widget   */\
/* else below */\
\
 if ( ( (int) y + (int) height + (int) bubbleheight ) \
                                      > DisplayHeight( UxDisplay, UxScreen ) )\
       XtVaSetValues( UxGetWidget(BubbleAndFootnote), \
                      XmNy, (int) y - (int) height,\
                      NULL );\
 else\
       XtVaSetValues( UxGetWidget(BubbleAndFootnote), \
                      XmNy, (int) y + (int) height,\
                      NULL );\
\
/* if x + bubblewidth is off the screen move left a bit                     */\
\
 if ( ( (int) x + (int) bubblewidth ) > DisplayWidth( UxDisplay, UxScreen ) )\
       XtVaSetValues( UxGetWidget(BubbleAndFootnote), \
                      XmNx, (int) DisplayWidth( UxDisplay, UxScreen ) - (int) bubblewidth,\
                      NULL );\
 else\
       XtVaSetValues( UxGetWidget(BubbleAndFootnote), \
                      XmNx, (int) x,\
                      NULL );\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* DisplayHelp                                                               */\
/* ===========                                                               */\
/*                                                                           */\
/*                                                                           */\
/* according to options displays the footnote help and/or pops up the popup  */\
/* help or starts the timer                                                  */\
/*                                                                           */\
/*****************************************************************************/\
\
static void DisplayHelp( char *helptext, Widget widget )\
{\
\
  if ( !created )\
       BubbleAndFootnote = create_BubbleAndFootnote( NO_PARENT );\
\
  if ( switchedon == True && helptext != NULL )\
     {\
       XtVaSetValues( UxGetWidget(BubbleAndFootnoteLabel), \
                      XmNlabelString,  XmStringCreateLocalized(helptext),\
                      NULL );\
\
       PositionBubble( widget );\
\
       if ( delaytime == 0 )\
             UxPopupInterface( BubbleAndFootnote, no_grab );\
       else\
             delayid = XtAppAddTimeOut( UxAppContext, \
                                        delaytime,\
                                        ReallyPopItUp,\
                                        (XtPointer) &delayid );\
     }\
\
  if ( FootnoteOn && FootnoteHelpWidget != NULL && helptext != NULL )\
       XtVaSetValues( FootnoteHelpWidget, \
                      XmNlabelString,  XmStringCreateLocalized(helptext),\
                      NULL );\
     \
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* UndisplayHelp                                                             */\
/* =============                                                             */\
/*                                                                           */\
/* removes the popup window and sets the footnote label to its default       */\
/*                                                                           */\
/*****************************************************************************/\
\
void UndisplayHelp()\
{\
/* if delayid is not zero then the delay timer has been set but */\
/* the window has not popped up yet                             */\
\
 if ( delayid != 0 )\
    {\
      XtRemoveTimeOut( delayid );\
      delayid = 0;\
    }\
\
/* have to check whether it exists because it seems that the leave event    */\
/* occurs even if the widget is insensitive                                 */\
\
 if ( created )\
      UxPopdownInterface( BubbleAndFootnote );\
\
 if ( FootnoteHelpWidget != NULL  )\
       XtVaSetValues( FootnoteHelpWidget, \
                      XmNlabelString, \
                      XmStringCreateLocalized("Move the pointer over an item for some help"),\
                      NULL );\
\
}\
\
\
/*****************************************************************************/\
/*                                                                           */\
/* FocusChangeEventHandler                                                   */\
/* =======================                                                   */\
/*                                                                           */\
/* sets or removes the footnote help widget for a particular shell           */\
/*                                                                           */\
/*****************************************************************************/\
\
static void FocusChangeEventHandler( Widget    widget, \
                                     XtPointer cd, \
                                     XEvent    *event, \
                                     Boolean   *ctd )\
{\
 if ( ( ( XAnyEvent * ) event )->type == FocusIn )\
       FootnoteHelpWidget = ( Widget ) cd;\
 else\
       FootnoteHelpWidget = ( Widget ) NULL;\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* HelpEnterEventHandler                                                     */\
/* =====================                                                     */\
/*                                                                           */\
/* set as the callback for enter events on any registered widgets            */\
/*                                                                           */\
/*****************************************************************************/\
\
static void HelpEnterEventHandler( Widget    widget, \
                            XtPointer cd, \
                            XEvent    *event, \
                            Boolean   *ctd )\
{\
 DisplayHelp( (char *) cd, widget );\
}\
\
\
/*****************************************************************************/\
/*                                                                           */\
/* HelpLeaveEventHandler                                                     */\
/* =====================                                                     */\
/*                                                                           */\
/* set as the callback for leave events on registered widgets                */\
/*                                                                           */\
/*****************************************************************************/\
\
\
static void HelpLeaveEventHandler( Widget    widget, \
                                   XtPointer cd, \
                                   XEvent    *event, \
                                   Boolean   *ctd )\
{\
\
/* undisplay help unless the pointer has gone into a child, if the child has */\
/* help of its own the label will change, if not the parent's help will still*/\
/* be displayed                                                              */\
\
 if ( ( ( XLeaveWindowEvent *) event )->detail != NotifyInferior )\
          UndisplayHelp();\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* GoAway                                                                    */\
/* =====================                                                     */\
/*                                                                           */\
/*                                                                           */\
/*****************************************************************************/\
\
\
static void GoAway( Widget    widget, \
                    XtPointer cd, \
                    XEvent    *event, \
                    Boolean   *ctd )\
{\
 UxPopdownInterface( (swidget) cd );\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* FindRegisteredWidget                                                      */\
/* ====================                                                      */\
/*                                                                           */\
/* find a widget in the list of registered widgets and return its number     */\
/*                                                                           */\
/*****************************************************************************/\
\
\
int FindRegisteredWidget( Widget widget )\
{\
 int i;\
\
 for ( i = 0; i < numberregistered; i++ )\
       if ( RegisteredPairs[i].widget == widget )\
            return( i );\
\
 return( -1 );\
\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* FindShellAncestor                                                         */\
/* =================                                                         */\
/*                                                                           */\
/* find the shell ancestor of the swidget in question                        */\
/*                                                                           */\
/*****************************************************************************/\
\
static Widget FindShellAncestor( Widget widget )\
{\
  Widget shellancestor;\
\
  shellancestor =  widget;\
  while ( !XtIsShell( shellancestor ) )\
          shellancestor = XtParent( shellancestor );\
\
  return( shellancestor );\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* Public Functions                                                          */\
/* ================                                                          */\
/*                                                                           */\
/*****************************************************************************/\
\
\
\
/*****************************************************************************/\
/*                                                                           */\
/* InstallWidgetHelp                                                         */\
/* ====================                                                      */\
/*                                                                           */\
/* registers a widget for this sort of help and stores its string in a list  */\
/* so the widget does not need to remember it itself ( the string needs to be*/\
/* remembered so that it is possible to remove the handler when changing the */\
/* string )                                                                  */\
/* the popup help works by setting a pair of event handlers on the widget so */\
/* it should not interfere with the widget's translations                    */\
/*                                                                           */\
/*****************************************************************************/\
\
void InstallWidgetHelp( Widget widget, char *helpstring )\
{\
\
  RegisteredPairs = ( HelpPair *) \
                      XtRealloc( ( void * ) RegisteredPairs,\
                               ( numberregistered+1 ) * sizeof( HelpPair ) );\
  RegisteredPairs[numberregistered].widget = widget;\
  RegisteredPairs[numberregistered].helpstring = XtNewString(helpstring);\
\
  XtAddEventHandler( widget, EnterWindowMask, False,\
                     HelpEnterEventHandler, \
                     RegisteredPairs[numberregistered].helpstring\
                  );\
\
  XtAddEventHandler( widget, LeaveWindowMask, False,\
                     HelpLeaveEventHandler, NULL );\
\
  numberregistered++;\
\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* ChangeWidgetHelp                                                          */\
/* ================                                                          */\
/*                                                                           */\
/* changes the help string registered for a particular widget                */\
/*                                                                           */\
/*****************************************************************************/\
\
void ChangeWidgetHelp( Widget widget, char *newhelp )\
{\
  int theone;\
\
  theone = FindRegisteredWidget( widget );\
\
  if ( theone == -1 )\
     {\
       fprintf( stderr, "Error finding widget help" );\
       return;\
     }\
\
\
  XtRemoveEventHandler( widget, EnterWindowMask, False,\
                        HelpEnterEventHandler, \
                        (XtPointer) RegisteredPairs[theone].helpstring );\
 \
  XtFree( RegisteredPairs[theone].helpstring  );\
\
  RegisteredPairs[theone].helpstring = XtNewString(newhelp);\
\
  XtAddEventHandler( widget, \
                     EnterWindowMask, \
                     False,\
                     HelpEnterEventHandler, \
                     (XtPointer) RegisteredPairs[theone].helpstring  );\
\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* SwitchOnBubbleHelp                                                        */\
/* ==================                                                        */\
/*                                                                           */\
/* switches on the popping up bubble help                                    */\
/*                                                                           */\
/*****************************************************************************/\
\
void SwitchOnBubbleHelp( )\
{\
  switchedon = True;\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* SwitchOffBubbleHelp                                                       */\
/* ===================                                                       */\
/*                                                                           */\
/* switches off the popping up bubble help                                   */\
/*                                                                           */\
/*****************************************************************************/\
\
void SwitchOffBubbleHelp()\
{\
 switchedon = False;\
}\
\
\
/*****************************************************************************/\
/*                                                                           */\
/* SetBubbleHelpDelay                                                        */\
/* ==================                                                        */\
/*                                                                           */\
/* sets the time delay for the popup window popping up delay time in mS      */\
/*                                                                           */\
/*****************************************************************************/\
\
void SetBubbleHelpDelay( int delay )\
{\
 delaytime = delay;\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* SwitchOnFootnoteHelp                                                      */\
/* =================                                                         */\
/*                                                                           */\
/* switch on displaying off footnote type help                               */\
/*                                                                           */\
/*****************************************************************************/\
\
void SwitchOnFootnoteHelp()\
{\
  FootnoteOn = True;\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* SetFootnoteHelpWidget                                                     */\
/* =================                                                         */\
/*                                                                           */\
/* Sets the widget into which the footnote help is displayed. This is done   */\
/* on a shell by shell basis - help is displayed in this widget only whenthe */\
/* the focus is in the window containing this widget.                        */\
/*                                                                           */\
/*****************************************************************************/\
\
void SetFootnoteHelpWidget( Widget help )\
{\
  Widget shellancestor;\
\
/* find the shell ancestor of the swidget in question                        */\
\
  shellancestor =  FindShellAncestor( help );\
\
/* install FocusIn and FocusOut event handlers on the shell to change the   */\
/* help widget                                                              */\
\
  XtAddEventHandler( shellancestor, FocusChangeMask, False,\
                     FocusChangeEventHandler, \
                     ( XtPointer ) help \
                   );\
\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* SwitchOffFootnoteHelp                                                     */\
/* ==================                                                        */\
/*                                                                           */\
/* switch off displaying off footnote type help                              */\
/*                                                                           */\
/*****************************************************************************/\
\
void SwitchOffFootnoteHelp( )\
{\
 FootnoteOn = False;\
}\
\
\
/*****************************************************************************/\
/*                                                                           */\
/* ForceBubbleDisplay                                                        */\
/* ================                                                          */\
/*                                                                           */\
/* forces display of the bubble help for a particular widget ( widgets which */\
/* switch help on and off will need this )                                   */\
/*                                                                           */\
/*****************************************************************************/\
\
void ForceBubbleDisplay( Widget widget )\
{\
 int theone;\
\
 theone = FindRegisteredWidget( widget );\
\
 if ( theone == -1 )\
    {\
      fprintf( stderr, "Error finding widget help" );\
      return;\
    }\
\
  XtVaSetValues( UxGetWidget(BubbleAndFootnoteLabel), \
                 XmNlabelString,  \
                 XmStringCreateLocalized(RegisteredPairs[theone].helpstring),\
                 NULL );\
\
  PositionBubble( widget );\
\
  if ( delaytime == 0 )\
       UxPopupInterface( BubbleAndFootnote, no_grab );\
  else\
       delayid = XtAppAddTimeOut( UxAppContext, \
                                   delaytime,\
                                   ReallyPopItUp,\
                                   (XtPointer) &delayid );\
}\
\
/*****************************************************************************/\
/*                                                                           */\
/* ForceBubbleUndisplay                                                      */\
/* =================                                                         */\
/*                                                                           */\
/* forces undisplay of the help for a particular widget ( widgets which      */\
/* switch help on and off will need this )                                   */\
/*                                                                           */\
/*****************************************************************************/\
\
void ForceBubbleUndisplay( )\
{\
 if ( delayid != 0 )\
      XtRemoveTimeOut( delayid );\
\
 UxPopdownInterface( BubbleAndFootnote );\
}\
\

*BubbleAndFootnote.static: true
*BubbleAndFootnote.name: BubbleAndFootnote
*BubbleAndFootnote.parent: NO_PARENT
*BubbleAndFootnote.parentExpression: UxParent
*BubbleAndFootnote.x: 531
*BubbleAndFootnote.y: 144
*BubbleAndFootnote.allowShellResize: "true"
*BubbleAndFootnote.height: 20

*BubbleAndFootnoteLabel.class: label
*BubbleAndFootnoteLabel.static: true
*BubbleAndFootnoteLabel.name: BubbleAndFootnoteLabel
*BubbleAndFootnoteLabel.parent: BubbleAndFootnote
*BubbleAndFootnoteLabel.unitType: "pixels"
*BubbleAndFootnoteLabel.x: 9
*BubbleAndFootnoteLabel.y: -1
*BubbleAndFootnoteLabel.background: "#ffffa0"
*BubbleAndFootnoteLabel.fontList: "-adobe-helvetica-bold-r-normal--14-100-100-100-p-82-iso8859-1"
*BubbleAndFootnoteLabel.foreground: "black"

