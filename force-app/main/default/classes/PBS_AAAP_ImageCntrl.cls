public with sharing class PBS_AAAP_ImageCntrl {
    
    public string folderId {get;set;}    
    transient public string strImageBlob {get;set;}
    transient public string strImagename {get;set;}    
    public List<string> lstDocIds {get;set;}
    public List<PBS_AAAP_IdentifyWinnerForm> identifyWinnerForm {get;set;}
    
    // constructor default
    public PBS_AAAP_ImageCntrl(){
        folderId = [SELECT ID 
                        FROM Folder 
                        WHERE NAME = 'AAAP Folder'].Id;
    }
    
    // constructor extension
    public PBS_AAAP_ImageCntrl(ApexPages.StandardController stdController) {
        folderId = [SELECT ID 
                        FROM Folder 
                        WHERE NAME = 'AAAP Folder'].Id;
    }      
    
    
    public void fetchDocument(){
        lstDocIds = new List<string>();
        
        string lstcompleteIds = '';
        
        // getting list if Images which is captured in the current user
        Cookie completeIds = ApexPages.currentPage().getCookies().get('savedrecordids');
        system.debug('\n---completeIds--'+completeIds);
        if(!Test.isRunningTest()){
            if(completeIds != null)
                lstcompleteIds = string.valueOf(completeIds.getValue());
        }        
        else{
            lstcompleteIds = [select id from document where folderid = :folderId limit 1].Id;
        }        
        system.debug('\n---lstcompleteIds--'+lstcompleteIds);  
        list<string> lstsaveRecs = lstcompleteIds.split(',');    
        system.debug('\n--lstsaveRecs--'+lstsaveRecs);
        
        /**
        // saving the list of ids which are valid
        List<string> lstCompId = new List<string>();
        for(string strIds : lstcompleteIds.split(',')){
            if(!string.isBlank(strIds) 
                && (strIds.length() >= 15)
              ){                
                  lstCompId.add(strIds+'.png');
            }
        } 
        system.debug('\n--lstCompId--'+lstCompId); 
        **/
        
        for(document doc : [SELECT ID,
                                    NAME 
                                FROM document 
                                WHERE /**folderId = :folderId Name IN: lstCompId**/id IN:lstsaveRecs order by createddate asc]){
            lstDocIds.add(doc.ID);
        }
        system.debug('\n--lstDocIds--'+lstDocIds+'\n--folderId--'+folderId);
        
        
    }
    
    public void deleteImage(){
        if(!lstDocIds.isEmpty()){
            delete [SELECT ID from document where id IN: lstDocIds];
        }
    }
    
    public void captureImage()
    {
        Document d = new Document(); 
        d.Name = strImagename+'.png';

        Integer strLen = strImageBlob.length() / 2;
        String first = strImageBlob.substring(0, strLen);
        String second = strImageBlob.substring(strLen);
        String first1 = first.replaceFirst('data:image/png;base64,','');
        String concat = first1 + second;

        d.Body = EncodingUtil.base64Decode(concat);

        //d.Body = EncodingUtil.base64Decode(strImageBlob.replaceFirst('data:image/png;base64,',''));
        d.ContentType = 'image/png';
        d.FolderId = folderId;
        d.IsPublic = true;
        insert d;
        PBS_AAAP_relateListSnapCntrl.saveRecIdinCookie(d.Id);
        system.debug('\n--d---'+d);
    }
}