public class NoParameterException extends Exception {

    public NoParameterException(String source) {
        super("Please input "+source);
    }
}
