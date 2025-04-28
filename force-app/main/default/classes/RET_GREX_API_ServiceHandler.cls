public class RET_GREX_API_ServiceHandler Implements RET_APIntegration_Interface{
    
    Public static Object doHandleRequest(String jsonRequest, String serviceType){
        System.debug('RET_GREX_API_ServiceHandler');
        RET_GREX_API_Integration__mdt Grex_mdt = RET_GREX_API_Integration__mdt.getInstance(serviceType);
		RET_GREX_API_ServiceImpl GREX_ServiceCall = new RET_GREX_API_ServiceImpl();
        Object obj = GREX_ServiceCall.handleGREXcall(jsonRequest, Grex_mdt);
        system.debug('Response' + Obj);
        return obj;
    }

}