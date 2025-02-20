trigger NCMT_RA_Phasing_Trigger on NCMT_RA_Phasing__c (before insert, after insert, after update, before update, before delete) {
	
	set<id> NCMTprojIds = new  set<id>();
	set<id> WorkItemIds = new  set<id>();
	set<id> currentRecordId = new set<id>();
	map<id,NCMT_Project__c > ncmtmap = new map<id,NCMT_Project__c >();
	map<string,NCMT_RA_Overhead_Analysis__c> RAOverheadAnalysisMap = new map<string,NCMT_RA_Overhead_Analysis__c>();
	map<id,integer> recordCountMap = new map<id,integer>();
	NCMT_RA_Phasing__c RAPhasinglist = new NCMT_RA_Phasing__c();
	list<NCMT_RA_Phasing__c> RAPhasingUpdatelist = new list<NCMT_RA_Phasing__c> ();
	list<NCMT_RA_Overhead_Analysis__c> lstOverheadAnalysis = new list<NCMT_RA_Overhead_Analysis__c> ();
	string strFiscalYear, strProjectType, strBuilding_Type, strEstimateType;
	date dtCostParamDate;	
	ID ProjectRecordID;
	NCMT_GenerateProjectDetails objGenerateData = new NCMT_GenerateProjectDetails();
	
	if(!Trigger.isdelete) {
		for(NCMT_RA_Phasing__c NCMTRAphasing : Trigger.new) {
			
			NCMTProjIds.add(NCMTRAphasing.Project__c);
			currentRecordId.add(NCMTRAphasing.ID);		
		}
	
		for(NCMT_Project__c  Proj :[SELECT id, Project_Type__c, Estimate_Type_Proj__c, Building_Type__c,Cost_Parameter_Date_FY__c, Total_Project_Cost__c, Cost_Parameter_Date__c,
											Level_of_Program_Definition__c
	                                 FROM NCMT_Project__c 
	                                WHERE id In :NCMTProjIds]) {
	        ncmtmap.put(Proj.Id,Proj);  
	        ProjectRecordID = Proj.ID;
	        strFiscalYear = Proj.Cost_Parameter_Date_FY__c;
            strEstimateType = Proj.Estimate_Type_Proj__c;                          
	        strProjectType = Proj.Project_Type__c;
	        dtcostParamDate = Proj.Cost_Parameter_Date__c;
	        strBuilding_Type = Proj.Building_Type__c;
	    }
	           
	    //for inserts and updates
	    if(Trigger.isbefore) {
	    	
	    	string ncmtRAPhaseId,ncmtID;
	    	decimal totalphasingpercent = 0, totalanticipatedphasingpercent = 0;
	        
	        for(NCMT_RA_Phasing__c ncmtRAPhase : Trigger.new) {
	        	if(trigger.isupdate)
	            ncmtRAPhaseId = ncmtRAPhase.id;
	            ncmtID = ncmtRAPhase.Project__c;
	        
	        }
	        
	        if(strProjectType == 'Repair & Alteration - Parametric Entry'){
		        for (AggregateResult aggr : [SELECT sum(Anticipated_Phasing__c)sum 
		                                       FROM NCMT_RA_Phasing__c 
		                                      WHERE  Project__c In :NCMTProjIds  and id != :ncmtRAPhaseId
		                                   GROUP BY  Project__c ]) {
		            totalphasingpercent = integer.valueof(aggr.get('sum'));                
		        } 
		        
		        for(NCMT_RA_Phasing__c ncmtRAPhase : Trigger.new) {
		        	if(trigger.isInsert || (trigger.isUpdate && trigger.oldmap.get(ncmtRAPhase.id).get('Anticipated_Phasing__c') != ncmtRAPhase.Anticipated_Phasing__c) ) {
	                	totalanticipatedphasingpercent = totalanticipatedphasingpercent + ncmtRAPhase.Anticipated_Phasing__c;
	            	}
		            if(totalanticipatedphasingpercent+totalphasingpercent > 100){
		                ncmtRAPhase.addError('Total Anticipated Phasing should not be greater than 100%');
		            }
	        	} 
	        }
	        
		}
		
		if(strEstimateType != 'Definitive Estimating' && strEstimateType != 'Cost Estimating Workbook'){
    
		    if(TriggerValue.isFirstRun && Trigger.isafter) {
	
		    	TriggerValue.isFirstRun = false; 
		    	NCMT_GenerateProjectDetailsExt objGenerateDataExt = new NCMT_GenerateProjectDetailsExt();
		    	
		    	objGenerateDataExt.Update_RA_Phasing(currentRecordId, NCMTProjIds);
		    	
		    	if(trigger.isinsert){
			    	//for updating professional service RA Phasing records
					objGenerateData.GenerateProfServEstData(ProjectRecordID, strBuilding_Type,'update',0);
		    	}
		    }
		}
	    
	}
        
    if(Trigger.isdelete  && Trigger.isbefore){
    	integer count;    	
    	for(NCMT_RA_Phasing__c NCMTRAphasing : Trigger.old) {
		
			NCMTProjIds.add(NCMTRAphasing.Project__c);
			currentRecordId.add(NCMTRAphasing.ID);		
		}
		for(NCMT_Project__c  Proj :[SELECT id, Project_Type__c, Building_Type__c,Cost_Parameter_Date_FY__c, Total_Project_Cost__c, Cost_Parameter_Date__c,
											Level_of_Program_Definition__c
	                                 FROM NCMT_Project__c 
	                                WHERE id In :NCMTProjIds]) { 
	        ProjectRecordID = Proj.ID;
	        strBuilding_Type = Proj.Building_Type__c;
    	}
    	        
		for(AggregateResult agr :[select count(id) total ,Project__c from NCMT_RA_Phasing__c where id != :currentRecordId and Project__c IN : NCMTProjIds group by Project__c ]) {
			string recordId = string.valueof(agr.get('Project__c'));
			count = integer.valueof(agr.get('total'));
			recordCountMap.put(recordId,count);
		}
		
		for(NCMT_RA_Phasing__c NCMTRAphasing : Trigger.old) {
			if(!recordCountMap.containsKey(NCMTRAphasing.Project__c))
				NCMTRAphasing.addError('A Project should have at least one RA Phasing record');
		}

    	//for updating professional service RA Phasing records
    	//system.debug('test===');
		objGenerateData.GenerateProfServEstData(ProjectRecordID, strBuilding_Type,'update', count);
		
    }
}