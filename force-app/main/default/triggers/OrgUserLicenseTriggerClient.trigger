trigger OrgUserLicenseTriggerClient on OrgUsersLicense__c (after insert) {

    Id networkId = ConnectionHelper.getConnectionId(LABEL.SF2SFConnectionName); 
    
    List<PartnerNetworkRecordConnection> newUserLicenseConnectionRecords = new List<PartnerNetworkRecordConnection>(); 
    
    for (OrgUsersLicense__c newUserLicense : TRIGGER.new) {
         PartnerNetworkRecordConnection newConnection = new PartnerNetworkRecordConnection ( 
            ConnectionId = networkId, 
            LocalRecordId = newUserLicense.Id, 
            SendClosedTasks = false, 
            SendOpenTasks = false, 
            SendEmails = false
         ); 
        newUserLicenseConnectionRecords.add(newConnection); 
    }
    
    if (newUserLicenseConnectionRecords.size() > 0 ) { 
        if(!Test.isRunningTest()){
            database.insert(newUserLicenseConnectionRecords); 
        }
    } 

}