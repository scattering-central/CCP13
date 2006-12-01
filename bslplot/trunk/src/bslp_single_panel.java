// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import java.lang.Boolean;

// This is for getting/displaying a single XY curve

public class bslp_single_panel extends JPanel 
  {
  int Error = 0; // default state 
  Graphics Global_g;

  int CrossHairX = -1;
  int CrossHairY = -1;

  private Vector CurveVector;
  private Vector FullPointCurveVector;

  private int Global_x_offset = 17;
  private int Global_y_offset = 45;

  // These ints are for joining up points on plot - 
  // need to store info on previous point to make joining line
  private int prev_was_drawn = -1;
  private int prev_curve_idx = -1;
  private int prev_curve_x;
  private int prev_curve_y;

  // These will hold the extrema values for the data sets.
  double Max_data_x;
  double Max_data_y;
  double Min_data_x;
  double Min_data_y;
  int Min_max_data_set = 0;

  // Z axis offset plottable for the first (smallest min x) curve
  int First_curve_z_offset  = 0;
  
  // Max length of z axis
  static int Max_z_axis_len = 200;

  // This holds the number of curves to be plotted
  int Num_curves_to_plot ;

  // This holds the value of the gap between curves on the z-axis 
  int Z_axis_step_size;

  // This is the default z-axis step-size 
  static int Default_z_axis_step_size  = 10 ;

  // These are for setting whether num plots is even or odd
  int Plot_even_odd_mode ; 
  static int Plot_mode_even = 0;
  static int Plot_mode_odd  = 1;

  int Max_x ;
  int Max_y ;
  int Min_x ;
  int Min_y ;
  static int Lower_panel_gap = 40;
  static String Prog_name = "BSLPlot";

  // Read-only possible values for data point characters.
  static String Data_point_char_plus      = "+";
  static String Data_point_char_dot       = ".";
  static String Data_point_char_cross     = "x";
  static String Data_point_char_minus     = "-";
  static String Data_point_char_star      = "*";
 
  // Indices for above characters. 
  static int Data_point_char_plus_idx     = 0;
  static int Data_point_char_dot_idx      = 1;
  static int Data_point_char_cross_idx    = 2;
  static int Data_point_char_minus_idx    = 3;
  static int Data_point_char_star_idx     = 4;
  static int Default_data_point_char_idx  = Data_point_char_dot_idx; 

  String Data_point_char ;

  int Data_point_char_set = 0;

  static int BSLPlot_colour_red_idx    = 0;
  static int BSLPlot_colour_green_idx  = 1;
  static int BSLPlot_colour_blue_idx   = 2;
  static int BSLPlot_colour_black_idx  = 3;
  static int BSLPlot_colour_white_idx  = 4;

  static int Default_data_point_primary_colour_idx   = BSLPlot_colour_blue_idx;
  static int Default_data_point_secondary_colour_idx = BSLPlot_colour_green_idx;

  int Data_point_primary_colour;
  int Data_point_secondary_colour;

  int Data_point_primary_colour_set = 0;
  int Data_point_secondary_colour_set = 0;

  private void draw_crosshairs(Graphics g)
    {
    set_colour(g,BSLPlot_colour_red_idx); 
    g.drawLine(Min_x,CrossHairY,Max_x,CrossHairY );
    g.drawLine(CrossHairX,Min_y,CrossHairX,Max_y );
    } 

  public void update_crosshairs (int x, int y)
    {
    CrossHairX = x;
    CrossHairY = y;
    repaint ();
    }

  public void set_data_array (int ar[][], int max_x, int max_y)
    {
    int i,j;
    Enumeration curve_enum;
    XYDataPoint prev = null;
    int prev_initialized = 0;

    for (i = 0; i < max_x; ++i)
      {
      for (j = 0; j < max_y; ++j)
        {
        ar[i][j] = 0;
        }  
      }  

    curve_enum = FullPointCurveVector.elements();
       
    while (curve_enum.hasMoreElements ())
      {
      XYDataPoint xydp = (XYDataPoint) curve_enum.nextElement ();

      if ((xydp.plot_x > -1) && (xydp.plot_x < max_x)
          && (xydp.plot_y > -1 ) && (xydp.plot_y < max_y   )) 
        ar[xydp.plot_x][xydp.plot_y] = 1; 
      }
    }

  public void draw_mouse_grid (int x, int y)
    {
    System.out.println("draw_mouse_grid:x=" + x + ", y=" + y);
    }

  public boolean is_odd( int i)
    {
    // Returns yes if i is odd 
    return ((i % 2) > 0);
    }

  public void plot_curves (Graphics g, Vector curve_vector)
    {
    Vector dummy_curve;
    int prev_idx, this_idx,i;
    Enumeration plot_vector_enum, curve_enum;
    Object dummy_object,dummy_object2;
    String dummy_string;
    double x,y;
    XYDataPoint prev = null;
    int prev_initialized = 0;

    curve_enum = curve_vector.elements();
       
    while (curve_enum.hasMoreElements ())
      {
      XYDataPoint xydp = (XYDataPoint) curve_enum.nextElement ();

      if (0 == prev_initialized)
	    {
	    // first time 'round - must init prev to xydp
	    prev = xydp;
	    prev_initialized = 1; 
	    }

	  draw_this_point(g,xydp,prev); 
	  prev = xydp;
      }
    }

  public void check_for_min_max_x_y (Vector plot_curve)
    {
    // Accepts a curve 
    Enumeration plot_vector_enum, curve_enum;
    curve_enum = plot_curve.elements();
    double x,y;
    XYDataPoint dummy_object2;
   
    while (curve_enum.hasMoreElements ())
      {
      dummy_object2 = (XYDataPoint)curve_enum.nextElement();
      x = dummy_object2.x;
      y = dummy_object2.y;
      
      if (Min_max_data_set == 0)
        {
        Min_data_x = x;
        Max_data_x = x;
        Min_data_y = y;
        Max_data_y = y;

        // This only ever has to be done once, so now we can
        // set it to '1' for ever.
        Min_max_data_set = 1;
        }
      else
        {
        if (x < Min_data_x)
          Min_data_x = x;
        else if (x > Max_data_x)
          Max_data_x = x;  
        
        if (y < Min_data_y)
          Min_data_y = y;
        else if (y > Max_data_y)
          Max_data_y = y;  
        }
      }
    }      

  public void set_min_max_x_y (Vector curve_vector)
    { 
    check_for_min_max_x_y(curve_vector);
    }

  public boolean plot_is_even (  )
    {
    return ( Plot_even_odd_mode == Plot_mode_even);
    }

  public Vector create_stack ()
    {
    GetOrderedXYDataFileVector xy = new GetOrderedXYDataFileVector("data");
    Vector master_v = xy.getVector();
    return (master_v); 
    }

  public void set_colour (Graphics g, int idx)
    {
    // Set colour for graphics context - default is black 

    if (idx == BSLPlot_colour_red_idx)
      g.setColor(new Color(255,0,0));
    else if (idx == BSLPlot_colour_green_idx)
      g.setColor(new Color(0,255,0));
    else if (idx == BSLPlot_colour_blue_idx)
      g.setColor(new Color(0,0,255));
    else if (idx == BSLPlot_colour_white_idx)
      g.setColor(new Color(255,255,255));
    else 
      g.setColor(new Color(0,0,0));  //  Default colour. 
    }

  public void set_data_point_primary_colour (Graphics g)
    {
    set_colour(g, Data_point_primary_colour);
    }

  public void set_data_point_secondary_colour (Graphics g)
    {
    set_colour(g, Data_point_secondary_colour);
    }

  public void set_data_point_char (int idx)
    {
    // This function sets the global data point character, given 
    // a passed-in index, "idx" 

    if (idx == Data_point_char_plus_idx)
      Data_point_char = Data_point_char_plus;
    else if (idx == Data_point_char_dot_idx)
      Data_point_char = Data_point_char_dot;     
    else if (idx == Data_point_char_cross_idx)
      Data_point_char = Data_point_char_cross;     
    else if (idx == Data_point_char_minus_idx)
      Data_point_char = Data_point_char_minus;     
    else if (idx == Data_point_char_star_idx)
      Data_point_char = Data_point_char_star;     
    }

  public void draw_bounding_box (Graphics g)
    {
    set_background_colour(g); 
    g.fillRect(Min_x, Min_y, Max_x, Max_y);
    set_bounding_box_colour(g); 
    g.drawRect(Min_x, Min_y, Max_x, Max_y);
    }

  public void draw_x_axis (Graphics g)
    {
    // This draws the x axis for plot   
    int j;
   // g.drawLine(Min_x,x,Min_x + Max_x,x);
    
    for (j=0; j<20; ++j)
      {
      // Drawing tic line 
      g.drawLine(Min_x + j*22,Min_y + Max_y,Min_x + j*22 , Min_y + Max_y+4);
      }
    } 

  public void draw_y_axis (Graphics g)
    {
    // This draws the x axis for plot   
    int j;
   // g.drawLine(x,Min_y,x,Min_y + Max_y);
    for (j=0; j<20; ++j)
      {
      // Drawing tic line 
      g.drawLine(Min_x - 4,Min_y + j*22,Min_x ,Min_y + j*22);
      }
    } 
 
  private void draw_this_point (Graphics g, XYDataPoint xydp, 
                                XYDataPoint prev)
    {
    g.drawLine( prev.plot_x + Global_x_offset,
                  prev.plot_y + Global_y_offset,
                  xydp.plot_x + Global_x_offset,
                  xydp.plot_y + Global_y_offset);  
      
    g.drawString(Data_point_char,
                 xydp.plot_x + Global_x_offset,
                 xydp.plot_y + Global_y_offset);
    }

  public void set_axis_colour (Graphics g)
    {
    // Sets axis colour  
    set_colour(g,BSLPlot_colour_blue_idx);
    }

  public void set_background_colour (Graphics g)
    {
    set_colour(g,BSLPlot_colour_white_idx);
    } 

  public void set_bounding_box_colour (Graphics g)
    {
    // Sets axis colour  
    set_colour(g,BSLPlot_colour_black_idx);
    } 
 
  public void set_data_point_colour (Graphics g)
    {
    // Sets data point colour  
    set_colour(g,BSLPlot_colour_red_idx);
    }

  public void set_data_point_colour_to_primary (Graphics g)
    {
    set_colour(g,Data_point_primary_colour);
    }

  public void set_data_point_colour_to_secondary (Graphics g)
    {
    set_colour(g,Data_point_secondary_colour);
    }

  public void set_data_point_primary_colour (int idx)
    {
    Data_point_primary_colour = idx  ;
    }

  public void set_data_point_secondary_colour (int idx)
    {
    Data_point_secondary_colour  = idx  ;
    }
  
  public void set_data_point_secondary_colour_red ()
    {
    set_data_point_secondary_colour(BSLPlot_colour_red_idx);
    }
  
  public void set_data_point_secondary_colour_green ()
    {
    set_data_point_secondary_colour(BSLPlot_colour_green_idx);
    }
 
  public void set_data_point_secondary_colour_blue ()
    {
    set_data_point_secondary_colour(BSLPlot_colour_blue_idx);
    }

  public void set_data_point_secondary_colour_black ()
    {
    set_data_point_secondary_colour(BSLPlot_colour_black_idx);
    }

  public void set_data_point_primary_colour_red ()
    {
    set_data_point_primary_colour(BSLPlot_colour_red_idx);
    }
  
  public void set_data_point_primary_colour_green ()
    {
    set_data_point_primary_colour(BSLPlot_colour_green_idx);
    }
 
  public void set_data_point_primary_colour_blue ()
    {
    set_data_point_primary_colour(BSLPlot_colour_blue_idx);
    }

  public void set_data_point_primary_colour_black ()
    {
    set_data_point_primary_colour(BSLPlot_colour_black_idx);
    }

  public void set_data_point_colour_red (Graphics g)
    {
    set_colour(g,BSLPlot_colour_red_idx);
    }
  
  public void set_data_point_colour_blue (Graphics g)
    {
    // Sets data point colour  
    set_colour(g,BSLPlot_colour_blue_idx);
    }
  
  public void set_data_point_colour_green (Graphics g)
    {
    // Sets data point colour  
    set_colour(g,BSLPlot_colour_green_idx);
    }
  
  public void plot_stack (Graphics g, Stack s)
    {
    System.out.println( s.pop());
    } 
 
  public void set_default_data_point_primary_colour ()
    {
    if (Data_point_primary_colour_set == 0)
      {
      Data_point_primary_colour_set = 1;
      set_data_point_primary_colour (Default_data_point_primary_colour_idx);  
      }
    }

  public void set_default_data_point_secondary_colour ()
    {
    if (Data_point_secondary_colour_set == 0)
      {
      Data_point_secondary_colour_set = 1;
      set_data_point_secondary_colour 
           (Default_data_point_secondary_colour_idx);  
      }
    }

  public void set_default_data_point_char ()
    {
    // Although this will be called for every repaint, we only
    // ever need to do anything once - the first time it is called - 
    // just so default data point char is set. 

    if (Data_point_char_set == 0)
      {
      Data_point_char_set = 1;
      set_data_point_char (Default_data_point_char_idx);  
      }
    }

  public void set_data_point_cross ()
    {
    set_data_point_char (Data_point_char_cross_idx);  
    }

  public void set_data_point_plus ()
    {
    set_data_point_char (Data_point_char_plus_idx);  
    }
  
  public void set_data_point_dot ()
    {
    set_data_point_char (Data_point_char_dot_idx);  
    }
 
  public void set_data_point_minus ()
    {
    set_data_point_char (Data_point_char_minus_idx);  
    }

  public void set_data_point_star ()
    {
    set_data_point_char (Data_point_char_star_idx);  
    }

  public bslp_single_panel ( int min_x,
                             int max_x,
                             int min_y,
                             int max_y)
    {
    Min_x = min_x; 
    Max_x = max_x; 
    Min_y = min_y; 
    Max_y = max_y; 

    CurveVector = create_stack(); 
    // Now set the max min parameters for the plot as a whole.
    set_min_max_x_y(CurveVector);
    
    CreateFullPointCurve fpc=  new CreateFullPointCurve (CurveVector,
                                Min_x + 10,
                                Max_x - 20,
                                Min_y + 10,
                                Max_y - 10,
                                Min_data_x,
                                Max_data_x,
                                Min_data_y,
                                Max_data_y);  
    FullPointCurveVector = fpc.getFullPointCurve() ;
    }

  public void paintComponent (Graphics g)
    {
    super.paintComponent(g); 
    set_default_data_point_char ();  
    set_default_data_point_primary_colour ();  
    set_default_data_point_secondary_colour ();  
    draw_bounding_box(g);
    draw_x_axis(g);
    draw_y_axis(g); 
    plot_curves(g, FullPointCurveVector); 
    //draw_crosshairs(g); 
    }

  public Dimension getPreferredSize()
    {
    return new Dimension (500,500);
    }

  public Dimension getMinimumSize()
    {
    return getPreferredSize();
    }

  public void redraw_plot ()
    {
    repaint();
    }
  }








