// Import essential modules
import java.awt.*;
import javax.swing.*;
import java.util.Stack;
import java.awt.event.*;
import java.util.*;
import java.io.*;
import java.lang.Boolean;

public class GetPlotXFromX 
  {
  public int plot_x;

  private int get_idx_shift (int idx,  
                             int first_curve_z_offset,  
                             int z_axis_step_size) 
    {
    GetIdxShift gis = new GetIdxShift(idx,
                                      first_curve_z_offset,  
                                      z_axis_step_size) ;  
    return gis.getShift ();
    } 

  public GetPlotXFromX (double x, 
                        double Max_data_x,
                        double Min_data_x,
                        int curve_idx,
                        int Max_x,
                        int Min_x,
                        int first_curve_z_offset,
                        int z_axis_step_size)
    {
    int idx_shift = get_idx_shift(curve_idx,
                                  first_curve_z_offset,  
                                  z_axis_step_size);
    plot_x = ( (int)(0.2*(Max_x - Min_x)) + 
             (int)(0.6*((Max_x - 2*Min_x)*((x - Min_data_x)/
             (Max_data_x - Min_data_x)))) -  
             idx_shift);  
    }
  }
