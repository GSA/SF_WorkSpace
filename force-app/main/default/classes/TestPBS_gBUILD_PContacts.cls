@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PContacts
{  
    public static testMethod void testConstructor()
    {
        TestPBS_gBUILD_Utility.TestData td;
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();

        PBS_gBUILD_Project__c p = td.createGbProjectOnPbsProjectEpm1();
        /////////////Share Testing With Group//////////////////////////////
        /*Group grp = new Group();
        grp.Name = 'GBuildGroupTest123_1';
        insert grp;
        Profile pro = [SELECT Id FROM Profile WHERE Name='Read Only'];
        User user1 = new User(Alias = 'GBTest1', Email='gbuildtesuser123_1@testorg.com', 
              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = pro.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='gbuildTestclassuser123_1@gsa.gov');
        insert user1;
        if(user1 != null && grp != null){
          GroupMember gm = new GroupMember();
          gm.GroupId=grp.id;
          gm.UserOrGroupId=user1.id;
          insert gm;
        }
        */
        Group grp=[select id,name from Group where Name='gBUILD Region 01 Viewer' limit 1];
        if(grp != null){
        PBS_gBUILD_Project__Share share = new PBS_gBUILD_Project__Share();
        share.parentId=p.id;
        share.UserOrGroupId =grp.id;//'00G80000002fBZa';
        share.AccessLevel='edit';
        insert share;   
        }     
        /////////////////////////////////////////////////////////

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);

        PBS_gBUILD_PContactsController ctrl = new PBS_gBUILD_PContactsController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        system.assertEquals(1, ctrl.ProjectActors.size());

        system.assert(ctrl.add()!=null);
        PageReference pgeRef = new PageReference( '/apex/PBS_gBUILD_PContacts');
        Test.setCurrentPage(pgeRef);       
        ctrl.save();
        ctrl.cancel();
        ctrl.edit();  
        ///Account Share Delete Function Test ///////////////////
        Profile pro = [SELECT Id FROM Profile WHERE Name='GSA System User'];
        User u = new User(Alias = 'GBTest2', Email='gbuildtesuser123_2@testorg.com', 
              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = pro.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='gbuildTestclassuser123_2@gsa.gov');
        insert u;
        
        PBS_gBUILD_Project__Share share1 = new PBS_gBUILD_Project__Share();
        share1.parentId=p.id;
        share1.UserOrGroupId =u.id;
        share1.AccessLevel='edit';
        insert share1;        
        //////////////////////////////////////////////////////////
        
        ctrl.actionId =share1.id;    
        ctrl.del();  
        
    }

    /*
    public static testMethod void testGlobalActors()
    {
        Group g = [select id from group where developername='gBUILD_Viewer'];
        GroupMember gm = new GroupMember();
        gm.groupid = g.id;
        gm.UserOrGroupId = UserInfo.getUserId();
        insert gm;
        
        test.startTest();

        TestPBS_gBUILD_Utility.TestData td;
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();

        PBS_gBUILD_Project__c p = td.createGbProjectOnPbsProjectEpm1();

        TestPBS_gBUILD_Utility.setCurrentPageReference(p.id);

        PBS_gBUILD_PContactsController ctrl = new PBS_gBUILD_PContactsController();
        integer cnt = ctrl.GlobalActors.size();
        system.assert(cnt>0);
        cnt = 0;
        for (PBS_gBUILD_PContactsController.Actor a : ctrl.GlobalActors)
        {
            if (a.Type=='User') ++cnt;
        }
        system.assertEquals(1, cnt);
        
        test.stopTest();        
    }
    */
}