public with sharing class NCMT_TIReport_Controller {
     @AuraEnabled
    public static reportData getTIReportData(string housingplanid, string projectid){
        reportData response = new reportData();
        //system.debug('projectId==='+projectId);
        //string strNCMTID = projectid.substring(0,projectid.length()-3);   
        /*response.ProjectDetails = [select id, Name,Basis_Date_Of_Estimate__c, Building_Type__c,Brief_Narrative__c, Building_Heigtht__c, Building_Quality__c, CreatedDate,
                                            CreatedBy.Name, GSA_Project__c, Level_of_Protection__c, Location__c, Location__r.State__c, Location__r.City__c, Project_type__c, 
                                            City__c, State__c, Project_Phases__c, Project_SubPhases__c,Regional_Portfolio__c, Regional_Portfolio__r.Name, Project_Status__c,Total_GSF__c,
                                            Project_Seismic_Design_Category__c, RegionCode__c , Start_Construction__c, Location__r.Name,
                                            Building_Cost_Type__c,Gross_Area__c,Useable_Area__c,Housing_Plan__c,Entry_Type__c,Calculated_Site_Area__c,Override_Calculated_Site_Area__c
                                    from NCMT_Project__c 
                                    where id= :projectid];
        if(string.isNotBlank(response.ProjectDetails.Regional_Portfolio__c)){
            response.Regional_Portfolio = response.ProjectDetails.Regional_Portfolio__r.Name;
        }*/
        
        //housingplan data
        response.hpData = [select id, Name,PBS_Agency_Bureau_Name__c,PBS_Agency_AB_Code__c,Housing_Plan_Type__c,Housing_Plan_Name__c,
                                  Total_USF__c,Project__r.Name,Project__r.City__c,Project__r.State__c,Project__r.Design_and_Site_Contingency__c,
                                  Project__r.General_Contractor_Overhead_Profit_Bonds__c,Project__r.Total_Escalation__c,
                                  Project__r.Total_Escalation_CPE__c,Project__r.Construction_Contingency__c,
                                  Project__r.Art_In_Architecture__c,Project__r.EDRC__c,Project__r.EMIC__c, Project__r.TI_Adjustment_Factor__c
                                 from NCMT_Housing_Plan__c
                                 where  id = :housingplanid];
        //for markups
        response.Design = response.hpData.Project__r.Design_and_Site_Contingency__c/100;
        response.General = response.hpData.Project__r.General_Contractor_Overhead_Profit_Bonds__c/100;
        if(response.hpData.Project__r.Total_Escalation__c!=null){
        response.Escmarket = response.hpData.Project__r.Total_Escalation__c/100;
        }   
        if(response.hpData.Project__r.Total_Escalation_CPE__c != null){
        	response.EscCPE = response.hpData.Project__r.Total_Escalation_CPE__c/100;
        }
        response.Construct = response.hpData.Project__r.Construction_Contingency__c/100;
        response.Art = response.hpData.Project__r.Art_In_Architecture__c/100;
        response.EDRC = response.hpData.Project__r.EDRC__c/100;
        response.EMIC = response.hpData.Project__r.EMIC__c/100;
        response.TIADJFactor = response.hpdata.Project__r.TI_Adjustment_Factor__c;
        response.USF = response.hpdata.Total_USF__c;
        
        //for TITRCS Cost details
        map<string,costDetails> costDetailsMap = new map<string,costDetails>();
        for(NCMT_TI_TRCS_Cost_Detail__c titrcsrec: [select id, Name,Cost_Category__c,TI_TRCS_Cost_Criterion__c,TI_Total_Cost__c,TRCS_Total_Cost__c,
                                                           Total_Cost__c
                                                      from NCMT_TI_TRCS_Cost_Detail__c
                                                      where  NCMT_Housing_Plan__c = :housingplanid order by Cost_Category__c]){
                                                          
                                          if(costDetailsMap.containsKey(titrcsrec.Cost_Category__c)){
                                              costDetails temp = costDetailsMap.get(titrcsrec.Cost_Category__c);
                                              temp.description = titrcsrec.TI_TRCS_Cost_Criterion__c;
                                              temp.totalTICost = (temp.totalTICost + (titrcsrec.TI_Total_Cost__c * response.TIADJFactor)) ;
                                              temp.totalTRCSCost = (temp.totalTRCSCost+(titrcsrec.TRCS_Total_Cost__c * response.TIADJFactor)) ;
                                              temp.total = temp.totalTICost + temp.totalTRCSCost;
                                              costDetailsMap.put(titrcsrec.Cost_Category__c,temp);
                                          } 
                                          else{
                                            costDetailsMap.put(titrcsrec.Cost_Category__c,new costDetails(titrcsrec.Cost_Category__c,titrcsrec.TI_TRCS_Cost_Criterion__c,(titrcsrec.TI_Total_Cost__c * response.TIADJFactor),(titrcsrec.TRCS_Total_Cost__c * response.TIADJFactor),titrcsrec.Total_Cost__c));  
                                          }
                                                          
                                          response.TotalTICost = (response.TotalTICost + (titrcsrec.TI_Total_Cost__c * response.TIADJFactor));
                                          response.TotalTRCSCost = (response.TotalTRCSCost + (titrcsrec.TRCS_Total_Cost__c * response.TIADJFactor)) ;
                                          response.TotalTITRCSCost = response.TotalTICost + response.TotalTRCSCost;
                                         
                                      }
        for(string code : costDetailsMap.keyset()){
            costDetails costDetail1 = costDetailsMap.get(code);
            costDetail1.ECCA = ((costDetail1.total * (1 + response.Design)) * (1 + response.General)) * (1+
                                response.Escmarket + response.EscCPE);
            costDetail1.ECC = ((costDetail1.ECCA *(1+ response.Construct))*(1+ response.Art));
            costDetail1.ETPC = (costDetail1.ECC *(1+ response.EDRC + response.EMIC));
            costDetail1.ECCAUSF = costDetail1.ECCA/response.USF;
            costDetail1.ECCUSF = costDetail1.ECC/response.USF;
            costDetail1.ETPCUSF = costDetail1.ETPC/response.USF; 
             
            costDetailsMap.put(code,costDetail1);
        }
        response.SubTIDesign =   response.TotalTICost * response.Design;
        response.SubTRCSDesign =   response.TotalTRCSCost * response.Design; 
        response.SubTITRCSDesign =   response.TotalTITRCSCost * response.Design;  
        
        response.SubtotTIDesign =   response.TotalTICost + response.SubTIDesign;
        response.SubtotTRCSDesign =   response.TotalTRCSCost + response.SubTRCSDesign; 
        response.SubtotTITRCSDesign =   response.TotalTITRCSCost + response.SubTITRCSDesign;
        
        response.SubTIGeneral =   response.SubtotTIDesign * response.General;
        response.SubTRCSGeneral =   response.SubtotTRCSDesign * response.General; 
        response.SubTITRCSGeneral =   response.SubtotTITRCSDesign * response.General;  
        
        response.SubtotTIGeneral =   response.SubtotTIDesign + response.SubTIGeneral;
        response.SubtotTRCSGeneral =   response.SubtotTRCSDesign + response.SubTRCSGeneral; 
        response.SubtotTITRCSGeneral =   response.SubtotTITRCSDesign + response.SubTITRCSGeneral; 
        
        response.SubTIEscmarket =   response.SubtotTIGeneral * response.Escmarket;
        response.SubTRCSEscmarket =   response.SubtotTRCSGeneral * response.Escmarket; 
        response.SubTITRCSEscmarket =   response.SubtotTITRCSGeneral * response.Escmarket;
        
        response.SubTIEscCPE =   response.SubtotTIGeneral * response.EscCPE;
        response.SubTRCSEscCPE =   response.SubtotTRCSGeneral * response.EscCPE; 
        response.SubTITRCSEscCPE =   response.SubtotTITRCSGeneral * response.EscCPE; 
        
        response.SubtotTIECCA =   response.SubtotTIGeneral + response.SubTIEscmarket + response.SubTIEscCPE;
        response.SubtotTRCSECCA =   response.SubtotTRCSGeneral + response.SubTRCSEscmarket + response.SubTRCSEscCPE; 
        response.SubtotTITRCSECCA =   response.SubtotTITRCSGeneral + response.SubTITRCSEscmarket + response.SubTITRCSEscCPE; 
        
        response.SubTIConstruct =   response.SubtotTIECCA * response.Construct;
        response.SubTRCSConstruct =   response.SubtotTRCSECCA * response.Construct; 
        response.SubTITRCSConstruct =   response.SubtotTITRCSECCA * response.Construct;  
        
        response.SubtotTIECC =   response.SubtotTIECCA + response.SubTIConstruct;
        response.SubtotTRCSECC =   response.SubtotTRCSECCA + response.SubTRCSConstruct; 
        response.SubtotTITRCSECC =   response.SubtotTITRCSECCA + response.SubTITRCSConstruct;
        
        response.SubTIArt =   response.SubtotTIECC * response.Art;
        response.SubTRCSArt =   response.SubtotTRCSECC * response.Art; 
        response.SubTITRCSArt =   response.SubtotTITRCSECC * response.Art;  
        
        response.totTIECC =   response.SubtotTIECC + response.SubTIArt;
        response.totTRCSECC =   response.SubtotTRCSECC + response.SubTRCSArt; 
        response.totTITRCSECC =   response.SubtotTITRCSECC + response.SubTITRCSArt;
        
        response.SubTIEDRC =   response.totTIECC * response.EDRC * 0.65;
        response.SubTRCSEDRC =   response.totTRCSECC * response.EDRC * 0.65; 
        response.SubTITRCSEDRC =   response.totTITRCSECC * response.EDRC * 0.65;  
        
        response.SubTIEMIC =   response.totTIECC * response.EMIC;
        response.SubTRCSEMIC =   response.totTRCSECC * response.EMIC; 
        response.SubTITRCSEMIC =   response.totTITRCSECC * response.EMIC;  
        
        response.totTIETPC =   response.totTIECC + response.SubTIEDRC + response.SubTIEMIC;
        response.totTRCSETPC =   response.totTRCSECC + response.SubTRCSEDRC + response.SubTRCSEMIC; 
        response.totTITRCSETPC =   response.totTITRCSECC +  response.SubTITRCSEDRC + response.SubTITRCSEMIC;
                
        if(costDetailsMap.values().size() > 0){
            response.costDetailsValues=costDetailsMap.values();
        }
        
        return response;
        
    }
 
    public class reportData{
        @AuraEnabled public NCMT_Project__c ProjectDetails{get;set;}
        @AuraEnabled public NCMT_Housing_Plan__c hpData{get;set;}
        @Auraenabled public string Regional_Portfolio{get;set;}
        @Auraenabled public list<costDetails> costDetailsValues{get;set;}
        @Auraenabled public decimal TotalTICost{get;set;}
        @Auraenabled public decimal TotalTRCSCost{get;set;}
        @Auraenabled public decimal TotalTITRCSCost{get;set;}
        @Auraenabled public decimal Design{get;set;}
        @Auraenabled public decimal General{get;set;}
        @Auraenabled public decimal Escmarket{get;set;}
        @Auraenabled public decimal EscCPE{get;set;}
        @Auraenabled public decimal Construct{get;set;}
        @Auraenabled public decimal Art{get;set;}
        @Auraenabled public decimal EDRC{get;set;}
        @Auraenabled public decimal EMIC{get;set;}
        @Auraenabled public decimal TIADJFactor{get;set;}
        @Auraenabled public decimal USF{get;set;}
        @Auraenabled public decimal SubTIDesign{get;set;}
        @Auraenabled public decimal SubTRCSDesign{get;set;}
        @Auraenabled public decimal SubTITRCSDesign{get;set;}
        @Auraenabled public decimal SubtotTIDesign{get;set;}
        @Auraenabled public decimal SubtotTRCSDesign{get;set;}
        @Auraenabled public decimal SubtotTITRCSDesign{get;set;}
        @Auraenabled public decimal SubTIGeneral{get;set;}
        @Auraenabled public decimal SubTRCSGeneral{get;set;}
        @Auraenabled public decimal SubTITRCSGeneral{get;set;}
        @Auraenabled public decimal SubtotTIGeneral{get;set;}
        @Auraenabled public decimal SubtotTRCSGeneral{get;set;}
        @Auraenabled public decimal SubtotTITRCSGeneral{get;set;}
        @Auraenabled public decimal SubTIEscmarket{get;set;}
        @Auraenabled public decimal SubTRCSEscmarket{get;set;}
        @Auraenabled public decimal SubTITRCSEscmarket{get;set;}
        @Auraenabled public decimal SubTIEscCPE{get;set;}
        @Auraenabled public decimal SubTRCSEscCPE{get;set;}
        @Auraenabled public decimal SubTITRCSEscCPE{get;set;}
        @Auraenabled public decimal SubtotTIECCA{get;set;}
        @Auraenabled public decimal SubtotTRCSECCA{get;set;}
        @Auraenabled public decimal SubtotTITRCSECCA{get;set;}
        @Auraenabled public decimal SubTIConstruct{get;set;}
        @Auraenabled public decimal SubTRCSConstruct{get;set;}
        @Auraenabled public decimal SubTITRCSConstruct{get;set;}
        @Auraenabled public decimal SubtotTIECC{get;set;}
        @Auraenabled public decimal SubtotTRCSECC{get;set;}
        @Auraenabled public decimal SubtotTITRCSECC{get;set;}
        @Auraenabled public decimal SubTIArt{get;set;}
        @Auraenabled public decimal SubTRCSArt{get;set;}
        @Auraenabled public decimal SubTITRCSArt{get;set;}
        @Auraenabled public decimal totTIECC{get;set;}
        @Auraenabled public decimal totTRCSECC{get;set;}
        @Auraenabled public decimal totTITRCSECC{get;set;}
        @Auraenabled public decimal SubTIEDRC{get;set;}
        @Auraenabled public decimal SubTRCSEDRC{get;set;}
        @Auraenabled public decimal SubTITRCSEDRC{get;set;}
        @Auraenabled public decimal SubTIEMIC{get;set;}
        @Auraenabled public decimal SubTRCSEMIC{get;set;}
        @Auraenabled public decimal SubTITRCSEMIC{get;set;}
        @Auraenabled public decimal totTIETPC{get;set;}
        @Auraenabled public decimal totTRCSETPC{get;set;}
        @Auraenabled public decimal totTITRCSETPC{get;set;}
        public reportData(){
            this.ProjectDetails=new NCMT_Project__c();
            this.hpData=new NCMT_Housing_Plan__c();
            this.Regional_Portfolio='';
            this.costDetailsValues = new list<costDetails>();
            this.TotalTICost=0;
            this.TotalTRCSCost=0;
            this.TotalTITRCSCost =0;
            this.Design = 0.00;
            this.General = 0.00;
            this.Escmarket = 0.00;
            this.EscCPE = 0.00;
            this.Construct = 0.00;
            this.Art = 0.00;
            this.EDRC=0.00;
            this.EMIC=0.00;
            this.USF=0.00;
            this.SubTIDesign = 0.00;
            this.SubTRCSDesign = 0.00;
            this.SubTITRCSDesign = 0.00;
            this.SubtotTIDesign = 0.00;
            this.SubtotTRCSDesign = 0.00;
            this.SubtotTITRCSDesign = 0.00;
            this.SubTIGeneral = 0.00;
            this.SubTRCSGeneral = 0.00;
            this.SubTITRCSGeneral = 0.00;
            this.SubtotTIGeneral = 0.00;
            this.SubtotTRCSGeneral = 0.00;
            this.SubtotTITRCSGeneral = 0.00;
            this.SubTIEscmarket = 0.00;
            this.SubTRCSEscmarket = 0.00;
            this.SubTITRCSEscmarket = 0.00;
            this.SubTIEscCPE = 0.00;
            this.SubTRCSEscCPE = 0.00;
            this.SubTITRCSEscCPE = 0.00;
            this.SubtotTIECCA = 0.00;
            this.SubtotTRCSECCA = 0.00;
            this.SubtotTITRCSECCA = 0.00;
            this.SubTIConstruct = 0.00;
       		this.SubTRCSConstruct = 0.00;
            this.SubTITRCSConstruct = 0.00;
            this.SubtotTIECC = 0.00;
            this.SubtotTRCSECC = 0.00;
            this.SubtotTITRCSECC = 0.00;
            this.SubTIArt = 0.00;
       		this.SubTRCSArt = 0.00;
            this.SubTITRCSArt = 0.00;
            this.totTIECC = 0.00;
            this.totTRCSECC = 0.00;
            this.totTITRCSECC = 0.00;
            this.SubTIEDRC = 0.00;
            this.SubTRCSEDRC = 0.00;
            this.SubTITRCSEDRC = 0.00;
            this.SubTIEMIC = 0.00;
            this.SubTRCSEMIC = 0.00;
            this.SubTITRCSEMIC = 0.00;
            this.totTIETPC = 0.00;
            this.totTRCSETPC = 0.00;
            this.totTITRCSETPC = 0.00;
            this.TIADJFactor = 0.00;
            }
        
    }
    public class costDetails{
        @AuraEnabled public string categoryCode{get;set;}
        @AuraEnabled public string description{get;set;}
        @AuraEnabled public decimal totalTICost{get;set;}
        @AuraEnabled public decimal totalTRCSCost{get;set;}
        @AuraEnabled public decimal total{get;set;}
        @AuraEnabled public decimal ECCA{get;set;}
        @AuraEnabled public decimal ECC{get;set;}
        @AuraEnabled public decimal ETPC{get;set;}
        @AuraEnabled public decimal ECCAUSF{get;set;}
        @AuraEnabled public decimal ECCUSF{get;set;}
        @AuraEnabled public decimal ETPCUSF{get;set;}
        public costDetails(){
            this.categoryCode='';
            this.description='';
            this.totalTICost=0;
            this.totalTRCSCost=0;  
            this.total=0;
            this.ECCA=0;
            this.ECC=0;
            this.ETPC=0;
            this.ECCAUSF=0;
            this.ECCUSF=0;
            this.ETPCUSF=0;
        }
        public costDetails(string catCode,string description, decimal total1,decimal total2,decimal total){
            this.categoryCode=catCode;
            this.description= description;
            this.totalTICost=total1;
            this.totalTRCSCost=total2;   
            this.total = total;
        }
    }

}