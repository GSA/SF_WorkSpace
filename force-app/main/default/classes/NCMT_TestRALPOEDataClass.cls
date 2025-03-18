@isTest(seeAllData = False)
public with sharing class NCMT_TestRALPOEDataClass {
    
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
    
    static List <NCMT_RA_Mods__c> lstNCMT_RA_Mods = Test.loadData(NCMT_RA_Mods__c.sObjectType, 'NCMT_RA_Mods');
    
    static List <NCMT_RA_Overhead_Analysis__c> lstNCMT_RA_Overhead_Analysis = Test.loadData(NCMT_RA_Overhead_Analysis__c.sObjectType, 'NCMT_RA_Overhead_Analysis');
    
    static List <NCMT_RA_Quality_Code_Lookup__c> lstNCMT_RA_Quality_Code_Lookup = Test.loadData(NCMT_RA_Quality_Code_Lookup__c.sObjectType, 'NCMT_RA_Quality_Code_Lookup');
    
    static List <NCMT_RA_WI_Lookup_Details__c> lstNCMT_RA_WI_Lookup_Details = Test.loadData(NCMT_RA_WI_Lookup_Details__c.sObjectType, 'NCMT_RA_WI_Lookup_Details');
    
    static List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');     
    
    static List <NCMT_LPOE_Parametric_Cost_Data__c> lstNCMT_LPOE_Parametric_Cost_Data = Test.loadData(NCMT_LPOE_Parametric_Cost_Data__c.sObjectType, 'NCMT_LPOEParametric_Cost_Data');
    
    static List <NCMT_LPOE_Parametric_Default_SpaceLookup__c> lstNCMT_LPOE_Parametric_Default_SpaceLookup = Test.loadData(NCMT_LPOE_Parametric_Default_SpaceLookup__c.sObjectType, 'NCMT_LPOE_Parametric_Default_SpaceLookup');
    
    public static void CreateRAProject(string strProjectType, string strProjectName, string strBuildingType, string strState, string strCity, string strBuilding_Cost_Type, string strBuilding_Heigtht, string strBuilding_Quality, 
                                       string strLevel_of_Protection, string strRemoteness, 
                                       boolean blnGross_Area, boolean blnUseable_Area, boolean blnHousing_Plan, string strHousing_Plan_Type,                               
                                       boolean blnRAWorkItems, string strCategoryDescription, string strRAWILookupDetails, boolean blnupdateProject, string strWorkItemType) {
                                           
                                           Date CostParaDate = date.newinstance(2016, 10, 1);
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
                                           Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
                                           
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
                                           else if(strProjectType == 'New Construction' && strBuildingType == 'Medical Office')
                                               strRecordTypeName ='Medical Office'; 
                                           else if(strProjectType == 'New Construction' && strBuildingType == 'Medical Clinic')
                                               strRecordTypeName ='Medical Office';
                                           
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
                                           Date EndConstDate = date.newinstance(2016, 10, 1);
                                           Proj.Start_Construction__c = ConstDate;
                                           Proj.Building_Cost_Type__c = strBuilding_Cost_Type;
                                           Proj.Building_Heigtht__c = strBuilding_Heigtht;
                                           Proj.Building_Quality__c = strBuilding_Quality;        
                                           Proj.Level_of_Protection__c = strLevel_of_Protection;
                                           Proj.Remoteness__c = strRemoteness;
                                           Proj.Dominant_Period__c = '1940 - 1949';
                                           Proj.Historic_Landmark_Status__c = 'Class 2';
                                           Proj.Overall_Condition__c = 'Good';
                                           if (strProjectType == 'Repair & Alteration - Parametric Entry') 
                                               Proj.RA_Estimate_Type__c ='Parametric Entry';
                                           else 
                                               Proj.RA_Estimate_Type__c ='Work Item Detail';
                                           
                                           Proj.Gross_Area_Including_Parking__c = 200000;
                                           Proj.Affected_Tenant_Area_USF__c = 10000;
                                           Proj.Total_Site_Area_Building_Footprint_SF__c = 300000;
                                           if (blnHousing_Plan == false) {
                                               Proj.Housing_Plan__c = false;
                                               Proj.Default_Housing_Plan__c = true;            
                                               Proj.Default_Housing_Plan_Entry_Type__c = strHousing_Plan_Type;
                                               Proj.RA_Security__c = 'Minimum upgrade to existing';
                                           }   
                                           else {
                                               Proj.Housing_Plan__c = true;
                                               Proj.Default_Housing_Plan__c = false;
                                               Proj.RA_Security__c = 'Minimum upgrade to existing';            
                                           }
                                           Proj.Project_Status__c = 'Draft';
                                           Proj.Cost_Parameter_Date__c = CostParaDate;
                                           //Proj.Project_Phases__c ='Design';
                                           Proj.Purpose_of_Estimate__c = 'Project Controls';
                                           //Proj.Project_SubPhases__c='Preliminary Concept';
                                           
                                           insert Proj;
                                           system.assertNotEquals(NULL,Proj);
                                           
                                           if (blnupdateProject == true && strBuildingType == 'Office') {
                                               NCMT_ProjectTriggerValue.firstRun = true;
                                               Projupd.id = Proj.Id;
                                               //Projupd.Gross_Area_Including_Parking__c = 100050;
                                               Projupd.City__c = 'Reston';
                                               Projupd.RA_Security__c = 'Upgrade: no blast';
                                               
                                               update Projupd;
                                               system.assertNotEquals(NULL,Projupd);
                                           }
                                           
                                           if (blnHousing_Plan == false && blnRAWorkItems == false && blnupdateProject == true) {
                                               system.debug('blnupdateProject===true');
                                               Schema.DescribeSObjectResult cfrSchemaPLP = Schema.SObjectType.Project_Level_Parameter__c; 
                                               Map<String,Schema.RecordTypeInfo> PLPTypeInfo = cfrSchemaPLP.getRecordTypeInfosByName();
                                               
                                               Project_Level_Parameter__c PLP = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Repair & Alteration').getRecordTypeId());
                                               Project_Level_Parameter__c PLPupd = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Repair & Alteration').getRecordTypeId());
                                               
                                               PLP =  [SELECT Id, Foot_Print_Area__c, Massing_Override_Comments__c, Structure_Override_Comments__c, Typical_Bay_Size_A__c, Interior_Override_Comments__c, Int_Const_Core_Shell_Partition_ratio__c, 
                                                       MEP_Override_Comments__c, Electrical_Load__c, Vertical_Transportation_Override_Comment__c, Vertical_Conveyance_Escalators_Pairs__c,
                                                       Cladding_Override_Comments__c, Cladding_Skin_Ratio__c
                                                       FROM Project_Level_Parameter__c WHERE NCMT_Project__c = :Proj.id];
                                               
                                               Test.startTest();
                                               TriggerValue.isupdate = false;
                                               TriggerValue.isupdate1 = true;
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
                                               
                                               Project_Level_Parameter__c PLP3 = new Project_Level_Parameter__c (id = null, recordtypeid = PLPTypeInfo.get('Repair & Alteration').getRecordTypeId());
                                               NCMT_Building_Massing_By_Floor__c BldgMassFloor = new NCMT_Building_Massing_By_Floor__c();
                                               
                                               PLP3 = [select Id from Project_Level_Parameter__c WHERE NCMT_Project__c = :Proj.id];
                                               
                                               BldgMassFloor = [select Id, Use_Area_SF__c from NCMT_Building_Massing_By_Floor__c where Proj_Level_Parameter__c = :PLP3.Id and Building_Massing_Area__c = 'Ground SF'];
                                               //Test.startTest();
                                               TriggerValue.firstRun = true;
                                               TriggerValue.isUpdate1 = false;
                                               BldgMassFloor.Use_Area_SF__c = 1000;
                                               update BldgMassFloor;
                                               system.assertNotEquals(NULL,BldgMassFloor);
                                               
                                               Test.stopTest();       
                                           }
                                           
                                           if (blnHousing_Plan == true && blnRAWorkItems == false && blnupdateProject == false) {
                                               
                                               Test.startTest();
                                               
                                               Schema.DescribeSObjectResult cfrSchemaHP = Schema.SObjectType.NCMT_Housing_Plan__c; 
                                               Map<String,Schema.RecordTypeInfo> HousingPlanTypeInfo = cfrSchemaHP.getRecordTypeInfosByName();
                                               
                                               NCMT_Housing_Plan__c HousingPlan = new NCMT_Housing_Plan__c (id = null, recordtypeid = HousingPlanTypeInfo.get('User Defined').getRecordTypeId());
                                               NCMT_Housing_Plan__c HousingPlan1 = new NCMT_Housing_Plan__c (id = null, recordtypeid = HousingPlanTypeInfo.get('User Defined').getRecordTypeId());
                                               NCMT_Housing_Plan__c HousingPlan2 = new NCMT_Housing_Plan__c (id = null, recordtypeid = HousingPlanTypeInfo.get('User Defined').getRecordTypeId());
                                               
                                               HousingPlan.Project__c = Proj.id ;
                                               HousingPlan.Housing_Plan_Name__c = 'HP1 new fit out';   
                                               HousingPlan.Housing_Plan_Type__c = strHousing_Plan_Type;
                                               HousingPlan.Workstations_open_office_Count__c = 30;
                                               HousingPlan.X20_or_more_person_rooms_Count__c = 3;
                                               HousingPlan.Closed_offices_Count__c  = 0;
                                               HousingPlan.Private_toilets_Count__c = 6;
                                               HousingPlan.X8_20_person_rooms_Count__c = 0;
                                               HousingPlan.Teleconference_Count__c = 0;
                                               HousingPlan.Auditorium_sloped_floor_Count__c = 0;
                                               HousingPlan.Child_care_Count__c = 0;
                                               HousingPlan.Libraries_Count__c = 0;
                                               HousingPlan.ADP_high_density_PC_s_Count__c = 0;
                                               HousingPlan.Courtroom_district_Ceremonial_Count__c= 0;
                                               HousingPlan.Courtroom_district_Standard_Count__c= 0;
                                               HousingPlan.Courtroom_Bankruptcy_Count__c= 0;
                                               HousingPlan.Courtroom_Magistrate_Count__c= 0;
                                               HousingPlan.Grand_Jury_Room_Count__c= 0;
                                               HousingPlan.Judicial_hearing_Count__c= 0;
                                               HousingPlan.Judicial_chambers_Count__c= 0;
                                               HousingPlan.Holding_cell_Central_Count__c= 0;
                                               HousingPlan.Holding_cell_Court_floors_Count__c= 0;
                                               HousingPlan.Unfinished_Shell_Area_Use_USF__c= 0;
                                               HousingPlan.General_storage_Use_USF__c= 0;
                                               HousingPlan.High_density_storage_Use_USF__c= 0;
                                               HousingPlan.Clinics_health_units_Use_USF__c= 0;
                                               HousingPlan.Physical_fitness_Use_USF__c= 0;
                                               HousingPlan.ADP_mainframe_Use_USF__c= 0;
                                               HousingPlan.Joint_use_retail_Use_USF__c= 0;
                                               HousingPlan.Food_service_cafeteria_Use_USF__c= 0;
                                               HousingPlan.Climate_controlled_for_artifacts_Use_USF__c= 0;
                                               HousingPlan.Non_climate_controlled_Use_USF__c= 0;
                                               HousingPlan.Laboratory_Dry_electronic_Use_USF__c= 0;
                                               HousingPlan.Laboratory_Wet_chemistry_Use_USF__c= 0;
                                               HousingPlan.Firing_range_Use_USF__c= 0;
                                               HousingPlan.Copy_Center_Use_USF__c= 0;
                                               HousingPlan.Credit_Union_Use_USF__c= 0;
                                               HousingPlan.Transaction_counter_space_Use_USF__c= 0;
                                               HousingPlan.Kitchen_Break_room_Use_USF__c= 0;
                                               HousingPlan.Locker_Shower_room_Use_USF__c= 0;
                                               HousingPlan.Hardened_offices_suites_Use_USF__c= 0;
                                               HousingPlan.Secure_Work_Environment_SWE_Std_Use_USF__c= 0;
                                               HousingPlan.Secure_Work_Environment_SWE_Enhd_UseUSF__c= 0;
                                               HousingPlan.Secured_Storage_SCIF_Standard_Use_USF__c= 0;
                                               HousingPlan.Secured_Storage_SCIF_Enhanced_Use_USF__c= 0;
                                               HousingPlan.Vault_Type_Storage_Use_USF__c= 0;
                                               HousingPlan.Interview_Detention_Use_USF__c= 0;
                                               HousingPlan.Non_Marshal_Holding_Cell_Single_Use_USF__c= 0;
                                               HousingPlan.Non_Marshal_Holding_Cell_Double_Use_USF__c= 0;
                                               HousingPlan.Enhanced_office_Use_USF__c= 0;
                                               HousingPlan.USMS_Suite_Administration_Use_USF__c= 0;
                                               HousingPlan.USMS_Suite_Operations_Use_USF__c= 0;
                                               HousingPlan.Sally_Port_Use_USF__c= 0;
                                               HousingPlan.Light_industrial_Use_USF__c= 0;
                                               HousingPlan.Warehouse_Use_USF__c= 0;
                                               HousingPlan.VA_Intake_Use_USF__c= 0;
                                               HousingPlan.VA_Exam_Suite_Use_USF__c= 0;
                                               HousingPlan.VA_Radiology_Use_USF__c= 0;
                                               HousingPlan.VA_Ambulatory_Surgery_Use_USF__c= 0;
                                               HousingPlan.VA_Infusion_Use_USF__c= 0;
                                               HousingPlan.VA_Pharmacy_Use_USF__c= 0;
                                               HousingPlan.Data_Center_Use_USF__c= 0;
                                               
                                               insert HousingPlan;
                                               test.stopTest();
                                               system.assertNotEquals(NULL,HousingPlan); 
                                               
                                               //HousingPlan2.id = HousingPlan.id ;
                                               //HousingPlan2.Housing_Plan_Name__c = 'HP2 new fit out';    
                                               //HousingPlan2.Housing_Plan_Type__c = strHousing_Plan_Type;
                                               //HousingPlan2.Workstations_open_office_Count__c = 130;
                                               
                                               //update HousingPlan2;
                                               //system.assertNotEquals(NULL,HousingPlan2); 
                                               if (strProjectType == 'Repair & Alteration - Work Item Detail') {
                                                   delete HousingPlan;
                                                   system.assertNotEquals(NULL,HousingPlan);
                                               } 
                                               
                                               Schema.DescribeSObjectResult cfrSchemaRAP = Schema.SObjectType.NCMT_RA_Phasing__c; 
                                                   Map<String,Schema.RecordTypeInfo> RAPhasingTypeInfo = cfrSchemaRAP.getRecordTypeInfosByName();
                                                   
                                                   NCMT_RA_Phasing__c RAPhasing2 = new NCMT_RA_Phasing__c (id = null, recordtypeid = RAPhasingTypeInfo.get(strProjectType).getRecordTypeId());
                                                   RAPhasing2.Name ='Phase 2';
                                                   RAPhasing2.Project__c = Proj.id;
                                                   RAPhasing2.Planned_Project_Start__c = date.newinstance(2017, 10, 1);
                                                   RAPhasing2.Planned_Duration_Months__c = 2;
                                                   RAPhasing2.Description__c = 'test';
                                                   RAPhasing2.Design_Contingency__c = 0.0;
                                                   RAPhasing2.On_site_General_Special_Conditions__c = 0.0;
                                                   RAPhasing2.Home_Office_Overhead_Bond_Profit__c = 0.0;
                                                   RAPhasing2.Work_Conditions__c = 'Fully occupied';
                                                   
                                                   insert RAPhasing2;
                                                   system.assertNotEquals(NULL,RAPhasing2);
                                                   
                                                   delete RAPhasing2;
                                                   system.assertNotEquals(NULL,RAPhasing2);
                                               
                                               //Test.stopTest();         
                                               
                                           }       
                                           
                                           if (blnHousing_Plan == false && blnRAWorkItems == true && blnupdateProject == false) {
                                               //Test.startTest();
                                               string strRARoofPlum;
                                               
                                               NCMT_Project_Cost_Summary__c NCMT_Project_Cost_Summary = new NCMT_Project_Cost_Summary__c (id = null);
                                               NCMT_Project_Cost_Summary =  [SELECT Id FROM NCMT_Project_Cost_Summary__c WHERE Project_Name__c = :Proj.id and Cost_Category_Description__c = :strCategoryDescription];
                                               
                                               NCMT_RA_WI_Lookup_Details__c NCMT_RA_WI_Lookup_Details = new NCMT_RA_WI_Lookup_Details__c (id = null);
                                               NCMT_RA_WI_Lookup_Details =  [SELECT Id FROM NCMT_RA_WI_Lookup_Details__c WHERE Name = :strRAWILookupDetails];
                                               
                                               NCMT_RA_Phasing__c NCMT_RA_Phasing = new NCMT_RA_Phasing__c (id = null);
                                               NCMT_RA_Phasing =  [SELECT Id FROM NCMT_RA_Phasing__c WHERE Project__c = :Proj.id and Work_Conditions__c = 'Fully vacant building'];
                                               
                                               Schema.DescribeSObjectResult cfrSchemaWI = Schema.SObjectType.NCMT_RA_Work_Items__c; 
                                               Map<String,Schema.RecordTypeInfo> RAWorkItemsTypeInfo = cfrSchemaWI.getRecordTypeInfosByName();
                                               
                                               NCMT_RA_Work_Items__c RA_Work_Items = new NCMT_RA_Work_Items__c (id = null, recordtypeid = RAWorkItemsTypeInfo.get('RA Work Items').getRecordTypeId());
                                               
                                               RA_Work_Items.Work_Item_Type_ID__c = NCMT_Project_Cost_Summary.id;
                                               RA_Work_Items.RA_WI_Lookup_Detail__c = NCMT_RA_WI_Lookup_Details.id;
                                               RA_Work_Items.Work_Item_Type__c = strWorkItemType;
                                               RA_Work_Items.Work_Item_Phase__c = NCMT_RA_Phasing.id;
                                               
                                               insert RA_Work_Items;
                                               system.assertNotEquals(NULL,RA_Work_Items);
                                               
                                               Test.startTest();
                                               
                                               NCMT_Project_Cost_Summary__c NCMT_Project_Cost_Summary1 = new NCMT_Project_Cost_Summary__c (id = null);
                                               NCMT_Project_Cost_Summary1 =  [SELECT Id FROM NCMT_Project_Cost_Summary__c WHERE Project_Name__c = :Proj.id and Cost_Category_Description__c = 'Exterior Closure'];
                                               
                                               NCMT_RA_WI_Lookup_Details__c NCMT_RA_WI_Lookup_Details1 = new NCMT_RA_WI_Lookup_Details__c (id = null);
                                               NCMT_RA_WI_Lookup_Details1 =  [SELECT Id FROM NCMT_RA_WI_Lookup_Details__c WHERE Name = 'Exterior Closure - 2017 - 99'];
                                               
                                               NCMT_RA_Work_Items__c RA_Work_Items1 = new NCMT_RA_Work_Items__c (id = null, recordtypeid = RAWorkItemsTypeInfo.get('RA Work Items').getRecordTypeId());
                                               
                                               RA_Work_Items1.Work_Item_Type_ID__c = NCMT_Project_Cost_Summary1.id;
                                               RA_Work_Items1.RA_WI_Lookup_Detail__c = NCMT_RA_WI_Lookup_Details1.id;
                                               RA_Work_Items1.Work_Item_Type__c = 'Repair';
                                               RA_Work_Items1.Work_Item_Phase__c = NCMT_RA_Phasing.id;
                                               
                                               insert RA_Work_Items1;
                                               system.assertNotEquals(NULL,RA_Work_Items1);
                                               
                                               
                                               NCMT_Project_Cost_Summary__c NCMT_Project_Cost_Summary2 = new NCMT_Project_Cost_Summary__c (id = null);
                                               NCMT_Project_Cost_Summary2 =  [SELECT Id FROM NCMT_Project_Cost_Summary__c WHERE Project_Name__c = :Proj.id and Cost_Category_Description__c = 'Land Improvements'];
                                               
                                               NCMT_RA_WI_Lookup_Details__c NCMT_RA_WI_Lookup_Details2 = new NCMT_RA_WI_Lookup_Details__c (id = null);
                                               NCMT_RA_WI_Lookup_Details2 =  [SELECT Id FROM NCMT_RA_WI_Lookup_Details__c WHERE Name = 'Land Improvements - 2017 - 15'];
                                               
                                               NCMT_RA_Work_Items__c RA_Work_Items2 = new NCMT_RA_Work_Items__c (id = null, recordtypeid = RAWorkItemsTypeInfo.get('RA Work Items').getRecordTypeId());
                                               
                                               RA_Work_Items2.Work_Item_Type_ID__c = NCMT_Project_Cost_Summary2.id;
                                               RA_Work_Items2.RA_WI_Lookup_Detail__c = NCMT_RA_WI_Lookup_Details2.id;
                                               RA_Work_Items2.Work_Item_Type__c = 'Repair';
                                               RA_Work_Items2.Work_Item_Phase__c = NCMT_RA_Phasing.id;
                                               
                                               insert RA_Work_Items2;
                                               system.assertNotEquals(NULL,RA_Work_Items2);
                                               
                                               NCMT_Project_Cost_Summary__c NCMT_Project_Cost_Summary3 = new NCMT_Project_Cost_Summary__c (id = null);
                                               NCMT_Project_Cost_Summary3 =  [SELECT Id FROM NCMT_Project_Cost_Summary__c WHERE Project_Name__c = :Proj.id and Cost_Category_Description__c = 'Roofing'];
                                               
                                               NCMT_RA_WI_Lookup_Details__c NCMT_RA_WI_Lookup_Details3 = new NCMT_RA_WI_Lookup_Details__c (id = null);
                                               NCMT_RA_WI_Lookup_Details3 =  [SELECT Id FROM NCMT_RA_WI_Lookup_Details__c WHERE Name = 'Roofing - 2017 - 311'];
                                               
                                               NCMT_RA_Work_Items__c RA_Work_Items3 = new NCMT_RA_Work_Items__c (id = null, recordtypeid = RAWorkItemsTypeInfo.get('RA Work Items').getRecordTypeId());
                                               
                                               RA_Work_Items3.Work_Item_Type_ID__c = NCMT_Project_Cost_Summary3.id;
                                               RA_Work_Items3.RA_WI_Lookup_Detail__c = NCMT_RA_WI_Lookup_Details3.id;
                                               RA_Work_Items3.Work_Item_Type__c = 'Replace';
                                               RA_Work_Items3.Work_Item_Phase__c = NCMT_RA_Phasing.id;
                                               
                                               insert RA_Work_Items3;
                                               system.assertNotEquals(NULL,RA_Work_Items3);
                                               
                                               NCMT_Project_Cost_Summary__c NCMT_Project_Cost_Summary4 = new NCMT_Project_Cost_Summary__c (id = null);
                                               NCMT_Project_Cost_Summary4 =  [SELECT Id FROM NCMT_Project_Cost_Summary__c WHERE Project_Name__c = :Proj.id and Cost_Category_Description__c = 'Plumbing'];
                                               
                                               NCMT_RA_WI_Lookup_Details__c NCMT_RA_WI_Lookup_Details4 = new NCMT_RA_WI_Lookup_Details__c (id = null);
                                               NCMT_RA_WI_Lookup_Details4 =  [SELECT Id FROM NCMT_RA_WI_Lookup_Details__c WHERE Name = 'Plumbing - 2017 - 655'];
                                               
                                               NCMT_RA_Work_Items__c RA_Work_Items4 = new NCMT_RA_Work_Items__c (id = null, recordtypeid = RAWorkItemsTypeInfo.get('RA Work Items').getRecordTypeId());
                                               
                                               RA_Work_Items4.Work_Item_Type_ID__c = NCMT_Project_Cost_Summary4.id;
                                               RA_Work_Items4.RA_WI_Lookup_Detail__c = NCMT_RA_WI_Lookup_Details4.id;
                                               RA_Work_Items4.Work_Item_Type__c = 'Replace';
                                               RA_Work_Items4.Work_Item_Phase__c = NCMT_RA_Phasing.id;
                                               
                                               insert RA_Work_Items4;
                                               system.assertNotEquals(NULL,RA_Work_Items4);
                                               
                                               if (strRAWILookupDetails == 'Roofing - 2017 - 74') {
                                                   Schema.DescribeSObjectResult cfrSchemaRAP = Schema.SObjectType.NCMT_RA_Phasing__c; 
                                                   Map<String,Schema.RecordTypeInfo> RAPhasingTypeInfo = cfrSchemaRAP.getRecordTypeInfosByName();
                                                   
                                                   NCMT_RA_Phasing__c RAPhasing2 = new NCMT_RA_Phasing__c (id = null, recordtypeid = RAPhasingTypeInfo.get(strProjectType).getRecordTypeId());
                                                   RAPhasing2.Name ='Phase 2';
                                                   RAPhasing2.Project__c = Proj.id;
                                                   RAPhasing2.Planned_Project_Start__c = date.newinstance(2017, 10, 1);
                                                   RAPhasing2.Planned_Duration_Months__c = 2;
                                                   RAPhasing2.Description__c = 'test';
                                                   RAPhasing2.Design_Contingency__c = 0.0;
                                                   RAPhasing2.On_site_General_Special_Conditions__c = 0.0;
                                                   RAPhasing2.Home_Office_Overhead_Bond_Profit__c = 0.0;
                                                   RAPhasing2.Work_Conditions__c = 'Fully occupied';
                                                   
                                                   insert RAPhasing2;
                                                   system.assertNotEquals(NULL,RAPhasing2);
                                                   
                                                   delete RAPhasing2;
                                                   system.assertNotEquals(NULL,RAPhasing2);
                                               }   
                                               Test.stopTest();                     
                                           }
                                           
                                           if (strRAWILookupDetails == 'Roofing - 2017 - 71') {
                                               Test.startTest();
                                               
                                               ApexPages.currentPage().getParameters().put('ProjectID', Proj.id);
                                               
                                               NCMT_ReportData objTest = new NCMT_ReportData();
                                               objTest.DatasetProjectCostSummaryGrouped(Proj.id);
                                               objTest.getProjectInformation();
                                               objTest.getDatasetProjectCostSummary(); 
                                               objTest.getDatasetHousingPlan();        
                                               
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
    
    public static void CreateLPOEProject(string strProjectType, string strProjectName, string strBuildingType, string strState, string strCity, string strBuilding_Cost_Type, string strBuilding_Heigtht, string strBuilding_Quality, 
                                         string strLevel_of_Protection, string strRemoteness, string strPOV_Port_Size, string strCommercial_Port_Size, boolean blnLPOEreports) {
                                             
                                             Date CostParaDate = date.newinstance(2016, 10, 1);
                                             NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
                                             NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
                                             NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
                                             insert NCMT_Cust_settings;
                                             
                                             string strRecordTypeName;
                                             //strRecordTypeName = 'Childcare Center';
                                             string strBLDGHeightRecordTypeID = Schema.SObjectType.NCMT_Building_Height_Parameter__c.getRecordTypeInfosByName().get('Land Port of Entry').getRecordTypeId();
                                             string strBLDGRecordTypeID = Schema.SObjectType.NCMT_Building_Parameter__c.getRecordTypeInfosByName().get('Childcare Center').getRecordTypeId(); 
                                             
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
                                             Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
                                             
                                             NCMT_Project__c Proj = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('LPOE').getRecordTypeId());
                                             NCMT_Project__c Projupd = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('LPOE').getRecordTypeId());
                                             NCMT_Project__c Projupd2 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get('LPOE').getRecordTypeId());       
                                             
                                             Proj.Estimate_Type_Proj__c  = 'Parametric';
                                             Proj.Project_type__c = strProjectType;
                                             Proj.Building_Type__c = strBuildingType;
                                             Proj.Name = strProjectName;
                                             Proj.State__c = strState;
                                             Proj.City__c = strCity;        
                                             
                                             Proj.Location__c = objlocation.Id;
                                             
                                             Date ConstDate = date.newinstance(2018, 1, 1);
                                             Date EndConstDate = date.newinstance(2020, 10, 1);
                                             Proj.Start_Construction__c = ConstDate;
                                             Proj.Building_Quality__c = strBuilding_Quality;
                                             Proj.Remoteness__c = strRemoteness;
                                             Proj.Project_Status__c = 'Draft';
                                             Proj.Cost_Parameter_Date__c = CostParaDate;
                                             //Proj.Project_Phases__c ='Design';
                                             //Proj.Project_SubPhases__c='Preliminary Concept';
                                             
                                             Proj.POV_Port_Size__c = strPOV_Port_Size;
                                             Proj.Commercial_Port_Size__c = strCommercial_Port_Size;
                                             
                                             insert Proj;
                                             system.assertNotEquals(NULL,Proj);
                                             
                                             if (blnLPOEreports == true) {
                                                 //Test.startTest();
                                                 
                                                 //PageReference pageRef = Page.NCMT_UniformatCostOutput;
                                                 //Test.setCurrentPage(pageRef);
                                                 
                                                 ApexPages.currentPage().getParameters().put('ProjectID', Proj.id);
                                                 
                                                 NCMT_LPOEReportData objTest = new NCMT_LPOEReportData();
                                                 objTest.getProjectInformation();
                                                 objTest.getDatasetLPOECostSummary();    
                                                 objTest.getDatasetLPOECostSummary1();    
                                                 objTest.getDatasetLPOECostSummary2();    
                                                 objTest.getDatasetLPOECostSummary3();
                                                 objTest.DatasetLPOECostSummaryGrouped(Proj.id);             
                                                 
                                                 //Test.stopTest(); 
                                             }
                                             
                                             if (strPOV_Port_Size == 'Medium') {
                                                 Test.startTest();               
                                                 LPOE_Space_Plan__c LPOESP = new LPOE_Space_Plan__c (id = null);
                                                 LPOESP =  [SELECT Id FROM LPOE_Space_Plan__c WHERE Project_Name__c = :Proj.id];
                                                 
                                                 LPOESP.Number_of_Lanes__c = 16;
                                                 LPOESP.Comm_Number_of_Lanes__c = 16; 
                                                 
                                                 update LPOESP;
                                                 system.assertNotEquals(NULL,LPOESP);
                                                 Test.stopTest();                    
                                             }   
                                             
                                             if (strPOV_Port_Size == 'Small') {
                                                 Test.startTest();   
                                                 NCMT_ProjectTriggerValue.firstRun = true;
                                                 Projupd.id = Proj.id;
                                                 Projupd.City__c = 'San Jose';
                                                 
                                                 update Projupd;
                                                 system.assertNotEquals(NULL,Projupd);
                                                 Test.stopTest();     
                                             }   
                                             
                                         }                               
}