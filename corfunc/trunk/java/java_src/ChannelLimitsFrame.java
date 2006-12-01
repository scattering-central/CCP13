import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;
import java.util.*;

//The ChannelLimitsFrame class
//Allows variable channel limits to be selected for tailfitting over multiple frames
public class ChannelLimitsFrame extends JFrame implements ActionListener {
    JPanel contentPane;
    JButton addButton, deleteButton, applyButton, cancelButton;
    JList list;
    DefaultListModel listModel;
    JTextField f1TextField, f2TextField, c1TextField, c2TextField;
    JScrollPane listScrollPane;
    GridBagLayout gridBag = new GridBagLayout();
    GridBagConstraints c = new GridBagConstraints();
    Vector data = new Vector(4,0);
    Vector stored_data;
    Dimension dim = new Dimension(30,20);
    String par;
    int maxFrame, minFrame;
    float maxChannel, minChannel, firstChannel, lastChannel;
    boolean full;

    public ChannelLimitsFrame() {
        //Set the title
        super("Variable limits");
        full=false;
        this.setResizable(false);

        //Set the look and feel
        try {
            UIManager.setLookAndFeel(
              UIManager.getCrossPlatformLookAndFeelClassName());
        } catch (Exception e) {}

        //cancel on close
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                ChannelLimitsFrame.this.setVisible(false);
                ChannelLimitsFrame.this.resetParameters();
            }
        });

        //Get the content pane and set layout manager
        contentPane = new JPanel();
        this.setContentPane(contentPane);
        contentPane.setLayout(new BoxLayout(contentPane,BoxLayout.Y_AXIS));

        //Create the column headers and text fields panel
        JLabel label;
        JPanel panel = new JPanel();
        panel.setLayout(gridBag);
        c.gridx=0;
        c.gridy=0;
        c.weightx=1;
        c.weighty=1;
        c.insets=new Insets(5,5,5,5);
        c.anchor=GridBagConstraints.CENTER;

        c.gridwidth=2;
        label = new JLabel("Frames",JLabel.CENTER);
        gridBag.setConstraints(label,c);
        panel.add(label);

        c.gridx=3;
        label = new JLabel("Limits",JLabel.CENTER);
        gridBag.setConstraints(label,c);
        panel.add(label);

        c.gridy=1;
        c.gridx=0;
        c.gridwidth=1;
        label = new JLabel("First",JLabel.CENTER);
        gridBag.setConstraints(label,c);
        panel.add(label);

        c.gridx=1;
        label = new JLabel("Last",JLabel.CENTER);
        gridBag.setConstraints(label,c);
        panel.add(label);

        c.gridx=3;
        label = new JLabel("First",JLabel.CENTER);
        gridBag.setConstraints(label,c);
        panel.add(label);

        c.gridx=4;
        label = new JLabel("Last",JLabel.CENTER);
        gridBag.setConstraints(label,c);
        panel.add(label);

        c.gridy=2;
        c.gridx=0;
        f1TextField=new JTextField();
        f1TextField.setPreferredSize(dim);
        f1TextField.setEnabled(false);
        gridBag.setConstraints(f1TextField,c);
        panel.add(f1TextField);

        c.gridx=1;
        f2TextField=new JTextField();
        f2TextField.setPreferredSize(dim);
        gridBag.setConstraints(f2TextField,c);
        panel.add(f2TextField);

        c.gridx=3;
        c1TextField=new JTextField();
        c1TextField.setPreferredSize(dim);
        gridBag.setConstraints(c1TextField,c);
        panel.add(c1TextField);

        c.gridx=4;
        c2TextField=new JTextField();
        c2TextField.setPreferredSize(dim);
        gridBag.setConstraints(c2TextField,c);
        panel.add(c2TextField);

        contentPane.add(panel);

        //Create the list model
        listModel = new DefaultListModel();
        list = new JList(listModel);
        list.setRequestFocusEnabled(false);
        list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        list.setSelectionBackground(Color.white);

        //Create the scrolling list window
        listScrollPane = new JScrollPane(list);
        contentPane.add(listScrollPane);

        //Create Buttons
        addButton = new JButton("Add");
        addButton.addActionListener(this);
        deleteButton = new JButton("Delete");
        deleteButton.setEnabled(false);
        deleteButton.addActionListener(this);
        applyButton = new JButton("Apply");
        applyButton.addActionListener(this);
        cancelButton = new JButton("Cancel");
        cancelButton.addActionListener(this);
        JPanel buttonsPanel = new JPanel();
        buttonsPanel.add(addButton);
        buttonsPanel.add(deleteButton);
        buttonsPanel.add(applyButton);
        buttonsPanel.add(cancelButton);
        contentPane.add(buttonsPanel);
    }

    //actionPerformed method for buttons
    public void actionPerformed(ActionEvent e) {
        if (e.getActionCommand().startsWith("Add")) {
            try {
                addItems();
            }
            catch (NoParameterException e1) {
                JOptionPane.showMessageDialog(null,e1.getMessage());
            }
            catch (NumberFormatException e2) {
            JOptionPane.showMessageDialog(null, "Illegal value : \""+e2.getMessage()+
                                          "\" for "+par,"Error Message",
                                          JOptionPane.ERROR_MESSAGE);
            }
            catch(Exception e3) {
            JOptionPane.showMessageDialog(null,e3.getMessage(),"Error message",
                                          JOptionPane.ERROR_MESSAGE);
            }
        }
        else if(e.getActionCommand().startsWith("Del")) {
            deleteItems();
        }
        else if(e.getActionCommand().startsWith("Apply")) {
            //Check that the range of frames are fully covered
            if(!data.isEmpty()) {
                if( ((Integer)data.elementAt(data.size()-3)).intValue()<maxFrame)
                    JOptionPane.showMessageDialog(null,"Specify all frames up to "+maxFrame,"Error message",
                                                  JOptionPane.ERROR_MESSAGE);
                else
                  this.setVisible(false);
            }
            else
                this.setVisible(false);
        }
        else if(e.getActionCommand().startsWith("Cancel")) {
            this.setVisible(false);
            this.resetParameters();
        }
    }

    // Add iems to the list
    public void addItems() throws NoParameterException, Exception, NumberFormatException {

        //Get the text field contents
        String[] text = new String[4];

        String[] parameter = {"first frame","last frame","first limit","last limit"};

        if ( (text[0]=f1TextField.getText().trim()).length()==0 )
            throw new NoParameterException(parameter[0]);
        if ( (text[1]=f2TextField.getText().trim()).length()==0 )
            throw new NoParameterException(parameter[1]);
        if ( (text[2]=c1TextField.getText().trim()).length()==0 )
            throw new NoParameterException(parameter[2]);
        if ( (text[3]=c2TextField.getText().trim()).length()==0 )
            throw new NoParameterException(parameter[3]);

        //Check these are integers/floats
        Integer[] integerValue = new Integer[2];
        Float [] floatValue = new Float[2];
        int[] intVal = new int[2];
        float[] floatVal = new float[2];
        for(int i=0;i<2;i++) {
            par=parameter[i];
            integerValue[i] = new Integer(text[i]);
            intVal[i] = integerValue[i].intValue();
        }
        for(int i=0,j=2;i<2;i++,j++) {
            par=parameter[j];
            floatValue[i] = new Float(text[j]);
            floatVal[i] = floatValue[i].floatValue();
        }

        //Check that limits are sensible
        for(int i=0;i<2;i++) {
            if (intVal[i]<=0||intVal[i]>maxFrame)
                throw new Exception(parameter[i]+" must be in the range "+1+" to "+maxFrame);
        }
        for(int i=0,j=2;i<2;i++,j++) {
            if (floatVal[i]<minChannel||floatVal[i]>maxChannel) {
                throw new Exception(parameter[j]+" must be in the range "+minChannel+" to "+maxChannel);
            }
        }
        if (intVal[1]<intVal[0])
            throw new Exception("Last frame cannot be lower than the first");
        if (floatVal[1]<floatVal[0])
            throw new Exception("Last limit cannot be lower than the first");

        //Check that these frame limits don't overlap with any other frame limits
        if(!data.isEmpty()){
            for(int i=0;i<data.size();i+=4) {
                if( (intVal[0]>=((Integer)data.elementAt(i)).intValue()
                    &&intVal[0]<=((Integer)data.elementAt(i+1)).intValue())||
                    (intVal[1]>=((Integer)data.elementAt(i)).intValue()
                    &&intVal[1]<=((Integer)data.elementAt(i+1)).intValue()) )
                    throw new Exception("This range overlaps the range in element "+(i/4+1));
            }
        }

        //Set the new first frame field to be this last frame + 1
        if(intVal[1]!=maxFrame) {
            setFirstFrame(intVal[1]+1);
            setLastFrame(maxFrame);
        }
        else {
        //If covered whole range, disable the text fields
            full=true;
            f2TextField.setEnabled(false);
            c1TextField.setEnabled(false);
            c2TextField.setEnabled(false);
        }

        //Add to the data Vector
        for(int i=0;i<2;i++) {
            data.addElement(integerValue[i]);
        }
        for(int i=0;i<2;i++) {
            data.addElement(floatValue[i]);
        }

        //Update the list
        listModel.addElement("Frames "+text[0]+" - "+
                             text[1]+"      "+
                             "Limits "+text[2]+" - "+
                             text[3]);
        int size = listModel.getSize();
        list.setSelectedIndex(--size);
        size++;

        //Enable the delete and apply buttons
        if (size > 0) {
            deleteButton.setEnabled(true);
        }
    }

    //Delete items from the list
    public void deleteItems() {
        //Update the list
        int index = listModel.getSize()-1;
        listModel.removeElementAt(index);

        //Update the data Vector
        for(int i=3;i>=0;i--) {
            data.removeElementAt((index*4)+i);
        }

        //If no longer full, enable the text fields
            f2TextField.setEnabled(true);
            c1TextField.setEnabled(true);
            c2TextField.setEnabled(true);

        int size = listModel.getSize();
        //No items left, disable delete and apply
        if (size == 0) {
            deleteButton.setEnabled(false);

            setFirstFrame(minFrame);
            setLastFrame(maxFrame);

        //Adjust the selection
        }else {
            if (index == size)//removed item in last position
                index--;
            list.setSelectedIndex(index);   //otherwise select same index

            int fframe = ((Integer)data.elementAt(data.size()-3)).intValue();
            setFirstFrame(++fframe);
            setLastFrame(maxFrame);
        }

    }

    public void clear () {
        //Update the list
        int index = listModel.getSize()-1;
        for(int i=index;i>=0;i--) {
            //Update the list model
            listModel.removeElementAt(i);
            //Update the data Vector
            for(int j=3;j>=0;j--) {
                data.removeElementAt((i*4)+j);
            }
        }
        //Set up defaults
        f2TextField.setEnabled(true);
        c1TextField.setEnabled(true);
        c2TextField.setEnabled(true);
        deleteButton.setEnabled(false);
        setFirstFrame(minFrame);
        setLastFrame(maxFrame);
    }

    public void setMaxFrame(int maxFrame) {
        this.maxFrame=maxFrame;
    }

    public void setMinFrame(int minFrame) {
        this.minFrame=minFrame;
    }

    public void setMaxChannel(float maxChannel) {
        this.maxChannel=maxChannel;
    }

    public void setMinChannel(float minChannel) {
        this.minChannel=minChannel;
    }

    public void setFirstFrame(int firstFrame) {
        f1TextField.setText(String.valueOf(firstFrame));
    }

    public void setLastFrame(int lastFrame) {
        f2TextField.setText(String.valueOf(lastFrame));
    }

    public void setFirstChannel(float firstChannel) {
        this.firstChannel=firstChannel;
        c1TextField.setText(String.valueOf(firstChannel));
    }

    public void setLastChannel(float lastChannel) {
        this.lastChannel=lastChannel;
        c2TextField.setText(String.valueOf(lastChannel));
    }

    public Vector getData() {
        return data;
    }

    public void storeParameters () {
        stored_data = (Vector) data.clone();
        if(stored_data.isEmpty()) {
            c1TextField.setText("");
            c2TextField.setText("");
        }
    }

    public void resetParameters() {
        //Clear the data
        int index = listModel.getSize()-1;
        for(int i=index;i>=0;i--) {
            //Update the list model
            listModel.removeElementAt(i);
            //Update the data Vector
            for(int j=3;j>=0;j--) {
                data.removeElementAt((i*4)+j);
            }
        }
        if(!stored_data.isEmpty()) {
            f2TextField.setEnabled(false);
            c1TextField.setEnabled(false);
            c2TextField.setEnabled(false);
            deleteButton.setEnabled(true);
        } else {
            setFirstFrame(minFrame);
            setLastFrame(maxFrame);
            c1TextField.setText("");
            c2TextField.setText("");
            f2TextField.setEnabled(true);
            c1TextField.setEnabled(true);
            c2TextField.setEnabled(true);
            deleteButton.setEnabled(false);
        }
        //Reload stored data
        data=(Vector)stored_data.clone();
        String[] text = new String[4];
        if(!data.isEmpty()) {
            for(int i=0; i<data.size(); i+=4) {
                text[0]=((Integer)data.elementAt(i)).toString();
                text[1]=((Integer)data.elementAt(i+1)).toString();
                text[2]=((Float)data.elementAt(i+2)).toString();
                text[3]=((Float)data.elementAt(i+3)).toString();
                listModel.addElement("Frames "+text[0]+" - "+
                                     text[1]+"      "+
                                     "Limits "+text[2]+" - "+
                                     text[3]);
            }
            int size = listModel.getSize();
            list.setSelectedIndex(--size);
            size++;
        }
    }
}