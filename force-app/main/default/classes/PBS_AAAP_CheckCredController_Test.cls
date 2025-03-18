@isTest 
private class PBS_AAAP_CheckCredController_Test {
    static testMethod void validate_PBS_AAAP_CheckCredController() {
    
        Account accUser = new Account();
        accUser.Name = 'User Name';
        insert accUser;
        
        Contact conUser = new Contact();
        conUser.LastName = 'TestConhere';
        conUser.accountId = accUser.Id;
        insert conUser;
    
        User u = new User(
         ProfileId = [Select name, id From Profile where Name like 'AAAP Customer Portal' limit 1].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com007_',
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         ContactId = conUser.Id
        );
        insert u;
        
        PBS_AAAP_CheckCredController obj = new PBS_AAAP_CheckCredController();
        system.runAs(u){            
            obj.checkCred();
        }
        obj.checkCred();
        
       
    }
}