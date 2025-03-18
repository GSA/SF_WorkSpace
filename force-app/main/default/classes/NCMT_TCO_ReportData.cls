public with sharing class NCMT_TCO_ReportData {

    @AuraEnabled public List<String> headers {get;set;}
    @AuraEnabled public List<NCMT_Report_ProjectComparisonRow> rows {get;set;}
    @AuraEnabled public List<NCMT_Report_Section> sections {get;set;}
    //@AuraEnabled public String sectionJSON {get;set;} //component not seeing sections, can't see inner classes? Oh well
    @AuraEnabled public List<NCMT_TCO_Project> projects {get;set;}  
    @AuraEnabled public List<Id> projIds {get;set;} 

    public NCMT_TCO_ReportData(List<Id> projIds, List<SectionSpec> sectionSpecs, String reportMode, String costType){
        this.projIds = projIds;

        //Check if LCC summary data should be compiled for projects
        Boolean needLCC = false;
        
        sections = new List<NCMT_Report_Section>();
        for (SectionSpec s : sectionSpecs){
            for (DataSpec r : s.dataSpecs){
                if (r.lccGrouping != null &&r.lccGrouping != '') needLCC = true;
            }
        }
        projects = new List<NCMT_TCO_Project>();
        headers = new List<String>();
        
        for (Id projId : projIds){
            NCMT_TCO_Project proj = new NCMT_TCO_Project(projId, needLCC);
            headers.add(proj.record.name);
            projects.add(proj);
        }
        for (SectionSpec s : sectionSpecs){
            NCMT_Report_Section section = new NCMT_Report_Section(s.headerLabel);
            section.defaultExpanded = s.defaultExpanded;
            for (DataSpec dataSpec : s.dataSpecs){
                System.debug('dataSpec.................. ' +dataSpec);
                //Move data cell data to chart if there is one
                if (dataSpec.chartType != null){
                    List<String> projectColors = new List<String>{'#3e95cd', '#8e5ea2','#3cba9f','#e8c3b9','#c45850'};
                    //Currently the only data being charted...
                    if (dataSpec.lccGrouping != null &&dataSpec.lccGrouping != ''){
                        //Only one category per chart right now....
                        String cat;
                        for (String c : dataSpec.categoryFilters){
                            cat = c;
                        }
                        
                        NCMT_Chart_JS chartJS = new NCMT_Chart_JS(dataSpec.chartType);
                        chartJS.uniqueId = dataSpec.chartType +cat;
                        Map<Id, Map<String, Double>> projValues = new Map<Id, Map<String, Double>>();
                        Map<String, Map<String, Double>> catValues = new Map<String, Map<String, Double>>();
                        Set<String> dates = new Set<String>();
                        NCMT_Report_ProjectComparisonRow row;
                        if (reportMode == 'comparison'){
                            row = new NCMT_Report_ProjectComparisonRow();
                            row.headerCol = (cat == null ? 'Total Costs' : cat);
                        }
                        for (NCMT_TCO_Project proj : projects){
                            
                            if (projValues.get(proj.record.Id) == null) 
                                projValues.put(proj.record.Id, new Map<String,Double>());
                            
                            
                            for (NCMT_TCO_LCC lcc : proj.lccs){
                                if (cat == null &&reportMode == 'comparison'){
                                    
                                    if (costType == 'escalatedDiscountedCost'){
                                        projValues.get(proj.record.Id).put(lcc.stringYear, lcc.totalEscalatedDiscounted);
                                    } else if (costType == 'escalatedCost') {
                                        projValues.get(proj.record.Id).put(lcc.stringYear, lcc.totalEscalated);
                                    } else {
                                        projValues.get(proj.record.Id).put(lcc.stringYear, lcc.totalCost);
                                    }
                                    dates.add(lcc.stringYear);
                                } else {
                                    for (NCMT_TCO_LCC.Category projCat : lcc.categories){
                                        if (cat == null){
                                            if (catValues.get(projCat.name) == null){
                                                catValues.put(projCat.name, new Map<String, Double>());
                                            }
                                        
                                            if (costType == 'escalatedDiscountedCost'){
                                                catValues.get(projCat.name).put(lcc.stringYear, projCat.escalatedDiscountedCost);
                                            } else if (costType == 'escalatedCost') {
                                                catValues.get(projCat.name).put(lcc.stringYear, projCat.escalatedCost);
                                            } else {
                                                catValues.get(projCat.name).put(lcc.stringYear, projCat.cost);
                                            }
                                            
                                            dates.add(lcc.stringYear);
                                            
                                        } else {
                                            if (dataSpec.categoryFilters.contains(projCat.name)
                                            ){
                                                if (costType == 'escalatedDiscountedCost'){
                                                    projValues.get(proj.record.Id).put(lcc.stringYear, projCat.escalatedDiscountedCost);
                                                } else if (costType == 'escalatedCost') {
                                                    projValues.get(proj.record.Id).put(lcc.stringYear, projCat.escalatedCost);
                                                } else {
                                                    projValues.get(proj.record.Id).put(lcc.stringYear, projCat.cost);
                                                }
                                                
                                                dates.add(lcc.stringYear);
                                            }
                                        }
                                    }//end category loop
                                }
                            }
                            
                        }
                        List<String> labels = new List<String>();
                        labels.addAll(dates);
                        labels.sort();
                        chartJS.data.labels = labels;
                        chartJS.options.title.text = (cat == null ? 'Totals' : cat);
                        Integer dataTrack = 0;
                        for (NCMT_TCO_Project proj : projects){
                            
                            if (dataSpec.groupProjects){
                                chartJS.data.datasets.add(new NCMT_Chart_JS.Dataset());
                                chartJS.data.datasets[dataTrack].label = proj.record.name +' Cost';
                            } else {
                                chartJS = new NCMT_Chart_JS(dataSpec.chartType);
                                chartJS.uniqueId = dataSpec.chartType +cat +proj.record.Id;
                                chartJS.data.labels = labels;
                                chartJS.data.datasets.add(new NCMT_Chart_JS.Dataset());
                                chartJS.data.datasets[dataTrack].label = 'Cost';
                                chartJS.options.title.text = (cat == null ? 'Total Costs' : cat);
                            }

                            //Specific to creating stacked bars 
                            Map<String, Integer> catNum = new Map<String, Integer>();
                            if (reportMode != 'comparison' &&cat == null){
                                chartJS.options.legend.display = true;

                                NCMT_Chart_JS.Axis a = new NCMT_Chart_JS.Axis();
                                a.stacked = true;
                                chartJS.options.scales.xAxes.add(a);
                                chartJS.options.scales.yAxes.add(a.clone());
                                Integer i = 0;  
                                for (String c : catValues.keySet()){
                                    catNum.put(c, i);
                                    i++;
                                }
                            }
                            for (String y : labels){
                                if (reportMode != 'comparison' &&cat == null){
                                    
                                    for (String c : catValues.keySet()){
                                        Double val = 0;
                                        if (catValues.get(c).keySet().contains(y)){
                                            val = catValues.get(c).get(y);
                                        
                                            if (chartJS.data.datasets.size() < (catNum.get(c) + 1))
                                                chartJS.data.datasets.add(new NCMT_Chart_JS.Dataset());
                                            
                                            chartJS.data.datasets[catNum.get(c)].label = c;

                                            chartJS.data.datasets[catNum.get(c)].data.add(val);
                                            chartJS.data.datasets[catNum.get(c)].backgroundColor.add(projectColors[catNum.get(c)]);
                                        }
                                    }
                                } else {
                                    Double val = 0;
                                    if (projValues.get(proj.record.Id).get(y) != null)
                                        val = projValues.get(proj.record.Id).get(y);

                                    chartJS.data.datasets[dataTrack].data.add(val);
                                    chartJS.data.datasets[dataTrack].backgroundColor.add(projectColors[dataTrack]);
                                }   
                            }
                            if (reportMode == 'comparison'){
                                dataTrack++;
                                row.isGroupdProjectRow = true;
                            } else {
                                //chartJS.jsonIfy();
                                section.charts.add(chartJS);
                            }
                        }
                        if (reportMode == 'comparison' &&dataSpec.groupProjects){
                            chartJS.options.legend.display = true;
                            row.charts.add(chartJS);
                        }
                        if (reportMode == 'comparison')
                            section.rows.add(row);
                        
                    }
                    

                } else {
                    
                    /*Objects that are their own beast
                    if (dataSpec.objectName == 'NCMT_Project_Cost_Summary__c'){
                        
                        if (reportMode == 'comparison'){
                            List<NCMT_Report_ProjectComparisonRow> costRows = (List<NCMT_Report_ProjectComparisonRow>)tcoCostRatesHelper(reportMode);
                            section.rows.addAll(costRows);
                        } else {
                            List<NCMT_Report_DataCell> costCells = (List<NCMT_Report_DataCell>)tcoCostRatesHelper(reportMode);
                            section.dataCells.addAll(costCells);
                        }
                    //HOUSING PLAN ROWS
                    } else*/ 
                    if (dataSpec.objectName == 'NCMT_TCO_HP_Level_of_Service__c'){
                        
                        
                        if (reportMode == 'comparison'){
                            List<NCMT_Report_ProjectComparisonRow> hpRows = (List<NCMT_Report_ProjectComparisonRow>)tcoHPHelper(reportMode);
                            section.rows.addAll(hpRows);
                        } else {
                            List<NCMT_Report_DataCell> hpCells = (List<NCMT_Report_DataCell>)tcoHPHelper(reportMode);
                            section.dataCells.addAll(hpCells);
                        }

                    //STORY DATA
                    } else if (dataSpec.objectName == 'NCMT_Building_Massing_By_Floor__c'){
                        
                        if (reportMode == 'comparison'){
                            List<NCMT_Report_ProjectComparisonRow> storyRows = (List<NCMT_Report_ProjectComparisonRow>)tcoStoriesHelper(reportMode);
                            section.rows.addAll(storyRows);
                        } else {
                            List<NCMT_Report_DataCell> storyCells = (List<NCMT_Report_DataCell>)tcoStoriesHelper(reportMode);
                            section.dataCells.addAll(storyCells);
                        }

                    //DATA FROM FIELD SETS
                    } else if (dataSpec.fieldSetName != null && dataSpec.fieldSetName != ''){
                        
                        if (reportMode == 'comparison'){
                            List<NCMT_Report_ProjectComparisonRow> fieldSetRows = (List<NCMT_Report_ProjectComparisonRow>)tcoFieldSetHelper(reportMode, dataSpec);
                            section.rows.addAll(fieldSetRows);
                        } else {
                            List<NCMT_Report_DataCell> fieldSetCells = (List<NCMT_Report_DataCell>)tcoFieldSetHelper(reportMode, dataSpec);
                            section.dataCells.addAll(fieldSetCells);
                        }
                    
                    //DATA FROM LCC DATA
                    } else if (dataSpec.lccGrouping != null &&dataSpec.lccGrouping != '') {
                        
                        if (reportMode == 'comparison'){
                            List<NCMT_Report_ProjectComparisonRow> lccRows = (List<NCMT_Report_ProjectComparisonRow>)tcoLCCHelper(reportMode, dataSpec, costType);
                            section.rows.addAll(lccRows);
                        } else {
                            List<NCMT_Report_DataCell> lccCells = (List<NCMT_Report_DataCell>)tcoLCCHelper(reportMode, dataSpec, costType);
                            section.dataCells.addAll(lccCells);
                        }
                    }//end if LCC data
                    
                    

                }
            }//end dataSpecs loop
            sections.add(section);
        }//end section spec loop
        
        
        
        //sectionJSON = JSON.serialize(sections);
        
    }//end ComparisonData()

    /*Not used, but maybe it will be
    Helper classes return either a list of rows or a data cells
    //Depending on the reportMode (comparison or detail)
    public List<Object> tcoCostRatesHelper(String reportMode){
        List<NCMT_Report_ProjectComparisonRow> rows = new List<NCMT_Report_ProjectComparisonRow>();
        List<NCMT_Report_DataCell> cells = new List<NCMT_Report_DataCell>();

        Map<Id, Map<String, Double>> coreShellByProj = new Map<Id, Map<String, Double>>();

        //May add some sort of filtering mechanism here, we'll see
        //Sums up Core_Shell_Total_Cost__c by project and cost category
        Set<String> costCats = new Set<String>();
        for (NCMT_Project_Cost_Summary__c costDetail : [Select Id, Core_Shell_Total_Cost__c, Project_Name__c, Cost_Category_Description__c
                from NCMT_Project_Cost_Summary__c where Project_Name__c IN: projIds]
        ){
            
            if (coreShellbyProj.get(costDetail.Project_Name__c) == null) 
                coreShellbyProj.put(costDetail.Project_Name__c, new Map<String, Double>());
            if (coreShellbyProj.get(costDetail.Project_Name__c).get(costDetail.Cost_Category_Description__c) == null) 
                coreShellbyProj.get(costDetail.Project_Name__c).put(costDetail.Cost_Category_Description__c, 0);

            coreShellbyProj.get(costDetail.Project_Name__c).put(costDetail.Cost_Category_Description__c,
                coreShellbyProj.get(costDetail.Project_Name__c).get(costDetail.Cost_Category_Description__c) + costDetail.Core_Shell_Total_Cost__c
            );

            costCats.add(costDetail.Cost_Category_Description__c);
        }
        
        //Bring it together, sorted alphabetically for now
        List<String> catList = new List<String>();
        catList.addAll(costCats);
        catList.sort();
        for (String cat : catList){
            NCMT_Report_ProjectComparisonRow row = new NCMT_Report_ProjectComparisonRow();
            
            NCMT_Report_ValueMetaData valueMeta = new NCMT_Report_ValueMetaData();
            valueMeta.dataType = 'number';
            valueMeta.numberStyle = 'currency';

            if (reportMode == 'comparison'){
                row.headerCol = cat;
                row.valueMeta = valueMeta;
            }

            for (NCMT_TCO_Project proj : projects){
                NCMT_Report_DataCell cell = new NCMT_Report_DataCell();
                cell.value = 0;
                if (coreShellByProj.get(proj.record.Id) != null &&coreShellByProj.get(proj.record.Id).get(cat) != null)
                    cell.value = coreShellByProj.get(proj.record.Id).get(cat);

                if (reportMode == 'comparison'){
                    row.cells.add(cell);
                } else {
                    cell.valueMeta = valueMeta;
                    cells.add(cell);
                }
            }
            rows.add(row);
        }
        if (reportMode == 'comparison'){
            return rows;
        } else {
            return cells;
        }
    }*/

    public List<Object> tcoFieldSetHelper(String reportMode, DataSpec dataSpec){
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(dataSpec.objectName);

        Map<Id, Map<String, Double>> projRecords = new Map<Id, Map<String, Double>>();
        
        
        /* Not needed, but keep just in case...
        Boolean useSummaryValue = false;

        //Sum records together into 1
        //Project Paramenters, but should work for about anything with some tweaks
        if (dataSpec.objectName == 'Project_Level_Parameter__c'){
            useSummaryValue = true;
            String soql = 'Select Id';
            for(Schema.FieldSetMember fieldMember : sObjType.getDescribe().fieldSets.getMap().get(dataSpec.fieldSetName).getFields())
                soql += ', ' +fieldMember.getFieldPath();

            soql += ', NCMT_Project__c';
            soql += ' from Project_Level_Parameter__c where NCMT_Project__c IN: projIds';
            for (SObject sobj : Database.query(soql)){
            
                if (projRecords.get(String.valueOf(sobj.get('NCMT_Project__c'))) == null){
                    projRecords.put(String.valueOf(sobj.get('NCMT_Project__c')), new Map<String, Double>());
                } 

                for(Schema.FieldSetMember fieldMember : sObjType.getDescribe().fieldSets.getMap().get(dataSpec.fieldSetName).getFields()){
                    if (projRecords.get(String.valueOf(sobj.get('NCMT_Project__c'))).get(fieldMember.getFieldPath()) == null){
                        projRecords.get(String.valueOf(sobj.get('NCMT_Project__c'))).put(fieldMember.getFieldPath(), 0);
                    }
                    Double prevVal = projRecords.get(String.valueOf(sobj.get('NCMT_Project__c'))).get(fieldMember.getFieldPath());
                    projRecords.get(String.valueOf(sobj.get('NCMT_Project__c'))).put(fieldMember.getFieldPath(), prevVal + Double.valueOf(sobj.get(fieldMember.getFieldPath())));

                }

            }
        }*/
        
        List<NCMT_Report_DataCell> cells = new List<NCMT_Report_DataCell>();
        List<NCMT_Report_ProjectComparisonRow> rows = new List<NCMT_Report_ProjectComparisonRow>();
        for(Schema.FieldSetMember fieldMember : sObjType.getDescribe().fieldSets.getMap().get(dataSpec.fieldSetName).getFields()){
            NCMT_Report_ProjectComparisonRow row = new NCMT_Report_ProjectComparisonRow();
            
            row.valueMeta = new NCMT_Report_ValueMetaData(fieldMember);
            row.headerCol = row.valueMeta.fieldLabel;
            for (NCMT_TCO_Project proj : projects){                        
                SObject sobj;
                
                NCMT_Report_DataCell cell = new NCMT_Report_DataCell();
                /*if (useSummaryValue){
                    if (projRecords.get(proj.record.Id) != null 
                        &&projRecords.get(proj.record.Id).get(fieldMember.getFieldPath()) != null
                    ){
                        NCMT_Report_ValueMetaData meta = new NCMT_Report_ValueMetaData(fieldMember);
                        Object cellVal = projRecords.get(proj.record.Id).get(fieldMember.getFieldPath());
                        if (cellVal != null &&meta.dataType == 'number' &&meta.numberStyle == 'percent'){
                            Double dbl = Double.valueOf(cellVal);
                            dbl = dbl / 100;
                            cellVal = dbl;
                        }
                        cell.value = cellVal;
                        cell.valueMeta = meta;
                    } 
                        
                } else {*/
                    switch on dataSpec.objectName{
                        when 'NCMT_Project__c'{
                            sobj = proj.record;
                        }
                        when 'NCMT_TCO_Annual_Cost_Summary__c'{
                            sobj = proj.annualCost;
                        }
                        when 'NCMT_Project_Cost_Rate__c'{
                            sobj = proj.costRates;
                        }
                        when 'NCMT_TCO_Lifecycle_Input__c'{
                            sobj = proj.lifeCycle;
                        } 
                        when 'Project_Level_Parameter__c'{
                            sobj = proj.projectParam;
                        }
                    }
                
                    //Just in case a record is missing...
                    if (sobj != null)
                        cell = new NCMT_Report_DataCell(sobj, row.valueMeta, reportMode == 'details');
                    
                //}
                if (reportMode == 'comparison'){
                    row.cells.add(cell);
                } else {
                    cells.add(cell);
                }
                System.debug('row after dataCell add.................. ' +row);
            }//end project loop
            if (reportMode == 'comparison')
                rows.add(row);
        }//end field set member loop
        if (reportMode == 'comparison'){
            return rows;
        } else {
            return cells;
        }
    }

    public List<Object> tcoLCCHelper(String reportMode, Dataspec dataspec, String costType){
        List<NCMT_Report_ProjectComparisonRow> rows = new List<NCMT_Report_ProjectComparisonRow>();
        List<NCMT_Report_DataCell> cells = new List<NCMT_Report_DataCell>();

        //Using this for category and cost names...
        System.debug('projects[0].totalLCC ===== ' +projects[0].totalLCC);
        for (NCMT_TCO_LCC.Category category : projects[0].totalLCC.categories){
            System.debug('category +++++++++ ' +category);
            if (dataSpec.lccGrouping == 'categories'){
                NCMT_Report_ProjectComparisonRow row = new NCMT_Report_ProjectComparisonRow();
                NCMT_Report_ValueMetaData valueMeta = new NCMT_Report_ValueMetaData();
                valueMeta.dataType = 'number';
                valueMeta.numberStyle = 'currency';
                valueMeta.maximumFractionDigits = 0;

                Boolean display = false;

                for (NCMT_TCO_Project proj : projects){
                    System.debug('project loop === ' +proj.record.name +' ' +proj.totalLCC.categories.size());
                    for (NCMT_TCO_LCC.Category projCat : proj.totalLCC.categories){
                        if (projCat.name == category.name
                            &&(dataSpec.categoryFilters.size() == 0 ||
                                dataSpec.categoryFilters.contains(projCat.name))
                        ){
                            display = true;

                            if (reportMode == 'comparison'){
                                row.headerCol = category.name;
                                row.valueMeta = valueMeta;
                            } else {
                                valueMeta.fieldLabel = category.name;
                            }
                            NCMT_Report_DataCell cell = new NCMT_Report_DataCell();

                            if (costType == 'escalatedCost'){
                                cell.value = projCat.escalatedCost;
                            } else if (costType == 'escalatedDiscountedCost'){
                                cell.value = projCat.escalatedDiscountedCost;
                            } else {
                                cell.value = projCat.cost;
                            }
                            if (reportMode == 'comparison'){
                                row.cells.add(cell);
                                System.debug('adding category cell ============== ' +category.name +' ' +cell);
                            } else {
                                cell.valueMeta = valueMeta;
                                cells.add(cell);
                            }
                            
                        }
                    }
                }//end project loop for categories

                if (reportMode == 'comparison' &&display){
                    rows.add(row);
                    
                }
            }//end if displaying categories

            if (dataSpec.lccGrouping == 'costs'){
                

                for (NCMT_TCO_LCC.Cost cost : category.costs){
                    NCMT_Report_ProjectComparisonRow row = new NCMT_Report_ProjectComparisonRow();
                    NCMT_Report_ValueMetaData valueMeta = new NCMT_Report_ValueMetaData();
                    valueMeta.dataType = 'number';
                    valueMeta.numberStyle = 'currency';
                    valueMeta.maximumFractionDigits = 0;

                    if (reportMode == 'comparison'){
                        row.headerCol = cost.label;
                        row.valueMeta = valueMeta;
                    } else {
                        valueMeta.fieldLabel = cost.label;
                    }

                    Boolean display = false;

                    for (NCMT_TCO_Project proj : projects){
                        for (NCMT_TCO_LCC.Category projCat : proj.totalLCC.categories){
                            if (projCat.name == category.name
                                &&(dataSpec.categoryFilters.size() == 0 ||
                                dataSpec.categoryFilters.contains(projCat.name))
                            ){

                                for (NCMT_TCO_LCC.Cost projCost : projCat.costs){
                                    if (projCost.label == cost.label
                                        &&(dataSpec.costFilters.size() == 0 ||
                                        dataSpec.costFilters.contains(projCost.label))
                                    ){
                                        display = true;

                                        NCMT_Report_DataCell cell = new NCMT_Report_DataCell();

                                        if (costType == 'escalatedCost'){
                                            cell.value = projCost.escalatedCost;
                                        } else if (costType == 'escalatedDiscountedCost'){
                                            cell.value = projCost.escalatedDiscountedCost;
                                        } else {
                                            cell.value = projCost.cost;
                                        }
                                        if (reportMode == 'comparison'){
                                            row.cells.add(cell);
                                        } else {
                                            cell.valueMeta = valueMeta;
                                            cells.add(cell);
                                        }
                                    }
                                }
                                
                            }//end if cost being displayed
                        }
                    }//end project loop
                    if (reportMode == 'comparison' &&display)
                        rows.add(row);
                }//end cost loop
                
            }//end if displaying costs
        }//end category loop
        
        if (reportMode == 'comparison'){
            return rows;
        } else {
            return cells;
        }
    }

    public List<Object> tcoStoriesHelper(String reportMode){
        List<NCMT_Report_ProjectComparisonRow> rows = new List<NCMT_Report_ProjectComparisonRow>();
        List<NCMT_Report_DataCell> cells = new List<NCMT_Report_DataCell>();

        Map<Id, Map<String, Double>> projStorySF = new Map<Id, Map<String, Double>>();
        Set<String> floors = new Set<String>();
        for (NCMT_Building_Massing_By_Floor__c floor : [Select Building_Massing_Area__c, Use_Area_SF__c, NCMT_Project_ID__c
                                                        from NCMT_Building_Massing_By_Floor__c 
                                                        where NCMT_Project_ID__c IN: projIds]
        ){
            if (projStorySF.get(floor.NCMT_Project_ID__c) == null) projStorySF.put(floor.NCMT_Project_ID__c, new Map<String, Double>());
            //I don't know that the same project will have the same floor multiple times, but let's assume nothing
            if (projStorySF.get(floor.NCMT_Project_ID__c).get(floor.Building_Massing_Area__c) == null) 
                projStorySF.get(floor.NCMT_Project_ID__c).put(floor.Building_Massing_Area__c, 0);
            
            projStorySF.get(floor.NCMT_Project_ID__c).put(floor.Building_Massing_Area__c, 
                projStorySF.get(floor.NCMT_Project_ID__c).get(floor.Building_Massing_Area__c) +floor.Use_Area_SF__c);
            
            floors.add(floor.Building_Massing_Area__c);
        }

        List<String> floorList = new List<String>();
        floorList.addAll(floors);
        floorList.sort();
        for (String floor : floorList){
            NCMT_Report_ProjectComparisonRow row = new NCMT_Report_ProjectComparisonRow();
                
            NCMT_Report_ValueMetaData valueMeta = new NCMT_Report_ValueMetaData();
            valueMeta.dataType = 'number';
            valueMeta.numberStyle = 'decimal';

            if (reportMode == 'comparison'){
                row.headerCol = floor;
                row.valueMeta = valueMeta;
            }

            for (NCMT_TCO_Project proj : projects){
                NCMT_Report_DataCell cell = new NCMT_Report_DataCell();
                cell.value = 0;
                if (projStorySF.get(proj.record.Id) != null &&projStorySF.get(proj.record.Id).get(floor) != null)
                    cell.value = projStorySF.get(proj.record.Id).get(floor);

                if (reportMode == 'comparison'){
                    row.cells.add(cell);
                } else {
                    cell.valueMeta = valueMeta;
                    cell.valueMeta.fieldLabel = floor;
                    cells.add(cell);
                }
            }

            if (reportMode == 'comparison'){
                rows.add(row);
            }
        }
        if (reportMode == 'comparison'){
            return rows;
        } else {
            return cells;
        }
    }

    public List<Object> tcoHPHelper(String reportMode){
        List<NCMT_Report_ProjectComparisonRow> rows = new List<NCMT_Report_ProjectComparisonRow>();
        List<NCMT_Report_DataCell> cells = new List<NCMT_Report_DataCell>();

        Map<Id, Map<String, Double>> usfByProj = new Map<Id, Map<String, Double>>();
        Map<Id, Map<String, String>> janByProj = new Map<Id, Map<String, String>>();
        Map<Id, Map<String, String>> effByProj = new Map<Id, Map<String, String>>();
        
        //Gathers NCMT_TCO_HP_Level_of_Service__c data to display
        Set<String> hps = new Set<String>();
        for (NCMT_TCO_HP_Level_of_Service__c hp : [Select Id, USF__c, Project_Name__c, 
                Space_Type__c, Janitorial_Cleanliness__c, Operational_efficiency__c
                from NCMT_TCO_HP_Level_of_Service__c where Project_Name__c IN: projIds]
        ){
            
            if (usfByProj.get(hp.Project_Name__c) == null){
                usfByProj.put(hp.Project_Name__c, new Map<String, Double>());
                janByProj.put(hp.Project_Name__c, new Map<String, String>());
                effByProj.put(hp.Project_Name__c, new Map<String, String>());
            }
            usfByProj.get(hp.Project_Name__c).put(hp.Space_Type__c, hp.USF__c);
            janByProj.get(hp.Project_Name__c).put(hp.Space_Type__c, hp.Janitorial_Cleanliness__c);
            effByProj.get(hp.Project_Name__c).put(hp.Space_Type__c, hp.Operational_efficiency__c);
            
            hps.add(hp.Space_Type__c);
        }
        
        //Bring it together, sorted alphabetically for now
        List<String> hpList = new List<String>();
        hpList.addAll(hps);
        hpList.sort();
        for (String hp : hpList){
            //Square Footage Row/cells
            NCMT_Report_ProjectComparisonRow row = new NCMT_Report_ProjectComparisonRow();
                
            NCMT_Report_ValueMetaData valueMeta = new NCMT_Report_ValueMetaData();
            valueMeta.dataType = 'number';
            valueMeta.numberStyle = 'decimal';
            valueMeta.fieldLabel = hp +' - USF';

            if (reportMode == 'comparison'){
                row.headerCol = hp +' - USF';
                row.valueMeta = valueMeta;
            } 

            for (NCMT_TCO_Project proj : projects){
                NCMT_Report_DataCell cell = new NCMT_Report_DataCell();
                cell.value = 0;
                if (usfByProj.get(proj.record.Id) != null &&usfByProj.get(proj.record.Id).get(hp) != null)
                    cell.value = usfByProj.get(proj.record.Id).get(hp);

                if (reportMode == 'comparison'){
                    row.cells.add(cell);
                } else {
                    cell.valueMeta = valueMeta;
                    cells.add(cell);
                }
            }
            

            //Cleanliness LOS Row
            valueMeta = new NCMT_Report_ValueMetaData();
            valueMeta.dataType = 'text';
            valueMeta.fieldLabel = hp +' - Cleaning LOS';
            if (reportMode == 'comparison'){
                rows.add(row);
                row = new NCMT_Report_ProjectComparisonRow();
                row.headerCol = hp +' - Cleaning LOS';
                row.valueMeta = valueMeta;
            }

            for (NCMT_TCO_Project proj : projects){
                NCMT_Report_DataCell cell = new NCMT_Report_DataCell();
                cell.value = 0;
                if (janByProj.get(proj.record.Id) != null &&janByProj.get(proj.record.Id).get(hp) != null)
                    cell.value = janByProj.get(proj.record.Id).get(hp);
                
                if (reportMode == 'comparison'){
                    row.cells.add(cell);
                } else {
                    cell.valueMeta = valueMeta;
                    cells.add(cell);
                }
            }
            

            //Maintenance LOS row?

            //Operation Efficiency Row
            valueMeta = new NCMT_Report_ValueMetaData();
            valueMeta.dataType = 'text';
            valueMeta.fieldLabel = hp +' - Operational Efficiency';
            if (reportMode == 'comparison'){
                rows.add(row);

                row = new NCMT_Report_ProjectComparisonRow();
                row.headerCol = hp +' - Operational Efficiency';
                row.valueMeta = valueMeta;
            }

            for (NCMT_TCO_Project proj : projects){
                NCMT_Report_DataCell cell = new NCMT_Report_DataCell();
                cell.value = 0;
                if (effByProj.get(proj.record.Id) != null &&effByProj.get(proj.record.Id).get(hp) != null)
                    cell.value = effByProj.get(proj.record.Id).get(hp);
                
                if (reportMode == 'comparison'){
                    row.cells.add(cell);
                } else {
                    cell.valueMeta = valueMeta;
                    cells.add(cell);
                }
            }
            if (reportMode == 'comparison'){
                rows.add(row);
            }
        }
            
        if (reportMode == 'comparison'){
            return rows;
        } else {
            return cells;
        }
    }

    public class SectionSpec{
        @AuraEnabled public String headerLabel {get;set;}
        @AuraEnabled public List<DataSpec> dataSpecs {get;set;}
        @AuraEnabled public Boolean defaultExpanded {get;set;}
        public SectionSpec(String h){
            dataSpecs = new List<DataSpec>();
            headerLabel = h;
            defaultExpanded = false;
        }
    }

    //Pass in either fieldSetName OR lcc return details
    public class DataSpec{
        @AuraEnabled public String objectName {get;set;}
        @AuraEnabled public String fieldSetName {get;set;}
        @AuraEnabled public String lccGrouping {get;set;} //Indicate which lcc data should be returned,
                                            //categories, costs
        @AuraEnabled public Set<String> categoryFilters {get;set;} //LCC only, to limit categories returned (blank = all)
        @AuraEnabled public Set<String> costFilters {get;set;} //LCC only, to limit categories returned (blank = all)
        @AuraEnabled public String chartType {get;set;}
        @AuraEnabled public String chartLabels {get;set;}
        @AuraEnabled public String chartData {get;set;}
        @AuraEnabled public Boolean groupProjects {get;set;} //specific to charts, set true to show all data on the same chart

        public DataSpec(){
            categoryFilters = new Set<String>();
            costFilters = new Set<String>();
            groupProjects = true;
        }
    }




    
}