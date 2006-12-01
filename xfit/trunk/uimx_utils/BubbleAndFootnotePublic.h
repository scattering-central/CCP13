/*
 * bubble.h
 *
 * this file contains definitions for the functions which other interfaces
 * need to know in order to  use the BubbleAndFootnote help system
 * to use the bubble system:
 *
 *            call InstallWidgetHelp for each widget which is to have help
 *            call SetBubbleHelpDelay to taste
 *            call SwitchOnBubbleHelp
 *
 * to use the footnote system:
 *
 *            create a widget in which to display the help
 *            call SetFootnoteHelpWidget
 *            call InstallWidgetHelp for each widget which is to have help
 *            call SwitchOnFootnoteHelp
 */

#ifndef BUBBLE_H
#define BUBBLE_H

/*
 * InstallWidgetHelp sets the help string to be used for a particular widget,
 * ChangeWidgetHelp changes it. The BubbleAndFootnote help interface makes its
 * own copies of the strings used.
 */

void InstallWidgetHelp (Widget, char *);
void ChangeWidgetHelp  (Widget, char *);

/*
 * SwitchOnBubbleHelp and SwitchOffBubbleHelp switch on and off the popping up
 * of the bubble help for all widgets throughout the project.
 */

void SwitchOnBubbleHelp ();
void SwitchOffBubbleHelp ();

/*
 * SetBubbleHelpDelay sets the delay time ( in mS between entering a widget 
 * and the help popping up.
 */

void SetBubbleHelpDelay (int);

/*
 * SetFootnoteHelpWidget sets the widget into which footnote help is displayed.
 * Each interface in the project which is to use footnote help should call this
 * function.
 */

void SetFootnoteHelpWidget (Widget);

/*
 * SwitchOnFootnoteHelp and SwitchOffFootnoteHelp switch on and off the
 * displaying of footnote help throughout the project
 */

void ForceBubbleDisplay (Widget);
void ForceBubbleUndisplay ();

#endif

