// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import java.lang.Boolean;

// This is the envirnment class for hosting the bslp_single_panel
// class, which plots a graph from a datafile containing a single
// set of XY data points.

public class bslp_single_panel_test extends JFrame 
                                     implements MouseMotionListener
  {
  private bslp_single_panel bp;
  private JComboBox data_point_chooser; 
  private JComboBox data_point_primary_colour_chooser; 
  private JComboBox data_point_secondary_colour_chooser; 

  int App_width = 500;
  int App_height = 650;
  int Min_x = 30;
  int Max_x = 440;
  int Min_y = 30;
  int Max_y = 440;
  int data_array[][]; 

  private boolean mouse_is_in_plot_panel (MouseEvent e)
    {
    return ((e.getX() > Min_x) &&
            (e.getX() < Max_x) && 
            (e.getY() > Min_y) && 
            (e.getY() < Max_y) ); 
    }

  public void mouseDragged(MouseEvent e)
    {
    
  //  System.out.println("Mouse dragged to:x=" + e.getX() + ", y=" + e.getY());
    }
  
  public void mouseMoved(MouseEvent e)
    {
    if (mouse_is_in_plot_panel(e)) 
      {
      bp.update_crosshairs(e.getX(),e.getY());   
      System.out.println("Mouse moved to:x=" + e.getX() + ", y=" + e.getY());
      }
    }

  public  bslp_single_panel_test ()
    {
    super("bslp test");

    JLabel data_point_chooser_label;
    JLabel data_point_primary_colour_chooser_label;
    JLabel data_point_secondary_colour_chooser_label;
    
    bp = new bslp_single_panel(Min_x,
                               Max_x,
                               Min_y,
                               Max_y);
    
    
    data_array = new int[Max_x][Max_y]; 
    bp.set_data_array(data_array,Max_x,Max_y); 
    getContentPane().add(bp,BorderLayout.NORTH);
    setSize(App_width,App_height);

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
    addMouseMotionListener(this);
    }

  public static void main (String args[])
    {
    bslp_single_panel_test bt = new bslp_single_panel_test();
    bt.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
  } 



