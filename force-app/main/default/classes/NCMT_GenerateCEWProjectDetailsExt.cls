public with sharing class NCMT_GenerateCEWProjectDetailsExt {

    public static void UpdateCEWProjectMarkup(List<NCMT_Project__c> projList, String ProjectType, String ProjPhases, 
                                       String ProjSubPhases, Boolean Include_Exclude_AIA, String ProjectRecordTypeName, 
                                       String OccupancyStatus,String PhaseLevel,decimal dblETPC){
        //get Markup values from CEW Parameters
        Decimal intDesignSiteContingency = 0;
        Decimal intGeneralContractorOverhead = 0;
        Decimal intConstructionContingency = 0;
        Decimal intArtInArchitecture = 0;
        Decimal SpecialUseGrossReceiptsTax = 0; 
        Decimal intPhasingPremium = 0;
        Date CostParameterDate;
        String CostParameterYear;
        String strcostlevel;                                   
                                           
        NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
        CostParameterDate = ncmt_customsettings.Cost_Parameter_Date__c;
        CostParameterYear = string.valueof(CostParameterDate.year()+1);                                    
        
            List <NCMT_CEW_Parameter__c> CEWParamList = [SELECT Name, Criteria_1__c, Criteria_2__c,Type__c,Value__c,Fiscal_Year__c FROM NCMT_CEW_Parameter__c where Fiscal_Year__c = :CostParameterYear ];
            system.debug('dblETPC====='+dblETPC);
            IF(dblETPC > = 0 && dblETPC < 100000){
                  strcostlevel = '1';                            
            }else if(dblETPC >=100000 && dblETPC <500000){
                 strcostlevel = '2';
            }else if(dblETPC >=500000 && dblETPC <1000000){
                 strcostlevel = '3';
            }else if(dblETPC >=1000000 && dblETPC <5000000){
                 strcostlevel = '4';
            }else if(dblETPC >=5000000 && dblETPC <10000000){
                 strcostlevel = '5';
            }else if(dblETPC >=10000000 && dblETPC <50000000){
                 strcostlevel = '6';
            }else if(dblETPC >=50000000 && dblETPC <100000000){
                 strcostlevel = '7';
            }else if(dblETPC >=100000000 && dblETPC <500000000){
                 strcostlevel = '8';
            }else if(dblETPC >= 500000000){
                strcostlevel = '9';
            } 
            system.debug('strcostlevel====='+strcostlevel);                               
            for (NCMT_CEW_Parameter__c CEWLst : CEWParamList ){
                if(CEWLst.Criteria_1__c == ProjPhases && CEWLst.Criteria_2__c == ProjSubPhases && CEWLst.Name == 'Design&Site'){
                        intDesignSiteContingency = CEWLst.Value__c ;
                }
                if(ProjectType=='New Construction - CEW'){
                    //intConstructionContingency = 7;
                    if(CEWLst.Criteria_1__c == strcostlevel && CEWLst.Criteria_2__c == 'New' && CEWLst.Name == 'GenConOPB'){
                        intGeneralContractorOverhead = CEWLst.Value__c ;
                    } 
                }else{
                    //intConstructionContingency=10;
                    if(CEWLst.Criteria_1__c == strcostlevel && CEWLst.Criteria_2__c == OccupancyStatus && CEWLst.Name == 'GenConOPB'){
                         intGeneralContractorOverhead = CEWLst.Value__c ;
                    }
                }
                if(CEWLst.Criteria_1__c == strcostlevel && CEWLst.Criteria_2__c == PhaseLevel && CEWLst.Name == 'Phasing'){
                    intPhasingPremium = CEWLst.Value__c ;
                }
                
            }
                 
        for(NCMT_Project__c objProj :projList){
            //update Project Markups from CEW Parameters
            objProj.Design_and_Site_Contingency__c = intDesignSiteContingency;
            objProj.General_Contractor_Overhead_Profit_Bonds__c = intGeneralContractorOverhead;
            //objProj.Construction_Contingency__c = intConstructionContingency;
            //objProj.Art_In_Architecture__c = 0.50;
            //objProj.Special_Use_Gross_Receipts_Tax__c = 5;
            objProj.Phasing_Premium__c = intPhasingPremium ;
            objProj.Cost_Parameter_Date__c = ncmt_customsettings.Cost_Parameter_Date__c;
        }       
    }
    
    public static void insertCloneDetails(String origID, ID projID)
    {
		System.debug('CEW CLONE = ' + TriggerValue.isClone);
        System.debug('String ID: ' + origID);
        System.debug('Id: ' + projId);
        
        NCMT_Project__c proj = [SELECT Id, Project_Record_ID__c, Project_Type__c, Project_Phases__c,
                                	   Project_SubPhases__c, Include_Exclude_AIA__c, Building_Type__c,
                                       CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                       CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                       CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                       CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                       CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                FROM NCMT_Project__c 
                                WHERE Id =: projId];
        
        
        
        if(origId == null)
        {
            //Not a clone. Set Project Record Id
            System.debug('Not a clone');
			proj.Project_Record_Id__C = projId;
            update proj;
        }
        else
        {
            //Clone
            System.debug('CLONE!');

            TriggerValue.isClone = true;
            
            NCMT_Project__c orig = [SELECT Id, Project_Record_ID__c, Project_Type__c, Project_Phases__c,
                                	   Project_SubPhases__c, Include_Exclude_AIA__c, Building_Type__c,
                                       CEW_Occupancy_Status__c, Phasing_Plan_Construction__c, ETPC__c,
                                       CEW_ECC1__c, EDRC__c, EMIC__c, CEW_Land_Cost__c, CEW_Demolition__c,
                                       CEW_Reloc_Associated_w_Site_Purchase__c, CEW_ECCA__c, ECCMultiplier__c,
                                       CEW_Total_Direct_Cost_2__c, CECAMultiplier__c, Total_Escalation__c,
                                       CEW_Total_Direct_Cost_1__c, Total_Escalation_CPE__c
                                FROM NCMT_Project__c 
                                WHERE Id =: origId];
            
            //Update Project Record Id from parent Id to current Id
            //proj.Project_Record_Id__c = projId;
            //update proj;
            
            
            //Get children of original record
            List<NCMT_CEW_Project_Agency__c> agencies = [SELECT Name, Agency_Tier__c, GSF__C,RSF__c, PBS_AB_Code__c,
                                                         		Tier_Allowance__c, Totals_RWA_Direct_Cost__c,
                                                         		Totals_TI_Fit_Out_Direct_Cost__c, 
                                                         		Total_Security_Direct_Cost__c, USF__c
                                                         FROM  NCMT_CEW_Project_Agency__C
                                                         WHERE NCMT_Project__c =: origId
                                                         ORDER BY Id DESC];
            System.debug('Project Agencies: ' + agencies.size());
            
            //Duplicate child records of original project and relate them to new clone
            List<NCMT_CEW_Project_Agency__c> agencyClones = new List<NCMT_CEW_Project_Agency__c>();
            List<String> oldAgencyIds = new List<String>();
            for(NCMT_CEW_Project_Agency__c p : agencies)
            {
                oldAgencyIds.add(p.Id);
                p.ID = null;
                p.NCMT_Project__c = projId;
				//System.debug(p);
                agencyClones.add(p);
            }
            insert agencyClones;
            
            Map<String, String> agencyNewMap = new Map<String, String>();
            
            for(Integer i = 0; i < agencyClones.size(); i++)
            {
                agencyNewMap.put(oldAgencyIds[i], agencyClones[i].Id);
            }
            System.debug(agencyNewMap);
            
            
            List<NCMT_Work_Description__c> workDescriptions = [SELECT Name, Cost_Data_Source__c, Description__c,
                                                                      Number__c, Unit__c, UOM__C
                                                               FROM NCMT_Work_Description__c 
                                                               WHERE NCMT_Project__c = : origId
                                                               ORDER BY Id DESC];
            System.debug('Work Descriptions: ' + workDescriptions.size());
            
            List<NCMT_Work_Description__c> wdClones = new List<NCMT_Work_Description__c>();
            List<String> oldDescIds = new List<String>();
            for(NCMT_Work_Description__c d : workDescriptions)
            {
                oldDescIds.add(d.Id);
                d.Id = null;
                d.NCMT_Project__c = projId;
                //System.debug(d);
                wdClones.add(d);
            }
            insert wdClones;
            
            Map<String, String> wdNewMap = new Map<String, String>();
            
            for(Integer i = 0; i < wdClones.size(); i++)
            {
				wdNewMap.put(oldDescIds[i], wdClones[i].Id);
            }
            
            List<NCMT_Project_Cost_Summary__c> pcsNew = [SELECT Id, Name, Cost_Category__c FROM NCMT_Project_Cost_Summary__c WHERE Project_Name__c =: projId];
            List<NCMT_Project_Cost_Summary__c> pcsOrig = [SELECT Id, Name, Cost_Category__c FROM NCMT_Project_Cost_Summary__c WHERE Project_Name__c =: origId];
            
            Map<String, String> pcsNewMap = new Map<String, String>();
            //populate map
            for(NCMT_Project_Cost_Summary__c pcs: pcsNew)
            {
				pcsNewMap.put(pcs.Cost_Category__c, pcs.Id);
            }
            //System.debug(pcsNewMap.keySet());
            
            
            
            //Get Work Items related to Project Cost Summary of original
            List<NCMT_CEW_Work_Item__c> workItems = [SELECT Name, CEW_Project_Agency__c, NCMT_CEW_Work_Description__c,
                                                     		Description__c, Project_Cost_Summary__c, Project_Cost_Summary__r.Cost_Category__c, Sq_Ft__c, Unit_Rate__c,
                                                            UOM__c, WorkDescNumber__c, Work_Item_Code__c, NCMT_Project_ID__c
                                                     FROM NCMT_CEW_Work_Item__c
                                                     WHERE Project_Cost_Summary__c IN: pcsOrig];
            System.debug('Work Items: ' + workItems.size());
            
            List<NCMT_CEW_Work_Item__c> workItemClones = new List<NCMT_CEW_Work_Item__c>();
            
            //Relate cloned Work Items to clones Project Cost Summaries
            for(NCMT_CEW_Work_Item__c wi: workItems)
            {
                String pcsId = wi.Project_Cost_Summary__r.Cost_Category__c;
    			String paID = agencyNewMap.get(wi.CEW_Project_Agency__c);
                String wdID = wdNewMap.get(wi.NCMT_CEW_Work_Description__c);
                
                wi.Id = null;
                wi.Project_Cost_Summary__c = pcsNewMap.get(pcsId);
                wi.CEW_Project_Agency__c = paID;
                wi.NCMT_CEW_Work_Description__c = wdID;
                //System.debug(wi);
                workItemClones.add(wi);
            }
            
            insert workItemClones;
            
            //Update Project Record Id from parent Id to current Id
            List<NCMT_Project__c> projList = new List<NCMT_Project__c>();
        	projList.add(proj);
            proj.Project_Record_Id__c = projId;
            UpdateCEWProjectMarkup(projList, orig.Project_Type__c, orig.Project_Phases__c, 
                               orig.Project_SubPhases__c, orig.Include_Exclude_AIA__c,
                               orig.Building_Type__c, orig.CEW_Occupancy_Status__c,
                               orig.Phasing_Plan_Construction__c, orig.ETPC__c);
            update proj;
        }
    }
}