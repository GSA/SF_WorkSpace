public with sharing class PBS_gBUILD_ProjectWorkflowController extends PBS_gBUILD_ProjectIdBaseController
{
    public string WorkflowGraphDisplayMode { get { return PBS_gBUILD_Utility.AppConfig.WorkflowGraphDisplayMode__c; } }
    public PBS_gBUILD_Utility.LinkedObjectFieldInfo wfMachineLink { get; private set; }
    public PBS_gBUILD_Utility.LinkedObjectFieldInfo wfPhaseLink { get; private set; }
    public string machineName { get; private set; }
    public string stateName { get; private set; }
    public string transitionMessage { get; set; }
    public List<SelectOption> nextActions { get; private set; }
    public List<SelectOption> allStates { get; private set; }
    public List<PBS_gBUILD_WorkflowHistory__c> history { get; private set; }
    public List<PBS_gBUILD_WorkflowHistory__c> apprHistory { get; private set; }
    public List<FormApproval> approvals { get; private set; }
    public string selectedTransition { get; set; }
    public string forcedStateNameNext { get; set; }
    public List<StateTransition> stateTransitions { get; private set; }
    public string stateTransitionsJson { get; set; }
    public class FormApproval
    {
        public string Key { get; private set; }
        public string Building { get; private set; }
        public string Form { get; private set; }
        public string Approved { get; set; }
        public string Action { get; set; }
        public string Notes { get; set; }
        public DateTime ReviewedAt  { get; set; }
        public string ReviewedBy  { get; set; }        
        public DateTime ModifiedAt  { get; set; }
        public string ModifiedBy  { get; set; }
        public string ModifiedReason  { get; set; }
        
        public FormApproval(string key, string building, string form)
        {
            this.Key = key;
            this.Building = building;
            this.Form = form;
        }
    }
    
    public PBS_gBUILD_ProjectWorkflowController()
    {
        super('Project Workflow');
        try
        {
            bind();
        }
        catch (Exception ex)
        {
            handleConstructorError(ex);
        }
    }
    
    public PageReference edit() 
    {
        PBS_gBUILD_Utility.showDebugMessage('Edit');
        viewMode = false;
        bind();
        return null;
    }  
         
    public PageReference cancel() 
    {
        PBS_gBUILD_Utility.showDebugMessage('Cancel');
        viewMode = true;
        bind();
        return null;
    }  
    
    public PageReference save() 
    {
        PBS_gBUILD_Utility.showDebugMessage('Save');
        string stateIdNext = null;
        string stateNameNext = null;
        string action = null;
        gBUILD_ApplicationConfig__c t = null;
       
        if (forcedStateNameNext!=null)
        {
            forcedStateNameNext = forcedStateNameNext.trim();
        }
        if (forcedStateNameNext!=null && forcedStateNameNext!='')
        {
            gBUILD_ApplicationConfig__c[] ts = 
            [
                select 
                    id, 
                    Label__c
                from gBUILD_ApplicationConfig__c
                where id=:forcedStateNameNext
            ];
            if (ts.size()>0)
            {
                stateIdNext = ts[0].id;
                stateNameNext = ts[0].Label__c;
                action = 'Forced State Change';
            }
        }
        else       
        {
            gBUILD_ApplicationConfig__c[] ts = 
            [
                select 
                    id, 
                    RecordTypeId, //appConfigRecordTypeIdWfTransition || appConfigRecordTypeIdWfAuthorization
                    Label__c,  //when appConfigRecordTypeIdWfTransition, the action; when appConfigRecordTypeIdWfAuthorization, not specified
                    Roles__c, //when appConfigRecordTypeIdWfTransition, roles that can execute this transition; when appConfigRecordTypeIdWfAuthorization, roles that have the permission
                    Parent__c, //the state this applies to
                    Parent__r.Label__c, //human name for state this applies to
                    WfNextState__c, //when appConfigRecordTypeIdWfTransition, the id of the next state
                    WfNextState__r.Label__c, //when appConfigRecordTypeIdWfTransition, human name of the next state
                    EmailSubjectTemplate__c,
                    EmailBodyTemplate__c
                from gBUILD_ApplicationConfig__c
                where id=:selectedTransition
            ];
            if (ts.size()>0)
            {
                t = ts[0];
                stateIdNext = t.WfNextState__c;
                stateNameNext = t.WfNextState__r.Label__c;
                action = t.Label__c;
            }
        }
        if(action==null)
        {
            PBS_gBUILD_Utility.showWarningMessage('You did not specify an action');
        }
        else
        {
            PBS_gBUILD_WorkflowHistory__c h = new PBS_gBUILD_WorkflowHistory__c();
            h.Rahd_ProjectParentId__c = projectId;
            h.Action__c = action;
            h.Comments__c = transitionMessage;
            h.StateNameCurrent__c = stateNameNext;
            h.StateNamePrevious__c = stateName;
            h.Context__c = string.Format('{0}, {1}', new string[]{stateName, stateNameNext});
            h.RecordTypeId = PBS_gBUILD_Utility.workflowHistoryRecordTypeIdWorkflowStateTransition;
            insert h;       
            
            PBS_gBUILD_Project__c pro = [select id, WorkflowPhaseId__c, ModifiedReason__c from PBS_gBUILD_Project__c where id=:projectId for update];
            pro.WorkflowPhaseId__c = stateIdNext;
            pro.ModifiedReason__c = string.format(
                'Workflow state changed from [{0}] to [{1}].',
                new string[]{h.StateNamePrevious__c, h.StateNameCurrent__c});
            update pro;     
            viewMode = true;
            sendTransitionMessage(t, h);
        }
        return createPageLink(ProjectPageRefs.PWorkflow, true);
    }      
    
    protected override void bind()
    {
        super.bind();
        PBS_gBUILD_Utility.showDebugMessage(string.format('WorkflowGraphDisplayMode__c={0}', new string[]{string.valueOf(AppConfig.WorkflowGraphDisplayMode__c)}));
        history = [
            select 
                RecordTypeId, RecordType.DeveloperName, CreatedDate, CreatedBy.Name,
                Action__c, Comments__c, Context__c, StateNameCurrent__c, StateNamePrevious__c, FormApprovedForReporting__c,
                ParentProjectBuilding__r.BldgId__r.Building_Name__c
            from PBS_gBUILD_WorkflowHistory__c
            where Rahd_ProjectParentId__c = :projectId
            order by LastModifiedDate DESC
            limit :PBS_gBUILD_Utility.soqlLimit
        ];
   //SD
        apprHistory = [
            select 
                RecordTypeId, RecordType.DeveloperName, CreatedDate, CreatedBy.Name,
                Action__c, Comments__c, Context__c, StateNameCurrent__c, StateNamePrevious__c, FormApprovedForReporting__c,
                ParentProjectBuilding__r.BldgId__r.Building_Name__c
            from PBS_gBUILD_WorkflowHistory__c
            where Rahd_ProjectParentId__c = :projectId and Action__c = 'Approved'
            order by Context__c, LastModifiedDate DESC
            limit :PBS_gBUILD_Utility.soqlLimit
        ];
        map<string, FormApproval> approvalByKey = new map<string, FormApproval>();
        approvals = new list<FormApproval>();
        for (PBS_gBUILD_WorkflowHistory__c h : apprHistory)
        {
            h.Comments__c = PBS_gBUILD_Utility.shorten(h.Comments__c);
            if (h.RecordTypeId==PBS_gBUILD_Utility.workflowHistoryRecordTypeIdFormSignoff ||
                h.RecordTypeId==PBS_gBUILD_Utility.workflowHistoryRecordTypeIdLastModifiedReason)
            {
                string key = string.format('{0}, {1}, {2}',new string[]{h.ParentProjectBuilding__r.BldgId__r.Building_Name__c, h.Context__c, h.Id}); //SD
                FormApproval fa;
                if (!approvalByKey.containsKey(key))
                {
                    fa = new FormApproval(key, h.ParentProjectBuilding__r.BldgId__r.Building_Name__c, h.Context__c);
                    approvalByKey.put(key, fa);
                    approvals.add(fa);
                }
                else
                {
                    fa = approvalByKey.get(key);                
                }
                if (h.RecordTypeId==PBS_gBUILD_Utility.workflowHistoryRecordTypeIdFormSignoff)
                {
                    fa.ReviewedAt = h.createddate;
                    fa.ReviewedBy = h.CreatedBy.Name;
                    fa.Notes = h.Comments__c;
                    fa.Approved = h.FormApprovedForReporting__c;
                    fa.Action = h.Action__c;
                }
                else if (h.RecordTypeId==PBS_gBUILD_Utility.workflowHistoryRecordTypeIdLastModifiedReason)
                {
                    fa.ModifiedAt = h.createddate;
                    fa.ModifiedBy = h.CreatedBy.Name;
                    fa.ModifiedReason = h.Comments__c;
                }
            }
        }

        gBUILD_ApplicationConfig__c ac =             
        [            
                select Parent__c, Parent__r.Label__c, Label__c
                from gBUILD_ApplicationConfig__c
                where id=:wfPhaseId 
        ];
        string machineId = ac.Parent__c;
        machineName = ac.Parent__r.Label__c;
        stateName = ac.Label__c;
        transitionMessage = null;
        
        String machineIdEscapeSingleQuotes = String.isNotBlank(machineId)?string.escapeSingleQuotes(machineId):machineId;
        String strQuery = 'select ';
        strQuery += 'id,RecordTypeId,Label__c,Roles__c,Parent__c,Parent__r.Label__c,WfNextState__r.Label__c';
        strQuery += ' from gBUILD_ApplicationConfig__c'; 
        strQuery += ' where Parent__r.Parent__c =: machineIdEscapeSingleQuotes';
        gBUILD_ApplicationConfig__c[] ts = Database.query(strQuery);
        
        /*
        gBUILD_ApplicationConfig__c[] ts = 
            [
                select 
                    id, 
                    RecordTypeId, //appConfigRecordTypeIdWfTransition || appConfigRecordTypeIdWfAuthorization
                    Label__c,  //when appConfigRecordTypeIdWfTransition, the action; when appConfigRecordTypeIdWfAuthorization, not specified
                    Roles__c, //when appConfigRecordTypeIdWfTransition, roles that can execute this transition; when appConfigRecordTypeIdWfAuthorization, roles that have the permission
                    Parent__c, //the state this applies to
                    Parent__r.Label__c, //human name for state this applies to
                    WfNextState__r.Label__c //when appConfigRecordTypeIdWfTransition, human name of the next state
                from gBUILD_ApplicationConfig__c
                where Parent__r.Parent__c=:machineId
            ];
        */
        
        PBS_gBUILD_Utility.showDebugMessage(string.Format('WF: found {0} transitions', new string[]{ts.size().format()}));

        stateTransitions = new List<StateTransition>();
        nextActions = new List<SelectOption>();
        set<string> seen = new set<string>();
        for (gBUILD_ApplicationConfig__c t: ts)
        {
            if (t.RecordTypeId != PBS_gBUILD_Utility.appConfigRecordTypeIdWfTransition) continue;
            StateTransition st = new StateTransition(t);
            if (AppConfig.WorkflowGraphDisplayMode__c!='Full' && st.StateNameCurrent != stateName) continue;
            stateTransitions.add(st);
            if (t.Parent__c != this.WfPhaseId) continue;
            string next = t.Label__c+' ('+t.WfNextState__r.Label__c+')';
            if (seen.contains(next)) continue;
            seen.add(next);
            nextActions.add(new SelectOption(t.id, t.Label__c));
        }       
		stateTransitionsJson = JSON.serialize(stateTransitions);
        ts = 
            [
                select 
                    id, 
                    Label__c,  //this state's name
                    Parent__r.Label__c //the machine name
                from gBUILD_ApplicationConfig__c
                where recordtypeid=:PBS_gBUILD_Utility.appConfigRecordTypeIdWfState and Label__c<>null and Parent__r.Label__c<>null
                order by Parent__r.Label__c, Label__c
            ];
        allStates = new List<SelectOption>();
        allStates.add(new SelectOption('', '<select a destination phase>'));
        for (gBUILD_ApplicationConfig__c t: ts)
        {
            allStates.add(new SelectOption(t.id, string.Format('{0} - {1}', new string[]{t.Parent__r.Label__c, t.Label__c})));
        }
        
        wfMachineLink = new PBS_gBUILD_Utility.LinkedObjectFieldInfo('Machine', null, machineId, machineName);                                
        wfPhaseLink = new PBS_gBUILD_Utility.LinkedObjectFieldInfo('Phase', null, wfPhaseId, stateName);
    }

    public class StateTransition
    {
        public string Id { public get; private set; }
        public string Role { public get; private set; }
        public string Action { public get; private set; }
        public string StateIdCurrent { public get; private set; }
        public string StateNameCurrent { public get; private set; }
        public string StateNameNext { public get; private set; }

        public StateTransition(gBUILD_ApplicationConfig__c ac)
        {
            Id = ac.id;
            Role = ac.Roles__c;
            Action = ac.Label__c;
            StateIdCurrent = ac.Parent__c;
            StateNameCurrent = ac.Parent__r.Label__c;
            StateNameNext = ac.WfNextState__r.Label__c;       
        }
    }

    private void sendTransitionMessage(gBUILD_ApplicationConfig__c transition, PBS_gBUILD_WorkflowHistory__c h)
    {
        if (transition==null) return;
        if (transition.EmailSubjectTemplate__c==null || transition.EmailBodyTemplate__c==null ||
            transition.EmailSubjectTemplate__c=='' || transition.EmailBodyTemplate__c=='')
        {
            PBS_gBUILD_Utility.showDebugMessage(string.format('Transition {0} does not have emailTemplate information', new string[]{transition.id}));
            return;
        }

        PBS_gBUILD_Project__c proj = 
            [
                select id, name, OwnerId, ProjectId__r.txtLongName__c, ProjectType__c
                from PBS_gBUILD_Project__c
                where id=:projectId
            ];
        set<string> userIds = new set<string>();
        userIds.add(proj.OwnerId);
        for (PBS_gBUILD_Project__share z : 
            [
                select UserOrGroupId, RowCause
                from PBS_gBUILD_Project__share 
                where ParentId=:projectId
            ])
        {
          //  if (z.RowCause.endsWith('__c'))
            if (z.RowCause == 'WfRoleProjectAdmin__c') //To add Project Admin Role Members
            {
                userIds.add(z.UserOrGroupId);  
                system.debug('Inside WfRoleProjectAdmin__c');      
            }
        }
        //SD
        
        
            List<GroupMember> lstEnergyDivAdminMembers = [Select g.UserOrGroupId From GroupMember g where g.Group.Name = 'gBUILD Energy Division Admin'];
            set<string> adminMembers = new set<string>();
            
            for (GroupMember gm : lstEnergyDivAdminMembers) {
                if ((proj.ProjectType__c == 'EnergyDivision') || (proj.ProjectType__c == 'EnergyDiv - ENE0000') || (proj.ProjectType__c == 'EnergyDiv - ENWTR000'))
                    adminMembers.add(gm.UserOrGroupID);
                    system.debug('Inside Energy Division Project');
            }
        
        //SD

        map<string, string> extras = new map<string,string>(); 
        extras.put('[Action]', h.Action__c);
        extras.put('[Comments]', h.Comments__c);
        extras.put('[State Name Prev]', h.StateNamePrevious__c);
        extras.put('[State Name Next]', h.StateNameCurrent__c);
        List<string> uids = new List<string>();
        uids.addAll(userIds);
        //SD 
        if (adminMembers.size() > 0) {
            uids.addAll(adminMembers);
            system.debug('Inside Energy Division Project 2');
        }
        //SD
        
        sendTemplatizedMessages(
            AppConfig.SendWorkflowEmails__c,
            uids, 
            transition.EmailSubjectTemplate__c,
            transition.EmailBodyTemplate__c,
            extras);
    }
}