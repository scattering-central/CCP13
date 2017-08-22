/*******************************************************************************
 *                                scale_image.c                                *
 *******************************************************************************
 Purpose: Display a scaled image and return coordinates in filespace
 Author:  R.C.Denny
 Returns: 1 for success, 0 for failure
 Updates:
 12/04/94 RCD Initial implementation
*/

#include <stdio.h>
#include "fixdefs.h"
#include "fixproto.h"

typedef struct                  /* Structure for transformation information */
{
   long int offset;             /* Memory offset of start of image */
   int npix,nrast;              /* Pixels and rasters in file */
   int ipix,irast;              /* Pixels and rasters in image */
   float scale;                 /* Scale factor image to file */
   float *buf;                  /* Start of filespace memory */
} Image_Description;

static Image_Description images [MAXWIN];

/*******************************************************************************
 *                              file_to_image.c                                *
 *******************************************************************************
 Purpose: Scale an image to a square of fixed dimensions
 Author:  R.C.Denny
 Returns: 1 for success, 0 for failure
 Updates:
 12/04/94 RCD Initial implementation
*/

int file_to_image (float *buf, int npix, int nrast, int nxwid, int nywid, 
                   long int offset) 
{
   Image_Description *imptr = images;
   int i, j, ix ,iy, ipix, irast, init_x, init_y, window_no;
   float stddim, maxdim, scale, x, y, dx, dy;
   float *data, *ptrf, *ptri;

/*
 * Do transformation when interpolation is unnecessary
 */
   if (MAX(nxwid, nywid) == STDDIM)
   {
      ipix = nxwid;
      irast = nywid;
      scale = 1.0;
      if ((data = (float *) malloc (sizeof(float) * ipix * irast)) == NULL)
      {
         printf("Error allocating memory\n");
         return (0);
      }
      ptri = data;
      for (j=0; j<irast; j++)
	 for (i=0; i<ipix; i++,ptri++)
         {
	    ptrf = buf + offset + j * npix + i;
	    *ptri = *ptrf;
         }
   }
   else
   {
      stddim = (float) (STDDIM - 1);
      maxdim = (float) (MAX(nxwid, nywid) - 1);
      scale =  maxdim / stddim;   
      ipix = (int) ((float) (nxwid-1)) / scale + 1;
      irast = (int) ((float) (nywid-1)) / scale + 1;
      if ((data = (float *) malloc (sizeof(float) * ipix * irast)) == NULL)      
      {
         printf("Error allocating memory\n");
         return (0);
      }
      ptri = data;
      init_x = offset % npix;
      init_y = offset / npix;
      for (j=0; j<irast; j++)
      {
	 y = (float) init_y + scale * (float) j;
	 iy = (int) y;

	 for (i=0; i<ipix; i++,ptri++)
	 {
            x = (float) init_x + scale * (float) i;
	    ix = (int) x;

	    if (ix >= 0 && ix < npix  && iy >= 0 && iy < nrast)
	    {
	       ptrf = buf + iy * npix + ix;
	       dx = x - (float) ix;
	       dy = y - (float) iy;
	       *ptri = (1.0 - dx) * (1.0 - dy) * *ptrf;
	       if (dx > 0.001)
		  *ptri +=     dx * (1.0 - dy) * *(ptrf + 1);
	       if (dy > 0.001)
		  *ptri +=     (1.0 - dx) * dy * *(ptrf + npix);
	       if (dx > 0.001 && dy > 0.001)
                  *ptri +=             dx * dy * *(ptrf + npix + 1);
	    }
         }
      }
   }
   if (!put_image (data, ipix, irast, &window_no))
      return (0);
   free (data);

   imptr += window_no;
   imptr->offset = offset;
   imptr->npix = npix;
   imptr->nrast = nrast;
   imptr->ipix = ipix;
   imptr->irast = irast;
   imptr->scale = scale;
   imptr->buf = buf;

/*
 * Change all memory pointers to the current file (ugly) for consistency with FIX
 */
   imptr = images;
   for (i=0; i<MAXWIN; i++)
     {
       imptr->buf = buf;
       imptr++;
     }

   return (1);
}

/*******************************************************************************
 *                              image_to_file_coords.c                         *
 *******************************************************************************
 Purpose: Return coordinates in filespace values
 Author:  R.C.Denny
 Returns: 1 for success, 0 for failure
 Updates:
 18/04/94 RCD Initial implementation
*/

int image_to_file_coords (int *ixpts, int *iypts, int npts, int window_no, 
			  int *fxpts, int *fypts)
{
   Image_Description *imptr = images;
   int i, offset, npix, nrast, init_x, init_y;
   float scale;
   
   imptr += window_no;
   offset = imptr->offset;
   npix = imptr->npix;
   nrast = imptr->nrast;
   scale = imptr->scale;

   init_x = offset % npix;
   init_y = offset / npix;
 
   for (i=0;i<npts;i++,ixpts++,iypts++,fxpts++,fypts++)
   {
      *fxpts = (int) ((float) init_x + scale * (float) *ixpts);
      *fypts = (int) ((float) init_y + scale * (float) *iypts);
   }

   return (npts);
}

int i2f_scale (int length, int window_no)
{
   Image_Description *imptr = images;
   float scale;

   imptr += window_no;
   scale = imptr->scale;

   return ((int) ((float) length * scale + 0.5));
}

int f2i_scale (double length, int window_no)
{
   Image_Description *imptr = images;
   float scale;

   imptr += window_no;
   scale = imptr->scale;

   return ((int) (length / scale + 0.5));
}
   
      
int data_thresh (int window_no)
{
  Image_Description *imptr = images;
  int i, j, offset, npix, nrast, init_x, init_y, ipix, irast, ix, iy;
  float scale, x, y, dx, dy;
  float *buf, *data, *ptrf, *ptri;

  imptr += window_no;
 
  npix = imptr->npix;
  nrast = imptr->nrast;
  scale = imptr->scale;   
  ipix = imptr->ipix;
  irast = imptr->irast;
  offset = imptr->offset;
  buf = imptr->buf;

  if ((data = (float *) malloc (sizeof(float) * ipix * irast)) == NULL) 
    {
      printf("Error allocating memory\n");
      return (0);
    }
  ptri = data;
  init_x = offset % npix;
  init_y = offset / npix;
  for (j=0; j<irast; j++)
    {
      y = (float) init_y + scale * (float) j;
      iy = (int) y;
	  
      for (i=0; i<ipix; i++,ptri++)
	{
	  x = (float) init_x + scale * (float) i;
	  ix = (int) x;
	  
	  if (ix >= 0 && ix < npix  && iy >= 0 && iy < nrast)
	    {
	      ptrf = buf + iy * npix + ix;
	      dx = x - (float) ix;
	      dy = y - (float) iy;
	      *ptri = (1.0 - dx) * (1.0 - dy) * *ptrf;
	      if (dx > 0.001)
		*ptri +=     dx * (1.0 - dy) * *(ptrf + 1);
	      if (dy > 0.001)
		*ptri +=     (1.0 - dx) * dy * *(ptrf + npix);
	      if (dx > 0.001 && dy > 0.001)
		*ptri +=             dx * dy * *(ptrf + npix + 1);
	    }
	}
    }

  process_event (window_no, ipix, irast, data);
  free (data);
  return (1);
}


int file_to_image_coords (float *fx, float *fy, int npts, int window_no, 
			  int *ix, int *iy)
{
   Image_Description *imptr = images;
   int n = 0;
   int i, offset, npix, nrast, init_x, init_y, ipix, irast;
   float scale;
   
   imptr += window_no;
   offset = imptr->offset;
   npix = imptr->npix;
   nrast = imptr->nrast;
   ipix = imptr->ipix;
   irast = imptr->irast;
   scale = imptr->scale;

   init_x = offset % npix;
   init_y = offset / npix;
 
   for (i=0; i<npts; i++)
     {
       *ix = (int) ((*fx++ - (float) init_x) / scale + 0.5);
       *iy = (int) ((*fy++ - (float) init_y) / scale + 0.5);
       if ((*ix >= 0 && *ix < ipix) && (*iy >= 0 && *iy < irast))
	 {
	   ix++;
	   iy++;
	   n++;
	 }
     }

   return (n);
}
  
