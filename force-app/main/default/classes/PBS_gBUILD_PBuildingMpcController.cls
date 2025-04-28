public with sharing class PBS_gBUILD_PBuildingMpcController extends PBS_gBUILD_ProjectIdBaseController 
{
    public PBS_gBUILD_ProjectBuilding__c pb { get; set; }
    public String mpcCategoryIntegratedDesign { get; private set; }
    public String mpcCategoryEnergyPerformance { get; private set; }
    public String mpcCategoryWater { get; private set; }
    public String mpcCategoryIndoorEnvironmentalQuality { get; private set; }
    public String mpcCategoryMaterials { get; private set; }
    public String selectedTabName { get; set; }
    public String projType { get; private set; }
    public Map<Integer, PBS_gBUILD_PBuildingMPCUpdate__c> mpcStatusByNum { get; private set; }
    public Map<Integer, PBS_gBUILD_PBuildingMPCUpdate__c> mpcDrByNum { get; private set; }
    public string uploadCatalog { get { return PBS_gBUILD_Utility.epmCatalogExecution; } }
    public string MpcLabel1 { get; private set; }
    public string MpcLabel2 { get; private set; }
    public string MpcLabel3 { get; private set; }
    public string MpcLabel4 { get; private set; }
    public string MpcLabel5 { get; private set; }
    public string MpcLabel6 { get; private set; }
    public string MpcLabel7 { get; private set; }
    public string MpcLabel8 { get; private set; }
    public string MpcLabel9 { get; private set; }
    public string MpcLabel10 { get; private set; }
    public string MpcLabel11 { get; private set; }
    public string MpcLabel12 { get; private set; }
    public string MpcLabel13 { get; private set; }
    public string MpcLabel14 { get; private set; }
    public string MpcLabel15 { get; private set; }
    public string MpcLabel16 { get; private set; }
    public string MpcLabel17 { get; private set; }
    public string MpcLabel18 { get; private set; }
    public string MpcLabel19 { get; private set; }
    public string MpcLabel20 { get; private set; }
    public string MpcLabel21 { get; private set; }
    /* public string MpcLabel22 { get; private set; }
    public string MpcLabel23 { get; private set; }
    public string MpcLabel24 { get; private set; }
    public string MpcLabel25 { get; private set; }
    public string MpcLabel26 { get; private set; }
    public string MpcLabel27 { get; private set; }
    public string MpcLabel28 { get; private set; }
    public string MpcLabel29 { get; private set; }
    public string MpcLabel30 { get; private set; }
    public string MpcLabel31 { get; private set; }
    public string MpcLabel32 { get; private set; }
    public string MpcLabel33 { get; private set; }
    public string MpcLabel34 { get; private set; }
    public string MpcLabel35 { get; private set; }
    public string MpcLabel36 { get; private set; }
    public string MpcLabel37 { get; private set; }
    public string MpcLabel38 { get; private set; }
    public string MpcLabel39 { get; private set; } */
    public static String section;
    public PBS_gBUILD_PBuildingMpcController()
    {       
        super('GPC', true, new List<string>{'Compliance', 'PBS_gBUILD_PBuildingCompliance'});        
        try
        {
            Integer num = 1;
            try
            {
                num = integer.valueOf(ApexPages.currentPage().getParameters().get('num'));               
            }
            catch (Exception ex2){} 
            selectedTabName = null;     
            for (PBS_gBUILD_Utility.MpcInfo mi : PBS_gBUILD_Utility.mpcInfos)
            {
                if (mi.num==num)
                {
                    selectedTabName = mi.cat;
                }                
               if (mi.num==1) MpcLabel1='GPC 1: '+mi.description;           
               else if (mi.num==2) MpcLabel2='GPC 2: '+mi.description;
               else if (mi.num==3) MpcLabel3='GPC 3: '+mi.description;
               else if (mi.num==4) MpcLabel4='GPC 4: '+mi.description;
               else if (mi.num==5) MpcLabel5='GPC 5: '+mi.description;
               else if (mi.num==6) MpcLabel6='GPC 6: '+mi.description;
               else if (mi.num==7) MpcLabel7='GPC 7: '+mi.description;
               else if (mi.num==8) MpcLabel8='GPC 8: '+mi.description;
               else if (mi.num==9) MpcLabel9='GPC 9: '+mi.description;
               else if (mi.num==10) MpcLabel10='GPC 10: '+mi.description;
               else if (mi.num==11) MpcLabel11='GPC 11: '+mi.description;
               else if (mi.num==12) MpcLabel12='GPC 12: '+mi.description;
               else if (mi.num==13) MpcLabel13='GPC 13: '+mi.description;
               else if (mi.num==14) MpcLabel14='GPC 14: '+mi.description;
               else if (mi.num==15) MpcLabel15='GPC 15: '+mi.description;
               else if (mi.num==16) MpcLabel16='GPC 16: '+mi.description;
               else if (mi.num==17) MpcLabel17='GPC 17: '+mi.description;
               else if (mi.num==18) MpcLabel18='GPC 18: '+mi.description;
               else if (mi.num==19) MpcLabel19='GPC 19: '+mi.description;
               else if (mi.num==20) MpcLabel20='GPC 20: '+mi.description;
               else if (mi.num==21) MpcLabel21='GPC 21: '+mi.description;
               /**else if (mi.num==22) MpcLabel22='GPC 22: '+mi.description;
               else if (mi.num==23) MpcLabel23='GPC 23: '+mi.description;
               else if (mi.num==24) MpcLabel24='GPC 24: '+mi.description;
               else if (mi.num==25) MpcLabel25='GPC 25: '+mi.description;
               else if (mi.num==26) MpcLabel26='GPC 26: '+mi.description;
               else if (mi.num==27) MpcLabel27='GPC 27: '+mi.description;
               else if (mi.num==28) MpcLabel28='GPC 28: '+mi.description;
               else if (mi.num==29) MpcLabel29='GPC 29: '+mi.description;
               else if (mi.num==30) MpcLabel30='GPC 30: '+mi.description;
               else if (mi.num==31) MpcLabel31='GPC 31: '+mi.description;
               else if (mi.num==32) MpcLabel32='GPC 32: '+mi.description;
               else if (mi.num==33) MpcLabel33='GPC 33: '+mi.description;
               else if (mi.num==34) MpcLabel34='GPC 34: '+mi.description;
               else if (mi.num==35) MpcLabel35='GPC 35: '+mi.description;
               else if (mi.num==36) MpcLabel36='GPC 36: '+mi.description;
               else if (mi.num==37) MpcLabel37='GPC 37: '+mi.description;
               else if (mi.num==38) MpcLabel38='GPC 38: '+mi.description;
               else if (mi.num==39) MpcLabel39='GPC 39: '+mi.description; */         
                                        
            }       
            this.mpcCategoryIntegratedDesign = PBS_gBUILD_Utility.mpcCategoryIntegratedDesign;
            this.mpcCategoryEnergyPerformance = PBS_gBUILD_Utility.mpcCategoryEnergyPerformance;
            this.mpcCategoryWater = PBS_gBUILD_Utility.mpcCategoryWater;
            this.mpcCategoryIndoorEnvironmentalQuality = PBS_gBUILD_Utility.mpcCategoryIndoorEnvironmentalQuality;
            this.mpcCategoryMaterials = PBS_gBUILD_Utility.mpcCategoryMaterials;
            this.projType =[select projecttype__c from PBS_gBUILD_Project__c where id=:projectid limit 1].projecttype__c;
            bind();
        }
        catch (Exception ex)
        {
            handleConstructorError(ex);
        }
    }
    
    public PageReference edit()
    {
        PBS_gBUILD_Utility.showDebugMessage('EDIT pba:'+pbuildingId);
        viewMode = false;
        for (PBS_gBUILD_Utility.MpcInfo mi : PBS_gBUILD_Utility.mpcInfos)
            {
                PBS_gBUILD_MpcPreviewCController mpcPreview = GetPreviewController(mi.num);
                if (mpcPreview==null) continue;
                system.debug('mpcPreview ' + mpcPreview);
                mpcPreview.edit();
            }
        bind();        
        return null;
    }
    
    public PBS_gBUILD_MpcPreviewCController GetPreviewController(integer mpcNum)
    {
        string miKey = 'mpcPreview'+mpcNum.format();
        return (PBS_gBUILD_MpcPreviewCController) this.getComponentByKey(miKey);
    }    
    
    public PageReference save()
    {
        try
        {
           // PBS_gBUILD_Utility.showDebugMessage('Status and Comments:'+ Status__c);
            PBS_gBUILD_Utility.showDebugMessage('SAVE pba:'+pbuildingId);
            viewMode = true;
            update pb;
            RecordPageSaved();            
        
            for (PBS_gBUILD_Utility.MpcInfo mi : PBS_gBUILD_Utility.mpcInfos)
            {
                PBS_gBUILD_MpcPreviewCController mpcPreview = GetPreviewController(mi.num);
                if (mpcPreview==null) {
                    continue;
                } else {
                    PBS_gBUILD_Utility.showDebugMessage('MPCPreview Comments Before: '+ mpcPreview.mpcEdit.Comments__c);                    
                    if (mpcPreview.mpcEdit.Comments__c != null && mpcPreview.mpcEdit.Status__c == null) {
                        viewMode = false;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'GPC Comments cannot be saved without selecting GPC Status. Please select a Status.'));
                        continue;
                    }  else {            
                    //PBS_gBUILD_Utility.showDebugMessage('SAVE: '+miKey);              
                    mpcPreview.save();
                    }
               }
            }
            bind();
/*            
            for (string key : componentControllerMap.keySet())
            {
                if (!key.StartsWithIgnoreCase('mpcPreview')) continue;
                PBS_gBUILD_MpcPreviewCController mpcPreview = (PBS_gBUILD_MpcPreviewCController) getComponentByKey(key);
                mpcPreview.mus = mpcUpdatesByNum.containsKey(mpcPreview.num) ? mpcUpdatesByNum.get(mpcPreview.num) : null;            
            }
*/            
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex);
        }
        return null;
    }

    public PageReference cancel()
    {
        PBS_gBUILD_Utility.showDebugMessage('CANCEL pba:'+pbuildingId);
        viewMode = true;
        bind();
        return null;
    }
        
    private map<integer, list<PBS_gBUILD_PBuildingMPCUpdate__c>> mpcUpdatesByNum;

    protected override void bind()
    {    
        super.bind();
        pb = PBS_gBUILD_Utility.loadProjectBuilding(pbuildingId);        
        mpcUpdatesByNum = new map<integer, list<PBS_gBUILD_PBuildingMPCUpdate__c>>();
        List<PBS_gBUILD_PBuildingMPCUpdate__c> mpcs = PBS_gBUILD_Utility.getMpcUpdates(pBuildingId);
        for (PBS_gBUILD_PBuildingMPCUpdate__c mpc : mpcs)
        {
            system.debug('mpc =====' + mpc.Question__c);
            if (!PBS_gBUILD_Utility.AppConfig.MpcPreviewCompleteHistory__c && !mpc.IsCurrent__c) continue;        
            integer num = PBS_gBUILD_Utility.convertMpcQuestionToNum(mpc.Question__c);
            if (!mpcUpdatesByNum.containsKey(num))
            {
                mpcUpdatesByNum.put(num, new list<PBS_gBUILD_PBuildingMPCUpdate__c>());
            }
            list<PBS_gBUILD_PBuildingMPCUpdate__c> l = mpcUpdatesByNum.get(num);
            l.add(mpc);
        }
        mpcStatusByNum = PBS_gBUILD_Utility.mapLatestMpcByMpcNum(mpcs, false);
        mpcDrByNum = PBS_gBUILD_Utility.mapLatestMpcByMpcNum(mpcs, true); 
    }
    
    protected override void onComponentRegistered(string key, PBS_gBUILD_ComponentBaseController c)
    {
//      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Registered component '+key));                      
        for (PBS_gBUILD_Utility.MpcInfo mi : PBS_gBUILD_Utility.mpcInfos)
        {
            string miKey = 'mpcPreview'+mi.num.format();
            if (miKey!=key) continue;                       
            PBS_gBUILD_MpcPreviewCController mpcPreview = (PBS_gBUILD_MpcPreviewCController) c;
            mpcPreview.num = mi.num;
            mpcPreview.mus = mpcUpdatesByNum.containsKey(mi.num) ? mpcUpdatesByNum.get(mi.num) : null;
        }
    }
}