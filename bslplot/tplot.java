import net.sourceforge.chart2d.*;

import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.JApplet;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import java.awt.Color;
import java.util.Random;

public class tplot extends JApplet 
  {
  private JFrame frame = null;
  private static boolean isApplet = true;

  public static void main (String[] args) 
    {
    isApplet = false;
    tplot demo = new tplot();
    demo.init();
    demo.start();
    //exit on frame close event
    }

  public void init() 
    {
    //Start configuring a JFrame GUI with a JTabbedPane for multiple chart panes
    JTabbedPane panes = new JTabbedPane();
    JPanel jp = new JPanel ();

    String OriginalDataTab               = "Input Data";
    String ProcessedDataTab              = "Adsorbed layer concentration";
    String OriginalDataTabYAxis          = "Count";    
    String ProcessedDataTabYAxis         = "Concentration";    
    String OriginalDataTabXAxis          = "Raster";    
    String ProcessedDataTabXAxis         = "Radius (nm)";    
    
    panes.addTab ("dummy panel tab",jp);
    
    panes.addTab (OriginalDataTab, 
                  getChart2DDemoF(OriginalDataTab,
                                  OriginalDataTabXAxis,
                                  OriginalDataTabYAxis));

    panes.addTab (ProcessedDataTab, 
                  getChart2DDemoF(ProcessedDataTab,
                                  ProcessedDataTabXAxis,
                                  ProcessedDataTabYAxis));

    Dimension maxSize = new Dimension (561, 214);
    for (int i = 1; i < panes.getTabCount(); ++i) 
      {
      Chart2D chart2D = (Chart2D)panes.getComponentAt (i);
      chart2D.setSize (maxSize);
      chart2D.setPreferredSize (maxSize);
      }
    panes.setPreferredSize (new Dimension (566 + 5, 280 + 5)); //+ 5 slop

    frame = new JFrame();
    frame.getContentPane().add (panes);
    frame.setTitle ("Tropus");
    frame.addWindowListener (
      new WindowAdapter() {
        public void windowClosing (WindowEvent e) {
          destroy();
    } } );
  
    frame.pack();
    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    frame.setLocation (
      (screenSize.width - frame.getSize().width) / 2,
      (screenSize.height - frame.getSize().height) / 2);
    }

  public void start() 
    {
    frame.show();
    }


  public void destroy() 
    {
    if (frame != null) frame.dispose();
    if (!isApplet) System.exit (0);
    }

  private Chart2D getChart2DDemoF(String paneTitle,
                                  String XAxisTitle,
                                  String YAxisTitle) 
    {
    //<-- Begin Chart2D configuration -->
    //Configure object properties
    Object2DProperties object2DProps = new Object2DProperties();
    object2DProps.setObjectTitleText (paneTitle);

    //Configure chart properties
    Chart2DProperties chart2DProps = new Chart2DProperties();
   
    //Configure legend properties
    LegendProperties legendProps = new LegendProperties();
    legendProps.setLegendExistence (false);

    //Configure graph chart properties
    GraphChart2DProperties graphChart2DProps = new GraphChart2DProperties();
    String[] labelsAxisLabels =
      {"0", "1", "2", "3", "4", "5",
       "6", "7", "8", "9", "10", "11"};
    graphChart2DProps.setLabelsAxisLabelsTexts (labelsAxisLabels);
    graphChart2DProps.setLabelsAxisTitleText (XAxisTitle);
    graphChart2DProps.setNumbersAxisTitleText (YAxisTitle);
    graphChart2DProps.setChartDatasetCustomizeGreatestValue (true);
    graphChart2DProps.setChartDatasetCustomGreatestValue (1000);
    graphChart2DProps.setLabelsAxisTicksAlignment (graphChart2DProps.CENTERED);

    //Configure graph properties
    GraphProperties graphProps = new GraphProperties();
    graphProps.setGraphBarsExistence (false);
    graphProps.setGraphLinesExistence (true);
    graphProps.setGraphOutlineComponentsExistence (true);
    graphProps.setGraphAllowComponentAlignment (true);

    //Configure dataset
    Dataset dataset = new Dataset (3, 12, 1);
    dataset.set (0,  0, 0, 100f);  //1990
    dataset.set (0,  1, 0, 200f);  //1991
    dataset.set (0,  2, 0, 300f);  //1992
    dataset.set (0,  3, 0, 400f);  //1993
    dataset.set (0,  4, 0, 100f);  //1994
    dataset.set (0,  5, 0, 200f);  //1995
    dataset.set (0,  6, 0, 100f);  //1996
    dataset.set (0,  7, 0,   0f);  //1997
    dataset.set (0,  8, 0, 100f);  //1998
    dataset.set (0,  9, 0, 100f);  //1999
    dataset.set (0, 10, 0, 200f);  //2000
    dataset.set (0, 11, 0, 300f);  //2001
    dataset.set (1,  0, 0,   0f);  //1990
    dataset.set (1,  1, 0,   0f);  //1991
    dataset.set (1,  2, 0,   0f);  //1992
    dataset.set (1,  3, 0, 100f);  //1993
    dataset.set (1,  4, 0, 200f);  //1994
    dataset.set (1,  5, 0, 400f);  //1995
    dataset.set (1,  6, 0, 500f);  //1996
    dataset.set (1,  7, 0, 700f);  //1997
    dataset.set (1,  8, 0, 900f);  //1998
    dataset.set (1,  9, 0, 100f);  //1999
    dataset.set (1, 10, 0, 200f);  //2000
    dataset.set (1, 11, 0, 300f);  //2001
    dataset.set (2,  0, 0,   0f);  //1990
    dataset.set (2,  1, 0,   0f);  //1991
    dataset.set (2,  2, 0,   0f);  //1992
    dataset.set (2,  3, 0,   0f);  //1993
    dataset.set (2,  4, 0, 100f);  //1994
    dataset.set (2,  5, 0, 200f);  //1995
    dataset.set (2,  6, 0, 300f);  //1996
    dataset.set (2,  7, 0, 400f);  //1997
    dataset.set (2,  8, 0, 500f);  //1998
    dataset.set (2,  9, 0, 100f);  //1999
    dataset.set (2, 10, 0, 300f);  //2000
    dataset.set (2, 11, 0, 900f);  //2001

    //Configure graph component colors
    MultiColorsProperties multiColorsProps = new MultiColorsProperties();

    //Configure chart
    LBChart2D chart2D = new LBChart2D();
    chart2D.setObject2DProperties (object2DProps);
    chart2D.setChart2DProperties (chart2DProps);
    chart2D.setLegendProperties (legendProps);
    chart2D.setGraphChart2DProperties (graphChart2DProps);
    chart2D.addGraphProperties (graphProps);
    chart2D.addDataset (dataset);
    chart2D.addMultiColorsProperties (multiColorsProps);

    //Optional validation:  Prints debug messages if invalid only.
    if (!chart2D.validate (false)) chart2D.validate (true);

    //<-- End Chart2D configuration -->
    return chart2D;
    }
  }
