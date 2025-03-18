@isTest
public class NCMT_TestclsHelpPageDetails{

@isTest static void testHelpPageDetailsController(){ 
        NCMT_HelpContent__c customsetting = new NCMT_HelpContent__c();
        customsetting.name = 'NCMT Help Site';
        customsetting.NCMT_Help_Site__c='https://www.google.com';
        customsetting.NCMT_Help_Site_New_Construction_LPOE__c='https://www.google.com';
        customsetting.NCMT_Help_Site_New_Construction_PG__c='https://www.google.com';
        customsetting.NCMT_Help_Site_New_Construction_Oth__c='https://www.google.com';
        customsetting.NCMT_Help_Site_RA_Parametric__c='https://www.google.com';
        customsetting.NCMT_Help_Site_RA_WorkItem__c='https://www.google.com';
        
        insert customsetting; 
        Test.startTest();       
            
        PageReference pageRef = Page.NCMT_HelpPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ProjectType', 'New Construction');
        ApexPages.currentPage().getParameters().put('BuildingType','LPOE');
         
        NCMT_clsHelpPageDetails objtest1 = new NCMT_clsHelpPageDetails();      
        objtest1.load(); 
        System.Assert(objTest1!=NULL);
        
        PageReference pageRef1 = Page.NCMT_HelpPage;
        Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('ProjectType', 'Parametric Entry');
        ApexPages.currentPage().getParameters().put('BuildingType', 'Parking Garage');
         
        NCMT_clsHelpPageDetails objtest2 = new NCMT_clsHelpPageDetails();      
        objtest2.load(); 
        System.Assert(objTest2!=NULL);
        
        PageReference pageRef2 = Page.NCMT_HelpPage;
        Test.setCurrentPage(pageRef2);
        ApexPages.currentPage().getParameters().put('ProjectType','Work Item Detail');
        ApexPages.currentPage().getParameters().put('BuildingType', 'Office');
         
        NCMT_clsHelpPageDetails objtest3 = new NCMT_clsHelpPageDetails();      
        objtest3.load();
        System.Assert(objTest3!=NULL);     
        
        PageReference pageRef3 = Page.NCMT_HelpPage;
        Test.setCurrentPage(pageRef3);
         
        NCMT_clsHelpPageDetails objtest4 = new NCMT_clsHelpPageDetails();      
        objtest4.load(); 
        System.Assert(objTest4!=NULL);  
        
        PageReference pageRef4 = Page.NCMT_HelpPage;
        Test.setCurrentPage(pageRef4);
        ApexPages.currentPage().getParameters().put('ProjectType', 'New Construction');
        ApexPages.currentPage().getParameters().put('BuildingType','Parking Garage');
         
        NCMT_clsHelpPageDetails objtest5 = new NCMT_clsHelpPageDetails();      
        objtest5.load();
        System.Assert(objTest5!=NULL);
        
        PageReference pageRef5 = Page.NCMT_HelpPage;
        Test.setCurrentPage(pageRef5);
        ApexPages.currentPage().getParameters().put('ProjectType', 'New Construction');
        ApexPages.currentPage().getParameters().put('BuildingType','Office');
         
        NCMT_clsHelpPageDetails objtest6 = new NCMT_clsHelpPageDetails();      
        objtest6.load(); 
        System.Assert(objTest6!=NULL);
      
        Test.stopTest();
         
    }
    
    @isTest static void testProfServHelpPageDetailsController() {
    
        NCMT_HelpContent__c customsetting = new NCMT_HelpContent__c();
        customsetting.name = 'NCMT Help Site';
        customsetting.NCMT_Help_Site_Professional_Services__c='https://www.google.com';
        
        insert customsetting; 
        Test.startTest();
        
        PageReference pageRef6 = Page.NCMT_HelpPage;
        Test.setCurrentPage(pageRef6);
         
        NCMT_clsProfServHelpPageDetails objtest7 = new NCMT_clsProfServHelpPageDetails();      
        objtest7.redirectHelp(); 
        System.Assert(objTest7!=NULL);
      
        Test.stopTest();
    
    }
    
    @isTest static void testRAWIHelpPageDetailsController() {
    
        NCMT_HelpContent__c customsetting = new NCMT_HelpContent__c();
        customsetting.name = 'NCMT Help Site';
        customsetting.NCMT_Help_Site_RA_WorkItem_Detail__c='https://www.google.com';
        
        insert customsetting; 
        Test.startTest();
        
        PageReference pageRef7 = Page.NCMT_HelpPage;
        Test.setCurrentPage(pageRef7);
         
        NCMT_clsRAWIHelpPageDetails objtest8 = new NCMT_clsRAWIHelpPageDetails();      
        objtest8.redirectHelp(); 
        System.Assert(objTest8!=NULL);
      
        Test.stopTest();
    
    }
}