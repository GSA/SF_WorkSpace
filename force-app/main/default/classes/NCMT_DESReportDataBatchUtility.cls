public class NCMT_DESReportDataBatchUtility {
   
        public static void copyReportDataToObject( List<Id> projectIds){
        Map<Integer,String> indexLevelNameFieldMap = new Map<Integer,String>{1=> 'Level_1_Name__c',2=> 'Level_2_Name__c',3=> 'Level_3_Name__c',4=> 'Level_4_Name__c',5=> 'Level_5_Name__c',6=> 'Level_6_Name__c',7=> 'Level_7_Name__c',8=> 'Level_8_Name__c',9=> 'Level_9_Name__c',10=> 'Level_10_Name__c'};
        Map<Integer,String> indexLevelFieldMap = new Map<Integer,String>{1=> 'Level_1__c',2=> 'Level_2__c',3=> 'Level_3__c',4=> 'Level_4__c',5=> 'Level_5__c',6=> 'Level_6__c',7=> 'Level_7__c',8=> 'Level_8__c',9=> 'Level_9__c',10=> 'Level_10__c'};
		Map<Id,List<NCMT_Des_Report__c>> projectncmtDESToInsertMap =  New Map<Id,List<NCMT_Des_Report__c>>();
            
        List<NCMT_Des_Report__c> ncmtDESToInsert =new List<NCMT_Des_Report__c>();
        NCMT_Project__c projectDetails;
        Map<Id,reportData> reportDataMap =  getProjectData(projectIds);
        Map<Id,Decimal> projectSubtotalMap =  New Map<Id,Decimal>();
        Map<String,String> TreeSortMap =  New Map<String,String>(); 
        Map<String,Decimal> TreeMPMap =  New Map<String,Decimal>(); 
        Map<string,integer> branchNameLevelMap = new Map<String,Integer>();    
        //system.debug(':::reportDataMap:::'+reportDataMap.keySet());
        
        for(String projectId : reportDataMap.keySet()){
            
            projectncmtDESToInsertMap.put(projectId, new List<NCMT_Des_Report__c>());
            
            reportData  projectReportData= reportDataMap.get(projectId);
           system.debug('projectId:::::==='+projectReportData.PMData.Project_Name__r.Id);
            
            integer i=1;
            string strSortOrdertxt;
            boolean Level1 = false;
            
            //tree Structure branchname
            for(NCMT_Tree_structure__c ncmtTree : projectReportData.treeStrucData){ 
                IF(Level1 == false || ncmtTree.Level__c == 1){
                    TreeSortMap.put(ncmtTree.SortOrdertxt__c,ncmtTree.Branch_Name__c);
                    TreeMPMap.put(ncmtTree.SortOrdertxt__c,ncmtTree.Total_Including_Markups__c);
                }
                IF(ncmtTree.Level__c == 1){
                    Level1 = true;
                }
            }
            
            for(NCMT_Tree_structure__c projDES : projectReportData.treeStrucData){
                //system.debug('::branch Name::'+projDES.Tree_structure__r.Branch_Name__c);
                IF(projDES.SortOrdertxt__c.length() > 2){
                    	strSortOrdertxt = projDES.SortOrdertxt__c.SubString(0,5);
                    }else if(Level1  ==  false)
                    {
                        strSortOrdertxt = projDES.SortOrdertxt__c;
                    }
                IF(strSortOrdertxt <> null){
                    if(!branchNameLevelMap.containsKey(strSortOrdertxt)){
                       branchNameLevelMap.put(strSortOrdertxt,i);
                        i++; 
                    }    
                    
                }
            }
            system.debug('::branchNameLevelMap:::'+branchNameLevelMap);
            Map<String,NCMT_Des_Report__c> branchNameDESItem = new  Map<String,NCMT_Des_Report__c>();
          
            for(NCMT_DES_Items__c projDES : projectReportData.projDESItemData){
                IF(projDES.Tree_structure__r.SortOrdertxt__c.length() > 2){
                    	strSortOrdertxt = projDES.Tree_structure__r.SortOrdertxt__c.SubString(0,5);
                    }else{
                        strSortOrdertxt = projDES.Tree_structure__r.SortOrdertxt__c;
                    }
                if(!branchNameDESItem.containsKey(projDES.Cost_Summary__c+'_'+strSortOrdertxt)){
                     
                    
                    integer level = branchNameLevelMap.get(strSortOrdertxt);
                    NCMT_Des_Report__c ncmtDESItem =  setDefaultNCMTDesData(projectReportData);
                    //ncmtDESItem.Project_ID__c = projDES.NCMT_Proj_ID__c;
                    //ncmtDESItem.Project_Name__c = projDES.NCMT_Project_Name__c;
                                        
                    ncmtDESItem.Division_Name__c = projDES.Level_2__r.Name ;
                     //system.debug('::level:::'+level);
                     //system.debug('::level:::'+indexLevelNameFieldMap.get(level));
                     //system.debug('::level:::'+indexLevelFieldMap.get(level));
                     system.debug('sortordertxt:::::===='+projDES.Tree_structure__r.SortOrdertxt__c);
                   
                    //ncmtDESItem.SortOrdertxt__c = strSortOrdertxt;
                    //system.debug('::strSortOrdertxt:::'+strSortOrdertxt);
                    ncmtDESItem.put(indexLevelNameFieldMap.get(level),TreeSortMap.get(strSortOrdertxt));
                    
                    ncmtDESItem.put(indexLevelFieldMap.get(level),projDES.Total_Cost__c);
                    ncmtDESItem.Division_Description__c = projDES.Cost_Summary__c;                     
                    
                    branchNameDESItem.put(projDES.Cost_Summary__c+'_'+strSortOrdertxt,ncmtDESItem);//+'_'+projDES.Tree_structure__r.SortOrdertxt__c+
                }
                else{
                    NCMT_Des_Report__c ncmtDESItem =  branchNameDESItem.get(projDES.Cost_Summary__c+'_'+strSortOrdertxt);
                    /*IF(projDES.Tree_structure__r.SortOrdertxt__c.length() > 2){
                     	strSortOrdertxt = projDES.Tree_structure__r.SortOrdertxt__c.SubString(0,5);
                    }else{
                        strSortOrdertxt = projDES.Tree_structure__r.SortOrdertxt__c;
                    }*/
                    integer level = branchNameLevelMap.get(strSortOrdertxt);
                    
                    ncmtDESItem.put(indexLevelFieldMap.get(level),projDES.Total_Cost__c + integer.valueof(ncmtDESItem.get(indexLevelFieldMap.get(level))));
                    ncmtDESItem.put(indexLevelNameFieldMap.get(level),TreeSortMap.get(strSortOrdertxt));
                    branchNameDESItem.put(projDES.Cost_Summary__c+'_'+strSortOrdertxt,ncmtDESItem);
                }
                //ncmtDESToInsert.add(ncmtDESItem);
                
            }            
            projectncmtDESToInsertMap.get(projectId).addAll(branchNameDESItem.values());
        }
           
        for(Id projectId : projectncmtDESToInsertMap.KeySet()){
             reportData  projectReportData= reportDataMap.get(projectId);
            
            NCMT_Des_Report__c ncmtTotal =  setDefaultNCMTDesData(projectReportData);
            ncmtTotal.Division_Name__c = 'Total'; 
            
        	List<NCMT_Des_Report__c> ncmtDesDToInsert= projectncmtDESToInsertMap.get(projectId);
            
            for(NCMT_Des_Report__c NCMT_DesProjTotal : ncmtDesDToInsert){
                NCMT_DesProjTotal.Project_Total__c = NCMT_DesProjTotal.LEVEL_1__c + NCMT_DesProjTotal.LEVEL_2__c + NCMT_DesProjTotal.LEVEL_3__c + NCMT_DesProjTotal.LEVEL_4__c + NCMT_DesProjTotal.LEVEL_5__c + NCMT_DesProjTotal.LEVEL_6__c + NCMT_DesProjTotal.LEVEL_7__c + NCMT_DesProjTotal.LEVEL_8__c + NCMT_DesProjTotal.LEVEL_9__c + NCMT_DesProjTotal.LEVEL_10__c;              
            	//Total
                ncmtTotal.LEVEL_1__c = ncmtTotal.LEVEL_1__c + NCMT_DesProjTotal.LEVEL_1__c;
                ncmtTotal.LEVEL_2__c = ncmtTotal.LEVEL_2__c + NCMT_DesProjTotal.LEVEL_2__c;
                ncmtTotal.LEVEL_3__c = ncmtTotal.LEVEL_3__c + NCMT_DesProjTotal.LEVEL_3__c;
                ncmtTotal.LEVEL_4__c = ncmtTotal.LEVEL_4__c + NCMT_DesProjTotal.LEVEL_4__c;
                ncmtTotal.LEVEL_5__c = ncmtTotal.LEVEL_5__c + NCMT_DesProjTotal.LEVEL_5__c;
                ncmtTotal.LEVEL_6__c = ncmtTotal.LEVEL_6__c + NCMT_DesProjTotal.LEVEL_6__c;
                ncmtTotal.LEVEL_7__c = ncmtTotal.LEVEL_7__c + NCMT_DesProjTotal.LEVEL_7__c;
                ncmtTotal.LEVEL_8__c = ncmtTotal.LEVEL_8__c + NCMT_DesProjTotal.LEVEL_8__c;
                ncmtTotal.LEVEL_9__c = ncmtTotal.LEVEL_9__c + NCMT_DesProjTotal.LEVEL_9__c;
                ncmtTotal.LEVEL_10__c = ncmtTotal.LEVEL_10__c + NCMT_DesProjTotal.LEVEL_10__c;
                ncmtTotal.Project_Total__c = ncmtTotal.Project_Total__c + NCMT_DesProjTotal.Project_Total__c;
                
            }
            for(NCMT_Des_Report__c NCMT_DesPercent : ncmtDesDToInsert){
               NCMT_DesPercent.Percent__c = (NCMT_DesPercent.Project_Total__c/ncmtTotal.Project_Total__c)*100;
            }
            //TOTAL DIRECT COST WITH BID FACTOR 
            NCMT_Des_Report__c ncmtBidF =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c == 'RSMeans - O&P'){
            ncmtBidF.Division_Name__c = 'TOTAL DIRECT COST WITH BID FACTOR '; 
            ncmtBidF.Division_Description__c = String.ValueOf(projectReportData.PMData.Bid_Factor__c)+'%';
            ncmtBidF.LEVEL_1__c = ncmtTotal.LEVEL_1__c * projectReportData.PMData.Bid_Factor__c/100;
            ncmtBidF.LEVEL_2__c = ncmtTotal.LEVEL_2__c * projectReportData.PMData.Bid_Factor__c/100;
            ncmtBidF.LEVEL_3__c = ncmtTotal.LEVEL_3__c * projectReportData.PMData.Bid_Factor__c/100;
            ncmtBidF.LEVEL_4__c = ncmtTotal.LEVEL_4__c * projectReportData.PMData.Bid_Factor__c/100;
            ncmtBidF.LEVEL_5__c = ncmtTotal.LEVEL_5__c * projectReportData.PMData.Bid_Factor__c/100;
            ncmtBidF.LEVEL_6__c = ncmtTotal.LEVEL_6__c * projectReportData.PMData.Bid_Factor__c/100;
            ncmtBidF.LEVEL_7__c = ncmtTotal.LEVEL_7__c * projectReportData.PMData.Bid_Factor__c/100;
            ncmtBidF.LEVEL_8__c = ncmtTotal.LEVEL_8__c * projectReportData.PMData.Bid_Factor__c/100;
            ncmtBidF.LEVEL_9__c = ncmtTotal.LEVEL_9__c * projectReportData.PMData.Bid_Factor__c/100;
            ncmtBidF.LEVEL_10__c = ncmtTotal.LEVEL_10__c * projectReportData.PMData.Bid_Factor__c/100;
            ncmtBidF.Project_Total__c = ncmtTotal.Project_Total__c * projectReportData.PMData.Bid_Factor__c/100;  
            }
            //SITE AND DESIGN CONTINGENCY 
            NCMT_Des_Report__c ncmtDesign =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtDesign.Division_Name__c = 'SITE AND DESIGN CONTINGENCY'; 
            ncmtDesign.Division_Description__c = String.ValueOf(projectReportData.PMData.Site_Design_Contingency__c)+'%';
            ncmtDesign.LEVEL_1__c = ncmtTotal.LEVEL_1__c * projectReportData.PMData.Site_Design_Contingency__c/100;
            ncmtDesign.LEVEL_2__c = ncmtTotal.LEVEL_2__c * projectReportData.PMData.Site_Design_Contingency__c/100;
            ncmtDesign.LEVEL_3__c = ncmtTotal.LEVEL_3__c * projectReportData.PMData.Site_Design_Contingency__c/100;
            ncmtDesign.LEVEL_4__c = ncmtTotal.LEVEL_4__c * projectReportData.PMData.Site_Design_Contingency__c/100;
            ncmtDesign.LEVEL_5__c = ncmtTotal.LEVEL_5__c * projectReportData.PMData.Site_Design_Contingency__c/100;
            ncmtDesign.LEVEL_6__c = ncmtTotal.LEVEL_6__c * projectReportData.PMData.Site_Design_Contingency__c/100;
            ncmtDesign.LEVEL_7__c = ncmtTotal.LEVEL_7__c * projectReportData.PMData.Site_Design_Contingency__c/100;
            ncmtDesign.LEVEL_8__c = ncmtTotal.LEVEL_8__c * projectReportData.PMData.Site_Design_Contingency__c/100;
            ncmtDesign.LEVEL_9__c = ncmtTotal.LEVEL_9__c * projectReportData.PMData.Site_Design_Contingency__c/100;
            ncmtDesign.LEVEL_10__c = ncmtTotal.LEVEL_10__c * projectReportData.PMData.Site_Design_Contingency__c/100;
            ncmtDesign.Project_Total__c = ncmtTotal.Project_Total__c * projectReportData.PMData.Site_Design_Contingency__c/100;  
            }
            
            //SUBTOTAL
            NCMT_Des_Report__c ncmtSubtotal =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtSubtotal.Division_Name__c = 'SUBTOTAL SITE AND DESIGN'; 
            ncmtSubtotal.LEVEL_1__c = ncmtTotal.LEVEL_1__c + ncmtDesign.LEVEL_1__c;
            ncmtSubtotal.LEVEL_2__c = ncmtTotal.LEVEL_2__c + ncmtDesign.LEVEL_2__c;
            ncmtSubtotal.LEVEL_3__c = ncmtTotal.LEVEL_3__c + ncmtDesign.LEVEL_3__c;
            ncmtSubtotal.LEVEL_4__c = ncmtTotal.LEVEL_4__c + ncmtDesign.LEVEL_4__c;
            ncmtSubtotal.LEVEL_5__c = ncmtTotal.LEVEL_5__c + ncmtDesign.LEVEL_5__c;
            ncmtSubtotal.LEVEL_6__c = ncmtTotal.LEVEL_6__c + ncmtDesign.LEVEL_6__c;
            ncmtSubtotal.LEVEL_7__c = ncmtTotal.LEVEL_7__c + ncmtDesign.LEVEL_7__c;
            ncmtSubtotal.LEVEL_8__c = ncmtTotal.LEVEL_8__c + ncmtDesign.LEVEL_8__c;
            ncmtSubtotal.LEVEL_9__c = ncmtTotal.LEVEL_9__c + ncmtDesign.LEVEL_9__c;
            ncmtSubtotal.LEVEL_10__c = ncmtTotal.LEVEL_10__c + ncmtDesign.LEVEL_10__c;
            ncmtSubtotal.Project_Total__c = ncmtTotal.Project_Total__c + ncmtDesign.Project_Total__c;
            }
            
          
            //CECA 
            NCMT_Des_Report__c ncmtCECA =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtCECA.Division_Name__c = 'CECA';
            map<string,integer> allStrs = new map<string,integer>();
            string str;
                system.debug('branchNameLevelMap::==::'+branchNameLevelMap);
            for(string st : branchNameLevelMap.keyset()){
                IF(st.length()>2){
                	 str = st.substring(0,5);
                }
                else{
                      str = st;   
                    }
               allStrs.put(str,branchNameLevelMap.Get(st));
            }
			integer level;            
            for(NCMT_Tree_structure__c NCMT_TreeM : projectReportData.treeStrucData){
                system.debug('branchNameLevelMap::==::'+branchNameLevelMap);
                system.debug('allStrs::=='+allStrs);
                system.debug('NCMT_TreeM.SortOrdertxt__c:::'+NCMT_TreeM.SortOrdertxt__c);
                IF(NCMT_TreeM.SortOrdertxt__c.length()>2){
                	level = allStrs.get(NCMT_TreeM.SortOrdertxt__c.substring(0,5));
                    ncmtCECA.put(indexLevelFieldMap.get(level),NCMT_TreeM.Total_Including_Markups__c);
                }else{
                    level = allStrs.get(NCMT_TreeM.SortOrdertxt__c);
                    IF(level <> null){
                    ncmtCECA.put(indexLevelFieldMap.get(level),NCMT_TreeM.Total_Including_Markups__c);
                    }
                }
                system.debug('level::=='+level);
                system.debug('indexLevelFieldMap::=='+indexLevelFieldMap);
                system.debug('indexLevelFieldMap::=='+indexLevelFieldMap.get(level));
                //ncmtCECA.put(indexLevelFieldMap.get(level),NCMT_TreeM.Total_Including_Markups__c);                
            }
            ncmtCECA.Project_Total__c = projectReportData.PMData.Subtotal_OS_Self__c;
            }
            
            //PRIME CONTRACTOR MARKUP 
            NCMT_Des_Report__c ncmtPrime =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtPrime.Division_Name__c = 'PRIME CONTRACTOR MARKUP '; 
            
                ncmtPrime.LEVEL_1__c = ncmtCECA.LEVEL_1__c - ncmtSubtotal.LEVEL_1__c;
                ncmtPrime.LEVEL_2__c = ncmtCECA.LEVEL_2__c  - ncmtSubtotal.LEVEL_2__c;
                ncmtPrime.LEVEL_3__c = ncmtCECA.LEVEL_3__c  - ncmtSubtotal.LEVEL_3__c;
                ncmtPrime.LEVEL_4__c = ncmtCECA.LEVEL_4__c  - ncmtSubtotal.LEVEL_4__c;
                ncmtPrime.LEVEL_5__c = ncmtCECA.LEVEL_5__c  - ncmtSubtotal.LEVEL_5__c;
                ncmtPrime.LEVEL_6__c = ncmtCECA.LEVEL_6__c  - ncmtSubtotal.LEVEL_6__c;
                ncmtPrime.LEVEL_7__c = ncmtCECA.LEVEL_7__c - ncmtSubtotal.LEVEL_7__c;
                ncmtPrime.LEVEL_8__c = ncmtCECA.LEVEL_8__c - ncmtSubtotal.LEVEL_8__c;
                ncmtPrime.LEVEL_9__c = ncmtCECA.LEVEL_9__c - ncmtSubtotal.LEVEL_9__c;
                ncmtPrime.LEVEL_10__c = ncmtCECA.LEVEL_10__c - ncmtSubtotal.LEVEL_10__c;
                ncmtPrime.Project_Total__c = projectReportData.PMData.Subtotal_OS_Self__c - ncmtSubtotal.Project_Total__c;
            }
            
            //CMC CONTINGENCY ALLOWANCE
            NCMT_Des_Report__c ncmtCMc =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtCMc.Division_Name__c = 'CMC CONTINGENCY ALLOWANCE'; 
            ncmtCMc.Division_Description__c = String.ValueOf(projectReportData.PMData.CMc__c)+'%';
            ncmtCMc.LEVEL_1__c = ncmtCECA.LEVEL_1__c * projectReportData.PMData.CMc__c/100;
            ncmtCMc.LEVEL_2__c = ncmtCECA.LEVEL_2__c * projectReportData.PMData.CMc__c/100;
            ncmtCMc.LEVEL_3__c = ncmtCECA.LEVEL_3__c * projectReportData.PMData.CMc__c/100;
            ncmtCMc.LEVEL_4__c = ncmtCECA.LEVEL_4__c * projectReportData.PMData.CMc__c/100;
            ncmtCMc.LEVEL_5__c = ncmtCECA.LEVEL_5__c * projectReportData.PMData.CMc__c/100;
            ncmtCMc.LEVEL_6__c = ncmtCECA.LEVEL_6__c * projectReportData.PMData.CMc__c/100;
            ncmtCMc.LEVEL_7__c = ncmtCECA.LEVEL_7__c * projectReportData.PMData.CMc__c/100;
            ncmtCMc.LEVEL_8__c = ncmtCECA.LEVEL_8__c * projectReportData.PMData.CMc__c/100;
            ncmtCMc.LEVEL_9__c = ncmtCECA.LEVEL_9__c * projectReportData.PMData.CMc__c/100;
            ncmtCMc.LEVEL_10__c = ncmtCECA.LEVEL_10__c * projectReportData.PMData.CMc__c/100;
            ncmtCMc.Project_Total__c = ncmtCECA.Project_Total__c * projectReportData.PMData.CMc__c/100;  
            }
            
            //PROF. SERVICES FEES (PRECONST. PHASE)
            NCMT_Des_Report__c ncmtProf =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtProf.Division_Name__c = 'PROF. SERVICES FEES (PRECONST. PHASE)'; 
            ncmtProf.Division_Description__c = String.ValueOf(projectReportData.PMData.Professional_Services_Fees_Preconst__c)+'%';
            ncmtProf.LEVEL_1__c = ncmtCECA.LEVEL_1__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            ncmtProf.LEVEL_2__c = ncmtCECA.LEVEL_2__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            ncmtProf.LEVEL_3__c = ncmtCECA.LEVEL_3__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            ncmtProf.LEVEL_4__c = ncmtCECA.LEVEL_4__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            ncmtProf.LEVEL_5__c = ncmtCECA.LEVEL_5__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            ncmtProf.LEVEL_6__c = ncmtCECA.LEVEL_6__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            ncmtProf.LEVEL_7__c = ncmtCECA.LEVEL_7__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            ncmtProf.LEVEL_8__c = ncmtCECA.LEVEL_8__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            ncmtProf.LEVEL_9__c = ncmtCECA.LEVEL_9__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            ncmtProf.LEVEL_10__c = ncmtCECA.LEVEL_10__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            ncmtProf.Project_Total__c = ncmtCECA.Project_Total__c * projectReportData.PMData.Professional_Services_Fees_Preconst__c/100 * (1 + projectReportData.PMData.CMc__c/100);
            }
            
            //SUBTOTAL - CMc
            NCMT_Des_Report__c ncmtSubtotalCMc =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtSubtotalCMc.Division_Name__c = 'SUBTOTAL - CMC'; 
            ncmtSubtotalCMc.LEVEL_1__c = ncmtCECA.LEVEL_1__c + ncmtCMc.LEVEL_1__c + ncmtProf.LEVEL_1__c ;
            ncmtSubtotalCMc.LEVEL_2__c = ncmtCECA.LEVEL_2__c + ncmtCMc.LEVEL_2__c + ncmtProf.LEVEL_2__c ;
            ncmtSubtotalCMc.LEVEL_3__c = ncmtCECA.LEVEL_3__c + ncmtCMc.LEVEL_3__c + ncmtProf.LEVEL_3__c ;
            ncmtSubtotalCMc.LEVEL_4__c = ncmtCECA.LEVEL_4__c + ncmtCMc.LEVEL_4__c + ncmtProf.LEVEL_4__c ;
            ncmtSubtotalCMc.LEVEL_5__c = ncmtCECA.LEVEL_5__c + ncmtCMc.LEVEL_5__c + ncmtProf.LEVEL_5__c ;
            ncmtSubtotalCMc.LEVEL_6__c = ncmtCECA.LEVEL_6__c + ncmtCMc.LEVEL_6__c + ncmtProf.LEVEL_6__c ;
            ncmtSubtotalCMc.LEVEL_7__c = ncmtCECA.LEVEL_7__c + ncmtCMc.LEVEL_7__c + ncmtProf.LEVEL_7__c ;
            ncmtSubtotalCMc.LEVEL_8__c = ncmtCECA.LEVEL_8__c + ncmtCMc.LEVEL_8__c + ncmtProf.LEVEL_8__c ;
            ncmtSubtotalCMc.LEVEL_9__c = ncmtCECA.LEVEL_9__c + ncmtCMc.LEVEL_9__c + ncmtProf.LEVEL_9__c ;
            ncmtSubtotalCMc.LEVEL_10__c = ncmtCECA.LEVEL_10__c + ncmtCMc.LEVEL_10__c + ncmtProf.LEVEL_10__c ;
            ncmtSubtotalCMc.Project_Total__c = ncmtCECA.Project_Total__c + ncmtCMc.Project_Total__c + ncmtProf.Project_Total__c ;
            }
            
            //DEVELOPER FEE
            NCMT_Des_Report__c ncmtDevFee =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtDevFee.Division_Name__c = 'DEVELOPER FEE'; 
            ncmtDevFee.Division_Description__c = String.ValueOf(projectReportData.PMData.Developer_Fee__c)+'%';
            ncmtDevFee.LEVEL_1__c = ncmtSubtotalCMc.LEVEL_1__c * projectReportData.PMData.Developer_Fee__c/100;
            ncmtDevFee.LEVEL_2__c = ncmtSubtotalCMc.LEVEL_2__c * projectReportData.PMData.Developer_Fee__c/100;
            ncmtDevFee.LEVEL_3__c = ncmtSubtotalCMc.LEVEL_3__c * projectReportData.PMData.Developer_Fee__c/100;
            ncmtDevFee.LEVEL_4__c = ncmtSubtotalCMc.LEVEL_4__c * projectReportData.PMData.Developer_Fee__c/100;
            ncmtDevFee.LEVEL_5__c = ncmtSubtotalCMc.LEVEL_5__c * projectReportData.PMData.Developer_Fee__c/100;
            ncmtDevFee.LEVEL_6__c = ncmtSubtotalCMc.LEVEL_6__c * projectReportData.PMData.Developer_Fee__c/100;
            ncmtDevFee.LEVEL_7__c = ncmtSubtotalCMc.LEVEL_7__c * projectReportData.PMData.Developer_Fee__c/100;
            ncmtDevFee.LEVEL_8__c = ncmtSubtotalCMc.LEVEL_8__c * projectReportData.PMData.Developer_Fee__c/100;
            ncmtDevFee.LEVEL_9__c = ncmtSubtotalCMc.LEVEL_9__c * projectReportData.PMData.Developer_Fee__c/100;
            ncmtDevFee.LEVEL_10__c = ncmtSubtotalCMc.LEVEL_10__c * projectReportData.PMData.Developer_Fee__c/100;
            ncmtDevFee.Project_Total__c = ncmtSubtotalCMc.Project_Total__c * projectReportData.PMData.Developer_Fee__c/100; 
            }
            
            //DEVELOPER PROFESSIONAL SERVICES (AE, CM, COMM)
            NCMT_Des_Report__c ncmtDevProfFee =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtDevProfFee.Division_Name__c = 'DEVELOPER PROFESSIONAL SERVICES (AE, CM, COMM)'; 
            ncmtDevProfFee.Division_Description__c = String.ValueOf(projectReportData.PMData.Professional_Services_Developer_Fee__c)+'%';
            ncmtDevProfFee.LEVEL_1__c = ncmtSubtotalCMc.LEVEL_1__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100);
            ncmtDevProfFee.LEVEL_2__c = ncmtSubtotalCMc.LEVEL_2__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100);
            ncmtDevProfFee.LEVEL_3__c = ncmtSubtotalCMc.LEVEL_3__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100);
            ncmtDevProfFee.LEVEL_4__c = ncmtSubtotalCMc.LEVEL_4__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100);
            ncmtDevProfFee.LEVEL_5__c = ncmtSubtotalCMc.LEVEL_5__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100);
            ncmtDevProfFee.LEVEL_6__c = ncmtSubtotalCMc.LEVEL_6__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100);
            ncmtDevProfFee.LEVEL_7__c = ncmtSubtotalCMc.LEVEL_7__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100);
            ncmtDevProfFee.LEVEL_8__c = ncmtSubtotalCMc.LEVEL_8__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100);
            ncmtDevProfFee.LEVEL_9__c = ncmtSubtotalCMc.LEVEL_9__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100);
            ncmtDevProfFee.LEVEL_10__c = ncmtSubtotalCMc.LEVEL_10__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100);
            ncmtDevProfFee.Project_Total__c = ncmtSubtotalCMc.Project_Total__c * projectReportData.PMData.Professional_Services_Developer_Fee__c/100 * (1 + projectReportData.PMData.Developer_Fee__c/100); 
            }
            
            //SUBTOTAL - DEVELOPER
            NCMT_Des_Report__c ncmtSubtotalDev =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtSubtotalDev.Division_Name__c = 'SUBTOTAL - DEVELOPER'; 
            ncmtSubtotalDev.LEVEL_1__c = ncmtSubtotalCMc.LEVEL_1__c + ncmtDevFee.LEVEL_1__c + ncmtDevProfFee.LEVEL_1__c ;
            ncmtSubtotalDev.LEVEL_2__c = ncmtSubtotalCMc.LEVEL_2__c + ncmtDevFee.LEVEL_2__c + ncmtDevProfFee.LEVEL_2__c ;
            ncmtSubtotalDev.LEVEL_3__c = ncmtSubtotalCMc.LEVEL_3__c + ncmtDevFee.LEVEL_3__c + ncmtDevProfFee.LEVEL_3__c ;
            ncmtSubtotalDev.LEVEL_4__c = ncmtSubtotalCMc.LEVEL_4__c + ncmtDevFee.LEVEL_4__c + ncmtDevProfFee.LEVEL_4__c ;
            ncmtSubtotalDev.LEVEL_5__c = ncmtSubtotalCMc.LEVEL_5__c + ncmtDevFee.LEVEL_5__c + ncmtDevProfFee.LEVEL_5__c ;
            ncmtSubtotalDev.LEVEL_6__c = ncmtSubtotalCMc.LEVEL_6__c + ncmtDevFee.LEVEL_6__c + ncmtDevProfFee.LEVEL_6__c ;
            ncmtSubtotalDev.LEVEL_7__c = ncmtSubtotalCMc.LEVEL_7__c + ncmtDevFee.LEVEL_7__c + ncmtDevProfFee.LEVEL_7__c ;
            ncmtSubtotalDev.LEVEL_8__c = ncmtSubtotalCMc.LEVEL_8__c + ncmtDevFee.LEVEL_8__c + ncmtDevProfFee.LEVEL_8__c ;
            ncmtSubtotalDev.LEVEL_9__c = ncmtSubtotalCMc.LEVEL_9__c + ncmtDevFee.LEVEL_9__c + ncmtDevProfFee.LEVEL_9__c ;
            ncmtSubtotalDev.LEVEL_10__c = ncmtSubtotalCMc.LEVEL_10__c + ncmtDevFee.LEVEL_10__c + ncmtDevProfFee.LEVEL_10__c ;
            ncmtSubtotalDev.Project_Total__c = ncmtSubtotalCMc.Project_Total__c + ncmtDevFee.Project_Total__c + ncmtDevProfFee.Project_Total__c ;
            }
            
            //LESSOR FEE
            NCMT_Des_Report__c ncmtLessorFee =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtLessorFee.Division_Name__c = 'LESSOR FEE'; 
            ncmtLessorFee.Division_Description__c = String.ValueOf(projectReportData.PMData.Lessor_Fee__c)+'%';
            ncmtLessorFee.LEVEL_1__c = ncmtSubtotalDev.LEVEL_1__c * projectReportData.PMData.Lessor_Fee__c/100;
            ncmtLessorFee.LEVEL_2__c = ncmtSubtotalDev.LEVEL_2__c * projectReportData.PMData.Lessor_Fee__c/100;
            ncmtLessorFee.LEVEL_3__c = ncmtSubtotalDev.LEVEL_3__c * projectReportData.PMData.Lessor_Fee__c/100;
            ncmtLessorFee.LEVEL_4__c = ncmtSubtotalDev.LEVEL_4__c * projectReportData.PMData.Lessor_Fee__c/100;
            ncmtLessorFee.LEVEL_5__c = ncmtSubtotalDev.LEVEL_5__c * projectReportData.PMData.Lessor_Fee__c/100;
            ncmtLessorFee.LEVEL_6__c = ncmtSubtotalDev.LEVEL_6__c * projectReportData.PMData.Lessor_Fee__c/100;
            ncmtLessorFee.LEVEL_7__c = ncmtSubtotalDev.LEVEL_7__c * projectReportData.PMData.Lessor_Fee__c/100;
            ncmtLessorFee.LEVEL_8__c = ncmtSubtotalDev.LEVEL_8__c * projectReportData.PMData.Lessor_Fee__c/100;
            ncmtLessorFee.LEVEL_9__c = ncmtSubtotalDev.LEVEL_9__c * projectReportData.PMData.Lessor_Fee__c/100;
            ncmtLessorFee.LEVEL_10__c = ncmtSubtotalDev.LEVEL_10__c * projectReportData.PMData.Lessor_Fee__c/100;
            ncmtLessorFee.Project_Total__c = ncmtSubtotalDev.Project_Total__c * projectReportData.PMData.Lessor_Fee__c/100; 
            }
            
            //LESSOR PROFESSIONAL SERVICES (AE, CM, COMM)
            NCMT_Des_Report__c ncmtLessorProfFee =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtLessorProfFee.Division_Name__c = 'LESSOR PROFESSIONAL SERVICES (AE, CM, COMM)'; 
            ncmtLessorProfFee.Division_Description__c = String.ValueOf(projectReportData.PMData.Professional_Services_Lessor_Fee__c)+'%';
            ncmtLessorProfFee.LEVEL_1__c = ncmtSubtotalDev.LEVEL_1__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100);
            ncmtLessorProfFee.LEVEL_2__c = ncmtSubtotalDev.LEVEL_2__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100);
            ncmtLessorProfFee.LEVEL_3__c = ncmtSubtotalDev.LEVEL_3__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100);
            ncmtLessorProfFee.LEVEL_4__c = ncmtSubtotalDev.LEVEL_4__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100);
            ncmtLessorProfFee.LEVEL_5__c = ncmtSubtotalDev.LEVEL_5__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100);
            ncmtLessorProfFee.LEVEL_6__c = ncmtSubtotalDev.LEVEL_6__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100);
            ncmtLessorProfFee.LEVEL_7__c = ncmtSubtotalDev.LEVEL_7__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100);
            ncmtLessorProfFee.LEVEL_8__c = ncmtSubtotalDev.LEVEL_8__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100);
            ncmtLessorProfFee.LEVEL_9__c = ncmtSubtotalDev.LEVEL_9__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100);
            ncmtLessorProfFee.LEVEL_10__c = ncmtSubtotalDev.LEVEL_10__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100);
            ncmtLessorProfFee.Project_Total__c = ncmtSubtotalDev.Project_Total__c * projectReportData.PMData.Professional_Services_Lessor_Fee__c/100 * (1 + projectReportData.PMData.Lessor_Fee__c/100); 
            }
            
            //SUB TOTAL - LESSOR
            NCMT_Des_Report__c ncmtSubtotalLes =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtSubtotalLes.Division_Name__c = 'SUB TOTAL - LESSOR'; 
            ncmtSubtotalLes.LEVEL_1__c = ncmtSubtotalDev.LEVEL_1__c + ncmtLessorFee.LEVEL_1__c + ncmtLessorProfFee.LEVEL_1__c ;
            ncmtSubtotalLes.LEVEL_2__c = ncmtSubtotalDev.LEVEL_2__c + ncmtLessorFee.LEVEL_2__c + ncmtLessorProfFee.LEVEL_2__c ;
            ncmtSubtotalLes.LEVEL_3__c = ncmtSubtotalDev.LEVEL_3__c + ncmtLessorFee.LEVEL_3__c + ncmtLessorProfFee.LEVEL_3__c ;
            ncmtSubtotalLes.LEVEL_4__c = ncmtSubtotalDev.LEVEL_4__c + ncmtLessorFee.LEVEL_4__c + ncmtLessorProfFee.LEVEL_4__c ;
            ncmtSubtotalLes.LEVEL_5__c = ncmtSubtotalDev.LEVEL_5__c + ncmtLessorFee.LEVEL_5__c + ncmtLessorProfFee.LEVEL_5__c ;
            ncmtSubtotalLes.LEVEL_6__c = ncmtSubtotalDev.LEVEL_6__c + ncmtLessorFee.LEVEL_6__c + ncmtLessorProfFee.LEVEL_6__c ;
            ncmtSubtotalLes.LEVEL_7__c = ncmtSubtotalDev.LEVEL_7__c + ncmtLessorFee.LEVEL_7__c + ncmtLessorProfFee.LEVEL_7__c ;
            ncmtSubtotalLes.LEVEL_8__c = ncmtSubtotalDev.LEVEL_8__c + ncmtLessorFee.LEVEL_8__c + ncmtLessorProfFee.LEVEL_8__c ;
            ncmtSubtotalLes.LEVEL_9__c = ncmtSubtotalDev.LEVEL_9__c + ncmtLessorFee.LEVEL_9__c + ncmtLessorProfFee.LEVEL_9__c ;
            ncmtSubtotalLes.LEVEL_10__c = ncmtSubtotalDev.LEVEL_10__c + ncmtLessorFee.LEVEL_10__c + ncmtLessorProfFee.LEVEL_10__c ;
            ncmtSubtotalLes.Project_Total__c = ncmtSubtotalDev.Project_Total__c + ncmtLessorFee.Project_Total__c + ncmtLessorProfFee.Project_Total__c ;
            }
            
            //GROSS RECEIPT/STATE CONS. TAX
            NCMT_Des_Report__c ncmtGross =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtGross.Division_Name__c = 'GROSS RECEIPT/STATE CONS. TAX'; 
            ncmtGross.Division_Description__c = String.ValueOf(projectReportData.PMData.Gross_Receipt_State_Construction__c)+'%';
            ncmtGross.LEVEL_1__c = ncmtSubtotalLes.LEVEL_1__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100;
            ncmtGross.LEVEL_2__c = ncmtSubtotalLes.LEVEL_2__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100;
            ncmtGross.LEVEL_3__c = ncmtSubtotalLes.LEVEL_3__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100;
            ncmtGross.LEVEL_4__c = ncmtSubtotalLes.LEVEL_4__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100;
            ncmtGross.LEVEL_5__c = ncmtSubtotalLes.LEVEL_5__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100;
            ncmtGross.LEVEL_6__c = ncmtSubtotalLes.LEVEL_6__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100;
            ncmtGross.LEVEL_7__c = ncmtSubtotalLes.LEVEL_7__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100;
            ncmtGross.LEVEL_8__c = ncmtSubtotalLes.LEVEL_8__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100;
            ncmtGross.LEVEL_9__c = ncmtSubtotalLes.LEVEL_9__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100;
            ncmtGross.LEVEL_10__c = ncmtSubtotalLes.LEVEL_10__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100;
            ncmtGross.Project_Total__c = ncmtSubtotalLes.Project_Total__c * projectReportData.PMData.Gross_Receipt_State_Construction__c/100; 
            }
            
            
            //TOTAL CECA
            NCMT_Des_Report__c ncmtTotalCECA =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtTotalCECA.Division_Name__c = 'TOTAL CECA'; 
            ncmtTotalCECA.LEVEL_1__c = ncmtSubtotalLes.LEVEL_1__c + ncmtGross.LEVEL_1__c;
            ncmtTotalCECA.LEVEL_2__c = ncmtSubtotalLes.LEVEL_2__c + ncmtGross.LEVEL_2__c;
            ncmtTotalCECA.LEVEL_3__c = ncmtSubtotalLes.LEVEL_3__c + ncmtGross.LEVEL_3__c;
            ncmtTotalCECA.LEVEL_4__c = ncmtSubtotalLes.LEVEL_4__c + ncmtGross.LEVEL_4__c;
            ncmtTotalCECA.LEVEL_5__c = ncmtSubtotalLes.LEVEL_5__c + ncmtGross.LEVEL_5__c;
            ncmtTotalCECA.LEVEL_6__c = ncmtSubtotalLes.LEVEL_6__c + ncmtGross.LEVEL_6__c;
            ncmtTotalCECA.LEVEL_7__c = ncmtSubtotalLes.LEVEL_7__c + ncmtGross.LEVEL_7__c;
            ncmtTotalCECA.LEVEL_8__c = ncmtSubtotalLes.LEVEL_8__c + ncmtGross.LEVEL_8__c;
            ncmtTotalCECA.LEVEL_9__c = ncmtSubtotalLes.LEVEL_9__c + ncmtGross.LEVEL_9__c;
            ncmtTotalCECA.LEVEL_10__c = ncmtSubtotalLes.LEVEL_10__c + ncmtGross.LEVEL_10__c;
            ncmtTotalCECA.Project_Total__c = ncmtSubtotalLes.Project_Total__c + ncmtGross.Project_Total__c;
            }
            
            //MARKET ESCALATION 
            NCMT_Des_Report__c ncmtMarketESC =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtMarketESC.Division_Name__c = 'MARKET ESCALATION '; 
            ncmtMarketESC.Division_Description__c = String.ValueOf(projectReportData.PMData.Market_Escalation__c)+'%';
            ncmtMarketESC.LEVEL_1__c = ncmtTotalCECA.LEVEL_1__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESC.LEVEL_2__c = ncmtTotalCECA.LEVEL_2__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESC.LEVEL_3__c = ncmtTotalCECA.LEVEL_3__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESC.LEVEL_4__c = ncmtTotalCECA.LEVEL_4__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESC.LEVEL_5__c = ncmtTotalCECA.LEVEL_5__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESC.LEVEL_6__c = ncmtTotalCECA.LEVEL_6__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESC.LEVEL_7__c = ncmtTotalCECA.LEVEL_7__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESC.LEVEL_8__c = ncmtTotalCECA.LEVEL_8__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESC.LEVEL_9__c = ncmtTotalCECA.LEVEL_9__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESC.LEVEL_10__c = ncmtTotalCECA.LEVEL_10__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESC.Project_Total__c = ncmtTotalCECA.Project_Total__c * projectReportData.PMData.Market_Escalation__c/100; 
            }
            //MARKET ESCALATION 
            NCMT_Des_Report__c ncmtMarketESCOP =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c == 'RSMeans - O&P'){
            ncmtMarketESCOP.Division_Name__c = 'MARKET ESCALATION '; 
            ncmtMarketESCOP.Division_Description__c = String.ValueOf(projectReportData.PMData.Market_Escalation__c)+'%';
            ncmtMarketESCOP.LEVEL_1__c = ncmtBidF.LEVEL_1__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESCOP.LEVEL_2__c = ncmtBidF.LEVEL_2__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESCOP.LEVEL_3__c = ncmtBidF.LEVEL_3__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESCOP.LEVEL_4__c = ncmtBidF.LEVEL_4__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESCOP.LEVEL_5__c = ncmtBidF.LEVEL_5__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESCOP.LEVEL_6__c = ncmtBidF.LEVEL_6__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESCOP.LEVEL_7__c = ncmtBidF.LEVEL_7__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESCOP.LEVEL_8__c = ncmtBidF.LEVEL_8__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESCOP.LEVEL_9__c = ncmtBidF.LEVEL_9__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESCOP.LEVEL_10__c = ncmtBidF.LEVEL_10__c * projectReportData.PMData.Market_Escalation__c/100;
            ncmtMarketESCOP.Project_Total__c = ncmtBidF.Project_Total__c * projectReportData.PMData.Market_Escalation__c/100; 
            }
            
            //ECCA  
            NCMT_Des_Report__c ncmtECCA =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtECCA.Division_Name__c = 'ECCA'; 
            ncmtECCA.LEVEL_1__c = ncmtTotalCECA.LEVEL_1__c + ncmtMarketESC.LEVEL_1__c;
            ncmtECCA.LEVEL_2__c = ncmtTotalCECA.LEVEL_2__c + ncmtMarketESC.LEVEL_2__c;
            ncmtECCA.LEVEL_3__c = ncmtTotalCECA.LEVEL_3__c + ncmtMarketESC.LEVEL_3__c;
            ncmtECCA.LEVEL_4__c = ncmtTotalCECA.LEVEL_4__c + ncmtMarketESC.LEVEL_4__c;
            ncmtECCA.LEVEL_5__c = ncmtTotalCECA.LEVEL_5__c + ncmtMarketESC.LEVEL_5__c;
            ncmtECCA.LEVEL_6__c = ncmtTotalCECA.LEVEL_6__c + ncmtMarketESC.LEVEL_6__c;
            ncmtECCA.LEVEL_7__c = ncmtTotalCECA.LEVEL_7__c + ncmtMarketESC.LEVEL_7__c;
            ncmtECCA.LEVEL_8__c = ncmtTotalCECA.LEVEL_8__c + ncmtMarketESC.LEVEL_8__c;
            ncmtECCA.LEVEL_9__c = ncmtTotalCECA.LEVEL_9__c + ncmtMarketESC.LEVEL_9__c;
            ncmtECCA.LEVEL_10__c = ncmtTotalCECA.LEVEL_10__c + ncmtMarketESC.LEVEL_10__c;
            ncmtECCA.Project_Total__c = ncmtTotalCECA.Project_Total__c + ncmtMarketESC.Project_Total__c;
            }

            //ECCA  
            NCMT_Des_Report__c ncmtECCAOP =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c == 'RSMeans - O&P'){
            ncmtECCAOP.Division_Name__c = 'ECCA'; 
            ncmtECCAOP.LEVEL_1__c = ncmtBidF.LEVEL_1__c + ncmtMarketESCOP.LEVEL_1__c;
            ncmtECCAOP.LEVEL_2__c = ncmtBidF.LEVEL_2__c + ncmtMarketESCOP.LEVEL_2__c;
            ncmtECCAOP.LEVEL_3__c = ncmtBidF.LEVEL_3__c + ncmtMarketESCOP.LEVEL_3__c;
            ncmtECCAOP.LEVEL_4__c = ncmtBidF.LEVEL_4__c + ncmtMarketESCOP.LEVEL_4__c;
            ncmtECCAOP.LEVEL_5__c = ncmtBidF.LEVEL_5__c + ncmtMarketESCOP.LEVEL_5__c;
            ncmtECCAOP.LEVEL_6__c = ncmtBidF.LEVEL_6__c + ncmtMarketESCOP.LEVEL_6__c;
            ncmtECCAOP.LEVEL_7__c = ncmtBidF.LEVEL_7__c + ncmtMarketESCOP.LEVEL_7__c;
            ncmtECCAOP.LEVEL_8__c = ncmtBidF.LEVEL_8__c + ncmtMarketESCOP.LEVEL_8__c;
            ncmtECCAOP.LEVEL_9__c = ncmtBidF.LEVEL_9__c + ncmtMarketESCOP.LEVEL_9__c;
            ncmtECCAOP.LEVEL_10__c = ncmtBidF.LEVEL_10__c + ncmtMarketESCOP.LEVEL_10__c;
            ncmtECCAOP.Project_Total__c = ncmtBidF.Project_Total__c + ncmtMarketESCOP.Project_Total__c;
            }
            
            //CONSTRUCTION CONTINGENCY 
            NCMT_Des_Report__c ncmtConstCont =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtConstCont.Division_Name__c = 'CONSTRUCTION CONTINGENCY '; 
            ncmtConstCont.Division_Description__c = String.ValueOf(projectReportData.PMData.Construction_Contingency__c)+'%';
            ncmtConstCont.LEVEL_1__c = ncmtECCA.LEVEL_1__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstCont.LEVEL_2__c = ncmtECCA.LEVEL_2__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstCont.LEVEL_3__c = ncmtECCA.LEVEL_3__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstCont.LEVEL_4__c = ncmtECCA.LEVEL_4__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstCont.LEVEL_5__c = ncmtECCA.LEVEL_5__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstCont.LEVEL_6__c = ncmtECCA.LEVEL_6__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstCont.LEVEL_7__c = ncmtECCA.LEVEL_7__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstCont.LEVEL_8__c = ncmtECCA.LEVEL_8__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstCont.LEVEL_9__c = ncmtECCA.LEVEL_9__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstCont.LEVEL_10__c = ncmtECCA.LEVEL_10__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstCont.Project_Total__c = ncmtECCA.Project_Total__c * projectReportData.PMData.Construction_Contingency__c/100; 
            }
            //CONSTRUCTION CONTINGENCY 
            NCMT_Des_Report__c ncmtConstContOP =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c == 'RSMeans - O&P'){
            ncmtConstContOP.Division_Name__c = 'CONSTRUCTION CONTINGENCY '; 
            ncmtConstContOP.Division_Description__c = String.ValueOf(projectReportData.PMData.Construction_Contingency__c)+'%';
            ncmtConstContOP.LEVEL_1__c = ncmtECCAOP.LEVEL_1__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstContOP.LEVEL_2__c = ncmtECCAOP.LEVEL_2__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstContOP.LEVEL_3__c = ncmtECCAOP.LEVEL_3__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstContOP.LEVEL_4__c = ncmtECCAOP.LEVEL_4__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstContOP.LEVEL_5__c = ncmtECCAOP.LEVEL_5__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstContOP.LEVEL_6__c = ncmtECCAOP.LEVEL_6__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstContOP.LEVEL_7__c = ncmtECCAOP.LEVEL_7__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstContOP.LEVEL_8__c = ncmtECCAOP.LEVEL_8__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstContOP.LEVEL_9__c = ncmtECCAOP.LEVEL_9__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstContOP.LEVEL_10__c = ncmtECCAOP.LEVEL_10__c * projectReportData.PMData.Construction_Contingency__c/100;
            ncmtConstContOP.Project_Total__c = ncmtECCAOP.Project_Total__c * projectReportData.PMData.Construction_Contingency__c/100; 
            }
            //ART IN ARCHITECTURE
            NCMT_Des_Report__c ncmtAiA =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtAiA.Division_Name__c = 'ART IN ARCHITECTURE'; 
            ncmtAiA.Division_Description__c = String.ValueOf(projectReportData.PMData.Art_In_Architecture__c)+'%';
            ncmtAiA.LEVEL_1__c = ncmtECCA.LEVEL_1__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100);
            ncmtAiA.LEVEL_2__c = ncmtECCA.LEVEL_2__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100);
            ncmtAiA.LEVEL_3__c = ncmtECCA.LEVEL_3__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100);
            ncmtAiA.LEVEL_4__c = ncmtECCA.LEVEL_4__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100);
            ncmtAiA.LEVEL_5__c = ncmtECCA.LEVEL_5__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100);
            ncmtAiA.LEVEL_6__c = ncmtECCA.LEVEL_6__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100);
            ncmtAiA.LEVEL_7__c = ncmtECCA.LEVEL_7__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100);
            ncmtAiA.LEVEL_8__c = ncmtECCA.LEVEL_8__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100);
            ncmtAiA.LEVEL_9__c = ncmtECCA.LEVEL_9__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100);
            ncmtAiA.LEVEL_10__c = ncmtECCA.LEVEL_10__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100);
            ncmtAiA.Project_Total__c = ncmtECCA.Project_Total__c * projectReportData.PMData.Art_In_Architecture__c/100 * (1 + projectReportData.PMData.Construction_Contingency__c/100); 
            }
            
            //ECC
            NCMT_Des_Report__c ncmtECC =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtECC.Division_Name__c = 'ECC'; 
            ncmtECC.LEVEL_1__c = ncmtECCA.LEVEL_1__c + ncmtConstCont.LEVEL_1__c + ncmtAiA.LEVEL_1__c;
            ncmtECC.LEVEL_2__c = ncmtECCA.LEVEL_2__c + ncmtConstCont.LEVEL_2__c + ncmtAiA.LEVEL_2__c;
            ncmtECC.LEVEL_3__c = ncmtECCA.LEVEL_3__c + ncmtConstCont.LEVEL_3__c+ ncmtAiA.LEVEL_3__c;
            ncmtECC.LEVEL_4__c = ncmtECCA.LEVEL_4__c + ncmtConstCont.LEVEL_4__c + ncmtAiA.LEVEL_4__c;
            ncmtECC.LEVEL_5__c = ncmtECCA.LEVEL_5__c + ncmtConstCont.LEVEL_5__c + ncmtAiA.LEVEL_5__c;
            ncmtECC.LEVEL_6__c = ncmtECCA.LEVEL_6__c + ncmtConstCont.LEVEL_6__c+ ncmtAiA.LEVEL_6__c;
            ncmtECC.LEVEL_7__c = ncmtECCA.LEVEL_7__c + ncmtConstCont.LEVEL_7__c + ncmtAiA.LEVEL_7__c;
            ncmtECC.LEVEL_8__c = ncmtECCA.LEVEL_8__c + ncmtConstCont.LEVEL_8__c + ncmtAiA.LEVEL_8__c;
            ncmtECC.LEVEL_9__c = ncmtECCA.LEVEL_9__c + ncmtConstCont.LEVEL_9__c+ ncmtAiA.LEVEL_9__c;
            ncmtECC.LEVEL_10__c = ncmtECCA.LEVEL_10__c + ncmtConstCont.LEVEL_10__c+ ncmtAiA.LEVEL_10__c;
            ncmtECC.Project_Total__c = ncmtECCA.Project_Total__c + ncmtConstCont.Project_Total__c + ncmtAiA.Project_Total__c;
            }
            
            //ECC
            NCMT_Des_Report__c ncmtECCOP =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c == 'RSMeans - O&P'){
            ncmtECCOP.Division_Name__c = 'ECC'; 
            ncmtECCOP.LEVEL_1__c = ncmtECCAOP.LEVEL_1__c + ncmtConstContOP.LEVEL_1__c;
            ncmtECCOP.LEVEL_2__c = ncmtECCAOP.LEVEL_2__c + ncmtConstContOP.LEVEL_2__c;
            ncmtECCOP.LEVEL_3__c = ncmtECCAOP.LEVEL_3__c + ncmtConstContOP.LEVEL_3__c;
            ncmtECCOP.LEVEL_4__c = ncmtECCAOP.LEVEL_4__c + ncmtConstContOP.LEVEL_4__c;
            ncmtECCOP.LEVEL_5__c = ncmtECCAOP.LEVEL_5__c + ncmtConstContOP.LEVEL_5__c;
            ncmtECCOP.LEVEL_6__c = ncmtECCAOP.LEVEL_6__c + ncmtConstContOP.LEVEL_6__c;
            ncmtECCOP.LEVEL_7__c = ncmtECCAOP.LEVEL_7__c + ncmtConstContOP.LEVEL_7__c;
            ncmtECCOP.LEVEL_8__c = ncmtECCAOP.LEVEL_8__c + ncmtConstContOP.LEVEL_8__c;
            ncmtECCOP.LEVEL_9__c = ncmtECCAOP.LEVEL_9__c + ncmtConstContOP.LEVEL_9__c;
            ncmtECCOP.LEVEL_10__c = ncmtECCAOP.LEVEL_10__c + ncmtConstContOP.LEVEL_10__c;
            ncmtECCOP.Project_Total__c = ncmtECCAOP.Project_Total__c + ncmtConstContOP.Project_Total__c;
            }
            
            //EDRC
            NCMT_Des_Report__c ncmtEDRC =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtEDRC.Division_Name__c = 'EDRC'; 
            ncmtEDRC.Division_Description__c = String.ValueOf(projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c)+'%';
            ncmtEDRC.LEVEL_1__c = ncmtECC.LEVEL_1__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100;
            ncmtEDRC.LEVEL_2__c = ncmtECC.LEVEL_2__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100;
            ncmtEDRC.LEVEL_3__c = ncmtECC.LEVEL_3__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100;
            ncmtEDRC.LEVEL_4__c = ncmtECC.LEVEL_4__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100;
            ncmtEDRC.LEVEL_5__c = ncmtECC.LEVEL_5__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100;
            ncmtEDRC.LEVEL_6__c = ncmtECC.LEVEL_6__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100;
            ncmtEDRC.LEVEL_7__c = ncmtECC.LEVEL_7__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100;
            ncmtEDRC.LEVEL_8__c = ncmtECC.LEVEL_8__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100;
            ncmtEDRC.LEVEL_9__c = ncmtECC.LEVEL_9__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100;
            ncmtEDRC.LEVEL_10__c = ncmtECC.LEVEL_10__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100;
            ncmtEDRC.Project_Total__c = ncmtECC.Project_Total__c * projectReportData.PMData.EDRC_Estimated_Design_and_Review_Cost__c/100; 
            }
            
            //EMIC
            NCMT_Des_Report__c ncmtEMIC =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtEMIC.Division_Name__c = 'EMIC'; 
            ncmtEMIC.Division_Description__c = String.ValueOf(projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c)+'%';
            ncmtEMIC.LEVEL_1__c = ncmtECC.LEVEL_1__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100;
            ncmtEMIC.LEVEL_2__c = ncmtECC.LEVEL_2__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100;
            ncmtEMIC.LEVEL_3__c = ncmtECC.LEVEL_3__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100;
            ncmtEMIC.LEVEL_4__c = ncmtECC.LEVEL_4__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100;
            ncmtEMIC.LEVEL_5__c = ncmtECC.LEVEL_5__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100;
            ncmtEMIC.LEVEL_6__c = ncmtECC.LEVEL_6__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100;
            ncmtEMIC.LEVEL_7__c = ncmtECC.LEVEL_7__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100;
            ncmtEMIC.LEVEL_8__c = ncmtECC.LEVEL_8__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100;
            ncmtEMIC.LEVEL_9__c = ncmtECC.LEVEL_9__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100;
            ncmtEMIC.LEVEL_10__c = ncmtECC.LEVEL_10__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100;
            ncmtEMIC.Project_Total__c = ncmtECC.Project_Total__c * projectReportData.PMData.EMIC_Estimated_Management_Inspection_Co__c/100; 
            }
            
            //ETPC
            NCMT_Des_Report__c ncmtETPC =  setDefaultNCMTDesData(projectReportData);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtETPC.Division_Name__c = 'ETPC'; 
            ncmtETPC.LEVEL_1__c = ncmtECC.LEVEL_1__c + ncmtEDRC.LEVEL_1__c + ncmtEMIC.LEVEL_1__c;
            ncmtETPC.LEVEL_2__c = ncmtECC.LEVEL_2__c + ncmtEDRC.LEVEL_2__c + ncmtEMIC.LEVEL_2__c;
            ncmtETPC.LEVEL_3__c = ncmtECC.LEVEL_3__c + ncmtEDRC.LEVEL_3__c+ ncmtEMIC.LEVEL_3__c;
            ncmtETPC.LEVEL_4__c = ncmtECC.LEVEL_4__c + ncmtEDRC.LEVEL_4__c + ncmtEMIC.LEVEL_4__c;
            ncmtETPC.LEVEL_5__c = ncmtECC.LEVEL_5__c + ncmtEDRC.LEVEL_5__c + ncmtEMIC.LEVEL_5__c;
            ncmtETPC.LEVEL_6__c = ncmtECC.LEVEL_6__c + ncmtEDRC.LEVEL_6__c+ ncmtEMIC.LEVEL_6__c;
            ncmtETPC.LEVEL_7__c = ncmtECC.LEVEL_7__c + ncmtEDRC.LEVEL_7__c + ncmtEMIC.LEVEL_7__c;
            ncmtETPC.LEVEL_8__c = ncmtECC.LEVEL_8__c + ncmtEDRC.LEVEL_8__c + ncmtEMIC.LEVEL_8__c;
            ncmtETPC.LEVEL_9__c = ncmtECC.LEVEL_9__c + ncmtEDRC.LEVEL_9__c+ ncmtEMIC.LEVEL_9__c;
            ncmtETPC.LEVEL_10__c = ncmtECC.LEVEL_10__c + ncmtEDRC.LEVEL_10__c+ ncmtEMIC.LEVEL_10__c;
            ncmtETPC.Project_Total__c = ncmtECC.Project_Total__c + ncmtEDRC.Project_Total__c + ncmtEMIC.Project_Total__c;
            }
            
            ncmtDESToInsert.addAll(ncmtDesDToInsert);   
            ncmtDESToInsert.add(ncmtTotal);
            IF(projectReportData.PMData.Project_Name__r.Markup_Method__c <> 'RSMeans - O&P'){
            ncmtDESToInsert.add(ncmtDesign);
            ncmtDESToInsert.add(ncmtSubtotal);
            ncmtDESToInsert.add(ncmtPrime);
            ncmtDESToInsert.add(ncmtCECA);
            ncmtDESToInsert.add(ncmtCMc);
            ncmtDESToInsert.add(ncmtProf);
            ncmtDESToInsert.add(ncmtSubtotalCMc);
            ncmtDESToInsert.add(ncmtDevFee);
            ncmtDESToInsert.add(ncmtDevProfFee);
            ncmtDESToInsert.add(ncmtSubtotalDev);
            ncmtDESToInsert.add(ncmtLessorFee);
            ncmtDESToInsert.add(ncmtLessorProfFee);
            ncmtDESToInsert.add(ncmtSubtotalLes);
            ncmtDESToInsert.add(ncmtGross);
            ncmtDESToInsert.add(ncmtTotalCECA);
            ncmtDESToInsert.add(ncmtMarketESC);
            ncmtDESToInsert.add(ncmtECCA);
            ncmtDESToInsert.add(ncmtConstCont);
            ncmtDESToInsert.add(ncmtAiA);
            ncmtDESToInsert.add(ncmtECC);  
            ncmtDESToInsert.add(ncmtEDRC);
            ncmtDESToInsert.add(ncmtEMIC);
            ncmtDESToInsert.add(ncmtETPC);
            }else{
                ncmtDESToInsert.add(ncmtBidF);
                ncmtDESToInsert.add(ncmtMarketESCOP);
                ncmtDESToInsert.add(ncmtECCAOP);
                ncmtDESToInsert.add(ncmtConstContOP);
                ncmtDESToInsert.add(ncmtECCOP);
            }
        }
        if(ncmtDESToInsert.size() > 0){
            list<NCMT_Des_Report__c> ncmtDESToDelete = [select id from NCMT_Des_Report__c where Project_ID__c In : reportDataMap.keySet()];
            delete ncmtDESToDelete;
            insert ncmtDESToInsert; 
        }
    }
    public static NCMT_Des_Report__c setDefaultNCMTDesData(reportData projectReportData){
        
            NCMT_Des_Report__c ncmtDesData =  new NCMT_Des_Report__c();
            ncmtDesData.Project_ID__c = projectReportData.PMData.Project_Name__r.id;
            ncmtDesData.Project_Name__c = projectReportData.PMData.Project_Name__r.Name;
            ncmtDesData.LEVEL_1__c = 0;
            ncmtDesData.LEVEL_2__c = 0;
            ncmtDesData.LEVEL_3__c = 0;
            ncmtDesData.LEVEL_4__c = 0;
            ncmtDesData.LEVEL_5__c = 0;
            ncmtDesData.LEVEL_6__c = 0;
            ncmtDesData.LEVEL_6__c = 0;
            ncmtDesData.LEVEL_7__c = 0;
            ncmtDesData.LEVEL_8__c = 0;
            ncmtDesData.LEVEL_9__c = 0;
            ncmtDesData.LEVEL_10__c = 0;
            ncmtDesData.Project_Total__c = 0;
        	return ncmtDesData;
    }
    
    
    private static Map<Id,reportData> getProjectData( List<Id> projectIds){
        Map<Id,reportData> responseMap = new Map<Id,reportData>();
        Map<Id,NCMT_Project_Markup__c> PMDataMap = new Map<Id,NCMT_Project_Markup__c>();
        Map<Id,List<NCMT_Tree_structure__c>> treeStrucMap = new Map<Id,List<NCMT_Tree_structure__c>>();
        Map<Id,List<NCMT_DES_Items__c>> projDESItemMap = new Map<Id,List<NCMT_DES_Items__c>>();
        
        
        for(NCMT_Project_Markup__c projectMarkup : [select id, Name,Project_Name__c, Subtotal_OS_Self__c,

                                                                        Total_Cost_w_o_SubCon_Markups__c, Total_Cost_w_Subcon_Markups__c,
                                                                        Site_Design_Contingency__c, Site_and_Design_Cont_Impact__c,
                                                                        
                                                                         SubTotal_w_o_SubCon__c, SubTotal_with_SubCon__c,  SubTotal__c,
                            
                                                                        Self_Work_Home_Office_Impact__c, Self_Work_Jobsite_Impact__c, Self_Work_Profit_Impact__c, 
                                                                        Self_Work_Commission_Impact__c, Self_Work_Bond_Impact__c, Self_Work_Pro_Services_Impact__c,
                            
                                                                        OS_Work_Home_Office_Impact__c, OS_Work_Jobsite_Overhead_Impact__c, OS_Work_Profit_Impact__c,
                                                                        OS_Work_Commission_Impact__c, OS_Work_Bond_Impact__c, OS_Work_Pro_Services_Impact__c, 
                                                                        
                                                                        SubTotal_SelfPerformedWork__c, Prime_Contractor_Markup_Cost__c,
                                                                        Prime_Con_SelfWork_HomeOff_Overhead__c, Prime_Con_SelfWork_JobSiteOverhead__c, Prime_Con_SelfWork_Profit__c, 
                                                                        Prime_Con_SelfWork_Commission__c, Prime_Con_SelfWork_Bond__c, Professional_Services_Fees_SelfWork__c,
                                                                        
                                                                        SubTotal_BidFactor__c, Bid_Factor__c, Bid_Factor_Impact__c,
                            
                                                                        SubTotal_Out_SourcedWork__c, Subcontractor_Markup_Cost__c,
                                                                        Prime_Con_OSWork_Homeoff_Overhead__c, Prime_Con_OSWork_Jobsite_Overhead__C, Prime_Con_OSWork_Profit__c, 
                                                                        Prime_Con_OSWork_Commission__c, Prime_Con_OSWork_Bond__c, Professional_Services_Fees_OSWork__c,
                                                                            
                                                                        CMc__c, CMC_Impact__c, Professional_Services_Fees_Preconst__c, Pro_Services_Pre_Const_Impact__c, SubTotal_CMc_f__c, 
                            
                                                                        Developer_Fee__c, Professional_Services_Developer_Fee__c, SubTotal_Developer_f__c,
                                                                        Developer_Fee_Impact__c, Developer_Professional_Services_Impact__c,
                            
                                                                        Lessor_Fee__c, Professional_Services_Lessor_Fee__c, Sub_Total_Lessor__c, SubTotal_Lessor_f__c,
                                                                        Lessor_Fee_impact__c, Lessor_Professional_Services_Impact__c,
                            
                                                                        Gross_Receipt_State_Construction__c, Gross_Receipts_Impact__c, CECCA__c, Total_CECCA__c,
                                                                        
                                                                        Market_Escalation__c, Market_Escalation_Markup_Impact__c, ECCA__c,
                                                                        
                                                                        Construction_Contingency__c, Construction_Contingency_Markup_Impact__c, 
                                                                        Art_In_Architecture__c, Art_In_Architecture_Markup_Impact__c, ECC__c, 
                            
                                                                        EDRC_Estimated_Design_and_Review_Cost__c , EDRC_Impact__c,
                                                                        EMIC_Estimated_Management_Inspection_Co__c, EMIC_Impact__c, ETPC__c, Project_Name__r.Id, Project_Name__r.Name, Project_Name__r.Markup_Method__c
                                                                from NCMT_Project_Markup__c  
                                                                where  Project_Name__c IN : projectIds]){
                                                                    PMDataMap.put(projectMarkup.Project_Name__c,projectMarkup);
                                                                    
                                                                }
        for(NCMT_Tree_structure__c treeStruc : [select id, Name,Project_ID__c,branch_name__c, level__c, SortOrdertxt__c,Total_Including_Markups__c
                                                   from NCMT_Tree_structure__c
                                                   where Project_ID__c IN :projectIds
                                                 	AND Include_in_Estimate__c = TRUE
                                                    and level__c In (0,1)
                                                 	ORDER BY SortOrdertxt__c]){
                                                       if(treeStrucMap.containsKey(treeStruc.Project_ID__c)){
                                                            treeStrucMap.get(treeStruc.Project_ID__c).add(treeStruc);
                                                        }
                                                        else{
                                                            treeStrucMap.put(treeStruc.Project_ID__c, new List<NCMT_Tree_structure__c>{treeStruc});
                                                        }
                                                   }
        
        for(NCMT_DES_Items__c ncmtDESItem : [select Level_2__c, Tree_structure__c,Cost_Summary__c, CSI_Line_Item_Number__c,
                                              Total_Cost__c,NCMT_Proj_ID__c,NCMT_Project_Name__c,Tree_structure__r.Branch_Name__c,
                                             Level_2__r.Name,Tree_structure__r.SortOrdertxt__c, Tree_structure__r.level__c,Tree_structure__r.Relatedtree__c,
                                             Tree_structure__r.Parent_Name__c,Tree_structure__r.Total_Including_Markups__c
                                             from NCMT_DES_Items__c 
                                             WHERE NCMT_Proj_ID__c IN : projectIds 
                                             AND Include_In_Estimate__c = TRUE
                                             Order by NCMT_Proj_ID__c, Tree_structure__r.SortOrdertxt__c])
        									{
                                                if(projDESItemMap.containsKey(ncmtDESItem.NCMT_Proj_ID__c)){
                                                     projDESItemMap.get(ncmtDESItem.NCMT_Proj_ID__c).add(ncmtDESItem);
                                                }
                                                else{
                                                    projDESItemMap.put(ncmtDESItem.NCMT_Proj_ID__c, new List<NCMT_DES_Items__c>{ncmtDESItem});
                                                }
                                             }                          
        
        
        for(Id projectId : projectIds){
            //system.debug(':::projectId:::'+projectId);
            reportData response = new reportData();
            response.PMData= PMDataMap.get(projectId);
            response.treeStrucData = treeStrucMap.get(projectId);
            response.projDESItemData = projDESItemMap.get(projectId);
            //system.debug('::response.projDESItemData:::'+response.projDESItemData);
            responseMap.put(projectId,response);
        }
        return responseMap;
        
    }
    
    
    
    public class reportData{
        @AuraEnabled public NCMT_Project_Markup__c PMData{get;set;}
        @AuraEnabled public List<NCMT_Tree_structure__c> treeStrucData{get;set;}
        @AuraEnabled public List<NCMT_DES_Items__c> projDESItemData{get;set;} 
        public reportData(){
            this.PMData=new NCMT_Project_Markup__c();
            this.treeStrucData=new List<NCMT_Tree_structure__c>();
            this.projDESItemData =new List<NCMT_DES_Items__c>();
        }
    }
}