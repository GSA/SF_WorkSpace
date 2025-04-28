public with sharing class PBS_gBUILD_PFinancialsController extends PBS_gBUILD_ProjectIdBaseController
{
    public PBS_gBUILD_Project__c fin { get; set; }
    public List<PBS_gBUILD_ProjectPerformanceCashflow__c> cashFlowList{ get; set; }
    public List<CashflowWrapper> cashflows { get; private set; }
    public String actionId { get; set; }
    
    public PBS_gBUILD_PFinancialsController()
    {
        super('Financials');
        try
        {
            bind();
        }
        catch (Exception ex)
        {
            handleConstructorError(ex);
        }
    }
    
    protected override void bind()
    {
        super.bind();
        fin = [
            Select UNID__c, TotProjectSimplePayback__c, TotProjectAnnualCostSav__c, TotOMCosts__c, TotMVCosts__c, TotFinancingCosts__c, TotContractAmount__c, TotAdminCosts__c, SystemModstamp, Sir__c, SavResultingFromFundedAmount__c, ProjectId__c, PrincipalAmount__c, PrepaymentPenalty__c, PrePerfPayment__c, PerfPeriodExpenses__c, PerfPaymentMethod__c, Payments__c, OwnerId, OtherCosts__c, Notes__c, Name, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Id, FundingRequested__c, FirstPaymentDue__c, FinancingRate__c, Escalation__c, ActualProjectInvestment__c, AwardDate__c 
            From PBS_gBUILD_Project__c
            where id=:ProjectId
            ];
        cashFlowList = [
            Select Year__c, CalendarQuarter__c, CalendarMonth__c, Rahd_ProjectParentId__c, ProposedGuaranteedAnnualCostSav__c, Name,Id, EstimatedAnnualCostSav__c, AnnualContractorPayments__c 
            From PBS_gBUILD_ProjectPerformanceCashflow__c 
            where Rahd_ProjectParentId__c =:ProjectId
            order by Year__c, CalendarQuarter__c, CalendarMonth__c
        ];     
        cashflows = new List<CashflowWrapper>();
        for (PBS_gBUILD_ProjectPerformanceCashflow__c z : cashFlowList)
        {
            CashflowWrapper cw = new CashflowWrapper(z, fin.PerfPaymentMethod__c);
            cashflows.add(cw);
        }
    }
    
    public PageReference edit() 
    {
        viewMode = false;
        bind();
        return null;
    }  
         
    public PageReference cancel() 
    {
        viewMode = true;
        bind();
        return null;
    }  
    
    public PageReference save() 
    {
        try
        {
            fin.ModifiedReason__c = 'Project financials changed.';
            update fin;
            update cashFlowList;

            string method = fin.PerfPaymentMethod__c;

            //get the 'ideal' set of cashflow items
            map<string, PBS_gBUILD_ProjectPerformanceCashflow__c> ideals = new map<string, PBS_gBUILD_ProjectPerformanceCashflow__c>();
            integer year = fin.FirstPaymentDue__c.year();
            integer month = fin.FirstPaymentDue__c.month();
            integer quarter;
            if (month<=3) quarter = 1;
            else if (month<=6) quarter = 2;
            else if (month<=9) quarter = 3;
            else quarter = 4;
            PBS_gBUILD_Utility.showDebugMessage(string.Format('initial y={0} q={1} m={2}', new string[]{string.valueof(year),string.valueof(quarter),string.valueof(month)}));
            for (integer z=0;z<fin.Payments__c;++z)
            {
                PBS_gBUILD_ProjectPerformanceCashflow__c cf = new PBS_gBUILD_ProjectPerformanceCashflow__c();
                cf.AnnualContractorPayments__c = 0;
                cf.EstimatedAnnualCostSav__c = 0;
                cf.ProposedGuaranteedAnnualCostSav__c = 0;
                cf.year__c = year;
                if (method==PBS_gBUILD_Utility.projectPerformancePaymentMethodMonthly)
                {
                    cf.calendarmonth__c = month++;
                    if (month>12)
                    {
                        month = 1;
                        ++year;
                    }
                }
                else if (method==PBS_gBUILD_Utility.projectPerformancePaymentMethodQuarterly)
                {
                    cf.calendarquarter__c = quarter++;
                    if (quarter>4)
                    {
                        quarter = 1;
                        ++year;
                    }
                }
                else if (method==PBS_gBUILD_Utility.projectPerformancePaymentMethodAnnually)
                {
                    ++year;
                }
                string period = createPeriodName(cf, method);
                ideals.put(period, cf);
                PBS_gBUILD_Utility.showDebugMessage('ideal period: '+period);
            }

            //existing items to be deleted
            set<string> existingPeriods = new set<string>();
            List<PBS_gBUILD_ProjectPerformanceCashflow__c> items = new List<PBS_gBUILD_ProjectPerformanceCashflow__c>();
            for (PBS_gBUILD_ProjectPerformanceCashflow__c cf : cashFlowList)
            {
                string period = createPeriodName(cf, method);
                existingPeriods.add(period);
                if (!ideals.containsKey(period))
                {
                    items.add(cf);
                    PBS_gBUILD_Utility.showDebugMessage('deleting existing period: '+period);
                }        
            }
            if (items.size()>0)
            {
                delete items;
            }

            //new items to be added
            items.clear();
            for (PBS_gBUILD_ProjectPerformanceCashflow__c cf : ideals.values())
            {
                string period = createPeriodName(cf, method);
                if (!existingPeriods.contains(period))
                {
                    cf.Rahd_ProjectParentId__c = this.ProjectId;
                    items.add(cf);
                    PBS_gBUILD_Utility.showDebugMessage('adding period: '+period);
                }
            }
            if (items.size()>0)
            {
                insert items;
            }
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex);
        }
        viewMode = true;
        RecordPageSaved();        
        bind();
        return null;
    }  

    private static final string periodNameUnknown = 'unknown';

    public static string formatLeadingZeros(integer num, integer characterCnt)
    {
        string s = string.valueOf(num);
        while (s.Length()<characterCnt)
        {
            s = '0' + s;
        }
        return s;
    }

    private static string createPeriodName(PBS_gBUILD_ProjectPerformanceCashflow__c item, string method)
    {
        string period = periodNameUnknown;
        try
        {
            integer year = integer.valueof(item.year__c);
            integer calendarquarter = integer.valueof(item.calendarquarter__c);
            integer calendarmonth = integer.valueof(item.calendarmonth__c);
            if (method==PBS_gBUILD_Utility.projectPerformancePaymentMethodMonthly)
            {
                period = string.Format('{1}-{0}', new string[]{formatLeadingZeros(calendarmonth,2), string.valueOf(year)});
            }
            else if (method==PBS_gBUILD_Utility.projectPerformancePaymentMethodQuarterly)
            {
                period = string.Format('{0}Q{1}', new string[]{string.valueOf(year), calendarquarter.format()});            
            }
            else if (method==PBS_gBUILD_Utility.projectPerformancePaymentMethodAnnually)
            {
                period = string.Format('{0}', new string[]{string.valueOf(year)});            
            }
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex);
        }
        return period;
    }

    public class CashflowWrapper
    {
        public PBS_gBUILD_ProjectPerformanceCashflow__c item { get; private set; }
        public string period { get; private set; }

        public CashflowWrapper(PBS_gBUILD_ProjectPerformanceCashflow__c item, string method)
        {
            this.item = item;
            this.period = createPeriodName(item, method);
        }
    }
}