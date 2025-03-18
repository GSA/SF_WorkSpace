public with sharing class PBS_Leasing_GIS_MapController { 
    @AuraEnabled 
	public static String getYestersDay(Datetime currentDatetime) { 
    // Use the passed datetime or the current datetime if not provided 
    Datetime nowInNewYork = (currentDatetime != null) ? currentDatetime : Datetime.now(); 
        // Get the current date and time in New York time zone 
        TimeZone newYorkTz = TimeZone.getTimeZone('America/New_York'); 
        nowInNewYork = nowInNewYork.addSeconds(newYorkTz.getOffset(nowInNewYork) / 1000); 
        // Get the day of the week in New York time zone 
        String dayOfWeek = nowInNewYork.format('EEEE', 'America/New_York'); 
        Datetime yesterdayDatetime;
        if(dayOfWeek == 'Sunday'){ 
            yesterdayDatetime = nowInNewYork.addDays(-3); 
        } 
        else if(dayOfWeek == 'Saturday'){ 
            yesterdayDatetime = nowInNewYork.addDays(-2); 
        } 
        else { 
            yesterdayDatetime = nowInNewYork.addDays(-1); 
        } 
        // Format the date as mm/dd/yyyy 
        String formattedDate = yesterdayDatetime.format('MM/dd/yyyy', 'America/New_York'); 
        return formattedDate; 
    }
}