@isTest(seeAllData = True)
public with sharing class NCMT_TestProjectRedirectExtnClass {
    
    List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');

    @isTest static void CreateProjectInitialSetup(){ 
       Date CostParaDate = date.newinstance(2016, 10, 1);
        
        List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');

        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                                                            and State__c = 'Virginia' and Name = 'State Average'];        
              
        NCMT_Project__c Proj = new NCMT_Project__c ();
                        
        Proj.Project_type__c = 'New Construction';
        Proj.Building_Type__c = 'Office';
        Proj.Estimate_Type_Proj__c  = 'Parametric';
        Proj.Purpose_of_Estimate__c = 'Project Controls';
        Proj.Building_Selection__c = 'New';
        Proj.Name = 'testProjCodeCovRAOff123';
        Proj.State__c = 'Virginia';
        Proj.City__c = 'State Average'; 
        Proj.Purpose_of_Estimate__c = 'Scenario Planning';
        
        Proj.Location__c = objlocation.Id;
        
        Date ConstDate = date.newinstance(2019, 1, 1);
        Date EndConstDate = date.newinstance(2020, 10, 1);
        Proj.Start_Construction__c = ConstDate;
        Proj.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj.Building_Quality__c = 'P100: Baseline';        
        Proj.Level_of_Protection__c = 'Level II - Low';
        Proj.Remoteness__c = 'Urban';
        Proj.Gross_Area__c = false;
        Proj.Useable_Area__c = false;
        Proj.Housing_Plan__c = true;
        Proj.Project_Status__c = 'Draft';
        Proj.Cost_Parameter_Date__c = CostParaDate;
        
        insert Proj;
        system.assertNotEquals(NULL,Proj);
        
        PageReference pageRef = Page.NCMT_Initial_Project_Setup_Page;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Project Type', '\'New Construction\',\'Repair & Alteration - Parametric Entry\',\'Repair & Alteration - Work Item Detail\'');
        ApexPages.currentPage().getParameters().put('Building Type', '\'Office\',\'Childcare Center\',\'Medical Office\',\'Medical Clinic\'');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Proj);       
        NCMT_Project_RedirectExtension NCMTProjextn = new NCMT_Project_RedirectExtension(sc);
        NCMTProjextn.temp = Proj;
        NCMTProjextn.redirect();
        
        NCMT_Project__c Proj1 = new NCMT_Project__c ();
        
        Proj1.Project_type__c = 'Repair & Alteration - Parametric Entry';
        proj1.Building_type__c = 'Office';
        Proj1.Estimate_Type_Proj__c  = 'Parametric - Repair & Alteration';
        //Proj1.Project_Phases__c ='Design';
        //Proj1.Project_SubPhases__c='Preliminary Concept';
        Proj1.Purpose_of_Estimate__c = 'Project Controls';
        Proj1.Name = 'testProjCodeCovRAOff1234';
        Proj1.State__c = 'Virginia';
        Proj1.City__c = 'State Average';
        Proj1.Building_Selection__c = 'Existing'; 
        Proj1.Purpose_of_Estimate__c = 'Scenario Planning';   
        
        Proj1.Location__c = objlocation.Id;
        
        Date ConstDate1 = date.newinstance(2019, 1, 1);
        Date EndConstDate1 = date.newinstance(2020, 10, 1);
        Proj1.Start_Construction__c = ConstDate1;
        Proj1.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj1.Building_Quality__c = 'P100: Baseline';        
        Proj1.Level_of_Protection__c = 'Level II - Low';
        Proj1.Remoteness__c = 'Urban';
        Proj1.Project_Status__c = 'Draft';
        Proj1.Cost_Parameter_Date__c = CostParaDate;
        Proj1.Dominant_Period__c = '1940 - 1949';
        Proj1.Historic_Landmark_Status__c = 'Class 2';
        Proj1.Overall_Condition__c = 'Good';
        Proj1.RA_Estimate_Type__c ='Parametric Entry';
        Proj1.Housing_Plan__c = true;
        Proj1.RA_Security__c = 'Minimum upgrade to existing'; 
        Proj1.Gross_Area_Including_Parking__c = 100000;
        Proj1.Affected_Tenant_Area_USF__c = 10000;
        Proj1.Total_Site_Area_Building_Footprint_SF__c = 200000;
        insert Proj1;
        system.assertNotEquals(NULL,Proj1);        
        NCMTProjextn.temp = Proj1;
        NCMTProjextn.redirect();
        
        NCMT_Project__c Proj2 = new NCMT_Project__c ();
        
        Proj2.Project_type__c = 'Repair & Alteration - Work Item Detail';
        proj2.Building_type__c = 'Office';
        Proj2.Estimate_Type_Proj__c  = 'Work Item - Repair & Alteration';
        //Proj2.Project_Phases__c ='Design';
        //Proj2.Project_SubPhases__c='Preliminary Concept';
        Proj2.Purpose_of_Estimate__c = 'Project Controls';
        Proj2.Name = 'testProjCodeCovRAOff12345';
        Proj2.State__c = 'Virginia';
        Proj2.City__c = 'State Average'; 
        Proj2.Building_Selection__c = 'Existing';   
        Proj2.Purpose_of_Estimate__c = 'Scenario Planning';  
        
        Proj2.Location__c = objlocation.Id;
        
        Date ConstDate2 = date.newinstance(2019, 1, 1);
        Date EndConstDate2 = date.newinstance(2020, 10, 1);
        Proj2.Start_Construction__c = ConstDate2;
        Proj2.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj2.Building_Quality__c = 'P100: Baseline';        
        Proj2.Level_of_Protection__c = 'Level II - Low';
        Proj2.Remoteness__c = 'Urban';
        Proj2.Project_Status__c = 'Draft';
        Proj2.Cost_Parameter_Date__c = CostParaDate;
        Proj2.Dominant_Period__c = '1940 - 1949';
        Proj2.Historic_Landmark_Status__c = 'Class 2';
        Proj2.Overall_Condition__c = 'Good';
        Proj2.RA_Estimate_Type__c ='Parametric Entry';
        Proj2.Housing_Plan__c = true;
        Proj2.Gross_Area_Including_Parking__c = 100000;
        Proj2.Affected_Tenant_Area_USF__c = 10000;
        Proj2.Total_Site_Area_Building_Footprint_SF__c = 200000;
        insert Proj2;
        system.assertNotEquals(NULL,Proj2);        
        NCMTProjextn.temp = Proj2;
        NCMTProjextn.redirect();
        
        NCMT_Project__c Proj3 = new NCMT_Project__c ();
        
        Proj3.Project_type__c = 'New Construction';
        proj3.Building_type__c = 'Childcare Center';
        Proj3.Estimate_Type_Proj__c  = 'Parametric';
        //Proj3.Project_Phases__c ='Design';
        //Proj3.Project_SubPhases__c='Preliminary Concept';
        Proj3.Purpose_of_Estimate__c = 'Project Controls';
        Proj3.Building_Selection__c = 'New';
        Proj3.Name = 'testProjCodeCovRAOff123456';
        Proj3.State__c = 'Virginia';
        Proj3.City__c = 'State Average';   
        Proj3.Purpose_of_Estimate__c = 'Scenario Planning'; 
        
        Proj3.Location__c = objlocation.Id;
        
        Date ConstDate3 = date.newinstance(2019, 1, 1);
        Proj3.Start_Construction__c = ConstDate3;
        Proj3.Remoteness__c = 'Urban';
        Proj3.Project_Status__c = 'Draft';
        Proj3.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj3.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj3.Building_Quality__c = 'P100: Baseline';        
        Proj3.Level_of_Protection__c = 'Level II - Low';
        Proj3.Cost_Parameter_Date__c = CostParaDate;
        Proj3.Gross_Area__c = false;
        Proj3.Useable_Area__c = false;
        Proj3.Housing_Plan__c = true;
        
        insert Proj3;
        system.assertNotEquals(NULL,Proj3); 
        
            NCMTProjextn.temp = Proj3;
            NCMTProjextn.redirect();
        
        
        NCMT_Project__c Proj4 = new NCMT_Project__c ();
        
        Proj4.Project_type__c = 'New Construction';
        proj4.Building_type__c = 'Medical Office';
        Proj4.Estimate_Type_Proj__c  = 'Parametric';
        Proj4.Purpose_of_Estimate__c = 'Project Controls';
        Proj4.Building_Selection__c = 'New';
        Proj4.Name = 'testProjCodeCovRAOff1234567';
        Proj4.State__c = 'Virginia';
        Proj4.City__c = 'State Average';
        Proj4.Purpose_of_Estimate__c = 'Scenario Planning';    
        
        Proj4.Location__c = objlocation.Id;
        
        Date ConstDate4 = date.newinstance(2019, 1, 1);
        Proj4.Start_Construction__c = ConstDate4;
        Proj4.Remoteness__c = 'Urban';
        Proj4.Project_Status__c = 'Draft';
        Proj4.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj4.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj4.Building_Quality__c = 'P100: Baseline';        
        Proj4.Level_of_Protection__c = 'Level II - Low';
        Proj4.Cost_Parameter_Date__c = CostParaDate;
        Proj4.Gross_Area__c = false;
        Proj4.Useable_Area__c = false;
        Proj4.Housing_Plan__c = true;
        
        insert Proj4;
        system.assertNotEquals(NULL,Proj4);  
        
            NCMTProjextn.temp = Proj4;
      
      // Code Block#1 commented out and added for SFWS-2234 
       
      //            NCMTProjextn.redirect();
                    NCMTProjextn.lightningRedirect();
      
      //      End of Code Block#1 for SFWS-2234 
                
        
        
       
    }
    
    @isTest static void CreateProjectDESCEWInitialSetup(){ 
        Date CostParaDate = date.newinstance(2016, 10, 1);
        
        List <NCMT_Location_Parameters__c> lstlocation = Test.loadData(NCMT_Location_Parameters__c.sObjectType, 'NCMT_Location_Parameter');

        NCMT_Location_Parameters__c objlocation = [select Id from NCMT_Location_Parameters__c where id in :lstlocation 
                                                                                            and State__c = 'Virginia' and Name = 'State Average'];        
              
    
        
        NCMT_Project__c Proj6 = new NCMT_Project__c ();
        
        Proj6.Project_type__c = 'New Construction - CEW';
        proj6.Building_type__c = 'Office';
        Proj6.Estimate_Type_Proj__c  = 'Cost Estimating Workbook';
        Proj6.Project_Phases__c ='Design';
        Proj6.Project_SubPhases__c='Design Development Draft';
        Proj6.Purpose_of_Estimate__c = 'Project Controls';
        Proj6.Project_Status__c= 'Draft';
        Proj6.Name = 'testProjCodeCov123-CEW';
        Proj6.State__c = 'Virginia';
        Proj6.City__c = 'State Average';   
        
        Proj6.Location__c = objlocation.Id;
        
        Date ConstDate6 = date.newinstance(2021, 1, 1);
        Proj6.Mid_Point_of_Construction__c= ConstDate6;
        Proj6.Start_Construction__c = ConstDate6;
        Proj6.Project_Status__c = 'Draft';
        Proj6.Cost_Parameter_Date__c = CostParaDate;
        Proj6.Project_Area_GSF__c = 100000;
        Proj6.CEW_Project_Funding_Source__c = 'RWA';
        
        insert Proj6;
        system.assertNotEquals(NULL,Proj6);  
        
        PageReference pageRef = Page.NCMT_Initial_Project_Setup_Page;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Project Type', '\'New Construction - CEW\',\'Repair & Alteration - CEW\'');
        ApexPages.currentPage().getParameters().put('Building Type', '\'Office\',\'Childcare Center\',\'Medical Office\',\'Medical Clinic\'');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Proj6);       
        NCMT_Project_RedirectExtension NCMTProjextn = new NCMT_Project_RedirectExtension(sc);
        NCMTProjextn.temp = Proj6;
        NCMTProjextn.redirect();
        
        NCMT_Project__c Proj7 = new NCMT_Project__c ();
        
        Proj7.Project_type__c = 'Repair & Alteration - CEW';
        proj7.Building_type__c = 'Office';
        Proj7.Estimate_Type_Proj__c  = 'Cost Estimating Workbook';
        Proj7.Project_Phases__c ='Design';
        Proj7.Project_SubPhases__c='Design Development Draft';
        Proj7.Purpose_of_Estimate__c = 'Project Controls';
        Proj7.Project_Status__c= 'Draft';
        Proj7.Name = 'testProjCodeCov1237-CEW';
        Proj7.State__c = 'Virginia';
        Proj7.City__c = 'State Average';   
        
        Proj7.Location__c = objlocation.Id;
        
        Date ConstDate7 = date.newinstance(2021, 1, 1);
        Proj7.Mid_Point_of_Construction__c= ConstDate7;
        Proj7.Start_Construction__c = ConstDate7;
        Proj7.Project_Status__c = 'Draft';
        Proj7.Cost_Parameter_Date__c = CostParaDate;
        Proj7.Project_Area_GSF__c = 100000;
        Proj7.CEW_Project_Funding_Source__c = 'RWA';
        Proj7.CEW_Occupancy_Status__c = 'Fully Vacated Building';
        
        insert Proj7;
        system.assertNotEquals(NULL,Proj7);  
        
        NCMTProjextn.temp = Proj7;
        NCMTProjextn.redirect();
        
        NCMT_Project__c Proj8 = new NCMT_Project__c ();
        
        Proj8.Project_type__c = 'New Construction - DES';
        Proj8.Building_type__c = 'Office';
        Proj8.Estimate_Type_Proj__c  = 'Definitive Estimating';
        Proj8.Project_Phases__c ='Design';
        Proj8.Project_SubPhases__c='Design Development Draft';
        Proj8.Purpose_of_Estimate__c = 'Project Controls';
        Proj8.Project_Status__c= 'Draft';
        Proj8.Name = 'testProjCodeCov123-DES';
        Proj8.State__c = 'Virginia';
        Proj8.City__c = 'State Average';   
        
        Proj8.Location__c = objlocation.Id;
        
        Date ConstDate8 = date.newinstance(2021, 1, 1);
        Proj8.Mid_Point_of_Construction__c= ConstDate8;
        Proj8.Start_Construction__c = ConstDate8;
        Proj8.Project_Delivery_Method__c= 'Design-Bid-Build';
        Proj8.Remoteness__c = 'Urban';
        Proj8.Project_Status__c = 'Draft';
        Proj8.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj8.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj8.Building_Quality__c = 'P100: Baseline';        
        Proj8.Level_of_Protection__c = 'Level II - Low';
        Proj8.Cost_Parameter_Date__c = CostParaDate;
        Proj8.Gross_Area__c = false;
        Proj8.Useable_Area__c = false;
        Proj8.Housing_Plan__c = true;
        
        insert Proj8;
        system.assertNotEquals(NULL,Proj8);        
        NCMTProjextn.temp = Proj8;
        NCMTProjextn.redirect();
        
        NCMT_Project__c Proj9 = new NCMT_Project__c ();
        
        Proj9.Project_type__c = 'Repair & Alteration - DES';
        Proj9.Building_type__c = 'Office';
        Proj9.Estimate_Type_Proj__c  = 'Definitive Estimating';
        Proj9.Project_Phases__c ='Design';
        Proj9.Project_SubPhases__c='Design Development Draft';
        Proj9.Purpose_of_Estimate__c = 'Project Controls';
        Proj9.Project_Status__c= 'Draft';
        Proj9.Name = 'testProjCodeCov123-DES';
        Proj9.State__c = 'Virginia';
        Proj9.City__c = 'State Average';   
        
        Proj9.Location__c = objlocation.Id;
        
        Date ConstDate9 = date.newinstance(2021, 1, 1);
        Proj9.Mid_Point_of_Construction__c= ConstDate9;
        Proj9.Start_Construction__c = ConstDate9;
        Proj9.Project_Delivery_Method__c= 'Design-Bid-Build';
        Proj9.Remoteness__c = 'Urban';
        Proj9.Project_Status__c = 'Draft';
        Proj9.Building_Cost_Type__c = 'Core/Shell with TI';
        Proj9.Building_Heigtht__c = 'Lowrise (2 - 3 stories)';
        Proj9.Building_Quality__c = 'P100: Baseline';        
        Proj9.Level_of_Protection__c = 'Level II - Low';
        Proj9.Cost_Parameter_Date__c = CostParaDate;
        Proj9.Gross_Area__c = false;
        Proj9.Useable_Area__c = false;
        Proj9.Housing_Plan__c = true;
        
        insert Proj9;
        system.assertNotEquals(NULL,Proj9);        
        NCMTProjextn.temp = Proj9;
        NCMTProjextn.redirect();
    }
}