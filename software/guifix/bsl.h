#ifndef _bsl_header_
#define _bsl_header_

#define BSLERR	-1
#define BSLOK	0
#define FALSE	0
#define TRUE	!FALSE
#define YES	1
#define NO	0

#define  FLOAT     0
#define  CHAR      1
#define  UCHAR     2
#define  SHORT16   3
#define  USHORT16  4
#define  LONG32    5
#define  ULONG32   6

#define  BIG_ENDIAN     0
#define  LITTLE_ENDIAN  1

#define LPR	"lpr"

#define MAX(a, b) ((a) > (b) ? (a) : (b)) 
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define NINT(a)   ((int)((a) + ((a) > 0.0 ? 0.5 : -0.5)))

typedef struct {
    int type;
    int first_frame;
    int last_frame;
    int frame_increment;
    int frame_count;
    int pixels;
    int rasters;
    int frames;
} BslImage;

typedef struct {
    char *header_file;
    int first_file;
    int last_file;
    int file_increment;
    int file_count;
    BslImage bslimage;
} BslFile;

#endif

/* bsl funcs header file */

/*
 
#ifndef _bsl_funcs_
#define _bsl_funcs_

typedef struct {
    char *instruction;
    void (*function) ();
} COMMANDS;

extern void zero (), display (), pack (), expon (), logthm (), maxval ();
extern void power (), sum (), divcon (), addcon (), mulcon (), average ();
extern void mirror (), add (), multiply (), divide (), shift (), radii ();
extern void gaussian (), merge (), addnrm (), subnrm () , divnrm (), mulnrm ();
extern void transpose (), windo (), deglitch (), mask (), fft(), ift (), convolve ();
extern void rotate (), cut (), prmass (), verint (), horint (), integ ();
extern void addfil (), divfil (), mulfil (), imprint (), prtval (), dupe ();
extern void histogram ();

extern void upcase (), errmsg ();
extern char *GetString ();

static COMMANDS command [] = {
    {".ADC", addcon},	{".ADD", add},		{".ADN", addnrm},
    {".ARG", display},	{".ASF", addfil},	{".AVE", average},
    {".CNV", convolve},
    {".CUT", cut},	{".DGL", deglitch},
    {".DIC", divcon},
    {".DIN", divnrm},	{".DIS", display},	{".DIV", divide},
    {".DSF", divfil},	{".DUP", dupe},		{".EXP", expon},
    {".FFT", fft},
    {".GAU", gaussian},	{".HIS", histogram},	{".HOR", horint},
    {".IFT", ift},	{".INT", integ},	{".LOG", logthm},
    {".LPR", imprint},	{".MAX", maxval},	{".MIR", mirror},
    {".MRG", merge},	{".MSF", mulfil},
    {".MSK", mask},
    {".MUC", mulcon},	{".MUL", multiply},	{".MUN", mulnrm},
    {".PAK", pack},	{".POW", power},	{".PRM", prmass},
    {".PRT", prtval},	{".RAD", radii},	{".REM", dupe},
    {".ROT", rotate},
    {".SHF", shift},	{".SUM", sum},		{".SUN", subnrm},
    {".TRN", transpose},{".VER", verint},
    {".WIN", windo},	{".ZER", zero},
    {NULL,   NULL}
};

#endif

*/

#ifndef _bsl_proto_
#define _bsl_proto_

int ReadFrame (int, int, int, int, void**);
void swabshort (void *, int);
void swablong  (void *, int);
int endian ();

#endif
