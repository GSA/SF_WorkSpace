@isTest
public class NCMT_TestDESProjects {
    
    @testSetup public static void setup()
    {
        NCMT_TestDataClass.CreateDESProject('New Construction - DES', 'testDESProjCodeCovDESOff6','Office','Virginia','State Average',
                                        'Design Build - Bridging','GSA Markups', false, false, false, false);
                                      
    }

    @isTest public static void test_basic()
    {
        
        NCMT_Project__c proj  = [SELECT Id, Name, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c,
            Project_Phases__c, Project_Status__c, Project_Delivery_Method__c, 
            Mid_Point_of_Construction__c, Project_SubPhases__c, State__c, City__c,
            Purpose_of_Estimate__c, Above_Ground__c, Location__c, Below_Ground__c,
            Below_Grade__C, Building_Cost_Type__c, Building_Heigtht__c, Building_Quality__c,
            Level_of_Protection__c, Remoteness__c, Gross_Area__c, Useable_Area__c, 
            Housing_Plan__c, Parking_Deck__c, Cost_Parameter_Date__c, CEW_Item1__c,
            Project_Area_GSF__c, Include_Exclude_AIA__c, 
            CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
            CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
            CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
            CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
            CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
        FROM NCMT_Project__c ORDER By CreatedDate DESC][0];

        Schema.DescribeSObjectResult cfrSchemaDS = Schema.SObjectType.NCMT_DES_Items__c;
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NCMT_Project__c;
        Map<String,Schema.RecordTypeInfo> ProjTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> DESItemInfo = cfrSchemaDS.getRecordTypeInfosByName();

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

        NCMT_Crew_Master__c objcrewmaster = [select Id from NCMT_Crew_Master__c where Name ='B86'];
            //and id in :listCrewMaster
                                          

        //TODO: Do this by test....
        String strProjectType = 'New Construction - DES';
        String strRecordTypeName;
        if(strProjectType == 'New Construction - DES'){
            strRecordTypeName = 'New Construction - DES';
        }else{
            strRecordTypeName = 'Repair & Alteration - DES';
        }
        NCMT_Project__c Projupd2 = new NCMT_Project__c (id = null, recordtypeid = ProjTypeInfo.get(strRecordTypeName).getRecordTypeId());
        
        for (NCMT_Tree_structure__c t : [Select Id, Branch_Name__c 
            from NCMT_Tree_Structure__c where Project_ID__c =: proj.Id]
        ){
            if (t.Branch_Name__c == 'Building1'){
                treestruc1 = t;
            } else if (t.Branch_Name__c == 'Floor1'){
                treestruc2 = t;
            } else {
                treestruc = t;
            }
        }
        for (NCMT_DES_Items__c di : [Select Id from NCMT_DES_Items__c where Item_Type__c = 'Master Format'])
            DESItem = di;


        NCMT_ProjectTriggerValue.firstRun = true;
        Projupd2.id = Proj.id;
        Projupd2.Project_type__c = strProjectType;
        Projupd2.Include_Exclude_AIA__c = true;
        Projupd2.Project_Delivery_Method__c = proj.Project_Delivery_Method__c; //strProjDelMethod;
        Projupd2.Project_SubPhases__c = '75% Construction Documents';  
        update Projupd2;
        system.assertNotEquals(NULL,Projupd2);  

        Test.startTest();
    
        //update tree structure
        treestrucupd.id = treestruc2.id;
        treestrucupd.Relatedtree__c = treestruc.id;
        update treestrucupd;
        system.assertNotEquals(NULL,treestrucupd);
        
        //update DES Item
        DESItemupd.id = DESItem.id; 
        DESItemupd.NCMT_Crew_Master__c = objcrewmaster.Id;
        update DESItemupd;
        system.assertNotEquals(NULL,DESItemupd); 
        
             
        

        DESItemD.Project_Cost_Summary_ID__c   = ProjCostSummary.id;
        DESItemD.Tree_structure__c = treestruc2.id;
        DESItemD.id = DESItem.id;
        Delete DESItemD;
        system.assertNotEquals(NULL,DESItemD); 
         
        Test.stopTest();

        Delete treestruc1;
        system.assertNotEquals(NULL,treestruc1);
        
        Delete treestruc2;
        system.assertNotEquals(NULL,treestruc2);  
    }
}