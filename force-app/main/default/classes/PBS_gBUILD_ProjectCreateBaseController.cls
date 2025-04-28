public virtual with sharing class PBS_gBUILD_ProjectCreateBaseController extends PBS_gBUILD_PageBaseController
{
    public PBS_gBUILD_ProjectCreateBaseController(String pageName)
    {
        super();
        PBS_gBUILD_CookieHelper ch = new PBS_gBUILD_CookieHelper();
        ch.resetProjectCookies();
        ch.setPageName(pageName);
        ch.setExtraBreadcrumbs(null);       
        ch.setCookies();                    
    }
}