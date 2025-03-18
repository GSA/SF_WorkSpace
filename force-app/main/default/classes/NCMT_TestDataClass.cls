@isTest(seeAllData = False)
public class NCMT_TestDataClass {
    
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
    
    static List <NCMT_P100_Parameter__c> lstNCMT_P100_Parameter = Test.loadData(NCMT_P100_Parameter__c.sObjectType, 'NCMT_P100_Parameter');  
    
    static List <NCMT_LEED_Parameter__c> lstNCMT_LEED_Parameter = Test.loadData(NCMT_LEED_Parameter__c.sObjectType, 'NCMT_LEED_Parameter');  
    
    static List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');
    
    static List <NCMT_RA_Mods__c> lstNCMT_RA_Mods = Test.loadData(NCMT_RA_Mods__c.sObjectType, 'NCMT_RA_Mods');
    
    static List <NCMT_RA_Overhead_Analysis__c> lstNCMT_RA_Overhead_Analysis = Test.loadData(NCMT_RA_Overhead_Analysis__c.sObjectType, 'NCMT_RA_Overhead_Analysis');
    
    static List <NCMT_RA_Quality_Code_Lookup__c> lstNCMT_RA_Quality_Code_Lookup = Test.loadData(NCMT_RA_Quality_Code_Lookup__c.sObjectType, 'NCMT_RA_Quality_Code_Lookup');
    
    static List <NCMT_RA_WI_Lookup_Details__c> lstNCMT_RA_WI_Lookup_Details = Test.loadData(NCMT_RA_WI_Lookup_Details__c.sObjectType, 'NCMT_RA_WI_Lookup_Details');
    
    static List <NCMT_LPOE_Parametric_Cost_Data__c> lstNCMT_LPOE_Parametric_Cost_Data = Test.loadData(NCMT_LPOE_Parametric_Cost_Data__c.sObjectType, 'NCMT_LPOEParametric_Cost_Data');
    
    static List <NCMT_LPOE_Parametric_Default_SpaceLookup__c> lstNCMT_LPOE_Parametric_Default_SpaceLookup = Test.loadData(NCMT_LPOE_Parametric_Default_SpaceLookup__c.sObjectType, 'NCMT_LPOE_Parametric_Default_SpaceLookup');
    
    static List <NCMT_Contractor__c> lstNCMT_Contractor = Test.loadData(NCMT_Contractor__c.sObjectType, 'NCMT_Subcontractor');
    
    static List <NCMT_Cost_Category__c> listCostCategories = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_Cost_Category_GSA_Assemblies');
    
    static List <NCMT_Crew_Master__c> listCrewMaster = Test.loadData(NCMT_Crew_Master__c.sObjectType, 'NCMT_Crew_Master');
    static List <NCMT_Labor_Resource__c> listLaborResources = Test.loadData(NCMT_Labor_Resource__c.sObjectType, 'NCMT_Labor_Resources');

    static List <NCMT_Labor_Location_Markup__c> listLaborLocMarkup = Test.loadData(NCMT_Labor_Location_Markup__c.sObjectType, 'NCMT_Labor_Location_Markup');

    static List <NCMT_Assembly_Lookup_Detail__c> lstNCMT_Assembly_Lookup_Detail = Test.loadData(NCMT_Assembly_Lookup_Detail__c.sObjectType, 'NCMT_Assembly_Lookup_Master');
    static List <NCMT_Assembly_Lookup_detail__c> lstGSAAssemblies = Test.loadData(NCMT_Assembly_Lookup_detail__c.sobjectType, 'NCMT_Assembly_Master_GSA_Assemblies');

    static List <NCMT_DES_Lookup_details__c> lstNCMT_DES_Lookup_Detail = Test.loadData(NCMT_DES_Lookup_details__c.sObjectType, 'NCMT_DES_Lookup_Detail');

    static List <NCMT_Assembly_Lookup_Item__c> lstNCMT_Assembly_Lookup_Item = Test.loadData(NCMT_Assembly_Lookup_Item__c.sObjectType, 'NCMT_Assembly_Lookup_Items');
    
    static List <NCMT_CEW_Parameter__c> lstNCMT_CEW_Parameter = Test.loadData(NCMT_CEW_Parameter__c.sObjectType, 'NCMT_CEW_Parameter');
    //Added this method to pass OfficeProject12 & OfficeProject15
    public static void CreateProjectNew(string strProjectType, string strProjectName, string strBuildingType, string strState, string strCity, string strBuilding_Cost_Type, string strBuilding_Heigtht, string strBuilding_Quality, 
                                     string strLevel_of_Protection, string strRemoteness, 
                                     boolean blnGross_Area, boolean blnUseable_Area, boolean blnHousing_Plan, boolean blnEnteredUSF,
                                     Decimal dblTotal_Area_Including_Parking, Decimal dblPercentage_of_Tenant_Area_Unfinished, Decimal dblParking_Within_Building_Structure, Decimal dblAbove_Ground,
                                     boolean blnOtherCost, boolean blnProjectP100, boolean blnPLPupdate, boolean blnEscalation, boolean blnNCMTreports, boolean blnBLDGMass,
                                     boolean blnOverrideAtrium) {
                                      
         Date CostParaDate = date.newinstance(2016, 10, 1);
       /* Integer FY=  system.now().Month() >= 10?  system.now().Year(): system.now().Year()-1;                           
        Date CostParaDate = date.newinstance(FY, 10, 1);*/
        NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
        NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
        NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        insert NCMT_Cust_settings;
        
        string strRecordTypeName;
        strRecordTypeName = strBuildingType;
        string strBLDGHeightRecordTypeID = Schema.SObjectType.NCMT_Building_Height_Parameter__c.getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId();
        if (strBuildingType == 'Laboratory: Dry' || strBuildingType == 'Laboratory: Wet') {
            strRecordTypeName = 'Laboratory';
        }    
        string strBLDGRecordTypeID = Schema.SObjectType.NCMT_Building_Parameter__c.getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId(); 
        
        
        for(NCMT_Building_Parameter__c BLDG: lstbuilding)
        {
            BLDG.Recordtypeid = strBLDGRecordTypeID;
        }         
        
        for(NCMT_Building_Height_Parameter__c BLDGHeight: lstbldgheight )
        { 
            BLDGHeight.Recordtypeid = strBLDGHeightRecordTypeID ; 
        }          
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                and State__c = :strState and Name = :strCity];
        

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NCMT_Project__c; 
        Schema.DescribeSObjectResult cfrSchemaDS = Schema.SObjectType.NCMT_DES_Items__c; 
        Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> DESItemInfo = cfrSchemaDS.getRecordTypeInfosByName();
        
        if(strProjectType == 'New Construction' && strBuildingType != 'Parking Garage' && strBuildingType != 'LPOE' && strBuildingType != 'Utility' 
        && strBuildingType != 'Data Center' && strBuildingType != 'Medical Office' && strBuildingType != 'Medical Clinic')  
            strRecordTypeName = 'New Construction';
        else if(strProjectType == 'Repair & Alteration - Parametric Entry')
            strRecordTypeName ='Repair & Alteration - Parametric Entry';
        else if(strProjectType == 'Repair & Alteration - Work Item Detail')
            strRecordTypeName ='Repair & Alteration - Work Item Detail';
        else if(strProjectType == 'New Construction' && strBuildingType == 'Parking Garage')
            strRecordTypeName ='Parking Garage';  
        else if(strProjectType == 'New Construction' && strBuildingType == 'LPOE')
            strRecordTypeName ='LPOE';
        else if(strProjectType == 'New Construction' && strBuildingType == 'Utility')
            strRecordTypeName ='Utility';
        else if(strProjectType == 'New Construction' && strBuildingType == 'Data Center')
            strRecordTypeName ='Data Center'; 
        else if(strProjectType == 'New Construction' && (strBuildingType == 'Medical Office' || strBuildingType == 'Medical Clinic'))
            strRecordTypeName ='Medical Office';
        else if(strProjectType == 'New Construction - DES')
            strRecordTypeName = 'New Construction - DES';
        
        NCMT_Project__c Proj = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());
        NCMT_Project__c Projupd = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());
        NCMT_Project__c Projupd2 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());       
        
        IF(strProjectType == 'New Construction - DES'){
            Proj.Estimate_Type_Proj__c  = 'Definitive Estimating';
        }else if(strProjectType == 'Repair & Alteration - Work Item Detail'){
            Proj.Estimate_Type_Proj__c  ='Work Item - Repair & Alteration';
        }else if(strProjectType == 'Repair & Alteration - Parametric Entry'){
            Proj.Estimate_Type_Proj__c  ='Parametric - Repair & Alteration';
        }else{
            Proj.Estimate_Type_Proj__c  ='Parametric';
        }
        
        Proj.Project_type__c = strProjectType;
        Proj.Building_Type__c = strBuildingType;
        Proj.Name = strProjectName;
        Proj.State__c = strState;
        Proj.City__c = strCity;        
        
        Proj.Location__c = objlocation.Id;
        
        Date ConstDate = date.newinstance(2025, 1, 1);
        Date MidPtConst = date.newInstance(2020, 12, 1);
        Date EndConstDate = date.newinstance(2016, 10, 1);
        if (blnEnteredUSF == false) {
            Proj.Start_Construction__c = ConstDate;
        }
        else {
            Proj.End_Construction__c = EndConstDate;
        }
        
        Proj.Building_Cost_Type__c = strBuilding_Cost_Type;
        Proj.Building_Heigtht__c = strBuilding_Heigtht;
                                         
        Proj.Level_of_Protection__c = strLevel_of_Protection;
        Proj.Building_Quality__c = strBuilding_Quality;
        Proj.Remoteness__c = strRemoteness;
        Proj.Gross_Area__c = blnGross_Area;
        Proj.Useable_Area__c = blnUseable_Area;
        Proj.Housing_Plan__c = blnHousing_Plan;
        if (blnGross_Area == true || blnUseable_Area == true) {
            Proj.Total_Area_Including_Parking__c = dblTotal_Area_Including_Parking;
        }
        Proj.Percentage_of_Tenant_Area_Unfinished__c = dblPercentage_of_Tenant_Area_Unfinished;
        Proj.Parking_Within_Building_Structure__c = dblParking_Within_Building_Structure;
        Proj.Stand_alone_Parking_Garage__c = 0;
        Proj.Surface_Parking__c = 0;
        Proj.Project_Status__c = 'Draft';
        Proj.Cost_Parameter_Date__c = CostParaDate;
        IF(Proj.Estimate_Type_Proj__c  == 'Definitive Estimating'){
            Proj.Project_Phases__c ='Design';
            Proj.Project_SubPhases__c = 'Design Development Draft';
        }
        Proj.Project_Delivery_Method__c= 'TI - Leasing';
        Proj.Markup_Method__c = 'GSA Markups';
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        Proj.Mid_Point_of_Construction__c = MidPtConst;
        
        insert Proj;
        system.assertNotEquals(NULL,Proj);  
                                                     
        if (blnOverrideAtrium == true && blnNCMTreports == true) {
           // test.startTest();
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            NCMT_Housing_Plan_Summary__c HousingPlanSummary2 = new NCMT_Housing_Plan_Summary__c (id = null);
            HousingPlanSummary2 =  [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :Proj.id];
            
            HousingPlanSummary2.Main_Lobby__c = 600;
            
            update HousingPlanSummary2;
            
            system.assertNotEquals(NULL,HousingPlanSummary2);  
            
            if (strBuilding_Cost_Type == 'TI Retrofit') {
                //Test.startTest();
                NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
                NCMT_ProjectTriggerValue.firstRun = true;
                NCMT_Project__c ProjTI = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());
                NCMT_ProjectTriggerValue.firstRun = true;
                ProjTI.Id = Proj.id;
                ProjTI.Total_Area_Including_Parking__c = 1000100;
                update ProjTI;
                system.assertNotEquals(NULL,ProjTI); 
                //Test.stopTest();
            }    
        }
        
        if (blnOverrideAtrium == true && blnNCMTreports == false) {
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            Projupd.Project_type__c = strProjectType;
            Projupd.Id = Proj.id;
            Projupd.City__c = 'San Jose';
            update Projupd;
            system.assertNotEquals(NULL,Projupd); 
            
            NCMT_Housing_Plan_Summary__c HousingPlanSummary2 = new NCMT_Housing_Plan_Summary__c (id = null);
            HousingPlanSummary2 =  [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :Proj.id];
            
            HousingPlanSummary2.Atrium_upper_levels_phantom_floors__c = 1;
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update HousingPlanSummary2;
            system.assertNotEquals(NULL,HousingPlanSummary2);  
        }
        
        if (blnEscalation == true) {    
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;

            //insert Escalation
            NCMT_Escalation__c ESC = new NCMT_Escalation__c (id = null);
            NCMT_Escalation__c ESCupd = new NCMT_Escalation__c (id = null);
            
            ESC.Project__c   = Proj.id;
            ESC.Escalation_Type__c = 'Market Escalation';
            ESC.Duration__c = 12;
            ESC.Yearly_Escalation__c = 4;
            ESC.FY__c = '2016';
            ESC.Escalation_Percentage__c = 3;
            
            insert ESC;
            system.assertNotEquals(NULL,ESC);
            //update Escalation
            ESCupd.id = ESC.id;
            ESCupd.Duration__c = 20;

            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update ESCupd;
            system.assertNotEquals(NULL,ESCupd);
            
            Test.startTest(); 
            //insert LEED
            Schema.DescribeSObjectResult cfrSchemaLEED = Schema.SObjectType.NCMT_LEED_Checklist__c; 
            Map<String,Schema.RecordTypeInfo> LEEDTypeInfo = cfrSchemaLEED.getRecordTypeInfosByName();
            
            NCMT_LEED_Checklist__c LEED = new NCMT_LEED_Checklist__c (id = null, recordtypeid = LEEDTypeInfo.get('LEED Checklist').getRecordTypeId());
            LEED.Project__c = Proj.id;
            LEED.Prerequisite_1__c = true;
            LEED.Prerequisite_2__c = true;
            LEED.Prerequisite_3__c = true;
            LEED.Prerequisite_4__c = true;
            LEED.Prerequisite_5__c = true;
            LEED.Prerequisite_6__c = true;
            LEED.Prerequisite_7__c = true;
            LEED.Prerequisite_8__c = true;
            LEED.Prerequisite_9__c = true;
            LEED.Prerequisite_10__c = true;
            LEED.Prerequisite_11__c = true;
            LEED.Prerequisite_12__c = true;

            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            insert LEED;
            system.assertNotEquals(NULL,LEED);
            //update LEED
            NCMT_LEED_Checklist__c LEEDupd = new NCMT_LEED_Checklist__c (id = null, recordtypeid = LEEDTypeInfo.get('LEED Checklist').getRecordTypeId());
            LEEDupd.Id = LEED.id;
            LEEDupd.LEED_USR_Mod_IP_1__c = 1;
            LEEDupd.LEED_USR_Mod_LT_1__c  = 8;
            LEEDupd.LEED_USR_Mod_LT_2__c = 1;
            LEEDupd.LEED_USR_Mod_LT_3__c = 2;
            LEEDupd.LEED_USR_Mod_LT_4__c = 5;
            LEEDupd.LEED_USR_Mod_LT_5__c  = 5;
            LEEDupd.LEED_USR_Mod_LT_6__c = 1;
            LEEDupd.LEED_USR_Mod_LT_7__c = 1;
            LEEDupd.LEED_USR_Mod_LT_8__c = 1;
            LEEDupd.LEED_USR_Mod_SS_1__c  = 1;
            LEEDupd.LEED_USR_Mod_SS_2__c = 2;
            LEEDupd.LEED_USR_Mod_SS_3__c = 1;
            LEEDupd.LEED_USR_Mod_SS_4__c = 2;
            LEEDupd.LEED_USR_Mod_SS_5__c = 2;
            LEEDupd.LEED_USR_Mod_SS_6__c = 1;
            LEEDupd.LEED_USR_Mod_WE_1__c = 2;
            LEEDupd.LEED_USR_Mod_WE_2__c  = 3;
            LEEDupd.LEED_USR_Mod_WE_4__c  = 1;
            LEEDupd.LEED_USR_Mod_EA_1__c  = 3;
            LEEDupd.LEED_USR_Mod_EA_2__c  = 3;
            LEEDupd.LEED_USR_Mod_EA_3__c = 1;
            LEEDupd.LEED_USR_Mod_EA_4__c = 2;
            LEEDupd.LEED_USR_Mod_EA_5__c =  3;
            LEEDupd.LEED_USR_Mod_EA_6__c =  1;
            LEEDupd.LEED_USR_Mod_EA_7__c =  2;
            LEEDupd.LEED_USR_Mod_MR_1__c =  5;
            LEEDupd.LEED_USR_Mod_MR_2__c =  2;
            LEEDupd.LEED_USR_Mod_MR_3__c =  2;
            LEEDupd.LEED_USR_Mod_MR_4__c =  2;
            LEEDupd.LEED_USR_Mod_MR_5__c =  2;
            LEEDupd.LEED_USR_Mod_IEQ_1__c = 2;
            LEEDupd.LEED_USR_Mod_IEQ_2__c = 3;
            LEEDupd.LEED_USR_Mod_IEQ_3__c = 1;
            LEEDupd.LEED_USR_Mod_IEQ_4__c = 2;
            LEEDupd.LEED_USR_Mod_IEQ_5__c = 1;
            LEEDupd.LEED_USR_Mod_IEQ_6__c = 2;
            LEEDupd.LEED_USR_Mod_IEQ_7__c = 3;
            LEEDupd.LEED_USR_Mod_IEQ_8__c = 1;
            LEEDupd.LEED_USR_Mod_IEQ_9__c = 1;
            LEEDupd.LEED_USR_Mod_Innovation_1__c =  5;
            LEEDupd.LEED_USR_Mod_Innovation_2__c =  1;
            LEEDupd.LEED_USR_Mod_RP_1__c =  4;
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update LEEDupd;
            system.assertNotEquals(NULL,LEEDupd);
            
            Delete LEEDupd;
            system.assertNotEquals(NULL,LEEDupd);
            NCMT_Housing_Plan_Option_Selection__c hpOption = new NCMT_Housing_Plan_Option_Selection__c ();
           // hpOption.NCMT_Housing_Plan_Option__c = '';
            hpOption.NCMT_Project__c = Proj.id ;
            hpOption.Recurrence__c = 0.0;
            insert hpOption;
            //update project
            ////Test.startTest();
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            TriggerValue.isupdate = true;
            TriggerValue.isupdate1 = true;
            Projupd.Project_type__c = strProjectType;
            Projupd.Id = Proj.id;
            Projupd.Gross_Area__c = false;
            Projupd.Useable_Area__c = true;  
            Projupd.Total_Area_Including_Parking__c = 2000000;
            Projupd.Building_Cost_Type__c = 'Core/Shell with TI';
            update Projupd;
            system.assertNotEquals(NULL,Projupd);   
            //Test.stopTest();   
        }
        
        if (blnPLPupdate == true) {
            
            Schema.DescribeSObjectResult cfrSchemaPLP = Schema.SObjectType.Project_Level_Parameter__c; 
            Map<String,Schema.RecordTypeInfo> PLPTypeInfo = cfrSchemaPLP.getRecordTypeInfosByName();
            
            Project_Level_Parameter__c PLP = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Other Building Use').getRecordTypeId());
            Project_Level_Parameter__c PLPupd = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Other Building Use').getRecordTypeId());
            
            PLP =  [SELECT Id, Foot_Print_Area__c, Massing_Override_Comments__c, Structure_Override_Comments__c, Typical_Bay_Size_A__c, Interior_Override_Comments__c, Int_Const_Core_Shell_Partition_ratio__c, 
                    MEP_Override_Comments__c, Electrical_Load__c, Vertical_Transportation_Override_Comment__c, Vertical_Conveyance_Escalators_Pairs__c,
                    Cladding_Override_Comments__c, Cladding_Skin_Ratio__c
                    FROM Project_Level_Parameter__c WHERE NCMT_Project__c = :Proj.id];
            
            //Test.startTest();
            TriggerValue.isupdate = false;
            TriggerValue.isupdate1 = true;
            //TriggerValue.isInsertPT = false;
            PLP.Use_Level_of_Protection__c = strLevel_of_Protection;
            PLP.Use_Blast_Resistance__c = strLevel_of_Protection;
            //PLP.Foot_Print_Area__c = 10000;
            PLP.Massing_Override_Comments__c = 'test';
            PLP.Typical_Bay_Size_A__c = 40;
            PLP.Structure_Override_Comments__c = 'test';
            PLP.Int_Const_Core_Shell_Partition_ratio__c = 0.05;      
            PLP.Interior_Override_Comments__c = 'test';
            PLP.Electrical_Load__c = 12;      
            PLP.MEP_Override_Comments__c = 'test';
            PLP.Vertical_Conveyance_Escalators_Pairs__c = 0.1;
            PLP.Vertical_Transportation_Override_Comment__c = 'test';
            PLP.Cladding_Skin_Ratio__c = 0.5;
            PLP.Cladding_Override_Comments__c = 'test'; 
            update PLP;      
            
            system.assertNotEquals(NULL,PLP);
            
            PLPupd.Id = PLP.Id;
            TriggerValue.isupdate = true;
            TriggerValue.isupdate1 = true;
            //TriggerValue.isInsertPT = false;
            //PLPupd.Foot_Print_Area__c = 600000;
            PLPupd.Massing_Override_Comments__c = 'test';
            PLPupd.Typical_Bay_Size_A__c = 40;
            
            update PLPupd;
            system.assertNotEquals(NULL,PLPupd);
            //Test.stopTest(); 
        }
        
        if (blnBLDGMass == true) {
            
            Schema.DescribeSObjectResult cfrSchemaPLP = Schema.SObjectType.Project_Level_Parameter__c; 
            Map<String,Schema.RecordTypeInfo> PLPTypeInfo = cfrSchemaPLP.getRecordTypeInfosByName();
            
            Project_Level_Parameter__c PLP = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Other Building Use').getRecordTypeId());
            NCMT_Building_Massing_By_Floor__c BldgMassFloor = new NCMT_Building_Massing_By_Floor__c();
            
            PLP = [select Id from Project_Level_Parameter__c WHERE NCMT_Project__c = :Proj.id];
            
            BldgMassFloor = [select Id, Use_Area_SF__c from NCMT_Building_Massing_By_Floor__c where Proj_Level_Parameter__c = :PLP.Id and Building_Massing_Area__c = 'Ground SF'];
            System.debug('BldgMassFloor.Use_Area_SF__c ================ ' +BldgMassFloor.Use_Area_SF__c);
            //Test.startTest();
            TriggerValue.firstRun = true;
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            TriggerValue.isUpdate1 = false;
            BldgMassFloor.Use_Area_SF__c = 1000;
            update BldgMassFloor;
            system.assertNotEquals(NULL,BldgMassFloor);
            //Test.stopTest(); 
        }
        
        if (blnHousing_Plan == true) {
            
            Schema.DescribeSObjectResult cfrSchemaHP = Schema.SObjectType.NCMT_Housing_Plan__c; 
            Map<String,Schema.RecordTypeInfo> HousingPlanTypeInfo = cfrSchemaHP.getRecordTypeInfosByName();
            
            NCMT_Housing_Plan__c HousingPlan = new NCMT_Housing_Plan__c (id = null, recordtypeid = HousingPlanTypeInfo.get('User Defined').getRecordTypeId());
            //NCMT_Housing_Plan__c HousingPlanupd = new NCMT_Housing_Plan__c (id = null, recordtypeid = HousingPlanTypeInfo.get('User Defined').getRecordTypeId());
            
            HousingPlan.Project__c = Proj.id ;
            HousingPlan.Housing_Plan_Type__c = 'New Fit Out';
            if (blnEnteredUSF == false) {
                if (strBuilding_Cost_Type == 'Core/Shell only') {
                    HousingPlan.Workstations_open_office_Count__c = 30;
                    HousingPlan.X20_or_more_person_rooms_Count__c = 3;
                    HousingPlan.Closed_offices_Count__c  = Null;
                    HousingPlan.Private_toilets_Count__c = Null;
                    HousingPlan.X8_20_person_rooms_Count__c = Null;
                    HousingPlan.Teleconference_Count__c = Null;
                    HousingPlan.Auditorium_sloped_floor_Count__c = Null;
                    HousingPlan.Child_care_Count__c = Null;
                    HousingPlan.Libraries_Count__c = Null;
                    HousingPlan.ADP_high_density_PC_s_Count__c = Null;
                    HousingPlan.Courtroom_district_Ceremonial_Count__c= Null;
                    HousingPlan.Courtroom_district_Standard_Count__c= Null;
                    HousingPlan.Courtroom_Bankruptcy_Count__c= Null;
                    HousingPlan.Courtroom_Magistrate_Count__c= Null;
                    HousingPlan.Grand_Jury_Room_Count__c= Null;
                    HousingPlan.Judicial_hearing_Count__c= Null;
                    HousingPlan.Judicial_chambers_Count__c= Null;
                    HousingPlan.Holding_cell_Central_Count__c= Null;
                    HousingPlan.Holding_cell_Court_floors_Count__c= Null;
                    HousingPlan.Unfinished_Shell_Area_Use_USF__c= Null;
                    HousingPlan.General_storage_Use_USF__c= Null;
                    HousingPlan.High_density_storage_Use_USF__c= Null;
                    HousingPlan.Clinics_health_units_Use_USF__c= Null;
                    HousingPlan.Physical_fitness_Use_USF__c= Null;
                    HousingPlan.ADP_mainframe_Use_USF__c= Null;
                    HousingPlan.Joint_use_retail_Use_USF__c= Null;
                    HousingPlan.Food_service_cafeteria_Use_USF__c= Null;
                    HousingPlan.Climate_controlled_for_artifacts_Use_USF__c= Null;
                    HousingPlan.Non_climate_controlled_Use_USF__c= Null;
                    HousingPlan.Laboratory_Dry_electronic_Use_USF__c= Null;
                    HousingPlan.Laboratory_Wet_chemistry_Use_USF__c= Null;
                    HousingPlan.Firing_range_Use_USF__c= Null;
                    HousingPlan.Copy_Center_Use_USF__c= Null;
                    HousingPlan.Credit_Union_Use_USF__c= Null;
                    HousingPlan.Transaction_counter_space_Use_USF__c= Null;
                    HousingPlan.Kitchen_Break_room_Use_USF__c= Null;
                    HousingPlan.Locker_Shower_room_Use_USF__c= Null;
                    HousingPlan.Hardened_offices_suites_Use_USF__c= Null;
                    HousingPlan.Secure_Work_Environment_SWE_Std_Use_USF__c= Null;
                    HousingPlan.Secure_Work_Environment_SWE_Enhd_UseUSF__c= Null;
                    HousingPlan.Secured_Storage_SCIF_Standard_Use_USF__c= Null;
                    HousingPlan.Secured_Storage_SCIF_Enhanced_Use_USF__c= Null;
                    HousingPlan.Vault_Type_Storage_Use_USF__c= Null;
                    HousingPlan.Interview_Detention_Use_USF__c= Null;
                    HousingPlan.Non_Marshal_Holding_Cell_Single_Use_USF__c= Null;
                    HousingPlan.Non_Marshal_Holding_Cell_Double_Use_USF__c= Null;
                    HousingPlan.Enhanced_office_Use_USF__c= Null;
                    HousingPlan.USMS_Suite_Administration_Use_USF__c= Null;
                    HousingPlan.USMS_Suite_Operations_Use_USF__c= Null;
                    HousingPlan.Sally_Port_Use_USF__c= Null;
                    HousingPlan.Light_industrial_Use_USF__c= Null;
                    HousingPlan.Warehouse_Use_USF__c= Null;
                    HousingPlan.VA_Intake_Use_USF__c= Null;
                    HousingPlan.VA_Exam_Suite_Use_USF__c= Null;
                    HousingPlan.VA_Radiology_Use_USF__c= Null;
                    HousingPlan.VA_Ambulatory_Surgery_Use_USF__c= Null;
                    HousingPlan.VA_Infusion_Use_USF__c= Null;
                    HousingPlan.VA_Pharmacy_Use_USF__c= Null;
                    HousingPlan.Data_Center_Use_USF__c= Null;
                }
                else if (strBuilding_Cost_Type == 'TI Only') {
                    HousingPlan.Workstations_open_office_Count__c = NULL;
                    HousingPlan.X20_or_more_person_rooms_Count__c = NULL;
                    HousingPlan.Private_toilets_Count__c =40;
                    HousingPlan.X8_20_person_rooms_Count__c = 5;
                }
                else if (strBuilding_Cost_Type == 'TI Retrofit') {
                    HousingPlan.Workstations_open_office_Count__c = 900;
                    HousingPlan.X20_or_more_person_rooms_Count__c = 3;
                }
                else if (strBuilding_Cost_Type == 'TI Including Warm Lit Shell') {
                    HousingPlan.Workstations_open_office_Count__c = 1500;
                    HousingPlan.X20_or_more_person_rooms_Count__c = 3;
                }
                else {
                    HousingPlan.Workstations_open_office_Count__c = 110;
                    HousingPlan.X20_or_more_person_rooms_Count__c = 3;
                }
                HousingPlan.User_Defined_Spaces1_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces2_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces3_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces1_Description__c = 't1';
                HousingPlan.User_Defined_Spaces2_Description__c = 't1';
                HousingPlan.User_Defined_Spaces3_Description__c = 't1';
            }
            else {
                HousingPlan.Workstations_open_office_Entered_USF__c = 100000;
                HousingPlan.Closed_offices_Entered_USF__c = 100000;
                HousingPlan.Private_toilets_Entered_USF__c = 100000;
                HousingPlan.X8_20_person_rooms_Entered_USF__c = 100000;
                HousingPlan.X20_or_more_person_rooms_Entered_USF__c = 100000;
                HousingPlan.Teleconference_Entered_USF__c = 100000;
                HousingPlan.Auditorium_sloped_floor_Entered_USF__c = 100000;
                HousingPlan.Child_care_Entered_USF__c = 100000;
                HousingPlan.Libraries_Entered_USF__c = 100000;
                HousingPlan.ADP_high_density_PC_s_Entered_USF__c = 100000;
                HousingPlan.Courtroom_district_CeremonialEntered_USF__c = 100000;
                HousingPlan.Courtroom_district_Standard_Entered_USF__c = 100000;
                HousingPlan.Courtroom_Bankruptcy_Entered_USF__c = 100000;
                HousingPlan.Courtroom_Magistrate_Entered_USF__c = 100000;
                HousingPlan.Grand_Jury_Room_Entered_USF__c = 100000;
                HousingPlan.Judicial_hearing_Entered_USF__c = 100000;
                HousingPlan.Judicial_chambers_Entered_USF__c = 100000;
                HousingPlan.Holding_cell_Central_Entered_USF__c = 100000;
                HousingPlan.Holding_cell_Court_floors_Entered_USF__c = 100000;   
                HousingPlan.User_Defined_Spaces1_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces2_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces3_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces1_Description__c = 't1';
                HousingPlan.User_Defined_Spaces2_Description__c = 't1';
                HousingPlan.User_Defined_Spaces3_Description__c = 't1';         
            }        
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            insert HousingPlan;
            system.assertNotEquals(NULL,HousingPlan); 
            /*
            //Test.startTest();
            
            Date ConstDate2 = date.newinstance(2030, 1, 1);
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            Projupd.Id = Proj.id;
            if (strBuilding_Cost_Type == 'Core/Shell only') {
                Projupd.Start_Construction__c = null;
                Projupd.End_Construction__c = ConstDate2;
                Proj.Building_Cost_Type__c = 'TI Retrofit';
            }
            else {
                Projupd.Set_Aside_100__c = true;
                Projupd.Start_Construction__c = ConstDate2;
                Projupd.End_Construction__c = null;
                Proj.Building_Cost_Type__c = 'Core/Shell only';
            }  
            
            update Projupd;
            system.assertNotEquals(NULL,Projupd);
            
            if (blnEnteredUSF == true) {
                
                if (strBuilding_Cost_Type == 'Core/Shell with TI') {
                    
                    NCMT_Housing_Plan_Summary__c HousingPlanSummary = new NCMT_Housing_Plan_Summary__c (id = null);
                    HousingPlanSummary =  [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :Proj.id];
                    
                    HousingPlanSummary.Override_RSF__c = 1990000;
                    
                    NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
                    NCMT_ProjectTriggerValue.firstRun = true;
                    update HousingPlanSummary;
                    system.assertNotEquals(NULL,HousingPlanSummary);
                }
                
                else if (strBuilding_Cost_Type == 'Core/Shell only') {
                    NCMT_Housing_Plan_Summary__c HousingPlanSummary = new NCMT_Housing_Plan_Summary__c (id = null);
                    HousingPlanSummary =  [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :Proj.id];
                    
                    HousingPlanSummary.Override_RSF__c = 2370001;
                    
                    NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
                    NCMT_ProjectTriggerValue.firstRun = true;
                    update HousingPlanSummary;
                    system.assertNotEquals(NULL,HousingPlanSummary);
                    
                }
            }  
            
            //Test.stopTest();     
            */     
        }
        if (blnOtherCost == true) {
            //Test.startTest();
            Schema.DescribeSObjectResult cfrSchemaOC = Schema.SObjectType.NCMT_Other_Cost__c; 
            Map<String,Schema.RecordTypeInfo> OtherCostsTypeInfo = cfrSchemaOC.getRecordTypeInfosByName();
            
            NCMT_Other_Cost__c OtherCost = new NCMT_Other_Cost__c (id=null, recordtypeid = OtherCostsTypeInfo.get('Other Facilities - Other Direct Cost').getRecordTypeId());
            NCMT_Other_Cost__c OtherCost2 = new NCMT_Other_Cost__c (id=null, recordtypeid = OtherCostsTypeInfo.get('Other Facilities - Other Cost').getRecordTypeId());
            NCMT_Other_Cost__c OtherCost3 = new NCMT_Other_Cost__c (id=null, recordtypeid = OtherCostsTypeInfo.get('Other Facilities - Other Cost').getRecordTypeId());
            List<NCMT_Other_Cost__c> otherCosts = new List<NCMT_Other_Cost__c>();

            OtherCost.NCMT_Project__c = Proj.id ;
            OtherCost.Cost_Description__c = 'Core/Shell Cost';
            OtherCost.Cost_Type__c = 'Direct Costs';
            OtherCost.Cost_Based_on__c = 'Gross Area';
            OtherCost.Unit_Rate__c = 2;
            OtherCost.Basis_of_Estimate__c = 'test';  
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;        
            otherCosts.add(OtherCost);
            
            
            OtherCost2.NCMT_Project__c = Proj.id ;
            OtherCost2.Cost_Description__c = 'Core/Shell Cost';
            OtherCost2.Cost_Type__c = 'Project Costs';
            OtherCost2.Cost_Based_on__c = 'Gross Area';
            OtherCost2.Unit_Rate__c = 2;
            OtherCost2.Basis_of_Estimate__c = 'test2';   
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;       
            otherCosts.add(OtherCost2);
                   
            
            OtherCost3.NCMT_Project__c = Proj.id ;
            OtherCost3.Cost_Description__c = 'N/A';
            OtherCost3.Cost_Type__c = 'Site Acquisition Cost';
            OtherCost3.Cost_Based_on__c = 'Other';
            OtherCost3.Other_Area__c = 20000;
            OtherCost3.Unit_Rate__c = 100;
            OtherCost3.Basis_of_Estimate__c = 'test3';  
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;        
            otherCosts.add(OtherCost3);
             
            insert otherCosts;
            system.assertNotEquals(NULL,OtherCost); 
            system.assertNotEquals(NULL,OtherCost2);
            system.assertNotEquals(NULL,OtherCost3);
            
            OtherCost3.Unit_Rate__c = 200;
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update OtherCost3;
            system.assertNotEquals(NULL,OtherCost3); 
            
            //Test.stopTest();
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            delete OtherCost2;
            system.assertNotEquals(NULL,OtherCost2);
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            delete Proj;
            system.assertNotEquals(NULL,Proj);
        }
        if (blnProjectP100 == true) {
            ////Test.startTest();
            
            NCMT_Project_P100_Data__c P100 = new NCMT_Project_P100_Data__c (id=null);
            
            P100.Project__c = Proj.id;
            P100.SiteUsesExistingInfrastructure_Resources__c = 'P100: Tier 3';
            P100.SiteTransitUseReduced_Automobile_commute__c = 'P100: Tier 3';
            P100.Site_Neighbor_Connect_Walk_Bike__c = 'P100: Tier 3';
            P100.Energy_30_40_50_NZE__c = 'P100: Tier 3';
            P100.Fossil_Fuel_65_80_90_NZC__c = 'P100: Tier 3';
            P100.Seismic_Performance__c = 'P100: Tier 3';
            P100.Flood_Resistance__c = 'P100: Tier 3';
            P100.Wind__c = 'P100: Tier 3';
            P100.Service_Life__c = 'P100: Tier 3';
            P100.Enclosure_Performance__c = 'P100: Tier 3';
            P100.Roofing__c = 'P100: Tier 3';
            P100.Interior_Performance__c = 'P100: Tier 3';
            P100.Mechanical__c = 'P100: Tier 3';
            P100.Lighting_Quality__c = 'P100: Tier 3';
            P100.Electrical_overall_quality_power_quality__c = 'P100: Tier 3';
            P100.Landscape_Performance__c = 'P100: Tier 3';
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            insert P100;
            system.assertNotEquals(NULL,P100); 
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            Delete P100;
            system.assertNotEquals(NULL,P100);
            
        }
        
        if (blnNCMTreports == true && blnOverrideAtrium == false) {
            //Test.startTest();
            
            //PageReference pageRef = Page.NCMT_UniformatCostOutput;
            //Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().put('ProjectID', Proj.id);
            
            NCMT_ReportData objTest = new NCMT_ReportData();
            objTest.DatasetProjectCostSummaryGrouped(Proj.id);
            objTest.getProjectInformation();
            objTest.getDatasetProjectCostSummary();  
            objTest.getDatasetHousingPlan();   
            objTest.getCoreShellData();      
            
            NCMT_ReportsLandingPage objRptTest = new NCMT_ReportsLandingPage();
            
            objRptTest.getProjectReports();
            objRptTest.getProjectLookUpReports();
            objRptTest.getRegionalReports();
            objRptTest.getRegions();
            objRptTest.getCurrentFY();
            objRptTest.getFiscalYears();
            objRptTest.getUserRegionValue();
            objRptTest.setUserRegionValue('1');           
            
            //Test.stopTest(); 
        } 
        Test.stopTest();
    }
    
    public static void CreateParkingGarageProject(string strProjectName, string strState, string strCity, string strRemoteness, 
                                                  string strParkingStructureArea, string strRampingOption, string strLayoutEfficiency, string strCladdingOption,
                                                  Decimal dblNumber_of_Spaces, Decimal dblAt_and_above_grade, Decimal dblBelow_grade, boolean blnEndConstruction) {
                                                      
        Date CostParaDate = date.newinstance(2016, 10, 1);
      /* Integer FY=  system.now().Month() >= 10?  system.now().Year(): system.now().Year()-1;                           
        Date CostParaDate = date.newinstance(FY, 10, 1);*/
        NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
        NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
        NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        insert NCMT_Cust_settings;
        
        string strBLDGPGRecordType = Schema.SObjectType.NCMT_Building_Parameter__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId(); 
        string strBLDGHeightPGRecordType = Schema.SObjectType.NCMT_Building_Height_Parameter__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId(); 
        
        for(NCMT_Building_Parameter__c BLDG: lstbuilding)
        { 
            BLDG.Recordtypeid = strBLDGPGRecordType; 
        }         
        
        for(NCMT_Building_Height_Parameter__c BLDGHeight: lstbldgheight )
        { 
            BLDGHeight.Recordtypeid = strBLDGHeightPGRecordType ; 
        }     
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                    and State__c = :strState and Name = :strCity];
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NCMT_Project__c; 
        Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        NCMT_Project__c Proj = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('Parking Garage').getRecordTypeId());
        
        Proj.Building_Type__c = 'Parking Garage';
        Proj.Project_type__c = 'New Construction';
        Proj.Estimate_Type_Proj__c  ='Parametric';
        Proj.Name = strProjectName;
        Proj.State__c = strState;
        Proj.City__c = strCity;        
        
        Proj.Location__c = objlocation.Id ;
        
        Date ConstDate = date.newinstance(2025, 1, 1);
        Date ConstDate2 = date.newinstance(2023, 1, 1);
        
        if (blnEndConstruction == true) {
            Proj.End_Construction__c = ConstDate;
        } 
        else {
            Proj.Start_Construction__c = ConstDate;
        }        
        Proj.Remoteness__c = strRemoteness;
        if (strParkingStructureArea == 'Parking Structure') {
            Proj.Parking_Structure__c = true;
            Proj.Parking_Deck__c = false;
            Proj.Below_Grade_Structure__c = false;
        }
        else if (strParkingStructureArea == 'Parking Deck') {
            Proj.Parking_Structure__c = false;
            Proj.Parking_Deck__c = true;
            Proj.Below_Grade_Structure__c = false;
        }
        else {
            Proj.Parking_Structure__c = false;
            Proj.Parking_Deck__c = false;
            Proj.Below_Grade_Structure__c = true;
        }
        if (strRampingOption == 'Sloped Parking Deck') {
            Proj.Sloped_Parking_Deck__c = true;
            Proj.Speed_Ramp__c = false;
        }
        else {
            Proj.Sloped_Parking_Deck__c = false;
            Proj.Speed_Ramp__c = true;
        }
        if (strLayoutEfficiency == 'Optimized for Parking') {
            Proj.Optimized_for_Parking__c = true;
            Proj.Medium_Efficiency__c = false;
            Proj.Low_Efficiency__c = false;
        }
        else if (strLayoutEfficiency == 'Medium Efficiency') {
            Proj.Optimized_for_Parking__c = false;
            Proj.Medium_Efficiency__c = true;
            Proj.Low_Efficiency__c = false;
        }
        else {
            Proj.Optimized_for_Parking__c = false;
            Proj.Medium_Efficiency__c = false;
            Proj.Low_Efficiency__c = true;
        }
        if (strCladdingOption == 'Utilitarian') {
            Proj.Utilitarian__c = true;
            Proj.Medium__c = false;
            Proj.High__c = false;
        }
        else if (strCladdingOption == 'Medium') {
            Proj.Utilitarian__c = false;
            Proj.Medium__c = true;
            Proj.High__c = false;
        }
        else {
            Proj.Utilitarian__c = false;
            Proj.Medium__c = false;
            Proj.High__c = true;
        }
        Proj.Number_of_Spaces__c = dblNumber_of_Spaces;
        Proj.At_and_above_grade__c = dblAt_and_above_grade;
        Proj.Below_grade__c = dblBelow_grade;
        Proj.Project_Status__c = 'Draft';
        Proj.Cost_Parameter_Date__c = CostParaDate;
        
        //Proj.Project_Phases__c ='Design';
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        //Proj.Project_SubPhases__c='Preliminary Concept';
        
        insert Proj;
        system.assertNotEquals(NULL,Proj); 
        
        Test.startTest();
        
        Schema.DescribeSObjectResult cfrSchemaPLP = Schema.SObjectType.Project_Level_Parameter__c; 
        Map<String,Schema.RecordTypeInfo> PLPTypeInfo = cfrSchemaPLP.getRecordTypeInfosByName();
        
        Project_Level_Parameter__c PLP = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Parking Garage').getRecordTypeId());
        Project_Level_Parameter__c PLPupd = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Parking Garage').getRecordTypeId());
        
        PLP =  [SELECT Id, Foot_Print_Area__c, Massing_Override_Comments__c, Structure_Override_Comments__c, Typical_Bay_Size_A__c, Interior_Override_Comments__c, Int_Const_Core_Shell_Partition_ratio__c, 
                MEP_Override_Comments__c, Electrical_Load__c, Vertical_Transportation_Override_Comment__c, Vertical_Conveyance_Escalators_Pairs__c,
                Cladding_Override_Comments__c, Cladding_Skin_Ratio__c
                FROM Project_Level_Parameter__c WHERE NCMT_Project__c = :Proj.id];
        
        //Test.startTest();
        TriggerValue.isupdate = false;
        TriggerValue.isupdate1 = true;
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_ProjectTriggerValue.firstRun = true;
        //TriggerValue.isInsertPT = false;
        //PLP.Use_Level_of_Protection__c = strLevel_of_Protection;
        //PLP.Use_Blast_Resistance__c = strLevel_of_Protection;
        //PLP.Foot_Print_Area__c = 10000;
        PLP.Massing_Override_Comments__c = 'test';
        PLP.Typical_Bay_Size_A__c = 40;
        PLP.Structure_Override_Comments__c = 'test';
        PLP.Int_Const_Core_Shell_Partition_ratio__c = 0.05;      
        PLP.Interior_Override_Comments__c = 'test';
        PLP.Electrical_Load__c = 12;      
        PLP.MEP_Override_Comments__c = 'test';
        PLP.Vertical_Conveyance_Escalators_Pairs__c = 0.1;
        PLP.Vertical_Transportation_Override_Comment__c = 'test';
        PLP.Cladding_Skin_Ratio__c = 0.5;
        PLP.Cladding_Override_Comments__c = 'test'; 
        update PLP;      
        
        system.assertNotEquals(NULL,PLP);
        
        PLPupd.Id = PLP.Id;
        TriggerValue.isupdate = true;
        TriggerValue.isupdate1 = true;
        //TriggerValue.isInsertPT = false;
        //PLPupd.Foot_Print_Area__c = 600000;
        PLPupd.Massing_Override_Comments__c = 'test';
        PLPupd.Typical_Bay_Size_A__c = 40;
        
        update PLPupd;
        system.assertNotEquals(NULL,PLPupd);
        //Test.stopTest(); 
        
        Project_Level_Parameter__c PLP3 = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Parking Garage').getRecordTypeId());
        NCMT_Building_Massing_By_Floor__c BldgMassFloor = new NCMT_Building_Massing_By_Floor__c();
        
        PLP3 = [select Id from Project_Level_Parameter__c WHERE NCMT_Project__c = :Proj.id];
        
        BldgMassFloor = [select Id, Use_Area_SF__c from NCMT_Building_Massing_By_Floor__c where Proj_Level_Parameter__c = :PLP3.Id and Building_Massing_Area__c = 'Ground SF'];
        //Test.startTest();
        TriggerValue.firstRun = true;
        TriggerValue.isUpdate1 = false;
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
        NCMT_ProjectTriggerValue.firstRun = true;
        BldgMassFloor.Use_Area_SF__c = 1000;
        
        update BldgMassFloor;
        system.assertNotEquals(NULL,BldgMassFloor);
        //Test.stopTest(); 
        
        //Test.startTest();
        /*
        if (strParkingStructureArea == 'Parking Structure') {
        
        NCMT_Project__c Projupd = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('Parking Garage').getRecordTypeId());
        NCMT_ProjectTriggerValue.firstRun = true;
        //NCMT_ProfSevEstTriggerValue.firstRun = true;
        
        Projupd.Id = Proj.id;
        Projupd.Number_of_Spaces__c = 4000;
        //Projupd.At_and_above_grade__c = 3;
        //Projupd.Remoteness__c = 'Suburban';
        Projupd.Set_Aside_100__c = true;
        Projupd.Start_Construction__c = ConstDate2;
        Projupd.End_Construction__c = null;
        update Projupd;
        system.assertNotEquals(NULL,Projupd);  
        
        }
        else if (strParkingStructureArea == 'Parking Deck') {
        
        NCMT_Project__c Projupd1 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('Parking Garage').getRecordTypeId());
        NCMT_ProjectTriggerValue.firstRun = true;
        //NCMT_ProfSevEstTriggerValue.firstRun = true;
        
        Projupd1.Id = Proj.id;
        Projupd1.Set_Aside_100__c = true;
        Projupd1.Start_Construction__c = ConstDate2;
        Projupd1.End_Construction__c = null;
        Projupd1.Override_Calculated_Site_Area__c = 20000;
        
        update Projupd1;
        system.assertNotEquals(NULL,Projupd1);  
        
        }
        else {
        
        NCMT_Project__c Projupd2 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('Parking Garage').getRecordTypeId());
        NCMT_ProjectTriggerValue.firstRun = true;
        //NCMT_ProfSevEstTriggerValue.firstRun = true;
        
        Projupd2.Id = Proj.id;
        Projupd2.Number_of_Spaces__c = 4000;
        Projupd2.Set_Aside_100__c = true;
        Projupd2.Start_Construction__c = ConstDate2;
        Projupd2.End_Construction__c = null;
        
        update Projupd2;
        system.assertNotEquals(NULL,Projupd2);  
        
        }
        */
        //Test.stopTest();
    }  
    
    public static void UpdateParkingGarageProject(string strProjectName, string strState, string strCity, string strRemoteness, 
                                                  string strParkingStructureArea, string strRampingOption, string strLayoutEfficiency, string strCladdingOption,
                                                  Decimal dblNumber_of_Spaces, Decimal dblAt_and_above_grade, Decimal dblBelow_grade, boolean blnEndConstruction) {
                                                      
        Date CostParaDate = date.newinstance(2016, 10, 1);
        /*Integer FY=  system.now().Month() >= 10?  system.now().Year(): system.now().Year()-1;                           
        Date CostParaDate = date.newinstance(FY, 10, 1);*/
        NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
        NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
        NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        insert NCMT_Cust_settings;
        
        string strBLDGPGRecordType = Schema.SObjectType.NCMT_Building_Parameter__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId(); 
        string strBLDGHeightPGRecordType = Schema.SObjectType.NCMT_Building_Height_Parameter__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId(); 
        
        for(NCMT_Building_Parameter__c BLDG: lstbuilding)
        { 
            BLDG.Recordtypeid = strBLDGPGRecordType; 
        }         
        
        for(NCMT_Building_Height_Parameter__c BLDGHeight: lstbldgheight )
        { 
            BLDGHeight.Recordtypeid = strBLDGHeightPGRecordType ; 
        }     
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                    and State__c = :strState and Name = :strCity];
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NCMT_Project__c; 
        Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        NCMT_Project__c Proj = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('Parking Garage').getRecordTypeId());
        
        Proj.Building_Type__c = 'Parking Garage';
        Proj.Project_type__c = 'New Construction';
        Proj.Estimate_Type_Proj__c  ='Parametric';
        Proj.Name = strProjectName;
        Proj.State__c = strState;
        Proj.City__c = strCity;        
        
        Proj.Location__c = objlocation.Id ;
        
        Date ConstDate = date.newinstance(2025, 1, 1);
        Date ConstDate2 = date.newinstance(2023, 1, 1);
        
        if (blnEndConstruction == true) {
            Proj.End_Construction__c = ConstDate;
        } 
        else {
            Proj.Start_Construction__c = ConstDate;
        }        
        Proj.Remoteness__c = strRemoteness;
        if (strParkingStructureArea == 'Parking Structure') {
            Proj.Parking_Structure__c = true;
            Proj.Parking_Deck__c = false;
            Proj.Below_Grade_Structure__c = false;
        }
        else if (strParkingStructureArea == 'Parking Deck') {
            Proj.Parking_Structure__c = false;
            Proj.Parking_Deck__c = true;
            Proj.Below_Grade_Structure__c = false;
        }
        else {
            Proj.Parking_Structure__c = false;
            Proj.Parking_Deck__c = false;
            Proj.Below_Grade_Structure__c = true;
        }
        if (strRampingOption == 'Sloped Parking Deck') {
            Proj.Sloped_Parking_Deck__c = true;
            Proj.Speed_Ramp__c = false;
        }
        else {
            Proj.Sloped_Parking_Deck__c = false;
            Proj.Speed_Ramp__c = true;
        }
        if (strLayoutEfficiency == 'Optimized for Parking') {
            Proj.Optimized_for_Parking__c = true;
            Proj.Medium_Efficiency__c = false;
            Proj.Low_Efficiency__c = false;
        }
        else if (strLayoutEfficiency == 'Medium Efficiency') {
            Proj.Optimized_for_Parking__c = false;
            Proj.Medium_Efficiency__c = true;
            Proj.Low_Efficiency__c = false;
        }
        else {
            Proj.Optimized_for_Parking__c = false;
            Proj.Medium_Efficiency__c = false;
            Proj.Low_Efficiency__c = true;
        }
        if (strCladdingOption == 'Utilitarian') {
            Proj.Utilitarian__c = true;
            Proj.Medium__c = false;
            Proj.High__c = false;
        }
        else if (strCladdingOption == 'Medium') {
            Proj.Utilitarian__c = false;
            Proj.Medium__c = true;
            Proj.High__c = false;
        }
        else {
            Proj.Utilitarian__c = false;
            Proj.Medium__c = false;
            Proj.High__c = true;
        }
        Proj.Number_of_Spaces__c = dblNumber_of_Spaces;
        Proj.At_and_above_grade__c = dblAt_and_above_grade;
        Proj.Below_grade__c = dblBelow_grade;
        Proj.Project_Status__c = 'Draft';
        Proj.Cost_Parameter_Date__c = CostParaDate;
        
        //Proj.Project_Phases__c ='Design';
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        //Proj.Project_SubPhases__c='Preliminary Concept';
        
        insert Proj;
        system.assertNotEquals(NULL,Proj);
        
        Test.startTest();
        
        if (strParkingStructureArea == 'Parking Structure') {
            
            NCMT_Project__c Projupd = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('Parking Garage').getRecordTypeId());
            NCMT_ProjectTriggerValue.firstRun = true;
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            //NCMT_ProfSevEstTriggerValue.firstRun = true;
            
            Projupd.Id = Proj.id;
            Projupd.Number_of_Spaces__c = 4000;
            //Projupd.At_and_above_grade__c = 3;
            //Projupd.Remoteness__c = 'Suburban';
            Projupd.Set_Aside_100__c = true;
            Projupd.Start_Construction__c = ConstDate2;
            Projupd.End_Construction__c = null;
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update Projupd;
            system.assertNotEquals(NULL,Projupd);  
            
        }
        else if (strParkingStructureArea == 'Parking Deck') {
            
            NCMT_Project__c Projupd1 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('Parking Garage').getRecordTypeId());
            NCMT_ProjectTriggerValue.firstRun = true;
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            //NCMT_ProfSevEstTriggerValue.firstRun = true;
            
            Projupd1.Id = Proj.id;
            Projupd1.Set_Aside_100__c = true;
            Projupd1.Start_Construction__c = ConstDate2;
            Projupd1.End_Construction__c = null;
            Projupd1.Override_Calculated_Site_Area__c = 20000;
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update Projupd1;
            system.assertNotEquals(NULL,Projupd1);  
            
        }
        else {
            
            NCMT_Project__c Projupd2 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('Parking Garage').getRecordTypeId());
            NCMT_ProjectTriggerValue.firstRun = true;
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            //NCMT_ProfSevEstTriggerValue.firstRun = true;
            
            Projupd2.Id = Proj.id;
            Projupd2.Number_of_Spaces__c = 4000;
            Projupd2.Set_Aside_100__c = true;
            Projupd2.Start_Construction__c = ConstDate2;
            Projupd2.End_Construction__c = null;
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update Projupd2;
            system.assertNotEquals(NULL,Projupd2);  
            
        }
        
        Test.stopTest();    
        
    }
    
    public static void CreateProfServEst(string strProjectName, string strState, string strCity, decimal dblEstimated_Total_GSF, decimal dblECC, string strBuilding_Type, string strProject_Type,
                                         string strDelivery_Method, string strCM_Role, string strDesign_Build_Leased_Delivery_Only, 
                                         string strFor_Design_Build_Owned_Stipend_Detail, string strFor_Design_Build_Owned_Stipend_Compl,
                                         string strScope, string strPhases) {
                                             
          Date CostParaDate = date.newinstance(2016, 10, 1);
       /* Integer FY=  system.now().Month() >= 10?  system.now().Year(): system.now().Year()-1;                           
        Date CostParaDate = date.newinstance(FY, 10, 1);*/
        NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
        NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
        NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        insert NCMT_Cust_settings;
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                and State__c = :strState and Name = :strCity];
    
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Professional_Service_Estimate__c; 
        Map<String,Schema.RecordTypeInfo> ProfServTypeInfo = cfrSchema.getRecordTypeInfosByName();
        String strRecordType;
        if (strProject_Type == 'Repair & Alteration') {
            strRecordType = 'User Defined Repair and Alteration';
        }
        else {
            strRecordType = 'User Defined';
        }
        Professional_Service_Estimate__c ProfServEst = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());        
        
        ProfServEst.Name = strProjectName;
        ProfServEst.Building_Type__c = strBuilding_Type;
        ProfServEst.Project_Type__c = strProject_Type;
        if (strProject_Type == 'Repair & Alteration') {
            ProfServEst.Scope__c = strScope;
            ProfServEst.Estimated_Number_of_Phases__c = strPhases;
        }
        ProfServEst.ECC__c = dblECC;
        ProfServEst.Estimated_Total_GSF__c = dblEstimated_Total_GSF;
        
        ProfServEst.Delivery_Method__c = strDelivery_Method;
        ProfServEst.CM_Role__c = strCM_Role;
        ProfServEst.Design_Build_Leased_Delivery_Only__c = strDesign_Build_Leased_Delivery_Only;
        ProfServEst.For_Design_Build_Owned_Stipend_Compl__c = strFor_Design_Build_Owned_Stipend_Compl;
        ProfServEst.For_Design_Build_Owned_Stipend_Detail__c = strFor_Design_Build_Owned_Stipend_Detail;       
        
        ProfServEst.State__c = strState;
        ProfServEst.City__c = strCity;        
        ProfServEst.Location_Parameter__c = objlocation.Id ;
        
        Date BaseDate = date.newinstance(2016, 1, 1);
        ProfServEst.Base_Date_of_Estimate__c = BaseDate;
        ProfServEst.Anticipated_Start_Date_of_Construction__c = BaseDate; 
        
        insert ProfServEst;
        system.assertNotEquals(NULL,ProfServEst);   
        
        Date StartDate = date.newinstance(2017, 1, 1);
        
        Professional_Service_Estimate__c ProfServEstUpd0 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
        NCMT_ProfSevEstTriggerValue.firstRun = true;      
        ProfServEstUpd0.id = ProfServEst.id;
        ProfServEstUpd0.Anticipated_Date_of_Design_Award__c = StartDate ;
        update ProfServEstUpd0;
        system.assertNotEquals(NULL,ProfServEstUpd0);
        
        /*Professional_Service_Estimate__c ProfServEstUpdDT = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
        NCMT_ProfSevEstTriggerValue.firstRun = true;      
        ProfServEstUpdDT.id = ProfServEst.id;
        ProfServEstUpdDT.Base_Date_of_Estimate__c = StartDate;
        update ProfServEstUpdDT;
        system.assertNotEquals(NULL,ProfServEstUpdDT);*/
        
        if (strDelivery_Method == 'Design Build - Leased' && strDesign_Build_Leased_Delivery_Only == 'Build to Suit') {
            Professional_Service_Estimate__c ProfServEstUpdLeased = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdLeased.id = ProfServEst.id;
            ProfServEstUpdLeased.Design_Build_Leased_Delivery_Only__c = 'Tenant Fit-out w/ no Redesign';
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update ProfServEstUpdLeased;
            system.assertNotEquals(NULL,ProfServEstUpdLeased);
        }
        
        if (strScope == 'Limited Scope') {
            Professional_Service_Estimate__c ProfServEstUpdRAL = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdRAL.id = ProfServEst.id;
            ProfServEstUpdRAL.Estimated_Number_of_Phases__c = '2';
            ProfServEstUpdRAL.ECC__c = 500040;
            update ProfServEstUpdRAL;
            system.assertNotEquals(NULL,ProfServEstUpdRAL);
            
            Professional_Service_Estimate__c ProfServEstUpdRAL1 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdRAL1.id = ProfServEst.id;
            ProfServEstUpdRAL1.Estimated_Number_of_Phases__c = '3';
            ProfServEstUpdRAL1.ECC__c = 2500040;
            update ProfServEstUpdRAL1;
            system.assertNotEquals(NULL,ProfServEstUpdRAL1);
            
            Professional_Service_Estimate__c ProfServEstUpdRAL2 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdRAL2.id = ProfServEst.id;
            ProfServEstUpdRAL2.Estimated_Number_of_Phases__c = '4';
            update ProfServEstUpdRAL2;
            system.assertNotEquals(NULL,ProfServEstUpdRAL2);
            
            Professional_Service_Estimate__c ProfServEstUpdRAL3 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdRAL3.id = ProfServEst.id;
            ProfServEstUpdRAL3.Estimated_Number_of_Phases__c = '4+';
            update ProfServEstUpdRAL3;
            system.assertNotEquals(NULL,ProfServEstUpdRAL3);        
        }
        
        if (strScope == 'Distributed Scope') {
            Professional_Service_Estimate__c ProfServEstUpdRAL = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdRAL.id = ProfServEst.id;
            ProfServEstUpdRAL.Estimated_Number_of_Phases__c = '1';
            ProfServEstUpdRAL.ECC__c = 500040;
            update ProfServEstUpdRAL;
            system.assertNotEquals(NULL,ProfServEstUpdRAL);
            
            Professional_Service_Estimate__c ProfServEstUpdRAL1 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdRAL1.id = ProfServEst.id;
            ProfServEstUpdRAL1.Estimated_Number_of_Phases__c = '3';
            ProfServEstUpdRAL1.ECC__c = 2500040;
            update ProfServEstUpdRAL1;
            system.assertNotEquals(NULL,ProfServEstUpdRAL1);
            
            Professional_Service_Estimate__c ProfServEstUpdRAL2 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdRAL2.id = ProfServEst.id;
            ProfServEstUpdRAL2.Estimated_Number_of_Phases__c = '4';
            update ProfServEstUpdRAL2;
            system.assertNotEquals(NULL,ProfServEstUpdRAL2);
            
            Professional_Service_Estimate__c ProfServEstUpdRAL3 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdRAL3.id = ProfServEst.id;
            ProfServEstUpdRAL3.Estimated_Number_of_Phases__c = '4+';
            update ProfServEstUpdRAL3;
            system.assertNotEquals(NULL,ProfServEstUpdRAL3);        
        }
        
        if (strScope == 'Full Modernization') {
            Professional_Service_Estimate__c ProfServEstUpdRAL = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdRAL.id = ProfServEst.id;
            ProfServEstUpdRAL.Estimated_Number_of_Phases__c = '1';
            ProfServEstUpdRAL.ECC__c = 500040;
            update ProfServEstUpdRAL;
            system.assertNotEquals(NULL,ProfServEstUpdRAL);
            
            Professional_Service_Estimate__c ProfServEstUpdRAL1 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpdRAL1.id = ProfServEst.id;
            ProfServEstUpdRAL1.Estimated_Number_of_Phases__c = '2';
            ProfServEstUpdRAL1.ECC__c = 2500040;
            update ProfServEstUpdRAL1;
            system.assertNotEquals(NULL,ProfServEstUpdRAL1);
        }
        
        if (strDelivery_Method == 'Design Build - Owned') {    
            
            Professional_Service_Estimate__c ProfServEstUpd = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpd.id = ProfServEst.id;
            ProfServEstUpd.ECC__c = 100000060 ;
            ProfServEstUpd.For_Design_Build_Owned_Stipend_Detail__c = 'Medium';        
            update ProfServEstUpd;
            system.assertNotEquals(NULL,ProfServEstUpd);  
            
            Professional_Service_Estimate__c ProfServEstUpd2 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpd2.id = ProfServEst.id;
            ProfServEstUpd2.ECC__c = 60162015 ;
            ProfServEstUpd2.For_Design_Build_Owned_Stipend_Detail__c = 'High';        
            update ProfServEstUpd2;
            system.assertNotEquals(NULL,ProfServEstUpd2);  
            
            Professional_Service_Estimate__c ProfServEstUpd3 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpd3.id = ProfServEst.id;
            ProfServEstUpd3.ECC__c = 150000050 ;      
            ProfServEstUpd3.For_Design_Build_Owned_Stipend_Compl__c = 'Medium';
            ProfServEstUpd3.For_Design_Build_Owned_Stipend_Detail__c = 'Low';        
            update ProfServEstUpd3;
            system.assertNotEquals(NULL,ProfServEstUpd3);  
            
            Professional_Service_Estimate__c ProfServEstUpd4 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpd4.id = ProfServEst.id;
            ProfServEstUpd4.ECC__c = 60162025 ;
            ProfServEstUpd4.For_Design_Build_Owned_Stipend_Detail__c = 'Medium';        
            update ProfServEstUpd4;
            system.assertNotEquals(NULL,ProfServEstUpd4);  
            
            Professional_Service_Estimate__c ProfServEstUpd5 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpd5.id = ProfServEst.id;
            ProfServEstUpd5.ECC__c = 60162030 ;
            ProfServEstUpd5.For_Design_Build_Owned_Stipend_Detail__c = 'High';        
            update ProfServEstUpd5;
            system.assertNotEquals(NULL,ProfServEstUpd5);  
            
            Professional_Service_Estimate__c ProfServEstUpd6 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpd6.id = ProfServEst.id;
            ProfServEstUpd6.ECC__c = 60162035 ;      
            ProfServEstUpd6.For_Design_Build_Owned_Stipend_Compl__c = 'High';
            ProfServEstUpd6.For_Design_Build_Owned_Stipend_Detail__c = 'Low';        
            update ProfServEstUpd6;
            system.assertNotEquals(NULL,ProfServEstUpd6);  
            
            Professional_Service_Estimate__c ProfServEstUpd7 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpd7.id = ProfServEst.id;
            ProfServEstUpd7.ECC__c = 60162040 ;
            ProfServEstUpd7.For_Design_Build_Owned_Stipend_Detail__c = 'Medium';        
            update ProfServEstUpd7;
            system.assertNotEquals(NULL,ProfServEstUpd7);  
            
            Professional_Service_Estimate__c ProfServEstUpd8 = new Professional_Service_Estimate__c (id = null, recordtypeid = ProfServTypeInfo.get(strRecordType).getRecordTypeId());      
            NCMT_ProfSevEstTriggerValue.firstRun = true;      
            ProfServEstUpd8.id = ProfServEst.id;
            ProfServEstUpd8.ECC__c = 200000070 ;
            ProfServEstUpd8.For_Design_Build_Owned_Stipend_Detail__c = 'High';        
            update ProfServEstUpd8;
            system.assertNotEquals(NULL,ProfServEstUpd8);                                                              
            
        }
        
    }  
    public static void CreateDESProject(string strProjectType, string strProjectName, string strBuildingType, string strState, string strCity, 
                                        string strprojdelmethod, string strmarkupmthd, boolean isclone, boolean isAssembly, boolean isMarkupMthdchanged, boolean isDesItemLaborRecord){

                                 
        Date CostParaDate = date.newinstance(2016, 10, 1);
       /* Integer FY=  system.now().Month() >= 10?  system.now().Year(): system.now().Year()-1;                           
        Date CostParaDate = date.newinstance(FY, 10, 1);   */                                
            NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
            NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
            NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
            insert NCMT_Cust_settings;
        
        string strRecordTypeName;
        strRecordTypeName = strBuildingType;
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                    and State__c = :strState and Name = :strCity];
        NCMT_Crew_Master__c objcrewmaster = [select Id from NCMT_Crew_Master__c where id in :listCrewMaster
                                                and Name ='B86'] ;   
        NCMT_Contractor__c objSubcon = [select Id from NCMT_Contractor__c where id in :lstNCMT_Contractor and Name = 'AB'];
        
        NCMT_DES_Lookup_details__c objDESLookupDet =[select Id from NCMT_DES_Lookup_details__c where id in :lstNCMT_DES_Lookup_Detail
                                                            and Name = 'S1']; 
        NCMT_DES_Lookup_details__c objDESLookupDetL =[select Id from NCMT_DES_Lookup_details__c where id in :lstNCMT_DES_Lookup_Detail
                                                            and Name = 'S2'];    
        NCMT_Assembly_Lookup_Detail__c objAssmMaster = [select Id from NCMT_Assembly_Lookup_Detail__c where id in :lstNCMT_Assembly_Lookup_Detail
                                                            and Name = '221'];    
        NCMT_Assembly_Lookup_Detail__c objGSAAssmMaster = [select Id, Minimum_Cost__c from NCMT_Assembly_Lookup_Detail__c where id in :lstGSAAssemblies
                                                            and Name = '01-003'];  
                                                    
        Schema.DescribeSObjectResult cfrSchemaDS = Schema.SObjectType.NCMT_DES_Items__c;
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NCMT_Project__c;
        Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> DESItemInfo = cfrSchemaDS.getRecordTypeInfosByName();
        
        if(strProjectType == 'New Construction - DES'){
                strRecordTypeName = 'New Construction - DES';
        }else{
            strRecordTypeName = 'Repair & Alteration - DES';
        }
                
        NCMT_Project__c Proj = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());
        NCMT_Project__c Proj1 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());

        NCMT_Project__c Projupd = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());
        NCMT_Project__c Projupd2 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());       
        NCMT_Project__c Projupd3 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());       

        Proj.Estimate_Type_Proj__c  = 'Definitive Estimating';  
        Proj.Project_type__c = strProjectType;
        Proj.Building_Type__c = strBuildingType;
        Proj.Name = strProjectName;
        Proj.State__c = strState;
        Proj.City__c = strCity;        
        
        Proj.Location__c = objlocation.Id;
        
        Date ConstDate = date.newinstance(2025, 1, 1);
        Date MidPtConst = date.newInstance(2020, 12, 1);
        Date EndConstDate = date.newinstance(2016, 10, 1);
                                                
    
        Proj.Project_Status__c = 'Draft';
        Proj.Cost_Parameter_Date__c = CostParaDate;
        Proj.Project_Phases__c ='Design';
        Proj.Project_SubPhases__c = '90% Construction Documents';
        Proj.Project_Delivery_Method__c= strprojdelmethod;
        Proj.Markup_Method__c = strmarkupmthd;   
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        Proj.Mid_Point_of_Construction__c = MidPtConst;
        
        insert Proj;
        system.assertNotEquals(NULL,Proj); 
        
        
        Test.startTest();

            NCMT_Project_Cost_Summary__c ProjCostSummary = new NCMT_Project_Cost_Summary__c (id = null);
            NCMT_DES_Items__c  DESItem  = new NCMT_DES_Items__c  (id = null);
            NCMT_DES_Items__c  DESItemL  = new NCMT_DES_Items__c  (id = null);
            NCMT_DES_Items__c DESItem2 = new NCMT_DES_Items__c (id = null, recordtypeid = DESItemInfo.get('NCMT DES Item Uniformat').getRecordTypeId());
            NCMT_DES_Items__c  DESItemupd  = new NCMT_DES_Items__c  (id = null);
            NCMT_DES_Items__c  DESItemD  = new NCMT_DES_Items__c  (id = null);
            NCMT_DES_Items__c DESItemGSA = new NCMT_DES_Items__c(id = null, recordtypeid = DESItemInfo.get('NCMT DES Item Master Format').getRecordTypeId());
            

            NCMT_Tree_structure__c treestruc = new NCMT_Tree_structure__c(id =null);
            NCMT_Tree_structure__c treestruc1 = new NCMT_Tree_structure__c(id =null);
            NCMT_Tree_structure__c treestruc2 = new NCMT_Tree_structure__c(id =null);
            NCMT_Tree_structure__c treestrucupd = new NCMT_Tree_structure__c(id =null);
            NCMT_Tree_structure__c treestrucupd1 = new NCMT_Tree_structure__c(id =null);
            
            ProjCostSummary =[Select id, Project_Name__c 
                                From NCMT_Project_Cost_Summary__c 
                                Where Project_Name__c =:Proj.id limit 1];
            treestruc = [Select id,name
                        From NCMT_Tree_structure__c 
                        where Project_ID__c = :Proj.id];
            if(!isAssembly){ 
            treestruc1.Project_ID__c = Proj.id;
            treestruc1.Relatedtree__c = treestruc.id;
            treestruc1.Branch_Name__c ='Building1';
            
            insert treestruc1;
            system.assertNotEquals(NULL,treestruc1);
        
            treestruc2.Project_ID__c = Proj.id;
            treestruc2.Relatedtree__c = treestruc1.id;
            treestruc2.Branch_Name__c ='Floor1';
            
            insert treestruc2;
            system.assertNotEquals(NULL,treestruc2);
        
            
            DESItem.Project_Cost_Summary_ID__c   = ProjCostSummary.id;
            DESItem.Tree_structure__c = treestruc2.id;
            DESItem.Item_Type__c = 'Master Format';
            DESItem.DES_Lookup_Detail__c = objDESLookupDet.Id;
            DESItem.NCMT_Contractor_ID__c = objSubcon.id;
            DESItem.Hourly_Rate__c = 50;
            DESItem.Quantity__c =100;
            DESItem.NCMT_Project_Location__c =strState;
            DESItem.Include_In_Estimate__c = true;    
            
            insert DESItem;
            system.assertNotEquals(NULL,DESItem);
            Test.stopTest();
            }
        if(isDesItemLaborRecord){
            DESItemL.Project_Cost_Summary_ID__c   = ProjCostSummary.id;
            DESItemL.Tree_structure__c = treestruc2.id;
            DESItemL.Item_Type__c = 'Master Format';
            DESItemL.DES_Lookup_Detail__c = objDESLookupDetL.Id;
            DESItemL.NCMT_Contractor_ID__c = objSubcon.id;
            DESItemL.Hourly_Rate__c = 50;
            DESItemL.Quantity__c =100;
            DESItemL.NCMT_Project_Location__c =strState;
            DESItemL.Include_In_Estimate__c = true;    
            
            insert DESItemL;
            system.assertNotEquals(NULL,DESItemL);
            
            ApexPages.StandardController TreeLst = new ApexPages.StandardController(Proj);
            NCMT_TreeRelatedListController objTreelist = new NCMT_TreeRelatedListController(TreeLst);    
        }
        
            if(isAssembly){ 
            DESItem2.Project_Cost_Summary_ID__c   = ProjCostSummary.id;
            DESItem2.Tree_structure__c = treestruc.id;
            DESItem2.Item_Type__c ='Assemblies';
            DESItem2.NCMT_Assembly_Master__c = objAssmMaster.id;
            DESItem2.Hourly_Rate__c = 50;
            DESItem2.Material_Unit_Cost__c = 10.2;
            DESItem2.Location_Multiplier_Washington_DC_1_00__c = 0.89;
            DESItem2.Quantity__c = 10;
            DESItem2.NCMT_Project_Location__c =strState;
            DESItem2.Original_Minimum_Cost__c=129;
            DESItem2.MinID__c='123'; 
            DESItem2.Total_Labor_Cost__c =150;
            DESItem2.Labor_Cost__c = 60;
            DESItem2.Minimum_Cost__c =30;    
            
             List<NCMT_DES_Items__c> tests = new List<NCMT_DES_Items__c>();
             tests.add(DESItem2);
            //insert DESItem2;
            //system.assertNotEquals(NULL,DESItem2); 
            
                
                //GSA Assemblies DES Item
                DESItemGSA.Project_Cost_Summary_ID__c   = ProjCostSummary.id;
                DESItemGSA.Tree_structure__c = treestruc.id;
                DESItemGSA.Item_Type__c ='GSAAssemblies';
                DESItemGSA.NCMT_Assembly_Master__c = objGSAAssmMaster.id;
                DESItemGSA.Hourly_Rate__c = 50;
                DESItemGSA.Material_Unit_Cost__c = 10.2;
                DESItemGSA.Location_Multiplier_Washington_DC_1_00__c = 0.89;
                DESItemGSA.Quantity__c = 100;
                DESItemGSA.Original_Minimum_Cost__c=129;
                DESItemGSA.MinID__c='123';  
                DESItemGSA.Total_Labor_Cost__c =150;
                DESItemGSA.Labor_Cost__c = 60;
                DESItemGSA.Minimum_Cost__c =30;  
                
                //insert DESItemGSA;
                tests.add(DESItemGSA);
                insert tests;
                system.assertNotEquals(NULL,DESItemGSA); 
                system.assertNotEquals(NULL,DESItem2);
                Test.stopTest();
                //Test.startTest();
                delete DESItemGSA;
                system.assertNotEquals(NULL,DESItemGSA);
                //Test.stopTest();
            }
                                                            

       
            
        IF(isMarkupMthdchanged ){ 
            
                    //update Project
                    NCMT_ProjectTriggerValue.firstRun = true;
                    Projupd3.id = Proj.id;
                    Projupd3.Project_type__c = strProjectType;
                    Projupd3.Markup_Method__c ='RSMeans - O&P'; 
                    NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
                    NCMT_ProjectTriggerValue.firstRun = true; 
                    update Projupd3;
                    system.assertNotEquals(NULL,Projupd3); 
                
            } 
        
        IF(isClone){                                        
            
                Proj1.Estimate_Type_Proj__c  = 'Definitive Estimating'; 
                Proj1.Project_type__c = strProjectType;
                Proj1.Building_Type__c = strBuildingType;
                Proj1.Name = strProjectName;
                Proj1.State__c = strState;
                Proj1.City__c = strCity;        
                
                Proj1.Location__c = objlocation.Id;                                                                                       
            
                Proj1.Project_Status__c = 'Draft';
                Proj1.Cost_Parameter_Date__c = CostParaDate;
                Proj1.Project_Phases__c ='Construction';
                Proj1.Project_SubPhases__c ='N/A';
                Proj1.Project_Delivery_Method__c= 'IDIQ-JOC';
                Proj1.Markup_Method__c = 'RSMeans - O&P'; 
                Proj1.Purpose_of_Estimate__c = 'Project Controls';
                Proj1.Mid_Point_of_Construction__c = MidPtConst;
                Proj1.Project_Record_ID__c = Proj.id;
                
                insert Proj1;
                system.assertNotEquals(NULL,Proj1); 
            
        }
        
         if(!Test.isRunningTest())   
            Test.stopTest();
        
            
    }
    
    public static void CreateCEWProject(string strProjectType, string strProjectName, string strBuildingType, string strState, string strCity,string strprojphase,string strprojsubphase, string strworkdescnumber,decimal dblsqlft){
            
        Date CostParaDate = date.newinstance(2016, 10, 1);
        /*Integer FY=  system.now().Month() >= 10?  system.now().Year(): system.now().Year()-1;                           
        Date CostParaDate = date.newinstance(FY, 10, 1);*/
        NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
        NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
        NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        insert NCMT_Cust_settings;
                                        
        string strRecordTypeName;
        strRecordTypeName = strBuildingType;
                                        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                      and State__c = :strState and Name = :strCity];
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NCMT_Project__c;
        Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        if(strProjectType == 'New Construction - CEW'){
            strRecordTypeName = 'New Construction - CEW';
        }else{
            strRecordTypeName = 'Repair & Alteration - CEW';
        }
                                             
        NCMT_Project__c Proj = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());
        NCMT_Project__c Projupd = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());

                                         Proj.Estimate_Type_Proj__c  = 'Cost Estimating Workbook';  
                                         Proj.Project_type__c = strProjectType;
                                         Proj.Building_Type__c = strBuildingType;
                                         Proj.Name = strProjectName;
                                         Proj.State__c = strState;
                                         Proj.City__c = strCity;        
                                         
                                         Proj.Location__c = objlocation.Id;
                                         
                                         Date ConstDate = date.newinstance(2025, 1, 1);
                                         Date MidPtConst = date.newInstance(2020, 12, 1);
                                         Date EndConstDate = date.newinstance(2016, 10, 1);
                                                                                  
                                        
                                         Proj.Project_Status__c = 'Draft';
                                         Proj.Cost_Parameter_Date__c = CostParaDate;
                                         Proj.Project_Phases__c =strprojphase;
                                         Proj.Project_SubPhases__c = strprojsubphase;  
                                         Proj.Project_Area_GSF__c = 100000;
                                         Proj.CEW_Project_Funding_Source__c = 'RWA';
                                         Proj.CEW_Occupancy_Status__c = 'Fully Vacated Building';
                                         Proj.Purpose_of_Estimate__c = 'Project Controls';
                                         Proj.Mid_Point_of_Construction__c = MidPtConst;
                                         
                                         insert Proj;
                                         system.assertNotEquals(NULL,Proj); 
                   
                   
                   NCMT_Project_Cost_Summary__c pcs = [SELECT Id, Name FROM NCMT_Project_Cost_Summary__c
                                                        WHERE Project_Name__c =: proj.Id LIMIT 1];
        
                    
                    //CEW Project Agency
                    NCMT_CEW_Project_Agency__c projagency = new NCMT_CEW_Project_Agency__c();
                    projagency.NCMT_Project__c = proj.Id;
                    projagency.Agency_Tier__c = '1';
                    insert projagency;
                    system.assertNotEquals(NULL,projagency);
        
                    //CEW Work Description
                    NCMT_Work_Description__c workdesc = new NCMT_Work_Description__c();
                    workdesc.NCMT_Project__c = proj.Id;
                    workdesc.Number__c = strworkdescnumber; 
                    if(strworkdescnumber !='7'){
                            workdesc.UOM__c = 'USF Area';
                    }else{
                            workdesc.UOM__c = 'Protection Level (I to IV)';
                        }    
        
                    insert workdesc;
                    system.assertNotEquals(NULL,workdesc);
        
                   //CEW work items to save
                    NCMT_CEW_Work_Item__c workitem = new NCMT_CEW_Work_Item__c();
                    workitem.Project_Cost_Summary__c = pcs.Id;
                    workitem.NCMT_CEW_Work_Description__c = workdesc.Id;
                    workitem.CEW_Project_Agency__c = projagency.Id;
                    workitem.WorkDescNumber__c = integer.valueOf(strworkdescnumber);
                    workitem.SQ_Ft__c =dblsqlft;
                    workitem.Unit_Rate__c = 60;
                    
        
                    insert workitem;
                    system.assertNotEquals(NULL,workitem);
        
        Test.startTest();
                    //update Project
                    NCMT_ProjectTriggerValue.firstRun = true;
                    Projupd.id = Proj.id;
                    Projupd.Project_type__c = strProjectType;
                    Projupd.Include_Exclude_AIA__c = true;
                    Projupd.Phasing_Plan_Construction__c = '4';  
                    NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
                    NCMT_ProjectTriggerValue.firstRun = true;
                    update Projupd;
                    system.assertNotEquals(NULL,Projupd);
                                        
                    //update Work Item
                    NCMT_CEW_Work_Item__c WorkItemupd = new NCMT_CEW_Work_Item__c();
                    WorkItemupd.id = workitem.id;
                    if(strworkdescnumber=='6'){
                        workitem.Unit_Rate__c = 900;
                    }else if(strworkdescnumber=='7'){
                        workitem.Unit_Rate__c = 800;
                    }else{
                        workitem.Unit_Rate__c = 700;
                    }
        
                    update WorkItemupd;
                    system.assertNotEquals(NULL,WorkItemupd); 
    
                    //update work desc
                    NCMT_Work_Description__c workdescupd = new NCMT_Work_Description__c();
                    workdescupd.id = workdesc.id; 
                    workdescupd.Number__c = '2';   
                    workdescupd.UOM__c = 'Affected Area - GSF';
        
                    update workdescupd;
                    system.assertNotEquals(NULL,workdescupd);
        
                    Delete workitem;
                    system.assertNotEquals(NULL,workitem);                    
        Test.stopTest();
    }
    
    
    public static void CreateProject(string strProjectType, string strProjectName, string strBuildingType, string strState, string strCity, string strBuilding_Cost_Type, string strBuilding_Heigtht, string strBuilding_Quality, 
                                     string strLevel_of_Protection, string strRemoteness, 
                                     boolean blnGross_Area, boolean blnUseable_Area, boolean blnHousing_Plan, boolean blnEnteredUSF,
                                     Decimal dblTotal_Area_Including_Parking, Decimal dblPercentage_of_Tenant_Area_Unfinished, Decimal dblParking_Within_Building_Structure, Decimal dblAbove_Ground,
                                     boolean blnOtherCost, boolean blnProjectP100, boolean blnPLPupdate, boolean blnEscalation, boolean blnNCMTreports, boolean blnBLDGMass,
                                     boolean blnOverrideAtrium) {
                                      
        Date CostParaDate = date.newinstance(2016, 10, 1);
       /*Integer FY=  system.now().Month() >= 10?  system.now().Year(): system.now().Year()-1;                           
        Date CostParaDate = date.newinstance(FY, 10, 1);*/
        NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
        NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
        NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        insert NCMT_Cust_settings;
        
        string strRecordTypeName;
        strRecordTypeName = strBuildingType;
        string strBLDGHeightRecordTypeID = Schema.SObjectType.NCMT_Building_Height_Parameter__c.getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId();
        if (strBuildingType == 'Laboratory: Dry' || strBuildingType == 'Laboratory: Wet') {
            strRecordTypeName = 'Laboratory';
        }    
        string strBLDGRecordTypeID = Schema.SObjectType.NCMT_Building_Parameter__c.getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId(); 
        
        
        for(NCMT_Building_Parameter__c BLDG: lstbuilding)
        {
            BLDG.Recordtypeid = strBLDGRecordTypeID;
        }         
        
        for(NCMT_Building_Height_Parameter__c BLDGHeight: lstbldgheight )
        { 
            BLDGHeight.Recordtypeid = strBLDGHeightRecordTypeID ; 
        }          
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                and State__c = :strState and Name = :strCity];
        

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NCMT_Project__c; 
        Schema.DescribeSObjectResult cfrSchemaDS = Schema.SObjectType.NCMT_DES_Items__c; 
        Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> DESItemInfo = cfrSchemaDS.getRecordTypeInfosByName();
        
        if(strProjectType == 'New Construction' && strBuildingType != 'Parking Garage' && strBuildingType != 'LPOE' && strBuildingType != 'Utility' 
        && strBuildingType != 'Data Center' && strBuildingType != 'Medical Office' && strBuildingType != 'Medical Clinic')  
            strRecordTypeName = 'New Construction';
        else if(strProjectType == 'Repair & Alteration - Parametric Entry')
            strRecordTypeName ='Repair & Alteration - Parametric Entry';
        else if(strProjectType == 'Repair & Alteration - Work Item Detail')
            strRecordTypeName ='Repair & Alteration - Work Item Detail';
        else if(strProjectType == 'New Construction' && strBuildingType == 'Parking Garage')
            strRecordTypeName ='Parking Garage';  
        else if(strProjectType == 'New Construction' && strBuildingType == 'LPOE')
            strRecordTypeName ='LPOE';
        else if(strProjectType == 'New Construction' && strBuildingType == 'Utility')
            strRecordTypeName ='Utility';
        else if(strProjectType == 'New Construction' && strBuildingType == 'Data Center')
            strRecordTypeName ='Data Center'; 
        else if(strProjectType == 'New Construction' && (strBuildingType == 'Medical Office' || strBuildingType == 'Medical Clinic'))
            strRecordTypeName ='Medical Office';
        else if(strProjectType == 'New Construction - DES')
            strRecordTypeName = 'New Construction - DES';
        
        NCMT_Project__c Proj = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());
        NCMT_Project__c Projupd = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());
        NCMT_Project__c Projupd2 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());       
        
        IF(strProjectType == 'New Construction - DES'){
            Proj.Estimate_Type_Proj__c  = 'Definitive Estimating';
        }else if(strProjectType == 'Repair & Alteration - Work Item Detail'){
            Proj.Estimate_Type_Proj__c  ='Work Item - Repair & Alteration';
        }else if(strProjectType == 'Repair & Alteration - Parametric Entry'){
            Proj.Estimate_Type_Proj__c  ='Parametric - Repair & Alteration';
        }else{
            Proj.Estimate_Type_Proj__c  ='Parametric';
        }
        
        Proj.Project_type__c = strProjectType;
        Proj.Building_Type__c = strBuildingType;
        Proj.Name = strProjectName;
        Proj.State__c = strState;
        Proj.City__c = strCity;        
        
        Proj.Location__c = objlocation.Id;
        
        Date ConstDate = date.newinstance(2025, 1, 1);
        Date MidPtConst = date.newInstance(2020, 12, 1);
        Date EndConstDate = date.newinstance(2016, 10, 1);
        if (blnEnteredUSF == false) {
            Proj.Start_Construction__c = ConstDate;
        }
        else {
            Proj.End_Construction__c = EndConstDate;
        }
        
        Proj.Building_Cost_Type__c = strBuilding_Cost_Type;
        Proj.Building_Heigtht__c = strBuilding_Heigtht;
        Proj.Level_of_Protection__c = strLevel_of_Protection;
        Proj.Building_Quality__c = strBuilding_Quality;
        Proj.Remoteness__c = strRemoteness;
        Proj.Gross_Area__c = blnGross_Area;
        Proj.Useable_Area__c = blnUseable_Area;
        Proj.Housing_Plan__c = blnHousing_Plan;
        if (blnGross_Area == true || blnUseable_Area == true) {
            Proj.Total_Area_Including_Parking__c = dblTotal_Area_Including_Parking;
        }
        Proj.Percentage_of_Tenant_Area_Unfinished__c = dblPercentage_of_Tenant_Area_Unfinished;
        Proj.Parking_Within_Building_Structure__c = dblParking_Within_Building_Structure;
        Proj.Stand_alone_Parking_Garage__c = 0;
        Proj.Surface_Parking__c = 0;
        Proj.Project_Status__c = 'Draft';
        Proj.Cost_Parameter_Date__c = CostParaDate;
        IF(Proj.Estimate_Type_Proj__c  == 'Definitive Estimating'){
            Proj.Project_Phases__c ='Design';
            Proj.Project_SubPhases__c = 'Design Development Draft';
        }
        Proj.Project_Delivery_Method__c= 'TI - Leasing';
        Proj.Markup_Method__c = 'GSA Markups';
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        Proj.Mid_Point_of_Construction__c = MidPtConst;
        
        insert Proj;
        system.assertNotEquals(NULL,Proj);                                         

                                                
        if (blnOverrideAtrium == true && blnNCMTreports == true) {
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            NCMT_Housing_Plan_Summary__c HousingPlanSummary2 = new NCMT_Housing_Plan_Summary__c (id = null);
            HousingPlanSummary2 =  [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :Proj.id];
            
            HousingPlanSummary2.Main_Lobby__c = 600;
            
            update HousingPlanSummary2;
            system.assertNotEquals(NULL,HousingPlanSummary2);  
            
            if (strBuilding_Cost_Type == 'TI Retrofit') {
                Test.startTest();
                NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
                NCMT_ProjectTriggerValue.firstRun = true;
                NCMT_Project__c ProjTI = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());
                NCMT_ProjectTriggerValue.firstRun = true;
                ProjTI.Id = Proj.id;
                ProjTI.Total_Area_Including_Parking__c = 1000100;
                update ProjTI;
                system.assertNotEquals(NULL,ProjTI); 
                Test.stopTest();
            }    
        }
        
        if (blnOverrideAtrium == true && blnNCMTreports == false) {
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            Projupd.Project_type__c = strProjectType;
            Projupd.Id = Proj.id;
            Projupd.City__c = 'San Jose';
            update Projupd;
            system.assertNotEquals(NULL,Projupd); 
            
            NCMT_Housing_Plan_Summary__c HousingPlanSummary2 = new NCMT_Housing_Plan_Summary__c (id = null);
            HousingPlanSummary2 =  [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :Proj.id];
            
            HousingPlanSummary2.Atrium_upper_levels_phantom_floors__c = 1;
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update HousingPlanSummary2;
            system.assertNotEquals(NULL,HousingPlanSummary2);  
        }
        
        if (blnEscalation == true) {    
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;

            //insert Escalation
            NCMT_Escalation__c ESC = new NCMT_Escalation__c (id = null);
            NCMT_Escalation__c ESCupd = new NCMT_Escalation__c (id = null);
            
            ESC.Project__c   = Proj.id;
            ESC.Escalation_Type__c = 'Market Escalation';
            ESC.Duration__c = 12;
            ESC.Yearly_Escalation__c = 4;
            ESC.FY__c = '2016';
            ESC.Escalation_Percentage__c = 3;
            
            insert ESC;
            system.assertNotEquals(NULL,ESC);
            //update Escalation
            ESCupd.id = ESC.id;
            ESCupd.Duration__c = 20;

            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update ESCupd;
            system.assertNotEquals(NULL,ESCupd);
            
             
            //insert LEED
            Schema.DescribeSObjectResult cfrSchemaLEED = Schema.SObjectType.NCMT_LEED_Checklist__c; 
            Map<String,Schema.RecordTypeInfo> LEEDTypeInfo = cfrSchemaLEED.getRecordTypeInfosByName();
            
            NCMT_LEED_Checklist__c LEED = new NCMT_LEED_Checklist__c (id = null, recordtypeid = LEEDTypeInfo.get('LEED Checklist').getRecordTypeId());
            LEED.Project__c = Proj.id;
            LEED.Prerequisite_1__c = true;
            LEED.Prerequisite_2__c = true;
            LEED.Prerequisite_3__c = true;
            LEED.Prerequisite_4__c = true;
            LEED.Prerequisite_5__c = true;
            LEED.Prerequisite_6__c = true;
            LEED.Prerequisite_7__c = true;
            LEED.Prerequisite_8__c = true;
            LEED.Prerequisite_9__c = true;
            LEED.Prerequisite_10__c = true;
            LEED.Prerequisite_11__c = true;
            LEED.Prerequisite_12__c = true;

            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            insert LEED;
            system.assertNotEquals(NULL,LEED);
            //update LEED
            NCMT_LEED_Checklist__c LEEDupd = new NCMT_LEED_Checklist__c (id = null, recordtypeid = LEEDTypeInfo.get('LEED Checklist').getRecordTypeId());
            LEEDupd.Id = LEED.id;
            LEEDupd.LEED_USR_Mod_IP_1__c = 1;
            LEEDupd.LEED_USR_Mod_LT_1__c  = 8;
            LEEDupd.LEED_USR_Mod_LT_2__c = 1;
            LEEDupd.LEED_USR_Mod_LT_3__c = 2;
            LEEDupd.LEED_USR_Mod_LT_4__c = 5;
            LEEDupd.LEED_USR_Mod_LT_5__c  = 5;
            LEEDupd.LEED_USR_Mod_LT_6__c = 1;
            LEEDupd.LEED_USR_Mod_LT_7__c = 1;
            LEEDupd.LEED_USR_Mod_LT_8__c = 1;
            LEEDupd.LEED_USR_Mod_SS_1__c  = 1;
            LEEDupd.LEED_USR_Mod_SS_2__c = 2;
            LEEDupd.LEED_USR_Mod_SS_3__c = 1;
            LEEDupd.LEED_USR_Mod_SS_4__c = 2;
            LEEDupd.LEED_USR_Mod_SS_5__c = 2;
            LEEDupd.LEED_USR_Mod_SS_6__c = 1;
            LEEDupd.LEED_USR_Mod_WE_1__c = 2;
            LEEDupd.LEED_USR_Mod_WE_2__c  = 3;
            LEEDupd.LEED_USR_Mod_WE_4__c  = 1;
            LEEDupd.LEED_USR_Mod_EA_1__c  = 3;
            LEEDupd.LEED_USR_Mod_EA_2__c  = 3;
            LEEDupd.LEED_USR_Mod_EA_3__c = 1;
            LEEDupd.LEED_USR_Mod_EA_4__c = 2;
            LEEDupd.LEED_USR_Mod_EA_5__c =  3;
            LEEDupd.LEED_USR_Mod_EA_6__c =  1;
            LEEDupd.LEED_USR_Mod_EA_7__c =  2;
            LEEDupd.LEED_USR_Mod_MR_1__c =  5;
            LEEDupd.LEED_USR_Mod_MR_2__c =  2;
            LEEDupd.LEED_USR_Mod_MR_3__c =  2;
            LEEDupd.LEED_USR_Mod_MR_4__c =  2;
            LEEDupd.LEED_USR_Mod_MR_5__c =  2;
            LEEDupd.LEED_USR_Mod_IEQ_1__c = 2;
            LEEDupd.LEED_USR_Mod_IEQ_2__c = 3;
            LEEDupd.LEED_USR_Mod_IEQ_3__c = 1;
            LEEDupd.LEED_USR_Mod_IEQ_4__c = 2;
            LEEDupd.LEED_USR_Mod_IEQ_5__c = 1;
            LEEDupd.LEED_USR_Mod_IEQ_6__c = 2;
            LEEDupd.LEED_USR_Mod_IEQ_7__c = 3;
            LEEDupd.LEED_USR_Mod_IEQ_8__c = 1;
            LEEDupd.LEED_USR_Mod_IEQ_9__c = 1;
            LEEDupd.LEED_USR_Mod_Innovation_1__c =  5;
            LEEDupd.LEED_USR_Mod_Innovation_2__c =  1;
            LEEDupd.LEED_USR_Mod_RP_1__c =  4;
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update LEEDupd;
            system.assertNotEquals(NULL,LEEDupd);
            
            Delete LEEDupd;
            system.assertNotEquals(NULL,LEEDupd);
            
            //update project
            //Test.startTest();
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            TriggerValue.isupdate = true;
            TriggerValue.isupdate1 = true;
            Projupd.Project_type__c = strProjectType;
            Projupd.Id = Proj.id;
            Projupd.Gross_Area__c = false;
            Projupd.Useable_Area__c = true;  
            Projupd.Total_Area_Including_Parking__c = 2000000;
            Proj.Building_Cost_Type__c = 'TI Retrofit';
            
            update Projupd;
            system.assertNotEquals(NULL,Projupd);   
            Test.stopTest();   
        }
        
        if (blnPLPupdate == true) {
            
            Schema.DescribeSObjectResult cfrSchemaPLP = Schema.SObjectType.Project_Level_Parameter__c; 
            Map<String,Schema.RecordTypeInfo> PLPTypeInfo = cfrSchemaPLP.getRecordTypeInfosByName();
            
            Project_Level_Parameter__c PLP = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Other Building Use').getRecordTypeId());
            Project_Level_Parameter__c PLPupd = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Other Building Use').getRecordTypeId());
            
            PLP =  [SELECT Id, Foot_Print_Area__c, Massing_Override_Comments__c, Structure_Override_Comments__c, Typical_Bay_Size_A__c, Interior_Override_Comments__c, Int_Const_Core_Shell_Partition_ratio__c, 
                    MEP_Override_Comments__c, Electrical_Load__c, Vertical_Transportation_Override_Comment__c, Vertical_Conveyance_Escalators_Pairs__c,
                    Cladding_Override_Comments__c, Cladding_Skin_Ratio__c
                    FROM Project_Level_Parameter__c WHERE NCMT_Project__c = :Proj.id];
            
            Test.startTest();
            TriggerValue.isupdate = false;
            TriggerValue.isupdate1 = true;
            //TriggerValue.isInsertPT = false;
            PLP.Use_Level_of_Protection__c = strLevel_of_Protection;
            PLP.Use_Blast_Resistance__c = strLevel_of_Protection;
            //PLP.Foot_Print_Area__c = 10000;
            PLP.Massing_Override_Comments__c = 'test';
            PLP.Typical_Bay_Size_A__c = 40;
            PLP.Structure_Override_Comments__c = 'test';
            PLP.Int_Const_Core_Shell_Partition_ratio__c = 0.05;      
            PLP.Interior_Override_Comments__c = 'test';
            PLP.Electrical_Load__c = 12;      
            PLP.MEP_Override_Comments__c = 'test';
            PLP.Vertical_Conveyance_Escalators_Pairs__c = 0.1;
            PLP.Vertical_Transportation_Override_Comment__c = 'test';
            PLP.Cladding_Skin_Ratio__c = 0.5;
            PLP.Cladding_Override_Comments__c = 'test'; 
            update PLP;      
            
            system.assertNotEquals(NULL,PLP);
            
            PLPupd.Id = PLP.Id;
            TriggerValue.isupdate = true;
            TriggerValue.isupdate1 = true;
            //TriggerValue.isInsertPT = false;
            //PLPupd.Foot_Print_Area__c = 600000;
            PLPupd.Massing_Override_Comments__c = 'test';
            PLPupd.Typical_Bay_Size_A__c = 40;
            
            update PLPupd;
            system.assertNotEquals(NULL,PLPupd);
            Test.stopTest(); 
        }
        
        if (blnBLDGMass == true) {
            
            Schema.DescribeSObjectResult cfrSchemaPLP = Schema.SObjectType.Project_Level_Parameter__c; 
            Map<String,Schema.RecordTypeInfo> PLPTypeInfo = cfrSchemaPLP.getRecordTypeInfosByName();
            
            Project_Level_Parameter__c PLP = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Other Building Use').getRecordTypeId());
            NCMT_Building_Massing_By_Floor__c BldgMassFloor = new NCMT_Building_Massing_By_Floor__c();
            
            PLP = [select Id from Project_Level_Parameter__c WHERE NCMT_Project__c = :Proj.id];
            
            BldgMassFloor = [select Id, Use_Area_SF__c from NCMT_Building_Massing_By_Floor__c where Proj_Level_Parameter__c = :PLP.Id and Building_Massing_Area__c = 'Ground SF'];
            System.debug('BldgMassFloor.Use_Area_SF__c ================ ' +BldgMassFloor.Use_Area_SF__c);
            Test.startTest();
            TriggerValue.firstRun = true;
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            TriggerValue.isUpdate1 = false;
            BldgMassFloor.Use_Area_SF__c = 1000;
            update BldgMassFloor;
            system.assertNotEquals(NULL,BldgMassFloor);
            Test.stopTest(); 
        }
        
        if (blnHousing_Plan == true) {
            
            Schema.DescribeSObjectResult cfrSchemaHP = Schema.SObjectType.NCMT_Housing_Plan__c; 
            Map<String,Schema.RecordTypeInfo> HousingPlanTypeInfo = cfrSchemaHP.getRecordTypeInfosByName();
            
            NCMT_Housing_Plan__c HousingPlan = new NCMT_Housing_Plan__c (id = null, recordtypeid = HousingPlanTypeInfo.get('User Defined').getRecordTypeId());
            //NCMT_Housing_Plan__c HousingPlanupd = new NCMT_Housing_Plan__c (id = null, recordtypeid = HousingPlanTypeInfo.get('User Defined').getRecordTypeId());
            
            HousingPlan.Project__c = Proj.id ;
            HousingPlan.Housing_Plan_Type__c = 'New Fit Out';
            if (blnEnteredUSF == false) {
                if (strBuilding_Cost_Type == 'Core/Shell only') {
                    HousingPlan.Workstations_open_office_Count__c = 30;
                    HousingPlan.X20_or_more_person_rooms_Count__c = 3;
                    HousingPlan.Closed_offices_Count__c  = Null;
                    HousingPlan.Private_toilets_Count__c = Null;
                    HousingPlan.X8_20_person_rooms_Count__c = Null;
                    HousingPlan.Teleconference_Count__c = Null;
                    HousingPlan.Auditorium_sloped_floor_Count__c = Null;
                    HousingPlan.Child_care_Count__c = Null;
                    HousingPlan.Libraries_Count__c = Null;
                    HousingPlan.ADP_high_density_PC_s_Count__c = Null;
                    HousingPlan.Courtroom_district_Ceremonial_Count__c= Null;
                    HousingPlan.Courtroom_district_Standard_Count__c= Null;
                    HousingPlan.Courtroom_Bankruptcy_Count__c= Null;
                    HousingPlan.Courtroom_Magistrate_Count__c= Null;
                    HousingPlan.Grand_Jury_Room_Count__c= Null;
                    HousingPlan.Judicial_hearing_Count__c= Null;
                    HousingPlan.Judicial_chambers_Count__c= Null;
                    HousingPlan.Holding_cell_Central_Count__c= Null;
                    HousingPlan.Holding_cell_Court_floors_Count__c= Null;
                    HousingPlan.Unfinished_Shell_Area_Use_USF__c= Null;
                    HousingPlan.General_storage_Use_USF__c= Null;
                    HousingPlan.High_density_storage_Use_USF__c= Null;
                    HousingPlan.Clinics_health_units_Use_USF__c= Null;
                    HousingPlan.Physical_fitness_Use_USF__c= Null;
                    HousingPlan.ADP_mainframe_Use_USF__c= Null;
                    HousingPlan.Joint_use_retail_Use_USF__c= Null;
                    HousingPlan.Food_service_cafeteria_Use_USF__c= Null;
                    HousingPlan.Climate_controlled_for_artifacts_Use_USF__c= Null;
                    HousingPlan.Non_climate_controlled_Use_USF__c= Null;
                    HousingPlan.Laboratory_Dry_electronic_Use_USF__c= Null;
                    HousingPlan.Laboratory_Wet_chemistry_Use_USF__c= Null;
                    HousingPlan.Firing_range_Use_USF__c= Null;
                    HousingPlan.Copy_Center_Use_USF__c= Null;
                    HousingPlan.Credit_Union_Use_USF__c= Null;
                    HousingPlan.Transaction_counter_space_Use_USF__c= Null;
                    HousingPlan.Kitchen_Break_room_Use_USF__c= Null;
                    HousingPlan.Locker_Shower_room_Use_USF__c= Null;
                    HousingPlan.Hardened_offices_suites_Use_USF__c= Null;
                    HousingPlan.Secure_Work_Environment_SWE_Std_Use_USF__c= Null;
                    HousingPlan.Secure_Work_Environment_SWE_Enhd_UseUSF__c= Null;
                    HousingPlan.Secured_Storage_SCIF_Standard_Use_USF__c= Null;
                    HousingPlan.Secured_Storage_SCIF_Enhanced_Use_USF__c= Null;
                    HousingPlan.Vault_Type_Storage_Use_USF__c= Null;
                    HousingPlan.Interview_Detention_Use_USF__c= Null;
                    HousingPlan.Non_Marshal_Holding_Cell_Single_Use_USF__c= Null;
                    HousingPlan.Non_Marshal_Holding_Cell_Double_Use_USF__c= Null;
                    HousingPlan.Enhanced_office_Use_USF__c= Null;
                    HousingPlan.USMS_Suite_Administration_Use_USF__c= Null;
                    HousingPlan.USMS_Suite_Operations_Use_USF__c= Null;
                    HousingPlan.Sally_Port_Use_USF__c= Null;
                    HousingPlan.Light_industrial_Use_USF__c= Null;
                    HousingPlan.Warehouse_Use_USF__c= Null;
                    HousingPlan.VA_Intake_Use_USF__c= Null;
                    HousingPlan.VA_Exam_Suite_Use_USF__c= Null;
                    HousingPlan.VA_Radiology_Use_USF__c= Null;
                    HousingPlan.VA_Ambulatory_Surgery_Use_USF__c= Null;
                    HousingPlan.VA_Infusion_Use_USF__c= Null;
                    HousingPlan.VA_Pharmacy_Use_USF__c= Null;
                    HousingPlan.Data_Center_Use_USF__c= Null;
                }
                else if (strBuilding_Cost_Type == 'TI Only') {
                    HousingPlan.Workstations_open_office_Count__c = NULL;
                    HousingPlan.X20_or_more_person_rooms_Count__c = NULL;
                    HousingPlan.Private_toilets_Count__c =40;
                    HousingPlan.X8_20_person_rooms_Count__c = 5;
                }
                else if (strBuilding_Cost_Type == 'TI Retrofit') {
                    HousingPlan.Workstations_open_office_Count__c = 900;
                    HousingPlan.X20_or_more_person_rooms_Count__c = 3;
                }
                else if (strBuilding_Cost_Type == 'TI Including Warm Lit Shell') {
                    HousingPlan.Workstations_open_office_Count__c = 1500;
                    HousingPlan.X20_or_more_person_rooms_Count__c = 3;
                }
                else {
                    HousingPlan.Workstations_open_office_Count__c = 110;
                    HousingPlan.X20_or_more_person_rooms_Count__c = 3;
                }
                HousingPlan.User_Defined_Spaces1_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces2_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces3_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces1_Description__c = 't1';
                HousingPlan.User_Defined_Spaces2_Description__c = 't1';
                HousingPlan.User_Defined_Spaces3_Description__c = 't1';
            }
            else {
                HousingPlan.Workstations_open_office_Entered_USF__c = 100000;
                HousingPlan.Closed_offices_Entered_USF__c = 100000;
                HousingPlan.Private_toilets_Entered_USF__c = 100000;
                HousingPlan.X8_20_person_rooms_Entered_USF__c = 100000;
                HousingPlan.X20_or_more_person_rooms_Entered_USF__c = 100000;
                HousingPlan.Teleconference_Entered_USF__c = 100000;
                HousingPlan.Auditorium_sloped_floor_Entered_USF__c = 100000;
                HousingPlan.Child_care_Entered_USF__c = 100000;
                HousingPlan.Libraries_Entered_USF__c = 100000;
                HousingPlan.ADP_high_density_PC_s_Entered_USF__c = 100000;
                HousingPlan.Courtroom_district_CeremonialEntered_USF__c = 100000;
                HousingPlan.Courtroom_district_Standard_Entered_USF__c = 100000;
                HousingPlan.Courtroom_Bankruptcy_Entered_USF__c = 100000;
                HousingPlan.Courtroom_Magistrate_Entered_USF__c = 100000;
                HousingPlan.Grand_Jury_Room_Entered_USF__c = 100000;
                HousingPlan.Judicial_hearing_Entered_USF__c = 100000;
                HousingPlan.Judicial_chambers_Entered_USF__c = 100000;
                HousingPlan.Holding_cell_Central_Entered_USF__c = 100000;
                HousingPlan.Holding_cell_Court_floors_Entered_USF__c = 100000;   
                HousingPlan.User_Defined_Spaces1_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces2_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces3_Use_USF__c = 100;
                HousingPlan.User_Defined_Spaces1_Description__c = 't1';
                HousingPlan.User_Defined_Spaces2_Description__c = 't1';
                HousingPlan.User_Defined_Spaces3_Description__c = 't1';         
            }        
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            insert HousingPlan;
            system.assertNotEquals(NULL,HousingPlan); 
            /*
            Test.startTest();
            
            Date ConstDate2 = date.newinstance(2030, 1, 1);
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            Projupd.Id = Proj.id;
            if (strBuilding_Cost_Type == 'Core/Shell only') {
                Projupd.Start_Construction__c = null;
                Projupd.End_Construction__c = ConstDate2;
                Proj.Building_Cost_Type__c = 'TI Retrofit';
            }
            else {
                Projupd.Set_Aside_100__c = true;
                Projupd.Start_Construction__c = ConstDate2;
                Projupd.End_Construction__c = null;
                Proj.Building_Cost_Type__c = 'Core/Shell only';
            }  
            
            update Projupd;
            system.assertNotEquals(NULL,Projupd);
            
            if (blnEnteredUSF == true) {
                
                if (strBuilding_Cost_Type == 'Core/Shell with TI') {
                    
                    NCMT_Housing_Plan_Summary__c HousingPlanSummary = new NCMT_Housing_Plan_Summary__c (id = null);
                    HousingPlanSummary =  [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :Proj.id];
                    
                    HousingPlanSummary.Override_RSF__c = 1990000;
                    
                    NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
                    NCMT_ProjectTriggerValue.firstRun = true;
                    update HousingPlanSummary;
                    system.assertNotEquals(NULL,HousingPlanSummary);
                }
                
                else if (strBuilding_Cost_Type == 'Core/Shell only') {
                    NCMT_Housing_Plan_Summary__c HousingPlanSummary = new NCMT_Housing_Plan_Summary__c (id = null);
                    HousingPlanSummary =  [SELECT Id FROM NCMT_Housing_Plan_Summary__c WHERE Project__c = :Proj.id];
                    
                    HousingPlanSummary.Override_RSF__c = 2370001;
                    
                    NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
                    NCMT_ProjectTriggerValue.firstRun = true;
                    update HousingPlanSummary;
                    system.assertNotEquals(NULL,HousingPlanSummary);
                    
                }
            }  
            
            Test.stopTest();     
            */     
        }
        if (blnOtherCost == true) {
            Test.startTest();
            Schema.DescribeSObjectResult cfrSchemaOC = Schema.SObjectType.NCMT_Other_Cost__c; 
            Map<String,Schema.RecordTypeInfo> OtherCostsTypeInfo = cfrSchemaOC.getRecordTypeInfosByName();
            
            NCMT_Other_Cost__c OtherCost = new NCMT_Other_Cost__c (id=null, recordtypeid = OtherCostsTypeInfo.get('Other Facilities - Other Direct Cost').getRecordTypeId());
            NCMT_Other_Cost__c OtherCost2 = new NCMT_Other_Cost__c (id=null, recordtypeid = OtherCostsTypeInfo.get('Other Facilities - Other Cost').getRecordTypeId());
            NCMT_Other_Cost__c OtherCost3 = new NCMT_Other_Cost__c (id=null, recordtypeid = OtherCostsTypeInfo.get('Other Facilities - Other Cost').getRecordTypeId());
            List<NCMT_Other_Cost__c> otherCosts = new List<NCMT_Other_Cost__c>();

            OtherCost.NCMT_Project__c = Proj.id ;
            OtherCost.Cost_Description__c = 'Core/Shell Cost';
            OtherCost.Cost_Type__c = 'Direct Costs';
            OtherCost.Cost_Based_on__c = 'Gross Area';
            OtherCost.Unit_Rate__c = 2;
            OtherCost.Basis_of_Estimate__c = 'test';  
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;        
            otherCosts.add(OtherCost);
            
            
            OtherCost2.NCMT_Project__c = Proj.id ;
            OtherCost2.Cost_Description__c = 'Core/Shell Cost';
            OtherCost2.Cost_Type__c = 'Project Costs';
            OtherCost2.Cost_Based_on__c = 'Gross Area';
            OtherCost2.Unit_Rate__c = 2;
            OtherCost2.Basis_of_Estimate__c = 'test2';   
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;       
            otherCosts.add(OtherCost2);
                   
            
            OtherCost3.NCMT_Project__c = Proj.id ;
            OtherCost3.Cost_Description__c = 'N/A';
            OtherCost3.Cost_Type__c = 'Site Acquisition Cost';
            OtherCost3.Cost_Based_on__c = 'Other';
            OtherCost3.Other_Area__c = 20000;
            OtherCost3.Unit_Rate__c = 100;
            OtherCost3.Basis_of_Estimate__c = 'test3';  
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;        
            otherCosts.add(OtherCost3);
             
            insert otherCosts;
            system.assertNotEquals(NULL,OtherCost); 
            system.assertNotEquals(NULL,OtherCost2);
            system.assertNotEquals(NULL,OtherCost3);
            
            OtherCost3.Unit_Rate__c = 200;
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            update OtherCost3;
            system.assertNotEquals(NULL,OtherCost3); 
            
            Test.stopTest();
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            delete OtherCost2;
            system.assertNotEquals(NULL,OtherCost2);
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            delete Proj;
            system.assertNotEquals(NULL,Proj);
        }
        if (blnProjectP100 == true) {
            //Test.startTest();
            
            NCMT_Project_P100_Data__c P100 = new NCMT_Project_P100_Data__c (id=null);
            
            P100.Project__c = Proj.id;
            P100.SiteUsesExistingInfrastructure_Resources__c = 'P100: Tier 3';
            P100.SiteTransitUseReduced_Automobile_commute__c = 'P100: Tier 3';
            P100.Site_Neighbor_Connect_Walk_Bike__c = 'P100: Tier 3';
            P100.Energy_30_40_50_NZE__c = 'P100: Tier 3';
            P100.Fossil_Fuel_65_80_90_NZC__c = 'P100: Tier 3';
            P100.Seismic_Performance__c = 'P100: Tier 3';
            P100.Flood_Resistance__c = 'P100: Tier 3';
            P100.Wind__c = 'P100: Tier 3';
            P100.Service_Life__c = 'P100: Tier 3';
            P100.Enclosure_Performance__c = 'P100: Tier 3';
            P100.Roofing__c = 'P100: Tier 3';
            P100.Interior_Performance__c = 'P100: Tier 3';
            P100.Mechanical__c = 'P100: Tier 3';
            P100.Lighting_Quality__c = 'P100: Tier 3';
            P100.Electrical_overall_quality_power_quality__c = 'P100: Tier 3';
            P100.Landscape_Performance__c = 'P100: Tier 3';
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            insert P100;
            system.assertNotEquals(NULL,P100); 
            
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = true;
            NCMT_ProjectTriggerValue.firstRun = true;
            Delete P100;
            system.assertNotEquals(NULL,P100);
            
        }
        
        if (blnNCMTreports == true && blnOverrideAtrium == false) {
            Test.startTest();
            
            //PageReference pageRef = Page.NCMT_UniformatCostOutput;
            //Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().put('ProjectID', Proj.id);
            
            NCMT_ReportData objTest = new NCMT_ReportData();
            objTest.DatasetProjectCostSummaryGrouped(Proj.id);
            objTest.getProjectInformation();
            objTest.getDatasetProjectCostSummary();  
            objTest.getDatasetHousingPlan();   
            objTest.getCoreShellData();      
            
            NCMT_ReportsLandingPage objRptTest = new NCMT_ReportsLandingPage();
            
            objRptTest.getProjectReports();
            objRptTest.getProjectLookUpReports();
            objRptTest.getRegionalReports();
            objRptTest.getRegions();
            objRptTest.getCurrentFY();
            objRptTest.getFiscalYears();
            objRptTest.getUserRegionValue();
            objRptTest.setUserRegionValue('1');           
            
            Test.stopTest(); 
        } 
    }
}