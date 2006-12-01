import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
import graph.*;

public class CorfuncDataGraph extends OtokoGraphics {

    private JMenuItem extrapFramesMenuItem, retransformFramesMenuItem;
    private double[] limits = new double[3];
    private DataSet[] limitsData;
    private DataSet[] extrapDataSet, retransformDataSet;
    private OtokoDataSet extrapData, extrapQData, retransformData;
    private int npts=50;
    private double[] ldata = new double[npts*2];
    private double ymin, ymax, ystep;
    private boolean gotExtrapData,gotLimits,gotRetransformData;
    private FrameChooser extFrameChooser;
    private FrameChooserListener frameChooserListener;

    public CorfuncDataGraph (OtokoDataSet otokoData, OtokoDataSet qaxData, int fframe,
                             int lframe, int incframe, String title, Component mainWin) throws Exception {

        //Plot the data
        super(otokoData,qaxData,fframe,lframe,incframe,title,mainWin);

        //Initialise
        gotExtrapData=false;
        gotRetransformData=false;
        gotLimits=false;
        limitsData=new DataSet[3];

        //Add button for picking extrapolated data frames
        frameChooserListener=new FrameChooserListener();
        extFrameChooser=new FrameChooser(frameChooserListener);
        extrapFramesMenuItem = new JMenuItem("Extrapolation frames ...");
        extrapFramesMenuItem.setEnabled(false);
        extrapFramesMenuItem.addActionListener(new ActionListener () {
            public void actionPerformed (ActionEvent e1)
            {
                final ActionEvent e = e1;
                SwingUtilities.invokeLater(new Runnable() {
                    public void run() {
                        frameChooserListener.setMode("extrapolation");
                        extFrameChooser.setVisible(true);
                    }
                });
            }
        });
        displayMenu.add(extrapFramesMenuItem);

        retransformFramesMenuItem = new JMenuItem("Re-transform frames ...");
        retransformFramesMenuItem.setEnabled(false);
        retransformFramesMenuItem.addActionListener(new ActionListener () {
            public void actionPerformed (ActionEvent e1)
            {
                final ActionEvent e = e1;
                SwingUtilities.invokeLater(new Runnable() {
                    public void run() {
                        frameChooserListener.setMode("retransform");
                        extFrameChooser.setVisible(true);
                    }
                });
            }
        });
        displayMenu.add(retransformFramesMenuItem);

        //Change the Action Listener on the display data frames button
        dataFramesMenuItem.removeActionListener(this);
        dataFramesMenuItem.addActionListener(new ActionListener () {
            public void actionPerformed (ActionEvent e1)
            {
                final ActionEvent e = e1;
                SwingUtilities.invokeLater(new Runnable() {
                    public void run() {
                        frameChooserListener.setMode("data");
                        extFrameChooser.setVisible(true);
                    }
                });
            }
        });

        //Set the default channel limits
        limits[0]=qaxData.data[otokoData.getDataStart()];
        limits[1]=(xaxis.maximum-xaxis.minimum)/2.0;
        limits[2]=(xaxis.maximum-xaxis.minimum)*3.0/4.0;

        //Plot the channel limits and allow user to change these
        plotLimits();
        LimitsMouseListener limitsMouseListener= new LimitsMouseListener ();
        graph.addMouseListener(limitsMouseListener);
        graph.addMouseMotionListener(limitsMouseListener);
    }

    public void loadExtrapData (OtokoDataSet extrapData, OtokoDataSet extrapQData,
                                int fframe, int lframe, int incframe)
                                throws Exception {

        this.extrapData=extrapData;
        this.extrapQData=extrapQData;

        //Create a DataSet object and display
        this.extrapDataSet=createDataSet(extrapData,extrapQData,fframe,lframe,incframe,Color.magenta);
   }

   public void loadRetransformData (OtokoDataSet retransformData, int fframe, int lframe, int incframe)
                                    throws Exception {

       this.retransformData=retransformData;

       //Create a DataSet object and display
        this.retransformDataSet=createDataSet(retransformData,qaxData,fframe,lframe,incframe,Color.green);
   }

   public void showRetransformData () {
        try {
            if(gotRetransformData)
                hideRetransformData();
            showDataSet(retransformDataSet);
            plotLimits();
            gotRetransformData=true;
            retransformFramesMenuItem.setEnabled(true);
        }
        catch(Exception e) {
            JOptionPane.showMessageDialog(null,e.getMessage(),
                                          "Error Message", JOptionPane.ERROR_MESSAGE);
        }
    }

    public void showExtrapData () {
        try {
            if(gotExtrapData)
                hideExtrapData();
            showDataSet(extrapDataSet);
            if(gotRetransformData) {
                showRetransformData();
            }
            plotLimits();
            gotExtrapData=true;
            extrapFramesMenuItem.setEnabled(true);
        }
        catch(Exception e) {
            JOptionPane.showMessageDialog(null,e.getMessage(),
                                          "Error Message", JOptionPane.ERROR_MESSAGE);
        }
    }

    public void hideRetransformData () {
        try {
            hideDataSet(retransformDataSet);
            gotRetransformData=false;
            retransformFramesMenuItem.setEnabled(false);
        }
        catch(Exception e) {
            JOptionPane.showMessageDialog(null,e.getMessage(),
                                          "Error Message", JOptionPane.ERROR_MESSAGE);
        }
    }

    public void hideExtrapData () {
        try {
            hideDataSet(extrapDataSet);
            gotExtrapData=false;
            extrapFramesMenuItem.setEnabled(false);
        }
        catch(Exception e) {
            JOptionPane.showMessageDialog(null,e.getMessage(),
                                          "Error Message", JOptionPane.ERROR_MESSAGE);
        }
    }

    //Fit data to window
    public void fitToWindow () {
        for(int k=0; k<3; k++) {
            graph.detachDataSet(limitsData[k]);
        }
        xaxis.setManualRange(true);
        yaxis.setManualRange(true);
        xaxis.maximum=xaxis.getDataMax();
        xaxis.minimum=xaxis.getDataMin();
        yaxis.maximum=yaxis.getDataMax();
        yaxis.minimum=yaxis.getDataMin();
        xaxis.setManualRange(false);
        yaxis.setManualRange(false);
        plotLimits();
        graph.repaint();
    }

    //Plot channel limits
    private void plotLimits () {
        int i,j,k;
        double yval;
        double txmax=xaxis.maximum;
        double txmin=xaxis.minimum;
        double tymax=yaxis.maximum;
        double tymin=yaxis.minimum;

        ymin=yaxis.getDataMin();
        ymax=yaxis.getDataMax();
        ystep=(ymax-ymin)/(npts-1);

        for(k=0; k<3; k++) {
            for(i=0,j=0,yval=ymin; i<npts; i++,j+=2,yval+=ystep) {
                ldata[j] = limits[k];
                ldata[j+1] = yval;
            }

            if(gotLimits)
                graph.detachDataSet(limitsData[k]);
            limitsData[k] = graph.loadDataSet(ldata,npts);
            limitsData[k].linecolor=Color.red;

            //Attach the DataSet object to the X-axis
            xaxis.attachDataSet(limitsData[k]);

            //Attach the DataSet object to the Y-axis
            yaxis.attachDataSet(limitsData[k]);
        }
        xaxis.setManualRange(true);
        yaxis.setManualRange(true);
        xaxis.maximum=txmax;
        xaxis.minimum=txmin;
        yaxis.maximum=tymax;
        yaxis.minimum=tymin;
        xaxis.setManualRange(false);
        yaxis.setManualRange(false);

        graph.repaint();
        gotLimits=true;
    }

    //Use right mouse button to move the nearest limit
    class LimitsMouseListener extends MouseInputAdapter {

        public void mouseDragged (MouseEvent e) {
            int ix=e.getX();
            if(SwingUtilities.isRightMouseButton(e)) {
                int closestLimit = CorfuncDataGraph.this.getClosestLimit(ix);
                moveLimit(closestLimit,ix);
            }
        }
	}

	private int getClosestLimit (int ix) {
	    int i,closest;
	    double dist;
        double dx;

        closest=-1;
	    dist=Double.MAX_VALUE;
	    dx=xaxis.getDouble(ix);
	    if(dx>xaxis.maximum)
	        dx=xaxis.maximum;
	    else if(dx<xaxis.minimum)
	        dx=xaxis.minimum;

	    for(i=0; i<3; i++) {
	        if(Math.abs(dx-limits[i])<dist) {
	            dist=dx-limits[i];
	            closest=i;
	        }
	    }
	return closest;
	}

    private void moveLimit(int index, int ix) {
        limits[index]=xaxis.getDouble(ix);

        double txmax=xaxis.maximum;
        double txmin=xaxis.minimum;
        double tymax=yaxis.maximum;
        double tymin=yaxis.minimum;

        if(limits[index]<=txmin)
            limits[index]=txmin;
        else if(limits[index]>=txmax)
            limits[index]=txmax;

        graph.detachDataSet(limitsData[index]);

        int i,j,k;
        double yval;

        for(i=0,j=0,yval=ymin; i<npts; i++,j+=2,yval+=ystep) {
            ldata[j] = limits[index];
            ldata[j+1] = yval;
        }

        limitsData[index] = graph.loadDataSet(ldata,npts);
        limitsData[index].linecolor=Color.red;

        //Attach the DataSet object to the X-axis
        xaxis.attachDataSet(limitsData[index]);
        //Attach the DataSet object to the Y-axis
        yaxis.attachDataSet(limitsData[index]);

        //Reset the range
        xaxis.setManualRange(true);
        yaxis.setManualRange(true);
        xaxis.maximum=txmax;
        xaxis.minimum=txmin;
        yaxis.maximum=tymax;
        yaxis.minimum=tymin;
        xaxis.setManualRange(false);
        yaxis.setManualRange(false);

        graph.repaint();
    }

    public int[] getLimits () {
        int[] ilimits = new int[3];
        int i,j;

        for(i=0;i<3;i++) {
            for(j=0;j<np;j++) {
                if(limits[i]<=super.qaxData.data[j]) {
                    ilimits[i]=j+1;
                    break;
                }
            }
        }
        return ilimits;
    }

    class FrameChooserListener implements ActionListener {
        String mode;

        public void actionPerformed (ActionEvent e) {
            int[] frames;
            int fframe,lframe,incframe;
            frames=CorfuncDataGraph.this.extFrameChooser.getFrameRange();
            if(frames!=null) {
                fframe=frames[0];
                lframe=frames[1];
                incframe=frames[2];
                try {
                    if(mode.startsWith("extrap")) {
                            DataSet[] oldData = CorfuncDataGraph.this.extrapDataSet;
                            CorfuncDataGraph.this.extrapDataSet=createDataSet(CorfuncDataGraph.this.extrapData,
                                                             CorfuncDataGraph.this.extrapQData,
                                                             fframe,lframe,incframe,Color.magenta);
                            CorfuncDataGraph.this.hideDataSet(oldData);
                            gotExtrapData=false;
                            CorfuncDataGraph.this.showExtrapData();
                    }
                    else if(mode.startsWith("retrans")) {
                            DataSet[] oldData = CorfuncDataGraph.this.retransformDataSet;
                            CorfuncDataGraph.this.retransformDataSet=createDataSet(CorfuncDataGraph.this.retransformData,
                                                             CorfuncDataGraph.this.qaxData,
                                                             fframe,lframe,incframe,Color.green);
                            CorfuncDataGraph.this.hideDataSet(oldData);
                            gotRetransformData=false;
                            CorfuncDataGraph.this.showRetransformData();
                    }
                    else if(mode.startsWith("data")) {
                        DataSet[] oldData = CorfuncDataGraph.this.mainDataSet;
                        CorfuncDataGraph.this.mainDataSet=createDataSet(CorfuncDataGraph.this.otokoData,
                                                                    CorfuncDataGraph.this.qaxData,
                                                                    fframe,lframe,incframe,Color.blue);
                        CorfuncDataGraph.this.hideDataSet(oldData);
                        CorfuncDataGraph.this.showDataSet(mainDataSet);
                        if(CorfuncDataGraph.this.gotExtrapData)
                           CorfuncDataGraph.this.showExtrapData();
                        if(CorfuncDataGraph.this.gotRetransformData)
                           CorfuncDataGraph.this.showRetransformData();
                        plotLimits();
                    }
                    CorfuncDataGraph.this.extFrameChooser.setVisible(false);
                }
                catch(Exception ex) {
                    JOptionPane.showMessageDialog(null,ex.getMessage(),
                                                  "Error Message", JOptionPane.ERROR_MESSAGE);
                }
            }
        }

        public void setMode(String mode) {
            this.mode=mode;
        }
    }
}