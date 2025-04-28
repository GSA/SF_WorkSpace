trigger PBS_gBUILD_PBuildingMPCUpdateChanged on PBS_gBUILD_PBuildingMPCUpdate__c (after insert, after update, after delete) 
{
    PBS_gBUILD_Utility.showDebugMessage('trigger: MPCUpdateChanged');
    try
    {        
        Set<string> ids = new Set<string>();
        for (PBS_gBUILD_PBuildingMPCUpdate__c z:trigger.new)
        {
            ids.add(z.Rahd_ProjectBldgParentId__c);
        }
        if (ids.size()>0)
        {
            List<PBS_gBUILD_PBuildingMPCUpdate__c> changes = new list<PBS_gBUILD_PBuildingMPCUpdate__c>();
            PBS_gBUILD_PBuildingMPCUpdate__c[] mpcs = [select id, Rahd_ProjectBldgParentId__c, iscurrent__c, recordtypeid, Question__c from PBS_gBUILD_PBuildingMPCUpdate__c where Rahd_ProjectBldgParentId__c in:ids order by Rahd_ProjectBldgParentId__c, recordtypeid, Question__c, createddate desc];
            string lastPb, lastRec, lastQ;
            for (PBS_gBUILD_PBuildingMPCUpdate__c mpc : mpcs)
            {
                if (mpc.Rahd_ProjectBldgParentId__c!=lastPb || mpc.recordtypeid!=lastRec || mpc.Question__c!=lastQ)
                {
                    lastPb=mpc.Rahd_ProjectBldgParentId__c;
                    lastRec=mpc.recordtypeid;
                    lastQ=mpc.Question__c;
                    if (!mpc.iscurrent__c)
                    {
                        mpc.iscurrent__c = true;
                        changes.add(mpc);
                    }
                }
                else if (mpc.iscurrent__c)
                {
                    mpc.iscurrent__c = false;
                    changes.add(mpc);
                }
            }
            if (changes.size()>0)
            {
                update changes;
                PBS_gBUILD_Utility.showDebugMessage(string.format(
                    'Updated current flag on {1} mpcs',
                    new string[]{changes.size().format() }));
            }
        }
    }
    catch (Exception ex)
    {
        PBS_gBUILD_Utility.showDebugMessage(ex);
    }   
}