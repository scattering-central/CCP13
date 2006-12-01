import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class FrameChooser extends JFrame implements ActionListener {
    private JPanel contentPane;
    private FramesPanel framesPanel;
    private JButton applyButton, cancelButton;
    private JLabel label;
    private int fframe, lframe, incframe;

    public FrameChooser (ActionListener frameChooserListener) {
        this.setResizable(false);
        GridBagLayout gridBag;
        GridBagConstraints c;

        //Set the look and feel
        try {
            UIManager.setLookAndFeel(
            UIManager.getCrossPlatformLookAndFeelClassName());
        } catch (Exception e) {}

        //Get the content pane and set layout manager
        contentPane = new JPanel();
        this.setContentPane(contentPane);
        gridBag = new GridBagLayout();
        c = new GridBagConstraints();
        contentPane.setLayout(gridBag);
        contentPane.setBorder(BorderFactory.createCompoundBorder(
                                BorderFactory.createEtchedBorder(),
                                BorderFactory.createEmptyBorder(10,0,0,0)));

        c.weightx=1;
        c.weighty=1;
        c.insets=new Insets(5,5,5,5);
        c.anchor=GridBagConstraints.CENTER;

        c.gridx=0;
        c.gridy=0;
        label=new JLabel("Display frames: ");
        gridBag.setConstraints(label, c);
        contentPane.add(label);

        c.gridx=1;
        framesPanel = new FramesPanel();
        framesPanel.firstFrameField.setText("1");
        framesPanel.lastFrameField.setText("1");
        framesPanel.incFrameField.setText("1");
        gridBag.setConstraints(framesPanel, c);
        contentPane.add(framesPanel);

        c.gridy=1;
        c.gridx=0;
        applyButton = new JButton("Apply");
        applyButton.addActionListener(frameChooserListener);
        gridBag.setConstraints(applyButton, c);
        contentPane.add(applyButton);

        c.gridx=1;
        cancelButton = new JButton("Cancel");
        cancelButton.addActionListener(this);
        gridBag.setConstraints(cancelButton, c);
        contentPane.add(cancelButton);

        this.setTitle("Frame Chooser");
        this.pack();
    }

    public void actionPerformed (ActionEvent e) {
        JButton source = (JButton) e.getSource();
        if (source==cancelButton)
            this.setVisible(false);
    }

    public int[] getFrameRange (){
        String par = new String();
        Integer integer;
        String string;
        int [] frames = new int[3];
        try {
            string = framesPanel.firstFrameField.getText().trim();
            par="first frame";
            if(string.length()>0) {
                integer = new Integer(string);
                fframe = integer.intValue();
            }else throw new NoParameterException("first frame");

            string = framesPanel.lastFrameField.getText().trim();
            par="last frame";
            if(string.length()>0) {
                integer = new Integer(string);
                lframe = integer.intValue();
            }else throw new NoParameterException("last frame");

            string = framesPanel.incFrameField.getText().trim();
            par="frame increment";
            if(string.length()>0) {
                integer = new Integer(string);
                incframe = integer.intValue();
            }else {
                incframe=1;
            if(fframe==lframe)
                incframe=1;
            }
            frames[0]=fframe;
            frames[1]=lframe;
            frames[2]=incframe;

            return frames;
        }
        catch(NumberFormatException e1) {
            JOptionPane.showMessageDialog(null, "Illegal value : \""+e1.getMessage()+
                                          "\" for "+par,
                                          "Error Message",JOptionPane.ERROR_MESSAGE);
            return null;
        }
        catch(Exception e2) {
            JOptionPane.showMessageDialog(null,e2.getMessage(),
                                          "Error Message", JOptionPane.ERROR_MESSAGE);
            return null;
        }
    }
}