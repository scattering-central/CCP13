// xconvDlg.cpp : implementation file
//

#include "stdafx.h"
#include "xconv.h"
#include "xconvDlg.h"
#include <string.h>



#include<iostream>
using namespace std;


#ifdef _DEBUG
#define new DEBUG_NEW
#endif
extern void Mainw( CString ,CString ,CString,CString ,CString ,int ,int, int,int,int,int,int,int\
				  ,float,float,	int,int  );
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// CxconvDlg dialog



CxconvDlg::CxconvDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CxconvDlg::IDD, pParent)
	, InFileName(_T(""))
	, OutFileName(_T(""))
	, aspectratio(1.0)
	, first(1)
	, last(1)
	, inc(1)
	, Headbyte(0)
	//,outFileType("bsl_out")
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CxconvDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_INFILE, InFileName);
	DDX_Text(pDX, IDC_OUTFILE, OutFileName);
	DDX_Control(pDX, IDC_INFILETYPE, InFileType);
	DDX_Control(pDX, IDC_OUTTYPE, OutType);
	DDX_Text(pDX, IDC_ASPECT, aspectratio);
	DDX_Control(pDX, IDC_COMBO1, Dtype);
	DDX_Control(pDX, IDC_FIRST, Cfirst);
	DDX_Control(pDX, IDC_CHECK1, swapbyte);
	DDX_Control(pDX, IDC_LAST, Clast);
	DDX_Control(pDX, IDC_INC, Cinc);
	DDX_Control(pDX, IDC_INPIX, Cinpix);
	DDX_Control(pDX, IDC_OUTPIX, OutPix);
	DDX_Control(pDX, IDC_OUTRAST, OutRast);
	DDX_Text(pDX, IDC_FIRST, first);
	DDX_Text(pDX, IDC_LAST, last);
	DDX_Text(pDX, IDC_INC, inc);
	DDX_Control(pDX, IDC_INRAST, Cinrast);
	DDX_Control(pDX, IDC_HEADBYTE, Cheadbyte);
	DDV_MinMaxInt(pDX, Headbyte, 0, 10000000);
	DDX_Control(pDX, IDC_ASPECT, Caspect);
	DDX_Control(pDX, IDC_DYNAMIC, Cdynamic);
	DDX_Control(pDX, IDC_HEAD1, Chead1);
	DDX_Control(pDX, IDC_HEAD2, Chead2);
}

BEGIN_MESSAGE_MAP(CxconvDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_CBN_SELCHANGE(IDC_INFILETYPE, OnCbnSelchangeInfiletype)
	ON_EN_CHANGE(IDC_INFILE, OnEnChangeInfile)
	ON_BN_CLICKED(IDC_BROWES2, OnBnClickedBrowes2)
	ON_BN_CLICKED(IDC_RUN, OnBnClickedRun)
	ON_BN_CLICKED(IDC_BROWSEIN, OnBnClickedBrowsein)
	ON_EN_CHANGE(IDC_OUTFILE, OnEnChangeOutfile)
	
	ON_CBN_SELCHANGE(IDC_COMBO1, OnCbnSelchangeCombo1)
	ON_CBN_SELCHANGE(IDC_OUTTYPE, OnCbnSelchangeOuttype)
	ON_EN_CHANGE(IDC_FIRST, OnEnChangeFirst)
	ON_EN_CHANGE(IDC_LAST, OnEnChangeLast)
	ON_EN_CHANGE(IDC_INC, OnEnChangeInc)
	ON_BN_CLICKED(IDHELP, OnBnClickedHelp)
	ON_BN_CLICKED(IDC_About, OnBnClickedAbout)
END_MESSAGE_MAP()


// CxconvDlg message handlers

BOOL CxconvDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}
	
	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	InFileType.SetCurSel(3);
	OutType.SetCurSel(0);
	Dtype.SetCurSel(0);
	Cheadbyte.SetWindowText("0");
	outdtype=0;
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CxconvDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CxconvDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
		
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CxconvDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}



void CxconvDlg::OnCbnSelchangeInfiletype()
{
	UpdateData(true);
	FieldsEditable( );
	UpdateData(false);
}

void CxconvDlg::OnEnChangeInfile()
{
	UpdateData(true);
  	ChangeInfile();
	UpdateData(false);
	
}
 
void CxconvDlg::OnBnClickedBrowes2()
{
   UpdateData(TRUE);
   CFileDialog fileDlg (FALSE, "", "",
      OFN_FILEMUSTEXIST| OFN_HIDEREADONLY, "BSL Files (*000.****)|*000.*|TiffFiles (*.tif)|*.tif|TxtFiles (*.txt)|*.txt|All Files (*.*)|*.*||", this);
      if( fileDlg.DoModal ()==IDOK )
   {
       CString pathName = fileDlg.GetPathName();
       OutFileName.Format("%s",pathName);
	     
   }
  
	UpdateData(FALSE);

}


void CxconvDlg::OnBnClickedBrowsein()
{
	 UpdateData(TRUE);
   CFileDialog fileDlg (TRUE, "", "",
      OFN_FILEMUSTEXIST| OFN_HIDEREADONLY, "All Files (*.*)|*.*|TiffFiles (*.tif)|*.tif|BSL Files (*000.***)|*000.*||", this);
      if( fileDlg.DoModal ()==IDOK )
   {
     CString pathName = fileDlg.GetPathName();
      InFileName.Format("%s",pathName);
	  this->outFileType.SetString("tif");
	   outFieldsEditable();
	}
	ChangeInfile();
  	UpdateData(FALSE);
}

void CxconvDlg::ChangeInfile()
{
	if (strchr( InFileName, '#')||strchr( InFileName, '%'))
	  {
		  Cfirst.SetReadOnly(false);
		  Clast.SetReadOnly(false);
		  Cinc.SetReadOnly(false);
	  }
	  else
	  {	 
		  Cfirst.SetReadOnly(true);
	      Clast.SetReadOnly(true);
		  Cinc.SetReadOnly(true);
		  first=1;
		  last=1;
		  inc=1;
	  }

   
	char *sptr;
	int i,ilen;
	sptr=InFileName.GetBuffer();
	ilen=(int)strlen(sptr);

	for(i=0;i<ilen;i++)
	{
	  if(strstr(sptr,".tif")!=NULL||strstr(sptr,".tiff")!=NULL||strstr(sptr,".TIF")!=NULL)
	  {
		  InFileType.SetCurSel(12);  
	       break;
       }
	if(strstr(sptr,".mar1200")!=NULL||strstr(sptr,".mar1600")!=NULL||strstr(sptr,".mar1800")!=NULL||\
	strstr(sptr,".mar2400")!=NULL||strstr(sptr,".mar2000")!=NULL||strstr(sptr,".mar3000")!=NULL||\
	strstr(sptr,".mar2300")!=NULL||strstr(sptr,".mar3450")!=NULL)
	  {
	    InFileType.SetCurSel(20); 
	       break;
	  }
        if(strstr(sptr,".smv")!=NULL||strstr(sptr,".SMV")!=NULL)
	  {
	   InFileType.SetCurSel(17); 
	   	    break;
	  }
	if(strstr(sptr,".Q")!=NULL||strstr(sptr,".QQ")!=NULL)
	  {
	    InFileType.SetCurSel(15); 
	     break;

	  }
	if(strstr(sptr,".LQA")!=NULL)
	  {
	    InFileType.SetCurSel(16); 
	    break;
	  }
        if(strstr(sptr,".gfrm")!=NULL)
	  {
	   InFileType.SetCurSel(19); 
	     break;
	  }
	
	if(strstr(sptr,".osc")!=NULL)
	  {
	   InFileType.SetCurSel(9); 
	   break;
	  }
	if(Legalbslname(InFileName))//strstr(sptr,"000.")!=NULL)
	  {
	    InFileType.SetCurSel(13); 
	    break;
	  }
	 sptr++;
	}
FieldsEditable( );

}

void CxconvDlg::OnBnClickedRun()
{   
	

    if(GetParams())
	{
		InFileType.GetWindowText(InputFileType);
        Mainw( OutFileName, InFileName,Head1,Head2,InputFileType \
			,InPixel,InRast, Swap,nOutPix, nOutRast,first,last,inc, aspectratio,
			dynamicrange, Headbyte,outdtype);

   	}
	UpdateData(FALSE);
}
bool CxconvDlg::Legalbslname(CString FileName )
{
   char *fptr, *sptr;
 
    fptr=FileName.GetBuffer();
    sptr=strrchr(fptr,'\\');
    if(sptr!=NULL)
	{
	  fptr=++sptr;
	}
 
	/*if(strlen(fptr)!=10)
	{
	  return(FALSE);
	}*/

	if(   isalnum((int)fptr[0])
		&& isdigit((int)fptr[1])
		&& isdigit((int)fptr[2]))
	{
	  if (strstr(fptr,"000.")!=fptr+3)
	  {
	    return(FALSE);
	  }
	}
	else
	{
	  return(FALSE);
	}

	if(isalnum((int)fptr[7]) && isalnum((int)fptr[8]) && isalnum((int)fptr[9]))
	{
	  return(TRUE);
	}
	else
	{
	  return(FALSE);
	}
}

int CxconvDlg::GetParams()
{
	CString tmp;
	char *sptr;
	int i,iflag;
	// **********************************************************************
	// Check that input files have been specified
	// **********************************************************************
  
   if(InFileName.GetLength()==0)
	{
	  AfxMessageBox("Input file not specified");
	  return 0;
    }
	// **********************************************************************
	// Check that input files have been specified and are readable
	// **********************************************************************
    if(OutFileName.GetLength()==0)
	{   
		AfxMessageBox("Output file not specified");
        return 0;
	}
	OutType.GetWindowText(tmp);
	if (strcmp(tmp,"BSL")==0)
	{
	 if(!Legalbslname(OutFileName))
	  {
		AfxMessageBox(" Invalid BSL Output header filename");
		return 0;
	  }
	}
	// **********************************************************************
	// Convert characters in output filename to uppercase
	// **********************************************************************


	// **********************************************************************
	// Check input and output pixels,rasters
	// **********************************************************************

InFileType.GetWindowText(tmp);
	
	if((strcmp(tmp,"riso")!=0)&&
	(strcmp(tmp,"esrf_id2(klora)")!=0)&&
	(strcmp(tmp,"bsl")!=0)&&
	(strcmp(tmp,"tiff")!=0)&&
	(strcmp(tmp,"esrf_id3")!=0)&&
	(strcmp(tmp,"smv")!=0)&&
	(strcmp(tmp,"loq1d")!=0)&&
	(strcmp(tmp,"loq2d")!=0)&&
	(strcmp(tmp,"bruker")!=0)&&
	(strcmp(tmp,"ILL_SANS")!=0)&&
	(strcmp(tmp,"mar345")!=0))
	{
		
		Cinpix.GetWindowText(tmp);
		tmp.Trim();
		sptr=tmp.GetBuffer();
		InPixel=atoi(sptr);

		if(tmp.GetLength()==0)
	    {
	    AfxMessageBox("Number of input pixels not specified");
	      return 0;
	    }
	    else
	    {
	     for( i=0;i<tmp.GetLength();i++)
	      {
	        if(sptr[i]=='.')
	        {
	         AfxMessageBox("Input pixels: Integer value expected");
	            return 0;
	         }
	         else if(!isdigit(sptr[i])||InPixel<=0)
	         {
	         AfxMessageBox("Invalid number of input pixels");
	          return 0;
	        }
	       }
	    }

	  	Cinrast.GetWindowText(tmp);
		tmp.Trim();
		sptr=tmp.GetBuffer();
		
	 
	  InRast=atoi(sptr);
	  if(strlen(sptr)==0)
	  {
	    AfxMessageBox("Number of input rasters not specified");
	     return 0;
	  }
	  else
	  {
	    for(i=0;i<(int)strlen(sptr);i++)
	    {
	      if(sptr[i]=='.')
	      {
	         AfxMessageBox("Input rasters: Integer value expected");
	        
	        return 0;
	      }
	      else if(!isdigit(sptr[i])||InRast<=0)
	      {
	         AfxMessageBox("Invalid number of input rasters");
	          return 0;
	      }
	    }
	  }

	}
	else
	{
	  InPixel=0;
	  InRast=0;
	}
	OutPix.GetWindowText(tmp);
	tmp.Trim();
	sptr=tmp.GetBuffer();
	nOutPix=atoi(sptr);
	if(strlen(sptr)==0)
	{
	  nOutPix=InPixel;
	}
	else
	{
	  for(i=0;i<(int)strlen(sptr);i++)
	  {
	    if(sptr[i]=='.')
	    {
	       AfxMessageBox("Output pixels: Integer value expected");
	          return 0;
	    }
	    else if(!isdigit(sptr[i])||nOutPix<=0)
	    {
	       AfxMessageBox("Invalid number of output pixels");
	         return 0;
	    }
	  }
	}
	 OutRast.GetWindowText(tmp);
	 tmp.Trim();
	 nOutRast=atoi(tmp);
	nOutRast=atoi(sptr);
	sptr=tmp.GetBuffer();
	if(strlen(sptr)==0)
	{
	  nOutRast=InRast;
	}
	else
	{
	  for(i=0;i<(int)strlen(sptr);i++)
	  {
	    if(sptr[i]=='.')
	    {
	       AfxMessageBox("Output rasters: Integer value expected");
	     
	      return 0;
	    }
	    else if(!isdigit(sptr[i])||nOutRast<=0)
	    {
	      AfxMessageBox("Invalid number of output rasters");
	      
	      return 0;
	    }
	  }
	}
InFileType.GetWindowText(tmp);	
 
if((strcmp(tmp,"fuji")==0))
	{
	   Cdynamic.GetWindowText(tmp);
	   tmp.Trim();
	   dynamicrange=(float)atof(sptr);
	   sptr=tmp.GetBuffer();
	  if(strlen(sptr)==0)
	  {
	     AfxMessageBox("Dynamic range not specified");
	      return 0;
	  }
	  else if (dynamicrange<=0.)
	  {
	     AfxMessageBox("Invalid dynamic range");
	       return 0;
	  }
	  else
	  {
	    iflag=0;
	    for(i=0;i<(int)strlen(sptr);i++)
	     {
	       if(!isdigit(sptr[i]))
	       {
	         if(sptr[i]="."&&!iflag)
	         iflag=1;
	         else
	         {
	            AfxMessageBox("Invalid dynamic range");
	            return 0;
	         }
	       }
	     }
	   }
	}
	else
	  dynamicrange=0.;

	
	if (swapbyte.GetCheck())
	 Swap=1;
 	 else
     Swap=0;
	Chead1.GetWindowText(Head1);
	Chead2.GetWindowText(Head2);

	outFieldsEditable();

return 1;
}
void CxconvDlg::OnEnChangeOutfile()
{
 UpdateData(true);
 UpdateData(false);
}

void CxconvDlg::FieldsEditable( )
{   CString tmp;
	InFileType.GetWindowText(tmp);
if((strcmp(tmp,"esrf_id2(klora)")==0)||
	(strcmp(tmp,"bsl")==0)||
	(strcmp(tmp,"tiff")==0)||
	(strcmp(tmp,"esrf_id3")==0)||
	(strcmp(tmp,"smv")==0)||
	(strcmp(tmp,"loq1d")==0)||
	(strcmp(tmp,"loq2d")==0)||
	(strcmp(tmp,"bruker")==0)||
	(strcmp(tmp,"ILL_SANS")==0)||
	(strcmp(tmp,"mar345")==0))
	{
	Cinpix.SetWindowText("");
	Cinrast.SetWindowText("");
    Cheadbyte.SetWindowText("0");
	Caspect.SetWindowText("1.0");
	Cdynamic.SetWindowText("");
	swapbyte.EnableWindow(false);
	Cinpix.EnableWindow(false);
	Cinrast.EnableWindow(false);
	Cheadbyte.EnableWindow(false);
	Caspect.EnableWindow(false);
	Cdynamic.EnableWindow(false);
	
	if((strcmp(tmp,"bsl")==0)||
	(strcmp(tmp,"loq1d")==0)||
	(strcmp(tmp,"loq2d")==0))
	 {     
		Cfirst.SetReadOnly(true);
	    Clast.SetReadOnly(true);
		Cinc.SetReadOnly(true);
		first=1;
		last=1;
		 inc=1;
      }
	} 
else if(strcmp(tmp,"riso")==0)
	{
	 Cinpix.SetWindowText("");
	 Cinrast.SetWindowText("");
     Cheadbyte.SetWindowText("0");
	 Caspect.SetWindowText("1.0");
	 Cdynamic.SetWindowText("");
	 swapbyte.EnableWindow(true);
     Cinpix.EnableWindow(false);
	 Cinrast.EnableWindow(false);
	 Cheadbyte.EnableWindow(false);
	 Caspect.EnableWindow(false);
	 Cdynamic.EnableWindow(false);
	}
else if(strcmp(tmp,"smar")==0)
	{
	 Cinpix.SetWindowText("1200");
	 Cinrast.SetWindowText("1200");
	 Cheadbyte.SetWindowText("2400");
	 Caspect.SetWindowText("1.0");
	 Cdynamic.SetWindowText("");
	 swapbyte.EnableWindow(true);
     Cinpix.EnableWindow(false);
	 Cinrast.EnableWindow(false);
	 Cheadbyte.EnableWindow(false);
	 Caspect.EnableWindow(false);
	 Cdynamic.EnableWindow(false);
	}
else if(strcmp(tmp,"bmar")==0)
	{
	 Cinpix.SetWindowText("2000");
	 Cinrast.SetWindowText("2000");
	 Cheadbyte.SetWindowText("4000");
	 Caspect.SetWindowText("1.0");
	 Cdynamic.SetWindowText("");
	 swapbyte.EnableWindow(true);
     Cinpix.EnableWindow(false);
	 Cinrast.EnableWindow(false);
	 Cheadbyte.EnableWindow(false);
	 Caspect.EnableWindow(false);
	 Cdynamic.EnableWindow(false);
	}
else if(strcmp(tmp,"fuji")==0)
	{
     Cinpix.SetWindowText("2048");
	 Cinrast.SetWindowText("4096");
	 Cheadbyte.SetWindowText("8192");
	 Caspect.SetWindowText("1.0");
	 Cdynamic.SetWindowText("4.0");
	 swapbyte.EnableWindow(true);
     Cinpix.EnableWindow(false);
	 Cinrast.EnableWindow(false);
	 Cheadbyte.EnableWindow(false);
	 Caspect.EnableWindow(false);
	 Cdynamic.EnableWindow(true);
	}
else if(strcmp(tmp,"fuji2500")==0)
	{
	 Cinpix.SetWindowText("2000");
	 Cinrast.SetWindowText("2500");
	 Cheadbyte.SetWindowText("0");
	 Caspect.SetWindowText("1.0");
	 Cdynamic.SetWindowText("5.0");
	 swapbyte.EnableWindow(true);
     Cinpix.EnableWindow(false);
	 Cinrast.EnableWindow(false);
	 Cheadbyte.EnableWindow(false);
	 Caspect.EnableWindow(false);
	 Cdynamic.EnableWindow(false);
	}
else if(strcmp(tmp,"rax2")==0)
	{
	Cinpix.SetWindowText("400");
	 Cinrast.SetWindowText("1");
	 Cheadbyte.SetWindowText("0");
	 Caspect.SetWindowText("1.0");
	 Cdynamic.SetWindowText("");
	 swapbyte.EnableWindow(true);
     Cinpix.EnableWindow(false);
	 Cinrast.EnableWindow(false);
	 Cheadbyte.EnableWindow(false);
	 Caspect.EnableWindow(false);
	 Cdynamic.EnableWindow(false);
	}
else if(strcmp(tmp,"rax4")==0)
	{ 
	Cinpix.SetWindowText("3000");
	 Cinrast.SetWindowText("3000");
	 Cheadbyte.SetWindowText("6000");
	 Caspect.SetWindowText("1.0");
	 Cdynamic.SetWindowText("");
	 swapbyte.EnableWindow(true);
     Cinpix.EnableWindow(false);
	 Cinrast.EnableWindow(false);
	 Cheadbyte.EnableWindow(false);
	 Caspect.EnableWindow(false);
	 Cdynamic.EnableWindow(false);
	}
else if(strcmp(tmp,"psci")==0)
	{ 
     Cinpix.SetWindowText("768");
	 Cinrast.SetWindowText("576");
	 Cheadbyte.SetWindowText("0");
	 Caspect.SetWindowText("1.0");
	 Cdynamic.SetWindowText("");
	 swapbyte.EnableWindow(true);
     Cinpix.EnableWindow(false);
	 Cinrast.EnableWindow(false);
	 Cheadbyte.EnableWindow(false);
	 Caspect.EnableWindow(false);
	 Cdynamic.EnableWindow(false);
	}
else
	{
	 Caspect.SetWindowText("1.0");
	 Cdynamic.SetWindowText("");
	 swapbyte.EnableWindow(true);
	 Cinpix.EnableWindow(true);
	 Cinrast.EnableWindow(true);
	 Cheadbyte.EnableWindow(true);
	 Caspect.EnableWindow(true);
	 Cdynamic.EnableWindow(false);
	}

}


void CxconvDlg::OnCbnSelchangeCombo1()
{
	CString tmp;
	Dtype.GetWindowText(tmp);

    if(strcmp(tmp,"float32")==0)
		 outdtype=0;
	else    if(strcmp(tmp,"float64")==0)
		 outdtype=9;
	else    if(strcmp(tmp,"int16")==0)
		 outdtype=3;
	else    if(strcmp(tmp,"uint16")==0)
		 outdtype=4;
	else    if(strcmp(tmp,"int32")==0)
		 outdtype=5;
	else    if(strcmp(tmp,"uint32")==0)
		 outdtype=6;
	else    if(strcmp(tmp,"int64")==0)
		 outdtype=7;
	else    if(strcmp(tmp,"uint64")==0)
		 outdtype=8;
    else   if(strcmp(tmp,"char8")==0)
		 outdtype=1;
	else   if(strcmp(tmp,"uchar8")==0)
		 outdtype=2;
	
}

void CxconvDlg::OnCbnSelchangeOuttype()
{
outFieldsEditable();
}
void CxconvDlg::outFieldsEditable()
{	CString tmp;
	OutType.GetWindowText(tmp);
    if(strcmp(tmp,"Tiff16bit")==0)
	{
	 outdtype=12;
	 //outFileType="tiff16";
	 
	 Chead1.EnableWindow(false);
	 Chead2.EnableWindow(false);
	 Dtype.EnableWindow(false);
	}
    else   if(strcmp(tmp,"Tiff8bit")==0)
	{ 
		 outdtype=11;
	     //outFileType="tiff8";
		 Chead1.EnableWindow(false);
	     Chead2.EnableWindow(false);
		 Dtype.EnableWindow(false);
	}
	else   if(strcmp(tmp,"txt")==0)
	{ 
		 outdtype=10;
	    // outFileType="txt";
		 Chead1.EnableWindow(false);
	     Chead2.EnableWindow(false);
		 Dtype.EnableWindow(false);
	}
	else   if(strcmp(tmp,"BSL")==0)
	{   //outdtype=0;	
	   // outFileType="bsl_out";
        //Dtype.SetCurSel(0); 
		Chead1.EnableWindow(true);
		Chead2.EnableWindow(true);
		Dtype.EnableWindow(true);
	}
}
void CxconvDlg::OnEnChangeFirst()
{
 UpdateData(true);
 UpdateData(false);
}

void CxconvDlg::OnEnChangeLast()
{
UpdateData(true);
 UpdateData(false);
}

void CxconvDlg::OnEnChangeInc()
{
UpdateData(true);
UpdateData(false);
}

void CxconvDlg::OnBnClickedHelp()
{
	
  if((32 >= (int)ShellExecute(NULL, "open", "../doc/xconv.html", NULL, NULL, SW_SHOWNORMAL)))
  (32 >= (int)ShellExecute(NULL, "open", "http://www.ccp13.ac.uk/software/program/xconv6.html", NULL, NULL, SW_SHOWNORMAL));

}
/*
CFILE
int CxconvDlg::SaveProfile( )
{

	const char* pptr;
	if((pptr=strrchr(gotFile.data(),(int)'/'))==NULL)
	  pptr=gotFile.data();
	else
	  pptr++;

	ofstream out_profile(gotFile.data(),ios::out);
	if(out_profile.bad())
	{
	  AfxMessageBox("Error opening output file");
	  return 0;
	}
	else
	{
	  out_profile<<"Xconv v 1.0 profile"<<endl;
	             <<pptr<<endl;
	             <<sType.data()<<endl;
 
	  if(InPixel>0)
	    out_profile<<InPixel<<endl;
	  else
	    out_profile<<endl;

	  if(InRast>0)
	    out_profile<<InRast<<endl;
	  else
	    out_profile<<endl;

	  if(Headbyte>0)
	    out_profile<<Headbyte<<endl;
	  else
	    out_profile<<endl;

	  if(aspectratio>0)
	    out_profile<<aspectratio<<endl;
	  else
	    out_profile<<endl;

	   if(dynamicrange)
	    out_profile<<dynamicrange<<endl;
	  else
	    out_profile<<endl;

	 if(nOutPix>0)
	    out_profile<<nOutPix<<endl;
	  else
	    out_profile<<endl;

	  if(nOutRast)
	    out_profile<<nOutRast<<endl;
	  else
	    out_profile<<endl;

	  if(Swap>0)
	    out_profile<<1<<endl;
	  else
	    out_profile<<0<<endl;

	  return 1;
	}
#endif
}
*/

void CxconvDlg::OnBnClickedAbout()
{
	CAboutDlg dlgAbout;
		dlgAbout.DoModal();
}
