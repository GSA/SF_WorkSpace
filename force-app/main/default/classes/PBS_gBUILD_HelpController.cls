public with sharing class PBS_gBUILD_HelpController extends PBS_gBUILD_PageBaseController 
{
    public Document[] Docs { get; private set; }
    
    public PBS_gBUILD_HelpController()
    {
        try
        {
            super();
            PBS_gBUILD_CookieHelper ch = new PBS_gBUILD_CookieHelper();
            ch.resetProjectCookies();
            ch.setPageName('Help');
            ch.setExtraBreadcrumbs(null);    
            ch.setCookies();        
            bind();        
        }
        catch (Exception ex)
        {        
            showDebugMessage(ex); 
        }        
    }    
    
    protected override void bind()
    {
        super.bind();
        Docs =
        [
            select id, AuthorId, BodyLength, ContentType, Description, DeveloperName, Keywords, Name, Type, Url, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById                
            from Document 
            where FolderId=:PBS_gBUILD_Utility.HelpDocsFolderId
        ];
    }
}