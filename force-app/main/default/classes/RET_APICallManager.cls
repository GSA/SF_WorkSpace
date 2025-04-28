/* This class will manage any API that is being called and helps in executing right service handler  
	Can also use custom metadata to handle this method
*/
public class RET_APICallManager {
    public static Map<String, Type> resourceToHandler = new Map<String, Type>{
        'RET_GREX_API_Integration' => RET_GREX_API_ServiceHandler.class
        //'RET_MULE_API_Integration' => RET_MULE_API_ServiceHandler.class
            };
}