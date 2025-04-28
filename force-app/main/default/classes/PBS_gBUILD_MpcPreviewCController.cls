public with sharing class PBS_gBUILD_MpcPreviewCController extends PBS_gBUILD_ComponentBaseController
{
    public Boolean viewMode { get; set; }
    //public String status{get;set;}
    //public String comments {get;set;}
    public Boolean flag;
    public String param1 {get; set;} 
    public List<PBS_gBUILD_PBuildingMPCUpdate__c> showMPCUpdate {get;set;}
    public List<PBS_gBUILD_PBuildingMPCUpdate__c> showDRUpdate {get;set;} // KUMAR
    
    public Map<String,List<String>> previousValuesMap;
    //public PBS_gBUILD_PBuildingMPCUpdate__c showMPCUpdate {get;set;}
    public Boolean editMode
    {
        get
        {
            return !viewMode;
        }       
    }
    public Integer num { get; set; }    
    public List<PBS_gBUILD_PBuildingMPCUpdate__c> mus { get; set; }  
    public boolean showExistingMpcUpdates
    {
        get
        {
            return mus!=null && mus.size()>0;
        }
    }
    public PBS_gBUILD_PBuildingMPCUpdate__c mpcEdit { get; set; }   
    public PBS_gBUILD_PBuildingMPCUpdate__c drEdit { get; set; }
    public boolean isDesignReviewer { get; set; }
    public string actionId { get; set; }
    
    public PBS_gBUILD_MpcPreviewCController()
    {
        system.debug('This is param value ==== ' + param1);
        mpcEdit = new PBS_gBUILD_PBuildingMPCUpdate__c();
        drEdit = new PBS_gBUILD_PBuildingMPCUpdate__c();
        previousValuesMap = new Map<String,List<String>>();
    }
    
    public String pbuildingId
    {
        get
        {
            return ((PBS_gBUILD_ProjectIdBaseController)pageController).pbuildingId; 
        }   
    }
    
    protected override void onRegistered()    
    {
        if (editMode)
        {
            PBS_gBUILD_PBuildingMpcController c = (PBS_gBUILD_PBuildingMpcController) pageController;
        }
    }
    
    public PageReference open()
    {
        return new PageReference('/apex/PBS_gBUILD_PBuildingMpcUpdate?'+PBS_gBUILD_Utility.queryStringMpcUpdateId+'='+actionId);
    }
    /*
        public PageReference setParams()
        {
        
        system.debug('This is param value ' + param1);      
        return null;
    }*/
    
    public void edit(){
        PBS_gBUILD_PBuildingMpcController c = (PBS_gBUILD_PBuildingMpcController) pageController;
        system.debug('This is Controller ' + c);
        String question = PBS_gBUILD_Utility.convertNumToMpcQuestion(num);
        system.debug('This is Question ' + question);
        //system.debug('Key ' + PBS_gBUILD_ComponentBaseController.key);
        if(c != null){
            showMPCUpdate = [SELECT Id, Name,RecordType.DeveloperName, Status__c, Comments__c, CreatedDate,Question__c  FROM PBS_gBUILD_PBuildingMPCUpdate__c WHERE Question__c = :question AND Rahd_ProjectBldgParentId__c = :c.pbuildingId AND RecordType.DeveloperName='MPC' AND IsCurrent__c= TRUE ORDER BY CreatedDate DESC LIMIT 1];
            //RITM0604555 - Added
            showDRUpdate = [SELECT Id, Name,RecordType.DeveloperName, DesignReviewStatus__c, Comments__c, CreatedDate,Question__c  FROM PBS_gBUILD_PBuildingMPCUpdate__c 
                            WHERE Question__c = :question AND Rahd_ProjectBldgParentId__c = :c.pbuildingId 
                            AND RecordType.DeveloperName='DR' AND IsCurrent__c= TRUE ORDER BY CreatedDate DESC LIMIT 1];
            
            // showMPCUpdate = [SELECT Id, Name, Status__c, Comments__c, CreatedDate,Question__c  FROM PBS_gBUILD_PBuildingMPCUpdate__c WHERE Question__c = :question ORDER BY CreatedDate DESC LIMIT 1];
            system.debug('This is showMPCUpdate ' + showMPCUpdate);
            for(PBS_gBUILD_PBuildingMPCUpdate__c eachObj :showMPCUpdate){
                    List<String> previousValuesList = new List<String>();
                    String keyVal = c.pbuildingId +eachObj.Question__c+'MPC';
                    previousValuesList.add(eachObj.Status__c);
                    previousValuesList.add(eachObj.Comments__c);
                    previousValuesMap.put(keyVal,previousValuesList);
            }
            if(!showMPCUpdate.isEmpty()){           
                mpcEdit.Status__c = showMPCUpdate[0].Status__c;
                mpcEdit.Comments__c = showMPCUpdate[0].Comments__c;
            }
            if(!showDRUpdate.isEmpty()){           
                drEdit.DesignReviewStatus__c = showDRUpdate[0].DesignReviewStatus__c;
                drEdit.Comments__c = showDRUpdate[0].Comments__c;
            }
        }
    }
    
    public void save()
    {
        //PBS_gBUILD_Utility.showDebugMessage('MPCC Save.A');
        if (drEdit==null || mpcEdit==null) return;
        //PBS_gBUILD_Utility.showDebugMessage('MPCC Save.B');
        
        PBS_gBUILD_PBuildingMpcController c = (PBS_gBUILD_PBuildingMpcController) pageController;
        String question = PBS_gBUILD_Utility.convertNumToMpcQuestion(num);
        if (drEdit.DesignReviewStatus__c!=null)
        {        
            drEdit.Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(num);
            //PBS_gBUILD_Utility.showDebugMessage(string.Format('MPC num={0} type=DR status=[{1}]', new string[]{drEdit.Question__c, drEdit.DesignReviewStatus__c}));
            
            if(c!=null) drEdit.Rahd_ProjectBldgParentId__c = c.pbuildingid; 
            drEdit.RecordTypeId = PBS_gBUILD_Utility.mpcUpdateRecordTypeIdDR;
            insert drEdit;
        }
      
      //SD
     // if (mpcEdit.Comments__c != null){  
        if (mpcEdit.Status__c!=null)
        {
            List<String> previousValuesList;
            String keyVal = c.pbuildingId +question+'MPC';
            flag = false;
            
            if(previousValuesMap.get(keyVal) != null){
                previousValuesList = previousValuesMap.get(keyVal);
                if(mpcEdit.Status__c != previousValuesList.get(0) || mpcEdit.Comments__c != previousValuesList.get(1)){
                    flag = true;
                }
            }else{
                previousValuesList = new List<String>();
                previousValuesList.add(mpcEdit.Status__c);
                previousValuesList.add(mpcEdit.Comments__c);
                previousValuesMap.put(keyVal,previousValuesList);
                flag = true;
            }
            
            
            mpcEdit.Question__c = PBS_gBUILD_Utility.convertNumToMpcQuestion(num);
            //PBS_gBUILD_Utility.showDebugMessage(string.Format('MPC num={0} type=MPC status=[{1}]', new string[]{ mpcEdit.Question__c, mpcEdit.Status__c}));
            
            if(c!=null) mpcEdit.Rahd_ProjectBldgParentId__c = c.pbuildingid; 
            mpcEdit.RecordTypeId = PBS_gBUILD_Utility.mpcUpdateRecordTypeIdMPC; 
            if(flag){
                insert mpcEdit;
                PBS_gBUILD_Utility.showDebugMessage('---------');
            } 
            mpcEdit = new PBS_gBUILD_PBuildingMPCUpdate__c();
            
        } 
        /*else {
            //SD               
                flag=false;               
                PBS_gBUILD_Utility.showDebugMessage('---Inside Status=null and Comment is not null------');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'MPC Comments cannot be saved without selecting MPC Status. Please select a Status.'));

        }  
      }  */
        mpcEdit = new PBS_gBUILD_PBuildingMPCUpdate__c();
        drEdit = new PBS_gBUILD_PBuildingMPCUpdate__c();
    }
    
  
}