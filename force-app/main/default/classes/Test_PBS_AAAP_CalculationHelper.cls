@IsTest
public class Test_PBS_AAAP_CalculationHelper {
	static testMethod void SmallLeaseNPVTest1(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(0.00).doublevalue(),
        					(0.00).doublevalue(),(0.00).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.1).doublevalue(),(9.51).doublevalue(),
                            (0.00).doublevalue(),(4.00).doublevalue(),(2.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
                            (6.00).doublevalue(),(0.00).doublevalue(),(0.05).doublevalue(),(0.025).doublevalue(),5000,5000,120,96,1,1,1,1);
		System.assertEquals((13.69).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void SmallLeaseNPVTest2(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),
							(0.01).doublevalue(),(1.00).doublevalue(),'$ Per ABOA SF',(1.00).doublevalue(),(0.01).doublevalue(),(1.00).doublevalue(),
							(0.01).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),
							(1.00).doublevalue(),(0.01).doublevalue(),(0.01).doublevalue(),1,1,120,96,1,1,1,1);
		System.assertEquals((47.98).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void SmallLeaseNPVTest3(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((5.00).doublevalue(),(6.00).doublevalue(),(7.00).doublevalue(),(8.00).doublevalue(),(13.00).doublevalue(),
							(0.10).doublevalue(),(0.15).doublevalue(),'%',(10.00).doublevalue(),(0.00).doublevalue(),(11.00).doublevalue(),
							(0.00).doublevalue(),(7.00).doublevalue(),(40.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(8.00).doublevalue(),
							(4.00).doublevalue(),(0.06).doublevalue(),(0.04).doublevalue(),14000,240000,120,96,100,100,100,100);
		System.assertEquals((22.01).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void SmallLeaseNPVTest4(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((6.00).doublevalue(),(8.00).doublevalue(),(9.00).doublevalue(),(11.00).doublevalue(),(1400.00).doublevalue(),
							(0.17).doublevalue(),(1400.00).doublevalue(),'$ Per ABOA SF',(3000.00).doublevalue(),(0.05).doublevalue(),
							(2500.00).doublevalue(),(0.03).doublevalue(),(19.00).doublevalue(),(14.00).doublevalue(),(2.00).doublevalue(),(4.00).doublevalue(),
							(11.00).doublevalue(),(0.50).doublevalue(),(0.001).doublevalue(),(0.035).doublevalue(),95400,102011,120,96,13,14,15,16);
		System.assertEquals((3956.92).doublevalue(),Round2(result),'Fail');
		
	}//failing due to garageparking rate and totlao lessor overhead fees
	static testMethod void SmallLeaseNPVTest5(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((13.00).doublevalue(),(12.00).doublevalue(),(8.00).doublevalue(),(2.00).doublevalue(),(140.00).doublevalue(),
							(0.02).doublevalue(),(0.15).doublevalue(),'%',(13.00).doublevalue(),(0.1321).doublevalue(),(10.11).doublevalue(),(0.1113).doublevalue(),
							(5.00).doublevalue(),(1.11).doublevalue(),(2.34).doublevalue(),(3.45).doublevalue(),(4.56).doublevalue(),(6.21).doublevalue(),
							(0.0412).doublevalue(),(0.0267).doublevalue(),150,2000,120,96,11,11,77,77);
		System.assertEquals((150.27).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void SmallLeaseNPVTest6(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((1.11).doublevalue(),(2.22).doublevalue(),(3.33).doublevalue(),(4.44).doublevalue(),(5.55).doublevalue(),
							(0.06).doublevalue(),(0.077).doublevalue(),'%',(8.80).doublevalue(),(0.099).doublevalue(),(10.10).doublevalue(),(0.1111).doublevalue(),
							(12.00).doublevalue(),(13.13).doublevalue(),(14.14).doublevalue(),(15.15).doublevalue(),(16.16).doublevalue(),(17.17).doublevalue(),
							(0.1818).doublevalue(),(0.1919).doublevalue(),20000,21000,120,96,22,23,24,25);
		System.assertEquals((13.90).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void SmallLeaseNPVTest7(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),(0.00).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.10).doublevalue(),(9.51).doublevalue(),(0.00).doublevalue(),
							(4.00).doublevalue(),(2.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(6.00).doublevalue(),(0.00).doublevalue(),
							(0.05).doublevalue(),(0.025).doublevalue(),5000,5000,120,96,1,1,1,1);
		System.assertEquals((13.69).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void SmallLeaseNPVTest8(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),(0.00).doublevalue(),'$ Per ABOA SF',(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
							(1.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),1,50,120,96,0,0,0,0);
		System.assertEquals((0.10).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void SmallLeaseNPVTest9(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((100.00).doublevalue(),(99.00).doublevalue(),(98.00).doublevalue(),(97.00).doublevalue(),(96.00).doublevalue(),
							(0.95).doublevalue(),(94.00).doublevalue(),'$ Per ABOA SF',(93.00).doublevalue(),(0.92).doublevalue(),(91.00).doublevalue(),(0.90).doublevalue(),
							(89.00).doublevalue(),(88.00).doublevalue(),(87.00).doublevalue(),(86.00).doublevalue(),(85.00).doublevalue(),(84.00).doublevalue(),(0.83).doublevalue(),
							(0.82).doublevalue(),80,81,120,96,79,78,77,76);
		System.assertEquals((-660.94).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void SmallLeaseNPVTest10(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((6.00).doublevalue(),(9.00).doublevalue(),(4.00).doublevalue(),(5.00).doublevalue(),(1.57).doublevalue(),
							(0.0857).doublevalue(),(18.37).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.10).doublevalue(),(9.51).doublevalue(),(0.089).doublevalue(),
							(92.00).doublevalue(),(1.47).doublevalue(),(3.57).doublevalue(),(8.56).doublevalue(),(9.25).doublevalue(),(15.00).doublevalue(),(0.1720).doublevalue(),
							(0.0445).doublevalue(),5000,72000,120,96,10,18,29,44);
		System.assertEquals((-5.79).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void SmallLeaseNPVTestNCR(){
		double result = PBS_AAAP_CalculationHelper.SmallLeaseNPV((62.00).doublevalue(),(74.00).doublevalue(),(85.00).doublevalue(),(49.99).doublevalue(),(15.40).doublevalue(),
							(0.0763).doublevalue(),(0.15).doublevalue(),'%',(8.58).doublevalue(),(0.11).doublevalue(),(73.40).doublevalue(),(0.0857).doublevalue(),
							(11.00).doublevalue(),(4.45).doublevalue(),(3.76).doublevalue(),(7.55).doublevalue(),(9.18).doublevalue(),(9.99).doublevalue(),(0.1222).doublevalue(),
							(0.0111).doublevalue(),1000000,1250000,120,96,12,2,13,15);
		System.assertEquals((19.11).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void MesiumLeaseNPVTest(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(8.15).doublevalue(),
        					(0.03).doublevalue(),(3.50).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.00).doublevalue(),(9.51).doublevalue(),
                            (0.00).doublevalue(),(4.00).doublevalue(),(54.69).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
                            (6.00).doublevalue(),(0.00).doublevalue(),(0.05).doublevalue(),(0.025).doublevalue(),75000,75000,180,96,1,1,1,1);
		System.assertEquals((20.04).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void MesiumLeaseNPVTest1(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),(0.00).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.10).doublevalue(),(9.51).doublevalue(),(0.00).doublevalue(),
							(4.00).doublevalue(),(2.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(6.00).doublevalue(),(0.00).doublevalue(),(0.05).doublevalue(),
							(0.025).doublevalue(),5000,5000,180,96,1,1,1,1);
		System.assertEquals((10.84).doublevalue(),Round2(result),'Fail');

	}
	static testMethod void MesiumLeaseNPVTest2(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),
							(0.01).doublevalue(),(1.00).doublevalue(),'$ Per ABOA SF',(1.00).doublevalue(),(0.01).doublevalue(),(1.00).doublevalue(),(0.01).doublevalue(),
							(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(0.01).doublevalue(),
							(0.01).doublevalue(),1,1,180,96,1,1,1,1);
		System.assertEquals((46.67).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void MesiumLeaseNPVTest3(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((5.00).doublevalue(),(6.00).doublevalue(),(7.00).doublevalue(),(8.00).doublevalue(),(13.00).doublevalue(),
							(0.10).doublevalue(),(0.15).doublevalue(),'%',(10.00).doublevalue(),(0.00).doublevalue(),(11.00).doublevalue(),(0.00).doublevalue(),
							(7.00).doublevalue(),(40.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(8.00).doublevalue(),(4.00).doublevalue(),(0.06).doublevalue(),
							(0.04).doublevalue(),14000,240000,180,96,100,100,100,100);
		System.assertEquals((19.69).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void MesiumLeaseNPVTest4(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((6.00).doublevalue(),(8.00).doublevalue(),(9.00).doublevalue(),(11.00).doublevalue(),(1400.00).doublevalue(),
							(0.17).doublevalue(),(1400.00).doublevalue(),'$ Per ABOA SF',(3000.00).doublevalue(),(0.05).doublevalue(),(2500.00).doublevalue(),(0.03).doublevalue(),
							(19.00).doublevalue(),(14.00).doublevalue(),(2.00).doublevalue(),(4.00).doublevalue(),(11.00).doublevalue(),(0.50).doublevalue(),(0.001).doublevalue(),
							(0.035).doublevalue(),95400,102011,180,96,13,14,15,16);
		System.assertEquals((4157.38).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void MesiumLeaseNPVTest5(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((13.00).doublevalue(),(12.00).doublevalue(),(8.00).doublevalue(),(2.00).doublevalue(),(140.00).doublevalue(),
							(0.02).doublevalue(),(0.15).doublevalue(),'%',(13.00).doublevalue(),(0.1321).doublevalue(),(10.11).doublevalue(),(0.1113).doublevalue(),
							(5.00).doublevalue(),(1.11).doublevalue(),(2.34).doublevalue(),(3.45).doublevalue(),(4.56).doublevalue(),(6.21).doublevalue(),(0.0412).doublevalue(),
							(0.0267).doublevalue(),150,2000,180,96,11,11,77,77);
		System.assertEquals((144.55).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void MesiumLeaseNPVTest6(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((1.11).doublevalue(),(2.22).doublevalue(),(3.33).doublevalue(),(4.44).doublevalue(),(5.55).doublevalue(),
							(0.06).doublevalue(),(0.077).doublevalue(),'%',(8.80).doublevalue(),(0.099).doublevalue(),(10.10).doublevalue(),(0.1111).doublevalue(),
							(12.00).doublevalue(),(13.13).doublevalue(),(14.14).doublevalue(),(15.15).doublevalue(),(16.16).doublevalue(),(17.17).doublevalue(),(0.1818).doublevalue(),
							(0.1919).doublevalue(),20000,21000,180,96,22,23,24,25);
		System.assertEquals((11.40).doublevalue(),Round2(result),'Fail');
	}

	static testMethod void MesiumLeaseNPVTest7(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),(0.00).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.10).doublevalue(),(9.51).doublevalue(),(0.00).doublevalue(),
							(4.00).doublevalue(),(2.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(6.00).doublevalue(),(0.00).doublevalue(),(0.05).doublevalue(),
							(0.025).doublevalue(),5000,5000,180,96,1,1,1,1);
		System.assertEquals((10.84).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void MesiumLeaseNPVTest8(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),(0.00).doublevalue(),'$ Per ABOA SF',(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),(1.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),1,50,180,96,0,0,0,0);
		System.assertEquals((0.07).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void MesiumLeaseNPVTest9(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((100.00).doublevalue(),(99.00).doublevalue(),(98.00).doublevalue(),(97.00).doublevalue(),(96.00).doublevalue(),
							(0.95).doublevalue(),(94.00).doublevalue(),'$ Per ABOA SF',(93.00).doublevalue(),(0.92).doublevalue(),(91.00).doublevalue(),(0.90).doublevalue(),(89.00).doublevalue(),
							(88.00).doublevalue(),(87.00).doublevalue(),(86.00).doublevalue(),(85.00).doublevalue(),(84.00).doublevalue(),(0.83).doublevalue(),(0.82).doublevalue(),
							80,81,180,96,79,78,77,76);
		System.assertEquals((-423.41).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void MesiumLeaseNPVTest10(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((6.00).doublevalue(),(9.00).doublevalue(),(4.00).doublevalue(),(5.00).doublevalue(),(1.57).doublevalue(),
							(0.0857).doublevalue(),(18.37).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.10).doublevalue(),(9.51).doublevalue(),(0.089).doublevalue(),
							(92.00).doublevalue(),(1.47).doublevalue(),(3.57).doublevalue(),(8.56).doublevalue(),(9.25).doublevalue(),(15.00).doublevalue(),(0.1720).doublevalue(),
							(0.0445).doublevalue(),5000,72000,180,96,10,18,29,44);
		System.assertEquals((-3.33).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void MesiumLeaseNPVTestNCR(){
		double result = PBS_AAAP_CalculationHelper.MediumLeaseNPV((62.00).doublevalue(),(74.00).doublevalue(),(85.00).doublevalue(),(49.99).doublevalue(),(15.40).doublevalue(),
							(0.0763).doublevalue(),(0.15).doublevalue(),'%',(8.58).doublevalue(),(0.11).doublevalue(),(73.40).doublevalue(),(0.0857).doublevalue(),(11.00).doublevalue(),
							(4.45).doublevalue(),(3.76).doublevalue(),(7.55).doublevalue(),(9.18).doublevalue(),(9.99).doublevalue(),(0.1222).doublevalue(),(0.0111).doublevalue(),
							1000000,1250000,180,96,12,2,13,15);
		System.assertEquals((19.61).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(8.15).doublevalue(),
        					(0.00).doublevalue(),(0.00).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.1).doublevalue(),(9.51).doublevalue(),
                            (0.00).doublevalue(),(4.00).doublevalue(),(30.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(6.00).doublevalue(),
                            (0.00).doublevalue(),(0.05).doublevalue(),(0.025).doublevalue(),5000,5000,204,96,1,1,1,1);
		System.assertEquals((18.20).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest1(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),(0.00).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.10).doublevalue(),(9.51).doublevalue(),(0.00).doublevalue(),
							(4.00).doublevalue(),(2.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(6.00).doublevalue(),(0.00).doublevalue(),(0.05).doublevalue(),
							(0.025).doublevalue(),5000,5000,204,96,1,1,1,1);
		System.assertEquals((10.08).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest2(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((5.00).doublevalue(),(6.00).doublevalue(),(7.00).doublevalue(),(8.00).doublevalue(),(13.00).doublevalue(),
							(0.10).doublevalue(),(0.15).doublevalue(),'%',(10.00).doublevalue(),(0.00).doublevalue(),(11.00).doublevalue(),(0.00).doublevalue(),(7.00).doublevalue(),
							(40.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(8.00).doublevalue(),(4.00).doublevalue(),(0.06).doublevalue(),(0.04).doublevalue(),
							14000,240000,204,96,100,100,100,100);
		System.assertEquals((18.96).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest3(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((6.00).doublevalue(),(8.00).doublevalue(),(9.00).doublevalue(),(11.00).doublevalue(),(1400.00).doublevalue(),
							(0.17).doublevalue(),(1400.00).doublevalue(),'$ Per ABOA SF',(3000.00).doublevalue(),(0.05).doublevalue(),(2500.00).doublevalue(),(0.03).doublevalue(),
							(19.00).doublevalue(),(14.00).doublevalue(),(2.00).doublevalue(),(4.00).doublevalue(),(11.00).doublevalue(),(0.50).doublevalue(),(0.001).doublevalue(),
							(0.035).doublevalue(),95400,102011,204,96,13,14,15,16);
		System.assertEquals((4233.76).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest4(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),
							(0.01).doublevalue(),(1.00).doublevalue(),'$ Per ABOA SF',(1.00).doublevalue(),(0.01).doublevalue(),(1.00).doublevalue(),(0.01).doublevalue(),
							(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(1.00).doublevalue(),(0.01).doublevalue(),
							(0.01).doublevalue(),1,1,204,96,1,1,1,1);
		System.assertEquals((46.19).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest5(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((13.00).doublevalue(),(12.00).doublevalue(),(8.00).doublevalue(),(2.00).doublevalue(),(140.00).doublevalue(),
							(0.02).doublevalue(),(0.15).doublevalue(),'%',(13.00).doublevalue(),(0.1321).doublevalue(),(10.11).doublevalue(),(0.1113).doublevalue(),(5.00).doublevalue(),
							(1.11).doublevalue(),(2.34).doublevalue(),(3.45).doublevalue(),(4.56).doublevalue(),(6.21).doublevalue(),(0.0412).doublevalue(),(0.0267).doublevalue(),
							150,2000,204,96,11,11,77,77);
		System.assertEquals((142.26).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest6(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((1.11).doublevalue(),(2.22).doublevalue(),(3.33).doublevalue(),(4.44).doublevalue(),(5.55).doublevalue(),
							(0.06).doublevalue(),(0.077).doublevalue(),'%',(8.80).doublevalue(),(0.099).doublevalue(),(10.10).doublevalue(),(0.1111).doublevalue(),(12.00).doublevalue(),
							(13.13).doublevalue(),(14.14).doublevalue(),(15.15).doublevalue(),(16.16).doublevalue(),(17.17).doublevalue(),(0.1818).doublevalue(),(0.1919).doublevalue(),
							20000,21000,204,96,22,23,24,25);
		System.assertEquals((10.77).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest7(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(20.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),(0.00).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.10).doublevalue(),(9.51).doublevalue(),(0.00).doublevalue(),
							(4.00).doublevalue(),(2.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(6.00).doublevalue(),(0.00).doublevalue(),(0.05).doublevalue(),(0.025).doublevalue(),
							5000,5000,204,96,1,1,1,1);
		System.assertEquals((10.08).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest8(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
							(0.00).doublevalue(),(0.00).doublevalue(),'$ Per ABOA SF',(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
							(1.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),(0.00).doublevalue(),
							1,50,204,96,0,0,0,0);
		System.assertEquals((0.06).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest9(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((100.00).doublevalue(),(99.00).doublevalue(),(98.00).doublevalue(),(97.00).doublevalue(),(96.00).doublevalue(),
							(0.95).doublevalue(),(94.00).doublevalue(),'$ Per ABOA SF',(93.00).doublevalue(),(0.92).doublevalue(),(91.00).doublevalue(),(0.90).doublevalue(),
							(89.00).doublevalue(),(88.00).doublevalue(),(87.00).doublevalue(),(86.00).doublevalue(),(85.00).doublevalue(),(84.00).doublevalue(),(0.83).doublevalue(),
							(0.82).doublevalue(),80,81,204,96,79,78,77,76);
		System.assertEquals((-367.90).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTest10(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((6.00).doublevalue(),(9.00).doublevalue(),(4.00).doublevalue(),(5.00).doublevalue(),(1.57).doublevalue(),
							(0.0857).doublevalue(),(18.37).doublevalue(),'$ Per ABOA SF',(19.02).doublevalue(),(0.10).doublevalue(),(9.51).doublevalue(),(0.089).doublevalue(),
							(92.00).doublevalue(),(1.47).doublevalue(),(3.57).doublevalue(),(8.56).doublevalue(),(9.25).doublevalue(),(15.00).doublevalue(),(0.1720).doublevalue(),
							(0.0445).doublevalue(),5000,72000,204,96,10,18,29,44);
		System.assertEquals((-2.82).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void LongLeaseNPVTestNCR(){
		double result = PBS_AAAP_CalculationHelper.LongLeaseNPV((62.00).doublevalue(),(74.00).doublevalue(),(85.00).doublevalue(),(49.99).doublevalue(),(15.40).doublevalue(),
							(0.0763).doublevalue(),(0.15).doublevalue(),'%',(8.58).doublevalue(),(0.11).doublevalue(),(73.40).doublevalue(),(0.0857).doublevalue(),(11.00).doublevalue(),
							(4.45).doublevalue(),(3.76).doublevalue(),(7.55).doublevalue(),(9.18).doublevalue(),(9.99).doublevalue(),(0.1222).doublevalue(),(0.0111).doublevalue(),
							1000000,1250000,204,96,12,2,13,15);
		System.assertEquals((18.91).doublevalue(),Round2(result),'Fail');
	}
	static testMethod void Census19NPVTest1(){
		double result = PBS_AAAP_CalculationHelper.Census19NPV((10.00).doublevalue(),(10.00).doublevalue(),(10.00).doublevalue(),(10.00).doublevalue(),(3.55).doublevalue(),
        					(0.03).doublevalue(),(3.26).doublevalue(),'$ Per ABOA SF',(15.00).doublevalue(),(0.05).doublevalue(),(19.00).doublevalue(),
                            (15.32).doublevalue(),(9.99).doublevalue(),(8.88).doublevalue(),(7.77).doublevalue(),(0.0632).doublevalue(),10,10000,19,11,1,2,3,4);
		System.assertEquals((5.86).doublevalue(),Round2(result),'Fail');
		
	}
	static testMethod void Census25NPVTest1(){
		double result = PBS_AAAP_CalculationHelper.Census25NPV((10.00).doublevalue(),(10.00).doublevalue(),(10.00).doublevalue(),(10.00).doublevalue(),(3.55).doublevalue(),
        					(0.03).doublevalue(),(3.26).doublevalue(),'$ Per ABOA SF',(15.00).doublevalue(),(0.05).doublevalue(),(25.00).doublevalue(),
                            (15.32).doublevalue(),(9.99).doublevalue(),(8.88).doublevalue(),(7.77).doublevalue(),(0.0632).doublevalue(),10,10000,25,16,1,2,3,4);
		System.assertEquals((5.30).doublevalue(),Round2(result),'Fail');
		
	}
	static double Round2(double val){
		System.debug('Before rounding value: '+val);
		val = Math.round(val*100);
		System.debug('Rounded value: '+val);
		return val/100;


	}
}