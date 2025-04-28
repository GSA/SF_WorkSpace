public virtual with sharing class PBS_gBUILD_ProjectIdBaseController  extends PBS_gBUILD_PageBaseController
{
    public boolean isApproveEnabled { get; private set; }
    public boolean showPageContent { get; protected set; }
    public boolean showNoProjectMessage { get; private set; }
    public boolean showNoBuildingMessage { get; private set; }
    public boolean isOwner { get; private set; }
    public boolean readonlyMode { get; protected set; }
    public boolean readWriteMode { get { return !readonlyMode; } }      
    public String projectId { get; private set; }
    public String pbsProjectId { get; private set; }    
    public Boolean pbsProjectCreatedInGbuild { get; private set; }
    public String pbsProjectCreatedIn { get; private set; }
    public String pbsBuildingId { get; set; }
    public String buildingId { get; private set; }
    public String pbuildingId { get; private set; }
    public String scopeSystemId { get; protected set; }
    public String pageName { get; private set; }
    public String pageLabel { get; private set; }
    public String prolianceAccountName { get; private set; }
    public String pmName { get; private set; }
    public String wfPhaseId { get; private set; }
    public String wfPhaseName { get; private set; }
    @TestVisible
    protected map<string,string> formPermissionByRole { get; private set; }
    public Boolean isProjectFormative { get; private set; }
    public Exception projectIdBaseControllerException { get; private set; }
    public Boolean viewMode { get; private set; }
    public boolean isProjectAdmin { get; private set; }
    public Boolean editMode{
        get {
            return !viewMode;    }   }

    protected void handleConstructorError(Exception ex) {
        projectIdBaseControllerException = ex;
        showPageContent = false;
        if (showNoProjectMessage){ ShowErrorMessage('A project must be selected to use this page.  Please click on the "Projects" tab to continue.'); }
        else if (showNoBuildingMessage){ ShowErrorMessage('A project-building must be selected to use this page.  Please click on the "Project Basics" tab and then the "Select a Building" dropdown to continue.');            
        }
        else{ ShowDebugMessage(ex); }
    }
    
    public void syncPBuildings(){
        PBS_gBUILD_Utility.syncPBuildings(projectId, pbsProjectId);
    }
    
    public PBS_gBUILD_ProjectIdBaseController(String pageName){                   
        this(pageName, false);
    }
    
    public PBS_gBUILD_ProjectIdBaseController(String pageName, Boolean isBuildingLevel){                   
        this(pageName, isBuildingLevel, null);
    }
    
    public class NoProjectNoBuildingException extends Exception {}    
    
    public PBS_gBUILD_ProjectIdBaseController(String pageName, Boolean isBuildingLevel, List<string> extraBreadcrumbs){                       
        super();
        try {
            readonlyMode = true;
            isApproveEnabled = false;
            isProjectAdmin = false;
            showNoProjectMessage = false;
            showNoBuildingMessage = false;        
            showPageContent = false;

            viewMode = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringPageMode) != PBS_gBUILD_Utility.pageModeEdit;
            projectId = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringProjectId);
            buildingId = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringBuildingId);
               system.debug(projectId +'dd'+buildingId ) ;                    
            PBS_gBUILD_CookieHelper ch = new PBS_gBUILD_CookieHelper();
            if (projectId==null || projectId==''){
                projectId = ch.getProjectId();
            }
            showNoProjectMessage = projectId == null || projectId=='';
            if (isBuildingLevel && buildingId==null || buildingId==''){
                buildingId = ch.getBuildingId();
            }
            if (isBuildingLevel){
                showNoBuildingMessage = true;
                PBS_gBUILD_ProjectBuilding__c z = [
                    select id, BldgId__c from PBS_gBUILD_ProjectBuilding__c where Rahd_ProjectParentId__c=:projectId and BldgId__r.Location_Code_Plus__c=:buildingId order by createddate limit 1
                ];
                pbuildingId = z.id;
                pbsBuildingId = z.BldgId__c;            
                ch.setDebugVal('pbuildingId: '+pbuildingId);
                showNoBuildingMessage =  pbuildingId == null || pbuildingId =='';
            }
            ShowDebugMessage(string.format('ProjectId={0} PBuildingId={1}', new string[]{projectId, pbuildingId}));
            ch.setProjectCookies(projectId, isBuildingLevel ? buildingId : null);       
            ch.setPageName(pageName);
            ch.setExtraBreadcrumbs(extraBreadcrumbs);
            ch.setCookies();                
            this.pageName = pageName;
            this.pageLabel = pageName + ' projectId=' + projectId;
            pbsProjectId = ch.pbsProjectId;
            pbsProjectCreatedIn = ch.pbsProjectCreatedIn;
            pbsProjectCreatedInGbuild = ch.pbsProjectCreatedIn==PBS_gBUILD_Utility.commonProjCreatorGbuild;
            prolianceAccountName  = ch.prolianceAccountName;    
            pmName = ch.pmName;        
            wfPhaseId = ch.wfPhaseId;
            wfPhaseName = ch.wfPhaseName;
            isProjectFormative = ch.isProjectFormative;
            isOwner = ch.projectOwnerId==UserInfo.getUserId();
            bindPermissions();
            showPageContent = !(showNoProjectMessage || showNoBuildingMessage );
            if (!showPageContent) throw new NoProjectNoBuildingException();
        }
        catch (Exception ex){ handleConstructorError(ex);}       
    }

    private string GetEditLevelProjectAuthorization(){
        if (isCustomerPortalUser){ PBS_gBUILD_Project__c[] ps =  [select id  from PBS_gBUILD_Project__c where  id=:projectId and (CpEditor1__c=:CustomerPortalContactId or CpEditor2__c=:CustomerPortalContactId or CpEditor3__c=:CustomerPortalContactId or CpEditor4__c=:CustomerPortalContactId or CpEditor5__c=:CustomerPortalContactId or CpEditor6__c=:CustomerPortalContactId or CpEditor7__c=:CustomerPortalContactId or CpEditor8__c=:CustomerPortalContactId or CpEditor9__c=:CustomerPortalContactId or CpEditor10__c=:CustomerPortalContactId)];
            if (ps.size()==1) return 'CP_Edit';
        }
        else{
            string userId = UserInfo.getUserId();
            list<string> ids = new list<string>();
            set<string> seen = new set<string>();
            for (PBS_gBUILD_Project__Share z :  [select UserOrGroupId, RowCause from PBS_gBUILD_Project__Share where  ParentId=:projectId and  (AccessLevel=:PBS_gBUILD_Utility.accessLevelEdit or AccessLevel=:PBS_gBUILD_Utility.accessLevelAll)])
            {
                if (z.UserOrGroupId==userId){
                    return z.RowCause.removeEndIgnoreCase('__c');
                }
                ids.add(z.UserOrGroupId);
            }
            if (!isCustomerPortalUser) {
                seen.addAll(ids);
                for (integer l=0;l<10&&ids.size()>0;++l) {
                    GroupMember[] items = [select UserOrGroupId from groupmember where GroupId in:ids];
                    ids.clear();
                    for (GroupMember z : items) {
                        if (z.UserOrGroupId==userId) return PBS_gBUILD_Utility.SharingReasonWfRoleProjectAdmin;
                        if (seen.contains(z.UserOrGroupId)) continue;
                        ids.add(z.UserOrGroupId);
                    }
                    seen.addAll(ids);
                }
            }
        }
        return null;
    }


    protected void bindPermissions() {
        readonlyMode = true;
        try {
            string auth = GetEditLevelProjectAuthorization();
            isApproveEnabled = auth==PBS_gBUILD_Utility.SharingReasonWfRoleProjectAdmin || hasPermissionGbAppConfig || isOwner;
            isProjectAdmin = auth==PBS_gBUILD_Utility.SharingReasonWfRoleProjectAdmin;
            readonlyMode = auth==null && !isOwner;
            ShowDebugMessage(string.format('GetEditLevelProjectAuthorization=>{0} isOwner={1} isApproveEnabled={2} readonlyMode= {3} isProjectAdmin = {4}', new string[]{auth, isOwner?'true':'false', isApproveEnabled?'true':'false', readonlyMode?'true':'false' , isProjectAdmin?'true':'false'}));
        }
        catch (Exception ex)  { ShowDebugMessage(ex);
        }
        if (readonlyMode) { PBS_gBUILD_Utility.showInfoMessage('Based on your role and the current state of the project, you have readonly permissions.');
        }
    }

    public transient List<PBS_gBUILD_Utility.DocInfo> DocInfos_p; //Public so we can setup unit testing

    public List<PBS_gBUILD_Utility.DocInfo> DocInfos {
        get {
            if (DocInfos_p==null) {
                string dn = 'P'+projectId+'_%';
                Document[] documents = [select id, AuthorId, BodyLength, ContentType, Description, DeveloperName, Keywords, Name, Type, Url, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById                
                    from Document where FolderId=:PBS_gBUILD_Utility.ProjectDocsFolderId and DeveloperName like :dn order by Name];
                List<PBS_gBUILD_Utility.DocInfo> docInfos = new List<PBS_gBUILD_Utility.DocInfo>();
                List<string> msgs = new List<string>();
                for (Document document : documents) {
                    msgs.add(string.Format('{0}:[{1}]', new string[]{document.developername, document.name}));
                    try {
                        docInfos.add(new PBS_gBUILD_Utility.DocInfo(document));
                    }
                    catch (Exception ex) { ShowDebugMessage(ex);
                    }    
                }  
                ShowDebugMessage('Docs: '+PBS_gBUILD_Utility.format(msgs, '; '));
                DocInfos_p = docInfos;
            }
            return DocInfos_p;
        }
    }

    //PageLink Helpers

    public enum ProjectPageRefs  {
        PBasics, PFundingSources, PFundingSourcesItem, PFinancials, PContacts, PContactsItem, PWorkflow, PManageBuildings,
        PbBasics, PbScope, PbCloseout, PbCompliance, PbInnovations, PbInnovationsItem,
        PbMpcM, PbMpcIEQ, PbMpcW, PbMpcEP, PbMpcID
    }
    @TestVisible
     protected PageReference createPageLinkFromObjectId(string objectId) {
        PageReference pr = new PageReference('/'+objectId);
        pr.setRedirect(true);
        return pr;
    }

    protected PageReference createMpcPageLink(integer mpcNum, boolean edit) {
        ProjectPageRefs ppr;

        if (mpcNum >= 19) ppr = ProjectPageRefs.PbMpcM;
        else if (mpcNum >= 15) ppr = ProjectPageRefs.PbMpcIEQ;
        else if (mpcNum >= 11)  ppr = ProjectPageRefs.PbMpcW;
        else if (mpcNum >= 6)  ppr = ProjectPageRefs.PbMpcEP;
        else ppr = ProjectPageRefs.PbMpcID;

        PageReference pr = createPageLink(ppr, 'num', mpcNum.format());
        pr.setAnchor('mpc'+mpcNum.format());
        if (edit) { pr.getParameters().put(PBS_gBUILD_Utility.queryStringPageMode, PBS_gBUILD_Utility.pageModeEdit);
        }

        return pr; 
    }

    protected PageReference createPageLink(ProjectPageRefs pageRef) {
        return createPageLink(pageRef, false);
    }

    protected PageReference createPageLink(ProjectPageRefs pageRef, boolean clientRedirect) {
        return createPageLink(pageRef, null, null, clientRedirect);
    }

    protected PageReference createPageLink(ProjectPageRefs pageRef, string idName, string idVal) {
        return createPageLink(pageRef, idName, idVal, false);
    }
        
    private PageReference createPageLink(ProjectPageRefs pageRef, string idName, string idVal, boolean clientRedirect) {
        boolean isBuilding = false;
        PageReference pr = null;
        if (pageRef==ProjectPageRefs.PBasics) pr = Page.PBS_gBUILD_ProjectBasics;
        else if (pageRef==ProjectPageRefs.PContacts) pr = Page.PBS_gBUILD_PContacts;
        else if (pageRef==ProjectPageRefs.PContactsItem) pr = Page.PBS_gBUILD_PContactsRoleDetail;
        else if (pageRef==ProjectPageRefs.PWorkflow) pr = Page.PBS_gBUILD_ProjectWorkflow;
        else if (pageRef==ProjectPageRefs.PFundingSources) pr = Page.PBS_gBUILD_PFundingSources;
        else if (pageRef==ProjectPageRefs.PFundingSourcesItem) pr = Page.PBS_gBUILD_PFundingItem;
        else if (pageRef==ProjectPageRefs.PManageBuildings) pr = Page.PBS_gBUILD_PBuildingsManage;
        else {
            if (pageRef==ProjectPageRefs.PbBasics) pr = Page.PBS_gBUILD_PBuildingBasics;
            else if (pageRef==ProjectPageRefs.PbScope) pr = Page.PBS_gBUILD_PBuildingScope;
            else if (pageRef==ProjectPageRefs.PbCompliance) pr = Page.PBS_gBUILD_PBuildingCompliance;
            else if (pageRef==ProjectPageRefs.PbCloseout) pr = Page.PBS_gBUILD_PBuildingCloseout;
            else if (pageRef==ProjectPageRefs.PbInnovations) pr = Page.PBS_gBUILD_PBuildingInnovation;
            else if (pageRef==ProjectPageRefs.PbInnovationsItem) pr = Page.PBS_gBUILD_PBInnovationNew;
            else if (pageRef==ProjectPageRefs.PbMpcM) pr = Page.PBS_gBUILD_PBuildingMpcM;
            else if (pageRef==ProjectPageRefs.PbMpcIEQ) pr = Page.PBS_gBUILD_PBuildingMpcIEQ;
            else if (pageRef==ProjectPageRefs.PbMpcW) pr = Page.PBS_gBUILD_PBuildingMpcW;
            else if (pageRef==ProjectPageRefs.PbMpcEP) pr = Page.PBS_gBUILD_PBuildingMpcEP;
            else if (pageRef==ProjectPageRefs.PbMpcID) pr = Page.PBS_gBUILD_PBuildingMpcID;
            else return null;
            isBuilding = true;        
        }
        pr.setRedirect(clientRedirect);
        map<string, string> ps = pr.getParameters();
        ps.put(PBS_gBUILD_Utility.queryStringProjectId, projectId);
        if (isBuilding) {
            ps.put(PBS_gBUILD_Utility.queryStringBuildingId, buildingId);
        }
        if (idName!=null) {
            ps.put(idName, idVal);
        }
        return pr;
    }

    protected virtual void RecordPageSaved() {
        RecordPageSaved(null);
    }
    
    protected virtual void RecordPageSaved(string comments)  {
        PBS_gBUILD_Utility.RecordWorkflowHistory(
            PBS_gBUILD_Utility.workflowHistoryRecordTypeIdLastModifiedReason, 
            PBS_gBUILD_Utility.ModifyReasonUpdated,
            comments,
            projectId,
            pbuildingId,
            scopeSystemId, 
            null,
            pageName);
    }

    public PageReference approve() {
        string comment = ApexPages.currentPage().getParameters().get('approveReason');
        string approved = ApexPages.currentPage().getParameters().get('approvedForReporting');
        PBS_gBUILD_WorkflowHistory__c z = PBS_gBUILD_Utility.RecordWorkflowHistory(
            PBS_gBUILD_Utility.workflowHistoryRecordTypeIdFormSignoff, 
            PBS_gBUILD_Utility.ModifyReasonApproved,
            comment,
            projectId,
            pbuildingId,
            scopeSystemId, 
            null,
            pageName);
        if (approved=='Yes' || approved=='No') {
            z.FormApprovedForReporting__c = approved;            
            update z;
        }
        ViewMode = true;
        return null;
    }

    protected void recordLastModifiedReason(string reason, string comments, string context) {
        PBS_gBUILD_Utility.RecordWorkflowHistory(PBS_gBUILD_Utility.workflowHistoryRecordTypeIdLastModifiedReason, reason, comments, projectId, pbuildingId, scopeSystemId, null, context);
    }
    
    private list<Messaging.SingleEmailMessage> createTemplatizedMessages(list<string> userIds, string subjectTemplate, string bodyTemplate, map<string, string> extras) {
        PBS_gBUILD_Project__c p = [select id, name, ProjectId__r.txtLongName__c from PBS_gBUILD_Project__c where id=:projectId];
        map<string, user> userById = new map<string,user>();
        for (User z : [select id, FirstName, LastName, Email, UserName from User where id in:userIds]) {
            userById.put(z.id, z);
        }

        string projectUrl = URL.getSalesforceBaseUrl().toExternalForm() + createPageLink(ProjectPageRefs.PBasics).getUrl();        

        list<Messaging.SingleEmailMessage> msgs = new list<Messaging.SingleEmailMessage>();
        for (string userId : userIds) {
            User u = userById.get(userId);
            if (u==null) continue;
            string[] lines = new string[]{subjectTemplate, bodyTemplate};
            for (integer z=0;z<lines.size();++z)  {
                string line = lines.get(z);
                line = line.replace('[Project Name]', p.ProjectId__r.txtLongName__c);
                line = line.replace('[ProjectUrl]', projectUrl);
                line = line.replace('[Name]', p.name);
                line = line.replace('[Id]', p.id);
                line = line.replace('[Project.Name]', p.ProjectId__r.txtLongName__c);
                line = line.replace('[Project.Url]', projectUrl);
                line = line.replace('[User.FirstName]', u.FirstName);
                line = line.replace('[User.LastName]', u.LastName);
                line = line.replace('[User.Email]', u.Email);
                line = line.replace('[User.UserName]', u.UserName);
                line = line.replace('[HelpDesk]', PBS_gBUILD_Utility.AppConfig.HelpDeskEmail__c);
                if (extras!=null) {
                    for (string key : extras.keySet()) {                    
                        string t = '['+key+']';
                        string v = extras.get(key);
                        if (v==null) v = '';
                        line = line.replace(t, v);
                    }
                }
                lines.set(z,line);                
            }
            string subject = lines.get(0);
            string body = lines.get(1);
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setTargetObjectId(userId);
            msg.setSubject(subject);
            msg.setPlainTextBody(body);
            msg.saveAsActivity = false;
            msgs.add(msg);
            ShowDebugMessage(string.format(
                'Recipient=[{0}] Subject=[{1}] Body=[{2}]',
                new string[]{userId, subject, body}
            ));            
        }
        return msgs;
    }        
    
    public void sendTemplatizedMessages(boolean functionSpecificSendFlag, list<string> userIds, string templateName, map<string, string> extras){
        gBUILD_ApplicationConfig__c[] items = [ select EmailBodyTemplate__c,EmailSubjectTemplate__c from gBUILD_ApplicationConfig__c where Name=:templateName limit 1];
        if (items.size()==0) {
            PBS_gBUILD_Utility.showErrorMessage(string.Format('Missing email template=[{0}]', new string[]{templateName}));
        }
        else {
            sendTemplatizedMessages(functionSpecificSendFlag, userIds, items[0].EmailSubjectTemplate__c, items[0].EmailBodyTemplate__c, extras);
        }
    }
        
    public void sendTemplatizedMessages(boolean functionSpecificSendFlag, list<string> userIds, string subjectTemplate, string bodyTemplate, map<string, string> extras){
        list<Messaging.SingleEmailMessage> msgs = createTemplatizedMessages(userIds, subjectTemplate, bodyTemplate, extras);
        
        if (!functionSpecificSendFlag) { ShowDebugMessage('function specific email are currently disabled'); return;}
        
        if (!AppConfig.SendApplicationEmails__c) {  ShowDebugMessage('application emails are currently disabled');  return;
        } if  (Test.isRunningTest()) { ShowDebugMessage('Running a unit test, will not send emails');  return;}
        Messaging.sendEmail(msgs);
        PBS_gBUILD_Utility.showInfoMessage(string.format('Sent messages to {0} users', new string[]{msgs.size().format()}));
    }    
}

/*
global with sharing class PBS_gBUILD_WebService 
{
    public static final string ProjectAuthorizationAdmin = 'Admin';
    public static final string ProjectAuthorizationEdit = 'Edit';
    public static final string ProjectAuthorizationView = 'View';
    public static final string ProjectAuthorizationNone = 'None ';
    
    webService static string getGbProjectAuthorization(string gBuildProjectId) 
    {
        boolean canEdit = false;
        SavePoint sp = database.setSavePoint();
        try
        {
            PBS_gBUILD_Project__c[] ps = [select id, Notes__c from PBS_gBUILD_Project__c where id=:gBuildProjectId];
            if (ps.size()==0) return ProjectAuthorizationNone;
            PBS_gBUILD_Project__c p = ps[0];
            p.Notes__c = 'edit test';
            Database.SaveResult sr = Database.update(p);
            if (sr.isSuccess())
            {
                PBS_gBUILD_Project__share[] shares = 
                [
                    select id
                    from PBS_gBUILD_Project__share 
                    where 
                        rowCause=:(PBS_gBUILD_Utility.SharingReasonWfRoleDataEntry+'__c') and 
                        ParentId=:gBuildProjectId and 
                        UserOrGroupId=:UserInfo.getUserId()
                    limit 1
                    ];
                if (shares.size()>0)
                {
                    return ProjectAuthorizationEdit;
                }
                return ProjectAuthorizationAdmin;
            }
        }
        catch (Exception ex)
        {}
        database.rollback(sp);
        return ProjectAuthorizationView;
    }
}
*/