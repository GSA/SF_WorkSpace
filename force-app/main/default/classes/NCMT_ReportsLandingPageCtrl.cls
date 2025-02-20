public with sharing class NCMT_ReportsLandingPageCtrl {
	public class reportWrapper {
		@AuraEnabled public Report [] projectReports { get; set; }
		@AuraEnabled public Report [] lookupReports { get; set; }
		@AuraEnabled public Report [] regionReports { get; set; }
    		@AuraEnabled public Boolean levelFiveUser { get; set; }

	//	@AuraEnabled Report [] IrisReports { get; set; }



	}

	@AuraEnabled
	public static NCMT_Project__c getProjectInfo(string projectId) {
        System.debug('projectId === ' + projectId);
		NCMT_Project__c project = [select id, name, Estimate_Type_Proj__c from NCMT_Project__c where id = :projectId];
		return project;
	}
	@AuraEnabled
	public static reportWrapper getReports(string reportDesc) {
    system.debug('reportDesc' + reportDesc);
    reportWrapper report = new reportWrapper();
    if(reportDesc != null){
      report.projectReports = reportsQuery(reportDesc);
    }
    report.lookupReports = reportsQuery('NCMT LOOKUP');
    report.regionReports = reportsQuery('NCMT PROJECTS REGION');
    report.levelFiveUser = islevelFive();
		// if(projectType == 'Parametric - New Construction' || projectType == 'Parametric - Repair & Alteration    ') {
		//     reportDesc = 'NCMT REPORTS'
		// } else if(projectType == 'Definitive Estimating') {
		//     reportDesc = 'NCMT DES Reports';
		// }
		// 
		// // Added for debug purpose

        System.debug('Reports'+report);
  return report;
	}

	public static list<Report> reportsQuery(string reportDesc) {
		Report[] reports = [Select Name, IsDeleted, Id, Description From Report Where Description = :reportDesc and IsDeleted = false Order By Name];

        
		return reports;

	}
  public static Boolean islevelFive(){
  AggregateResult[] listCount = [select  count(Id) something FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name IN ('NCMT_Users_LVL4_CRE','NCMT_Users_LVL5_CRE') ];
  Integer count = (integer)listCount[0].get('something');
  system.debug('count' + count); 

  boolean islevelFive = (count > 0);
  system.debug('islevelFive' + islevelFive);
  return islevelFive;

  }
    
  // Added for SFWS-2239 #block 1
  @AuraEnabled
    public static Boolean isLightning(){
        String theme=UserInfo.getUiThemeDisplayed();
        system.debug('urlvalue'+theme);
        
        
        If(theme=='Theme2'||theme=='Theme3'){
            return false;
                }  else {
                  return   true;
                }
    }
  // End of code added for SFWS-2239 #block 1
}