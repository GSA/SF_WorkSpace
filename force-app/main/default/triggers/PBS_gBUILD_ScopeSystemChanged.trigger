trigger PBS_gBUILD_ScopeSystemChanged on PBS_gBUILD_PBuildingScopeSystem__c (after insert, after update) 
{
    PBS_gBUILD_Utility.showDebugMessage('trigger: PBS_gBUILD_ScopeSystemChanged');
    try
    {
        list<string> parentIds = new list<string>();
        for (PBS_gBUILD_PBuildingScopeSystem__c z : trigger.new) parentIds.add(z.id);
        map<string, PBS_gBUILD_PBuildingScopeSystem__c> parentById = new map<string, PBS_gBUILD_PBuildingScopeSystem__c>();
        for (PBS_gBUILD_PBuildingScopeSystem__c z : [select id, UtilitySav__c, ActualUtilitySav__c, Rahd_ProjectBldgParentId__r.Rahd_ProjectParentId__c, Rahd_ProjectBldgParentId__c from PBS_gBUILD_PBuildingScopeSystem__c where id in:parentIds]) parentById.put(z.id, z);
        list<PBS_gBUILD_UtilitySavings__c> usToInsert = new list<PBS_gBUILD_UtilitySavings__c>();
        for (PBS_gBUILD_PBuildingScopeSystem__c z : parentById.values())
        {
            if (z.UtilitySav__c==null)
            {
                usToInsert.add(new PBS_gBUILD_UtilitySavings__c(ParentScopeSystem__c=z.id, ProjectId__c=z.Rahd_ProjectBldgParentId__r.Rahd_ProjectParentId__c, ParentProjectBuilding__c=z.Rahd_ProjectBldgParentId__c, Phase__c=PBS_gBUILD_Utility.utilitySavingsPhaseAnticipated));
            }
            if (z.ActualUtilitySav__c==null) 
            {
                usToInsert.add(new PBS_gBUILD_UtilitySavings__c(ParentScopeSystem__c=z.id, ProjectId__c=z.Rahd_ProjectBldgParentId__r.Rahd_ProjectParentId__c, ParentProjectBuilding__c=z.Rahd_ProjectBldgParentId__c, Phase__c=PBS_gBUILD_Utility.utilitySavingsPhaseActual));
            }
        }
        if (usToInsert.size()>0)
        {
            insert usToInsert;
            map<string, PBS_gBUILD_PBuildingScopeSystem__c> parentsToUpdateById = new map<string, PBS_gBUILD_PBuildingScopeSystem__c>();            
            for (PBS_gBUILD_UtilitySavings__c us : usToInsert)
            {                
                PBS_gBUILD_PBuildingScopeSystem__c z = parentById.get(us.ParentScopeSystem__c);
                if (us.Phase__c==PBS_gBUILD_Utility.utilitySavingsPhaseAnticipated) z.UtilitySav__c=us.id;
                if (us.Phase__c==PBS_gBUILD_Utility.utilitySavingsPhaseActual) z.ActualUtilitySav__c=us.id;
                parentsToUpdateById.put(z.id, z);
            }
            List<PBS_gBUILD_PBuildingScopeSystem__c> u = new List<PBS_gBUILD_PBuildingScopeSystem__c>();
            u.addAll(parentsToUpdateById.values());
            update u;
            PBS_gBUILD_Utility.showDebugMessage(string.format('Added {0} utility savings to {0} scopeSystems', new string[]{usToInsert.size().format(), u.size().format() }));
        }
    }
    catch (Exception ex)
    {
        PBS_gBUILD_Utility.showDebugMessage(ex);
    }   
}