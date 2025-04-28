/*
  TestPublicUserGroupHandlerTest.cls
  Class for testing PublicGroupUserSyncHelper object
  -------------------------------------------------------------------------------
  Author                 Date        Version  Description
  -------------------------------------------------------------------------------
  Murugaboopathi         07/02/2012  1.0      Creation
*/
@isTest(SeeAllData=true)
public class PublicGroupUserSyncHelperTest {

    static testMethod void testStaticVariables()    
    {
        Test.startTest();
        PublicGroupUserSyncHelper.isTestMethod = true;
        System.assertEquals(PublicGroupUserSyncHelper.UPDATE_PREVIOUS_ORG_VALUE,'');
        System.assertEquals(PublicGroupUserSyncHelper.IS_BEFORE_UPDATE ,true);
        System.assertEquals(PublicGroupUserSyncHelper.count,0);
        System.assertEquals(PublicGroupUserSyncHelper.afterMajorOrgName,'');
        System.assertEquals(PublicGroupUserSyncHelper.beforeMajorOrgName,'');
        System.assertEquals(PublicGroupUserSyncHelper.isTestMethod ,true);
        PublicGroupUserSyncHelper.isTestMethod = false;
        Test.stopTest();
    }    
}