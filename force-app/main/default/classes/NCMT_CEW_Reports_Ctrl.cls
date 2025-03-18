public with sharing class NCMT_CEW_Reports_Ctrl {
    public class reportWrapper {
        @AuraEnabled public NCMT_Project__c  project {get; set;}
        @AuraEnabled public List<NCMT_Project_Cost_Summary__c> pcs {get; set;}
        @AuraEnabled public Professional_Service_Estimate__c proServEst {get; set;}
        @AuraEnabled public List<AggregateResult> workDescTotals {get; set;}
        @AuraEnabled public Decimal rwaDirectCost {get;set;}
    }
    @AuraEnabled
    public static reportWrapper getReportData(string projectId){
        reportWrapper reportData = new reportWrapper();
        reportData.project = getProjectData(projectId);
        reportData.pcs = getPcsData(projectId);
        reportData.proServEst = getProServiceEst(projectId);
        reportData.workDescTotals = getWDTotals(projectId);
        reportData.rwaDirectCost = getRWADirectCost(projectId);
        return reportData;
    }

    public static NCMT_Project__c getProjectData(string projectId){
        NCMT_Project__c project = [SELECT name, Location__c, City__c, State__c, Project_type__c, Project_Phases__c,
                                   Phasing_Plan_Construction__c,  Project_Status__c, Project_Area_GSF__c, 
                                   CEW_Occupancy_Status__c, CreatedBy.Name,Regional_Office_Cost_Mgt_QC__r.Name,
                                   Central_Office_Cost_Mgt_QA__r.Name,Building_Type__c,


                                   
                                   
                                   CEW_Total_Cost_W_O_Markup__c, CEW_Total_Direct_Cost_1__c, CEW_Total_Direct_Cost_2__c,
                                   Design_and_Site_Contingency__c, General_Contractor_Overhead_Profit_Bonds__c, 
                                   Phasing_Premium__c, Special_Use_Gross_Receipts_Tax__c, EMIC__c,
                                   Total_Escalation__c, Total_Escalation_CPE__c,
                                   CEW_Item1__c, CEW_Item2__c, CEW_Item3__c,
                                   CEW_Item1_Description__c, CEW_Item2_Description__c, CEW_Item3_Description__c,


                                   CEW_Land_Cost__c, CEW_Demolition__c, CEW_Reloc_Associated_w_Site_Purchase__c,


                                   Basis_Date_Of_Estimate__c, Start_Construction__c, Mid_Point_of_Construction__c,
                                   Construction_Contingency__c , Art_In_Architecture__c, EDRC__c, 
                                   CEW_ECC1__c, CEW_ECCA__c, ETPC__c
                                   FROM  NCMT_Project__c
                                   WHERE id= :projectId];
        return project;
        
    }    
    public static List<NCMT_Project_Cost_Summary__c> getPcsData(string projectId){
         List<NCMT_Project_Cost_Summary__c> pcs = [SELECT Cost_Category_Code__c, Cost_Category_Description__c, CEW_Total_Ditect_Cost__c, CEW_ECC__c, CEW_Total_Cost_GSF__c
                                                  FROM NCMT_Project_Cost_Summary__c 
                                                  WHERE Project_Name__c = :projectId
                                                  AND CEW_Total_Ditect_Cost__c > 0
                                                  ];
        return pcs;
    }
    public static Professional_Service_Estimate__c getProServiceEst(string projectId){
        Professional_Service_Estimate__c proServ = [SELECT Anticipated_Date_of_Design_Award__c,
                                                    Design_AE_Percent__c, Design_CM_as_Agent_and_CM_as_Const__c,Design_Cx_Percent__c, Total_AE_Percent__c,

                                                    Construction_AE_Percent__c, Construction_CM_as_Agent_CM_as_Const__c, Construction_Cx_Percent__c 
                                                    FROM Professional_Service_Estimate__c 
                                                    WHERE NCMT_Project__c = :projectId];
        return proServ;
    }
    public static List<AggregateResult> getWDTotals(string projectId){
           List<AggregateResult> ar = [SELECT Number__c, SUM(Total_Direct_Cost__c) Total_Direct_Cost__c, SUM(CECCA__c) CECCA__c, SUM(ECCA__c) ECCA__c, SUM(ECC__c) ECC__c, 
                                                         SUM(Impact_EDRC__c) EDRC__c, SUM (Impact_EMIC__c) EMIC__c, SUM(ETPC__c) ETPC__c
                                FROM NCMT_Work_Description__c
                                WHERE NCMT_Project__c = :projectId 
                                GROUP BY Number__c];
        return ar;
    }

    public static Decimal getRWADirectCost(string projectId){
        Decimal directCost = 0;
        for (NCMT_CEW_Project_Agency__c projAgency : [Select Id, Totals_RWA_Cost_W_O_MarkupF__c 
            from NCMT_CEW_Project_Agency__c where NCMT_Project__c =: projectId]
        ){
            directCost += projAgency.Totals_RWA_Cost_W_O_MarkupF__c;
        }
        return directCost;
    }
}