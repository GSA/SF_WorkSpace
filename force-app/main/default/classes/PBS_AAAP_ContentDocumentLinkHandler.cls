public with sharing class PBS_AAAP_ContentDocumentLinkHandler implements ITriggerHandler
{
	/* This class implements ITriggerHander. This sample shows how to 
	 * retrieve the metadata type and set the isDisabled flag
	*/
    public Trigger_Settings__mdt triggerMeta = new Trigger_Settings__mdt();
    
    //create a constructor to get the metadatatype
    public PBS_AAAP_ContentDocumentLinkHandler() {
          //Retrive the metadata type
    	triggerMeta = [Select DeveloperName, isActive__c, ObjectName__c, Recursion_Check__c, Max_Loop_Count__c from Trigger_Settings__mdt where DeveloperName='ContentDocumentLinkTrigger' LIMIT 1] ; 
    
    }
    
    //read the custom metadata and look for the customer permission
    public Boolean IsDisabled()
    {
		// return IsDisabled= true if the metadata setting isActive = false or
		// the user has the Bypass Trigger custom permission
        if (!triggerMeta.isActive__c || FeatureManagement.checkPermission('Bypass_Trigger')) 
        	return true;
        else 
        	return false;
    } 
 
    public void BeforeInsert(List<SObject> newItems) {
        Set<Id> contentDocumentIds = new Set<Id>();
        Set<Id> contentVersionIds = new Set<Id>();
        String lhwDocumentPrefix = Schema.getGlobalDescribe().get('PBS_AAAP_RLP_Attachments__c').getDescribe().getKeyPrefix();
        List<ContentDocumentLink> newList = (List<ContentDocumentLink>)newItems;
        //looping through ContentDocumentLink
        for (ContentDocumentLink cdl : newList) {
            //Here we are filtering records that are having PBS_AAAP_RLP_Attachments__c records
            if (String.valueOf(cdl.LinkedEntityId).startsWithIgnoreCase(lhwDocumentPrefix)) {
                //Here we are setting Visibility to AllUsers so quest users also can see the files.
                cdl.Visibility = 'AllUsers';
                contentDocumentIds.add(cdl.ContentDocumentId);
            }
        }
        List<ContentDistribution> contentDistributionListToInsert = new List<ContentDistribution>();
        //Here we are querying ContentDocument records and looping through them 
        for(ContentDocument contentDocumentRecord : [Select Id, Title, LatestPublishedVersionId From ContentDocument Where Id In :contentDocumentIds]){
            //Here we are creating new ContentDistribution object and adding it to contentVersionIds list
            ContentDistribution cd = new ContentDistribution();
                cd.Name = contentDocumentRecord.Title;
                cd.ContentVersionId = contentDocumentRecord.LatestPublishedVersionId;
                cd.PreferencesAllowViewInBrowser= true;
                cd.PreferencesLinkLatestVersion=true;
                cd.PreferencesNotifyOnVisit=false;
                cd.PreferencesPasswordRequired=false;
                cd.PreferencesAllowOriginalDownload= true;
            	contentDistributionListToInsert.add(cd);
            	contentVersionIds.add(contentDocumentRecord.LatestPublishedVersionId);
        }
        //Checking the size of the list and inserting them
        if(contentDistributionListToInsert.size() > 0){
            insert contentDistributionListToInsert;
        }
        List<ContentVersion> contentVersionRecords = new List<ContentVersion>();
        //Querying Looping ContentDistribution through inserted records
        for(ContentDistribution contentDistributionRecord : [Select Id, DistributionPublicUrl, ContentVersionId From ContentDistribution Where ContentVersionId In :contentVersionIds]){
            //Here we are setting Public_Link__c field value from DistributionPublicUrl
            contentVersionRecords.add(new ContentVersion(Id=contentDistributionRecord.ContentVersionId,Public_Link__c=contentDistributionRecord.DistributionPublicUrl));
        }
        //Here we are checking size and updating records
        if(contentVersionRecords.size() > 0){
            update contentVersionRecords;
        }
        
    }
 
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
 
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
 
    public void AfterInsert(Map<Id, SObject> newItems) {}
 
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
 
    public void AfterDelete(Map<Id, SObject> oldItems) {}
 
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
}