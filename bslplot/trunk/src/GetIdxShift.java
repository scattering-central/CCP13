public class GetIdxShift 
  {
  private int idx_shift;

  public int getShift ()
    {
    return idx_shift;
    }

  public GetIdxShift (int idx,
                      int First_curve_z_offset,
                      int Z_axis_step_size)  
                              
    {
    idx_shift =  (int)(First_curve_z_offset - 
                         idx*Z_axis_step_size   );
    }
  }
