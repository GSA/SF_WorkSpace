/*******************************************************************************************
* Name: PBS_AAAP_ContentVersionTriggerHandler
* Test: Test_PBS_AAAP_ContentVersionTrigger
* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              ???     	  	  ????	             Initial Creation  
*  1.1				Vanwinkle T		  3/14/2021			 update to With Shraring per SFWS-1666
*******************************************************************************/

public with sharing class PBS_AAAP_ContentVersionTriggerHandler implements ITriggerHandler
{
    /* This class implements ITriggerHander. This sample shows how to 
     * retrieve the metadata type and set the isDisabled flag
    */
    public Trigger_Settings__mdt triggerMeta = new Trigger_Settings__mdt();
    
    //create a constructor to get the metadatatype
    public PBS_AAAP_ContentVersionTriggerHandler() {
          //Retrive the metadata type
        triggerMeta = [Select DeveloperName, isActive__c, ObjectName__c, Recursion_Check__c, Max_Loop_Count__c from Trigger_Settings__mdt where DeveloperName='ContentVersionTrigger' LIMIT 1] ; 
    
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
        List<ContentVersion> newList = (List<ContentVersion>) newItems;
        //Looping through all the ContentVersion records
        for(ContentVersion ContentVersionRecord : newList){
            //Here we are setting Origin to C so these files also can be used by quest user
           	ContentVersionRecord.Origin = 'C';
        }
        
    }
 
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
 
    public void BeforeDelete(Map<Id, SObject> oldItems) {}  
 
    public void AfterInsert(Map<Id, SObject> newItems) {}
 
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
    
    public void AfterDelete(Map<Id, SObject> oldItems) {}  
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
 
   
 
   
}