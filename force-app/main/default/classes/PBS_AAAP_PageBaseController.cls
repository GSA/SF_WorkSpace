//public with sharing virtual class PBS_AAAP_PageBaseController {
public virtual class PBS_AAAP_PageBaseController {
    protected string getQueryParamAsString(string paramName) {
        return PBS_AAAP_Utility.getQueryParamAsString(paramName);
    }
    protected decimal getQueryParamAsDecimal(string paramName) {
        return PBS_AAAP_Utility.getQueryParamAsDecimal(paramName);
    }
    protected decimal getQueryParamAsDecimal(string paramName, decimal defaultValue) {
        return PBS_AAAP_Utility.getQueryParamAsDecimal(paramName, defaultValue);
    }
    protected void setQueryParam(string paramName, string val) {
        PBS_AAAP_Utility.setQueryParam(paramName, val);
    }
    protected void logConstructorStart(string className){
        logMethodStart(className + ' constructor');
    }
    protected void logConstructorEnd(string className){
        logMethodEnd(className + ' constructor');
    }
    protected void logMethodStart(string methodName){
        PBS_AAAP_Utility.logMethodStart(methodName);
    }
    protected void logMethodEnd(string methodName){
        PBS_AAAP_Utility.logMethodEnd(methodName);
    }
    protected void logMethodEnd(string methodName, object ret){
        PBS_AAAP_Utility.logMethodEnd(methodName, ret);
    }
}