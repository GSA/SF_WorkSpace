public class NCMT_TCOReportDataSelector {


    public NCMT_TCOReportDataSelector(ApexPages.StandardController stdcontroller) {

    }

    @AuraEnabled(cacheable=true)
    public static NCMT_TCO_ReportData getReportData(String[] projIds, String reportType, String reportMode, String costType){
        System.debug('projIds ==== ' +projIds +'reportType ====== ' +reportType);
        NCMT_TCO_ReportData.SectionSpec[] specs = getDataSpecs(reportType);
        System.debug(specs);
        return new NCMT_TCO_ReportData(projIds, specs, reportMode, costType);
    }

    @AuraEnabled
    public static NCMT_TCO_ReportData.SectionSpec[] getDataSpecs(String reportType){
        System.debug('reportType ====== ' +reportType );
        List<NCMT_TCO_ReportData.SectionSpec> secSpecs = new List<NCMT_TCO_ReportData.SectionSpec>();

        //Always start with this....
        NCMT_TCO_ReportData.SectionSpec secSpec = new NCMT_TCO_ReportData.SectionSpec('Project Information');
        NCMT_TCO_ReportData.DataSpec spec = new NCMT_TCO_ReportData.DataSpec();
        spec.objectName = 'NCMT_Project__c';
        spec.fieldSetName = 'Report_Basic_Project_Info';
        secSpec.dataSpecs.add(spec);
        
        secSpecs.add(secSpec);

        switch on reportType {
            when 'BasicCostOutputs' {
                secSpec = new NCMT_TCO_ReportData.SectionSpec('Costs');
                secSpec.defaultExpanded = true;
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'categories';
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);
                
            }
            when 'DetailedCostOutputs' {
               
                secSpec = new NCMT_TCO_ReportData.SectionSpec('Initial Costs');
                secSpec.defaultExpanded = true;
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'costs';
                spec.categoryFilters.add('Initial Cost');
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                secSpec = new NCMT_TCO_ReportData.SectionSpec('Operations & Maintenance Costs');
                secSpec.defaultExpanded = true;
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'costs';
                spec.categoryFilters.add('Operations and Maintenance');
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                secSpec = new NCMT_TCO_ReportData.SectionSpec('Replacement/Refresh');
                secSpec.defaultExpanded = true;
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'costs';
                spec.categoryFilters.add('Replacement/Refresh');
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                secSpec = new NCMT_TCO_ReportData.SectionSpec('Utilities');
                secSpec.defaultExpanded = true;
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'costs';
                spec.categoryFilters.add('Utilities');
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);
                
            }
            when 'BasicInputs' {
                
                secSpec = new NCMT_TCO_ReportData.SectionSpec('Financial Data');
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.objectName = 'NCMT_Project__c';
                spec.fieldSetName = 'Report_Building_Fiscal_Data';
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                secSpec = new NCMT_TCO_ReportData.SectionSpec('Building Info');
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.objectName = 'NCMT_Project__c';
                spec.fieldSetName = 'Report_Building_Info';
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                secSpec = new NCMT_TCO_ReportData.SectionSpec('Stories');
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.objectName = 'NCMT_Building_Massing_By_Floor__c';
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                secSpec = new NCMT_TCO_ReportData.SectionSpec('Building Areas');
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.objectName = 'Project_Level_Parameter__c';
                spec.fieldSetName = 'Report_Building_Data_Areas';
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                //HOUSING PLANS
                secSpec = new NCMT_TCO_ReportData.SectionSpec('Level of Service');
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.objectName = 'NCMT_TCO_HP_Level_of_Service__c';
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                //COST RATES
                secSpec = new NCMT_TCO_ReportData.SectionSpec('Cost Rates');
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.objectName = 'NCMT_Project_Cost_Rate__c';
                spec.fieldSetName = 'Report_Cost_Rates';
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                //LIFECYCLE
                secSpec = new NCMT_TCO_ReportData.SectionSpec('Lifecycle');
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.objectName = 'NCMT_TCO_Lifecycle_Input__c';
                spec.fieldSetName = 'Reports_Inputs';
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);
                
            }
            when 'DetailedSummary' {
                
                secSpec = new NCMT_TCO_ReportData.SectionSpec('Initial Cost');
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'categories';
                spec.categoryFilters.add('Initial Cost');
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                secSpec = new NCMT_TCO_ReportData.SectionSpec('Operations & Maintenance Costs');
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'costs';
                spec.categoryFilters.add('Operations and Maintenance');
                spec.categoryFilters.add('Replacement/Refresh');
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

                //Add all basic input sections
                secSpecs.addAll(getDataSpecs('BasicInputs'));
                
            } //Currently charts only accept one LCC category at a time, or total (no categoryFilters)
            when 'ExpenditureCurveStacked' {

                secSpec = new NCMT_TCO_ReportData.SectionSpec('Expenditure Curves');
                secSpec.defaultExpanded = true;
 
                //In detail mode, the totals view (not filtered by category) displays
                //with the categories stacked, so only this one is needed
                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'categories';
                spec.chartType = 'bar';
                spec.chartData = 'lccCost'; 
                spec.chartLabels = 'lccYear';
                
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

            }
            when 'ExpenditureCurve' {

                secSpec = new NCMT_TCO_ReportData.SectionSpec('Expenditure Curves');
                secSpec.defaultExpanded = true;

                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'categories';
                spec.chartType = 'bar';
                spec.chartData = 'lccCost';
                spec.chartLabels = 'lccYear';
                
                secSpec.dataSpecs.add(spec);

                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'categories';
                spec.categoryFilters.add('Initial Cost');
                spec.chartType = 'bar';
                spec.chartData = 'lccCost';
                spec.chartLabels = 'lccYear';
                
                secSpec.dataSpecs.add(spec);

                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'categories';
                spec.categoryFilters.add('Operations and Maintenance');
                spec.chartType = 'bar';
                spec.chartData = 'lccCost';
                spec.chartLabels = 'lccYear';
                
                secSpec.dataSpecs.add(spec);

                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'categories';
                spec.categoryFilters.add('Utilities');
                spec.chartType = 'bar';
                spec.chartData = 'lccCost';
                spec.chartLabels = 'lccYear';
                
                secSpec.dataSpecs.add(spec);

                spec = new NCMT_TCO_ReportData.DataSpec();
                spec.lccGrouping = 'categories';
                spec.categoryFilters.add('Replacement/Refresh');
                spec.chartType = 'bar';
                spec.chartData = 'lccCost';
                spec.chartLabels = 'lccYear';
                
                secSpec.dataSpecs.add(spec);

                secSpecs.add(secSpec);

            }
            when else {
                
            }
        }
        return secSpecs;
    }

}