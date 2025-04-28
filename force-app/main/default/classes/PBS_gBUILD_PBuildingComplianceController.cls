public with sharing class PBS_gBUILD_PBuildingComplianceController extends PBS_gBUILD_ProjectIdBaseController 
{
    public Map<Integer, PBS_gBUILD_PBuildingMPCUpdate__c> mpcStatusByNum { get; private set; }
    public Map<Integer, PBS_gBUILD_PBuildingMPCUpdate__c> mpcDrByNum { get; private set; }
    public Integer selectedNum { get; set; }
    public List<Item> items { get; private set; }
    
    public PBS_gBUILD_PBuildingComplianceController()
    {
        super('Compliance', true);
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
        List<PBS_gBUILD_PBuildingMPCUpdate__c> mpcs = PBS_gBUILD_Utility.getMpcUpdates(pBuildingId);
        mpcStatusByNum = PBS_gBUILD_Utility.mapLatestMpcByMpcNum(mpcs, false);
        mpcDrByNum = PBS_gBUILD_Utility.mapLatestMpcByMpcNum(mpcs, true);            
        items = new List<Item>();
        for (PBS_gBUILD_Utility.MpcInfo mi : PBS_gBUILD_Utility.mpcInfos)
        {           
            PBS_gBUILD_PBuildingMPCUpdate__c mpc, dr;
            mpc = mpcStatusByNum.containsKey(mi.num) ? mpcStatusByNum.get(mi.num) : null; 
            dr = mpcDrByNum.containsKey(mi.num) ? mpcDrByNum.get(mi.num) : null; 
            Item i = new Item(mi, mpc, dr);
            items.add(i);
        }
    }
        
    public PageReference open()
    {        
        return createMpcPageLink(selectedNum, false);       
        
    }

    public PageReference edit()
    {        
        return createMpcPageLink(selectedNum, true);
    }
    
    public class Item
    {
        public PBS_gBUILD_Utility.MpcInfo info { get; private set; }
        public PBS_gBUILD_PBuildingMPCUpdate__c mpc { get; private set; }
        public PBS_gBUILD_PBuildingMPCUpdate__c dr { get; private set; }
        
        public Item(PBS_gBUILD_Utility.MpcInfo info, PBS_gBUILD_PBuildingMPCUpdate__c mpc, PBS_gBUILD_PBuildingMPCUpdate__c dr)
        {
            this.info = info;
            this.mpc = mpc;
            this.dr = dr;
        }
    }
}