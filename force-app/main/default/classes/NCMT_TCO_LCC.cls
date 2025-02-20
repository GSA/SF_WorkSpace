public class NCMT_TCO_LCC {
    /*
        Class to store a TCO NCMT_TCO_LCC__c record and related metrics
    
        Create a new NCMT_TCO_Project object by passing in project Id
        The lccs property of the class is a list populated based on that project's
        LCC records (children of the NCMT TCO Lifecycle record):
    
            NCMT_TCO_Project p = projectMap.get(projectId, true);
            for (NCMT_TCO_LCC lcc : p.lccs){
                NCMT_TCO_LCC__c lccRecord = lcc.record; //Includes fields for fiscal year, start/end dates
                for (Category cat : lcc.categories){
                    String categoryName = cat.name; //(eg. Facilities, Utilities...)
                    for (Cost c : cat.costs){
                        String costLabel = c.label; (eg. Janitorial, Landscaping, etc)
                        Double costValue = c.cost;
                        Double escalatedCostValue = c.escalatedCost;
                        Double escalatedDiscountedCostValue = c.escalatedDiscountedCost;
                    }
                }
            }
    
        The Categories and all of the NCMT_TCO_LCC__c fields where the cost data is pulled
        from is stored in the NCMT_TCO_LCC_Cost_Field__c custom object. 
        
        5/27/20- Created, JG
    */
        //Organize the fields so the data can be normalized
        
        
        @AuraEnabled public NCMT_TCO_LCC__c record {get;set;}
        @AuraEnabled public String stringYear {get;set;}
        @AuraEnabled public List<Category> categories {get;set;}
        @AuraEnabled public Decimal totalCost {get;set;}
        @AuraEnabled public Decimal totalEscalated {get;set;}
        @AuraEnabled public Decimal totalEscalatedDiscounted {get;set;}
    
        public NCMT_TCO_LCC(){
            categories = new List<Category>();
            populateCategories();
        }

        public NCMT_TCO_LCC(NCMT_TCO_LCC__c r, Boolean populateCostData) {
            record = r;
            categories = new List<Category>();

            if (r.Start_Date__c != null) stringYear = String.valueOf(r.Start_Date__c.year());
            if (populateCostData){
                
                populateCategories();
            }//end if populateCostData
        }
        
        public void populateCategories(){
            Map<String, Category> catMap = new Map<String, Category>();
            totalCost = 0;
            totalEscalated = 0;
            totalEscalatedDiscounted = 0;
            for (lccCostField f : new lccCostFieldDef().costFields){
                if (catMap.get(f.category) == null)
                    catMap.put(f.category, new Category(f.category));

                Cost c;
                if (record != null){
                    c = new Cost(f, record);
                    System.debug('cost logging..............');
                    System.debug(f);
                    System.debug(c.cost);
                    System.debug(totalCost);
                    totalCost += c.cost;
                    totalEscalated += c.escalatedCost;
                    totalEscalatedDiscounted += c.escalatedDiscountedCost;

                    catMap.get(f.category).cost += c.cost;
                    catMap.get(f.category).escalatedCost += c.escalatedCost;
                    catMap.get(f.category).escalatedDiscountedCost += c.escalatedDiscountedCost;
                } else {
                    c = new Cost(f.label);
                }
                catMap.get(f.category).costs.add(c);
            
            }

            for (Category c : catMap.values()){
                categories.add(c);
            }
        }
    
        public class Category{
            @AuraEnabled public String name {get;set;}
            @AuraEnabled public List<Cost> costs {get;set;}
            @AuraEnabled public Decimal cost {get;set;}
            @AuraEnabled public Decimal escalatedCost {get;set;}
            @AuraEnabled public Decimal escalatedDiscountedCost {get;set;}
    
            public Category(String n){
                name = n;
                costs = new List<Cost>();
    
                cost = 0;
                escalatedCost = 0;
                escalatedDiscountedCost = 0;
            }
        }
    
        public class Cost{
            @AuraEnabled public String label {get;set;}
            @AuraEnabled public Double cost {get;set;}
            @AuraEnabled public Double escalatedCost {get;set;}
            @AuraEnabled public Double escalatedDiscountedCost {get;set;}
            
            public Cost(String l){
                label = l;
                cost = 0;
                escalatedCost = 0;
                escalatedDiscountedCost = 0;
            }

            public Cost(lccCostField costField, NCMT_TCO_LCC__c lcc){
                System.debug('costField ======= ' +costField);
                label = costField.label;
                cost = Double.valueOf(lcc.get(costField.costField));
                if (cost == null) cost = 0;
                System.debug('cost ======= ' +cost);
                escalatedCost = Double.valueOf(lcc.get(costField.escalatedField));
                escalatedDiscountedCost = Double.valueOf(lcc.get(costField.discountedField));
            }
        }

        public class lccCostFieldDef{
            public List<lccCostField> costFields {get;set;}

            public lccCostFieldDef(){
                costFields = new List<lccCostField>();
                costFields.add(new lccCostField('Janitorial', 
                'Operations and Maintenance', 
                'Janitorial_Cost__c', 
                'Janitorial_Escalated_Discounted_Cost__c', 
                'Janitorial_Escalated_Cost__c'));

                costFields.add(new lccCostField('Landscaping Cost', 
                'Operations and Maintenance', 
                'Landscaping_Cost__c', 
                'Landscaping_Escalated_Discounted_Cost__c', 
                'Landscaping_Escalated_Cost__c'));

                costFields.add(new lccCostField('Routine Maintenance', 
                'Operations and Maintenance', 
                'Routine_Maint_Cost__c', 
                'Routine_Maint_Esc_Discounted_Cost__c', 
                'Routine_Maint_Escalated_Cost__c'));

                costFields.add(new lccCostField('Building Supplies', 
                'Operations and Maintenance', 
                'Bldg_Supp_Cost__c', 
                'Bldg_Supp_Escalated_Discounted_Cost__c', 
                'Bldg_Supp_Escalated_Cost__c'));

                costFields.add(new lccCostField('Minor Repair', 
                'Operations and Maintenance', 
                'Minor_Repair_Cost__c', 
                'Minor_Repair_Escalated_Discounted_Cost__c', 
                'Minor_Repair_Escalated_Cost__c'));

                costFields.add(new lccCostField('Building Shell Clean', 
                'Operations and Maintenance', 
                'Bldg_Shell_Clean_Cost__c', 
                'Bldg_Shell_Clean_Esc_Discounted_Cost__c', 
                'Bldg_Shell_Clean_Escalated_Cost__c'));

                costFields.add(new lccCostField('Building Management', 
                'Operations and Maintenance', 
                'Bldg_Mgmt_Cost__c', 
                'Bldg_Mgmt_Escalated_Discounted_Cost__c', 
                'Bldg_Mgmt_Escalated_Cost__c'));

                costFields.add(new lccCostField('Grid Electricity', 
                'Utilities', 
                'Grid_Electricity_Cost__c', 
                'Grid_Electricity_Esc_Discounted_Cost__c', 
                'Grid_Electricity_Escalated_Cost__c'));

                costFields.add(new lccCostField('Potable Water', 
                'Utilities', 
                'Ptbl_Water_Cost__c', 
                'Ptbl_Water_Escalated_Discounted_Cost__c', 
                'Ptbl_Water_Escalated_Cost__c'));

                costFields.add(new lccCostField('Gas', 
                'Utilities', 
                'Gas_Cost__c', 
                'Gas_Escalated_Discounted_Cost__c', 
                'Gas_Escalated_Cost__c'));

                costFields.add(new lccCostField('Reclaimed Water', 
                'Utilities', 
                'Reclaim_Water_Cost__c', 
                'Reclaim_Water_Esc_Discounted_Cost__c', 
                'Reclaim_Water_Escalated_Cost__c'));

                costFields.add(new lccCostField('Other Heating', 
                'Utilities', 
                'Oth_Heating_Cost__c', 
                'Oth_Heating_Escalated_Discounted_Cost__c', 
                'Oth_Heating_Escalated_Cost__c'));

                costFields.add(new lccCostField('Other Cooling', 
                'Utilities', 
                'Other_Cooling_Cost__c', 
                'Other_Cooling_Escalated_Discounted__c', 
                'Other_Cooling_Escalated_Cost__c'));

                costFields.add(new lccCostField('Sewer', 
                'Utilities', 
                'Sewer_Cost__c', 
                'Sewer_Escalated_Discounted_Cost__c', 
                'Sewer_Escalated_Cost__c'));

                
                costFields.add(new lccCostField('Moving', 
                'Replacement/Refresh', 
                'Moving_Cost__c', 
                'Moving_Escalated_Discounted_Price__c', 
                'Moving_Escalated_Cost__c'));

                costFields.add(new lccCostField('TI CRR', 
                'Replacement/Refresh', 
                'TI_CRR_Cost__c', 
                'TI_CRR_Escalated_Discounted_Cost__c', 
                'TI_CRR_Escalated_Cost__c'));

                costFields.add(new lccCostField('Shell CRR', 
                'Replacement/Refresh', 
                'Replacement_Cost__c', 
                'Replacement_Escalated_Discounted_Cost__c', 
                'Replacement_Escalated_Cost__c'));

                costFields.add(new lccCostField('Initial Cost', 
                'Initial Cost', 
                'Construction_Cost__c', 
                'Construction_Escalated_Discounted_Cost__c', 
                'Construction_Escalated_Cost__c'));
            }
        }

        public class lccCostField{
            public String label {get;set;}
            public String category {get;set;}
            public String costField {get;set;}
            public String escalatedField {get;set;}
            public String discountedField {get;set;}

            public lccCostField(String l, String cat, String cf, String df, String ef){
                label = l;
                category = cat;
                costField = cf;
                escalatedField = ef;
                discountedField = df;
            }
        }

    }