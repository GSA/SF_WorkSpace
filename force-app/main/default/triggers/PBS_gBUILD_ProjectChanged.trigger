trigger PBS_gBUILD_ProjectChanged on PBS_gBUILD_Project__c (after insert, after update) 
{
    PBS_gBUILD_Utility.showDebugMessage(string.format(
        'PBS_gBUILD_Project__c Changed Trigger IsAfter={0} IsInsert={1} isUpdate={2}',
        new string[] { trigger.IsAfter?'t':'f', trigger.isInsert?'t':'f', trigger.isUpdate?'t':'f'}
        ));
    try
    {
        if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
        {            
            List<string> ids = new List<string>();        
            for (PBS_gBUILD_Project__c z : trigger.new)
            {
                ids.add(z.id);
            }
            PBS_gBUILD_Project__c[] ps = [select id, projectid__r.txtRegion__c, projectid__r.txtProgramArea_FullCode__c, numRegion__c, txtProgramArea_FullCode__c from PBS_gBUILD_Project__c where id in:ids];
            List<PBS_gBUILD_Project__c> changedProjects = new List<PBS_gBUILD_Project__c>();
            for (PBS_gBUILD_Project__c p : ps)
            {
                boolean changed = false;
                if (p.txtProgramArea_FullCode__c != p.projectid__r.txtProgramArea_FullCode__c)
                {
                    p.txtProgramArea_FullCode__c = p.projectid__r.txtProgramArea_FullCode__c;
                    changed = true;
                }
                integer r = 0;
                if (p.projectid__r.txtRegion__c!=null) r = integer.valueOf(p.projectid__r.txtRegion__c);
                if (p.numRegion__c != r)
                {
                    p.numRegion__c = r;
                    changed = true;
                }
                if (changed) changedProjects.add(p);
            }
            if (changedProjects.size()>0) update changedProjects;
            PBS_gBUILD_Utility.showDebugMessage(string.format(
                'PBS_gBUILD_Project__c Changed Updates {0} records',
                new string[] { changedProjects.size().format() }
                ));
        }
    }
    catch (Exception ex)
    {
        PBS_gBUILD_Utility.showDebugMessage(ex);
    }
}

/*
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
    {            
        List<string> ids = new List<string>();        
        List<PBS_gBUILD_Project__Share> shares = new List<PBS_gBUILD_Project__Share>();
        for (PBS_gBUILD_Project__c z : trigger.new)
        {
            if (Trigger.isInsert)
            {
                PBS_gBUILD_Project__Share s = new PBS_gBUILD_Project__Share();
                s.UserOrGroupId = UserInfo.getUserId();
                s.ParentId = z.id;
                s.RowCause = Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleProjectAdmin__c;
                s.AccessLevel = 'Edit';
                shares.add(s);
            }
            ids.add(z.id);
        }
        if (shares.size()>0)
        {
            insert shares;
            PBS_gBUILD_Utility.showDebugMessage(string.format(
                'PBS_gBUILD_Project__c Changed Trigger inserted {0} shares',
                new string[] { shares.size().format() }
                ));
        }
        Group g = [select id from group where developername='gBUILD_ProjectOwner'];
        PBS_gBUILD_Project__c[] ps = [select id, projectid__r.txtRegion__c, projectid__r.txtProgramArea_FullCode__c, OwnerId, numRegion__c, txtProgramArea_FullCode__c from PBS_gBUILD_Project__c where id in:ids];
        List<PBS_gBUILD_Project__c> changedProjects = new List<PBS_gBUILD_Project__c>();
        for (PBS_gBUILD_Project__c p : ps)
        {
            if (
                p.OwnerId == g.id &&
                p.numRegion__c == integer.valueOf(p.projectid__r.txtRegion__c) &&
                p.txtProgramArea_FullCode__c == p.projectid__r.txtProgramArea_FullCode__c
            ) continue;
            p.OwnerId = g.id;
            p.numRegion__c = integer.valueOf(p.projectid__r.txtRegion__c);
            p.txtProgramArea_FullCode__c = p.projectid__r.txtProgramArea_FullCode__c;
            changedProjects.add(p);
        }
        update changedProjects;
        PBS_gBUILD_Utility.showDebugMessage(string.format(
            'PBS_gBUILD_Project__c Changed Updates {0} records',
            new string[] { changedProjects.size().format() }
            ));
    }
*/
/*
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {            
        Group g = [select id from group where developername='gBUILD_ProjectOwner'];
        List<string> ids = new List<string>();
        for (PBS_gBUILD_Project__c z : trigger.new)
        {
            ids.add(z.projectid__c);
        }
        PBS_Project__c[] refs = [select id, txtRegion__c, txtProgramArea_FullCode__c from PBS_Project__c where id in:ids ];
        map<string, PBS_Project__c> m = new map<string, PBS_Project__c>();
        for (PBS_Project__c q : refs)
        {
            m.put(q.id, q);
        }
        for (PBS_gBUILD_Project__c z : trigger.new)
        {
            z.OwnerId = g.id;
            PBS_Project__c p = m.get(z.projectid__c);
            z.numRegion__c = integer.valueOf(p.txtRegion__c);
            z.txtProgramArea_FullCode__c = p.txtProgramArea_FullCode__c;
        }
    }
*/