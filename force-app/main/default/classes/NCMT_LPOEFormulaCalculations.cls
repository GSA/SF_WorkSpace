public with sharing class NCMT_LPOEFormulaCalculations{

    public static void formulaCalculation(ID ProjectRecordID, map<id,LPOE_Space_Plan__c> triggerOldmap ,List<LPOE_Space_Plan__c> LPOESpaceplanList, Map<String,NCMT_Project__c> ncmtMap,map<string,NCMT_LPOE_Parametric_Default_SpaceLookup__c> Parammap){
        
        map<id,LPOE_Space_Plan__c> projectSpacePlanMap = new map<id,LPOE_Space_Plan__c>();
        
        for(LPOE_Space_Plan__c key :LPOESpaceplanList){
            
            Decimal POVPortDepth = 0, POVPortWidth = 0, TotalPOVStandard = 0, CommPortDepth = 0, CommPortWidth = 0, TotalCommStandard = 0,flag = 0, dblcommelementsdefault = 0,
                    dblPOVelements = 0, dblpovprimaryroadways = 0, dblcommprimaryroadways = 0;
            
            NCMT_project__c ncmtRec = new NCMT_Project__c();
            ncmtRec = ncmtMap.get(key.Project_Name__c);
              
            NCMT_LPOE_Parametric_Default_SpaceLookup__c LPOEParamRec = new NCMT_LPOE_Parametric_Default_SpaceLookup__c();
            string keyValue = LPOEParamRec.LPOE_Line_Item__c+LPOEParamRec.LPOE_Type__c;
                   LPOEParamRec = Parammap.get(keyValue);
                   
            if(trigger.isInsert) {
                
                // POV Number of Lanes
                if(ncmtRec.POV_Port_Size__c == 'Mini'){
                    key.Number_of_Lanes_Default__c = key.Number_of_Lanes__c = 1;
                }else if(ncmtRec.POV_Port_Size__c == 'Small'){
                    key.Number_of_Lanes_Default__c = key.Number_of_Lanes__c = 3;
                }else if(ncmtRec.POV_Port_Size__c == 'Medium'){
                    key.Number_of_Lanes_Default__c = key.Number_of_Lanes__c =10;
                }else if(ncmtRec.POV_Port_Size__c == 'Large'){
                    key.Number_of_Lanes_Default__c = key.Number_of_Lanes__c = 16;
                }else if(ncmtRec.POV_Port_Size__c == 'Mega'){
                    key.Number_of_Lanes_Default__c = key.Number_of_Lanes__c = 25;
                }else{
                    key.Number_of_Lanes_Default__c = key.Number_of_Lanes__c = 0;
                }
                
                // Commercial Number of Lanes
                if(ncmtRec.Commercial_Port_Size__c == 'Small'){
                    key.Comm_Number_of_Lanes_Default__c = key.Comm_Number_of_Lanes__c = 3;
                }else if(ncmtRec.Commercial_Port_Size__c == 'Medium'){
                    key.Comm_Number_of_Lanes_Default__c = key.Comm_Number_of_Lanes__c =10;
                }else if(ncmtRec.Commercial_Port_Size__c == 'Large'){
                    key.Comm_Number_of_Lanes_Default__c = key.Comm_Number_of_Lanes__c = 16;
                }else if(ncmtRec.Commercial_Port_Size__c == 'Mega'){
                    key.Comm_Number_of_Lanes_Default__c = key.Comm_Number_of_Lanes__c = 25;
                }else{
                    key.Comm_Number_of_Lanes_Default__c = key.Comm_Number_of_Lanes__c = 0;
                }         
            }
            
            //Border flag
            if(ncmtRec.Border__c == 'Southern'){
                flag = 0;
            } else{
                flag = 1;
            }
           
            // POV Acreage
            if(key.Number_of_Lanes__c == 0){
                POVPortDepth = 0;
            }else{
                POVPortDepth = (((key.Number_of_Lanes__c/40)*1000)+800);
            }
            
            if(key.Number_of_Lanes__c == 0){
                POVPortWidth = 0;
            }else{
                POVPortWidth = (Math.Ceil(key.Number_of_Lanes__c *4/3)*30)+200;
            } 
            totalPOVStandard  = POVPortDepth * POVPortWidth * 0.9;
            key.Acreage_Default__c = Math.Round(totalPOVStandard/43560);
            
            //POV Calculations
            //Main Building
            if(key.Number_of_Lanes__c == 0){
                key.Main_Building_Default__c = 0;
                key.Large_Inbound_Booth_Default__c = 0;
                key.Large_Outbound_Booth_Default__c = 0;
            }else{
                 if(key.Number_of_Lanes__c < 5){
                    key.Main_Building_Default__c = (key.Number_of_Lanes__c * (Parammap.get('Main BuildingPOV').GSF_MX__c)/2)+  Parammap.get('Main BuildingPOV').GSF_C__c ;
                 }else{
                    key.Main_Building_Default__c = (key.Number_of_Lanes__c * Parammap.get('Main BuildingPOV').GSF_MX__c) + Parammap.get('Main BuildingPOV').GSF_C__c;
                 }
                 
                 key.Large_Inbound_Booth_Default__c = Parammap.get('Large Booth/Canopy (Inbound)POV').GSF_MX__c + Parammap.get('Large Booth/Canopy (Inbound)POV').GSF_C__c;
                 key.Large_Outbound_Booth_Default__c = Parammap.get('Large Booth/Canopy (Outbound)POV').GSF_MX__c + Parammap.get('Large Booth/Canopy (Outbound)POV').GSF_C__c;
            }
            
            //Inbound AutoInspection building
            if(key.Number_of_Lanes__c < 5){
                key.Inbound_Auto_Inspection_Default__c = 0;
                key.Kennel_Default__c = 0;
                key.Aviary_Holding_Default__c = 0;
                key.Maintenance_Default__c = 0;
                key.Sentri_Inspection_Lane_Default__c = 0;
            }else{
                key.Inbound_Auto_Inspection_Default__c = ((key.Number_of_Lanes__c - 5)* Parammap.get('Inbound Auto Inspection BuildingPOV').GSF_MX__c) + Parammap.get('Inbound Auto Inspection BuildingPOV').GSF_C__c;
                key.Kennel_Default__c = (key.Number_of_Lanes__c* Parammap.get('KennelPOV').GSF_MX__c) + Parammap.get('KennelPOV').GSF_C__c;
                key.Aviary_Holding_Default__c = Parammap.get('Aviary Holding BuildingPOV').GSF_MX__c + Parammap.get('Aviary Holding BuildingPOV').GSF_C__c;
                key.Maintenance_Default__c = Parammap.get('Maintenance BuildingPOV').GSF_MX__c + Parammap.get('Maintenance BuildingPOV').GSF_C__c;
                key.Sentri_Inspection_Lane_Default__c = Parammap.get('Sentri Inspection LanePOV').GSF_MX__c + Parammap.get('Sentri Inspection LanePOV').GSF_C__c;
            }
            
            //Repatriation Facility & Outbound AutoInspection building & Narcotics
            if(key.Number_of_Lanes__c < 15){
                key.Repatriation_Facility_Default__c = 0;
                key.Outbound_Auto_Inspection_Default__c = 0;
                key.Narcotics_Seizures_Vault_Default__c = 0;
                key.Bus_Drop_Off_Default__c = 0;
            }else{
                key.Repatriation_Facility_Default__c = NCMT_GenerateProjectDetails.roundofneg((Parammap.get('Repatriation Facility - Study DataPOV').GSF_MX__c),-2);
                key.Outbound_Auto_Inspection_Default__c = (key.Number_of_Lanes__c * Parammap.get('Outbound Auto Inspection BuildingPOV').GSF_MX__c) + Parammap.get('Outbound Auto Inspection BuildingPOV').GSF_C__c;
                key.Narcotics_Seizures_Vault_Default__c = Parammap.get('Narcotics Seizures VaultPOV').GSF_MX__c + Parammap.get('Narcotics Seizures VaultPOV').GSF_C__c;
                key.Bus_Drop_Off_Default__c = Parammap.get('Bus Drop Off Canopy - Study DataPOV').GSF_MX__c;
            }
            
            //Vehicle Breakdown building
            key.Vehicle_Breakdown_Default__c = (Math.Ceil(key.Number_of_Lanes__c/8) * Parammap.get('Vehicle Breakdown BuildingPOV').GSF_MX__c) + Parammap.get('Vehicle Breakdown BuildingPOV').GSF_C__c;
            
            //Central Plant & Garage
            if(key.Number_of_Lanes__c < 10){
                key.Central_Plant_Default__c = 0;
                key.Garage_Default__c = 0;
                key.Inbound_Bypass_Lane_Default__c = 0;
                key.Outbound_Bypass_Lane_Default__c = 0;
            }else{
                key.Central_Plant_Default__c = ((key.Number_of_Lanes__c - 10)* Parammap.get('Central PlantPOV').GSF_MX__c) + Parammap.get('Central PlantPOV').GSF_C__c;
                key.Garage_Default__c = ((Math.Ceil(key.Number_of_Lanes__c/8) * Parammap.get('GaragePOV').GSF_MX__c) + Parammap.get('GaragePOV').GSF_C__c) * flag;
                key.Inbound_Bypass_Lane_Default__c = Parammap.get('Bypass Lane Canopy (Inbound)POV').GSF_MX__c + Parammap.get('Bypass Lane Canopy (Inbound)POV').GSF_C__c;
                key.Outbound_Bypass_Lane_Default__c = Parammap.get('Bypass Lane Canopy (Outbound)POV').GSF_MX__c + Parammap.get('Bypass Lane Canopy (Outbound)POV').GSF_C__c;
            }
            
            // Exit Booth canopy
            if(key.Number_of_Lanes__c < 2){
                key.Inbound_Exit_Booth_Default__c = 0;
                key.Outbound_Exit_Booth_Default__c = 0;
            }else{
                key.Inbound_Exit_Booth_Default__c = Parammap.get('Exit Booth/Canopy (Inbound)POV').GSF_MX__c + Parammap.get('Exit Booth/Canopy (Inbound)POV').GSF_C__c;
                key.Outbound_Exit_Booth_Default__c = Parammap.get('Exit Booth/Canopy (Outbound)POV').GSF_MX__c + Parammap.get('Exit Booth/Canopy (Outbound)POV').GSF_C__c;
            }
            
            if(key.Number_of_Lanes__c == 0){
                 key.Inbound_Booth_Default__c = 0;
                 key.Outbound_Booth_Default__c = 0;
            }else{
                key.Inbound_Booth_Default__c = ((key.Number_of_Lanes__c * Parammap.get('Booth/Canopy (Inbound)POV').GSF_MX__c) + Parammap.get('Booth/Canopy (Inbound)POV').GSF_C__c) -
                                                key.Inbound_Bypass_Lane_Default__c - key.Sentri_Inspection_Lane_Default__c - key.Large_Inbound_Booth_Default__c;
                key.Outbound_Booth_Default__c = ((Math.Ceil(key.Number_of_Lanes__c/3) * Parammap.get('Booth/Canopy (Outbound)POV').GSF_MX__c) + Parammap.get('Booth/Canopy (Outbound)POV').GSF_C__c) -
                                                 key.Outbound_Bypass_Lane_Default__c - key.Large_Outbound_Booth_Default__c;                                
            }
            
            //POV Secondary Inspection canopy
            key.Secondary_Inspection_Default__c = Math.Round(key.Inbound_Booth_Default__c * 4);  
                        
            //Commercial Acreage    
            CommPortDepth = ((key.Comm_Number_of_Lanes__c/12)*1000)+500;
                                
            if(key.Comm_Number_of_Lanes__c == 0){
                CommPortWidth = 0;
            }else{
                CommPortWidth = (Math.Ceil(key.Comm_Number_of_Lanes__c *4/3)*25)+3000;
            }
            
            totalCommStandard  = CommPortDepth * CommPortWidth * 0.9;
            key.Comm_Acreage_Default__c = Math.Round(totalCommStandard/43560); 
            
            //Office buildings
            if(key.Comm_Number_of_Lanes__c < 15){
                key.Commercial_Plant_Inspection_Default__c = 0;
                key.Veterinary_Default__c = 0;
                key.Commercial_FMCSA_Default__c = 0;
                key.Comm_Hazmat_Lane_Default__c = 0;
            }else{
                key.Commercial_Plant_Inspection_Default__c = Parammap.get('Plant Inspection BuildingCommercial').GSF_MX__c + Parammap.get('Plant Inspection BuildingCommercial').GSF_C__c;
                key.Veterinary_Default__c = Parammap.get('Veterinary BuildingCommercial').GSF_MX__c + Parammap.get('Veterinary BuildingCommercial').GSF_C__c;
                key.Commercial_FMCSA_Default__c = Parammap.get('FMCSA BuildingCommercial').GSF_MX__c + Parammap.get('FMCSA BuildingCommercial').GSF_C__c;
                key.Comm_Hazmat_Lane_Default__c = Parammap.get('Hazmat Lane CanopyCommercial').GSF_MX__c + Parammap.get('Hazmat Lane CanopyCommercial').GSF_C__c;
            }
            
            //Warehouse buildings & Canopies
            if(key.Comm_Number_of_Lanes__c == 0){
                key.Outbound_Secondary_Inspection_Default__c = 0;
                key.Inbound_Secondary_Inspection_Default__c = 0;
                key.VACIS_Default__c = 0;
                key.Hazmat_Inspection_Default__c = 0;
                key.Seizures_Vault_Default__c = 0;
            }else{
                key.Outbound_Secondary_Inspection_Default__c = (key.Comm_Number_of_Lanes__c * Parammap.get('Outbound Secondary Inspection FacilityCommercial').GSF_MX__c) + Parammap.get('Outbound Secondary Inspection FacilityCommercial').GSF_C__c;
                key.Inbound_Secondary_Inspection_Default__c = (key.Comm_Number_of_Lanes__c * Parammap.get('Inbound Secondary Inspection FacilityCommercial').GSF_MX__c) + Parammap.get('Inbound Secondary Inspection FacilityCommercial').GSF_C__c;
                key.VACIS_Default__c = (Math.Ceil(key.Comm_Number_of_Lanes__c/10) * Parammap.get('VACIS BuildingCommercial').GSF_MX__c) + Parammap.get('VACIS BuildingCommercial').GSF_C__c;
                key.Hazmat_Inspection_Default__c = (Math.Ceil(key.Comm_Number_of_Lanes__c/10) * Parammap.get('Hazmat Inspection FacilityCommercial').GSF_MX__c) + Parammap.get('Hazmat Inspection FacilityCommercial').GSF_C__c;
                key.Seizures_Vault_Default__c = (Math.Round(key.Comm_Number_of_Lanes__c/30) * Parammap.get('Seizures VaultCommercial').GSF_MX__c) + Parammap.get('Seizures VaultCommercial').GSF_C__c;
            }
            
            if(key.Comm_Number_of_Lanes__c < 5){
                key.Bird_Quarantine_Default__c = 0;
                key.Comm_Aviary_Holding_Default__c = 0;
                key.Comm_Inbound_Bypass_Lane_Default__c = 0;
                key.Comm_Outbound_Bypass_Lane_Default__c = 0;
                key.Large_Inbound_Inspection_Lane_Default__c = 0;
                key.Large_Outbound_Inspection_Lane_Default__c = 0;
                key.Inbound_Non_Laden_Inspection_Default__c = 0;
                key.Outbound_Non_Laden_Inspection_Default__c = 0;
                key.comm_Inbound_Truck_Scale_Default__c = 0;
                key.Comm_Outbound_Truck_Scale_Default__c = 0;
                key.Comm_Sentri_Lane_Default__c = 0;
            }else{
                key.Bird_Quarantine_Default__c = Parammap.get('Bird Quarantine BuildingCommercial').GSF_MX__c + Parammap.get('Bird Quarantine BuildingCommercial').GSF_C__c;
                key.Comm_Aviary_Holding_Default__c = Parammap.get('Aviary Holding BuildingCommercial').GSF_MX__c + Parammap.get('Aviary Holding BuildingCommercial').GSF_C__c;
                key.Comm_Inbound_Bypass_Lane_Default__c = Parammap.get('Bypass Lane Canopy (Inbound)Commercial').GSF_MX__c + Parammap.get('Bypass Lane Canopy (Inbound)Commercial').GSF_C__c;
                key.Comm_Outbound_Bypass_Lane_Default__c = Parammap.get('Bypass Lane Canopy (Outbound)Commercial').GSF_MX__c + Parammap.get('Bypass Lane Canopy (Outbound)Commercial').GSF_C__c;
                key.Large_Inbound_Inspection_Lane_Default__c = Parammap.get('Large Inspection Lane Canopy (Inbound)Commercial').GSF_MX__c + Parammap.get('Large Inspection Lane Canopy (Inbound)Commercial').GSF_C__c;
                key.Large_Outbound_Inspection_Lane_Default__c = Parammap.get('Large Inspection Lane Canopy (Outbound)Commercial').GSF_MX__c + Parammap.get('Large Inspection Lane Canopy (Outbound)Commercial').GSF_C__c;
                key.Inbound_Non_Laden_Inspection_Default__c = Parammap.get('Non-Laden Inspection Canopy (Inbound)Commercial').GSF_MX__c + Parammap.get('Non-Laden Inspection Canopy (Inbound)Commercial').GSF_C__c;
                key.Outbound_Non_Laden_Inspection_Default__c = Parammap.get('Non-Laden Inspection Canopy (Outbound)Commercial').GSF_MX__c + Parammap.get('Non-Laden Inspection Canopy (Outbound)Commercial').GSF_C__c;
                key.comm_Inbound_Truck_Scale_Default__c = Parammap.get('Truck Scale Canopy (Inbound)Commercial').GSF_MX__c + Parammap.get('Truck Scale Canopy (Inbound)Commercial').GSF_C__c;
                key.Comm_Outbound_Truck_Scale_Default__c = Parammap.get('Truck Scale Canopy (Outbound)Commercial').GSF_MX__c + Parammap.get('Truck Scale Canopy (Outbound)Commercial').GSF_C__c;
                key.Comm_Sentri_Lane_Default__c = Parammap.get('Sentri Lane CanopyCommercial').GSF_MX__c + Parammap.get('Sentri Lane CanopyCommercial').GSF_C__c;
            }
            
            key.Inbound_Inspection_Lane_Default__c = ((key.Comm_Number_of_Lanes__c * Parammap.get('Inspection Lane Canopy (Inbound)Commercial').GSF_MX__c) + Parammap.get('Inspection Lane Canopy (Inbound)Commercial').GSF_C__c) -
                                                      key.Comm_Inbound_Bypass_Lane_Default__c - key.Large_Inbound_Inspection_Lane_Default__c - key.Inbound_Non_Laden_Inspection_Default__c; 
                                                      
            key.Outbound_Inspection_Lane_Default__c = ((Math.Ceil(key.Comm_Number_of_Lanes__c/3)* Parammap.get('Inspection Lane Canopy (Outbound)Commercial').GSF_MX__c) + Parammap.get('Inspection Lane Canopy (Outbound)Commercial').GSF_C__c) -                                           
                                                       key.Comm_Outbound_Bypass_Lane_Default__c - key.Large_Outbound_Inspection_Lane_Default__c - key.Outbound_Non_Laden_Inspection_Default__c;
            
            key.Comm_Inbound_Exit_Booth_Default__c = ((Math.Ceil(key.Comm_Number_of_Lanes__c/3)* Parammap.get('Exit Booth (Inbound)Commercial').GSF_MX__c) + Parammap.get('Exit Booth (Inbound)Commercial').GSF_C__c) -                                           
                                                       key.comm_Inbound_Truck_Scale_Default__c - key.Comm_Sentri_Lane_Default__c ;  
                                                       
            key.Comm_Outbound_Exit_Booth_Default__c = ((Math.Ceil(key.Comm_Number_of_Lanes__c/3)* Parammap.get('Exit Booth (Outbound)Commercial').GSF_MX__c) + Parammap.get('Exit Booth (Outbound)Commercial').GSF_C__c) -                                           
                                                       key.Comm_Outbound_Truck_Scale_Default__c - key.Comm_Hazmat_Lane_Default__c ;  
  
            if(trigger.isinsert){
                key.Acreage__c = key.Acreage_Default__c;    
                key.Comm_Acreage__c = key.Comm_Acreage_Default__c;
                //POV
                key.Main_Building__c = key.Main_Building_Default__c;
                key.Inbound_Auto_Inspection__c = key.Inbound_Auto_Inspection_Default__c;
                key.Repatriation_Facility__c = key.Repatriation_Facility_Default__c;
                key.Outbound_Auto_Inspection__c = key.Outbound_Auto_Inspection_Default__c;
                key.Vehicle_Breakdown__c = key.Vehicle_Breakdown_Default__c;
                key.Kennel__c = key.Kennel_Default__c;
                key.Aviary_Holding__c = key.Aviary_Holding_Default__c;
                key.Central_Plant__c  = key.Central_Plant_Default__c;
                key.Maintenance__c = key.Maintenance_Default__c;
                key.Narcotics_Seizures_Vault__c = key.Narcotics_Seizures_Vault_Default__c;
                key.Garage__c = key.Garage_Default__c;
                key.Inbound_Bypass_Lane__c = key.Inbound_Bypass_Lane_Default__c;
                key.Outbound_Bypass_Lane__c = key.Outbound_Bypass_Lane_Default__c;
                key.Inbound_Exit_Booth__c = key.Inbound_Exit_Booth_Default__c;
                key.Outbound_Exit_Booth__c = key.Outbound_Exit_Booth_Default__c;
                key.Sentri_Inspection_Lane__c = key.Sentri_Inspection_Lane_Default__c;  
                key.Large_Inbound_Booth__c = key.Large_Inbound_Booth_Default__c;
                key.Large_Outbound_Booth__c = key.Large_Outbound_Booth_Default__c;
                key.Bus_Drop_Off__c = key.Bus_Drop_Off_Default__c;
                key.Inbound_Booth__c = key.Inbound_Booth_Default__c;
                key.Outbound_Booth__c = key.Outbound_Booth_Default__c;
                key.Secondary_Inspection__c = key.Secondary_Inspection_Default__c;
 
                //Commercial
                key.Commercial_Plant_Inspection__c = key.Commercial_Plant_Inspection_Default__c;
                key.Veterinary__c = key.Veterinary_Default__c;
                key.Commercial_FMCSA__c = key.Commercial_FMCSA_Default__c;
                key.Outbound_Secondary_Inspection__c = key.Outbound_Secondary_Inspection_Default__c;
                key.Inbound_Secondary_Inspection__c = key.Inbound_Secondary_Inspection_Default__c;
                key.VACIS__c = key.VACIS_Default__c ;
                key.Hazmat_Inspection__c = key.Hazmat_Inspection_Default__c;
                key.Seizures_Vault__c = key.Seizures_Vault_Default__c;
                key.Bird_Quarantine__c = key.Bird_Quarantine_Default__c;
                key.Comm_Aviary_Holding__c = key.Comm_Aviary_Holding_Default__c;
                key.Comm_Inbound_Bypass_Lane__c = key.Comm_Inbound_Bypass_Lane_Default__c;
                key.Comm_Outbound_Bypass_Lane__c = key.Comm_Outbound_Bypass_Lane_Default__c;
                key.Large_Inbound_Inspection_Lane__c = key.Large_Inbound_Inspection_Lane_Default__c;
                key.Large_Outbound_Inspection_Lane__c = key.Large_Outbound_Inspection_Lane_Default__c;
                key.Inbound_Non_Laden_Inspection__c = key.Inbound_Non_Laden_Inspection_Default__c;
                key.Outbound_Non_Laden_Inspection__c = key.Outbound_Non_Laden_Inspection_Default__c;
                key.Comm_Inbound_Truck_Scale__c = key.comm_Inbound_Truck_Scale_Default__c;
                key.Comm_Outbound_Truck_Scale__c = key.Comm_Outbound_Truck_Scale_Default__c;
                key.Comm_Sentri_Lane__c = key.Comm_Sentri_Lane_Default__c;
                key.Comm_Hazmat_Lane__c = key.Comm_Hazmat_Lane_Default__c;
                key.Inbound_Inspection_Lane__c = key.Inbound_Inspection_Lane_Default__c;
                key.Outbound_Inspection_Lane__c = key.Outbound_Inspection_Lane_Default__c;
                key.Comm_Inbound_Exit_Booth__c = key.Comm_Inbound_Exit_Booth_Default__c;
                key.Comm_Outbound_Exit_Booth__c = key.Comm_Outbound_Exit_Booth_Default__c;
            }   
            
            if(trigger.isupdate){
                if(triggerOldmap.get(key.id).Number_of_Lanes__c != key.Number_of_Lanes__c){
                    //if(triggerOldmap.get(key.id).Acreage__c == key.Acreage__c)
                        key.Acreage__c = key.Acreage_Default__c;  
                        key.Main_Building__c = key.Main_Building_Default__c;
                        key.Inbound_Auto_Inspection__c = key.Inbound_Auto_Inspection_Default__c;
                        key.Repatriation_Facility__c = key.Repatriation_Facility_Default__c;
                        key.Outbound_Auto_Inspection__c = key.Outbound_Auto_Inspection_Default__c;
                        key.Vehicle_Breakdown__c = key.Vehicle_Breakdown_Default__c;
                        key.Kennel__c = key.Kennel_Default__c;
                        key.Aviary_Holding__c = key.Aviary_Holding_Default__c;
                        key.Central_Plant__c  = key.Central_Plant_Default__c;
                        key.Maintenance__c = key.Maintenance_Default__c;
                        key.Narcotics_Seizures_Vault__c = key.Narcotics_Seizures_Vault_Default__c;
                        key.Garage__c = key.Garage_Default__c;
                        key.Inbound_Bypass_Lane__c = key.Inbound_Bypass_Lane_Default__c;
                        key.Outbound_Bypass_Lane__c = key.Outbound_Bypass_Lane_Default__c;
                        key.Inbound_Exit_Booth__c = key.Inbound_Exit_Booth_Default__c;
                        key.Outbound_Exit_Booth__c = key.Outbound_Exit_Booth_Default__c;
                        key.Sentri_Inspection_Lane__c = key.Sentri_Inspection_Lane_Default__c;
                        key.Large_Inbound_Booth__c = key.Large_Inbound_Booth_Default__c;
                        key.Large_Outbound_Booth__c = key.Large_Outbound_Booth_Default__c;
                        key.Bus_Drop_Off__c = key.Bus_Drop_Off_Default__c;
                        key.Inbound_Booth__c = key.Inbound_Booth_Default__c;
                        key.Outbound_Booth__c = key.Outbound_Booth_Default__c;
                        key.Secondary_Inspection__c = key.Secondary_Inspection_Default__c;
                }  
                if(triggerOldmap.get(key.id).Comm_Number_of_Lanes__c != key.Comm_Number_of_Lanes__c){
                    //if((triggerOldmap.get(key.id).Comm_Acreage__c == key.Comm_Acreage__c))
                        key.Comm_Acreage__c = key.Comm_Acreage_Default__c;
                        key.Commercial_Plant_Inspection__c = key.Commercial_Plant_Inspection_Default__c;
                        key.Veterinary__c = key.Veterinary_Default__c;
                        key.Commercial_FMCSA__c = key.Commercial_FMCSA_Default__c;
                        key.Outbound_Secondary_Inspection__c = key.Outbound_Secondary_Inspection_Default__c;
                        key.Inbound_Secondary_Inspection__c = key.Inbound_Secondary_Inspection_Default__c;
                        key.VACIS__c = key.VACIS_Default__c ;
                        key.Hazmat_Inspection__c = key.Hazmat_Inspection_Default__c;
                        key.Seizures_Vault__c = key.Seizures_Vault_Default__c;
                        key.Bird_Quarantine__c = key.Bird_Quarantine_Default__c;
                        key.Comm_Aviary_Holding__c = key.Comm_Aviary_Holding_Default__c;
                        key.Comm_Inbound_Bypass_Lane__c = key.Comm_Inbound_Bypass_Lane_Default__c;
                        key.Comm_Outbound_Bypass_Lane__c = key.Comm_Outbound_Bypass_Lane_Default__c;
                        key.Large_Inbound_Inspection_Lane__c = key.Large_Inbound_Inspection_Lane_Default__c;
                        key.Large_Outbound_Inspection_Lane__c = key.Large_Outbound_Inspection_Lane_Default__c;
                        key.Inbound_Non_Laden_Inspection__c = key.Inbound_Non_Laden_Inspection_Default__c;
                        key.Outbound_Non_Laden_Inspection__c = key.Outbound_Non_Laden_Inspection_Default__c;
                        key.Comm_Inbound_Truck_Scale__c = key.comm_Inbound_Truck_Scale_Default__c;
                        key.Comm_Outbound_Truck_Scale__c = key.Comm_Outbound_Truck_Scale_Default__c;
                        key.Comm_Sentri_Lane__c = key.Comm_Sentri_Lane_Default__c;
                        key.Comm_Hazmat_Lane__c = key.Comm_Hazmat_Lane_Default__c;
                        key.Inbound_Inspection_Lane__c = key.Inbound_Inspection_Lane_Default__c;
                        key.Outbound_Inspection_Lane__c = key.Outbound_Inspection_Lane_Default__c;
                        key.Comm_Inbound_Exit_Booth__c = key.Comm_Inbound_Exit_Booth_Default__c;
                        key.Comm_Outbound_Exit_Booth__c = key.Comm_Outbound_Exit_Booth_Default__c;
                }
            }
            
            key.Total_GSF__c = key.Main_Building__c + key.Inbound_Auto_Inspection__c + key.Repatriation_Facility__c  + key.Outbound_Auto_Inspection__c + key.Vehicle_Breakdown__c + key.Kennel__c + key.Aviary_Holding__c +
                               key.Central_Plant__c + key.Maintenance__c + key.Narcotics_Seizures_Vault__c + key.Garage__c + key.Inbound_Bypass_Lane__c + key.Outbound_Bypass_Lane__c + key.Inbound_Exit_Booth__c + key.Outbound_Exit_Booth__c +
                               key.Sentri_Inspection_Lane__c + key.Large_Inbound_Booth__c + key.Large_Outbound_Booth__c + key.Bus_Drop_Off__c + key.Inbound_Booth__c + key.Outbound_Booth__c + key.Secondary_Inspection__c + key.Commercial_Plant_Inspection__c +
                               key.Veterinary__c + key.Commercial_FMCSA__c + key.Outbound_Secondary_Inspection__c + key.Inbound_Secondary_Inspection__c + key.VACIS__c + key.Hazmat_Inspection__c + key.Seizures_Vault__c + key.Bird_Quarantine__c +
                               key.Comm_Aviary_Holding__c + key.Comm_Inbound_Bypass_Lane__c + key.Comm_Outbound_Bypass_Lane__c + key.Large_Inbound_Inspection_Lane__c + key.Large_Outbound_Inspection_Lane__c + key.Inbound_Non_Laden_Inspection__c +
                               key.Outbound_Non_Laden_Inspection__c + key.Comm_Inbound_Truck_Scale__c + key.Comm_Outbound_Truck_Scale__c + key.Comm_Sentri_Lane__c + key.Comm_Hazmat_Lane__c + key.Inbound_Inspection_Lane__c + key.Outbound_Inspection_Lane__c + 
                               key.Comm_Inbound_Exit_Booth__c + key.Comm_Outbound_Exit_Booth__c;
                               
            //POV Sitework calculations
            key.Paving_Default__c = (key.Main_Building__c * Parammap.get('Main BuildingPOV').Site_Veh__c) + (key.Inbound_Auto_Inspection__c * Parammap.get('Inbound Auto Inspection BuildingPOV').Site_Veh__c) + (key.Repatriation_Facility__c * Parammap.get('Repatriation Facility - Study DataPOV').Site_Veh__c) +
                                    (key.Outbound_Auto_Inspection__c * Parammap.get('Outbound Auto Inspection BuildingPOV').Site_Veh__c) + (key.Vehicle_Breakdown__c * Parammap.get('Vehicle Breakdown BuildingPOV').Site_Veh__c) + (key.Kennel__c * Parammap.get('KennelPOV').Site_Veh__c) +
                                    (key.Aviary_Holding__c * Parammap.get('Aviary Holding BuildingPOV').Site_Veh__c) + (key.Central_Plant__c * Parammap.get('Central PlantPOV').Site_Veh__c) + (key.Maintenance__c * Parammap.get('Maintenance BuildingPOV').Site_Veh__c) +
                                    (key.Narcotics_Seizures_Vault__c * Parammap.get('Narcotics Seizures VaultPOV').Site_Veh__c) + (key.Garage__c * Parammap.get('GaragePOV').Site_Veh__c) + (key.Inbound_Bypass_Lane__c * Parammap.get('Bypass Lane Canopy (Inbound)POV').Site_Veh__c) + (key.Outbound_Bypass_Lane__c * Parammap.get('Bypass Lane Canopy (Outbound)POV').Site_Veh__c) +
                                    (key.Inbound_Booth__c * Parammap.get('Booth/Canopy (Inbound)POV').Site_Veh__c) + (key.Outbound_Booth__c * Parammap.get('Booth/Canopy (Outbound)POV').Site_Veh__c) + (key.Secondary_Inspection__c * Parammap.get('Secondary Inspection CanopyPOV').Site_Veh__c) + (key.Inbound_Exit_Booth__c * Parammap.get('Exit Booth/Canopy (Inbound)POV').Site_Veh__c) + 
                                    (key.Outbound_Exit_Booth__c * Parammap.get('Exit Booth/Canopy (Outbound)POV').Site_Veh__c) + (key.Sentri_Inspection_Lane__c * Parammap.get('Sentri Inspection LanePOV').Site_Veh__c) +
                                    (key.Large_Inbound_Booth__c * Parammap.get('Large Booth/Canopy (Inbound)POV').Site_Veh__c) + (key.Large_Outbound_Booth__c * Parammap.get('Large Booth/Canopy (Outbound)POV').Site_Veh__c) + (key.Bus_Drop_Off__c * Parammap.get('Bus Drop Off Canopy - Study DataPOV').Site_Veh__c);
                                    
            key.POV_BAS_Pedestrian_paving_Default__c =  Math.Min((key.Main_Building__c * Parammap.get('Main BuildingPOV').Site_Ped__c),50000) + (key.Inbound_Auto_Inspection__c * Parammap.get('Inbound Auto Inspection BuildingPOV').Site_Ped__c) + (key.Repatriation_Facility__c * Parammap.get('Repatriation Facility - Study DataPOV').Site_Ped__c) +
                                    (key.Outbound_Auto_Inspection__c * Parammap.get('Outbound Auto Inspection BuildingPOV').Site_Ped__c) + (key.Vehicle_Breakdown__c * Parammap.get('Vehicle Breakdown BuildingPOV').Site_Ped__c) + (key.Kennel__c * Parammap.get('KennelPOV').Site_Ped__c) +
                                    (key.Aviary_Holding__c * Parammap.get('Aviary Holding BuildingPOV').Site_Ped__c) + (key.Central_Plant__c * Parammap.get('Central PlantPOV').Site_Ped__c) + (key.Maintenance__c * Parammap.get('Maintenance BuildingPOV').Site_Ped__c) +
                                    (key.Narcotics_Seizures_Vault__c * Parammap.get('Narcotics Seizures VaultPOV').Site_Ped__c) + (key.Garage__c * Parammap.get('GaragePOV').Site_Ped__c) + (key.Inbound_Bypass_Lane__c * Parammap.get('Bypass Lane Canopy (Inbound)POV').Site_Ped__c) + (key.Outbound_Bypass_Lane__c * Parammap.get('Bypass Lane Canopy (Outbound)POV').Site_Ped__c) +
                                    (key.Inbound_Booth__c * Parammap.get('Booth/Canopy (Inbound)POV').Site_Ped__c) + (key.Outbound_Booth__c * Parammap.get('Booth/Canopy (Outbound)POV').Site_Ped__c) + (key.Secondary_Inspection__c * Parammap.get('Secondary Inspection CanopyPOV').Site_Ped__c) + (key.Inbound_Exit_Booth__c * Parammap.get('Exit Booth/Canopy (Inbound)POV').Site_Ped__c) + 
                                    (key.Outbound_Exit_Booth__c * Parammap.get('Exit Booth/Canopy (Outbound)POV').Site_Ped__c) + (key.Sentri_Inspection_Lane__c * Parammap.get('Sentri Inspection LanePOV').Site_Ped__c) +
                                    (key.Large_Inbound_Booth__c * Parammap.get('Large Booth/Canopy (Inbound)POV').Site_Ped__c) + (key.Large_Outbound_Booth__c * Parammap.get('Large Booth/Canopy (Outbound)POV').Site_Ped__c) + (key.Bus_Drop_Off__c * Parammap.get('Bus Drop Off Canopy - Study DataPOV').Site_Ped__c);
                                    
            dblPOVelements = ((key.Main_Building_Default__c  + key.Inbound_Auto_Inspection_Default__c + key.Repatriation_Facility_Default__c + key.Outbound_Auto_Inspection_Default__c  + key.Vehicle_Breakdown_Default__c  + key.Kennel_Default__c +
                                           key.Aviary_Holding_Default__c + key.Central_Plant_Default__c + key.Maintenance_Default__c + key.Narcotics_Seizures_Vault_Default__c  + key.Garage_Default__c)*0.7);
            
            if(dblPOVelements < (325/2)){
                key.POV_elements_Default__c = 0;
            }else if(dblPOVelements < (325*3/2)){
                key.POV_elements_Default__c = 325;
            }else{
                key.POV_elements_Default__c = Math.Round(dblPOVelements/325)*325;
            } 
            
            if((key.Number_of_Lanes__c/3) < 1){
                dblpovprimaryroadways  = 0;  
            }else if((key.Number_of_Lanes__c/3) < 3){   
                dblpovprimaryroadways = 2;
            }else{
                dblpovprimaryroadways = Math.round((key.Number_of_Lanes__c/3)/2) * 2;
            }    
             
            if(key.Number_of_Lanes__c  == 0){                               
                key.POV_Primary_roadways_Default__c = 0;
                key.Site_Cir_POV_Pedestrian_paving_Default__c = 0;
            }else{
                key.POV_Primary_roadways_Default__c = Math.Max(2, Math.Min(12, dblpovprimaryroadways)) * Math.Round(Math.Max(POVPortDepth,CommPortDepth)) * 14;
                key.Site_Cir_POV_Pedestrian_paving_Default__c = (Math.Round(Math.Max(POVPortDepth,CommPortDepth))*10) + (key.Number_of_Lanes__c * 1200);
            }  
            
            key.POV_Internal_roads_Default__c = key.Number_of_Lanes__c * 6000;   
            
            //Commercial Sitework calculations
            key.Vehicular_paving_Default__c = (key.Comm_Inbound_Bypass_Lane__c * Parammap.get('Bypass Lane Canopy (Inbound)Commercial').Site_Veh__c) + (key.Comm_Outbound_Bypass_Lane__c * Parammap.get('Bypass Lane Canopy (Outbound)Commercial').Site_Veh__c) + 
                                    (key.Inbound_Inspection_Lane__c * Parammap.get('Inspection Lane Canopy (Inbound)Commercial').Site_Veh__c) + (key.Outbound_Inspection_Lane__c * Parammap.get('Inspection Lane Canopy (Outbound)Commercial').Site_Veh__c) + (key.Large_Inbound_Inspection_Lane__c * Parammap.get('Large Inspection Lane Canopy (Inbound)Commercial').Site_Veh__c) +
                                    (key.Large_Outbound_Inspection_Lane__c * Parammap.get('Large Inspection Lane Canopy (Outbound)Commercial').Site_Veh__c) + (key.Inbound_Non_Laden_Inspection__c * Parammap.get('Non-Laden Inspection Canopy (Inbound)Commercial').Site_Veh__c) + (key.Outbound_Non_Laden_Inspection__c * Parammap.get('Non-Laden Inspection Canopy (Outbound)Commercial').Site_Veh__c) +
                                    (key.Comm_Inbound_Truck_Scale__c * Parammap.get('Truck Scale Canopy (Inbound)Commercial').Site_Veh__c) + (key.Comm_Outbound_Truck_Scale__c * Parammap.get('Truck Scale Canopy (Outbound)Commercial').Site_Veh__c) + (key.Comm_Inbound_Exit_Booth__c * Parammap.get('Exit Booth (Inbound)Commercial').Site_Veh__c) + (key.Comm_Outbound_Exit_Booth__c * Parammap.get('Exit Booth (Outbound)Commercial').Site_Veh__c) +
                                    (key.Comm_Sentri_Lane__c * Parammap.get('Sentri Lane CanopyCommercial').Site_Veh__c) + (key.Comm_Hazmat_Lane__c * Parammap.get('Hazmat Lane CanopyCommercial').Site_Veh__c) + (key.Outbound_Secondary_Inspection__c * Parammap.get('Outbound Secondary Inspection FacilityCommercial').Site_Veh__c) +
                                    (key.Inbound_Secondary_Inspection__c * Parammap.get('Inbound Secondary Inspection FacilityCommercial').Site_Veh__c) + (key.VACIS__c * Parammap.get('VACIS BuildingCommercial').Site_Veh__c) +
                                    (key.Hazmat_Inspection__c * Parammap.get('Hazmat Inspection FacilityCommercial').Site_Veh__c) + (key.Bird_Quarantine__c * Parammap.get('Bird Quarantine BuildingCommercial').Site_Veh__c) +
                                    (key.Seizures_Vault__c * Parammap.get('Seizures VaultCommercial').Site_Veh__c) + (key.Comm_Aviary_Holding__c * Parammap.get('Aviary Holding BuildingCommercial').Site_Veh__c) ;
            
            
             dblcommelementsdefault = (key.Commercial_Plant_Inspection_Default__c + key.Veterinary_Default__c + key.Commercial_FMCSA_Default__c + key.Outbound_Secondary_Inspection_Default__c + 
                                                            key.Inbound_Secondary_Inspection_Default__c + key.VACIS_Default__c + key.Hazmat_Inspection_Default__c + key.Seizures_Vault_Default__c + key.Bird_Quarantine_Default__c +
                                                            key.Comm_Aviary_Holding_Default__c)* 0.3; 
                                                            
            if(dblcommelementsdefault < (325/2)){
                key.Commercial_elements_Default__c = 0;
            }else if (dblcommelementsdefault < (325*3/2)){
                key.Commercial_elements_Default__c = 325;
            }else {
                key.Commercial_elements_Default__c = Math.Round(dblcommelementsdefault/325)*325;
            }                                                
            
            if((key.Comm_Number_of_Lanes__c/4) < 1){
                dblcommprimaryroadways  = 0;  
            }else if((key.Comm_Number_of_Lanes__c/4) < 3){  
                dblcommprimaryroadways = 2;
            }else{
                dblcommprimaryroadways = Math.round((key.Comm_Number_of_Lanes__c/4)/2) * 2;
            }                       
                               
            if(key.Comm_Number_of_Lanes__c  == 0){  
                key.Comm_Primary_roadways_Default__c = 0;
                key.Site_Cir_Comm_Pedestrian_paving_Default__c = 0;
            }else{
                key.Comm_Primary_roadways_Default__c = Math.Max(2, Math.Min(12, dblcommprimaryroadways)) * Math.Round(Math.Max(POVPortDepth,CommPortDepth)) * 14;
                key.Site_Cir_Comm_Pedestrian_paving_Default__c = (Math.Round(Math.Max(POVPortDepth,CommPortDepth))*10) + (key.Comm_Number_of_Lanes__c * 300);
            }
            key.Comm_Internal_roads_Default__c = key.Comm_Number_of_Lanes__c * 9000;
                                
            if(trigger.isinsert){
                key.Paving__c = key.Paving_Default__c;
                key.POV_BAS_Pedestrian_paving__c = key.POV_BAS_Pedestrian_paving_Default__c;
                key.POV_elements__c = key.POV_elements_Default__c;
                key.POV_Primary_roadways__c = key.POV_Primary_roadways_Default__c ;
                key.POV_Internal_roads__c = key.POV_Internal_roads_Default__c;
                key.Site_Cir_POV_Pedestrian_paving__c = key.Site_Cir_POV_Pedestrian_paving_Default__c;
                //Commercial
                key.Vehicular_paving__c = key.Vehicular_paving_Default__c;
                key.Commercial_elements__c   = key.Commercial_elements_Default__c;
                key.Comm_Primary_roadways__c = key.Comm_Primary_roadways_Default__c;
                key.Site_Cir_Comm_Pedestrian_paving__c = key.Site_Cir_Comm_Pedestrian_paving_Default__c;
                key.Comm_Internal_roads__c = key.Comm_Internal_roads_Default__c;
                
            }   
            if(trigger.isupdate){
                if(triggerOldmap.get(key.id).Number_of_Lanes__c != key.Number_of_Lanes__c){
                    key.Paving__c = key.Paving_Default__c;
                    key.POV_BAS_Pedestrian_paving__c = key.POV_BAS_Pedestrian_paving_Default__c;
                    key.POV_elements__c = key.POV_elements_Default__c;
                    key.POV_Primary_roadways__c = key.POV_Primary_roadways_Default__c ;
                    key.POV_Internal_roads__c = key.POV_Internal_roads_Default__c;
                    key.Site_Cir_POV_Pedestrian_paving__c = key.Site_Cir_POV_Pedestrian_paving_Default__c;
                } 
                if(triggerOldmap.get(key.id).Comm_Number_of_Lanes__c != key.Comm_Number_of_Lanes__c){
                    key.Vehicular_paving__c = key.Vehicular_paving_Default__c;
                    key.Commercial_elements__c   = key.Commercial_elements_Default__c;
                    key.Comm_Primary_roadways__c = key.Comm_Primary_roadways_Default__c;
                    key.Site_Cir_Comm_Pedestrian_paving__c = key.Site_Cir_Comm_Pedestrian_paving_Default__c;
                    key.Comm_Internal_roads__c = key.Comm_Internal_roads_Default__c;
                }
            }  
            
            key.POV_Core_Area_Default__c = Math.Min(((key.Acreage__c * 43560)- (key.Main_Building__c + key.Inbound_Auto_Inspection__c + key.Repatriation_Facility__c  + key.Outbound_Auto_Inspection__c + key.Vehicle_Breakdown__c + key.Kennel__c + key.Aviary_Holding__c +
                                            key.Central_Plant__c + key.Maintenance__c + key.Narcotics_Seizures_Vault__c + key.Garage__c) - (key.Paving__c + key.POV_BAS_Pedestrian_paving__c + key.POV_elements__c + key.POV_Primary_roadways__c + key.POV_Internal_roads__c +
                                            key.Site_Cir_POV_Pedestrian_paving__c))*0.85,(key.Main_Building__c + key.Inbound_Auto_Inspection__c + key.Repatriation_Facility__c  + key.Outbound_Auto_Inspection__c + key.Vehicle_Breakdown__c + key.Kennel__c + key.Aviary_Holding__c +
                                            key.Central_Plant__c + key.Maintenance__c + key.Narcotics_Seizures_Vault__c + key.Garage__c)*1.5); 
                                            
            key.Comm_Core_Area_Default__c = Math.Min(((key.Comm_Acreage__c * 43560)- (key.Commercial_Plant_Inspection__c + key.Veterinary__c + key.Commercial_FMCSA__c  + key.Outbound_Secondary_Inspection__c + key.Inbound_Secondary_Inspection__c + key.VACIS__c +
                                            key.Hazmat_Inspection__c + key.Seizures_Vault__c + key.Bird_Quarantine__c + key.Comm_Aviary_Holding__c) - (key.Vehicular_paving__c + key.Commercial_elements__c + key.Comm_Primary_roadways__c + key.Site_Cir_Comm_Pedestrian_paving__c +
                                            key.Comm_Internal_roads__c))*0.85,(key.Commercial_Plant_Inspection__c + key.Veterinary__c + key.Commercial_FMCSA__c  + key.Outbound_Secondary_Inspection__c + key.Inbound_Secondary_Inspection__c + key.VACIS__c +
                                            key.Hazmat_Inspection__c + key.Seizures_Vault__c + key.Bird_Quarantine__c + key.Comm_Aviary_Holding__c)*1.5);                                                                      
                               
            if(trigger.isinsert){
                key.POV_Core_Area__c = key.POV_Core_Area_Default__c;
                key.Comm_Core_Area__c = key.Comm_Core_Area_Default__c;
            }
            if(trigger.isupdate){
                if(triggerOldmap.get(key.id).Number_of_Lanes__c != key.Number_of_Lanes__c){
                    key.POV_Core_Area__c = key.POV_Core_Area_Default__c;
                }
                if(triggerOldmap.get(key.id).Comm_Number_of_Lanes__c != key.Comm_Number_of_Lanes__c){
                    key.Comm_Core_Area__c = key.Comm_Core_Area_Default__c;
                }   
            }   
            
            key.POV_Peripheral__c = (key.Acreage__c * 43560)- (key.Paving__c + key.POV_BAS_Pedestrian_paving__c + key.POV_elements__c + key.POV_Primary_roadways__c + key.POV_Internal_roads__c +
                                    key.Site_Cir_POV_Pedestrian_paving__c + key.POV_Core_Area__c) - (key.Main_Building__c + key.Inbound_Auto_Inspection__c + key.Repatriation_Facility__c  + key.Outbound_Auto_Inspection__c) 
                                    - (key.Vehicle_Breakdown__c + key.Kennel__c + key.Aviary_Holding__c + key.Central_Plant__c + key.Maintenance__c + key.Narcotics_Seizures_Vault__c + key.Garage__c);
            key.Comm_Peripheral__c = (key.Comm_Acreage__c * 43560)- (key.Vehicular_paving__c + key.Commercial_elements__c + key.Comm_Primary_roadways__c + key.Site_Cir_Comm_Pedestrian_paving__c +
                                            key.Comm_Internal_roads__c + key.Comm_Core_Area__c) - (key.Commercial_Plant_Inspection__c + key.Veterinary__c + key.Commercial_FMCSA__c) 
                                    - (key.Outbound_Secondary_Inspection__c + key.Inbound_Secondary_Inspection__c + key.VACIS__c + key.Hazmat_Inspection__c + key.Seizures_Vault__c + key.Bird_Quarantine__c + key.Comm_Aviary_Holding__c);
            
            key.Total_Site_Area__c = key.Paving__c + key.POV_BAS_Pedestrian_paving__c + key.POV_elements__c + key.POV_Primary_roadways__c + key.POV_Internal_roads__c  + key.Comm_Internal_roads__c + 
                                     key.Site_Cir_POV_Pedestrian_paving__c +  key.Vehicular_paving__c + key.Commercial_elements__c + key.Comm_Primary_roadways__c + key.Site_Cir_Comm_Pedestrian_paving__c +                                                                   
                                     key.POV_Core_Area__c + key.Comm_Core_Area__c + key.POV_Peripheral__c + key.Comm_Peripheral__c;
                                     
            ProjectSpacePlanMap.put(key.project_name__c,key);
            
        }
        
        //for updating LPOE Cost Summary
        list<NCMT_LPOE_Cost_Summary__c> lpoeCostSummaryListToUpdate = new list<NCMT_LPOE_Cost_Summary__c>();
                
        for(NCMT_LPOE_Cost_Summary__c objCostSummaryRecord : [Select id, POV_SF__c, Cost_Category_Description__c, Core_Shell_Unit_Cost__c, Commercial_SF__c, Core_Shell_Cost__c, TI_Cost__c,TI_Unit_Cost__c, Security_Cost__c,
                                                                    Security_Unit_Cost__c
                                                                From NCMT_LPOE_Cost_Summary__c where Project_Name__c = :ProjectRecordID]){
            LPOE_Space_Plan__c temp = projectSpacePlanMap.get(ProjectRecordID);
            Decimal dblsizefactor = 0, dblsizefactor1 = 0;
            
            if(temp.Main_Building__c < 150000 && temp.Main_Building__c >=0){
                dblsizefactor = (0.000000005 * ((temp.Main_Building__c).pow(2)))- (0.0014 * temp.Main_Building__c) + 99;
            }else{
                dblsizefactor = 0;
            }
            system.debug('dblsizefactor===='+dblsizefactor);
            if(temp.Inbound_Auto_Inspection__c < 40000 && temp.Inbound_Auto_Inspection__c >=0){
                dblsizefactor1 = (0.00000003 * ((temp.Inbound_Auto_Inspection__c).pow(2)))- (0.0034 * temp.Inbound_Auto_Inspection__c) + 70;
            }else{
                dblsizefactor1 = 0;
            }
            
            if(objCostSummaryRecord.Cost_Category_Description__c == 'Main Building'){
                objCostSummaryRecord.POV_SF__c = temp.Main_Building__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Main_Building__c * (objCostSummaryRecord.Core_Shell_Unit_Cost__c + dblsizefactor));
                objCostSummaryRecord.TI_Cost__c = (temp.Main_Building__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Main_Building__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Inbound Auto Inspection Building'){
                objCostSummaryRecord.POV_SF__c = temp.Inbound_Auto_Inspection__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Inbound_Auto_Inspection__c * (objCostSummaryRecord.Core_Shell_Unit_Cost__c + dblsizefactor1));
                objCostSummaryRecord.TI_Cost__c = (temp.Inbound_Auto_Inspection__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Inbound_Auto_Inspection__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Repatriation Facility'){
                objCostSummaryRecord.POV_SF__c = temp.Repatriation_Facility__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Repatriation_Facility__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Repatriation_Facility__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Repatriation_Facility__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Outbound Auto Inspection Building'){
                objCostSummaryRecord.POV_SF__c = temp.Outbound_Auto_Inspection__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Outbound_Auto_Inspection__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Outbound_Auto_Inspection__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Outbound_Auto_Inspection__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Plant Inspection Building'){
                objCostSummaryRecord.Commercial_SF__c = temp.Commercial_Plant_Inspection__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Commercial_Plant_Inspection__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Commercial_Plant_Inspection__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Commercial_Plant_Inspection__c * objCostSummaryRecord.Security_Unit_Cost__c); 
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Veterinary Building'){
                objCostSummaryRecord.Commercial_SF__c = temp.Veterinary__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Veterinary__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Veterinary__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Veterinary__c * objCostSummaryRecord.Security_Unit_Cost__c);  
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial FMCSA Building'){
                objCostSummaryRecord.Commercial_SF__c = temp.Commercial_FMCSA__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Commercial_FMCSA__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Commercial_FMCSA__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Commercial_FMCSA__c * objCostSummaryRecord.Security_Unit_Cost__c);    
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'POV Inbound Bypass Lane Canopy'){
                objCostSummaryRecord.POV_SF__c = temp.Inbound_Bypass_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Inbound_Bypass_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Inbound_Bypass_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Inbound_Bypass_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c); 
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'POV Outbound Bypass Lane Canopy'){
                objCostSummaryRecord.POV_SF__c = temp.Outbound_Bypass_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Outbound_Bypass_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Outbound_Bypass_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Outbound_Bypass_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c);    
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'POV Inbound Booth/Canopy'){
                objCostSummaryRecord.POV_SF__c = temp.Inbound_Booth__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Inbound_Booth__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Inbound_Booth__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Inbound_Booth__c * objCostSummaryRecord.Security_Unit_Cost__c);   
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'POV Outbound Booth/Canopy'){
                objCostSummaryRecord.POV_SF__c = temp.Outbound_Booth__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Outbound_Booth__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Outbound_Booth__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Outbound_Booth__c * objCostSummaryRecord.Security_Unit_Cost__c);  
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'POV Secondary Inspection Canopy'){
                objCostSummaryRecord.POV_SF__c = temp.Secondary_Inspection__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Secondary_Inspection__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Secondary_Inspection__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Secondary_Inspection__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'POV Inbound Exit Booth/Canopy'){
                objCostSummaryRecord.POV_SF__c = temp.Inbound_Exit_Booth__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Inbound_Exit_Booth__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Inbound_Exit_Booth__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Inbound_Exit_Booth__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'POV Outbound Exit Booth/Canopy'){
                objCostSummaryRecord.POV_SF__c = temp.Outbound_Exit_Booth__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Outbound_Exit_Booth__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Outbound_Exit_Booth__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Outbound_Exit_Booth__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'POV Sentri Inspection Lane'){
                objCostSummaryRecord.POV_SF__c = temp.Sentri_Inspection_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Sentri_Inspection_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Sentri_Inspection_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Sentri_Inspection_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Large POV Inbound Booth/Canopy'){
                objCostSummaryRecord.POV_SF__c = temp.Large_Inbound_Booth__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Large_Inbound_Booth__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Large_Inbound_Booth__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Large_Inbound_Booth__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Large POV Outbound Booth/Canopy'){
                objCostSummaryRecord.POV_SF__c = temp.Large_Outbound_Booth__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Large_Outbound_Booth__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Large_Outbound_Booth__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Large_Outbound_Booth__c * objCostSummaryRecord.Security_Unit_Cost__c);    
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Bus Drop Off Canopy'){
                objCostSummaryRecord.POV_SF__c = temp.Bus_Drop_Off__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Bus_Drop_Off__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Bus_Drop_Off__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Bus_Drop_Off__c * objCostSummaryRecord.Security_Unit_Cost__c);                                                    
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Inbound Bypass Lane Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Inbound_Bypass_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Comm_Inbound_Bypass_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Comm_Inbound_Bypass_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Comm_Inbound_Bypass_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Outbound Bypass Lane Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Outbound_Bypass_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Comm_Outbound_Bypass_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Comm_Outbound_Bypass_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Comm_Outbound_Bypass_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Inbound Inspection Lane Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Inbound_Inspection_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Inbound_Inspection_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Inbound_Inspection_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Inbound_Inspection_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Outbound Inspection Lane Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Outbound_Inspection_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Outbound_Inspection_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Outbound_Inspection_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Outbound_Inspection_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Large Commercial Inbound Inspection Lane Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Large_Inbound_Inspection_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Large_Inbound_Inspection_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Large_Inbound_Inspection_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Large_Inbound_Inspection_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Large Commercial Outbound Inspection Lane Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Large_Outbound_Inspection_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Large_Outbound_Inspection_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Large_Outbound_Inspection_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Large_Outbound_Inspection_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commerical Inbound Non-Laden Inspection Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Inbound_Non_Laden_Inspection__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Inbound_Non_Laden_Inspection__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Inbound_Non_Laden_Inspection__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Inbound_Non_Laden_Inspection__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commerical Outbound Non-Laden Inspection Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Outbound_Non_Laden_Inspection__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Outbound_Non_Laden_Inspection__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Outbound_Non_Laden_Inspection__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Outbound_Non_Laden_Inspection__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Inbound Truck Scale Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Inbound_Truck_Scale__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Comm_Inbound_Truck_Scale__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Comm_Inbound_Truck_Scale__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Comm_Inbound_Truck_Scale__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Outbound Truck Scale Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Outbound_Truck_Scale__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Comm_Outbound_Truck_Scale__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Comm_Outbound_Truck_Scale__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Comm_Outbound_Truck_Scale__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Inbound Exit Booth'){
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Inbound_Exit_Booth__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Comm_Inbound_Exit_Booth__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Comm_Inbound_Exit_Booth__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Comm_Inbound_Exit_Booth__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Outbound Exit Booth'){
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Outbound_Exit_Booth__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Comm_Outbound_Exit_Booth__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Comm_Outbound_Exit_Booth__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Comm_Outbound_Exit_Booth__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Sentri Lane Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Sentri_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Comm_Sentri_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Comm_Sentri_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Comm_Sentri_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Hazmat Lane Canopy'){
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Hazmat_Lane__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Comm_Hazmat_Lane__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Comm_Hazmat_Lane__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Comm_Hazmat_Lane__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Vehicle Breakdown Building'){
                objCostSummaryRecord.POV_SF__c = temp.Vehicle_Breakdown__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Vehicle_Breakdown__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Vehicle_Breakdown__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Vehicle_Breakdown__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Kennel'){
                objCostSummaryRecord.POV_SF__c = temp.Kennel__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Kennel__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Kennel__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Kennel__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Aviary Holding Building'){
                objCostSummaryRecord.POV_SF__c = temp.Aviary_Holding__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Aviary_Holding__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Aviary_Holding__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Aviary_Holding__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Central Plant'){
                objCostSummaryRecord.POV_SF__c = temp.Central_Plant__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Central_Plant__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Central_Plant__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Central_Plant__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Maintenance Building'){
                objCostSummaryRecord.POV_SF__c = temp.Maintenance__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Maintenance__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Maintenance__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Maintenance__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'POV Narcotics Seizures Vault'){
                objCostSummaryRecord.POV_SF__c = temp.Narcotics_Seizures_Vault__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Narcotics_Seizures_Vault__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Narcotics_Seizures_Vault__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Narcotics_Seizures_Vault__c * objCostSummaryRecord.Security_Unit_Cost__c);        
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Outbound Commercial Secondary Inspection Facility'){
                objCostSummaryRecord.Commercial_SF__c = temp.Outbound_Secondary_Inspection__c;  
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Outbound_Secondary_Inspection__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Outbound_Secondary_Inspection__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Outbound_Secondary_Inspection__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Inbound Commercial Secondary Inspection Facility'){
                objCostSummaryRecord.Commercial_SF__c = temp.Inbound_Secondary_Inspection__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Inbound_Secondary_Inspection__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Inbound_Secondary_Inspection__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Inbound_Secondary_Inspection__c * objCostSummaryRecord.Security_Unit_Cost__c);    
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial VACIS Building'){
                objCostSummaryRecord.Commercial_SF__c = temp.VACIS__c;  
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.VACIS__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.VACIS__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.VACIS__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Hazmat Inspection Facility'){
                objCostSummaryRecord.Commercial_SF__c = temp.Hazmat_Inspection__c;  
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Hazmat_Inspection__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Hazmat_Inspection__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Hazmat_Inspection__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Bird Quarantine Building'){
                objCostSummaryRecord.Commercial_SF__c = temp.Bird_Quarantine__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Bird_Quarantine__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Bird_Quarantine__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Bird_Quarantine__c * objCostSummaryRecord.Security_Unit_Cost__c); 
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Seizures Vault'){
                objCostSummaryRecord.Commercial_SF__c = temp.Seizures_Vault__c; 
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Seizures_Vault__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Seizures_Vault__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Seizures_Vault__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Aviary Holding Building'){
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Aviary_Holding__c;    
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Comm_Aviary_Holding__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Comm_Aviary_Holding__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Comm_Aviary_Holding__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Garage'){
                objCostSummaryRecord.POV_SF__c = temp.Garage__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Garage__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Garage__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Garage__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'POV Paving'){
                objCostSummaryRecord.POV_SF__c = temp.Paving__c;    
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Paving__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Paving__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Paving__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Commercial Vehicular Paving'){
                objCostSummaryRecord.Commercial_SF__c = temp.Vehicular_paving__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Vehicular_paving__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Vehicular_paving__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Vehicular_paving__c * objCostSummaryRecord.Security_Unit_Cost__c);    
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Pedestrian Paving'){
                objCostSummaryRecord.POV_SF__c = temp.POV_BAS_Pedestrian_paving__c; 
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.POV_BAS_Pedestrian_paving__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.POV_BAS_Pedestrian_paving__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.POV_BAS_Pedestrian_paving__c * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Site Parking - POV Elements'){
                objCostSummaryRecord.POV_SF__c = temp.POV_elements__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.POV_elements__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.POV_elements__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.POV_elements__c * objCostSummaryRecord.Security_Unit_Cost__c);    
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Site Parking - Commercial Elements'){
                objCostSummaryRecord.Commercial_SF__c = temp.Commercial_elements__c;
                objCostSummaryRecord.Core_Shell_Cost__c = (temp.Commercial_elements__c * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = (temp.Commercial_elements__c * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = (temp.Commercial_elements__c * objCostSummaryRecord.Security_Unit_Cost__c); 
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Site Circulation - Primary Roadways'){
                objCostSummaryRecord.POV_SF__c = temp.POV_Primary_roadways__c;  
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Primary_roadways__c;
                objCostSummaryRecord.Core_Shell_Cost__c = ((temp.POV_Primary_roadways__c + temp.Comm_Primary_roadways__c) * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = ((temp.POV_Primary_roadways__c + temp.Comm_Primary_roadways__c) * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = ((temp.POV_Primary_roadways__c + temp.Comm_Primary_roadways__c) * objCostSummaryRecord.Security_Unit_Cost__c);
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Site Circulation - Internal Roads'){
                objCostSummaryRecord.POV_SF__c = temp.POV_Internal_roads__c;
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Internal_roads__c;
                objCostSummaryRecord.Core_Shell_Cost__c = ((temp.POV_Internal_roads__c + temp.Comm_Internal_roads__c) * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = ((temp.POV_Internal_roads__c + temp.Comm_Internal_roads__c) * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = ((temp.POV_Internal_roads__c + temp.Comm_Internal_roads__c) * objCostSummaryRecord.Security_Unit_Cost__c);  
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Site Circulation - Pedestrian Paving'){
                objCostSummaryRecord.POV_SF__c = temp.Site_Cir_POV_Pedestrian_paving__c;
                objCostSummaryRecord.Commercial_SF__c = temp.Site_Cir_Comm_Pedestrian_paving__c;  
                objCostSummaryRecord.Core_Shell_Cost__c = ((temp.Site_Cir_POV_Pedestrian_paving__c + temp.Site_Cir_Comm_Pedestrian_paving__c) * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = ((temp.Site_Cir_POV_Pedestrian_paving__c + temp.Site_Cir_Comm_Pedestrian_paving__c) * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = ((temp.Site_Cir_POV_Pedestrian_paving__c + temp.Site_Cir_Comm_Pedestrian_paving__c)* objCostSummaryRecord.Security_Unit_Cost__c);           
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Site Landscaping - Core Area'){
                objCostSummaryRecord.POV_SF__c = temp.POV_Core_Area__c;
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Core_Area__c;       
                objCostSummaryRecord.Core_Shell_Cost__c = ((temp.Comm_Core_Area__c + temp.POV_Core_Area__c) * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = ((temp.Comm_Core_Area__c + temp.POV_Core_Area__c) * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = ((temp.Comm_Core_Area__c + temp.POV_Core_Area__c) * objCostSummaryRecord.Security_Unit_Cost__c);        
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Site Landscaping - Peripheral'){
                objCostSummaryRecord.POV_SF__c = temp.POV_Peripheral__c;
                objCostSummaryRecord.Commercial_SF__c = temp.Comm_Peripheral__c; 
                objCostSummaryRecord.Core_Shell_Cost__c = ((temp.POV_Peripheral__c + temp.Comm_Peripheral__c) * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = ((temp.POV_Peripheral__c + temp.Comm_Peripheral__c) * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = ((temp.POV_Peripheral__c + temp.Comm_Peripheral__c) * objCostSummaryRecord.Security_Unit_Cost__c);                                                                                                                                                                                      
            }else if(objCostSummaryRecord.Cost_Category_Description__c == 'Site Utilities'){
                objCostSummaryRecord.POV_SF__c = 0;
                objCostSummaryRecord.Commercial_SF__c = 0; 
                objCostSummaryRecord.Core_Shell_Cost__c = ((temp.Acreage__c + temp.Comm_Acreage__c) * objCostSummaryRecord.Core_Shell_Unit_Cost__c);
                objCostSummaryRecord.TI_Cost__c = ((temp.Acreage__c + temp.Comm_Acreage__c) * objCostSummaryRecord.TI_Unit_Cost__c);
                objCostSummaryRecord.Security_Cost__c = ((temp.Acreage__c + temp.Comm_Acreage__c) * objCostSummaryRecord.Security_Unit_Cost__c);                                                                                                                                                                                    
            }else{
                objCostSummaryRecord.POV_SF__c = 0;
                objCostSummaryRecord.Commercial_SF__c = 0;
            }
            
            lpoeCostSummaryListToUpdate.add(objCostSummaryRecord);
        }
        if(lpoeCostSummaryListToUpdate != null && lpoeCostSummaryListToUpdate.size() > 0)
        update lpoeCostSummaryListToUpdate;
    }
    
    public static void UpdateProjectData(List<LPOE_Space_Plan__c> LPOESpacePlanList, Map<String,NCMT_Project__c> ncmtMap) {
        
        Integer intGSF_10000;   
        Integer intGSF_25000;
        Integer intGSF_50000;
        Integer intGSF_100000;
        Integer intGSF_150000;
        Integer intGSF_250000;
        Integer intGSF_500000;
        Integer intGSF_GT_500000;       
        Decimal ConstructionMonth=0;
        Decimal Total_GSF = 0, Total_LPOE_Site_Area = 0;

        for(LPOE_Space_Plan__c objRecord : LPOESpacePlanList) {
            Total_GSF = objRecord.Total_GSF__c;
            Total_LPOE_Site_Area = objRecord.Total_Site_Area__c;
            
            NCMT_project__c ncmtRec = new NCMT_Project__c();
            ncmtRec = ncmtMap.get(objRecord.Project_Name__c);
                
        
        //update Total GSF, Start or End Construction
         IF (Total_GSF > 0) {
                        
                intGSF_10000 = Integer.valueOf(ncmtRec.Building_Height_Parameter__r.GSF_10000__c);
                intGSF_25000 = Integer.valueOf(ncmtRec.Building_Height_Parameter__r.GSF_25000__c );
                intGSF_50000 = Integer.valueOf(ncmtRec.Building_Height_Parameter__r.GSF_50000__c );
                intGSF_100000 = Integer.valueOf(ncmtRec.Building_Height_Parameter__r.GSF_100000__c );
                intGSF_150000 = Integer.valueOf(ncmtRec.Building_Height_Parameter__r.GSF_150000__c );
                intGSF_250000 = Integer.valueOf(ncmtRec.Building_Height_Parameter__r.GSF_250000__c );
                intGSF_500000 = Integer.valueOf(ncmtRec.Building_Height_Parameter__r.GSF_500000__c );
                intGSF_GT_500000 = Integer.valueOf(ncmtRec.Building_Height_Parameter__r.GSF_GT_500000__c );
                
                ncmtRec.Total_GSF__c = Total_GSF;
                ncmtRec.Total_LPOE_Site_Area_SF__c = Total_LPOE_Site_Area;
                
                //update End or Start Construction Building Type other than Parking Garage
               IF (Total_GSF < 10000 ) {
                   ConstructionMonth = intGSF_10000;
               } 
               ELSE IF (Total_GSF >= 10000 && Total_GSF < 25000) {
                   ConstructionMonth = intGSF_25000;
               }    
               ELSE IF (Total_GSF >= 25000 && Total_GSF < 50000) {
                   ConstructionMonth = intGSF_50000;
               } 
               ELSE IF (Total_GSF >= 50000 && Total_GSF < 100000) {
                   ConstructionMonth = intGSF_100000;
               } 
               ELSE IF (Total_GSF >= 100000 && Total_GSF < 150000) {
                   ConstructionMonth = intGSF_150000;
               } 
               ELSE IF (Total_GSF >= 150000 && Total_GSF < 250000) {
                   ConstructionMonth = intGSF_250000;
               } 
               ELSE IF (Total_GSF >= 250000 && Total_GSF < 500000) {
                   ConstructionMonth = intGSF_500000;
               } 
               ELSE IF (Total_GSF >= 500000 ) {
                   ConstructionMonth = intGSF_GT_500000;
               } 
               if (ConstructionMonth == null) {
                    ConstructionMonth = 0;
               }
               //If (ConstructionMonth <> 0 && ConstructionMonth <> NULL) {
               //    ConstructionMonth = (ConstructionMonth * 30.2)/2;
               //}
               IF (ncmtRec.Start_Construction__c <> null) {
                    ncmtRec.End_Construction__c = ncmtRec.Start_Construction__c.addMonths(Integer.valueOf(ConstructionMonth)) ;   
               }
               ELSE IF (ncmtRec.End_Construction__c <> null) {
                    ncmtRec.Start_Construction__c = ncmtRec.End_Construction__c.addMonths(Integer.valueOf(ConstructionMonth * - 1));
               } 
         
                update ncmtRec;                    
         }
        }
    }
}