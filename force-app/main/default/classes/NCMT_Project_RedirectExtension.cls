public class NCMT_Project_RedirectExtension  {
    RecordType currentRecordType;
    String ent;
    String retURL;
    String currentRecordTypeId;
    public NCMT_Project__c temp{get;set;} 
    public string ncmtprojKeyPrefix{get;set;} 
    //string campusName {get; set;}        
    
    // constructor used to initialize all the variables
    public NCMT_Project_RedirectExtension (ApexPages.StandardController stdController)
    {    
        //pull campus id from url, if campus id, set campus name value for lookup field in new project
        /*string idVar = system.currentPageReference().getParameters().get('retURL').remove('/');
           
        List<NCMT_Campus__c> campusObj = [select name from NCMT_Campus__c where id = :idVar limit 1];
        if(campusObj.size()>0){
            campusName = campusObj[0].Name;
        }*/
        ncmtprojKeyPrefix = '';
        temp = new NCMT_Project__c();

        Schema.DescribeSObjectResult NcmtProjDescResult=NCMT_Project__c.sObjectType.getDescribe();
        ncmtprojKeyPrefix=NcmtProjDescResult.getKeyPrefix();
        

    }
    
 public PageReference redirect()
    {
        PageReference returnPage = NULL;
        
        NCMT_RedirectCustomObjectpage__c ncmt_customsettings = NCMT_RedirectCustomObjectpage__c.getOrgDefaults();

        String strcustomObjectId = ncmt_customsettings.NCMT_Project_ID__c;
        String strcustomfieldId = ncmt_customsettings.Building_Type_ID__c;
        String strcustomfieldId1 = ncmt_customsettings.Project_Type_ID__c;
        String strcustomfieldId2 = ncmt_customsettings.Purpose_Of_Estimate_ID__c;
        String strcustomfieldId3 = ncmt_customsettings.Building_Selection__c;
        String strcustomfieldId4 = ncmt_customsettings.Estimate_Type_ID__c;
        //String strcustomfieldId5 = ncmt_customsettings.Estimate_Format_ID__c;
        //String strcustomfieldId6 = ncmt_customsettings.Campus__c;
        String strcustomfieldId7 = ncmt_customsettings.Project_Phases_ID__c;
        String strcustomfieldId8 = ncmt_customsettings.Project_SubPhase_ID__c;
       
        if(temp.Project_type__c == 'New Construction' && temp.Building_type__c != 'Parking Garage' && temp.Building_type__c != 'LPOE' && temp.Building_type__c != 'Utility' 
            && temp.Building_type__c != 'Data Center' && temp.Building_type__c != 'Courthouse' && temp.Building_type__c != 'Medical Office' && temp.Building_type__c != 'Medical Clinic' && temp.Building_type__c != 'Childcare Center')  
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('New Construction').getRecordTypeId();

        else if(temp.Project_type__c == 'Repair & Alteration - Parametric Entry')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Repair & Alteration - Parametric Entry').getRecordTypeId();
        else if(temp.Project_type__c == 'Repair & Alteration - Work Item Detail')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Repair & Alteration - Work Item Detail').getRecordTypeId();                
        else if(temp.Project_type__c == 'New Construction' && temp.Building_type__c == 'Parking Garage')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId();  
        else if(temp.Project_type__c == 'New Construction' && temp.Building_type__c == 'LPOE')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('LPOE').getRecordTypeId(); 
        else if(temp.Project_type__c == 'New Construction' && temp.Building_type__c == 'Utility')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Utility').getRecordTypeId(); 
        else if(temp.Project_type__c == 'New Construction' && temp.Building_type__c == 'Childcare Center')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Childcare Center').getRecordTypeId();                  
        else if(temp.Project_type__c == 'New Construction' && temp.Building_type__c == 'Data Center')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Data Center').getRecordTypeId(); 
        else if(temp.Project_type__c == 'New Construction' && temp.Building_type__c == 'Courthouse')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Courthouse').getRecordTypeId();
        else if(temp.Project_type__c == 'New Construction' && (temp.Building_type__c == 'Medical Office' || temp.Building_type__c == 'Medical Clinic'))
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Medical Office').getRecordTypeId(); 
        else if(temp.Project_type__c == 'Repair & Alteration - DES')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Repair & Alteration - DES').getRecordTypeId();                
        else if(temp.Project_type__c == 'New Construction - DES')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('New Construction - DES').getRecordTypeId();                                                              
        else if(temp.Project_type__c == 'New Construction - CEW')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('New Construction - CEW').getRecordTypeId();                                                              
        else if(temp.Project_type__c == 'Repair & Alteration - CEW')
                        currentRecordTypeId= Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Repair & Alteration - CEW').getRecordTypeId();                                                                                                                                             

     
        // Added for SFWS-2234 Block #1
         System.debug('getUiTheme'+UserInfo.getUiTheme());

        String theme=UserInfo.getUiThemeDisplayed();
        system.debug('urlvalue'+theme);
        
        
        If(theme=='Theme2'||theme=='Theme3'){
       
        
        // End of new code added for SFWS-2234    Block #1
            
    
        String url1;
            url1 = '/'+ncmtprojKeyPrefix+'/e'+'?';
        string retUrl = ncmtprojKeyPrefix+'/o';
        
        returnPage = new PageReference(url1); 
        returnPage.getParameters().put('ent', strcustomObjectId); 
        returnPage.getParameters().put('retURL',retUrl  );
        returnPage.getParameters().put('RecordType', currentRecordTypeId);
        returnPage.getParameters().put('nooverride', '1');
        returnPage.getParameters().put(strcustomfieldId, temp.Building_Type__c);
        returnPage.getParameters().put(strcustomfieldId1, temp.Project_type__c);
        returnPage.getParameters().put(strcustomfieldId3, temp.Building_Selection__c);
        returnPage.getParameters().put(strcustomfieldId2, temp.Purpose_of_Estimate__c);
        returnPage.getParameters().put(strcustomfieldId4, temp.Estimate_Type_Proj__c);
        //returnPage.getParameters().put(strcustomfieldId5, temp.Estimate_Format__c);
        //returnPage.getParameters().put(strcustomfieldId6, campusName);
        returnPage.getParameters().put(strcustomfieldId7, temp.Project_Phases__c);
        returnPage.getParameters().put(strcustomfieldId8, temp.Project_SubPhases__c);
        //system.debug('get parameters'+ returnPage.getParameters());
        
            
              returnpage.setRedirect(true);
        return returnPage;
        } 
           
        
        // Added for SFWS-2234 Block #2
        Else{
  
        return lightningRedirect();
        }
 
        // End of new code added for SFWS-2234    Block #2
     
     
          
    }
    
     // Added for SFWS-2234 Block #3
    
    public PageReference lightningRedirect(){
      
        PageReference returnPage = NULL;
        String url1;
        String modProjectSubphase;
        
        url1 = '/lightning/o/NCMT_Project__c/new?';
  
        if(temp.Project_SubPhases__c!=null){
           modProjectSubphase= temp.Project_SubPhases__c.replace('%','%25');
        } else{
            modProjectSubphase=temp.Project_SubPhases__c;
        }
        
        String presetValues='Estimate_Type_Proj__c='+temp.Estimate_Type_Proj__c+','+'Project_type__c='+temp.Project_type__c+','+'Building_Selection__c='+temp.Building_Selection__c+','
                             +','+'Building_Type__c='+temp.Building_Type__c+','+'Purpose_of_Estimate__c='+temp.Purpose_of_Estimate__c+','+'Project_Phases__c='+temp.Project_Phases__c+
                              ','+'Project_SubPhases__c='+modProjectSubphase; 
                
        returnPage = new PageReference(url1); 
        
        system.debug('Preset Values'+presetValues);      
        system.debug('currentRecordTypeId'+ currentRecordTypeId);
        
        returnPage.getParameters().put('recordTypeId', currentRecordTypeId);   
        returnPage.getParameters().put('defaultFieldValues',presetValues); 
        returnPage.getParameters().put('nooverride','1');
        returnpage.setRedirect(true);
        return returnPage;
    }
     // End of new code added for SFWS-2234    Block #3         
}