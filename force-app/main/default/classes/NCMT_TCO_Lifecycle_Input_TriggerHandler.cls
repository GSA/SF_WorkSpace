public with sharing class NCMT_TCO_Lifecycle_Input_TriggerHandler {
/*
    Trigger handler for NCMT_TCO_Lifecycle_Input__c object that stores lifecycle (construction/operation phases and dates, etc)
    
    linkSummary - links the single, not normalized NCMT TCO Annual Cost Summary record to the Lifecycle

    manageLCC - creates and updates the related LCC records when the single, not normalized Lifecycle record 
    is inserted or the years being analysed/retrofit/refresh changes

    5/27/20- Created, JG
*/
    private final List<NCMT_TCO_Lifecycle_Input__c> oldList { get; set; }
	private final List<NCMT_TCO_Lifecycle_Input__c> newList { get; set; }
	private final Map<Id, NCMT_TCO_Lifecycle_Input__c> oldMap { get; set; }
    private final Map<Id, NCMT_TCO_Lifecycle_Input__c> newMap { get; set; }
    //Probably will only deal with 1 project at a time, but let's plan for the worst
    private static Map<Id, NCMT_TCO_Project> projectMap {get;set;}
    public static Boolean triggerHandlerUpdate = false;
    public static Boolean forceRecalc = false;
    public NCMT_TCO_Lifecycle_Input_TriggerHandler() {

    }
    public NCMT_TCO_Lifecycle_Input_TriggerHandler(List<NCMT_TCO_Lifecycle_Input__c> oldLst, List<NCMT_TCO_Lifecycle_Input__c> newLst, Map<Id, NCMT_TCO_Lifecycle_Input__c> oldMp, Map<Id, NCMT_TCO_Lifecycle_Input__c> newMp) {
		oldList = (oldLst == null ? new List<NCMT_TCO_Lifecycle_Input__c>() : oldLst);
		newList = (newLst == null ? new List<NCMT_TCO_Lifecycle_Input__c>() : newLst);
		oldMap = (oldMp == null ? new Map<Id, NCMT_TCO_Lifecycle_Input__c>() : oldMp);
        newMap = (newMp == null ? new Map<Id, NCMT_TCO_Lifecycle_Input__c>() : newMp);
        
        projectMap = new Map<Id, NCMT_TCO_Project>();

        for (NCMT_TCO_Lifecycle_Input__c l : newList){
            //Build NCMT_TCO_Project objects with everything 
            projectMap.put(l.NCMT_Project__c, new NCMT_TCO_Project(l.NCMT_Project__c, false));
        }
    }


    @future
    public static void futureUpdateByProject(Set<Id> projIds){
        for (Id projId : projIds){
            NCMT_TCO_Project tcoProj = new NCMT_TCO_Project(projId, false);

            if (tcoProj.lifeCycle != null){
                forceRecalc = true;
                update tcoProj.lifeCycle;
            }
            System.debug('firing lifecycle update...................');
        }
    }

    public void beforeLogic(){
        for (NCMT_TCO_Lifecycle_Input__c l : newList){
            NCMT_TCO_Project p = projectMap.get(l.NCMT_Project__c); 

            if (p.record.End_Construction__c != null &&p.record.Start_Construction__c != null){
                l.Construction__c = p.record.Start_Construction__c.monthsBetween(p.record.End_Construction__c);
            } else {
                l.Construction__c = 0;
            }
            //System.debug('p.lifeCycle.Construction__c ** ' +p.lifeCycle.Construction__c +' p.record.End_Construction__c = ' +p.record.End_Construction__c +' p.record.Start_Construction__c = ' +p.record.Start_Construction__c);
            
            //Is there already a lifecycle? Then don't allow another
            if (p.lifeCycle != null &&p.lifeCycle.Id != l.Id){
                l.addError('A Lifecycle record already exists for this project, please adjust that one instead of creating another.');
            }
        }
    }
    
    public void manageLCC(){
        
        List<NCMT_TCO_Lifecycle_Input__c> lifecycles = new List<NCMT_TCO_Lifecycle_Input__c>();
        
        for (NCMT_TCO_Lifecycle_Input__c l : newList){
            NCMT_TCO_Project p = projectMap.get(l.NCMT_Project__c); 

            
            if (p.annualCost != null){
                p.lifeCycle.NCMT_TCO_Annual_Cost_Summary__c =  p.annualCost.Id;
                p.lifeCycle.TCO_Project_Cost_Rate__c = p.costRates.Id;
                
            }
            System.debug('p.annualCost == ' +p.annualCost);
            System.debug('p.lifeCycle == ' +p.lifeCycle);
            if (p.annualCost != null &&(p.annualCost.NCMT_TCO_Lifecycle_Input__c == null
                || p.annualCost.NCMT_TCO_Lifecycle_Input__c != p.lifeCycle.Id)
            ){
                p.annualCost.NCMT_TCO_Lifecycle_Input__c = p.lifeCycle.Id;
                triggervalue.isPerformanceUpdate= true;
                update p.annualCost;
            }
            
            lifecycles.add(p.lifeCycle);
        }
        triggerHandlerUpdate = true;
        update lifecycles;

        
        //Only need to update the LCC records if the record is new
        //or the retro/refresh or analysis fields are updated
        Boolean needsRecalc = false;
        Set<Id> projIds = new Set<Id>();
        Boolean includeRefresh = false;
        Integer fitOutYears;
        for (NCMT_TCO_Lifecycle_Input__c l : newList){
            
            if (oldMap.get(l.Id) == null ||
                (oldMap.get(l.Id) != null &&
                    (l.Include_Tenant_Refresh_Costs__c != oldMap.get(l.Id).Include_Tenant_Refresh_Costs__c
                    || l.New_fit_out_every_years__c != oldMap.get(l.Id).New_fit_out_every_years__c
                    || l.Refresh_every_years__c != oldMap.get(l.Id).Refresh_every_years__c
                    || l.Period_of_Analysis__c != oldMap.get(l.Id).Period_of_Analysis__c
                    || l.Planning_and_Pre_design__c  != oldMap.get(l.Id).Planning_and_Pre_design__c
                    || l.Design__c != oldMap.get(l.Id).Design__c
                    || l.Construction__c != oldMap.get(l.Id).Construction__c
                    || l.Start_for_Maintenance_Operations__c != oldMap.get(l.Id).Start_for_Maintenance_Operations__c
                    || l.Years_of_Routine_Periodic_Maint__c != oldMap.get(l.Id).Years_of_Routine_Periodic_Maint__c
                    || l.Years_of_Major_Maint_Replace__c != oldMap.get(l.Id).Years_of_Major_Maint_Replace__c
                    || l.Number_of_Years_of_Operation__c != oldMap.get(l.Id).Number_of_Years_of_Operation__c
                    ))
                || system.isFuture() //If it's the future, assume a date for the period analysis or something else was changed and recalc
            ){
                needsRecalc = true;
                projIds.add(l.NCMT_Project__c);
                includeRefresh = l.Include_Tenant_Refresh_Costs__c;
                fitOutYears = (l.New_fit_out_every_years__c != null ? Integer.valueOf(l.New_fit_out_every_years__c) : 0);
            }
        }
        if (forceRecalc) needsRecalc = true;

        Map<Id, List<replacementCost>> projReplace = new Map<Id, List<replacementCost>>();
        Decimal movingCosts = 0;
        if (needsRecalc){
            for (NCMT_Core_Shell_Cost_Detail__c d : [Select Id, Project_Cost_Summary__r.Project_Name__c,
                    Replacement_Cost__c, Replacement_Frequency__c, Core_Shell_Cost_Parameter__r.Type1__c
                    from NCMT_Core_Shell_Cost_Detail__c 
                    where Project_Cost_Summary__r.Project_Name__c IN: projIds AND Replacement_Cost__c > 0]
            ){
                if (projReplace.get(d.Project_Cost_Summary__r.Project_Name__c) == null)
                    projReplace.put(d.Project_Cost_Summary__r.Project_Name__c, new List<replacementCost>());
                
                    projReplace.get(d.Project_Cost_Summary__r.Project_Name__c).add(new replacementCost(d));
            }

            for (NCMT_Other_Cost__c other : [Select Id, Frequency_Years__c, Total1__c, NCMT_Project__c, NCMT_Housing_Plan_Cost_Parameter__c 
                    from NCMT_Other_Cost__c 
                    where NCMT_Project__c IN: projIds AND
                    RecordType.DeveloperName = 'Other_Capital_Renewal_Cost' and Total1__c > 0]
            ){
                if (projReplace.get(other.NCMT_Project__c) == null)
                    projReplace.put(other.NCMT_Project__c, new List<replacementCost>());
                
                    projReplace.get(other.NCMT_Project__c).add(new replacementCost(other));
            }
            
            for (NCMT_Other_Cost__c other : [Select Id, NCMT_Housing_Plan_Option_Selection__c, NCMT_Project__c,
                    Unit_Rate__c, Housing_Plan_Option_Square_Footage__c , Total1__c,
                    NCMT_Housing_Plan_Cost_Parameter__c, RecordTypeId, Cost_Type__c,
                    NCMT_Housing_Plan_Option_Selection__r.TCO_Replacement_Every_X_Years__c,
                    NCMT_Housing_Plan_Option_Selection__r.TCO_Repair_Every_X_Years__c,
                    NCMT_Housing_Plan_Option_Selection__r.TCO_Repair_Cost_Percentage__c,
                    NCMT_Housing_Plan_Option_Selection__r.Recurs_on_TCO_Tenant_Refresh_Years__c,
                    Housing_Plan_Cost_Type__c
                from NCMT_Other_Cost__c where NCMT_Project__c IN: projIds 
                and NCMT_Housing_Plan_Cost_Parameter__c <> null]
            ){
                if (projReplace.get(other.NCMT_Project__c) == null)
                    projReplace.put(other.NCMT_Project__c, new List<replacementCost>());
                
                projReplace.get(other.NCMT_Project__c).add(new replacementCost(other));

                if (includeRefresh &&fitOutYears != 0
                    &&other.NCMT_Housing_Plan_Option_Selection__r.Recurs_on_TCO_Tenant_Refresh_Years__c
                ){
                    replacementCost o = new replacementCost(other);
                    o.replaceCycle = fitOutYears;
                    projReplace.get(other.NCMT_Project__c).add(o);
                }
                //Moving costs needs to be applied when operations begins as well.
                if (other.Housing_Plan_Cost_Type__c == 'Moving Costs'){
                    movingCosts += other.Total1__c;
                }

            }
        }

        List<NCMT_TCO_LCC__c> lccRecords = new List<NCMT_TCO_LCC__c>();
        List<NCMT_TCO_LCC__c> lccDeletes = new List<NCMT_TCO_LCC__c>();
        for (NCMT_TCO_Lifecycle_Input__c l : newList){
            NCMT_TCO_Lifecycle_Input__c life = projectMap.get(l.NCMT_Project__c).lifecycle;
            if (projectMap.get(l.NCMT_Project__c).record.End_Construction__c != null &&projectMap.get(l.NCMT_Project__c).record.Start_Construction__c != null){
                life.Construction__c = projectMap.get(l.NCMT_Project__c).record.Start_Construction__c.monthsBetween(projectMap.get(l.NCMT_Project__c).record.End_Construction__c);
            } else {
                life.Construction__c = 0;
            }

            if (needsRecalc){
                Map<Integer, NCMT_TCO_LCC> lccYearMap = new Map<Integer, NCMT_TCO_LCC>();
                for (NCMT_TCO_LCC lcc : projectMap.get(l.NCMT_Project__c).lccs){
                    if (lcc.record.Year__c > life.Period_of_Analysis__c){
                        lccDeletes.add(lcc.record);
                    } else {
                        lccYearMap.put(Integer.valueOf(lcc.record.Year__c), lcc);
                    }
                }
                
                Integer i = 1;
                Integer refresh;
                Integer retrofit;
                
                while (i <= life.Period_of_Analysis__c){
                    NCMT_TCO_LCC__c lcc = new NCMT_TCO_LCC__c(
                        NCMT_Project__c = l.NCMT_Project__c,
                        TCO_Lifecycle_Input__c = life.Id,
                        Year__c = i 
                    );
                    if (lccYearMap.get(i) != null) lcc = lccYearMap.get(i).record.clone(true, true);

                    //RecaclulateFormulas returns a null for start date even after the record is saved, as does querying and displaying it? 
                    //I don't know, easier to just use this
                    Date lccStart = Date.newInstance(Integer.valueOf(life.Start_Date__c.year() +lcc.Year__c - 1), Integer.valueOf(life.Start_Date__c.month()), Integer.valueOf(1));
                    Date lccEnd = lccStart.addYears(1).addDays(-1);
                    //lcc.recalculateFormulas();

                    //First year of operations? Set the clock
                    if (lccStart <= life.Start_for_Maintenance_Operations__c
                        &&lccEnd >= life.Start_for_Maintenance_Operations__c)
                    {
                        lcc.Moving_Cost__c = movingCosts;
                    } else {
                        lcc.Moving_Cost__c = 0;
                    }
                

                    //Reset
                    lcc.Refresh_Year__c = false;
                    lcc.Retrofit_Year__c = false;
                    if (life.Include_Tenant_Refresh_Costs__c 
                        //Only operational years count for refresh / retrofit
                        &&lccEnd >= life.Start_for_Maintenance_Operations__c
                        &&lccStart <= life.End_of_Maintenance_Operations__c
                        //Frankly, they're not likely to refresh or retrofit the last year of operations, 
                        //but let's not assume anything.
                    ){
                        
                        //First year of operations? Set the clock
                        if (lccStart <= life.Start_for_Maintenance_Operations__c
                            &&lccEnd >= life.Start_for_Maintenance_Operations__c
                        ){
                            refresh = 1;
                            retrofit = 1;
                        } else {
                            refresh++;
                            retrofit++;
                        }
                        System.debug('Before, year = ' +lcc.Year__c +' refresh === ' +refresh +' retrofit === ' +retrofit);
                        if (retrofit == life.New_fit_out_every_years__c){
                            lcc.Retrofit_Year__c = true;
                            refresh = 0;
                            retrofit = 0;
                            System.debug('retrofit year');
                        } else {
                            System.debug('not retrofit year');
                            if (refresh == life.Refresh_every_years__c){
                                lcc.Refresh_Year__c = true;
                                refresh = 0;
                            } else {
                                
                            }
                            
                        }
                    
                        
                    }


                    //Add up Replacement Costs
                    lcc.Replacement_Cost__c = 0;
                    lcc.Repair_Cost__c = 0;
                    Date endMaintenance = (life.Years_of_Routine_Periodic_Maint__c != null ? life.Start_for_Maintenance_Operations__c.addYears(Integer.valueOf(life.Years_of_Routine_Periodic_Maint__c)) : life.End_of_Maintenance_Operations__c);
                    
                    Date endMajor = (life.Years_of_Major_Maint_Replace__c != null ? life.Start_for_Maintenance_Operations__c.addYears(Integer.valueOf(life.Years_of_Major_Maint_Replace__c)) : life.End_of_Maintenance_Operations__c);
                    
                    //These fields being phasd out
                    if (life.Years_of_Routine_Periodic_Maint__c == null && life.End_Routine_Periodic_Maintenance_Early__c != null)
                        endMaintenance = (life.End_Routine_Periodic_Maintenance_Early__c != null ? life.End_of_Maintenance_Operations__c.addYears(Integer.valueOf(-1 * life.End_Routine_Periodic_Maintenance_Early__c)) : life.End_of_Maintenance_Operations__c);
                    if (life.Years_of_Major_Maint_Replace__c == null && life.End_Major_Maint_System_Replace_Early__c != null)
                        endMajor = (life.End_Major_Maint_System_Replace_Early__c != null ? life.End_of_Maintenance_Operations__c.addYears(Integer.valueOf(-1 * life.End_Major_Maint_System_Replace_Early__c)) : life.End_of_Maintenance_Operations__c);

                    if (projReplace.get(l.NCMT_Project__c) != null){
                        for (replacementCost r : projReplace.get(l.NCMT_Project__c)){
                            Date relevantEnd = life.End_of_Maintenance_Operations__c;
                            if (r.isMaintenance) relevantEnd = endMaintenance;
                            if (r.isMajorRepair) relevantEnd = endMajor;
                            if (lccEnd >= life.Start_for_Maintenance_Operations__c
                                &&lccStart <= relevantEnd
                            ){
                                
                                //First year of operations? Set the clock
                                if (lccStart <= life.Start_for_Maintenance_Operations__c
                                    &&lccEnd >= life.Start_for_Maintenance_Operations__c
                                ){
                                    r.replaceCycle = 1;
                                    r.repairCycle = 1;
                                } else {
                                    r.replaceCycle++;
                                    r.repairCycle++;
                                }
                                if (r.replaceCycle == r.replacementYear){
                                    lcc.Replacement_Cost__c += r.amount;
                                    r.replaceCycle = 0;
                                } 
                                if (r.repairCycle == r.repairYear){
                                    lcc.Repair_Cost__c += r.repairAmount;
                                    r.repairCycle = 0;
                                }
                            }
                        }
                    }

                    //Calculate how many months fall into the different construction phases
                    //lcc.recalculateFormulas();
                    Date preDesignEnd = life.Design_Start__c;
                    Date designEnd = life.Construction_Start__c;

                    
                    Date constructionEnd = life.Construction_Start__c.addMonths(Integer.valueOf(life.Construction__c));
                    System.debug('lccStart == ' +lccStart +' lccEnd  == ' +lccEnd +' preDesignEnd == ' +preDesignEnd +' life.Planning_and_Pre_design_Start__c == ' +life.Planning_and_Pre_design_Start__c);
                    if (lccStart <= preDesignEnd //&&lccStart >= life.Planning_and_Pre_design_Start__c
                        &&lccEnd >= life.Planning_and_Pre_design_Start__c 
                    ){
                        Date startDte = (lccStart > life.Planning_and_Pre_design_Start__c ? lccStart : life.Planning_and_Pre_design_Start__c);
                        Date endDte = (lccEnd > preDesignEnd ? preDesignEnd : lccEnd.addDays(1));
                        lcc.Months_Pre_Design__c = startDte.monthsBetween(endDte);
                    } else {
                        lcc.Months_Pre_Design__c = 0;
                    }

                    if (lccStart <= designEnd //&&lccStart >= life.Design_Start__c
                        &&lccEnd >= life.Design_Start__c 
                    ){
                        Date startDte = (lccStart > life.Design_Start__c ? lccStart : life.Design_Start__c);
                        Date endDte = (lccEnd > designEnd ? designEnd : lccEnd.addDays(1));
                        lcc.Months_Design__c = startDte.monthsBetween(endDte);
                    } else {
                        lcc.Months_Design__c = 0;
                    }
                    if (lccStart <= constructionEnd 
                        &&lccEnd >= life.Construction_Start__c 
                    ){
                        Date startDte = (lccStart > life.Construction_Start__c ? lccStart : life.Construction_Start__c);
                        Date endDte = (lccEnd > constructionEnd ? constructionEnd : lccEnd.addDays(1));
                        
                        lcc.Months_Construction__c = startDte.monthsBetween(endDte);
                    } else {
                        lcc.Months_Construction__c = 0;
                    }
                    
                    if (lccStart <= life.End_of_Maintenance_Operations__c 
                        &&lccEnd >= life.Start_for_Maintenance_Operations__c 
                    ){
                        Date startDte = (lccStart > life.Start_for_Maintenance_Operations__c ? lccStart : life.Start_for_Maintenance_Operations__c);
                        Date endDte = (lccEnd > life.End_of_Maintenance_Operations__c ? life.End_of_Maintenance_Operations__c : lccEnd.addDays(1));
                        
                        lcc.Months_Operational__c = startDte.monthsBetween(endDte);
                    } else {
                        lcc.Months_Operational__c = 0;
                    }

                    lccRecords.add(lcc);
                    i++;
                }//end years to analyze loop

            }//end if lcc inserts/updates required
            upsert lccRecords;
            delete lccDeletes;

            //Requery to get formula calculations and total them since RecaclulateFormulas has been weird
            String soql = 'Select ' +NCMT_Utilities.getFieldSoQL('NCMT_TCO_LCC__c');
            soql += ' from NCMT_TCO_LCC__c where TCO_Lifecycle_Input__c = \'' +life.Id +'\' Order By Year__c';
            life.Total_Construction__c = 0;
            life.Total_Operations_Maintenance__c = 0;
            life.Total_Replacement__c = 0;
            life.Total_TI_CRR__c = 0;
            life.Total_Utilities__c = 0;
            life.Total_Cost__c = 0;
            life.Total_Escalated_Discounted__c = 0;
            life.Total_Escalated__c = 0;


            //These fields being phasd out
            if (life.Years_of_Routine_Periodic_Maint__c == null && life.End_Routine_Periodic_Maintenance_Early__c != null)
                life.Years_of_Routine_Periodic_Maint__c = life.End_of_Maintenance_Operations__c.year() - life.End_of_Maintenance_Operations__c.year() - life.End_Routine_Periodic_Maintenance_Early__c;
            if (life.Years_of_Major_Maint_Replace__c == null && life.End_Major_Maint_System_Replace_Early__c != null)
                life.Years_of_Major_Maint_Replace__c = life.End_of_Maintenance_Operations__c.year() - life.End_of_Maintenance_Operations__c.year() - life.End_Major_Maint_System_Replace_Early__c;

            
            for (NCMT_TCO_LCC__c lcc : Database.query(soql)){
                life.Total_Construction__c += lcc.Construction_Cost__c;
                life.Total_Operations_Maintenance__c += lcc.Utilities_Cost__c;
                life.Total_Replacement__c += lcc.Replacement_Cost__c;
                life.Total_TI_CRR__c += lcc.TI_CRR_Cost__c;
                life.Total_Utilities__c += lcc.Utilities_Cost__c;
                life.Total_Cost__c += lcc.Total_Cost__c;
                life.Total_Escalated_Discounted__c += lcc.Operations_Maint_Esc_Discounted__c +lcc.Utilities_Escalated_Discounted__c + lcc.TI_CRR_Escalated_Discounted_Cost__c +lcc.Replacement_Escalated_Discounted_Cost__c + lcc.Construction_Escalated_Discounted_Cost__c;
                life.Total_Escalated__c += lcc.Operations_Maintenance_Escalated__c + lcc.Utilities_Escalated__c +lcc.TI_CRR_Escalated_Cost__c + lcc.Replacement_Escalated_Cost__c + lcc.Construction_Escalated_Cost__c;
            }
            triggerHandlerUpdate = true;
            update life;

        }


    }

    public class replacementCost{
        public Integer replacementYear {get;set;}
        public Integer replaceCycle {get;set;}
        public Integer repairYear {get;set;}
        public Integer repairCycle {get;set;}
        public Boolean isMajorRepair {get;set;}
        public Boolean isMaintenance {get;set;}
        public Decimal amount {get;set;}
        public Decimal repairAmount {get;set;}

        public replacementCost(NCMT_Core_Shell_Cost_Detail__c d){
            replacementYear = Integer.valueOf(d.Replacement_Frequency__c);
            amount = d.Replacement_Cost__c;
            isMajorRepair = (d.Core_Shell_Cost_Parameter__r.Type1__c == 'Major Repair');
            isMaintenance = (d.Core_Shell_Cost_Parameter__r.Type1__c == 'Maintenance');
        }
        
        public replacementCost(NCMT_Other_Cost__c o){
            amount = o.Total1__c;
            isMajorRepair = false;
            if (o.NCMT_Housing_Plan_Cost_Parameter__c != null){
                replacementYear = Integer.valueOf(o.NCMT_Housing_Plan_Option_Selection__r.TCO_Replacement_Every_X_Years__c);
                isMaintenance = (o.NCMT_Housing_Plan_Option_Selection__r.TCO_Replacement_Every_X_Years__c != 0);
                repairYear = Integer.valueOf(o.NCMT_Housing_Plan_Option_Selection__r.TCO_Repair_Every_X_Years__c);
                repairAmount = o.NCMT_Housing_Plan_Option_Selection__r.TCO_Repair_Cost_Percentage__c * o.Total1__c;
            } else {
                replacementYear = Integer.valueOf(o.Frequency_Years__c);
                
                
                isMaintenance = false;
            }
            
        }
    }
}