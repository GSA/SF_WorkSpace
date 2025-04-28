public with sharing class PBS_gBUILD_MpcWaiversCController extends PBS_gBUILD_ComponentBaseController 
{
    public Boolean viewMode { get; set; }
    public Boolean editMode
    {
        get
        {
            return !viewMode;
        }       
    }
    public String readableWaiverKeyTokens { get; set; }
    public Integer mpcNum { get; set; } 
    public String epmCatalog
    {
        get { return PBS_gBUILD_Utility.epmCatalogExecution; }
    }    
    public string ctitle
    {
        get
        {
            PBS_gBUILD_Utility.MpcInfo mi = PBS_gBUILD_Utility.getMpcInfo(mpcNum);
            return string.format('{0}: {1}', new string[]{PBS_gBUILD_Utility.convertNumToMpcQuestion(mpcNum), mi.cat});
        }
    }
}