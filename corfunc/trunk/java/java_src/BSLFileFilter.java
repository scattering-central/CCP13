import javax.swing.filechooser.*;
import java.io.File;

public class BSLFileFilter extends FileFilter {

    public boolean accept(File f){
        String fName = f.getName();
        if(f.isDirectory()) {
            return (true);
        }else if (fName.length()==10 &&
            fName.startsWith("000.",3) &&
            Character.isLetterOrDigit(fName.charAt(0)) &&
            Character.isDigit(fName.charAt(1)) &&
            Character.isDigit(fName.charAt(2)) &&
            Character.isLetterOrDigit(fName.charAt(7)) &&
            Character.isLetterOrDigit(fName.charAt(8)) &&
            Character.isLetterOrDigit(fName.charAt(9))) {
                return (true);
        }else {
            return (false);
        }
    }

    public String getDescription(){
        return ("BSL/OTOKO files");
    }
}
