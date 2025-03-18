public with sharing class RET_FileUploadController {
    public RET_Document_Data__c dataTemplate {get;set;}
    public List<RET_Document_Data__c> collRET{get;set;}
    public Boolean showUpload { get; set; }
    public String leaseNumber { get; set; }
    public String docMapValues {get;set;}
    public String caseId { get; set; }
    public String attID { get; set; }
    public Boolean showForm { get; set; }
    public RET_FileUploadController() {
        showForm = true;        

        caseID = getValidId(ApexPages.currentPage().getParameters().get('caseId'));
        if(String.isBlank(caseID)) {
            showForm = false;
            docMapValues = '{}';
            return;
        }
        attID = getValidId(ApexPages.currentPage().getParameters().get('attachmentId'));

        Set<Id> unqAtt = new Set<Id>();
        for(Attachment aRec :[select id from Attachment where parentId = :caseId]){
            unqAtt.add(aRec.Id);
        }
        system.debug(unqAtt);
        Map<String,Integer> mapDoctypeToCount = new Map<String,Integer>();
        for(RET_Document_Data__c tmp: [select Id,Name,Full_File_Name__c,Document_Type__c 
                                           from RET_Document_Data__c 
                                           where Attachment_ID__c in :unqAtt 
                                           ORDER BY Name ASC]){
            if( !mapDoctypeToCount.containskey(tmp.Document_Type__c))
                mapDoctypeToCount.put(tmp.Document_Type__c,0);
            mapDoctypeToCount.put(tmp.Document_Type__c,mapDoctypeToCount.get(tmp.Document_Type__c)+1);
        }
        docMapValues = Json.serialize(mapDoctypeToCount);
        
        if(!String.isBlank(caseID)){
            List<Case> collCase = [select id,PBS_Lease__r.Lease_Number__c from Case where id = :caseId limit 1];
            if(collCase.size()>0 && collCase[0].PBS_Lease__r.Lease_Number__c != null) {
                leaseNumber = collCase[0].PBS_Lease__r.Lease_Number__c;
            } else {
                showForm = false;
                docMapValues = '{}';
                return;
            }
        }
        
        if(!String.isBlank(attId)){
            showUpload = false;
            collRET = [select Id, Name,Full_File_Name__c, Tax_Year__c, Document_Type__c, Attachment_ID__c, 
                            Tax_Block_Number__c, Tax_Lot_Number__c, Tax_Bill_Frequency__c, 
                            Tax_Period_Start__c, Tax_Period_End__c,Tax_Authority_for_Document__c,Tax_Bill_Due_Date__c from RET_Document_Data__c 
                            where attachment_id__c =:attId limit 1];
            if(collRET !=null && collRET.size() >0){
                dataTemplate = collRET[0];
            }
        }else{
            dataTemplate = new RET_Document_Data__c();
            showUpload = true;
        }
    }  
    private String getValidId(String idToCheck) {
        if(!String.isBlank(idToCheck)) {
            if((idToCheck.length() == 15 || idToCheck.length() == 18)
                && Pattern.matches('^[a-zA-Z0-9]*$', idToCheck)) {
                return idToCheck;
            }
        }
        return '';
    }

}