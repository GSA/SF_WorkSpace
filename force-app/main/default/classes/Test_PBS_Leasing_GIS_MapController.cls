@isTest
public class Test_PBS_Leasing_GIS_MapController { 
    @isTest 
    static void testGetYestersDay() { 
        // Mock the date to May 26, 2024 (Sunday) 
        Datetime mockDate = Datetime.newInstance(2024, 5, 26, 12, 0, 0); 
        // Expected result is the Thursday before the mock date (2024, 5, 23) 
        String expectedSunday = '05/23/2024'; 
        String resultSunday = PBS_Leasing_GIS_MapController.getYestersDay(mockDate); 
        System.assertEquals(expectedSunday, resultSunday, 'The date for Thursday is not correct.'); 
        // Mock the date to May 25, 2024 (Saturday) 
        mockDate = Datetime.newInstance(2024, 5, 25, 12, 0, 0); 
        // Expected result is the Thursday before the mock date (2024, 5, 23) 
        String expectedSaturday = '05/23/2024'; 
        String resultSaturday = PBS_Leasing_GIS_MapController.getYestersDay(mockDate); 
        System.assertEquals(expectedSaturday, resultSaturday, 'The date for Thursday is not correct.'); 
        // Mock the date to May 23, 2024 (Thursday) 
        mockDate = Datetime.newInstance(2024, 5, 23, 12, 0, 0); 
        // Expected result is the day before the mock date (2024, 5, 29) 
        String expectedWednesday = '05/22/2024'; 
        String resultWednesday = PBS_Leasing_GIS_MapController.getYestersDay(mockDate); 
        System.assertEquals(expectedWednesday, resultWednesday, 'The date for Wednesday is not correct.'); 
    }
}