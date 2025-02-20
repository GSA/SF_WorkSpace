public with sharing class NCMT_MoveCostModule_Ctrl_LC {

    public static NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
    
    public class moveCostWrapper {
        @AuraEnabled public NCMT_Housing_Plan__c housingPlan {get;set;}
        @AuraEnabled public List<NCMT_Other_Cost__c> otherCosts {get;set;}
        @AuraEnabled public String reportId {get;set;}
        @AuraEnabled public List<NCMT_Project__c> projList {get;set;}
        @AuraEnabled public String redirectProjName {get;set;}
        @AuraEnabled public String redirectMoveCostMod {get;set;}

    }
    
    @AuraEnabled
    public static NCMT_Project__c createProject(String projName)
    {
        System.debug('Create Dummy Project for Move Cost Module');
        
        String fiscalYear = String.valueOf(ncmt_customsettings.Cost_Parameter_Date__c.year()+1);
        NCMT_Project__c proj = new NCMT_Project__c(Name = projName,
            									   Estimate_Type_Proj__c = 'Parametric',
                                                   Project_Type__c = 'New Construction',
                                                   Building_Type__c = 'Office',
                                                   Building_Selection__c = 'New',
                                                   Purpose_of_Estimate__c = 'Portfolio Planning',
                                                   Start_Construction__c = System.today(),
                                                   Housing_Plan__c = true,
                                                   State__c = 'California',
                                                   City__c = 'San Diego',
                                                   Remoteness__c = 'Urban',
            									   Move_Cost_Module__c = true,
                                                   RecordTypeId = Schema.getGlobalDescribe().get('NCMT_Project__c').getDescribe().getRecordTypeInfosByName().get('New Construction').getRecordTypeId()
                                                   );
        
        
        
        NCMT_Location_Parameters__c loc = [SELECT Id FROM NCMT_Location_Parameters__c
                                          WHERE State__c =: proj.State__c 
                                          AND City__c =: proj.City__c
                                          AND Fiscal_Year__c =: '2017'];
        
        proj.Location__c = loc.Id;
        insert proj;
        
        return proj;
    }
    
    @AuraEnabled
    public static moveCostWrapper initMoveCostMod()
    {
        NCMT_RedirectCustomObjectpage__c customSettings = NCMT_RedirectCustomObjectpage__c.getOrgDefaults();
        
        moveCostWrapper mc = new moveCostWrapper();
        mc.projList = [SELECT Name, (SELECT Name, Housing_Plan_Name__c FROM NCMT_Housing_Plans__r),
                       (SELECT Total1__C FROM Other_Costs__r WHERE Cost_Type__c =: 'Moving Costs')
                       FROM NCMT_Project__C
                       WHERE Move_Cost_Module__C =: true
                       AND CreatedById =: UserInfo.getUserId()
                       ORDER BY LastModifiedDate DESC];
      
		Report rep = [Select Name, IsDeleted, Id, Description 
                      From Report 
                      Where Description = : 'NCMT Reports' 
                      and Name =: 'Project Moving Costs'
                      and IsDeleted = false 
                      Order By Name LIMIT 1];
        
        mc.reportId = rep.Id;
        
        mc.otherCosts = [SELECT Name, Cost_Type__c, Cost_based_on__c, Housing_Plan_Cost_Sub_Type__c,
                         		Housing_Plan_Option_Choice__c, Space_Type__c, Total1__c, NCMT_Project__c,
                         		NCMT_Housing_Plan_Option_Selection__r.NCMT_Housing_Plan__c
                         FROM NCMT_Other_Cost__C 
                         WHERE NCMT_Project__c IN: mc.projList
                         AND Cost_Type__c =: 'Moving Costs'];
        
        mc.redirectProjName = customSettings.Housing_Plan_Project_Name__c;
        mc.redirectMoveCostMod = customSettings.HP_Move_Cost_Module__c;
        
        return mc;
    }
    
    @AuraEnabled
    public static moveCostWrapper getOtherCostData(String recId){
        moveCostWrapper wrap = new moveCostWrapper();
        wrap.housingPlan = [SELECT Id, Name, Project__c, Move_Cost_Module__c 
                            FROM NCMT_Housing_Plan__c WHERE Id =: recId];
        String projId = wrap.housingPlan.Project__c;
        
        wrap.otherCosts = [SELECT Name, Cost_Type__c, Cost_based_on__c, Housing_Plan_Cost_Sub_Type__c,
                                                 Housing_Plan_Option_Choice__c, Space_Type__c, Total1__c, 
                           						 NCMT_Project__c, NCMT_Housing_Plan_Option_Selection__r.NCMT_Housing_Plan__c
                                          FROM NCMT_Other_Cost__C 
                                          WHERE NCMT_Project__c =: projId
                                          AND Cost_Type__c =: 'Moving Costs'
                          				  AND NCMT_Housing_Plan_Option_Selection__r.NCMT_Housing_Plan__c =: wrap.housingPlan.Id];
        return wrap;
    }
    // Added for Project Move Cost #block 1
  @AuraEnabled
    public static Boolean isLightning(){
        String theme=UserInfo.getUiThemeDisplayed();
        system.debug('urlvalue'+theme);
        
        
        If(theme=='Theme2'||theme=='Theme3'){
            return false;
                }  else {
                  return   true;
                }
    }
  // End of code added  #block 1

}