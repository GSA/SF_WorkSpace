/*********************************************************************************************************************
*   Acumen Solutions
*   
*   This controller contains the various methods used for Contact and Portal User regitration
*   
*
*   Modification Log
**********************************************************************************************************************
*   Defect / Change No. |   Date        | Author                 |Description
**********************************************************************************************************************
*   N/A                 |   02/01/2012  | Santosh Guni           | Initial construction.
*---------------------------------------------------------------------------------------------------------------------
*
*********************************************************************************************************************/
public with sharing class SiteRegisterController {  
     
    public Contact c                            {get;set;}  
    public User u                               {get;set;}  
    public User newUser                         {get;set;}  
    public String selectedProfileId             {get;set;}  
    public Boolean isDisabled                   {get;set;}  
    public Boolean isNewUserFound               {get;set;}  
    public Boolean showRegistrationForm         {get;set;} 
    public Boolean conf1                        {get;set;}
    public Boolean conf2                        {get;set;} 
    public PBS_AAAP_RLP_Regions_Map__c regions  {get;set;}
    public boolean chkTerms                     {get;set;}
    public String confirmTempEmail              {get;set;} 
    public String publicKey                     {get;set;}
    public String password                      {get;set;}
    public String confirmPassword               {get;set;}

    @TestVisible private reCAPTCHA captcha;   
       
    public SiteRegisterController() {             
        showRegistrationForm = true; 
        c = new Contact();
        c.MailingCountry = 'USA';
        string values = 'NCR;Alaska;Arizona;Arkansas;Alabama;California;Colorado;Connecticut;Delaware;District Of Columbia;Florida;Georgia;Hawaii;Idaho;Illinois;Indiana;Iowa;Kansas;Kentucky;Louisiana;Maine;Maryland;Massachusetts;Michigan;Minnesota;Mississippi;Missouri;Montana;Nebraska;Nevada;New Hampshire;New Jersey;New Mexico;New York;North Carolina;North Dakota;Ohio;Oklahoma;Oregon;Pennsylvania;Rhode Island;South Carolina;South Dakota;Tennessee;Texas;Utah;Vermont;Virginia;Washington;West Virginia;Wisconsin;Wyoming;Puerto Rico;Guam;Northern Mariana Islands;United States Virgin Islands;American Samoa';
        c.PBS_AAAP_StatesOfInterest__c = values;
        u = new User();  
        newUser= new User();  
        isDisabled=false;     
        System.debug('inside constructor'); 
        isNewUserFound=false;  
          

        captcha = new reCAPTCHA();
        publicKey = captcha.publicKey;    
     }            
     
     public PageReference actionChkTermsAndConds(){         
        chkTerms = c.PBS_AAAP_Terms_and_Conditions__c;
        
        //added by syam ganna on 07/25/2016 to validate email fields
        actionChkConfirmEmail();
        return null;
     }
     public PageReference actionChkConfirmEmail(){      
        String email = c.Email;
         String confirmEmail = this.confirmTempEmail;

        if(email != confirmEmail){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Confirmation Email must match your Email Address');
            ApexPages.addMessage(myMsg);            
            chkTerms = false;
        }       
        return null;
     }
     
     
     public Static String selectRegions(String selectedStates){
        String s = selectedStates;
        system.debug('************Selected states:::: '+s);
        String resultString='';
        Set<String> regionsSet;
        List<String> soi = new List<String>();
        Set<string> states = new Set<string>();
        List<string> statesNCR = new List<string>();
        List<PBS_AAAP_RLP_Regions_Map__c> regionsList;
        if(s != null){          
            soi = s.Split(';');
        }
        system.debug('************SOI:::: '+soi);
        
        for(String str:soi){
            //str = +str;
            states.add(str);
        }
        system.debug('************stat:::: '+states);
        regionsSet = new Set<String>();
        String soqlQuery = 'Select PBS_AAAP_Region_Name__c from PBS_AAAP_RLP_Regions_Map__c where PBS_AAAP_RLP_State__c in '+states;
        system.debug('::::::::::soqlQuery:::::: '+soqlQuery);
         
        
        
        regionsList = [Select PBS_AAAP_Region_Name__c from PBS_AAAP_RLP_Regions_Map__c where PBS_AAAP_RLP_State__c in :states];    
        System.debug ('*****Regions List ::::::::' + regionsList);
        for(PBS_AAAP_RLP_Regions_Map__c reg : regionsList){regionsSet.add(reg.PBS_AAAP_Region_Name__c);}
        System.debug ('*****Regions Set ::::::::' + regionsSet);
         
        for(String setStr : regionsSet){
            if(resultString != '') resultString += ';'+setStr;
            else resultString += setStr;             
        }             
        return resultString;
     }

    //Controller method invoked from the VF page button  
    public PageReference createPortaluser(){             
       
        boolean strVerifyRecaptcha; 
        strVerifyRecaptcha = captcha.verify();
             
        if(!strVerifyRecaptcha) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.AAAP_Captcha_Validation_Failed);
            ApexPages.addMessage(msg);            
        }
 
        if(ApexPages.getMessages().size() > 0) {
            return null;
        }
                                     
        try{  
            System.debug('checking for new user with username:' + u.username);  
             
            User usr = [select id, name, username, profileId, contactId from User where username= :c.Email LIMIT 1]; 

            if(usr!=null && usr.username == c.Email){  
                newUser = usr;  
                isNewUserFound = true;  
                System.debug('user with this email '+ c.Email +' already exists in the system');  
                System.debug('isNewUserFound: ' + isNewUserFound); 
                Profile[] profiles = [Select name, id From Profile where Name like '%GSA RET Community Plus Login User%' limit 1];
                system.debug('****'+usr.profileId);
                if(usr.profileId == profiles[0].Id){
                    Boolean flag;
                    String accId = null;
                    accId = [Select Id from Account 
                                    Where recordType.Name =: PBS_AAAP_GlobalConstants.CUSTOMER_PORTAL_ACCOUNT 
                                    and Name = :PBS_AAAP_GlobalConstants.CUSTOMER_PORTAL_ACCOUNT_NAME limit 1].Id;
                    Id cId = usr.contactId;  
                    updateContact(cId, c.PBS_AAAP_StatesOfInterest__c, c.Phone, c.PBS_AAAP_Alternate_Phone__c, c.MailingStreet, c.MailingState, c.MailingCity, 
                                                    c.MailingCountry, c.MailingPostalCode, c.PBS_AAAP_Company__c, c.Title, c.PBS_AAAP_Website__c);
        
                    SiteRegisterController.updateUser(usr.Id, c.Email, c.Phone, 
                                                    c.MailingStreet, c.MailingState, c.PBS_AAAP_PIN__c, c.MailingCity, 
                                                    c.MailingCountry, c.MailingPostalCode, c.PBS_AAAP_Company__c, c.PBS_AAAP_StatesOfInterest__c, 
                                                    c.PBS_AAAP_Regions__c, c.PBS_AAAP_Alternate_Phone__c, c.Title);
                    flag = assignPermissionSet(usr.Id);                    
                    if(flag){
                        conf1 = false; conf2 = true; showRegistrationForm = false;
                    } 
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_DUPLICATE_USER);
                    ApexPages.addMessage(myMsg); 
                }
                return null;  
            }               

        }catch(Exception ex){  
            System.debug('...didnt find user yet...');
        }  
            
        Savepoint sp0 = Database.setSavepoint();
        
        if(isNewUserFound != true){
            try{  
                //  Setting up the account Id to AAAP Customer Portal Account.  
                String accountId = null;
                accountId = [Select Id from Account 
                                Where recordType.Name =: PBS_AAAP_GlobalConstants.CUSTOMER_PORTAL_ACCOUNT 
                                and Name = :PBS_AAAP_GlobalConstants.CUSTOMER_PORTAL_ACCOUNT_NAME limit 1].Id;
                System.debug('***********Account Id:::::::::: '+accountId);
                Id contactId = null;
                
                
                //Create the Contact associated to the Portal Account.  
                contactId = createContact(accountId); 
              
                //Since the user is created asynchronously, we want to do some data validation to ensure the proper fields are populated  
    
                Profile profile = [Select p.name, p.id From Profile p where p.Name like '%AAAP Customer Portal%' limit 1];  
                selectedProfileId = profile.Id;
    
                //Create the User
                //NOTE - Must invoke a @future method to be able to create Account, Contacts, and Users in the same Apex Transaction             
                            
                SiteRegisterController.createUser((String)contactId, c.Email, c.FirstName, c.LastName, c.email, c.Phone, 
                                                    c.MailingStreet, c.MailingState, c.PBS_AAAP_PIN__c, c.MailingCity, 
                                                    c.MailingCountry, c.MailingPostalCode, c.PBS_AAAP_Company__c, c.PBS_AAAP_StatesOfInterest__c, 
                                                    c.PBS_AAAP_Regions__c, c.PBS_AAAP_Alternate_Phone__c, selectedProfileId, c.Title);
                             
                showRegistrationForm = false; conf1 = true; conf2 = false; 
    
             }catch(Exception ex){  
    
                 //Display error message to VF page  
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());  
                 ApexPages.addMessage(myMsg);          
                 Database.rollback(sp0);
             } 
        } 
        return null; 
    }
    
    
    
    public static boolean assignPermissionSet(Id usrId){   
        Boolean success = FALSE;     
        PermissionSet[] permSet = [Select name, id FROm PermissionSet where Name like '%AAAP_User%' limit 1];
        List<PermissionSetAssignment> ps = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId =: permSet[0].Id AND AssigneeId =: usrId];
        if(ps.size() == 0){
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permSet[0].Id, AssigneeId = usrId);
            insert psa;
            success = TRUE;
        } else {
            //Julia Kantarovsky changed typo here 9.15.20   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A registered account has already been created using this email address. Click the Login/Reset Password link at the top of the page where you can sign in or use the \'Forgot Your Password?\' feature.');   
            //Typo changes to here
            ApexPages.addMessage(myMsg);
        }
        return success;
    }
       
     //Method to create the Contact  
     public Id createContact(Id acctId){         
        c.accountid=acctId;
        c.PBS_AAAP_Regions__c = selectRegions(c.PBS_AAAP_StatesOfInterest__c);
        insert c;  
        return c.id;  
     } 
    
     //Async method, using @future, to create the User record and associate it to the previously created Contact  
     //This uses @future because you can not have mixed DML operations for standard objects (Account, Contact) and Setup objects(User)  
     @future
     public static void createUser(String conId, String email, String fName, String lName, String userName, String Phone, String street, String state, String pin, String city, String country, String zip, String company, String sofi, String sofreg, String altPhone, String profileId, String ttl) {
    
         Database.DMLOptions dmo = new Database.DMLOptions();  
    
         dmo.EmailHeader.triggerUserEmail = true;
         String aliasStr;  
         if(lName.length()>6){
            aliasStr = fName.substring(0, 1)+lName.substring(0, 5);
         }
         else{
            aliasStr = fName.substring(0, 1)+lName;
         }
         User u = new User(alias = aliasStr, email=email, emailencodingkey='UTF-8', firstname=fName, lastname=lName, PBS_AAAP_PIN__c = pin,
                languagelocalekey='en_US', localesidkey='en_US', profileid = profileId, contactId=conId, timezonesidkey='America/New_York',
                username=username, street=street, city=city, state=state, country=country, postalcode=zip, CompanyName=company,
                phone=phone, PBS_AAAP_Alternate_Phone__c = altPhone, PBS_AAAP_StatesOfInterest__c=sofi, PBS_AAAP_Regions__c=sofreg, Title = ttl);
    
         u.setOptions(dmo);  
         try{
            insert u;
         }catch(Exception ex){
            System.debug(ex.getMessage());
         }  
    
     }
    
     @future 
     public static void updateContact(Id conId, String States, String phone, String altPhone, String street, String state, String city, String country, String zip, String company,String ttl, String website){  
         Map<String, Object> params = new Map<String, Object>();
         params.put('ContactId',conId);
         params.put('AlternatePhone',altPhone);
         params.put('Phone',phone);
         params.put('Regions',SiteRegisterController.selectRegions(States));
         params.put('StatesOfInterest',States);
         params.put('Street',street);
         params.put('State',state);
         params.put('City',city);
         params.put('Country',country);
         params.put('Zip',zip);
         params.put('Company',company);
         params.put('Title',ttl);
         params.put('Website',website);
         Flow.Interview.RET_LOP_Registration_Process_Update_Contact RETLOPRegistrationProcessUpdateContactFlow = new Flow.Interview.RET_LOP_Registration_Process_Update_Contact(params);
         RETLOPRegistrationProcessUpdateContactFlow.start();
     }
  
     @future
     static void updateUser(Id uId, String email, String Phone, String street, String state, String pin, String city, String country, String zip, String company, String sofi, String sofreg, String altPhone, String ttl) {

         Database.DMLOptions dmo = new Database.DMLOptions();  

         dmo.EmailHeader.triggerUserEmail = true;
         
         User u = [SELECT Id, email, PBS_AAAP_PIN__c, street, city, state, country, postalcode, CompanyName, phone, PBS_AAAP_Alternate_Phone__c, 
                          PBS_AAAP_StatesOfInterest__c, PBS_AAAP_Regions__c
                          FROM User 
                          WHERE Id =: uId];
         u.email = email;
         u.PBS_AAAP_PIN__c = pin;
         u.street = street;
         u.city = city; 
         u.state = state;
         u.country = country;
         u.postalcode = zip;
         u.CompanyName = company;    
         u.PBS_AAAP_StatesOfInterest__c = sofi;
         u.PBS_AAAP_Regions__c = selectRegions(sofi);
         u.Phone = phone;
         u.PBS_AAAP_Alternate_Phone__c = altPhone;
         u.Title = ttl;

         u.setOptions(dmo);  
         try{
            update u;
         }catch(Exception ex){
            System.debug(ex.getMessage());

         }  

     }      

     public List<SelectOption> getCustomerPortalProfiles() {  

         //Execute query to get all profiles associated to Customer Portal  
         Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%AAAP Customer Portal%' limit 1];
         List<SelectOption> options = new List<SelectOption>();  
         for(Profile p: profiles)  
               options.add(new SelectOption(p.id,p.name));  
         return options;  

     }     

     public PageReference reset(){  
         c = new Contact();
         if (System.currentPageReference() == null || System.currentPageReference().getURL() == null) {
             return null;
         } else {
             PageReference newpage = new PageReference(System.currentPageReference().getURL());    
             newpage.getParameters().clear();
             newpage.setRedirect(true);
             return newpage;
         }
     }  
  
     public String getReferer(){    
        String result;  
        String urlStr = ApexPages.currentPage().getHeaders().get('referer');    
        if(urlStr.contains('RSAP')){    
            result = 'RSAP';  
        } else {    
            result = 'AAAP';
        }           
        return result;          
     }  
 }