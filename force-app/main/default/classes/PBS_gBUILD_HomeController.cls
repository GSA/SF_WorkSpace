public with sharing class PBS_gBUILD_HomeController extends PBS_gBUILD_PageBaseController 
{
    public PBS_gBUILD_HomeController()
    {
        super();
        PBS_gBUILD_CookieHelper ch = new PBS_gBUILD_CookieHelper();
        ch.resetProjectCookies();
        ch.setPageName('gBUILD Home');
        ch.setExtraBreadcrumbs(null);    
        ch.setCookies();              
    }    
}