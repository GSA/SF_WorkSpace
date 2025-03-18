@isTest
public class NCMT_TriageRiskToolCtrl_LC_Test {
	
    @testSetup static void setup()
    {
        
        List <NCMT_Project_Deliverable__c> deliverables = Test.loadData(NCMT_Project_Deliverable__c.sObjectType,'NCMT_Project_Deliverables_Test_Data');
       
        Date CostParaDate = date.newinstance(2016, 10, 1);
        Date MidPtConst = date.newInstance(2019, 12, 1);
        NCMT_CustomSettings__c NCMT_Cust_settings = new NCMT_CustomSettings__c();
        NCMT_Cust_settings.Cost_Parameter_Date__c = CostParaDate;
        NCMT_Cust_settings.Professional_Service_Cost_Parameter_Date__c = CostParaDate;
        
        insert NCMT_Cust_settings;
        
        List <AE_CMa_CMc_Cx__c> lstAE_CMa_CMc_Cx = Test.loadData(AE_CMa_CMc_Cx__c.sObjectType,'NCMT_AE_CMa_CMc_Cx');
        
        List <Professional_Service_Estimate_Parameter__c> lstProfessional_Service_Estimate_Parameter = Test.loadData(Professional_Service_Estimate_Parameter__c.sObjectType, 'NCMT_Professional_Service_Estimate_Parameter');
        
        List <System_Level_Parameter__c> lstsystemlevelparameter = Test.loadData(System_Level_Parameter__c.sObjectType, 'NCMT_System_Level_Parameter');
        
        List <NCMT_Building_Parameter__c> lstbuilding = Test.loadData(NCMT_Building_Parameter__c.sObjectType, 'NCMT_Building_Parameter');
        
        List <NCMT_Building_Height_Parameter__c> lstbldgheight = Test.loadData(NCMT_Building_Height_Parameter__c.sObjectType, 'NCMT_Building_Height_Parameter');
        
        List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');
        List <NCMT_Quality_Code_Parameter__c> lstqualitycodeparameter = Test.loadData(NCMT_Quality_Code_Parameter__c.sobjectType, 'NCMT_Quality_Code_Parameter');
        
        List <NCMT_Quality_Code_Lookup__c> lstqualitycodelookup = Test.loadData(NCMT_Quality_Code_Lookup__c.sObjectType, 'NCMT_Quality_Code_Lookup');
        
        
        List <NCMT_Cost_Category__c> listCostCategories = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_DES_Cost_Category_Assemblies');
        system.debug('listCostCategories'+ listCostCategories[0].Estimate_Format__c);
        
        List <NCMT_Assembly_Lookup_detail__c> lstLookupDetails = Test.loadData(NCMT_Assembly_Lookup_detail__c.sobjectType, 'NCMT_Assembly_Lookup_Detail');
        
        List <NCMT_Cost_Category__c> listCostCategoriesGSA = Test.loadData(NCMT_Cost_Category__c.sObjectType, 'NCMT_Cost_Category_GSA_Assemblies');
       
        List <NCMT_Assembly_Lookup_detail__c> lstLookupDetailsGSA = Test.loadData(NCMT_Assembly_Lookup_detail__c.sobjectType, 'NCMT_Assembly_Master_GSA_Assemblies');
        
        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                   and State__c = 'Virginia' and Name = 'State Average'];        
        NCMT_Project__c Proj = new NCMT_Project__c ();

        Proj.Project_type__c = 'Repair & Alteration - CEW';
        Proj.Estimate_Type_Proj__c  = 'Cost Estimating Workbook';
        Proj.Building_Type__c = 'Office';
        Proj.Project_Phases__c ='Pre-Planning';
        Proj.Project_Status__c= 'Draft';
        Proj.Project_Delivery_Method__c= 'Design-Bid-Build';
        Proj.Mid_Point_of_Construction__c= MidPtConst;
        Proj.Project_SubPhases__c='Pre-Planning Phase';
        Proj.Name = 'testProjectDes';
        Proj.State__c = 'Virginia';
        Proj.City__c = 'State Average'; 
        Proj.Purpose_of_Estimate__c = 'Project Planning / Budgeting';
        Proj.Above_Ground__c = 2;  
        Proj.Location__c = objlocation.Id;
        Proj.Below_Ground__c = 0;
        Proj.Below_grade__c = 0;
        Proj.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj.Building_Quality__c = 'P100: Baseline';        
        Proj.Level_of_Protection__c = 'Level II - Low';
        Proj.Remoteness__c = 'Urban';
        Proj.Gross_Area__c = false;
        Proj.Useable_Area__c = false;
        Proj.Housing_Plan__c = false;
        Proj.Parking_Deck__c = false;
        Proj.Cost_Parameter_Date__c = CostParaDate;
        Proj.Project_Area_GSF__c = 2222;
        insert Proj;
        
    }
    
    static testMethod void test_Init()
    {
        NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        
        ApexPages.StandardController controller = new ApexPages.StandardController(proj);
        NCMT_TriageRiskToolCtrl_LC triageCtrl = new NCMT_TriageRiskToolCtrl_LC(controller);
        
		NCMT_TriageRiskToolCtrl_LC.triageWrapper wrap = NCMT_TriageRiskToolCtrl_LC.init(proj.Id); 
        
        System.assertEquals(proj.Id, wrap.project.Id);
        System.assert(wrap.filterDeliverable != null);
    }
    
    static testMethod void test_Filter()
    {
        //NCMT_Project__c proj = [SELECT Id, Name FROM NCMT_Project__c LIMIT 1];
        
        NCMT_Project_Deliverable__c filt = new NCMT_Project_Deliverable__c(
        	Funding_Type__c = 'BA 51',
            Project_type__c = 'New Construction',
            Project_Delivery_Method__c = 'Design-Bid-Build',
            Project_Budget__c = 'Prospectus <> $5M',
            Project_Phases__c = 'Project Initiation',
            Project_SubPhase__c = 'Scope Definition'
        );
        
		List<NCMT_Project_Deliverable__c> delivs = NCMT_TriageRiskToolCtrl_LC.getDeliverables(filt); 
        System.assertEquals(3, delivs.size());
        
        filt = new NCMT_Project_Deliverable__c(
        	Funding_Type__c = 'BA 666',
            Project_type__c = 'New Construction',
            Project_Delivery_Method__c = 'Design-Bid-Build',
            Project_Budget__c = 'Prospectus <> $5M',
            Project_Phases__c = 'Project Initiation',
            Project_SubPhase__c = 'Scope Definition'
        );
        
		delivs = NCMT_TriageRiskToolCtrl_LC.getDeliverables(filt); 
        System.assertEquals(0, delivs.size());
    }
}