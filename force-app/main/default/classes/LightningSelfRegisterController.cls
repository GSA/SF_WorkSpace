global without sharing class LightningSelfRegisterController {
    public LightningSelfRegisterController() {
    }
    
    private static RET_reCAPTCHAHandler recaptchaHandler;
    
    @TestVisible 
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }
    
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
     
    @TestVisible 
    private static void validatePassword(User u, String password, String confirmPassword) {
        if(!Test.isRunningTest()) {Site.validatePassword(u, password, confirmPassword);}
        return;
    }
    
    @AuraEnabled
    public static String selfRegister(String firstname ,String lastname, String email, String password, String confirmPassword, String accountId, String extraFields, String startUrl, Boolean includePassword, String captchaSolve) {
        Savepoint sp = null;
        boolean strVerifyRecaptcha; 
        String regConfirmUrl='';
        String regConfirmExistingUserUrl='';
        regConfirmUrl = label.regConfirmUrl;
        regConfirmExistingUserUrl = label.regConfirmExistingUserUrl;
                             system.debug('****regConfirmUrl'+regConfirmUrl); system.debug('****regConfirmExistingUserUrl:'+regConfirmExistingUserUrl);
            system.debug('startUrl::'+startUrl);
        try {            
            recaptchaHandler = new RET_reCAPTCHAHandler(RET_Helper.RECAPTCHA_CUSTOM_SETTING_NAME, captchaSolve);
            strVerifyRecaptcha = recaptchaHandler.isVerifiedRecaptcha();            
            
            sp = Database.setSavepoint();        
            
            if (lastname == null || String.isEmpty(lastname)) {
                return Label.Site.lastname_is_required;
            }
            
            if (email == null || String.isEmpty(email)) {
                return Label.Site.email_is_required;
            }
            
            User u = new User();
            u.Username = email;
            u.put('Email',email);
            
            u.FirstName = firstname;
            u.LastName = lastname;
            
            String networkId = Network.getNetworkId();

            // If using site to host the community the user should not hit s1 after logging in from mobile.
            if(networkId != null && siteAsContainerEnabled(Network.getLoginUrl(networkId))) {
                u.put('UserPreferencesHideS1BrowserUI',true);
            }
            
            String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
            nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
            u.put('CommunityNickname', nickname);
                     
            if (extraFields != null) {
                List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);        
                for (Object thisFieldObject : extraFieldsList) {
                    Map<String,Object> thisField = (Map<String,Object>) thisFieldObject;
                    Schema.SObjectField sof = Schema.SObjectType.User.fields.getMap().get((String) thisField.get('fieldPath'));
                    u.put(sof, thisField.get('value'));
                }
            }
                        
            if (includePassword) {    
                if (!isValidPassword(password, confirmPassword)) {
                    return Label.site.passwords_dont_match;
                }
             validatePassword(u, password, confirmPassword);
            }
            else {
                password = null;
            }
                 
            if(!strVerifyRecaptcha){return Label.RET_reCaptchaIsRequired;}       
            
            // lastName is a required field on user, but if it isn't specified, we'll default it to the username
            String userId;
            if(!checkAAAPUser(email)){
                 userId = Site.createPortalUser(u, accountId, password);
                system.debug('****userId'+userId); 
            }else{
                system.debug('****regConfirmExistingUserUrl:'+regConfirmExistingUserUrl);
                 system.debug('****userId'+userId);
                  ApexPages.PageReference confirmRef = new PageReference(regConfirmExistingUserUrl);
                    if(!Test.isRunningTest()) {
                        aura.redirect(confirmRef);
              }
            }
           
            system.debug('****userId'+userId);
            // create a fake userId for test.
            if (Test.isRunningTest()) {
                userId = 'fakeUserId';           
            }
            if (userId != null) { 
                if (password != null && password.length() > 1) {
                    ApexPages.PageReference lgn = Site.login(email, password, startUrl);
                    if(!Test.isRunningTest()) {aura.redirect(lgn);}
                }
                else {
                    ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
                    if(!Test.isRunningTest()) {aura.redirect(confirmRef);}
                }
            }
            return null;
        }
        catch (Exception ex) {
            Database.rollback(sp);
            return ex.getMessage(); 
        }
    }
    
    @AuraEnabled
    public static List<Map<String,Object>> getExtraFields(String extraFieldsFieldSet) { 
        List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
        Schema.FieldSet fieldSet = Schema.SObjectType.User.fieldSets.getMap().get(extraFieldsFieldSet);
        if (fieldSet != null) {
            for (Schema.FieldSetMember f : fieldSet.getFields()) {
                Map<String, Object> fieldDetail = new Map<String, Object>(); fieldDetail.put('dbRequired', f.getDBRequired());fieldDetail.put('fieldPath', f.getFieldPath());fieldDetail.put('label', f.getLabel()); fieldDetail.put('required', f.getRequired());fieldDetail.put('type', f.getType());fieldDetail.put('value', ''); extraFields.add(fieldDetail);
            }
        }
        return extraFields;
    }
    
    @AuraEnabled
    global static String setExperienceId(String expId) {
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                Site.setExperienceId(expId);   
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }        
    } 
    
    //Check if a AAAP user already exists with same username
    private static boolean checkAAAPUser(String email){
        //query the AAAP customer portal profile Id
        Id profileId = [Select Id from Profile where name='AAAP Customer Portal'].Id;
        //query the user matching the email and AAAP Customer Portal profile
        List<User> u = [Select Id, Name, profileId from user where username=:email And ProfileId=:profileId];
        system.debug('u::'+u);
        //if user found than add permission set.
         if(u.size()>0){
            switchUserToRET(u[0]); addPermissionSet(u[0].Id); return true;
        }
        return false;
    }
    
    @AuraEnabled
    public static void switchUserToRET(User u){
        Id profId = [select Id, Name from profile where Name = :RET_LeaseShareUtility.RET_CCP_Profile].Id;
        u.profileId = profId;
        try{
           update u;  
        }Catch(Exception e){
            if(!test.isRunningTest()){
                throw new AuraHandledException('Error Registring in RET Community: '+e.getMessage());
            }
        }
    }
    
    @AuraEnabled
    public static void addPermissionSet(Id userId){
        Id permId = [Select Id from Permissionset where name = 'AAAP_User' limit 1].Id;
     //   Id permId = [Select Id from Permissionset where name = 'RET_Community_User_CRED' limit 1].Id;
        PermissionSetAssignment psa = new PermissionSetAssignment
            (PermissionSetId =permId, AssigneeId = userId);
        try{
           insert psa;  
        }Catch(Exception e){
            if(!test.isRunningTest()){
                throw new AuraHandledException('Error Registring in RET Community: '+e.getMessage());
            }
        }
    }
    
}