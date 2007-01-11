/*******************************************************************************
 *                                   fplex.c                                   *
 *******************************************************************************
 Purpose: Partition parameter groups for downhill-simplex refinement
 Author:  R.C.Denny
 Returns: Tests for the return value are performed in the following order:
          0  -  Error allocating memory
          1  -  Fractional error less than FTOL
          2  -  Absolute function value less than ATOL
          3  -  Maximum number of iterations reached without convergence
 Updates: 
 06/07/95 RCD Initial implementation

*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "fplex.h"

static void dsort (float *, int, int *);

int freplex (float *const pr, float *const shift, int na, float (*const func)(), 
             int itmax, int maxits, float ftol, float atol, float *const fret)
{
    /* Initialized data */

    static float tiny = (float) 1e-15;

    /* Local variables */

    float pgrp[MAXGRP], p[(MAXGRP+1)*MAXGRP], y[MAXGRP+1]; 
    int lista[MAXGRP];
    float *pshft, *gap, *ptr;
    int *indg, *inds, *ngap, *nxtgap, *lengrp;
    int jpos, igap, kgap, iter, good_gap;
    int i, j, k;
    int mingl, mingr;
    int nzero, ndim;
    int nl, nr, maxgap, mainit;
    int  numgap;
    int ihi, ilo;
    float logsft, olgsft;
    float fp;

    /* Memory allocation */

    if (
	!(pshft = (float *) malloc (na * sizeof (float))) ||
	!(gap = (float *) malloc ((na - 1) * sizeof (float))) ||
	!(inds = (int *) malloc (na * sizeof (int))) ||
	!(indg = (int *) malloc ((na - 1) * sizeof (int))) ||
	!(ngap = (int *) malloc ((na + 1) * sizeof (int))) ||
	!(nxtgap = (int *) malloc ((na/MINGRP + 1) * sizeof (int))) ||
	!(lengrp = (int *) malloc ((na/MINGRP + 1) * sizeof (int)))
	) 
    {
        free(pshft);free(gap);free(inds);free(indg);free(nxtgap);free(ngap);free
(lengrp);
        printf ("REPLEX: Error - not enough memory\n");
	return (0);
    }

    /* Function Body */

    y[0] = (*func)(pr);
    fp = y[0];

#ifdef DEBUG
    printf ("Start of downhill simplex: function = %12g\n", fp);
    printf ("Point  ");
    for (j = 0; j < na; j++) {
        printf (" %12g ", pr[j]);
    }
#endif

/* ========Find number of zero shifts */

    nzero = 0;
    for (j = 0; j < na; j++) {
	if (shift[j] == (float) 0.0) {
	    ++nzero;
	} ptr = pshft;
	*(pshft + j) = fabs (shift[j]);
    }
    if (nzero == na) {
        free(pshft);free(gap);free(inds);free(indg);free(nxtgap);free(ngap);free
(lengrp);
        printf ("REPLEX: Warning - no non-zero shifts\n");
        return (0);
    }

/* ========Start main loop */

    mainit = 0;
    while (1) {
/* ========Sort shifts on magnitude into ascending order */

        dsort (pshft, na, inds);

/* ========Find gaps in distribution of shifts and sort */

	olgsft = log(*(pshft + *(inds + nzero)));
	for (j = nzero + 1; j < na; j++) {
	    logsft = log(*(pshft + *(inds + j)));
	    *(gap + j - nzero - 1) = logsft - olgsft;
	    olgsft = logsft;   
	}

/* ========Allow gaps which satisfy minimum group size. Put in */
/* ========biggest gaps first */

	igap = 2;
	*ngap = nzero - 1;
	*(ngap + 1) = na - 1;
	if (na - nzero >= 2*MINGRP) {
	  
	  dsort (gap, (na - nzero - 1), indg);

	  for (j = na - nzero - 2; j >= 0; j--) {
	    jpos = *(indg + j) + nzero;
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
	}

/* ========Loop over gaps to find the minimum number that satisfies */
/* ========the maximum limit on group size */

	*nxtgap = 1;
	*(nxtgap + 1) = 0;
	*lengrp = na - nzero;
	*(lengrp + 1) = 0;
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
	    *(lengrp + j) = mingr;
	    *(lengrp + nl) = mingl;
	    *(nxtgap + j) = nr;
	    *(nxtgap + nl) = j;

	    maxgap = 0;
	    for (k = 0; k <= j; k++) {
	        if (*(lengrp + k) > maxgap) {
		    maxgap = *(lengrp + k);
		}
	    }
	    if (maxgap <= MAXGRP) {
	      /*    numgap = j+1;   */
		break;
	    }
	}

/* ========Group parameters w.r.t. the magnitude of their shifts */
/* ========Refine parameter groups with smallest shifts first */

	j = 0;
	do {
	    jpos = *(ngap + j);
	    ndim = *(lengrp + j);	    for (k = 0; k < ndim; k++) {
	        lista[k] = *(inds + jpos + k + 1);
		p[k] = pr[lista[k]];
		pgrp[k] = p[k];
		for (i = 0; i < ndim; i++) {
		    p[(k+1)*ndim + i] = pr[*(inds + jpos + i + 1)];
		}
		p[(k+1)*ndim + k] += pshft[lista[k]];
	    }
	    for (k = 0; k < ndim; k++) {
	        for (i = 0; i < ndim; i++) {
		    pr[lista[i]] = p[(k+1)*ndim + i];
		}
		y[k+1] = (*func)(pr);
	    }
	    if (!(fsimplex (p, y, ndim, pr, na, ftol, atol, lista, func, itmax, 
			    &iter, &ilo, &ihi)))
	    {
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
	while ((j = *(nxtgap + j)) > 1);

/* ========Check termination criteria */

	*fret = y[ilo];
	++mainit;

#ifdef DEBUG
	printf ("\n\nAfter iteration %6d       function = %12g\n", mainit, *fret);
	printf ("Point  ");
	for (j = 0; j < na; j++) {
	    printf (" %12g ", pr[j]);
	}
	printf ("\nShifts ");
	for (j = 0; j < na; j++) {
	    printf (" %12g ",*(pshft + j));
	}
#endif

	if (fabs (*fret - fp) * (float)2. <= ftol * (fabs(*fret) + fabs(fp))) {
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

} /* freplex */

int fsimplex (float *const p, float *const y, int ndim, float *const pr, int na, 
	      float ftol, float atol, int *const lista, float (*const funk)(), int itmax, 
	      int *const iter, int *const ilo, int *const ihi)
{

    /* Initialized data */

    static float alpha = 1.0, beta = 0.5, gamma = 2.0;

    /* Local variables */

    float *pbar, *prr;
    float yprr, ypr;
    int inhi, mpts;
    int i, j;

    /* Memory allocation */

    if (
	!(pbar = (float *) malloc (na * sizeof (float))) ||
	!(prr = (float *) malloc (na * sizeof (float)))
       )
    {
        printf ("SIMPLX: Error - not enough memory\n");
	return (0);
    }
	
    /* Function Body */

    mpts = ndim + 1;
    *iter = 0;

    while (1) {
        *ilo = 0;

/* ========Find which point is highest, second and lowest */

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

/* ========Calculate maximum fractional difference of simplex */
/* ========Return if convergence has been achieved */

	if (fabs (y[*ihi] - y[*ilo]) * (float)2.0 <= ftol * (fabs(y[*ihi])
	    + fabs (y[*ilo]))) {
	    free(pbar);free(prr);
	    return (1);
	}

/* ========Check lowest point against absolute function tolerance */

	if (y[*ilo] < atol) {
	    free(pbar);free(prr);
	    return (2);
	}

/* ========Return if maximum number of iterations have been performed */

	if (*iter == itmax) {
	    free(pbar);free(prr);
	    return (3);
	}

	++(*iter);

	for (j = 0; j < ndim; j++) {
	    *(pbar + j) = (float) 0.0;
	}

/* ========Calculate centre of face opposing high point */

	for (i = 0; i < mpts; i++) {
	    if (i != *ihi) {
	        for (j = 0; j < ndim; j++) {
		    *(pbar + j) += p[i*ndim + j];
		}
	    }
	}

/* ========Reflect the simplex */

	for (j = 0; j < ndim; j++) {
	    pbar[j] /= (float) ndim;
	    pr[lista[j]] = *(pbar + j) * ((float)1.0 + alpha) - 
	                   alpha * p[*ihi*ndim + j];
	}

/* ========Copy reflected point into PRR */

	for (j = 0; j < na; j++) {
	    *(prr + j) = pr[j];

	}

/* ========Evaluate function at reflected point */

	ypr = (*funk)(pr);
	if (ypr < y[*ilo]) {
	    for (j = 0; j < ndim; j++) {
	        *(prr + lista[j]) = pr[lista[j]] * gamma + 
		                    *(pbar + j) * ((float)1.0 - gamma);
	    }

/* ========Try additional extrapolation */

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

/* ========Check the worst reflected point */

	} else if (ypr >= y[inhi]) {

	    if (ypr < y[*ihi]) {
	        for (j = 0; j < ndim; j++) {
		    p[*ihi*ndim + j] = pr[lista[j]];
		}
		y[*ihi] = ypr;
	    }

/* ========Contract in each dimension */

	    for (j = 0; j < ndim; j++) {
	        *(prr + lista[j]) = p[*ihi*ndim+ j] * beta + 
		                    *(pbar + j) * ((float)1.0 - beta);
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
                                           p[*ilo*ndim + j]) * (float)0.5;
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

} /* fsimplex */

static void dsort (float *const x, int n, int *const ind)

/* Purpose: Sorts an array *x returning it unchanged but with an index */
/*          array *ind. */

{

    /* Local variables */
    int i, j, l;
    float q;
    int ir, itmp;

    /* Function Body */

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
} /* dsort */


void FREPLX (float *const pr, float *const shift, int *const na, float (*const func)(), 
	     int *const itmax, int *const maxits, float *const ftol, float *const atol, 
	     float *const fret, int *const iflag)
{
    *iflag = freplex (pr, shift, *na, func, *itmax, *maxits, *ftol, *atol, fret);
}


void FSMPLX (float *const p, float *const y, int *const na, float *const ftol, 
	     float *const atol, float (*const funk)(), int *const itmax, int *const iter, 
	     int *const iflag)
{
    float *pr;
    int *lista;
    int ndim = *na;
    int ilo, ihi, i;

    if (
	!(pr = (float *) malloc (ndim * sizeof (float))) ||
	!(lista = (int *) malloc (ndim * sizeof (int)))
	)
    {
        printf ("FSMPLX: Error - not enough memory\n");
	*iflag = 0;
	return;
    }

    for (i = 0; i < ndim; i++)
    {
        *(pr + i) = *(p + i);
	*(lista + i) = i;
    }

    *iflag = fsimplex (p, y, ndim, pr, *na, *ftol, *atol, lista, funk, *itmax, 
		       iter, &ilo, &ihi);
    
    for (i = 0; i < ndim; i++)
    {
        *(p + i) = *(p + ilo * ndim + i);
    }
    
    free(pr);
    free(lista);
}
      






