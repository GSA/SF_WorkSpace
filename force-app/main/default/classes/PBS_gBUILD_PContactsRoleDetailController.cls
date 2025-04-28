public without sharing class PBS_gBUILD_PContactsRoleDetailController extends PBS_gBUILD_ProjectIdBaseController
{
    public List<SelectOption> Roles { get; set; }
    public string Role { get; set; }
    public map<string, string> temp = new map<string,string>();
    public PBS_gBUILD_Project__c Container { get; set; }

    public PBS_gBUILD_PContactsRoleDetailController()
    {
        super(
            'Details', 
            false,
            new List<string>{
                'Contact Roles', 'PBS_gBUILD_PContacts'                     
            });

        Roles = new List<SelectOption>(); 
        Roles.add(new SelectOption(PBS_gBUILD_Utility.SharingReasonWfRoleDataEntry, 'Data Entry'));
        Roles.add(new SelectOption(PBS_gBUILD_Utility.SharingReasonWfRoleDesignReviewer, 'Design Reviewer'));
        Roles.add(new SelectOption(PBS_gBUILD_Utility.SharingReasonWfRoleProjectAdmin, 'Project Admin'));
        Roles.add(new SelectOption(PBS_gBUILD_Utility.SharingReasonWfRoleViewer, 'Viewer'));

        try
        {            
            bind();
        }
        catch (Exception ex)
        {   handleConstructorError(ex);
        }            
    }
    
    protected override void bind()
    {
        super.bind();
        Container = new PBS_gBUILD_Project__c();
    }
    /*
    private void insertUser()
    {
        PBS_gBUILD_Project__Share s = new PBS_gBUILD_Project__Share();
        s.UserOrGroupId = Container.OwnerId;
        s.ParentId = projectId;
        if (Role==PBS_gBUILD_Utility.SharingReasonWfRoleDataEntry)
        {
            s.RowCause = Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleDataEntry__c;
            s.AccessLevel = 'Edit';
        }
        else if (Role==PBS_gBUILD_Utility.SharingReasonWfRoleDesignReviewer)
        {
            s.RowCause = Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleDesignReviewer__c;
            s.AccessLevel = 'Edit';
        }
        else if (Role==PBS_gBUILD_Utility.SharingReasonWfRoleProjectAdmin)
        {
            s.RowCause = Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleProjectAdmin__c;
            s.AccessLevel = 'Edit';
        }
        else
        {
            s.RowCause = Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleViewer__c;
            s.AccessLevel = 'Read';
        }
        insert s;    
        map<string, string> t = new map<string,string>();
        t.put('Role', Role);
        sendTemplatizedMessages(PBS_gBUILD_Utility.AppConfig.SendContactEmails__c, new string[]{s.UserOrGroupId}, 'ContactAdded', t);
        User u = [select name from user where id=:container.ownerid];
        RecordLastModifiedReason('Contact created', null, u.Name);
    }
    */
    private void insertUser()
    {
        PBS_gBUILD_Project__Share s;
        showDebugMessage('Role is '+Role);
        s = new PBS_gBuild_Project__Share();
        if (Role==PBS_gBUILD_Utility.SharingReasonWfRoleDataEntry)
        {
            showDebugMessage('Data Entry Row Cause '+Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleDataEntry__c);
            s.RowCause = Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleDataEntry__c; //SD
            s.AccessLevel = 'Edit';
        }
        else if (Role==PBS_gBUILD_Utility.SharingReasonWfRoleDesignReviewer)
        {
            showDebugMessage('Design Review Row Cause '+Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleDesignReviewer__c);
            s.RowCause = Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleDesignReviewer__c; //SD
            s.AccessLevel = 'Edit';
        }
        else if (Role==PBS_gBUILD_Utility.SharingReasonWfRoleProjectAdmin)
        {
            showDebugMessage('Project Admin Row Cause '+Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleProjectAdmin__c);
            s.RowCause = Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleProjectAdmin__c; //SD
            s.AccessLevel = 'Edit';
        }
        else
        {
            showDebugMessage('Role Viewer Row Cause '+Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleViewer__c);
            s.RowCause = Schema.PBS_gBUILD_Project__Share.RowCause.WfRoleViewer__c; //SD
            s.AccessLevel = 'Read';
        }
        
        s.UserOrGroupId = Container.OwnerId;
        s.ParentId = projectId;
        showDebugMessage('This is s'+ s);
        insert s;    
        map<string, string> t = new map<string,string>();
        t.put('Role', Role);
        sendTemplatizedMessages(PBS_gBUILD_Utility.AppConfig.SendContactEmails__c, new string[]{s.UserOrGroupId}, 'ContactAdded', t);
        User u = [select name from user where id=:container.OwnerId];
        showDebugMessage('This is user u' + u);
        RecordLastModifiedReason('Contact created', null, u.Name);
    }
    
    public PageReference save()
    {
        //try
        //{    
            showDebugMessage('SAVE');
            insertUser();
           // return createPageLink(ProjectPageRefs.PContacts);
            //SD 
       PageReference pageRef= new PageReference('/apex/PBS_gBUILD_PContacts?sfdc.tabName='+ApexPages.currentPage().getParameters().get('sfdc.tabName'));       
       pageRef.setredirect(true);
       return pageRef;
        ///}
        //catch (Exception ex)
        //{   showDebugMessage(ex);
        //    return null;
        //}        
    }

    public PageReference saveAndNew()
    {
        try{
        showDebugMessage('SAVEandNEW');
        insertUser();
        return createPageLink(ProjectPageRefs.PContactsItem, true);
        }
        catch(Exception ex){
          showDebugMessage(ex);
          return null;
        }
    }

    public PageReference cancel()
    {
        return createPageLink(ProjectPageRefs.PContacts);
    }   
}