trigger PBS_gBUILD_ProjectBuildingChanged on PBS_gBUILD_ProjectBuilding__c (after insert, after update) 
{
    PBS_gBUILD_Utility.showDebugMessage('trigger: ProjectBuildingChanged');
    try
    {
        List<string> ids = new List<string>();
        for (PBS_gBUILD_ProjectBuilding__c pb : trigger.new) ids.add(pb.id);
        map<string, PBS_gBUILD_ProjectBuilding__c> projectBuildingById = new map<string, PBS_gBUILD_ProjectBuilding__c>();
        List<PBS_gBUILD_UtilitySavings__c> usToInsert = new List<PBS_gBUILD_UtilitySavings__c>();
        PBS_gBUILD_ProjectBuilding__c[] pbs = [select id, Rahd_ProjectParentId__c, PerffutUtilitySav__c, ActualUtilitySav__c from PBS_gBUILD_ProjectBuilding__c where id in:ids and (PerffutUtilitySav__c=null or ActualUtilitySav__c=null)];
        if (pbs.size()==0) return;
        for (PBS_gBUILD_ProjectBuilding__c pb : pbs)
        {
            projectBuildingById.put(pb.id, pb);
            if (pb.PerffutUtilitySav__c==null)
            {
                usToInsert.add(new PBS_gBUILD_UtilitySavings__c(ProjectId__c=pb.Rahd_ProjectParentId__c, ParentProjectBuilding__c=pb.id, Phase__c=PBS_gBUILD_Utility.utilitySavingsPhaseAnticipated));
            }
            if (pb.ActualUtilitySav__c==null) 
            {
                usToInsert.add(new PBS_gBUILD_UtilitySavings__c(ProjectId__c=pb.Rahd_ProjectParentId__c, ParentProjectBuilding__c=pb.id, Phase__c=PBS_gBUILD_Utility.utilitySavingsPhaseActual));
            }
        }
        insert usToInsert;
        for (PBS_gBUILD_UtilitySavings__c us : usToInsert)
        {
            PBS_gBUILD_ProjectBuilding__c pb = projectBuildingById.get(us.ParentProjectBuilding__c);
            if (us.Phase__c==PBS_gBUILD_Utility.utilitySavingsPhaseActual)
            {
                pb.ActualUtilitySav__c = us.id;
            }
            else
            {
                pb.PerffutUtilitySav__c = us.id;
            }
        }
        update pbs;
        PBS_gBUILD_Utility.showDebugMessage(string.format('PBS_gBUILD_ProjectBuildingChanged inserted {0} utilitySavings to {1} projectBuildings', 
            new string[]{usToInsert.size().format(), pbs.size().format()}));
    }
    catch (Exception ex)
    {
        PBS_gBUILD_Utility.showDebugMessage(ex);
    }   
}