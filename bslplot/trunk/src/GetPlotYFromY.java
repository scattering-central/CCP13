public class GetPlotYFromY 
  {
  public int plot_y;

  private int get_idx_shift (int idx,
                             int first_curve_z_offset , 
                             int z_axis_step_size  )  

    {
    GetIdxShift gis = new GetIdxShift(idx,
                                      first_curve_z_offset , 
                                      z_axis_step_size  )  ;
    return gis.getShift ();
    }

  public GetPlotYFromY (double y, 
                        double Max_data_y,
                        double Min_data_y,
                        int curve_idx,
                        int Max_y,
                        int Min_y,
                        int first_curve_z_offset,
                        int z_axis_step_size)
    {
    int idx_shift = get_idx_shift(curve_idx,
                                  first_curve_z_offset,
                                  z_axis_step_size   );
    plot_y =  ( (int)(0.2*(Max_y - Min_y)) + 
                (int)(0.6*(Max_y - ((Max_y - 2*Min_y) *(y - Min_data_y)
                /(Max_data_y - Min_data_y)))) + 
                idx_shift);  
    }
  }
