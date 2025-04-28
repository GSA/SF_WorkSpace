public with sharing class PBS_gBUILD_FileManagerController
{
    public static final string paramNameProjectId = 'pid';
    private static final string paramNameFolder = PBS_ePM_FileManagerController.paramNameFolder;
    private static final string paramNameTags = PBS_ePM_FileManagerController.paramNameTags;
    private static final string paramNameDescription = PBS_ePM_FileManagerController.paramNameDescription;
    private static final string paramNameContextualTitle = PBS_ePM_FileManagerController.paramNameContextualTitle;
    private static final string paramNameIntro = PBS_ePM_FileManagerController.paramNameIntro;
    private static final string paramNameDeveloperName = PBS_ePM_FileManagerController.paramNameDeveloperName;
    private static final string paramNameDeveloperNameRandomFormat = PBS_ePM_FileManagerController.paramNameDeveloperNameRandomFormat;
    public Document[] Docs { get; private set; }
    public boolean inputMode { get; private set; }
    public boolean uploadedMode { get { return !inputMode; } }
    public string intro { get; private set; }
    private string developerName { get; set; }
    private string developerNameRandomFormat { get; set; }
    public string actionId { get; set; }
    public Document file { get; set; }
    public string subtitle { get; private set; }
    public string tags { get; set; }
    private string projectId { get; set; }
    public string selectedDocumentId { get; set; }

    public PBS_gBUILD_FileManagerController()
    {
        try
        {
            Map<string, string> p = ApexPages.currentPage().getParameters();
            projectId = p.get(paramNameProjectId);
            subtitle = p.get(paramNameContextualTitle);
            developerName = p.get(paramNameDeveloperName);
            developerNameRandomFormat = p.get(paramNameDeveloperNameRandomFormat);
            intro = p.get(paramNameIntro);
            tags = p.get(paramNameTags);
            bind();
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex);                
        }
    }

    private void bind()
    {
        inputMode = true;
        selectedDocumentId = null;
        Map<string, string> p = ApexPages.currentPage().getParameters();
        file = new Document();
        file.description = p.get(paramNameDescription);
        string dn = 'P'+projectId+'_%';
        PBS_gBUILD_Utility.showDebugMessage('folderId: '+PBS_gBUILD_Utility.ProjectDocsFolderId);
        PBS_gBUILD_Utility.showDebugMessage('dn Expr: '+dn);
        Docs =
        [
            select id, AuthorId, BodyLength, ContentType, Description, DeveloperName, Keywords, Name, Type, Url, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById                
            from Document 
            where FolderId=:PBS_gBUILD_Utility.ProjectDocsFolderId and DeveloperName like :dn
        ];    
    }

    public PageReference uploadAgain()
    {
        bind();
        return null;
    }

    public PageReference upload()
    {
        try
        {
            List<string> parts;
            Integer partCount;

            Map<string, string> p = ApexPages.currentPage().getParameters();
            if (file.body!=null && file.BodyLength>0)
            {
                Integer fileSize = file.BodyLength;

                PBS_gBUILD_Utility.showDebugMessage('vvvvvvvvvvv');
                PBS_gBUILD_Utility.showDebugMessage('file.name');
                try{
                PBS_gBUILD_Utility.showDebugMessage(file.name);
                } catch (exception ex){PBS_gBUILD_Utility.showDebugMessage(ex);}
                PBS_gBUILD_Utility.showDebugMessage('file.contenttype');
                try{
                PBS_gBUILD_Utility.showDebugMessage(file.contenttype);
                } catch (exception ex){PBS_gBUILD_Utility.showDebugMessage(ex);}
                PBS_gBUILD_Utility.showDebugMessage('fileSize.format()');
                try{
                PBS_gBUILD_Utility.showDebugMessage(fileSize.format());
                } catch (exception ex){PBS_gBUILD_Utility.showDebugMessage(ex);}
                PBS_gBUILD_Utility.showDebugMessage('^^^^^^^^^^^');

                PBS_gBUILD_Utility.showDebugMessage('File name:['+file.name+'] size:'+fileSize.format());
            }
            else if (selectedDocumentId!=null && selectedDocumentId.trim().length()>4)
            {
                selectedDocumentId = selectedDocumentId.trim();
                Document d = [select name, body, url, contentType from document where id=:selectedDocumentId];
                file.name = d.name;
                file.body = d.body;
                file.url = d.url;
                file.contentType = d.contentType;
            }
            else 
            {
                PBS_gBUILD_Utility.showWarningMessage('You did not select an existing file AND you did not select a file from your desktop.  Please try again.');
                return null;
            }

            //store the document
            if (developerName!=null && developerName.length()>0)
            {
                file.DeveloperName = developerName;
                if (developerNameRandomFormat!=null && developerNameRandomFormat!='')
                {
                    string rnd = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0,8);
                    file.DeveloperName = string.Format(developerNameRandomFormat, new string[]{file.DeveloperName, rnd});
                }
            }
            file.Type = file.name.substringAfterLast('.');
            file.AuthorId = UserInfo.getUserId();
            file.FolderId = PBS_gBUILD_Utility.ProjectDocsFolderId;
            PBS_gBUILD_Utility.showDebugMessage(string.Format(
                'file: name=[{0}] url=[{1}] folderId=[{2}] developerName=[{3}] contentType=[{4}] type=[{5}]',
                new string[]{file.name, file.url, file.FolderId, file.DeveloperName, file.contenttype, file.type}));
            insert file;
            file.body = null;
            inputMode = false;
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex);
        }
        return null;
    }
}