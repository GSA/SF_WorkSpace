public with sharing class NCMT_TCO_Project {
    /*
        Class to store a TCO NCMT_Project__c record and related records/classes
    
        Create a new NCMT_TCO_Project object by passing in project Id:
            NCMT_TCO_Project p = projectMap.get(projectId);
        OR, to include LCC cost breakouts...
            NCMT_TCO_Project p = projectMap.get(projectId, true);
    
        The related records are queried and populated in the variables 
        with get/set methods at the top of this class
            e.g. annualCost is a NCMT_TCO_Annual_Cost_Summary__c record, 
            so tcoProject.annualCost.<field_name> returns that field value
        
        lccs is a list of the custom class NCMT_TCO_LCC with the NCMT_TCO_LCC__C record
        and, if populateCostDate = true, properties that gather 
        and store the cost data by category, which summaries at the LCC record
        level (fiscal year) and for each category (Facilities, Construction, Utilities...)
    
        5/27/20- Created, JG
    */
        
        @AuraEnabled public NCMT_Project__c record {get;set;}
        //The Project only has one of each of these records
        @AuraEnabled public NCMT_TCO_Annual_Cost_Summary__c annualCost {get;set;}
        @AuraEnabled public NCMT_Project_Cost_Rate__c costRates {get;set;}
        @AuraEnabled public Project_Level_Parameter__c projectParam {get;set;}
        @AuraEnabled public NCMT_TCO_Lifecycle_Input__c lifeCycle {get;set;}
        @AuraEnabled public List<NCMT_TCO_LCC> lccs {get;set;}
        @AuraEnabled public Decimal totalCost {get;set;}
        @AuraEnabled public Decimal totalEscalated {get;set;}
        @AuraEnabled public Decimal totalEscalatedDiscounted {get;set;}
        @AuraEnabled public NCMT_TCO_LCC totalLCC {get;set;}
    
        public NCMT_TCO_Project(Id projId, Boolean populateCostData) {
    
            //May not need every field here so if size becomes an issue, par down
            String soql = 'Select ' +NCMT_Utilities.getFieldSoQL('NCMT_Project__c', 'all');
            soql += ' from NCMT_Project__c where Id = \'' +projId +'\'';
            for (NCMT_Project__c proj : Database.query(soql))
                record =  proj;
    
            soql = 'Select ' +NCMT_Utilities.getFieldSoQL('NCMT_TCO_Annual_Cost_Summary__c', 'all');
            soql += ' from NCMT_TCO_Annual_Cost_Summary__c where Project_Name__c = \'' +projId +'\'';
            for (NCMT_TCO_Annual_Cost_Summary__c annual : Database.query(soql))
                annualCost =  annual;
        
            soql = 'Select ' +NCMT_Utilities.getFieldSoQL('NCMT_Project_Cost_Rate__c', 'all');
            soql += ' from NCMT_Project_Cost_Rate__c where Project_Name__c = \'' +projId +'\'';
            for (NCMT_Project_Cost_Rate__c rate : Database.query(soql))
                costRates =  rate;
        
            soql = 'Select ' +NCMT_Utilities.getFieldSoQL('NCMT_TCO_Lifecycle_Input__c', 'all');
            soql += ' from NCMT_TCO_Lifecycle_Input__c where NCMT_Project__c = \'' +projId +'\'';
            for (NCMT_TCO_Lifecycle_Input__c life : Database.query(soql))
                lifeCycle =  life;

            soql = 'Select ' +NCMT_Utilities.getFieldSoQL('Project_Level_Parameter__c', 'all');
            soql += ' from Project_Level_Parameter__c where NCMT_Project__c = \'' +projId +'\'';
            for (Project_Level_Parameter__c pp : Database.query(soql))
                projectParam =  pp;
            
            lccs = new List<NCMT_TCO_LCC>();
            String lccFieldString = NCMT_Utilities.getFieldSoQL('NCMT_TCO_LCC__c', 'all');
            //These fields hit an error when doing recalculateFormulas on the LCC, so skip them...
            lccFieldString.replace(', tco_lifecycle_input__c', '').replace(', ncmt_project__c', '');
            soql = 'Select ' +lccFieldString;
            soql += ' from NCMT_TCO_LCC__c where NCMT_Project__c = \'' +projId +'\' Order By Year__c';
            for (NCMT_TCO_LCC__c l : Database.query(soql))
                lccs.add(new NCMT_TCO_LCC(l, populateCostData));
            
            if (populateCostData){
                totalCost = 0;
                totalEscalated = 0;
                totalEscalatedDiscounted = 0;
    
                Map<String, NCMT_TCO_LCC.Category> catMap = new Map<String, NCMT_TCO_LCC.Category>();
                Map<String, NCMT_TCO_LCC.Cost> costMap = new Map<String, NCMT_TCO_LCC.Cost>();
                //Grab project totals
                List<String> catNames = new List<String>();
                Map<String, List<String>> costLabels = new Map<String, List<String>>();
                totalLCC = new NCMT_TCO_LCC();
                if (lccs.size() > 0){

                    for (NCMT_TCO_LCC lcc : lccs){
                        for (NCMT_TCO_LCC.Category cat : lcc.categories){
                            if (catMap.get(cat.name) == null){
                                catMap.put(cat.name, new NCMT_TCO_LCC.Category(cat.Name));
                                catNames.add(cat.name);
                            }
                            catMap.get(cat.name).cost += cat.cost;
                            catMap.get(cat.name).escalatedCost += cat.escalatedCost;
                            catMap.get(cat.name).escalatedDiscountedCost += cat.escalatedDiscountedCost;
        
                            for (NCMT_TCO_LCC.Cost c : cat.costs){
                                if (costMap.get(c.label) == null){
                                    costMap.put(c.label, new NCMT_TCO_LCC.Cost(c.label));
                                    if (costLabels.get(cat.name) == null) costLabels.put(cat.name, new List<String>());
                                    costLabels.get(cat.name).add(c.label);
                                }
                                costMap.get(c.label).cost += c.cost;
                                costMap.get(c.label).escalatedCost += c.escalatedCost;
                                costMap.get(c.label).escalatedDiscountedCost += c.escalatedDiscountedCost;
                
                            }
                        }
                        totalCost += lcc.totalCost;
                        totalEscalated += lcc.totalEscalated;
                        totalEscalatedDiscounted += lcc.totalEscalatedDiscounted;
                    }  
                    for (String catName : catNames){
                        NCMT_TCO_LCC.Category cat = catMap.get(catName);
                        
                        for (String costLabel : costLabels.get(catName)){
                            cat.costs.add(costMap.get(costLabel));
                        }
                        for (Integer i = 0; i < totalLCC.categories.size(); i++){
                            NCMT_TCO_LCC.Category c = totalLCC.categories[i];
                            if (c.name == catName) totalLCC.categories[i] = cat;
                        }
                        //totalLCC.categories.add(cat);
                        System.debug('total catName ----------------------- ' +catName);
                    }
                }
            
            }
        }
    }