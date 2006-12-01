import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

//The FramesPanel class
public class FramesPanel extends JPanel{
    JTextField firstFrameField, lastFrameField, incFrameField;

    //Constructor
    public FramesPanel() {
        JLabel label;

        setLayout(new FlowLayout(FlowLayout.CENTER,0,0));

        firstFrameField = new JTextField("");
        firstFrameField.setPreferredSize(new Dimension(30,20));
        add(firstFrameField);

        label = new JLabel(" to ",JLabel.CENTER);
        add(label);

        lastFrameField = new JTextField("");
        lastFrameField.setPreferredSize(new Dimension(30,20));
        add(lastFrameField);

        label = new JLabel(" inc. ",JLabel.CENTER);
        add(label);

        incFrameField = new JTextField("");
        incFrameField.setPreferredSize(new Dimension(30,20));
        add(incFrameField);
    }
}