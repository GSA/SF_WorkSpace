@isTest(SeeAllData=false)
public class TestPBS_gBUILD_HomeController
{  
    static 
    {
        TestPBS_gBUILD_Utility.setup();
    }

    public static testMethod void testConstructor()
    {
        PBS_gBUILD_HomeController ctrl = new PBS_gBUILD_HomeController();
        system.assert(ctrl!=null);
    } 
    
    public static testMethod void PBS_gBUILD_ComponentBaseControllerOnRegistered()
    {
        PBS_gBUILD_HomeController ctrl = new PBS_gBUILD_HomeController();
        system.assert(ctrl!=null);
        PBS_gBUILD_ComponentBaseController com = new PBS_gBUILD_ComponentBaseController();
        com.pageController = ctrl;
    }     
}