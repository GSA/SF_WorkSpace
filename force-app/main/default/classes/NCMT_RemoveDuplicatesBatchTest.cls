@isTest
public class NCMT_RemoveDuplicatesBatchTest {
    public static String fiscalYear;
    public static String prevFiscalYear;
    @testSetup 
    static void setup(){
         Date CostParaDate = date.newinstance(2016, 10, 1);
         Date MidPtConst = date.newInstance(2019, 12, 1);
         NCMT_CustomSettings__c NCMT = new NCMT_CustomSettings__c();
         NCMT.Cost_Parameter_Date__c = CostParaDate;
         NCMT.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
         NCMT.Data_Load_Current_FY__c = String.valueOf(System.today().year());
         NCMT.Data_Load_Previous_FY__c = String.valueOf(System.today().year()-1);
         insert NCMT;
        
        List<NCMT_CustomSettings__c> fy1 = [SELECT Data_Load_Current_FY__c,Data_Load_Previous_FY__c FROM NCMT_CustomSettings__c];
        fiscalYear =  String.valueOf(NCMT.Data_Load_Current_FY__c); 
        prevFiscalYear = String.valueOf(NCMT.Data_Load_Previous_FY__c);
        
        NCMT_Cost_Category__c costCat = new NCMT_Cost_Category__c(
                    Name = 'B10',
                    Category_Description__c = 'The B10 one'
                );
        insert costCat;
        
        NCMT_Assembly_Lookup_detail__c detail = new NCMT_Assembly_Lookup_detail__c();
        detail.Name = '10000';
        detail.Level_2__c = costCat.Id;
        detail.Fiscal_Year__c = fiscalYear;
        insert detail;

        NCMT_Assembly_Lookup_detail__c detail1 = new NCMT_Assembly_Lookup_detail__c();
        detail1.Name = '10000';
        detail1.Level_2__c = costCat.Id;
        detail1.Fiscal_Year__c = fiscalYear;
        insert detail1;
        
        NCMT_DES_Lookup_details__c  lookup = new NCMT_DES_Lookup_details__c  ();
        lookup.Name = 'General Requirements - 2019 -9'; 
        lookup.Level_2__c = costCat.id;
        lookup.Level_3_Description__c = 'Test Level 3';
        lookup.Level_4_Description__c  = 'Test Level 4';
        lookup.Level_5_Description__c = 'Test Level 5';
        lookup.Fiscal_Year__c = fiscalYear;
        lookup.Line_Item_Number__c = '12';
        insert lookup;
        
        NCMT_DES_Lookup_details__c  lookup1 = new NCMT_DES_Lookup_details__c  ();
        lookup1.Name = 'General Requirements - 2019 -9'; 
        lookup1.Level_2__c = costCat.id;
        lookup1.Level_3_Description__c = 'Test Level 3';
        lookup1.Level_4_Description__c  = 'Test Level 4';
        lookup1.Level_5_Description__c = 'Test Level 5';
        lookup1.Fiscal_Year__c = fiscalYear;
        lookup1.Line_Item_Number__c = '12';
        insert lookup1;
        
        
        
        NCMT_DES_Lookup_details__c d = [SELECT Id, Line_Item_Number__c FROM NCMT_DES_Lookup_details__c LIMIT 1];
        
        NCMT_Assembly_Lookup_Item__c i = new NCMT_Assembly_Lookup_Item__C(
        	Assembly_Lookup_Detail__c = detail1.Id,
            NCMT_Master_Format_Lookup__c = lookup1.Id,
            Conversion_Factor__c = 1,
            Master_Format_Line_Item_Number__c = lookup1.Line_Item_Number__c,
            Fiscal_Year__c = fiscalYear
        );
        insert i;
        
        NCMT_Assembly_Lookup_Item__c i1 = new NCMT_Assembly_Lookup_Item__C(
        	Assembly_Lookup_Detail__c = detail1.Id,
            NCMT_Master_Format_Lookup__c = lookup1.Id,
            Conversion_Factor__c = 1,
            Master_Format_Line_Item_Number__c = lookup1.Line_Item_Number__c,
            Fiscal_Year__c = fiscalYear
        );
        insert i1;
        
    }
	@isTest
    public static void testRemoveDuplicatesBatch(){
        
        
        List<NCMT_Cost_Category__c> costCats = new List<NCMT_Cost_Category__c>();
        NCMT_Cost_Category__c costCat = new NCMT_Cost_Category__c(
            Name = 'B10',
            Category_Description__c = 'The B10 one'
        );
        costCats.add(costCat);

        costCat = new NCMT_Cost_Category__c(
            Name = 'A10',
            Category_Description__c = 'Doors & Lock Installation'
        );
        costCats.add(costCat);
        costCat = new NCMT_Cost_Category__c(
            Name = 'MR0',
            Category_Description__c = 'Doors & Lock Installation'
        );
        costCats.add(costCat);
        costCat = new NCMT_Cost_Category__c(
            Name = 'PM0',
            Category_Description__c = 'Doors & Lock Installation'
        );
        costCats.add(costCat);
        costCat = new NCMT_Cost_Category__c(
            Name = 'A10000001',
            Category_Description__c = 'DES Cat'
        );
        costCats.add(costCat);
        insert costCats;
        
		List<NCMT_Data_Upload__c> uploads = new List<NCMT_Data_Upload__c>();

        //Location Parameters
		NCMT_Data_Upload__c up = new NCMT_Data_Upload__c(
        	Upload__c = 'Location',Text_1__c = 'Alabama',Text_2__c = 'Auburn',Text_3__c = 'NA',
            Text_4__c = '3A',Text_5__c = 'A',Text_6__c = 'B',Text_7__c = '4',Text_8__c = 'Alabama',
            Text_9__c = 'Rest of US',Number_1__c = 0.83,Number_2__c = 0.86,Number_3__c = 0.79717,
            Number_4__c = 1.883216,Number_5__c = 2,Number_6__c = 1.05,Number_7__c = 1.1,Number_8__c = 1,
            Number_9__c = 1, Number_10__c = 1, Number_11__c = 0.919015
        );        
        
        uploads.add(up);
        insert uploads;
        fiscalYear = '2022';
        List<NCMT_Location_Parameters__c> locParams = [SELECT Id FROM NCMT_Location_Parameters__c 
                                                      WHERE Fiscal_Year__c =: fiscalYear];
        System.assertEquals(1, locParams.size());
        
        //LPOE Costs
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'LPOE_Costs', Text_1__c = 'Garage', Text_2__c = 'Southern', Text_3__c = 'Mega',
            Text_4__c = 'POV', Text_5__c = 'FALSE', Text_6__c = 'Warehouse Buildings'
        );
        
        uploads.add(up);
        insert uploads;
        
        //LPOE Space
        NCMT_LPOE_Parametric_Default_SpaceLookup__c spaceLkp = new NCMT_LPOE_Parametric_Default_SpaceLookup__c(
        	GSF_C__c = 0, GSF_MX__c = 1600, LPOE_Bldg_Group__c = 'Office Buildings', LPOE_Type__c = 'POV',
            LPOE_Line_Item__C = 'Repatriation Facility - Study Data', Site_Ped__c = 0, Site_Veh__c = 0
        );
        insert spaceLkp;
        
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'LPOE_SPACE', Text_1__c = 'Office Buildings', Text_2__c = 'POV', 
            Text_3__c = 'Repatriation Facility - Study Data',Number_1__c = 0, Number_2__c = 0,
            Number_3__c = 2.73, Number_4__c = 0
        );
        
        uploads.add(up);
        insert uploads;
        
        //Move Costs
        NCMT_Housing_Plan_Option_Template__c temp = new NCMT_Housing_Plan_Option_Template__c(
        	Type__c = 'Moving Costs', Sub_Type__c = 'Acquisition', Sort_Order__c = 2
        );
        insert temp;
        
        NCMT_Housing_Plan_Option__c opt = new NCMT_Housing_Plan_Option__c(
        	NCMT_Housing_Plan_Option_Template__c = temp.Id, CHOICE_TEXT__C ='Furniture', 
            Description__c = 'Purchase and deliver new furnishings'
        );
        insert opt;
        
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'Move_Cost', Text_1__c = 'Childcare TI', Text_2__c = 'AcquisitionFurniture', 
            Number_1__c = 0
        );
        
        uploads.add(up);
        insert uploads;
        
        List<NCMT_Housing_Plan_Cost_Parameter__c> moveCosts = [SELECT Id FROM NCMT_Housing_Plan_Cost_Parameter__c
                                                               WHERE Fiscal_Year__c =:fiscalYear];
        System.assertEquals(1, moveCosts.size());
        
        //Security Parameter
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'Security', Text_1__c = 'Blast Resistance - Progressive Collapse', Text_2__c = 'B10', 
            Text_3__c = 'B1010',Text_4__c = 'Floor Construction', Text_5__c = 'Superstructure', 
            Text_6__c = 'Construction', Text_7__c = 'GSF', Number_1__c = 0, Number_2__c = 0, Number_3__c = 9.731799,
            Number_4__c = 9.731799, Number_5__c = 12.68175
        );
        
        uploads.add(up);
        insert uploads;
        
        //TI-TRCS
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'TI_TRCS', Text_1__c = 'B10', Text_2__c = 'ADP - High Density PCs', 
            Text_3__c = 'B1010',Text_4__c = 'Floor Construction', Number_1__c = 0, 
            Number_2__c = 0, Number_3__c = 0,Number_4__c = 0, Number_5__c = 10
        );
        
        uploads.add(up);
        insert uploads;
        
        
        //Triage
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'Triage', Text_1__c = 'BA 51', Text_2__c = 'New Construction',Text_3__c = 'Design-Bid-Build',
            Text_4__c = 'Prospectus <> $5M', Text_5__c = 'Project Initiation', Text_6__c = 'Building Evaluation Report',
            Text_7__c = 'Work Item Cost Estimate', Text_8__c = 'N/A', Text_9__c = '1', Number_1__c = 1
        );
        
        uploads.add(up);
        insert uploads;
        
        //Core Shell
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'coreshell', Text_1__c = 'A10', Text_2__c = 'CC1',Text_3__c = 'Standard Foundations',
            Text_4__c = 'Column bases', Text_5__c = 'EA', Text_6__c = 'EA',
            Text_7__c = 'ROUND((pfoot/(+\'Parametric Entry - PS\'!J136))+(((pfoot*\'Parametric Entry - PS\'!I143/\'Parametric Entry - PS\'!I132)/((\'Parametric Entry - PS\'!E136+\'Parametric Entry - PS\'!G136)/2))/2),0)', 
            Text_8__c = 'Value=+Round(bfoot/+\'Parametric Entry\'!J119+((bfoot*\'Parametric Entry\'!I130/\'Parametric Entry\'!I115)/((\'Parametric Entry\'!E119+\'Parametric Entry\'!G119)/2))/2,0)', 
            Text_9__c = 'A1010', Text_10__c = 'Standard Foundations', Text_11__c = 'FALSE', Number_1__c = 0, Number_2__c = 0
        );
        
        uploads.add(up);
        //insert uploads;
        
        //uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'coreUpdate', Text_1__c = 'CC1', Text_2__c = '',Text_3__c = 'Major Repair',
            Text_4__c = 'Construction', Text_5__c = 'Real Property'
        );
        
        uploads.add(up);
        insert uploads;
        
        List<NCMT_Core_Shell_Cost_Parameter__c> coreShells = [SELECT Id, Name FROM NCMT_Core_Shell_Cost_Parameter__c 
                                                              WHERE Fiscal_Year__C =: fiscalYear];
        System.assertEquals(1, coreShells.size());
        
        
        //CEW
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'CEW', Text_1__c = 'Design&Site', Text_2__c = 'Planning',
            Text_3__c = 'Draft Concept',Text_4__c = 'Markup', Number_1__c = 8.5
        );
        
        uploads.add(up);
        insert uploads;
        
        //P100
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'P100', Text_1__c = 'B10', Text_2__c = 'Electrical - overall quality/power quality',
            Number_1__c = 0, Number_2__c = 0, Number_3__c = 0, Number_4__c = 0
        );
        
        uploads.add(up);
        insert uploads;
        
        //LEED
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'LEED', Text_1__c = 'B10', Text_2__c = 'Energy and Atmosphere',
            Text_3__c = 'Prereq', Text_4__c = 'Building-Level Energy Metering',	
            Number_1__c = 1, Number_2__c = 0, Number_3__c = 0, Number_4__c = 0, Number_5__c = 0
        );
        
        uploads.add(up);
        insert uploads;
        
        //RA Mods
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'raMOD', Text_1__c = 'A10', Text_2__c = 'Structural',
            Text_3__c = '19th Century',
            Number_1__c = 1, Number_2__c = 0, Number_3__c = 0, Number_4__c = 0, Number_5__c = 1
        );
        
        uploads.add(up);
        insert uploads;
        
        //RA Overhead Analysis
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'raOverhead', Text_1__c = 'GC Overhead & Profit - Home Office, Bond & Profit', 
            Number_1__c = 0, Number_2__c = 17, Number_3__c = 15, Number_4__c = 15, Number_5__c = 17,
            Number_6__c = 15.5, Number_7__c = 16
        );
        
        uploads.add(up);
        insert uploads;
        
        //RA Work Item
        uploads = new List<NCMT_Data_Upload__c>();
        
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'raWI', Text_1__c = 'Repair 310 - Replace 410', Text_2__c = 'SF', Text_3__c = '310.11',
            Text_4__c = 'Cut and patch asphalt', Text_5__c = 'Sawcut and remove damaged paving, reconsolidate base, place new patch material',
            Text_6__c = 'Repair paving', Text_7__c = 'Vehicular paving', Text_8__c = 'Repair',
            Number_1__c = 0, Number_2__c = 0, Number_3__c = 144.53, Number_4__c = 50.09, Number_5__c = 0,
            Number_6__c = 0, Number_7__c = 112.08
        );
        
        uploads.add(up);
        insert uploads;
        
        Test.startTest();
         	NCMT_DataUpload_TriggerHandler.removeAssemblyLookupDetailDuplicates();
            NCMT_DataUpload_TriggerHandler.removeDESLookupDetailsDuplicates();
            NCMT_DataUpload_TriggerHandler.removeAssemblyLookupItemDuplicates();
        Test.stopTest();
        
        List<NCMT_Assembly_Lookup_Item__c> items = [Select Id From NCMT_Assembly_Lookup_Item__c];
        System.assertEquals(1, items.size());
        
    }
}