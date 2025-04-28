@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PFinancialsController
{  
    private static final TestPBS_gBUILD_Utility.TestData td;

    static 
    {
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();
    }

    public static testMethod void testConstructor()
    {
        PBS_gBUILD_Project__c p = td.createGbProjectOnPbsProjectEpm1();

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);

        PBS_gBUILD_PFinancialsController ctrl = new PBS_gBUILD_PFinancialsController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assert(ctrl.fin!=null);
        system.assertEquals(0, ctrl.cashFlowList.size());
        system.assertEquals(0, ctrl.cashflows.size());

        Date dt = date.parse('12/27/2009');
        dt = dt.addYears(1);
        ctrl.fin.FirstPaymentDue__c = dt;
        ctrl.fin.Payments__c = 24;
        ctrl.fin.PerfPaymentMethod__c = PBS_gBUILD_Utility.projectPerformancePaymentMethodMonthly;
        ctrl.save();

        system.assertEquals(24, ctrl.cashFlowList.size());
        system.assertEquals(24, ctrl.cashflows.size());
                
        ctrl.fin.PerfPaymentMethod__c = PBS_gBUILD_Utility.projectPerformancePaymentMethodQuarterly;
        ctrl.save();
        ctrl.fin.PerfPaymentMethod__c = PBS_gBUILD_Utility.projectPerformancePaymentMethodAnnually;
        ctrl.save();                

        ctrl.cancel();
        ctrl.edit();
    }
}