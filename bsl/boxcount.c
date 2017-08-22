#include <stdio.h>
#include <math.h>

#define DIVIDER 2

boxcount_(pixels,xsize,ysize,tresh)
float *pixels;
int *xsize, *ysize;
float *tresh;
{
	FILE *outf, *outf1;
	int L,SIZE;
	int i,j;
        int *count;

	if ( (outf = fopen("result.data", "w")) == NULL) {
	        printf("Unable to open file result.data\n");
                exit(1);
        };
	if ( (outf1 = fopen("res.data", "w")) == NULL) {
       		printf("Unable to open file res.data\n");
        	exit(1);
       	};
        SIZE = (*xsize > *ysize) ? *ysize : *xsize;
        printf("Using %dx%d raster\n",*xsize,*ysize);
        printf("Using %d as SIZE\n",SIZE);
        printf("Treshold %8.3f\n",*tresh);
	count  = (int *) malloc(sizeof(int)*SIZE/DIVIDER+1);
	
	
        printf(" === Init counters\n");
     	for (i=0; i<=SIZE/DIVIDER; i++) 
		count[i] = 0;

        printf(" === Counting boxes\n");
	i = 0;
     	for (L=1; L<=SIZE/DIVIDER; L++) 
		if ((SIZE%L) == 0) Sum(pixels,count,L,*xsize,*ysize,*tresh);

        printf(" === Printing results\n");
     	for (i=1; i<=SIZE/DIVIDER; i++) 
		if (count[i]>0) {
		   fprintf(outf,"%10.5f %10.5f %5d, %5d\n", log((float)i), log((float)count[i]),
                                                            i,count[i]); 
		}

	free(count);
	fclose(outf);
	fclose(outf1);
}



Sum(pixels,count,L,xsize,ysize,tr)
float *pixels;
int *count;
int L;
int xsize,ysize;
float tr;
{
	int i, j;
	int res = 0;

	printf("L is %d\n", L);
	for (i=0; i<=(xsize-L); i += L) 
	   for (j=0; j<=(ysize-L); j += L)
		if ( (res = add(pixels,xsize,tr,i,i+L,j,j+L)) > 0) {
			count[L] += 1;
		} 
}

int add(pixels,xsize,tr,x1,x2,y1,y2)
float *pixels;
int xsize;
float tr;
int x1,x2,y1,y2;
{
	int i, j;
	int res = 0;

     	for (j=y1; j<y2; j++) 
     	   for (i=x1; i<x2; i++)  
		if (pixels[i*xsize+j]> tr) 
			return(1);
	return(0);
}


