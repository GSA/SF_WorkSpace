trigger NCMT_SiteInformationTrigger on Site_Information__c (after insert, after update) {
    
    System.debug('RUN SITE INFO TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {

        if (Trigger.isAfter) {
            //get Project ID
            
            Set<Id> PIds = new Set<Id>();
            Decimal Footprint_Area;
            Decimal Site_Area_for_Default_Value;
            for (Site_Information__c SI : Trigger.new) {
                PIds.add(SI.Project__c);
                Footprint_Area = SI.Footprint_Area__c;
                Site_Area_for_Default_Value = SI.Site_Area_for_Default_Value__c; // + SI.Surface_parking_Area_required__c;
            }   
        
            NCMT_Project__c Proj = [SELECT Footprint_Area__c, Calculated_Site_Area__c, Override_Calculated_Site_Area__c
                                        FROM NCMT_Project__c WHERE Id = :PIds ];
            
            //Update needed
            System.debug('Proj.Calculated_Site_Area__c' + Proj.Calculated_Site_Area__c +' Site_Area_for_Default_Value ' +Site_Area_for_Default_Value);
            Boolean updateProj = (Proj.Calculated_Site_Area__c != Site_Area_for_Default_Value);
            //Only update on insert
            if (Trigger.isInsert){
                Proj.Footprint_Area__c = Footprint_Area;
                
                Proj.Calculated_Site_Area__c =  Site_Area_for_Default_Value;
                
            }
            

            //if (Proj.Override_Calculated_Site_Area__c == 0 || proj.Override_Calculated_Site_Area__c == null
            //    || updateProj
            //){
                proj.Override_Calculated_Site_Area__c = Site_Area_for_Default_Value;
            //}
            upsert Proj;
            
        }
    }
}