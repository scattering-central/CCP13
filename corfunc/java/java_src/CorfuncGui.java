import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.filechooser.*;
import java.io.*;
import java.util.*;
import javax.swing.event.*;
import java.beans.*;
import java.net.URL;
import javax.help.*;

//The Corfunc GUI class
public class CorfuncGui extends JFrame implements ActionListener {
    JTextArea output;
    JScrollPane scrollPane;
    JPanel contentPane;
    JMenuItem extrapMenuItem,transMenuItem,extractMenuItem,
              paramMenuItem,clearMenuItem;
    JCheckBoxMenuItem cbDataMenuItem,cbExtrapMenuItem,cbGamma1MenuItem,
                      cbGamma3MenuItem,cbRetransMenuItem,cbGuinierMenuItem,
                      cbThermalMenuItem,cbPorodMenuItem,cbSigmaMenuItem,
                      cbMomentMenuItem,cbParMenuItem,cbInterfaceMenuItem;

//added dwf
JCheckBoxMenuItem hilbertMenuItem;

    EditParametersFrame editParametersFrame;
    final String newline = "\n";
    final BSLFileChooser fc = new BSLFileChooser();
    File dataFile, qaxFile, parInFile, parOutFile;
    String dataFileName, qaxFileName, parInFileName, parOutFileName;
    String frameAxisFileName,thermalFileName, porodFileName, sigmaFileName;
    String guinierFileName, gamma1FileName, gamma3FileName, realAxisFileName;
    String momentFileName, retransFileName, interfaceFileName;
    String extrapFileName, extrapQFileName;
    boolean gotData, gotQAxis, gotNewData, gotNewQAxis;
    boolean gotThermal,gotFrameAxis,gotPorod,gotSigma, gotGuinier;
    boolean gotGamma1, gotGamma3, gotRealAxis, gotMoment, gotRetrans, gotInterface;

//added by dwf
boolean gotHilbert;

    OtokoDataSet dataSet, qAxis, oldDataSet, oldQAxis, extrapData, extrapQData;
    OtokoDataSet frameAxis, thermalData, porodData, sigmaData, guinierData;
    OtokoDataSet realAxis, gamma1Data, gamma3Data, momentData, retransData, interfaceData;

//added by dwf
    OtokoDataSet hilbertData, hilbertAxis;

    CorfuncDataGraph dataGraph;
    OtokoGraphics thermalGraph, porodGraph, sigmaGraph, guinierGraph;
    OtokoGraphics gamma1Graph, gamma3Graph, momentGraph, interfaceGraph;
    Executable extrapolate, transform, extract_par;

//added dwf
Executable hilbert;
boolean doneHilbert;
HilbertObserver hilbertObserver;
OtokoGraphics hilbertGraph;

    ExtrapolateObserver extrapolateObserver;
    TransformObserver transformObserver;
    ExtractObserver extractObserver;
    boolean gotExtrapData, gotRetransData, doneExtrap, doneTransform, doneExtract;


    JOptionPane WIPoptionPane;
    JDialog WIPdialog;
    WIPOptionPaneListener WIPoptionPaneListener;
    Object[] options = {"Cancel"};
    boolean gotWarning;
    HelpBroker hb;
    HelpSet hs;
    HelpActionListener helpActionListener;

    //Variables from "Edit Parameters"
    Vector limitsData, limitsData2;
    int firstFrame, lastFrame, incFrame, iterations;
    float fraction, maxD, stepD;

//added by dwf
float polyDensity, normAccuracy, adsorbedAmount;
String qAxisDims, qAxisDimsYN;


    boolean arbitraryScale, variableLimits, retrans_opt, interface_opt, userExtract;
    int tailFit, backEx;
    static final int SIGMOID=0;
    static final int POROD=1;
    static final int GUINIER=0;
    static final int VONK=1;
    private int tailfitframe = 1;
    private int linearfitframe=1;

    //Channel limits
    int[] limits;

    //Constructor
    public CorfuncGui() {
        JMenuBar menuBar;
        JMenu menu;
        JMenuItem menuItem;
        JCheckBoxMenuItem cbMenuItem;
        JLabel label, dataLabel, qaxLabel;
        JPanel panel;

        extrapolateObserver = new ExtrapolateObserver();
        transformObserver = new TransformObserver();
        extractObserver = new ExtractObserver();

//added by dwf
hilbertObserver = new HilbertObserver();
gotHilbert=false;

        gotExtrapData=false;
        gotRetransData=false;
        gotThermal = false;
        gotFrameAxis = false;
        gotPorod = false;
        gotSigma = false;
        gotGuinier = false;
        gotGamma1 = false;
        gotGamma3 = false;
        gotMoment = false;
        gotRetrans = false;
        gotInterface = false;
        gotRealAxis = false;
        gotWarning = false;

        //Find the HelpSet file and create the HelpSet object
        try {
            URL hsURL = HelpSet.findHelpSet(null,"corfunc_help/Help.hs");
            hs = new HelpSet(null,hsURL);
        }catch (Exception e) {
            JOptionPane.showMessageDialog(CorfuncGui.this,"Help pages not found",
                                          "Error Message", JOptionPane.ERROR_MESSAGE);
        }

        //Create HelpBroker and Help pages ActionListener
        hb = hs.createHelpBroker();
        helpActionListener = new HelpActionListener();

        //Set up the WIP monitor listener
        WIPoptionPaneListener = new WIPOptionPaneListener();

        //Create the Edit parameters frame
        editParametersFrame = new EditParametersFrame();
        editParametersFrame.setTitle("Parameters");
        editParametersFrame.pack();

        //Set the look and feel
        try {
            UIManager.setLookAndFeel(
              UIManager.getCrossPlatformLookAndFeelClassName());
        } catch (Exception e) {}

        //Get the content pane and set layout manager
        contentPane = new JPanel();
        this.setContentPane(contentPane);
        contentPane.setLayout(new BoxLayout(contentPane,BoxLayout.Y_AXIS));

        //Make the program request for confirmation to quit when window is closed
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                if(JOptionPane.showConfirmDialog(CorfuncGui.this, "Quit corfunc?", "Confirm exit",
                    JOptionPane.YES_NO_OPTION)==JOptionPane.YES_OPTION) {
                        System.exit(0);
                }
            }
        });

        //Create the main menu bar.
        menuBar = new JMenuBar();
        setJMenuBar(menuBar);

        //Add rigid area
        contentPane.add(Box.createRigidArea(new Dimension(0,15)));

        //Create Message Window label
        label = new JLabel("Message window",JLabel.LEFT);
        contentPane.add(label);

        //Add rigid area
        contentPane.add(Box.createRigidArea(new Dimension(0,5)));

        //Create a scrollable message window
        output = new JTextArea(20,35);
        output.setFont(new Font("Monospaced",Font.PLAIN,12));
        output.setColumns(80);
        output.setEditable(false);
        output.setAutoscrolls(true);
        scrollPane = new JScrollPane(output);
        contentPane.add(scrollPane);

        //Build the File menu.
        menu = new JMenu("File");
        menuBar.add(menu);

        menuItem = new JMenuItem("Load data ...");
        menuItem.setAccelerator(KeyStroke.getKeyStroke(
                KeyEvent.VK_D, ActionEvent.ALT_MASK));
        menuItem.addActionListener(this);
        menu.add(menuItem);

        menuItem = new JMenuItem("Load q-axis ...");
        menuItem.setAccelerator(KeyStroke.getKeyStroke(
                KeyEvent.VK_A, ActionEvent.ALT_MASK));
        menuItem.addActionListener(this);
        menu.add(menuItem);

        menuItem = new JMenuItem("Quit");
        menuItem.setAccelerator(KeyStroke.getKeyStroke(
                KeyEvent.VK_Q, ActionEvent.ALT_MASK));
        menuItem.addActionListener(this);
        menu.add(menuItem);

        //Build the Edit menu.
        menu = new JMenu("Edit");
        menuBar.add(menu);

        paramMenuItem = new JMenuItem("Parameters ...");
        paramMenuItem.setEnabled(false);
        paramMenuItem.setAccelerator(KeyStroke.getKeyStroke(
                KeyEvent.VK_P, ActionEvent.ALT_MASK));
        paramMenuItem.addActionListener(this);
        menu.add(paramMenuItem);

        clearMenuItem = new JMenuItem("Clear messages");
        clearMenuItem.setEnabled(true);
        clearMenuItem.setAccelerator(KeyStroke.getKeyStroke(
                KeyEvent.VK_C, ActionEvent.ALT_MASK));
        clearMenuItem.addActionListener(this);
        menu.add(clearMenuItem);

        //Build the Actions menu.
        menu = new JMenu("Actions");
        menuBar.add(menu);

        extrapMenuItem = new JMenuItem("Extrapolate");
        extrapMenuItem.setEnabled(false);
        extrapMenuItem.setAccelerator(KeyStroke.getKeyStroke(
                KeyEvent.VK_E, ActionEvent.ALT_MASK));
        extrapMenuItem.addActionListener(this);
        menu.add(extrapMenuItem);

        transMenuItem = new JMenuItem("Transform");
        transMenuItem.setEnabled(false);
        transMenuItem.setAccelerator(KeyStroke.getKeyStroke(
                KeyEvent.VK_T, ActionEvent.ALT_MASK));
        transMenuItem.addActionListener(this);
        menu.add(transMenuItem);

        extractMenuItem = new JMenuItem("Extract parameters");
        extractMenuItem.setEnabled(false);
        extractMenuItem.setAccelerator(KeyStroke.getKeyStroke(
                KeyEvent.VK_X, ActionEvent.ALT_MASK));
        extractMenuItem.addActionListener(this);
        menu.add(extractMenuItem);

        //Build the Display menu
        menu = new JMenu("Display");
        menuBar.add(menu);

        cbDataMenuItem = new JCheckBoxMenuItem("Data",true);
        cbDataMenuItem.addActionListener(this);
        menu.add(cbDataMenuItem);

        cbExtrapMenuItem = new JCheckBoxMenuItem("Extrapolation",true);
        cbExtrapMenuItem.addActionListener(this);
        menu.add(cbExtrapMenuItem);

        cbGamma1MenuItem = new JCheckBoxMenuItem("Gamma1",true);
        cbGamma1MenuItem.addActionListener(this);
        menu.add(cbGamma1MenuItem);

	hilbertMenuItem = new JCheckBoxMenuItem("Hilbert",true);
        hilbertMenuItem.addActionListener(this);
        menu.add(hilbertMenuItem);


//        cbGamma3MenuItem = new JCheckBoxMenuItem("Gamma3");
//        cbGamma3MenuItem.addActionListener(this);
//        menu.add(cbGamma3MenuItem);

        cbRetransMenuItem = new JCheckBoxMenuItem("Re-transform",true);
        cbRetransMenuItem.addActionListener(this);
        menu.add(cbRetransMenuItem);

        cbGuinierMenuItem = new JCheckBoxMenuItem("Guinier radius");
        cbGuinierMenuItem.addActionListener(this);
        menu.add(cbGuinierMenuItem);

        cbThermalMenuItem = new JCheckBoxMenuItem("Thermal background");
        cbThermalMenuItem.addActionListener(this);
        menu.add(cbThermalMenuItem);

        cbPorodMenuItem = new JCheckBoxMenuItem("Porod Constant");
        cbPorodMenuItem.addActionListener(this);
        menu.add(cbPorodMenuItem);

        cbSigmaMenuItem = new JCheckBoxMenuItem("Sigma");
        cbSigmaMenuItem.addActionListener(this);
        menu.add(cbSigmaMenuItem);

        cbMomentMenuItem = new JCheckBoxMenuItem("Second moment");
        cbMomentMenuItem.addActionListener(this);
        menu.add(cbMomentMenuItem);

        cbInterfaceMenuItem = new JCheckBoxMenuItem("Interface distribution");
        cbInterfaceMenuItem.addActionListener(this);
        menu.add(cbInterfaceMenuItem);

//        cbParMenuItem = new JCheckBoxMenuItem("Strucural parameters",true);
//        cbParMenuItem.addActionListener(this);
//        menu.add(cbParMenuItem);

        //Add horizontal space
        menuBar.add(Box.createHorizontalGlue());

        //Build the Help menu.
        menu = new JMenu("Help");
        menu.setMnemonic(KeyEvent.VK_H);
        JMenuItem helpMenuItem = new JMenuItem("Overview");
        helpMenuItem.setEnabled(true);
        menu.add(helpMenuItem);
        CSH.setHelpIDString(helpMenuItem,"Overview");
        CSH.setHelpSet(helpMenuItem,hs);
        helpMenuItem.addActionListener(helpActionListener);
        helpMenuItem = new JMenuItem("File");
        helpMenuItem.setEnabled(true);
        menu.add(helpMenuItem);
        CSH.setHelpIDString(helpMenuItem,"File");
        CSH.setHelpSet(helpMenuItem,hs);
        helpMenuItem.addActionListener(helpActionListener);
        helpMenuItem = new JMenuItem("Edit");
        helpMenuItem.setEnabled(true);
        menu.add(helpMenuItem);
        CSH.setHelpIDString(helpMenuItem,"Edit");
        CSH.setHelpSet(helpMenuItem,hs);
        helpMenuItem.addActionListener(helpActionListener);
        helpMenuItem = new JMenuItem("Actions");
        helpMenuItem.setEnabled(true);
        menu.add(helpMenuItem);
        CSH.setHelpIDString(helpMenuItem,"Actions");
        CSH.setHelpSet(helpMenuItem,hs);
        helpMenuItem.addActionListener(helpActionListener);
        helpMenuItem = new JMenuItem("Display");
        helpMenuItem.setEnabled(true);
        menu.add(helpMenuItem);
        CSH.setHelpIDString(helpMenuItem,"Display");
        CSH.setHelpSet(helpMenuItem,hs);
        helpMenuItem.addActionListener(helpActionListener);
        helpMenuItem = new JMenuItem("About");
        helpMenuItem.setEnabled(true);
        menu.add(helpMenuItem);
        CSH.setHelpIDString(helpMenuItem,"About");
        CSH.setHelpSet(helpMenuItem,hs);
        helpMenuItem.addActionListener(helpActionListener);
        helpMenuItem = new JMenuItem("Bugs");
        helpMenuItem.setEnabled(true);
        menu.add(helpMenuItem);
        CSH.setHelpIDString(helpMenuItem,"Bugs");
        CSH.setHelpSet(helpMenuItem,hs);
        helpMenuItem.addActionListener(helpActionListener);
        menuBar.add(menu);
    }

    // actionPerformed method
    public void actionPerformed(ActionEvent event) {
        final ActionEvent e = event;
        //Update the GUI before do action
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
            try {
                JMenuItem source = (JMenuItem)(e.getSource());

                // ************************************************
                // Edit parameters
                // ************************************************
                if (source.getText().startsWith("Param")) {
                    editParametersFrame.setLocation((int)CorfuncGui.this.getLocation().getX()+50,
                                                    (int)CorfuncGui.this.getLocation().getY()+50);
                    editParametersFrame.storeParameters();
                    editParametersFrame.channelLimitsFrame.storeParameters();
                    editParametersFrame.channelLimitsFrame2.storeParameters();
                    editParametersFrame.setVisible(true);

                // ************************************************
                // Load data
                // ************************************************
                }else if (source.getText().startsWith("Load data")) {
                    //Open File Chooser
                    fc.setOptions(true,false,true,true);
                    fc.setDialogTitle("Load data");
                    int returnVal;
                    returnVal = fc.showOpenDialog(CorfuncGui.this);
                    CorfuncGui.this.update(CorfuncGui.this.getGraphics());
                    if (returnVal == JFileChooser.APPROVE_OPTION) {
                        dataFile = fc.getSelectedFile();
                        dataFileName = dataFile.getName();
                        //Check the name is not too long for FORTRAN
                        if(dataFile.getParent()!=null)
                            if((dataFile.getParent()+File.separatorChar+dataFileName).length()>80)
                                throw new Exception("Filename too long");
                        //Load OTOKO file
                        if(gotData)
                            oldDataSet=dataSet;
                        //Check if file is ASCII or OTOKO
                        //S King, July 2004
                        //Allowed other types of ASCII file descriptor
                        if((dataFileName.toLowerCase()).endsWith(".txt")) {
                            dataSet = new OtokoDataSet(dataFile,"ascii");}
                        else if((dataFileName.toLowerCase()).endsWith(".dat")) {
                            dataSet = new OtokoDataSet(dataFile,"ascii");}
                        else if((dataFileName.toLowerCase()).endsWith(".loq")) {
                            dataSet = new OtokoDataSet(dataFile,"ascii");
                        } else {
                            dataSet = new OtokoDataSet(dataFile);
                        }
                        if(gotQAxis) {
                            if(dataSet.getChannels()!=qAxis.getChannels()){
                                if(JOptionPane.showOptionDialog(CorfuncGui.this,
                                   "Data has a different number of channels to q-axis. Continue and load a new q-axis?",
                                   "Option dialog",JOptionPane.YES_NO_OPTION,
                                   JOptionPane.QUESTION_MESSAGE,null,null,"Yes")
                                   ==JOptionPane.YES_OPTION) {
                                    qAxis=null;
                                    gotQAxis=false;
                                    editParametersFrame.qaxLabel.setText("None");
                                    extrapMenuItem.setEnabled(false);
                                    if(dataGraph!=null) {
                                        dataGraph.close();
                                        dataGraph=null;
                                    }
                                    gotNewData=true;
                                }
                                else {
                                    gotNewData=false;
                                    dataSet=oldDataSet;
                                }
                            }
                            else {
                                gotNewData=true;
                            }
                        }
                        else {
                            gotNewData=true;
                        }
                        //Set defaults and enable buttons if loaded
                        if(gotNewData) {
                            gotData=true;
                            //Close all graphs and auxilliary windows
                            closeTailfittingGraphs();
                            closeTransformGraphs();
                            if(editParametersFrame.isVisible()){
                                editParametersFrame.setVisible(false);
                                editParametersFrame.channelLimitsFrame.setVisible(false);
                                editParametersFrame.channelLimitsFrame2.setVisible(false);
                                editParametersFrame.enableUserExtractBox(false);
                                editParametersFrame.resetParameters();
                            }
                            transMenuItem.setEnabled(false);
                            if(gotRetransData)gotRetransData=false;
                            extractMenuItem.setEnabled(false);
                            if(gotExtrapData)gotExtrapData=false;
                            output.append("Loaded data: " + dataFileName + "." + newline);
                            //If got Q-axis, display graph
                            if(!gotQAxis)
                                paramMenuItem.setEnabled(false);
                            if(gotQAxis) {
                                extrapMenuItem.setEnabled(true);
                                if(dataGraph!=null) {
                                    dataGraph.close();
                                    dataGraph=null;
                                }
                                dataGraph = new CorfuncDataGraph(dataSet,qAxis,1,1,1,"Data : "+dataFileName+"  q-axis : "+qaxFileName,CorfuncGui.this);
                                dataGraph.addWindowListener(new WindowAdapter() {
                                    public void windowClosing(WindowEvent e) {
                                        CorfuncGui.this.dataGraph.setVisible(false);
                                        cbDataMenuItem.setSelected(false);
                                    }
                                });
                                editParametersFrame.dataLabel.setText(dataFileName);
                                editParametersFrame.setMinFrame(1);
                                editParametersFrame.setMaxFrame(dataSet.getFrames());
                                editParametersFrame.setMaxChannel(dataGraph.getMax());
                                editParametersFrame.setMinChannel(dataGraph.getMin());
                                editParametersFrame.channelLimitsFrame.clear();
                                editParametersFrame.turnoffVariableBox();
                                paramMenuItem.setEnabled(true);
                                if(cbDataMenuItem.isSelected()) {
                                    //Display the data
                                    dataGraph.setLocation((int)CorfuncGui.this.getLocation().getX()+50,
                                                          (int)CorfuncGui.this.getLocation().getY()+50);
                                    dataGraph.setVisible(true);
                                }
                            }
                        }
                    }

                // ************************************************
                // Load Q-axis
                // ************************************************
                }else if (source.getText().startsWith("Load q")) {
                // Open File Chooser
                fc.setDialogTitle("Load q-axis");
                fc.setOptions(true,false,true,true);
                int returnVal = fc.showOpenDialog(CorfuncGui.this);
                CorfuncGui.this.update(CorfuncGui.this.getGraphics());
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    qaxFile = fc.getSelectedFile();
                    qaxFileName = qaxFile.getName();
                    //Check the name is not too long for FORTRAN
                    if(qaxFile.getParent()!=null)
                        if((qaxFile.getParent()+File.separatorChar+qaxFileName).length()>80)
                            throw new Exception("Filename too long");
                    //Load Q-axis file
                    if(gotQAxis)oldQAxis=qAxis;
                    //Check if file is ASCII or OTOKO
                    //S King, July 2004
                    //Allowed other types of ASCII file descriptor
                    if((qaxFileName.toLowerCase()).endsWith(".txt")) {
                        qAxis = new OtokoDataSet(qaxFile,"ascii");}
                    else if((dataFileName.toLowerCase()).endsWith(".dat")) {
                        qAxis = new OtokoDataSet(dataFile,"ascii");}
                    else if((dataFileName.toLowerCase()).endsWith(".loq")) {
                        qAxis = new OtokoDataSet(dataFile,"ascii");
                   } else {
                        qAxis = new OtokoDataSet(qaxFile);
                    }
                    if(gotData) {
                        if(dataSet.getChannels()!=qAxis.getChannels()){
                            if(JOptionPane.showOptionDialog(CorfuncGui.this,
                               "Data has a different number of channels to q-axis. Continue and load new data?",
                               "Option dialog",JOptionPane.YES_NO_OPTION,
                               JOptionPane.QUESTION_MESSAGE,null,null,"Yes")
                               ==JOptionPane.YES_OPTION) {
                                dataSet=null;
                                gotData=false;
                                editParametersFrame.dataLabel.setText("None");
                                extrapMenuItem.setEnabled(false);
                                if(dataGraph!=null) {
                                    dataGraph.close();
                                    dataGraph=null;
                                }
                                gotNewQAxis=true;
                            }
                            else {
                                gotNewQAxis=false;
                                qAxis=oldQAxis;
                            }
                        }
                        else {
                            gotNewQAxis=true;
                        }
                    }
                    else {
                        gotNewQAxis=true;
                    }
                    if(gotNewQAxis) {
                        gotQAxis=true;
                        //Close all graphs and auxilliary windows
                        closeTailfittingGraphs();
                        closeTransformGraphs();
                        if(editParametersFrame.isVisible()){
                            editParametersFrame.setVisible(false);
                            editParametersFrame.channelLimitsFrame.setVisible(false);
                            editParametersFrame.channelLimitsFrame2.setVisible(false);
                            editParametersFrame.enableUserExtractBox(false);
                            editParametersFrame.resetParameters();
                        }
                        transMenuItem.setEnabled(false);
                        extractMenuItem.setEnabled(false);
                        if(gotExtrapData)gotExtrapData=false;
                        if(gotRetransData)gotRetransData=false;
                        editParametersFrame.qaxLabel.setText(qaxFileName);
                        output.append("Loaded q-axis: " + qaxFileName + "." + newline);
                        //If got data, display graph
                        if(!gotData)
                            paramMenuItem.setEnabled(false);
                        if(gotData) {
                            extrapMenuItem.setEnabled(true);
                            if(dataGraph!=null) {
                                dataGraph.close();
                                dataGraph=null;
                            }
                            dataGraph = new CorfuncDataGraph(dataSet,qAxis,1,1,1,"Data : "+dataFileName+"  q-axis : "+qaxFileName,CorfuncGui.this);
                            dataGraph.addWindowListener(new WindowAdapter() {
                                public void windowClosing(WindowEvent e) {
                                    CorfuncGui.this.dataGraph.setVisible(false);
                                    cbDataMenuItem.setSelected(false);
                                }
                            });
                            editParametersFrame.dataLabel.setText(dataFileName);
                            editParametersFrame.setMinFrame(1);
                            editParametersFrame.setMaxFrame(dataSet.getFrames());
                            editParametersFrame.setMaxChannel(dataGraph.getMax());
                            editParametersFrame.setMinChannel(dataGraph.getMin());
                            editParametersFrame.channelLimitsFrame.clear();
                            editParametersFrame.turnoffVariableBox();
                            paramMenuItem.setEnabled(true);
                            if(cbDataMenuItem.isSelected()) {
                                //Display the data
                                dataGraph.setLocation((int)CorfuncGui.this.getLocation().getX()+50,
                                                      (int)CorfuncGui.this.getLocation().getY()+50);
                                dataGraph.setVisible(true);
                            }
                        }
                    }
                }

                // ************************************************
                // Display checkboxes
                // ************************************************
                }else if (source==cbDataMenuItem) {
                    if(cbDataMenuItem.isSelected()) {
                        if(dataGraph!=null) {
                            dataGraph.setLocation((int)CorfuncGui.this.getLocation().getX()+50,
                                                  (int)CorfuncGui.this.getLocation().getY()+50);
                            dataGraph.setVisible(true);
                        }
                    } else if(dataGraph!=null)
                        dataGraph.setVisible(false);
                }else if(source==cbExtrapMenuItem) {
                    if(cbExtrapMenuItem.isSelected()) {
                        if(dataGraph!=null&&gotExtrapData)
                            dataGraph.showExtrapData();
                    } else if(dataGraph!=null&&gotExtrapData) {
                        dataGraph.hideExtrapData();
                    }
                }else if(source==cbThermalMenuItem) {
                    if(cbThermalMenuItem.isSelected()) {
                        if(thermalGraph!=null&&gotThermal)
                            thermalGraph.setVisible(true);
                    } else if(thermalGraph!=null&&gotThermal) {
                        thermalGraph.setVisible(false);
                    }
                }else if(source==cbPorodMenuItem) {
                    if(cbPorodMenuItem.isSelected()) {
                        if(porodGraph!=null&&gotPorod)
                            porodGraph.setVisible(true);
                    } else if(porodGraph!=null&&gotPorod) {
                        porodGraph.setVisible(false);
                    }
                }else if(source==cbSigmaMenuItem) {
                    if(cbSigmaMenuItem.isSelected()) {
                        if(sigmaGraph!=null&&gotSigma)
                            sigmaGraph.setVisible(true);
                    } else if(sigmaGraph!=null&&gotSigma) {
                        sigmaGraph.setVisible(false);
                    }
                }else if(source==cbGuinierMenuItem) {
                    if(cbGuinierMenuItem.isSelected()) {
                        if(guinierGraph!=null&&gotGuinier)
                            guinierGraph.setVisible(true);
                    } else if(guinierGraph!=null&&gotGuinier) {
                        guinierGraph.setVisible(false);
                    }
                }else if(source==cbGamma1MenuItem) {
                    if(cbGamma1MenuItem.isSelected()) {
                        if(gamma1Graph!=null&&gotGamma1)
                            gamma1Graph.setVisible(true);
                    } else if(gamma1Graph!=null&&gotGamma1) {
                        gamma1Graph.setVisible(false);
                    }
		}else if(source==hilbertMenuItem) {
                    if(hilbertMenuItem.isSelected()) {
                        if(hilbertGraph!=null&&gotHilbert)   //change this william!!!1
                            hilbertGraph.setVisible(true);
                    } else if(hilbertGraph!=null&&gotHilbert) {
                        hilbertGraph.setVisible(false);
                    }
//                }else if(source==cbGamma3MenuItem) {
//                    if(cbGamma3MenuItem.isSelected()) {
//                        if(gamma3Graph!=null&&gotGamma3)
//                           gamma3Graph.setVisible(true);
//                    } else if(gamma3Graph!=null&&gotGamma3) {
//                        gamma3Graph.setVisible(false);
//                    }
                }else if(source==cbMomentMenuItem) {
                    if(cbMomentMenuItem.isSelected()) {
                        if(momentGraph!=null&&gotMoment)
                            momentGraph.setVisible(true);
                    } else if(momentGraph!=null&&gotMoment) {
                        momentGraph.setVisible(false);
                    }
                }else if(source==cbRetransMenuItem) {
                    if(cbRetransMenuItem.isSelected()) {
                        if(dataGraph!=null&&gotRetransData)
                            dataGraph.showRetransformData();
                    } else if(dataGraph!=null&&gotRetransData) {
                        dataGraph.hideRetransformData();
                    }
                }else if(source==cbInterfaceMenuItem) {
                    if(cbInterfaceMenuItem.isSelected()) {
                        if(interfaceGraph!=null&&gotInterface)
                            interfaceGraph.setVisible(true);
                    } else if(interfaceGraph!=null&&gotInterface) {
                        interfaceGraph.setVisible(false);
                    }

                // ************************************************
                // Actions
                // ************************************************
                } else if (source.getText().startsWith("Clear")) {
                    output.setText(null);

                }else if (source==extrapMenuItem) {
                    getTailfittingParameters();
                    if(checkTailfittingParameters()) {
                        printTailfittingParameters();
                        //Close all graphs and certain windows
                        closeTailfittingGraphs();
                        closeTransformGraphs();
                        editParametersFrame.channelLimitsFrame2.setVisible(false);
                        editParametersFrame.enableUserExtractBox(false);
                        //Run tailfitting
                        if(extrapolate!=null) {
                          extrapolate.kill();
                          extrapolate=null;
                        }
                        doneExtrap=false;
                        transMenuItem.setEnabled(false);
                        extractMenuItem.setEnabled(false);
                        extrapolate = new Executable("extrapolate",true,false);
                        extrapolate.addObserver(extrapolateObserver);

                        //Show processing monitor
                        if(!doneExtrap) {
                            WIPdialog=new JDialog(CorfuncGui.this,"Status dialog",true);
                            WIPdialog.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
                            WIPoptionPane = new JOptionPane("Processing...",
                                                JOptionPane.INFORMATION_MESSAGE,
                                                JOptionPane.DEFAULT_OPTION);
                            WIPoptionPane.setOptions(options);
                            WIPoptionPaneListener.setProcess(extrapolate);
                            WIPoptionPane.addPropertyChangeListener(WIPoptionPaneListener);
                            WIPdialog.setContentPane(WIPoptionPane);
                            WIPdialog.pack();
                            WIPdialog.setLocation((int)CorfuncGui.this.getLocation().getX()+20,
                                                  (int)CorfuncGui.this.getLocation().getY()+20);
                        }
                        if(!doneExtrap)
                            WIPdialog.setVisible(true);
                    }
                }else if (source==transMenuItem) {

//added by dwf
//if not Hilbert
if (editParametersFrame.transformBox.getSelectedIndex()==0) {


                    getTransformParameters();
                    printTransformParameters();
                    //Close certain graphs and windows
                    closeTransformGraphs();
                    editParametersFrame.channelLimitsFrame2.setVisible(false);
                    editParametersFrame.enableUserExtractBox(false);
                    //Start transform program
                    if(transform!=null) {
                        transform.kill();
                        transform=null;
                    }
                    doneTransform=false;
                    extractMenuItem.setEnabled(false);

			transform = new Executable("ftransform",true,false);

                    transform.addObserver(transformObserver);

                    //Show processing monitor
                    if(!doneTransform) {
                        WIPdialog=new JDialog(CorfuncGui.this,"Processing",true);
                        WIPdialog.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
                        WIPoptionPane = new JOptionPane("Processing...",
                                            JOptionPane.INFORMATION_MESSAGE,
                                            JOptionPane.DEFAULT_OPTION);
                        WIPoptionPane.setOptions(options);
                        WIPoptionPaneListener.setProcess(transform);
                        WIPoptionPane.addPropertyChangeListener(WIPoptionPaneListener);
                        WIPdialog.setContentPane(WIPoptionPane);
                        WIPdialog.pack();
                        WIPdialog.setLocation((int)CorfuncGui.this.getLocation().getX()+20,
                                              (int)CorfuncGui.this.getLocation().getY()+20);
                    }
                    if(!doneTransform)
                        WIPdialog.setVisible(true);




} else {

		    getHilbertParameters();
		    printHilbertParameters();

		    //Start hilbert program
                    if(hilbert!=null) {
                        hilbert.kill();
                        hilbert=null;
                    }
                    doneHilbert=false;
                    extractMenuItem.setEnabled(false);

                    hilbert = new Executable("tropus",true,true);
                    hilbert.addObserver(hilbertObserver);

                    //Show processing monitor
                    if(!doneHilbert) {
                        WIPdialog=new JDialog(CorfuncGui.this,"Processing",true);
                        WIPdialog.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
                        WIPoptionPane = new JOptionPane("Processing...",
                                            JOptionPane.INFORMATION_MESSAGE,
                                            JOptionPane.DEFAULT_OPTION);

                        WIPoptionPane.setOptions(options);
                        WIPoptionPaneListener.setProcess(hilbert);
                        WIPoptionPane.addPropertyChangeListener(WIPoptionPaneListener);
                        WIPdialog.setContentPane(WIPoptionPane);
                        WIPdialog.pack();
                        WIPdialog.setLocation((int)CorfuncGui.this.getLocation().getX()+20,
                                              (int)CorfuncGui.this.getLocation().getY()+20);

                    }
                    if(!doneHilbert)
                        WIPdialog.setVisible(true);


}//end if





                }else if (source==extractMenuItem) {
                    getExtractParameters();
                    printExtractParameters();
                    //Start extract program
                    if(extract_par!=null) {
                        extract_par.kill();
                        extract_par=null;
                    }
                    doneExtract=false;
                    extract_par = new Executable("extract_par",true,false);
                    extract_par.addObserver(extractObserver);

                    //Show processing monitor
                    if(!doneExtract) {
                        WIPdialog=new JDialog(CorfuncGui.this,"Processing",true);
                        WIPdialog.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
                        WIPoptionPane = new JOptionPane("Processing...",
                                            JOptionPane.INFORMATION_MESSAGE,
                                            JOptionPane.DEFAULT_OPTION);
                        WIPoptionPane.setOptions(options);
                        WIPoptionPaneListener.setProcess(extract_par);
                        WIPoptionPane.addPropertyChangeListener(WIPoptionPaneListener);
                        WIPdialog.setContentPane(WIPoptionPane);
                        WIPdialog.pack();
                        WIPdialog.setLocation((int)CorfuncGui.this.getLocation().getX()+20,
                                              (int)CorfuncGui.this.getLocation().getY()+20);
                        }
                        if(!doneExtract)
                            WIPdialog.setVisible(true);

                // ************************************************
                // Quit
                // ************************************************
                }else if (source.getText().startsWith("Quit")) {
                    if(JOptionPane.showConfirmDialog(CorfuncGui.this, "Quit corfunc?", "Confirm exit",
                        JOptionPane.YES_NO_OPTION)==JOptionPane.YES_OPTION) {
                            System.exit(0);
                    }
                }
            }
            catch (Exception ex) {
            JOptionPane.showMessageDialog(CorfuncGui.this,ex.toString(),
                                          "Error Message", JOptionPane.ERROR_MESSAGE);
            }

            }
        });
        this.update(this.getGraphics());

    }

    public void getTailfittingParameters () {
        limits = dataGraph.getLimits();
        arbitraryScale = editParametersFrame.arbitraryScale;
        tailFit = editParametersFrame.tailFit;
        backEx = editParametersFrame.backEx;
        firstFrame = editParametersFrame.firstFrame;
        lastFrame = editParametersFrame.lastFrame;
        incFrame = editParametersFrame.incFrame;
        iterations = editParametersFrame.iterations;
        variableLimits = editParametersFrame.variableLimits;
        if(variableLimits) {
            limitsData = (Vector) editParametersFrame.limitsData.clone();

            //Convert q-axis limits to OTOKO file channel limits
            boolean gotLower,gotUpper;
            for(int i=0;i<limitsData.size();i+=4) {
                gotLower=false;
                gotUpper=false;
                for(int j=0;j<qAxis.getChannels();j++) {
                    if(!gotLower&&((Float)limitsData.elementAt(i+2)).floatValue()<=qAxis.getData(j)) {
                        limitsData.setElementAt(new Float(j+1),i+2);
                        gotLower=true;
                    }
                    if(!gotUpper&&((Float)limitsData.elementAt(i+3)).floatValue()<=qAxis.getData(j)) {
                        limitsData.setElementAt(new Float(j+1),i+3);
                        gotUpper=true;
                    }
                }
            }
        }
    }

    public void getTransformParameters () {
        maxD = editParametersFrame.maxD;
        stepD = editParametersFrame.stepD;
        retrans_opt = editParametersFrame.retrans_opt;
    }


//method added by DWF
   public void getHilbertParameters () {
	  polyDensity = editParametersFrame.polyDensity;
	  normAccuracy = editParametersFrame.normAccuracy;
	  adsorbedAmount = editParametersFrame.adsorbedAmount;
	qAxisDims = (String)editParametersFrame.qAxisBox.getItemAt(editParametersFrame.qAxisBox.getSelectedIndex());
	if (qAxisDims.startsWith(" /Ang"))
		qAxisDimsYN = "y";
	else
		qAxisDimsYN = "n";
   }//end method


    public void getExtractParameters () {
        interface_opt = editParametersFrame.interface_opt;
        userExtract = editParametersFrame.userExtract;
        if(userExtract)
            limitsData2 = editParametersFrame.limitsData2;
        fraction = editParametersFrame.fraction;
    }

    //Check parameters that have not already been checked in editParametersFrame
    public boolean checkTailfittingParameters () {
        if(variableLimits){
            for(int i=0; i<limitsData.size();i+=4) {
                if( ((Float)limitsData.elementAt(i+2)).intValue()<limits[0]) {
                    JOptionPane.showMessageDialog(CorfuncGui.this,"First limit for tailfit preceeds start of data limit"+
                                                  " at element "+((i+4)/4),
                                                  "Error Message", JOptionPane.ERROR_MESSAGE);
                    return(false);
                }
            }
        }
        return(true);
    }

    public void printTailfittingParameters () {
        output.append(newline);
        output.append(" EXTRAPOLATE"+newline);
        output.append(" INPUT PARAMETERS"+newline);
        output.append(" Act on frames : "+firstFrame+" to "+lastFrame+" inc "+incFrame+newline);
        if(!variableLimits)
            output.append(" Channel limits : start "+limits[0]+", tailfit "+limits[1]+" to "+limits[2]+newline);
        else {
            output.append(" Channel limits : "+newline);
            output.append(" Start "+limits[0]+newline);
            for(int i=0; i<limitsData.size();i+=4) {
                output.append(" Tailfit frames  "+(Integer)limitsData.elementAt(i)+
                              " to "+(Integer)limitsData.elementAt(i+1)+
                              ", limits : "+((Float)limitsData.elementAt(i+2)).intValue()+
                              " to "+((Float)limitsData.elementAt(i+3)).intValue()+newline);
            }
        }
        output.append(" Data scale : ");
        if(arbitraryScale)
            output.append("arbitrary"+newline);
        else
            output.append("absolute"+newline);
        output.append(" Tail fit : ");
        if(tailFit==SIGMOID)
            output.append("Sigmoid"+newline);
        else if(tailFit==POROD)
            output.append("Porod"+newline);
        output.append(" Number of iterations for tailfitting : "+iterations+newline);
        output.append(" Back extrapolation : ");
        if(backEx==GUINIER)
            output.append("Guinier"+newline);
        else if(backEx==VONK)
            output.append("Vonk"+newline);
    }

    public void printTransformParameters () {
        output.append(newline);
        output.append(" TRANSFORM"+newline);
        output.append(" INPUT PARAMETERS"+newline);
        output.append(" Maximum D for FT : "+maxD+newline);
        output.append(" Step in D for FT : "+stepD+newline);
    }

//method added by dwf
    public void printHilbertParameters () {
        output.append(newline);
        output.append(" TRANSFORM (Hilbert)"+newline);
        output.append(" INPUT PARAMETERS"+newline);
        output.append(" Q-axis dimensions : "+qAxisDims+newline);
        output.append(" Bulk density of polymer [g/cm3] : "+polyDensity +newline);
        output.append(" Adsorbed amount [mg/m2] : "+adsorbedAmount+newline);
        output.append(" Normalisation accuracy : "+normAccuracy+newline);
    }//end method



    public void printExtractParameters () {
        output.append(newline);
        output.append(" EXTRACT"+newline);
        output.append(" INPUT PARAMETERS"+newline);
        if(userExtract) {
            output.append(" Channel limits : "+newline);
            for(int i=0; i<limitsData2.size();i+=4) {
                output.append(" Frames  "+(Integer)limitsData2.elementAt(i)+
                              " to "+(Integer)limitsData2.elementAt(i+1)+
                              ", limits : "+(Float)limitsData2.elementAt(i+2)+
                              " to "+(Float)limitsData2.elementAt(i+3)+newline);
            }
        }
        output.append(" Estimated volume fraction crystallinity : "+fraction+newline);
    }

    public void closeTailfittingGraphs() {
        if(gotGuinier) {
            gotGuinier=false;
            guinierGraph.close();
            guinierGraph=null;
        }
        if(gotThermal) {
            gotThermal=false;
            thermalGraph.close();
            thermalGraph=null;
        }
        if(gotPorod) {
            gotPorod=false;
            porodGraph.close();
            porodGraph=null;
        }
        if(gotSigma) {
            gotSigma=false;
            sigmaGraph.close();
            sigmaGraph=null;
        }
        if(gotExtrapData) {
            gotExtrapData=false;
            if(dataGraph!=null)dataGraph.hideExtrapData();
        }
    }

    public void closeTransformGraphs() {
        if(gotGamma1) {
            gotGamma1=false;
            gamma1Graph.close();
            gamma1Graph=null;
        }

//added by dwf
if(gotHilbert) {
	gotHilbert=false;
	hilbertGraph.close();
	hilbertGraph=null;
}

//        if(gotGamma3) {
//            gotGamma3=false;
//            gamma3Graph.close();
//            gamma3Graph=null;
//        }
        if(gotMoment) {
            gotMoment=false;
            momentGraph.close();
            momentGraph=null;
        }
        if(gotInterface) {
            gotInterface=false;
            interfaceGraph.close();
            interfaceGraph=null;
        }
        if(gotRetrans) {
            gotRetrans=false;
            if(gotRetransData) {
                gotRetransData=false;
                dataGraph.hideRetransformData();
            }
        }
    }

    //Main method
    public static void main(String[] args) {
        CorfuncGui corfuncWindow = new CorfuncGui();
//        GraphicsEnvironment gEnv = GraphicsEnvironment.getLocalGraphicsEnvironment();
//        String envfonts[] = gEnv.getAvailableFontFamilyNames();
//        for(int i=0;i<envfonts.length;i++) {
//            System.out.println(envfonts[i]);
//        }
        corfuncWindow.setTitle("Corfunc for Windows v1.5");
        corfuncWindow.pack();
        corfuncWindow.setVisible(true);
    }

    public class ExtrapolateObserver implements Observer {
        //Update method for observing the corfunc Executable object
        public void update (Observable o, Object arg1) {
            final Object arg = arg1;

            SwingUtilities.invokeLater(new Runnable() {
                public void run() {

                    String message;
                    int i=0;

                    try {
                        message=(String)arg;
                        message=processMessage(message);
                        if(message.startsWith(" Enter intensity"))
                            extrapolate.writeToApp(dataFile.getParent()+File.separatorChar+dataFileName);
                        else if(message.startsWith(" Enter Q"))
                            extrapolate.writeToApp(qaxFile.getParent()+File.separatorChar+qaxFileName);
                        else if(message.startsWith(" Enter start frame"))
                            extrapolate.writeToApp(String.valueOf(firstFrame));
                        else if(message.startsWith(" Enter end"))
                            extrapolate.writeToApp(String.valueOf(lastFrame));
                        else if(message.startsWith(" Enter inc"))
                            extrapolate.writeToApp(String.valueOf(incFrame));
                        else if(message.startsWith(" Data in arbitrary")) {
                            if(arbitraryScale)
                                extrapolate.writeToApp(new String("arb"));
                            else
                                extrapolate.writeToApp(new String ("abs"));
                        }
                        else if(message.startsWith(" Same channel")) {
                            if(!variableLimits)
                                extrapolate.writeToApp(new String ("y"));
                            else
                                extrapolate.writeToApp(new String ("n"));
                        }
                        else if(message.startsWith(" Limits for frame")) {
                            StringBuffer sbuf = new StringBuffer(message);
                            String substring = (sbuf.substring(17,sbuf.length()-1)).trim();
                            tailfitframe = Integer.parseInt(substring);
                        }
                        else if(message.startsWith(" Enter tailfit start")) {
                            while(tailfitframe>((Integer)limitsData.elementAt(i+1)).intValue()) {
                              i+=4;
                            }
                            extrapolate.writeToApp(String.valueOf( ((Float)limitsData.elementAt(i+2)).intValue() ));
                        }
                        else if(message.startsWith(" Enter tailfit end")) {
                            while(tailfitframe>((Integer)limitsData.elementAt(i+1)).intValue()) {
                              i+=4;
                            }
                            extrapolate.writeToApp(String.valueOf( ((Float)limitsData.elementAt(i+3)).intValue() ));
                        }
                        else if(message.startsWith(" Enter channel at start of tail"))
                            extrapolate.writeToApp(String.valueOf(limits[1]));
                        else if(message.startsWith(" Enter channel at end of tail"))
                            extrapolate.writeToApp(String.valueOf(limits[2]));
                        else if(message.startsWith(" Enter start channel opt"))
                            extrapolate.writeToApp(new String ("n"));
                        else if(message.startsWith(" Enter number of iterations"))
                            extrapolate.writeToApp(String.valueOf(iterations));
                        else if(message.startsWith(" Apply sigmoid")) {
                            if(tailFit==SIGMOID)
                                extrapolate.writeToApp("y");
                            else if(tailFit==POROD)
                                extrapolate.writeToApp("n");
                        }
                        else if(message.startsWith(" Vonk")) {
                            if(backEx==GUINIER)
                                extrapolate.writeToApp("g");
                            else if(backEx==VONK)
                                extrapolate.writeToApp("v");
                        }
                        else if(message.startsWith(" Enter channel at start of genuine data"))
                            extrapolate.writeToApp(String.valueOf(limits[0]));
                        else if(message.startsWith(" Written x-axis:")) {
                            frameAxisFileName = message.substring(17,27);
                            gotFrameAxis=true;
                        }
                        else if(message.startsWith(" Written thermal background")) {
                            thermalFileName = message.substring(37,47);
                            gotThermal=true;
                        }
                        else if(message.startsWith(" Written Porod")) {
                            porodFileName = message.substring(33,43);
                            gotPorod=true;
                        }
                        else if(message.startsWith(" Written sigma")) {
                            sigmaFileName = message.substring(24,34);
                            gotSigma=true;
                        }
                        else if(message.startsWith(" Written extrapolated data:")) {
                            extrapFileName = message.substring(28,38);
                        }
                        else if(message.startsWith(" Written extrapolated data q-axis:")) {
                            extrapQFileName = message.substring(35,45);
                        }
                        else if(message.startsWith(" Written Guinier")) {
                            guinierFileName = message.substring(45,55);
                            gotGuinier = true;
                        }
                        else if(message.startsWith(" Finished tailfitting")) {
                            //Display graphs from tailfit
                            if(gotThermal) {
                                if(thermalGraph!=null) {
                                    thermalGraph.close();
                                    thermalGraph=null;
                                }
                                thermalData = new OtokoDataSet(thermalFileName);
                                frameAxis = new OtokoDataSet(frameAxisFileName);
                                thermalGraph = new OtokoGraphics(thermalData,frameAxis,1,1,1,"Data : "+thermalFileName+"  X-axis : "+frameAxisFileName,CorfuncGui.this);
                                thermalGraph.setAxes("Frame","Thermal background");
                                if(cbThermalMenuItem.isSelected()) {
                                    thermalGraph.setVisible(true);
                                }
                                thermalGraph.addWindowListener(new WindowAdapter() {
                                    public void windowClosing(WindowEvent e) {
                                        CorfuncGui.this.thermalGraph.setVisible(false);
                                        cbThermalMenuItem.setSelected(false);
                                    }
                                });
                            }
                            if(gotPorod) {
                                if(porodGraph!=null) {
                                    porodGraph.close();
                                    porodGraph=null;
                                }
                                porodData = new OtokoDataSet(porodFileName);
                                frameAxis = new OtokoDataSet(frameAxisFileName);
                                porodGraph = new OtokoGraphics(porodData,frameAxis,1,1,1,"Data : "+porodFileName+"  X-axis : "+frameAxisFileName,CorfuncGui.this);
                                porodGraph.setAxes("Frame","Porod constant");
                                if(cbPorodMenuItem.isSelected()) {
                                    porodGraph.setVisible(true);
                                }
                                porodGraph.addWindowListener(new WindowAdapter() {
                                    public void windowClosing(WindowEvent e) {
                                        CorfuncGui.this.porodGraph.setVisible(false);
                                        cbPorodMenuItem.setSelected(false);
                                    }
                                });
                            }
                            if(gotSigma) {
                                if(sigmaGraph!=null) {
                                    sigmaGraph.close();
                                    sigmaGraph=null;
                                }
                                sigmaData = new OtokoDataSet(sigmaFileName);
                                frameAxis = new OtokoDataSet(frameAxisFileName);
                                sigmaGraph = new OtokoGraphics(sigmaData,frameAxis,1,1,1,"Data : "+sigmaFileName+"  X-axis : "+frameAxisFileName,CorfuncGui.this);
                                sigmaGraph.setAxes("Frame","Sigma (Angstroms)");
                                if(cbSigmaMenuItem.isSelected()) {
                                    sigmaGraph.setVisible(true);
                                }
                                sigmaGraph.addWindowListener(new WindowAdapter() {
                                    public void windowClosing(WindowEvent e) {
                                        CorfuncGui.this.sigmaGraph.setVisible(false);
                                        cbSigmaMenuItem.setSelected(false);
                                    }
                                });
                            }
                        }
                        else if(message.startsWith(" Finished tailjoin")) {
                            //Show the extrapolated data
                            doneExtrap=true;
                            extrapolate.kill();
                            extrapolate=null;
                            extrapData=new OtokoDataSet(extrapFileName);
                            extrapQData = new OtokoDataSet(extrapQFileName);
                            dataGraph.loadExtrapData(extrapData,extrapQData,1,1,1);
                            gotExtrapData = true;
                            transMenuItem.setEnabled(true);
                            extractMenuItem.setEnabled(false);
                            if(dataGraph!=null&&cbExtrapMenuItem.isSelected()) {
                                dataGraph.showExtrapData();
                            }
                            WIPdialog.setVisible(false);
                            output.repaint();
                            //Plot Guinier radius
                            if(gotGuinier) {
                                if(guinierGraph!=null) {
                                    guinierGraph.close();
                                    guinierGraph=null;
                                }
                                guinierData = new OtokoDataSet(guinierFileName);
                                frameAxis = new OtokoDataSet(frameAxisFileName);
                                guinierGraph = new OtokoGraphics(guinierData,frameAxis,1,1,1,"Data : "+guinierFileName+"  X-axis : "+frameAxisFileName,CorfuncGui.this);
                                guinierGraph.setAxes("Frame","Radius of gyration (Angstroms)");
                                if(cbGuinierMenuItem.isSelected()) {
                                    guinierGraph.setVisible(true);
                                }
                                guinierGraph.addWindowListener(new WindowAdapter() {
                                    public void windowClosing(WindowEvent e) {
                                        CorfuncGui.this.guinierGraph.setVisible(false);
                                        cbGuinierMenuItem.setSelected(false);
                                    }
                                });
                            }
                        if(gotWarning)
                            showWarningMessage();
                        }
                        else if(message.startsWith(" ERROR")) {
                            if(message.endsWith("FATAL"))
                                showErrorMessage(message, extrapolate);
                            else {
                                gotWarning=true;
                            }
                        }
                        else if(message.startsWith(" WARNING")) {
                            gotWarning=true;
                        }
                    }
                    catch (Exception ex) {
                        JOptionPane.showMessageDialog(CorfuncGui.this,ex.getMessage(),
                                                      "Error Message", JOptionPane.ERROR_MESSAGE);
                    }
                }
            });
        }
    }

    public class TransformObserver implements Observer {
        //Update method for observing the transform Executable object
        public void update (Observable o, Object arg1) {
            final Object arg = arg1;

            SwingUtilities.invokeLater(new Runnable() {
                public void run() {

                    String message;
                    try {
                        message=(String)arg;
                        message=processMessage(message);
                        if(message.startsWith(" Enter maximum D"))
                            transform.writeToApp(String.valueOf(maxD));
                        else if(message.startsWith(" Enter step in D"))
                            transform.writeToApp(String.valueOf(stepD));
                        else if(message.startsWith(" Re-transform correlation function"))
                            if(retrans_opt)
                                transform.writeToApp(new String("y"));
                            else
                                transform.writeToApp(new String("n"));
                        else if(message.startsWith(" Calculate the interface"))
                            if(retrans_opt)
                                transform.writeToApp(new String("y"));
                            else
                                transform.writeToApp(new String("n"));
                        else if(message.startsWith(" Finished transform")) {
                            doneTransform=true;
                            transform.kill();
                            transform=null;
                            WIPdialog.setVisible(false);
                            output.repaint();
                            extractMenuItem.setEnabled(true);
                            //Plot the results of transform
                            if(gotGamma1) {
                                if(gamma1Graph!=null) {
                                    gamma1Graph.close();
                                    gamma1Graph=null;
                                }
                                gamma1Data = new OtokoDataSet(gamma1FileName);
                                realAxis = new OtokoDataSet(realAxisFileName);
                                gamma1Graph = new OtokoGraphics(gamma1Data,realAxis,1,1,1,"Data : "+gamma1FileName+"  X-axis : "+realAxisFileName,CorfuncGui.this);
                                gamma1Graph.setAxes("R (Angstroms)","Gamma 1");

                                editParametersFrame.channelLimitsFrame2.setMinFrame(1);
                                editParametersFrame.channelLimitsFrame2.setMaxFrame(gamma1Data.getFrames());
                                editParametersFrame.channelLimitsFrame2.setMinChannel(gamma1Graph.getMin());
                                editParametersFrame.channelLimitsFrame2.setMaxChannel(gamma1Graph.getMax());
                                editParametersFrame.channelLimitsFrame2.clear();
                                editParametersFrame.enableUserExtractBox(true);

                                if(cbGamma1MenuItem.isSelected()) {
                                    gamma1Graph.setVisible(true);
                                }
                                gamma1Graph.addWindowListener(new WindowAdapter() {
                                    public void windowClosing(WindowEvent e) {
                                        CorfuncGui.this.gamma1Graph.setVisible(false);
                                        cbGamma1MenuItem.setSelected(false);
                                    }
                                });
                            }
//                            if(gotGamma3) {
//                                if(gamma3Graph!=null) {
//                                    gamma3Graph.close();
//                                    gamma3Graph=null;
//                                }
//                                gamma3Data = new OtokoDataSet(gamma3FileName);
//                                realAxis = new OtokoDataSet(realAxisFileName);
//                                gamma3Graph = new OtokoGraphics(gamma3Data,realAxis,1,1,1,"Data : "+gamma3FileName+"  X-axis : "+realAxisFileName,CorfuncGui.this);
//                                gamma3Graph.setAxes("R (Angstroms)","Gamma 3");
//                                if(cbGamma3MenuItem.isSelected()) {
//                                    gamma3Graph.setVisible(true);
//                                }
//                                gamma3Graph.addWindowListener(new WindowAdapter() {
//                                    public void windowClosing(WindowEvent e) {
//                                        CorfuncGui.this.gamma3Graph.setVisible(false);
//                                        cbGamma3MenuItem.setSelected(false);
//                                    }
//                                });
//                            }
                            if(gotMoment) {
                                if(momentGraph!=null) {
                                    momentGraph.close();
                                    momentGraph=null;
                                }
                                momentData = new OtokoDataSet(momentFileName);
                                frameAxis = new OtokoDataSet(frameAxisFileName);
                                momentGraph = new OtokoGraphics(momentData,frameAxis,1,1,1,"Data : "+momentFileName+"  X-axis : "+frameAxisFileName,CorfuncGui.this);
                                momentGraph.setAxes("Frame","Second moment");
                                if(cbMomentMenuItem.isSelected()) {
                                    momentGraph.setVisible(true);
                                }
                                momentGraph.addWindowListener(new WindowAdapter() {
                                    public void windowClosing(WindowEvent e) {
                                        CorfuncGui.this.momentGraph.setVisible(false);
                                        cbMomentMenuItem.setSelected(false);
                                    }
                                });
                            }
                            if(gotInterface) {
                                if(interfaceGraph!=null) {
                                    interfaceGraph.close();
                                    interfaceGraph=null;
                                }
                                interfaceData = new OtokoDataSet(interfaceFileName);
                                realAxis = new OtokoDataSet(realAxisFileName);
                                interfaceGraph = new OtokoGraphics(interfaceData,realAxis,1,1,1,"Data : "+interfaceFileName+"  X-axis : "+realAxisFileName,CorfuncGui.this);
                                interfaceGraph.setAxes("Angstroms","Interface dist function");
                                if(cbInterfaceMenuItem.isSelected()) {
                                    interfaceGraph.setVisible(true);
                                }
                                interfaceGraph.addWindowListener(new WindowAdapter() {
                                    public void windowClosing(WindowEvent e) {
                                        CorfuncGui.this.interfaceGraph.setVisible(false);
                                        cbInterfaceMenuItem.setSelected(false);
                                    }
                                });
                            }
                            if(gotRetrans) {
                                //Show the re-transformed data if required
                                retransData = new OtokoDataSet(retransFileName);
                                dataGraph.loadRetransformData(retransData,1,1,1);
                                gotRetransData=true;
                                if(dataGraph!=null&&cbRetransMenuItem.isSelected()) {
                                    dataGraph.showRetransformData();
                                }
                            }
                        if(gotWarning)
                            showWarningMessage();
                        }
                        else if(message.startsWith(" Written Gamma1")) {
                            gamma1FileName = message.substring(17,27);
                            gotGamma1 = true;
                        }
//                        else if(message.startsWith(" Written Gamma3")) {
//                            gamma3FileName = message.substring(17,27);
//                            gotGamma3 = true;
//                        }
                        else if(message.startsWith(" Written x-axis")) {
                            realAxisFileName = message.substring(17,27);
                            gotRealAxis = true;
                        }
                        else if(message.startsWith(" Written re-transform")) {
                            retransFileName = message.substring(23,33);
                            gotRetrans = true;
                        }
                        else if(message.startsWith(" Written second moment")) {
                            momentFileName = message.substring(32,42);
                            gotMoment = true;
                        }
                        else if(message.startsWith(" Written interface")) {
                            interfaceFileName = message.substring(38,48);
                            gotInterface = true;
                        }
                        else if(message.startsWith(" ERROR")) {
                            if(message.endsWith("FATAL"))
                                showErrorMessage(message, transform);
                            else {
                                gotWarning=true;
                            }
                        }
                        else if(message.startsWith(" WARNING")) {
                            gotWarning=true;
                        }
                    }
                    catch (Exception ex) {
                        JOptionPane.showMessageDialog(CorfuncGui.this,ex.getMessage(),
                                                      "Error Message", JOptionPane.ERROR_MESSAGE);
                    }
                }
            });
        }
    }

    public class ExtractObserver implements Observer {
        //Update method for observing the extract Executable object
        public void update (Observable o, Object arg1) {
            final Object arg = arg1;

            SwingUtilities.invokeLater(new Runnable() {
                public void run() {

                    String message;
                    int i=0;

                    try {
                        message=(String)arg;
                        message=processMessage(message);
                        if(message.startsWith(" Enter estimate"))
                            extract_par.writeToApp(String.valueOf(fraction));
                        else if(message.startsWith(" Do you want user control"))
                            if(userExtract)
                                extract_par.writeToApp(new String("y"));
                            else
                                extract_par.writeToApp(new String("n"));
                        else if(message.startsWith(" Limits for frame")) {
                            StringBuffer sbuf = new StringBuffer(message);
                            String substring = (sbuf.substring(17,sbuf.length()-1)).trim();
                            linearfitframe = Integer.parseInt(substring);
                        }
                        else if(message.startsWith(" Enter R at start of linear section")) {
                            while(linearfitframe>((Integer)limitsData2.elementAt(i+1)).intValue()) {
                              i+=4;
                            }
                            extract_par.writeToApp(String.valueOf((Float)limitsData2.elementAt(i+2)));
                        }
                        else if(message.startsWith(" Enter R at end of linear section")) {
                            while(linearfitframe>((Integer)limitsData2.elementAt(i+1)).intValue()) {
                              i+=4;
                            }
                            extract_par.writeToApp(String.valueOf((Float)limitsData2.elementAt(i+3)));
                        }
                        else if(message.startsWith(" Finished extract")) {
                            doneExtract=true;
                            WIPdialog.setVisible(false);
                            extract_par.kill();
                            extract_par=null;
                            output.repaint();
                        if(gotWarning)
                            showWarningMessage();
                        }
                        else if(message.startsWith(" ERROR")) {
                            if(message.endsWith("FATAL"))
                                showErrorMessage(message, extract_par);
                            else {
                                gotWarning=true;
                            }
                        }
                        else if(message.startsWith(" WARNING")) {
                            gotWarning=true;
                        }
                    }
                    catch (Exception ex) {
                        JOptionPane.showMessageDialog(CorfuncGui.this,ex.getMessage(),
                                                      "Error Message", JOptionPane.ERROR_MESSAGE);
                    }
                }
            });
        }
    }





//added by dwf
public class HilbertObserver implements Observer {
        //Update method for observing the extract Executable object
        public void update (Observable o, Object arg1) {
            final Object arg = arg1;

            SwingUtilities.invokeLater(new Runnable() {
                public void run() {
		    String fPrefix = dataFile.getName().substring(0,3);
     		//System.out.println("***" + fPrefix);

                    String message;
                    int i=0;

                    try {
                        message=(String)arg;
                        message=processMessage(message);

				if(message.startsWith(" Extrapol")) {
                            	        hilbert.writeToApp(fPrefix);
				} else if(message.indexOf(" Is the Q-axis") != -1) {
                                        hilbert.writeToApp(qAxisDimsYN);					
                                } else if(message.indexOf("Bulk density") != -1) {
                                        hilbert.writeToApp(Float.toString(polyDensity));
                                } else if(message.indexOf("Adsorbed amount") != -1) {
                                        hilbert.writeToApp(Float.toString(adsorbedAmount));
                                } else if(message.indexOf("differ from normalisation") != -1) {
                                        hilbert.writeToApp(Float.toString(normAccuracy));
				} else if (message.indexOf("Writing file:") != -1) {
                                        output.append(message.toString());
                                        doneExtract = true;
                                        WIPdialog.setVisible(false);
                                        hilbert.kill();
                                        hilbert = null;
                                        output.repaint();
					gotHilbert=true;


			    extractMenuItem.setEnabled(true);
                            //Plot the results of transform
                            if(gotHilbert) {
                                if(hilbertGraph!=null) {
                                    hilbertGraph.close();
                                    hilbertGraph=null;
                                }


                                hilbertData = new OtokoDataSet(fPrefix + "VFR.txt", "corfunc", "y");  //x
                                hilbertAxis = new OtokoDataSet(fPrefix + "VFR.txt", "corfunc", "z");  //y
                                hilbertGraph = new OtokoGraphics(hilbertData,hilbertAxis,1,1,1,"Data : "+ fPrefix +"VFR.txt"+"  X-axis : "+ fPrefix + "VFR.txt",CorfuncGui.this);
                                hilbertGraph.setAxes("z (" + qAxisDims + " )","Volume Fraction");

                                editParametersFrame.channelLimitsFrame2.setMinFrame(1);
                                editParametersFrame.channelLimitsFrame2.setMaxFrame(hilbertData.getFrames());
                                editParametersFrame.channelLimitsFrame2.setMinChannel(hilbertGraph.getMin());
                                editParametersFrame.channelLimitsFrame2.setMaxChannel(hilbertGraph.getMax());
                                editParametersFrame.channelLimitsFrame2.clear();
                                editParametersFrame.enableUserExtractBox(true);

                                if(hilbertMenuItem.isSelected()) {
                                    hilbertGraph.setVisible(true);
                                }


                                hilbertGraph.addWindowListener(new WindowAdapter() {
                                    public void windowClosing(WindowEvent e) {
                                        CorfuncGui.this.hilbertGraph.setVisible(false);
                                        hilbertMenuItem.setSelected(false);
                                    }
                                });
                            }




				}//end if

                    } catch (Exception ex) {
ex.printStackTrace();
                        JOptionPane.showMessageDialog(CorfuncGui.this,ex.getMessage(),
                                                      "Error Message", JOptionPane.ERROR_MESSAGE);
                    }
                }
            });
        }
    }
// dwf end




    public void showErrorMessage (String message, Executable exec) {
        try {
            exec.kill();
        }
        catch (Exception ex) {
            JOptionPane.showMessageDialog(CorfuncGui.this,ex.getMessage(),
                                          "Error Message", JOptionPane.ERROR_MESSAGE);
        }
        WIPdialog.setVisible(false);
        CorfuncGui.this.update(CorfuncGui.this.getGraphics());

        int index1 = message.indexOf(":");
        int index2 = message.lastIndexOf(":");
        final String err_message = message.substring(index1+2,index2);
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                JOptionPane.showMessageDialog(CorfuncGui.this, err_message,
                                              "Error Message", JOptionPane.ERROR_MESSAGE);
            }
        });
        output.repaint();
    }

    public void showWarningMessage () {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                JOptionPane.showMessageDialog(CorfuncGui.this, " Message window contains warnings",
                                              "Warning Message", JOptionPane.WARNING_MESSAGE);
            }
        });
        output.repaint();
        gotWarning=false;
    }

    public String processMessage (String message) {

        if(message.startsWith(" 100:")) {
            int index1 = message.indexOf(":");
            message=message.substring(index1+1);
            output.append(message+newline);
            //Ensure that message window scrolls
            Rectangle rview = scrollPane.getViewport().getViewRect();
            Dimension tpane = output.getPreferredSize();
            Rectangle r = new Rectangle(0,tpane.height-rview.height,rview.width,rview.height);
            scrollPane.getViewport().scrollRectToVisible(r);
        }
        else if(message.startsWith(" ERROR:")||message.startsWith(" WARNING")) {
            output.append(newline+"********** "+message+" **********"+newline+newline);
        }
        return message;
    }

    public class WIPOptionPaneListener implements PropertyChangeListener {
        Executable exec;

        public void setProcess(Executable exec) {
            this.exec=exec;
        }

        public void propertyChange(PropertyChangeEvent e) {
            final String prop = e.getPropertyName();
            SwingUtilities.invokeLater(new Runnable() {
                public void run() {
                    if (prop.equals(JOptionPane.VALUE_PROPERTY) ||
                        prop.equals(JOptionPane.INPUT_VALUE_PROPERTY)) {
                        try {
                            exec.kill();
                            exec=null;
                            WIPdialog.setVisible(false);
                            WIPdialog=null;
                            WIPoptionPane=null;
                            CorfuncGui.this.output.append(newline+"Terminated process"+newline);
                        }
                        catch(Exception ex) {
                        }
                    }
                }
            });
        }
    };

    private class HelpActionListener implements ActionListener{
        public void actionPerformed(ActionEvent e) {
            final ActionEvent event =e;
            SwingUtilities.invokeLater(new Runnable() {
                public void run() {
                    new CSH.DisplayHelpFromSource(hb).actionPerformed(event);
                }
            });
            CorfuncGui.this.update(CorfuncGui.this.getGraphics());
        }
    }

}
