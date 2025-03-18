public with sharing class NCMT_LPOEReportData {

    public String   strProjectID            {get; set;}
    public String   strProjectType          {get; set;}
    public String   strProjectName          {get; set;}
    public String   strProjectState         {get; set;}
    public String   strProjectLocation      {get; set;}
    public String   strbriefnarrative       {get; set;}
    public string   strCity                 {get; set;}
    public string   strRegionCode           {get; set;}
    public string   strGSAProject           {get; set;}
    public string   strPBSBuilding          {get; set;}
    public string   strRecordtype           {get; set;}
    public decimal  dblescrate              {get; set;}
    public decimal  dblTIAdjFactor          {get; set;}
    public string   strremoteness           {get; set;}
    public string   strbuildingquality      {get; set;}
    public string   strprojseismicdesigncat {get; set;}
    public string   strcreatedby            {get; set;}
    public string   strpeerreviewer         {get; set;}
    public date     dateofestimate          {get; set;}
    public date     costparamdate           {get; set;}
    public date     startconsdate           {get; set;}
    public decimal  dblstandardesc          {get; set;}
    public decimal  dblEscMarkets           {get; set;}
    public decimal  dblEscCode              {get; set;}
    public Decimal  dblGross                {get; set;}
    public string   strBorder               {get; set;} 
    public decimal  dblCommnumberoflanes    {get; set;} 
    public decimal  dblPOVnumberoflanes     {get; set;}
    public string   dblporttype             {get; set;} 
    public decimal  dbltotalnumberoflanes   {get; set;} 
    public decimal  dbltotalacreage         {get; set;}
    public decimal  dblPOVacreage           {get; set;}
    public decimal  dblcommacreage          {get; set;}
    
    public decimal  dblOtherDirectCost          {get; set;}
    public decimal  dblOtherDirectCostTI        {get; set;}
    public decimal  dblOtherDirectCostCoreShell {get; set;}
    public decimal  dblTotalOtherCost           {get; set;}
    public decimal  dblOtherCoreShellCosts      {get; set;}
    public decimal  dblOtherTICosts             {get; set;}
    public decimal  dblOtherSecurityCosts       {get; set;}
    public decimal  dblOtherSiteInfrastructureCosts {get; set;}
    //gm sprint 7 added site aquisition costs
    public decimal  dblOtherSiteAquisitionCosts {get; set;}
    
    public decimal  dblEDRC         {get; set;}
    public decimal  dblEMIC         {get; set;}
    public decimal  dblEDRCPercent  {get; set;}
    public decimal  dblEMICPercent  {get; set;}
    
    public Decimal  dblCoreShellCosts       {get; set;}
    public Decimal  dblTICosts              {get; set;}
    public Decimal  dblSecurityCosts        {get; set;}
    public Decimal  dblTotalCost            {get; set;}
    public Decimal  dblTotalCoreShellCostsECC       {get; set;}
    public Decimal  dblTotalTICostsECC              {get; set;}
    public Decimal  dblTotalSecurityCostsECC        {get; set;}
    public Decimal  dblTotalCostsECC                {get; set;}
    public Decimal  dblPOVSF                {get; set;}
    public Decimal  dblCommercialSF         {get; set;}
    public Decimal  dblTotalSF              {get; set;}
    
    public Decimal  dblSiteCoreShellCosts       {get; set;}
    public Decimal  dblSiteTICosts              {get; set;}
    public Decimal  dblSiteSecurityCosts        {get; set;}
    public Decimal  dblSiteTotalCost            {get; set;}
    public Decimal  dblSiteCoreShellCostsECC    {get; set;}
    public Decimal  dblSiteTICostsECC           {get; set;}
    public Decimal  dblSiteSecurityCostsECC     {get; set;}
    public Decimal  dblSiteTotalCostECC         {get; set;}
    public Decimal  dblSitePOVSF                {get; set;}
    public Decimal  dblSiteCommercialSF         {get; set;}
    public Decimal  dblSiteTotalSF              {get; set;}
    public Decimal  dblTotalSiteCoreShellCostsETPC {get; set;}
    public Decimal  dblTotalSiteTICostsETPC        {get; set;}
    public Decimal  dblTotalSiteSecurityCostsETPC  {get; set;}
    public Decimal  dblTotalSiteCostsETPC          {get; set;}
    
    public Decimal dblCoreShellCostETPC         {get; set;}
    public Decimal dblTICostETPC                {get; set;}
    public Decimal dblSecurityCostETPC          {get; set;}
    public Decimal dblTotalCostETPC             {get; set;}
    public Decimal dblTotalCoreShellCostsETPC   {get; set;}
    public Decimal dblTotalTICostsETPC          {get; set;}
    public Decimal dblTotalSecurityCostsETPC    {get; set;}
    public Decimal dblTotalCostsETPC            {get; set;}
    //added for 4.2, 1.2.1
    public decimal  dblUseableeff           {get; set;}
    public string   strPurposeOfEstimate   {get; set;}
    public String   strRegionalPortfolio    {get; set;}
    public String   strRequestor            {get; set;}

            
    public List<NCMT_Other_Cost__c> objOClist {get; set;}


    public NCMT_LPOEReportData() {
         objOClist = new List<NCMT_Other_Cost__c>();
         strProjectID = 'Not Specified';
            if (System.currentPageReference().getParameters().get('ProjectID')!=null){
                strProjectID = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('ProjectID'));
            }
            getProjectInformation();    
            getDatasetLPOECostSummary();     
            getDatasetLPOECostSummary1();
            getDatasetLPOECostSummary2(); 
            getDatasetLPOECostSummary3();        
            DatasetLPOECostSummaryGrouped(strProjectID);
    }
    
    public NCMT_Project__c getProjectInformation(){
               
        List<NCMT_Project__c> ListProjectInfo = [SELECT Id, Name, Location__r.name, State__c, Total_Escalation__c, TI_Adjustment_Factor__c, 
                                                        Brief_Narrative__c, City__c, RegionCode__c, GSA_Project__c, RecordType.Name, Building_Heigtht__c,
                                                        Remoteness__c, Building_Quality__c, Level_of_Protection__c, Project_Seismic_Design_Category__c, CreatedBy.Name, Peer_Reviewer__c,
                                                        Cost_Parameter_Date__c, End_Construction__c, Start_Construction__c,CreatedDate, Location__r.Standard_Escalation__c,
                                                        Location__r.State__c, Project_Status__c,RecordType.DeveloperName,Central_Office_Portfolio_Manager__r.FirstName, Level_III_ODC_Approver__r.FirstName, 
                                                        Level_III_OFM_Approver__r.FirstName, Level_IV_Approver__r.FirstName,Central_Office_Portfolio_Manager__r.LastName, Level_III_ODC_Approver__r.LastName, 
                                                        Level_III_OFM_Approver__r.LastName, Level_IV_Approver__r.LastName,Total_Escalation_CPE__c, Total_GSF__c,Other_Direct_Cost_Core_Shell__c, Other_Direct_Cost_TI__c,
                                                        Prorated_ODC__c, Prorated_OPC__c, Coreshell_OPC__c, TI_OPC__c, Useable_Area_Total_USF__c, Total_Other_Project_Costs__c,
                                                        Rentable_Area_w_o_parking_RSF__c, Project_type__c,Building_Type__c, Border__c, Purpose_of_Estimate__c, Useable_Area_Total_Efficiency__c, Regional_Portfolio__r.Name,
                                                        PBS_Building__r.Location_Code_Plus__c, Requestor__c, Estimate_Reviewed_By__r.Name, Estimate_Approved_By__r.Name
                                                   FROM NCMT_Project__c  
                                                   Where (ID = :strProjectID OR Name = :strProjectID) Limit 1]; 
                                           
         if (ListProjectInfo.size() > 0){
            //Project Parameters  
            
            NCMT_Project__c dsProjectInfo = ListProjectInfo.get(0);

            //added for 4.2, 1.2.1
            strPurposeOfEstimate = ListProjectInfo.get(0).Purpose_of_Estimate__c;
            //added for 5.0
            strRegionalPortfolio = ListProjectInfo.get(0).Estimate_Approved_By__r.Name;
            strRequestor = ListProjectInfo.get(0).Requestor__c;
            dblUseableeff = (Decimal) ListProjectInfo.get(0).Useable_Area_Total_Efficiency__c.setscale(3);

            strProjectType = ListProjectInfo.get(0).Project_type__c+' - '+ListProjectInfo.get(0).Building_Type__c;
            strProjectName = ListProjectInfo.get(0).Name;
            strBorder = ListProjectInfo.get(0).Border__c;
            dblescrate = (Decimal) (ListProjectInfo.get(0).Total_Escalation__c).setscale(2);   
            dblTIAdjFactor = (Decimal)  ListProjectInfo.get(0).TI_Adjustment_Factor__c;
            strProjectState = ListProjectInfo.get(0).State__c;
            strProjectLocation = ListProjectInfo.get(0).Location__r.name;
            strbriefnarrative = ListProjectInfo.get(0).Brief_Narrative__c;
            strCity = ListProjectInfo.get(0).City__c;
            strRegionCode = ListProjectInfo.get(0).RegionCode__c;
            strGSAProject = ListProjectInfo.get(0).GSA_Project__c;
            strPBSBuilding = ListProjectInfo.get(0).PBS_Building__r.Location_Code_Plus__c;
            strrecordtype = ListProjectInfo.get(0).RecordType.Name;
            strremoteness = ListProjectInfo.get(0).Remoteness__c;
            strbuildingquality = ListProjectInfo.get(0).Building_Quality__c;
            strprojseismicdesigncat = ListProjectInfo.get(0).Project_Seismic_Design_Category__c;
            strcreatedby = ListProjectInfo.get(0).CreatedBy.Name;
            //added for 5.0
            strpeerreviewer = ListProjectInfo.get(0).Estimate_Reviewed_By__r.Name;
            dateofestimate = ListProjectInfo.get(0).CreatedDate.date();
            costparamdate = ListProjectInfo.get(0).Cost_Parameter_Date__c;
            startconsdate = ListProjectInfo.get(0).Start_Construction__c;
            dblstandardesc = ListProjectInfo.get(0).Location__r.Standard_Escalation__c;
            dblEscMarkets = ((Decimal) ListProjectInfo.get(0).Total_Escalation__c/100).setScale(4);
            if(ListProjectInfo.get(0).Total_Escalation_CPE__c != null){
                dblEscCode = ((Decimal) ListProjectInfo.get(0).Total_Escalation_CPE__c/100).setScale(4);
            }else {
                dblEscCode = 0.00;
            }
            dblOtherDirectCost = ListProjectInfo.get(0).Other_Direct_Cost_TI__c + ListProjectInfo.get(0).Other_Direct_Cost_Core_Shell__c; 
            dblOtherDirectCostTI = ListProjectInfo.get(0).Other_Direct_Cost_TI__c;
            dblOtherDirectCostCoreShell = ListProjectInfo.get(0).Other_Direct_Cost_Core_Shell__c;
            dblGross  = (Decimal) ListProjectInfo.get(0).Total_GSF__c;
            
            List<LPOE_Space_Plan__c> LPOESpacePlanlist = [Select Comm_Number_of_Lanes__c, Number_of_Lanes__c, Acreage__c, Comm_Acreage__c
                                                           From  LPOE_Space_Plan__c
                                                           Where (Project_Name__r.ID = :strProjectID OR Project_Name__r.Name = :strProjectID) Limit 1];
    
            if (LPOESpacePlanlist.size() > 0){
                dblPOVnumberoflanes = LPOESpacePlanlist.get(0).Number_of_Lanes__c;
                dblCommnumberoflanes = LPOESpacePlanlist.get(0).Comm_Number_of_Lanes__c;
                dblPOVAcreage = LPOESpacePlanlist.get(0).Acreage__c;
                dblCommAcreage = LPOESpacePlanlist.get(0).Comm_Acreage__c;
                if(dblPOVnumberoflanes * dblCommnumberoflanes > 0){
                    dblporttype = 'POV & Commercial';
                }else{
                    
                    if(dblPOVnumberoflanes > 0){
                        dblporttype = 'POV';
                    }else{
                        dblporttype = 'Commercial';
                    }
                }
                
                dbltotalnumberoflanes = dblPOVnumberoflanes + dblCommnumberoflanes;
                dbltotalacreage = dblPOVAcreage + dblCommAcreage;
            }
                    
            // Other Project cost
                                                         
            List<AggregateResult> OtherSumCosts = [ SELECT Cost_Type__c costtype, SUM(Total1__c) Total
                                                     FROM  NCMT_Other_Cost__c 
                                                    WHERE  (NCMT_Project__r.ID = :strProjectID OR NCMT_Project__r.Name = :strProjectID)               
                                                    Group By Cost_Type__c]; 
            dblTotalOtherCost = 0; 
            dblOtherCoreShellCosts = 0;
            dblOtherTICosts = 0;
            dblOtherSecurityCosts = 0;
            dblOtherSiteInfrastructureCosts = 0;
            dblOtherSiteAquisitionCosts = 0;
            string strCosttype;
                                               
            for (AggregateResult RowData : OtherSumCosts) { 
                
                dblTotalOtherCost = (Decimal) RowData.get('Total');
                strCosttype = (string) RowData.get('costtype');
                
                if(strCosttype == 'Core/Shell'){
                    dblOtherCoreShellCosts = dblTotalOtherCost;
                }else if(strCosttype == 'Tenant'){
                    dblOtherTICosts = dblTotalOtherCost;
                }else if(strCosttype == 'Security'){
                    dblOtherSecurityCosts = dblTotalOtherCost;
                }else if(strCosttype == 'Site/ Infrastructure'){
                    dblOtherSiteInfrastructureCosts = dblTotalOtherCost;
                }else if(strCosttype == 'Site Acquisition Cost'){
                    dblOtherSiteAquisitionCosts = dblTotalOtherCost;
                }
            }     
            
            // Professional Services Parameters
            List<Professional_Service_Estimate__c> objPS = [
                Select  Total_Design_Percent__c, Total_Construction_Percent__c
                From    Professional_Service_Estimate__c 
                Where   Name = :strProjectName Limit 1
            ];
            
            dblEDRC = 0.00;
            dblEMIC = 0.00;
            dblEDRCPercent = 0.00;
            dblEMICPercent = 0.00;
            
            if (objPS.size() > 0){
                dblEDRCPercent = (Decimal) objPS.get(0).Total_Design_Percent__c;
                dblEMICPercent = (Decimal) objPS.get(0).Total_Construction_Percent__c;
                dblEDRC = (Decimal) objPS.get(0).Total_Design_Percent__c/100;
                dblEMIC = (Decimal) objPS.get(0).Total_Construction_Percent__c/100;
            }        
    
            return  dsProjectInfo;
          }else{
            ApexPages.Message errormessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter custom housing plan data before viewing report data');
            ApexPages.addMessage(errormessage);
            return null;
      }
    
    }
    
    public List<reportDetails> getDatasetLPOECostSummary(){
        dblCoreShellCostETPC = 0.00;
        dblTICostETPC = 0.00;
        dblSecurityCostETPC = 0.00;
        dblTotalCostETPC = 0.00;
        
         list<reportDetails> tempList = new list<reportDetails>();  
            
        List<NCMT_LPOE_Cost_Summary__c> DataRecords = [  
            Select  Total_Cost_Adjusted__c, TI_Cost_Adjusted__c, Security_Cost_Adjusted__c, Building_Group__c,
                    Name, Id, Cost_Category_Description__c, POV_SF__c,Commercial_SF__c,Total_SF__c, 
                    Core_Shell_Cost_Adjusted__c, Core_Shell_Cost_ECC__c, Security_Cost_ECC__c, TI_Cost_ECC__c,
                    Total_ECC__c
            From    NCMT_LPOE_Cost_Summary__c
            Where   (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID) 
            And    Building_Group__c = 'Office Buildings'                                    
            Order by Name Limit 100];
            
        if(DataRecords.size() > 0){
                 For(NCMT_LPOE_Cost_Summary__c LPOECostSummary :DataRecords){
                    reportDetails temp = new reportDetails();
                    temp.costSummaryRecord = LPOECostSummary;
                    temp.dblCoreShellCostETPC = (temp.costSummaryRecord.Core_Shell_Cost_ECC__c + ((temp.costSummaryRecord.TI_Cost_ECC__c + temp.costSummaryRecord.Security_Cost_ECC__c)* 0.35)) *(1+ dblEDRC + dblEMIC );
                    temp.dblTICostETPC = temp.costSummaryRecord.TI_Cost_ECC__c *(1+ dblEDRC + dblEMIC )*0.65;
                    temp.dblSecurityCostETPC = temp.costSummaryRecord.Security_Cost_ECC__c *(1+ dblEDRC + dblEMIC )*0.65;
                    temp.dblTotalCostETPC = temp.dblCoreShellCostETPC + temp.dblTICostETPC + temp.dblSecurityCostETPC;
                    tempList.add(temp);
                 }
        }    

        return tempList;
    }
     public List<reportDetails> getDatasetLPOECostSummary1(){
        dblCoreShellCostETPC = 0.00;
        dblTICostETPC = 0.00;
        dblSecurityCostETPC = 0.00;
        dblTotalCostETPC = 0.00;
        
        list<reportDetails> tempList = new list<reportDetails>();
        
        List<NCMT_LPOE_Cost_Summary__c> DataRecords = [  
            Select  Total_Cost_Adjusted__c, TI_Cost_Adjusted__c, Security_Cost_Adjusted__c, Building_Group__c,
                    Name, Id, Cost_Category_Description__c, POV_SF__c,Commercial_SF__c,Total_SF__c, 
                    Core_Shell_Cost_Adjusted__c, Core_Shell_Cost_ECC__c, Security_Cost_ECC__c, TI_Cost_ECC__c,
                    Total_ECC__c
            From    NCMT_LPOE_Cost_Summary__c
            Where   (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID) 
            And    Building_Group__c = 'Warehouse Buildings'                                    
            Order by Name Limit 100];

        if(DataRecords.size() > 0){
                 For(NCMT_LPOE_Cost_Summary__c LPOECostSummary :DataRecords){
                    reportDetails temp = new reportDetails();
                    temp.costSummaryRecord = LPOECostSummary;
                    temp.dblCoreShellCostETPC = (temp.costSummaryRecord.Core_Shell_Cost_ECC__c + ((temp.costSummaryRecord.TI_Cost_ECC__c + temp.costSummaryRecord.Security_Cost_ECC__c)* 0.35)) *(1+ dblEDRC + dblEMIC );
                    temp.dblTICostETPC = temp.costSummaryRecord.TI_Cost_ECC__c *(1+ dblEDRC + dblEMIC )*0.65;
                    temp.dblSecurityCostETPC = temp.costSummaryRecord.Security_Cost_ECC__c *(1+ dblEDRC + dblEMIC )*0.65;
                    temp.dblTotalCostETPC = temp.dblCoreShellCostETPC + temp.dblTICostETPC + temp.dblSecurityCostETPC;
                    tempList.add(temp);
                 }
        }    

        return tempList;
    }
    public List<reportDetails> getDatasetLPOECostSummary2(){
        dblCoreShellCostETPC = 0.00;
        dblTICostETPC = 0.00;
        dblSecurityCostETPC = 0.00;
        dblTotalCostETPC = 0.00;
        
        list<reportDetails> tempList = new list<reportDetails>();
        
        List<NCMT_LPOE_Cost_Summary__c> DataRecords = [  
            Select  Total_Cost_Adjusted__c, TI_Cost_Adjusted__c, Security_Cost_Adjusted__c, Building_Group__c,
                    Name, Id, Cost_Category_Description__c, POV_SF__c,Commercial_SF__c,Total_SF__c, 
                    Core_Shell_Cost_Adjusted__c, Core_Shell_Cost_ECC__c, Security_Cost_ECC__c, TI_Cost_ECC__c,
                    Total_ECC__c
            From    NCMT_LPOE_Cost_Summary__c
            Where   (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID) 
            And    Building_Group__c = 'Canopies'                                    
            Order by Name Limit 100];

        if(DataRecords.size() > 0){
                 For(NCMT_LPOE_Cost_Summary__c LPOECostSummary :DataRecords){
                    reportDetails temp = new reportDetails();
                    temp.costSummaryRecord = LPOECostSummary;
                    temp.dblCoreShellCostETPC = (temp.costSummaryRecord.Core_Shell_Cost_ECC__c + ((temp.costSummaryRecord.TI_Cost_ECC__c + temp.costSummaryRecord.Security_Cost_ECC__c)* 0.35)) *(1+ dblEDRC + dblEMIC );
                    temp.dblTICostETPC = temp.costSummaryRecord.TI_Cost_ECC__c *(1+ dblEDRC + dblEMIC )*0.65;
                    temp.dblSecurityCostETPC = temp.costSummaryRecord.Security_Cost_ECC__c *(1+ dblEDRC + dblEMIC )*0.65;
                    temp.dblTotalCostETPC = temp.dblCoreShellCostETPC + temp.dblTICostETPC + temp.dblSecurityCostETPC;
                    tempList.add(temp);
                 }
        }    

        return tempList;
    }
    public List<reportDetails> getDatasetLPOECostSummary3(){
        dblCoreShellCostETPC = 0.00;
        dblTICostETPC = 0.00;
        dblSecurityCostETPC = 0.00;
        dblTotalCostETPC = 0.00;
        
        list<reportDetails> tempList = new list<reportDetails>();
        
        List<NCMT_LPOE_Cost_Summary__c> DataRecords = [  
            Select  Total_Cost_Adjusted__c, TI_Cost_Adjusted__c, Security_Cost_Adjusted__c, Building_Group__c,
                    Name, Id, Cost_Category_Description__c, POV_SF__c,Commercial_SF__c,Total_SF__c, 
                    Core_Shell_Cost_Adjusted__c, Core_Shell_Cost_ECC__c, Security_Cost_ECC__c, TI_Cost_ECC__c,
                    Total_ECC__c
            From    NCMT_LPOE_Cost_Summary__c
            Where   (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID) 
            And    Building_Group__c = 'Sitework'                                    
            Order by Name Limit 100];

        if(DataRecords.size() > 0){
                 For(NCMT_LPOE_Cost_Summary__c LPOECostSummary :DataRecords){
                    reportDetails temp = new reportDetails();
                    temp.costSummaryRecord = LPOECostSummary;
                    temp.dblCoreShellCostETPC = (temp.costSummaryRecord.Core_Shell_Cost_ECC__c + ((temp.costSummaryRecord.TI_Cost_ECC__c + temp.costSummaryRecord.Security_Cost_ECC__c)* 0.35)) *(1+ dblEDRC + dblEMIC );
                    temp.dblTICostETPC = temp.costSummaryRecord.TI_Cost_ECC__c *(1+ dblEDRC + dblEMIC )*0.65;
                    temp.dblSecurityCostETPC = temp.costSummaryRecord.Security_Cost_ECC__c *(1+ dblEDRC + dblEMIC )*0.65;
                    temp.dblTotalCostETPC = temp.dblCoreShellCostETPC + temp.dblTICostETPC + temp.dblSecurityCostETPC;
                    tempList.add(temp);
                 }
        }    

        return tempList;
    }
    
    public void DatasetLPOECostSummaryGrouped(string strProjectID){
        dblCoreShellCosts = 0.00;
        dblTICosts = 0.00;
        dblSecurityCosts = 0.00;
        dblTotalCost = 0.00;
        dblPOVSF = 0.00;
        dblCommercialSF = 0.00;
        dblTotalSF = 0.00;
        
        dblTotalCoreShellCostsECC = 0.00;
        dblTotalTICostsECC = 0.00;
        dblTotalSecurityCostsECC = 0.00;
        dblTotalCostsECC = 0.00;
        dblTotalCoreShellCostsETPC = 0.00;
        dblTotalTICostsETPC = 0.00;
        dblTotalSecurityCostsETPC = 0.00;
        dblTotalCostsETPC = 0.00;
                
        dblSiteCoreShellCosts = 0.00;
        dblSiteTICosts = 0.00;
        dblSiteSecurityCosts = 0.00;
        dblSiteTotalCost = 0.00;
        dblSitePOVSF = 0.00;
        dblSiteCommercialSF = 0.00;
        dblSiteTotalSF = 0.00;
        
        dblSiteCoreShellCostsECC = 0.00;
        dblSiteTICostsECC = 0.00;
        dblSiteSecurityCostsECC = 0.00;
        dblSiteTotalCostECC = 0.00;
        dblTotalSiteCoreShellCostsETPC = 0.00;
        dblTotalSiteTICostsETPC = 0.00;
        dblTotalSiteSecurityCostsETPC = 0.00;
        dblTotalSiteCostsETPC = 0.00;
        
        
        List<AggregateResult> DataRecords = [   
            Select  Project_Name__c, Sum(Total_Cost_Adjusted__c) TotalCostAdjusted,
                    Sum(Core_Shell_Cost_Adjusted__c) CoreShellCosts,
                    Sum(TI_Cost_Adjusted__c) TICosts, Sum(Security_Cost_Adjusted__c) SecurityCosts,
                    Sum(POV_SF__c) POVSF, Sum(Commercial_SF__c) CommercialSF, Sum(Total_SF__c) TotalSF,
                    Sum(Core_Shell_Cost_ECC__c) CoreShellCostECC, Sum(TI_Cost_ECC__c) TICostECC, Sum(Security_Cost_ECC__c) SecurityCostECC, 
                    Sum(Total_ECC__c) TotalECC
            From    NCMT_LPOE_Cost_Summary__c
            Where   (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID) 
            And     Site_Related__c = False                                          
            Group by Project_Name__c Limit 10];
               
        if (DataRecords.size() > 0){
            dblCoreShellCosts = (Decimal) DataRecords[0].get('CoreShellCosts');
            dblTICosts = (Decimal) DataRecords[0].get('TICosts');
            dblSecurityCosts = ((Decimal) DataRecords[0].get('SecurityCosts'));
            dblTotalCost = (Decimal) DataRecords[0].get('CoreShellCosts') + (Decimal) DataRecords[0].get('TICosts') + ((Decimal) DataRecords[0].get('SecurityCosts'));
            dblPOVSF = ((Decimal) DataRecords[0].get('POVSF'));
            dblCommercialSF = ((Decimal) DataRecords[0].get('CommercialSF'));
            dblTotalSF = ((Decimal) DataRecords[0].get('TotalSF'));
            dblTotalCoreShellCostsECC = (Decimal) DataRecords[0].get('CoreShellCosts') * (1+ dblEscMarkets + dblEscCode);
            dblTotalTICostsECC = (Decimal) DataRecords[0].get('TICosts') * (1+ dblEscMarkets + dblEscCode);
            dblTotalSecurityCostsECC = ((Decimal) DataRecords[0].get('SecurityCosts')) * (1+ dblEscMarkets + dblEscCode);
            dblTotalCostsECC = dblTotalCost * (1+ dblEscMarkets + dblEscCode);
            dblTotalCoreShellCostsETPC = (dblTotalCoreShellCostsECC + ((dblTotalTICostsECC + dblTotalSecurityCostsECC) * 0.35)) * (1+ dblEDRC + dblEMIC);
            dblTotalTICostsETPC = (dblTotalTICostsECC * (1+ dblEDRC + dblEMIC) * 0.65);
            dblTotalSecurityCostsETPC = (dblTotalSecurityCostsECC * (1+ dblEDRC + dblEMIC) * 0.65);
            dblTotalCostsETPC = dblTotalCoreShellCostsETPC + dblTotalTICostsETPC + dblTotalSecurityCostsETPC;
         } 
        
       List<AggregateResult> SiteDataRecords = [   
            Select  Project_Name__c, Sum(Total_Cost_Adjusted__c) TotalCostAdjusted,
                    Sum(Core_Shell_Cost_Adjusted__c) CoreShellCosts,
                    Sum(TI_Cost_Adjusted__c) TICosts, Sum(Security_Cost_Adjusted__c) SecurityCosts,
                    Sum(POV_SF__c) POVSF, Sum(Commercial_SF__c) CommercialSF, Sum(Total_SF__c) TotalSF,
                    Sum(Core_Shell_Cost_ECC__c) CoreShellCostECC, Sum(TI_Cost_ECC__c) TICostECC, Sum(Security_Cost_ECC__c) SecurityCostECC, 
                    Sum(Total_ECC__c) TotalECC
            From    NCMT_LPOE_Cost_Summary__c
            Where   (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID) 
            And     Site_Related__c = True                                          
            Group by Project_Name__c Limit 10];
               
        if (SiteDataRecords.size() > 0){
            dblSiteCoreShellCosts = (Decimal) SiteDataRecords[0].get('CoreShellCosts');
            dblSiteTICosts = (Decimal) SiteDataRecords[0].get('TICosts');
            dblSiteSecurityCosts = ((Decimal) SiteDataRecords[0].get('SecurityCosts'));
            dblSiteTotalCost = (Decimal) SiteDataRecords[0].get('CoreShellCosts') + (Decimal) SiteDataRecords[0].get('TICosts') + ((Decimal) SiteDataRecords[0].get('SecurityCosts'));
            dblSitePOVSF = ((Decimal) SiteDataRecords[0].get('POVSF'));
            dblSiteCommercialSF = ((Decimal) SiteDataRecords[0].get('CommercialSF'));
            dblSiteTotalSF = ((Decimal) SiteDataRecords[0].get('TotalSF'));
            dblSiteCoreShellCostsECC = dblSiteCoreShellCosts * (1+ dblEscMarkets + dblEscCode);
            dblSiteTICostsECC = dblSiteTICosts * (1+ dblEscMarkets + dblEscCode);
            dblSiteSecurityCostsECC = dblSiteSecurityCosts * (1+ dblEscMarkets + dblEscCode);
            dblSiteTotalCostECC = dblSiteTotalCost * (1+ dblEscMarkets + dblEscCode);
            dblTotalSiteCoreShellCostsETPC = (dblSiteCoreShellCostsECC + ((dblSiteTICostsECC + dblSiteSecurityCostsECC) * 0.35)) * (1+ dblEDRC + dblEMIC);
            dblTotalSiteTICostsETPC = (dblSiteTICostsECC * (1+ dblEDRC + dblEMIC) * 0.65);
            dblTotalSiteSecurityCostsETPC = (dblSiteSecurityCostsECC * (1+ dblEDRC + dblEMIC) * 0.65);
            dblTotalSiteCostsETPC = dblTotalSiteCoreShellCostsETPC + dblTotalSiteTICostsETPC + dblTotalSiteSecurityCostsETPC;
        } 
    }



    public class reportDetails{
        public NCMT_LPOE_Cost_Summary__c costSummaryRecord{get;set;}
        public Decimal dblCoreShellCostETPC         {get; set;}
        public Decimal dblTICostETPC                {get; set;}
        public Decimal dblSecurityCostETPC          {get; set;}
        public Decimal dblTotalCostETPC             {get; set;} 
    }















}