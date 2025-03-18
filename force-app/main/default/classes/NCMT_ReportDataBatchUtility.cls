public with sharing class NCMT_ReportDataBatchUtility {
    public static void copyReportDataToObject( List<Id> projectIds){
        List<NCMT_Uniformat_Data__c> ncmtUniformatsToInsert =new List<NCMT_Uniformat_Data__c>();
        
        decimal dblCPEEsc,dblMarkEsc = 0;
        Map<Id,reportData> reportDataMap =  getProjectData(projectIds);
        Map<Id,Decimal> projectSubtotalMap =  New Map<Id,Decimal>();
        Map<Id,NCMT_Project__c> projectdetailMap =  New Map<Id,NCMT_Project__c>();
        Map<Id,List<NCMT_Uniformat_Data__c>> projectncmtUniformatToInsertMap =  New Map<Id,List<NCMT_Uniformat_Data__c>>();
         //system.debug(':::reportDataMap:::'+reportDataMap.keySet());
        for(String projectId : reportDataMap.keySet()){
            NCMT_Project__c projectDetails;
            
            projectncmtUniformatToInsertMap.put(projectId, new List<NCMT_Uniformat_Data__c>());
            
            reportData  projectReportData= reportDataMap.get(projectId);
            NCMT_Uniformat_Data__c ncmtsubtotal =  new NCMT_Uniformat_Data__c();
            ncmtsubtotal.Core_Shell_Cost__c=0;
            ncmtsubtotal.Tenant_Imp_Cost__c=0;
            ncmtsubtotal.TRCS_Cost__c=0;
            ncmtsubtotal.Blast_Security_Cost__c=0;
            ncmtsubtotal.Parking_Cost__c=0;
            ncmtsubtotal.Total_Cost__c=0;
            ncmtsubtotal.Work_Description__c = 'SubTotal'; 
                       
            for(NCMT_Project_Cost_Summary__c projCost : projectReportData.projCostSummaryData){
                projectDetails = projCost.Project_Name__r;
                projectdetailMap.put(projCost.Project_Name__r.Id,projCost.Project_Name__r);
                
                ncmtsubtotal.Project_ID__c = projCost.Project_Name__r.Id;
                ncmtsubtotal.Project_Name__c = projCost.Project_Name__r.Name;
                NCMT_Uniformat_Data__c ncmtUniformat =  new NCMT_Uniformat_Data__c();
                ncmtUniformat.Project_ID__c = projCost.Project_Name__r.Id;
                ncmtUniformat.Project_Name__c = projCost.Project_Name__r.Name;
                ncmtUniformat.Code__c = projCost.Cost_Category_Code__c;
                ncmtUniformat.Work_Description__c = projCost.Cost_Category_Description__c;
         
                ncmtUniformat.Core_Shell_Cost__c = projCost.Core_Shell_Cost_Adj__c + projCost.Other_Core_Shell_Cost__c;
                ncmtUniformat.TRCS_Cost__c = projCost.TRCS_Cost_Adjusted__c;
                ncmtUniformat.Tenant_Imp_Cost__c = projCost.TI_Cost_Adjusted__c + projCost.Oth_TI_Cst__c;
                ncmtUniformat.Blast_Security_Cost__c = projCost.Security_Cost_Adjusted__c + projCost.Other_Direct_Security_Costs__c;
                ncmtUniformat.Parking_Cost__c = projCost.Parking_Cost_Adjusted__c;
                ncmtUniformat.Total_Cost__c = projCost.Total_Cost_Adjusted__c;
                ncmtUniformat.ECCA__c = projCost.ECCA__c;
                ncmtUniformat.ECC__c = projCost.ECC__c;
                ncmtUniformat.ETPC__c = projCost.ECC__c * (1 + projCost.Project_Name__r.EDRC__c/100 + projCost.Project_Name__r.EMIC__c/100);
                ncmtUniformat.Oth_Direct_Cost_GSF__c = projCost.Other_Direct_Cost_GSF__c;
                ncmtUniformat.Direct_Cost_GSF__c = projCost.Direct_Cost_GSF__c;
                ncmtUniformat.ECC_GSF__c = projCost.ECC_GSF__c;
                ncmtUniformat.ECCA_GSF__c = projCost.ECCA_GSF__c;
                IF(projectReportData.PLPData.NCMT_Project__r.Building_Type__c <> 'Parking_Garage'){
                    ncmtUniformat.ETPC_GSF__c = ncmtUniformat.ETPC__c/projCost.Project_Name__r.Total_GSF__c;
                }else{
                    ncmtUniformat.ETPC_GSF__c = ncmtUniformat.ETPC__c/projCost.Project_Name__r.Parking_Garage_Gross_Area_SF__c;
                }
                IF(ncmtUniformat.Code__c =='A10'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.Foot_Print_Area__c;
                    ncmtUniformat.UOM__c = 'SFFP';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='A20'){
                    ncmtUniformat.Quantity__c = (projectReportData.PLPData.Basement_Story_Height__c * projectReportData.PLPData.Basement_SF__c)/27;
                    ncmtUniformat.UOM__c = 'CY';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                        //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='B10'){
                    ncmtUniformat.Quantity__c = (projectReportData.PLPData.Basement_SF__c + projectReportData.PLPData.Elevated_Floor_Area_SF__c + projectReportData.PLPData.Total_Roof_Area_SF__c);
                    ncmtUniformat.UOM__c = 'SFFA';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='B20'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.Cladding_Skin_Ratio_SF__c;
                    ncmtUniformat.UOM__c = 'SFSA';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='B30'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.Total_Roof_Area_SF__c;
                    ncmtUniformat.UOM__c = 'SFRA';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF((ncmtUniformat.Code__c =='C10' || ncmtUniformat.Code__c =='C30' || ncmtUniformat.Code__c =='D40' || ncmtUniformat.Code__c =='E10' || ncmtUniformat.Code__c =='E20' || ncmtUniformat.Code__c =='F10' || ncmtUniformat.Code__c =='G20') && projectReportData.PLPData.NCMT_Project__r.Building_Type__c <> 'Parking_Garage'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
                    ncmtUniformat.UOM__c = 'GSF';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                    
                }ELSE IF((ncmtUniformat.Code__c =='C10'  || ncmtUniformat.Code__c =='C30' || ncmtUniformat.Code__c =='D40' || ncmtUniformat.Code__c =='E10' || ncmtUniformat.Code__c =='E20' || ncmtUniformat.Code__c =='F10' || ncmtUniformat.Code__c =='G20') && projectReportData.PLPData.NCMT_Project__r.Building_Type__c == 'Parking_Garage'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
                    ncmtUniformat.UOM__c = 'GSF';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='C20'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.Stair_Analysis_Total_Flights__c;
                    ncmtUniformat.UOM__c = 'FL';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                        //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='D10'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.NCMT_Project__r.Number_of_Stops__c;
                    ncmtUniformat.UOM__c = 'STP';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='D20'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.Plumbing_Fixtures_EA__c;
                    ncmtUniformat.UOM__c = 'FXT';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='D30'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.HVAC_Cooling_Load_Tons__c;
                    ncmtUniformat.UOM__c = 'TN';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='D50'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.Electrical_Load_kW__c;
                    ncmtUniformat.UOM__c = 'kW';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='F20'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.Foot_Print_Area__c;
                    ncmtUniformat.UOM__c = 'SFFP';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                        //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                    
                }ELSE IF(ncmtUniformat.Code__c =='G10'){
                    ncmtUniformat.Quantity__c = projectReportData.siteData.Finished_Site__c;
                    ncmtUniformat.UOM__c = 'SFSA';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                    //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='G30'){
                    ncmtUniformat.Quantity__c = projectReportData.PLPData.Foot_Print_Area__c;
                    ncmtUniformat.UOM__c = 'SFFP';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                        //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                }ELSE IF(ncmtUniformat.Code__c =='G40'){
                    ncmtUniformat.Quantity__c = projectReportData.siteData.Finished_Site__c;
                    ncmtUniformat.UOM__c = 'SFSA';
                    /*IF(ncmtUniformat.Quantity__c <> 0 && ncmtUniformat.Total_Cost__c <> 0){
                        ncmtUniformat.ETPC_shell_Parameter__c = ((ncmtUniformat.ETPC__c/ncmtUniformat.Total_Cost__c) * ncmtUniformat.Core_Shell_Cost__c)/ncmtUniformat.Quantity__c; 
                    }*/
                        //ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
                } 
                ncmtUniformat.Profile_of_Cost__c = (ncmtUniformat.ECC__c/projCost.Project_Name__r.Total_ECC__c) * 100;
               
                ncmtsubtotal.Core_Shell_Cost__c = ncmtsubtotal.Core_Shell_Cost__c + ncmtUniformat.Core_Shell_Cost__c;
                ncmtsubtotal.Tenant_Imp_Cost__c = ncmtsubtotal.Tenant_Imp_Cost__c + ncmtUniformat.Tenant_Imp_Cost__c;
                ncmtsubtotal.TRCS_Cost__c = ncmtsubtotal.TRCS_Cost__c + ncmtUniformat.TRCS_Cost__c;
                ncmtsubtotal.Blast_Security_Cost__c = ncmtsubtotal.Blast_Security_Cost__c + ncmtUniformat.Blast_Security_Cost__c;
                ncmtsubtotal.Parking_Cost__c = ncmtsubtotal.Parking_Cost__c + ncmtUniformat.Parking_Cost__c;
                ncmtsubtotal.Total_Cost__c = ncmtsubtotal.Total_Cost__c + ncmtUniformat.Total_Cost__c;
                
                projectncmtUniformatToInsertMap.get(projectId).add(ncmtUniformat);
            }
            //Surface Parking
            NCMT_Uniformat_Data__c ncmtParking =  new NCMT_Uniformat_Data__c();
            system.debug(':::projectId:::'+projectDetails.Id);
            ncmtParking.Project_ID__c = projectReportData.PLPData.NCMT_Project__r.Id;
            ncmtParking.Project_Name__c = projectReportData.PLPData.NCMT_Project__r.Name; 
            ncmtParking.Core_Shell_Cost__c = 0;
            ncmtParking.Tenant_Imp_Cost__c = 0;
            ncmtParking.TRCS_Cost__c = 0;
            ncmtParking.Blast_Security_Cost__c = 0;
            ncmtParking.Quantity__c = 0;
            ncmtParking.Work_Description__c = 'Surface Parking';
            ncmtParking.Parking_Cost__c = projectReportData.PLPData.NCMT_Project__r.Surface_Parking__c * 400;
            ncmtParking.Total_Cost__c =  projectReportData.PLPData.NCMT_Project__r.Surface_Parking__c * 400;
            dblCPEEsc= projectReportData.PLPData.NCMT_Project__r.Total_Escalation_CPE__c;
            dblMarkEsc = projectReportData.PLPData.NCMT_Project__r.Total_Escalation__c;
            IF(dblCPEEsc == null){
                dblCPEEsc = 0;
            }
            IF(dblMarkEsc == null){
                dblMarkEsc = 0;
            }
            //system.debug('dblCPEEsc:::'+dblCPEEsc);
            ncmtParking.ECCA__c = ((ncmtParking.Total_Cost__c * (1 + projectReportData.PLPData.NCMT_Project__r.Design_and_Site_Contingency__c/100)) * (1 + projectReportData.PLPData.NCMT_Project__r.General_Contractor_Overhead_Profit_Bonds__c/100)) * (1+
                                    dblMarkEsc/100 + dblCPEEsc/100)
                                    ;
            ncmtParking.ECC__c = ((ncmtParking.ECCA__c *(1+ projectReportData.PLPData.NCMT_Project__r.Construction_Contingency__c/100))*(1+ projectReportData.PLPData.NCMT_Project__r.Art_In_Architecture__c/100));
            ncmtParking.ETPC__c = ncmtParking.ECC__c * (1 + projectReportData.PLPData.NCMT_Project__r.EDRC__c/100 + projectReportData.PLPData.NCMT_Project__r.EMIC__c/100);
            IF(projectReportData.PLPData.NCMT_Project__r.Building_Type__c <> 'Parking_Garage'){
            ncmtParking.Oth_Direct_Cost_GSF__c = ncmtParking.Total_Cost__c/projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
            ncmtParking.Direct_Cost_GSF__c = ncmtParking.Total_Cost__c/projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
            ncmtParking.ECC_GSF__c = ncmtParking.ECC__c/projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
            ncmtParking.ECCA_GSF__c = ncmtParking.ECCA__c/projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
            ncmtParking.ETPC_GSF__c = ncmtParking.ETPC__c/projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
            }else{
                ncmtParking.Oth_Direct_Cost_GSF__c = ncmtParking.Total_Cost__c/projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
                ncmtParking.Direct_Cost_GSF__c = ncmtParking.Total_Cost__c/projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
                ncmtParking.ECC_GSF__c = ncmtParking.ECC__c/projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
                ncmtParking.ECCA_GSF__c = ncmtParking.ECCA__c/projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
                ncmtParking.ETPC_GSF__c = ncmtParking.ETPC__c/projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
            }
             IF(ncmtParking.Total_Cost__c <> 0){
                 ncmtParking.ETPC_shell_Parameter__c = ((ncmtParking.ETPC__c/ncmtParking.Total_Cost__c) * ncmtParking.Core_Shell_Cost__c); 
                 ncmtParking.Profile_of_Cost__c = (ncmtParking.ECC__c/projectReportData.PLPData.NCMT_Project__r.Total_ECC__c) * 100;
             }
            
            ncmtsubtotal.Core_Shell_Cost__c = ncmtsubtotal.Core_Shell_Cost__c + ncmtParking.Core_Shell_Cost__c;
            ncmtsubtotal.Tenant_Imp_Cost__c = ncmtsubtotal.Tenant_Imp_Cost__c + ncmtParking.Tenant_Imp_Cost__c;
            ncmtsubtotal.TRCS_Cost__c = ncmtsubtotal.TRCS_Cost__c + ncmtParking.TRCS_Cost__c;
            ncmtsubtotal.Blast_Security_Cost__c = ncmtsubtotal.Blast_Security_Cost__c + ncmtParking.Blast_Security_Cost__c;
            ncmtsubtotal.Parking_Cost__c = ncmtsubtotal.Parking_Cost__c + ncmtParking.Parking_Cost__c;
            ncmtsubtotal.Total_Cost__c = ncmtsubtotal.Total_Cost__c + ncmtParking.Total_Cost__c;
            
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtParking);
            //Structured Parking
            NCMT_Uniformat_Data__c ncmtParkingStruc =  new NCMT_Uniformat_Data__c();
            ncmtParkingStruc.Project_ID__c = projectReportData.PLPData.NCMT_Project__r.Id;
            ncmtParkingStruc.Project_Name__c = projectReportData.PLPData.NCMT_Project__r.Name;   
            ncmtParkingStruc.Work_Description__c = 'Structured Parking';
            ncmtParkingStruc.Core_Shell_Cost__c = 0;
            ncmtParkingStruc.Tenant_Imp_Cost__c = 0;
            ncmtParkingStruc.TRCS_Cost__c = 0;
            ncmtParkingStruc.Blast_Security_Cost__c = 0;
            ncmtParkingStruc.Quantity__c = 0;
            ncmtParkingStruc.Parking_Cost__c = projectReportData.PLPData.NCMT_Project__r.Parking_Within_Building_Structure__c * 350;
            ncmtParkingStruc.Total_Cost__c =  projectReportData.PLPData.NCMT_Project__r.Parking_Within_Building_Structure__c * 350;
            ncmtParkingStruc.ECCA__c = ((ncmtParkingStruc.Total_Cost__c * (1 + projectReportData.PLPData.NCMT_Project__r.Design_and_Site_Contingency__c/100)) * (1 + projectReportData.PLPData.NCMT_Project__r.General_Contractor_Overhead_Profit_Bonds__c/100)) * (1+
                                    dblMarkEsc/100 + dblCPEEsc/100)
                                    ;
            ncmtParkingStruc.ECC__c = ((ncmtParkingStruc.ECCA__c *(1+ projectReportData.PLPData.NCMT_Project__r.Construction_Contingency__c/100))*(1+ projectReportData.PLPData.NCMT_Project__r.Art_In_Architecture__c/100));
            ncmtParkingStruc.ETPC__c = ncmtParkingStruc.ECC__c * (1 + projectReportData.PLPData.NCMT_Project__r.EDRC__c/100 + projectReportData.PLPData.NCMT_Project__r.EMIC__c/100);
            IF(projectReportData.PLPData.NCMT_Project__r.Building_Type__c <> 'Parking_Garage'){
            ncmtParkingStruc.Oth_Direct_Cost_GSF__c = ncmtParkingStruc.Total_Cost__c/projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
            ncmtParkingStruc.Direct_Cost_GSF__c = ncmtParkingStruc.Total_Cost__c/projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
            ncmtParkingStruc.ECC_GSF__c = ncmtParkingStruc.ECC__c/projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
            ncmtParkingStruc.ECCA_GSF__c = ncmtParkingStruc.ECCA__c/projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
            ncmtParkingStruc.ETPC_GSF__c = ncmtParkingStruc.ETPC__c/projectReportData.PLPData.NCMT_Project__r.Total_GSF__c;
            }else{
                ncmtParkingStruc.Oth_Direct_Cost_GSF__c = ncmtParkingStruc.Total_Cost__c/projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
                ncmtParkingStruc.Direct_Cost_GSF__c = ncmtParkingStruc.Total_Cost__c/projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
                ncmtParkingStruc.ECC_GSF__c = ncmtParkingStruc.ECC__c/projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
                ncmtParkingStruc.ECCA_GSF__c = ncmtParkingStruc.ECCA__c/projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
                ncmtParkingStruc.ETPC_GSF__c = ncmtParkingStruc.ETPC__c/projectReportData.PLPData.NCMT_Project__r.Parking_Garage_Gross_Area_SF__c;
            }
            IF(ncmtParkingStruc.Total_Cost__c <> 0){
                 ncmtParkingStruc.ETPC_shell_Parameter__c = ((ncmtParkingStruc.ETPC__c/ncmtParkingStruc.Total_Cost__c) * ncmtParkingStruc.Core_Shell_Cost__c); 
                 ncmtParkingStruc.Profile_of_Cost__c = (ncmtParkingStruc.ECC__c/projectReportData.PLPData.NCMT_Project__r.Total_ECC__c) * 100;
            }
            
            ncmtsubtotal.Core_Shell_Cost__c = ncmtsubtotal.Core_Shell_Cost__c + ncmtParkingStruc.Core_Shell_Cost__c;
            ncmtsubtotal.Tenant_Imp_Cost__c = ncmtsubtotal.Tenant_Imp_Cost__c + ncmtParkingStruc.Tenant_Imp_Cost__c;
            ncmtsubtotal.TRCS_Cost__c = ncmtsubtotal.TRCS_Cost__c + ncmtParkingStruc.TRCS_Cost__c;
            ncmtsubtotal.Blast_Security_Cost__c = ncmtsubtotal.Blast_Security_Cost__c + ncmtParkingStruc.Blast_Security_Cost__c;
            ncmtsubtotal.Parking_Cost__c = ncmtsubtotal.Parking_Cost__c + ncmtParkingStruc.Parking_Cost__c;
            ncmtsubtotal.Total_Cost__c = ncmtsubtotal.Total_Cost__c + ncmtParkingStruc.Total_Cost__c;
            
            projectSubtotalMap.put(ncmtSubtotal.Project_ID__c,ncmtSubtotal.Total_Cost__c);
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtParkingStruc); 
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtsubtotal);
            
            //Design and Site
            NCMT_Uniformat_Data__c ncmtDesignSubtotal =  new NCMT_Uniformat_Data__c();
            ncmtDesignSubtotal.Project_ID__c = projectDetails.ID;
            ncmtDesignSubtotal.Project_Name__c = projectDetails.Name;
            ncmtDesignSubtotal.Work_Description__c = 'Design Contingency';
            ncmtDesignSubtotal.Core_Shell_Cost__c= (ncmtsubtotal.Core_Shell_Cost__c * projectDetails.Design_and_Site_Contingency__c)/100;
            ncmtDesignSubtotal.Tenant_Imp_Cost__c= (ncmtsubtotal.Tenant_Imp_Cost__c * projectDetails.Design_and_Site_Contingency__c)/100;
            ncmtDesignSubtotal.TRCS_Cost__c= (ncmtsubtotal.TRCS_Cost__c * projectDetails.Design_and_Site_Contingency__c)/100;
            ncmtDesignSubtotal.Blast_Security_Cost__c= (ncmtsubtotal.Blast_Security_Cost__c * projectDetails.Design_and_Site_Contingency__c)/100;
            ncmtDesignSubtotal.Parking_Cost__c= (ncmtsubtotal.Parking_Cost__c * projectDetails.Design_and_Site_Contingency__c)/100;
            ncmtDesignSubtotal.Total_Cost__c= (ncmtsubtotal.Total_Cost__c * projectDetails.Design_and_Site_Contingency__c)/100;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtDesignSubtotal);
            
            //SubTotal
            NCMT_Uniformat_Data__c ncmtSubtotal1 =  new NCMT_Uniformat_Data__c();
            ncmtSubtotal1.Project_ID__c = projectDetails.ID;
            ncmtSubtotal1.Project_Name__c = projectDetails.Name;
            ncmtSubtotal1.Work_Description__c = 'SubTotal1';
            ncmtSubtotal1.Core_Shell_Cost__c= ncmtsubtotal.Core_Shell_Cost__c + ncmtDesignSubtotal.Core_Shell_Cost__c;
            ncmtSubtotal1.Tenant_Imp_Cost__c= ncmtsubtotal.Tenant_Imp_Cost__c + ncmtDesignSubtotal.Tenant_Imp_Cost__c;
            ncmtSubtotal1.TRCS_Cost__c= ncmtsubtotal.TRCS_Cost__c + ncmtDesignSubtotal.TRCS_Cost__c;
            ncmtSubtotal1.Blast_Security_Cost__c= ncmtsubtotal.Blast_Security_Cost__c + ncmtDesignSubtotal.Blast_Security_Cost__c;
            ncmtSubtotal1.Parking_Cost__c= ncmtsubtotal.Parking_Cost__c + ncmtDesignSubtotal.Parking_Cost__c;
            ncmtSubtotal1.Total_Cost__c= ncmtsubtotal.Total_Cost__c + ncmtDesignSubtotal.Total_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtSubtotal1);
            
            //General Conditions and Profit
            NCMT_Uniformat_Data__c ncmtgeneral =  new NCMT_Uniformat_Data__c();
            ncmtgeneral.Project_ID__c = projectDetails.ID;
            ncmtgeneral.Project_Name__c = projectDetails.Name;
            ncmtgeneral.Work_Description__c = 'General Conditions and Profit';
            ncmtgeneral.Core_Shell_Cost__c= (ncmtSubtotal1.Core_Shell_Cost__c * projectDetails.General_Contractor_Overhead_Profit_Bonds__c)/100;
            ncmtgeneral.Tenant_Imp_Cost__c= (ncmtSubtotal1.Tenant_Imp_Cost__c * projectDetails.General_Contractor_Overhead_Profit_Bonds__c)/100;
            ncmtgeneral.TRCS_Cost__c= (ncmtSubtotal1.TRCS_Cost__c * projectDetails.General_Contractor_Overhead_Profit_Bonds__c)/100;
            ncmtgeneral.Blast_Security_Cost__c= (ncmtSubtotal1.Blast_Security_Cost__c * projectDetails.General_Contractor_Overhead_Profit_Bonds__c)/100;
            ncmtgeneral.Parking_Cost__c= (ncmtSubtotal1.Parking_Cost__c * projectDetails.General_Contractor_Overhead_Profit_Bonds__c)/100;
            ncmtgeneral.Total_Cost__c= (ncmtSubtotal1.Total_Cost__c * projectDetails.General_Contractor_Overhead_Profit_Bonds__c)/100;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtgeneral);
            
            //SubTotal CECA
            NCMT_Uniformat_Data__c ncmtsubtotCECA =  new NCMT_Uniformat_Data__c();
            ncmtsubtotCECA.Project_ID__c = projectDetails.ID;
            ncmtsubtotCECA.Project_Name__c = projectDetails.Name;
            ncmtsubtotCECA.Work_Description__c = 'SubTotal CECA';
            ncmtsubtotCECA.Core_Shell_Cost__c= ncmtSubtotal1.Core_Shell_Cost__c + ncmtgeneral.Core_Shell_Cost__c;
            ncmtsubtotCECA.Tenant_Imp_Cost__c= ncmtSubtotal1.Tenant_Imp_Cost__c + ncmtgeneral.Tenant_Imp_Cost__c;
            ncmtsubtotCECA.TRCS_Cost__c= ncmtSubtotal1.TRCS_Cost__c + ncmtgeneral.TRCS_Cost__c;
            ncmtsubtotCECA.Blast_Security_Cost__c= ncmtSubtotal1.Blast_Security_Cost__c + ncmtgeneral.Blast_Security_Cost__c;
            ncmtsubtotCECA.Parking_Cost__c= ncmtSubtotal1.Parking_Cost__c + ncmtgeneral.Parking_Cost__c;
            ncmtsubtotCECA.Total_Cost__c= ncmtSubtotal1.Total_Cost__c + ncmtgeneral.Total_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtsubtotCECA);
            
            //Market Escalation
            NCMT_Uniformat_Data__c ncmtmarket =  new NCMT_Uniformat_Data__c();
            ncmtmarket.Project_ID__c = projectDetails.ID;
            ncmtmarket.Project_Name__c = projectDetails.Name;
            ncmtmarket.Work_Description__c = 'Market Escalation';
            IF(projectDetails.Total_Escalation__c <> null){
                ncmtmarket.Core_Shell_Cost__c= (ncmtsubtotCECA.Core_Shell_Cost__c * projectDetails.Total_Escalation__c)/100 ;
                ncmtmarket.Tenant_Imp_Cost__c= (ncmtsubtotCECA.Tenant_Imp_Cost__c * projectDetails.Total_Escalation__c)/100;
                ncmtmarket.TRCS_Cost__c= (ncmtsubtotCECA.TRCS_Cost__c * projectDetails.Total_Escalation__c)/100;
                ncmtmarket.Blast_Security_Cost__c= (ncmtsubtotCECA.Blast_Security_Cost__c * projectDetails.Total_Escalation__c)/100;
                ncmtmarket.Parking_Cost__c= (ncmtsubtotCECA.Parking_Cost__c * projectDetails.Total_Escalation__c)/100;
                ncmtmarket.Total_Cost__c= (ncmtsubtotCECA.Total_Cost__c * projectDetails.Total_Escalation__c)/100;
            }else{
                ncmtmarket.Core_Shell_Cost__c= 0;
                ncmtmarket.Tenant_Imp_Cost__c= 0;
                ncmtmarket.TRCS_Cost__c= 0;
                ncmtmarket.Blast_Security_Cost__c= 0;
                ncmtmarket.Parking_Cost__c= 0;
                ncmtmarket.Total_Cost__c= 0;
            }
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtmarket);
            
            //Code and Practice Escalation
            NCMT_Uniformat_Data__c ncmtCPE =  new NCMT_Uniformat_Data__c();
            ncmtCPE.Project_ID__c = projectDetails.ID;
            ncmtCPE.Project_Name__c = projectDetails.Name;
            ncmtCPE.Work_Description__c = 'Code and Practice Escalation';
            IF(projectDetails.Total_Escalation_CPE__c <> null){
            ncmtCPE.Core_Shell_Cost__c= (ncmtsubtotCECA.Core_Shell_Cost__c * projectDetails.Total_Escalation_CPE__c)/100 ;
            ncmtCPE.Tenant_Imp_Cost__c= (ncmtsubtotCECA.Tenant_Imp_Cost__c * projectDetails.Total_Escalation_CPE__c)/100;
            ncmtCPE.TRCS_Cost__c= (ncmtsubtotCECA.TRCS_Cost__c * projectDetails.Total_Escalation_CPE__c)/100;
            ncmtCPE.Blast_Security_Cost__c= (ncmtsubtotCECA.Blast_Security_Cost__c * projectDetails.Total_Escalation_CPE__c)/100;
            ncmtCPE.Parking_Cost__c= (ncmtsubtotCECA.Parking_Cost__c * projectDetails.Total_Escalation_CPE__c)/100;
            ncmtCPE.Total_Cost__c= (ncmtsubtotCECA.Total_Cost__c * projectDetails.Total_Escalation_CPE__c)/100;
            }else{
                ncmtCPE.Core_Shell_Cost__c= 0;
                ncmtCPE.Tenant_Imp_Cost__c= 0;
                ncmtCPE.TRCS_Cost__c= 0;
                ncmtCPE.Blast_Security_Cost__c= 0;
                ncmtCPE.Parking_Cost__c= 0;
                ncmtCPE.Total_Cost__c= 0;
            }
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtCPE);
            
            //SubTotal ECCA
            NCMT_Uniformat_Data__c ncmtsubtotECCA =  new NCMT_Uniformat_Data__c();
            ncmtsubtotECCA.Project_ID__c = projectDetails.ID;
            ncmtsubtotECCA.Project_Name__c = projectDetails.Name;
            ncmtsubtotECCA.Work_Description__c = 'SubTotal ECCA';
            ncmtsubtotECCA.Core_Shell_Cost__c= ncmtsubtotCECA.Core_Shell_Cost__c + ncmtmarket.Core_Shell_Cost__c + ncmtCPE.Core_Shell_Cost__c;
            ncmtsubtotECCA.Tenant_Imp_Cost__c= ncmtsubtotCECA.Tenant_Imp_Cost__c + ncmtmarket.Tenant_Imp_Cost__c + ncmtCPE.Tenant_Imp_Cost__c;
            ncmtsubtotECCA.TRCS_Cost__c= ncmtsubtotCECA.TRCS_Cost__c + ncmtmarket.TRCS_Cost__c + ncmtCPE.TRCS_Cost__c;
            ncmtsubtotECCA.Blast_Security_Cost__c= ncmtsubtotCECA.Blast_Security_Cost__c + ncmtmarket.Blast_Security_Cost__c + ncmtCPE.Blast_Security_Cost__c;
            ncmtsubtotECCA.Parking_Cost__c= ncmtsubtotCECA.Parking_Cost__c + ncmtmarket.Parking_Cost__c + ncmtCPE.Parking_Cost__c;
            ncmtsubtotECCA.Total_Cost__c = ncmtsubtotCECA.Total_Cost__c + ncmtmarket.Total_Cost__c + ncmtCPE.Total_Cost__c;
            ncmtsubtotECCA.ECCA__c = ncmtsubtotECCA.Total_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtsubtotECCA);
            
            //Construction Contingency
            NCMT_Uniformat_Data__c ncmtConsCont =  new NCMT_Uniformat_Data__c();
            ncmtConsCont.Project_ID__c = projectDetails.ID;
            ncmtConsCont.Project_Name__c = projectDetails.Name;
            ncmtConsCont.Work_Description__c = 'Construction Contingency';
            ncmtConsCont.Core_Shell_Cost__c= (ncmtsubtotECCA.Core_Shell_Cost__c * projectDetails.Construction_Contingency__c)/100;
            ncmtConsCont.Tenant_Imp_Cost__c= (ncmtsubtotECCA.Tenant_Imp_Cost__c * projectDetails.Construction_Contingency__c)/100;
            ncmtConsCont.TRCS_Cost__c= (ncmtsubtotECCA.TRCS_Cost__c * projectDetails.Construction_Contingency__c)/100;
            ncmtConsCont.Blast_Security_Cost__c= (ncmtsubtotECCA.Blast_Security_Cost__c * projectDetails.Construction_Contingency__c)/100;
            ncmtConsCont.Parking_Cost__c= (ncmtsubtotECCA.Parking_Cost__c * projectDetails.Construction_Contingency__c)/100;
            ncmtConsCont.Total_Cost__c= (ncmtsubtotECCA.Total_Cost__c * projectDetails.Construction_Contingency__c)/100;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtConsCont);
            
            //SubTotal ECC*
            NCMT_Uniformat_Data__c ncmtSubTotECC =  new NCMT_Uniformat_Data__c();
            ncmtSubTotECC.Project_ID__c = projectDetails.ID;
            ncmtSubTotECC.Project_Name__c = projectDetails.Name;
            ncmtSubTotECC.Work_Description__c = 'SubTotal ECC*';
            ncmtSubTotECC.Core_Shell_Cost__c= (ncmtsubtotECCA.Core_Shell_Cost__c + ncmtConsCont.Core_Shell_Cost__c);
            ncmtSubTotECC.Tenant_Imp_Cost__c= (ncmtsubtotECCA.Tenant_Imp_Cost__c + ncmtConsCont.Tenant_Imp_Cost__c);
            ncmtSubTotECC.TRCS_Cost__c= (ncmtsubtotECCA.TRCS_Cost__c + ncmtConsCont.TRCS_Cost__c);
            ncmtSubTotECC.Blast_Security_Cost__c= (ncmtsubtotECCA.Blast_Security_Cost__c + ncmtConsCont.Blast_Security_Cost__c);
            ncmtSubTotECC.Parking_Cost__c= (ncmtsubtotECCA.Parking_Cost__c + ncmtConsCont.Parking_Cost__c);
            ncmtSubTotECC.Total_Cost__c= (ncmtsubtotECCA.Total_Cost__c + ncmtConsCont.Total_Cost__c);
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtSubTotECC);
            
            //Art-In-Architecture
            NCMT_Uniformat_Data__c ncmtAiA =  new NCMT_Uniformat_Data__c();
            ncmtAiA.Project_ID__c = projectDetails.ID;
            ncmtAiA.Project_Name__c = projectDetails.Name;
            ncmtAiA.Work_Description__c = 'Art-In-Architecture';
            ncmtAiA.Core_Shell_Cost__c= (ncmtSubTotECC.Core_Shell_Cost__c * projectDetails.Art_In_Architecture__c)/100;
            ncmtAiA.Tenant_Imp_Cost__c= (ncmtSubTotECC.Tenant_Imp_Cost__c * projectDetails.Art_In_Architecture__c)/100;
            ncmtAiA.TRCS_Cost__c= (ncmtSubTotECC.TRCS_Cost__c * projectDetails.Art_In_Architecture__c)/100;
            ncmtAiA.Blast_Security_Cost__c= (ncmtSubTotECC.Blast_Security_Cost__c * projectDetails.Art_In_Architecture__c)/100;
            ncmtAiA.Parking_Cost__c= (ncmtSubTotECC.Parking_Cost__c * projectDetails.Art_In_Architecture__c)/100;
            ncmtAiA.Total_Cost__c= (ncmtSubTotECC.Total_Cost__c * projectDetails.Art_In_Architecture__c)/100;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtAiA);
            
            //Total ECC
            NCMT_Uniformat_Data__c ncmtTotECC =  new NCMT_Uniformat_Data__c();
            ncmtTotECC.Project_ID__c = projectDetails.ID;
            ncmtTotECC.Project_Name__c = projectDetails.Name;
            ncmtTotECC.Work_Description__c = 'Total ECC';
            ncmtTotECC.Core_Shell_Cost__c= (ncmtSubTotECC.Core_Shell_Cost__c + ncmtAiA.Core_Shell_Cost__c);
            ncmtTotECC.Tenant_Imp_Cost__c= (ncmtSubTotECC.Tenant_Imp_Cost__c + ncmtAiA.Tenant_Imp_Cost__c);
            ncmtTotECC.TRCS_Cost__c= (ncmtSubTotECC.TRCS_Cost__c + ncmtAiA.TRCS_Cost__c);
            ncmtTotECC.Blast_Security_Cost__c= (ncmtSubTotECC.Blast_Security_Cost__c + ncmtAiA.Blast_Security_Cost__c);
            ncmtTotECC.Parking_Cost__c= (ncmtSubTotECC.Parking_Cost__c + ncmtAiA.Parking_Cost__c);
            ncmtTotECC.Total_Cost__c = (ncmtSubTotECC.Total_Cost__c + ncmtAiA.Total_Cost__c);
            ncmtTotECC.ECC__c = ncmtTotECC.Total_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtTotECC);
            
            //EDRC: GSA
            NCMT_Uniformat_Data__c ncmtEDRCGSA =  new NCMT_Uniformat_Data__c();
            ncmtEDRCGSA.Project_ID__c = projectDetails.ID;
            ncmtEDRCGSA.Project_Name__c = projectDetails.Name;
            ncmtEDRCGSA.Work_Description__c = 'EDRC: GSA';
            ncmtEDRCGSA.Core_Shell_Cost__c= (ncmtTotECC.Core_Shell_Cost__c * projectDetails.EDRC__c)/100;
            ncmtEDRCGSA.Tenant_Imp_Cost__c= ((ncmtTotECC.Tenant_Imp_Cost__c * projectDetails.EDRC__c)/100)*0.35;
            ncmtEDRCGSA.TRCS_Cost__c= ((ncmtTotECC.TRCS_Cost__c * projectDetails.EDRC__c)/100) * 0.35;
            ncmtEDRCGSA.Blast_Security_Cost__c= ((ncmtTotECC.Blast_Security_Cost__c * projectDetails.EDRC__c)/100) * 0.35;
            ncmtEDRCGSA.Parking_Cost__c= (ncmtTotECC.Parking_Cost__c * projectDetails.EDRC__c)/100;
            ncmtEDRCGSA.Total_Cost__c= ncmtEDRCGSA.Core_Shell_Cost__c +  ncmtEDRCGSA.Tenant_Imp_Cost__c + ncmtEDRCGSA.TRCS_Cost__c + ncmtEDRCGSA.Blast_Security_Cost__c + ncmtEDRCGSA.Parking_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtEDRCGSA);
            
            //EDRC: Tenant
            NCMT_Uniformat_Data__c ncmtEDRCTenant =  new NCMT_Uniformat_Data__c();
            ncmtEDRCTenant.Project_ID__c = projectDetails.ID;
            ncmtEDRCTenant.Project_Name__c = projectDetails.Name;
            ncmtEDRCTenant.Work_Description__c = 'EDRC: Tenant';
            ncmtEDRCTenant.Core_Shell_Cost__c= 0;
            ncmtEDRCTenant.Tenant_Imp_Cost__c= ((ncmtTotECC.Tenant_Imp_Cost__c * projectDetails.EDRC__c)/100) * 0.65;
            ncmtEDRCTenant.TRCS_Cost__c= ((ncmtTotECC.TRCS_Cost__c * projectDetails.EDRC__c)/100) * 0.65;
            ncmtEDRCTenant.Blast_Security_Cost__c= ((ncmtTotECC.Blast_Security_Cost__c * projectDetails.EDRC__c)/100) * 0.65;
            ncmtEDRCTenant.Parking_Cost__c= 0;
            ncmtEDRCTenant.Total_Cost__c= ncmtEDRCTenant.Core_Shell_Cost__c +  ncmtEDRCTenant.Tenant_Imp_Cost__c + ncmtEDRCTenant.TRCS_Cost__c + ncmtEDRCTenant.Blast_Security_Cost__c + ncmtEDRCTenant.Parking_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtEDRCTenant);
            
            //Total EDRC
            NCMT_Uniformat_Data__c ncmtEDRC =  new NCMT_Uniformat_Data__c();
            ncmtEDRC.Project_ID__c = projectDetails.ID;
            ncmtEDRC.Project_Name__c = projectDetails.Name;
            ncmtEDRC.Work_Description__c = 'Total EDRC';
            ncmtEDRC.Core_Shell_Cost__c= ncmtEDRCGSA.Core_Shell_Cost__c + ncmtEDRCTenant.Core_Shell_Cost__c;
            ncmtEDRC.Tenant_Imp_Cost__c= ncmtEDRCGSA.Tenant_Imp_Cost__c + ncmtEDRCTenant.Tenant_Imp_Cost__c;
            ncmtEDRC.TRCS_Cost__c = ncmtEDRCGSA.TRCS_Cost__c + ncmtEDRCTenant.TRCS_Cost__c;
            ncmtEDRC.Blast_Security_Cost__c = ncmtEDRCGSA.Blast_Security_Cost__c + ncmtEDRCTenant.Blast_Security_Cost__c;
            ncmtEDRC.Parking_Cost__c = ncmtEDRCGSA.Parking_Cost__c + ncmtEDRCTenant.Parking_Cost__c;
            ncmtEDRC.Total_Cost__c = ncmtEDRC.Core_Shell_Cost__c +  ncmtEDRC.Tenant_Imp_Cost__c + ncmtEDRC.TRCS_Cost__c + ncmtEDRC.Blast_Security_Cost__c + ncmtEDRC.Parking_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtEDRC);
            
            //EMIC: GSA
            NCMT_Uniformat_Data__c ncmtEMICGSA =  new NCMT_Uniformat_Data__c();
            ncmtEMICGSA.Project_ID__c = projectDetails.ID;
            ncmtEMICGSA.Project_Name__c = projectDetails.Name;
            ncmtEMICGSA.Work_Description__c = 'EMIC: GSA';
            ncmtEMICGSA.Core_Shell_Cost__c= (ncmtTotECC.Core_Shell_Cost__c * projectDetails.EMIC__c)/100;
            ncmtEMICGSA.Tenant_Imp_Cost__c= 0;
            ncmtEMICGSA.TRCS_Cost__c= 0;
            ncmtEMICGSA.Blast_Security_Cost__c=0;
            ncmtEMICGSA.Parking_Cost__c= (ncmtTotECC.Parking_Cost__c * projectDetails.EMIC__c)/100;
            ncmtEMICGSA.Total_Cost__c= ncmtEMICGSA.Core_Shell_Cost__c +  ncmtEMICGSA.Tenant_Imp_Cost__c + ncmtEMICGSA.TRCS_Cost__c + ncmtEMICGSA.Blast_Security_Cost__c + ncmtEMICGSA.Parking_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtEMICGSA);
            
            //EMIC: Tenant
            NCMT_Uniformat_Data__c ncmtEMICTenant =  new NCMT_Uniformat_Data__c();
            ncmtEMICTenant.Project_ID__c = projectDetails.ID;
            ncmtEMICTenant.Project_Name__c = projectDetails.Name;
            ncmtEMICTenant.Work_Description__c = 'EMIC: Tenant';
            ncmtEMICTenant.Core_Shell_Cost__c= 0;
            ncmtEMICTenant.Tenant_Imp_Cost__c= ((ncmtTotECC.Tenant_Imp_Cost__c * projectDetails.EMIC__c)/100);
            ncmtEMICTenant.TRCS_Cost__c= ((ncmtTotECC.TRCS_Cost__c * projectDetails.EMIC__c)/100);
            ncmtEMICTenant.Blast_Security_Cost__c= ((ncmtTotECC.Blast_Security_Cost__c * projectDetails.EMIC__c)/100);
            ncmtEMICTenant.Parking_Cost__c= 0;
            ncmtEMICTenant.Total_Cost__c= ncmtEMICTenant.Core_Shell_Cost__c +  ncmtEMICTenant.Tenant_Imp_Cost__c + ncmtEMICTenant.TRCS_Cost__c + ncmtEMICTenant.Blast_Security_Cost__c + ncmtEMICTenant.Parking_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtEMICTenant);
            
            //Total EMIC
            NCMT_Uniformat_Data__c ncmtEMIC =  new NCMT_Uniformat_Data__c();
            ncmtEMIC.Project_ID__c = projectDetails.ID;
            ncmtEMIC.Project_Name__c = projectDetails.Name;
            ncmtEMIC.Work_Description__c = 'Total EMIC';
            ncmtEMIC.Core_Shell_Cost__c= ncmtEMICGSA.Core_Shell_Cost__c + ncmtEMICTenant.Core_Shell_Cost__c;
            ncmtEMIC.Tenant_Imp_Cost__c= ncmtEMICGSA.Tenant_Imp_Cost__c + ncmtEMICTenant.Tenant_Imp_Cost__c;
            ncmtEMIC.TRCS_Cost__c = ncmtEMICGSA.TRCS_Cost__c + ncmtEMICTenant.TRCS_Cost__c;
            ncmtEMIC.Blast_Security_Cost__c = ncmtEMICGSA.Blast_Security_Cost__c + ncmtEMICTenant.Blast_Security_Cost__c;
            ncmtEMIC.Parking_Cost__c = ncmtEMICGSA.Parking_Cost__c + ncmtEMICTenant.Parking_Cost__c;
            ncmtEMIC.Total_Cost__c= ncmtEMIC.Core_Shell_Cost__c +  ncmtEMIC.Tenant_Imp_Cost__c + ncmtEMIC.TRCS_Cost__c + ncmtEMIC.Blast_Security_Cost__c + ncmtEMIC.Parking_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtEMIC);
            
            //Estimated Site and Other Costs
            NCMT_Uniformat_Data__c ncmtESOC =  new NCMT_Uniformat_Data__c();
            ncmtESOC.Project_ID__c = projectDetails.ID;
            ncmtESOC.Project_Name__c = projectDetails.Name;
            ncmtESOC.Work_Description__c = 'Estimated Site and Other Costs';
            ncmtESOC.Total_Cost__c= projectDetails.Total_Other_Project_Costs__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtESOC);
            
            //Total ETPC: GSA
            NCMT_Uniformat_Data__c ncmtETPCGSA =  new NCMT_Uniformat_Data__c();
            ncmtETPCGSA.Project_ID__c = projectDetails.ID;
            ncmtETPCGSA.Project_Name__c = projectDetails.Name;
            ncmtETPCGSA.Work_Description__c = 'Total ETPC: GSA';
            ncmtETPCGSA.Total_Cost__c= ncmtTotECC.Core_Shell_Cost__c + ncmtTotECC.Parking_Cost__c + ncmtEMICGSA.Total_Cost__c + ncmtEDRCGSA.Total_Cost__c + ncmtESOC.Total_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtETPCGSA);
            
            //Total ETPC: Tenant
            NCMT_Uniformat_Data__c ncmtETPCTenant =  new NCMT_Uniformat_Data__c();
            ncmtETPCTenant.Project_ID__c = projectDetails.ID;
            ncmtETPCTenant.Project_Name__c = projectDetails.Name;
            ncmtETPCTenant.Work_Description__c = 'Total ETPC: Tenant';
            ncmtETPCTenant.Total_Cost__c= ncmtTotECC.Tenant_Imp_Cost__c + ncmtTotECC.TRCS_Cost__c + ncmtTotECC.Blast_Security_Cost__c + ncmtEMICTenant.Total_Cost__c + ncmtEDRCTenant.Total_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtETPCTenant);
            
            //Total ETPC
            NCMT_Uniformat_Data__c ncmtTotalETPC =  new NCMT_Uniformat_Data__c();
            ncmtTotalETPC.Project_ID__c = projectDetails.ID;
            ncmtTotalETPC.Project_Name__c = projectDetails.Name;
            ncmtTotalETPC.Work_Description__c = 'Total ETPC';
            ncmtTotalETPC.Total_Cost__c= ncmtETPCTenant.Total_Cost__c + ncmtETPCGSA.Total_Cost__c;
            projectncmtUniformatToInsertMap.get(projectId).add(ncmtTotalETPC);
        }
        for(Id projectId : projectncmtUniformatToInsertMap.KeySet()){
            NCMT_project__c projectdetails = projectdetailMap.get(projectId);
        List<NCMT_Uniformat_Data__c> ncmtUniformatToInsert= projectncmtUniformatToInsertMap.get(projectId);
            for(NCMT_Uniformat_Data__c NCMT_Uniformat : ncmtUniformatToInsert){
                if(NCMT_Uniformat.code__c != null && NCMT_Uniformat.Quantity__c <> 0){
                    decimal subtotal = projectSubtotalMap.get(NCMT_Uniformat.project_id__c);
                    
                    NCMT_Uniformat.ETPC_shell_Parameter__c = ((projectDetails.Total_Project_Cost_Aggregate__c/subtotal) * NCMT_Uniformat.Core_Shell_Cost__c)/NCMT_Uniformat.Quantity__c;  
                    }
            }
            ncmtUniformatsToInsert.addAll(ncmtUniformatToInsert)
;        }
        if(ncmtUniformatsToInsert.size() > 0){
           list<NCMT_Uniformat_Data__c> ncmtUniformatToDelete = [select id from NCMT_Uniformat_Data__c where Project_ID__c In : reportDataMap.keySet()];
            delete ncmtUniformatToDelete;
           insert ncmtUniformatsToInsert; 
        }
    }
    private static Map<Id,reportData> getProjectData( List<Id> projectIds){
        Map<Id,reportData> responseMap = new Map<Id,reportData>();
        Map<Id,Project_Level_Parameter__c> PLPDataMap = new Map<Id,Project_Level_Parameter__c>();
        Map<Id,Site_Information__c> siteDataMap = new Map<Id,Site_Information__c>();
        Map<Id,List<NCMT_Project_Cost_Summary__c>> projCostSummaryMap = new Map<Id,List<NCMT_Project_Cost_Summary__c>>();       
        
        for(Project_Level_Parameter__c projectLevelParameter : [select id, Name,SiteRemoteness_Cost_Impact__c, Foot_Print_Area__c, Basement_Story_Height__c, Basement_SF__c, Finished_Site_Area__c,
                                                                    Elevated_Floor_Area_SF__c, Total_Roof_Area_SF__c, Cladding_Skin_Ratio_SF__c, 
                                                                    Stair_Analysis_Total_Flights__c, Plumbing_Fixtures_EA__c, 
                                                                    HVAC_Cooling_Load_Tons__c, Electrical_Load_kW__c, Curtain_Wall_Percentage_SF__c, Window_Percentage_SF__c, Base_SF__c, Mid_SF__c, Top_SF__c,
                                                                    Level_of_Protection__c, Use_Level_of_Protection__c, Over_percentage_of_Perimeter__c,
                                                                    Change_Setback_100__c, Default_Setback_100_FT__c, Default_Adj_LOP_Setback_FT__c, Adj_LOP_Setback__c, Default_Finished_Site_Area__c,NCMT_Project__c,
                                                                    NCMT_Project__r.Building_Type__c,NCMT_Project__r.Number_of_Stops__c,NCMT_Project__r.Total_GSF__c,NCMT_Project__r.Parking_Garage_Gross_Area_SF__c,
                                                                    NCMT_Project__r.Surface_Parking__c,NCMT_Project__r.Parking_Within_Building_Structure__c,NCMT_Project__r.Id,NCMT_Project__r.Name,
                                                                    NCMT_Project__r.Design_and_Site_Contingency__c,NCMT_Project__r.General_Contractor_Overhead_Profit_Bonds__c,NCMT_Project__r.Total_Escalation__c,
                                                                    NCMT_Project__r.Total_Escalation_CPE__c,NCMT_Project__r.Construction_Contingency__c,NCMT_Project__r.Art_In_Architecture__c,NCMT_Project__r.EDRC__c,
                                                                NCMT_Project__r.EMIC__c,NCMT_Project__r.Total_ECC__c
                                                                from Project_Level_Parameter__c  
                                                                where  NCMT_Project__c IN : projectIds]){
                                                                    PLPDataMap.put(projectLevelParameter.NCMT_Project__c,projectLevelParameter);
                                    
                                                                }
        for(Site_Information__c siteInformation : [select id, Name,Finished_Site__c,Project__c
                                                   from Site_Information__c
                                                   where  Project__c IN : projectIds]){
                                                       
                                                       siteDataMap.put(siteInformation.Project__c,siteInformation);
                                                   }
        
        for(NCMT_Project_Cost_Summary__c ncmtProjectCostSummary : [Select  Quantity__c, Total_Cost_Adjusted__c, TRCS_Cost_Adjusted__c, TI_Cost_Adjusted__c, Security_Cost_Adjusted__c, 
                                                                            Parking_Cost_Adjusted__c, Name, Id, ECCA__c, Cost_Category_Description__c, Cost_Category_Code__c, 
                                                                            Core_Shell_Total_Cost_Adjusted__c, Core_Shell_Cost_Adj__c,Other_Direct_Costs__c, Other_Core_Shell_Cost__c, Oth_TI_Cst__c, Other_Direct_Security_Costs__c,
                                                                            Direct_Cost_GSF__c, ECC__c, ECC_GSF__c, ECCA_GSF__c, 
                                                                            Other_Direct_Cost_GSF__c,Project_Name__c, Project_Name__r.Id,Project_Name__r.Name,Project_Name__r.EDRC__c, Project_Name__r.EMIC__c,Project_Name__r.Total_GSF__c,
                                                                            Project_Name__r.Design_and_Site_Contingency__c,Project_Name__r.General_Contractor_Overhead_Profit_Bonds__c,Project_Name__r.Total_Escalation__c,
                                                                            Project_Name__r.Total_Escalation_CPE__c,Project_Name__r.Construction_Contingency__c,Project_Name__r.Art_In_Architecture__c,Project_Name__r.Total_ECC__c,
                                                                            Project_Name__r.Total_Other_Project_Costs__c,Project_Name__r.Total_Project_Cost_Aggregate__c
                                                                    From    NCMT_Project_Cost_Summary__c
                                                                    Where   Project_Name__c IN : projectIds                                
                                                                            Order by Cost_Category_Code__c]){
                                                                            if(projCostSummaryMap.containsKey(ncmtProjectCostSummary.Project_Name__c)){
                                                                                    projCostSummaryMap.get(ncmtProjectCostSummary.Project_Name__c).add(ncmtProjectCostSummary);
                                                                             }
                                                                             else{
                                                                                    projCostSummaryMap.put(ncmtProjectCostSummary.Project_Name__c, new List<NCMT_Project_Cost_Summary__c>{ncmtProjectCostSummary});
                                                                             }
                                                                     }                          
        
         
        for(Id projectId : projectIds){
            //system.debug(':::projectId:::'+projectId);
            reportData response = new reportData();
            response.PLPData= PLPDataMap.get(projectId);
            response.siteData = siteDataMap.get(projectId);
            response.projCostSummaryData = projCostSummaryMap.get(projectId);
            //system.debug('::responseMap:::'+responseMap.keySet());
            responseMap.put(projectId,response);
        }
        return responseMap;
        
    }
    
    
    
    public class reportData{
        @AuraEnabled public Project_Level_Parameter__c PLPData{get;set;}
        @AuraEnabled public Site_Information__c siteData{get;set;}
        @AuraEnabled public List<NCMT_Project_Cost_Summary__c> projCostSummaryData{get;set;} 
        public reportData(){
            this.PLPData=new Project_Level_Parameter__c();
            this.siteData=new Site_Information__c();
            this.projCostSummaryData=new List<NCMT_Project_Cost_Summary__c>();
        }
    }
}