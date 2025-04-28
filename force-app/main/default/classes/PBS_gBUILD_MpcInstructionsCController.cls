public with sharing class PBS_gBUILD_MpcInstructionsCController
{
    public Integer mpcNum { get; set; }
    public String projType { get; set; }    
    public String instructions
    {
        get
        {
            for (PBS_gBUILD_Utility.MpcInfo mi : PBS_gBUILD_Utility.mpcInfos)
            {
                if (mi.num==mpcNum)
                {
                    if (projType==PBS_gBUILD_Utility.projectTypePartialModernizations ||
                        projType==PBS_gBUILD_Utility.projectTypeLimitScope ||
                        projType==PBS_gBUILD_Utility.projectTypeSmallProject )
                    {
                        return mi.helpPM==null?mi.helpNC:mi.helpPM;
                    }
                    else 
                    {
                        return mi.helpNC==null?mi.helpPM:mi.helpNC;
                    }
                }
            }
            return 'No instructions for MPC '+mpcNum.format();
        }
    }       
}