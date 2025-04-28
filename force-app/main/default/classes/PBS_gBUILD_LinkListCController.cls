public with sharing class PBS_gBUILD_LinkListCController
{
    public string Name { get; set; }
    public string Target { get; set; }
    public string Title { get { bind(); return Title_p; } }
    private string Title_p;
    public List<Link> Links { get { bind(); return Links_p; } }
    private List<Link> Links_p;
    
    public class Link
    {
        public string Text { get; set; }
        public string Reference { get; set; }
    }
    
    public PBS_gBUILD_LinkListCController()
    {
        Links_p = null;
        Title_p = '';
    }
    
    private void bind()
    {
        if (Links_p!=null) return;
        boolean isCustomerPortalUser = UserInfo.getUserType()=='CspLitePortal' || UserInfo.getUiTheme()=='PortalDefault';
        gBUILD_ApplicationConfig__c[] acs;
        if (isCustomerPortalUser)
        {
            acs = 
            [
                select parent__r.label__c, name, label__c, LinkReference__c 
                from gBUILD_ApplicationConfig__c 
                where 
                    RecordTypeId=:PBS_gBUILD_Utility.appConfigRecordTypeIdLink and 
                    Parent__r.name=:Name and ForCustomerPortalUsers__c=true
                order by order__c, name
            ];
         }
         else
         {
            acs = 
            [
                select parent__r.label__c, name, label__c, LinkReference__c 
                from gBUILD_ApplicationConfig__c 
                where 
                    RecordTypeId=:PBS_gBUILD_Utility.appConfigRecordTypeIdLink and 
                    Parent__r.name=:Name and ForInternalUsers__c=true
                order by order__c, name
            ];         
         }
        
//        Title_p = string.format('My Title(name="{0}", cnt={1}, rt={2})', new string[]{Name, acs.size().format(), PBS_gBUILD_Utility.appConfigRecordTypeIdLink});
        Links_p = new List<Link>();
        for (gBUILD_ApplicationConfig__c ac : acs)
        {
            Link l = new Link();
            l.Text=ac.label__c;
            l.Reference=ac.LinkReference__c;
            Links_p.add(l);
            Title_p = ac.parent__r.label__c;
        }
    }
}