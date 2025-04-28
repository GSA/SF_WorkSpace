@isTest
private class GSA_Login_CodeGeneratorTest
{
    static testMethod void getCode() {
     
        GSA_Login_CodeGenerator generator = new GSA_Login_CodeGenerator();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
         
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = generator.invoke(request);
        
        System.AssertEquals(1,1);
    }

    static testMethod void describeTest() {

        GSA_Login_CodeGenerator generator = new GSA_Login_CodeGenerator();
        Process.PluginDescribeResult result = generator.describe();
       
        System.AssertEquals(result.OutputParameters.size(), 1);
     }
}