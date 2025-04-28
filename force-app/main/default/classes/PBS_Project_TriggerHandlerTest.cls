@isTest
public class PBS_Project_TriggerHandlerTest {
  static testMethod void TestOnAfterUpdate(){
                
       PBS_Project__c proj1 = new PBS_Project__c();
       PBS_Small_Projects_Historical_Database__c sphd1 = new PBS_Small_Projects_Historical_Database__c();

       proj1.Name = 'Test 1';
       proj1.txtProjectDescription__c = 'Scope Description for Project 1';
       
       List<PBS_Project__c> prjts = new List<PBS_Project__c>();
       prjts.add(proj1);
       insert prjts;
       
       sphd1.PBS_Project_Name__c = proj1.ID;
       sphd1.Central_Facility_Repository_CFR__c = 'www.gsa.gov';
       sphd1.Scope_Description__c = 'Scope Description for Project 1 v1.0';
       sphd1.Property_Manager_User__c = UserInfo.getUserId();
       sphd1.Supervisor_User__c = UserInfo.getUserId();
       insert sphd1;
       
       proj1.txtProjectDescription__c = 'Scope Description for Project 1 v2.0';
       update proj1;
       
       List<PBS_Small_Projects_Historical_Database__c> gtList = [SELECT ID, Scope_Description__c
                                                                    FROM PBS_Small_Projects_Historical_Database__c 
                                                                    WHERE PBS_Project_Name__c IN :prjts];
       
       system.assertEquals(proj1.txtProjectDescription__c,gtList[0].Scope_Description__c); 

    } 
}