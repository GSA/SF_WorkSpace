@istest
private class RET_ConvertCaseAttachmentsBatchTest {

    static testMethod void testMethodOne() {

        //insert new Account(Name = 'Real Estate Tax Bucket');
        Id acctOwnerId = [Select Id From User where isActive = true and UserRoleId != null and profile.name = 'GSA System Administrator' Limit 1].id;
        Account acct = new Account(name ='Real Estate Tax Bucket', ownerid = acctOwnerId) ;
        insert acct; 
        
       //Create Lease Record
        PBS_Lease__c leaseRec = new PBS_Lease__c(Name = 'Test Lease', Lease_Number__c = 'LKS01234', Lease_Effective_Date__c = date.today());
        insert leaseRec;
    
        //Create POC Lease Access Record
        insert new PBS_Lease_Access__c(PBS_Lease__c = leaseRec.Id, Requestor__c = UserInfo.getUserId(), Status__c = 'POC');
    
        //Create a draft case record
        Case tmpCase = new case(origin = 'Web', Status = 'Draft', RET_Initial_Submission_Date__c = Datetime.now(), RET_Last_Submission_Date__c = Datetime.now(), PBS_Lease__c = leaseRec.id);
        insert tmpCase;
        
        //Create attachments for the case
        Attachment att1 = new Attachment(parentid = tmpCase.Id, name = 'Bill desk', body = Blob.valueOf('Unit Test Attachment Body'));
        insert att1;
        att1.name = att1.name + '_' + att1.Id + '.txt';
        update att1;

        //Create RET_Document_Data__c records for the attachments    
        List<RET_Document_Data__c> collDocData = new List<RET_Document_Data__c>();
        collDocData.add(new RET_Document_Data__c(Attachment_ID__c = att1.Id, name = 'test ret', Full_File_Name__c = 'ret test', Parent_Case__c = tmpCase.Id, Tax_Year__c = '2017', Document_Category__c = 'Real Estate Taxes', Document_Type__c = 'Tax bill(s)', Tax_Bill_Frequency__c = 'Annual', Tax_Block_Number__c = '123', Tax_Lot_Number__c = 'ABC', Tax_Period_Start__c = date.today().addyears(-2), Tax_Period_End__c = date.today().addyears(-1)));
        insert collDocData;    
        
        Test.startTest();
               
            RET_ConvertCaseAttachmentsBatch btch = new RET_ConvertCaseAttachmentsBatch();
            Database.executeBatch(btch);

        Test.stopTest();
                
        List<RET_Document_Data__c> docs = [SELECT Id FROM RET_Document_Data__c LIMIT 20];
        System.assertEquals(1, docs.size());
        
    }

/*
    static testMethod void testMethod1() {

        //insert new Account(Name = 'Real Estate Tax Bucket');
        Id acctOwnerId = [Select Id From User where isActive = true and UserRoleId != null and profile.name = 'GSA System Administrator' Limit 1].id;
        Account acct = new Account(name ='Real Estate Tax Bucket', ownerid = acctOwnerId) ;
        insert acct; 
        
       //Create Lease Record
        PBS_Lease__c leaseRec = new PBS_Lease__c(Name = 'Test Lease', Lease_Number__c = 'LKS01234', Lease_Effective_Date__c = date.today());
        insert leaseRec;
    
        //Create POC Lease Access Record
        insert new PBS_Lease_Access__c(PBS_Lease__c = leaseRec.Id, Requestor__c = UserInfo.getUserId(), Status__c = 'POC');
    
        //Create a draft case record
        Case tmpCase = new case(origin = 'Web', Status = 'Draft', RET_Initial_Submission_Date__c = Datetime.now(), RET_Last_Submission_Date__c = Datetime.now(), PBS_Lease__c = leaseRec.id);
        insert tmpCase;
        
        //Create attachments for the case
        Attachment att1 = new Attachment(parentid = tmpCase.Id, name = 'Bill desk', body = Blob.valueOf('Unit Test Attachment Body'));
        insert att1;
        att1.name = att1.name + '_' + att1.Id + '.txt';
        update att1;
        Attachment att2 = new Attachment(parentid = tmpCase.Id, name = 'Bill desk', body = Blob.valueOf('Unit Test Attachment Body2'));
        insert att2;
        att2.name = att2.name + '_' + att2.Id + '.txt';
        update att2;
        Attachment att3 = new Attachment(parentid = tmpCase.Id, name = 'Bill desk', body = Blob.valueOf('Unit Test Attachment Body3'));
        insert att3;
        att3.name = att3.name + '_' + att3.Id + '.txt';
        update att3;

        //Create RET_Document_Data__c records for the attachments    
        List<RET_Document_Data__c> collDocData = new List<RET_Document_Data__c>();
        collDocData.add(new RET_Document_Data__c(Attachment_ID__c = att1.Id, name = 'test ret', Full_File_Name__c = 'ret test', Tax_Year__c = '2017', Document_Category__c = 'Real Estate Taxes', Document_Type__c = 'Real Estate Tax - Bill', Tax_Bill_Frequency__c = 'Annual', Tax_Block_Number__c = '123', Tax_Lot_Number__c = 'ABC', Tax_Period_Start__c = date.today().addyears(-2), Tax_Period_End__c = date.today().addyears(-1)));
        collDocData.add(new RET_Document_Data__c(Attachment_ID__c = att2.Id, name = 'test ret2', Full_File_Name__c = 'ret test2', Tax_Year__c = '2017', Document_Category__c = 'Real Estate Taxes', Document_Type__c = 'Real Estate Tax - Appeal Notice', Tax_Bill_Frequency__c = 'Annual', Tax_Block_Number__c = '123', Tax_Lot_Number__c = 'ABC', Tax_Period_Start__c = date.today().addyears(-3), Tax_Period_End__c = date.today().addyears(-2)));
        collDocData.add(new RET_Document_Data__c(Attachment_ID__c = att3.Id, name = 'test ret3', Full_File_Name__c = 'ret test3', Tax_Year__c = '2017', Document_Category__c = 'Real Estate Taxes', Document_Type__c = 'Proof of Ownership', Tax_Bill_Frequency__c = 'Annual', Tax_Block_Number__c = '123', Tax_Lot_Number__c = 'ABC', Tax_Period_Start__c = date.today().addyears(-1), Tax_Period_End__c = date.today()));
        insert collDocData;    
        
        Test.startTest();
               
            RET_ConvertCaseAttachmentsBatch btch = new RET_ConvertCaseAttachmentsBatch();
            Database.executeBatch(btch);

        Test.stopTest();
                
        List<RET_Document_Data__c> docs = [SELECT Id FROM RET_Document_Data__c LIMIT 20];
        System.assertEquals(3, docs.size());
        
    }

    static testMethod void testMethod2() {

        Test.startTest();
            
            DateTime n = datetime.now().addMinutes(1);
            String cron = '';
            cron += n.second();
            cron += ' ' + n.minute();
            cron += ' ' + n.hour();
            cron += ' ' + n.day();
            cron += ' ' + n.month();
            cron += ' ' + '?';
            cron += ' ' + n.year();
            String jobId = System.schedule('Test RET_ConvertCaseAttachmentsBatch', cron, new RET_ConvertCaseAttachmentsSched()); 
            
        Test.stopTest();
        
    }
    
    static testMethod void testMethod3() {

        //insert new Account(Name = 'Real Estate Tax Bucket');
        Id acctOwnerId = [Select Id From User where isActive = true and UserRoleId != null and profile.name = 'GSA System Administrator' Limit 1].id;
        Account acct = new Account(name ='Real Estate Tax Bucket', ownerid = acctOwnerId) ;
        insert acct; 
        
       //Create Lease Record
        PBS_Lease__c leaseRec = new PBS_Lease__c(Name = 'Test Lease', Lease_Number__c = 'LKS01234', Lease_Effective_Date__c = date.today());
        insert leaseRec;
    
        //Create POC Lease Access Record
        insert new PBS_Lease_Access__c(PBS_Lease__c = leaseRec.Id, Requestor__c = UserInfo.getUserId(), Status__c = 'POC');
    
        //Create a draft case record
        Case tmpCase = new case(origin = 'Web', Status = 'Draft', RET_Initial_Submission_Date__c = Datetime.now(), RET_Last_Submission_Date__c = Datetime.now(), PBS_Lease__c = leaseRec.id);
        insert tmpCase;
        
        //Create attachments for the case
        Attachment att1 = new Attachment(parentid = tmpCase.Id, name = 'Bill desk', body = Blob.valueOf('Unit Test Attachment Body'));
        insert att1;
        att1.name = att1.name + '_' + att1.Id + '.txt';
        update att1;
        Attachment att2 = new Attachment(parentid = tmpCase.Id, name = 'Bill desk', body = Blob.valueOf('Unit Test Attachment Body2'));
        insert att2;
        att2.name = att2.name + '_' + att2.Id + '.txt';
        update att2;
        Attachment att3 = new Attachment(parentid = tmpCase.Id, name = 'Bill desk', body = Blob.valueOf('Unit Test Attachment Body3'));
        insert att3;
        att3.name = att3.name + '_' + att3.Id + '.txt';
        update att3;

        //Create RET_Document_Data__c records for the attachments    
        List<RET_Document_Data__c> collDocData = new List<RET_Document_Data__c>();
        collDocData.add(new RET_Document_Data__c(Attachment_ID__c = att1.Id, name = 'test ret', Full_File_Name__c = 'ret test', Tax_Year__c = '2017', Document_Category__c = 'Real Estate Taxes', Document_Type__c = 'Real Estate Tax - Bill', Tax_Bill_Frequency__c = 'Annual', Tax_Block_Number__c = '123', Tax_Lot_Number__c = 'ABC', Tax_Period_Start__c = date.today().addyears(-2), Tax_Period_End__c = date.today().addyears(-1)));
        collDocData.add(new RET_Document_Data__c(Attachment_ID__c = att2.Id, name = 'test ret2', Full_File_Name__c = 'ret test2', Tax_Year__c = '2017', Document_Category__c = 'Real Estate Taxes', Document_Type__c = 'Real Estate Tax - Appeal Notice', Tax_Bill_Frequency__c = 'Annual', Tax_Block_Number__c = '123', Tax_Lot_Number__c = 'ABC', Tax_Period_Start__c = date.today().addyears(-3), Tax_Period_End__c = date.today().addyears(-2)));
        //collDocData.add(new RET_Document_Data__c(Attachment_ID__c = att3.Id, name = 'test ret3', Full_File_Name__c = 'ret test3', Tax_Year__c = '2017', Document_Category__c = 'Real Estate Taxes', Document_Type__c = 'Proof of Ownership', Tax_Bill_Frequency__c = 'Annual', Tax_Block_Number__c = '123', Tax_Lot_Number__c = 'ABC', Tax_Period_Start__c = date.today().addyears(-1), Tax_Period_End__c = date.today()));
        insert collDocData;    
        
        Test.startTest();
               
            RET_ConvertCaseAttachmentsBatch btch = new RET_ConvertCaseAttachmentsBatch();
            Database.executeBatch(btch);

        Test.stopTest();
                
        List<RET_Document_Data__c> docs = [SELECT Id FROM RET_Document_Data__c LIMIT 20];
        System.assertEquals(2, docs.size());
        
    }
    */   
}