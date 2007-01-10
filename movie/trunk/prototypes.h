/*                                      
   Program    :    Movie 
   FileName   :    prototypes.h
   Author     :    Written By L.Hudson.
 */        

#include <stdio.h>

#ifndef _HEADERS_
#define _HEADERS_

     static double maxarg1,maxarg2;
     #define FMAX(a,b) (maxarg1=(a),maxarg2=(b),(maxarg1) > (maxarg2) ?\
		   (maxarg1) : (maxarg2))

     #define SIGN(a,b) ((b) >= 0.0 ? fabs(a) : -fabs(a))
     static double sqrarg;
     #define SQR(a) ((sqrarg=(a)) == 0.0 ? 0.0 : sqrarg*sqrarg)
     #define CUBE(a) ((sqrarg=(a)) == 0.0 ? 0.0 : sqrarg*sqrarg*sqrarg)

     void amebsa(double **p, double y[], int ndim, double pb[], double *yb,double ftol,
		 double (*funk)(double []), int *iter, double temptr);
     void amoeba(double **p, double y[], int ndim, double ftol,double (*funk)(double []),
		 int *iter);
     double amotry(double **p, double y[], double psum[], int ndim,double (*funk)(double []),
		   int ihi, double fac);
     double amotsa(double **p, double y[], double psum[], int ndim, double pb[],double *yb,
		   double (*funk)(double []), int ihi, double *yhi, double fac);
     double brent(double ax, double bx, double cx,double (*f)(double), double tol, double *xmin);
     double f1dim(double x);
     void linmin(double p[], double xi[], int n, double *fret,double (*func)(double []));
     void mnbrak(double *ax, double *bx, double *cx, double *fa, double *fb,double *fc,
		 double (*func)(double));
     void powell(double p[], double **xi, int n, double ftol, int *iter, double *fret,
		 double (*func)(double []));
     double ran1(long *idum);
     void correl(double x[], double y[], unsigned long n, double *r);
     void wcorrel(double x[], double y[], double sd[], unsigned long n, double *r); 
#endif
     
#ifndef _NRUTILS_
#define _NRUTILS_
     double  *dvector(long nl, long nh);
     int  *ivector(long nl, long nh);
     char  *cvector(long nl, long nh);
     struct Search_Range *datavector(long nl,long nh);
     double  **dmatrix(long nrl, long nrh, long ncl, long nch);
     struct Search_Range **datamatrix(long nrl, long nrh, long ncl, long nch);
     float ***f3tensor();
     double ***d3tensor();
     int     **imatrix(long nrl, long nrh, long ncl, long nch);
     char    **cmatrix(long nrl, long nrh, long ncl, long nch);
     void    free_dvector(double *v, long nl, long nh);
     void    free_ivector(int *v, long nl, long nh);
     void    free_cvector(char *v, long nl, long nh);
     void	free_datavector(struct Search_Range *v, long nl, long nh);
     void    free_dmatrix(double **m, long nrl, long nrh, long ncl, long nch);
     void	free_datamatrix(struct Search_Range **m,long nrl, long nrh, long ncl, long nch);
     void    free_imatrix(int **m, long nrl, long nrh, long ncl, long nch);
     void    free_cmatrix(char **m, long nrl, long nrh, long ncl, long nch);
     void    free_d3tensor(double ***t, long nrl, long nrh, long ncl, long nch,
			   long ndl, long ndh);
     void free_f3tensor(float ***t, long nrl, long nrh, long ncl, long nch,
			long ndl, long ndh);
     double bessj0(double x);
     double bessj1(double x);
     double bessj(int n, double x);
#endif

     void Reset_Myosin_Start(void);
     void Reset_Titin_Start(void);
     void Reset_C_Protein_Start(void);
     void Reset_Tropomyosin_Start(void);
     void Reset_Actin_Start(void);
     void Output();
     void Fourier_Calculation();
     void Finish();
     int Dimension (double *, double *);
     void subcommand(char **,int *,int *,char *,int *,char **,double [],int *,int *,
		     double *,double *,double *,double *,int *,int,int *);
     void comment(char **,int *,int *,char *,int *,char **,double [],int,int *);
     void shell(char **,int *,int *,char *,int *,char **,double [],int,int *);
     int rdcomc (FILE *, FILE *,char **, int *, double *, int *, int *, int, int);
     int optcmp (char *, char **);
     int upc (char *);
     int Legal( FILE *);
     int Check_Val(int *);
     int Check_Char(int *, int *);
     int Bounds(int, int);
     void Status(FILE *);
     void Copyright( int );
     void Write_Status();
     void Correlation();
     void WCrystal();
     void WLeast_SQR();
     void Crystal();
     void Least_SQR();
     void View_Output();
     void Myosin_Global_Search();
     void C_Protein_Global_Search();
     void Titin_Global_Search();
     void BackBone_Global_Search();
     void Set_Myosin_Vals();
     void Set_C_Protein_Vals();
     void Set_Titin_Vals();
     void Set_Initial_Vals();
     void Set_Actin_Vals();
     void Set_BackBone_Vals();
     void Set_Tropomyosin_Vals();
     void Trans_Myosin_Coords();
     void Trans_C_Protein_Coords();
     void Trans_Titin_Coords();
     void Trans_Actin_Coords();
     void Trans_Tropomyosin_Coords();
     void Trans_BackBone_Coords();
     void Output();
     void Fourier_Calculation();
     void Simplex();
     void Torus();
     void Replex();
     void Powell();
     void Anneal();
     void Copyright( int );
     void Parse(FILE *,FILE *);
     void Load_Intensity(void);
     void Initialization(void);
     void Process_Data(void);
     void CleanUp(void);
     void Reset(void);
     void Load_MCoords(void);
     void Load_BrookMCoords(void);
     void Load_BCoords(void);
     void Reset_Search(void);
     void Reset_Simul(void);
     void Reset_Molecule(void);
     void Alloc_Myosin(void);
     void Alloc_Titin(void);
     void Alloc_C_Protein(void);
     void Alloc_BackBone(void);
     void Alloc_Tropomyosin(void);
     void Alloc_Actin(void);
     int Alloc_Mem_Myosin(void);
     int Alloc_Mem_Titin(void);
     int Alloc_Mem_C_Protein(void);
     int Alloc_Mem_BackBone(void);
     int Alloc_Mem_Actin(void);
     int Alloc_Mem_Tropomyosin(void);
     void Zero_Tropomyosin_Mem(void);
     void Zero_Actin_Mem(void);
     void Zero_Myosin_Mem(void);
     void Zero_Titin_Mem(void);
     void Zero_C_Protein_Mem(void);
     void Zero_BackBone_Mem(void);
     int Iterations(void);
     void nrerror(char error_text[]);
     void Field_File(FILE *,char *,int,char *);
     void Get_Data_Mem(void);
     void Zero_Data_Mem(void);
     void Load_Intensity_Data(void);
     void Generate_Intensity_Params(void);
     void Set_Data_Mem(void);
     void Generate_Bessel_Orders(void);
     void Generate_Bessel_Table(void);

     int torus (char *, double *, double *, double *, double (*)(), char *, double *,
		int, Torus_Input *);
     void FTORUS (int *, double *, double *, double *, double (*)(), int *, double *,
		  int *, double *, int *, int *, double *, int *, int *, double *,
		  double *, double *, int *);

     int replex (double *, double *, int, double (*)(), int, int, double, double, 
		 double *);
     int simplx (double *, double *, int, double *, int, double, double, int *, 
		 double (*)(), int, int *, int *, int *);
     void FREPLX (double *, double *, int *, double (*)(), int *, int *, double *, 
		  double *, double *, int *);
     void FSMPLX (double *, double *, int *, double *, double *, double (*)(),
		  int *, int *, int *);

     
