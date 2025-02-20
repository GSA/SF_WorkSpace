trigger NCMT_HousingPlanTrigger on NCMT_Housing_Plan__c (after insert, after update, before insert, before update, before delete, after delete) {

    NCMT_UpdateHousingPlan objUpdateHPData = new NCMT_UpdateHousingPlan();
    ID ProjectRecordID, HPRecordID;
    String ProjectRecordTypeName, ProjectRecordType, Project_Type;
    Boolean blnHousingPlan, blnMoveCost;
    decimal dblSumTITotalCost =0, TICostAdjusted = 0;
    
    System.debug('RUN HP TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    
    if(!trigger.isdelete && NCMT_GenerateTCOProjectDetailsExt.runTriggers == true){
    for (NCMT_Housing_Plan__c HP : Trigger.new) {
            ProjectRecordID = HP.Project__c;
            HPRecordID = HP.ID;
            blnHousingPlan = HP.HousingPlanFlag__c;
            ProjectRecordType = HP.Building_Type__c;
            Project_Type = HP.Project_Type__c;
        	blnMoveCost = HP.Move_Cost_Module__c;
    }
    system.debug('blnHousingPlan :' + blnHousingPlan );
    system.debug('blnMoveCost : ' + blnMoveCost);
    /**List <NCMT_Project__c> Projlst = [select Building_Type__c, Project_Type__c, Housing_Plan__c FROM NCMT_Project__c WHERE Id = :ProjectRecordID];
                                                                                                    
    ProjectRecordTypeName = Projlst[0].Building_Type__c;
    Project_Type = Projlst[0].Project_Type__c;   **/                            
    
    if (Trigger.isBefore /*&& blnMoveCost == false*/) {
        System.debug('HP Trigger before');
        //List <NCMT_Project__c> Projlst = [select Building_Type__c, Project_Type__c, Housing_Plan__c FROM NCMT_Project__c WHERE Id = :ProjectRecordID];
                                                                                                 
        //ProjectRecordTypeName = Projlst[0].Building_Type__c;
        //Project_Type = Projlst[0].Project_Type__c; 
        objUpdateHPData.UpdateHousingPlanData(trigger.new, ProjectRecordID);     
    }   
    
    if (Trigger.isAfter /*&& blnMoveCost == false*/) {
		System.debug('HP Trigger after');
        /**blnHousingPlan = Projlst[0].Housing_Plan__c;
        ProjectRecordType = Projlst[0].Building_Type__c;**/
        
        //insert Housing Plan Summary record
        if (blnHousingPlan == True) {
            /** Shifted to the future method in NCMT_HousingPlanTriggerHelper class
			NCMT_UpdateHousingPlanSummary objinsertHPSummaryData = new NCMT_UpdateHousingPlanSummary();
            objinsertHPSummaryData.insertHousingPlanSummary(trigger.new, ProjectRecordID, ProjectRecordType);
			*/
			if(!System.isFuture()){
				String triggerEvent;
				if(trigger.isInsert){
					triggerEvent = 'insert';
				}
				else if(trigger.isUpdate){
					triggerEvent = 'update';
				}
				
				NCMT_HousingPlanTriggerHelper.insertHousingPlanSummaryFuture(ProjectRecordID,ProjectRecordType,Project_Type,TICostAdjusted,triggerEvent,HPRecordID);
			}
            
			/** Shifted to the future method in NCMT_HousingPlanTriggerHelper class
            if(Project_Type == 'Repair & Alteration - Work Item Detail'){
                //insert default work item after creation of housing plan record    
                list<NCMT_RA_Work_Items__c> RAWIlst = new list<NCMT_RA_Work_Items__c>();
                
                string  strRAWIRecordTypeName = Schema.SObjectType.NCMT_RA_Work_Items__c.getRecordTypeInfosByName().get('RA Work Items Space Plan').getRecordTypeId();
                
                list<NCMT_Project_Cost_Summary__c> ProjCostSumlst = [SELECT Id, TI_Cost_Adjusted__c FROM NCMT_Project_Cost_Summary__c WHERE Project_Name__c = :ProjectRecordID and Cost_Category_Description__c = 'Interior Construction - Space Plans'];
                ID ProjCostSumID = ProjCostSumlst[0].id;
                TICostAdjusted = ProjCostSumlst[0].TI_Cost_Adjusted__c;
                
                list<NCMT_RA_Phasing__c>  RAPhasinglst =  [SELECT Id FROM NCMT_RA_Phasing__c WHERE Project__c = :ProjectRecordID and Work_Conditions__c = 'Fully vacant building'];
                
                list<NCMT_Housing_Plan__c> hplst = [SELECT Id, Total_USF__c FROM NCMT_Housing_Plan__c WHERE ID = :HPRecordID ];
                                
                if(trigger.isInsert){
                    RAWIlst.Add(new NCMT_RA_Work_Items__c(
                        Housing_Plan__c = HPRecordID,
                        Work_Item_Type_ID__c = ProjCostSumlst[0].id,
                        Work_Item_Phase__c = RAPhasinglst[0].id,
                        Quantity_SF__c  = hplst[0].Total_USF__c,
                        Rate__c = TICostAdjusted/hplst[0].Total_USF__c,
                        RecordTypeID = strRAWIRecordTypeName,
                        Cost_Allocation_GSA__c = 0
                        ));
     
                        insert RAWIlst;
                }else if(trigger.isUpdate){
                   NCMT_RA_Work_Items__c NCMTRAWI = [Select ID, Quantity_SF__c, Rate__c from NCMT_RA_Work_Items__c where Housing_Plan__c = :HPRecordID];
                   
                   NCMTRAWI.Quantity_SF__c  = hplst[0].Total_USF__c;
                   NCMTRAWI.Rate__c = TICostAdjusted/hplst[0].Total_USF__c;
                   
                   update NCMTRAWI;
                    
                }
                NCMT_GenerateProjectDetails objGenerateData = new NCMT_GenerateProjectDetails(); 
                objGenerateData.GenerateProfServEstData(ProjectRecordID, ProjectRecordType,'update',0);
            }
			*/
        }
    }  
  }   
    
   if(trigger.isdelete && Trigger.isbefore){
        for(NCMT_Housing_Plan__c Hp :trigger.old){
            ProjectRecordID = HP.Project__c;
            HPRecordID = Hp.ID;
            blnHousingPlan = HP.HousingPlanFlag__c;
            ProjectRecordType = HP.Building_Type__c;
            Project_Type = HP.Project_Type__c;
        }
                
        /**List <NCMT_Project__c> Projlst = [select Building_Type__c, Project_Type__c, Housing_Plan__c FROM NCMT_Project__c WHERE Id = :ProjectRecordID];
        blnHousingPlan = Projlst[0].Housing_Plan__c;
        Project_Type = Projlst[0].Project_Type__c;**/
                
        if (blnHousingPlan == True) {
            if(Project_Type == 'Repair & Alteration - Work Item Detail'){
        
                list<NCMT_RA_Work_Items__c> NCMTRAWIlst = [Select ID from NCMT_RA_Work_Items__c where Housing_Plan__c = :HPRecordID];
                if(NCMTRAWIlst != null && NCMTRAWIlst.size() > 0){
                    delete NCMTRAWIlst;
                }
            }
        }
    }
}