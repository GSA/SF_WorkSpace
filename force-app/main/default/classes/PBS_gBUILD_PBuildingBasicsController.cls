public with sharing class PBS_gBUILD_PBuildingBasicsController extends PBS_gBUILD_ProjectIdBaseController
{
    public string uploadCatalog { get { return PBS_gBUILD_Utility.epmCatalogExecution; } }
    public PBS_gBUILD_Utility.LinkedObjectFieldInfo buildingNameLink { get; private set; }
    public PBS_Building__c b { get; private set; }
    public PBS_BuildingProjectAssociation__c[] projectAssociations { get; private set; }
    public PBS_gBUILD_ProjectBuilding__c projectBuilding { get; private set; }
    public string actionId { get; set; }    
    public string mapEmbedUrl { get; private set; }
    public string mapLinkUrl { get; private set; }
    public string mapQuestLinkUrl{get;private set;}//added by Ramesh
    public string mapYahooLinkUrl{get; private set;}//added by Ramesh
    public boolean renderMap { get; private set; }
    public boolean renderAddress { get; private set; }
        
    public PBS_gBUILD_PBuildingBasicsController()
    {
        super('Building Basics', true);
        renderAddress = false;
        renderMap = false;
        try
        {        
            super.bind();
            projectBuilding = PBS_gBUILD_Utility.loadProjectBuilding(pbuildingid);
            b=null;
            List<PBS_Building__c >lstBuildPro=null;
             lstBuildPro= [
                select
                    Building_ID__c,
                    Building_Name__c,
                    Facility_Id__c,
                    Street_Address__c,
                    Address2__c,
                    State_Code__c,
                    Zip_Code__c,
                    Region_Code__c,
                    Building_RSF__c,
                    Building_RU__c,
                    Building_USF__c,
                    Building_GSF__c,
                    City__c,
                    Construct_Complete_Date__c,
                    Field_Office_Code__c,
                    Location_Code_Plus__c,
                    LATITUDE__C,
                    LONGITUDE__C
                from PBS_Building__c
                where id=:pbsBuildingId
                ];
                
                if(lstBuildPro.size()>0)
                {
                    b=lstBuildPro.get(0);
                    buildingNameLink = new PBS_gBUILD_Utility.LinkedObjectFieldInfo(Schema.sObjectType.PBS_Building__c.fields.Building_Name__c, b.id, b.Building_Name__c);                                
                    PageReference pr = new PageReference('https://maps.google.com/maps');
                    PageReference mq = new PageReference('https://www.mapquest.com');
                    PageReference yh = new PageReference('https://maps.yahoo.com/search/');
                    Map<string, string> params = pr.getParameters();
                    Map<string, string> mapqparams = mq.getParameters();
                    Map<string, string> yhparams = yh.getParameters();

                    params.put('z', '15');
                    mapqparams.put('z', '15');


                    if (
                        b.Street_Address__c!=null && b.Street_Address__c.length()>0 &&
                        b.City__c!=null && b.City__c.length()>0 &&
                        b.State_Code__c!=null && b.State_Code__c.length()>0)
                    {
                        params.put('q', string.format(
                            '{0} {1};{2}, {3}',
                            new string[]{ b.Street_Address__c, b.Address2__c==null?'':b.Address2__c, b.City__c, b.State_Code__c}));                        
                        
                        mapqparams.put('q', string.format(
                            '{0} {1};{2}, {3}',
                            new string[]{ b.Street_Address__c, b.Address2__c==null?'':b.Address2__c, b.City__c, b.State_Code__c}));                        

                        yhparams.put('p', string.format(
                            '{0} {1};{2}, {3}',
                            new string[]{ b.Street_Address__c, b.Address2__c==null?'':b.Address2__c, b.City__c, b.State_Code__c}));                        

                    }
                    else if (
                        b.LATITUDE__C!=null && b.LATITUDE__C!=0 &&
                        b.LONGITUDE__C!=null && b.LONGITUDE__C!=0                    
                    )
                    {
                        renderAddress = true;
                        params.put('q', string.format(
                            '{0}, {1}',
                            new string[]{ string.valueOf(b.LATITUDE__c), string.valueOf(b.LONGITUDE__c)}));                                            
                        
                        mapqparams.put('q', string.format(
                            '{0}, {1}',
                            new string[]{ string.valueOf(b.LATITUDE__c), string.valueOf(b.LONGITUDE__c)}));                                            
                        
                         yhparams.put('p', string.format(
                            '{0}, {1}',
                            new string[]{ string.valueOf(b.LATITUDE__c), string.valueOf(b.LONGITUDE__c)}));

                    }
                    else
                    {
                        renderAddress = true;
                        params = null;
                        mapqparams=null;
                        yhparams = null;
                    }
                    if (params!=null || mapqparams!=null || yhparams!=null)
                    {
                        mapLinkUrl = pr.getUrl();
                        mapQuestLinkUrl = mq.getUrl();
                        mapYahooLinkUrl = yh.getUrl();
                        params.put('output', 'embed');
                        mapEmbedUrl = pr.getUrl();
                        renderMap = true;
                    }
                }
    
            projectAssociations = 
            [
                select rluProject__r.id, rluProject__r.name, rluProject__r.txtLongName__c, rluProject__r.txtCreatedIn__c, rluProject__r.txtCurrentState__c
                from PBS_BuildingProjectAssociation__c
                where 
                    rluBuilding__c=:pbsBuildingId and
                    rluProject__c<>null
            ];
        }
        catch (Exception ex)
        {            
            handleConstructorError(ex);
        }            
    }   

    public PageReference openProject()
    {
        return new PageReference('/'+actionId);
    }
}