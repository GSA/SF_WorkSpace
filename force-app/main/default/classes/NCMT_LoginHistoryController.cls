public with sharing class NCMT_LoginHistoryController {
    @AuraEnabled(cacheable=true)
    public static reportData retrieveloginhist(integer numdays) {
        
        reportData response = new reportData();
        Integer iRecCount = 0;
        
        response.usrList = Database.query('select Id,Name, Username, Email, NCMT_User_Level__c,NCMT_UserRegionCode__c, LastLogindate ,Profile.Name, IsActive from User where NCMT_UserRegionCode__c != null AND DAY_ONLY( LastLogindate ) = LAST_N_DAYS:' + numdays + 'ORDER BY LastLogindate DESC');
        iRecCount = Database.countQuery('select count() from User where NCMT_UserRegionCode__c != null AND DAY_ONLY( LastLogindate ) = LAST_N_DAYS:' + numdays);     
        
        response.numday = numdays;
        response.usrCount = iRecCount;

        return response;
    }
    // wrapper class with @AuraEnabled and {get;set;} properties 
    public class reportData{
        @AuraEnabled
        public List<User> usrList{get;set;}
        @AuraEnabled
        public Integer usrCount{get;set;}
        @AuraEnabled
        public Integer numday{get;set;}
        public reportData(){
            this.usrList=new List<User>();
            this.usrCount =0;
            this.numday=0;
        }
    }
}