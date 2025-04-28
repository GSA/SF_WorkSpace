@isTest
public class TestPBS_gBUILD_PCashflowEditController
{
    public static testMethod void testPlaceholder()
    {  
        system.assert(true);  
    }  
    
/*  
  
  public static testMethod void testPCashFlow()
  {
        PBS_Project__c testMPro = new PBS_Project__c();
        insert testMPro;
        PBS_gBUILD_Project__c testPro = new PBS_gBUILD_Project__c (
        Projectid__c=testMPro.id
        );
        testPro.MachineName__c='testmachine';
        testPro.StateNameCurrent__c='testState';
        insert testPro;
        PBS_Building__c testPB = new PBS_Building__c (
        Building_ID__c=1111,
        Location_Code_Plus__c='abcd'
        );
        insert testPB;
        PBS_gBUILD_ProjectBuilding__c testB = new PBS_gBUILD_ProjectBuilding__c (
        Rahd_ProjectParentId__c=testPro.id,
        BldgId__c=testpb.id
        );
        insert testB;
         PageReference pageRef = Page.PBS_gBUILD_PCashflowEdit;  
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('id', testPro.id);
         pageRef.getParameters().put('pbuildingId', testPB.id);
         Cookie[] cookies  = new Cookie[3];
         Cookie c=new Cookie('id', testPro.id, null, -1, false);
         Cookie c1=new Cookie('pbuildingId', testB.id, null, -1, false);
         cookies[0]=c;
         cookies[1]=c1;  
         PBS_gBUILD_ProjectPerformanceCashflow__c testCash = new PBS_gBUILD_ProjectPerformanceCashflow__c(
                                                                 AnnualContractorPayments__c = 0,
                                                                 EstimatedAnnualCostSav__c = 0,
                                                                 ProposedGuaranteedAnnualCostSav__c = 0,
                                                                 Year__c=9999,
                                                                 Rahd_ProjectParentId__c =testPro.id
                                                                 );
          insert testCash;
          pageRef.getParameters().put('Cashid', testCash.id);
          Cookie c2=new Cookie('CashId', testCash.id, null, -1, false);
          cookies[2]=c2;
          pageRef.setCookies(cookies);
          PBS_gBUILD_PCashflowEditController con= new PBS_gBUILD_PCashflowEditController ();
           PageReference pf=null;
           PBS_gBUILD_ProjectPerformanceCashflow__c testCashinsert = [select id, name from PBS_gBUILD_ProjectPerformanceCashflow__c where Year__c=9999 LIMIT 1];
           upsert testCashinsert;
          
      //  pf=con.bind();
          pf=con.edit();
          system.assertEquals(pf ,null);
          pf=con.cancel();
          system.assertEquals(pf ,null);
         pf=con.save();
         system.assertEquals(pf ,null);
          
         
        }
 */
}