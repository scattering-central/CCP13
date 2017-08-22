#include "fixcursor"
#include "fixmask"

#define MAXIMAGE 10
#define MAXCOLOR 256
#define STDDIM 512
#define MAGDIM 128
#define MAXVERTS 10
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define SWAP(a, b) (itemp = (a), (a) = (b), (b) = itemp)
 
extern Display           *UxDisplay;
extern int               UxScreen;

typedef struct
{
  int x, y;                                   /* Starting point in file space */
  int ipix, irast;                            /* Pixels and rasters in file space */
  int width, height;                          /* Width and height in image space */
  float scale;                                /* Scale factor for image to file space */
  unsigned char *pixelValues;                 /* Pixel values */
  unsigned long *pixelColours;                /* Pixel colours */
  unsigned long *magnifyColours;              /* Colours for magnify window */
  float tmin, tmax;                           /* Thresholds */
  int magx, magy;                             /* Centre of magnified region */
  XImage *pXimage1, *pXimage2;                /* XImage pointers */
} FixImage;

typedef struct _FixObject
{
  int number;
  float *xv, *yv;
  int points;
  char *type;
  float xc, yc;
  Boolean selected;
  struct _FixObject *pNext;
} FixObject;

typedef struct _FixLine
{
  int number;
  float xStart, yStart, xEnd, yEnd;
  float width;
  Boolean selected;
  struct _FixLine *pNext;
} FixLine;
 
typedef struct _FixScan
{
  int number;
  float xCentre, yCentre, xStart, yStart, xEnd, yEnd;
  Boolean selected;
  struct _FixScan *pNext;
} FixScan;
 
typedef struct _FixDrawnCircle
{
  float xCentre, yCentre, radius;
  struct _FixDrawnCircle *pNext;
} FixDrawnCircle;

typedef struct _FixDrawnRing
{
  float xCentre, yCentre, radius;
  struct _FixDrawnRing *pNext;
} FixDrawnRing;

typedef struct _FixDrawnCross
{
  float xCentre, yCentre;
  struct _FixDrawnCross *pNext;
} FixDrawnCross;

typedef struct _FixDrawnPoint
{
  float xCentre, yCentre;
  struct _FixDrawnPoint *pNext;
} FixDrawnPoint;

static GC                paintGC, drawGC, textGC, pointGC, actionGC;
static Colormap          cmap;
static FixImage          *xi[MAXIMAGE];
static XColor            colors[MAXCOLOR];
static XColor            black, white, red, blue, green, yellow;
static Cursor            cursorPoint, cursorBox, cursorPoly;
static Visual            *visual;
static Region            area1Region;
static int NColor;
static int NColorAlloc;
static unsigned long pixcol[MAXCOLOR];
static int screen;
static int depth;
static int bitmap_pad;
static int bits_per_pixel;
static int magnification;
static int pointWidth;
static Boolean interpolation;
static Boolean logarithmic;
static Boolean setMagnify;
static Boolean showPoints;
static int currentImage, totalImages, totalObjects, totalLines, totalScans;
static int fontWidth, fontHeight, fontAscent, fontDescent;
static FixObject *pFirstObject;
static FixLine *pFirstLine;
static FixScan *pFirstScan;
static FixDrawnCircle *pFirstDrawnCircle;
static FixDrawnCross *pFirstDrawnCross;
static FixDrawnPoint *pFirstDrawnPoint;
static FixDrawnRing *pFirstDrawnRing;
static char textBuf[256];

static int client_order;
static int server_order;

FixObject *CreateFixObject (float *, float *, int, char *);
void DestroyObject (FixObject *);
void DestroyAllObjects ();
void CentreObject (FixObject *);
void CentreSector (FixObject *);
int CreateObjectItem (FixObject *);
void DestroyObjectPos (int);
void MarkObjects (int, int, int);
void DrawObjects ();
void MarkObjectsOnDrawable (int, int, int, Drawable);
void DrawObjectsOnDrawable (Drawable);
void RepaintOverObjectMarkers ();
void renumberObjects ();

void ListSelectedItems (Widget);
void ListRangesOfSelectedItems (Widget);

FixLine *CreateFixLine (float, float, float, float, float);
void DestroyLine (FixLine *);
void DestroyAllLines ();
int CreateLineItem (FixLine *);
void DestroyLinePos (int);
void MarkLines (int, int, int);
void DrawLines ();
void MarkLinesOnDrawable (int, int, int, Drawable);
void DrawLinesOnDrawable (Drawable);
void RepaintOverLineMarkers ();
void renumberLines ();

FixScan *CreateFixScan (float *, float *);
void DestroyScan (FixScan *);
void DestroyAllScans ();
int CreateScanItem (FixScan *);
void DestroyScanPos (int);
void MarkScans (int, int, int);
void DrawScans ();
void MarkScansOnDrawable (int, int, int, Drawable);
void DrawScansOnDrawable (Drawable);
void RepaintOverScanMarkers ();
void renumberScans ();

FixDrawnCircle *CreateFixDrawnCircle (float, float, float);
void DestroyDrawnCircles ();
void DrawDrawnCircles (Drawable);

FixDrawnRing *CreateFixDrawnRing (float, float, float);
void DestroyDrawnRings ();
void DrawDrawnRings (Drawable);
void RepaintOverDrawnRings ();

FixDrawnCross *CreateFixDrawnCross (float, float);
void DestroyDrawnCrosses ();
void DrawDrawnCrosses (Drawable);

FixDrawnPoint *CreateFixDrawnPoint (float, float);
void DestroyDrawnPoints ();
void DrawDrawnPoints (Drawable);
void RepaintOverDrawnPoints ();

void InitGraphics ();
void ScaleLinear (FixImage *);
void ScaleLog (FixImage *);
void GreyScale ();
void ColourPalette1 ();
void ColourPalette2 ();
void ColourPalette3 ();
void ColourPalette4 ();
void ColourPalette5 ();
void InvertPalette ();

FixImage *CreateFixImage (int, int, int, int);
float Interpolate (FixImage *, float, float);
void ImageToFileCoords (float, float, FixImage *, float *, float *);
void FileToImageCoords (float, float, FixImage *, int *, int *);
void MagToImageCoords (int, int, FixImage *, float *, float *);
void LoadImage (FixImage *);
void CloseImage (FixImage *);
void CloseAllImages ();
void Magnify (FixImage *);
void UpdateXYLabels (int, int, float);
void RefreshImage (Widget, XEvent *, XImage *);

void ProcessPoint1 (Widget, XEvent *);
void ProcessPoint2 (Widget, XEvent *);
void TrackArea2 (Widget, XEvent *);
void UpdateArea2 (Widget, XEvent *);
void Refresh1 (Widget, XEvent *);
void Refresh2 (Widget, XEvent *);
void ProcessLine1 (int, int, int, int, int);
void ProcessRect1 (int, int, int, int);
void ProcessPoly1 (int *, int *, int);
void ProcessSector1 (int, int, int, int);
void ProcessLine2 (int, int, int, int, int);
void ProcessRect2 (int, int, int, int);
void ProcessPoly2 (int *, int *, int);
void ProcessBox1 (int, int, int, int);

void DrawPlus (Display *, Window, GC, int *, int *, int, int);
void DrawCross (Display *, Window, GC, int *, int *, int, int);
void DrawLine (Display *, Window, GC, int, int, int, int, int);
void DrawCircle (Display *, Window, GC, int, int, int, int, int);
void DrawSector (Display *, Window, GC, int, int, int, int, int, int);

void FixDrawCross (float, float, Drawable);
void FixDrawCircle (float, float, float, Drawable);
void FixDrawRing (float, float, float, Drawable);
void FixDrawPoint (float, float, Drawable);

void fpoint (int, int, int, int, int, int ,int, XPoint *);
int fwidth (int, int, int, int, int, int);
void pswrite (char *, XImage *);
void psout (char *);
