@IsTest (seeAllData = false)
public class PBS_ProjectNameTriggerTEST{
    /*public static testMethod void testSOPT(){
      //create and insert a project
        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');
        insert config;
        Test.startTest();
        PBS_Project__c proj = new PBS_Project__c(txtCreatedIn__c = 'SOPT', txtLongName__c = 'Testing Projects Long Name');
        insert proj;
        PBS_Project__c proj2 = [SELECT Name, txtLongName__c FROM PBS_Project__c WHERE txtCreatedIn__c = 'SOPT' LIMIT 1];
        upsert proj2;
        system.assertEquals('Testing Projects Long Nameso0000001', proj2.Name);
        Test.stopTest();
    }*/
    public static testMethod void testgBuild(){
        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');
        insert config;
        Test.startTest();
        PBS_Project__c proj = new PBS_Project__c(txtCreatedIn__c = 'gBuild', txtLongName__c = 'Testing Projects Long Nameeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        insert proj;
        PBS_Project__c proj2 = [SELECT Name, txtLongName__c FROM PBS_Project__c WHERE txtCreatedIn__c = 'gBuild' LIMIT 1];
        upsert proj2;
        system.assertEquals('Testing Projects Long Nameeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeegb0000001', proj2.Name);
        Test.stopTest();
    }
    public static testMethod void testEPM(){
        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');
        insert config;
      Test.startTest();
      PBS_Project__c proj = new PBS_Project__c(txtCreatedIn__c = 'ePM', txtLongName__c = 'Testing Projects Long Name');
      insert proj;
      system.assertEquals('ePM', proj.txtCreatedIn__c);
      Test.stopTest();
    }
    public static testMethod void testEmpty(){
        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');
        insert config;
        Test.startTest();
        PBS_Project__c proj = new PBS_Project__c(txtCreatedIn__c = '', txtLongName__c = 'Testing Projects Long Name');
        insert proj;
        system.assertEquals('', proj.txtCreatedIn__c);
        Test.stopTest();
    }
    public static testMethod void testNoLongNameSOPT(){
        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');
        insert config;
        Test.startTest();
        PBS_Project__c proj = new PBS_Project__c(txtCreatedIn__c = 'SOPT');
        insert proj;
        system.assertEquals('SOPT', proj.txtCreatedIn__c);
        Test.stopTest();
    }
    public static testMethod void testNoLongNamegBUILD(){
        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');
        insert config;
        Test.startTest();
        PBS_Project__c proj = new PBS_Project__c(txtCreatedIn__c = 'gBuild');
        insert proj;
        system.assertEquals('gBuild', proj.txtCreatedIn__c);
        Test.stopTest();
    }

    public static testMethod void testNoDefaults(){
        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');
        insert config;
        Test.startTest();
        PBS_Project__c proj = new PBS_Project__c();
        insert proj;
        system.assertEquals(null, proj.txtCreatedIn__c);
        Test.stopTest();
    }
    public static testMethod void testMass(){
        soptConfig__c config = new soptConfig__c(Name = 'PBS Project Auto Numbers', txtaLabel_1__c = '1', txtaLabel_2__c = '1');
        insert config;
        Test.startTest();
        List<PBS_Project__c> projList = new List<PBS_Project__c>();
        for(Integer x=0; x<150; x++){
            PBS_Project__c proj = new PBS_Project__c(txtCreatedIn__c = 'SOPT', txtLongName__c = 'Testing Projects Long Name');
            projList.add(proj);
        system.assertEquals('SOPT', proj.txtCreatedIn__c);
        }
        insert projList;
        Test.stopTest();
    }

}