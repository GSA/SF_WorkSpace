@isTest
public class NCMT_TestClass {

    static testmethod void OfficeProject1() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff1','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, true);
        
    }

    static testmethod void OfficeProject201() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff2','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, true, false, true);
        
    }   
    
    /*
    static testmethod void OfficeProject2() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff123','Office','Missouri','Cape Girardeau','Core/Shell with TI'
                                        ,'Single Story','P100: Monumental','Level II - Low','Urban', false, true, false, false, 100000, 10, 0, 0, false, true, false, false, false, false, false);
        
    }
    */
    static testmethod void OfficeProject3() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff3','Office','Illinois','Alton','TI Only'
                                        ,'Single Story','P100: Landmark','Level II - Low','Urban', false, true, false, false, 70000, 0, 0, 0, false, true, false, false, false, false, false);
        
    }

    static testmethod void OfficeProject4() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff4','Office','South Dakota','Aberdeen','TI Including Warm Lit Shell'
                                        ,'Lowrise (2 - 3 stories)','Code Minimum','Level II - Low','Urban', false, true, false, false, 1000000, 0, 0, 0, false, false, false, false, true, false, false);
        
    }
    
    static testmethod void OfficeProject5() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff5','Office','California','State Average','TI Retrofit'
                                        ,'Lowrise (2 - 3 stories)','Class A','Level II - Low','Urban', false, true, false, false, 1000000, 0, 0, 0, false, false, false, false, true, false, true);
        
    }

    static testmethod void OfficeProject6() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff6','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level II - Low','Urban', true, false, false, false, 30000, 0, 1, 0, false, false, false, false, false, false, false);
        
    }   

    static testmethod void OfficeProject7() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff7','Office','Virginia','State Average','Core/Shell only'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
        
    }   

    static testmethod void OfficeProject8() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff8','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, true, false, false, false);
        
    }
    
    static testmethod void OfficeProject81() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff9','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level III - Medium','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, true, false, false, false);
        
    }

    static testmethod void OfficeProject82() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff10','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level IV - High','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, true, false, false, false);
        
    }
    static testmethod void OfficeProject83() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff11','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level V - Very High','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, true, false, false, false);
        
    }   

    static testmethod void OfficeProject9() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff12','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, true, false, false, false, false, false, false);
        
    }
    
    static testmethod void OfficeProject10() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff13','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level I - Minimum','Central Business District', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, true, false, false);
        
    }   

    static testmethod void OfficeProject101() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff14','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level II - Low','Central Business District', true, false, false, false, 1000000, 0, 10, 20, false, false, false, false, true, false, false);
        
    }

    static testmethod void OfficeProject102() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff15','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level III - Medium','Central Business District', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, true, false, false);
        
    }

    static testmethod void OfficeProject103() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff16','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level IV - High','Central Business District', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, true, false, false);
        
    }
    
    static testmethod void OfficeProject104() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff17','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level V - Very High','Central Business District', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, true, false, false);
        
    }

    static testmethod void OfficeProject105() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff18','Office','District of Columbia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, true, false, false);
        
    }
    
/*Too many SOQL queries error   
    static testmethod void OfficeProject11() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff123','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, true, false, false, true, false, false, false);
        
    }
*/
    static testmethod void OfficeProject12() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff19','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, true, false, false, false);
        
    }
    /*
    static testmethod void OfficeProject13() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff123','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Midrise (4 - 9 stories)','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   
    */
    static testmethod void OfficeProject14() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff20','Office','Missouri','Cape Girardeau','Core/Shell with TI'
                                        ,'Single Story','P100: Monumental','Level II - Low','Urban', false, true, false, false, 1000000, 10, 0, 0, false, false, false, false, false, true, false);
        
    }

    static testmethod void OfficeProject15() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff21','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, true, false, false, false);
        
    }   

    static testmethod void OfficeProject16() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff22','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
        
    }       

    static testmethod void OfficeProject17() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff23','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level III - Medium','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
        
    }
    
    static testmethod void OfficeProject18() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff24','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level IV - High','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
        
    }
    
    static testmethod void OfficeProject19() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff25','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level V - Very High','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
        
    }

    static testmethod void OfficeProject20() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff26','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level I - Minimum','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, true, false, false, false, false);
        
    }
                                        
    static testmethod void OfficeCustomHPProject1() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP1','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, true, 100000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
 /*Too many SOQL queries error  
    static testmethod void OfficeCustomHPProject2() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP3','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Single Story','P100: Baseline','Level V - Very High','Urban', false, false, true, false, 120000, 0, 0, 0, false, false, false, false, false, false);
        
    }           
*/  

    static testmethod void OfficeCustomHPProject3() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP3','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
    
    static testmethod void OfficeCustomHPProject4() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP4','Office','Virginia','State Average','TI Including Warm Lit Shell'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, false, 140000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }               

    static testmethod void OfficeCustomHPProject5() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP5','Office','Virginia','State Average','TI Retrofit'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, false, 150000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }               
    
    static testmethod void OfficeCustomHPProject6() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP6','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','Class A','Level II - Low','Central Business District', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
        
    static testmethod void OfficeCustomHPProject7() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP7','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','Class A','Level I - Minimum','Suburban', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   

    static testmethod void OfficeCustomHPProject8() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP8','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','Class A','Level III - Medium','Rural', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   

    static testmethod void OfficeCustomHPProject9() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP9','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','Class A','Level IV - High','Remote', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   
    
    static testmethod void OfficeCustomHPProject10() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP10','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','Class A','Level V - Very High','Very Remote', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   
    
    static testmethod void OfficeCustomHPProject11() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP11','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','Class A','Level II - Low','Urban', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
    
    static testmethod void OfficeCustomHPProject12() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP12','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','Class A','Level II - Low','Urban', false, false, true, true, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   
    
    static testmethod void OfficeCustomHPProject13() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP13','Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   
    
    static testmethod void OfficeCustomHPProject14() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP14','Office','Virginia','State Average','TI Retrofit'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   

    static testmethod void OfficeCustomHPProject15() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP15','Office','Virginia','State Average','TI Only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', false, false, true, false, 130000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }       
    
    static testmethod void OfficeCustomHPProject16() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP16','Office','Virginia','State Average','Core/Shell only'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level II - Low','Urban', false, false, true, true, 100000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
    
    static testmethod void OfficeCustomHPProject17() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovCustomHP17','Office','Virginia','State Average','Core/Shell only'
                                        ,'Midrise (4 - 9 stories)','P100: Baseline','Level II - Low','Urban', false, false, true, true, 0, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
 /*Too many SOQL queries error  
    static testmethod void OfficeCustomHPProject18() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovOff123','Office','Virginia','State Average','Core/Shell with TI'
                                        ,'Lowrise (2 - 3 stories)','P100: Baseline','Level II - Low','Urban', false, false, true, true, 0, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   
*/          
    static testmethod void CourthouseProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovCO1','Courthouse','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 100000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
    
    static testmethod void LaboratoryDryProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovLD1','Laboratory: Dry','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 100000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
    
    static testmethod void LaboratoryWetProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovLW1','Laboratory: Wet','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 100000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
    //Your runAllTests request is using too many DB resources. only in validate of changeset
    static testmethod void AUtilityProject1() {
        NCMT_TestDataClass.CreateProject('New Construction', 'testProjCodeCovUT1','Utility','Virginia','State Average','Core/Shell only'
                                        ,'1 story, high bay, light structure','P100: Baseline','Level I - Minimum','Urban', true, false, false, false, 10000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
    
    static testmethod void ChildcareProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCC1','Childcare Center','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 3000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }
        
    static testmethod void ParkingProject1() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG1', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',
                                                    3000, 1, 0, false);
    }
    /*
    static testmethod void ParkingProject2() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG2', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',
                                                    3000, 2, 0, false);
    }
    
    static testmethod void ParkingProject3() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG3', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',
                                                    100, 2, 0, false);
    }
    */
    static testmethod void ParkingProject4() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG4', 'Virginia','State Average', 'Urban', 
                                                    'Parking Deck', 'Speed Ramp', 'Medium Efficiency', 'Medium',
                                                    100, 2, 0, false);
    }
    
    static testmethod void ParkingProject5() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG5', 'Virginia','State Average', 'Urban', 
                                                    'Below Grade Structure', 'Sloped Parking Deck', 'Low Efficiency', 'High',
                                                    100, 0, 2, false);
    }
    
    static testmethod void ParkingProject6() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG6', 'Virginia','State Average', 'Urban', 
                                                    'Below Grade Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',
                                                    100, 0, 2, false);
    }
    
    static testmethod void ParkingProject7() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG7', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Low Efficiency', 'High',
                                                    50, 1, 0, false);
    }
    /*Your runAllTests request is using too many DB resources. only in validate of changeset
    static testmethod void ParkingProject8() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG8', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Low Efficiency', 'High',
                                                    250, 1, 0, false);
    }   
    
    static testmethod void ParkingProject9() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG9', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Low Efficiency', 'Medium',
                                                    200, 2, 0, false);
    }   
    */
    static testmethod void ParkingProject10() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG10', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Low Efficiency', 'Medium',
                                                    1000, 2, 0, false);
    }   
    
    static testmethod void ParkingProject11() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG11', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Low Efficiency', 'Medium',
                                                    540, 2, 0, true);
    }
    
    static testmethod void ParkingProject12() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG12', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',
                                                    3000, 4, 0, false);
    }
    
    static testmethod void ParkingProject13() {        
        NCMT_TestDataClass.CreateParkingGarageProject('testProjCodePG13', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',
                                                    3000, 11, 1, false);
    }   

    static testmethod void ParkingProjectUpdate1() {        
        NCMT_TestDataClass.UpdateParkingGarageProject('testProjCodeUpdatePG1', 'Virginia','State Average', 'Urban', 
                                                    'Parking Structure', 'Sloped Parking Deck', 'Optimized for Parking', 'Utilitarian',
                                                    3000, 1, 0, false);
    }

    static testmethod void ParkingProjectUpdate2() {        
        NCMT_TestDataClass.UpdateParkingGarageProject('testProjCodeUpdatePG2', 'Virginia','State Average', 'Urban', 
                                                    'Parking Deck', 'Speed Ramp', 'Medium Efficiency', 'Medium',
                                                    100, 2, 0, false);
    }
    
    static testmethod void ParkingProjectUpdate3() {        
        NCMT_TestDataClass.UpdateParkingGarageProject('testProjCodeUpdatePG3', 'Virginia','State Average', 'Urban', 
                                                    'Below Grade Structure', 'Sloped Parking Deck', 'Low Efficiency', 'High',
                                                    100, 0, 2, false);
    }
    
    static testmethod void MedicalClinicProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovMC1','Medical Clinic','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }       

    static testmethod void MedicalOfficeProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovMO1','Medical Office','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   
    
    static testmethod void DataCenterProject1() {
        NCMT_TestDataClass.CreateProject('New Construction','testProjCodeCovDC1','Data Center','Virginia','State Average','Core/Shell only'
                                        ,'Single Story','P100: Baseline','Level II - Low','Urban', true, false, false, false, 1000000, 0, 0, 0, false, false, false, false, false, false, false);
        
    }   
            
    static testmethod void AProfServEst() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst1', 'Virginia','State Average', 150000, 60000, 
                                                'Federal Office Building', 'New Construction', 'Design-Bid-Build', 'CM as Agent',
                                                '','','','','');
    }
        
    static testmethod void AProfServEst2() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst2', 'Virginia','State Average', 60000, 26000000, 
                                                'Federal Office Building', 'New Construction', 'Design Build - Owned', 'Design-Build CM',
                                                '','Low','Low','','');
    }
    
    static testmethod void AProfServEst3() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst3', 'Virginia','State Average', 270000, 270000000, 
                                                'Courthouse', 'New Construction', 'Design Build - Leased', 'Developer CM',
                                                'Build to Suit','','','','');
    }   
    //Your runAllTests request is using too many DB resources. only in validate of changeset
    
    static testmethod void AProfServEst4() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst4', 'Virginia','State Average', 20000, 120000000, 
                                                'Courthouse', 'New Construction', 'Design Build - Leased', 'Developer CM',
                                                'Tenant Fit-out w/ no Redesign','','','','');
    }
    
    static testmethod void AProfServEst5() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst5', 'Virginia','State Average', 0, 0, 
                                                'Childcare Center', 'New Construction', 'Design Build - Leased', 'Developer CM',
                                                'Tenant Fit-out w/ no Redesign','','','','');
    }   
        
    static testmethod void AProfServEstRA() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst6', 'Virginia','State Average', 150000, 60000, 
                                                'Federal Office Building', 'Repair & Alteration', 'Design-Bid-Build', 'CM as Agent',
                                                '','','','Limited Scope','1');
    }
        
    static testmethod void AProfServEstRA2() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst7', 'Virginia','State Average', 60000, 26000000, 
                                                'Federal Office Building', 'Repair & Alteration', 'Design Build - Owned', 'Design-Build CM',
                                                '','Low','Low','Distributed Scope','2');
    }
    
    static testmethod void AProfServEstRA3() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst8', 'Virginia','State Average', 270000, 270000000, 
                                                'Courthouse', 'Repair & Alteration', 'Design Build - Leased', 'Developer CM',
                                                'Build to Suit','','','Full Modernization','3');
    }   

    static testmethod void AProfServEstRA4() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst9', 'Virginia','State Average', 20000, 120000000, 
                                                'Courthouse', 'Repair & Alteration', 'Design Build - Leased', 'Developer CM',
                                                'Tenant Fit-out w/ no Redesign','','','Full Modernization','4');
    }

    static testmethod void AProfServEstRA5() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst10', 'Virginia','State Average', 20000, 100050, 
                                                'Courthouse', 'Repair & Alteration', 'Design Build - Leased', 'Developer CM',
                                                'Tenant Fit-out w/ no Redesign','','','Full Modernization','4+');
    }

    static testmethod void AProfServEstRA6() {
        NCMT_TestDataClass.CreateProfServEst('testProfServEst11', 'Virginia','State Average', 20000, 500000050, 
                                                'Courthouse', 'Repair & Alteration', 'Design Build - Leased', 'Developer CM',
                                                'Tenant Fit-out w/ no Redesign','','','Full Modernization','4+');
    }
}