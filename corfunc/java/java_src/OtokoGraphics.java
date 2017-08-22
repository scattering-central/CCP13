import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import graph.*;
import java.awt.print.*;
import java.io.*;
import com.sun.media.jai.codec.*;
import javax.media.jai.*;
import java.util.*;
import java.net.URL;
import javax.help.*;

public class OtokoGraphics extends JFrame implements Printable, ActionListener {
    protected G2Dint graph;
    protected Axis xaxis, yaxis;
    protected DataSet[] mainDataSet;
    private JPanel contentPane;
    private JMenuBar menuBar;
    protected JMenu displayMenu;
    private JMenu fileMenu,helpMenu;
    private JMenuItem rangeMenuItem, fitToWindowMenuItem, refreshMenuItem,
                      coordsMenuItem, printMenuItem, saveMenuItem;
    protected JMenuItem dataFramesMenuItem;
    private FrameChooser frameChooser;
    protected int np;
    private BufferedImage graphImage;
    private Graphics2D imgGraphics;
    private BSLFileChooser fc;
    private ImageFileFilter imageFileFilter;
    private File outFile;
    private String outFileName;
    private Component mainWin;
    private JPanel panel;
    private boolean painted;
    protected OtokoDataSet otokoData,qaxData;
    private HelpBroker hb;
    private HelpSet hs;
    private HelpActionListener helpActionListener;

    private JPEGEncodeParam jpge;
    private BMPEncodeParam bmpe;
    private TIFFEncodeParam tife;

    public OtokoGraphics (OtokoDataSet otokoData, OtokoDataSet qaxData, int fframe,
                          int lframe, int incframe, String title, Component mainWin) throws Exception {
        this.mainWin = mainWin;
        this.otokoData=otokoData;
        this.qaxData=qaxData;
        np = otokoData.getChannels();
        painted=false;

        //Find the HelpSet file and create the HelpSet object
        try {
            URL hsURL = HelpSet.findHelpSet(null,"corfunc_help/Help.hs");
            hs = new HelpSet(null,hsURL);
        }catch (Exception e) {
            JOptionPane.showMessageDialog(OtokoGraphics.this,"Help pages not found",
                                          "Error Message", JOptionPane.ERROR_MESSAGE);
        }

        //Create HelpBroker and Help pages ActionListener
        hb = hs.createHelpBroker();
        helpActionListener = new HelpActionListener();

        //Set up image encoders
        jpge = new JPEGEncodeParam();
        bmpe = new BMPEncodeParam();
        tife = new TIFFEncodeParam();

        //Set up the file chooser for saving images
        fc = new BSLFileChooser();
        imageFileFilter = new ImageFileFilter();

        //Set the look and feel
        try {
            UIManager.setLookAndFeel(
              UIManager.getCrossPlatformLookAndFeelClassName());
        } catch (Exception e) {}
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        this.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                if(OtokoGraphics.this.frameChooser!=null)
                    OtokoGraphics.this.frameChooser.setVisible(false);
                if(OtokoGraphics.this.graph.getcpgin()!=null)
                    OtokoGraphics.this.graph.getcpgin().setVisible(false);
                if(OtokoGraphics.this.graph.getdpgin()!=null)
                    OtokoGraphics.this.graph.getdpgin().setVisible(false);
                if(OtokoGraphics.this.graph.getrange()!=null)
                    OtokoGraphics.this.graph.getrange().setVisible(false);
            }
        });

        //Get the content pane and set layout manager
        contentPane = new JPanel();
        this.setContentPane(contentPane);
        contentPane.setLayout(new BorderLayout());
        contentPane.setPreferredSize(new Dimension(450,300));

        //Create a menu bar
        menuBar = new JMenuBar();
        setJMenuBar(menuBar);

        JMenu fileMenu = new JMenu("File");
        menuBar.add(fileMenu);

        saveMenuItem = new JMenuItem("Save as ...");
        saveMenuItem.setEnabled(true);
        saveMenuItem.addActionListener(this);
        fileMenu.add(saveMenuItem);
        //Print option not working at present
/*
        printMenuItem = new JMenuItem("Print ...");
        printMenuItem.setEnabled(true);
        printMenuItem.addActionListener(this);
        menu.add(printMenuItem);
*/

        displayMenu = new JMenu("Display");
        menuBar.add(displayMenu);
        fitToWindowMenuItem = new JMenuItem("Fit to window");
        fitToWindowMenuItem.setEnabled(true);
        fitToWindowMenuItem.addActionListener(this);
        displayMenu.add(fitToWindowMenuItem);
        refreshMenuItem = new JMenuItem("Refresh");
        refreshMenuItem.setEnabled(true);
        refreshMenuItem.addActionListener(this);
        displayMenu.add(refreshMenuItem);
        coordsMenuItem = new JMenuItem("Coordinates");
        coordsMenuItem.setEnabled(true);
        coordsMenuItem.addActionListener(this);
        displayMenu.add(coordsMenuItem);
        dataFramesMenuItem = new JMenuItem("Data frames ...");
        dataFramesMenuItem.setEnabled(true);
        dataFramesMenuItem.addActionListener(this);
        displayMenu.add(dataFramesMenuItem);

        menuBar.add(Box.createHorizontalGlue());

        helpMenu = new JMenu("Help");
        helpMenu.setMnemonic(KeyEvent.VK_H);
        JMenuItem helpMenuItem = new JMenuItem("Graphics Windows");
        helpMenuItem.setEnabled(true);
        helpMenu.add(helpMenuItem);
        CSH.setHelpIDString(helpMenuItem,"Graphics Windows");
        CSH.setHelpSet(helpMenuItem,hs);
        helpMenuItem.addActionListener(helpActionListener);
        menuBar.add(helpMenu);

        //Create the graph
        graph = new G2Dint();

        xaxis = graph.createXAxis();
        xaxis.setPosition(Axis.BOTTOM);
        xaxis.positionAxis(100,0,0,0);
        xaxis.setTitleText("q");
        xaxis.setLabelPrecision(1);

        yaxis = graph.createYAxis();
        yaxis.setPosition(Axis.LEFT);
        yaxis.positionAxis(0,0,0,1000);
        yaxis.setTitleText("Intensity");
        yaxis.setLabelPrecision(1);

        graph.drawgrid=false;
        graph.drawzero=true;
        graph.zerocolor=Color.black;
        graph.setDataBackground(Color.white);
        graph.setGraphBackground(Color.lightGray);
        graph.borderRight=50;
        this.setTheTitle(title);
        mainDataSet=createDataSet(otokoData,qaxData,fframe,lframe,incframe,Color.blue);
        showDataSet(mainDataSet);

        panel = new JPanel(new BorderLayout());
        panel.add(graph);

        //Set up the frame
        contentPane.add(panel);
        this.pack();

    }

    //Create DataSet object
    protected DataSet[] createDataSet (OtokoDataSet otokoData, OtokoDataSet qaxData,
                                    int fframe,int lframe, int incframe,Color color)
                                    throws Exception {

        if(fframe<=0||lframe<fframe||lframe>otokoData.getFrames())
            throw new Exception("Invalid range");

        //Set up the data
        int length=0;
        if(lframe==fframe)length=np*2;
        else length=(((lframe-fframe)/incframe)+1)*np*2;
        double[] data = new double[length];
        for(int nframe=fframe,l=0;nframe<=lframe;nframe+=incframe,l++) {
            for(int i=0,j=(nframe-1)*otokoData.getChannels(),k=0; i<np; i++,j++,k+=2) {
                data[(l*np*2)+k] = (double) qaxData.data[i];
                data[(l*np*2)+k+1] = (double) otokoData.data[j];
            }
        }

        //Create a DataSet object
        if(lframe==fframe)length=1;
        else length=((lframe-fframe)/incframe)+1;
        DataSet[] dSet = new DataSet[length];
        double[] plotData = new double[np*2];
        for(int nframe=fframe,l=0;nframe<=lframe;nframe+=incframe,l++){
            for(int i=0;i<np*2;i++) {
                plotData[i]=data[(l*np*2)+i];
            }
            dSet[l] = new DataSet(plotData,np);
            dSet[l].linecolor=color;
        }
        return dSet;
    }

    public void showDataSet(DataSet[] dSet) throws Exception{
        for(int i=0;i<dSet.length;i++){
            //Attach the DataSet object to the X-axis
            xaxis.attachDataSet(dSet[i]);
            //Attach the DataSet object to the Y-axis
            yaxis.attachDataSet(dSet[i]);
            //Attach DataSet object to the graph
            graph.attachDataSet(dSet[i]);
        }
        if(!painted) {
            graph.paint(this.getGraphics());
            painted=true;
        }
        else
            graph.repaint();
    }

    public void hideDataSet (DataSet[] dSet) throws Exception {
        for(int i=0;i<dSet.length;i++){
          //Detach the DataSet object from the X-axis
          xaxis.detachDataSet(dSet[i]);
          //Detach the DataSet object from the Y-axis
          yaxis.detachDataSet(dSet[i]);
          //Detach DataSet from the graph
          graph.detachDataSet(dSet[i]);
        }
        graph.repaint();
    }

    //Set the title
    public void setTheTitle (String title) {
        this.setTitle(title);
    }

    //Set the axes titles
    public void setAxes (String xaxisname, String yaxisname) throws Exception {
        xaxis.setTitleText(xaxisname);
        yaxis.setTitleText(yaxisname);
    }


    //Close the graph
    public void close () {
        this.setVisible(false);
    }

    //Fit data to window
    public void fitToWindow () {
        xaxis.setManualRange(true);
        yaxis.setManualRange(true);
        xaxis.maximum=xaxis.getDataMax();
        xaxis.minimum=xaxis.getDataMin();
        yaxis.maximum=yaxis.getDataMax();
        yaxis.minimum=yaxis.getDataMin();
        xaxis.setManualRange(false);
        yaxis.setManualRange(false);
        graph.repaint();
    }

    //Action performed method
    public void actionPerformed (ActionEvent e1) {
        final ActionEvent e = e1;
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                JMenuItem source = (JMenuItem)(e.getSource());
                if(source==dataFramesMenuItem) {
                    if(frameChooser==null)
                        frameChooser=new FrameChooser(new FrameChooserListener());
                    frameChooser.setVisible(true);
                }
                else if(source==rangeMenuItem)
                    graph.popupRange();
                else if(source==fitToWindowMenuItem)
                    fitToWindow();
                else if(source==refreshMenuItem)
                    graph.repaint();
                else if(source==coordsMenuItem)
                    graph.showCoords();
                else if (source==printMenuItem) {
                    PrinterJob printJob = PrinterJob.getPrinterJob();
                    PageFormat pf = printJob.pageDialog(printJob.defaultPage());
                    printJob.setPrintable(OtokoGraphics.this,pf);
                        if(printJob.printDialog()) {
                            try {
                                printJob.print();
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        }
                }
                else if(source==saveMenuItem) {
                    //Save image to file
                    ImageEncodeParam ep;
                    String name;
                    try{
                        fc.setDialogTitle("Save image as ...");
                        fc.addChoosableFileFilter(imageFileFilter);
                        fc.setFileFilter(imageFileFilter);
                        fc.setOptions(false,true,false,false);
                        int returnVal = fc.showSaveDialog(OtokoGraphics.this);
                        OtokoGraphics.this.update(OtokoGraphics.this.getGraphics());
                        OtokoGraphics.this.mainWin.update(OtokoGraphics.this.mainWin.getGraphics());
                        if (returnVal == JFileChooser.APPROVE_OPTION) {
                            outFile = fc.getSelectedFile();
                            outFileName = outFile.getName();
                            String extension = Utils.getExtension(outFile);
                            if(extension!=null) {
                                if (extension.equals(Utils.bmp)) {
                                    ep = bmpe;
                                    name = new String("bmp");
                                }
                                else if (extension.equals(Utils.jpeg) ||
                                         extension.equals(Utils.jpg)) {
                                    ep = jpge;
                                    name = new String("jpeg");
                                }
                                else if (extension.equals(Utils.tiff) ||
                                         extension.equals(Utils.tif)) {
                                    ep =tife;
                                    name = new String("tiff");
                                }
                                else {
                                    String newFileName = new String(outFile.getParent()+File.separatorChar+outFileName+".tif");
                                    outFile.delete();
                                    outFile=null;
                                    outFile = new File(newFileName);
                                    outFileName = outFile.getName();
                                    ep = tife;
                                    name = new String("tiff");
                                }
                            }else {
                                String newFileName = new String(outFile.getParent()+File.separatorChar+outFileName+".tif");
                                outFile.delete();
                                outFile=null;
                                outFile = new File(newFileName);
                                outFileName = outFile.getName();
                                ep = tife;
                                name = new String("tiff");
                            }
                            BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(outFile));
                            OtokoGraphics.this.writeImage(out,ep,name);
                        }else {
                        }
                    }
                    catch (Exception e2) {
                        JOptionPane.showMessageDialog(null,e2.getMessage(),
                                                      "Error Message", JOptionPane.ERROR_MESSAGE);
                        e2.printStackTrace();
                    }
                }
            }
        });
        this.update(this.getGraphics());
    }

    //Print method
    public int print (Graphics g, PageFormat pf, int pi) throws PrinterException {
        if (pi >= 1) {
            return Printable.NO_SUCH_PAGE;
        }
        draw(g);
        return Printable.PAGE_EXISTS;
    }

    //Write image file
    public void writeImage (OutputStream out,ImageEncodeParam ep, String name) {

        //Create off-screen drawable image
        graphImage = new BufferedImage(graph.getWidth(),graph.getHeight(),BufferedImage.TYPE_3BYTE_BGR);
        imgGraphics = ((BufferedImage)graphImage).createGraphics();

        try {
            draw(imgGraphics);
            ImageEncoder encoder = ImageCodec.createImageEncoder(name,out,ep);
            encoder.encode(graphImage);
            out.flush();
            out.close();
            out=null;
            graphImage=null;
            imgGraphics.dispose();
            imgGraphics=null;
        }
        catch(Exception e) {
            JOptionPane.showMessageDialog(null,e.getMessage(),
                                          "Error Message", JOptionPane.ERROR_MESSAGE);
            e.printStackTrace();
        }
    }

    // Draw a graph in graphics context g
    public void draw (Graphics g) {
        int xmax=xaxis.getInteger((xaxis.maximum));
        int ymax=yaxis.getInteger((yaxis.maximum));
        int xmin=xaxis.getInteger((xaxis.minimum));
        int ymin=yaxis.getInteger((yaxis.minimum));
        graph.setGraphBackground(Color.white);
        graph.paintComponent(g);
        g.setColor(Color.black);
        xaxis.drawAxis(g);
        yaxis.drawAxis(g);
        g.drawLine(xmin,ymax,xmax,ymax);
        g.drawLine(xmax,ymin,xmax,ymax);
        graph.setGraphBackground(Color.lightGray);
    }

    public float getMax() {
        return (float)xaxis.maximum;
    }

    public float getMin() {
        return (float)xaxis.minimum;
    }

    class FrameChooserListener implements ActionListener {
        public void actionPerformed (ActionEvent e) {
            int[] frames;
            int fframe,lframe,incframe;
            frames=OtokoGraphics.this.frameChooser.getFrameRange();
            if(frames!=null) {
                fframe=frames[0];
                lframe=frames[1];
                incframe=frames[2];
                try {
                    DataSet[] oldData = OtokoGraphics.this.mainDataSet;
                    OtokoGraphics.this.mainDataSet=createDataSet(OtokoGraphics.this.otokoData,
                                                             OtokoGraphics.this.qaxData,
                                                             fframe,lframe,incframe,Color.blue);
                    OtokoGraphics.this.hideDataSet(oldData);
                    OtokoGraphics.this.showDataSet(mainDataSet);
                    OtokoGraphics.this.frameChooser.setVisible(false);
                }
                catch(Exception ex) {
                    JOptionPane.showMessageDialog(null,ex.getMessage(),
                                                  "Error Message", JOptionPane.ERROR_MESSAGE);
                }
            }
        }
    }

    private class HelpActionListener implements ActionListener{
        public void actionPerformed(ActionEvent e) {
            final ActionEvent event =e;
            SwingUtilities.invokeLater(new Runnable() {
                public void run() {
                    new CSH.DisplayHelpFromSource(hb).actionPerformed(event);
                }
            });
            OtokoGraphics.this.update(OtokoGraphics.this.getGraphics());
        }
    }
}