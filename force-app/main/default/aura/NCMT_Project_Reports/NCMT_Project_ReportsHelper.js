({
    sanitizeParams : function(cmp){
        return new Promise($A.getCallback(function(resolve, reject){ 
         let sanitize = cmp.get('c.sanitizeParams'); 
         sanitize.setParams({ 
            "reportType": cmp.get('v.reportType'),
            "categoriesReport": cmp.get('v.categoriesReport')
         }); 
         sanitize.setCallback(this, function(res){ 
          resolve(res.getReturnValue()); 
         }); 
         $A.enqueueAction(sanitize); 
        }));
    },
    fetchData : function(cmp) {
        var projectId = cmp.get('v.recordId');
        
        return new Promise($A.getCallback(function(resolve, reject){
            let init = cmp.get('c.init');
            init.setParams({
                'recordId' :cmp.get('v.recordId')
            });
            init.setCallback(this, function(res){
                resolve(res.getReturnValue());
            });
            $A.enqueueAction(init);
            
        }));
        
    },formatTreesAndItems: function(cmp, treeValues){
        let item;
        console.log('formatTreesAndItems');
        console.log(treeValues);
        //set all tree totals
        // let treeStrucTotal = {Quantity__c: 0, Total_Direct_Cost__c: 0,  Total_Assembly_Cost__c: 0, Total_Cost__c: 0, subContactorMarkups: 0};

        for(let i=0; i<treeValues.length; i++){
            treeValues[i].tree.subContactorMarkups = (treeValues[i].tree.Total_Cost__c - treeValues[i].tree.Total_Direct_Cost__c);
            // //add tree values to tree totals
            // treeStrucTotal.Quantity__c += treeValues[i].tree.Quantity__c;
            // treeStrucTotal.Total_Direct_Cost__c += treeValues[i].tree.Total_Direct_Cost__c;
            // treeStrucTotal.Total_Assembly_Cost__c += treeValues[i].tree.Total_Assembly_Cost__c;
            // treeStrucTotal.Total_Cost__c += treeValues[i].tree.Total_Cost__c;
            // treeStrucTotal.subContactorMarkups += treeValues[i].tree.subContactorMarkups;
			console.log(treeValues[i].tree);
            //create category array for iteration
            treeValues[i].catArr = [];
            for(var cat in treeValues[i].catMap){
                // set category totas
                 treeValues[i].catMap[cat].Quantity__c = 0;
                 treeValues[i].catMap[cat].Labor_Hours__c = 0;
                 treeValues[i].catMap[cat].Total_Equipment_Cost__c = 0;
                 treeValues[i].catMap[cat].Total_Labor_Cost__c = 0;
                 treeValues[i].catMap[cat].Total_Material_Cost__c = 0;
                 treeValues[i].catMap[cat].Total_Cost__c = 0;
                 treeValues[i].catMap[cat].Total_Direct_Cost__c = 0;
                 treeValues[i].catMap[cat].Total_with_subcontractor = 0;
                 treeValues[i].catMap[cat].Total_w_o_subcontractor = 0;
                 treeValues[i].catMap[cat].Total_With_Markups = 0
                 treeValues[i].catMap[cat].ecca = 0;
                 treeValues[i].catMap[cat].ecc = 0;
                 treeValues[i].catMap[cat].etpc = 0;
                 treeValues[i].catMap[cat].subContactorMarkups = 0;
                 treeValues[i].catMap[cat].Direct_Unit_Cost__c = 0;
                 treeValues[i].catMap[cat].Total_Material_Cost_w_Sales_Tax__c  = 0; 
                 treeValues[i].catMap[cat].Total_Material_Cost_Adj__c = 0; 
                 treeValues[i].catMap[cat].materialSalesTax = 0
                
                 treeValues[i].catMap[cat].Total_Labor_Cost_w_Labor_Burden_Tax__c  = 0;
                 treeValues[i].catMap[cat].Total_Labor_Cost_Adj__c = 0;
                 treeValues[i].catMap[cat].laborBurden= 0;                 
                 treeValues[i].catMap[cat].Total_Equipment_Cost_w_Sales_Tax__c  = 0;
                 treeValues[i].catMap[cat].Total_Equip_Cost_Adj__c = 0;
                 treeValues[i].catMap[cat].equipmentSalesTax = 0;
                 treeValues[i].catMap[cat].Labor_Subtotal__c =0;
                 treeValues[i].catMap[cat].difficultyFactor = 0;

                 for(let j=0; j<treeValues[i].catMap[cat].length; j++){
                    //get item values, add to category totals
                    item = treeValues[i].catMap[cat][j];
					item.hasSubCon = item.hasOwnProperty('NCMT_Contractor_ID__c');
                    var itemMarkups = this.calculateItemMarkups(cmp, item.Total_Cost__c, item.hasSubCon);
                    item.Total_With_Markups = itemMarkups.totalCost;

                    item.ecca = itemMarkups.ecca;
                    item.ecc = itemMarkups.ecc;
                    item.etpc = itemMarkups.etpc;
                    item.subContactorMarkups = (item.Total_Cost__c - item.Total_Direct_Cost__c);
                    item.Unit_Cost__c = (item.Quantity__c? item.Total_Cost__c /item.Quantity__c : 0);
                    item.Direct_Unit_Cost__c =  (item.Quantity__c? item.Total_Direct_Cost__c /item.Quantity__c : 0);
                    item.materialSalesTax = item.Total_Material_Cost_w_Sales_Tax__c - item.Total_Material_Cost_Adj__c;
                    item.laborBurden = item.Total_Labor_Cost_w_Labor_Burden_Tax__c - item.Total_Labor_Cost_Adj__c  ;
                    item.equipmentSalesTax = item.Total_Equipment_Cost_w_Sales_Tax__c - item.Total_Equip_Cost_Adj__c;
                    item.difficultyFactor =  (item.Total_Labor_Cost_Adj__c  - item.Labor_Subtotal__c);

                    treeValues[i].catMap[cat].Quantity__c += item.Quantity__c;
                    treeValues[i].catMap[cat].Labor_Hours__c += item.Labor_Hours__c;
                    treeValues[i].catMap[cat].Total_Equipment_Cost__c += item.Total_Equipment_Cost1__c;
                    treeValues[i].catMap[cat].Total_Labor_Cost__c += item.Total_Labor_Cost1__c;  
                    treeValues[i].catMap[cat].Total_Material_Cost__c += item.Total_Material_Cost1__c;
                    treeValues[i].catMap[cat].Total_Cost__c += item.Total_Cost__c;    
                    treeValues[i].catMap[cat].Total_Direct_Cost__c += item.Total_Direct_Cost__c;
                    treeValues[i].catMap[cat].ecca += item.ecca;
                    treeValues[i].catMap[cat].ecc  += item.ecc;
                    treeValues[i].catMap[cat].etpc += item.etpc;
                    treeValues[i].catMap[cat].subContactorMarkups += item.subContactorMarkups;
                    treeValues[i].catMap[cat].Direct_Unit_Cost__c += item.Direct_Unit_Cost__c;
                    
                    treeValues[i].catMap[cat].Total_Material_Cost_w_Sales_Tax__c += item.Total_Material_Cost_w_Sales_Tax__c;
                    treeValues[i].catMap[cat].Total_Material_Cost_Adj__c += item.Total_Material_Cost_Adj__c;
                    treeValues[i].catMap[cat].materialSalesTax += item.materialSalesTax;
                    treeValues[i].catMap[cat].Total_Labor_Cost_w_Labor_Burden_Tax__c += item.Total_Labor_Cost_w_Labor_Burden_Tax__c;           
                    treeValues[i].catMap[cat].Total_Labor_Cost_Adj__c += item.Total_Labor_Cost_Adj__c;
                    treeValues[i].catMap[cat].laborBurden += item.laborBurden;
                    treeValues[i].catMap[cat].Total_Equipment_Cost_w_Sales_Tax__c += item.Total_Equipment_Cost_w_Sales_Tax__c;
                    treeValues[i].catMap[cat].Total_Equip_Cost_Adj__c += item.Total_Equip_Cost_Adj__c;
                    treeValues[i].catMap[cat].equipmentSalesTax += item.equipmentSalesTax;
                    treeValues[i].catMap[cat].Labor_Subtotal__c += item.Labor_Subtotal__c;
                    treeValues[i].catMap[cat].difficultyFactor += item.difficultyFactor;
                    treeValues[i].catMap[cat].Total_With_Markups += item.Total_With_Markups;
                    
                 }
                    treeValues[i].catMap[cat].Unit_Cost__c  = (treeValues[i].catMap[cat].Quantity__c? treeValues[i].catMap[cat].Total_Cost__c /treeValues[i].catMap[cat].Quantity__c : 0);
                    treeValues[i].catArr.push({key: cat, value:treeValues[i].catMap[cat]});
            }
            //sort categories
            treeValues[i].catArr.sort((a,b)=>(a.key >b.key)? 1:-1)

        }
        
        //CostWorks Report
        if(cmp.get('v.reportType') == 'detailC'){
        //console.log('TESTING');
        treeValues.catArrTotal = [];
        treeValues.catsUsed = [];
        //Create list of all Categories used in this estimate
        for(let i=0; i<treeValues.length; i++){
            for(let j=0; j<treeValues[i].catArr.length; j++)
            {
            	//if category not already in list
                if(!treeValues.catsUsed.includes(treeValues[i].catArr[j].key))
                {
                	//add category to list and push info to master list
                      treeValues.catsUsed.push(treeValues[i].catArr[j].key);
                }
            }
        }
        console.log(treeValues.catsUsed);
        var m1 = cmp.get('v.markup');
        var m2 = cmp.get('v.markuppctnts');
        
        //Populate tree info for each category
        for(let c=0;c<treeValues.catsUsed.length; c++)
        {
            var infoList = [];
            infoList.Total = 0;
            console.log(treeValues.catsUsed[c]);
            var parentIndex = 0;
            for(let t=0;t<treeValues.length;t++)
            {
                //console.log(treeValues[t]);
                //Set tree-specific markup values
                var t1 = treeValues[t].tree;
                t1.CMc_Impact = m2.CMc__c * t1.Total_Including_Markups__c;
                t1.Pro_Services_Pre_Const_Impact = m2.Professional_Services_Fees_Preconst__c * (t1.Total_Including_Markups__c + t1.CMc_Impact);
                t1.Subtotal_CMc = t1.Total_Including_Markups__c + t1.CMc_Impact + t1.Pro_Services_Pre_Const_Impact;
                t1.Dev_Fee_Impact = m2.Developer_Fee__c * t1.Subtotal_CMc;
                t1.Dev_Prof_Serv_Impact = m2.Professional_Services_Developer_Fee__c * (t1.Dev_Fee_Impact + t1.Subtotal_CMc);
                t1.Subtotal_Dev = t1.Subtotal_CMc + t1.Dev_Fee_Impact + t1.Dev_Prof_Serv_Impact;
                
                t1.Lessor_Fee_Impact = m2.Lessor_Fee__c * t1.Subtotal_Dev;
                t1.Lessor_Prof_Serv_Impact = m2.Professional_Services_Lessor_Fee__c * (t1.Lessor_Fee_Impact + t1.Subtotal_Dev);
                t1.Subtotal_Lessor = t1.Subtotal_Dev + t1.Lessor_Fee_Impact + t1.Lessor_Prof_Serv_Impact;
                t1.Gross_Receipt_Impact = m2.Gross_Receipt_State_Construction__c * t1.Subtotal_Lessor;
                t1.Total_CECA = t1.Subtotal_Lessor + t1.Gross_Receipt_Impact;
                
                //Only add tree with Total > 0 to report
                if(treeValues[t].tree.Total_Cost__c > 0){
            	var info = {Total: 0};
                info.Tree = treeValues[t].tree.Branch_Name__c;
                info.Level = treeValues[t].tree.Level__c;
                
                    
                //if tree has DES items, find any that match the currently iterating category and get the total
                if(treeValues[t].catArr.length > 0)
                {
                    for(let i=0;i<treeValues[t].catArr.length;i++)
                    {
                        //Check for category match
                        if(treeValues[t].catArr[i].key === treeValues.catsUsed[c])
                        {
                            //console.log(treeValues[t].catArr[i]);
                            //console.log('parentIndex === ' + parentIndex);
                            //console.log(info);
                            //console.log(infoList);
                            //console.log(infoList[parentIndex]);
                            //console.log(infoList[0]);
                            info.Total += treeValues[t].catArr[i].value.Total_Cost__c;
                            infoList.Total += info.Total;
                            if(treeValues.length > 1) {
                            if(info.Level != 1)
                            	infoList[parentIndex].Total += info.Total; //Add Total to parent total
                            //if(parentIndex != 0)
                            	infoList[0].Total += info.Total;
                            
                            //console.log(info.Total);
                            //console.log(infoList[0].Total);
                            }
                        }
                    }
                }
                /*else
                {
                    console.log(treeValues[t].tree.Branch_Name__c + ' has no items in catArr');
                    //It's a parent branch, save its index
                    //if(treeValues.catArrTotal.length > 0){
                        	console.log('current parent = ' + parentIndex);
                    		console.log(infoList[parentIndex]);
                    		//console.log('infoList length ==='+infoList.length);
                            if(infoList.length >0){
                                //console.log('NEW parentIndex==='+(infoList.length-1));
                                //parentIndex = infoList.length;
                                //console.log('length==='+treeValues.catArrTotal[0].value.length-1);
                           // }
                        }
                }*/
                    
                //Only add to infoList if Level 0 or 1 (aka don't display anything lower than Level 1 on the report)
                if(treeValues[t].tree.Level__c < 2){
                        infoList.push(info);
                    
                    	//Set parent index to index of last item added to infoList
                        console.log('PARENT INDEX = ' + (infoList.length-1));
                        parentIndex = infoList.length-1;
                    }
            }
           	
            }
            treeValues.catArrTotal.push({key: treeValues.catsUsed[c], value: infoList});
        }
            
        //Add Division Nums and put top-level parent branch at end of list
        for(let i=0;i<treeValues.catArrTotal.length;i++)
        {
            treeValues.catArrTotal[i].value.Division = treeValues.catArrTotal[i].key.split(' - ')[0];
            treeValues.catArrTotal[i].value.Description = treeValues.catArrTotal[i].key.split(' - ')[1];
            
            //Master Format Division
            if(treeValues.catArrTotal[i].value.Division.length > 3){
                treeValues.catArrTotal[i].value.Division = treeValues.catArrTotal[i].value.Division.substring(0,2);
                treeValues.catArrTotal[i].value.Division = 'Division ' + treeValues.catArrTotal[i].value.Division;
            } //Express Menu Division/Description
            else if(treeValues.catArrTotal[i].value.Division.length == 2){
                treeValues.catArrTotal[i].value.Division = 'Express Menu';
                treeValues.catArrTotal[i].value.Description = treeValues.catArrTotal[i].key;
            } //Assembly/Uniformat Division
            else
                treeValues.catArrTotal[i].value.Division = 'Division ' + treeValues.catArrTotal[i].value.Division;
            
            //Sort so that top-level tree is at end of list
            treeValues.catArrTotal[i].value.sort((a,b)=>(a.Level > b.Level)? -1: 1);
        }
        //Sort catArrTotal by Description first (to put Express Menu items in order), then by Division
        treeValues.catArrTotal.sort((a,b)=>(a.value.Description >b.value.Description)? -1:1);
        treeValues.catArrTotal.sort((a,b)=>(a.value.Division >b.value.Division)? 1:-1);
        cmp.set('v.catsUsed', treeValues.catArrTotal);
        //END Costworks
        }
        
        // treeStrucTotal.Unit_Cost__c = (treeStrucTotal.Quantity__c? treeStrucTotal.Total_Cost__c/treeStrucTotal.Quantity__c: 0);
        // treeStrucTotal.Direct_Unit_Cost__c  = (treeStrucTotal.Quantity__c? treeStrucTotal.Total_Direct_Cost__c/treeStrucTotal.Quantity__c: 0);

        // cmp.set('v.treeStrucTotal', treeStrucTotal);
        cmp.set('v.treeObj', treeValues);
    },
 
    
    calculateItemMarkups: function(cmp, cost, hasSubCon){
        let markups =  cmp.get('v.markuppctnts');
        let isOP = cmp.get('v.isOandP');
        let calculationObj = {};
        let markupObj = {};
        markupObj.totalCost = 0;
        //outsourced work markups
        let Prime_Con_OSWork_Homeoff_Overhead__c = 1+(markups.Prime_Con_OSWork_Homeoff_Overhead__c? markups.Prime_Con_OSWork_Homeoff_Overhead__c: 0);
        let Prime_Con_OSWork_Jobsite_Overhead__c = 1+ (markups.Prime_Con_OSWork_Jobsite_Overhead__c? markups.Prime_Con_OSWork_Jobsite_Overhead__c: 0);
        let Prime_Con_OSWork_Profit__c = 1+ (markups.Prime_Con_OSWork_Profit__c? markups.Prime_Con_OSWork_Profit__c:0);
        let Prime_Con_OSWork_Commission__c = 1+ (markups.Prime_Con_OSWork_Commission__c? markups.Prime_Con_OSWork_Commission__c: 0);
        let Prime_Con_OSWork_Bond__c = 1+ (markups.Prime_Con_OSWork_Bond__c? markups.Prime_Con_OSWork_Bond__c: 0);
        let Professional_Services_Fees_OSWork__c = 1+ (markups.Professional_Services_Fees_OSWork__c? markups.Professional_Services_Fees_OSWork__c: 0);

        //self work markups
        let Prime_Con_SelfWork_HomeOff_Overhead__c = 1+(markups.Prime_Con_SelfWork_HomeOff_Overhead__c? markups.Prime_Con_SelfWork_HomeOff_Overhead__c: 0);
        let Prime_Con_SelfWork_JobSiteOverhead__c = 1+ (markups.Prime_Con_SelfWork_JobSiteOverhead__c ? markups.Prime_Con_SelfWork_JobSiteOverhead__c : 0);
        let Prime_Con_SelfWork_Profit__c = 1+ (markups.Prime_Con_SelfWork_Profit__c ? markups.Prime_Con_SelfWork_Profit__c :0);
        let Prime_Con_SelfWork_Commission__c = 1+ (markups.Prime_Con_SelfWork_Commission__c ? markups.Prime_Con_SelfWork_Commission__c : 0);
        let Professional_Services_Fees_SelfWork__c = 1+ (markups.Professional_Services_Fees_SelfWork__c ? markups.Professional_Services_Fees_SelfWork__c : 0);
        let Prime_Con_SelfWork_Bond__c = 1+ (markups.Prime_Con_SelfWork_Bond__c ? markups.Prime_Con_SelfWork_Bond__c : 0);

        //total markups
        calculationObj.Cmc__c = 1+(markups.CMc__c  ? markups.CMc__c  : 0);
        calculationObj.Professional_Services_Fees_Preconst__c = 1+(markups.Professional_Services_Fees_Preconst__c  ? markups.Professional_Services_Fees_Preconst__c  : 0);
        calculationObj.Developer_Fee__c = 1+(markups.Developer_Fee__c  ? markups.Developer_Fee__c  : 0);
        calculationObj.Professional_Services_Developer_Fee__c = 1+(markups.Professional_Services_Developer_Fee__c ? markups.Professional_Services_Developer_Fee__c : 0);
        calculationObj.Lessor_Fee__c =  1+(markups.Lessor_Fee__c? markups.Lessor_Fee__c: 0);
        calculationObj.Professional_Services_Lessor_Fee__c = 1+(markups.Professional_Services_Lessor_Fee__c ? markups.Professional_Services_Lessor_Fee__c : 0);
        calculationObj.Gross_Receipt_State_Construction__c = 1+(markups.Gross_Receipt_State_Construction__c ? markups.Gross_Receipt_State_Construction__c : 0);
        calculationObj.Market_Escalation__c =  1+(markups.Market_Escalation__c ? markups.Market_Escalation__c : 0);
        calculationObj.Construction_Contingency__c = 1+(markups.Construction_Contingency__c  ? markups.Construction_Contingency__c  : 0);
        calculationObj.Art_In_Architecture__c = 1 +(markups.Art_In_Architecture__c  ? markups.Art_In_Architecture__c  : 0)
        calculationObj.EDRC_Estimated_Design_and_Review_Cost__c = 1+(markups.EDRC_Estimated_Design_and_Review_Cost__c   ? markups.EDRC_Estimated_Design_and_Review_Cost__c   : 0);
        calculationObj.EMIC_Estimated_Management_Inspection_Co__c = 1 +(markups.EMIC_Estimated_Management_Inspection_Co__c  ? markups.EMIC_Estimated_Management_Inspection_Co__c  : 0);
 


     // calculate total markups cost of item with or without subcontractor 
        markupObj.totalCost = cost;
        if(!isOP){
        cost = cost * (1 + markups.Site_Design_Contingency__c );
            console.log(hasSubCon);
        if(hasSubCon){
            markupObj.totalCost = cost 
            * Prime_Con_OSWork_Homeoff_Overhead__c
            * Prime_Con_OSWork_Jobsite_Overhead__c
            * Prime_Con_OSWork_Profit__c
            * Prime_Con_OSWork_Commission__c
            * Professional_Services_Fees_OSWork__c
            * Prime_Con_OSWork_Bond__c;
            
            }else{
            markupObj.totalCost = cost 
                * Prime_Con_SelfWork_HomeOff_Overhead__c
                * Prime_Con_SelfWork_JobSiteOverhead__c 
                * Prime_Con_SelfWork_Profit__c
                * Prime_Con_SelfWork_Commission__c
                * Professional_Services_Fees_SelfWork__c 
                * Prime_Con_SelfWork_Bond__c;
            }
            this.calculateGSAMarkups(markupObj, calculationObj);

        }else{
            this.calculateOPMarkups(markupObj, calculationObj);
        }
        
        
        return markupObj;
    }, 
    calculateGSAMarkups: function(markupObj, percents){
        
       
       //ECCA calculations
        let subtotalCmc = (markupObj.totalCost *  percents.Cmc__c) *  percents.Professional_Services_Fees_Preconst__c;
        
        let subTotalDeveloper = (subtotalCmc *  percents.Developer_Fee__c) *  percents.Professional_Services_Developer_Fee__c;
        //subtotalLessor === Cecca
        let cecca = (subTotalDeveloper *  percents.Lessor_Fee__c) * percents.Professional_Services_Lessor_Fee__c;
        
        //CECCA calculations
        let totalCecca = cecca *   percents.Gross_Receipt_State_Construction__c;
        let ecca = totalCecca * percents.Market_Escalation__c;
        markupObj.ecca = ecca;

        // ECC Calculations
        var ecc =  (ecca * percents.Construction_Contingency__c) *  percents.Art_In_Architecture__c;        
        markupObj.ecc = ecc;
        
        //ETPC calculations
        var etpc = ecc *  percents.EDRC_Estimated_Design_and_Review_Cost__c * percents.EMIC_Estimated_Management_Inspection_Co__c;
        markupObj.etpc = etpc;
    },
    calculateOPMarkups : function(markupObj, percents){
        let ecca;
        ecca = markupObj.totalCost * percents.Market_Escalation__c;
        markupObj.ecca = ecca;
        markupObj.ecc = ecca * percents.Construction_Contingency__c;

    }

    
})