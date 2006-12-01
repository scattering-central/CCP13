// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import java.lang.Boolean;

public class bslp_test extends JFrame
  {
  private bslp_panel_test bp;
  private JComboBox data_point_chooser; 
  private JComboBox data_point_primary_colour_chooser; 
  private JComboBox data_point_secondary_colour_chooser; 

  public  bslp_test ()
    {
    super("bslp test");

    JLabel data_point_chooser_label;
    JLabel data_point_primary_colour_chooser_label;
    JLabel data_point_secondary_colour_chooser_label;
    
    bp = new bslp_panel_test();
    getContentPane().add(bp,BorderLayout.NORTH);
    setSize(500,650);

    // Now add lower panel widgets
    JPanel lower_panel = new JPanel();
    
    data_point_chooser = new JComboBox( new String[]
       {"+",".","x","-"});
    data_point_primary_colour_chooser = new JComboBox( new String[]
       {"red","blue","green","black"});
    data_point_secondary_colour_chooser = new JComboBox( new String[]
       {"red","blue","green","black"});
    
    data_point_chooser.setSelectedIndex(1);
    data_point_primary_colour_chooser.setSelectedIndex(1);
    data_point_secondary_colour_chooser.setSelectedIndex(2);

    data_point_chooser.addItemListener(
      new ItemListener()  {
        int dummy;
        public void itemStateChanged (ItemEvent event)
          {
          if (event.getStateChange() == ItemEvent.SELECTED)
            {
            dummy = data_point_chooser.getSelectedIndex();

            if (dummy == 0)
              bp.set_data_point_plus();            
            else if (dummy == 1)
              bp.set_data_point_dot();            
            else if (dummy == 2)
              bp.set_data_point_cross();            
            else if (dummy == 3)
              bp.set_data_point_minus();            
          
            bp.redraw_plot();
            }
          }
        }
      ); 

    data_point_primary_colour_chooser.addItemListener(
      new ItemListener()  {
        int dummy;
        public void itemStateChanged (ItemEvent event)
          {
          if (event.getStateChange() == ItemEvent.SELECTED)
            {
            dummy = data_point_primary_colour_chooser.getSelectedIndex();

            if (dummy == 0)
              bp.set_data_point_primary_colour_red();            
            else if (dummy == 1)
              bp.set_data_point_primary_colour_blue();            
            else if (dummy == 2)
              bp.set_data_point_primary_colour_green();            
            else if (dummy == 3)
              bp.set_data_point_primary_colour_black();            
          
            bp.redraw_plot();
            }
          }
        }
      );

    data_point_secondary_colour_chooser.addItemListener(
      new ItemListener()  {
        int dummy;
        public void itemStateChanged (ItemEvent event)
          {
          if (event.getStateChange() == ItemEvent.SELECTED)
            {
            dummy = data_point_secondary_colour_chooser.getSelectedIndex();

            if (dummy == 0)
              bp.set_data_point_secondary_colour_red();            
            else if (dummy == 1)
              bp.set_data_point_secondary_colour_blue();            
            else if (dummy == 2)
              bp.set_data_point_secondary_colour_green();            
            else if (dummy == 3)
              bp.set_data_point_secondary_colour_black();            
          
            bp.redraw_plot();
            }
          }
        }
      );

    data_point_chooser_label = new JLabel("Char");
    data_point_primary_colour_chooser_label = 
         new JLabel("Colour 1");
    data_point_secondary_colour_chooser_label = 
         new JLabel("Colour 2");
 
    // Now add widgets to lower control panel 
    lower_panel.add(data_point_chooser_label);
    lower_panel.add(data_point_chooser);
    lower_panel.add(data_point_primary_colour_chooser_label);
    lower_panel.add(data_point_primary_colour_chooser);
    lower_panel.add(data_point_secondary_colour_chooser_label);
    lower_panel.add(data_point_secondary_colour_chooser);
    
    lower_panel.setPreferredSize(new Dimension(400,40)); 
    getContentPane().add(lower_panel,BorderLayout.SOUTH);
    setVisible(true);
    }

  public static void main (String args[])
    {
    bslp_test bt = new bslp_test();
    bt.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
  } 



