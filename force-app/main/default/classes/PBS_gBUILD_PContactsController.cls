public with sharing class PBS_gBUILD_PContactsController extends PBS_gBUILD_ProjectIdBaseController
{
    public List <Actor> ProjectActors { get; private set; }
    public List <Actor> GlobalActors { get; private set; }
    public string actionId { get; set; }
    public PBS_gBUILD_Project__c pro { get; private set; }
    
    public PBS_gBUILD_PContactsController()
    {
        super('Contact Roles');
        try
        {
            bind();
        }
        catch (Exception ex)
        {
            handleConstructorError(ex);
        }           
        this.ProjectActors = ProjectActors; 
        system.debug('Action ID---->' + actionId);   
    }

    public class Actor implements Comparable 
    {
        public string Name { get; set; }
        public string Email { get; set; }
        public string Type { get; set; }
        public string UserOrGroupId { get; set; }
        public string AccessLevel { get; set; }
        public string RowCause { get; set; }
        public string ShareId { get; set; }

        public string Link
        {
            get 
            { 
                if(Type=='User' || Type=='Group') return '/'+UserOrGroupId;
                return null;
            }
        }

        public integer compareTo(object other) 
        {
            Actor that = (Actor) other;
            return Name.compareto(that.name);
        }
    }

    protected override void bind()
    {
        super.bind();
        
        readonlyMode = !(IsOwner || hasPermissionGbAppConfig || isProjectAdmin);
        System.debug('#project Id:' + ProjectId);
        pro = 
        [
            select
                name,
                id, 
                CpEditor1__c,
                CpEditor2__c,
                CpEditor3__c,
                CpEditor4__c,
                CpEditor5__c,
                CpEditor6__c,
                CpEditor7__c,
                CpEditor8__c,
                CpEditor9__c,
                CpEditor10__c,
                CpViewer1__c,
                CpViewer2__c,
                CpViewer3__c,
                CpViewer4__c,
                CpViewer5__c,
                CpViewer6__c,
                CpViewer7__c,
                CpViewer8__c, 
                CpViewer9__c,
                CpViewer10__c
            from PBS_gBUILD_Project__c
            where id=:ProjectId
        ];        

        map<string, PBS_gBUILD_Project__Share> shareByUGId = new map<string, PBS_gBUILD_Project__Share>();
        List<string> userOrGroupIds = new List<string>();
        for (PBS_gBUILD_Project__Share s : 
        [
            select Id, UserOrGroupId, AccessLevel, RowCause
            from PBS_gBUILD_Project__Share
            where ParentId=:projectId           
            limit :PBS_gBUILD_Utility.soqlLimit
        ])
        {
            shareByUGId.put(s.UserOrGroupId, s);
            userOrGroupIds.add(s.UserOrGroupId);
        }
        System.debug('#userOrGroupIds::' + userOrGroupIds);
        ProjectActors = new List<Actor>();
        GlobalActors = new List<Actor>();
        for (User u :
        [
            select Id, Name, Email
            from User
            where id in :userOrGroupIds
        ])            
        {
            PBS_gBUILD_Project__Share s = shareByUGId.get(u.Id);
            Actor a = new Actor();
            a.Name = u.Name;
            a.UserOrGroupId = u.Id;
            a.Type = 'User';
            a.Email = u.Email;
            a.AccessLevel = s.AccessLevel;
            a.RowCause = s.RowCause.removeEnd('__c');
            a.ShareId = s.Id;
            ProjectActors.add(a);
        }

        map<string, List<string>> groupIdsByAccessLevel = new map<string, List<string>>();
        for (Group g :
        [
            select Id, Name, Type, DeveloperName
            from Group
            where id in :userOrGroupIds
        ])            
        {
            PBS_gBUILD_Project__Share s = shareByUGId.get(g.Id);
            Actor a = new Actor();
            a.Name = g.Name;
            if (a.Name==null || a.Name=='') a.Name = g.DeveloperName;
            a.UserOrGroupId = g.Id;
            a.Type = g.Type;
            a.AccessLevel = s.AccessLevel;
            a.RowCause = s.RowCause.removeEnd('__c');
            a.ShareId = s.Id;
            GlobalActors.add(a);
            if (!groupIdsByAccessLevel.containsKey(s.AccessLevel))
            {
                groupIdsByAccessLevel.put(s.AccessLevel, new list<string>());
            }
            groupIdsByAccessLevel.get(s.AccessLevel).add(g.id);
        }

        PBS_gBUILD_Utility.showDebugMessage('---------');

        map<string, Group> groupById = new map<string,Group>();
        for (Group g : [select id, developername, type from group where developername like 'gB%'])
        {
            groupById.put(g.id, g);
        }

        map<string, Actor> globalActorById = new map<string,Actor>();
        set<string> userIds = new set<string>();        
        for (string accessLevel : groupIdsByAccessLevel.keySet())
        {
            List<string> groupIds = groupIdsByAccessLevel.get(accessLevel);
            PBS_gBUILD_Utility.showDebugMessage(string.Format('contact AccessLevel={0} groupCount={1}', new string[]{accessLevel, groupIds.size().format()}));
            map<string, List<string>> userIdsByGroupId = PBS_gBUILD_Utility.GetGroupMemberIds(groupIds, false);
            for (string groupId : userIdsByGroupId.keySet())
            {
                Group g = null;
                if (groupById.containsKey(groupId))
                {
                    g = groupById.get(groupId);
                }
                userIds.addAll(userIdsByGroupId.get(groupId));
                for (string userId : userIdsByGroupId.get(groupId))
                {
                    Actor a;
                    if (globalActorById.containsKey(userId))
                    {
                        a = globalActorById.get(userId);
                    }
                    else
                    {
                        a = new Actor();
                        globalActorById.put(userId, a);
                        a.UserOrGroupId = userId;
                        a.Type = 'User';                        
                    }
                    if (
                        (a.AccessLevel==PBS_gBUILD_Utility.accessLevelRead || a.AccessLevel==null) ||
                        (a.AccessLevel==PBS_gBUILD_Utility.accessLevelEdit && accessLevel==PBS_gBUILD_Utility.accessLevelAll))
                    {
                        a.AccessLevel = accessLevel;
                        a.RowCause = 'Group Membership';
                        if (g!=null) a.RowCause += ' ('+g.DeveloperName+')';
                    }
                }
            }
        }
        for (User u : 
        [
            select id, username, firstname, lastname, name, email, usertype
            from user
            where id in:PBS_gBUILD_Utility.ToList(userIds)
        ])
        {
            if (globalActorById.containsKey(u.id))
            {
                Actor a = globalActorById.get(u.id);
                a.Name = u.Name;
                a.Email = u.Email;
                GlobalActors.add(a);                        
            }
        }
        ProjectActors.sort();
        GlobalActors.sort();
    }

    public PageReference add() 
    {
        return createPageLink(ProjectPageRefs.PContactsItem);
    }       


    public PageReference del() 
    {
        PBS_gBUILD_Project__Share z;
        ShowDebugMessage('ProjectActors is '+ProjectActors);
        ShowDebugMessage('action id is '+actionId);
        try
        {
        z = [select id, UserOrGroupId from PBS_gBUILD_Project__Share where UserOrGroupId=:actionId OR id=:actionId];
        }
        catch (Exception ex)
        {
         ShowDebugMessage(ex);
         ShowDebugMessage('Action ID is '+actionId);
         ShowDebugMessage('z is '+z);
        }
        if(z != null){
            delete z;
            User u =[select name from user where id=:z.UserOrGroupId];
            if(u !=null){
                RecordLastModifiedReason('Contact removed', null, u.Name);
            }
            sendTemplatizedMessages(PBS_gBUILD_Utility.AppConfig.SendContactEmails__c, new string[]{z.UserOrGroupId}, 'ContactRemoved', null);                
        }
       // return createPageLink(ProjectPageRefs.PContacts, true);
       //SD 
       PageReference pageRef= new PageReference('/apex/PBS_gBUILD_PContacts?sfdc.tabName='+ApexPages.currentPage().getParameters().get('sfdc.tabName'));       
       pageRef.setredirect(true);
       return pageRef;
       
    }
 
    public PageReference edit() 
    {
        viewMode = false;
        bind();
        return null;
    }  
         
    public PageReference cancel() 
    {
        viewMode = true;
        bind();
        return null;
    }  
    
    public PageReference save() 
    {
        update pro;
        viewMode = true;
        bind();
        return null;
    }          
}