import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.util.*;

//The EditParametersFrame class
public class EditParametersFrame extends JFrame implements ActionListener {
    JLabel dataLabel, qaxLabel;
    JTextField iterationsField, maxDField, stepDField,
        fractionField;
    JButton editButton, editButton2;
    JComboBox transformBox, scaleBox, tailBox, backexBox;
    FramesPanel framesPanel;
    JCheckBox variableBox, retransBox, interfaceBox, userExtractBox;
    ChannelLimitsFrame channelLimitsFrame, channelLimitsFrame2;
    String par;

//added by DWF 12-July-2004
JPanel genPanel, fitPanel, transPanel, extractPanel, buttonsPanel;
JPanel contentPane ;
JPanel hilbertPanel ;
JTabbedPane tabbedPane;
JLabel maxDFieldLabel;
JLabel stepDFieldLabel;
JTextField qAxisDimsField;
JTextField polDensityField;
JComboBox qAxisBox;
JTextField adsorbedField;
JTextField accuracyField;


    int firstFrame, lastFrame, incFrame, iterations;
    Vector limitsData, limitsData2;
    float fraction, maxD, stepD;

//added by dwf
float polyDensity, normAccuracy, adsorbedAmount;


    boolean arbitraryScale, variableLimits, userExtract, retrans_opt, interface_opt;
    int tailFit, backEx;
    int maxFrame, minFrame;
    float maxChannel, minChannel;

    boolean stored_arbitraryScale, stored_variableLimits, stored_userExtract,
            stored_retrans_opt, stored_interface_opt;
    int stored_tailFit, stored_backEx;
    int stored_firstFrame, stored_lastFrame, stored_incFrame, stored_iterations;
    float stored_maxD, stored_stepD, stored_fraction;

    static final int SIGMOID=0;
    static final int POROD=1;
    static final int GUINIER=0;
    static final int VONK=1;

    //Constructor
    public EditParametersFrame() {
        this.setResizable(true);

//removed by DWF 12-July-2004
//JPanel genPanel, fitPanel, transPanel, extractPanel, buttonsPanel;


        JLabel label;
        GridBagLayout gridBag;
        GridBagConstraints c;
        JButton applyButton, cancelButton;

        //Initialise parameters
        firstFrame=1;
        lastFrame=1;
        incFrame=1;
        arbitraryScale=true;
        maxD=(float)200.0;
        stepD=(float)1.0;
        fraction=(float)0.5;
        variableLimits=false;
        userExtract=false;
        retrans_opt=true;
        interface_opt=true;
        iterations=100;
        tailFit=SIGMOID;
        backEx=GUINIER;

//added by dwf
adsorbedAmount = (float)1.0;
polyDensity = (float)1.0;
normAccuracy = (float)0.01;


        // Create the "Channel Limits" table
        channelLimitsFrame = new ChannelLimitsFrame();
        channelLimitsFrame2 = new ChannelLimitsFrame();
        channelLimitsFrame.pack();
        channelLimitsFrame2.pack();

        //Set the look and feel
        try {
            UIManager.setLookAndFeel(
              UIManager.getCrossPlatformLookAndFeelClassName());
        } catch (Exception e){}

        //Cancel on close
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                channelLimitsFrame.setVisible(false);
                channelLimitsFrame.resetParameters();
                channelLimitsFrame2.setVisible(false);
                channelLimitsFrame2.resetParameters();
                EditParametersFrame.this.resetParameters();
                EditParametersFrame.this.setVisible(false);
            }
        });

        //Get the content Pane

//removed by dwf
//  JPanel 

	contentPane = new JPanel();
        this.setContentPane(contentPane);
        contentPane.setLayout(new BoxLayout(contentPane,BoxLayout.Y_AXIS));

        //Create the "General" Panel
        genPanel = new JPanel();
        genPanel.setBorder(BorderFactory.createEtchedBorder());

        gridBag = new GridBagLayout();
        c = new GridBagConstraints();

        genPanel.setLayout(gridBag);
        c.weightx=1;
        c.weighty=1;
        c.insets=new Insets(5,5,5,5);
        c.anchor=GridBagConstraints.WEST;

        c.gridx=0;
        c.gridy=0;
        label = new JLabel("Data file : ",JLabel.LEFT);
        gridBag.setConstraints(label, c);
        genPanel.add(label);

        c.gridx=1;
        dataLabel = new JLabel("None",JLabel.LEFT);
        gridBag.setConstraints(dataLabel, c);
        genPanel.add(dataLabel);

        c.gridy=1;
        c.gridx=0;
        label = new JLabel("q-axis file : ",JLabel.LEFT);
        gridBag.setConstraints(label, c);
        genPanel.add(label);

        c.gridx=1;
        qaxLabel = new JLabel("None",JLabel.LEFT);
        gridBag.setConstraints(qaxLabel, c);
        genPanel.add(qaxLabel);

        c.gridy=2;
        c.gridx=0;
        label = new JLabel("Act on frames : ",JLabel.LEFT);
        gridBag.setConstraints(label, c);
        genPanel.add(label);

        c.gridx=1;
        c.gridwidth=5;
        framesPanel = new FramesPanel();
        gridBag.setConstraints((JPanel)framesPanel, c);
        framesPanel.firstFrameField.setText(String.valueOf(minFrame));
        framesPanel.lastFrameField.setText(String.valueOf(maxFrame));
        framesPanel.incFrameField.setText("1");
        genPanel.add((JPanel)framesPanel);

        c.gridx=0;
        c.gridy=3;
        c.gridwidth=1;
        label = new JLabel("Data scale : ",JLabel.LEFT);
        gridBag.setConstraints(label, c);
        genPanel.add(label);

        c.gridx=1;
        String [] scaleOptions = {
            " Arbitrary",
            " Absolute "
        };
        scaleBox = new JComboBox(scaleOptions);
        scaleBox.setPreferredSize(new Dimension (100,20));
        gridBag.setConstraints(scaleBox, c);
        genPanel.add(scaleBox);

        //Create the "Fitting" Panel
        fitPanel = new JPanel();
        fitPanel.setBorder(BorderFactory.createEtchedBorder());

        gridBag = new GridBagLayout();
        c = new GridBagConstraints();

        c.weightx=1;
        c.weighty=1;
        c.insets=new Insets(5,5,5,5);
        c.anchor=GridBagConstraints.WEST;

        fitPanel.setLayout(gridBag);

        c.gridx=0;
        c.gridy=3;
        c.gridwidth=1;
        variableBox = new JCheckBox(" Variable limits for tail fit",false);
        variableBox.addItemListener(new ItemListener () {
            public void itemStateChanged(ItemEvent e) {
                if(e.getStateChange()==ItemEvent.SELECTED) {
                    editButton.setEnabled(true);
                    variableLimits=true;
                }else {
                    editButton.setEnabled(false);
                    variableLimits=false;
                }
            }
        });
        gridBag.setConstraints(variableBox, c);
        fitPanel.add(variableBox);

        c.gridx=1;
        editButton = new JButton("Edit limits");
        editButton.setEnabled(false);
        editButton.setPreferredSize(new Dimension (115,20));
        editButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                channelLimitsFrame.setFirstFrame(minFrame);
                channelLimitsFrame.setLastFrame(maxFrame);
                channelLimitsFrame.setLocation((int)EditParametersFrame.this.getLocation().getX()+50,
                                               (int)EditParametersFrame.this.getLocation().getY()+50);
                channelLimitsFrame.storeParameters();
                channelLimitsFrame.setVisible(true);
            }
        });
        gridBag.setConstraints(editButton, c);
        fitPanel.add(editButton);

        c.gridx=0;
        c.gridy=2;
        label = new JLabel("No. of iterations for tail fit : ",JLabel.LEFT);
        gridBag.setConstraints(label, c);
        fitPanel.add(label);

        c.gridx=1;
        iterationsField = new JTextField("");
        iterationsField.setPreferredSize(new Dimension(40,20));
        gridBag.setConstraints(iterationsField, c);
        fitPanel.add(iterationsField);

        c.gridx=0;
        c.gridy=1;
        label = new JLabel("Tail fit : ",JLabel.LEFT);
        gridBag.setConstraints(label, c);
        fitPanel.add(label);

        c.gridx=1;
        String [] tailOptions = {
            " Sigmoid",
            " Porod  "
        };
        tailBox = new JComboBox(tailOptions);
        tailBox.setPreferredSize(new Dimension (100,20));
        tailBox.setEditable(false);
        gridBag.setConstraints(tailBox, c);
        fitPanel.add(tailBox);

        c.gridx=0;
        c.gridy=0;
        label = new JLabel("Back extrapolation : ",JLabel.LEFT);
        gridBag.setConstraints(label, c);
        fitPanel.add(label);

        c.gridx=1;
        String [] backexOptions = {
            " Guinier",
            " Vonk   "
        };
        backexBox = new JComboBox(backexOptions);
        backexBox.setPreferredSize(new Dimension (100,20));
        backexBox.setEditable(false);
        gridBag.setConstraints(backexBox, c);
        fitPanel.add(backexBox);

        //Create the "Transform" Panel
        transPanel = new JPanel();
        transPanel.setBorder(BorderFactory.createEtchedBorder());

        gridBag = new GridBagLayout();
        c = new GridBagConstraints();

        c.weightx=1;
        c.weighty=1;
        c.insets=new Insets(5,5,5,5);
        c.anchor=GridBagConstraints.WEST;

        transPanel.setLayout(gridBag);

        c.gridx=0;
        c.gridy=2;
        c.gridwidth=2;

        retransBox = new JCheckBox(" Calculate re-transform",true);
        gridBag.setConstraints(retransBox, c);
        transPanel.add(retransBox);


        c.gridx=0;
        c.gridy=3;
        label = new JLabel("Transform type : ",JLabel.LEFT);
        gridBag.setConstraints(label, c);
        transPanel.add(label);
        
	c.gridx=1;
        c.gridy=3;
        String [] transformOptions = {
            " Standard",
            " Hilbert"
        };
        transformBox = new JComboBox(transformOptions);

//dwf - add an actionListener to the combo box, so we can detect when it chages
transformBox.addActionListener(this);


        transformBox.setPreferredSize(new Dimension (100,20));
        gridBag.setConstraints(transformBox, c);
        
        // This "turns on" MJR's Transform Option Box
        transPanel.add(transformBox);

        c.gridwidth=1;
        c.gridy=0;
        c.gridx=0;

//removed by dwf
//label = new JLabel("Max d for FT (Angstrom) : ",JLabel.LEFT);
//added by dwf
maxDFieldLabel = new JLabel("Max d for FT (Angstrom) : ",JLabel.LEFT);


        gridBag.setConstraints(maxDFieldLabel , c);
        transPanel.add(maxDFieldLabel );

        c.gridx=1;
        maxDField = new JTextField("");
        maxDField.setPreferredSize(new Dimension(40,20));
        gridBag.setConstraints(maxDField, c);
        transPanel.add(maxDField);

        c.gridx=0;
        c.gridy=1;

//removed by dwf
//label = new JLabel("Step in d for FT (Angstrom) : ",JLabel.LEFT);
//added by dwf
stepDFieldLabel = new JLabel("Step in d for FT (Angstrom) : ",JLabel.LEFT);

        gridBag.setConstraints(stepDFieldLabel , c);
        transPanel.add(stepDFieldLabel );

        c.gridx=1;
        stepDField = new JTextField("");
        stepDField.setPreferredSize(new Dimension(40,20));
        gridBag.setConstraints(stepDField, c);
        transPanel.add(stepDField);

        //Create the Extraction Panel
        extractPanel = new JPanel();
        extractPanel.setBorder(BorderFactory.createEtchedBorder());

        gridBag = new GridBagLayout();
        c = new GridBagConstraints();

        c.weightx=1;
        c.weighty=1;
        c.insets=new Insets(5,5,5,5);
        c.anchor=GridBagConstraints.WEST;

        extractPanel.setLayout(gridBag);

        c.gridx=0;
        c.gridy=0;
        c.gridwidth=2;

        interfaceBox = new JCheckBox(" Calculate interface distribution function",true);
        gridBag.setConstraints(interfaceBox, c);
        extractPanel.add(interfaceBox);

        c.gridy=1;
        c.gridwidth=1;
        userExtractBox = new JCheckBox(" User control of extraction",false);
        userExtractBox.addItemListener(new ItemListener () {
            public void itemStateChanged(ItemEvent e) {
                if(e.getStateChange()==ItemEvent.SELECTED) {
                    editButton2.setEnabled(true);
                    userExtract=true;
                }else {
                    editButton2.setEnabled(false);
                    userExtract=false;
                }
            }
        });
        gridBag.setConstraints(userExtractBox, c);
        userExtractBox.setEnabled(false);
        extractPanel.add(userExtractBox);

        c.gridx=1;
        editButton2 = new JButton("Edit limits");
        editButton2.setEnabled(false);
        editButton2.setPreferredSize(new Dimension (115,20));
        editButton2.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                channelLimitsFrame.setFirstFrame(1);
                channelLimitsFrame2.setLocation((int)EditParametersFrame.this.getLocation().getX()+50,
                                               (int)EditParametersFrame.this.getLocation().getY()+50);
                channelLimitsFrame2.storeParameters();
                channelLimitsFrame2.setVisible(true);
            }
        });
        gridBag.setConstraints(editButton2, c);
        editButton2.setEnabled(false);
        extractPanel.add(editButton2);

        c.gridwidth=1;
        c.gridx=0;
        c.gridy=2;
        label = new JLabel("Volume fraction crystallinity (%) : ",JLabel.LEFT);
        gridBag.setConstraints(label, c);
        extractPanel.add(label);

        c.gridx=1;
        fractionField = new JTextField("");
        fractionField.setPreferredSize(new Dimension(40,20));
        gridBag.setConstraints(fractionField, c);
        extractPanel.add(fractionField);

        //Set the defaults
        maxDField.setText("200");
        stepDField.setText("1");
        fractionField.setText("50");
        iterationsField.setText("100");





//added by dwf - begin
//Create the "Hilbert" Panel
        hilbertPanel = new JPanel();
        hilbertPanel.setBorder(BorderFactory.createEtchedBorder());

        gridBag = new GridBagLayout();
        c = new GridBagConstraints();

        c.weightx=1;
        c.weighty=1;
        c.insets=new Insets(5,5,5,5);
        c.anchor=GridBagConstraints.WEST;

        hilbertPanel.setLayout(gridBag);


        c.gridwidth=1;
        c.gridy=0;
        c.gridx=0;
	  JLabel qAxisDimsLabel = new JLabel("q-axis dimensions : ",JLabel.LEFT);
        gridBag.setConstraints(qAxisDimsLabel , c);
        hilbertPanel.add(qAxisDimsLabel );

        c.gridx=1;
	  String [] qAxisOptions = {
            " /Angstrom",
            " /nm"
        };
        qAxisBox = new JComboBox(qAxisOptions);
        qAxisBox.setPreferredSize(new Dimension (100,20));
        gridBag.setConstraints(qAxisBox, c);        
        hilbertPanel.add(qAxisBox);



        c.gridx=0;
        c.gridy=1;
	  JLabel polDensityLabel = new JLabel("Bulk density of polymer [g/cm3] : ",JLabel.LEFT);
        gridBag.setConstraints(polDensityLabel , c);
        hilbertPanel.add(polDensityLabel );

        c.gridx=1;
        polDensityField = new JTextField("");
        polDensityField.setPreferredSize(new Dimension(40,20));
	  polDensityField.setText("1.0");
        gridBag.setConstraints(polDensityField, c);
        hilbertPanel.add(polDensityField);




        c.gridx=0;
        c.gridy=2;
	  JLabel adsorbedLabel = new JLabel("Adsorbed amount [mg/m2] : ",JLabel.LEFT);
        gridBag.setConstraints(adsorbedLabel , c);
        hilbertPanel.add(adsorbedLabel );

        c.gridx=1;
        adsorbedField= new JTextField("");
        adsorbedField.setPreferredSize(new Dimension(40,20));
	  adsorbedField.setText("1.0");
        gridBag.setConstraints(adsorbedField, c);
        hilbertPanel.add(adsorbedField);




   	  c.gridx=0;
        c.gridy=3;
	  JLabel accuracyLabel = new JLabel("Normalisation accuracy : ",JLabel.LEFT);
        gridBag.setConstraints(accuracyLabel , c);
        hilbertPanel.add(accuracyLabel );

        c.gridx=1;
        accuracyField= new JTextField("");
        accuracyField.setPreferredSize(new Dimension(40,20));
	  accuracyField.setText("0.01");
        gridBag.setConstraints(accuracyField, c);
        hilbertPanel.add(accuracyField);

// dwf - end






        //Create a Tabbed Pane
//removed by dwf
//JTabbedPane 
	
	  tabbedPane = new JTabbedPane();
        tabbedPane.addTab("General", genPanel);
        tabbedPane.addTab("Fit", fitPanel);
        tabbedPane.addTab("Transform",transPanel);
        tabbedPane.addTab("Extraction",extractPanel);

//added by dwf
tabbedPane.addTab("Hilbert",hilbertPanel);


        tabbedPane.setBorder(BorderFactory.createEmptyBorder(10,10,10,10));

        contentPane.add(tabbedPane);

        //Make the buttons Panel
        buttonsPanel = new JPanel();
        buttonsPanel.setLayout(new BorderLayout());

        //Add the apply Button
        applyButton = new JButton("Apply");
        applyButton.addActionListener(this);
        buttonsPanel.add(applyButton,BorderLayout.WEST);

        //Add the cancel Button
        cancelButton = new JButton("Cancel");
        cancelButton.addActionListener(this);
        buttonsPanel.add(cancelButton,BorderLayout.EAST);

        buttonsPanel.setBorder(BorderFactory.createEmptyBorder(0,30,20,30));

        //Add the buttons Panel
        contentPane.add(Box.createRigidArea(new Dimension(0,5)));
        contentPane.add(buttonsPanel);
        this.pack();

//added by dwf
//disable Hilbert Panel
tabbedPane.setEnabledAt(4, false);

    }//end constructor

    //actionPerformed method for the Apply button
    public void actionPerformed(ActionEvent e1){


//dwf 12/07/04 begin
	if (e1.getSource() == transformBox){
		if (transformBox.getSelectedIndex()==1) {    //if Hilbert
			retransBox.setEnabled(false);
			maxDField.setEnabled(false);
			stepDField.setEnabled(false);
			stepDFieldLabel.setEnabled(false);
			maxDFieldLabel.setEnabled(false);
			tabbedPane.setEnabledAt(3, false); //disable Extraction panel
			tabbedPane.setEnabledAt(4, true);	//enable Hilbert panel


		} else {
			retransBox.setEnabled(true);
			maxDField.setEnabled(true);
			stepDField.setEnabled(true);
			stepDFieldLabel.setEnabled(true);
			maxDFieldLabel.setEnabled(true);
			tabbedPane.setEnabledAt(3, true); //enable Extraction panel
			tabbedPane.setEnabledAt(4, false); //disable Hilbert panel

		}//end if

	}//end if
//dwf end



        if (e1.getActionCommand().startsWith("Apply")) {
            try {
                this.getParameters();
                this.setVisible(false);
                if(channelLimitsFrame.isVisible()){
                    channelLimitsFrame.setVisible(false);
                    channelLimitsFrame.resetParameters();
                }
                if(channelLimitsFrame2.isVisible()){
                    channelLimitsFrame2.setVisible(false);
                    channelLimitsFrame2.resetParameters();
                }
            }
            catch (NoParameterException e2) {
                JOptionPane.showMessageDialog(null,e2.getMessage());
            }
            catch (NumberFormatException e) {
                JOptionPane.showMessageDialog(null, "Illegal value : \""+e.getMessage()+
                                              "\" for "+par,
                                              "Error Message",JOptionPane.ERROR_MESSAGE);
            }
            catch (Exception e3) {
                JOptionPane.showMessageDialog(null,e3.getMessage(),
                                            "Error Message", JOptionPane.ERROR_MESSAGE);
            }
        }
        else if (e1.getActionCommand().startsWith("Cancel")) {
            channelLimitsFrame.setVisible(false);
            channelLimitsFrame.resetParameters();
            channelLimitsFrame2.setVisible(false);
            channelLimitsFrame2.resetParameters();
            resetParameters();
            this.setVisible(false);
        }
    }

    //Check the input is legal and get the parameters for the application
    public void getParameters () throws NoParameterException,
                                        Exception,
                                        NumberFormatException {

        //Get parameters from the JComboBoxes
        if(((String)scaleBox.getSelectedItem()).startsWith(" Arb"))
            arbitraryScale=true;
        else
            arbitraryScale=false;
        if(((String)tailBox.getSelectedItem()).startsWith(" Sig"))
            tailFit=SIGMOID;
        else
            tailFit=POROD;
        if(((String)backexBox.getSelectedItem()).startsWith(" Guin"))
            backEx=GUINIER;
        else
            backEx=VONK;

        //Verify and get text field info
        String string;
        Integer integer;
        Float floating;
        JTextField field;

        getFrameRange();

        field = framesPanel.incFrameField;
        par = new String ("increment in data frames");
        string = field.getText().trim();
        if(string.length()>0) {
            integer = new Integer(string);
            incFrame = integer.intValue();
        }else throw new NoParameterException(par);

        field = iterationsField;
        par = new String("number of iterations for tailfit");
        string = field.getText().trim();
        if(string.length()>0) {
            integer = new Integer(string);
            iterations = integer.intValue();
        }else throw new NoParameterException(par);

        par = new String ("max d for FT");
        string = maxDField.getText().trim();
        if(string.length()>0) {
            floating = new Float(string);
            maxD = floating.floatValue();
        }else throw new NoParameterException(par);

        par = new String ("step in d for FT");
        string = stepDField.getText().trim();
        if(string.length()>0) {
            floating = new Float(string);
            stepD = floating.floatValue();
        }else throw new NoParameterException(par);

        par = new String("volume fraction crystallinity");
        string = fractionField.getText().trim();
        if(string.length()>0) {
            floating = new Float(string);
            fraction = floating.floatValue()/(float)100.;
        }else throw new NoParameterException(par);

        if(retransBox.isSelected())
            retrans_opt=true;
        else
            retrans_opt=false;

        if(interfaceBox.isSelected())
            interface_opt=true;
        else
            interface_opt=false;

        //Check that parameters are sensible
        if(firstFrame<=0||firstFrame>maxFrame)
            throw new Exception("First data frame must be in the range "+1+"-"+maxFrame);
        if(lastFrame<=0||lastFrame>maxFrame)
            throw new Exception("Last data frame must be in the range "+1+"-"+maxFrame);
        if(lastFrame<firstFrame)
            throw new Exception("Last data frame cannot be lower than the first");
        if(firstFrame==lastFrame)
            incFrame=1;
        if(maxD<=0)
            throw new Exception("Max d for FT must be positive");
        if(stepD<=0)
            throw new Exception("Step in d for FT must be positive");
        if(stepD>=maxD)
            throw new Exception("Step in d for FT must be less than max d");
        if((maxD/stepD)>511.0F)
            throw new Exception("Number of steps in d must not exceed 511");
        if(fraction<0||fraction>1)
            throw new Exception("Volume fraction crystallinity must be in the range 0-100%");
        if(iterations<=0)
            throw new Exception("Number of iterations for tailfit must be positive");
        if(variableLimits) {
            limitsData=channelLimitsFrame.getData();
            if(limitsData.isEmpty())
                throw new NoParameterException("variable limits for tail-fitting");
/*            else {
                for(int i=0; i<limitsData.size();i+=4) {
                    if( ((Integer)limitsData.elementAt(i+2)).intValue()<=minChannel )
                        throw new Exception("First channel limit at element "+
                                           (i/4+1)+" preceeds start of data");
                }
            }
*/
        }


//added by dwf
	  if (transformBox.getSelectedIndex()==1) {    //if Hilbert

		par = new String ("Bulk density of polymer (Hilbert Panel)");
	      string = polDensityField.getText().trim();
		
		if(string.length()>0) {
            	floating = new Float(string);
			
            	polyDensity = floating.floatValue();			
			if ((polyDensity < 0.5F) || (polyDensity > 2.0F)) {
				throw new Exception("Bulk density of polymer must be between 0.5 and 2.0 (Hilbert Panel)");
			} 
	      }else throw new NoParameterException(par);
		

		par = new String ("Adsorbed amount (Hilbert Panel)");
	      string = adsorbedField.getText().trim();
		if(string.length()>0) {
            	floating = new Float(string);
            	adsorbedAmount = floating.floatValue();
			if ((adsorbedAmount < 0.0F) || (adsorbedAmount > 100.0F)) {
				throw new Exception("Adsorbed amount must be between 0.0 and 100.0 (Hilbert Panel)");
			} 			
	      }else throw new NoParameterException(par);


		par = new String ("Normalisation accuracy (Hilbert Panel)");
	      string = accuracyField.getText().trim();
		if(string.length()>0) {
            	floating = new Float(string);
            	normAccuracy = floating.floatValue();
			if ((normAccuracy < 0.0F) || (normAccuracy > 1.0F)) {
				throw new Exception("Normalisation accuracy must be between 0.0 and 1.0 (Hilbert Panel)");
			} 
	      }else throw new NoParameterException(par);


	  }//end if







        if(userExtract) {
            limitsData2=channelLimitsFrame2.getData();
            if(limitsData2.isEmpty())
                throw new NoParameterException("limits for user-controlled parameter extraction");
        }
    }

    public void getFrameRange () throws NoParameterException,
                                    Exception,
                                    NumberFormatException {
        String string;
        Integer integer;
        JTextField field;

        field = framesPanel.firstFrameField;
        par = new String("first data frame");
        string = field.getText().trim();
        if(string.length()>0) {
            integer = new Integer(string);
            firstFrame = integer.intValue();
        }else throw new NoParameterException(par);

        field = framesPanel.lastFrameField;
        par = new String("last data frame");
        string = field.getText().trim();
        if(string.length()>0) {
            integer = new Integer(string);
            lastFrame = integer.intValue();
        }else throw new NoParameterException(par);
    }

    public void setMaxFrame(int maxFrame) {
        this.maxFrame=maxFrame;
        framesPanel.lastFrameField.setText(String.valueOf(maxFrame));
        lastFrame=maxFrame;
        channelLimitsFrame.setMaxFrame(maxFrame);
    }

    public void setMinFrame(int minFrame) {
        this.minFrame=minFrame;
        framesPanel.firstFrameField.setText(String.valueOf(minFrame));
        firstFrame=minFrame;
        channelLimitsFrame.setMinFrame(minFrame);
    }

    public void setMaxChannel(float maxChannel) {
        this.maxChannel=maxChannel;
        channelLimitsFrame.setMaxChannel(maxChannel);
    }

    public void setMinChannel(float minChannel) {
        this.minChannel=minChannel;
        channelLimitsFrame.setMinChannel(minChannel);
    }

    public void enableUserExtractBox(boolean val) {
        userExtractBox.setEnabled(val);
        if(!val) {
            userExtractBox.setSelected(val);
            editButton2.setEnabled(false);
        }
    }

    public void turnoffVariableBox() {
        variableBox.setSelected(false);
        editButton.setEnabled(false);
    }

    public void storeParameters() {
        stored_arbitraryScale=arbitraryScale;
        stored_tailFit=tailFit;
        stored_backEx=backEx;
        stored_firstFrame=firstFrame;
        stored_lastFrame=lastFrame;
        stored_incFrame=incFrame;
        stored_iterations=iterations;
        stored_variableLimits=variableLimits;
        stored_maxD=maxD;
        stored_stepD=stepD;
        stored_retrans_opt=retrans_opt;
        stored_interface_opt=interface_opt;
        stored_userExtract=userExtract;
        stored_fraction=fraction;
    }

    public void resetParameters() {
        variableBox.setSelected(stored_variableLimits);
        editButton.setEnabled(stored_variableLimits);
        userExtractBox.setSelected(stored_userExtract);
        editButton2.setEnabled(stored_userExtract);
        retransBox.setSelected(stored_retrans_opt);
        interfaceBox.setSelected(stored_interface_opt);
        framesPanel.firstFrameField.setText(String.valueOf(stored_firstFrame));
        framesPanel.lastFrameField.setText(String.valueOf(stored_lastFrame));
        framesPanel.incFrameField.setText(String.valueOf(stored_incFrame));
        maxDField.setText(String.valueOf(stored_maxD));
        stepDField.setText(String.valueOf(stored_stepD));
        fractionField.setText(String.valueOf(stored_fraction*100.));
        tailBox.setSelectedIndex(stored_tailFit);
        backexBox.setSelectedIndex(stored_backEx);
        iterationsField.setText(String.valueOf(stored_iterations));
        if(stored_arbitraryScale)
            scaleBox.setSelectedIndex(0);
        else
            scaleBox.setSelectedIndex(1);
    }
}
