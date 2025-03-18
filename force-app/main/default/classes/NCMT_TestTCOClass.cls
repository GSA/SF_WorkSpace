@isTest
public class NCMT_TestTCOClass {
    
    static testmethod void TCOOfficeProject1() {
        NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCovTCOOff1','Virginia','State Average'
        								          ,'Lowrise (2 - 3 stories)', true, false, false, 1000000, true, false, false, false, false);
	}
    
    /*static testmethod void TCOOfficeProject2() {
        NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCovTCOOff2','Virginia','State Average'
        								          ,'Single Story', true, false, false, 100000, true, true, false, false, false);
        
	}*/
    
    static testmethod void TCOOfficeProject3() {
        NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCovTCOOff3','Virginia','State Average'
        								          ,'Single Story', true, false, false, 1000000, true, false, true, false, false);
        
	}
    
    static testmethod void TCOOfficeProject4() {
        NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCovTCOOff4','Virginia','State Average'
        								          ,'Single Story', true, false, false, 1000000, true, false, false, true, false);
        
	}
    
    static testmethod void TCOOfficeProject5() {
        NCMT_TestTCOProjectClass.CreateTCOProject('testProjCodeCovTCOOff5','Virginia','State Average'
        								          ,'Single Story', true, false, false, 1000000, true, false, false, false, true);
        
	}
    
}