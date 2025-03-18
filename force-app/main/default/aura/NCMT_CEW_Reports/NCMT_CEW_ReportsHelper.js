({
    getData : function(cmp, projectId) {
        return new Promise($A.getCallback(function(resolve, reject){ 
         let getReportData = cmp.get('c.getReportData'); 
         getReportData.setParams({ 
             "projectId": projectId
         }); 
         getReportData.setCallback(this, function(res){ 
          resolve(res.getReturnValue()); 
         }); 
         $A.enqueueAction(getReportData); 
        }));
    },
     formatMarkups : function(cmp, project, proServ){ 

        project.Estimated_Site_Cost__c = project.CEW_Land_Cost__c + project.CEW_Reloc_Associated_w_Site_Purchase__c + project.CEW_Demolition__c;
        
        project.cityState = project.City__c  + ', ' + project.State__c;
        
        //get markup percentages
     

        //calculate markups and impacts for cost type one and type separately, then combine for totals;
        let cost_one = project.CEW_Total_Direct_Cost_1__c;
        let cost_two = project.CEW_Total_Direct_Cost_2__c;

        let markuppctnts = this.getPercentages(project);
        markuppctnts.Construction_Contingency_And_Reservation__c = markuppctnts.Construction_Contingency__c + markuppctnts.CEW_Item1__c + markuppctnts.CEW_Item2__c + markuppctnts.CEW_Item3__c;

        cmp.set('v.markuppctnts', markuppctnts);
        let proServPcnts = this.getPercentages(proServ);
        cmp.set('v.proServPcnts', proServPcnts);

        // let directCost = project.CEW_Total_Cost_W_O_Markup__c;
        
        project.Impact_Design_and_Site_Contingency__c = (cost_one + cost_two) *  markuppctnts.Design_and_Site_Contingency__c;

        cost_one = cost_one * (1 +  markuppctnts.Design_and_Site_Contingency__c);
        cost_two = cost_two * (1 +  markuppctnts.Design_and_Site_Contingency__c);
        project.Subtotal_Design_and_Site_Contingency__c = cost_one + cost_two; 
        
        project.Impact_General_Contractor_Overhead_Profit_Bonds__c = (cost_one + cost_two) *  markuppctnts.General_Contractor_Overhead_Profit_Bonds__c;
        
        cost_one = cost_one * (1 +  markuppctnts.General_Contractor_Overhead_Profit_Bonds__c  +  markuppctnts.Phasing_Premium__c);
        cost_two = cost_two * (1 +  markuppctnts.General_Contractor_Overhead_Profit_Bonds__c +  markuppctnts.Phasing_Premium__c);
        project.Subtotal_GeneralConditons_Phasing__c =  cost_one + cost_two; 

        project.Impact_Phasing_Premium__c  =  project.Subtotal_GeneralConditons_Phasing__c - ( project.Subtotal_Design_and_Site_Contingency__c +  project.Impact_General_Contractor_Overhead_Profit_Bonds__c);
        project.Impact_Special_Use_Tax__c =  (cost_one + cost_two) * markuppctnts.Special_Use_Gross_Receipts_Tax__c;

        cost_one = cost_one * (1 +  markuppctnts.Special_Use_Gross_Receipts_Tax__c);
        cost_two = cost_two * (1 +  markuppctnts.Special_Use_Gross_Receipts_Tax__c);
        project.Subtotal_Special_Use_Tax__c = (cost_one + cost_two);
        
        project.Impact_Total_Escalation_CPE__c = cost_one * (markuppctnts.Total_Escalation__c + markuppctnts.Total_Escalation_CPE__c );
        project.Impact_Total_Escalation__c = cost_two * markuppctnts.Total_Escalation__c;

        cost_one = cost_one * (1 +  markuppctnts.Total_Escalation__c + markuppctnts.Total_Escalation_CPE__c );
        cost_two = cost_two * (1 +  markuppctnts.Total_Escalation__c);
        project.Subtotal_Escalation__c = cost_one + cost_two; 
        
        // ecca

        //combined for FBF and RWA FUNDING report
        
        project.Impact_Construction_Contingency_And_Reservation__c = project.Subtotal_Escalation__c * markuppctnts.Construction_Contingency_And_Reservation__c;
        

        project.Impact_Item1 = project.Subtotal_Escalation__c * markuppctnts.CEW_Item1__c;
        project.Impact_Item2 =  project.Subtotal_Escalation__c * (1 +markuppctnts.CEW_Item1__c) * markuppctnts.CEW_Item2__c;
        project.Impact_Item3 =  project.Subtotal_Escalation__c * (1 +markuppctnts.CEW_Item1__c + markuppctnts.CEW_Item2__c) * markuppctnts.CEW_Item3__c;
        project.subTotalReservations = project.Subtotal_Escalation__c * (1 +markuppctnts.CEW_Item1__c + markuppctnts.CEW_Item2__c + markuppctnts.CEW_Item3__c); 

        project.Subtotal_Contruction_Reservations  = project.Subtotal_Escalation__c * (1 + markuppctnts.Construction_Contingency_And_Reservation__c);
        project.Impact_Construction_Contingency__c = project.Subtotal_Contruction_Reservations - project.subTotalReservations;

        project.Impact_Art_In_Architecture__c = project.Subtotal_Contruction_Reservations  * markuppctnts.Art_In_Architecture__c;
        project.ECC__c = project.Subtotal_Contruction_Reservations  * (1+ markuppctnts.Art_In_Architecture__c);
         

        project.Impact_Design_AE__c = project.ECC__c * proServPcnts.Design_AE_Percent__c;
        project.Impact_Design_CM__c = project.ECC__c  * proServPcnts.Design_CM_as_Agent_and_CM_as_Const__c;
        project.Impact_Design_Services__c = project.ECC__c *proServPcnts.Design_Cx_Percent__c;



        project.Impact_EDRC__c =  project.ECC__c * markuppctnts.EDRC__c;

        let subtotalEDRC = project.ECC__c * (1+ markuppctnts.EDRC__c);

        project.ETPC__c = project.ECC__c * (1+ (markuppctnts.EDRC__c + markuppctnts.EMIC__c)) + project.Estimated_Site_Cost__c; 
        project.Impact_EMIC__c =  project.ECC__c *  markuppctnts.EMIC__c;          

        project.Impact_Construction_AE__c = project.ECC__c * proServPcnts.Construction_AE_Percent__c;
        project.Impact_Construction_CM__c = project.ECC__c  * proServPcnts.Construction_CM_as_Agent_CM_as_Const__c; 
        project.Impact_Construction_Services__c = project.ECC__c *proServPcnts.Construction_Cx_Percent__c


        cmp.set('v.project', project);
     }, 
     calculateWorkDecTotals :function(cmp, workDesc, rwaDirectCost){
        //create  objects for totals values, add key for html label
        let buildingShell = {key: 'Building Shell-Related Work Items'};
        let pbs = {key: 'SubTotal - PBS Funded'};
        let total = {key: 'Total - PBS and RWA Funded'};
        let TI = {key: 'Tenant Improvement Work Items'}; 
        let blast = {key: 'Blast/Security Work Items'};
        let RWA = {key : 'RWA Funded Work'};




        //add keys to totals objects
        let blankObj = { Total_Direct_Cost__c: 0, CECCA__c: 0, ECCA__c: 0, ECC__c: 0,  EDRC__c: 0, EMIC__c: 0, ETPC__c: 0};
        Object.assign(buildingShell, blankObj );
        Object.assign(pbs, blankObj );
        Object.assign(total, blankObj );
        Object.assign(TI, blankObj );
        Object.assign(blast, blankObj );
        Object.assign(RWA, blankObj );

        
        //get work item description values, add to totals objects
         for (let i=0; i<workDesc.length; i++){
             if(!['6', '7', '8'].includes(workDesc[i].Number__c)){
                buildingShell.Total_Direct_Cost__c += workDesc[i].Total_Direct_Cost__c;
                buildingShell.CECCA__c += workDesc[i].CECCA__c;
                buildingShell.ECCA__c += workDesc[i].ECCA__c;
                buildingShell.ECC__c += workDesc[i].ECC__c;
                buildingShell.EDRC__c += workDesc[i].EDRC__c
                buildingShell.EMIC__c += workDesc[i].EMIC__c;
                buildingShell.ETPC__c += workDesc[i].ETPC__c;
             }
             if(workDesc[i].Number__c == '6'){
                TI.Total_Direct_Cost__c += workDesc[i].Total_Direct_Cost__c;
                TI.CECCA__c += workDesc[i].CECCA__c;
                TI.ECCA__c += workDesc[i].ECCA__c;
                TI.ECC__c += workDesc[i].ECC__c;
                TI.EDRC__c += workDesc[i].EDRC__c
                TI.EMIC__c += workDesc[i].EMIC__c;
                TI.ETPC__c += workDesc[i].ETPC__c;           
             }
             if(workDesc[i].Number__c == '7'){
                blast.Total_Direct_Cost__c += workDesc[i].Total_Direct_Cost__c;
                blast.CECCA__c += workDesc[i].CECCA__c;
                blast.ECCA__c += workDesc[i].ECCA__c;
                blast.ECC__c += workDesc[i].ECC__c;
                blast.EDRC__c += workDesc[i].EDRC__c
                blast.EMIC__c += workDesc[i].EMIC__c;
                blast.ETPC__c += workDesc[i].ETPC__c;           
             }
             if(workDesc[i].Number__c == '8'){
              
                // RWA.Total_Direct_Cost__c += workDesc[i].Total_Direct_Cost__c;
                
                RWA.CECCA__c += workDesc[i].CECCA__c;
                RWA.ECCA__c += workDesc[i].ECCA__c;
                RWA.ECC__c += workDesc[i].ECC__c;
                RWA.EDRC__c += workDesc[i].EDRC__c
                RWA.EMIC__c += workDesc[i].EMIC__c;
                RWA.ETPC__c += workDesc[i].ETPC__c;           
             }
             if(workDesc[i].Number__c != '8'){

                pbs.Total_Direct_Cost__c += workDesc[i].Total_Direct_Cost__c;
                pbs.CECCA__c += workDesc[i].CECCA__c;
                pbs.ECCA__c += workDesc[i].ECCA__c;
                pbs.ECC__c += workDesc[i].ECC__c;
                pbs.EDRC__c += workDesc[i].EDRC__c
                pbs.EMIC__c += workDesc[i].EMIC__c;
                pbs.ETPC__c += workDesc[i].ETPC__c;
                //moved total to this section to not duplicate rwa total direct cost. 
                total.Total_Direct_Cost__c += workDesc[i].Total_Direct_Cost__c;

             }
                total.CECCA__c += workDesc[i].CECCA__c;
                total.ECCA__c += workDesc[i].ECCA__c;
                total.ECC__c += workDesc[i].ECC__c;
                total.EDRC__c += workDesc[i].EDRC__c
                total.EMIC__c += workDesc[i].EMIC__c;
                total.ETPC__c += workDesc[i].ETPC__c;
            }

            //RWA Total Direct Cost is calculated on the Project Agency records using undocumented business logic 
            //so this value is pulled directly from there
            RWA.Total_Direct_Cost__c = rwaDirectCost;
            total.Total_Direct_Cost__c += rwaDirectCost;

            
            let workDescArr = [];
            workDescArr.push(buildingShell);
            workDescArr.push(TI);
            workDescArr.push(blast);


            //find number 6,7,8 values in descrption values array and
            //add totals object and work description objects to new array. 
            //order of pushing to array will be the same order displayed in cew summary report. 

            //moved this logic to if statements above to show rows if no data for the work description number -- gm 6/26
            
            // let TI = workDesc.findIndex((obj => obj.Number__c == '6'));
            // if(TI>=0) {
            //     workDesc[TI].key = 'Tenant Improvement Work Items';
            //     workDescArr.push(workDesc[TI]);
            // }

            // let blast = workDesc.findIndex((obj => obj.Number__c == '7'));
            // if(blast >= 0){
            //      workDesc[blast].key = 'Blast/Security Work Items';
            //      workDescArr.push(workDesc[blast]);
            // }

            workDescArr.push(pbs);
            workDescArr.push(RWA);


            // let RWA = workDesc.findIndex((obj => obj.Number__c == '8'));
            // if(RWA>=0) {
            //     workDesc[RWA].key = 'RWA Funded Work';
            //     workDescArr.push(workDesc[RWA]);
            // }
            workDescArr.push(total);

            console.log('workDescArr', workDescArr);
            cmp.set('v.workDescTotals', workDescArr);

     },
     
    getPercentages: function(valueObject){
        let pcntObj = Object.assign({}, valueObject);
        for(var key in pcntObj){
            pcntObj[key] = pcntObj[key]/100;
        };
        return pcntObj;
    }
})