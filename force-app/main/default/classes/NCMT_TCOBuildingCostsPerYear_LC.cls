public with sharing class NCMT_TCOBuildingCostsPerYear_LC {
    public NCMT_TCOBuildingCostsPerYear_LC(ApexPages.StandardController controller) {

    }


    @AuraEnabled(cacheable=true)
    public static NCMT_TCO_Project projectData(String projId){
        return new NCMT_TCO_Project(projId, true);
    }

    
}