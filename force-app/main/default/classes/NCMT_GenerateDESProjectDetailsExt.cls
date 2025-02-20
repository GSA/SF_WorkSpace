public with sharing class NCMT_GenerateDESProjectDetailsExt {
    
    public Decimal GenerateDESMarkups(ID ProjectID, String strProjectType, string strProjectDeliveryMethod, string strMarkupMethod){
        
        System.debug('GENERATE DES MARKUPS');
        Decimal salesTax = 0;
        NCMT_Project__c proj = [SELECT Id, Project_Record_Id__c, Markup_Method__c, Design_and_Site_Contingency__c, 
                                			Construction_Contingency__c, Art_In_Architecture__c,sales_tax__c FROM NCMT_Project__c WHERE Id =: ProjectId];
        System.debug('Proj: ' + proj);
        NCMT_Project__c orig = new NCMT_Project__c();
        
        if(proj.Project_Record_Id__c != null)
        {
            orig = [SELECT Id, Project_Record_Id__c, Markup_Method__c, Sales_Tax__c FROM NCMT_Project__c WHERE Id =: proj.Project_Record_Id__c];
        	System.debug('Orig: ' + orig);
        }
            
        //If project is a clone and the markup method has not been changed, clone NCMT Project Markup record 
        if(orig.Project_Record_Id__c != null &&
           orig.Project_Record_Id__c == proj.Project_Record_Id__c &&
           orig.Markup_Method__C == proj.Markup_Method__c)
        {
            System.debug('CLONE!');
			List<NCMT_Project_Markup__c> markups = [SELECT Id FROM NCMT_Project_Markup__c WHERE Project_Name__c =: orig.Id];
            System.debug(markups);
            
            List<NCMT_Project_Markup__c> markupsToInsert = new List<NCMT_Project_Markup__c>();
            
            for(NCMT_Project_Markup__c m : markups)
            {
				NCMT_Project_Markup__c mark = (NCMT_Project_Markup__c)NCMT_Utilities.cloneMe('NCMT_Project_Markup__c', m.Id, new Set<String>(), false);
                System.debug('CLONED: ' + mark.Sales_Tax__c);
                mark.Id = null;
                mark.Project_Name__c = proj.Id;
                salesTax = mark.Sales_Tax__c;
                markupsToInsert.add(mark);
            }
            System.debug('TriggerValue.isClone === ' + TriggerValue.isClone);
            TriggerValue.isClone = true;
            insert markupsToInsert;
            return salesTax;
        }
        else 
        {
            List<NCMT_Project_Markup__c> objProjectMarkupRecords = New List<NCMT_Project_Markup__c>();
            string strRecordTypeID = Schema.SObjectType.NCMT_Project_Markup__c.getRecordTypeInfosByName().get('DES O&P Project Markup').getRecordTypeId();
            
            if(strProjectType == 'New Construction - DES' || strProjectType == 'Repair & Alteration - DES'){
                
                if(strProjectDeliveryMethod =='Design Build - Bridging' || strProjectDeliveryMethod =='Design Build - Owned'){
                    objProjectMarkupRecords.Add(new NCMT_Project_Markup__c(
                        Project_Name__c = ProjectID,
                        Professional_Services_Fees_OSWork__c = 5,
                        Professional_Services_Fees_SelfWork__c = 5,
                        Developer_Fee__c = 5,
                        Design_and_Site_Contingency__c = proj.Design_and_Site_Contingency__c,
                        Construction_Contingency_new__c = proj.Construction_Contingency__c,
                        Art_In_Architecture_new__c = proj.Art_In_Architecture__c,
                        Sales_Tax__c = proj.Sales_Tax__c
                    ));
                }else if(strProjectDeliveryMethod =='Build to Suit Lease'){
                    objProjectMarkupRecords.Add(new NCMT_Project_Markup__c(
                        Project_Name__c = ProjectID,
                        Developer_Fee__c = 5,
                        Professional_Services_Developer_Fee__c = 5,
                        Design_and_Site_Contingency__c = proj.Design_and_Site_Contingency__c,
                        Construction_Contingency_new__c = proj.Construction_Contingency__c,
                        Art_In_Architecture_new__c = proj.Art_In_Architecture__c,
                        Sales_Tax__c = proj.Sales_Tax__c
                    ));           
                }else if(strProjectDeliveryMethod =='TI - Leasing'){
                    objProjectMarkupRecords.Add(new NCMT_Project_Markup__c(
                        Project_Name__c = ProjectID,
                        Lessor_Fee__c= 5,
                        Professional_Services_Lessor_Fee__c = 5,
                        Design_and_Site_Contingency__c = proj.Design_and_Site_Contingency__c,
                        Construction_Contingency_new__c = proj.Construction_Contingency__c,
                        Art_In_Architecture_new__c = proj.Art_In_Architecture__c,
                        Sales_Tax__c = proj.Sales_Tax__c
                    )); 
                }else if(strProjectDeliveryMethod =='CMc'){
                    objProjectMarkupRecords.Add(new NCMT_Project_Markup__c(
                        Project_Name__c = ProjectID,
                        CMc__c= 3,
                        Professional_Services_Fees_Preconst__c = 0.5,
                        Design_and_Site_Contingency__c = proj.Design_and_Site_Contingency__c,
                        Construction_Contingency_new__c = proj.Construction_Contingency__c,
                        Art_In_Architecture_new__c = proj.Art_In_Architecture__c,
                        Sales_Tax__c = proj.Sales_Tax__c
                    )); 
                }else{
                    IF(strProjectDeliveryMethod =='IDIQ-JOC' && strMarkupMethod=='RSMeans - O&P'){
                        objProjectMarkupRecords.Add(new NCMT_Project_Markup__c(
                        Project_Name__c = ProjectID,
                        RecordTypeID = strRecordTypeID,
                        Design_and_Site_Contingency__c = proj.Design_and_Site_Contingency__c,
                        Construction_Contingency_new__c = proj.Construction_Contingency__c,
                        Art_In_Architecture_new__c = proj.Art_In_Architecture__c,
                        Sales_Tax__c = proj.Sales_Tax__c    
                    )); 
                    }else{
                        objProjectMarkupRecords.Add(new NCMT_Project_Markup__c(
                        Project_Name__c = ProjectID,
                        Design_and_Site_Contingency__c = proj.Design_and_Site_Contingency__c,
                        Construction_Contingency_new__c = proj.Construction_Contingency__c,
                        Art_In_Architecture_new__c = proj.Art_In_Architecture__c,
                        Sales_Tax__c = proj.Sales_Tax__c    
                    )); 
                    }
                    
                }
                
            }       
            
            insert objProjectMarkupRecords;
            return proj.Sales_Tax__c;
        }
    }
    
    public void UpdateDESItemsTax(ID ProjectID, String strProjectType, string strProjectRecordID,string strProjectDeliveryMethod,decimal dblsalestax,decimal dbllocationmultiplier,string strMarkupMethod, string strstate){
           
        strProjectRecordID = strProjectRecordID.substring(0,strProjectRecordID.length()-3);
        string  strRTypeDESMOP = Schema.SObjectType.NCMT_DES_Items__c.getRecordTypeInfosByName().get('NCMT DES Item Master O&P').getRecordTypeId();
        string  strRTypeDESUOP = Schema.SObjectType.NCMT_DES_Items__c.getRecordTypeInfosByName().get('NCMT DES Item Uniformat O&P').getRecordTypeId();        
        
        List<NCMT_DES_Items__c> DESItemsList = [Select ID, Name, Item_Type__c,RecordTypeID ,
                                                Sales_Tax__c, Labor_Burden_Tax__c, 
                                                Location_Multiplier_Washington_DC_1_00__c,NCMT_Project_Location__c
                                                From NCMT_DES_Items__c 
                                                where NCMT_Project_ID__c = :strProjectRecordID
                                               ];
        
        for (NCMT_DES_Items__c DESList : DESItemsList){
            
            DESList.Location_Multiplier_Washington_DC_1_00__c = dbllocationmultiplier;
            DESList.Sales_Tax__c =dblsalestax;
            DESList.NCMT_Project_Location__c=strstate;
            //DESList.Labor_Burden_Tax__c = dbllaborburdentax;
            IF(strMarkupMethod == 'RSMeans - O&P' && DESList.Item_Type__c =='Master Format'){
                DESList.RecordTypeID = strRTypeDESMOP;
                DESList.Sales_Tax__c =0;
                DESList.Labor_Burden_Tax__c = 0;
                DESList.Markup_Method__c ='RSMeans - O&P';
            }else if(strMarkupMethod == 'RSMeans - O&P' && DESList.Item_Type__c =='Assemblies'){
                DESList.RecordTypeID = strRTypeDESUOP;
                DESList.Sales_Tax__c =0;
                DESList.Labor_Burden_Tax__c = 0;
                DESList.Markup_Method__c ='RSMeans - O&P';
            }
        }
        
        update DESItemsList;
        
    } 
    
    public void UpdateDESTreeStruc(ID ProjectID, String strProjectType, string strProjectRecordID,string strMarkupMethod){
        
        //strProjectRecordID = strProjectRecordID.substring(0,strProjectRecordID.length()-3);
        string  RecordTypeTreeLeaf = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Tree Leaf').getRecordTypeId();
        string  RecordTypeTreeLeafOP = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Tree Leaf O&P').getRecordTypeId();
                
        List<NCMT_Tree_structure__c> TreeStrucList = [Select ID, Name,RecordTypeID 
                                                      From NCMT_Tree_structure__c 
                                                      where Project_ID__c = :ProjectID
                                                       ];
        
        for (NCMT_Tree_structure__c TreeList : TreeStrucList){
            
            IF(strMarkupMethod == 'RSMeans - O&P' && TreeList.RecordTypeID ==RecordTypeTreeLeaf){
                TreeList.RecordTypeID = RecordTypeTreeLeafOP;
                TreeList.markup_method__c = 'RSMeans - O&P';
            }
        }
        
        update TreeStrucList;
        
    }
    
    public void UpdateDESMarkups(ID ProjectID, String strProjectType, String strProjectDeliveryMethod,string strMarkupMethod){
        string  strRecordTypeDESPMOP = Schema.SObjectType.NCMT_Project_Markup__c.getRecordTypeInfosByName().get('DES O&P Project Markup').getRecordTypeId();
        string  strRecordTypeGSAM = Schema.SObjectType.NCMT_Project_Markup__c.getRecordTypeInfosByName().get('DES Project Markup').getRecordTypeId();
        
        List<NCMT_Project_Markup__c> DESMarkupList = [Select ID, Name, CMc__c,Professional_Services_Fees_Preconst__c,Lessor_Fee__c, Developer_Fee__c, Professional_Services_Developer_Fee__c,
                                                      Professional_Services_Lessor_Fee__c, Professional_Services_Fees_SelfWork__c,
                                                      Professional_Services_Fees_OSWork__c,Prime_Con_OSWork_Commission__c,Prime_Con_SelfWork_Commission__c
                                                      From NCMT_Project_Markup__c 
                                                      where Project_Name__c = :ProjectID
                                                     ];
        
        for (NCMT_Project_Markup__c MarkupList : DESMarkupList){
            if(strProjectDeliveryMethod !='Design Build - Bridging' && strProjectDeliveryMethod !='Design Build - Owned'){
                MarkupList.Professional_Services_Fees_OSWork__c = 0;
                MarkupList.Professional_Services_Fees_SelfWork__c = 0;
                if(strProjectDeliveryMethod !='Build to Suit Lease'){
                    MarkupList.Developer_Fee__c = 0;
                }
            }else {
                MarkupList.Professional_Services_Fees_OSWork__c = 5;
                MarkupList.Professional_Services_Fees_SelfWork__c = 5;
                MarkupList.Developer_Fee__c = 5;
            }
            
            if(strProjectDeliveryMethod !='Build to Suit Lease'){
                //MarkupList.Developer_Fee__c = 0;
                MarkupList.Professional_Services_Developer_Fee__c = 0;                
            }else {
                MarkupList.Developer_Fee__c = 5;
                MarkupList.Professional_Services_Developer_Fee__c = 5; 
            }
            
            if(strProjectDeliveryMethod !='TI - Leasing'){
                MarkupList.Lessor_Fee__c= 0;
                MarkupList.Professional_Services_Lessor_Fee__c = 0;
            }else{
                MarkupList.Lessor_Fee__c= 5;
                MarkupList.Professional_Services_Lessor_Fee__c = 5;
            }
            
            if(strProjectDeliveryMethod =='CMc'){
                MarkupList.CMc__c= 3;
                Markuplist.Professional_Services_Fees_Preconst__c=0.5;
            }else{
                MarkupList.CMc__c= 0;
                Markuplist.Professional_Services_Fees_Preconst__c=0;
            }
            
            if(strMarkupMethod == 'RSMeans - O&P'){
                MarkupList.RecordTypeID = strRecordTypeDESPMOP;
            }
            
        }
        
        update DESMarkupList;
    }
    
     public void GenerateDESTreeStr(ID ProjectID, String strProjectType, string projectName, string strProjectRecordID, decimal dblSalestax,decimal dbllocationmultiplier,string strMarkupMethod,string strstate){
        map<string,string> masterRecordMap  = new map<string,string>();
        string  RecordTypeTreeDefault = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        string  strRTypeDESMOP = Schema.SObjectType.NCMT_DES_Items__c.getRecordTypeInfosByName().get('NCMT DES Item Master O&P').getRecordTypeId();
        string  strRTypeDESUOP = Schema.SObjectType.NCMT_DES_Items__c.getRecordTypeInfosByName().get('NCMT DES Item Uniformat O&P').getRecordTypeId();
        string  RecordTypeTreeBranch = Schema.SObjectType.NCMT_Tree_structure__c.getRecordTypeInfosByName().get('Tree Branch').getRecordTypeId();
        map<string,decimal> totalcostMap = new map<string,decimal>();
        map<string,decimal> totaldirectcostMap = new map<string,decimal>();
        map<string,decimal> totalcostwosubMap = new map<string,decimal>();
        list<NCMT_Tree_structure__c>  NCMTList = new List<NCMT_Tree_structure__c>();    
         
         System.debug('GenerateDESTreeStruc ' + dblSalesTax);
         
        List<NCMT_Tree_structure__c> objTreeStrucRecords = New List<NCMT_Tree_structure__c>();
        NCMT_Project__c proj = new NCMT_Project__c(id=ProjectID,Project_Record_ID__c=ProjectID,Sales_Tax__c=dblSalestax, Location_Multiplier__c=dbllocationmultiplier);
        System.debug(proj);
        update proj;
        if(strProjectRecordID == NULL || strProjectRecordID == ''){             
            objTreeStrucRecords.Add(new NCMT_Tree_structure__c(
                Branch_Name__c = projectName,
                Project_ID__c = ProjectID,
                description__c = projectName,
                Level__c = 0,
                Order__c = 1,
                SortOrdertxt__c = '01',
                RecordTypeID = RecordTypeTreeDefault 
            ));
            
            insert objTreeStrucRecords;
            
        }else{
            system.debug('testing==');
            TriggerValue.isClone = true;
            
            List<NCMT_Tree_structure__c> TreeStrucList = [Select ID, Name, Branch_Name__c, description__c,Display_Name__c,Estimate_Format__c,
                                                          Include_In_Estimate__c,Level__c,Items__c,Project_ID__c,Order__c,Relatedtree__c,
                                                          Parent_Node_Desc__c,Quantity__c,SortOrdertxt__c,Parent_Name__c,Total_Including_Markups__c,
                                                          Relatedtree__r.SortOrdertxt__c,
                                                          Markup_Method__c,ECC__c,ECCA__c,ETPC__c,Markup__c,Total_OS_Work__c,Total_Self_Work__c,UOM__c,
                                                          Unit_Cost__c, RecordTypeID
                                                          From NCMT_Tree_structure__c 
                                                          Where Project_ID__c = :strProjectRecordID
                                                         ];
            NCMT_Project_Markup__c projMarkup = [SELECT Id from NCMT_Project_Markup__c WHERE Project_Name__c = :ProjectID]; 
                                                        
            for(NCMT_Tree_structure__c obj : TreeStrucList)
                masterRecordMap.put(obj.SortOrdertxt__c,obj.Relatedtree__r.SortOrdertxt__c);          
            list<NCMT_Tree_structure__c> treeClones = TreeStrucList.deepClone();
            
            for(NCMT_Tree_structure__c obj : treeClones){
                
                IF(strMarkupMethod == 'RSMeans - O&P'){
                    if(obj.markup_method__c !='User Defined'){
                        obj.markup_method__c = 'RSMeans - O&P';
                    }
                }
                obj.Markup__c = projMarkup.Id;
                obj.Project_ID__c = ProjectID;
                obj.Relatedtree__c = Null;
            }
            insert treeClones;
            
            //get related__c trees from orginal tree structures and find cloned versions with matching name, relate these to other tree structues based on original layout.  
            map<string, id> cloneNodeMap = new map<string, id>();
            for (NCMT_Tree_structure__c clone : treeClones){
                cloneNodeMap.put(clone.SortOrdertxt__c, clone.id);   
            }
            
            for(NCMT_Tree_structure__c tree2 : treeClones){
                if(tree2.Level__c != 0){
                    string nodeId= cloneNodeMap.get(masterRecordMap.get(tree2.SortOrdertxt__c));
                    tree2.Relatedtree__c = nodeId;
                }
            } 
            
            List<Database.SaveResult> updateResults = Database.update(treeClones, false);
            
            //for DES Items            
            list<NCMT_Project_Cost_Summary__c> pcs = [select id, Cost_Category_Code__c, Cost_Category_Description__c  from NCMT_Project_Cost_Summary__c where Project_Name__c= :ProjectID];
            
            strProjectRecordID = strProjectRecordID.substring(0,strProjectRecordID.length()-3);
            List<NCMT_DES_Items__c> DESItemsList = [Select ID, Name, RecordType.Name,Adj_Labor_Hours__c,Adj_Labor_Unit_Cost__c,Equipment_Assembly_Cost__c,Labor_Assembly_Cost__c,
                                                    Material_Assembly_Cost__c,Assembly_SKey__c,Comments__c,Cost_Summary__c,Cost_Type__c,CSI_Line_Item_Number__c,Daily_Output__c,
                                                    Default_Hourly_Rate__c,Default_Material_Unit_Cost__c,Description__c,DES_Lookup_Detail__c,Difficulty_Factor_Percent__c,
                                                    Direct_Cost__c,Equipment_Rental_Day__c,Hierarchy__c,Include_In_Estimate__c,Installation_Assembly_Cost__c,Item_Type__c,Labor_Burden_Tax__c,
                                                    Labor_Hours__c,Hourly_Rate__c,Level_2__c,Level_2_Description__c,Level_3__c,Level_3_Description__c,Level_4__c,Level_4_Description__c,Level_5__c,
                                                    Level_5_Description__c,Location_Multiplier_Washington_DC_1_00__c,Material_Adj__c,Material_Unit_Cost__c,NCMT_Assembly_Master__c,
                                                    NCMT_Crew_Master__c,NCMT_Project_ID__c,NCMT_Project_Name__c,NCMT_Contractor_ID__c,Project_Cost_Summary_ID__c,Project_Phasing__c,Quantity__c,
                                                    Sales_Tax__c,SubContractor_Bond__c,SubContractor_Overhead__c,SubContractor_Profit__c,Sub_Total__c,Tag__c,Total_Assembly_Cost__c,Total_Cost__c,
                                                    Total_Direct_Cost__c,Total_Equipment_Cost1__c,Total_Equip_Cost_Adj__c,Total_Equipment_Cost_w_Sales_Tax__c,Total_Labor_Cost_Adj__c,Total_Labor_Cost_w_Labor_Burden_Tax__c,
                                                    Total_Labor_Cost1__c,Total_Material_Cost_Adj__c,Total_Material_Cost_w_Sales_Tax__c,Total_Material_Cost1__c,Tree_structure__c,Unit__c,Waste_Factor__c,
                                                    Tree_structure__r.SortOrdertxt__c,Total_Cost_w_o_Subcon__c,In_house_Unit_Total__c,In_house_Unit_Total_f__c,In_house_Unit_Total_Adj__c,O_P_Unit_Total__c,O_P_Unit_Total_Adj__c,
                                                    Markup_Method__c,NCMT_Project_Location__c,Minimum_Cost__c,Total_In_House_Total_Adj_f__c,Labor_Burden_Impact_Rollup__c,Labor_Burden_Tax_f__c,MinID__c,Line_Item_Number__c,
                                                    Original_Minimum_Cost__c,Total_Labor_Cost__c,Labor_Cost__c
                                                    From NCMT_DES_Items__c 
                                                    where NCMT_Project_ID__c = :strProjectRecordID
                                                    //Limit 25
                                                   ];
            
            list<ncmt_des_items__c> desItems = DESItemsList.deepClone();            
            
            for(ncmt_des_items__c item : desItems){
                item.Location_Multiplier_Washington_DC_1_00__c = dbllocationmultiplier;
                item.Sales_Tax__c = dblSalestax;  
                item.NCMT_Project_Location__c=strstate ;
                
                IF(strMarkupMethod == 'RSMeans - O&P' && item.Item_Type__c =='Master Format'){
                    item.RecordTypeID = strRTypeDESMOP;
                    if(item.markup_method__c !='User Defined'){
                        item.markup_method__c = 'RSMeans - O&P';
                    }
                }else if(strMarkupMethod == 'RSMeans - O&P' && item.Item_Type__c =='Assemblies'){
                    item.RecordTypeID = strRTypeDESUOP;
                    if(item.markup_method__c !='User Defined'){
                        item.markup_method__c = 'RSMeans - O&P';
                    }
                }
                
                for(NCMT_Project_Cost_Summary__c pc :pcs ){
                    if (item.Cost_Summary__c == pc.Cost_Category_Description__c){
                        item.Project_Cost_Summary_ID__c = pc.id;
                    } 
                    if(item.Tree_structure__c != null){
                        id treeId = cloneNodeMap.get(item.Tree_structure__r.SortOrdertxt__c);
                        item.Tree_structure__c = treeId;
                    } 
                }
            }
            List<Database.SaveResult> insertResults = Database.insert(desItems, false);  
            
            //for updating parent tree cost
            list<NCMT_Tree_structure__c> TreeStrucParentList = [SELECT Id,Relatedtree__c,RecordTypeID, 
                                                                       order__c, level__c,SortOrdertxt__c,Total_Cost_w_o_Subcon__c,
                                                                       Total_Direct_Cost__c,Total_Cost__c
                                                                  FROM NCMT_Tree_structure__c 
                                                                 WHERE Project_ID__c = :ProjectID
                                                                  order by RecordTypeID desc, level__c desc];
            
            for(NCMT_Tree_structure__c Treelist:TreeStrucParentList){
                totalcostMap.put(Treelist.Id,Treelist.Total_Cost__c); 
                totaldirectcostMap.put(Treelist.Id,Treelist.Total_Direct_Cost__c);  
                totalcostwosubMap.put(Treelist.Id,Treelist.Total_Cost_w_o_Subcon__c); 
            }
            for(NCMT_Tree_structure__c Treelist:TreeStrucParentList){
                if (totalcostMap.get(Treelist.Relatedtree__c) !=null){
                    totalcostMap.put(Treelist.Relatedtree__c,totalcostMap.get(Treelist.Relatedtree__c) + totalcostMap.get(Treelist.Id));
                    totaldirectcostMap.put(Treelist.Relatedtree__c,totaldirectcostMap.get(Treelist.Relatedtree__c) + totaldirectcostMap.get(Treelist.Id));
                    totalcostwosubMap.put(Treelist.Relatedtree__c,totalcostwosubMap.get(Treelist.Relatedtree__c) + totalcostwosubMap.get(Treelist.Id));
                 }
                        
            }
            for( NCMT_Tree_structure__c TreeStrucParent : TreeStrucParentList){
                        TreeStrucParent.Total_Cost__c = totalcostMap.get(TreeStrucParent.Id);
                        TreeStrucParent.Total_Direct_Cost__c = totaldirectcostMap.get(TreeStrucParent.Id);
                       TreeStrucParent.Total_Cost_w_o_Subcon__c = totalcostwosubMap.get(TreeStrucParent.Id);
                    
                NCMTList.add(TreeStrucParent);
            }
                                
               Update NCMTList;  
            
            TriggerValue.isClone = false;
        }
        
    }  
    
}