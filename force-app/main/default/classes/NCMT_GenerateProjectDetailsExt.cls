public with sharing class NCMT_GenerateProjectDetailsExt {
//SFWS 1774 Solution for line 1593 starts here (Developer: Ozlem Ece)
public static Boolean firstCall=false;
//SFWS 1774 Solution ends here    
    public Double fnUserLevel (string strUserLevel){
        if (strUserLevel == 'Level I' || strUserLevel == 'Office of Portfolio Management - Regular User' || 
            strUserLevel == 'Office of Leasing' || strUserLevel == 'Oversight - Finance Level1'){
            return 1;
        } else if (strUserLevel == 'Level II' || strUserLevel == 'Office of Portfolio Management - Super User' ||
                   strUserLevel == 'Office of Design and Construction - Project Management' ||
                   strUserLevel == 'Office of Design and Construction - Program Management' ||
                   strUserLevel == 'Office of Facility Management - Building Management' || 
                   strUserLevel == 'Oversight - Finance Level2'){
            return 2;
        } else if (strUserLevel == 'Level III OFM' || strUserLevel == 'Level III ODC' ||
                   strUserLevel == 'Office of Design and Construction - Estimating' || 
                   strUserLevel == 'Office of Design and Construction - Quality Control'  ||
                   strUserLevel == 'Oversight - Inspector General' ||
                   strUserLevel == 'Oversight - OMB'){
            return 3;
        } else if (strUserLevel == 'Level IV' || 
                   strUserLevel == 'Office of Design and Construction - Quality Assurance'){
            return 4;
        } else if (strUserLevel == 'Level V' ||
                   strUserLevel == 'Office of Design and Construction - System Administration'){
            return 5;           
        } else {
            return 9;       
        }
    }
    
        
    public void DeleteSecurityData (ID ProjectID) {
        List <NCMT_Security_Detail__c> lstDelete = [select ID from NCMT_Security_Detail__c Where Project_Cost_Summary__r.Project_Name__r.ID = :ProjectID limit 50000] ;
        if(lstDelete.size() > 0) Delete lstDelete;
    }
    
    public void GenerateSecurityData(ID ProjectID, Decimal dblGrossSqFt, String strSecurityLevel, string txtCostParameterDateFY, Map<String,String> mapCostSummary){
        System.debug('CAROLINE DEBUG====='+mapCostSummary);
        String  strSOQL;
        String  StrSOQL1;
        string  strColumnToPick = 'Level_I_Minimum__c';
        Decimal ItemSqFt = 0.0;

        // Refer the Excel Template file to see category breakdowns ...
        // Commented line 45,47 and added line 46 and 48 lines for the story SFWS-1824 to resolve NCMT Security Items "Unit Totals" Issue.
        //Set<string> setAssign0 = new Set <string> {'Biological Filtration - General Building'};
        Set<string> setAssign0 = new Set <string> ();
        //Set<string> setAssign1 = new Set <string> {'Guard Fixed Post - Exterior', 'Control of Parking', 'Entrance Co-location', 'Vehicle Access to Controlled Parking', 'Ballistic Protection at Screening Locations', 'Publicly Accessible Restrooms', 'Security Control Center', 'Guard Fixed Post - Exterior'};
        Set<string> setAssign1 = new Set <string> {'Control of Parking'};
       //Set<string> setAssign2 = new Set <string> {'Occupant Screening'};
        Set<string> setAssign2 = new Set <string> ();
        Set<string> setAssign3 = new Set <string> {'Mail/Package Handling and Other Deliveries'};
        
        Set<string> setAssignCustom1 = new Set <string> {'Pedestrian Access to Site'};
        Set<string> setAssignCustom2 = new Set <string> {'Isolated Ventilation Systems', 'CBR Detection Technology'};
        Set<string> setAssignCustom3 = new Set <string> {'Blast Resistance - Windows'};
        Set<string> setAssignCustom4 = new Set <string> {'Blast Resistance - Façade and Structure'};
        Set<string> setAssignCustom5 = new Set <string> {'Windows in Critical Areas - Ballistic Protection'};
        Set<string> setAssignCustom6 = new Set <string> {'Windows in Critical Areas - Ballistic Protection-2nd Cost'};
        Set<string> setAssignCustom7 = new Set <string> {'Biological Filtration - Lobbies and Mailrooms'};
        Set<string> setAssignCustom8 = new Set <string> {'Chemical Filtration'};
        Set<string> setAssignCustom9 = new Set <string> {'CCTV Coverage'};
        Set<string> setAssignCustom10 = new Set <string> {'Intrusion Detection System (IDS) Coverage'};
        Set<string> setAssignCustom11 = new Set <string> {'Blast Resistance - Progressive Collapse'};
        Decimal dblAssignCustom1 = 0.00;
        Decimal dblAssignCustom2 = 0.00;
        Decimal dblAssignCustom3 = 0.00;
        Decimal dblAssignCustom4 = 0.00;
        Decimal dblAssignCustom5 = 0.00;
        Decimal dblAssignCustom6 = 0.00;
        Decimal dblAssignCustom7 = 0.00;
        Decimal dblAssignCustom8 = 0.00;
        Decimal dblAssignCustom9 = 0.00;
        Decimal dblAssignCustom10 = 0.00;
        Decimal dblblastProgCollapse = 0.00;
        String  struseblastlevel;
        
        //Make sure you have the #s handy for custom strings
        List<Site_Information__c> lstSites = [Select Site_Area_for_Default_Value__c From Site_Information__c Where Project__c = :ProjectID Limit 1];
        for(Site_Information__c objItem : lstSites){
            dblAssignCustom1 = Math.Sqrt((Decimal) objItem.Site_Area_for_Default_Value__c) * 3;
        }
        
        List<NCMT_Housing_Plan_Summary__c> lstHousingPlans = [Select Total_GSF__c, Main_Lobby__c, Atrium_Ground_floor_plan_area__c, Ground_floor_circulation__c, Loading_dock_Recycling_Trash__c From NCMT_Housing_Plan_Summary__c Where Project__c = :ProjectID Limit 1];
        for(NCMT_Housing_Plan_Summary__c objItem : lstHousingPlans){
            dblGrossSqFt = (Decimal) objItem.Total_GSF__c;
            dblAssignCustom2 = (Decimal) objItem.Main_Lobby__c + (Decimal) objItem.Atrium_Ground_floor_plan_area__c + (Decimal) objItem.Ground_floor_circulation__c + (Decimal) objItem.Loading_dock_Recycling_Trash__c;
        }
        
        List<Project_Level_Parameter__c> lstProjectParameters = [Select Curtain_Wall_Percentage_SF__c, Window_Percentage_SF__c, Base_SF__c, Mid_SF__c, Top_SF__c,
                                                                        Use_HEPA_Filtration_Area_served_SF__c, Use_Chemical_Filtration_Area_served_SF__c,Use_Blast_Resistance__c, 
                                                                        Use_CCTV_System_CCTV_Allowance__c, Use_Intrusion_Detection_System_IDS__c, Use_Ballistic_Protection_to_windows__c,
                                                                        Add_Visitor_Access_Control__c, Add_MailRoom_XRay__c 
                                                                   From Project_Level_Parameter__c 
                                                                   Where NCMT_Project__c = :ProjectID Limit 1];
        for(Project_Level_Parameter__c objItem : lstProjectParameters){
            dblAssignCustom3 = (Decimal) objItem.Curtain_Wall_Percentage_SF__c + (Decimal) objItem.Window_Percentage_SF__c;
            dblAssignCustom4 = (Decimal) objItem.Base_SF__c + (Decimal) objItem.Mid_SF__c + (Decimal) objItem.Top_SF__c;
            dblAssignCustom7 = (Decimal) objItem.Use_HEPA_Filtration_Area_served_SF__c;
            dblAssignCustom8 = (Decimal) objItem.Use_Chemical_Filtration_Area_served_SF__c;
            dblAssignCustom9 = (Decimal) objItem.Use_CCTV_System_CCTV_Allowance__c;
            dblAssignCustom10 = (Decimal) objItem.Use_Intrusion_Detection_System_IDS__c;
            struseblastlevel = (string) objItem.Use_Blast_Resistance__c;
        }
        //Make sure you have the #s handy for custom strings
        
        
        /*List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :ProjectID Limit 1000];
        Map<string, String> mapCostSummary = new Map<string, String>();
        for(NCMT_Project_Cost_Summary__c objItem : listCostSummary)
            mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);*/
                        
        //string strFiscalYear = String.ValueOf([SELECT MAX(Fiscal_Year__c) FiscalYear FROM NCMT_Security_Parameters__c][0].get('FiscalYear'));
        //string strFiscalYear = String.ValueOf([SELECT MAX(Cost_Parameter_Date_FY__c) FiscalYear FROM NCMT_Project__c Where ID = :ProjectID][0].get('FiscalYear'));
        string strFiscalYear = txtCostParameterDateFY;
        List<NCMT_Security_Detail__c> objProjectSecurityRecords = New List<NCMT_Security_Detail__c>();
         
        // Pick the Security Parameters that affect this project ...
        if (strSecurityLevel == 'Level II - Low' ){
            strColumnToPick = 'Level_II_Low__c';
        } else if (strSecurityLevel == 'Level III - Medium' ){
            strColumnToPick = 'Level_III_Medium__c';
        } else if (strSecurityLevel == 'Level IV - High'){
            strColumnToPick = 'Level_IV_High__c';
        } else if (strSecurityLevel == 'Level V - Very High'){
            strColumnToPick = 'Level_V_Very_High__c';
        }
        System.debug('CAROLINE DEBUG strColumnToPick====='+strColumnToPick);
        
        // Generate the security parameters for this project ...
        strSOQL =   'Select  ID, Security_Criterion__c, Cost_Description__c, ' + strColumnToPick + ' ' +  
                    'From    NCMT_Security_Parameters__c ' + ' ' +   
                    'Where   Fiscal_Year__c = :strFiscalYear ' +  
                    'And     (' + strColumnToPick + ' > 0 OR Security_Criterion__c = :setAssignCustom11)' +   
                    'Order by Name ';
        //system.debug('MyDebug0824-strSOQL====' + strSOQL);
        //system.debug('strFiscalYear'+ strFiscalYear);
        
        StrSOQL1 =   'Select  ID, Security_Criterion__c ,Level_I_Minimum__c, Level_II_Low__c, Level_III_Medium__c , Level_IV_High__c , Level_V_Very_High__c'+ ' ' +
                       'From  NCMT_Security_Parameters__c'+ ' ' +    
                       'Where Fiscal_Year__c = :strFiscalYear'+ ' ' +
                       'And   Security_Criterion__c = :setAssignCustom11'; 
        
                  
        List<NCMT_Security_Parameters__c> objSecurityParameters1 = Database.query(StrSOQL1); 
        System.debug('CAROLINE DEBUG objSecurityParameters1====='+objSecurityParameters1);
        
        for(NCMT_Security_Parameters__c objRecord: objSecurityParameters1) {
            System.debug('CAROLINE DEBUG struseblastlevel====='+struseblastlevel);
            if(struseblastlevel == 'Level I - Minimum'){
                dblblastProgCollapse = objRecord.Level_I_Minimum__c; 
            }else if(struseblastlevel == 'Level II - Low'){
                dblblastProgCollapse = objRecord.Level_II_Low__c;
            }else if(struseblastlevel == 'Level III - Medium'){
                dblblastProgCollapse = objRecord.Level_III_Medium__c;
            }else if(struseblastlevel == 'Level IV - High'){
                dblblastProgCollapse = objRecord.Level_IV_High__c;
            }else if(struseblastlevel == 'Level V - Very High'){
                dblblastProgCollapse = objRecord.Level_V_Very_High__c;
            }
        }
        System.debug('CAROLINE DEBUG dblblastProgCollapse====='+dblblastProgCollapse);
                  
        List<NCMT_Security_Parameters__c> objSecurityParameters = Database.query(strSOQL); 
        System.debug('CAROLINE DEBUG objSecurityParameters====='+objSecurityParameters);

        
        for(NCMT_Security_Parameters__c objRecord: objSecurityParameters) {
            System.debug('CAROLINE DEBUG pcs====='+objRecord.Cost_Description__c);
            System.debug('CAROLINE DEBUG pcs====='+mapCostSummary.get(objRecord.Cost_Description__c));

            if (setAssign0.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = 0.0;
            } else if (setAssign1.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = 1.0;
            } else if (setAssign2.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = 1.0; 
            } else if (setAssign3.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = 1.0; 
            } else if (setAssignCustom1.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = dblAssignCustom1;
            } else if (setAssignCustom2.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = dblAssignCustom2;
            } else if (setAssignCustom3.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = dblAssignCustom3; 
            } else if (setAssignCustom4.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = dblAssignCustom4; 
            } else if (setAssignCustom5.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = .10 * dblAssignCustom3; 
            } else if (setAssignCustom6.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = .10 * dblAssignCustom4; 
            } else if (setAssignCustom7.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = dblAssignCustom7;
            } else if (setAssignCustom8.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = dblAssignCustom8;
            } else if (setAssignCustom9.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = dblGrossSqFt;
            } else if (setAssignCustom10.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = dblGrossSqFt;    
            } else if (setAssignCustom11.Contains(objRecord.Security_Criterion__c)){
                ItemSqFt = dblGrossSqFt;                            
            } else {    
                ItemSqFt = dblGrossSqFt;
            }
            //system.debug('MyDebug-mapCostSummary.get(objRecord.Cost_Description__c)===='+ mapCostSummary.get(objRecord.Cost_Description__c));
            //system.debug('MyDebug-objRecord.ID===='+ objRecord.ID);
            //system.debug('MyDebug-ItemSqFt===='+ ItemSqFt);
            //system.debug('MyDebug-(Decimal) objRecord.get(strColumnToPick)'+ (Decimal) objRecord.get(strColumnToPick));
            if((setAssign2.Contains(objRecord.Security_Criterion__c) && lstProjectParameters[0].Add_Visitor_Access_Control__c == false)){   
                objProjectSecurityRecords.Add(new NCMT_Security_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Description__c),
                    Security_Parameter__c = objRecord.ID,
                    Gross_Sq_Ft__c = ItemSqFt * 0 ,
                    Unit_Cost__c = (Decimal) objRecord.get(strColumnToPick)
                ));
            }else if((setAssign3.Contains(objRecord.Security_Criterion__c) && lstProjectParameters[0].Add_MailRoom_XRay__c == false)){  
                objProjectSecurityRecords.Add(new NCMT_Security_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Description__c),
                    Security_Parameter__c = objRecord.ID,
                    Gross_Sq_Ft__c = ItemSqFt ,
                    Unit_Cost__c = (Decimal) objRecord.get(strColumnToPick) - 250000
                ));
            }else if(setAssignCustom9.Contains(objRecord.Security_Criterion__c)){   
                objProjectSecurityRecords.Add(new NCMT_Security_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Description__c),
                    Security_Parameter__c = objRecord.ID,
                    Gross_Sq_Ft__c = ItemSqFt,
                    Unit_Cost__c = dblAssignCustom9
                ));
            }else if(setAssignCustom10.Contains(objRecord.Security_Criterion__c)){  
                objProjectSecurityRecords.Add(new NCMT_Security_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Description__c),
                    Security_Parameter__c = objRecord.ID,
                    Gross_Sq_Ft__c = ItemSqFt,
                    Unit_Cost__c = dblAssignCustom10
                ));
            }else if(setAssignCustom11.Contains(objRecord.Security_Criterion__c)){  
                //system.debug('MyDebug0824-SetAssign11====' + strColumnToPick1);
                objProjectSecurityRecords.Add(new NCMT_Security_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Description__c),
                    Security_Parameter__c = objRecord.ID,
                    Gross_Sq_Ft__c = ItemSqFt,
                    Unit_Cost__c = dblblastProgCollapse
                ));
            }else{
                system.debug('MyDebug0824-SetAssignElse====' + strColumnToPick);
                objProjectSecurityRecords.Add(new NCMT_Security_Detail__c(
                    Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Description__c),
                    Security_Parameter__c = objRecord.ID,
                    Gross_Sq_Ft__c = ItemSqFt,
                    Unit_Cost__c = (Decimal) objRecord.get(strColumnToPick)
                ));
            }
        }
        
        insert objProjectSecurityRecords;
    }

    public void GenerateCostSummary (ID ProjectID, String strProjectType, string strRAEstimateType, string strRASecurity, Decimal dblRASecurityCost){
        Boolean addedNew = GenerateCostSummaries(ProjectID, strProjectType, strRAEstimateType, strRASecurity, dblRASecurityCost, new Set<Id>());
    }
    
    public Boolean GenerateCostSummaries (ID ProjectID, String strProjectType, string strRAEstimateType, string strRASecurity, Decimal dblRASecurityCost, Set<Id> existingCats){
        String  strRecordTypeID;
        List<NCMT_Project_Cost_Summary__c> objCostSummaryRecords = New List<NCMT_Project_Cost_Summary__c>();
        
        if(strProjectType == 'New Construction'){
            strRecordTypeID = Schema.SObjectType.NCMT_Project_Cost_Summary__c.getRecordTypeInfosByName().get('New Construction').getRecordTypeId();
        }else if(strProjectType == 'Repair & Alteration - Parametric Entry'){
            strRecordTypeID = Schema.SObjectType.NCMT_Project_Cost_Summary__c.getRecordTypeInfosByName().get('Repair & Alteration - Parametric Entry').getRecordTypeId();
        }else if(strProjectType == 'Repair & Alteration - Work Item Detail'){
            strRecordTypeID = Schema.SObjectType.NCMT_Project_Cost_Summary__c.getRecordTypeInfosByName().get('Repair & Alteration - Work Item Detail').getRecordTypeId();
        }else if(strProjectType == 'New Construction - DES' || strProjectType == 'Repair & Alteration - DES'){
            strRecordTypeID = Schema.SObjectType.NCMT_Project_Cost_Summary__c.getRecordTypeInfosByName().get('New Construction - DES').getRecordTypeId();
        }else if(strProjectType == 'New Construction - CEW' || strProjectType == 'Repair & Alteration - CEW'){
            strRecordTypeID = Schema.SObjectType.NCMT_Project_Cost_Summary__c.getRecordTypeInfosByName().get('New Construction - CEW').getRecordTypeId();
        }
        Boolean newAdded = false;
        if(strProjectType == 'New Construction - DES' || strProjectType == 'Repair & Alteration - DES' ){
            for (NCMT_Cost_Category__c objRecord : [Select ID, Cost_Category_Type__c,Estimate_Format__c From NCMT_Cost_Category__c where Cost_Category_Type__c in ('Definitive Estimating', 'New Construction') Limit 1000]){
                if (!existingCats.contains(objRecord.Id)){
                    objCostSummaryRecords.Add(new NCMT_Project_Cost_Summary__c(
                    Project_Name__c = ProjectID,
                    Cost_Category_ID__c = objRecord.ID,
                    RecordTypeID = strRecordTypeID
                    ));
                    newAdded = true;
                }
            }  
        }       
        else if(strProjectType == 'Repair & Alteration - Work Item Detail'){
            for (NCMT_Cost_Category__c objRecord : [Select ID, Cost_Category_Type__c From NCMT_Cost_Category__c Where Cost_Category_Type__c = 'Repair & Alteration WI Detail' Limit 1000]){
                if (!existingCats.contains(objRecord.Id)){
                    objCostSummaryRecords.Add(new NCMT_Project_Cost_Summary__c(
                    Project_Name__c = ProjectID,
                    Cost_Category_ID__c = objRecord.ID,
                    RecordTypeID = strRecordTypeID
                    ));
                    newAdded = true;
                }
            }       
        }else{
            for (NCMT_Cost_Category__c objRecord : [Select ID, Cost_Category_Type__c From NCMT_Cost_Category__c Where Cost_Category_Type__c = 'New Construction' Limit 1000]){
                if (!existingCats.contains(objRecord.Id)){
                    objCostSummaryRecords.Add(new NCMT_Project_Cost_Summary__c(
                    Project_Name__c = ProjectID,
                    Cost_Category_ID__c = objRecord.ID,
                    RecordTypeID = strRecordTypeID
                    ));
                    newAdded = true;
                }
            }
            
        }
        
        insert objCostSummaryRecords;
        return newAdded;
    }
    
    public void GenerateLPOECostSummary (ID ProjectID, String strProjectType,string Border, string txtCostParameterDateFY){
        List<NCMT_LPOE_Cost_Summary__c> objLPOECostSummaryRecords = New List<NCMT_LPOE_Cost_Summary__c>();
        for (NCMT_LPOE_Parametric_Cost_Data__c objRecord : [Select ID From NCMT_LPOE_Parametric_Cost_Data__c Where Border_Type__c = :Border and Fiscal_Year__c = :txtCostParameterDateFY Limit 1000]){
                    objLPOECostSummaryRecords.Add(new NCMT_LPOE_Cost_Summary__c(
                    Project_Name__c = ProjectID,
                    Cost_Category_ID__c = objRecord.ID
                    ));
        }
        insert objLPOECostSummaryRecords;
    }
    
    public void GenerateRAPhasing (ID ProjectID, String strProjectType,Date dtCostParameterDate, Date Mid_Construction_dt, Date dtConstructionStartDate, Date dtConstructionEndDate){
        String  strRecordTypeID;
        List<NCMT_RA_Phasing__c> objRAPhasingRecords = New List<NCMT_RA_Phasing__c>();
        
        if(strProjectType == 'Repair & Alteration - Parametric Entry'){
            strRecordTypeID = Schema.SObjectType.NCMT_RA_Phasing__c.getRecordTypeInfosByName().get('Repair & Alteration - Parametric Entry').getRecordTypeId();
        }else if(strProjectType == 'Repair & Alteration - Work Item Detail'){
            strRecordTypeID = Schema.SObjectType.NCMT_RA_Phasing__c.getRecordTypeInfosByName().get('Repair & Alteration - Work Item Detail').getRecordTypeId(); 
        }else if(strProjectType == 'New Construction - DES' || strProjectType == 'Repair & Alteration - DES' ){
            strRecordTypeID = Schema.SObjectType.NCMT_RA_Phasing__c.getRecordTypeInfosByName().get('New Construction - DES').getRecordTypeId(); 
        }else if(strProjectType == 'New Construction - CEW' || strProjectType == 'Repair & Alteration - CEW' ){
            strRecordTypeID = Schema.SObjectType.NCMT_RA_Phasing__c.getRecordTypeInfosByName().get('New Construction - CEW').getRecordTypeId(); 
        }
        
        if(strProjectType == 'Repair & Alteration - Parametric Entry'){     
            objRAPhasingRecords.Add(new NCMT_RA_Phasing__c(
            Project__c = ProjectID,
            RecordTypeID = strRecordTypeID,
            Name = 'Phase 1',
            Description__c = 'Initial Phase',
            Anticipated_Phasing__c = 100,
            Planned_Duration_Months__c = Math.abs(dtConstructionEndDate.monthsBetween(dtConstructionStartDate)),
            Work_Conditions__c = 'Fully vacant building',
            Planned_Project_Start__c = dtConstructionStartDate
            ));
            
        }else if(strProjectType == 'Repair & Alteration - Work Item Detail'){           
            objRAPhasingRecords.Add(new NCMT_RA_Phasing__c(
            Project__c = ProjectID,
            RecordTypeID = strRecordTypeID,
            Name = 'Phase 1',
            Description__c = 'Initial Phase',
            Planned_Duration_Months__c = Math.abs(dtConstructionEndDate.monthsBetween(dtConstructionStartDate)),
            Work_Conditions__c = 'Fully vacant building',
            Planned_Project_Start__c = dtConstructionStartDate
            ));
        }else if(strProjectType == 'New Construction - DES' || strProjectType == 'Repair & Alteration - DES'){           
            objRAPhasingRecords.Add(new NCMT_RA_Phasing__c(
            Project__c = ProjectID,
            RecordTypeID = strRecordTypeID,
            Name = 'Phase 1',
            Description__c = 'Initial Phase',
            Planned_Duration_Months__c = Math.abs(Mid_Construction_dt.monthsBetween(dtCostParameterDate)),
            Work_Conditions__c = 'Fully vacant building',
            Planned_Project_Start__c = dtCostParameterDate
            ));
        }else if(strProjectType == 'New Construction - CEW' || strProjectType == 'Repair & Alteration - CEW'){
            objRAPhasingRecords.Add(new NCMT_RA_Phasing__c(
            Project__c = ProjectID,
            RecordTypeID = strRecordTypeID,
            Name = 'Phase 1',
            Description__c = 'Initial Phase',
            Planned_Duration_Months__c = Math.abs(Mid_Construction_dt.monthsBetween(dtCostParameterDate)),
            Work_Conditions__c = 'Fully vacant building',
            Planned_Project_Start__c = dtCostParameterDate
            ));
        }     
            
            insert objRAPhasingRecords;
        
    }
    
    
    public void DeleteEstimateAdjustments (ID ProjectID) {
        List <NCMT_EstimateAdjustment__c> lstDelete = [select ID from NCMT_EstimateAdjustment__c Where NCMTProject__c = :ProjectID limit 50000] ;
        if(lstDelete.size() > 0) Delete lstDelete;
    }
    
    public void GenerateEstimateAdjustments(List<NCMT_Project__c> objProjects){
        
        ID      ProjectID;
        String  LocationName;
        Decimal dblLoactionMultiplier = 0.00;
        Decimal dblPLAAdjustment = 1.00;
        Decimal dblSmallBusiness = 1.00;
        Decimal dblParametricAdjustment = 1.00;
        Decimal dblSeismic = 1.0;
        Decimal dblSeismicTI = 1.0;
        Decimal dblQuality = 1.0;
        Decimal dblQualityTI = 1.0;
        Decimal dblGross_Area_Including_Parking = 0.00;
        
        
        // Calculate the values to be assigned
        string  strSeismic;
        string  strQuality;
        string  strProjectType;
        string  strBuilding_Type;
        string  strFiscal_Year;
        string  strState;
        string  strEstimateType;
        Boolean blnPLA;
        Boolean blnSBA;
        
        For (NCMT_Project__c objProj : objProjects ){
            ProjectID = objProj.ID;
            LocationName = objProj.Location_Name__c;
            strState = objProj.State__c;
            blnPLA = objProj.Project_Labor_Agreement__c;
            blnSBA = objProj.Set_Aside_100__c;
            strSeismic = objProj.Project_Seismic_Design_Category__c;
            strQuality = objProj.Building_Quality__c;
            strBuilding_Type = objProj.Building_Type__c;
            strProjectType = objProj.Project_Type__c;
            strEstimateType = objProj.Estimate_Type_Proj__c;
            strFiscal_Year = objProj.Cost_Parameter_Date_FY__c;
            dblGross_Area_Including_Parking = objProj.Gross_Area_Including_Parking__c;
            //dblParametricAdjustment = objProj.ParaSiteAdj__c;
            dblLoactionMultiplier = (Decimal) objProj.Location_Adjustment_DC__c;
            If (blnPLA) dblPLAAdjustment = (Decimal) objProj.PLA__c;
            If (blnSBA) dblSmallBusiness = (Decimal) objProj.SB_HUB__c;            
        }
        
        if((strProjectType == 'New Construction' && strBuilding_Type == 'LPOE') || (strProjectType == 'Repair & Alteration - Parametric Entry' && dblGross_Area_Including_Parking == 0) || (strEstimateType =='Cost Estimating Workbook') || (strEstimateType == 'Work Item - Repair & Alteration')){
            dblParametricAdjustment = 1;
        }
        else{
            dblParametricAdjustment = [Select ParaSiteAdj__c From Project_Level_Parameter__c where NCMT_Project__c = :ProjectID Limit 1].ParaSiteAdj__c;
        }
        
       /* For (NCMT_Location_Parameters__c objLocation : [Select Location_Adjustment_DC__c, PLA__c, SB_HUB__c From NCMT_Location_Parameters__c Where Name = :LocationName and State__c = :strState and Fiscal_Year__c= :strFiscal_Year Limit 1]){
            dblLoactionMultiplier = (Decimal) objLocation.Location_Adjustment_DC__c;
            If (blnPLA) dblPLAAdjustment = (Decimal) objLocation.PLA__c;
            If (blnSBA) dblSmallBusiness = (Decimal) objLocation.SB_HUB__c;
        }*/
        
        if (strSeismic == 'A'){
            dblSeismic = 1.0;
            dblSeismicTI = 1.0;
        } else if (strSeismic == 'B'){
            dblSeismic = 1.01;
            dblSeismicTI = 1.0;
        } else if (strSeismic == 'C'){
            dblSeismic = 1.02;
            dblSeismicTI = 1.0;
        } else if (strSeismic == 'D'){
            dblSeismic = 1.08;
            dblSeismicTI = 1.02;
        } else if (strSeismic == 'E'){
            dblSeismic = 1.11;
            dblSeismicTI = 1.04;
        } else if (strSeismic == 'F'){
            dblSeismic = 1.15;
            dblSeismicTI = 1.06;
        } else {
            dblSeismic = 1.0;
            dblSeismicTI = 1.0;
        }
        
        if (strQuality == 'P100: Monumental'){
            dblQuality = 1.05;
            dblQualityTI = 1.10;
        } else if (strQuality == 'P100: Landmark'){
            dblQuality = 1.03;
            dblQualityTI = 1.05;
        } else if (strQuality == 'P100: Baseline'){
            dblQuality = 1.00;
            dblQualityTI = 1.00;
        } else if (strQuality == 'Class A'){
            dblQuality = 0.93;
            dblQualityTI = 0.94;
        } else if (strQuality == 'Code Minimum'){
            dblQuality = 0.90;
            dblQualityTI = 0.90;
        } else {
            dblQuality = 1.0;
            dblQualityTI = 1.0;
        }       
        // Calculate the values to be assigned
        
        // Add the 2 Adjustment records
        List<NCMT_EstimateAdjustment__c> objEstimateAdjustments = New List<NCMT_EstimateAdjustment__c>();
        //Core/Shell Adjustment Factors
        objEstimateAdjustments.Add(new NCMT_EstimateAdjustment__c(
                NCMTProject__c = ProjectID,
                Adjustment_Type__c = 'Core/Shell Adjustment Factors', 
                LocationMultiplierDef__c = dblLoactionMultiplier, LocationMultiplier__c = dblLoactionMultiplier,
                ParametricAdjustmentDef__c = dblParametricAdjustment, ParametricAdjustment__c = dblParametricAdjustment,
                PLAAdjustmentDef__c = dblPLAAdjustment, PLAAdjustment__c = dblPLAAdjustment,
                SeismicDesignFactorDef__c = dblSeismic, SeismicDesignFactor__c = dblSeismic,
                SetupQualityAdjustmentDef__c = dblQuality, SetupQualityAdjustment__c = dblQuality,
                SmallBusinessHUBDef__c = dblSmallBusiness, SmallBusinessHUB__c = dblSmallBusiness
         ));
         
        //TI Adjustment Factors
        objEstimateAdjustments.Add(new NCMT_EstimateAdjustment__c(
                NCMTProject__c = ProjectID,
                Adjustment_Type__c = 'TI Adjustment Factors', 
                LocationMultiplierDef__c = dblLoactionMultiplier, LocationMultiplier__c = dblLoactionMultiplier,
                ParametricAdjustmentDef__c = dblParametricAdjustment, ParametricAdjustment__c = dblParametricAdjustment,
                PLAAdjustmentDef__c = dblPLAAdjustment, PLAAdjustment__c = dblPLAAdjustment,
                SeismicDesignFactorDef__c = dblSeismicTI, SeismicDesignFactor__c = dblSeismicTI,
                SetupQualityAdjustmentDef__c = dblQualityTI, SetupQualityAdjustment__c = dblQualityTI,
                SmallBusinessHUBDef__c = dblSmallBusiness, SmallBusinessHUB__c = dblSmallBusiness
         ));
         
         Insert objEstimateAdjustments;
         // Add the 2 Adjustment records

    }
    
    public void DeleteTIandTRCSData (ID ProjectID) {
        List <NCMT_TI_TRCS_Cost_Detail__c> lstDelete = [select ID from NCMT_TI_TRCS_Cost_Detail__c Where Project_Cost_Summary__r.Project_Name__r.Id = :ProjectID limit 50000] ;
        if(lstDelete.size() > 0) Delete lstDelete;
    }

    public static Boolean genHPRun = false;
    public void GenerateHPOptionData(ID ProjectID, String sProjectType, boolean blnhousingplan, boolean blnDefault_Housing_Plan, string txtCostParameterDateFY){
         
        System.debug('genHPRun --------------- ' +genHPRun); 
        if (!genHPRun){
            System.debug('GenerateHPOptionData'); 
            genHPRun = true;
            string otherRTId = Schema.SObjectType.NCMT_Other_Cost__c.getRecordTypeInfosByName().get('Other Housing Plan Cost').getRecordTypeId();

            //Find Housing Plan options 
            Set<Id> selectedOpts = new Set<Id>();
            //For TCO Only logic
            Id tcoRecordTypeId = NCMT_Utilities.getProjectRecordTypeId('New_Construction_TCO');
            Set<Id> tcoProjIds = new Set<Id>(); 
            Set<Integer> recurrences = new Set<Integer>();

            //Map<Id, NCMT_Housing_Plan_Option_Selection__c> optionToSelection = new Map<Id, NCMT_Housing_Plan_Option_Selection__c>();
            Map<String, List<NCMT_Housing_Plan_Option_Selection__c>> hpOptions = new Map<String, List<NCMT_Housing_Plan_Option_Selection__c>>();
            for (NCMT_Housing_Plan_Option_Selection__c optSelect : [Select Id, NCMT_Housing_Plan_Option__c, NCMT_Housing_Plan__c, NCMT_Project__c, NCMT_Project__r.RecordTypeId, Recurrence__c
                from NCMT_Housing_Plan_Option_Selection__c where NCMT_Project__c =: ProjectId]
            ){
                recurrences.add(Integer.valueOf(optSelect.Recurrence__c));
                selectedOpts.add(optSelect.NCMT_Housing_Plan_Option__c);
                String groupBy = optSelect.Recurrence__c +(optSelect.NCMT_Housing_Plan__c == null ? 'Summary' : optSelect.NCMT_Housing_Plan__c);
                if (hpOptions.get(groupBy) == null) hpOptions.put(groupBy, new List<NCMT_Housing_Plan_Option_Selection__c>());
                
                hpOptions.get(groupBy).add(optSelect);
                //optionToSelection.put(optSelect.NCMT_Housing_Plan_Option__c, optSelect);
                System.debug('optSelect.NCMT_Project__r.RecordTypeId == ' +optSelect.NCMT_Project__r.RecordTypeId +' tcoRecordTypeId = ' +tcoRecordTypeId);
                if (optSelect.NCMT_Project__r.RecordTypeId == tcoRecordTypeId){
                        tcoProjIds.add(optSelect.NCMT_Project__c);
                }
            }
            System.debug('txtCostParameterDateFY is ------------ ' +txtCostParameterDateFY);
            Map<Id, List<NCMT_Housing_Plan_Cost_Parameter__c>> params = new Map<Id, List<NCMT_Housing_Plan_Cost_Parameter__c>>();
            for (NCMT_Housing_Plan_Cost_Parameter__c costParam : [Select Id, Cost__c, NCMT_Housing_Plan_Option__c, 
                Space_Type__c, NCMT_Housing_Plan_Option__r.NCMT_Housing_Plan_Option_Template__r.Type__c
                from NCMT_Housing_Plan_Cost_Parameter__c where NCMT_Housing_Plan_Option__c IN: selectedOpts
                AND Fiscal_Year__c = :txtCostParameterDateFY AND Cost__c <> 0
                ]
            ){
                if (params.get(costParam.NCMT_Housing_Plan_Option__c) == null)
                    params.put(costParam.NCMT_Housing_Plan_Option__c, new List<NCMT_Housing_Plan_Cost_Parameter__c>());

                params.get(costParam.NCMT_Housing_Plan_Option__c).add(costParam);
            }

            Map<String, NCMT_Other_Cost__c> existingCosts = new  Map<String, NCMT_Other_Cost__c>();
            for (NCMT_Other_Cost__c other : [Select Id, NCMT_Housing_Plan_Option_Selection__c, NCMT_Project__c,
                                            Unit_Rate__c, Housing_Plan_Option_Square_Footage__c , Total1__c,
                                            NCMT_Housing_Plan_Cost_Parameter__c, NCMT_Housing_Plan_Option_Selection__r.Recurrence__c,
                                            RecordTypeId, Cost_Type__c, NCMT_Housing_Plan_Option_Selection__r.NCMT_Housing_Plan__c
                                            from NCMT_Other_Cost__c where NCMT_Project__c =: ProjectId 
                                            and NCMT_Housing_Plan_Cost_Parameter__c <> null]
            ){
                existingCosts.put('' +other.NCMT_Housing_Plan_Option_Selection__r.NCMT_Housing_Plan__c +other.NCMT_Housing_Plan_Option_Selection__r.Recurrence__c +other.NCMT_Housing_Plan_Cost_Parameter__c, other);
            }
            Set<Id> paramsUsed = new Set<Id>();
            List<NCMT_Other_Cost__c> otherCosts = new List<NCMT_Other_Cost__c>();
            //Added for New Construction and R&A - User Defined Housing Plan
            if ((sProjectType == 'New Construction' || sProjectType == 'Repair & Alteration - Parametric Entry' || sProjectType == 'Repair & Alteration - Work Item Detail') && blnhousingplan == true) {
        
                List<NCMT_Housing_Plan__c> listhp = [Select  Unfinished_Shell_Area_Use_USF__c, Workstations_open_office_Use_USF__c, Closed_offices_Use_USF__c, Private_toilets_Use_USF__c, 
                                                            X8_20_person_rooms_Use_USF__c,X20_or_more_person_rooms_Use_USF__c, Teleconference_Use_USF__c,Auditorium_sloped_floor_Use_USF__c, 
                                                            General_storage_Use_USF__c, High_density_storage_Use_USF__c, Clinics_health_units_Use_USF__c, Physical_fitness_Use_USF__c, 
                                                            Child_care_Use_USF__c,  Libraries_Use_USF__c, ADP_mainframe_Use_USF__c, ADP_high_density_PC_s_Use_USF__c, 
                                                            Joint_use_retail_Use_USF__c,Food_service_cafeteria_Use_USF__c, Climate_controlled_for_artifacts_Use_USF__c, Laboratory_Dry_electronic_Use_USF__c, 
                                                            Laboratory_Wet_chemistry_Use_USF__c, Firing_range_Use_USF__c, Copy_Center_Use_USF__c,  Credit_Union_Use_USF__c, 
                                                            Transaction_counter_space_Use_USF__c, Kitchen_Break_room_Use_USF__c, Locker_Shower_room_Use_USF__c, Hardened_offices_suites_Use_USF__c, 
                                                            Secure_Work_Environment_SWE_Std_Use_USF__c,  Secure_Work_Environment_SWE_Enhd_UseUSF__c, Secured_Storage_SCIF_Standard_Use_USF__c, 
                                                            Secured_Storage_SCIF_Enhanced_Use_USF__c,  Vault_Type_Storage_Use_USF__c,  Interview_Detention_Use_USF__c, Non_Marshal_Holding_Cell_Single_Use_USF__c , 
                                                            Non_Marshal_Holding_Cell_Double_Use_USF__c,  Courtroom_district_Ceremonial_Use_USF__c ,  Courtroom_district_Standard_Use_USF__c , Courtroom_Bankruptcy_Use_USF__c , 
                                                            Courtroom_Magistrate_Use_USF__c,  Grand_Jury_Room_Use_USF__c , Judicial_hearing_Use_USF__c ,  Judicial_chambers_Use_USF__c , 
                                                            Enhanced_office_Use_USF__c ,  USMS_Suite_Administration_Use_USF__c ,  USMS_Suite_Operations_Use_USF__c,  Sally_Port_Use_USF__c , 
                                                            Holding_cell_Central_Use_USF__c , Holding_cell_Court_floors_Use_USF__c ,  Light_industrial_Use_USF__c ,  Warehouse_Use_USF__c,
                                                            Non_climate_controlled_Use_USF__c,  VA_Exam_Suite_Use_USF__c,  VA_Ambulatory_Surgery_Use_USF__c, VA_Infusion_Use_USF__c,
                                                            VA_Intake_Use_USF__c, VA_Pharmacy_Use_USF__c, VA_Radiology_Use_USF__c, Data_Center_Use_USF__c, Mailroom_Use_USF__c, Secure_Mailroom_Use_USF__c,
                                                            Housing_Plan_Type__c,ID
                                                        from    NCMT_Housing_Plan__c
                                                        Where   Project__c = :ProjectID];
                                                                        
                for (NCMT_Housing_Plan__c hp : listhp) {      
                    System.debug('-------------------'+recurrences);
                    for (Integer r : recurrences){
                        if (hpOptions.get('' +r +hp.Id) != null){
                            
                            for (NCMT_Housing_Plan_Option_Selection__c opt : hpOptions.get('' +r +hp.Id)){
                                List<NCMT_Housing_Plan_Cost_Parameter__c> costParams = params.get(opt.NCMT_Housing_Plan_Option__c);


                                if (costParams != null &&costParams.size() > 0){
                                    for (NCMT_Housing_Plan_Cost_Parameter__c costParam : costParams){

                                        Decimal optionSquareFt = hpSpaceHelper(hp, costParam.Space_Type__c);
                                        
                                        if (optionSquareFt != 0){
                                            NCMT_Other_Cost__c otherCost = existingCosts.get(hp.Id +String.valueOf(opt.Recurrence__c) +costParam.Id);
                                            if (otherCost == null){
                                                otherCost = new NCMT_Other_Cost__c(
                                                    NCMT_Housing_Plan_Option_Selection__c = opt.Id,
                                                    NCMT_Project__c = ProjectID,
                                                    Unit_Rate__c = costParam.Cost__c,
                                                    Housing_Plan_Option_Square_Footage__c = OptionSquareFt,
                                                    Total1__c = costParam.Cost__c * OptionSquareFt,
                                                    NCMT_Housing_Plan_Cost_Parameter__c = costParam.Id,
                                                    RecordTypeId = otherRTId,
                                                    Cost_Type__c = costParam.NCMT_Housing_Plan_Option__r.NCMT_Housing_Plan_Option_Template__r.Type__c,
                                                    Cost_Based_on__c = 'Useable Area',
                                                    Cost_Description__c = 'N/A'
                                                );
                                            } 
                                            paramsUsed.add(costParam.Id);
                                            
                                            System.debug('hp other cost ----------- ' +otherCost);
                                            otherCosts.add(otherCost);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }  
            }else{
                System.debug('GrossArea');

                list<NCMT_Housing_Plan_Summary__c> listhpsummary= [Select 
                            Unfinished_Shell_Area_Use_USF__c , Workstations_open_office_Use_USF__c , Closed_offices_Use_USF__c , Private_toilets_Use_USF__c , 
                            X8_20_person_rooms_Use_USF__c  , X20_or_more_person_rooms_Use_USF__c , Teleconference_Use_USF__c , Auditorium_sloped_floor_Use_USF__c , 
                            General_storage_Use_USF__c , High_density_storage_Use_USF__c , Clinics_health_units_Use_USF__c , Physical_fitness_Use_USF__c  , 
                            Child_care_Use_USF__c , Libraries_Use_USF__c  , ADP_mainframe_Use_USF__c , ADP_high_density_PC_s_Use_USF__c  , 
                            Joint_use_retail_Use_USF__c , Food_service_cafeteria_Use_USF__c , Climate_controlled_for_artifacts_Use_USF__c , Laboratory_Dry_electronic_Use_USF__c  , 
                            Laboratory_Wet_chemistry_Use_USF__c , Firing_range_Use_USF__c , Copy_Center_Use_USF__c , Credit_Union_Use_USF__c , 
                            Transaction_counter_space_Use_USF__c , Kitchen_Break_room_Use_USF__c , Locker_Shower_room_Use_USF__c , Hardened_offices_suites_Use_USF__c , 
                            Secure_Work_Environment_SWE_Std_Use_USF__c , Secure_Work_Environment_SWE_Enhd_UseUSF__c , Secured_Storage_SCIF_Standard_Use_USF__c , 
                            Secured_Storage_SCIF_Enhanced_Use_USF__c , Vault_Type_Storage_Use_USF__c , Interview_Detention_Use_USF__c , Non_Marshal_Holding_Cell_Single_Use_USF__c  , 
                            Non_Marshal_Holding_Cell_Double_Use_USF__c , Courtroom_district_Ceremonial_Use_USF__c  , Courtroom_district_Standard_Use_USF__c  , Courtroom_Bankruptcy_Use_USF__c  , 
                            Courtroom_Magistrate_Use_USF__c , Grand_Jury_Room_Use_USF__c  , Judicial_hearing_Use_USF__c  , Judicial_chambers_Use_USF__c  , 
                            Enhanced_office_Use_USF__c  , USMS_Suite_Administration_Use_USF__c  , USMS_Suite_Operations_Use_USF__c , Sally_Port_Use_USF__c  , 
                            Holding_cell_Central_Use_USF__c  , Holding_cell_Court_floors_Use_USF__c  , Light_industrial_Use_USF__c  , Warehouse_Use_USF__c  ,
                            Non_climate_controlled_Use_USF__c , VA_Exam_Suite_Use_USF__c , VA_Ambulatory_Surgery_Use_USF__c , VA_Infusion_Use_USF__c ,
                            VA_Intake_Use_USF__c , VA_Pharmacy_Use_USF__c , VA_Radiology_Use_USF__c , Data_Center_Use_USF__c, Project__r.Project_Type__c, Project__r.Default_Housing_Plan_Entry_Type__c,
                            Project__r.Default_Housing_Plan__c, Mailroom_Use_USF__c, Secure_Mailroom_Use_USF__c
                        From    NCMT_Housing_Plan_Summary__c
                        Where   Project__c = :ProjectID];
        
                for (NCMT_Housing_Plan_Summary__c hp : listhpsummary) { 
            
                    for (Integer r : recurrences){
                        if (hpOptions.get(r +'Summary') != null){
                            
                            for (NCMT_Housing_Plan_Option_Selection__c opt : hpOptions.get(r +'Summary')){
                                List<NCMT_Housing_Plan_Cost_Parameter__c> costParams = params.get(opt.NCMT_Housing_Plan_Option__c);


                                if (costParams != null &&costParams.size() > 0){
                                    for (NCMT_Housing_Plan_Cost_Parameter__c costParam : costParams){

                                        Decimal optionSquareFt = hpSummarySpaceHelper(hp, costParam.Space_Type__c);
                                        
                                        if (optionSquareFt != 0){
                                            NCMT_Other_Cost__c otherCost = existingCosts.get(String.valueOf(opt.Recurrence__c) +costParam.Id);
                                            if (otherCost == null){
                                                otherCost = new NCMT_Other_Cost__c(
                                                    NCMT_Housing_Plan_Option_Selection__c = opt.Id,
                                                    NCMT_Project__c = ProjectID,
                                                    Unit_Rate__c = costParam.Cost__c,
                                                    Housing_Plan_Option_Square_Footage__c = OptionSquareFt,
                                                    Total1__c = costParam.Cost__c * OptionSquareFt,
                                                    NCMT_Housing_Plan_Cost_Parameter__c = costParam.Id,
                                                    RecordTypeId = otherRTId,
                                                    Cost_Type__c = costParam.NCMT_Housing_Plan_Option__r.NCMT_Housing_Plan_Option_Template__r.Type__c,
                                                    Cost_Based_on__c = 'Useable Area',
                                                    Cost_Description__c = 'N/A'
                                                );
                                            } 
                                            paramsUsed.add(costParam.Id);

                                            otherCosts.add(otherCost);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            
            }
            Boolean origRun = NCMT_GenerateTCOProjectDetailsExt.runTriggers;
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = false;
            List<NCMT_Other_Cost__c> oldCosts = new List<NCMT_Other_Cost__c>();
            for (NCMT_Other_Cost__c c : existingCosts.values()){
                //If an existing cost wasn't used 
                if (!paramsUsed.contains(c.NCMT_Housing_Plan_Cost_Parameter__c)){
                    oldCosts.add(c);
                }
            }

            upsert otherCosts;

            
            if (tcoProjIds.size() > 0){
                System.debug('Update TCO Lifecycle calculations....');
                NCMT_TCO_Lifecycle_Input_TriggerHandler.futureUpdateByProject(tcoProjIds);
            }

            if (oldCosts.size() > 0) delete oldCosts;
            NCMT_GenerateTCOProjectDetailsExt.runTriggers = origRun;
        }

    }
    
    public void GenerateTIandTRCSData(ID ProjectID, Decimal dblGrossSqFt, String strProjectTypeName, String sProjectType, boolean blnhousingplan, boolean blnDefault_Housing_Plan, string txtCostParameterDateFY, Map<String,String> mapCostSummary){
        System.debug('GenerateTIandTRCSData');  
        String  strSOQL;
        Decimal TIItemSqFt= 0.0, TIItemSqFtRefresh= 0.0, TIItemSqFtRenovate = 0.0;
        Decimal TRCSItemSqFt= 0.0, TRCSItemSqFtRefresh= 0.0, TRCSItemSqFtRenovate = 0.0;
        Decimal TIUtiltemSqFt= 0.0, TIUtiltemSqFtRefresh= 0.0, TIUtiltemSqFtRenovate = 0.0;
        Decimal TIItemCost= 0.0, TIItemCostRefresh= 0.0, TIItemCostRenovate = 0.0;
        /*Also used for R&A New Fit Out
        Decimal  dblSpace1= 0.0, dblSpace2= 0.0, dblSpace3= 0.0, dblSpace4= 0.0, dblSpace5 = 0.0, dblSpace6 = 0.0, dblSpace7= 0.0, dblSpace8= 0.0, dblSpace9= 0.0, dblSpace10 = 0.0;
        Decimal  dblSpace11= 0.0, dblSpace12= 0.0, dblSpace13= 0.0, dblSpace14= 0.0, dblSpace15= 0.0, dblSpace16= 0.0, dblSpace17= 0.0, dblSpace18= 0.0, dblSpace19= 0.0, dblSpace20 = 0.0;
        Decimal  dblSpace21= 0.0, dblSpace22= 0.0, dblSpace23= 0.0, dblSpace24= 0.0, dblSpace25= 0.0, dblSpace26= 0.0, dblSpace27= 0.0, dblSpace28= 0.0, dblSpace29= 0.0, dblSpace30 = 0.0;
        Decimal  dblSpace31= 0.0, dblSpace32= 0.0, dblSpace33= 0.0, dblSpace34= 0.0, dblSpace35= 0.0, dblSpace36= 0.0, dblSpace37= 0.0, dblSpace38= 0.0, dblSpace39= 0.0, dblSpace40 = 0.0;
        Decimal  dblSpace41= 0.0, dblSpace42= 0.0, dblSpace43= 0.0, dblSpace44= 0.0, dblSpace45= 0.0, dblSpace46= 0.0, dblSpace47= 0.0, dblSpace48= 0.0, dblSpace49= 0.0, dblSpace50= 0.0, dblSpace51= 0.0, dblSpace52 = 0.0;
        Decimal  dblSpace53= 0.0, dblSpace54= 0.0, dblSpace55= 0.0, dblSpace56= 0.0, dblSpace57= 0.0, dblSpace58= 0.0, dblSpace59 = 0.0, dblSpace60 = 0.0, dblSpace61 = 0.0;
        */
        //Added for R&A Refresh
        Decimal  dblSpaceRefresh1= 0.0, dblSpaceRefresh2= 0.0, dblSpaceRefresh3= 0.0, dblSpaceRefresh4= 0.0, dblSpaceRefresh5 = 0.0, dblSpaceRefresh6 = 0.0, dblSpaceRefresh7= 0.0, dblSpaceRefresh8= 0.0, dblSpaceRefresh9= 0.0, dblSpaceRefresh10 = 0.0;
        Decimal  dblSpaceRefresh11= 0.0, dblSpaceRefresh12= 0.0, dblSpaceRefresh13= 0.0, dblSpaceRefresh14= 0.0, dblSpaceRefresh15= 0.0, dblSpaceRefresh16= 0.0, dblSpaceRefresh17= 0.0, dblSpaceRefresh18= 0.0, dblSpaceRefresh19= 0.0, dblSpaceRefresh20 = 0.0;
        Decimal  dblSpaceRefresh21= 0.0, dblSpaceRefresh22= 0.0, dblSpaceRefresh23= 0.0, dblSpaceRefresh24= 0.0, dblSpaceRefresh25= 0.0, dblSpaceRefresh26= 0.0, dblSpaceRefresh27= 0.0, dblSpaceRefresh28= 0.0, dblSpaceRefresh29= 0.0, dblSpaceRefresh30 = 0.0;
        Decimal  dblSpaceRefresh31= 0.0, dblSpaceRefresh32= 0.0, dblSpaceRefresh33= 0.0, dblSpaceRefresh34= 0.0, dblSpaceRefresh35= 0.0, dblSpaceRefresh36= 0.0, dblSpaceRefresh37= 0.0, dblSpaceRefresh38= 0.0, dblSpaceRefresh39= 0.0, dblSpaceRefresh40 = 0.0;
        Decimal  dblSpaceRefresh41= 0.0, dblSpaceRefresh42= 0.0, dblSpaceRefresh43= 0.0, dblSpaceRefresh44= 0.0, dblSpaceRefresh45= 0.0, dblSpaceRefresh46= 0.0, dblSpaceRefresh47= 0.0, dblSpaceRefresh48= 0.0, dblSpaceRefresh49= 0.0, dblSpaceRefresh50= 0.0, dblSpaceRefresh51= 0.0, dblSpaceRefresh52 = 0.0;
        Decimal  dblSpaceRefresh53= 0.0, dblSpaceRefresh54= 0.0, dblSpaceRefresh55= 0.0, dblSpaceRefresh56= 0.0, dblSpaceRefresh57= 0.0, dblSpaceRefresh58= 0.0, dblSpaceRefresh59 = 0.0;
        
        //Added for R&A Renovate
        Decimal  dblSpaceRenovate1= 0.0, dblSpaceRenovate2= 0.0, dblSpaceRenovate3= 0.0, dblSpaceRenovate4= 0.0, dblSpaceRenovate5 = 0.0, dblSpaceRenovate6 = 0.0, dblSpaceRenovate7= 0.0, dblSpaceRenovate8= 0.0, dblSpaceRenovate9= 0.0, dblSpaceRenovate10 = 0.0;
        Decimal  dblSpaceRenovate11= 0.0, dblSpaceRenovate12= 0.0, dblSpaceRenovate13= 0.0, dblSpaceRenovate14= 0.0, dblSpaceRenovate15= 0.0, dblSpaceRenovate16= 0.0, dblSpaceRenovate17= 0.0, dblSpaceRenovate18= 0.0, dblSpaceRenovate19= 0.0, dblSpaceRenovate20 = 0.0;
        Decimal  dblSpaceRenovate21= 0.0, dblSpaceRenovate22= 0.0, dblSpaceRenovate23= 0.0, dblSpaceRenovate24= 0.0, dblSpaceRenovate25= 0.0, dblSpaceRenovate26= 0.0, dblSpaceRenovate27= 0.0, dblSpaceRenovate28= 0.0, dblSpaceRenovate29= 0.0, dblSpaceRenovate30 = 0.0;
        Decimal  dblSpaceRenovate31= 0.0, dblSpaceRenovate32= 0.0, dblSpaceRenovate33= 0.0, dblSpaceRenovate34= 0.0, dblSpaceRenovate35= 0.0, dblSpaceRenovate36= 0.0, dblSpaceRenovate37= 0.0, dblSpaceRenovate38= 0.0, dblSpaceRenovate39= 0.0, dblSpaceRenovate40 = 0.0;
        Decimal  dblSpaceRenovate41= 0.0, dblSpaceRenovate42= 0.0, dblSpaceRenovate43= 0.0, dblSpaceRenovate44= 0.0, dblSpaceRenovate45= 0.0, dblSpaceRenovate46= 0.0, dblSpaceRenovate47= 0.0, dblSpaceRenovate48= 0.0, dblSpaceRenovate49= 0.0, dblSpaceRenovate50= 0.0, dblSpaceRenovate51= 0.0, dblSpaceRenovate52 = 0.0;
        Decimal  dblSpaceRenovate53= 0.0, dblSpaceRenovate54= 0.0, dblSpaceRenovate55= 0.0, dblSpaceRenovate56= 0.0, dblSpaceRenovate57= 0.0, dblSpaceRenovate58= 0.0, dblSpaceRenovate59 = 0.0;  
        
        /*List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c From NCMT_Project_Cost_Summary__c Where Project_Name__c = :ProjectID];
        Map<string, String> mapCostSummary = new Map<string, String>();
        for(NCMT_Project_Cost_Summary__c objItem : listCostSummary)
            mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);*/
                
        //string strFiscalYear = String.ValueOf([SELECT MAX(Fiscal_Year__c) FiscalYear FROM TI_TRCS_Cost_Parameter__c][0].get('FiscalYear'));
        //string strFiscalYear = String.ValueOf([SELECT MAX(Cost_Parameter_Date_FY__c) FiscalYear FROM NCMT_Project__c Where ID = :ProjectID][0].get('FiscalYear'));
          string strFiscalYear = txtCostParameterDateFY;
        // Get the Space Info from hosuing Plan .for this project ...
        //For New Contruction project
        String strProjectType, strDefaultHousingPlanType;
        ID HousingPlanID;
        boolean blndefaulthousingplan;
        
        // Generate the TI-TRCS parameters for this project ...
        List<NCMT_TI_TRCS_Cost_Detail__c> objProjectTIAndTRCSlDetailRecords = New List<NCMT_TI_TRCS_Cost_Detail__c>();
        
        strSOQL =   'Select  ID, Cost_Type__c, Space_Type__c, Unit_TI_Cost__c, Unit_TRCS_Cost__c, Unit_TI_Utilities_Cost__c, RA_Unit_Core_Shell_Cost__c, RA_Unit_New_Fit_Out_Cost__c, RA_Unit_Refresh_Cost__c, RA_Unit_Renovate_Cost__c ' + 
                    'From    TI_TRCS_Cost_Parameter__c ' + ' ' +   
                    'Where   Fiscal_Year__c = :strFiscalYear ' +  
                    'And     (Unit_TI_Cost__c > 0 Or Unit_TRCS_Cost__c > 0) ' +   
                    'Order by Name ';
        List<TI_TRCS_Cost_Parameter__c> objTIAndTRCSParameters = Database.query(strSOQL); 
        
        
        
        //Added for New Construction and R&A - User Defined Housing Plan
        if ((sProjectType == 'New Construction' || sProjectType == 'Repair & Alteration - Parametric Entry' || sProjectType == 'Repair & Alteration - Work Item Detail') && blnhousingplan == true) {
    
            List<NCMT_Housing_Plan__c> listhp = [Select  Unfinished_Shell_Area_Use_USF__c, Workstations_open_office_Use_USF__c, Closed_offices_Use_USF__c, Private_toilets_Use_USF__c, 
                                                        X8_20_person_rooms_Use_USF__c,X20_or_more_person_rooms_Use_USF__c, Teleconference_Use_USF__c,Auditorium_sloped_floor_Use_USF__c, 
                                                        General_storage_Use_USF__c, High_density_storage_Use_USF__c, Clinics_health_units_Use_USF__c, Physical_fitness_Use_USF__c, 
                                                        Child_care_Use_USF__c,  Libraries_Use_USF__c, ADP_mainframe_Use_USF__c, ADP_high_density_PC_s_Use_USF__c, 
                                                        Joint_use_retail_Use_USF__c,Food_service_cafeteria_Use_USF__c, Climate_controlled_for_artifacts_Use_USF__c, Laboratory_Dry_electronic_Use_USF__c, 
                                                        Laboratory_Wet_chemistry_Use_USF__c, Firing_range_Use_USF__c, Copy_Center_Use_USF__c,  Credit_Union_Use_USF__c, 
                                                        Transaction_counter_space_Use_USF__c, Kitchen_Break_room_Use_USF__c, Locker_Shower_room_Use_USF__c, Hardened_offices_suites_Use_USF__c, 
                                                        Secure_Work_Environment_SWE_Std_Use_USF__c,  Secure_Work_Environment_SWE_Enhd_UseUSF__c, Secured_Storage_SCIF_Standard_Use_USF__c, 
                                                        Secured_Storage_SCIF_Enhanced_Use_USF__c,  Vault_Type_Storage_Use_USF__c,  Interview_Detention_Use_USF__c, Non_Marshal_Holding_Cell_Single_Use_USF__c , 
                                                        Non_Marshal_Holding_Cell_Double_Use_USF__c,  Courtroom_district_Ceremonial_Use_USF__c ,  Courtroom_district_Standard_Use_USF__c , Courtroom_Bankruptcy_Use_USF__c , 
                                                        Courtroom_Magistrate_Use_USF__c,  Grand_Jury_Room_Use_USF__c , Judicial_hearing_Use_USF__c ,  Judicial_chambers_Use_USF__c , 
                                                        Enhanced_office_Use_USF__c ,  USMS_Suite_Administration_Use_USF__c ,  USMS_Suite_Operations_Use_USF__c,  Sally_Port_Use_USF__c , 
                                                        Holding_cell_Central_Use_USF__c , Holding_cell_Court_floors_Use_USF__c ,  Light_industrial_Use_USF__c ,  Warehouse_Use_USF__c,
                                                        Non_climate_controlled_Use_USF__c,  VA_Exam_Suite_Use_USF__c,  VA_Ambulatory_Surgery_Use_USF__c, VA_Infusion_Use_USF__c,
                                                        VA_Intake_Use_USF__c, VA_Pharmacy_Use_USF__c, VA_Radiology_Use_USF__c, Data_Center_Use_USF__c, Mailroom_Use_USF__c, Secure_Mailroom_Use_USF__c,
                                                        Housing_Plan_Type__c,ID
                                                    from    NCMT_Housing_Plan__c
                                                    Where   Project__c = :ProjectID];
                                                                
            for (NCMT_Housing_Plan__c RowData : listhp) {      
                
                HousingPlanID = RowData.ID;          
       system.debug('test--------'+RowData);
            for(TI_TRCS_Cost_Parameter__c objRecord: objTIAndTRCSParameters) {
                //Data from housing plan ...
                TIItemSqFt = TRCSItemSqFt = TIUtiltemSqFt  = hpSpaceHelper(RowData, objRecord.Space_Type__c);
                system.debug('priya-------------'+objRecord.Space_Type__c+'-----'+TIItemSqFt);
                
                //Utility Project? Add utility cost to TI ...
                TIItemCost = (Decimal) objRecord.Unit_TI_Cost__c;
                if (strProjectTypeName == 'Utility'){
                    TIItemSqFt += TIUtiltemSqFt;
                    TIItemCost += (Decimal) objRecord.Unit_TI_Utilities_Cost__c;
                }
                
                
                
                if (sProjectType <> 'New Construction') {
                        if(sProjectType == 'Repair & Alteration - Parametric Entry'){
                            IF(TIItemSqFt>0 || TIItemSqFtRefresh>0 || TIItemSqFtRenovate>0){
                                if(RowData.get('Housing_Plan_Type__c') == 'New Fit Out'){
                                            objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                                            Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                                            TI_TRCS_Cost_Parameter__c = objRecord.ID,
                                            TI_Total_Units__c = 0,
                                            TI_Unit_Cost__c = 0,
                                            TRCS_Total_Units__c = 0,
                                            TRCS_Unit_Cost__c = 0,
                                            RA_New_Fit_Out_Unit_Cost__c = (Decimal) objRecord.RA_Unit_New_Fit_Out_Cost__c,
                                            RA_Core_Shell_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Core_Shell_Cost__c,
                                            RA_New_Fit_Out_Total_Units__c = TIItemSqFt,
                                            RA_Refresh_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Refresh_Cost__c,
                                            RA_Refresh_Total_Units__c = 0,
                                            RA_Renovate_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Renovate_Cost__c,
                                            RA_Renovate_Total_Units__c = 0,
                                            NCMT_Housing_Plan__c = HousingPlanID   
                                            ));
                                    }else if(RowData.get('Housing_Plan_Type__c') == 'Refresh'){
                                        objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                                            Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                                            TI_TRCS_Cost_Parameter__c = objRecord.ID,
                                            TI_Total_Units__c = 0,
                                            TI_Unit_Cost__c = 0,
                                            TRCS_Total_Units__c = 0,
                                            TRCS_Unit_Cost__c = 0,
                                            RA_New_Fit_Out_Unit_Cost__c = (Decimal) objRecord.RA_Unit_New_Fit_Out_Cost__c,
                                            RA_Core_Shell_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Core_Shell_Cost__c,
                                            RA_New_Fit_Out_Total_Units__c = 0,
                                            RA_Refresh_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Refresh_Cost__c,
                                            RA_Refresh_Total_Units__c = TIItemSqFt,
                                            RA_Renovate_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Renovate_Cost__c,
                                            RA_Renovate_Total_Units__c = 0,
                                            NCMT_Housing_Plan__c = HousingPlanID   
                                            ));
                                    }else if (RowData.get('Housing_Plan_Type__c') == 'Renovate'){
                                        objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                                            Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                                            TI_TRCS_Cost_Parameter__c = objRecord.ID,
                                            TI_Total_Units__c = 0,
                                            TI_Unit_Cost__c = 0,
                                            TRCS_Total_Units__c = 0,
                                            TRCS_Unit_Cost__c = 0,
                                            RA_New_Fit_Out_Unit_Cost__c = (Decimal) objRecord.RA_Unit_New_Fit_Out_Cost__c,
                                            RA_Core_Shell_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Core_Shell_Cost__c,
                                            RA_New_Fit_Out_Total_Units__c = 0,
                                            RA_Refresh_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Refresh_Cost__c,
                                            RA_Refresh_Total_Units__c = 0,
                                            RA_Renovate_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Renovate_Cost__c,
                                            RA_Renovate_Total_Units__c = TIItemSqFt,
                                            NCMT_Housing_Plan__c = HousingPlanID   
                                            ));
                                    }
                            }
                        }else{
                            IF(TIItemSqFt>0 || TIItemSqFtRefresh>0 || TIItemSqFtRenovate>0){
                                if(RowData.get('Housing_Plan_Type__c') == 'New Fit Out'){
                                    objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                                            Project_Cost_Summary__c = mapCostSummary.get('Interior Construction - Space Plans'),
                                            TI_TRCS_Cost_Parameter__c = objRecord.ID,
                                            TI_Total_Units__c = 0,
                                            TI_Unit_Cost__c = 0,
                                            TRCS_Total_Units__c = 0,
                                            TRCS_Unit_Cost__c = 0,
                                            RA_New_Fit_Out_Unit_Cost__c = (Decimal) objRecord.RA_Unit_New_Fit_Out_Cost__c,
                                            RA_Core_Shell_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Core_Shell_Cost__c,
                                            RA_New_Fit_Out_Total_Units__c = TIItemSqFt,
                                            RA_Refresh_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Refresh_Cost__c,
                                            RA_Refresh_Total_Units__c = 0,
                                            RA_Renovate_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Renovate_Cost__c,
                                            RA_Renovate_Total_Units__c = 0,
                                            NCMT_Housing_Plan__c = HousingPlanID    
                                        ));
                                    }else if(RowData.get('Housing_Plan_Type__c') == 'Refresh'){
                                        objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                                            Project_Cost_Summary__c = mapCostSummary.get('Interior Construction - Space Plans'),
                                            TI_TRCS_Cost_Parameter__c = objRecord.ID,
                                            TI_Total_Units__c = 0,
                                            TI_Unit_Cost__c = 0,
                                            TRCS_Total_Units__c = 0,
                                            TRCS_Unit_Cost__c = 0,
                                            RA_New_Fit_Out_Unit_Cost__c = (Decimal) objRecord.RA_Unit_New_Fit_Out_Cost__c,
                                            RA_Core_Shell_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Core_Shell_Cost__c,
                                            RA_New_Fit_Out_Total_Units__c = 0,
                                            RA_Refresh_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Refresh_Cost__c,
                                            RA_Refresh_Total_Units__c = TIItemSqFt,
                                            RA_Renovate_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Renovate_Cost__c,
                                            RA_Renovate_Total_Units__c = 0,
                                            NCMT_Housing_Plan__c = HousingPlanID    
                                        ));
                                    }else if (RowData.get('Housing_Plan_Type__c') == 'Renovate'){
                                    objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                                            Project_Cost_Summary__c = mapCostSummary.get('Interior Construction - Space Plans'),
                                            TI_TRCS_Cost_Parameter__c = objRecord.ID,
                                            TI_Total_Units__c = 0,
                                            TI_Unit_Cost__c = 0,
                                            TRCS_Total_Units__c = 0,
                                            TRCS_Unit_Cost__c = 0,
                                            RA_New_Fit_Out_Unit_Cost__c = (Decimal) objRecord.RA_Unit_New_Fit_Out_Cost__c,
                                            RA_Core_Shell_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Core_Shell_Cost__c,
                                            RA_New_Fit_Out_Total_Units__c = 0,
                                            RA_Refresh_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Refresh_Cost__c,
                                            RA_Refresh_Total_Units__c = 0,
                                            RA_Renovate_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Renovate_Cost__c,
                                            RA_Renovate_Total_Units__c = TIItemSqFt,
                                            NCMT_Housing_Plan__c = HousingPlanID    
                                        ));
                                    }
                                
                            }
                        }
                }
                else {
                IF(TIItemSqFt>0 || TRCSItemSqFt>0){
                        objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                            Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                            TI_TRCS_Cost_Parameter__c = objRecord.ID,
                            TI_Total_Units__c = TIItemSqFt,
                            TI_Unit_Cost__c = TIItemCost,
                            TRCS_Total_Units__c = TRCSItemSqFt,
                            TRCS_Unit_Cost__c = (Decimal) objRecord.Unit_TRCS_Cost__c,
                            NCMT_Housing_Plan__c = HousingPlanID
                        ));
                }
                }                 
            }
        }                       
     }else{
        System.debug('GrossArea');
        list<NCMT_Housing_Plan_Summary__c> listhpsummary= [Select 
                        Unfinished_Shell_Area_Use_USF__c , Workstations_open_office_Use_USF__c , Closed_offices_Use_USF__c , Private_toilets_Use_USF__c , 
                        X8_20_person_rooms_Use_USF__c  , X20_or_more_person_rooms_Use_USF__c , Teleconference_Use_USF__c , Auditorium_sloped_floor_Use_USF__c , 
                        General_storage_Use_USF__c , High_density_storage_Use_USF__c , Clinics_health_units_Use_USF__c , Physical_fitness_Use_USF__c  , 
                        Child_care_Use_USF__c , Libraries_Use_USF__c  , ADP_mainframe_Use_USF__c , ADP_high_density_PC_s_Use_USF__c  , 
                        Joint_use_retail_Use_USF__c , Food_service_cafeteria_Use_USF__c , Climate_controlled_for_artifacts_Use_USF__c , Laboratory_Dry_electronic_Use_USF__c  , 
                        Laboratory_Wet_chemistry_Use_USF__c , Firing_range_Use_USF__c , Copy_Center_Use_USF__c , Credit_Union_Use_USF__c , 
                        Transaction_counter_space_Use_USF__c , Kitchen_Break_room_Use_USF__c , Locker_Shower_room_Use_USF__c , Hardened_offices_suites_Use_USF__c , 
                        Secure_Work_Environment_SWE_Std_Use_USF__c , Secure_Work_Environment_SWE_Enhd_UseUSF__c , Secured_Storage_SCIF_Standard_Use_USF__c , 
                        Secured_Storage_SCIF_Enhanced_Use_USF__c , Vault_Type_Storage_Use_USF__c , Interview_Detention_Use_USF__c , Non_Marshal_Holding_Cell_Single_Use_USF__c  , 
                        Non_Marshal_Holding_Cell_Double_Use_USF__c , Courtroom_district_Ceremonial_Use_USF__c  , Courtroom_district_Standard_Use_USF__c  , Courtroom_Bankruptcy_Use_USF__c  , 
                        Courtroom_Magistrate_Use_USF__c , Grand_Jury_Room_Use_USF__c  , Judicial_hearing_Use_USF__c  , Judicial_chambers_Use_USF__c  , 
                        Enhanced_office_Use_USF__c  , USMS_Suite_Administration_Use_USF__c  , USMS_Suite_Operations_Use_USF__c , Sally_Port_Use_USF__c  , 
                        Holding_cell_Central_Use_USF__c  , Holding_cell_Court_floors_Use_USF__c  , Light_industrial_Use_USF__c  , Warehouse_Use_USF__c  ,
                        Non_climate_controlled_Use_USF__c , VA_Exam_Suite_Use_USF__c , VA_Ambulatory_Surgery_Use_USF__c , VA_Infusion_Use_USF__c ,
                        VA_Intake_Use_USF__c , VA_Pharmacy_Use_USF__c , VA_Radiology_Use_USF__c , Data_Center_Use_USF__c, Project__r.Project_Type__c, Project__r.Default_Housing_Plan_Entry_Type__c,
                        Project__r.Default_Housing_Plan__c, Mailroom_Use_USF__c, Secure_Mailroom_Use_USF__c
                    From    NCMT_Housing_Plan_Summary__c
                    Where   Project__c = :ProjectID];
             
            strProjectType = listhpsummary[0].Project__r.Project_Type__c ;
            strDefaultHousingPlanType = listhpsummary[0].Project__r.Default_Housing_Plan_Entry_Type__c;
            blndefaulthousingplan = listhpsummary[0].Project__r.Default_Housing_Plan__c;    
            
            for(TI_TRCS_Cost_Parameter__c objRecord: objTIAndTRCSParameters) {
                for (NCMT_Housing_Plan_Summary__c RowData : listhpsummary) { 
                    TIItemSqFt = TRCSItemSqFt = TIUtiltemSqFt = hpSummarySpaceHelper(RowData, objRecord.Space_Type__c);
                }
            

                //Utility Project? Add utility cost to TI ...
                TIItemCost = (Decimal) objRecord.Unit_TI_Cost__c;
                if (strProjectTypeName == 'Utility'){
                    TIItemSqFt += TIUtiltemSqFt;
                    TIItemCost += (Decimal) objRecord.Unit_TI_Utilities_Cost__c;
                }

               
                if (sProjectType <> 'New Construction') {
                    if (blnDefault_Housing_Plan == true && strDefaultHousingPlanType == 'New Fit Out') {
                        IF(TIItemSqFt>0){
                            objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                            Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                            TI_TRCS_Cost_Parameter__c = objRecord.ID,
                            TI_Total_Units__c = 0.0,
                            TI_Unit_Cost__c = 0,
                            TRCS_Total_Units__c = 0,
                            TRCS_Unit_Cost__c = 0,
                            RA_New_Fit_Out_Unit_Cost__c = (Decimal) objRecord.RA_Unit_New_Fit_Out_Cost__c,
                            RA_Core_Shell_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Core_Shell_Cost__c,
                            RA_New_Fit_Out_Total_Units__c = TIItemSqFt
                        ));
                    }
                    }
                    else if (blnDefault_Housing_Plan == true && strDefaultHousingPlanType == 'Refresh') {
                    IF(TIItemSqFt>0){
                            objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                            Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                            TI_TRCS_Cost_Parameter__c = objRecord.ID,
                            TI_Total_Units__c = 0.0,
                            TI_Unit_Cost__c = 0,
                            TRCS_Total_Units__c = 0,
                            TRCS_Unit_Cost__c = 0,
                            RA_Refresh_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Refresh_Cost__c,
                            RA_Refresh_Total_Units__c = TIItemSqFt
                            ));
                        }
                    }
                    else if (blnDefault_Housing_Plan == true && strDefaultHousingPlanType == 'Renovate') {
                    IF(TIItemSqFt>0){
                                objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                                Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                                TI_TRCS_Cost_Parameter__c = objRecord.ID,
                                TI_Total_Units__c = 0.0,
                                TI_Unit_Cost__c = 0,
                                TRCS_Total_Units__c = 0,
                                TRCS_Unit_Cost__c = 0,
                                RA_Renovate_Unit_Cost__c = (Decimal) objRecord.RA_Unit_Renovate_Cost__c,
                                RA_Renovate_Total_Units__c = TIItemSqFt
                            ));
                        }
                    }
                } else {
                    IF(TIItemSqFt>0 || TRCSItemSqFt>0){
                            objProjectTIAndTRCSlDetailRecords.Add(new NCMT_TI_TRCS_Cost_Detail__c(
                                Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                                TI_TRCS_Cost_Parameter__c = objRecord.ID,
                                TI_Total_Units__c = TIItemSqFt,
                                TI_Unit_Cost__c = TIItemCost,
                                TRCS_Total_Units__c = TRCSItemSqFt,
                                TRCS_Unit_Cost__c = (Decimal) objRecord.Unit_TRCS_Cost__c
                            ));
                    }
                }             
            }
      }  
        
        insert objProjectTIAndTRCSlDetailRecords;

        
    }

    public double hpSpaceHelper(NCMT_Housing_Plan__c RowData, String spaceType){
        Decimal TIItemSqFt = 0.0;
        if (spaceType == 'General Office Space Type, 20% Open'){
            TIItemSqFt = RowData.Closed_offices_Use_USF__c;                
        }  else if (spaceType == 'General Office Space Type, 100% Open'){
            TIItemSqFt = RowData.Workstations_open_office_Use_USF__c;
        } else if (spaceType == 'Enhanced Office Space Type'){
            TIItemSqFt = RowData.Enhanced_office_Use_USF__c;
        } else if (spaceType == 'General Storage'){
            TIItemSqFt = RowData.General_storage_Use_USF__c;
        } else if (spaceType == 'High Density Storage'){
            TIItemSqFt = RowData.High_density_storage_Use_USF__c;
        } else if (spaceType == 'Dry/Electronic Lab'){
            TIItemSqFt = RowData.Laboratory_Dry_electronic_Use_USF__c;
        } else if (spaceType == 'Wet Lab'){
            TIItemSqFt = RowData.Laboratory_Wet_chemistry_Use_USF__c;
        } else if (spaceType == 'Holding cell'){
            TIItemSqFt = RowData.Holding_cell_Court_floors_Use_USF__c;
        } else if (spaceType == 'USMS Suite: Administrative Area'){
            TIItemSqFt = RowData.USMS_Suite_Administration_Use_USF__c;
        } else if (spaceType == 'USMS Suite, Sally Port'){
            TIItemSqFt = RowData.Sally_Port_Use_USF__c;
        } else if (spaceType == 'USMS Operations Area'){
            TIItemSqFt = RowData.USMS_Suite_Operations_Use_USF__c;
        } else if (spaceType == 'USMS Suite: Central Holding Area'){
            TIItemSqFt = RowData.Holding_cell_Central_Use_USF__c;
        } else if (spaceType == 'Private Toilet'){
            TIItemSqFt = RowData.Private_toilets_Use_USF__c;
        } else if (spaceType == 'Clinic/Health Unit'){
            TIItemSqFt = RowData.Clinics_health_units_Use_USF__c; 
        } else if (spaceType == 'Fitness/Exercise'){
            TIItemSqFt = RowData.Physical_fitness_Use_USF__c;
        } else if (spaceType == 'Childcare TI'){
            TIItemSqFt = RowData.Child_care_Use_USF__c;
        } else if (spaceType == 'Conference/Classrooms'){
            TIItemSqFt = (RowData.X8_20_person_rooms_Use_USF__c + RowData.X20_or_more_person_rooms_Use_USF__c) ;
        } else if (spaceType == 'Teleconference'){
            TIItemSqFt = RowData.Teleconference_Use_USF__c;
        } else if (spaceType == 'Auditorium'){
            TIItemSqFt = RowData.Auditorium_sloped_floor_Use_USF__c;
        } else if (spaceType == 'Library'){
            TIItemSqFt = RowData.Libraries_Use_USF__c;
        } else if (spaceType == 'ADP Mainframe'){
            TIItemSqFt = RowData.ADP_mainframe_Use_USF__c;
        } else if (spaceType == 'ADP - High Density PCs'){
            TIItemSqFt = RowData.ADP_high_density_PC_s_Use_USF__c;
        } else if (spaceType == 'Courtroom - District Court'){
            TIItemSqFt = RowData.Courtroom_district_Standard_Use_USF__c;
        } else if (spaceType == 'Courtroom, District Grand Jury'){
            TIItemSqFt = RowData.Grand_Jury_Room_Use_USF__c;
        } else if (spaceType == 'Courtroom - Bankruptcy'){
            TIItemSqFt = RowData.Courtroom_Bankruptcy_Use_USF__c;
        } else if (spaceType == 'Courtroom - Magistrate'){
            TIItemSqFt = RowData.Courtroom_Magistrate_Use_USF__c;
        } else if (spaceType == 'Judicial Hearing Room'){
            TIItemSqFt = RowData.Judicial_hearing_Use_USF__c;
        } else if (spaceType == 'Judicial Chambers'){
            TIItemSqFt = RowData.Judicial_chambers_Use_USF__c;
        } else if (spaceType == 'Light Industrial'){
            TIItemSqFt = RowData.Light_industrial_Use_USF__c;
        } else if (spaceType == 'Warehouse'){
            TIItemSqFt = RowData.Warehouse_Use_USF__c;
        } else if (spaceType == 'Joint Use-Retail'){
            TIItemSqFt = RowData.Joint_use_retail_Use_USF__c;
        } else if (spaceType == 'Copy Center'){
            TIItemSqFt = RowData.Copy_Center_Use_USF__c;
        } else if (spaceType == 'Credit Union'){
            TIItemSqFt = RowData.Credit_Union_Use_USF__c; 
        } else if (spaceType == 'Food Service/Cafeteria'){
            TIItemSqFt = RowData.Food_service_cafeteria_Use_USF__c;
        } else if (spaceType == 'Exhibit Hall Non-Climate Controlled'){
            TIItemSqFt = RowData.Non_climate_controlled_Use_USF__c;
        } else if (spaceType == 'Exhibit Hall Climate Controlled'){
            TIItemSqFt = RowData.Climate_controlled_for_artifacts_Use_USF__c;  
        } else if (spaceType == 'Hardened Suite: 20% open'){
            TIItemSqFt = RowData.Hardened_offices_suites_Use_USF__c;
        } else if (spaceType == 'Secure Work Environment'){
            TIItemSqFt = RowData.Secure_Work_Environment_SWE_Std_Use_USF__c; 
        } else if (spaceType == 'Secure Work Environment: Enhanced'){
            TIItemSqFt = RowData.Secure_Work_Environment_SWE_Enhd_UseUSF__c;
        }  else if (spaceType == 'Secured Storage/SCIF Standard'){
            TIItemSqFt = RowData.Secured_Storage_SCIF_Standard_Use_USF__c;
        } else if (spaceType == 'Secured Storage/SCIF Enhanced'){
            TIItemSqFt = RowData.Secured_Storage_SCIF_Enhanced_Use_USF__c;
        } else if (spaceType == 'Firing Range'){
            TIItemSqFt = RowData.Firing_range_Use_USF__c;
        }  else if (spaceType == 'Public Transaction Space, Tenant Improvement'){
            TIItemSqFt = RowData.Transaction_counter_space_Use_USF__c; 
        }  else if (spaceType == 'Detention Suite - exc holding, Tenant Improvement'){
            TIItemSqFt = RowData.Interview_Detention_Use_USF__c;
        } else if (spaceType == 'Holding Cell - Single, Tenant Improvement'){
            TIItemSqFt = RowData.Non_Marshal_Holding_Cell_Single_Use_USF__c;
        } else if (spaceType == 'Holding Cell - Group, Tenant Improvement'){
            TIItemSqFt = RowData.Non_Marshal_Holding_Cell_Double_Use_USF__c;
        } else if (spaceType == 'Shower and Locker Rooms, Tenant Improvement'){
            TIItemSqFt = RowData.Locker_Shower_room_Use_USF__c;
        } else if (spaceType == 'Kitchen-Break room, Tenant Improvement'){
            TIItemSqFt = RowData.Kitchen_Break_room_Use_USF__c; 
        } else if (spaceType == 'Vaults/Secure Storage, Tenant Improvement'){
            TIItemSqFt = RowData.Vault_Type_Storage_Use_USF__c;
        } else if (spaceType == 'Medical Spaces - Exam Suite'){
            TIItemSqFt = RowData.VA_Exam_Suite_Use_USF__c; 
        } else if (spaceType == 'Medical Spaces - Ambulatory Surgery'){
            TIItemSqFt = RowData.VA_Ambulatory_Surgery_Use_USF__c; 
        } else if (spaceType == 'Medical Spaces - Infusion'){
            TIItemSqFt = RowData.VA_Infusion_Use_USF__c; 
        } else if (spaceType == 'Medical Spaces - Intake'){
            TIItemSqFt = RowData.VA_Intake_Use_USF__c; 
        } else if (spaceType == 'Medical Spaces - Pharmacy'){
            TIItemSqFt = RowData.VA_Pharmacy_Use_USF__c; 
        } else if (spaceType == 'Medical Spaces - Radiology'){
            TIItemSqFt = RowData.VA_Radiology_Use_USF__c;
        } else if (spaceType == 'Data Center'){
            TIItemSqFt = RowData.Data_Center_Use_USF__c;  
        } else if (spaceType == 'Mailroom'){
            TIItemSqFt = RowData.Mailroom_Use_USF__c;  
        }else if (spaceType == 'Secure Mailroom'){
            TIItemSqFt = RowData.Secure_Mailroom_Use_USF__c;  
        }else {    
            TIItemSqFt = 0.00;
        }
        if (TIItemSqFt == null) TIItemSqFt = 0;
        return TIItemSqFt;
    }

    public Double hpSummarySpaceHelper(NCMT_Housing_Plan_Summary__c RowData, String spaceType){
       Decimal TIItemSqFt = 0;
        //Data from housing summary plan ...

        if (spaceType == 'General Office Space Type, 20% Open' &&RowData.Closed_offices_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Closed_offices_Use_USF__c;
        } else if (spaceType == 'General Office Space Type, 100% Open' &&RowData.Workstations_open_office_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Workstations_open_office_Use_USF__c;
        } else if (spaceType == 'Enhanced Office Space Type' &&RowData.Enhanced_office_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Enhanced_office_Use_USF__c;
        } else if (spaceType == 'General Storage' &&RowData.General_storage_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.General_storage_Use_USF__c;
        } else if (spaceType == 'High Density Storage' &&RowData.High_density_storage_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.High_density_storage_Use_USF__c;
        } else if (spaceType == 'Dry/Electronic Lab' &&RowData.Laboratory_Dry_electronic_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Laboratory_Dry_electronic_Use_USF__c;
        } else if (spaceType == 'Wet Lab' &&RowData.Laboratory_Wet_chemistry_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Laboratory_Wet_chemistry_Use_USF__c;
        } else if (spaceType == 'Holding cell' &&RowData.Holding_cell_Court_floors_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Holding_cell_Court_floors_Use_USF__c;
        } else if (spaceType == 'USMS Suite: Administrative Area' &&RowData.USMS_Suite_Administration_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.USMS_Suite_Administration_Use_USF__c;
        } else if (spaceType == 'USMS Suite, Sally Port' &&RowData.Sally_Port_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Sally_Port_Use_USF__c;
        } else if (spaceType == 'USMS Operations Area' &&RowData.USMS_Suite_Operations_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.USMS_Suite_Operations_Use_USF__c;
        } else if (spaceType == 'USMS Suite: Central Holding Area' &&RowData.Holding_cell_Central_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Holding_cell_Central_Use_USF__c;
        } else if (spaceType == 'Private Toilet' &&RowData.Private_toilets_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Private_toilets_Use_USF__c;
        } else if (spaceType == 'Clinic/Health Unit' &&RowData.Clinics_health_units_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Clinics_health_units_Use_USF__c;  
        } else if (spaceType == 'Fitness/Exercise' &&RowData.Physical_fitness_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Physical_fitness_Use_USF__c;
        } else if (spaceType == 'Childcare TI' &&RowData.Child_care_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Child_care_Use_USF__c;
        } else if (spaceType == 'Conference/Classrooms'){
            if (RowData.X8_20_person_rooms_Use_USF__c != null)
                TIItemSqFt += (Decimal) RowData.X8_20_person_rooms_Use_USF__c;
            if (RowData.X20_or_more_person_rooms_Use_USF__c != null)
                TIItemSqFt += (Decimal) RowData.X20_or_more_person_rooms_Use_USF__c;
        } else if (spaceType == 'Teleconference' &&RowData.Teleconference_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Teleconference_Use_USF__c;
        } else if (spaceType == 'Auditorium' &&RowData.Auditorium_sloped_floor_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Auditorium_sloped_floor_Use_USF__c;
        } else if (spaceType == 'Library' &&RowData.Libraries_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Libraries_Use_USF__c;
        } else if (spaceType == 'ADP Mainframe' &&RowData.ADP_mainframe_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.ADP_mainframe_Use_USF__c;
        } else if (spaceType == 'ADP - High Density PCs' &&RowData.ADP_high_density_PC_s_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.ADP_high_density_PC_s_Use_USF__c;
        } else if (spaceType == 'Courtroom - District Court' &&RowData.Courtroom_district_Standard_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Courtroom_district_Standard_Use_USF__c;
        } else if (spaceType == 'Courtroom, District Grand Jury' &&RowData.Grand_Jury_Room_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Grand_Jury_Room_Use_USF__c;
        } else if (spaceType == 'Courtroom - Bankruptcy' &&RowData.Courtroom_Bankruptcy_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Courtroom_Bankruptcy_Use_USF__c;
        } else if (spaceType == 'Courtroom - Magistrate' &&RowData.Courtroom_Magistrate_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Courtroom_Magistrate_Use_USF__c;
        } else if (spaceType == 'Judicial Hearing Room' &&RowData.Judicial_hearing_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Judicial_hearing_Use_USF__c;
        } else if (spaceType == 'Judicial Chambers' &&RowData.Judicial_chambers_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Judicial_chambers_Use_USF__c;
        } else if (spaceType == 'Light Industrial' &&RowData.Light_industrial_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Light_industrial_Use_USF__c;
        } else if (spaceType == 'Warehouse' &&RowData.Warehouse_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Warehouse_Use_USF__c;
        } else if (spaceType == 'Joint Use-Retail' &&RowData.Joint_use_retail_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Joint_use_retail_Use_USF__c;
        } else if (spaceType == 'Copy Center' &&RowData.Copy_Center_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Copy_Center_Use_USF__c;
        } else if (spaceType == 'Credit Union' &&RowData.Credit_Union_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Credit_Union_Use_USF__c;
        } else if (spaceType == 'Food Service/Cafeteria' &&RowData.Food_service_cafeteria_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Food_service_cafeteria_Use_USF__c;
        } else if (spaceType == 'Exhibit Hall Non-Climate Controlled' &&RowData.Non_climate_controlled_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Non_climate_controlled_Use_USF__c;
        } else if (spaceType == 'Exhibit Hall Climate Controlled' &&RowData.Climate_controlled_for_artifacts_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Climate_controlled_for_artifacts_Use_USF__c; 
        } else if (spaceType == 'Hardened Suite: 20% open' &&RowData.Hardened_offices_suites_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Hardened_offices_suites_Use_USF__c;
        } else if (spaceType == 'Secure Work Environment' &&RowData.Secure_Work_Environment_SWE_Std_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Secure_Work_Environment_SWE_Std_Use_USF__c; 
        } else if (spaceType == 'Secure Work Environment: Enhanced' &&RowData.Secure_Work_Environment_SWE_Enhd_UseUSF__c != null){
            TIItemSqFt = (Decimal) RowData.Secure_Work_Environment_SWE_Enhd_UseUSF__c;
        } else if (spaceType == 'Secured Storage/SCIF Standard' &&RowData.Secured_Storage_SCIF_Standard_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Secured_Storage_SCIF_Standard_Use_USF__c;
        } else if (spaceType == 'Secured Storage/SCIF Enhanced' &&RowData.Secured_Storage_SCIF_Enhanced_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Secured_Storage_SCIF_Enhanced_Use_USF__c;
        } else if (spaceType == 'Firing Range' &&(Decimal) RowData.Firing_range_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Firing_range_Use_USF__c;
        } else if (spaceType == 'Public Transaction Space, Tenant Improvement' &&RowData.Transaction_counter_space_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Transaction_counter_space_Use_USF__c; 
        }  else if (spaceType == 'Detention Suite - exc holding, Tenant Improvement' &&RowData.Interview_Detention_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Interview_Detention_Use_USF__c;
        } else if (spaceType == 'Holding Cell - Single, Tenant Improvement' &&RowData.Non_Marshal_Holding_Cell_Single_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Non_Marshal_Holding_Cell_Single_Use_USF__c;
        } else if (spaceType == 'Holding Cell - Group, Tenant Improvement' &&RowData.Non_Marshal_Holding_Cell_Double_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Non_Marshal_Holding_Cell_Double_Use_USF__c;
        } else if (spaceType == 'Shower and Locker Rooms, Tenant Improvement' &&RowData.Locker_Shower_room_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Locker_Shower_room_Use_USF__c;
        } else if (spaceType == 'Kitchen-Break room, Tenant Improvement' &&RowData.Kitchen_Break_room_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Kitchen_Break_room_Use_USF__c; 
        } else if (spaceType == 'Vaults/Secure Storage, Tenant Improvement' &&RowData.Vault_Type_Storage_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Vault_Type_Storage_Use_USF__c;
        } else if (spaceType == 'Medical Spaces - Exam Suite' &&RowData.VA_Exam_Suite_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.VA_Exam_Suite_Use_USF__c; 
        } else if (spaceType == 'Medical Spaces - Ambulatory Surgery' &&RowData.VA_Ambulatory_Surgery_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.VA_Ambulatory_Surgery_Use_USF__c;
        } else if (spaceType == 'Medical Spaces - Infusion' &&RowData.VA_Infusion_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.VA_Infusion_Use_USF__c; 
        } else if (spaceType == 'Medical Spaces - Intake' &&RowData.VA_Intake_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.VA_Intake_Use_USF__c;
        } else if (spaceType == 'Medical Spaces - Pharmacy' &&RowData.VA_Pharmacy_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.VA_Pharmacy_Use_USF__c; 
        } else if (spaceType == 'Medical Spaces - Radiology' &&RowData.VA_Radiology_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.VA_Radiology_Use_USF__c;
        } else if (spaceType == 'Data Center' &&RowData.Data_Center_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Data_Center_Use_USF__c;                         
        } else if (spaceType == 'Mailroom' &&RowData.Mailroom_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Mailroom_Use_USF__c;                         
        }else if (spaceType == 'Secure Mailroom' &&RowData.Secure_Mailroom_Use_USF__c != null){
            TIItemSqFt = (Decimal) RowData.Secure_Mailroom_Use_USF__c;                         
        }else {    
            TIItemSqFt = 0.00;
        }
        if (TIItemSqFt == null) TIItemSqFt = 0;
        return TIItemSqFt;
    }

    
    public void DeleteEscalationData (ID ProjectID) {
        List <NCMT_Escalation__c> lstDelete = [select ID from NCMT_Escalation__c Where Project__c = :ProjectID limit 50000] ;
        if(lstDelete.size() > 0) Delete lstDelete;
    }
    
    public void GenerateEscalationData(ID ProjectID, Decimal dblStandardRate, Date dtCostParameterDate, Date dtConstructionEndDate, string txtCostParameterDateFY, string txtConstructionEndDateFY, Date dtConstructionStartDate, Date dtmidconstructiondate){
        Decimal dblRateCumulative = 0.00;
        Decimal dblRateCumulativeCPE = 0.00;
        Decimal dblRateYearly = 0.00;
        Decimal dblRateYearlyCPE = 0.00;
        
        Decimal dblStandardRateCPE = (Decimal)([SELECT Value__c FROM System_Level_Parameter__c Where Category__c = 'Escalation' And Name = 'CPE Escalation' Limit 1][0].get('Value__c'));
        Date    dtStartFYDate,dtStartFYDateCPE;
        Date    dtEndFYDate, AnticipatedDesignDate;
        integer intMonths,intMonthsCPE;
        integer ForLoopsYears;
        integer intDesignDateFY;
        List<NCMT_Escalation__c> objProjectEscalationRecords = New List<NCMT_Escalation__c>();
        intDesignDateFY = 0;
        NCMT_Project__c NCMTRec = [Select ID, Building_Quality__c, Project_Type__c,Estimate_Type_Proj__c,Anticipated_Date_of_Design_Award__c From NCMT_Project__c Where ID = :ProjectID];
        If(NCMTRec.Estimate_Type_Proj__c == 'Parametric'){
            AnticipatedDesignDate = NCMTRec.Anticipated_Date_of_Design_Award__c;
            intDesignDateFY = Integer.ValueOf(AnticipatedDesignDate.Month() > 9? AnticipatedDesignDate.Year() + 1 : AnticipatedDesignDate.Year());
        }
        If (dtConstructionEndDate == Null){ 
            dtConstructionEndDate = dtCostParameterDate;
            txtConstructionEndDateFY = txtCostParameterDateFY;
        }
        
        If(NCMTRec.Estimate_Type_Proj__c == 'Definitive Estimating' || NCMTRec.Estimate_Type_Proj__c == 'Cost Estimating Workbook'){
            dtConstructionStartDate = dtCostParameterDate;
            dtConstructionEndDate = dtmidconstructiondate;
        }
         
        If(NCMTRec.Estimate_Type_Proj__c != 'Definitive Estimating' && NCMTRec.Estimate_Type_Proj__c != 'Cost Estimating Workbook'){
            dtConstructionEndDate = dtConstructionStartDate.addDays(dtConstructionStartDate.daysBetween(dtConstructionEndDate)/2);
        }else{
            dtConstructionEndDate = dtConstructionStartDate.addDays(dtConstructionStartDate.daysBetween(dtConstructionEndDate));
        }
         
        txtConstructionEndDateFY = String.ValueOf(dtConstructionEndDate.Month() > 9? dtConstructionEndDate.Year() + 1 : dtConstructionEndDate.Year());
        system.debug('txtConstructionEndDateFY==='+txtConstructionEndDateFY);
        dtEndFYDate = Date.newInstance(Integer.ValueOf(txtCostParameterDateFY), 9, 30);
        dtStartFYDate = Date.newInstance(Integer.ValueOf(txtConstructionEndDateFY) - 1, 10, 1);
        If(NCMTRec.Estimate_Type_Proj__c == 'Parametric'){
            dtStartFYDateCPE = Date.newInstance(Integer.ValueOf(intDesignDateFY) - 1, 10, 1);
        }
         if (intDesignDateFY> Integer.ValueOf(txtConstructionEndDateFY))
         {
            ForLoopsYears = intDesignDateFY;
         }
         else{
            ForLoopsYears = Integer.ValueOf(txtConstructionEndDateFY);
         }
        for (Integer intFY = Integer.ValueOf(txtCostParameterDateFY); intFY <= Integer.ValueOf(ForLoopsYears); intFY ++){
            system.debug('intFY==='+intFY);
            If (Integer.ValueOf(txtCostParameterDateFY) == Integer.ValueOf(txtConstructionEndDateFY)){
                    intMonths = dtCostParameterDate.monthsBetween(dtConstructionEndDate) + 1;
                    
                    dblRateYearly = (intMonths * dblStandardRate) / 12;
                    dblRateYearlyCPE = (intMonths * dblStandardRateCPE) / 12;
                    //dblRateCumulative += (intMonths * dblStandardRate) / 12;
                    //dblRateCumulativeCPE += (intMonths * dblStandardRateCPE) / 12;
                    dblRateCumulative = dblstandardrate; //+ (dblRateCumulative * (1 + dblstandardrate/100));
                    dblRateCumulative = (intMonths * dblRateCumulative) / 12;
                    dblRateCumulativeCPE = dblStandardRateCPE; //+ (dblRateCumulativeCPE * (1 + dblStandardRateCPE/100));
                    dblRateCumulativeCPE = (intMonths * dblRateCumulativeCPE) / 12;
                IF(NCMTRec.Estimate_Type_Proj__c == 'Parametric'){    //Added for NCMT Release 6.0
                   intMonthsCPE = dtCostParameterDate.monthsBetween(NCMTRec.Anticipated_Date_of_Design_Award__c) + 1;  
                   dblRateYearlyCPE = (intMonthsCPE * dblStandardRateCPE) / 12;
                   dblRateCumulativeCPE = (intMonthsCPE * dblRateCumulativeCPE) / 12; 
                }
            } else If (intFY == Integer.ValueOf(txtCostParameterDateFY)){
                intMonths = dtCostParameterDate.monthsBetween(dtEndFYDate) + 1; 
                
                dblRateYearly = (intMonths * dblStandardRate) / 12;
                dblRateYearlyCPE = (intMonths * dblStandardRateCPE) / 12;
                //dblRateCumulative += (intMonths * dblStandardRate) / 12;
                //dblRateCumulativeCPE += (intMonths * dblStandardRateCPE) / 12;
                dblRateCumulative = dblstandardrate; //+ (dblRateCumulative * (1 + dblstandardrate/100));
                dblRateCumulative = (intMonths * dblRateCumulative) / 12;
                dblRateCumulativeCPE = dblStandardRateCPE; //+ (dblRateCumulativeCPE * (1 + dblStandardRateCPE/100));
                dblRateCumulativeCPE = (intMonths * dblRateCumulativeCPE) / 12;
                IF(NCMTRec.Estimate_Type_Proj__c == 'Parametric'){
                    IF(intFY == intDesignDateFY){
                        intMonthsCPE = dtCostParameterDate.monthsBetween(NCMTRec.Anticipated_Date_of_Design_Award__c) + 1; 
                    }else{
                        intMonthsCPE = dtCostParameterDate.monthsBetween(dtEndFYDate) + 1;
                    }
                        dblRateYearlyCPE = (intMonthsCPE * dblStandardRateCPE) / 12;
                   dblRateCumulativeCPE = (intMonthsCPE * dblRateCumulativeCPE) / 12; 
                }
            } else if (intFY == Integer.ValueOf(ForLoopsYears)) {
                 //system.debug('intFY==='+intFY);
                //system.debug('txtConstructionEndDateFY==='+txtConstructionEndDateFY);
                intMonths = dtStartFYDate.monthsBetween(dtConstructionEndDate) + 1;
                
                dblRateYearly = (intMonths * dblStandardRate) / 12;
                dblRateYearlyCPE = (intMonths * dblStandardRateCPE) / 12;
                //dblRateCumulative += (intMonths * dblStandardRate) / 12;
                //dblRateCumulativeCPE += (intMonths * dblStandardRateCPE) / 12;
                dblRateCumulative += (dblstandardrate + (dblRateCumulative * (dblstandardrate/100))) * intMonths/12;
                //dblRateCumulative += (intMonths * dblRateCumulative) / 12;
                dblRateCumulativeCPE += (dblStandardRateCPE + (dblRateCumulativeCPE * (dblStandardRateCPE/100))) * intMonths/12;
                //dblRateCumulativeCPE += (intMonths * dblRateCumulativeCPE) / 12;
                IF(NCMTRec.Estimate_Type_Proj__c == 'Parametric'){
                   intMonthsCPE = dtStartFYDateCPE.monthsBetween(NCMTRec.Anticipated_Date_of_Design_Award__c) + 1; 
                   dblRateYearlyCPE = (intMonthsCPE * dblStandardRateCPE) / 12;
                   dblRateCumulativeCPE += (dblStandardRateCPE + (dblRateCumulativeCPE * (dblStandardRateCPE/100))) * intMonthsCPE/12;
                }
                //system.debug('intMonthsCPE==='+intMonthsCPE);
                //system.debug('dblRateYearlyCPE==='+dblRateYearlyCPE);
                //system.debug('dblRateCumulativeCPE==='+dblRateCumulativeCPE);
            } else {
                IF(intFY == Integer.ValueOf(txtConstructionEndDateFY)){
                    intMonths = intMonths = dtStartFYDate.monthsBetween(dtConstructionEndDate) + 1;
                }else{
                    intMonths = 12;
                }
                //intMonths = 12;
                //intMonthsCPE = 12;
                
                Date intFYDate = Date.newInstance(Integer.ValueOf(intFY) - 1, 10, 1);
                IF(intFY == intDesignDateFY){
                    intMonthsCPE = intFYDate.monthsBetween(NCMTRec.Anticipated_Date_of_Design_Award__c) + 1;
                }else{
                    intMonthsCPE = 12;
                }
                dblRateYearly = dblStandardRate;
                dblRateYearlyCPE = dblStandardRateCPE;
                //dblRateCumulative += dblStandardRate;
                //dblRateCumulativeCPE += dblStandardRateCPE;
                dblRateCumulative = dblstandardrate + (dblRateCumulative * (1 + dblstandardrate/100));
                dblRateCumulativeCPE = dblStandardRateCPE + (dblRateCumulativeCPE * (1 + dblStandardRateCPE/100));
            }
            system.debug('intMonths==='+intMonths);
            if (intFY <= Integer.ValueOf(txtConstructionEndDateFY))
            {
                objProjectEscalationRecords.Add(new NCMT_Escalation__c(
                    Project__c = ProjectID,
                    FY__c = String.valueOf(intFY),
                    Escalation_Type__c = 'Market Escalation',
                    Yearly_Escalation__c = dblRateYearly,
                    Escalation_Percentage__c = Math.Abs(dblRateCumulative),
                    Duration__c  = intMonths
                ));
            }
            if (intFY <= intDesignDateFY)
            {
                If(NCMTRec.Building_Quality__c != 'Class A'  && NCMTRec.Building_Quality__c != 'Code Minimum'  && NCMTRec.Project_Type__c != 'Repair & Alteration - Parametric Entry' && NCMTRec.Project_Type__c != 'Repair & Alteration - Work Item Detail' && NCMTRec.Estimate_Type_Proj__c!='Definitive Estimating' && (intFY <= intDesignDateFY)){
                        
                        objProjectEscalationRecords.Add(new NCMT_Escalation__c(
                            Project__c = ProjectID,
                            FY__c = String.valueOf(intFY),
                            Escalation_Type__c = 'Code & Practice Escalation',
                            Yearly_Escalation__c = dblRateYearlyCPE,
                            Escalation_Percentage__c = Math.Abs(dblRateCumulativeCPE),
                            Duration__c  = intMonthsCPE
                        ));
                }
            }
        }
        
        If(NCMTRec.Estimate_Type_Proj__c == 'Parametric'){
            IF(dtCostParameterDate > AnticipatedDesignDate) { 
                objProjectEscalationRecords.Add(new NCMT_Escalation__c(
                            Project__c = ProjectID,
                            FY__c = String.valueOf(intDesignDateFY),
                            Escalation_Type__c = 'Code & Practice Escalation',
                            Yearly_Escalation__c = 0,
                            Escalation_Percentage__c = 0,
                            Duration__c  = 0
                        ));
            }
        }
        
        // If we don't see any escalations, enter defaults -  based on what we saw in the old system
        Integer intConstructionStartDateFY = dtConstructionStartDate.Month() > 9? dtConstructionStartDate.Year() + 1 : dtConstructionStartDate.Year();
        Integer intEscDefaultFY;
        If (intConstructionStartDateFY > Integer.ValueOf(txtCostParameterDateFY)){
            intEscDefaultFY = Integer.ValueOf(txtCostParameterDateFY) + 1;
        }else{
            intEscDefaultFY = Integer.ValueOf(txtCostParameterDateFY);
        }
        
        if (objProjectEscalationRecords.Size() == 0)
        {
            objProjectEscalationRecords.Add(new NCMT_Escalation__c(
                Project__c = ProjectID,
                FY__c = String.valueOf(intEscDefaultFY),
                Escalation_Type__c = 'Market Escalation',
                Yearly_Escalation__c = dblStandardRate,
                Escalation_Percentage__c = dblStandardRate,
                Duration__c  = 12
            ));
            
            If(NCMTRec.Building_Quality__c != 'Class A' && NCMTRec.Building_Quality__c != 'Code Minimum'  && NCMTRec.Project_Type__c != 'Repair & Alteration - Parametric Entry' && NCMTRec.Project_Type__c != 'Repair & Alteration - Work Item Detail'){         
                   
                    objProjectEscalationRecords.Add(new NCMT_Escalation__c(
                            Project__c = ProjectID,
                            FY__c =  String.valueOf(intEscDefaultFY),
                            Escalation_Type__c = 'Code & Practice Escalation',
                            Yearly_Escalation__c = dblStandardRateCPE,
                            Escalation_Percentage__c = dblStandardRateCPE,
                            Duration__c  = 12
                        ));
            }
        }
        
        System.debug('Inserting Escalation records ===== ' + objProjectEscalationRecords.size());
        insert objProjectEscalationRecords;
    }
    
    public void AdjustEscalationData(ID ProjectID){

        List <NCMT_Escalation__c> objUpdatedEscalationRecords = New List<NCMT_Escalation__c>();
        List <NCMT_Escalation__c> lstEscalationsMarket = [select ID, Yearly_Escalation__c, Escalation_Percentage__c from NCMT_Escalation__c Where Project__c = :ProjectID And Escalation_Type__c = 'Market Escalation' limit 50000];
        List <NCMT_Escalation__c> lstEscalationsCPE =    [select ID, Yearly_Escalation__c, Escalation_Percentage__c from NCMT_Escalation__c Where Project__c = :ProjectID And Escalation_Type__c = 'Code & Practice Escalation' limit 50000];
        NCMT_Project__c NCMTRec = [Select ID, Building_Quality__c, Project_Type__c From NCMT_Project__c Where ID = :ProjectID];
        
        Boolean blnFirstRecord = true;
        Decimal dblCummulative = 0.00;
        
        for(NCMT_Escalation__c objRecord: lstEscalationsMarket) {
            If (blnFirstRecord){
                dblCummulative = (Decimal) objRecord.Yearly_Escalation__c;
            } else {
                dblCummulative = dblCummulative + (Decimal) objRecord.Yearly_Escalation__c;
            }   
            
            objUpdatedEscalationRecords.Add(new NCMT_Escalation__c(
                ID = objRecord.ID,
                Escalation_Percentage__c = dblCummulative
            ));

            blnFirstRecord = false; 
        }
        
        blnFirstRecord = true;
        dblCummulative = 0.00;
        
        
            for(NCMT_Escalation__c objRecord: lstEscalationsCPE) {
                If (blnFirstRecord){
                    dblCummulative = (Decimal) objRecord.Yearly_Escalation__c;
                } else {
                    dblCummulative = dblCummulative + (Decimal) objRecord.Yearly_Escalation__c;
                }   
                If(NCMTRec.Building_Quality__c != 'Class A' && NCMTRec.Building_Quality__c != 'Code Minimum' && NCMTRec.Project_Type__c != 'Repair & Alteration - Parametric Entry' && NCMTRec.Project_Type__c != 'Repair & Alteration - Work Item Detail'){
                        objUpdatedEscalationRecords.Add(new NCMT_Escalation__c(
                        ID = objRecord.ID,
                        Escalation_Percentage__c = dblCummulative
                    ));
                }
    
                blnFirstRecord = false; 
            }
        
        System.debug('Updating Escalations ===== ' + objUpdatedEscalationRecords);
        Update objUpdatedEscalationRecords;
        
    }
    
    public static void Update_Leed_Checklist(list<NCMT_LEED_Checklist__c> triggerVariable){
        
                string txtOldCostCategory = '000000000000000000'; 
                ID idOldCostCategory = (ID) txtOldCostCategory; 
                ID idNewCostCategory;
                Double dblCostCategoryAmount = 0.00;
                boolean blnHasData = false;
                Map<ID, Double> MapCostSumByCategory = new Map<ID, Double>();
                string strFiscalYear;
                string strBuildingQuality;
                set<id> ncmtleedIDs = new set<id>();
                
                ID idProjectID;
                string str1;
                for(NCMT_LEED_Checklist__c  objLeedData:triggerVariable) {
                ncmtleedIDs.add(objLeedData.id);
                }
                
                list<NCMT_LEED_Checklist__c> NcmtLeedList = [Select Project__r.Cost_Parameter_Date_FY__c, Project__r.Building_Quality__c
                                                               From NCMT_LEED_Checklist__c
                                                               Where id In :ncmtleedIDs];
             
                //Current Record Data
                for (NCMT_LEED_Checklist__c  objLeedData:NcmtLeedList){
                    idProjectID = objLeedData.Project__c;
                    strFiscalYear =objLeedData.Project__r.Cost_Parameter_Date_FY__c;
                    strBuildingQuality = objLeedData.Project__r.Building_Quality__c;
                    str1= (strBuildingQuality).substringbefore(':').replaceAll(' ', '_').replaceAll('\\s+', '') + '_Percent__c';    
                }
                //Current Record Data
            for(NCMT_LEED_Checklist__c objLeedProj: triggerVariable){
                // Loop and aggregate by Category
                for (NCMT_LEED_Parameter__c objRecord : [Select  Cost_Category__c, LEED_Category__c, LEED_Max_Points__c, Code_Minimum_Percent__c, Class_A_Percent__c, P100_Percent__c,Total_Points__c
                                                           FROM  NCMT_LEED_Parameter__c 
                                                          Where  Fiscal_Year__c = :strFiscalYear
                                                        Order by Cost_Category__c, LEED_Category__c]){
                    blnHasData = true;
                    
                    idNewCostCategory = objRecord.Cost_Category__c;
                    // Id has changed, update the Map ...
                    if ((idNewCostCategory <> idOldCostCategory) && (idOldCostCategory <> '000000000000000000')){
                        System.Debug('MyDebug - idOldCostCategory - ' + idOldCostCategory + '-%-' + dblCostCategoryAmount);
                        MapCostSumByCategory.Put(idOldCostCategory, dblCostCategoryAmount);
                        dblCostCategoryAmount = 0.00;
                    }
                
                    If (objRecord.LEED_Category__c == 'Integrative Process' && objLeedProj.LEED_USR_Mod_IP_1__c  == objRecord.LEED_Max_Points__c){
                        dblCostCategoryAmount += (Decimal) objRecord.get(str1);
                    } else If (objRecord.LEED_Category__c == 'LEED for Neighborhood Development Location' && objLeedProj.LEED_USR_Mod_LT_1__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Sensitive Land Protection' && objLeedProj.LEED_USR_Mod_LT_2__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'High Priority Site' && objLeedProj.LEED_USR_Mod_LT_3__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Surrounding Density and Diverse Uses' && objLeedProj.LEED_USR_Mod_LT_4__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Access to Quality Transit' && objLeedProj.LEED_USR_Mod_LT_5__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Bicycle Facilities' && objLeedProj.LEED_USR_Mod_LT_6__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Reduced Parking Footprint' && objLeedProj.LEED_USR_Mod_LT_7__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Green Vehicles' && objLeedProj.LEED_USR_Mod_LT_8__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Construction Activity Pollution Prevention'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);         
                    } else If (objRecord.LEED_Category__c == 'Site Assessment'  && objLeedProj.LEED_USR_Mod_SS_1__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Site Development - Protect or Restore Habitat' && objLeedProj.LEED_USR_Mod_SS_2__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);         
                    } else If (objRecord.LEED_Category__c == 'Open Space' && objLeedProj.LEED_USR_Mod_SS_3__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Rainwater Management' && objLeedProj.LEED_USR_Mod_SS_4__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Heat Island Reduction' && objLeedProj.LEED_USR_Mod_SS_5__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Light Pollution Reduction' && objLeedProj.LEED_USR_Mod_SS_6__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Outdoor Water Use Reduction'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1); 
                    } else If (objRecord.LEED_Category__c == 'Indoor Water Use Reduction'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1); 
                    } else If (objRecord.LEED_Category__c == 'Building-Level Water Metering'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);                     
                    } else If (objRecord.LEED_Category__c == 'Outdoor Water Use Reduction - Credit' && objLeedProj.LEED_USR_Mod_WE_1__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Indoor Water Use Reduction - Credit' && objLeedProj.LEED_USR_Mod_WE_2__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Cooling Tower Water Use' && objLeedProj.LEED_USR_Mod_WE_3__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Water Metering' && objLeedProj.LEED_USR_Mod_WE_4__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1); 
                    } else If (objRecord.LEED_Category__c == 'Fundamental Commissioning and Verification'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1); 
                    } else If (objRecord.LEED_Category__c == 'Minimum Energy Performance'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1); 
                    } else If (objRecord.LEED_Category__c == 'Building-Level Energy Metering'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1); 
                    } else If (objRecord.LEED_Category__c == 'Fundamental Refrigerant Management'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);                                  
                    } else If (objRecord.LEED_Category__c == 'Enhanced Commissioning' && objLeedProj.LEED_USR_Mod_EA_1__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Optimize Energy Performance' && objLeedProj.LEED_USR_Mod_EA_2__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Advanced Energy Metering' && objLeedProj.LEED_USR_Mod_EA_3__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Demand Response' && objLeedProj.LEED_USR_Mod_EA_4__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Renewable Energy Production' && objLeedProj.LEED_USR_Mod_EA_5__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Enhanced Refrigerant Management' && objLeedProj.LEED_USR_Mod_EA_6__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Green Power and Carbon Offsets' && objLeedProj.LEED_USR_Mod_EA_7__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1); 
                    } else If (objRecord.LEED_Category__c == 'Storage and Collection of Recyclables'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1); 
                    } else If (objRecord.LEED_Category__c == 'Construction and Demolition Waste Management Planning'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);                  
                    } else If (objRecord.LEED_Category__c == 'Building Life-Cycle Impact Reduction' && objLeedProj.LEED_USR_Mod_MR_1__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Building Product Disclosure and Optimization - Environmental Product Declarations' && objLeedProj.LEED_USR_Mod_MR_2__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Building Product Disclosure and Optimization - Sourcing of Raw Materials' && objLeedProj.LEED_USR_Mod_MR_3__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Building Product Disclosure and Optimization - Material Ingredients' && objLeedProj.LEED_USR_Mod_MR_4__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Construction and Demolition Waste Management - Credit' && objLeedProj.LEED_USR_Mod_MR_5__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1); 
                    } else If (objRecord.LEED_Category__c == 'Minimum Indoor Air Quality Performance'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);
                    } else If (objRecord.LEED_Category__c == 'Environmental Tobacco Smoke Control'){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);              
                    } else If (objRecord.LEED_Category__c == 'Enhanced Indoor Air Quality Strategies' && objLeedProj.LEED_USR_Mod_IEQ_1__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Low-Emitting Materials' && objLeedProj.LEED_USR_Mod_IEQ_2__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Construction Indoor Air Quality Management Plan'  && objLeedProj.LEED_USR_Mod_IEQ_3__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Indoor Air Quality Assessment' && objLeedProj.LEED_USR_Mod_IEQ_4__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Thermal Comfort' && objLeedProj.LEED_USR_Mod_IEQ_5__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Interior Lighting' && objLeedProj.LEED_USR_Mod_IEQ_6__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Daylight' && objLeedProj.LEED_USR_Mod_IEQ_7__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Quality Views' && objLeedProj.LEED_USR_Mod_IEQ_8__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Acoustic Performance' && objLeedProj.LEED_USR_Mod_IEQ_9__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Innovation' && objLeedProj.LEED_USR_Mod_Innovation_1__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'LEED Accredited Professional' && objLeedProj.LEED_USR_Mod_Innovation_2__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else If (objRecord.LEED_Category__c == 'Regional Priority: Specific Credit' && objLeedProj.LEED_USR_Mod_RP_1__c == objRecord.LEED_Max_Points__c){
                            dblCostCategoryAmount += (Decimal) objRecord.get(str1);  
                    } else {
                        dblCostCategoryAmount += 0.00;
                    }
                    // assign old as loop ends ...
                    idOldCostCategory = idNewCostCategory; 
                }
                // Loop and aggregate by Category
            }
                //One Last ID ...
                if (blnHasData = true){
                    MapCostSumByCategory.Put(idOldCostCategory, dblCostCategoryAmount); 
                }
                
                // The Map is ready with the associated Leed Costs; loop through the cost summary for that Project and start updating the numbers ...
                List<NCMT_Project_Cost_Summary__c> objCostSummaryRecords = New List<NCMT_Project_Cost_Summary__c>();
                for (Id key : MapCostSumByCategory.keySet()) {
                    System.Debug('MyDebug - Loop - ' + string.ValueOf(idProjectID).Left(15) + '||' + string.ValueOf(Key).Left(15));
                    System.Debug('MyDebug - Loop - % age - ' + string.ValueOf((Decimal) MapCostSumByCategory.get(key)));
                    objCostSummaryRecords.Add(new NCMT_Project_Cost_Summary__c(
                        External_Key__c = string.ValueOf(idProjectID).Left(15) + '||' + string.ValueOf(Key).Left(15),
                        Leed_Percentage__c = (Decimal) MapCostSumByCategory.get(key)
                    ));                                     
                }
                
                try{    
                    database.UpsertResult[] results = Database.Upsert(objCostSummaryRecords, Schema.NCMT_Project_Cost_Summary__c.External_Key__c, false);
                }catch (Exception e){
                    System.debug('MyDebug - Upsert error - ' + e.getMessage());
                }
        
    }
    
    public void Update_RA_Phasing(set<id> RAPhaseID, set<ID> NCMTRAProjId){
        
        
        Decimal totalprojectcost = 0, dblphasingcondpercent = 0, dblbaseesc = 0, fieldgcrange = 0, homegcrange =0, totalcost = 0, escalationmonths = 0, totalescpercent = 0;
        string strWorkConditions, strColumnToPick, str1,ncmtprojId;
        string strFiscalYear, strProjectType;
        date dtCostParamDate;
        map<id,NCMT_Project__c > ncmtmap = new map<id,NCMT_Project__c >();
        map<string,NCMT_RA_Overhead_Analysis__c> RAOverheadAnalysisMap = new map<string,NCMT_RA_Overhead_Analysis__c>();
        list<NCMT_RA_Overhead_Analysis__c> lstOverheadAnalysis = new list<NCMT_RA_Overhead_Analysis__c> ();
        NCMT_RA_Phasing__c RAPhasinglist = new NCMT_RA_Phasing__c();
        list<NCMT_RA_Phasing__c> RAPhasingUpdatelist = new list<NCMT_RA_Phasing__c> ();
        
        for(NCMT_Project__c  Proj :[SELECT id, Project_Type__c, Cost_Parameter_Date_FY__c, Total_Project_Cost__c, Cost_Parameter_Date__c,
                                            Level_of_Program_Definition__c
                                     FROM NCMT_Project__c 
                                    WHERE id In :NCMTRAProjId]) {
            ncmtmap.put(Proj.Id,Proj);  
            strFiscalYear = Proj.Cost_Parameter_Date_FY__c;
            strProjectType = Proj.Project_Type__c;
            dtcostParamDate = Proj.Cost_Parameter_Date__c;
        }
        
        RAPhasinglist = [SELECT Anticipated_Phasing__c,Project__c ,Design_Contingency__c, Work_Conditions__c, Home_Office_Overhead_Bond_Profit__c, 
                                On_site_General_Special_Conditions__c, Escalation_Months__c, Total_Cost__c  
                           FROM NCMT_RA_Phasing__c 
                          WHERE Project__c IN :NCMTRAProjId and id IN :RAPhaseID
                          ORDER BY name limit 1];                             
                     
        // for(NCMT_RA_Phasing__c ncmt : RAPhasinglist) {
            
              ncmtprojId = RAPhasinglist.Project__c;              
              strWorkConditions = RAPhasinglist.Work_Conditions__c;
              escalationmonths = RAPhasinglist.Escalation_Months__c;
              str1= (strWorkConditions).replaceAll(' ', '_').replaceAll('\\s+', '').replaceAll(':', '') + '__c';
        //  }             
                           
        NCMT_Project__c ncmtproj1 = ncmtmap.get(ncmtprojId);
        
        //for calculating Design Contingency percent
        RAPhasinglist.Design_Contingency__c = decimal.valueof(ncmtproj1.Level_of_Program_Definition__c);
               
        //for calculating totalprojectcost
        if(strProjectType == 'Repair & Alteration - Parametric Entry'){
            totalprojectcost = ncmtproj1.Total_Project_Cost__c * (RAPhasinglist.Anticipated_Phasing__c/100);
        }else if(strProjectType == 'Repair & Alteration - Work Item Detail'){
            totalprojectcost = RAPhasinglist.Total_Cost__c;
        } 
        
        totalprojectcost = totalprojectcost + (totalprojectcost * (RAPhasinglist.Design_Contingency__c/100));
 
        string key = '';
        list<integer> numbers = new list<integer>{0,50000,100000,250000,500000,1000000,2500000,5000000,10000000,25000000,50000000,100000000,250000000,500000000};
        for(integer i=0;i<=numbers.size()-1;i++) {
            if(totalprojectcost >= 0){
                if(totalprojectcost >=numbers[i] && totalprojectcost <=numbers[i+1] )
                key = string.valueof(numbers[i]);
            }
        }
        if(key!=null)
        totalcost = decimal.valueof(key);
        
        lstOverheadAnalysis = [Select  Fully_occupied__c, Fully_vacant_building__c, New__c, Overhead_Type__c, Partially_vacant_work_area__c,
                                        Vacant_work_area_clear_path_travel__c, Vacant_work_area_difficult_path_travel__c
                                FROM  NCMT_RA_Overhead_Analysis__c 
                                Where  Fiscal_Year__c = :strFiscalYear and Contract_Amount__c = :totalcost
                                Order by name, Overhead_Type__c];
        
        for (NCMT_RA_Overhead_Analysis__c objRecord : lstOverheadAnalysis){ 
                                                            
            
                   RAOverheadAnalysisMap.put(objRecord.Overhead_Type__c,objRecord);                                         
                                                            
        }  
         NCMT_RA_Overhead_Analysis__c temp = RAOverheadAnalysisMap.get('GC Overhead & Profit - Home Office, Bond & Profit');
         homegcrange = (Decimal) temp.get(str1);
         NCMT_RA_Overhead_Analysis__c temp1 = RAOverheadAnalysisMap.get('Field Special and General Conditions');
         fieldgcrange = (Decimal) temp1.get(str1);
         
        RAPhasinglist.On_site_General_Special_Conditions__c = fieldgcrange;
        
        RAPhasinglist.Home_Office_Overhead_Bond_Profit__c = homegcrange; 
            
      RAPhasingUpdatelist.add(RAPhasinglist); 
      system.debug('RAPhasingUpdatelist=='+RAPhasingUpdatelist);       
                     
       update RAPhasingUpdatelist;  
        
    }
    
}