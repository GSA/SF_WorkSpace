public with sharing class NCMT_ReportData {

    public String   strRegionalPortfolio    {get; set;}
    public String   strRequestor            {get; set;}
    public String   strProjectID            {get; set;}
    public String   URLProjectID            {get; set;}//SFWS-2246
    public String   strProjectType          {get; set;}
    public decimal  dblUseableeff           {get; set;}
    public String   strProjectName          {get; set;}
    public String   strCUIHeader            {get; set;}
    public String   strProjectState         {get; set;}
    public String   strProjectLocation      {get; set;}
    public String   strProjectStatus        {get; set;}
    public String   strbriefnarrative       {get; set;}
    public string   strCity                 {get; set;}
    public string   strRegionCode           {get; set;}
    public string   strGSAProject           {get; set;}
    public string   strPBSBuilding           {get; set;}
    public string   strbuildingcosttype     {get; set;}
    public string   strRecordtype           {get; set;}
    public string   strbuildingheight       {get; set;}
    public string   strremoteness           {get; set;}
    public string   strbuildingquality      {get; set;}
    public string   strlvlofprotection      {get; set;}
    public string   strprojseismicdesigncat {get; set;}
    public string   strcreatedby            {get; set;}
    public string   strpeerreviewer         {get; set;}
    public string   strBuildingtype         {get; set;}   
    public decimal  dblgrosswoparking       {get; set;}
    public decimal  dbltotrsfwoparking      {get; set;}
    public date     dateofestimate          {get; set;}
    public date     costparamdate           {get; set;}
    public date     startconsdate           {get; set;}
    public string   strPurposeOfEstimate   {get; set;}
    public decimal  dblstandardesc          {get; set;}
    public decimal  dbltotsitearea          {get; set;}
    public decimal  dbltotsiteareaacres     {get; set;}
    public decimal  dblparkinggrossarea     {get; set;}
    public decimal  dblparkingspaces        {get; set;}
    public decimal  dblTIAdjFactor          {get; set;}
    
    public decimal  dblDesign               {get; set;}
    public decimal  dblGeneral              {get; set;}
    public decimal  dblEscMarkets           {get; set;}
    public decimal  dblEscCode              {get; set;}
    public decimal  dblConstructArt         {get; set;}
    
    public decimal  dbltotgsf               {get; set;}
    
    public decimal dblblastwinFac           {get; set;}
    public decimal dblchangesetbackcost     {get; set;}
    public decimal dblchangeadjsetbackcost  {get; set;}
    public decimal dblTotalOtherCost        {get; set;} 
    
    public decimal  dblescrate                   {get; set;}
    public decimal  dbluseableareafinished       {get; set;}
    public decimal  dbluseableareaunfinishedusf  {get; set;}
    public decimal  dblparkingwthinbuildingstruc {get; set;}
    public decimal  dblstandalonepg              {get; set;}
    public decimal  dblsurfaceparking            {get; set;}
    public decimal  dblenclosedparking           {get; set;}
    public decimal  dblsiteinfosurfaceparking    {get; set;}
    public decimal  dblsiteinfostrucparking      {get; set;}
    public decimal  dblenclosedparkingpesf       {get; set;}
    public decimal  dbltotusf                    {get; set;}
    public decimal  dblunitcost                  {get; set;}    
    public decimal  dblspecialesccost            {get; set;}
    public decimal  dblspecialtotcostECC         {get; set;}
    public decimal  dblcoreshelltotadj           {get; set;}
    public decimal  dblsecuritytotadj            {get; set;}
    public decimal  dblparkingcosttotadj         {get; set;}
    public decimal  dblTRCStotadj                {get; set;}
    public decimal  dblsecuritycost              {get; set;}
    
    public decimal  dblCSlocationmultiplier      {get; set;}
    public decimal  dblCSseismicdesignfactor     {get; set;}
    public decimal  dblCSsetupqualityadj         {get; set;}
    public decimal  dblTIlocationmultiplier      {get; set;}
    public decimal  dblTIseismicdesignfactor     {get; set;}
    public decimal  dblTIsetupqualityadj         {get; set;}
    public decimal  dblCScummlocadj              {get; set;}
    public decimal  dblTIcummlocadj              {get; set;}
    
    public decimal dblprogressivecoltotcecc      {get; set;}
    public decimal dblsecuritytotcecc            {get; set;}
    public decimal dblshellcostceccpergsf        {get; set;}
    public decimal dblshellcostceccgsf           {get; set;}
    public decimal dblcoreshellcostesc           {get; set;}
    public decimal dblprogressiveshellcostesc    {get; set;}
    public decimal dblsecurityshellcostesc       {get; set;}
    
    public decimal  dblsiteremotnesscostimact    {get; set;}
    public decimal  dblFootPrintArea             {get; set;}    
    
    public decimal dbllssurfaceparkingcost          {get; set;}
    public decimal dbllssurfaceparkingcosts          {get; set;}
    public decimal dbllsstructuredparkingcost       {get; set;}
    public decimal dbllsstructuredparkingcosts       {get; set;}
    public decimal dblshellcostcsinsideparking      {get; set;}
    public decimal dblshellcostcsstrucdpg           {get; set;}
    public decimal dblshellcostcssurfacepg          {get; set;}
    public decimal dblshellcostgsfinsidepg          {get; set;}
    public decimal dblshellcostgsfstrucdpg          {get; set;}
    public decimal dblshellcostgsfsurfacepg         {get; set;}
    public decimal dblshellcostgsfinsidepgesc       {get; set;}
    public decimal dblshellcostgsfstrucdpgesc       {get; set;}
    public decimal dblshellcostgsfsurfacepgesc      {get; set;}
    public decimal dblshellcostgsfinsidepgtotecc    {get; set;}
    public decimal dblshellcostgsfstrucdpgtotecc    {get; set;}
    public decimal dblshellcostgsfsurfacepgtotecc   {get; set;}
    public decimal dblshellcostinsidepgeccgsf       {get; set;}
    public decimal dblshellcoststrucdpgeccgsf       {get; set;}
    public decimal dblshellcostsurfacepgeccgsf      {get; set;}
    public decimal dblcoreshellcosttotecc           {get; set;}
    public decimal dblprogressiveshellcosttotecc    {get; set;}
    public decimal dblsecurityshellcosttotecc       {get; set;}
    public decimal dblcoreshellcosteccgsf           {get; set;}
    public decimal dblprogressiveshellcosteccgsf    {get; set;}
    public decimal dblsecurityshellcosteccgsf       {get; set;}
    public decimal dblSUBtotalshellcostcecc         {get; set;}
    public decimal dblSUBtotalescapplied            {get; set;}
    public decimal dblSUBtotalcostECC               {get; set;}
    public decimal dblSUBtotalcostECCGSF            {get; set;}
    
    public decimal dblparkingcosttotshellcostcecc   {get; set;}
    public decimal dblparkingcosttotesc             {get; set;}
    public decimal dblparkingcosttotecc             {get; set;}
    
    public decimal dbltotbldshellTIcostECC          {get; set;}
    public decimal dbltotbldshellTIcostECCGSF       {get; set;}
    public decimal dblmarketshellecccost            {get; set;}
    
    public decimal dblsecurityitemscostecc          {get; set;}
    public decimal dbltotalTIcostecc                {get; set;}
     
    public decimal  dblEDRC         {get; set;}
    public decimal  dblEMIC         {get; set;}
    public decimal  dblEDRCPercent  {get; set;}
    public decimal  dblEMICPercent  {get; set;}

     public String   strHPProjectType          {get; set;}    
     public decimal  dblUnfinishedShellArea    {get; set;}
     public decimal  dblWorkstationsOpenOff    {get; set;}
     public decimal  dblClosedOff              {get; set;}
     public decimal  dbl820Personrooms         {get; set;}
     public decimal  dbl20morePersonrooms      {get; set;}
     public decimal  dblTeleconference         {get; set;}
     public decimal  dblAuditorium             {get; set;}
     public decimal  dblGeneralStorage         {get; set;}
     public decimal  dblClinicsHealth          {get; set;}
     public decimal  dblFit                    {get; set;}
     public decimal  dblChildcare              {get; set;}
     public decimal  dblLibraries              {get; set;}
     public decimal  dblADPHigh                {get; set;}
     public decimal  dblADPMain                {get; set;}
     public decimal  dblJoinRetail             {get; set;}
     public decimal  dblFood                   {get; set;}
     public decimal  dblNonClimate             {get; set;}
     public decimal  dblprivatetoilets         {get; set;}
     public decimal  dblhighdensitystorage     {get; set;} 
     public decimal  dblclimatecontrolled      {get; set;}
     public decimal  dbllabdry                 {get; set;}
     public decimal  dbllabwet                 {get; set;}
     public decimal  dblfiringrange            {get; set;}
     public decimal  dblcopycenter             {get; set;}
     public decimal  dblcreditunion            {get; set;}
     public decimal  dblTranscount             {get; set;}
     public decimal  dblkitchenbreak           {get; set;}
     public decimal  dbllockershower           {get; set;}
     public decimal  dblhardenedoff            {get; set;}  
     public decimal  dblswestd                 {get; set;}
     public decimal  dblsweenhd                {get; set;}
     public decimal  dblscifstd                {get; set;}
     public decimal  dblscifenhd               {get; set;}
     public decimal  dblvaultstg               {get; set;}
     public decimal  dblinterviewdet           {get; set;}
     public decimal  dblnonmarshellsingle      {get; set;}
     public decimal  dblnonmarshelldouble      {get; set;}
     public decimal  dbllightind               {get; set;}
     public decimal  dblwarehouse              {get; set;}
     public decimal  dblcourtceremonial        {get; set;}
     public decimal  dblcourtstandard          {get; set;}
     public decimal  dblcourtbankruptcy        {get; set;}
     public decimal  dblcourtmagistrate        {get; set;}
     public decimal  dblgrandjury              {get; set;}
     public decimal  dbljudicialhearing        {get; set;}
     public decimal  dbljudicialchambers       {get; set;}
     public decimal  dblenhancedoff            {get; set;}
     public decimal  dblusmsadmin              {get; set;}
     public decimal  dblusmsops                {get; set;}
     public decimal  dblsallyport              {get; set;}
     public decimal  dblholdingcellcentral     {get; set;}
     public decimal  dblholidngcellcourt       {get; set;}
     public string   struserdef1desc           {get; set;}
     public string   struserdef2desc           {get; set;}
     public string   struserdef3desc           {get; set;}
     public decimal  dbluserdef1spaces         {get; set;}
     public decimal  dbluserdef2spaces         {get; set;}
     public decimal  dbluserdef3spaces         {get; set;}
     public decimal  dblAmbulatorySurgery      {get; set;}
     public decimal  dblExamSuite              {get; set;}
     public decimal  dblInfusion               {get; set;}
     public decimal  dblIntake                 {get; set;}
     public decimal  dblPharmacy               {get; set;}
     public decimal  dblRadiology              {get; set;}
     public decimal  dblDataCenter             {get; set;}
     public decimal  dblMain_Lobby             {get; set;}
     public decimal  dblAtrium_Ground_floor_plan_area  {get; set;}
     public decimal  dblEnclosed_Parking       {get; set;}
     public decimal  dblRestrooms              {get; set;}
     public decimal  dblGround_floor_circulation  {get; set;}
     public decimal  dblElevator_lobbies       {get; set;}
     public decimal  dblOther_circulation      {get; set;}
     public decimal  dblMechanical_Electrical_IT {get; set;}
     public decimal  dblLoading_dock_Recycling_Trash {get; set;}
     public decimal  dblStructural_Area        {get; set;}
     public decimal  dblElevator_shafts        {get; set;}
     public decimal  dblStair_shafts           {get; set;}
     public decimal  dblOther_vertical_penetrations  {get; set;}
     public decimal  dblAtrium_upper_levels_phantom_floors  {get; set;}
     public decimal  dblConditioned_Core_Area  {get; set;}
     public decimal  dblMailroom  {get; set;} 
     public decimal  dblSecureMailroom {get; set;} 
     
     public decimal  dblWorkstationsOpenOffCECCUSF {get; set;}
     public decimal  dblClosedOffCECCUSF           {get; set;}
     public decimal  dbl820PersonroomsCECCUSF      {get; set;}
     public decimal  dbl20morePersonroomsCECCUSF   {get; set;}
     public decimal  dblTeleconferenceCECCUSF      {get; set;}
     public decimal  dblAuditoriumCECCUSF          {get; set;}
     public decimal  dblGeneralStorageCECCUSF      {get; set;}
     public decimal  dblClinicsHealthCECCUSF       {get; set;}
     public decimal  dblFitCECCUSF                 {get; set;}
     public decimal  dblChildcareCECCUSF           {get; set;}
     public decimal  dblLibrariesCECCUSF           {get; set;}
     public decimal  dblADPHighCECCUSF             {get; set;}
     public decimal  dblADPMainCECCUSF             {get; set;}
     public decimal  dblJoinRetailCECCUSF          {get; set;}
     public decimal  dblFoodCECCUSF                {get; set;}
     public decimal  dblNonClimateCECCUSF          {get; set;}
     public decimal  dblprivatetoiletsCECCUSF      {get; set;}
     public decimal  dblhighdensitystorageCECCUSF  {get; set;}
     public decimal  dblClimateControlledCECCUSF   {get; set;}
     public decimal  dbllabdryCECCUSF              {get; set;} 
     public decimal  dbllabwetCECCUSF              {get; set;}
     public decimal  dblfiringrangeCECCUSF         {get; set;}
     public decimal  dblcopycenterCECCUSF          {get; set;}
     public decimal  dblcreditunionCECCUSF         {get; set;}
     public decimal  dblTranscountCECCUSF          {get; set;}
     public decimal  dblkitchenbreakCECCUSF        {get; set;}
     public decimal  dbllockershowerCECCUSF        {get; set;}
     public decimal  dblhardenedoffCECCUSF            {get; set;}  
     public decimal  dblswestdCECCUSF                 {get; set;}
     public decimal  dblsweenhdCECCUSF                {get; set;}
     public decimal  dblscifstdCECCUSF                {get; set;}
     public decimal  dblscifenhdCECCUSF               {get; set;}
     public decimal  dblvaultstgCECCUSF               {get; set;}
     public decimal  dblinterviewdetCECCUSF           {get; set;}
     public decimal  dblnonmarshellsingleCECCUSF      {get; set;}
     public decimal  dblnonmarshelldoubleCECCUSF      {get; set;}
     public decimal  dbllightindCECCUSF               {get; set;}
     public decimal  dblwarehouseCECCUSF              {get; set;}
     public decimal  dblcourtceremonialCECCUSF        {get; set;}
     public decimal  dblcourtstandardCECCUSF          {get; set;}
     public decimal  dblcourtbankruptcyCECCUSF        {get; set;}
     public decimal  dblcourtmagistrateCECCUSF        {get; set;}
     public decimal  dblgrandjuryCECCUSF              {get; set;}
     public decimal  dbljudicialhearingCECCUSF        {get; set;}
     public decimal  dbljudicialchambersCECCUSF       {get; set;}
     public decimal  dblenhancedoffCECCUSF            {get; set;}
     public decimal  dblusmsadminCECCUSF              {get; set;}
     public decimal  dblusmsopsCECCUSF                {get; set;}
     public decimal  dblsallyportCECCUSF              {get; set;}
     public decimal  dblholdingcellcentralCECCUSF     {get; set;}
     public decimal  dblholidngcellcourtCECCUSF       {get; set;}
     public decimal  dbluserdef1spacesCECCUSF         {get; set;}
     public decimal  dbluserdef2spacesCECCUSF         {get; set;}
     public decimal  dbluserdef3spacesCECCUSF         {get; set;}
     public decimal  dblAmbulatorySurgeryCECCUSF      {get; set;}
     public decimal  dblExamSuiteCECCUSF              {get; set;}
     public decimal  dblInfusionCECCUSF               {get; set;}
     public decimal  dblIntakeCECCUSF                 {get; set;}
     public decimal  dblPharmacyCECCUSF               {get; set;}
     public decimal  dblRadiologyCECCUSF              {get; set;}
     public decimal  dblDataCenterCECCUSF             {get; set;}
     public decimal  dblMailroomCECCUSF               {get; set;}
     public decimal  dblSecureMailroomCECCUSF         {get; set;}
     
     //for uniformatsum reports
    public Decimal  dblFinSite      {get; set;}
    public decimal  dblConstruct    {get; set;}
    public decimal  dblArt          {get; set;}
    
    public Decimal  dblGross        {get; set;}
    public Decimal  dblVertical     {get; set;}
    
    public Decimal  dblSurfaceParkingCost       {get; set;}
    public Decimal  dblStructuredParkingCost    {get; set;}
    public Decimal  dblOtherDirectCost          {get; set;}
    public Decimal  dblOtherDirectCostTI        {get; set;}
    public Decimal  dblOtherDirectCostCoreShell {get; set;}
    
    public Decimal  dblProRatedOPC  {get; set;}
    public Decimal  dblProRatedODC  {get; set;}
    public Decimal  dblCoreShellOPC {get; set;}
    public Decimal  dblTIOPC        {get; set;}
    
    public Decimal  dblBasementStoryHeight          {get; set;}
    public Decimal  dblBasementSF                   {get; set;}
    public Decimal  dblElevatedFloorAreaSF          {get; set;}
    public Decimal  dblTotalRoofAreaSF              {get; set;}
    public Decimal  dblCladdingSkinRatioSF          {get; set;}
    public Decimal  dblStairAnalysisTotalFlights    {get; set;}
    public Decimal  dblPlumbingFixturesEA           {get; set;}
    public Decimal  dblHVACCoolingLoadTons          {get; set;}
    public Decimal  dblElectricalLoadkW             {get; set;}
    
    public Decimal  dblCoreShellCosts   {get; set;}
    public Decimal  dblTRCSCosts        {get; set;}
    public Decimal  dblTICosts          {get; set;}
    public Decimal  dblSecurityCosts    {get; set;}
    public Decimal  dblParkingCosts     {get; set;}
    public Decimal  dblMult             {get; set;}
    public Decimal  dblTotalUSF         {get; set;}
    public Decimal  dblRepairCosts      {get; set;}
    public Decimal  dblReplaceCosts     {get; set;}
    public Decimal  dblGSACosts         {get; set;}
    public Decimal  dblGSAPkgCosts      {get; set;}
    public Decimal  dblTIAMCosts        {get; set;}
    public Decimal  dblTIRWACosts       {get; set;}
    public Decimal  dbltotalotherprojectcosts  {get; set;}
    
    public Decimal  dblNonBuildingRelatedSiteCost   {get; set;}
    
    public List<NCMT_Other_Cost__c> objOClist {get; set;}
    public list<level3Wrapper> lvlthrees {get; set;}
    public Boolean showLevel3 {get;set;}
  
    
     public NCMT_ReportData() {
         objOClist = new List<NCMT_Other_Cost__c>();
         strProjectID = 'Not Specified';
            if (System.currentPageReference().getParameters().get('ProjectID')!=null){
                strProjectID = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('ProjectID'));
            }
        
            getProjectInformation();
            DatasetProjectCostSummaryGrouped(strProjectID);
     }
       
     public NCMT_Project__c getProjectInformation(){
     
         decimal dblmarkupsDC, dblmarkupsGC, dblmarkupsCC, dblmarkupsAA, dblECCmarkups, dblcalculatedsitearea, dbloverridecalsitearea, dbluserdef1dc, dbluserdef2dc, dbluserdef3dc  = 0.00; 
         dbluseableareaunfinishedusf = 0.00; dbltotusf = 0.00; dblunitcost = 0.00; dblspecialesccost = 0; dblspecialtotcostECC = 0; dbllssurfaceparkingcost = 0.00;     
         dbllsstructuredparkingcost     = 0.00; dblshellcostcsinsideparking    = 0.00;  dblshellcostcsstrucdpg = 0.00; dblshellcostcssurfacepg = 0.00;      
         dblshellcostgsfinsidepg        = 0.00; dblshellcostgsfstrucdpg = 0.00; dblshellcostgsfsurfacepg = 0.00; dblshellcostgsfinsidepgesc  = 0.00; 
         dblshellcostgsfstrucdpgesc     = 0.00; dblshellcostgsfsurfacepgesc    = 0.00; dblshellcostgsfinsidepgtotecc  = 0.00; dblshellcostgsfstrucdpgtotecc  = 0.00;   
         dblshellcostgsfsurfacepgtotecc = 0.00; dblshellcostinsidepgeccgsf     = 0.00; dblshellcoststrucdpgeccgsf     = 0.00; dblshellcostsurfacepgeccgsf    = 0.00;
         dbllssurfaceparkingcosts=0.00;
         
         dblprogressivecoltotcecc = 0.00; 
         dblsecuritytotcecc = 0.00;  
         dblshellcostceccpergsf = 0.00;
         dblshellcostceccgsf  = 0.00;
         dblcoreshellcostesc  = 0.00;
         dblprogressiveshellcostesc = 0.00;
         dblsecurityshellcostesc = 0.00;
         dblcoreshellcosttotecc = 0.00;
         dblprogressiveshellcosttotecc = 0.00;
         dblsecurityshellcosttotecc = 0.00;
         dblcoreshellcosteccgsf = 0.00;
         dblprogressiveshellcosteccgsf = 0.00;
         dblsecurityshellcosteccgsf = 0.00;
         
         dblSUBtotalshellcostcecc = 0.00;
         dblSUBtotalescapplied = 0.00; 
         dblSUBtotalcostECC = 0.00;
         dblSUBtotalcostECCGSF = 0.00;
         
         dbltotbldshellTIcostECC = 0.00;
         dbltotbldshellTIcostECCGSF = 0.00; 
         
         dblparkingcosttotshellcostcecc = 0.00;
         dblparkingcosttotesc = 0.00;
         dblparkingcosttotecc = 0.00;  
         dblmarketshellecccost = 0.00;
         dblsiteinfostrucparking = 0;
         dblECCmarkups = 0;
         dblCScummlocadj = 0; 
         
         //dblsubtotalTIcostecc = 0.00;  
         dblsecurityitemscostecc = 0.00;
         dbltotalTIcostecc = 0.00;
         //dbltotalprojectcostecc = 0.00;  
         //dbltotalbuildingcostgsfwopg = 0.00;
         dblEscCode = 0.00;
         dblFinSite = 0.00;
         decimal dblTotalCostDC = 0.00;
         decimal dblTotalCostEsc = 0.00;
         decimal dblTotalCostGC = 0.00;
 
        List<NCMT_Project__c> ListProjectInfo = [SELECT Id, Name, Useable_Area_Total_Efficiency__c, Location__r.name, State__c, Total_Escalation__c, TI_Adjustment_Factor__c, 
                                                        Design_and_Site_Contingency__c, General_Contractor_Overhead_Profit_Bonds__c, Construction_Contingency__c, Art_In_Architecture__c,
                                                        Useable_Area_Unfinished_USF__c, CUI_Header__c, Parking_Within_Building_Structure__c, Stand_alone_Parking_Garage__c, Surface_Parking__c,
                                                        Brief_Narrative__c, City__c, RegionCode__c, GSA_Project__c, RecordType.Name, Building_Cost_Type__c, Building_Heigtht__c,
                                                        Remoteness__c, Building_Quality__c, Level_of_Protection__c, Project_Seismic_Design_Category__c, CreatedBy.Name, Peer_Reviewer__c,
                                                        Gross_Area_w_o_parking_BGSF__c, Cost_Parameter_Date__c, End_Construction__c, Start_Construction__c,CreatedDate, Location__r.Standard_Escalation__c,
                                                        Override_Calculated_Site_Area__c, Calculated_Site_Area__c, Enclosed_parking_PRSF__c,
                                                        Location__r.State__c, Project_Status__c,Sign_this_Project__c,Signed_By__c,Signed_Date__c,
                                                        RecordType.DeveloperName, Gross_Area__c, Useable_Area__c, Housing_Plan__c, 
                                                        Central_Office_Portfolio_Manager__r.FirstName, Level_III_ODC_Approver__r.FirstName, 
                                                        Level_III_OFM_Approver__r.FirstName, Level_IV_Approver__r.FirstName,
                                                        Central_Office_Portfolio_Manager__r.LastName, Level_III_ODC_Approver__r.LastName, 
                                                        Level_III_OFM_Approver__r.LastName, Level_IV_Approver__r.LastName,
                                                        Total_Escalation_CPE__c,
                                                        Parking_Garage_Gross_Area_SF__c, Total_GSF__c, Number_of_Stops__c,
                                                        Other_Direct_Cost_Core_Shell__c, Other_Direct_Cost_TI__c,
                                                        Prorated_ODC__c, Prorated_OPC__c, Coreshell_OPC__c, TI_OPC__c,
                                                        Useable_Area_Total_USF__c, Total_Other_Project_Costs__c,
                                                        Rentable_Area_w_o_parking_RSF__c, Project_Type__c , Building_Type__c,  
                                                        Purpose_of_Estimate__c, Regional_Portfolio__r.Name, PBS_Building__r.Location_Code_Plus__c,
                                                        Estimate_Reviewed_By__r.Name,Estimate_Approved_By__r.Name, Requestor__c, EDRC__c, EMIC__c
                                                   FROM NCMT_Project__c  
                                                   Where (ID = :strProjectID OR Name = :strProjectID) Limit 1];   
                                                   //, UserDefinedHousingPlan_Record_Count__c, DefaultHousingPlan_Record_Count__c
                                                  // And (UserDefinedHousingPlan_Record_Count__c >= 1 OR DefaultHousingPlan_Record_Count__c = 1) 
                                           
         if (ListProjectInfo.size() > 0){
            //Project Parameters  
            URLProjectID=ListProjectInfo[0].ID;//SFWS-2246
            NCMT_Project__c dsProjectInfo = ListProjectInfo.get(0);
             strProjectType = ListProjectInfo.get(0).RecordType.DeveloperName;
             strProjectName = ListProjectInfo.get(0).Name;
             strCUIHeader = ListProjectInfo.get(0).CUI_Header__c;
             strBuildingtype = ListProjectInfo.get(0).Building_Type__c;
             dbltotalotherprojectcosts = ListProjectInfo.get(0).Total_Other_Project_Costs__c;
             strProjectStatus = ListProjectInfo.get(0).Project_Status__c;
             dblUseableeff = (Decimal) ListProjectInfo.get(0).Useable_Area_Total_Efficiency__c.setscale(3);
             if (ListProjectInfo.get(0).Total_Escalation__c <> null) {
                dblescrate = (Decimal) (ListProjectInfo.get(0).Total_Escalation__c).setscale(4);
             }  
             else {
                dblescrate = 0.0;
             }
             System.debug('ESCALATION: ' + ListProjectInfo.get(0).Total_Escalation__c+ ' ' + dblescrate);
             dblTIAdjFactor = (Decimal)  ListProjectInfo.get(0).TI_Adjustment_Factor__c; 
             dblmarkupsDC = (Decimal) ListProjectInfo.get(0).Design_and_Site_Contingency__c/100;
             dblmarkupsGC = (Decimal) ListProjectInfo.get(0).General_Contractor_Overhead_Profit_Bonds__c/100;
             dblmarkupsCC = (Decimal) ListProjectInfo.get(0).Construction_Contingency__c/100;
             dblmarkupsAA = (Decimal) ListProjectInfo.get(0).Art_In_Architecture__c/100;                       
             strProjectState = ListProjectInfo.get(0).State__c;
             strProjectLocation = ListProjectInfo.get(0).Location__r.name;
             dbluseableareaunfinishedusf = ListProjectInfo.get(0).Useable_Area_Unfinished_USF__c;
             dblparkingwthinbuildingstruc = ListProjectInfo.get(0).Parking_Within_Building_Structure__c;
             dblstandalonepg = ListProjectInfo.get(0).Stand_alone_Parking_Garage__c;
             dblsurfaceparking = ListProjectInfo.get(0).Surface_Parking__c;
             strbriefnarrative = ListProjectInfo.get(0).Brief_Narrative__c;             
             strCity = ListProjectInfo.get(0).City__c;
             strRegionCode = ListProjectInfo.get(0).RegionCode__c;
             strGSAProject = ListProjectInfo.get(0).GSA_Project__c;
             strPBSBuilding = ListProjectInfo.get(0).PBS_Building__r.Location_Code_Plus__c;
             strbuildingcosttype = ListProjectInfo.get(0).Building_Cost_Type__c;
             strrecordtype = ListProjectInfo.get(0).RecordType.Name;
             strbuildingheight = ListProjectInfo.get(0).Building_Heigtht__c;
             strremoteness = ListProjectInfo.get(0).Remoteness__c;
             strbuildingquality = ListProjectInfo.get(0).Building_Quality__c;
             strlvlofprotection = ListProjectInfo.get(0).Level_of_Protection__c;
             strprojseismicdesigncat = ListProjectInfo.get(0).Project_Seismic_Design_Category__c;
             strcreatedby = ListProjectInfo.get(0).CreatedBy.Name;
             //strpeerreviewer = ListProjectInfo.get(0).Peer_Reviewer__c;  --Modified for release 5.0
             strpeerreviewer = ListProjectInfo.get(0).Estimate_Reviewed_By__r.Name;
             dblgrosswoparking = ListProjectInfo.get(0).Gross_Area_w_o_parking_BGSF__c;
             dateofestimate = ListProjectInfo.get(0).CreatedDate.date();
             costparamdate = ListProjectInfo.get(0).Cost_Parameter_Date__c;
             startconsdate = ListProjectInfo.get(0).Start_Construction__c;
             dblstandardesc = ListProjectInfo.get(0).Location__r.Standard_Escalation__c;
             dbloverridecalsitearea = ListProjectInfo.get(0).Override_Calculated_Site_Area__c;
             dblcalculatedsitearea = ListProjectInfo.get(0).Calculated_Site_Area__c;
             dblenclosedparkingpesf = ListProjectInfo.get(0).Enclosed_parking_PRSF__c;
             strHPProjectType = ListProjectInfo.get(0).Project_Type__c;
             dblsiteinfostrucparking = dblstandalonepg * 400;
             dblsiteinfosurfaceparking = dblsurfaceparking * 350;
             strPurposeOfEstimate = ListProjectInfo.get(0).Purpose_of_Estimate__c;
             //strRegionalPortfolio = ListProjectInfo.get(0).Regional_Portfolio__r.Name; --Modified for release 5.0
             strRegionalPortfolio = ListProjectInfo.get(0).Estimate_Approved_By__r.Name;
             strRequestor = ListProjectInfo.get(0).Requestor__c;

             

             // for uniformatsum reports
            dblDesign = ((Decimal) ListProjectInfo.get(0).Design_and_Site_Contingency__c/100).setScale(2);
            dblGeneral = ((Decimal) ListProjectInfo.get(0).General_Contractor_Overhead_Profit_Bonds__c/100).setScale(2);
            //added conditional to avoid null reference error if no housing plan summary gm-6/7
            if(ListProjectInfo.get(0).Total_Escalation__c <>null){
                dblEscMarkets = ((Decimal) ListProjectInfo.get(0).Total_Escalation__c/100);
            }
            if(strHPProjectType == 'New Construction'){
                dblGeneral = ((Decimal) ListProjectInfo.get(0).General_Contractor_Overhead_Profit_Bonds__c/100).setScale(2);
                if (ListProjectInfo.get(0).Total_Escalation__c <> null) {
                    dblEscMarkets = ((Decimal) ListProjectInfo.get(0).Total_Escalation__c/100);
                }
                else {
                    dblEscMarkets = 0.0;
                }
            }
            if(ListProjectInfo.get(0).Total_Escalation_CPE__c != null){
                dblEscCode = ((Decimal) ListProjectInfo.get(0).Total_Escalation_CPE__c/100);
            }else {
                dblEscCode = 0.00;
            }
            dblConstructArt = (Decimal) ListProjectInfo.get(0).Construction_Contingency__c/100 + (Decimal) ListProjectInfo.get(0).Art_In_Architecture__c/100;
            dblConstruct = (Decimal) ListProjectInfo.get(0).Construction_Contingency__c/100;
            dblArt = (Decimal) ListProjectInfo.get(0).Art_In_Architecture__c/100;
            dblVertical = (Decimal) ListProjectInfo.get(0).Number_of_Stops__c;
            dblSurfaceParkingCost = ListProjectInfo.get(0).Surface_Parking__c * 400;
            dblStructuredParkingCost = ListProjectInfo.get(0).Parking_Within_Building_Structure__c * 350;
            dblOtherDirectCost = ListProjectInfo.get(0).Other_Direct_Cost_TI__c + ListProjectInfo.get(0).Other_Direct_Cost_Core_Shell__c; 
            dblOtherDirectCostTI = ListProjectInfo.get(0).Other_Direct_Cost_TI__c;
            dblOtherDirectCostCoreShell = ListProjectInfo.get(0).Other_Direct_Cost_Core_Shell__c;
            dblProRatedODC = ListProjectInfo.get(0).Prorated_ODC__c;
            dblProRatedOPC = ListProjectInfo.get(0).Prorated_OPC__c;
            dblCoreShellOPC = ListProjectInfo.get(0).Coreshell_OPC__c;
            dblTIOPC = ListProjectInfo.get(0).TI_OPC__c;
            dblTotalUSF = ListProjectInfo.get(0).Useable_Area_Total_USF__c;
			//for professional services percentages -- added for Release 6.0
                dblEDRCPercent = (Decimal) ListProjectInfo.get(0).EDRC__c;
                dblEMICPercent = (Decimal) ListProjectInfo.get(0).EMIC__c;
                dblEDRC = (Decimal) ListProjectInfo.get(0).EDRC__c/100;
                dblEMIC = (Decimal) ListProjectInfo.get(0).EMIC__c/100;            
            
            dblGross  = (Decimal) ListProjectInfo.get(0).Total_GSF__c;
            if (ListProjectInfo.get(0).RecordType.DeveloperName == 'Parking_Garage')
                dblGross  = (Decimal) ListProjectInfo.get(0).Parking_Garage_Gross_Area_SF__c;
            
            dblMult = dblTotalUSF;
            if (ListProjectInfo.get(0).Building_Cost_Type__c.contains('Core/Shell') || ListProjectInfo.get(0).Building_Cost_Type__c =='TI Including Warm Lit Shell' || ListProjectInfo.get(0).Building_Cost_Type__c=='TI Retrofit')
                dblMult = dblGross ;
             
             //calculating markups                          
             dblECCmarkups =  (1 + dblmarkupsDC) * (1 + dblmarkupsGC) * (1 + dblmarkupsCC) * (1 + dblmarkupsAA);     
             
            //calculating totsitearea
            if(dbloverridecalsitearea > 0){
                dbltotsitearea  = dbloverridecalsitearea;
                dbltotsiteareaacres = (dbltotsitearea/43560).setscale(2);
            }else{
                dbltotsitearea  = dblcalculatedsitearea;
                dbltotsiteareaacres = (dbltotsitearea/43560).setscale(2);
            }   
            
                                     
            //calculating parking totals
            dblparkinggrossarea = dblsiteinfostrucparking + dblsiteinfosurfaceparking + dblenclosedparkingpesf;
            dblparkingspaces = dblparkingwthinbuildingstruc + dblstandalonepg + dblsurfaceparking;
            
            //calculating RA Phasing percentages
            List<AggregateResult> arRAPhasingCost = [Select  SUM (Total_Cost_w_Design_Contingency__c) TotalCostDC, SUM (Total_Cost_w_Escalation__c) TotalCostEsc, 
                                                             SUM (Total_Cost_w_General_Conditions__c) TotalCostGC   
                                                       From   NCMT_RA_Phasing__c
                                                      Where   (Project__r.ID = :strProjectID OR Project__r.Name = :strProjectID)  
                                                     Group by Project__c]; 
                                                  
             For(AggregateResult ar :arRAPhasingCost){
                      
                 dblTotalCostDC = (decimal) ar.get('TotalCostDC');
                 dblTotalCostEsc = (decimal) ar.get('TotalCostEsc');
                 dblTotalCostGC = (decimal) ar.get('TotalCostGC');
             }
             //if(strHPProjectType != 'New Construction'){
                //if(dblTotalCostDC > 0 && dblTotalCostDC != null){
                    //dblGeneral = ((dblTotalCostGC - dblTotalCostDC)/dblTotalCostDC).setScale(2);
                    //dblEscMarkets = ((dblTotalCostEsc - dblTotalCostGC)/dblTotalCostGC).setScale(2);
                //}
             //}
                                                            
                      
            List<NCMT_Housing_Plan_Summary__c> Hplist = [Select Workstations_open_office_Use_USF__c, Closed_offices_Use_USF__c, X8_20_person_rooms_Use_USF__c, X20_or_more_person_rooms_Use_USF__c, Teleconference_Use_USF__c,
                                                                Auditorium_sloped_floor_Use_USF__c, General_storage_Use_USF__c, Clinics_health_units_Use_USF__c, Physical_fitness_Use_USF__c, Child_care_Use_USF__c, Libraries_Use_USF__c,
                                                                ADP_high_density_PC_s_Use_USF__c, ADP_mainframe_Use_USF__c, Joint_use_retail_Use_USF__c, Food_service_cafeteria_Use_USF__c, Non_climate_controlled_Use_USF__c,
                                                                Total_USF__c, Enclosed_Parking__c, Total_GSF__c, Total_RSF_w_o_parking__c, Private_toilets_Use_USF__c, High_density_storage_Use_USF__c,
                                                                Climate_controlled_for_artifacts_Use_USF__c, Laboratory_Dry_electronic_Use_USF__c, Laboratory_Wet_chemistry_Use_USF__c, Firing_range_Use_USF__c, Copy_Center_Use_USF__c,
                                                                Credit_Union_Use_USF__c, Transaction_counter_space_Use_USF__c, Kitchen_Break_room_Use_USF__c, Locker_Shower_room_Use_USF__c, Hardened_offices_suites_Use_USF__c,
                                                                Secure_Work_Environment_SWE_Std_Use_USF__c, Secure_Work_Environment_SWE_Enhd_UseUSF__c, Secured_Storage_SCIF_Standard_Use_USF__c, Secured_Storage_SCIF_Enhanced_Use_USF__c,
                                                                Vault_Type_Storage_Use_USF__c, Interview_Detention_Use_USF__c, Non_Marshal_Holding_Cell_Single_Use_USF__c, Non_Marshal_Holding_Cell_Double_Use_USF__c, Light_industrial_Use_USF__c,
                                                                Warehouse_Use_USF__c, Courtroom_district_Ceremonial_Use_USF__c, Courtroom_district_Standard_Use_USF__c, Courtroom_Bankruptcy_Use_USF__c, Courtroom_Magistrate_Use_USF__c, Grand_Jury_Room_Use_USF__c,
                                                                Judicial_hearing_Use_USF__c, Judicial_chambers_Use_USF__c, Enhanced_office_Use_USF__c, USMS_Suite_Administration_Use_USF__c, USMS_Suite_Operations_Use_USF__c, Sally_Port_Use_USF__c,
                                                                Holding_cell_Central_Use_USF__c, Holding_cell_Court_floors_Use_USF__c, User_Defined_Spaces1_Description__c, User_Defined_Spaces2_Description__c, User_Defined_Spaces3_Description__c,
                                                                User_Defined_Spaces1_Use_USF__c, User_Defined_Spaces2_Use_USF__c, User_Defined_Spaces3_Use_USF__c, User_Defined_Spaces1_USF_for_DC__c, User_Defined_Spaces2_USF_for_DC__c,
                                                                User_Defined_Spaces3_USF_for_DC__c, VA_Ambulatory_Surgery_Use_USF__c, VA_Exam_Suite_Use_USF__c, VA_Infusion_Use_USF__c, VA_Intake_Use_USF__c, VA_Pharmacy_Use_USF__c,
                                                                VA_Radiology_Use_USF__c, Data_Center_Use_USF__c,Unfinished_Shell_Area_Use_USF__c, Mailroom_Use_Usf__c, Secure_Mailroom_Use_Usf__c,
                                                                Main_Lobby__c, Atrium_Ground_floor_plan_area__c, Restrooms__c, Ground_floor_circulation__c, Elevator_lobbies__c, Other_circulation__c, Mechanical_Electrical_IT__c, 
                                                                Loading_dock_Recycling_Trash__c, Structural_Area__c, Elevator_shafts__c, Stair_shafts__c, Other_vertical_penetrations__c, Atrium_upper_levels_phantom_floors__c, Conditioned_Core_Area__c
                                                           From  NCMT_Housing_Plan_Summary__c
                                                           Where (Project__r.ID = :strProjectID OR Project__r.Name = :strProjectID) Limit 1];
                                                 
              dblenclosedparking = 0;
              
              dblWorkstationsOpenOffCECCUSF = 0.00; dblClosedOffCECCUSF = 0.00; dbl820PersonroomsCECCUSF  = 0.00;
              dbl20morePersonroomsCECCUSF   = 0.00; dblTeleconferenceCECCUSF = 0.00; dblAuditoriumCECCUSF  = 0.00;
              dblGeneralStorageCECCUSF  = 0.00; dblClinicsHealthCECCUSF  = 0.00; dblFitCECCUSF  = 0.00;
              dblChildcareCECCUSF  = 0.00; dblLibrariesCECCUSF  = 0.00; dblADPHighCECCUSF  = 0.00;
              dblADPMainCECCUSF  = 0.00; dblJoinRetailCECCUSF  = 0.00;  dblFoodCECCUSF   = 0.00; dblNonClimateCECCUSF  = 0.00;
              dblhighdensitystorageCECCUSF  = 0.00;  dblClimateControlledCECCUSF  = 0.00; dbllabdryCECCUSF = 0.00;  dblprivatetoiletsCECCUSF  = 0.00; 
              dbllabwetCECCUSF = 0.00;  dblfiringrangeCECCUSF = 0.00;  dblcopycenterCECCUSF = 0.00;  dblcreditunionCECCUSF = 0.00;
              dblTranscountCECCUSF = 0.00;  dblkitchenbreakCECCUSF = 0.00; dbllockershowerCECCUSF = 0.00; dblhardenedoffCECCUSF = 0.00;    
              dblswestdCECCUSF = 0.00; dblsweenhdCECCUSF  = 0.00; dblscifstdCECCUSF = 0.00;  dblscifenhdCECCUSF = 0.00; dblvaultstgCECCUSF = 0.00; 
              dblinterviewdetCECCUSF = 0.00; dblnonmarshellsingleCECCUSF = 0.00;  dblnonmarshelldoubleCECCUSF = 0.00;  dbllightindCECCUSF  = 0.00; 
              dblwarehouseCECCUSF = 0.00;  dblcourtceremonialCECCUSF = 0.00; dblcourtstandardCECCUSF  = 0.00; dblcourtbankruptcyCECCUSF = 0.00; 
              dblcourtmagistrateCECCUSF = 0.00;  dblgrandjuryCECCUSF = 0.00;  dbljudicialhearingCECCUSF = 0.00;  dbljudicialchambersCECCUSF = 0.00; 
              dblenhancedoffCECCUSF = 0.00;  dblusmsadminCECCUSF = 0.00; dblusmsopsCECCUSF = 0.00; dblsallyportCECCUSF = 0.00;  dblholdingcellcentralCECCUSF = 0.00; 
              dblholidngcellcourtCECCUSF  = 0.00;  dbluserdef1spacesCECCUSF = 0.00; dblMailroomCECCUSF = 0.00; dblSecureMailroomCECCUSF = 0.0;
              dbluserdef2spacesCECCUSF = 0.00;  dbluserdef3spacesCECCUSF = 0.00; dblAmbulatorySurgeryCECCUSF = 0.00; 
              dblExamSuiteCECCUSF = 0.00; dblInfusionCECCUSF = 0.00; dblIntakeCECCUSF = 0.00; dblPharmacyCECCUSF = 0.00; dblRadiologyCECCUSF = 0.00; dblDataCenterCECCUSF = 0.00;
               
               dblWorkstationsOpenOff = 0; dblClosedOff = 0;  dbl820Personrooms = 0; dblUnfinishedShellArea = 0;
               dbl20morePersonrooms = 0; dblTeleconference  = 0; dblAuditorium = 0; 
               dblGeneralStorage = 0; dblClinicsHealth = 0; dblFit = 0; 
               dblChildcare = 0; dblLibraries = 0; dblADPHigh = 0; 
               dblADPMain  = 0; dblJoinRetail = 0; dblFood = 0; 
               dblNonClimate  = 0; dblprivatetoilets = 0; 
               dblhighdensitystorage = 0; dblclimatecontrolled = 0; dbllabwet = 0; dbllabdry = 0;
               dblfiringrange = 0;  dblcopycenter = 0; dblcreditunion = 0;  dblTranscount = 0; 
               dblkitchenbreak = 0; dbllockershower = 0; dblhardenedoff = 0;dblswestd = 0; 
               dblsweenhd  = 0; dblscifstd = 0; dblscifenhd = 0; dblvaultstg = 0;  dblinterviewdet = 0; 
               dblnonmarshellsingle = 0; dblnonmarshelldouble = 0; dbllightind  = 0; dblwarehouse = 0; 
               dblcourtceremonial = 0; dblcourtstandard  = 0;  dblcourtbankruptcy = 0; dblcourtmagistrate = 0; 
               dblgrandjury = 0; dbljudicialhearing = 0; dbljudicialchambers = 0; dblenhancedoff = 0; 
               dblusmsadmin = 0; dblusmsops = 0; dblsallyport = 0; dblholdingcellcentral = 0; 
               dblholidngcellcourt  = 0; dbluserdef1spaces = 0; dbluserdef2spaces = 0; 
               dbluserdef3spaces = 0; dblAmbulatorySurgery = 0; dblExamSuite =0; 
               dblInfusion = 0; dblIntake = 0; dblPharmacy = 0; dblRadiology = 0; dblDataCenter = 0;
               dblMailroom = 0; dblSecureMailroom = 0;
               
               dblMain_Lobby = 0; dblAtrium_Ground_floor_plan_area = 0; dblEnclosed_Parking = 0; dblRestrooms = 0; 
               dblGround_floor_circulation = 0; dblElevator_lobbies = 0; dblOther_circulation = 0; dblMechanical_Electrical_IT = 0; 
               dblLoading_dock_Recycling_Trash = 0; dblStructural_Area = 0; dblElevator_shafts = 0; dblStair_shafts = 0; 
               dblOther_vertical_penetrations = 0; dblAtrium_upper_levels_phantom_floors = 0; dblConditioned_Core_Area = 0; 
                    
                                                                   
            if (Hplist.size() > 0){
             
                dblUnfinishedShellArea = Hplist.get(0).Unfinished_Shell_Area_Use_USF__c;
                dblWorkstationsOpenOff = Hplist.get(0).Workstations_open_office_Use_USF__c;
                dblClosedOff = Hplist.get(0).Closed_offices_Use_USF__c;
                dbl820Personrooms = Hplist.get(0).X8_20_person_rooms_Use_USF__c;
                dbl20morePersonrooms = Hplist.get(0).X20_or_more_person_rooms_Use_USF__c;
                dblTeleconference =  Hplist.get(0).Teleconference_Use_USF__c;
                dblAuditorium =  Hplist.get(0).Auditorium_sloped_floor_Use_USF__c;
                dblGeneralStorage =  Hplist.get(0).General_storage_Use_USF__c;
                dblClinicsHealth =  Hplist.get(0).Clinics_health_units_Use_USF__c;
                dblFit = Hplist.get(0).Physical_fitness_Use_USF__c;
                dblChildcare = Hplist.get(0).Child_care_Use_USF__c;
                dblLibraries = Hplist.get(0).Libraries_Use_USF__c;
                dblADPHigh = Hplist.get(0).ADP_high_density_PC_s_Use_USF__c;
                dblADPMain = Hplist.get(0).ADP_mainframe_Use_USF__c;
                dblJoinRetail = Hplist.get(0).Joint_use_retail_Use_USF__c;
                dblFood = (Hplist.get(0).Food_service_cafeteria_Use_USF__c != null ? 
                    Hplist.get(0).Food_service_cafeteria_Use_USF__c : 0);
                dblNonClimate = (Hplist.get(0).Non_climate_controlled_Use_USF__c != null ? 
                    Hplist.get(0).Non_climate_controlled_Use_USF__c : 0);
                dblprivatetoilets = Hplist.get(0).Private_toilets_Use_USF__c;
                dblhighdensitystorage = Hplist.get(0).High_density_storage_Use_USF__c;
                dblclimatecontrolled = (Hplist.get(0).Climate_controlled_for_artifacts_Use_USF__c != null ? 
                    Hplist.get(0).Climate_controlled_for_artifacts_Use_USF__c : 0);
                dbllabdry = (Hplist.get(0).Laboratory_Dry_electronic_Use_USF__c != null ? 
                    Hplist.get(0).Laboratory_Dry_electronic_Use_USF__c : 0);
                dbllabwet = Hplist.get(0).Laboratory_Wet_chemistry_Use_USF__c;
                dblfiringrange = Hplist.get(0).Firing_range_Use_USF__c;
                dblcopycenter  = Hplist.get(0).Copy_Center_Use_USF__c;
                dblcreditunion = Hplist.get(0).Credit_Union_Use_USF__c;
                dblTranscount  = Hplist.get(0).Transaction_counter_space_Use_USF__c;
                dblkitchenbreak = Hplist.get(0).Kitchen_Break_room_Use_USF__c;
                dbllockershower = Hplist.get(0).Locker_Shower_room_Use_USF__c;
                dblhardenedoff   = Hplist.get(0).Hardened_offices_suites_Use_USF__c;
                dblswestd   = Hplist.get(0).Secure_Work_Environment_SWE_Std_Use_USF__c;
                dblsweenhd   = Hplist.get(0).Secure_Work_Environment_SWE_Enhd_UseUSF__c;
                dblscifstd   = Hplist.get(0).Secured_Storage_SCIF_Standard_Use_USF__c ;
                dblscifenhd   = Hplist.get(0).Secured_Storage_SCIF_Enhanced_Use_USF__c ;
                dblvaultstg   = Hplist.get(0).Vault_Type_Storage_Use_USF__c;
                dblinterviewdet   = Hplist.get(0).Interview_Detention_Use_USF__c;
                dblnonmarshellsingle   = Hplist.get(0).Non_Marshal_Holding_Cell_Single_Use_USF__c;
                dblnonmarshelldouble   = Hplist.get(0).Non_Marshal_Holding_Cell_Double_Use_USF__c;
                dbllightind   = Hplist.get(0).Light_industrial_Use_USF__c;
                dblwarehouse   = Hplist.get(0).Warehouse_Use_USF__c;
                dblcourtceremonial   = Hplist.get(0).Courtroom_district_Ceremonial_Use_USF__c;
                dblcourtstandard   = Hplist.get(0).Courtroom_district_Standard_Use_USF__c;
                dblcourtbankruptcy   = Hplist.get(0).Courtroom_Bankruptcy_Use_USF__c;
                dblcourtmagistrate   = Hplist.get(0).Courtroom_Magistrate_Use_USF__c;
                dblgrandjury   = Hplist.get(0).Grand_Jury_Room_Use_USF__c;
                dbljudicialhearing   = Hplist.get(0).Judicial_hearing_Use_USF__c;
                dbljudicialchambers   = Hplist.get(0).Judicial_chambers_Use_USF__c;
                dblenhancedoff   = Hplist.get(0).Enhanced_office_Use_USF__c;
                dblusmsadmin   = Hplist.get(0).USMS_Suite_Administration_Use_USF__c;
                dblusmsops =  Hplist.get(0).USMS_Suite_Operations_Use_USF__c;
                dblsallyport   = Hplist.get(0).Sally_Port_Use_USF__c;
                dblholdingcellcentral   = Hplist.get(0).Holding_cell_Central_Use_USF__c;
                dblholidngcellcourt   = Hplist.get(0).Holding_cell_Court_floors_Use_USF__c;
                struserdef1desc   = Hplist.get(0).User_Defined_Spaces1_Description__c;
                struserdef2desc   = Hplist.get(0).User_Defined_Spaces2_Description__c;
                struserdef3desc   = Hplist.get(0).User_Defined_Spaces3_Description__c;
                dbluserdef1spaces   = Hplist.get(0).User_Defined_Spaces1_Use_USF__c;
                dbluserdef2spaces   = Hplist.get(0).User_Defined_Spaces2_Use_USF__c;
                dbluserdef3spaces   = Hplist.get(0).User_Defined_Spaces3_Use_USF__c ;
                dbluserdef1dc = Hplist.get(0).User_Defined_Spaces1_USF_for_DC__c;
                dbluserdef2dc = Hplist.get(0).User_Defined_Spaces2_USF_for_DC__c;
                dbluserdef3dc = Hplist.get(0).User_Defined_Spaces3_USF_for_DC__c;
                dblAmbulatorySurgery = Hplist.get(0).VA_Ambulatory_Surgery_Use_USF__c;
                dblExamSuite = Hplist.get(0).VA_Exam_Suite_Use_USF__c;
                dblInfusion = Hplist.get(0).VA_Infusion_Use_USF__c;
                dblIntake = Hplist.get(0).VA_Intake_Use_USF__c;
                dblPharmacy = Hplist.get(0).VA_Pharmacy_Use_USF__c;
                dblRadiology = Hplist.get(0).VA_Radiology_Use_USF__c;
                dblDataCenter = Hplist.get(0).Data_Center_Use_USF__c;
                dblMailroom = (Hplist.get(0).Mailroom_Use_USF__c != null ? 
                    Hplist.get(0).Mailroom_Use_USF__c : 0);
                dblSecureMailroom = (Hplist.get(0).Secure_Mailroom_Use_USF__c != null ? 
                    Hplist.get(0).Secure_Mailroom_Use_USF__c : 0);                
                
                dblMain_Lobby = Hplist.get(0).Main_Lobby__c; 
                dblAtrium_Ground_floor_plan_area = Hplist.get(0).Atrium_Ground_floor_plan_area__c; 
                dblEnclosed_Parking = Hplist.get(0).Enclosed_Parking__c;
                dblRestrooms = Hplist.get(0).Restrooms__c; 
                dblGround_floor_circulation = Hplist.get(0).Ground_floor_circulation__c;
                dblElevator_lobbies = Hplist.get(0).Elevator_lobbies__c;
                dblOther_circulation = Hplist.get(0).Other_circulation__c;
                dblMechanical_Electrical_IT = Hplist.get(0).Mechanical_Electrical_IT__c; 
                dblLoading_dock_Recycling_Trash = Hplist.get(0).Loading_dock_Recycling_Trash__c;
                dblStructural_Area = Hplist.get(0).Structural_Area__c;
                dblElevator_shafts = Hplist.get(0).Elevator_shafts__c;
                dblStair_shafts = Hplist.get(0).Stair_shafts__c; 
                dblOther_vertical_penetrations = Hplist.get(0).Other_vertical_penetrations__c;
                dblAtrium_upper_levels_phantom_floors = Hplist.get(0).Atrium_upper_levels_phantom_floors__c;
                dblConditioned_Core_Area = Hplist.get(0).Conditioned_Core_Area__c;
               
                dbltotusf = Math.round(Hplist.get(0).Total_USF__c);
                dblenclosedparking = Math.Round(Hplist.get(0).Enclosed_Parking__c);
                dbltotgsf = Hplist.get(0).Total_GSF__c;
                dbltotrsfwoparking = (Hplist.get(0).Total_RSF_w_o_parking__c).setscale(0);
                
            }
            
            ID costsummaryid;
            dbluseableareafinished =0.00;
            decimal dblTICOSTUSF = 0;
            decimal dblTRCSCOSTUSF = 0;
            string strspacetype;
            
            List<NCMT_Project_Cost_Summary__c> projsumlist = [select Name
                                                                From NCMT_Project_Cost_Summary__c
                                                                where (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID) limit 1];                    //(Project_Name__c = :strProjectID ) limit 1];  
                                                                
                                                                
            costsummaryid = projsumlist[0].Id;
             
            List<AggregateResult> arTITRCSCost = [Select  TI_TRCS_Cost_Parameter__r.Space_Type__c spacetype, SUM (TI_Total_Cost__c) TICOST, SUM (TRCS_Total_Cost__c) TRCSCOST   
                                                   From   NCMT_TI_TRCS_Cost_Detail__c
                                                  Where   NCMT_Project_ID__c = :strProjectName 
                                                  and     TI_TRCS_Cost_Criterion__c != 'Building Demolition and Abatement'
                                                  Group by TI_TRCS_Cost_Parameter__r.Space_Type__c]; 
                                                  
             For(AggregateResult ar :arTITRCSCost){
                      
                 dblTICOSTUSF = (decimal) ar.get('TICOST');
                 dblTRCSCOSTUSF = (decimal) ar.get('TRCSCOST');
                 strspacetype = (string) ar.get('spacetype');
             
                 if(strspacetype == 'General Office Space Type, 100% Open'){
                    dblWorkstationsOpenOffCECCUSF = (dblWorkstationsOpenOff == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblWorkstationsOpenOff).setscale(2));
                    System.debug('dblWorkstationsOpenOffCECCUSF: ' + dblWorkstationsOpenOffCECCUSF);
                 }else if(strspacetype == 'General Office Space Type, 20% Open'){
                    dblClosedOffCECCUSF = (dblClosedOff == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblClosedOff).setscale(2)); 
                    
                 }else if(strspacetype == 'Private Toilet'){
                    dblprivatetoiletsCECCUSF = (dblprivatetoilets == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblprivatetoilets).setscale(2)); 
                    
                 }else if(strspacetype == 'Conference/Classrooms'){
                    dbl820PersonroomsCECCUSF = (dbl820Personrooms == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/(dbl20morePersonrooms + dbl820Personrooms)).setscale(2));
                    
                    // for 20-more person rooms
                    dbl20morePersonroomsCECCUSF = (dbl20morePersonrooms == 0 ? 0 :((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/(dbl20morePersonrooms + dbl820Personrooms)).setscale(2));
                    
                 }else if(strspacetype == 'Teleconference'){
                    dblTeleconferenceCECCUSF = (dblTeleconference == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblTeleconference).setscale(2));
                    
                 }else if(strspacetype == 'Auditorium'){
                    dblAuditoriumCECCUSF = (dblAuditorium == 0 ? 0 :
                        ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblAuditorium).setscale(2));
                 }else if(strspacetype == 'General Storage'){
                    dblGeneralStorageCECCUSF = (dblGeneralStorage == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblGeneralStorage).setscale(2));
                    
                 }else if(strspacetype == 'High Density Storage'){
                    dblhighdensitystorageCECCUSF = (dblhighdensitystorage == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblhighdensitystorage).setscale(2)); 
                    
                 }else if(strspacetype == 'Clinic/Health Unit'){
                    dblClinicsHealthCECCUSF = (dblClinicsHealth == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblClinicsHealth).setscale(2));
                    
                 }else if(strspacetype == 'Fitness/Exercise'){
                    dblFitCECCUSF = (dblFit == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblFit).setscale(2));
                    
                 }else if(strspacetype == 'Childcare TI'){
                    dblChildcareCECCUSF = (dblChildcare == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblChildcare).setscale(2));
                    
                 }else if(strspacetype == 'Library'){
                    dblLibrariesCECCUSF = (dblLibraries == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblLibraries).setscale(2));
                    
                 }else if(strspacetype == 'ADP - High Density PCs'){
                    dblADPHighCECCUSF = (dblADPHigh == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblADPHigh).setscale(2));
                    
                 }else if(strspacetype == 'ADP Mainframe'){
                    dblADPMainCECCUSF = (dblADPMain == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblADPMain).setscale(2));
                    
                 }else if(strspacetype == 'Joint Use-Retail'){
                    dblJoinRetailCECCUSF = (dblJoinRetail == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblJoinRetail).setscale(2));
                    
                 }else if(strspacetype == 'Food Service/Cafeteria'){
                    dblFoodCECCUSF = (dblFood == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblFood).setscale(2));
                    
                 }else if(strspacetype == 'Exhibit Hall Non-Climate Controlled'){
                    dblNonClimateCECCUSF = (dblNonClimate == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblNonClimate).setscale(2));
                    
                 }else if(strspacetype == 'Exhibit Hall Climate Controlled'){
                    dblClimateControlledCECCUSF = (dblClimateControlled == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblClimateControlled).setscale(2));
                    
                 }else if(strspacetype == 'Dry/Electronic Lab'){
                    dbllabdryCECCUSF = (dbllabdry == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dbllabdry).setscale(2));
                    
                 }else if(strspacetype == 'Wet Lab'){
                    dbllabwetCECCUSF = (dbllabwet == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dbllabwet).setscale(2));
                    
                  }else if(strspacetype == 'Firing Range'){
                    dblfiringrangeCECCUSF = (dblfiringrange == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblfiringrange).setscale(2));
                    
                  }else if(strspacetype == 'Copy Center'){
                    dblcopycenterCECCUSF = (dblcopycenter  == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblcopycenter).setscale(2));
                    
                  }else if(strspacetype == 'Credit Union'){
                    dblcreditunionCECCUSF = (dblcreditunion == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblcreditunion).setscale(2));
                    
                  }else if(strspacetype == 'Public Transaction Space, Tenant Improvement'){
                    dblTranscountCECCUSF = (dblTranscount == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblTranscount).setscale(2));
                    
                  }else if(strspacetype == 'Kitchen-Break room, Tenant Improvement'){
                    dblkitchenbreakCECCUSF = (dblkitchenbreak == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblkitchenbreak).setscale(2));
                    
                   }else if(strspacetype == 'Shower and Locker Rooms, Tenant Improvement'){
                    dbllockershowerCECCUSF = (dbllockershower == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dbllockershower).setscale(2));
                    
                   }else if(strspacetype == 'Hardened Suite: 20% open'){
                    dblhardenedoffCECCUSF = (dblhardenedoff == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblhardenedoff).setscale(2));
                    
                   }else if(strspacetype == 'Secure Work Environment'){
                    dblswestdCECCUSF = (dblswestd == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblswestd).setscale(2));
                    
                   }else if(strspacetype == 'Secure Work Environment: Enhanced'){
                    dblsweenhdCECCUSF = (dblsweenhd  == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblsweenhd).setscale(2));
                    
                   }else if(strspacetype == 'Secured Storage/SCIF Standard'){
                    dblscifstdCECCUSF = (dblscifstd == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblscifstd).setscale(2));
                    
                   }else if(strspacetype == 'Secured Storage/SCIF Enhanced'){
                    dblscifenhdCECCUSF = (dblscifenhd == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblscifenhd).setscale(2));
                    
                   }else if(strspacetype == 'Vaults/Secure Storage, Tenant Improvement'){
                    dblvaultstgCECCUSF = (dblvaultstg == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblvaultstg).setscale(2));
                    
                   }else if(strspacetype == 'Detention Suite - exc holding, Tenant Improvement'){
                    dblinterviewdetCECCUSF = (dblinterviewdet == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblinterviewdet).setscale(2));
                    
                   }else if(strspacetype == 'Holding Cell - Single, Tenant Improvement'){
                    dblnonmarshellsingleCECCUSF = (dblnonmarshellsingle == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblnonmarshellsingle).setscale(2));
                    
                   }else if(strspacetype == 'Holding Cell - Group, Tenant Improvement'){
                    dblnonmarshelldoubleCECCUSF = (dblnonmarshelldouble == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblnonmarshelldouble).setscale(2));
                    
                   }else if(strspacetype == 'Light Industrial'){
                    dbllightindCECCUSF = (dbllightind  == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dbllightind).setscale(2));
                    
                   }else if(strspacetype == 'Warehouse'){
                    dblwarehouseCECCUSF = (dblwarehouse == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblwarehouse).setscale(2));
                    
                   }else if(strspacetype == 'Courtroom - District Court'){
                    dblcourtstandardCECCUSF = (dblcourtstandard  == 0 ? 0 :((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblcourtstandard).setscale(2));
                    
                   }else if(strspacetype == 'Courtroom - Bankruptcy'){
                    dblcourtbankruptcyCECCUSF = (dblcourtbankruptcy == 0 ? 0 :   ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblcourtbankruptcy).setscale(2));
                    
                   }else if(strspacetype == 'Courtroom - Magistrate'){
                    dblcourtmagistrateCECCUSF = (dblcourtmagistrate == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblcourtmagistrate).setscale(2));
                    
                   }else if(strspacetype == 'Courtroom, District Grand Jury'){
                    dblgrandjuryCECCUSF = (dblgrandjury == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblgrandjury).setscale(2));
                    
                   }else if(strspacetype == 'Judicial Hearing Room'){
                    dbljudicialhearingCECCUSF = (dbljudicialhearing == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dbljudicialhearing).setscale(2));
                    
                   }else if(strspacetype == 'Judicial Chambers'){
                    dbljudicialchambersCECCUSF = (dbljudicialchambers == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dbljudicialchambers).setscale(2));
                    
                   }else if(strspacetype == 'Enhanced Office Space Type'){
                    dblenhancedoffCECCUSF = (dblenhancedoff == 0 ? 0 :    ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblenhancedoff).setscale(2));
                    
                   }else if(strspacetype == 'USMS Suite: Administrative Area'){
                    dblusmsadminCECCUSF = (dblusmsadmin == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblusmsadmin).setscale(2));
                    
                   }else if(strspacetype == 'USMS Operations Area'){
                    dblusmsopsCECCUSF = (dblusmsops == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblusmsops).setscale(2));
                     
                   }else if(strspacetype == 'USMS Suite, Sally Port'){
                    dblsallyportCECCUSF = (dblsallyport == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblsallyport).setscale(2));
                    
                   }else if(strspacetype == 'USMS Suite: Central Holding Area'){
                    dblholdingcellcentralCECCUSF = (dblholdingcellcentral == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblholdingcellcentral).setscale(2));
                    
                   }else if(strspacetype == 'Holding cell'){
                    dblholidngcellcourtCECCUSF = (dblholidngcellcourt  == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblholidngcellcourt).setscale(2));
                    
                   }else if(strspacetype == 'Medical Spaces - Ambulatory Surgery'){
                    dblAmbulatorySurgeryCECCUSF = (dblAmbulatorySurgery  == 0 ? 0 :  ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblAmbulatorySurgery).setscale(2));
                    
                   }else if(strspacetype == 'Medical Spaces - Exam Suite'){
                    dblExamSuiteCECCUSF = (dblExamSuite  == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblExamSuite).setscale(2));
                    
                   }else if(strspacetype == 'Medical Spaces - Infusion'){
                    dblInfusionCECCUSF = (dblInfusion  == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblInfusion).setscale(2));
                    
                   }else if(strspacetype == 'Medical Spaces - Intake'){
                    dblIntakeCECCUSF = (dblIntake  == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblIntake).setscale(2));
                    
                   }else if(strspacetype == 'Medical Spaces - Pharmacy'){
                    dblPharmacyCECCUSF = (dblPharmacy  == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblPharmacy).setscale(2));
                    
                   }else if(strspacetype == 'Medical Spaces - Radiology'){
                    dblRadiologyCECCUSF = (dblRadiology  == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblRadiology).setscale(2));
                    
                   }else if(strspacetype == 'Data Center'){
                    dblDataCenterCECCUSF = (dblDataCenter  == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblDataCenter).setscale(2));
                    
                   }else if(strspacetype == 'Mailroom'){
                    dblMailroomCECCUSF = (dblMailroom  == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblMailroom).setscale(2));
                    
                   }else if(strspacetype == 'Secure Mailroom'){
                    dblSecureMailroomCECCUSF = (dblSecureMailroom  == 0 ? 0 : ((dblTICOSTUSF * dblTIAdjFactor * dblECCmarkups)/dblSecureMailroom).setscale(2));
                    
                   }                                                                 
             }
             
             //calculating user defined spaces for housing plan
             dbluserdef1spacesCECCUSF = (dbluserdef1dc == null || dblTIAdjFactor == null ? 0.0 :
                    dbluserdef1dc * dblTIAdjFactor);
             
             dbluserdef2spacesCECCUSF = (dbluserdef2dc == null || dblTIAdjFactor == null ? 0.0 :
                dbluserdef2dc * dblTIAdjFactor);
             
             dbluserdef3spacesCECCUSF = (dbluserdef3dc == null || dblTIAdjFactor == null ? 0.0 :
                dbluserdef3dc * dblTIAdjFactor);
              
             
            dbluseableareafinished = (dbltotusf - dbluseableareaunfinishedusf);
 
            
            // Project Parameters
            List<Project_Level_Parameter__c> objPP = [Select  SiteRemoteness_Cost_Impact__c, Foot_Print_Area__c, Basement_Story_Height__c, Basement_SF__c, Finished_Site_Area__c,
                                                              Elevated_Floor_Area_SF__c, Total_Roof_Area_SF__c, Cladding_Skin_Ratio_SF__c, 
                                                              Stair_Analysis_Total_Flights__c, Plumbing_Fixtures_EA__c, 
                                                              HVAC_Cooling_Load_Tons__c, Electrical_Load_kW__c, Curtain_Wall_Percentage_SF__c, Window_Percentage_SF__c, Base_SF__c, Mid_SF__c, Top_SF__c,
                                                              Level_of_Protection__c,   Use_Level_of_Protection__c, Over_percentage_of_Perimeter__c,
                                                              Change_Setback_100__c, Default_Setback_100_FT__c, Default_Adj_LOP_Setback_FT__c, Adj_LOP_Setback__c, Default_Finished_Site_Area__c  
                                                        From  Project_Level_Parameter__c 
                                                        Where (NCMT_Project__r.ID = :strProjectID OR NCMT_Project__r.Name = :strProjectID)  Limit 1];                   //NCMT_Project__c = :strProjectID];
                                                        
            dblsiteremotnesscostimact = 0;
            dblFootPrintArea = 0;
            dblBasementStoryHeight = 0.00;
            dblBasementSF= 0.00;
            dblElevatedFloorAreaSF = 0.00;
            dblTotalRoofAreaSF= 0.00;
            dblCladdingSkinRatioSF= 0.00;
            dblStairAnalysisTotalFlights= 0.00;
            dblPlumbingFixturesEA = 0.00;
            dblHVACCoolingLoadTons = 0.00;
            dblElectricalLoadkW = 0.00;
            Decimal dblwindowarea = 0.00;
            Decimal dblopaquearea = 0.00;
            dblblastwinFac = 0.00;
            Decimal dblblastwindows = 0.00;
            Decimal dblblastFacade = 0.00;
            Decimal dblusesetback = 0.00;
            Decimal dbldefsetback = 0.00;
            Decimal dbluseadjsetback = 0.00;
            Decimal dbldefadjsetback = 0.00;
            Decimal dbluselvlprot = 0.00;
            Decimal dbllvlprot = 0.00;
            Decimal dbluselvlprot1 = 0.00;
            Decimal dbllvlprot1 = 0.00;
            Decimal dblvalue = 0.00;
            Decimal dblchangesetback = 0.00;
            Decimal dblUseOverPerimeter = 0.00;
            dblchangesetbackcost = 0.00;
            Decimal dbladjchangesetback = 0.00;
            dblchangeadjsetbackcost = 0.00;
            Decimal dblmulti = 0.00;
            String  struselvlprot;
            String  strlvlprot;
            String  strSOQL;
                                                        
            if (objPP.size() > 0){
                dblsiteremotnesscostimact = (Decimal) (objPP.get(0).SiteRemoteness_Cost_Impact__c/100)+1;
                dblFootPrintArea = (Decimal) objPP.get(0).Foot_Print_Area__c;
                dblBasementStoryHeight = (Decimal) objPP.get(0).Basement_Story_Height__c ;
                dblBasementSF= (Decimal) objPP.get(0).Basement_SF__c;
                dblElevatedFloorAreaSF = (Decimal) objPP.get(0).Elevated_Floor_Area_SF__c ;
                dblTotalRoofAreaSF= (Decimal) objPP.get(0).Total_Roof_Area_SF__c;
                dblCladdingSkinRatioSF= (Decimal) objPP.get(0).Cladding_Skin_Ratio_SF__c;
                dblStairAnalysisTotalFlights= (Decimal) objPP.get(0).Stair_Analysis_Total_Flights__c;
                dblPlumbingFixturesEA = (Decimal) objPP.get(0).Plumbing_Fixtures_EA__c;
                dblHVACCoolingLoadTons = (Decimal) objPP.get(0).HVAC_Cooling_Load_Tons__c;
                dblElectricalLoadkW = (Decimal) objPP.get(0).Electrical_Load_kW__c;
                dblwindowarea = (Decimal) objPP.get(0).Curtain_Wall_Percentage_SF__c + (Decimal) objPP.get(0).Window_Percentage_SF__c;
                dblopaquearea = (Decimal) objPP.get(0).Base_SF__c + (Decimal) objPP.get(0).Mid_SF__c + (Decimal) objPP.get(0).Top_SF__c;
                struselvlprot = (string) objPP.get(0).Use_Level_of_Protection__c;
                strlvlprot = (string) objPP.get(0).Level_of_Protection__c;
                dblUseOverPerimeter = (Decimal) objPP.get(0).Over_percentage_of_Perimeter__c/100;
                dblusesetback = (Decimal) objPP.get(0).Change_Setback_100__c;
                dbldefsetback = (Decimal) objPP.get(0).Default_Setback_100_FT__c;
                dbluseadjsetback = (Decimal) objPP.get(0).Adj_LOP_Setback__c;
                dbldefadjsetback = (Decimal) objPP.get(0).Default_Adj_LOP_Setback_FT__c;
                if(strHPProjectType != 'New Construction'){
                    dblfinsite = (Decimal) objPP.get(0).Finished_Site_Area__c;
                }
            } 
            
            string setAssignCustom1 = 'Blast Resistance - Windows';
            string setAssignCustom2 = 'Blast Resistance - Façade and Structure';
            Integer intYear = Integer.valueOf([SELECT MAX(Cost_Parameter_Date_FY__c) FiscalYear FROM NCMT_Project__c Where ID = :strProjectID][0].get('FiscalYear'));
            
            showLevel3 = intYear > 2019;
            string strFiscalYear = String.ValueOf(intYear);
            SYstem.debug('FISCAL YEAR IS!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ' +strFiscalYear);
            StrSOQL =   'Select  ID, Security_Criterion__c ,Level_I_Minimum__c, Level_II_Low__c, Level_III_Medium__c , Level_IV_High__c , Level_V_Very_High__c'+ ' ' +
                       'From  NCMT_Security_Parameters__c'+ ' ' +    
                       'Where Fiscal_Year__c = :strFiscalYear'+ ' ' +
                       'And   (Security_Criterion__c = :setAssignCustom1 OR Security_Criterion__c = :setAssignCustom2)';
                       
            List<NCMT_Security_Parameters__c> objSecurityParameters = Database.query(StrSOQL);         
        
        for(NCMT_Security_Parameters__c objRecord: objSecurityParameters) {
        
             if(objRecord.Security_Criterion__c == 'Blast Resistance - Windows'){
                if(struselvlprot == 'Level I - Minimum'){
                    dbluselvlprot = objRecord.Level_I_Minimum__c; 
                }else if(struselvlprot == 'Level II - Low'){
                    dbluselvlprot = objRecord.Level_II_Low__c;
                }else if(struselvlprot == 'Level III - Medium'){
                    dbluselvlprot = objRecord.Level_III_Medium__c;
                }else if(struselvlprot == 'Level IV - High'){
                    dbluselvlprot = objRecord.Level_IV_High__c;
                }else if(struselvlprot == 'Level V - Very High'){
                    dbluselvlprot = objRecord.Level_V_Very_High__c;
                }
                
                if(strlvlprot == 'Level I - Minimum'){
                    dbllvlprot = objRecord.Level_I_Minimum__c; 
                }else if(strlvlprot == 'Level II - Low'){
                    dbllvlprot = objRecord.Level_II_Low__c;
                }else if(strlvlprot == 'Level III - Medium'){
                    dbllvlprot = objRecord.Level_III_Medium__c;
                }else if(strlvlprot == 'Level IV - High'){
                    dbllvlprot = objRecord.Level_IV_High__c;
                }else if(strlvlprot == 'Level V - Very High'){
                    dbllvlprot = objRecord.Level_V_Very_High__c;
                }
             }
         
             if(objRecord.Security_Criterion__c == 'Blast Resistance - Façade and Structure'){
                if(struselvlprot == 'Level I - Minimum'){
                    dbluselvlprot1 = objRecord.Level_I_Minimum__c; 
                }else if(struselvlprot == 'Level II - Low'){
                    dbluselvlprot1 = objRecord.Level_II_Low__c;
                }else if(struselvlprot == 'Level III - Medium'){
                    dbluselvlprot1 = objRecord.Level_III_Medium__c;
                }else if(struselvlprot == 'Level IV - High'){
                    dbluselvlprot1 = objRecord.Level_IV_High__c;
                }else if(struselvlprot == 'Level V - Very High'){
                    dbluselvlprot1 = objRecord.Level_V_Very_High__c;
                }
                
                if(strlvlprot == 'Level I - Minimum'){
                    dbllvlprot1 = objRecord.Level_I_Minimum__c; 
                }else if(strlvlprot == 'Level II - Low'){
                    dbllvlprot1 = objRecord.Level_II_Low__c;
                }else if(strlvlprot == 'Level III - Medium'){
                    dbllvlprot1 = objRecord.Level_III_Medium__c;
                }else if(strlvlprot == 'Level IV - High'){
                    dbllvlprot1 = objRecord.Level_IV_High__c;
                }else if(strlvlprot == 'Level V - Very High'){
                    dbllvlprot1 = objRecord.Level_V_Very_High__c;
                }
             }
         
        }
        
        dblblastwindows = (dblwindowarea * (dbluselvlprot-dbllvlprot));
        dblblastFacade = (dblopaquearea * (dbluselvlprot1-dbllvlprot1));
        
        dblblastwinFac = Math.Ceil(((dblblastwindows + dblblastFacade) * dblUseOverPerimeter)) * dblECCmarkups.setscale(0);
        
        // for calculating setback
        dblvalue = (strlvlprot == 'Level IV - High' || strlvlprot == 'Level V - Very High' ? 50 : 30);
        
        
        dblmulti = (strlvlprot == struselvlprot ?  1 : 1-dblUseOverPerimeter);
        
        dblchangesetback = Math.Max((dbldefsetback - dblusesetback),0);
        
        if(dblchangesetback > dblvalue){
            dblchangesetbackcost = 0;
        }else{
            dblchangesetbackcost = (dblchangesetback == 0 ? 0 :
                Math.Ceil(((dblwindowarea * dbllvlprot) + (dblopaquearea * dbllvlprot1)) * ((2 * (dblchangesetback/dblvalue).pow(2))+0.5)) * dblmulti * dblECCmarkups.setscale(0));
            
        }
        
        // for calculating adjLOP setback
        dbladjchangesetback = Math.Max((dbldefadjsetback - dbluseadjsetback),0);
        system.debug('dbladjchangesetback==='+dbladjchangesetback);
        
        if(dbladjchangesetback > 30){
            dblchangeadjsetbackcost = 0;
        }else{
            dblchangeadjsetbackcost = (dbladjchangesetback == 0 ? 0 :
                Math.ceil(((dblwindowarea * dbluselvlprot) + (dblopaquearea * dbluselvlprot1)) * ((2 * (dbladjchangesetback/30).pow(2))+0.5)) * (1-dblmulti) * dblECCmarkups.setscale(0));
            
        }           
                       
            
            ID categoryid;
            // getting project cost summary details
            List<AggregateResult>  arProjCostSumlist = [Select  SUM(Core_Shell_Cost_Adj__c) coreshelltotadj, SUM(Parking_Cost_Adjusted__c) parkingcosttotadj, SUM(Security_Cost_Adjusted__c) securitycostadj, 
                                                                SUM(TRCS_Cost_Adjusted__c) trcscostadj   
                                                          From  NCMT_Project_Cost_Summary__c
                                                         Where  (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID)                          //Project_Name__c = :strProjectID 
                                                      group by  Project_Name__c]; 
                                                      
            For(AggregateResult ar :arProjCostSumlist){
                      
                 dblcoreshelltotadj = (decimal) ar.get('coreshelltotadj') * dblECCmarkups;
                 dblsecuritytotadj = (decimal) ar.get('securitycostadj') + dblblastwinFac + dblchangesetbackcost + dblchangeadjsetbackcost;
                 dblTRCStotadj = (decimal) ar.get('trcscostadj');
                 dblparkingcosttotadj = (decimal) ar.get('parkingcosttotadj');
            }                                                     
            
            // special requirment cost calculation
               if(dbltotusf > 0){
                dblunitcost = (dblTRCStotadj/dbltotusf).setscale(2) ;
               }
                dblspecialesccost = (dblTRCStotadj * dblescrate).setscale(2) ;
                dblspecialtotcostECC = Math.Round(dblTRCStotadj + dblspecialesccost); 
            
            //getting security cost detail parameters                                                          
            List<NCMT_Security_Detail__c> securitydetlist = [Select Security_Parameter__r.Security_Criterion__c, Unit_Cost__c, Gross_Sq_Ft__c
                                                              From  NCMT_Security_Detail__c
                                                              Where Security_Criterion__c = 'Blast Resistance - Progressive Collapse'
                                                              And   Project_Cost_Summary__c = :costsummaryid];  
            dblsecuritycost = 0;                                                  
            if(securitydetlist.size() > 0){
                dblsecuritycost = securitydetlist[0].Unit_Cost__c * securitydetlist[0].Gross_Sq_Ft__c ;
            }   
            
            //getting estimate adj details
            List<NCMT_EstimateAdjustment__c> estimateadjlist = [Select LocationMultiplier__c, SeismicDesignFactor__c, SetupQualityAdjustment__c, Adjustment_Type__c, CumulativeLocationAdjustment__c
                                                                  From NCMT_EstimateAdjustment__c
                                                                 Where (NCMTProject__r.ID = :strProjectID OR NCMTProject__r.Name = :strProjectID) ];                            //NCMTProject__c = :strProjectID];
            
            dblCSlocationmultiplier = 0;
            dblCSseismicdesignfactor = 0;                                                     
            if(estimateadjlist.size() > 0){
                for(NCMT_EstimateAdjustment__c estadj :estimateadjlist){
                    if(estadj.Adjustment_Type__c == 'Core/Shell Adjustment Factors'){
                        dblCSlocationmultiplier = estadj.LocationMultiplier__c;
                        dblCSseismicdesignfactor = estadj.SeismicDesignFactor__c;
                        dblCSsetupqualityadj = estadj.SetupQualityAdjustment__c;
                        dblCScummlocadj  = estadj.CumulativeLocationAdjustment__c;
                    } else if (estadj.Adjustment_Type__c == 'TI Adjustment Factors') {
                        dblTIlocationmultiplier = estadj.LocationMultiplier__c;
                        dblTIseismicdesignfactor = estadj.SeismicDesignFactor__c;
                        dblTIsetupqualityadj = estadj.SetupQualityAdjustment__c;
                        dblTIcummlocadj  = estadj.CumulativeLocationAdjustment__c;
                    }
                }
            }  
            
            // for calculating building core shell values
            if ((dblsecuritycost * dblCSlocationmultiplier *  dblCSseismicdesignfactor) == 0) {
                dblprogressivecoltotcecc = 0;
            }
            else {
               dblprogressivecoltotcecc = (dblsecuritycost * dblCSlocationmultiplier *  dblCSseismicdesignfactor).setscale(0) ;
            }   
               dblsecuritytotcecc = (dblsecuritytotadj - dblprogressivecoltotcecc).setscale(0); 
                
               dblcoreshellcostesc = (dblcoreshelltotadj * dblescrate/100).setscale(0);               
               dblprogressiveshellcostesc = (dblprogressivecoltotcecc * dblescrate/100).setscale(0);
               dblsecurityshellcostesc = (dblsecuritytotcecc * dblescrate/100).setscale(0);
               
               dblcoreshellcosttotecc = (dblcoreshelltotadj + dblcoreshellcostesc).setscale(0);
               dblprogressiveshellcosttotecc = (dblprogressivecoltotcecc + dblprogressiveshellcostesc).setscale(0) ;
               dblsecurityshellcosttotecc = (dblsecuritytotcecc + dblsecurityshellcostesc).setscale(0);
               
               
               dblSUBtotalshellcostcecc = (dblcoreshelltotadj + dblprogressivecoltotcecc + dblsecuritytotcecc).setscale(0);
               dblSUBtotalescapplied = (dblcoreshellcostesc + dblprogressiveshellcostesc + dblsecurityshellcostesc).setscale(0);
               dblSUBtotalcostECC = (dblcoreshellcosttotecc + dblprogressiveshellcosttotecc + dblsecurityshellcosttotecc).setscale(0);
            
            // Professional Services Parameters
           /* List<Professional_Service_Estimate__c> objPS = [
                Select  Total_Design_Percent__c, Total_Construction_Percent__c
                From    Professional_Service_Estimate__c 
                Where   Name = :strProjectName Limit 1
            ];
             
             System.debug('objPS===' + objPS);
             System.debug('strProjectName==='+strProjectName);
            
            dblEDRC = 0.00;
            dblEMIC = 0.00;
            dblEDRCPercent = 0.00;
            dblEMICPercent = 0.00;
            
            if (objPS.size() > 0){
                dblEDRCPercent = (Decimal) objPS.get(0).Total_Design_Percent__c;
                dblEMICPercent = (Decimal) objPS.get(0).Total_Construction_Percent__c;
                dblEDRC = (Decimal) objPS.get(0).Total_Design_Percent__c/100;
                dblEMIC = (Decimal) objPS.get(0).Total_Construction_Percent__c/100;
            } */
            
            // Site Information Parameters
            List<Site_Information__c> objSI = [
                Select  Finished_Site__c
                From    Site_Information__c 
                Where   (Project__r.ID = :strProjectID OR Project__r.Name = :strProjectID)  Limit 1                           //Project__c = :strProjectID Limit 1
            ];
            
            if (objSI.size() > 0){
                if(strHPProjectType == 'New Construction'){
                    dblFinSite = (Decimal) objSI.get(0).Finished_Site__c;
                }
            }
            // Other Project cost
             objOClist = [ Select Gross_Area__c, Unit_Rate__c, Cost_Type__c, Total__c, Cost_Description__c
                                                From  NCMT_Other_Cost__c
                                                Where  (NCMT_Project__r.ID = :strProjectID OR NCMT_Project__r.Name = :strProjectID)             //NCMT_Project__c = :strProjectID 
                                                 And  Cost_Type__c != 'Direct Costs'];
                                            
            AggregateResult[] SumCosts = [ SELECT   NCMT_Project__c, SUM(Total__c) Total
                                                 FROM     NCMT_Other_Cost__c 
                                                 WHERE    (NCMT_Project__r.ID = :strProjectID OR NCMT_Project__r.Name = :strProjectID)               //NCMT_Project__c = :strProjectID
                                                 And  Cost_Type__c != 'Direct Costs'
                                                 Group By NCMT_Project__c]; 
            dblTotalOtherCost = 0;                                     
            for (AggregateResult RowData : SumCosts) { 
                 dblTotalOtherCost = (Decimal) RowData.get('Total');
            }                                      
                                                 
            //getting cost category id
            List<NCMT_Cost_Category__c> costcatlist =[select ID, name from NCMT_Cost_Category__c where name = 'F10']; 
            
            categoryid = costcatlist[0].id;                                                  
            
            // getting coreshell cost parameters for structured and surface parking
            List<NCMT_Core_Shell_Cost_Parameter__c> coreshellparamlist = [Select Other_Space_Unit_Cost__c, Cost_Sub_Type_Description__c
                                                                            From NCMT_Core_Shell_Cost_Parameter__c
                                                                            Where Cost_Category__c = :categoryid
                                                                            And   (Core_Shell_Cost_Parameter_Identifier__c = 'CC-27141' OR Core_Shell_Cost_Parameter_Identifier__c = 'CC-27142')];
            if(coreshellparamlist.size() > 0){
                For(NCMT_Core_Shell_Cost_Parameter__c coreshellCP :coreshellparamlist){
                    if(coreshellCP.Cost_Sub_Type_Description__c == 'Structured Parking'){
                        dbllsstructuredparkingcost = Math.Round(dblsiteinfostrucparking * coreshellCP.Other_Space_Unit_Cost__c * dblECCmarkups * dblCScummlocadj);
                        dbllsstructuredparkingcosts = Math.Round(dblsiteinfostrucparking * coreshellCP.Other_Space_Unit_Cost__c * dblCScummlocadj);
                    }else if(coreshellCP.Cost_Sub_Type_Description__c == 'Surface Parking'){
                        dbllssurfaceparkingcost = Math.round(dblsiteinfosurfaceparking * coreshellCP.Other_Space_Unit_Cost__c * dblECCmarkups * dblCScummlocadj);
                        dbllssurfaceparkingcosts = Math.round(dblsiteinfosurfaceparking * coreshellCP.Other_Space_Unit_Cost__c * dblCScummlocadj);
                    }
                }
            }
            
            //calculating parking section
            if(dblparkingcosttotadj == 0){
                dblshellcostcsinsideparking = 0;
            }else{
                if(dblenclosedparking > 0){
                  dblshellcostcsinsideparking = (dblparkingcosttotadj/dblenclosedparking).setscale(2);
                }
            }
            if(dbllsstructuredparkingcost == 0){
                dblshellcostcsstrucdpg = 0;
            }else if(dblsiteinfostrucparking > 0){
                    dblshellcostcsstrucdpg = (dbllsstructuredparkingcost/dblsiteinfostrucparking).setscale(2);
                
            }
            if(dbllssurfaceparkingcost == 0){
                dblshellcostcssurfacepg = 0;
            }else if(dblsiteinfosurfaceparking > 0){
                    dblshellcostcssurfacepg = (dbllssurfaceparkingcost/dblsiteinfosurfaceparking).setscale(2);
                
            }
            
            if(dblCScummlocadj > 0){
                dblshellcostgsfinsidepg = (dblshellcostcsinsideparking/dblCScummlocadj).setscale(2);
                dblshellcostgsfstrucdpg = (dblshellcostcsstrucdpg/dblCScummlocadj).setscale(2);
                dblshellcostgsfsurfacepg = (dblshellcostcssurfacepg/dblCScummlocadj).setscale(2);
            }
            
            dblshellcostgsfinsidepgesc = (dblparkingcosttotadj * dblescrate / 100).setscale(0);
            dblshellcostgsfstrucdpgesc = (dbllsstructuredparkingcost * dblescrate / 100).setscale(0);
            dblshellcostgsfsurfacepgesc = (dbllssurfaceparkingcost * dblescrate / 100).setscale(0);
            
            dblshellcostgsfinsidepgtotecc = (dblparkingcosttotadj + dblshellcostgsfinsidepgesc).setscale(0);
            dblshellcostgsfstrucdpgtotecc = (dbllsstructuredparkingcost + dblshellcostgsfstrucdpgesc).setscale(0);
            dblshellcostgsfsurfacepgtotecc = (dbllssurfaceparkingcost + dblshellcostgsfsurfacepgesc).setscale(0);
            
            if(dblshellcostgsfinsidepgtotecc == 0){
                dblshellcostinsidepgeccgsf = 0; 
            }else if(dblenclosedparking > 0){
                    dblshellcostinsidepgeccgsf = (dblshellcostgsfinsidepgtotecc / dblenclosedparking).setscale(2);
                
            }
            if(dblshellcostgsfstrucdpgtotecc == 0){
                dblshellcoststrucdpgeccgsf = 0;
            }else if(dblsiteinfostrucparking > 0){
                    dblshellcoststrucdpgeccgsf = (dblshellcostgsfstrucdpgtotecc / dblsiteinfostrucparking).setscale(2);
                
            }
            if(dblshellcostgsfsurfacepgtotecc == 0){
                dblshellcostsurfacepgeccgsf = 0;
            }else if(dblsiteinfosurfaceparking > 0){
                    dblshellcostsurfacepgeccgsf = (dblshellcostgsfsurfacepgtotecc / dblsiteinfosurfaceparking).setscale(2);
                
            }
            
            dblparkingcosttotshellcostcecc = (dblparkingcosttotadj + dbllsstructuredparkingcost + dbllssurfaceparkingcost).setscale(0);
            dblparkingcosttotesc =  (dblshellcostgsfinsidepgesc + dblshellcostgsfstrucdpgesc + dblshellcostgsfsurfacepgesc).setscale(0);
            dblparkingcosttotecc =   (dblshellcostgsfinsidepgtotecc + dblshellcostgsfstrucdpgtotecc + dblshellcostgsfsurfacepgtotecc).setscale(0);
            
            //calculating subtotal ecc
            dblmarketshellecccost = (dblparkingcosttotecc + dblcoreshellcosttotecc).setscale(0);
            dblsecurityitemscostecc = (dblprogressiveshellcosttotecc + dblsecurityshellcosttotecc).setscale(0);
            
            //dbltotalTIcostecc = (dblsubtotalTIcostecc + dblsecurityitemscostecc).setscale(0);
            //dbltotalprojectcostecc = (dblmarketshellecccost + dbltotalTIcostecc).setscale(0);
                                                                                                       
            return  dsProjectInfo;
          }else{
            ApexPages.Message errormessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter custom housing plan data before viewing report data');
            ApexPages.addMessage(errormessage);
            return null;
      }
    }

    public Double getMovingCosts(){
        Double movingCosts = 0;
        for (NCMT_Other_Cost__c other : [Select Id, NCMT_Housing_Plan_Option_Selection__c, NCMT_Project__c,
                    Unit_Rate__c, Housing_Plan_Option_Square_Footage__c , Total1__c,
                NCMT_Housing_Plan_Cost_Parameter__c, RecordTypeId, Cost_Type__c,
                NCMT_Housing_Plan_Option_Selection__r.TCO_Replacement_Every_X_Years__c,
                NCMT_Housing_Plan_Option_Selection__r.TCO_Repair_Every_X_Years__c,
                NCMT_Housing_Plan_Option_Selection__r.TCO_Repair_Cost_Percentage__c,
                NCMT_Housing_Plan_Option_Selection__r.Recurs_on_TCO_Tenant_Refresh_Years__c,
                Housing_Plan_Cost_Type__c
            from NCMT_Other_Cost__c where NCMT_Project__c =: strProjectID 
                                         
            and Housing_Plan_Cost_Type__c = 'Moving Costs']
        ){
            movingCosts += other.Total1__c;
            

        }
        return movingCosts;
    }
    
    public List<NCMT_Project_Cost_Summary__c> getDatasetProjectCostSummary(){
        List<NCMT_Project_Cost_Summary__c> DataRecords = [  
            Select  Quantity__c, Total_Cost_Adjusted__c, TRCS_Cost_Adjusted__c, TI_Cost_Adjusted__c, Security_Cost_Adjusted__c, 
                    Parking_Cost_Adjusted__c, Name, Id, ECCA__c, Cost_Category_Description__c, Cost_Category_Code__c, 
                    Core_Shell_Total_Cost_Adjusted__c, Core_Shell_Cost_Adj__c,Other_Direct_Costs__c, Other_Core_Shell_Cost__c, Oth_TI_Cst__c, Other_Direct_Security_Costs__c,
                    Direct_Cost_GSF__c, ECC__c, RA_ECC__c, ECC_GSF__c, ECCA_GSF__c, Repair_Cost__c, Replace_Cost__c,
                    GSA_Costs__c, GSAPkg_Costs__c, Tenant_Amortized_Costs__c, Other_Direct_Cost_GSF__c, Tenant_RWA_Costs__c, RA_ECCA__c, Total_RA_ECCA__c,RA_ECCA_Shell_Parameter__c   
            From    NCMT_Project_Cost_Summary__c
            Where   (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID)                                 
            Order by Cost_Category_Code__c Limit 100];

        return DataRecords;
    }
    
    public Map<String, List<level3Wrapper>> getCoreShellData(){

        Map<String, Map<String, level3Wrapper>> level3Map = new Map<String, Map<String, level3Wrapper>>();
 
        
        List<string> pcsCodes = new list<string>();
        Map<String, NCMT_Project_Cost_Summary__c> pcsCodeMap = new Map<String, NCMT_Project_Cost_Summary__c>();
        for (NCMT_Project_Cost_Summary__c  pcs : [select Cost_Category_Code__c,
            Project_Name__r.Construction_Contingency__c, Project_Name__r.Art_In_Architecture__c,
            Project_Name__r.Design_and_Site_Contingency__c, 
            Project_Name__r.General_Contractor_Overhead_Profit_Bonds__c, 
            Project_Name__r.Building_Cost_Type__c, TI_Cost__c, Project_Name__r.Total_Escalation__c,
            Project_Name__r.Total_Escalation_CPE__c, Project_Name__r.Project_type__c
            from NCMT_Project_Cost_Summary__c  where Project_Name__c = :strProjectID]
        ){
            pcsCodes.add(pcs.Cost_Category_Code__c);
            pcsCodeMap.put(pcs.Cost_Category_Code__c, pcs);
        }
        system.debug('pcs codes'+ pcsCodes);
        system.debug('index' + pcsCodes.indexof('A10'));
        List<AggregateResult> coreShell = [SELECT sum(Core_Shell_Cost_Adj__c ) coreShell, sum(Parking_Cost_Adjusted__c) parking,sum(Total_Cost__c) total, sum(Total_Units__c) qty,
                                    Project_Cost_Summary__r.Cost_Category_ID__r.Name, Core_Shell_Cost_Parameter__r.Level_3__c level3,
                                    Core_Shell_Cost_Parameter__r.Level_3_Description__c level3desc
                                    
                                    FROM NCMT_Core_Shell_Cost_Detail__c
                                    WHERE Project_Cost_Summary__r.Project_Name__c = :strProjectID
                                    group by Project_Cost_Summary__r.Cost_Category_ID__r.Name, Core_Shell_Cost_Parameter__r.Level_3__c, 
                                    Core_Shell_Cost_Parameter__r.Level_3_Description__c
                                    
                                    ];
       
        List<AggregateResult> trcs = [SELECT sum(TRCS_Total_Cost_Adjusted__c) trcsCost, sum(TI_Cost_Adjusted__c) tiCost, 
                                        Project_Cost_Summary__r.Cost_Category_ID__r.Name, TI_TRCS_Cost_Parameter__r.Level_3__c level3,
                                        TI_TRCS_Cost_Parameter__r.Level_3_Description__c level3desc
                                        FROM NCMT_TI_TRCS_Cost_Detail__c
                                    WHERE Project_Cost_Summary__r.Project_Name__c = :strProjectID and TI_TRCS_Cost_Parameter__c != null
                                    Group by Project_Cost_Summary__r.Cost_Category_ID__r.Name, TI_TRCS_Cost_Parameter__r.Level_3__c, 
                                    TI_TRCS_Cost_Parameter__r.Level_3_Description__c];

       List<AggregateResult> secs = [SELECT sum(Total_Cost_Adjusted__c) secCost, 
                                Project_Cost_Summary__r.Cost_Category_ID__r.Name, Security_Parameter__r.Level_3__c level3
                                FROM NCMT_Security_Detail__c
                                WHERE Project_Cost_Summary__r.Project_Name__c = :strProjectID and Security_Parameter__c != null
                                Group by Project_Cost_Summary__r.Cost_Category_ID__r.Name, Security_Parameter__r.Level_3__c];  
        
         List<AggregateResult> secs1 = [SELECT sum(Total_Cost_Adjusted__c) secCost, 
                                Project_Cost_Summary__r.Cost_Category_ID__r.Name, Security_Parameter__r.Level_3__c level3,
                                Security_Parameter__r.Level_3_Description__c level3desc
                                FROM NCMT_Security_Detail__c
                                WHERE Project_Cost_Summary__r.Project_Name__c = :strProjectID and Security_Parameter__c != null
                                Group by Project_Cost_Summary__r.Cost_Category_ID__r.Name, Security_Parameter__r.Level_3__c, 
                                Security_Parameter__r.Level_3_Description__c];       

        for(AggregateResult item:coreShell){            
            string catCode = string.valueOf(item.get('Name'));
            string level3 = string.valueOf(item.get('level3'));
            

            if (level3Map.get(catCode) == null) level3Map.put(catCode, new Map<String, level3Wrapper>());

            if (level3Map.get(catCode).get(level3) == null){  
                system.debug('inside if core');
                level3Map.get(catCode).put(level3, new level3Wrapper(catCode, level3));
               level3Map.get(catCode).get(level3).level3desc = string.valueOf(item.get('level3desc'));
            }
            level3Wrapper wrap = level3Map.get(catCode).get(level3);

            wrap.coreShell = double.valueOf(item.get('coreshell'));
            wrap.parking = double.valueOf(item.get('parking'));
            Double total = double.valueOf(item.get('total'));
            wrap.qty = integer.valueOf(item.get('qty'));
            system.debug('wrap ' + wrap + ' level3map' + level3Map);
           
        }

        for(AggregateResult item:trcs){            
            string catCode = string.valueOf(item.get('Name'));
            string level3 = string.valueOf(item.get('level3'));

            if (level3Map.get(catCode) == null) level3Map.put(catCode, new Map<String, level3Wrapper>());

            level3Wrapper wrap = level3Map.get(catCode).get(level3);
            system.debug('wrap trcs' +wrap);
            if (wrap == null){   
                system.debug('inside if trcs');
                wrap = new level3Wrapper(catCode, level3);
                level3Map.get(catCode).put(level3, wrap);
              wrap.level3desc = string.valueOf(item.get('level3desc'));
                
                
            }
            wrap.trcs = double.valueOf(item.get('trcsCost'));
            wrap.ti = double.valueOf(item.get('tiCost'));
            
        }

        for(AggregateResult item:secs){            
            string catCode = string.valueOf(item.get('Name'));
            string level3 = string.valueOf(item.get('level3'));
            System.debug('Name----' +string.valueOf(item.get('level3')));

            if (level3Map.get(catCode) == null) level3Map.put(catCode, new Map<String, level3Wrapper>());

            level3Wrapper wrap = level3Map.get(catCode).get(level3);
            system.debug('wrap 1' + wrap);
            if (wrap == null){   
                system.debug('secs inside if');
                wrap = new level3Wrapper(catCode, level3);
                level3Map.get(catCode).put(level3, wrap);
                for(AggregateResult item1:secs1){
                    if(string.valueOf(item1.get('level3'))==string.valueOf(item.get('level3'))){
                        system.debug('secs item1');
                          
                    wrap.level3desc = string.valueOf(item1.get('level3desc'));
                      
                      
                     }
                }
               //wrap.level3desc = string.valueOf(item.get('level3desc'));               
                
            }
            wrap.security = double.valueOf(item.get('secCost'));
            
        }
        

        Map<String, List<level3Wrapper>> level3Data = new Map<String, List<level3Wrapper>>();
        for (String cat : level3Map.keySet()){
            List<String> level3s = new List<String>();
            level3s.addAll(level3Map.get(cat).keySet());
            level3s.sort();

            level3Data.put(cat, new List<level3Wrapper>());

            String projType = pcsCodeMap.get(cat).Project_Name__r.Project_type__c;

            Double designSite = pcsCodeMap.get(cat).Project_Name__r.Design_and_Site_Contingency__c/100;
            Double contractOverhead = pcsCodeMap.get(cat).Project_Name__r.General_Contractor_Overhead_Profit_Bonds__c/100;
            Double contContig = pcsCodeMap.get(cat).Project_Name__r.Construction_Contingency__c/100;
            Double artArch = pcsCodeMap.get(cat).Project_Name__r.Art_In_Architecture__c/100;
            String buildCostType = pcsCodeMap.get(cat).Project_Name__r.Building_Cost_Type__c;
            String costCode = pcsCodeMap.get(cat).Cost_Category_Code__c;
            Double tiCost = pcsCodeMap.get(cat).TI_Cost__c;
            Double totalEsc = (pcsCodeMap.get(cat).Project_Name__r.Total_Escalation__c != null ? pcsCodeMap.get(cat).Project_Name__r.Total_Escalation__c/100 : 0);
            Double totalEscCPE = (pcsCodeMap.get(cat).Project_Name__r.Total_Escalation_CPE__c != null ? pcsCodeMap.get(cat).Project_Name__r.Total_Escalation_CPE__c/100 : 0);
            Double coreTotalAdj;
            System.debug('designSite == ' +designSite +' contractOverhead == ' +contractOverhead +' contContig == ' +contContig +' artArch == ' +artArch);

            //Totals
            for (String l : level3s){
                level3Wrapper l3w = level3Map.get(cat).get(l);
                l3w.total = l3w.coreShell + l3w.parking + l3w.security + l3w.ti + l3w.trcs;
                if (l3w.total != 0 ){
                    
                    l3w.ecca = l3w.total * (1 + dblDesign) * (1 + dblGeneral) * (1 + dblEscMarkets) +(1 + dblEscCode);
                    //(1+totalEsc + (totalEscCPE == null ?  0 : totalEscCPE));
                    //parseFloat((TotalCost * (1 + Number({!dblDesign}))) * (1 + Number({!dblGeneral})) * (1+ Number({!dblEscMarkets}) + Number({!dblEscCode}))).toFixed(2);
                    
                    l3w.ecc = (l3w.ecca *(1+ contContig))*(1+ artArch);
                
                    System.debug('wrap.ecc = ' +l3w.ecc + ' designSite = ' +designSite +' contractOverhead = ' +contractOverhead +' dblEscMarkets = ' +dblEscMarkets +' dblEscCode = ' +dblEscCode +' dblConstruct = ' +dblConstruct +' dblArt = ' +dblArt);
                    
                    l3w.otherGSF = 0;
                    if (dblGross != 0){
                        l3w.directGSF = (l3w.total / dblGross).setScale(2); 
                        l3w.eccaGSF = l3w.ecca / dblGross;
                        l3w.eccGSF = l3w.ecc / dblGross;
                    } else {
                        l3w.directGSF = 0;
                        l3w.eccaGSF = 0;
                        l3w.eccGSF = 0;
                    }
                    level3Data.get(cat).add(l3w);
                }
            }
        }

        system.debug('leve three data' + level3Map);
        return level3Data;

    }


    public class level3Wrapper {
        // public map<string,intger > catMap{get;set;}
        public string catCode {get; set;}
        public string level3 {get; set;}
        public string level3desc {get;set;}
        public double coreShell {get; set;}
        public double parking {get; set;}
        public double total {get; set;}
        public integer qty {get; set;}
        public double trcs {get; set;}
        public double ti {get; set;}
        public double security {get;set;}

        //Calculations
        public double ecc {get;set;}
        public double ecca {get;set;}
        //public double etpc {get;set;}
        public double otherGSF {get;set;}
        public double directGSF {get;set;}
        public double eccGSF {get;set;}
        public double eccaGSF {get;set;}
        /*
        public double etpcGSF {get;set;}
        public double etpcShellParam {get;set;}
        public double profileOfCost {get;set;}

        //For calculations
        public String projType {get; set;}
        public double contContig {get; set;}
        public double artArch {get; set;}*/
        
        public level3Wrapper(string catCode, string level3){
            this.catCode = catCode;
            this.level3 = level3;
            coreShell = 0;
            parking = 0;
            trcs = 0;
            ti = 0;
            security = 0;
        }
    }


    
    
    public List<NCMT_Housing_Plan__c> getDatasetHousingPlan(){
            List<NCMT_Housing_Plan__c> HPDataRecords = [Select Name, Housing_Plan_Name__c, Unfinished_Shell_Area_Use_USF__c,Workstations_open_office_Use_USF__c, Closed_offices_Use_USF__c, X8_20_person_rooms_Use_USF__c, X20_or_more_person_rooms_Use_USF__c, Teleconference_Use_USF__c,
                                                                Auditorium_sloped_floor_Use_USF__c, General_storage_Use_USF__c, Clinics_health_units_Use_USF__c, Physical_fitness_Use_USF__c, Child_care_Use_USF__c, Libraries_Use_USF__c,
                                                                ADP_high_density_PC_s_Use_USF__c, ADP_mainframe_Use_USF__c, Joint_use_retail_Use_USF__c, Food_service_cafeteria_Use_USF__c, Non_climate_controlled_Use_USF__c,
                                                                Total_USF__c, Enclosed_Parking__c, Total_GSF__c, Total_RSF_w_o_parking__c, Private_toilets_Use_USF__c, High_density_storage_Use_USF__c,
                                                                Climate_controlled_for_artifacts_Use_USF__c, Laboratory_Dry_electronic_Use_USF__c, Laboratory_Wet_chemistry_Use_USF__c, Firing_range_Use_USF__c, Copy_Center_Use_USF__c,
                                                                Credit_Union_Use_USF__c, Transaction_counter_space_Use_USF__c, Kitchen_Break_room_Use_USF__c, Locker_Shower_room_Use_USF__c, Hardened_offices_suites_Use_USF__c,
                                                                Secure_Work_Environment_SWE_Std_Use_USF__c, Secure_Work_Environment_SWE_Enhd_UseUSF__c, Secured_Storage_SCIF_Standard_Use_USF__c, Secured_Storage_SCIF_Enhanced_Use_USF__c,
                                                                Vault_Type_Storage_Use_USF__c, Interview_Detention_Use_USF__c, Non_Marshal_Holding_Cell_Single_Use_USF__c, Non_Marshal_Holding_Cell_Double_Use_USF__c, Light_industrial_Use_USF__c,
                                                                Warehouse_Use_USF__c, Courtroom_district_Ceremonial_Use_USF__c, Courtroom_district_Standard_Use_USF__c, Courtroom_Bankruptcy_Use_USF__c, Courtroom_Magistrate_Use_USF__c, Grand_Jury_Room_Use_USF__c,
                                                                Judicial_hearing_Use_USF__c, Judicial_chambers_Use_USF__c, Enhanced_office_Use_USF__c, USMS_Suite_Administration_Use_USF__c, USMS_Suite_Operations_Use_USF__c, Sally_Port_Use_USF__c,
                                                                Holding_cell_Central_Use_USF__c, Holding_cell_Court_floors_Use_USF__c, User_Defined_Spaces1_Description__c, User_Defined_Spaces2_Description__c, User_Defined_Spaces3_Description__c,
                                                                User_Defined_Spaces1_Use_USF__c, User_Defined_Spaces2_Use_USF__c, User_Defined_Spaces3_Use_USF__c, User_Defined_Spaces1_USF_for_DC__c, User_Defined_Spaces2_USF_for_DC__c,
                                                                User_Defined_Spaces3_USF_for_DC__c, VA_Ambulatory_Surgery_Use_USF__c, VA_Exam_Suite_Use_USF__c, VA_Infusion_Use_USF__c, VA_Intake_Use_USF__c, VA_Pharmacy_Use_USF__c,
                                                                VA_Radiology_Use_USF__c, Data_Center_Use_USF__c, PBS_Agency_AB_Code__c, PBS_AB_Code__r.Agency_Bureau_Name__c, Housing_Plan_Type__c,NCMT_Project_ID__c, Mailroom_Use_USF__c, Secure_Mailroom_Use_Usf__c
                                                           From  NCMT_Housing_Plan__c
                                                           Where (Project__r.ID = :strProjectID OR Project__r.Name = :strProjectID) 
                                                           Order by Name Limit 100];
        return HPDataRecords;
    }    
    
    
    //Used in Building Cost Summary Report ...
    public void DatasetProjectCostSummaryGrouped(string strProjectID){
        dblCoreShellCosts = 0.00;
        dblTRCSCosts = 0.00;
        dblTICosts = 0.00;
        dblSecurityCostS = 0.00;
        dblParkingCosts = 0.00;
        dblNonBuildingRelatedSiteCost = 0.00;
        dblRepairCosts =  0.00;
        dblReplaceCosts =  0.00;
        dblGSACosts =  0.00;
        dblGSAPkgCosts =  0.00;
        dblTIAMCosts =  0.00;
        dblTIRWACosts =  0.00;
        
        List<AggregateResult> DataRecords = [   
            Select  Project_Name__c, 
                    Sum(Core_Shell_Cost_Adj__c) CoreShellCosts, Sum(TRCS_Cost_Adjusted__c) TRCSCosts,
                    Sum(TI_Cost_Adjusted__c) TICosts, Sum(Security_Cost_Adjusted__c) SecurityCosts, 
                    Sum(Parking_Cost_Adjusted__c) ParkingCosts, Sum(Repair_Cost__c) RepairCost, Sum(Replace_Cost__c) ReplaceCost,
                    Sum(GSA_Costs__c) GSACosts, sum(GSAPkg_Costs__c) GSAPkgCosts, Sum(Tenant_Amortized_Costs__c) TIAMCosts, Sum(Tenant_RWA_Costs__c) TIRWACosts
            From    NCMT_Project_Cost_Summary__c
            Where   (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID)                                          //Project_Name__c = :strProjectID 
            Group by Project_Name__c Limit 10];
               
        if (DataRecords.size() > 0){
            dblCoreShellCosts = (Decimal) DataRecords[0].get('CoreShellCosts');
            dblTRCSCosts = (Decimal) DataRecords[0].get('TRCSCosts');
            dblTICosts = (Decimal) DataRecords[0].get('TICosts');
            dblSecurityCosts = ((Decimal) DataRecords[0].get('SecurityCosts'))+ dblblastwinFac + dblchangesetbackcost + dblchangeadjsetbackcost;
            dblParkingCosts = (Decimal) DataRecords[0].get('ParkingCosts');
            dblRepairCosts = (Decimal) DataRecords[0].get('RepairCost');
            dblReplaceCosts = (Decimal) DataRecords[0].get('ReplaceCost');
            dblGSACosts = (Decimal) DataRecords[0].get('GSACosts');
            dblGSAPkgCosts = (Decimal) DataRecords[0].get('GSAPkgCosts');
            dblTIAMCosts = (Decimal) DataRecords[0].get('TIAMCosts');
            dblTIRWACosts = (Decimal) DataRecords[0].get('TIRWACosts');
            
        } 
        
        List<NCMT_Project_Cost_Summary__c> dsNonBuildingRelatedSiteCost = 
            [Select Core_Shell_Cost_Adj__c 
            From    NCMT_Project_Cost_Summary__c
            Where   (Project_Name__r.ID = :strProjectID OR Project_name__r.Name = :strProjectID)                                         //Project_Name__c = :strProjectID 
            And     Cost_Category_Code__c = 'G20'       // Other Sitework - Project Related
            Limit 1];
        
        if (dsNonBuildingRelatedSiteCost.size() > 0){
                dblNonBuildingRelatedSiteCost = (Decimal) dsNonBuildingRelatedSiteCost[0].get('Core_Shell_Cost_Adj__c');
        }
            
    }
}