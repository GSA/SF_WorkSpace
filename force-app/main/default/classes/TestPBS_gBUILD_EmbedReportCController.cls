@isTest(SeeAllData=false)
public class TestPBS_gBUILD_EmbedReportCController
{  
    public static testMethod void testConstructor()
    {
        PBS_gBUILD_EmbedReportCController ctrl = new PBS_gBUILD_EmbedReportCController();
        system.assert(ctrl!=null);
        ctrl.height=1;
        ctrl.width=2;
        system.assertEquals('1px', ctrl.heightAttrVal);
        system.assertEquals('2px', ctrl.widthAttrVal);
    } 
}