public class LogEventUtil {
      
    //Generated Unique Identifier.
    //Used to set unique Id for custom platform events(Log__e) and App Log records
    public static string generateUUID(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        //Commented out due to Critical privacy vulnerability identified by Fortify 01/2025
        //system.debug(guid);
        
        return guid;
    }
}