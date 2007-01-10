#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <math.h>
#include <ctype.h>
#include <string.h>
#include "pck.h"
#include "xerror.h"
//function to read size of the image
int getimagesize(FILE *fp)
{
int		head[10], nx;
  /* Read header */
        if (fread(head,sizeof(int), 10, fp) != 10 ) {
	           THROW_ERR("ERROR> Cannot read header of \n");
	}

	/*
	 * The first number must be 1200, 2000 (old 300 mm mar)
	 * or 1234 (new 345 mm mar)
	 */

        if ((head[0] > 5000) && (head[0] < 100)) {
           swaplong(head, 10);
	/* Was byte swapping successful */
		if ((head[0] > 5000) || (head[0] < 100)) {
		     	THROW_ERR("ERROR> Cannot byteswap header of \n");
			}
        }
	/* 345mm scanner */
	if (head[0] == 1234 ) {
		nx 	= head[1];

	}
	/* 300mm scanner */
	else {
		nx	= head[0];

	}
 return nx;
}
WORD *
openpckfile(FILE *fp)
{
unsigned short	i16, *i2;
int		i32,n,j,row,col,i=0;
int		head[10], nx, n32, ihigh,high[2];
long 		total;
short		is;
char		byteswap, mar345;
WORD  		*img;
	/* Read header */
	fseek( fp, 0, SEEK_SET );
        if (fread(head,sizeof(int), 10, fp) != 10 ) {
	           THROW_ERR("ERROR> Cannot read header of \n");
	}

	/*
	 * The first number must be 1200, 2000 (old 300 mm mar)
	 * or 1234 (new 345 mm mar)
	 */

        if ((head[0] < 5000) && (head[0] > 100)) {
                byteswap = 0;
        }
        else {

                byteswap = 1;
                swaplong(head, 10);

		/* Was byte swapping successful */
		if ((head[0] > 5000) || (head[0] < 100)) {
		     	THROW_ERR("ERROR> Cannot byteswap header of \n");
			}
        }

	/* 345mm scanner */
	if (head[0] == 1234 ) {
		nx 	= head[1];
		n32    	= head[2];
		mar345  = 1;
	}

	/* 300mm scanner */
	else {
		nx	= head[0];
		n32   	= head[4];
		mar345  = 0;
	}

	/* Get packed 16 bit array with nx*nx elements */
	img= (WORD*)malloc((nx*nx)*sizeof(WORD));
	get_pck( fp, img );

	/*
	 * 345mm scanners: to get the image into the same orientation
	 * as the 300 mm scanners, rotate image by +90 deg.
	 */

	if ( mar345 ) {
		rotate_clock90( img, nx );
	}

	total = nx*nx;

	i2 = (unsigned short *) img;
	for ( i=0; i<total; i++, i2++ )
		if ( *i2 > 32767 )
			*i2 = -(*i2 + 4)/8;


	/* Any pixels with intensities > 16 bit (65535) */
	if ( n32 != 0 )
	  {
       /* Yes, there are, so we need to read overflow record */
	if ( mar345 )
		fseek( fp, 4096, SEEK_SET );
	else
		fseek( fp, 2*nx, SEEK_SET );

	/* Read high intensity pixel pairs (address + 32bit-value) */

	for ( i=0; i<n32; i++ ) {
		if ( ( n=fread(high, sizeof(int), 2, fp) )!= 2 ) {
			THROW_ERR("ERROR> Cannot read pixel ");
		}
		if (byteswap) swaplong(high, 2);

		if ( mar345 ) {

			j   = high[0];
			row = high[0]/nx;
			col = high[0]%nx;
			j = col*nx + nx - row - 1;
		}
		else {
			row = high[0]/nx;
			col = high[0]%nx;
			j = row*nx + col - 1;
		}

		/*
		 * Check that the corresponding address in the 16bit
		 * array really is at the upper limit
                 * DOES NOT CHECK !! AGWL
		 */
		//printf("%d : %d ",high[0],high[1]);
		i16 =(unsigned short)*(img+j) ;
                ihigh = high[1];
                ihigh = min(ihigh, 262128);
		i32 = -(ihigh + 4)/8;
		*(img+j) = (unsigned short)i32;
	}
	  }
	  return (img);
}

/***************************************************************************
 * Function: get_pck
 ***************************************************************************/
static void
get_pck(FILE *fp, WORD *img)
{
int 	x = 0, y = 0, i = 0, c = 0;
char 	header[BUFSIZ];

  	if (fp == NULL) return;

	rewind( fp );
	header[0] = '\n';
	header[1] = 0;

	/*
	 * Scan file until PCK header is found
	 */
	while ((c != EOF) && ((x == 0) || (y == 0))) {
		c = i = x = y = 0;
		while ((++i < BUFSIZ) && (c != EOF) && (c != '\n') && (x==0) && (y==0))
			if ((header[i] = c = getc(fp)) == '\n')
				sscanf(header, PACKIDENTIFIER, &x, &y);
	}

	unpack_wordmar(fp, x, y, img);
}


/*****************************************************************************
 * Function: unpack_word
 * Unpacks a packed image into the WORD-array 'img'.
 *****************************************************************************/
static void
unpack_wordmar(FILE *packfile, int x, int y, WORD *img)
{
int 		valids = 0, spillbits = 0, usedbits;
LONG 		window = 0L, spill, pixel = 0, nextint, bitnum, pixnum ,total = x * y  ;
static int 	bitdecode[8] = {0, 4, 5, 6, 7, 8, 16, 32};

	while (pixel < total) {
	    if (valids < 6) {
	      if (spillbits > 0) {
      			window |= shift_left(spill, valids);
        		valids += spillbits;
        		spillbits = 0;
		}
      	    	else {
      			spill = (LONG) getc(packfile);
        		spillbits = 8;
		}
	    }
    	    else {
    		pixnum = 1 << (window & setbits[3]);
      		window = shift_right(window, 3);
      		bitnum = bitdecode[window & setbits[3]];
      		window = shift_right(window, 3);
      		valids -= 6;
      		while ((pixnum > 0) && (pixel < total)) {
      		    if (valids < bitnum) {
        		if (spillbits > 0) {
          		    window |= shift_left(spill, valids);
            		    if ((32 - valids) > spillbits) {
            			valids += spillbits;
              			spillbits = 0;
			    }
            		    else {
            			usedbits = 32 - valids;
			        spill = shift_right(spill, usedbits);
			        spillbits -= usedbits;
			        valids = 32;
			    }
			}
          		else {
          		    spill = (LONG) getc(packfile);
            		    spillbits = 8;
			}
		    }
        	    else {
        		--pixnum;
		  	if (bitnum == 0)
            		    nextint = 0;
          		else {
          		    nextint = window & setbits[bitnum];
            		    valids -= bitnum;
            		    window = shift_right(window, bitnum);
		            if ((nextint & (1 << (bitnum - 1))) != 0)
		              	nextint |= ~setbits[bitnum];
			}
			/*if (pixel > x) {
         		    img[pixel] = (WORD) (nextint +
                                      (img[pixel-1] + img[pixel-x+1] +
                                       img[pixel-x] + img[pixel-x-1] + 2) / 4);
            		    pixel++;
			}
          		else if (pixel != 0) {
          		    img[pixel] = (WORD) (img[pixel - 1] + nextint);
            		    pixel++;
			}
          		else
				{
			 	 img[pixel++] = (WORD) nextint;*/
                  if (pixel > x) {
         		    *(img+pixel) = (WORD) (nextint +
                                      (*(img+pixel-1) + *(img+pixel-x+1) +
                                       *(img+pixel-x) + *(img+pixel-x-1) + 2) / 4);
            		    pixel++;
			}
          		else if (pixel != 0) {
          		    *(img+pixel) = (WORD) (*(img+pixel - 1) + nextint);
            		    pixel++;
			}
          		else
				{
			 	 *(img+(pixel++)) = (WORD) nextint;
						
				}
          		}
		}
	    }	
	}

}

/*****************************************************************************
 * Function: rotate_clock90 = rotates image by +90 deg.
 *****************************************************************************/
static void
rotate_clock90(WORD *data, int nx)
{
register WORD   *ptr1, *ptr2, *ptr3, *ptr4, temp;
register int    i, j;
int             nx2 = (nx+1)/2;

        for ( i=nx/2; i--; ) {
                /* Set pointer addresses */

                j    = nx2 - 1;
                ptr1 = data + nx*i        + j;          /* 1. Quadrant */
                ptr2 = data + nx*j        + nx-1-i;     /* 2. Quadrant */
                ptr3 = data + nx*(nx-1-i) + nx-1-j;     /* 4. Quadrant */
                ptr4 = data + nx*(nx-1-j) + i;          /* 3. Quadrant */

                for ( j = nx2; j--; ) {

                        /* Restack: clockwise rotation by 90.0 */
                        temp  = *ptr4;
                        *ptr4 = *ptr3;
                        *ptr3 = *ptr2;
                        *ptr2 = *ptr1;
                        *ptr1 = temp;

                        /* Increase pointer */
                         ptr1 --;
                         ptr2 -= nx;
                         ptr3 ++;
                         ptr4 += nx;
                }
        }
}

/*****************************************************************************
 * Function: swaplong = swaps bytes of 32 bit values
 *****************************************************************************/
static void
swaplong(int *data, int nbytes)
{
register int i, t1, t2, t3, t4;

        for(i=nbytes/4;i--;) {
                t1 = data[i*4+3];
                t2 = data[i*4+2];
                t3 = data[i*4+1];
                t4 = data[i*4+0];
                data[i*4+0] = t1;
                data[i*4+1] = t2;
                data[i*4+2] = t3;
                data[i*4+3] = t4;
        }
}
