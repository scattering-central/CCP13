/***********************************************************************
 *                          bslimage.h                                 *
 ***********************************************************************
 Purpose: Image header file
 Authors: G.R.Mant
 Returns: Nil
 Updates: 27/06/89 Initial implementation

*/

#define DATA_TYPE unsigned char
#define FALSE   0
#define TRUE    !FALSE
#define MAXWIN  4
#define MAXTERM 80
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define SWAP(a, b) (itemp = (a), (a) = (b), (b) = itemp)

extern	Display	*bsl_display;
extern	Window	bsl_window[MAXWIN];
extern	GC	bsl_gc[MAXWIN];	
extern	XImage *xi[MAXWIN];
extern	int	current_win;
extern	int	NColor;

