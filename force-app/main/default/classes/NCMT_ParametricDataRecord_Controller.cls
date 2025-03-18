public with sharing class NCMT_ParametricDataRecord_Controller {
    

    public String projectName { get; set; }
    public String projectId { get; set;}
    
    public NCMT_ParametricDataRecord_Controller(ApexPages.StandardController controller) {
        if (controller == null) {
            throw new IllegalArgumentException('StandardController is null.');
        }
        Id recordId = controller.getId();

        // Validate the recordId
        if (recordId != null) {
            projectId = recordId;
        }
        else{
            projectId = ApexPages.currentPage().getParameters().get('ProjectId');
        }
        
        if(projectId == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No record ID in URL.'));
            return;
        }
        // Fetch the project record based on the projectId
        try {
            NCMT_Project__c project = [SELECT id, CUI_Header__c, Name FROM NCMT_Project__c WHERE Id = :projectId LIMIT 1];
            projectName = project.CUI_Header__c;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid or inaccessible projectId.'));
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static reportData getProjectData( string projectId){
        reportData response = new reportData();
        
        //system.debug('projectId==='+projectId);
        
        string strNCMTID = projectId.substring(0,projectId.length()-3); 
        
        response.ProjectDetails = [select id, Name,Basis_Date_Of_Estimate__c, Building_Type__c,Brief_Narrative__c, Building_Heigtht__c, Building_Quality__c, CreatedDate,
                                            CreatedBy.Name, GSA_Project__c, Level_of_Protection__c, Location__c, Location__r.State__c, Location__r.City__c, Project_type__c, 
                                            City__c, State__c, Project_Phases__c, Project_SubPhases__c,Regional_Portfolio__c, Regional_Portfolio__r.Name, Project_Status__c,Total_GSF__c,
                                            Project_Seismic_Design_Category__c, RegionCode__c , CUI_Header__c, Start_Construction__c, Location__r.Name,
                                            Building_Cost_Type__c,Gross_Area__c,Useable_Area__c,Housing_Plan__c,Entry_Type__c,Calculated_Site_Area__c,Override_Calculated_Site_Area__c,
                                            Estimate_Reviewed_By__r.Name,Estimate_Approved_By__r.Name, Requestor__c
                                    from NCMT_Project__c 
                                    where id= :projectId];
        if(string.isNotBlank(response.ProjectDetails.Estimate_Reviewed_By__r.Name)){
             response.Reviewed_By = response.ProjectDetails.Estimate_Reviewed_By__r.Name;
        }
        if(string.isNotBlank(response.ProjectDetails.Estimate_Approved_By__r.Name)){
            response.Approved_By = response.ProjectDetails.Estimate_Approved_By__r.Name;
        }
        response.PLPData= [select id, Name,Above_Ground__c,Below_Ground__c,Default_Above_Ground__c,Default_Below_Ground__c,Default_Foot_Print_Area__c,Foot_Print_Area__c,
                                  Basement_SF__c,Default_Basement_SF__c,Default_Elevated_Floor_Area_SF__c,Elevated_Floor_Area_SF__c,Default_Average_Story_Height__c,Average_Story_Height__c,
                                  Basement_Story_Height__c,Default_Basement_Story_Height__c,Structural_Frame__c,Average_Typical_Bay_Area__c,Dead_Load__c,Default_Dead_Load__c,Live_Load__c,
                                  Default_Live_Load__c,Default_Cladding_Type__c,Cladding_Type__c,Default_Cladding_Quality__c,Cladding_Quality__c,Cladding_Skin_Ratio__c,Default_Skin_Ratio__c,
                                  Default_Glazing_Ratio__c,Glazing_Ratio_of_above_grade_skin__c,Cladding_Skin_Ratio_SF__c,Default_Total_Wall_Area_SF__c,Cladding_Retaining_Wall_SF__c,Default_Retaining_Wall_SF__c,
                                  Finished_Opaque_Wall_SF__c,Default_Finished_Wall_Area_SF__c,Finished_Wall_Area_SF__c,Default_Glazing_SF__c,Glazing_Ratio_SF__c,Default_Finished_Opaque_Wall_SF__c,
                                  Total_Roof_Area_SF__c,Upper_Roof_SF__c,Basement_Roof_SF__c,Sloped_Roof_SF__c,Green_Roof_SF__c,Flat_Roof_SF__c,Roofing_Skylights__c,Default_Roofing_Skylights__c,
                                  Soil_Bearing_Strength__c,Site_Access__c,Site_Access_Cost_Impact__c,Site_Remoteness__c,SiteRemoteness_Cost_Impact__c,Other_Special_Condition_Specify__c,Cost_Impact_Percent__c,
                                  Freeze_Depth_Footing_Depth_BG__c,Default_Freeze_Depth_Footing_Depth__c,Default_Water_Table_Depth__c,Water_Table_Depth__c,Excavation_Percent_Shored_BG__c,
                                  Excavation_Percentage_Shored_BG__c,Int_Const_Core_Shell_Partition_ratio__c,Default_Core_Shell_Partition_Ratio__c,Default_Stairs_Flight__c,Use_Stairs_Flight__c,
                                  Def_Vertical_Conveyance_Elevators_Stops__c,Vertical_Conveyance_Escalators_PR__c,HVAC_Heating_Load_Mbtu__c,Default_Heating_Load_Mbtuh__c,HVAC_Cooling_Load_Tons__c,
                                  Default_Cooling_Load__c,HVAC_Air_Handling_Capacity_CFM__c,Default_AHU_Load__c,Electrical_Load_kW__c,Number_of_Stops__c,Default_Electrical_Load_Primary_kW__c,Panelboards__c,
                                  Fixtures_Utility_Water_Coolers__c,Default_Fixtures_Public_Restrooms__c,Use_Fixtures_Public_Restrooms__c,Cladding_Override_Comments__c,Interior_Override_Comments__c,Massing_Override_Comments__c,
                                  MEP_Override_Comments__c,Structure_Override_Comments__c,Skin_System_Override_Comments__c,Roof_System_Override_Comments__c,Vertical_Transportation_Override_Comment__c
                                from Project_Level_Parameter__c  
                                where  NCMT_Project__c = :projectId];
        response.bldgmassData = [select id, Name,Building_Massing_Area__c,Default_Area_SF__c,
                                         Default_Skylights_SF__c,Use_Area_SF__c,NCMT_Project_ID__c 
                                 from NCMT_Building_Massing_By_Floor__c
                                 where  NCMT_Project_ID__c = :projectId];
                                
        response.siteData = [select id, Name,Finished_Site__c
                                 from Site_Information__c
                                 where  Project__c = :projectId];
        response.hpData = [select id, Name,Light_Fixtures__c
                                 from NCMT_Housing_Plan_Summary__c
                                 where  Project__c = :projectId];
        /*response.coreShellData = [select id, Name,Total_Cost__c,NCMT_Project_ID__c 
                                 from NCMT_Core_Shell_Cost_Detail__c
                                 where  (NCMT_Project_ID__c = :projectId OR NCMT_Project_ID__c =:strNCMTID)
                                 and Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c IN ('CC19')];*/
        
        List<NCMT_Core_Shell_Cost_Detail__c> csdList = [select id, Name,Total_Cost__c,NCMT_Project_ID__c 
                                                         from NCMT_Core_Shell_Cost_Detail__c
                                                         where  (NCMT_Project_ID__c = :projectId OR NCMT_Project_ID__c =:strNCMTID)
                                                         and Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c IN ('CC19')];
        if (csdList.size() > 0){
            response.coreShellData = csdList[0];
        }
            
        
        System.debug(response.coreShellData.Total_Cost__c);                         
        if(response.coreShellData.Total_Cost__c > 0){
            response.foundations = 'Special';
        }else{
            response.foundations = 'Spread';
        }
        
        return response;
        
    }
    
    public class reportData{
        @AuraEnabled public NCMT_Project__c ProjectDetails{get;set;}
        @AuraEnabled public Project_Level_Parameter__c PLPData{get;set;}
        @AuraEnabled public Site_Information__c siteData{get;set;}
        @AuraEnabled public NCMT_Housing_Plan_Summary__c hpData{get;set;}
        @AuraEnabled public NCMT_Core_Shell_Cost_Detail__c coreShellData{get;set;}
        @auraenabled public string Reviewed_By{get;set;}
        @auraenabled public string Approved_By{get;set;}
        @auraenabled public string foundations{get;set;}
        @AuraEnabled public List<NCMT_Building_Massing_By_Floor__c> bldgmassData{get;set;} 
        public reportData(){
            this.Reviewed_By ='';
            this.Approved_By ='';
            this.foundations='';
            this.ProjectDetails=new NCMT_Project__c();
            this.PLPData=new Project_Level_Parameter__c();
            this.siteData=new Site_Information__c();
            this.hpData=new NCMT_Housing_Plan_Summary__c();
            this.coreShellData=new NCMT_Core_Shell_Cost_Detail__c();
            this.bldgmassData=new List<NCMT_Building_Massing_By_Floor__c>();
        }
    }
    
}