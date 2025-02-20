public with sharing class NCMT_TCOClone_Ctrl_LC {
    
    @AuraEnabled
    public static NCMT_Project__c getProject(String projId){
        
        NCMT_Project__c proj = [SELECT Id, Name, Project_Record_Id__c FROM NCMT_Project__c WHERE Id =: projId];
        NCMT_Project__C proj2 = (NCMT_Project__c)NCMT_Utilities.cloneMe('NCMT_Project__c', proj.Id, new Set<String>(), false);
        System.debug('Project to clone: ' + proj2);
        
        return proj2;
    }
    
    @AuraEnabled
    public static String cloneTCOProject(String proj) {
        NCMT_Project__c projToClone = (NCMT_Project__c)JSON.deserialize(proj,NCMT_Project__c.class);
        System.debug('projToClone: ' + projToClone.Id);
        System.debug('projRecordID: ' + projToClone.Project_Record_Id__c);
		
        projToClone.Id = null;
        //projToClone.End_Construction__c = null;
        
        try {
        insert projToClone;
        System.debug('CLONE: ' + projToClone.Id);
        
            return projToClone.Id;}
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}