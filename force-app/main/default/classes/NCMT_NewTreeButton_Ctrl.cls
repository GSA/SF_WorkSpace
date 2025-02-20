public with sharing class NCMT_NewTreeButton_Ctrl {
    @AuraEnabled
    public static String projectId {get; set;}
    @AuraEnabled
    public static String projectName {get; set;}
    @AuraEnabled
    public static String parentTreeName {get; set;}
    @AuraEnabled
    public static String recordTypeName {get; set;}
    @AuraEnabled
    public static String branchName {get; set;}
    @AuraEnabled
    public static Boolean includeInEstimate {get; set;}
    @AuraEnabled
    public static NCMT_Tree_structure__c newCustomObject {get; set;}
    @AuraEnabled
    public static NCMT_Tree_structure__c existingCustomObject {get; set;}
    @AuraEnabled
    public static void getRecordInformation(Id recordId){
        existingCustomObject=[Select Id, Name, RecordTypeId, Project_ID__c, Project_ID__r.Name, Branch_Name__c,
                              Relatedtree__c,Relatedtree__r.Name, RecordType.Name, description__c, Include_In_Estimate__c	
                              From NCMT_Tree_structure__c Where Id=:recordId];
        projectId=existingCustomObject.Project_ID__c;
        projectName=existingCustomObject.Project_ID__r.Name;
        parentTreeName=existingCustomObject.Name;
        branchName=existingCustomObject.Branch_Name__c;
        recordTypeName='Default';
        includeInEstimate=existingCustomObject.Include_In_Estimate__c;
        newCustomObject=new NCMT_Tree_structure__c();
    }

    @AuraEnabled
    public static Id getsaveNewrecord(String projectName, Id recordId, String dsc, String branchName, Boolean check){
      System.System.debug('projectName: '+ projectName);
      try{
        existingCustomObject=[Select Id, Name, RecordTypeId, Project_ID__c, Project_ID__r.Name, Branch_Name__c,
                              Relatedtree__c,Relatedtree__r.Name, RecordType.Name, description__c, Include_In_Estimate__c	
                              From NCMT_Tree_structure__c Where Id=:recordId];
        projectId=existingCustomObject.Project_ID__c;
        parentTreeName=existingCustomObject.Name;
        recordTypeName='Default';

        newCustomObject=new NCMT_Tree_structure__c();
        newCustomObject.RecordTypeId=Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByDeveloperName().get('Default').getRecordTypeId();
        newCustomObject.Project_ID__c=existingCustomObject.Project_ID__r.Id;
        newCustomObject.Relatedtree__c=existingCustomObject.Id;
        newCustomObject.description__c=dsc;
        newCustomObject.Include_In_Estimate__c=existingCustomObject.Include_In_Estimate__c;
        newCustomObject.Branch_Name__c= branchName;
        insert newCustomObject;
        System.debug('newCustomObject: '+newCustomObject);

        return newCustomObject.Id;
      }  
      catch(Exception e){
        System.debug('An Exception: '+e);
        return null;
      }
    }
    @AuraEnabled(cacheable=true)
    public static string getProjectName(Id recordId){
        NCMT_Tree_structure__c obj=[Select Id, Name, RecordTypeId, Project_ID__c, Project_ID__r.Name, Branch_Name__c,
        Relatedtree__c,Relatedtree__r.Name, RecordType.Name, description__c, Include_In_Estimate__c	
        From NCMT_Tree_structure__c Where Id=:recordId];
        return obj.Project_ID__r.Name;
    }
    
    @AuraEnabled(cacheable=true)
    public static string getParentTree(Id recordId){
        NCMT_Tree_structure__c obj=[Select Id, Name, RecordTypeId, Project_ID__c, Project_ID__r.Name, Branch_Name__c,
        Relatedtree__c,Relatedtree__r.Name, RecordType.Name, description__c, Include_In_Estimate__c	
        From NCMT_Tree_structure__c Where Id=:recordId];
        return obj.Relatedtree__r.Name;
    }
    @AuraEnabled(cacheable=true)
    public static string getrecordTypeName(Id recordId){
        NCMT_Tree_structure__c obj=[Select Id, Name, RecordTypeId, Project_ID__c, Project_ID__r.Name, Branch_Name__c,
        Relatedtree__c,Relatedtree__r.Name, RecordType.Name, description__c, Include_In_Estimate__c	
        From NCMT_Tree_structure__c Where Id=:recordId];
        return obj.recordType.Name;
    }
    @AuraEnabled(cacheable=true)
    public static Boolean getCheck(Id recordId){
        NCMT_Tree_structure__c obj=[Select Id, Name, RecordTypeId, Project_ID__c, Project_ID__r.Name, Branch_Name__c,
        Relatedtree__c,Relatedtree__r.Name, RecordType.Name, description__c, Include_In_Estimate__c	
        From NCMT_Tree_structure__c Where Id=:recordId];
        return obj.Include_In_Estimate__c;
    }
}