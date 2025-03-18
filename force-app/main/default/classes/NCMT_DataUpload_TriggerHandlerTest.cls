@isTest
public with sharing class NCMT_DataUpload_TriggerHandlerTest {
    
    @testSetup static void setup(){
     String fiscalYear =  String.valueOf(System.Today().year()-1); 
     String prevFiscalYear = String.valueOf(System.Today().year()-2);
         Date CostParaDate = date.newinstance(2016, 10, 1);
        Date MidPtConst = date.newInstance(2019, 12, 1);
        NCMT_CustomSettings__c NCMT = new NCMT_CustomSettings__c();
        NCMT.Cost_Parameter_Date__c = CostParaDate;
        NCMT.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        NCMT.Data_Load_Current_FY__c = fiscalYear;
        NCMT.Data_Load_Previous_FY__c = prevFiscalYear;
         insert NCMT;
    }

    @isTest
    public static void test_2021_data_upload1() {
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

       
        //NCMT ASSEMBLY MASTERS, GSA and FAC
        List<NCMT_Data_Upload__c> uploads = new List<NCMT_Data_Upload__c>();
                    //SFWS-1604- changing GSA_2021_ASMUNIto GSA_ASMUNI

        NCMT_Data_Upload__c up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_ASMUNI',
            Text_2__c = 'ASMUNI',
            Text_1__c = 'A1020301'
        );
        uploads.add(up);
            //SFWS-1604- changing GSA_2021_ASMUNIto GSA_ASMUNI

        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_ASMUNI',
            Text_2__c = 'ASMUNI',
            Text_1__c = 'A1020'
        );
        uploads.add(up);
            // SFWS-1606- changingGSA_2021_FAC_ASMUNIto GSA_FAC_ASMUNI 

        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_FAC_ASMUNI',
            Text_2__c = 'FAC_ASMUNI',
            Text_1__c = 'B1020301'
        );
        uploads.add(up);

        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_FAC_ASMUNI',
            Text_2__c = 'FAC_ASMUNI',
            Text_1__c = 'B1020'
        ); 
        uploads.add(up);

        //  SFWS-1599 - Changing GSA_2021_ASMDESC to GSA_ASMDESC

        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_ASMDESC',
            Text_1__c = 'Limit Building Entry Points 1',
            Text_2__c = 'A1020301'
        );
        uploads.add(up);
        //  SFWS-1602 - changing GSA_2021_FAC_ASMDES to GSA_FAC_ASMDES
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_FAC_ASMDES',
            Text_1__c = 'Limit Building Entry Points 2',
            Text_2__c = 'B1020301'
        );
        uploads.add(up);

        insert uploads;
        
        List<NCMT_Assembly_Lookup_Detail__c> assDetails = [Select Id from NCMT_Assembly_Lookup_Detail__c where Name <> null];
        System.assertEquals(2, assDetails.size());

        //NCMT ASSEMBLY MASTERS, MR
        uploads = new List<NCMT_Data_Upload__c>();
             //SFWS-1609 changing GSA_2021_M&R ASMUNI to GSA_M&R ASMUNI
 
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_M&R ASMUNI',
            Text_1__c = 'MR020301',
            Text_2__c = 'MR_ASMUNI'
        );
        uploads.add(up);
       //SFWS-1609 changing GSA_2021_M&R ASMUNI to GSA_M&R ASMUNI
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_M&R ASMUNI',
            Text_2__c = 'ASMUNI',
            Text_1__c = 'MR020'
        );
        uploads.add(up);
        
        //SFWS-1607 changing GSA_2021_M&R Assembly Data to GSA_M&R Assembly Data

        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_M&R Assembly Data',
            Text_1__c = 'Limit Building Entry Points',
            Text_2__c = 'MR020301',
            Number_1__c = 1,
            Number_2__c = 2,
            Number_3__c = 3,
            Number_4__c = 4
        );
        uploads.add(up);

        insert uploads;

        assDetails = [Select Id from NCMT_Assembly_Lookup_Detail__c where Name <> null];
        System.assertEquals(3, assDetails.size());

        Test.startTest();

        //NCMT ASSEMBLY MASTERS, PM
        uploads = new List<NCMT_Data_Upload__c>();
       //changing GSA_2021_PM_ASMUNI to GSA_PM_ASMUNI - SFWS-1614
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_PM_ASMUNI',
            Text_2__c = 'PM_ASMUNI',
            Text_1__c = 'PM020301'
        );
        uploads.add(up);

        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_PM_ASMUNI',
            Text_2__c = 'ASMUNI',
            Text_1__c = 'PM020'
        );
        uploads.add(up);
       //SFWS-1611 Changing GSA_2021_PM_SEQ to GSA_PM_SEQ
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_PM_SEQ',
            Text_1__c = 'Limit Building Entry Points',
            Text_2__c = 'PM020301',
            Number_1__c = 1,
            Number_2__c = 2,
            Number_3__c = 3,
            Number_4__c = 4
        );
        uploads.add(up);

        insert uploads;

        assDetails = [Select Id from NCMT_Assembly_Lookup_Detail__c where Name <> null];
        System.assertEquals(4, assDetails.size());

        //LABOR RESOURCES
       //SFWS-1642 Changing GSA_2021_STD_LAB to GSA_STD_LAB
        uploads = new List<NCMT_Data_Upload__c>();
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_STD_LAB',
            Text_1__c = 'CREW'
        );
        uploads.add(up);

       //SFWS-1643 Changing GSA_2021_STD_LAB_AIO to GSA_STD_LAB_AIO
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_STD_LAB_AIO',
            Text_1__c = 'Blah',
            Text_2__c = 'CREW',
            Number_1__c = 1
        );
        uploads.add(up);

        insert uploads;

        List<NCMT_Labor_Resource__c> labRecs = [Select Id from NCMT_Labor_Resource__c where Name <> null];
        System.assertEquals(1, labRecs.size());

        //EQUIPMENT / CREW
       //SFWS-1644 Changing GSA_2021_EQ_CREW  to GSA_EQ_CREW

        uploads = new List<NCMT_Data_Upload__c>();
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_EQ_CREW',
            Text_1__c = 'Some',
            Text_2__c = 'EQUIP',
            Text_3__c = 'Other'
        );
        uploads.add(up);
      //SFWS-1642 Changing GSA_2021_STD_LAB to GSA_STD_LAB
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_STD_LAB',
            Text_1__c = 'LABOR',
            Number_1__c = 1
        );
        uploads.add(up);
       //SFWS-1651 Changing GSA_2021_STD_CREW  to GSA_STD_CREW 
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_STD_CREW',
            Text_1__c = 'EQUIP',
            Text_2__c = 'LABOR',
            Number_1__c = 1
        );
        uploads.add(up);

        insert uploads;

        List<NCMT_Equipment__c> equips = [Select Id from NCMT_Equipment__c where Name <> null];
        System.assertEquals(1, equips.size());

        List<NCMT_Crew_Master__c> crewMasters = [Select Id from NCMT_Crew_Master__c where Name <> null];
        System.assertEquals(1, crewMasters.size());

        List<NCMT_Crew_Details__c> crews = [Select Id from NCMT_Crew_Details__c where Name <> null];
        System.assertEquals(1, crewMasters.size());

        // changing GSA_2021_ASMCSI16 to GSA_ASMCSI16

        //DES ITEMS / Assembly Lines
        uploads = new List<NCMT_Data_Upload__c>();
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_ASMCSI16',
            Text_1__c = 'Code',
            Text_2__c = 'Descrip'
        );
        uploads.add(up);
        
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_2021_FAC_ASMCSI16',
            Text_1__c = 'Code',
            Text_2__c = 'Descrip'
        );
        uploads.add(up);
       // changing GSA_2021_GM MF2014 CSI to GSA_GM MF2014 CSI 
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_GM MF2014 CSI',
            Text_1__c = 'Code',
            Text_2__c = 'Descrip'
        );
        uploads.add(up);

		// SFWS-1645 - Changing  GSA_2021_ASSMUP to GSA_ASSMUP
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_ASSMUP',
            Text_1__c = 'EQUIP',
            Text_2__c = 'LABOR1',
            Text_3__c = 'A10203013251',
            Text_4__c = 'EQUIP',
            Text_5__c = 'EQUIP',
            Number_1__c = 1,
            Number_2__c = 2,
            Number_3__c = 3,
            Number_4__c = 4,
            Number_5__c = 5,
            Number_6__c = 6,
            Number_7__c = 7,
            Number_8__c = 8
        );
        uploads.add(up);
        
        /*up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_2021_FAC_ASSMUP',
            Text_1__c = 'EQUIP',
            Text_2__c = 'LABOR2',
            Text_3__c = 'A10203013252',
            Text_4__c = 'EQUIP',
            Text_5__c = 'EQUIP',
            Number_1__c = 1,
            Number_2__c = 2,
            Number_3__c = 3,
            Number_4__c = 4,
            Number_5__c = 5,
            Number_6__c = 6,
            Number_7__c = 7,
            Number_8__c = 8
        );
        uploads.add(up);*/

        insert uploads;

        equips = [Select Id from NCMT_Equipment__c where Name <> null];
        System.assertEquals(1, equips.size());

        crewMasters = [Select Id from NCMT_Crew_Master__c where Name <> null];
        System.assertEquals(1, crewMasters.size());

        crews = [Select Id from NCMT_Crew_Details__c where Name <> null];
        System.assertEquals(1, crewMasters.size());

        List<NCMT_DES_Lookup_details__c> desitems = [Select Id from NCMT_DES_Lookup_details__c where Name <> null];
        System.assertEquals(1, desitems.size());
       //SFWS-1653 - changing GSA_2021_ASSM to GSA_ASSM
        uploads = new List<NCMT_Data_Upload__c>();
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_ASSM',
            Text_1__c = 'EQUIP',
            Text_2__c = 'A1020301',
            Text_3__c = 'A10203013251',
            Text_4__c = 'A10203013251',
            Text_5__c = 'EQUIP',
            Number_1__c = 1,
            Number_2__c = 2,
            Number_3__c = 3,
            Number_4__c = 4,
            Number_5__c = 5,
            Number_6__c = 6,
            Number_7__c = 7,
            Number_8__c = 8
        );
        uploads.add(up);
            //  SFWS-1652 - changing Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook_12092020 to Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook
        uploads = new List<NCMT_Data_Upload__c>();
        up = new NCMT_Data_Upload__c(
            Upload__c = 'Copy of UpdatedGSAassembliesANDUCLsFMR-PMAINTbook',
            Text_1__c = 'EQUIP',
            Text_2__c = 'A1020301',
            Text_3__c = 'A10203013251',
            Text_4__c = 'A10203013251',
            Text_5__c = 'EQUIP',
            Number_1__c = 1,
            Number_2__c = 2,
            Number_3__c = 3,
            Number_4__c = 4,
            Number_5__c = 5,
            Number_6__c = 6,
            Number_7__c = 7,
            Number_8__c = 8
        );
        uploads.add(up);
        insert uploads;

        List<NCMT_Assembly_Lookup_Item__c> assitems = [Select Id from NCMT_Assembly_Lookup_Item__c where Name <> null];
        System.assertEquals(1, assitems.size());
       
        //Frequencies
        //  SFWS-1657 - changing GSA_2021_PM_PRN to GSA_PM_PRN
        uploads = new List<NCMT_Data_Upload__c>();
        up = new NCMT_Data_Upload__c(
            Upload__c = 'GSA_PM_PRN',
            Text_1__c = 'Code',
            Text_2__c = 'A1020301'
        );
        uploads.add(up);
        insert uploads;
        
        //Location Markups
        uploads = new List<NCMT_Data_Upload__c>();
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'LocationMarkup',
            Text_1__c = 'EQMD',
            Text_2__c = 'Alabama',
            Number_1__c = 25
        );
        uploads.add(up);
        insert uploads;
        
        //Subcontractors
        uploads = new List<NCMT_Data_Upload__c>();
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'Subcon',
            Text_1__c = 'AB',
            Text_2__c = 'Abatement',
            Number_1__c = 2,
            Number_2__c = 10,
            Number_3__c = 10
        );
        uploads.add(up);
        insert uploads;
        
        //Express Menu
        //First add data for 2020
        NCMT_Cost_Category__C cat = [SELECT Id FROM NCMT_Cost_Category__C WHERE Name =: 'A10' LIMIT 1];
        NCMT_Assembly_Lookup_detail__C x = new NCMT_Assembly_Lookup_detail__c(
        	File_Type__c = 'GSAAssemblies',
            Fiscal_Year__c = '2020',
            Level_2__c = cat.Id,
            Assembly_Number__c = 'ass1'
        );
        insert x;
        
        NCMT_DES_Lookup_details__c d = [SELECT Id, Line_Item_Number__c FROM NCMT_DES_Lookup_details__c LIMIT 1];
        
        NCMT_Assembly_Lookup_Item__c i = new NCMT_Assembly_Lookup_Item__C(
        	Assembly_Lookup_Detail__c = x.Id,
            NCMT_Master_Format_Lookup__c = d.Id,
            Conversion_Factor__c = 1,
            Master_Format_Line_Item_Number__c = d.Line_Item_Number__c,
            Fiscal_Year__c = '2020'
        );
        insert i;
        
        uploads = new List<NCMT_Data_Upload__c>();
        up = new NCMT_Data_Upload__c(
        	Upload__c = 'Express',
            Text_1__c = 'go'
        );
        uploads.add(up);
        insert uploads;
    }
    
    @isTest
    public static void test_2021_data_upload2() {
        
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
        
        List<NCMT_Location_Parameters__c> locParams = [SELECT Id FROM NCMT_Location_Parameters__c 
                                                      WHERE Fiscal_Year__c =: '2021'];
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
                                                               WHERE Fiscal_Year__c =: '2021'];
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
                                                              WHERE Fiscal_Year__C =: '2021'];
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
        
        //Test Remove Duplicates
        //NCMT_DataUpload_TriggerHandler.removeDuplicates();
		//NCMT_DataUpload_TriggerHandler.removeDuplicates_Items();
    	NCMT_DataUpload_TriggerHandler.removeAssemblyLookupDetailDuplicates();
        NCMT_DataUpload_TriggerHandler.removeDESLookupDetailsDuplicates();
        NCMT_DataUpload_TriggerHandler.removeAssemblyLookupItemDuplicates();
    }
}