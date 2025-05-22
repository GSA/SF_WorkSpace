public class LMTException extends Exception {
    public static void throwLMTException(String message){
        System.debug('In LMTException class: ' + message);
        throw new LMTException(message); 
    }
}