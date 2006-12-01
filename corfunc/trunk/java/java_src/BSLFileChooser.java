import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;

//BSLFileChooser overrides the approveSelection method of JFileChooser
//in order to check that the file exists and is readable/writable and a valid
//BSL filename first.
public class BSLFileChooser extends JFileChooser {
    private boolean readCheck=false;
    private boolean writeCheck=false;
    private boolean bslCheck=false;
    private String fileName;
    private File selectedFile;
    final BSLFileFilter bslFileFilter = new BSLFileFilter();
    final AsciiFileFilter asciiFileFilter = new AsciiFileFilter();

    public BSLFileChooser () {
        super();
        this.setCurrentDirectory(new File("."));
        this.setMultiSelectionEnabled(false);
    }

    public void setOptions(boolean readOpt, boolean writeOpt, boolean bslOpt, boolean asciiOpt){
        readCheck=readOpt;
        writeCheck=writeOpt;
        bslCheck=bslOpt;
        if(asciiOpt) {
            this.addChoosableFileFilter(asciiFileFilter);
        }
        if(bslOpt) {
            this.addChoosableFileFilter(bslFileFilter);
            this.setFileFilter(bslFileFilter);
        }
    }

    public void setReadCheck(boolean opt) {
        readCheck=opt;
    }

    public void setWriteCheck(boolean opt) {
        writeCheck=opt;
    }

    public void setBSLCheck(boolean opt) {
        bslCheck=opt;
    }

    public void approveSelection() {
        fileName=(selectedFile=getSelectedFile()).getName();
        if(readCheck&&!selectedFile.exists()){
            JOptionPane.showMessageDialog(null,fileName+" : File not found",
                                                "Error message",
                                                JOptionPane.ERROR_MESSAGE);
        } else if(readCheck&&!selectedFile.isFile()){
            JOptionPane.showMessageDialog(null,fileName+" is not a normal file",
                                                "Error message",
                                                JOptionPane.ERROR_MESSAGE);
        } else if(readCheck&&!selectedFile.canRead()){
            JOptionPane.showMessageDialog(null,fileName+" : Read permission denied",
                                                "Error message",
                                                JOptionPane.ERROR_MESSAGE);
        } else if(writeCheck&&selectedFile.exists()&&!selectedFile.canWrite()){
            JOptionPane.showMessageDialog(null,fileName+" : Write permission denied",
                                                "Error message",
                                                JOptionPane.ERROR_MESSAGE);
//SMK, Nov 05
//File chooser complains about ASCII filename syntax
//        } else if(bslCheck&&(fileName.length()!=10 ||
//               !fileName.startsWith("000.",3) ||
//               !Character.isLetterOrDigit(fileName.charAt(0)) ||
//               !Character.isDigit(fileName.charAt(1)) ||
//               !Character.isDigit(fileName.charAt(2)) ||
//               !Character.isLetterOrDigit(fileName.charAt(7)) ||
//               !Character.isLetterOrDigit(fileName.charAt(8)) ||
//               !Character.isLetterOrDigit(fileName.charAt(9)))) {
//                   JOptionPane.showMessageDialog(null,fileName+" is not a valid filename",
//                                                 "Error message",
//                                                 JOptionPane.ERROR_MESSAGE);
        }
        else {
            super.approveSelection();
        }
    }
}
