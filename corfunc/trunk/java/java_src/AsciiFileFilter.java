import javax.swing.filechooser.*;
import java.io.File;

public class AsciiFileFilter extends FileFilter {

    public boolean accept(File f){
        String fName = f.getName();
        if(f.isDirectory()) {
            return (true);
        }else if ((fName.toLowerCase()).endsWith(".txt")) {
                return (true);
        }else if ((fName.toLowerCase()).endsWith(".dat")) {
                return (true);
        }else if ((fName.toLowerCase()).endsWith(".loq")) {
                return (true);
        }else {
            return (false);
        }
    }

    public String getDescription(){
        return ("ASCII files");
    }
}
