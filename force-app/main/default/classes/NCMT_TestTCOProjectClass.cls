@isTest(seeAllData = False)

public with sharing class NCMT_TestTCOProjectClass {
    
    static List <AE_CMa_CMc_Cx__c> lstAE_CMa_CMc_Cx = Test.loadData(AE_CMa_CMc_Cx__c.sObjectType,'NCMT_AE_CMa_CMc_Cx');
    
    static List <Professional_Service_Estimate_Parameter__c> lstProfessional_Service_Estimate_Parameter = Test.loadData(Professional_Service_Estimate_Parameter__c.sObjectType, 'NCMT_Professional_Service_Estimate_Parameter');
    
    static List <System_Level_Parameter__c> lstsystemlevelparameter = Test.loadData(System_Level_Parameter__c.sObjectType, 'NCMT_System_Level_Parameter');
    
    static List <NCMT_Building_Parameter__c> lstbuilding = Test.loadData(NCMT_Building_Parameter__c.sObjectType, 'NCMT_Building_Parameter');
    
    static List <NCMT_Building_Height_Parameter__c> lstbldgheight = Test.loadData(NCMT_Building_Height_Parameter__c.sObjectType, 'NCMT_Building_Height_Parameter');
    
    static List <NCMT_Quality_Code_Parameter__c> lstqualitycodeparameter = Test.loadData(NCMT_Quality_Code_Parameter__c.sobjectType, 'NCMT_Quality_Code_Parameter');
    
    static List <NCMT_Quality_Code_Lookup__c> lstqualitycodelookup = Test.loadData(NCMT_Quality_Code_Lookup__c.sObjectType, 'NCMT_Quality_Code_Lookup');
    
    static List <NCMT_Cost_Category__c> lstNCMT_Cost_Category = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_Cost_Category');
    
    static List <NCMT_Security_Parameters__c> lstNCMT_Security_Parameters = Test.loadData(NCMT_Security_Parameters__c.sObjectType, 'NCMT_Security_Parameters');
    
    static List <NCMT_Core_Shell_Cost_Parameter__c> lstNCMT_Core_Shell_Cost_Parameter = Test.loadData(NCMT_Core_Shell_Cost_Parameter__c.sObjectType, 'NCMT_Core_Shell_Cost_Parameter');    
    
    static List <TI_TRCS_Cost_Parameter__c> lstTI_TRCS_Cost_Parameter = Test.loadData(TI_TRCS_Cost_Parameter__c.sObjectType, 'NCMT_TI_TRCS_Cost_Parameter');
    
    //static List <NCMT_P100_Parameter__c> lstNCMT_P100_Parameter = Test.loadData(NCMT_P100_Parameter__c.sObjectType, 'NCMT_P100_Parameter');  
    
    //static List <NCMT_LEED_Parameter__c> lstNCMT_LEED_Parameter = Test.loadData(NCMT_LEED_Parameter__c.sObjectType, 'NCMT_LEED_Parameter');  
    
    static List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');
      
    static List <NCMT_TCO_Parameter__c> listTCOParameter = Test.loadData(NCMT_TCO_Parameter__c.sObjectType, 'NCMT_TCO_Parameter');

    static List <NCMT_TCO_HP_Parameters__c> listTCOHPParameters = Test.loadData(NCMT_TCO_HP_Parameters__c.sObjectType, 'NCMT_TCO_HP_Parameter');

    static List <NCMT_TCO_Cost_Parameter__c> listTCOCostParameter = Test.loadData(NCMT_TCO_Cost_Parameter__c.sObjectType, 'NCMT_TCO_Cost_Rates_Parameters');
    
    
    public static void CreateTCOProject(string strProjectName,string strState, string strCity, string strBuilding_Heigtht,
                                         boolean blnGross_Area, boolean blnUseable_Area, boolean blnHousing_Plan,
                                         Decimal dblTotal_Area_Including_Parking, boolean blnprojupd, boolean blnbldghghtupd,
                                         boolean blnCostRateupd, boolean blnPerfIpupd, boolean blnAddtlCost){ 
       Date CostParaDate = date.newinstance(2016, 10, 1);
        NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
        NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
        NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        insert NCMT_Cust_settings; 
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                                                            and State__c = 'Virginia' and Name = 'State Average'];        
              
        NCMT_Project__c Proj = new NCMT_Project__c ();
        
        string strRecordTypeID = Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('New Construction - TCO').getRecordTypeId();
        
        Proj.Project_type__c = 'New Construction';
        Proj.Building_Type__c = 'Office';
        Proj.Estimate_Type_Proj__c  = 'Parametric';
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        Proj.Building_Selection__c = 'New';
        Proj.Name = strProjectName;
        Proj.State__c = strState;
        Proj.City__c = strCity; 
        Proj.Purpose_of_Estimate__c = 'Scenario Planning';
        
        Proj.Location__c = objlocation.Id;
        
        Date ConstDate = date.newinstance(2021, 1, 1);
        //Date EndConstDate = date.newinstance(2020, 10, 1);
        Proj.Start_Construction__c = ConstDate;
        Proj.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj.Building_Heigtht__c = strBuilding_Heigtht;
        Proj.Building_Quality__c = 'P100: Baseline';        
        Proj.Level_of_Protection__c = 'Level II - Low';
        Proj.Remoteness__c = 'Urban';
        Proj.Gross_Area__c = blnGross_Area;
        Proj.Useable_Area__c = blnUseable_Area;
        Proj.Housing_Plan__c = blnHousing_Plan;
        Proj.Project_Status__c = 'Draft';
        Proj.Total_Area_Including_Parking__c = dblTotal_Area_Including_Parking;
        Proj.Cost_Parameter_Date__c = CostParaDate;
        
        insert Proj;
        system.assertNotEquals(NULL,Proj);                                
        
        Test.startTest();
        if(blnprojupd == true){
                NCMT_Project__c Projupd = new NCMT_Project__c();
                
                //update project
               
                NCMT_ProjectTriggerValue.firstRun = true;
                Projupd.id = Proj.id;
                Projupd.RecordTypeID = strRecordTypeID; 
                update Projupd;
                system.assertNotEquals(NULL,Projupd);
                
                               
        }
                                             
        /*if (blnbldghghtupd == true) {
            NCMT_Project__c Projupd1 = new NCMT_Project__c();
            
            //update project
            NCMT_ProjectTriggerValue.firstRun = true;
            Projupd1.id = Proj.id;
            Projupd1.Building_Heigtht__c = 'Midrise (4 - 9 stories)'; 
            update Projupd1;
            system.assertNotEquals(NULL,Projupd1);
            
        }  */
        //Test.stopTest();                                    
                                                                               
        if(blnCostRateupd == true){
            
            NCMT_Project_Cost_Rate__c ProjCostRateRec = new NCMT_Project_Cost_Rate__c (id = null);
            ProjCostRateRec =  [SELECT Id FROM NCMT_Project_Cost_Rate__c WHERE Project_Name__c = :Proj.id];
            
            ProjCostRateRec.Janitorial_Rate__c = 100;
            
            update ProjCostRateRec;
            system.assertNotEquals(NULL,ProjCostRateRec);
                                                 
        }
                                             
        if(blnPerfIpupd == true){
            
            NCMT_TCO_Performance_Input__c ProjPerfIpRec = new NCMT_TCO_Performance_Input__c (id = null);
            ProjPerfIpRec =  [SELECT Id FROM NCMT_TCO_Performance_Input__c WHERE NCMT_Project__c = :Proj.id];
            
            ProjPerfIpRec.Janitorial_Cleanliness__c = '1';
            
            update ProjPerfIpRec;
            system.assertNotEquals(NULL,ProjPerfIpRec);
                                                 
        }
       
        if(blnAddtlCost == true){
            NCMT_TCO_Additional_Cost__c addtlcost = new NCMT_TCO_Additional_Cost__c (id=null);
            
            addtlcost.Project_Name__c = Proj.id ;
            addtlcost.Janitorial_Cleaning__c = 300; 
            addtlcost.Comments_AnnualCost_Changes__c = 'test';
            insert addtlcost;
            system.assertNotEquals(NULL,addtlcost); 

                                                 
        }
        
    }
    
    /*public static void UpdateTCOProject(){
         NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        
         NCMT_Project__c Projupd1 = new NCMT_Project__c();
        
        Test.startTest();
            //update project
            NCMT_ProjectTriggerValue.firstRun = true;
            Projupd1.id = Proj.id;
            Projupd1.Building_Heigtht__c = 'Midrise (4 - 9 stories)'; 
            update Projupd1;
            system.assertNotEquals(NULL,Projupd1);
        Test.stopTest(); 
        
    }*/

}