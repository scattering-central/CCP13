/***********************************************************************
 *                          palette_module.c                           *
 ***********************************************************************
 Purpose: Palette routines
 Author:  G.Mant
 Returns: Void
 Updates:
 10/08/92 GRM Initial C implementation.
*/

#include <stdio.h>
#include <math.h>
#include "mprintf.h"
#include "palette.h"

/***********************************************************************
 *                           palette_init ()                           *
 ***********************************************************************
 Purpose: Initialise the palette
 Author:  G.Mant
 Returns: CMAP* or NULL pointer
 Updates:
 10/08/92 GRM Initial C implementation.
*/

CMAP *palette_init ()
{
    CMAP *handle = (CMAP *) NULL;
    COLOR *colormap = (COLOR *) NULL;
	int i;
/*
 * Allocate space for handle & private data parameters
 */
    if (((handle = (CMAP *) malloc (sizeof (CMAP))) == (CMAP *) NULL))
    {
		mprintf ("%d Insufficient memory for data acquisition code (PALETTE)", ERROR);
		handle = (CMAP *) NULL;
	}
	else if ((colormap = (COLOR *) calloc (NCOLORS, sizeof (COLOR))) == (COLOR *) NULL)
	{
   	    mprintf ("%d Insufficient memory for data acquisition code (PALETTE)", ERROR);
	    free ((void *) handle);
	    handle = (CMAP *) NULL;
	}
    else
    {
		PRIVATE_DATA (handle) = (void *) colormap;
	    for (i=0; i<NCOLORS; i++)
    	{
        	colormap[i].red   = i;
	        colormap[i].green = i;
    	    colormap[i].blue  = i;
	    }
/*
 * Assign pointers to all valid functions.
 */
		PALETTE_SET_COMPLIMENT(handle,map_compliment);
		PALETTE_SET_GREYSCALE(handle,map_greyscale);
		PALETTE_SET_INVERT(handle,map_invert);
		PALETTE_SET_HOTSPOT(handle,map_hotspot);
		PALETTE_SET_DEFAULT(handle,map_default);
		PALETTE_SET_CLOSE(handle,map_close);
	}
    return (handle);
}

/***********************************************************************
 *                       map_compliment ()                             *
 ***********************************************************************
 Purpose: Compliment the current palette.
 Author:  G.Mant
 Returns: Void
 Updates: 
 02/12/89 GRM Initial C implementation
*/

static long map_compliment (CMAP *handle)
{
    register int i;
    int top = NCOLORS - 1;
	COLOR *colormap = (COLOR *) PRIVATE_DATA (handle);

    for (i=0; i<NCOLORS; i++)
    {
        colormap[i].red   = top - colormap[i].red;
        colormap[i].green = top - colormap[i].green;
        colormap[i].blue  = top - colormap[i].blue;
    }
	return (long) colormap;
}
/***********************************************************************
 *                       map_greyscale ()                              *
 ***********************************************************************
 Purpose: Greyscale colour palette.
 Author:  G.Mant
 Returns: 
 Updates: 
 02/12/89 GRM Initial C implementation
*/

static long map_greyscale (CMAP *handle)
{
    register int i;
	COLOR *colormap = (COLOR *) PRIVATE_DATA (handle);

    for (i=0; i<NCOLORS; i++)
    {
        colormap[i].red   = i;
        colormap[i].green = i;
        colormap[i].blue  = i;
    }
	return (long) colormap;
}

/***********************************************************************
 *                             map_invert ()                           *
 ***********************************************************************
 Purpose: Invert the current palette.
 Author:  G.Mant
 Returns: Void
 Updates: 
 02/12/899 GRM Initial C implementation
*/

static long map_invert (CMAP *handle)
{
    int isave1, isave2, isave3;
    register int i, j;
	COLOR *colormap = (COLOR *) PRIVATE_DATA (handle);

    for (i=0, j=NCOLORS-1; i<(NCOLORS)/2; i++, j--)
    {
        isave1 = colormap[i].red;
        isave2 = colormap[i].green;
        isave3 = colormap[i].blue;
        colormap[i].red   = colormap[j].red;
        colormap[i].green = colormap[j].green;
        colormap[i].blue  = colormap[j].blue;
        colormap[j].red   = isave1;
        colormap[j].green = isave2;
        colormap[j].blue  = isave3;
    }
	return (long) colormap;
}

/***********************************************************************
 *                             map_hotspot ()                          *
 ***********************************************************************
 Purpose: Hotspot colour palette.
 Author:  G.Mant
 Returns: 
 Updates: 
 02/12/89 GRM Initial C implementation
*/

static long map_hotspot (CMAP *handle)
{
	COLOR *colormap = (COLOR *) PRIVATE_DATA (handle);
    register int i;
	int red = 0, green = 0, blue = 128;

    colormap[0].red   = 0;
    colormap[0].green = 0;
    colormap[0].blue  = 0;
    for (i=1; i<32; i++)
    {
        colormap[i].red   = red;
        colormap[i].green = green;
        colormap[i].blue  = blue;
		blue += 2;
    }
    for (i=32; i<64; i++)
    {
        colormap[i].red   = red;
        colormap[i].green = green;
        colormap[i].blue  = blue;
        green += 8;
        blue += 2;
    }
    for (i=64; i<128; i++)
    {
        colormap[i].red   = red;
        colormap[i].green = green;
        colormap[i].blue  = blue;
        red  += 4;
        blue -= 4;
    }
    for (i=128; i<160; i++)
    {
        colormap[i].red   = red;
        colormap[i].green = green;
        colormap[i].blue  = blue;
        green -= 8;
        blue += 4;
    }
    for (i=160; i<192; i++)
    {
        colormap[i].red   = red;
        colormap[i].green = green;
        colormap[i].blue  = blue;
        blue +=4;
    }
    for (i=192; i<224; i++)
    {
        colormap[i].red  = red;
        colormap[i].green = green;
        colormap[i].blue  = blue;
    }
    for (i=224; i<256; i++)
    {
        colormap[i].red   = red;
        colormap[i].green = green;
        colormap[i].blue  = blue;
        green += 8;
    }
    for (i=0; i<256; i++)
    {
		if (colormap[i].red > 0xff) 
	        colormap[i].red = 0xff;
		if (colormap[i].green > 0xff) 
	        colormap[i].green = 0xff;
		if (colormap[i].blue > 0xff) 
    	    colormap[i].blue  = 0xff;
		if (colormap[i].red < 0) 
	        colormap[i].red = 0;
		if (colormap[i].green < 0) 
	        colormap[i].green = 0;
		if (colormap[i].blue < 0) 
    	    colormap[i].blue  = 0;
    }
	return (long) colormap;
}

/***********************************************************************
 *                           map_default ()                            *
 ***********************************************************************
 Purpose:  Default colour palette.
           Assgin default colours to the colour table. Method is using 3
           different sine-wave curves each represents red, green and
           blue. Equations are:-
           red= sin(angle*2) between 0-90 and sin(angle) between 0-90
           green=sin(angle) between 0-180
           blue= cos(angle)between 0-90 and sin(angle*2) between 0-90
           By mixing the amount of intensities according to those 
           curves to obtain maxminum colour effect.
 Author:  G.Mant
 Returns: Void
 Updates: 
 02/12/89 GRM Initial C implementation
*/


static long map_default (CMAP *handle)
{
    double red, green, blue, temp;
    register int i;
	COLOR *colormap = (COLOR *) PRIVATE_DATA (handle);

	if ((handle == (CMAP *) NULL) || (colormap == (COLOR *) NULL))
		return (0);

    colormap[0].red   = 0;
    colormap[0].green = 0;
    colormap[0].blue  = 0;

    for (i=1; i<NCOLORS-1; i++)
    {
        temp = (double) (i - 1);
        green = sin (temp * 0.0123685);
        colormap[i].green = (long) (255.0 * green);
        if (i < 129)
        {
            red =  sin (temp * 0.0123685 * 2.0);
            blue = cos (temp * 0.0123685);
        }
        else
        {
            red =  sin ((temp - 128.0) * 0.0123685);
            blue = sin ((temp - 128.0) * 0.0123685 * 2.0);
        }
        colormap[i].red  = (long) (255.0 * red);
        colormap[i].blue = (long) (255.0 * blue);
    }
    colormap[NCOLORS-1].red   = 0xff;
    colormap[NCOLORS-1].green = 0;
    colormap[NCOLORS-1].blue  = 0;
	return (long) colormap;
}

/***********************************************************************
 *                       map_close ()                                  *
 ***********************************************************************
 Purpose: Close the current palette.
 Author:  G.Mant
 Returns: Void
 Updates: 
 02/12/89 GRM Initial C implementation
*/

static long map_close (CMAP *handle)
{
	COLOR *colormap = (COLOR *) PRIVATE_DATA (handle);

	free ((void *) colormap);
	free ((void *) handle);
	return (long) NULL;
}
