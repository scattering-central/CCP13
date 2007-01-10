// xconvDlg.h : header file
//

#pragma once
#include "afxwin.h"
#include "afxcmn.h"


// CxconvDlg dialog
class CxconvDlg : public CDialog
{
// Construction
public:
	CxconvDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_XCONV_DIALOG };


	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnCbnSelchangeInfiletype();
	afx_msg void OnEnChangeInfile();
	afx_msg void OnBnClickedBrowes2();
	afx_msg void OnBnClickedRun();
	afx_msg void OnBnClickedBrowsein();
	afx_msg void OnEnChangeOutfile();
	void ChangeInfile( );	
	bool Legalbslname(CString);
	int CxconvDlg::SaveProfile(CString );
	bool CheckInFile(bool);
	int GetParams();
    void FieldsEditable();
	 void outFieldsEditable();
	CString InFileName;
	CString OutFileName;
	int InPixel;
	int InRast;
	int nOutPix;
	int nOutRast;
	CString Head1;
	CString Head2;
    CString InputFileType;
	CString outFileType;
	CComboBox InFileType; 
	CComboBox OutType;
	float aspectratio;
	float dynamicrange;
	int Headbyte;
	CComboBox Dtype;
	CEdit Cfirst;
	CButton swapbyte;
	CEdit Clast;
	CEdit Cinc;
	CEdit Cinpix;
	CEdit OutPix;
	int first;
	int last;
	int inc;
	int Swap;
	int outdtype;
	
	CEdit OutRast;
	CEdit Cinrast;
	CEdit Cheadbyte;
	CEdit Caspect;
	CEdit Cdynamic;
	
	CEdit Chead1;
	CEdit Chead2;
	afx_msg void OnCbnSelchangeCombo1();
	afx_msg void OnCbnSelchangeOuttype();
	afx_msg void OnEnChangeFirst();
	afx_msg void OnEnChangeLast();
	afx_msg void OnEnChangeInc();
	afx_msg void OnBnClickedHelp();
	afx_msg void OnBnClickedAbout();
};
