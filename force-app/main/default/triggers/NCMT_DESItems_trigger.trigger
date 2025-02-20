trigger NCMT_DESItems_trigger on NCMT_DES_Items__c (before insert, before update, after delete, after insert, after update) {
    
    set<id> PCSIds = new set<id>();
    set<id> DESItemIds = new set<id>();
    set<id> NCMTIdsset = new  set<id>();
    set<string> strMinIDs = new  set<string>();
    map<id,NCMT_Project_Cost_Summary__c> PCSmap = new map<id,NCMT_Project_Cost_Summary__c>();
    map<string,string> plpProjMap = new map<string ,string>();
    Set<String> SubContractorNames = new Set<String>();
    string  RecordTypeTreeLeaf = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Tree Leaf').getRecordTypeId();
    string  RecordTypeTreeLeafOP = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Tree Leaf O&P').getRecordTypeId();
    string  RecordTypeTreeDefault = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
    set<String> crewMasterSet = new set<String>();                                         
    set<String> laborResourcesSet = new set<String>();
    set<String> projectLocationSet = new set<String>();
    Map<String,Decimal> laborlocMap = new Map<String,Decimal>();
    Decimal dblMinCost, totalcount,dbltotallaborcost,dblnewQuantity,dbloldQuantity = 0;
    String  strMinID,projectId; 
    Map<ID,Schema.RecordTypeInfo> rt_Map = NCMT_DES_Items__c.sObjectType.getDescribe().getRecordTypeInfosById();
    //get current year and convert to string for comparison to fiscal year
    NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
    Date CostParameterDate = ncmt_customsettings.Cost_Parameter_Date__c;
    string CostParameterYear = string.valueof(CostParameterDate.year()+1); 
    System.debug('DES ITEM TRIGGER');
    
    if((trigger.isInsert && trigger.isBefore) || (trigger.isUpdate && trigger.IsBefore)) {
        //System.debug('Trigger** Before Insert & before Update: ' + trigger.new[0].In_house_Unit_Total__c);
        map<string,decimal> OverheadMap = new map<string,decimal>();
        map<string,decimal> ProfitMap = new map<string,decimal>();
        map<string,decimal> BondMap = new map<string,decimal>();
        //SFWS-1472/1555
        
        Id recordId1 = Schema.getGlobalDescribe().get('NCMT_DES_Items__c').getDescribe().getRecordTypeInfosByName().get('NCMT DES Item Uniformat').getRecordTypeId();
        Id recordId2 = Schema.getGlobalDescribe().get('NCMT_DES_Items__c').getDescribe().getRecordTypeInfosByName().get('NCMT DES Item Uniformat O&P').getRecordTypeId();
        
/*Solution Code SFWS-2018 block 1:
 *  Added LabourMarkupMap,EquipmentMarkupMap,MaterialMarkupMap created so that it can be called to fetcg the Markup for given Project Name.
 */        
        List<String> ncmtprojectIds = new List<String> ();
        Map<String,Decimal> ProjectIdLabourMarkupMap = new Map<String,Decimal>();
        Map<String,Decimal> ProjectIdEquipmentMarkupMap = new Map<String,Decimal>();
        Map<String,Decimal> ProjectIdMaterialMarkupMap = new Map<String,Decimal>();
        
        //  Below code added as soln to SFWS-2033 on 11/21/2022
        Map<String,Decimal> projectIdSalesTaxMap = new Map<String,Decimal>();
        
        for (NCMT_DES_Items__c iter :trigger.new){
            
            ncmtprojectIds.add(iter.NCMT_Project_ID__c);
        }
        
        for(NCMT_Project_Markup__c markUp:[Select Id,Sales_Tax__c,Project_Name__c,Equipment_Project_Premium_Markup__c,Labor_Project_Premium_Markup__c,Material_Project_Premium_Markup__c from NCMT_Project_Markup__c where Project_Name__c in: ncmtprojectIds]){
 
            // Added the Map to fetch the Markups from ProjectName
            ProjectIdLabourMarkupMap.put(String.valueOf(markUp.Project_Name__c).substring(0, 15),markUp.Labor_Project_Premium_Markup__c);
            ProjectIdEquipmentMarkupMap.put(String.valueOf(markUp.Project_Name__c).substring(0, 15),markUp.Equipment_Project_Premium_Markup__c);
            ProjectIdMaterialMarkupMap.put(String.valueOf(markUp.Project_Name__c).substring(0, 15),markUp.Material_Project_Premium_Markup__c);
            
           //  Below code added to fetch Salestax from Markup as soln to SFWS-2033 on 11/21/2022  
           projectIdSalesTaxMap.put(String.valueOf(markUp.Project_Name__c).substring(0, 15),markUp.Sales_Tax__c);
            
        }
// End of Solution Code SFWS-2018 Block 1 ends
        
        for(NCMT_DES_Items__c iter :trigger.new){
            DESItemIds.add(iter.id);
            strMinIDs.add(iter.MinID__c);
            projectId = iter.NCMT_Project_ID__c;
            SubContractorNames.add(iter.NCMT_Contractor_ID__c);
            crewMasterSet.add(iter.NCMT_Crew_Master__c);
            laborResourcesSet.add(iter.NCMT_Labor_Resources__c);
            projectLocationSet.add(iter.NCMT_Project_Location__c); 
            dblnewQuantity = iter.Quantity__c;
            //SFWS-1472/1555
            system.debug('Record Type name: '+iter.RecordTypeId);          
            
            //  Below code Commented out as soln to SFWS-2033 on 11/21/2022 
            // NCMT_Project_Markup__c markupData = [SELECT id, Sales_Tax__c FROM NCMT_Project_Markup__c WHERE Project_Name__c  =:projectId];
            //8/15/22 - SFWS-1894 (ensure sales tax is retrieved from the markup record)
/*
* Solution Code SFWS-2018 block 2: 
*/ 
            Decimal LaborMarkupVar = ProjectIdLabourMarkupMap.get(projectId); 
            iter.Labor_Project_Premium_Markup__c = LaborMarkupVar;  
            
            Decimal MaterialMarkupVar = ProjectIdMaterialMarkupMap.get(projectId); 
            iter.Material_Project_Premium_Markup__c = MaterialMarkupVar;  
            
            Decimal EquipmentMarkupVar = ProjectIdEquipmentMarkupMap.get(projectId); 
            iter.Equipment_Project_Premium_Markup__c = EquipmentMarkupVar;
            
            // Below code Commented out and replaced by next two lines as soln to SFWS-2033 on 11/21/2022  
            // iter.Sales_Tax__c = markupData.Sales_Tax__c;
            
            Decimal salesTaxFromMarkupVar = projectIdSalesTaxMap.get(projectId); 
            iter.Sales_Tax__c = salesTaxFromMarkupVar;
            
            system.debug('Sales Tax'+ iter.Sales_Tax__c);
            
            /*
* End of  Solution Code SFWS-2018 block 2 ends
*/ 
            if((iter.RecordTypeId == recordId1) || (iter.RecordTypeId == recordId2)){
                //moving this logic to trigger: Unit_Total_per_Quantity__c = Labor_Assembly_Cost__c + Material_Assembly_Cost__c + Equipment_Assembly_Cost__c
                iter.In_house_Unit_Total__c = iter.Labor_Assembly_Cost__c + iter.Material_Assembly_Cost__c + iter.Equipment_Assembly_Cost__c;
                
                iter.O_P_Unit_Total__c = iter.O_P_Total_Cost__c;
            } 
            
            //End SFWS-1472/1555
            IF(trigger.isupdate){
                dbloldQuantity = trigger.oldmap.get(iter.id).Quantity__c;
            } 
        }
        
        if(TriggerValue.isClone == false && TriggerValue.isPaste == false){
            List <NCMT_Contractor__c> SubConlst = [SELECT Id,Name,Overhead__c,Profit__c, Bond__c,Fiscal_Year__c FROM NCMT_Contractor__c 
                                                   WHERE Id IN :SubContractorNames
                                                   and  fiscal_year__c = :CostParameterYear];
            for(NCMT_Contractor__c sublist:SubConlst){    
                OverheadMap.put(sublist.Id,sublist.Overhead__c);
                ProfitMap.put(sublist.Id,sublist.Profit__c);
                BondMap.put(sublist.Id,sublist.Bond__c);
            }
            for(NCMT_DES_Items__c iter :trigger.new){
                if(iter.NCMT_Contractor_ID__c != null)
                {
                    if(trigger.isinsert || (trigger.isupdate && trigger.oldmap.get(iter.id).NCMT_Contractor_ID__c != iter.NCMT_Contractor_ID__c)){
                        iter.SubContractor_Overhead__c = OverheadMap.get(iter.NCMT_Contractor_ID__c);
                        iter.SubContractor_Profit__c = ProfitMap.get(iter.NCMT_Contractor_ID__c);
                        iter.SubContractor_Bond__c =  BondMap.get(iter.NCMT_Contractor_ID__c);
                    }
                }else{
                    if(trigger.isinsert || (trigger.isupdate && trigger.oldmap.get(iter.id).NCMT_Contractor_ID__c != iter.NCMT_Contractor_ID__c)){
                        
                        iter.SubContractor_Overhead__c = 0.00;
                        iter.SubContractor_Profit__c = 0.00;
                        iter.SubContractor_Bond__c = 0.00;
                    }
                    
                }
            }     
        }
        
        //for updating current labor cost for MinID
        if((!TriggerValue.isMinCost)){
            IF(trigger.isupdate){
                for(NCMT_DES_Items__c iter :trigger.new){
                    
                    dbltotallaborcost =  iter.Total_Labor_Cost__c;
                    if ((trigger.oldmap.get(iter.id).Quantity__c != iter.Quantity__c) && (iter.Original_Minimum_Cost__c >0) && (!TriggerValue.isMinCostCurrent)){
                        dbloldQuantity = trigger.oldmap.get(iter.id).Quantity__c;    
                        iter.Labor_Cost__c = iter.Labor_Assembly_Cost__c * iter.Quantity__c;
                        
                        iter.Total_Labor_Cost__c = (iter.Total_Labor_Cost__c - (dbloldQuantity*iter.Labor_Assembly_Cost__c))+(iter.Labor_Assembly_Cost__c * iter.Quantity__c);
                        dbltotallaborcost =  iter.Total_Labor_Cost__c;
                        TriggerValue.isMinCostCurrent=true;
                    }
                }
            }  
            //for updating minimum cost having same MinID 
            if(trigger.isUpdate){
                if ((dbloldQuantity != dblnewQuantity) && strMinIDs.size() >0){                    
                    List<NCMT_DES_Items__c> DESItemsList = [Select ID, Name, MinID__c,Minimum_Cost__c,Total_Labor_Cost__c
                                                            From NCMT_DES_Items__c 
                                                            where NCMT_Project_ID__c = :projectId
                                                            and ID NOT IN :DESItemIds
                                                            and MinID__c IN :strMinIDs
                                                            and Original_Minimum_Cost__c > 0
                                                           ];
                    //system.debug('dbltotallaborcost==='+dbltotallaborcost);
                    if(DESItemsList.size()>0){
                        for(NCMT_DES_Items__c DESList :DESItemsList){
                            //DESList.Minimum_Cost__c = dblMinCost;
                            DESList.Total_Labor_Cost__c = dbltotallaborcost;
                        }
                        update DESItemsList;
                    }
                }
                //TriggerValue.isMinCost = true;
            }
            
        }
        
        //for updating labor burden tax
        List <NCMT_Labor_Location_Markup__c> laborLoclst = [SELECT Id,Name,Labor_Burden_Tax__c,NCMT_Crew_Master__c,
                                                            NCMT_Labor_Resource__c,Per_State_Territory__c,NCMT_Labor_Resource__r.name,
                                                            NCMT_Crew_Master__r.name
                                                            FROM NCMT_Labor_Location_Markup__c 
                                                            WHERE (NCMT_Crew_Master__c IN :crewMasterSet
                                                                   OR NCMT_Labor_Resource__r.name IN :laborResourcesSet)
                                                            AND Per_State_Territory__c IN :projectLocationSet
                                                            AND Fiscal_Year__c = :CostParameterYear] ;
        system.debug('laborLoclst=='+laborLoclst);
        system.debug('laborLoclst=='+laborLoclst.size());
        if(laborLoclst.size()>0){       
            for (NCMT_Labor_Location_Markup__c iter: laborLoclst) {
                if(iter.NCMT_Crew_Master__c !=null){
                    laborLocMap.put(iter.NCMT_Crew_Master__c,iter.Labor_Burden_Tax__c); 
                }else{
                    laborLocMap.put(iter.NCMT_Labor_Resource__r.name,iter.Labor_Burden_Tax__c);    
                }
            }
            for(NCMT_DES_Items__c objDes :trigger.new){
                if((trigger.isinsert && TriggerValue.isClone == true)|| (trigger.isupdate && (trigger.oldmap.get(objDes.id).NCMT_Crew_Master__c != objDes.NCMT_Crew_Master__c ||
                                                                                              trigger.oldmap.get(objDes.id).NCMT_Project_Location__c != objDes.NCMT_Project_Location__c))){ 
                                                                                                  if(objDes.NCMT_Crew_Master__c !=null){ 
                                                                                                      objDes.Labor_Burden_Tax__c =laborLocMap.get(objDes.NCMT_Crew_Master__c); 
                                                                                                      //system.debug('testcrew=='+objDes.Labor_Burden_Tax__c);
                                                                                                  }else if(objDes.NCMT_Labor_Resources__c !=null){  
                                                                                                      objDes.Labor_Burden_Tax__c = laborLocMap.get(objDes.NCMT_Labor_Resources__c); 
                                                                                                      //system.debug('testlab=='+objDes.Labor_Burden_Tax__c);
                                                                                                  }else{
                                                                                                      objDes.Labor_Burden_Tax__c =0;
                                                                                                      //system.debug('testna==');
                                                                                                  }
                                                                                              }                                            
                
            }
            
        }
        
    }
    
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        //System.debug('Trigger After Insert & Update: ' + trigger.new[0].In_house_Unit_Total__c);
        System.debug('DES ITEM AFTER ' + trigger.new.size());
        Decimal TotalDirectCosts,totcostwsub, totcostwosub,dbltotallaborcost = 0;
        Decimal DirectCosts,totalcost, totalUcost, totalassembliescost,totalDEScount  = 0;
        String strNCMTIDs,strCampIDs, strRecordTypeID, assmkey, DESRecordTypeName,markupmethod ;
        ID DESItemRecordID;
        map<string,decimal> totalcostMap = new map<string,decimal>();
        map<string,decimal> totaldirectcostMap = new map<string,decimal>();
        map<string,decimal> totalcostwosubMap = new map<string,decimal>();
        map<string,decimal> totalassembliescostMap = new map<string,decimal>();
        set<id>  Tree_structureIds = new set<id>(); 
        List<NCMT_DES_Assembly_Details__c> objDESAssmRecords = New List<NCMT_DES_Assembly_Details__c>();
        List<String> newASSMKeysList = new List<String>();
        map<string,Id> DESItemMap = new map<string,Id>();
        map<string,List<Id>> DESItemMap2 = new map<string,List<Id>>();
        map<string,decimal> dbltotallaborcostMap = new map<string,decimal>();
        map<string,decimal> dblMinCostMap = new map<string,decimal>();
        
        for(NCMT_DES_Items__c objDesItem:trigger.new)
        {
            
            
            System.debug(objDesItem);
            PCSIds.add(objDesItem.Project_Cost_Summary_ID__c);
            Tree_structureIds.add(objDesItem.Tree_structure__c);
            DESRecordTypeName = rt_Map.get(objDesItem.recordTypeID).getName();
            
            if(DESRecordTypeName == 'NCMT DES Item Uniformat' || DESRecordTypeName == 'NCMT DES Item Uniformat O&P'){
                DESItemIds.add(objDesItem.id);
                newASSMKeysList.add(objDesItem.Assembly_SKey__c);
                DESItemMap.put(objDesItem.Assembly_SKey__c,objDesItem.ID);
                //Bulkify for copy/paste
                if(DESItemMap2.containsKey(objDesItem.Assembly_SKey__c))
                    DESItemMap2.get(objDesItem.Assembly_SKey__c).add(objDesItem.ID);
                else{
                    List<Id> desId = new List<Id>();
                    desId.add(objDesItem.Id);
                    DESItemMap2.put(objDesItem.Assembly_SKey__c, desId);
                }
                dblMinCostMap.put(objDesItem.MinID__c,objDesItem.Minimum_Cost__c);
                strMinIDs.add(objDesItem.MinID__c);
                projectLocationSet.add(objDesItem.NCMT_Project_Location__c);
                dbltotallaborcostMap.put(objDesItem.MinID__c,objDesItem.Total_Labor_Cost__c);
                //projectId = objDesItem.NCMT_Project_ID__c;
            }
        }    
        System.debug('DESItemMap ' + DESItemMap);
        System.debug('DEsItemMap2 ' + DESItemMap2);
        for(NCMT_Project_Cost_Summary__c ncmtprojcostsummary : [Select id, Project_Name__c From NCMT_Project_Cost_Summary__c where id in :PCSIds]){
            PCSmap.put(ncmtprojcostsummary.Id,ncmtprojcostsummary);
            strNCMTIDs = (ncmtprojcostsummary.Project_Name__c);
            strNCMTIDs = strNCMTIDs.substring(0,strNCMTIDs.length()-3); 
            NCMTIdsset.add(strNCMTIDs);
            //plpProjMap.put(ncmtprojcostsummary.id,ncmtprojcostsummary.Project_Name__c);
        }  
        
        if(trigger.isAfter && trigger.isInsert){
            System.debug('newASSMKeysList.size === '+ newASSMKeysList.size());
            if(newASSMKeysList.size()>0){
                
                list<NCMT_Assembly_Lookup_Item__c> desassmdets = [Select ID, Master_Format_Line_Item_Number__c,MF_Line_Item_Description__c,Material_Unit_Cost__c,
                                                                  Installation_Cost__c,Quantity__c, Assembly_SKey__c,Unit_f__c,Equipment_Unit_Cost__c,Labor_Unit_Cost__c,
                                                                  Crew_Master_Name__c,Labor_Resource_Name__c,Total_Cost_OP__c         
                                                                  From NCMT_Assembly_Lookup_Item__c 
                                                                  where Assembly_SKey__c IN : newASSMKeysList
                                                                  AND Fiscal_Year__c =: CostParameterYear];
                System.debug('desassmdets.size() === ' + desassmdets.size());
                System.debug(DESItemMap);
                for (NCMT_Assembly_Lookup_Item__c objAssmd : desassmdets){
                    crewMasterSet.add(objAssmd.Crew_Master_Name__c);
                    laborResourcesSet.add(objAssmd.Labor_Resource_Name__c);
                }
                //system.debug('crewMasterSet=='+crewMasterSet);
                //system.debug('laborResourcesSet=='+laborResourcesSet);
                List <NCMT_Labor_Location_Markup__c> laborLoclst = [SELECT Id,Name,Labor_Burden_Tax__c,NCMT_Crew_Master__c,
                                                                    NCMT_Labor_Resource__c,Per_State_Territory__c,NCMT_Labor_Resource__r.name,
                                                                    NCMT_Crew_Master__r.name
                                                                    FROM NCMT_Labor_Location_Markup__c 
                                                                    WHERE (NCMT_Crew_Master__r.name IN :crewMasterSet
                                                                           OR NCMT_Labor_Resource__r.name IN :laborResourcesSet)
                                                                    AND Per_State_Territory__c IN :projectLocationSet                                                              
                                                                    AND Fiscal_Year__c = :CostParameterYear] ;
                //system.debug('laborLoclst=='+laborLoclst);
                //system.debug('laborLoclst=='+laborLoclst.size());
                if(laborLoclst.size()>0){       
                    for (NCMT_Labor_Location_Markup__c iter: laborLoclst) {
                        if(iter.NCMT_Crew_Master__c !=null){
                            laborLocMap.put(iter.NCMT_Crew_Master__r.name,iter.Labor_Burden_Tax__c); 
                        }else{
                            laborLocMap.put(iter.NCMT_Labor_Resource__r.name,iter.Labor_Burden_Tax__c);    
                        }
                    }
                }
                for (NCMT_Assembly_Lookup_Item__c obj : desassmdets){
                    if(obj.Crew_Master_Name__c!= null){
                        for(Integer i = 0; i < DESItemMap2.get(obj.Assembly_SKey__c).size(); i++)
                        {
                            String curr = DESItemMap2.get(obj.Assembly_SKey__c)[i];
                            System.debug('curr ==='+ curr + ' obj  === ' + obj);
                            
                            NCMT_DES_Assembly_Details__c det = new NCMT_DES_Assembly_Details__c(
                                Name = obj.Master_Format_Line_Item_Number__c,
                                //NCMT_DES_Item__c=DESItemMap.get(obj.Assembly_SKey__c),
                                Line_Item_Description__c = obj.MF_Line_Item_Description__c,
                                /*Material_Unit_Cost__c = obj.Material_Unit_Cost__c,
                                Labor_Unit_Cost__c = obj.Labor_Unit_Cost__c,
                                Equipment_Unit_Cost__c = obj.Equipment_Unit_Cost__c,*/
                                Quantity__c  = obj.Quantity__c,
                                Unit__c = obj.Unit_f__c,
                                Crew_Master_Name__c = obj.Crew_Master_Name__c,
                                Labor_Resource_Name__c =obj.Labor_Resource_Name__c,
                                Labor_Burden_Tax__c =laborLocMap.get(obj.Crew_Master_Name__c));
                            if(obj.Quantity__c == 0){
                                det.Material_Unit_Cost__c = obj.Material_Unit_Cost__c;
                                det.Labor_Unit_Cost__c = obj.Labor_Unit_Cost__c;
                                det.Equipment_Unit_Cost__c = obj.Equipment_Unit_Cost__c;
                                det.O_P_Per_Quantity__c = obj.Total_Cost_OP__c;
                            }else{
                                det.Material_Unit_Cost__c = obj.Material_Unit_Cost__c/obj.Quantity__c;
                                det.Labor_Unit_Cost__c = obj.Labor_Unit_Cost__c/obj.Quantity__c;
                                det.Equipment_Unit_Cost__c = obj.Equipment_Unit_Cost__c/obj.Quantity__c;
                                det.O_P_Per_Quantity__c = obj.Total_Cost_OP__c/obj.Quantity__c;
                            }
                            det.NCMT_DES_Item__c = curr;
                            objDESAssmRecords.Add(det);
                        }
                    }else if(obj.Labor_Resource_Name__c!=null){
                        
                        for(Integer i = 0; i < DESItemMap2.get(obj.Assembly_SKey__c).size(); i++)
                        {
                            String curr = DESItemMap2.get(obj.Assembly_SKey__c)[i];
                            System.debug('curr ==='+ curr + ' obj  === ' + obj);
                            
                            NCMT_DES_Assembly_Details__c det = new NCMT_DES_Assembly_Details__c(
                                Name = obj.Master_Format_Line_Item_Number__c,
                                //NCMT_DES_Item__c=DESItemMap.get(obj.Assembly_SKey__c),
                                Line_Item_Description__c = obj.MF_Line_Item_Description__c,
                                /*Material_Unit_Cost__c = obj.Material_Unit_Cost__c,
                                Labor_Unit_Cost__c = obj.Labor_Unit_Cost__c,
                                Equipment_Unit_Cost__c = obj.Equipment_Unit_Cost__c,*/
                                Quantity__c  = obj.Quantity__c,
                                Unit__c = obj.Unit_f__c,
                                Crew_Master_Name__c = obj.Crew_Master_Name__c,
                                Labor_Resource_Name__c =obj.Labor_Resource_Name__c,
                                Labor_Burden_Tax__c =laborLocMap.get(obj.Labor_Resource_Name__c));
                            if(obj.Quantity__c == 0){
                                det.Material_Unit_Cost__c = obj.Material_Unit_Cost__c;
                                det.Labor_Unit_Cost__c = obj.Labor_Unit_Cost__c;
                                det.Equipment_Unit_Cost__c = obj.Equipment_Unit_Cost__c;
                                det.O_P_Per_Quantity__c = obj.Total_Cost_OP__c;
                            }else{
                                det.Material_Unit_Cost__c = obj.Material_Unit_Cost__c/obj.Quantity__c;
                                det.Labor_Unit_Cost__c = obj.Labor_Unit_Cost__c/obj.Quantity__c;
                                det.Equipment_Unit_Cost__c = obj.Equipment_Unit_Cost__c/obj.Quantity__c;
                                det.O_P_Per_Quantity__c = obj.Total_Cost_OP__c/obj.Quantity__c;
                            }
                            det.NCMT_DES_Item__c = curr;
                            objDESAssmRecords.Add(det);
                        }
                        
                    }else{
                        for(Integer i = 0; i < DESItemMap2.get(obj.Assembly_SKey__c).size(); i++)
                        {
                            String curr = DESItemMap2.get(obj.Assembly_SKey__c)[i];
                            //System.debug('curr ==='+ curr + ' obj  === ' + obj);
                            
                            NCMT_DES_Assembly_Details__c det = new NCMT_DES_Assembly_Details__c(
                                Name = obj.Master_Format_Line_Item_Number__c,
                                NCMT_DES_Item__c=DESItemMap.get(obj.Assembly_SKey__c),
                                Line_Item_Description__c = obj.MF_Line_Item_Description__c,
                                /*Material_Unit_Cost__c = obj.Material_Unit_Cost__c,
                                Labor_Unit_Cost__c = obj.Labor_Unit_Cost__c,
                                Equipment_Unit_Cost__c = obj.Equipment_Unit_Cost__c,*/
                                Quantity__c  = obj.Quantity__c,
                                Unit__c = obj.Unit_f__c,
                                Crew_Master_Name__c = obj.Crew_Master_Name__c,
                                Labor_Resource_Name__c =obj.Labor_Resource_Name__c,
                                Labor_Burden_Tax__c =0);
                            //SFWS-1472/1555
                            if(obj.Quantity__c == 0){
                                det.Material_Unit_Cost__c = obj.Material_Unit_Cost__c;
                                det.Labor_Unit_Cost__c = obj.Labor_Unit_Cost__c;
                                det.Equipment_Unit_Cost__c = obj.Equipment_Unit_Cost__c;
                                det.O_P_Per_Quantity__c = obj.Total_Cost_OP__c;
                            }else{
                                det.Material_Unit_Cost__c = obj.Material_Unit_Cost__c/obj.Quantity__c;
                                det.Labor_Unit_Cost__c = obj.Labor_Unit_Cost__c/obj.Quantity__c;
                                det.Equipment_Unit_Cost__c = obj.Equipment_Unit_Cost__c/obj.Quantity__c;
                                det.O_P_Per_Quantity__c = obj.Total_Cost_OP__c/obj.Quantity__c;
                            }
                            det.NCMT_DES_Item__c = curr;
                            objDESAssmRecords.Add(det);
                        }
                        
                    }
                    
                }  
                System.debug('DES Assembly Details Insert!');
                System.debug(objDESAssmRecords.size());    
                insert objDESAssmRecords;
            }        
            //for updating minimum cost having same MinID 
            if((!TriggerValue.isMinCost) && (TriggerValue.isClone == false)){                    
                List<NCMT_DES_Items__c> DESItemsList = [Select ID, Name, MinID__c,Minimum_Cost__c,Total_Labor_Cost__c
                                                        From NCMT_DES_Items__c 
                                                        where NCMT_Project_ID__c = :strNCMTIDs
                                                        and ID NOT IN :DESItemIds
                                                        and MinID__c IN :strMinIDs
                                                       ];
                
                if(DESItemsList.size()>0){
                    for(NCMT_DES_Items__c DESList :DESItemsList){
                        DESList.Minimum_Cost__c = dblMinCostMap.get(DESList.MinID__c);
                        DESList.Total_Labor_Cost__c = dbltotallaborcostMap.get(DESList.MinID__c);
                        
                    }
                    update DESItemsList;
                }
                TriggerValue.isMinCost = True;
            }
        }  
        
     
        
        //for updating project markup and calculating primemarkups
        for (AggregateResult ar : [SELECT sum(Total_Cost__c) totcostwsub
                                   FROM NCMT_DES_Items__c
                                   WHERE NCMT_Project_ID__c =:strNCMTIDs 
                                   and NCMT_Contractor_ID__c != null
                                   and Include_In_Estimate__c = true
                                   GROUP BY Project_Cost_Summary_ID__r.Project_Name__c]) {
                                       totcostwsub = (Decimal) ar.get('totcostwsub');
                                   }
        System.debug('W/ subcon: ' + totcostwsub);
        
        for (AggregateResult ar : [SELECT sum(Total_Cost__c) totcostwosub 
                                   FROM NCMT_DES_Items__c
                                   WHERE NCMT_Project_ID__c =:strNCMTIDs 
                                   and NCMT_Contractor_ID__c = null
                                   and Include_In_Estimate__c = true
                                   GROUP BY Project_Cost_Summary_ID__r.Project_Name__c]) {
                                       totcostwosub = (Decimal) ar.get('totcostwosub');
                                   }
        System.debug('W/O subcon: ' + totcostwosub);
        
        NCMT_Project_Markup__c ProjMarkup = [SELECT Total_Cost_w_Subcon_Markups__c,Total_Cost_w_o_SubCon_Markups__c
                                             FROM NCMT_Project_Markup__c 
                                             WHERE Project_Name__c IN :NCMTIdsset];
        
        if(totcostwosub != null){                                                                        
            ProjMarkup.Total_Cost_w_o_SubCon_Markups__c = totcostwosub;  
        }else{
            ProjMarkup.Total_Cost_w_o_SubCon_Markups__c = 0;
        }
        if(totcostwsub != null){                                                                        
            ProjMarkup.Total_Cost_w_Subcon_Markups__c = totcostwsub;  
        }else{
            ProjMarkup.Total_Cost_w_Subcon_Markups__c = 0;
        }                
        
        upsert ProjMarkup;     
        
        //for updating tree structure total cost
        if(Tree_structureIds.size() > 0){
            for (AggregateResult ar : [SELECT count(ID) totcount, sum(Total_Cost__c) totalcost,Tree_structure__c treeStruct, 
                                       sum(Total_Direct_Cost__c) totdirectcost, sum(Total_Cost_w_o_Subcon__c) totcostwosub
                                       FROM NCMT_DES_Items__c
                                       WHERE Tree_structure__c IN : Tree_structureIds
                                       and NCMT_Project_ID__c = :strNCMTIDs
                                       and Include_In_Estimate__c = true
                                       GROUP BY Tree_structure__c,Project_Cost_Summary_ID__r.Project_Name__c]) {
                                           totalcostMap.put(string.valueof(ar.get('treeStruct')),(Decimal) ar.get('totalcost'));
                                           totaldirectcostMap.put(string.valueof(ar.get('treeStruct')),(Decimal) ar.get('totdirectcost'));
                                           totalcostwosubMap.put(string.valueof(ar.get('treeStruct')),(Decimal) ar.get('totcostwosub'));
                                           
                                       }  
            
            for (AggregateResult ar : [SELECT sum(Total_Cost__c) totalcost,Tree_structure__c treeStruct
                                       FROM NCMT_DES_Items__c
                                       WHERE Tree_structure__c IN : Tree_structureIds
                                       and NCMT_Project_ID__c = :strNCMTIDs
                                       and Include_In_Estimate__c = true
                                       and Item_Type__c ='Assemblies'
                                       GROUP BY Tree_structure__c,Project_Cost_Summary_ID__r.Project_Name__c]) {
                                           totalassembliescostMap.put(string.valueof(ar.get('treeStruct')),(Decimal) ar.get('totalcost'));
                                           
                                           //totalassembliescost = integer.valueof(ar.get('totalcost'));
                                       }   
            
            
            list<NCMT_Tree_structure__c> TreeStrucList = [SELECT Total_Cost__c,RecordTypeID,markup_method__c,Total_Cost_w_o_Subcon__c,
                                                          Total_Direct_Cost__c,Project_ID__r.markup_method__c
                                                          FROM NCMT_Tree_structure__c 
                                                          WHERE Project_ID__c = :NCMTIdsset 
                                                          and id In :Tree_structureIds ];
            list<NCMT_Tree_structure__c> treeStructureUpdateList = new list<NCMT_Tree_structure__c>();
            for(NCMT_Tree_structure__c TreeStruc : TreeStrucList){
                
                TreeStruc.Total_Cost__c = totalcostMap.get(TreeStruc.Id);
                TreeStruc.Total_Direct_Cost__c = totaldirectcostMap.get(TreeStruc.Id);
                TreeStruc.Total_Cost_w_o_Subcon__c = totalcostwosubMap.get(TreeStruc.Id);
                
                if(totalassembliescostMap.get(TreeStruc.Id) != null){
                    TreeStruc.Total_Assembly_Cost__c = totalassembliescostMap.get(TreeStruc.Id) ;
                }else{
                    TreeStruc.Total_Assembly_Cost__c = 0;
                }
                
                
                if(TreeStruc.Project_ID__r.markup_method__c =='GSA Markups'){
                    TreeStruc.RecordTypeID = RecordTypeTreeLeaf;
                    TreeStruc.markup_method__c ='GSA Markups';
                }else{
                    TreeStruc.RecordTypeID = RecordTypeTreeLeafOP; 
                    markupmethod = TreeStruc.markup_method__c;
                    if(markupmethod!='User Defined'){
                        TreeStruc.markup_method__c ='RSMeans - O&P';
                    }
                }
                
                treeStructureUpdateList.add(TreeStruc);
            }            
            upsert treeStructureUpdateList;
            
        }
        
        //FOR CLONE
        //System.debug('Trigger** FOR CLONE before if: ' + trigger.new[0].In_house_Unit_Total__c + 'isClone: ' + TriggerValue.isClone);
        if(trigger.isinsert && TriggerValue.isClone){
            System.debug('IS CLONE!');
            Map<Id, String> mfClones = new Map<Id,String>();
            List<NCMT_DES_Items__c> clonesToUpdate = [SELECT Id, Item_Type__c, Line_Item_Number__C, Material_Unit_Cost__c, 
                                                      NCMT_Contractor_Id__r.Name, Markup_Method__c, O_P_Unit_Total__c
                                                      FROM NCMT_DES_Items__c
                                                      WHERE ID IN: trigger.new ];
            Map<Id,String> subconMap = new Map<Id, String>();
            
            for(NCMT_DES_Items__c d : clonesToUpdate)
            {
                subconMap.put(d.Id, d.NCMT_Contractor_ID__r.Name);
                if(d.Item_Type__c == 'Master Format')
                {
                    mfClones.put(d.Id, d.Line_Item_Number__c);
                    System.debug('MASTER FORMAT CLONE! ' + d.Id + ' ' + d.Line_Item_Number__c + ' ' + d.NCMT_Contractor_ID__r.Name);
                }
            }
            List<NCMT_DES_Lookup_details__c> desLookup21 = [SELECT Id, Line_Item_Number__c, Labor_Hours_txt__c, Hourly_Rate_txt__c,
                                                            Equipment_Unit_Cost__c, Material_Unit_Cost__c, Daily_Output__c, 
                                                            Equipment_Unit_O_P_Cost__c, Material_Unit_O_P_Cost__c, NCMT_Crew_Master__c,
                                                            NCMT_Labor__c, Waste_Factor__c, NCMT_Contractor_ID__c, Labor_Unit_O_P_Cost__c,
                                                            Difficulty_Factor_Percent__c, O_P_Unit_Total__c, In_house_Unit_Total__c
                                                            FROM NCMT_DES_Lookup_details__c 
                                                            WHERE Fiscal_Year__c =: CostParameterYear
                                                            AND Line_Item_Number__c IN: mfClones.values()];
            List<NCMT_Contractor__c> subcon21 = [SELECT Id, Name FROM NCMT_Contractor__c 
                                                 WHERE Fiscal_Year__c =: CostParameterYear 
                                                 AND Name IN: subconMap.values()];
            //Update subcon to 2021
            for(NCMT_Contractor__C sub : subcon21)
            {
                for(NCMT_DES_Items__c item : clonesToUpdate)
                {
                    if(subconMap.get(item.Id) == sub.Name)
                    {
                        System.debug('Updating subcon');
                        item.NCMT_Contractor_ID__c = sub.Id;
                    }
                }
            }
            //Labor, Material, Equipment cost updates
            for(NCMT_Des_Lookup_details__c lookup : desLookup21)
            {
                for(NCMT_DES_Items__c item : clonesToUpdate)
                {
                    if(item.Line_Item_Number__c == lookup.Line_Item_Number__c)
                    {
                        //System.debug('MASTER FORMAT ' + item.Line_Item_Number__c + ' ' + item.O_P_Unit_Total__c );
                        item.DES_Lookup_Detail__c = lookup.Id;
                        //System.debug('Trigger** Before 501: ' + trigger.new[0].In_house_Unit_Total__c);
                        item.In_house_Unit_Total__c = lookup.In_house_Unit_Total__c;
                        //System.debug('Trigger** after 501: ' + trigger.new[0].In_house_Unit_Total__c);
                        item.O_P_Unit_Total__c = lookup.O_P_Unit_Total__c;
                        if(TriggerValue.isPaste == false)
                        {
                            item.Material_Unit_Cost__c = lookup.Material_Unit_Cost__c;
                            item.Equipment_Rental_Day__c = lookup.Equipment_Unit_Cost__c;
                            item.Hourly_Rate__c = lookup.Hourly_Rate_txt__c;
                        }
                        item.Labor_Unit_Hours__c = lookup.Labor_Hours_txt__c;
                        //item.Hourly_Rate__c = lookup.Hourly_Rate_txt__c;
                        item.Comments__c = 'cloned';
                        
                    }
                }
            }
            update clonesToUpdate;
        }
        
        
    }
    if(trigger.isAfter && trigger.isDelete){
        
        //System.debug('DES Item Trigger After Delete ' + trigger.old.size());
        id Tree_structureId,DESItemId;
        Set<Id> relatedTrees = new Set<Id>();
        string strNCMTIDs;
        decimal totalcount, totalassembliescost, totaldcost,totallabcost,dbllaborcost= 0;
        // block-1 Added for SFWS-2046 DES LineItem Deletion
        Set<String> setDeletedDesItemsIds = new Set<String>();
        map<string,decimal> dbltotallaborcostMap1 = new map<string,decimal>();
        map<string,decimal> dblMinCostMap1 = new map<string,decimal>();
        //block-1 ends here
        
        for(NCMT_DES_Items__c objDesItem:trigger.old){
            PCSIds.add(objDesItem.Project_Cost_Summary_ID__c);
            setDeletedDesItemsIds.add(objDesItem.id);    ///DESItemId =objDesItem.id;
            relatedTrees.add(objDesItem.Tree_Structure__c);
            Tree_structureId  = objDesItem.Tree_structure__c;
            dblMinCost = objDesItem.Minimum_Cost__c;
            strMinIDs.add(objDesItem.MinID__c);
            dbllaborcost = objDesItem.Labor_Cost__c;
            dblMinCostMap1.put(objDesItem.MinID__c,objDesItem.Minimum_Cost__c);
            dbltotallaborcostMap1.put(objDesItem.MinID__c,objDesItem.Total_Labor_Cost__c);

        }
        System.debug(relatedTrees);
        decimal totalCost, totalUcost, totalacost,totcostwosub,totcostwsub,totcostwosub1= 0.00;
        for(NCMT_Project_Cost_Summary__c ncmtprojcostsummary : [Select id, Project_Name__c From NCMT_Project_Cost_Summary__c where id in :PCSIds]){
            PCSmap.put(ncmtprojcostsummary.Id,ncmtprojcostsummary);
            strNCMTIDs = (ncmtprojcostsummary.Project_Name__c);
            strNCMTIDs = strNCMTIDs.substring(0,strNCMTIDs.length()-3); 
            NCMTIdsset.add(strNCMTIDs);
        }  
    //block-2 Added for SFWS-2046 DES LineItem Deletion, ProjectMarkup is updated first and later Tree Structure
        if(dblMinCost>0){            
            for (AggregateResult ar : [SELECT count(MinID__c) minidcount,sum(Total_Labor_Cost__c) totlabcost
                                       FROM NCMT_DES_Items__c
                                       WHERE NCMT_Project_ID__c = :strNCMTIDs
                                       and MinID__c IN :strMinIDs
                                       and Include_In_Estimate__c = true
                                       GROUP BY Project_Cost_Summary_ID__r.Project_Name__c]) {
                                           totalcount = (Decimal) ar.get('minidcount');
                                           totallabcost =(Decimal) ar.get('totlabcost');                       
                                       }  
            
            List<NCMT_DES_Items__c> DESItemsList = [Select ID, Name, MinID__c,Minimum_Cost__c,Original_Minimum_Cost__c,
                                                    Total_Labor_Cost__c,Labor_Cost__c
                                                    From NCMT_DES_Items__c 
                                                    where NCMT_Project_ID__c = :strNCMTIDs
                                                    and ID  NOT IN : setDeletedDesItemsIds   /*!= :DESItemId*/
                                                    and MinID__c IN :strMinIDs
                                                    and Original_Minimum_Cost__c > 0
                                                   ];
            if(DESItemsList.size()>0){
                for(NCMT_DES_Items__c DESList :DESItemsList){
                    DESList.Minimum_Cost__c = DESList.Original_Minimum_Cost__c/totalcount;
                    DESList.Total_Labor_Cost__c=DESList.Total_Labor_Cost__c - dbllaborcost;
                }
                update DESItemsList;
            }
        }
        //for updating project markup and calculating primemarkups
        for (AggregateResult ar : [SELECT sum(Total_Cost__c) totcostwsub
                                   FROM NCMT_DES_Items__c
                                   WHERE NCMT_Project_ID__c =:strNCMTIDs 
                                   and NCMT_Contractor_ID__c != null
                                   and Include_In_Estimate__c = true
                                   GROUP BY Project_Cost_Summary_ID__r.Project_Name__c]) {
                                       totcostwsub = (Decimal) ar.get('totcostwsub');
                                   }  
        System.debug('totcostwsub === ' + totcostwsub);
        for (AggregateResult ar : [SELECT sum(Total_Cost__c) totcostwosub 
                                   FROM NCMT_DES_Items__c
                                   WHERE NCMT_Project_ID__c =:strNCMTIDs 
                                   and NCMT_Contractor_ID__c = null
                                   and Include_In_Estimate__c = true
                                   GROUP BY Project_Cost_Summary_ID__r.Project_Name__c]) {
                                       totcostwosub = (Decimal) ar.get('totcostwosub');
                                   }                  
        System.debug('totcostwosub === ' + totcostwosub);                                        
        NCMT_Project_Markup__c ProjMarkup = [SELECT  id,ECC__c,ECCA__c,Total_Cost_w_Subcon_Markups__c,Total_Cost_w_o_SubCon_Markups__c
                                             FROM NCMT_Project_Markup__c 
                                             WHERE Project_Name__c = :NCMTIdsset ];
         System.debug('<=====MMM ' + ProjMarkup);
        if(totcostwosub > 0){                                                                        
            ProjMarkup.Total_Cost_w_o_SubCon_Markups__c = totcostwosub;  
        }else{
            ProjMarkup.Total_Cost_w_o_SubCon_Markups__c = 0;
        }
        if(totcostwsub > 0){                                                                        
            ProjMarkup.Total_Cost_w_Subcon_Markups__c = totcostwsub;  
        }else{
            ProjMarkup.Total_Cost_w_Subcon_Markups__c = 0;
        }                
          
        update ProjMarkup;
            
        if(Tree_structureId != null && relatedTrees.size() == 1){ 
            for (AggregateResult ar : [SELECT sum(Total_Cost__c) totalcost, sum(Total_Direct_Cost__c) totaldcost,
                                       Count(id) totcount,sum(Total_Cost_w_o_Subcon__c) totcostwosub1
                                       FROM NCMT_DES_Items__c
                                       WHERE Tree_structure__c = :Tree_structureId
                                       //WHERE Tree_Structure__C IN: relatedTrees
                                       and NCMT_Project_ID__c = :strNCMTIDs
                                       and Include_In_Estimate__c = true
                                       GROUP BY Project_Cost_Summary_ID__r.Project_Name__c]) {
                                           totalcost = (Decimal) ar.get('totalcost');
                                           totalcount = (Decimal) ar.get('totcount');
                                           totaldcost = (Decimal) ar.get('totaldcost');
                                           totcostwosub1 = (Decimal) ar.get('totcostwosub1');     
                                           System.debug('totalcost === ' + totalcost);
                                       }  
            
            for (AggregateResult ar : [SELECT sum(Total_Cost__c) totalacost
                                       FROM NCMT_DES_Items__c
                                       WHERE Tree_structure__c = :Tree_structureId
                                       and NCMT_Project_ID__c = :strNCMTIDs
                                       and Include_In_Estimate__c = true
                                       and item_type__c = 'Assemblies'
                                       GROUP BY Project_Cost_Summary_ID__r.Project_Name__c]) {
                                           totalassembliescost = (Decimal) ar.get('totalacost');
                                       } 
            
            NCMT_Tree_structure__c TreeStruc = [SELECT  id,ECC__c,ECCA__c,Total_Cost__c,Total_Direct_Cost__c ,Total_Cost_w_o_Subcon__c,
                                                RecordTypeID
                                                FROM NCMT_Tree_structure__c 
                                                WHERE Project_ID__c = :NCMTIdsset
                                                and id =:Tree_structureId ];
           
            if(totalcost > 0 && totaldcost > 0){
                
                TreeStruc.Total_Cost__c = totalcost;
                TreeStruc.Total_Direct_Cost__c = totaldcost;
                TreeStruc.Total_Cost_w_o_Subcon__c = totcostwosub1;
            }else{
                TreeStruc.Total_Cost__c = 0;
                TreeStruc.Total_Direct_Cost__c =0;
                TreeStruc.Total_Cost_w_o_Subcon__c =0;
            }
            
            
            
            if(totalassembliescost > 0){
                TreeStruc.Total_Assembly_Cost__c = totalassembliescost ;
            }else{
                TreeStruc.Total_Assembly_Cost__c = 0;
            }
            
            if(totalcount == null || totalcount == 0){
                TreeStruc.RecordTypeID = RecordTypeTreeDefault;
            }
           
            update TreeStruc;
           
             
        }
       else if (relatedTrees.size() > 1) //If deleting multiple trees
        {
            System.debug('Deleting multiple trees!');
            List<Id> parentIds = new List<Id>();
            List<NCMT_Tree_Structure__c> trees = [SELECT id,ECC__c,ECCA__c, Branch_Name__c,Total_Cost__c,Total_Direct_Cost__c ,
                                                  Total_Cost_w_o_Subcon__c,RecordTypeID, Relatedtree__c
                                                  FROM NCMT_Tree_structure__c 
                                                  WHERE Project_ID__c = :NCMTIdsset
                                                  and id IN: relatedTrees];
            
            //Get Ids for parents of trees being deleted
            for(NCMT_Tree_Structure__c t : trees)
            {
                System.debug(t);
                t.Total_Cost__c = 0;
                t.Total_Direct_Cost__c =0;
                t.Total_Cost_w_o_Subcon__c =0;
                if(!relatedTrees.contains(t.Relatedtree__c))
                    parentIds.add(t.Relatedtree__c);
            }
            
            List<NCMT_Tree_Structure__c> parentsToUpdate = [SELECT id,ECC__c,ECCA__c, Branch_Name__c,Total_Cost__c,Total_Direct_Cost__c ,
                                                            Total_Cost_w_o_Subcon__c,RecordTypeID, Relatedtree__c 
                                                            FROM NCMT_Tree_Structure__c WHERE Id IN: parentIds];
            trees.addAll(parentsToUpdate);
            
            update trees;
        }
       
    }
}