#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <ctype.h>
#include <math.h>
#include "constants.h"
#include "structures.h"
#include "prototypes.h"

#define TOL 2.0e-4
#define ITMAXI 100
#define ITMAX 200
#define GOLD 1.618034
#define CGOLD 0.3819660
#define GLIMIT 100.0
#define TINY 1.0e-20
#define ZEPS 1.0e-10
#define NMAX 1000000
#define IA 16807
#define IM 2147483647
#define AM (1.0/IM)
#define IQ 127773
#define IR 2836
#define NTAB 32
#define NDIV (1+(IM-1)/NTAB)
#define EPS 1.2e-14
#define RNMX (1.0-EPS)
#define SHFT(a,b,c,d) (a)=(b);(b)=(c);(c)=(d);
#define SWAP(a,b) {swap=(a);(a)=(b);(b)=swap;}
#define MAXPAR 50
#define MINGRP  2
#define MAXGRP  5
#define MAXGAP 26

Torus_Input Torus_defaults =
{
  (double) 0.5,      /* Torus_defaults.bump         */
  (int)    4,        /* Torus_defaults.counter1     */
  (int)    40,       /* Torus_defaults.counter2     */
  (double) 1.0e-06,  /* Torus_defaults.tor_exit     */
  (int)    1,        /* Torus_defaults.scalar1      */
  (int)    1,        /* Torus_defaults.scalar2      */
  (double) 1.5,      /* Torus_defaults.shrink_hit   */
  (double) 1.5,      /* Torus_defaults.shrink_trial */
  (double) 2000.0    /* Torus_defaults.tor_hole     */
};

void powell(double p[], double **xi, int n, double ftol, int *iter, double *fret,
	    double (*func)(double []))
{
  void linmin(double p[], double xi[], int n, double *fret,
	      double (*func)(double []));
  int i,ibig,j;
  double del,fp,fptt,t,*pt,*ptt,*xit;
     
  pt=dvector(1,n);
  ptt=dvector(1,n);
  xit=dvector(1,n);
  *fret=(*func)(p);
  for (j=1;j<=n;j++) pt[j]=p[j];
  for (*iter=1;;++(*iter)) {
    fp=(*fret);
    ibig=0;
    del=0.0;
    for (i=1;i<=n;i++) {
      for (j=1;j<=n;j++) xit[j]=xi[j][i];
      fptt=(*fret);
      linmin(p,xit,n,fret,func);
      if (fabs(fptt-(*fret)) > del) {
	del=fabs(fptt-(*fret));
	ibig=i;
      }
    }
    if (2.0*fabs(fp-(*fret)) <= ftol*(fabs(fp)+fabs(*fret))) {
      free_dvector(xit,1,n);
      free_dvector(ptt,1,n);
      free_dvector(pt,1,n);
      return;
    }
    if (*iter == ITMAX) nrerror("powell exceeding maximum iterations.");
    for (j=1;j<=n;j++) {
      ptt[j]=2.0*p[j]-pt[j];
      xit[j]=p[j]-pt[j];
      pt[j]=p[j];
    }
    fptt=(*func)(ptt);
    if (fptt < fp) {
      t=2.0*(fp-2.0*(*fret)+fptt)*SQR(fp-(*fret)-del)-del*SQR(fp-fptt);
      if (t < 0.0) {
	linmin(p,xit,n,fret,func);
	for (j=1;j<=n;j++) {
	  xi[j][ibig]=xi[j][n];
	  xi[j][n]=xit[j];
	}
      }
    }
  }
}

extern int ncom;
extern double *pcom,*xicom,(*nrfunc)(double []);

double f1dim(double x)
{
  int j;
  double f,*xt;
     
  xt=dvector(1,ncom);
  for (j=1;j<=ncom;j++) xt[j]=pcom[j]+x*xicom[j];
  f=(*nrfunc)(xt);
  free_dvector(xt,1,ncom);
  return f;
}



void mnbrak(double *ax, double *bx, double *cx, double *fa, double *fb, 
	    double *fc, double (*func)(double))
{
  double ulim,u,r,q,fu,dum;
     
  *fa=(*func)(*ax);
  *fb=(*func)(*bx);
  if (*fb > *fa) {
    SHFT(dum,*ax,*bx,dum)
      SHFT(dum,*fb,*fa,dum)
      }
  *cx=(*bx)+GOLD*(*bx-*ax);
  *fc=(*func)(*cx);
  while (*fb > *fc) {
    r=(*bx-*ax)*(*fb-*fc);
    q=(*bx-*cx)*(*fb-*fa);
    u=(*bx)-((*bx-*cx)*q-(*bx-*ax)*r)/
      (2.0*SIGN(FMAX(fabs(q-r),TINY),q-r));
    ulim=(*bx)+GLIMIT*(*cx-*bx);
    if ((*bx-u)*(u-*cx) > 0.0) {
      fu=(*func)(u);
      if (fu < *fc) {
	*ax=(*bx);
	*bx=u;
	*fa=(*fb);
	*fb=fu;
	return;
      } else if (fu > *fb) {
	*cx=u;
	*fc=fu;
	return;
      }
      u=(*cx)+GOLD*(*cx-*bx);
      fu=(*func)(u);
    } else if ((*cx-u)*(u-ulim) > 0.0) {
      fu=(*func)(u);
      if (fu < *fc) {
	SHFT(*bx,*cx,u,*cx+GOLD*(*cx-*bx))
	  SHFT(*fb,*fc,fu,(*func)(u))
	  }
    } else if ((u-ulim)*(ulim-*cx) >= 0.0) {
      u=ulim;
      fu=(*func)(u);
    } else {
      u=(*cx)+GOLD*(*cx-*bx);
      fu=(*func)(u);
    }
    SHFT(*ax,*bx,*cx,u)
      SHFT(*fa,*fb,*fc,fu)
      }
}

double brent(double ax, double bx, double cx, double (*f)(double),
	     double tol, double *xmin)
{
  int iter;
  double a,b,d,etemp,fu,fv,fw,fx,p,q,r,tol1,tol2,u,v,w,x,xm;
  double e=0.0;
     
  a=(ax < cx ? ax : cx);
  b=(ax > cx ? ax : cx);
  x=w=v=bx;
  fw=fv=fx=(*f)(x);
  for (iter=1;iter<=ITMAXI;iter++) {
    xm=0.5*(a+b);
    tol2=2.0*(tol1=tol*fabs(x)+ZEPS);
    if (fabs(x-xm) <= (tol2-0.5*(b-a))) {
      *xmin=x;
      return fx;
    }
    if (fabs(e) > tol1) {
      r=(x-w)*(fx-fv);
      q=(x-v)*(fx-fw);
      p=(x-v)*q-(x-w)*r;
      q=2.0*(q-r);
      if (q > 0.0) p = -p;
      q=fabs(q);
      etemp=e;
      e=d;
      if (fabs(p) >= fabs(0.5*q*etemp) || p <= q*(a-x) || p >= q*(b-x))
	d=CGOLD*(e=(x >= xm ? a-x : b-x));
      else {
	d=p/q;
	u=x+d;
	if (u-a < tol2 || b-u < tol2)
	  d=SIGN(tol1,xm-x);
      }
    } else {
      d=CGOLD*(e=(x >= xm ? a-x : b-x));
    }
    u=(fabs(d) >= tol1 ? x+d : x+SIGN(tol1,d));
    fu=(*f)(u);
    if (fu <= fx) {
      if (u >= x) a=x; else b=x;
      SHFT(v,w,x,u)
	SHFT(fv,fw,fx,fu)
	} else {
	  if (u < x) a=u; else b=u;
	  if (fu <= fw || w == x) {
	    v=w;
	    w=u;
	    fv=fw;
	    fw=fu;
	  } else if (fu <= fv || v == x || v == w) {
	    v=u;
	    fv=fu;
	  }
	}
  }
  nrerror("Too many iterations in brent");
  *xmin=x;
  return fx;
}

int ncom;
double *pcom,*xicom,(*nrfunc)(double []);

void linmin(double p[], double xi[], int n, double *fret, 
	    double (*func)(double []))
{
  double brent(double ax, double bx, double cx,
	       double (*f)(double), double tol, double *xmin);
  double f1dim(double x);
  void mnbrak(double *ax, double *bx, double *cx, double *fa,
	      double *fb,double *fc, double (*func)(double));
  int j;
  double xx,xmin,fx,fb,fa,bx,ax;
     
  ncom=n;
  pcom=dvector(1,n);
  xicom=dvector(1,n);
  nrfunc=func;
  for (j=1;j<=n;j++) {
    pcom[j]=p[j];
    xicom[j]=xi[j];
  }
  ax=0.0;
  xx=1.0;
  mnbrak(&ax,&xx,&bx,&fa,&fx,&fb,f1dim);
  *fret=brent(ax,xx,bx,f1dim,TOL,&xmin);
  for (j=1;j<=n;j++) {
    xi[j] *= xmin;
    p[j] += xi[j];
  }
  free_dvector(xicom,1,n);
  free_dvector(pcom,1,n);
}

void amoeba(double **p, double y[], int ndim, double ftol,
	    double (*funk)(double []), int *nfunk)
{
  double amotry(double **p, double y[], double psum[], int ndim,
		double (*funk)(double []), int ihi, double fac);
  int i,ihi,ilo,inhi,j,mpts=ndim+1;
  double rtol,sum,swap,ysave,ytry,*psum;
  psum=dvector(1,ndim);
  *nfunk=0;
  for (j=1;j<=ndim;j++) {
    for (sum=0.0,i=1;i<=mpts;i++) sum += p[i][j];
    psum[j]=sum;
  }
  for (;;) {
    ilo=1;
    ihi = y[1]>y[2] ? (inhi=2,1) : (inhi=1,2);
    for (i=1;i<=mpts;i++) {
      if (y[i] <= y[ilo]) ilo=i;
      if (y[i] > y[ihi]) {
	inhi=ihi;
	ihi=i;
      } else if (y[i] > y[inhi] && i != ihi) inhi=i;
    }
    rtol=2.0*fabs(y[ihi]-y[ilo])/(fabs(y[ihi])+fabs(y[ilo]));
    if (rtol < ftol) {
      SWAP(y[1],y[ilo])
	for (i=1;i<=ndim;i++) SWAP(p[1][i],p[ilo][i])
				break;
    }
    if (*nfunk >= NMAX) nrerror("NMAX exceeded");
    *nfunk += 2;
    ytry=amotry(p,y,psum,ndim,funk,ihi,-1.0);
    if (ytry <= y[ilo])
      ytry=amotry(p,y,psum,ndim,funk,ihi,2.0);
    else if (ytry >= y[inhi]) {
      ysave=y[ihi];
      ytry=amotry(p,y,psum,ndim,funk,ihi,0.5);
      if (ytry >= ysave) {
	for (i=1;i<=mpts;i++) {
	  if (i != ilo) {
	    for (j=1;j<=ndim;j++)
	      p[i][j]=psum[j]=0.5*(p[i][j]+p[ilo][j]);
	    y[i]=(*funk)(psum);
	  }
	}
	*nfunk += ndim;
	for (j=1;j<=ndim;j++) {
	  for (sum=0.0,i=1;i<=mpts;i++) sum += p[i][j];
	  psum[j]=sum;
	}
      }
    } else --(*nfunk);
  }
  free_dvector(psum,1,ndim);
}

double amotry(double **p, double y[], double psum[], int ndim,
	      double (*funk)(double []), int ihi, double fac)
{
  int j;
  double fac1,fac2,ytry,*ptry;
     
  ptry=dvector(1,ndim);
  fac1=(1.0-fac)/ndim;
  fac2=fac1-fac;
  for (j=1;j<=ndim;j++) ptry[j]=psum[j]*fac1-p[ihi][j]*fac2;
  ytry=(*funk)(ptry);
  if (ytry < y[ihi]) {
    y[ihi]=ytry;
    for (j=1;j<=ndim;j++) {
      psum[j] += ptry[j]-p[ihi][j];
      p[ihi][j]=ptry[j];
    }
  }
  free_dvector(ptry,1,ndim);
  return ytry;
}

extern long idum;
double tt;

void amebsa(double **p, double y[], int ndim, double pb[], double *yb, double ftol,
	    double (*funk)(double []), int *iter, double temptr)
{
  double amotsa(double **p, double y[], double psum[], int ndim, double pb[],
		double *yb, double (*funk)(double []), int ihi, 
		double *yhi, double fac);
  double ran1(long *idum);
  int i,ihi,ilo,j,m,n,mpts=ndim+1;
  double rtol,sum,swap,yhi,ylo,ynhi,ysave,yt,ytry,*psum;
     
  psum=dvector(1,ndim);
  tt = -temptr;
  for (n=1;n<=ndim;n++) {
    for (sum=0.0,m=1;m<=mpts;m++) sum += p[m][n];
    psum[n]=sum;
  }
  for (;;) {
    ilo=1;
    ihi=2;
    ynhi=ylo=y[1]+tt*log(ran1(&idum));
    yhi=y[2]+tt*log(ran1(&idum));
    if (ylo > yhi) {
      ihi=1;
      ilo=2;
      ynhi=yhi;
      yhi=ylo;
      ylo=ynhi;
    }
    for (i=3;i<=mpts;i++) {
      yt=y[i]+tt*log(ran1(&idum));
      if (yt <= ylo) {
	ilo=i;
	ylo=yt;
      }
      if (yt > yhi) {
	ynhi=yhi;
	ihi=i;
	yhi=yt;
      } else if (yt > ynhi) {
	ynhi=yt;
      }
    }
    rtol=2.0*fabs(yhi-ylo)/(fabs(yhi)+fabs(ylo));
    if (rtol < ftol || *iter < 0) {
      swap=y[1];
      y[1]=y[ilo];
      y[ilo]=swap;
      for (n=1;n<=ndim;n++) {
	swap=p[1][n];
	p[1][n]=p[ilo][n];
	p[ilo][n]=swap;
      }
      break;
    }
    *iter -= 2;
    ytry=amotsa(p,y,psum,ndim,pb,yb,funk,ihi,&yhi,-1.0);
    if (ytry <= ylo) {
      ytry=amotsa(p,y,psum,ndim,pb,yb,funk,ihi,&yhi,2.0);
    } else if (ytry >= ynhi) {
      ysave=yhi;
      ytry=amotsa(p,y,psum,ndim,pb,yb,funk,ihi,&yhi,0.5);
      if (ytry >= ysave) {
	for (i=1;i<=mpts;i++) {
	  if (i != ilo) {
	    for (j=1;j<=ndim;j++) {
	      psum[j]=0.5*(p[i][j]+p[ilo][j]);
	      p[i][j]=psum[j];
	    }
	    y[i]=(*funk)(psum);
	  }
	}
	*iter -= ndim;
	for (n=1;n<=ndim;n++) {
	  for (sum=0.0,m=1;m<=mpts;m++) sum += p[m][n];
	  psum[n]=sum;
	}
      }
    } else ++(*iter);
  }
  free_dvector(psum,1,ndim);
}

double amotsa(double **p, double y[], double psum[], int ndim, double pb[],
	      double *yb, double (*funk)(double []), int ihi, double *yhi, double fac)
{
  double ran1(long *idum);
  int j;
  double fac1,fac2,yflu,ytry,*ptry;
     
  ptry=dvector(1,ndim);
  fac1=(1.0-fac)/ndim;
  fac2=fac1-fac;
  for (j=1;j<=ndim;j++)
    ptry[j]=psum[j]*fac1-p[ihi][j]*fac2;
  ytry=(*funk)(ptry);
  if (ytry <= *yb) {
    for (j=1;j<=ndim;j++) pb[j]=ptry[j];
    *yb=ytry;
  }
  yflu=ytry-tt*log(ran1(&idum));
  if (yflu < *yhi) {
    y[ihi]=ytry;
    *yhi=yflu;
    for (j=1;j<=ndim;j++) {
      psum[j] += ptry[j]-p[ihi][j];
      p[ihi][j]=ptry[j];
    }
  }
  free_dvector(ptry,1,ndim);
  return yflu;
}

double ran1(long *idum)
{
  int j;
  long k;
  static long iy=0;
  static long iv[NTAB];
  double temp;
     
  if (*idum <= 0 || !iy) {
    if (-(*idum) < 1) *idum=1;
    else *idum = -(*idum);
    for (j=NTAB+7;j>=0;j--) {
      k=(*idum)/IQ;
      *idum=IA*(*idum-k*IQ)-IR*k;
      if (*idum < 0) *idum += IM;
      if (j < NTAB) iv[j] = *idum;
    }
    iy=iv[0];
  }
  k=(*idum)/IQ;
  *idum=IA*(*idum-k*IQ)-IR*k;
  if (*idum < 0) *idum += IM;
  j=iy/NDIV;
  iy=iv[j];
  iv[j] = *idum;
  if ((temp=AM*iy) > RNMX) return RNMX;
  else return temp;
}

double bump;
int counter1,counter2;
double tor_exit;
int scalar1,scalar2;
double shrink_hit,shrink_trial,tor_hole;

static double multi_fun (double *, double *, double *, double (*)(), int,
                         double *, double *, int, int);
static double single_fun (double *, double *, double *, double (*)(), int,
                          double *, double *, int, int, int, int);
static double ran2 (int *);
static void seed (int *);

int iseed;          /*  Initial seed for random number generator  */

int torus (char *type, double *lower, double *upper, double *cutoff,
           double (*fname)(), char *minmax, double *start_set, int numvar,
           Torus_Input *input)
{
  double *range, *cutoff_alt, *minotaur, *start_value;
  double *cut, *new_range, *bump_set, *last_set, *best_set = start_set;
  static char *max = "MAX";
  char min[] = "MIN", *cptr = minmax;
  int sign = 0;
  double vbump, last_minimum, last_score, factor;
  int single_its, multi_its, single_count, multi_count;
  int within_trial, within_trial_count, flagz_count, count, next_variable,
    down_up;
  int flag_direction, flagz;
  int i, iproc;

  if (
      !(range = (double *) malloc (numvar * sizeof (double))) ||
      !(cutoff_alt = (double *) malloc (numvar * sizeof (double))) ||
      !(minotaur = (double *) malloc (numvar * sizeof (double))) ||
      !(start_value = (double *) malloc (numvar * sizeof (double))) ||
      !(cut = (double *) malloc (numvar * sizeof (double))) ||
      !(new_range = (double *) malloc (numvar * sizeof (double))) ||
      !(bump_set = (double *) malloc (numvar * sizeof (double))) ||
      !(last_set = (double *) malloc (numvar * sizeof (double)))
      )
    {
      printf ("TORUS: Error - not enough memory\n");
      return (0);
    }
#define FREE free(range); free(cutoff_alt); free(minotaur); free(start_value); \
  free(cut); free(new_range); free(bump_set); free(last_set);
 
  seed (&iseed);
  if (input != (Torus_Input *) NULL) {
    bump = input->bump;
    counter1 = input->counter1;
    counter2 = input->counter2;
    tor_exit = input->tor_exit;
    scalar1 = input->scalar1;
    scalar2 = input->scalar2;
    shrink_hit = input->shrink_hit;
    shrink_trial = input->shrink_trial;
    tor_hole = input->tor_hole;
  }

  switch (*type) {
  case 'i':
  case 'I':
    factor = 2.0;
    break;
  case 'f':
  case 'F':
    factor = 32.0;
    break;
  case 'd':
  case 'D':
  default:
    factor = 64.0;
  }

  i = 0;
  while (*cptr) {
    *(min + i) = (char) toupper ((int) *cptr);
    cptr++;
    i++;
  }
  if (!strcmp (min, max)) {
    sign = -1;
  }

  for (i=0; i<numvar; i++) {
    range[i] = upper[i] - lower[i];
    cutoff_alt[i] = MAX (cutoff[i], range[i]/tor_hole);
    minotaur[i] = factor * cutoff[i];
    if (start_set == (double *) NULL) {
      start_value[i] = (upper[i] - lower[i]) / 2.0;
    }
    else {
      start_value[i] = start_set[i];
    }
  }
  single_its = 10 * scalar1;
  multi_its = 10 * scalar2 * numvar * numvar;
  single_count = counter1 * single_its;
  multi_count = counter1 * multi_its;

  for (iproc=0; iproc<counter1; iproc++) {
    last_minimum = multi_fun (lower, upper, cutoff_alt, fname, sign,
			      start_value, range, multi_its, numvar);
  }

  within_trial = 0;
  within_trial_count = 0;
  flagz_count = 0;
  flagz = 1;
  count = 0;
  next_variable = 0;
  flag_direction = 0;
  down_up = 0;
  vbump = 0.0;
  last_score = last_minimum;
  for (i=0; i<numvar; i++) {
    cut[i] = cutoff_alt[i];
    new_range[i] = range[i];
    bump_set[i] = start_value[i];
    best_set[i] = start_value[i];
    last_set[i] = start_value[i];
  }

  while (1) {
    if (within_trial > 1 && flagz == 0) {
      within_trial = within_trial;
    } 
    else if (within_trial == 3) {
      within_trial = 1;
    } 
    else {
      within_trial++;
    }
    if (within_trial > 1) {
      within_trial_count++;
    }
    else {
      within_trial_count = 0;
    }
    if (flagz == 0) {
      flagz_count++;
    }
    if (within_trial == 1) {
      count++;
    }
    next_variable = count % numvar;
    if (flag_direction == 0) {
      flag_direction = 1;
    }
    else {
      flag_direction = 0;
    }
    if (within_trial_count > 1 && flagz == 0) {
      for (i=0; i<numvar; i++) {
	cut[i] = MAX (cut[i]/shrink_hit, cutoff[i]);
      }
    }
    else if (within_trial == 1) {
      for (i=0; i<numvar; i++)
	{
	  cut[i] = MAX (cut[i]/shrink_trial, cutoff[i]);
	}
    }
    if (within_trial_count > 1 && flagz == 0) {
      for (i=0; i<numvar; i++) {
	new_range[i] = MAX (new_range[i]/shrink_hit, minotaur[i]);
      }
    }
    else if (within_trial == 1) {
      for (i=0; i<numvar; i++) {
	new_range[i] = MAX (new_range[i]/shrink_trial, minotaur[i]);
      }
    }
    if (within_trial_count > 1 && flagz == 0) {
      if (best_set[next_variable] < last_set[next_variable]) {
	down_up = 0;
      }
      else if (best_set[next_variable] > last_set[next_variable]) {
	down_up = 1;
      }
    }
    else if (within_trial == 2) {
      down_up = 1;
    }
    else if (down_up == 1) {
      down_up = 0;
    }
    else {
      down_up = 1;
    }
    if (down_up == 1) {
      vbump = new_range[next_variable] * bump;
    }
    else {
      vbump = new_range[next_variable] * -bump;
    }
    if (within_trial == 1) {
      for (i=0; i<numvar; i++) {
	bump_set[i] = best_set[i];
      }
    }
    else if (((best_set[next_variable] + vbump) > lower[next_variable]) &&
	     ((best_set[next_variable] + vbump) < upper[next_variable])) {
      for (i=0; i<numvar; i++) {
	bump_set[i] = best_set[i];
      }
      bump_set[next_variable] += vbump;
    }
    else if (((best_set[next_variable] - vbump) > lower[next_variable]) &&
	     ((best_set[next_variable] - vbump) < upper[next_variable])) {
      for (i=0; i<numvar; i++) {
	bump_set[i] = best_set[i];
      }
      bump_set[next_variable] -= vbump;
    }
    else {
      for (i=0; i<numvar; i++) {
	bump_set[i] = best_set[i];
      }
    }
    if (flagz == 0) {
      last_minimum = last_score;
    }
    if (flagz == 0) {
      for (i=0; i<numvar; i++) {
	best_set[i] = last_set[i];
      }
    }
    if (within_trial == 1) {
      for (iproc=0; iproc<counter1; iproc++) {
	last_score = single_fun (lower, upper, cut, fname, sign,
				 bump_set, new_range, single_its,
				 next_variable, flag_direction, numvar);
      }
    }
    else {
      for (iproc=0; iproc<counter1; iproc++) {
	last_score = multi_fun (lower, upper, cut, fname, sign,
				bump_set, new_range, multi_its, numvar);
      }
      for (iproc=0; iproc<counter1; iproc++) {
	last_score = single_fun (lower, upper, cut, fname, sign,
				 bump_set, new_range, single_its,
				 next_variable, flag_direction, numvar);
      }
    }
    for (i=0; i<numvar; i++) {
      last_set[i] = bump_set[i];
    }
    if (last_score < last_minimum) {
      flagz = 0;
    }
    else {
      flagz++;
    }
    if (count == counter2) {
      FREE
	return (1);
    }
    if (flagz == 36) {
      FREE
	return (2);
    }
    if (((last_minimum - last_score) > 0.0) &&
	((last_minimum - last_score) < tor_exit)) {
      FREE
	return (3);
    }
    if (flagz_count == 24) {
      FREE
	return (4);
    }
  }
}

static double multi_fun (double *lower, double *upper, double *cutoff,
                         double (*fname)(), int sign, double *bump_set,
                         double *range, int multi_its, int numvar)
{
  double log_constant = log ((double) multi_its);
  int iterate = 0;
  int variable_flag = 0;
  int value_flag = 0;
  int shit_out = 0;
  double iterate_delta = 1.0;
  double *variable_set, *delta, *value_set = bump_set;
  double value, best_value;
  int i;

  if (
      !(variable_set = (double *) malloc (sizeof (double) * numvar)) ||
      !(delta = (double *) malloc (sizeof (double) * numvar))
      ) {
    printf ("MULTI_FUN: Error - not enough memory\n");
    return (0.0);
  }
  for (i=0; i<numvar; i++) {
    variable_set[i] = bump_set[i];
    delta[i] = 0.0;
  }
  best_value = fname (value_set);
  best_value = (sign == 0) ? best_value : -best_value;
  while (1) {
    if (variable_flag != 1) {
      iterate++;
    }
    iterate_delta = 1.0 - log(iterate) / log_constant;
    for (i=0; i<numvar; i++) {
      delta[i] = iterate_delta * range[i] * (2.0 * ran2 (&iseed) - 1.0);
      iseed = -iseed;
      if (abs (delta[i]) < cutoff[i]) {
	if (delta[i] < 0.0) {
	  delta[i] = -cutoff[i];
	}
	else {
	  delta[i] = cutoff[i];
	}
      }
    }
    for (i=0; i<numvar; i++) {
      if (delta[i] < 0.0) {
	if (value_set[i] + delta[i] > lower[i]) {
	  variable_set[i] = value_set[i] + delta[i];
	}
	else {
	  variable_set[i] = value_set[i];
	}
      }
      else if (delta[i] > 0.0) {
	if (value_set[i] + delta[i] < upper[i]) {
	  variable_set[i] = value_set[i] + delta[i];
	}
	else {
	  variable_set[i] = value_set[i];
	}
      }
      else {
	variable_set[i] = value_set[i];
      }
    }
    variable_flag = 1;
    i = 0;
    while (variable_flag == 1 && i < numvar) {
      if (variable_set[i] == value_set[i]) {
	i++;
      }
      else {
	variable_flag = 0;
      }
    }
    if (variable_flag == 0) {
      value = fname (variable_set);
      value = (sign == 0) ? value : -value;
      shit_out = 0;
    }
    else {
      shit_out++;
    }
    if (value < best_value) {
      value_flag = 1;
    }
    else {
      value_flag = 0;
    }
    if (value_flag == 1) {
      best_value = value;
    }
    if (value_flag == 1) {
      for (i=0; i<numvar; i++) {
	value_set[i] = variable_set[i];
      }
    }

    if (iterate == multi_its || shit_out == 10) {
      free (delta); free (variable_set);
      return (best_value);
    }
  }
}


static double single_fun (double *lower, double *upper, double *cut,
                          double (*fname)(), int sign, double *bump_set,
                          double *new_range, int single_its, int next_variable,
                          int flag_direction, int numvar)
{
  int count1 = 1;
  int count2;
  double log_constant = log ((double) single_its);
  int iterate = 0;
  int variable_flag = 0;
  int value_flag = 0;
  int shit_out = 0;
  double delta = 0.0, iterate_delta = 1.0;
  double *variable_set, *value_set = bump_set;
  double value, best_value;
  int i;

  if (
      !(variable_set = (double *) malloc (sizeof (double) * numvar))
      ) {
    printf ("SINGLE_FUN: Error - not enough memory\n");
    return (0.0);
  }

  best_value = fname (value_set);
  best_value = (sign == 0) ? best_value : -best_value;
  while (1) {
    if (flag_direction == 0) {
      count2 = (next_variable + count1) % numvar;
    }
    else {
      count2 = (next_variable - count1) % numvar;
    }
    if (count2 < 0) {
      count2 += numvar;
    }
    while (1) {
      if (variable_flag != 1) {
	iterate++;
      }
      iterate_delta = 1.0 - log(iterate) / log_constant;
      delta = iterate_delta * new_range[count2] * (2.0 * ran2 (&iseed)-1.0);
      iseed = -iseed;
      if (abs (delta) < cut[count2]) {
	if (delta < 0.0) {
	  delta = -cut[count2];
	}
	else {
	  delta = cut[count2];
	}
      }
      for (i=0; i<numvar; i++) {
	variable_set[i] = value_set[i];
      }
      if (delta < 0.0) {
	if (value_set[count2] + delta > lower[count2]) {
	  variable_set[count2] += delta;
	}
      }
      else if (delta > 0.0) {
	if (value_set[count2] + delta < upper[count2]) {
	  variable_set[count2] += delta;
	}
      }
      variable_flag = 0;
      if (variable_set[count2] == value_set[count2]) {
	variable_flag = 1;
      }
      if (variable_flag == 0) {
	value = fname (variable_set);
	value = (sign == 0) ? value : -value;
	shit_out = 0;
      }
      else {
	shit_out++;
      }
      if (value < best_value) {
	value_flag = 1;
      }
      else {
	value_flag = 0;
      }
      if (value_flag == 1) {
	best_value = value;
      }
      if (value_flag == 1) {
	value_set[count2] = variable_set[count2];
      }
      if (iterate == single_its || shit_out == 10) {
	iterate = 0;
	variable_flag = 0;
	break;
      }
    }
    if (count1 == numvar) {
      free (variable_set);
      return (best_value);
    }
    count1++;
  }
}

static double ran2 (int *idum)
{
  static int m = 714205, ia = 1366, ic = 150889;
  static double rm = 1.40015821787e-6;
  static int iff = 0;

  static int ir[97], iy;
  int j;
  double y;

  if (*idum < 0 || iff == 0) {
    iff = 1;
    *idum = (ic - *idum) % m;
    for (j = 0; j < 97; ++j) {
      *idum = (*idum * ia + ic) % m;
      ir[j] = *idum;
    }
    *idum = (*idum * ia + ic) % m;
    iy = *idum;
  }
  j = (iy * 97) / m;
  if (j > 96 || j < 0) {
    return (-1.0);
  }
  y = (double) ir[j];
  *idum = (*idum * ia + ic) % m;
  ir[j] = *idum;
  return ((double) iy * rm);
}

#include <stdlib.h>
#include <time.h>

static void seed (int *iseed)
{
  unsigned int sd;
  time_t tmp = time (&tmp);
  long lseed = tmp - clock ();
  sd = (unsigned int) lseed;

/*#if defined (__hpux) || defined (linux)*/
  srand (sd);
  *iseed = -rand ();
/*#else
  *iseed = -rand_r (&sd);
#endif*/
  return;
}


void FTORUS (int *itype, double *lower, double *upper, double *cutoff,
             double (*fname)(), int *minmax, double *start_set, int *numvar,
             double *bump, int *counter1, int *counter2, double *tor_exit,
             int *scalar1, int *scalar2, double *shrink_hit,
             double *shrink_trial, double *tor_hole, int *iflag)
{
  static char *min = "MIN", *max = "MAX";
  static char *types[3] = {"D", "F", "I"};
  char *type = types[*itype];
  char *m;
 
  if (*minmax <= 0) {
    m = min;
  }
  else {
    m = max;
  }
  if (*bump > 0.0) Torus_defaults.bump = *bump;
  if (*counter1 > 0) Torus_defaults.counter1 = *counter1;
  if (*counter2 > 0) Torus_defaults.counter2 = *counter2;
  if (*tor_exit > 0.0) Torus_defaults.tor_exit = *tor_exit;
  if (*scalar1 > 0) Torus_defaults.scalar1 = *scalar1;
  if (*scalar2 > 0) Torus_defaults.scalar2 = *scalar2;
  if (*shrink_hit > 0.0) Torus_defaults.shrink_hit = *shrink_hit;
  if (*shrink_trial > 0.0) Torus_defaults.shrink_trial = *shrink_trial;
  if (*tor_hole > 0.0) Torus_defaults.tor_hole = *tor_hole;
  *iflag = torus (type, lower, upper, cutoff, fname, m, start_set, *numvar,
                  &Torus_defaults);
  return;
}

static void dsort (double *, int, int *);

int replex (double *pr, double *shift, int na, double (*func)(), int itmax, 
	    int maxits, double ftol, double atol, double *fret)
{
  static double tiny = (double) 1e-15;

  double pgrp[MAXGRP], p[(MAXGRP+1)*MAXGRP], y[MAXGRP+1]; 
  int lista[MAXGRP];
  double *pshft, *gap, *ptr;
  int *indg, *inds, *ngap, *nxtgap, *lengrp;
  int jpos, igap, kgap, iter, good_gap;
  int i, j, k;
  int mingl, mingr;
  int nzero, ndim;
  int nl, nr, maxgap, mainit, numgap;
  int ihi, ilo;
  double logsft, olgsft;
  double fp;

  if (
      !(pshft = (double *) malloc (na * sizeof (double))) ||
      !(gap = (double *) malloc ((na - 1) * sizeof (double))) ||
      !(inds = (int *) malloc (na * sizeof (int))) ||
      !(indg = (int *) malloc ((na - 1) * sizeof (int))) ||
      !(ngap = (int *) malloc ((na + 1) * sizeof (int))) ||
      !(nxtgap = (int *) malloc ((na/MINGRP + 1) * sizeof (int))) ||
      !(lengrp = (int *) malloc ((na/MINGRP + 1) * sizeof (int)))
      ) 
    {
      printf ("REPLEX: Error - not enough memory\n");
      return (0);
    }

  y[0] = (*func)(pr);
  fp = y[0];
  printf ("Start of downhill simplex: function = %12g\n", fp);
  printf ("Point  ");
  for (j = 0; j < na; j++) {
    printf (" %12g ", pr[j]);
  }
  nzero = 0;
  ptr = pshft;
  for (j = 0; j < na; j++) {
    if (shift[j] == (double)0.0) {
      ++nzero;
    }
    *ptr++ = fabs (shift[j]);
  }
  mainit = 0;
  while (1) {
    dsort (pshft, na, inds);
    ptr = gap;
    olgsft = log(*(pshft + *(inds + nzero)));
    for (j = nzero + 1; j < na; j++) {
      logsft = log(*(pshft + *(inds + nzero + j)));
      *ptr++ = logsft - olgsft;
      olgsft = logsft;
    }
    dsort (gap, na-1, indg);
    igap = 2;
    *ngap = nzero - 1;
    *(ngap + 1) = na - 1;
    for (j = na - 2; j >= nzero; j--) {
      jpos = *(indg + j);
      good_gap = 1;
      for (k = 0; k < igap; k++) {
	kgap = jpos - *(ngap + k);
	if (abs (kgap) < MINGRP) {
	  good_gap = 0;
	  break;
	}
      }
      if (good_gap) {
	*(ngap + igap) = jpos;
	igap++;
      }
    }
    *nxtgap = 1;
    *(nxtgap + 1) = 0;
    *(lengrp + 1) = na - nzero;
    for (j = 2; j < igap; j++) {
      jpos = *(ngap + j);
      mingr = na - nzero;
      mingl = na - nzero;
      for (k = 0; k < j; k++) {
	kgap = *(ngap + k) - jpos;
	if (kgap > 0) {
	  if (kgap < mingr) {
	    mingr = kgap;
	    nr = k;
	  }
	} else if (kgap < 0) {
	  if (-kgap < mingl) {
	    mingl = -kgap;
	    nl = k;
	  }
	}
      }
      *(lengrp + j) = mingl;
	    *(lengrp + nr) = mingr;
	    *(nxtgap + j) = nr;
	    *(nxtgap + nl) = j;
	    maxgap = 0;
	    for (k = 1; k <= j; k++) {
	      if (*(lengrp + k) > maxgap) {
		maxgap = *(lengrp + k);
	      }
	    }
	    if (maxgap <= MAXGRP) {
	      numgap = j+1;
	      break;
	    }
    }
    j = 0;
    do {
      j = *(nxtgap + j);
      jpos = *(ngap + j);
      ndim = *(lengrp + j);
      for (k = 0; k < ndim; k++) {
	lista[k] = *(inds + jpos - k);
	p[k] = pr[lista[k]];
	pgrp[k] = p[k];
	for (i = 0; i < ndim; i++) {
	  p[(k+1)*ndim + i] = pr[*(inds + jpos - i)];
	}
	p[(k+1)*ndim + k] += pshft[*(inds + jpos - k)];
      }
      for (k = 0; k < ndim; k++) {
	for (i = 0; i < ndim; i++) {
	  pr[lista[i]] = p[(k+1)*ndim + i];
	}
	y[k+1] = (*func)(pr);
      }
      if (!(simplx (p, y, ndim, pr, na, ftol, atol, lista, func, itmax, 
		    &iter, &ilo, &ihi))) {
	return (0);
      }
      for (k = 0; k < ndim; k++) {
	*(pshft + lista[k]) = fabs(p[ilo * ndim + k] - pgrp[k]);
	if (*(pshft + lista[k]) < tiny * fabs(shift[lista[k]])) {
	  *(pshft + lista[k]) = tiny * fabs(shift[lista[k]]);
	}
	pr[lista[k]] = p[ilo * ndim + k];
      }
      if (y[ihi] > fp) {
	fp = y[ihi];
      }
      y[0] = y[ilo];
    }
    while (j > 1);
    *fret = y[ilo];
    ++mainit;
    printf ("\n\nAfter iteration %6d       function = %12g\n", mainit, *fret);
    printf ("Point  ");
    for (j = 0; j < na; j++) {
      printf (" %12g ", pr[j]);
    }
    printf ("\nShifts ");
    for (j = 0; j < na; j++) {
      printf (" %12g ",*(pshft + j));
    }
    if (fabs (*fret - fp) * (double)2. <= ftol * (fabs(*fret) + fabs(fp))) {
      free(pshft);free(gap);free(inds);free(indg);free(nxtgap);free(ngap);free(lengrp);
      return (1);
    }
    if (*fret < atol) {
      free(pshft);free(gap);free(inds);free(indg);free(nxtgap);free(ngap);free(lengrp);
      return (2);
    }
    if (mainit == maxits) {
      free(pshft);free(gap);free(inds);free(indg);free(nxtgap);free(ngap);free(lengrp);
      return (3);
    }
    fp = *fret;
  }
}

int simplx (double *p, double *y, int ndim, double *pr, int na, double ftol, 
	    double atol, int *lista, double (*funk)(), int itmax, int *iter, 
	    int *ilo, int *ihi)
{
  static double alpha = 1.0, beta = 0.5, gamma = 2.0;

  double *pbar, *prr;
  double yprr, ypr;
  int inhi, mpts;
  int i, j;

  if (
      !(pbar = (double *) malloc (na * sizeof (double))) ||
      !(prr = (double *) malloc (na * sizeof (double)))
      ) {
    printf ("SIMPLX: Error - not enough memory\n");
    return (0);
  }
	
  mpts = ndim + 1;
  *iter = 0;
  while (1) {
    *ilo = 0;
    if (y[0] > y[1]) {
      *ihi = 0;
      inhi = 1;
    } else {
      *ihi = 1;
      inhi = 0;
    }
    for (i = 0; i < mpts; i++) {
      if (y[i] < y[*ilo]) {
	*ilo = i;
      }
      if (y[i] > y[*ihi]) {
	inhi = *ihi;
	*ihi = i;
      } else if (y[i] > y[inhi]) {
	if (i != *ihi) {
	  inhi = i;
	}
      }
    }
    if (fabs (y[*ihi] - y[*ilo]) * (double)2.0 <= ftol * (fabs(y[*ihi])
							  + fabs (y[*ilo]))) {
      free(pbar);free(prr);
      return (1);
    }
    if (y[*ilo] < atol) {
      free(pbar);free(prr);
      return (2);
    }
    if (*iter == itmax) {
      free(pbar);free(prr);
      return (3);
    }
    ++(*iter);
    for (j = 0; j < ndim; j++) {
      *(pbar + j) = (double) 0.0;
    }
    for (i = 0; i < mpts; i++) {
      if (i != *ihi) {
	for (j = 0; j < ndim; j++) {
	  *(pbar + j) += p[i*ndim + j];
	}
      }
    }
    for (j = 0; j < ndim; j++) {
      pbar[j] /= (double) ndim;
      pr[lista[j]] = *(pbar + j) * ((double)1.0 + alpha) - 
	alpha * p[*ihi*ndim + j];
    }
    for (j = 0; j < na; j++) {
      *(prr + j) = pr[j];

    }
    ypr = (*funk)(pr);
    if (ypr < y[*ilo]) {
      for (j = 0; j < ndim; j++) {
	*(prr + lista[j]) = pr[lista[j]] * gamma + 
	  *(pbar + j) * ((double)1.0 - gamma);
      }
      yprr = (*funk)(prr);
      if (yprr < y[*ilo]) {
	for (j = 0; j < ndim; j++) {
	  p[*ihi*ndim + j] = *(prr + lista[j]);
	}
	y[*ihi] = yprr;
      } else {
	for (j = 0; j < ndim; j++) {
	  p[*ihi*ndim + j] = pr[lista[j]];
	}
	y[*ihi] = ypr;
      }
    } else if (ypr >= y[inhi]) {
      if (ypr < y[*ihi]) {
	for (j = 0; j < ndim; j++) {
	  p[*ihi*ndim + j] = pr[lista[j]];
	}
	y[*ihi] = ypr;
      }
      for (j = 0; j < ndim; j++) {
	*(prr + lista[j]) = p[*ihi*ndim+ j] * beta + 
	  *(pbar + j) * ((double)1.0 - beta);
      }
      yprr = (*funk)(prr);
      if (yprr < y[*ihi]) {
	for (j = 0; j < ndim; j++) {
	  p[*ihi*ndim + j] = *(prr + lista[j]);
	}
	y[*ihi] = yprr;
      } else {
	for (i = 0; i < mpts; i++) {
	  if (i != *ilo) {
	    for (j = 0; j < ndim; j++) {
	      pr[lista[j]] = (p[i*ndim + j] + 
			      p[*ilo*ndim + j]) * (double)0.5;
			      p[i*ndim + j] = pr[lista[j]];
	    }
	    y[i] = (*funk)(pr);
	  }
	}
      }
    } else {
      for (j = 0; j < ndim; j++) {
	p[*ihi*ndim + j] = pr[lista[j]];
      }
      y[*ihi] = ypr;
    }
  }
}

static void dsort (double *x, int n, int *ind)
{

  int i, j, l;
  double q;
  int ir, itmp;

  for (i = 0; i < n; i++) {
    *(ind + i) = i;
  }
  if (n == 1) {
    return;
  }
  l = n / 2;
  ir = n - 1;
  while (1) {
    if (l > 0) {
      --l;
      itmp = *(ind + l);
      q = *(x + itmp);
    } else {
      itmp = *(ind + ir);
      q = *(x + itmp);
      *(ind + ir) = *ind;
      --ir;
      if (ir == 0) {
	*ind = itmp;
	return;
      }
    }
    i = l;
    j = l + l + 1;
    while (j <= ir) {
      if (j < ir) {
	if (*(x + *(ind + j)) < *(x + *(ind + j + 1))) {
	  ++j;
	}
      }
      if (q < *(x + *(ind + j))) {
	*(ind + i) = *(ind + j);
	i = j;
	j += j;
      } else {
	j = ir + 1;
      }
    }
      
    *(ind + i) = itmp;
  }
}

void FREPLX (double *pr, double *shift, int *na, double (*func)(), int *itmax, 
             int *maxits, double *ftol, double *atol, double *fret, int *iflag)
{
  *iflag = replex (pr, shift, *na, func, *itmax, *maxits, *ftol, *atol, fret);
}

void FSMPLX (double *p, double *y, int *na, double *ftol, double *atol, 
	     double (*funk)(), int *itmax, int *iter, int *iflag)
{
  double *pr;
  int *lista;
  int ndim = *na;
  int ilo, ihi, i;

  if (
      !(pr = (double *) malloc (ndim * sizeof (double))) ||
      !(lista = (int *) malloc (ndim * sizeof (int)))
      ) {
    printf ("FSMPLX: Error - not enough memory\n");
    *iflag = 0;
    return;
  }
  for (i = 0; i < ndim; i++) {
    *(pr + i) = *(p + i);
    *(lista + i) = i;
  }
  *iflag = simplx (p, y, ndim, pr, *na, *ftol, *atol, lista, funk, *itmax, 
		   iter, &ilo, &ihi);
  for (i = 0; i < ndim; i++) {
    *(p + i) = *(p + ilo * ndim + i);
  }
  free(pr);
  free(lista);
}
      

