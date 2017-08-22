#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

#define NR_END 1
#define FREE_ARG char*
#define FREE_STRUCT struct Search_Range*
#define ACC 40.0
#define BIGNO 1.0e10
#define BIGNI 1.0e-10

double bessj0(double x)
{
  double ax,z;
  double xx,y,ans,ans1,ans2;

  if ((ax=fabs(x)) < 8.0) {
    y=x*x;
    ans1=57568490574.0+y*(-13362590354.0+y*(651619640.7
					    +y*(-11214424.18+y*(77392.33017+y*(-184.9052456)))));
    ans2=57568490411.0+y*(1029532985.0+y*(9494680.718
					  +y*(59272.64853+y*(267.8532712+y*1.0))));
    ans=ans1/ans2;
  } else {
    z=8.0/ax;
    y=z*z;
    xx=ax-0.785398164;
    ans1=1.0+y*(-0.1098628627e-2+y*(0.2734510407e-4
				    +y*(-0.2073370639e-5+y*0.2093887211e-6)));
    ans2 = -0.1562499995e-1+y*(0.1430488765e-3
			       +y*(-0.6911147651e-5+y*(0.7621095161e-6
						       -y*0.934935152e-7)));
    ans=sqrt(0.636619772/ax)*(cos(xx)*ans1-z*sin(xx)*ans2);
  }
  return ans;
}

double bessj1(double x)
{
  double ax,z;
  double xx,y,ans,ans1,ans2;

  if ((ax=fabs(x)) < 8.0) {
    y=x*x;
    ans1=x*(72362614232.0+y*(-7895059235.0+y*(242396853.1
					      +y*(-2972611.439+y*(15704.48260+y*(-30.16036606))))));
    ans2=144725228442.0+y*(2300535178.0+y*(18583304.74
					   +y*(99447.43394+y*(376.9991397+y*1.0))));
    ans=ans1/ans2;
  } else {
    z=8.0/ax;
    y=z*z;
    xx=ax-2.356194491;
    ans1=1.0+y*(0.183105e-2+y*(-0.3516396496e-4
			       +y*(0.2457520174e-5+y*(-0.240337019e-6))));
    ans2=0.04687499995+y*(-0.2002690873e-3
			  +y*(0.8449199096e-5+y*(-0.88228987e-6
						 +y*0.105787412e-6)));
    ans=sqrt(0.636619772/ax)*(cos(xx)*ans1-z*sin(xx)*ans2);
    if (x < 0.0) ans = -ans;
  }
  return ans;
}

double bessj(int n, double x)
{
  double bessj0(double x);
  double bessj1(double x);
  void nrerror(char error_text[]);
  int j,jsum,m;
  double ax,bj,bjm,bjp,sum,tox,ans;

  if (n < 2) nrerror("Index n less than 2 in bessj");
  ax=fabs(x);
  if (ax == 0.0)
    return 0.0;
  else if (ax > (double) n) {
    tox=2.0/ax;
    bjm=bessj0(ax);
    bj=bessj1(ax);
    for (j=1;j<n;j++) {
      bjp=j*tox*bj-bjm;
      bjm=bj;
      bj=bjp;
    }
    ans=bj;
  } else {
    tox=2.0/ax;
    m=2*((n+(int) sqrt(ACC*n))/2);
    jsum=0;
    bjp=ans=sum=0.0;
    bj=1.0;
    for (j=m;j>0;j--) {
      bjm=j*tox*bj-bjp;
      bjp=bj;
      bj=bjm;
      if (fabs(bj) > BIGNO) {
	bj *= BIGNI;
	bjp *= BIGNI;
	ans *= BIGNI;
	sum *= BIGNI;
      }
      if (jsum) sum += bj;
      jsum=!jsum;
      if (j == n) ans=bjp;
    }
    sum=2.0*sum-bj;
    ans /= sum;
  }
  return x < 0.0 && (n & 1) ? -ans : ans;
}

void nrerror(char error_text[])
{
  fprintf(stderr,"Numerical Recipes run-time error...\n");
  fprintf(stderr,"%s\n",error_text);
  fprintf(stderr,"...now exiting to system...\n");
  exit(1);
}

double *dvector(long nl, long nh)
{
  double *v;
  v=(double *)malloc((size_t) ((nh-nl+1+NR_END)*sizeof(double)));
  if (!v) nrerror("allocation failure in dvector()");

  return v-nl+NR_END;
}

int *ivector(long nl, long nh)
{
  int *v;
  v=(int *)malloc((size_t) ((nh-nl+1+NR_END)*sizeof(int)));
  if (!v) nrerror("allocation failure in dvector()");

  return v-nl+NR_END;
}

char *cvector(long nl, long nh)
{
  char *v;
  v=(char *)malloc((size_t) ((nh-nl+1+NR_END)*sizeof(char)));
  if (!v) nrerror("allocation failure in dvector()");

  return v-nl+NR_END;
}


struct Search_Range *datavector(long nl, long nh)
{
  struct Search_Range *v;
  v=( struct Search_Range *)malloc((size_t) ((nh-nl+1+NR_END)*sizeof( struct Search_Range)));
  if (!v) nrerror("allocation failure in  struct Search_Range dvector()");
  return v-nl+NR_END;
}

double **dmatrix(long nrl, long nrh, long ncl, long nch)
{
  long i, nrow=nrh-nrl+1,ncol=nch-ncl+1;
  double **m;
     
  m=(double **) malloc((size_t)((nrow+NR_END)*sizeof(double*)));
  if (!m) nrerror("allocation failure 1 in matrix()");
  m += NR_END;
  m -= nrl;
     
  m[nrl]=(double *) malloc((size_t)((nrow*ncol+NR_END)*sizeof(double)));
  if (!m[nrl]) nrerror("allocation failure 2 in matrix()");
  m[nrl] += NR_END;
  m[nrl] -= ncl;
     
  for(i=nrl+1;i<=nrh;i++) m[i]=m[i-1]+ncol;

  return m;
}

struct Search_Range **datamatrix(long nrl, long nrh, long ncl, long nch)
{
  long i, nrow=nrh-nrl+1,ncol=nch-ncl+1;
  struct Search_Range **m;
     
  m=(struct Search_Range **) malloc((size_t)((nrow+NR_END)*sizeof(struct Search_Range*)));
  if (!m) nrerror("allocation failure 1 in matrix()");
  m += NR_END;
  m -= nrl;
     
  m[nrl]=(struct Search_Range *) malloc((size_t)((nrow*ncol+NR_END)*sizeof(struct Search_Range)));
  if (!m[nrl]) nrerror("allocation failure 2 in matrix()");
  m[nrl] += NR_END;
  m[nrl] -= ncl;
     
  for(i=nrl+1;i<=nrh;i++) m[i]=m[i-1]+ncol;
     
  return m;
}

int **imatrix(long nrl, long nrh, long ncl, long nch)
{
  long i, nrow=nrh-nrl+1,ncol=nch-ncl+1;
  int **m;

  m=(int **) malloc((size_t)((nrow+NR_END)*sizeof(int*)));
  if (!m) nrerror("allocation failure 1 in matrix()");
  m += NR_END;
  m -= nrl;
     
     
  m[nrl]=(int *) malloc((size_t)((nrow*ncol+NR_END)*sizeof(int)));
  if (!m[nrl]) nrerror("allocation failure 2 in matrix()");
  m[nrl] += NR_END;
  m[nrl] -= ncl;
     
  for(i=nrl+1;i<=nrh;i++) m[i]=m[i-1]+ncol;

  return m;
}

char **cmatrix(long nrl, long nrh, long ncl, long nch)
{
  long i, nrow=nrh-nrl+1,ncol=nch-ncl+1;
  char **m;
     
  m=(char **) malloc((size_t)((nrow+NR_END)*sizeof(char*)));
  if (!m) nrerror("allocation failure 1 in matrix()");
  m += NR_END;
  m -= nrl;
     
     
  m[nrl]=(char *) malloc((size_t)((nrow*ncol+NR_END)*sizeof(char)));
  if (!m[nrl]) nrerror("allocation failure 2 in matrix()");
  m[nrl] += NR_END;
  m[nrl] -= ncl;
     
  for(i=nrl+1;i<=nrh;i++) m[i]=m[i-1]+ncol;

  return m;
}

float ***f3tensor(long nrl, long nrh, long ncl, long nch, long ndl, long ndh)
{
  long i,j,nrow=nrh-nrl+1,ncol=nch-ncl+1,ndep=ndh-ndl+1;
  float ***t;

  t=(float ***) malloc((size_t)((nrow+NR_END)*sizeof(float**)));
  if (!t) nrerror("allocation failure 1 in f3tensor()");
  t += NR_END;
  t -= nrl;

  t[nrl]=(float **) malloc((size_t)((nrow*ncol+NR_END)*sizeof(float*)));
  if (!t[nrl]) nrerror("allocation failure 2 in f3tensor()");
  t[nrl] += NR_END;
  t[nrl] -= ncl;

  t[nrl][ncl]=(float *) malloc((size_t)((nrow*ncol*ndep+NR_END)*sizeof(float)));
  if (!t[nrl][ncl]) nrerror("allocation failure 3 in f3tensor()");
  t[nrl][ncl] += NR_END;
  t[nrl][ncl] -= ndl;

  for(j=ncl+1;j<=nch;j++) t[nrl][j]=t[nrl][j-1]+ndep;
  for(i=nrl+1;i<=nrh;i++) {
    t[i]=t[i-1]+ncol;
    t[i][ncl]=t[i-1][ncl]+ncol*ndep;
    for(j=ncl+1;j<=nch;j++) t[i][j]=t[i][j-1]+ndep;
  }

  return t;
}

double ***d3tensor(long nrl, long nrh, long ncl, long nch, long ndl, long ndh)
     /* allocate a double 3tensor with range t[nrl..nrh][ncl..nch][ndl..ndh] */
{
  long i,j,nrow=nrh-nrl+1,ncol=nch-ncl+1,ndep=ndh-ndl+1;
  double ***t;

  t=(double ***) malloc((size_t)((nrow+NR_END)*sizeof(double**)));
  if (!t) nrerror("allocation failure 1 in d3tensor()");
  t += NR_END;
  t -= nrl;

  t[nrl]=(double **) malloc((size_t)((nrow*ncol+NR_END)*sizeof(double*)));
  if (!t[nrl]) nrerror("allocation failure 2 in d3tensor()");
  t[nrl] += NR_END;
  t[nrl] -= ncl;

  t[nrl][ncl]=(double *) malloc((size_t)((nrow*ncol*ndep+NR_END)*sizeof(double)));
  if (!t[nrl][ncl]) nrerror("allocation failure 3 in d3tensor()");
  t[nrl][ncl] += NR_END;
  t[nrl][ncl] -= ndl;

  for(j=ncl+1;j<=nch;j++) t[nrl][j]=t[nrl][j-1]+ndep;
  for(i=nrl+1;i<=nrh;i++) {
    t[i]=t[i-1]+ncol;
    t[i][ncl]=t[i-1][ncl]+ncol*ndep;
    for(j=ncl+1;j<=nch;j++) t[i][j]=t[i][j-1]+ndep;
  }

  return t;
}

void free_dvector(double *v, long nl, long nh)
{
  free((FREE_ARG) (v+nl-NR_END));
}

void free_cvector(char *v, long nl, long nh)
{
  free((FREE_ARG) (v+nl-NR_END));
}

void free_ivector(int *v, long nl, long nh)
{
  free((FREE_ARG) (v+nl-NR_END));
}

void free_datavector(struct Search_Range *v, long nl, long nh)
{
  free((FREE_ARG)(v+nl-NR_END));
}

void free_dmatrix(double **m, long nrl, long nrh, long ncl, long nch)
{
  free((FREE_ARG) (m[nrl]+ncl-NR_END));
  free((FREE_ARG) (m+nrl-NR_END));
}

void free_datamatrix(struct Search_Range **m, long nrl, long nrh, long ncl, long nch)
{
  free((FREE_ARG) (m[nrl]+ncl-NR_END));
  free((FREE_ARG) (m+nrl-NR_END));
}

void free_imatrix(int **m, long nrl, long nrh, long ncl, long nch)
{
  free((FREE_ARG) (m[nrl]+ncl-NR_END));
  free((FREE_ARG) (m+nrl-NR_END));
}

void free_cmatrix(char **m, long nrl, long nrh, long ncl, long nch)
{
  free((FREE_ARG) (m[nrl]+ncl-NR_END));
  free((FREE_ARG) (m+nrl-NR_END));
}

void free_d3tensor(double ***t, long nrl, long nrh, long ncl, long nch,
		   long ndl, long ndh)
{
  free((FREE_ARG) (t[nrl][ncl]+ndl-NR_END));
  free((FREE_ARG) (t[nrl]+ncl-NR_END));
  free((FREE_ARG) (t+nrl-NR_END));
}

void free_f3tensor(float ***t, long nrl, long nrh, long ncl, long nch,
		   long ndl, long ndh)
{
  free((FREE_ARG) (t[nrl][ncl]+ndl-NR_END));
  free((FREE_ARG) (t[nrl]+ncl-NR_END));
  free((FREE_ARG) (t+nrl-NR_END));
}
