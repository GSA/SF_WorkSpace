public with sharing class NCMT_ProfessionalServiceEstimate {

    public void UpdateCostParameterDate(List<Professional_Service_Estimate__c> ProfServEstList){
        Date ProfServCostParameterDate;
        String CostParameterYear;
 
        NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
        ProfServCostParameterDate = ncmt_customsettings.Professional_Service_Cost_Parameter_Date__c;
        CostParameterYear = string.valueof(ProfServCostParameterDate.year()+1);
        
        Professional_Service_Estimate_Parameter__c objPSEPara = [SELECT A_E_SUM_75_Average__c, A_E_SUM_90_Average__c,
                                                                            CM_75_Average__c, CM_90_Average__c,
                                                                            Const_Bldg_Inspectors_Cx_75_Average__c, 
                                                                            Const_Bldg_Inspectors_Cx_90_Average__c,
                                                                            GSA_CM_Design_Slope__c, GSA_CM_Construction_Slope__c,
                                                                            GSA_CM_Design_Constant__c, GSA_CM_Construction_Constant__c
                                                                        FROM Professional_Service_Estimate_Parameter__c 
                                                                        WHERE NAME = :CostParameterYear];

        for(Professional_Service_Estimate__c objProfServEst :ProfServEstList){
            objProfServEst.AE75__c = objPSEPara.A_E_SUM_75_Average__c;
            objProfServEst.AE90__c = objPSEPara.A_E_SUM_90_Average__c;
            objProfServEst.CM75__c = objPSEPara.CM_75_Average__c;
            objProfServEst.CM90__c = objPSEPara.CM_90_Average__c;
            objProfServEst.Cx75__c = objPSEPara.Const_Bldg_Inspectors_Cx_75_Average__c;
            objProfServEst.Cx90__c = objPSEPara.Const_Bldg_Inspectors_Cx_90_Average__c;
            objProfServEst.GSA_CM_Design_Slope__c = objPSEPara.GSA_CM_Design_Slope__c;
            objProfServEst.GSA_CM_Construction_Slope__c = objPSEPara.GSA_CM_Construction_Slope__c;
            objProfServEst.GSA_CM_Design_Constant__c = objPSEPara.GSA_CM_Design_Constant__c;
            objProfServEst.GSA_CM_Construction_Constant__c = objPSEPara.GSA_CM_Construction_Constant__c;
            if (objProfServEst.RecordType.Name == 'User Defined' || objProfServEst.RecordType.Name == 'User Defined Repair and Alteration') {
                objProfServEst.Base_Date_of_Estimate__c =   ProfServCostParameterDate;
            }
        }   
    }
    
    public void UpdateProfServEstData(List<Professional_Service_Estimate__c> ProfServEstList, String strstate, String strlocation, String strBuilding_Type, String strProject_Type, String strDelivery_Method, String strCM_Role, String strDesign_Build_Leased_Delivery_Only, String strScope, String strEstimatedNumberofPhases) {
            string strSOQL;
            string LocName;
            string LocCode;
            string LocRegion;
            string BType;
            string BCode;
            Decimal ConstructionDuration;
            Decimal ECC;
            Decimal Estimated_Total_GSF;
            Decimal intGSF_10000;   
            Decimal intGSF_25000;
            Decimal intGSF_50000;
            Decimal intGSF_100000;
            Decimal intGSF_150000;
            Decimal intGSF_250000;
            Decimal intGSF_500000;
            Decimal intGSF_GT_500000;
            Decimal Annual_Escalation_Rate;
            Date ProfServCostParameterDate;
            Decimal SinglePhaseDurationMonths, TotalPhaseDurationMultiplier;
            integer ECCRangeIdentifierScope, ECCRangeIdentifierPhases;
        	String CostParameterYear;
        	
        	NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
        	ProfServCostParameterDate = ncmt_customsettings.Professional_Service_Cost_Parameter_Date__c;
        	CostParameterYear = string.valueof(ProfServCostParameterDate.year()+1);
         
             if (strBuilding_Type == 'Federal Office Building') {
                BType = 'Office';
             }
             else {
                BType = strBuilding_Type;
             }
                
             //get Building Code Id to store in ProfessionalServiceEstimate Building parameter
             List <NCMT_Building_Parameter__c> ListBcode = [SELECT ID, GSF_10_000__c, GSF_25_000__c, GSF_50_000__c, GSF_100_000__c, GSF_150_000__c, 
                                                            GSF_250_000__c, GSF_500_000__c, GSF_GT500_000__c 
                                                            FROM NCMT_Building_Parameter__c where Building_Parameter_Name__c = :BType];
             For (NCMT_Building_Parameter__c objBCode: ListBcode) {
                 BCode = objBCode.ID;
                 intGSF_10000 = objBCode.GSF_10_000__c;
                 intGSF_25000 = objBCode.GSF_25_000__c;
                 intGSF_50000 = objBCode.GSF_50_000__c;
                 intGSF_100000 = objBCode.GSF_100_000__c;
                 intGSF_150000 = objBCode.GSF_150_000__c;
                 intGSF_250000 = objBCode.GSF_250_000__c;
                 intGSF_500000 = objBCode.GSF_500_000__c;
                 intGSF_GT_500000 = objBCode.GSF_GT500_000__c;
             }
             if (intGSF_10000 == null) {
             	intGSF_10000 = 0;
             }
             if (intGSF_25000 == null) {
             	intGSF_25000 = 0;
             }
             if (intGSF_50000 == null) {
             	intGSF_50000 = 0;
             }
             if (intGSF_100000 == null) {
             	intGSF_100000 = 0;
             }
             if (intGSF_150000 == null) {
             	intGSF_150000 = 0;
             }
             if (intGSF_250000 == null) {
             	intGSF_250000 = 0;
             }
             if (intGSF_500000 == null) {
             	intGSF_500000 = 0;
             }
             if (intGSF_GT_500000 == null) {
             	intGSF_GT_500000 = 0;
             }
             
             //get Location Parameter Id to get Annual Escalation Rate 
             LocCode='';
             strSOQL = 'SELECT Name, Annual_Escalation_Rate__c, GSA_Region__c FROM NCMT_Location_Parameters__c where Name = :strlocation and state__c = :strstate and Fiscal_Year__c = :CostParameterYear';
             List <NCMT_Location_Parameters__c> ListLcode = Database.query(strSOQL);
             For (NCMT_Location_Parameters__c objLCode: ListLcode) {
                 LocCode = objLCode.Name;
                 Annual_Escalation_Rate = objLCode.Annual_Escalation_Rate__c;
                 LocRegion = objLCode.GSA_Region__c;
             }
             
             //get CECC & ECC Id to store in ProfessionalServiceEstimate CECC & ECC lookup             
             string strCECC;
             string strECC;
             string strLeased1;
             strLeased1='True';
             
             strSOQL = 'SELECT ID, Type__c FROM AE_CMa_CMc_Cx__c WHERE Building_Type__c = :strBuilding_Type and Project_Type__c = :strProject_Type ' + ' ' +
                        'and Delivery_Type__c = :strDelivery_Method and CM_Role__c = :strCM_Role ';
             if (strDelivery_Method == 'Design Build - Leased' && (strDesign_Build_Leased_Delivery_Only == 'Build to Suit' || strDesign_Build_Leased_Delivery_Only == 'Tenant Fit-out w/ Redesign')) {              
                strSOQL = strSOQL + ' and Build_to_Suit_Tenant_Fit_out_w_Redesign__c = :strLeased1 ';
             }
             else if (strDelivery_Method == 'Design Build - Leased' && strDesign_Build_Leased_Delivery_Only =='Tenant Fit-out w/ no Redesign') {
                strSOQL = strSOQL + ' and Tenant_Fit_Out__c = :strLeased1 ';
             }
             //else if (strDelivery_Method == 'Design Build - Leased' && strDesign_Build_Leased_Delivery_Only == null) {
             //   strLeased1 = 'Not Selected';
             //   strSOQL = strSOQL + ' and Tenant_Fit_Out__c = :strLeased1 ';
             //}
              
             List <AE_CMa_CMc_Cx__c> ListAECode = Database.query(strSOQL);
             for (AE_CMa_CMc_Cx__c objAECode: ListAECode) {
                if (objAECode.Type__c == 'CECC') {
                    strCECC = objAECode.ID;
                }
                else {
                    strECC = objAECode.ID;
                }
             }
             
             //calculate Design Build - Owned values
	        
    	    Professional_Service_Estimate_Parameter__c objPSEPara = [SELECT Complexity_Low_Detail_Low__c, Complexity_Low_Detail_Medium__c, Complexity_Low_Detail_High__c,
                                                                            Complexity_Medium_Detail_Low__c, Complexity_Medium_Detail_Medium__c, Complexity_Medium_Detail_High__c,
                                                                            Complexity_High_Detail_Low__c, Complexity_High_Detail_Medium__c, Complexity_High_Detail_High__c,                                                                            
                                                                            ECC_Ranges_constant_25_000_000__c, ECC_Ranges_constant_50_000_000__c, ECC_Ranges_constant_100_000_000__c,
                                                                            ECC_Ranges_constant_150_000_000__c, ECC_Ranges_constant_200_000_000__c, ECC_Ranges_constant_100_000_0000__c,
                                                                            ECC_Ranges_exponent_25_000_000__c, ECC_Ranges_exponent_50_000_000__c, ECC_Ranges_exponent_100_000_000__c,
                                                                            ECC_Ranges_exponent_150_000_000__c, ECC_Ranges_exponent_200_000_000__c, ECC_Ranges_exponent_100_000_0000__c,
                                                                            Cost_Advantage_ECCA_25_000_000__c, Cost_Advantage_ECCA_50_000_000__c, Cost_Advantage_ECCA_100_000_000__c,
                                                                            Cost_Advantage_ECCA_250_000_000__c, Cost_Advantage_ECCA_500_000_000__c, Cost_Advantage_ECCA_GT500_000_000__c,
                                                                            Limited_Scope_Category_1__c, Limited_Scope_Category_2__c, Limited_Scope_Category_3__c, 
                                                                            Limited_Scope_Category_4__c, Limited_Scope_Category_5__c,
                                                                            Distributed_Scope_Category_1__c, Distributed_Scope_Category_2__c, Distributed_Scope_Category_3__c,
                                                                            Distributed_Scope_Category_4__c, Distributed_Scope_Category_5__c,
                                                                            Full_Modernization_Category_1__c, Full_Modernization_Category_2__c, Full_Modernization_Category_3__c,
                                                                            Full_Modernization_Category_4__c, Full_Modernization_Category_5__c,
                                                                            Number_of_Phases_2_ECC_Range_1__c, Number_of_Phases_2_ECC_Range_2__c, Number_of_Phases_2_ECC_Range_3__c, 
                                                                            Number_of_Phases_2_ECC_Range_4__c, Number_of_Phases_2_ECC_Range_5__c, Number_of_Phases_2_ECC_Range_6__c,
                                                                            Number_of_Phases_2_ECC_Range_7__c, Number_of_Phases_2_ECC_Range_8__c, Number_of_Phases_2_ECC_Range_9__c,
                                                                            Number_of_Phases_3_ECC_Range_1__c, Number_of_Phases_3_ECC_Range_2__c, Number_of_Phases_3_ECC_Range_3__c,
                                                                            Number_of_Phases_3_ECC_Range_4__c, Number_of_Phases_3_ECC_Range_5__c, Number_of_Phases_3_ECC_Range_6__c,
                                                                            Number_of_Phases_3_ECC_Range_7__c, Number_of_Phases_3_ECC_Range_8__c, Number_of_Phases_3_ECC_Range_9__c,
                                                                            Number_of_Phases_4_ECC_Range_1__c, Number_of_Phases_4_ECC_Range_2__c, Number_of_Phases_4_ECC_Range_3__c,
                                                                            Number_of_Phases_4_ECC_Range_4__c, Number_of_Phases_4_ECC_Range_5__c, Number_of_Phases_4_ECC_Range_6__c,
                                                                            Number_of_Phases_4_ECC_Range_7__c, Number_of_Phases_4_ECC_Range_8__c, Number_of_Phases_4_ECC_Range_9__c,
                                                                            Number_of_Phases_4Plus_ECC_Range_1__c, Number_of_Phases_4Plus_ECC_Range_2__c, Number_of_Phases_4Plus_ECC_Range_3__c,
                                                                            Number_of_Phases_4Plus_ECC_Range_4__c, Number_of_Phases_4Plus_ECC_Range_5__c, Number_of_Phases_4Plus_ECC_Range_6__c,
                                                                            Number_of_Phases_4Plus_ECC_Range_7__c, Number_of_Phases_4Plus_ECC_Range_8__c, Number_of_Phases_4Plus_ECC_Range_9__c                                                                             
                                                                        FROM Professional_Service_Estimate_Parameter__c 
                                                                        WHERE NAME = :CostParameterYear];             
             
             //update Location, CECC & ECC Ids to ProfessionalServiceEstimate
             for (Professional_Service_Estimate__c ProfServEst : ProfServEstList) {
                 //if (LocCode == null) {
                 //   ProfServEst.adderror('Index Location is not available for the selection.');
                 //}
                 if (strCECC == null) {
                    //if (strLeased1 == 'Not Selected') {
                    //    ProfServEst.adderror('Design Build - Leased Delivery Only must be selected.');
                    //}
                    //else {
                        ProfServEst.adderror('AE CMa CMc Cx CECC is not available for the selection.');
                    //}
                 }
                 if (strECC == null) {
                    //if (strLeased1 == 'Not Selected') {
                    //    ProfServEst.adderror('Design Build - Leased Delivery Only must be selected.');
                    //}
                    //else {
                        ProfServEst.adderror('AE CMa CMc Cx ECC is not available for the selection.');
                    //}
                 }     
                                
                ProfServEst.AE_CMa_CMc_Cx_CECC__c = strCECC;
                ProfServEst.AE_CMa_CMc_Cx_ECC__c = strECC;
                ProfServEst.Building_Parameter__c = BCode;
                ProfServEst.Region_Code__c = LocRegion;
                ECC = ProfServEst.ECC__c;
                Estimated_Total_GSF = ProfServEst.Estimated_Total_GSF__c;
                
                IF (Estimated_Total_GSF <= 10000 ) {
                   ConstructionDuration = intGSF_10000;
                } 
                ELSE IF (Estimated_Total_GSF > 10000 && Estimated_Total_GSF <= 25000) {
                   ConstructionDuration = intGSF_25000;
                }    
                ELSE IF (Estimated_Total_GSF > 25000 && Estimated_Total_GSF <= 50000) {
                   ConstructionDuration = intGSF_50000;
                } 
                ELSE IF (Estimated_Total_GSF > 50000 && Estimated_Total_GSF <= 100000) {
                   ConstructionDuration = intGSF_100000;
                } 
                ELSE IF (Estimated_Total_GSF > 100000 && Estimated_Total_GSF <= 150000) {
                   ConstructionDuration = intGSF_150000;
                } 
                ELSE IF (Estimated_Total_GSF > 150000 && Estimated_Total_GSF <= 250000) {
                   ConstructionDuration = intGSF_250000;
                } 
                ELSE IF (Estimated_Total_GSF > 250000 && Estimated_Total_GSF <= 500000) {
                   ConstructionDuration = intGSF_500000;
                } 
                ELSE IF (Estimated_Total_GSF > 500000 ) {
                   ConstructionDuration = intGSF_GT_500000;
                }
                
                ConstructionDuration = ConstructionDuration / 12;
                ProfServEst.New_Construction_Duration__c = ConstructionDuration;
                
                If (ECC < 10000000) {
                    ProfServEst.Design_Duration__c = ConstructionDuration;
                }
                else {
                    ProfServEst.Design_Duration__c = ConstructionDuration * 0.68;
                }

                if (strProject_Type == 'Repair & Alteration') {
                	//=IF(ECC_Form<500000,1,IF(ECC_Form<2500000,2,IF(ECC_Form<10000000,3,IF(ECC_Form<50000000,4,5))))
                	IF (ECC < 500000) {
                		ECCRangeIdentifierScope = 1;
                	}
                	else IF (ECC >= 500000 && ECC < 2500000) {
                		ECCRangeIdentifierScope = 2;
                	}
                	else IF (ECC >= 2500000 && ECC < 10000000) {
                		ECCRangeIdentifierScope = 3;
                	}
                	else IF (ECC >= 10000000 && ECC < 50000000) {
                		ECCRangeIdentifierScope = 4;
                	}
                	else if (ECC >= 50000000) {                				
                		ECCRangeIdentifierScope = 5;
                	}
                	
                	if (strScope == 'Limited Scope') {
                		if (ECCRangeIdentifierScope == 1) {
                			SinglePhaseDurationMonths = objPSEPara.Limited_Scope_Category_1__c;
                		}	
                		else if (ECCRangeIdentifierScope == 2) {
                			SinglePhaseDurationMonths = objPSEPara.Limited_Scope_Category_2__c;
                		}
                		else if (ECCRangeIdentifierScope == 3) {
                			SinglePhaseDurationMonths = objPSEPara.Limited_Scope_Category_3__c;
                		}
                		else if (ECCRangeIdentifierScope == 4) {
                			SinglePhaseDurationMonths = objPSEPara.Limited_Scope_Category_4__c;
                		}
                		else if (ECCRangeIdentifierScope == 5) {
                			SinglePhaseDurationMonths = objPSEPara.Limited_Scope_Category_5__c;
                		}
                	}
                	else if (strScope == 'Distributed Scope') {
                		if (ECCRangeIdentifierScope == 1) {
                			SinglePhaseDurationMonths = objPSEPara.Distributed_Scope_Category_1__c;
                		}	
                		else if (ECCRangeIdentifierScope == 2) {
                			SinglePhaseDurationMonths = objPSEPara.Distributed_Scope_Category_2__c;
                		}
                		else if (ECCRangeIdentifierScope == 3) {
                			SinglePhaseDurationMonths = objPSEPara.Distributed_Scope_Category_3__c;
                		}
                		else if (ECCRangeIdentifierScope == 4) {
                			SinglePhaseDurationMonths = objPSEPara.Distributed_Scope_Category_4__c;
                		}
                		else if (ECCRangeIdentifierScope == 5) {
                			SinglePhaseDurationMonths = objPSEPara.Distributed_Scope_Category_5__c;
                		}
                	}
                	else if (strScope == 'Full Modernization') {
                		if (ECCRangeIdentifierScope == 1) {
                			SinglePhaseDurationMonths = objPSEPara.Full_Modernization_Category_1__c;
                		}	
                		else if (ECCRangeIdentifierScope == 2) {
                			SinglePhaseDurationMonths = objPSEPara.Full_Modernization_Category_2__c;
                		}
                		else if (ECCRangeIdentifierScope == 3) {
                			SinglePhaseDurationMonths = objPSEPara.Full_Modernization_Category_3__c;
                		}
                		else if (ECCRangeIdentifierScope == 4) {
                			SinglePhaseDurationMonths = objPSEPara.Full_Modernization_Category_4__c;
                		}
                		else if (ECCRangeIdentifierScope == 5) {
                			SinglePhaseDurationMonths = objPSEPara.Full_Modernization_Category_5__c;
                		}
                	}
                	
                	//=IF(C1<100000,1,IF(C1<500000,2,IF(C1<1000000,3,IF(C1<5000000,4,IF(C1<10000000,5,IF(C1<50000000,6,IF(C1<100000000,7,IF(C1<500000000,8,9))))))))
                	IF (ECC < 100000) {
                		ECCRangeIdentifierPhases = 1;
                	}
                	else IF (ECC >= 100000 && ECC < 500000) {
                		ECCRangeIdentifierPhases = 2;
                	}
                	else IF (ECC >= 500000 && ECC < 1000000) {
                		ECCRangeIdentifierPhases = 3;
                	}
                	else IF (ECC >= 1000000 && ECC < 5000000) {
                		ECCRangeIdentifierPhases = 4;
                	}
                	else IF (ECC >= 5000000 && ECC < 10000000) {
                		ECCRangeIdentifierPhases = 5;
                	}
                	else IF (ECC >= 10000000 && ECC < 50000000) {
                		ECCRangeIdentifierPhases = 6;
                	}
                	else IF (ECC >= 50000000 && ECC < 100000000) {
                		ECCRangeIdentifierPhases = 7;
                	}
                	else IF (ECC >= 100000000 && ECC < 500000000) {
                		ECCRangeIdentifierPhases = 8;
                	}
                	else IF (ECC >= 500000000) {
                		ECCRangeIdentifierPhases = 9;
                	}
                	
                	if (strEstimatedNumberofPhases == '1') {
                		TotalPhaseDurationMultiplier = 1;
                	}
                	else if (strEstimatedNumberofPhases == '2') {
                		if (ECCRangeIdentifierPhases == 1) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_2_ECC_Range_1__c;
                		}	
                		else if (ECCRangeIdentifierPhases == 2) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_2_ECC_Range_2__c;
                		}
						else if (ECCRangeIdentifierPhases == 3) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_2_ECC_Range_3__c;
                		}
						else if (ECCRangeIdentifierPhases == 4) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_2_ECC_Range_4__c;
                		}
						else if (ECCRangeIdentifierPhases == 5) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_2_ECC_Range_5__c;
                		}
						else if (ECCRangeIdentifierPhases == 6) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_2_ECC_Range_6__c;
                		}
						else if (ECCRangeIdentifierPhases == 7) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_2_ECC_Range_7__c;
                		}
						else if (ECCRangeIdentifierPhases == 8) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_2_ECC_Range_8__c;
                		}
						else if (ECCRangeIdentifierPhases == 9) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_2_ECC_Range_9__c;
                		}                		
                	}
                	else if (strEstimatedNumberofPhases == '3') {
                		if (ECCRangeIdentifierPhases == 1) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_3_ECC_Range_1__c;
                		}	
                		else if (ECCRangeIdentifierPhases == 2) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_3_ECC_Range_2__c;
                		}
						else if (ECCRangeIdentifierPhases == 3) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_3_ECC_Range_3__c;
                		}
						else if (ECCRangeIdentifierPhases == 4) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_3_ECC_Range_4__c;
                		}
						else if (ECCRangeIdentifierPhases == 5) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_3_ECC_Range_5__c;
                		}
						else if (ECCRangeIdentifierPhases == 6) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_3_ECC_Range_6__c;
                		}
						else if (ECCRangeIdentifierPhases == 7) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_3_ECC_Range_7__c;
                		}
						else if (ECCRangeIdentifierPhases == 8) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_3_ECC_Range_8__c;
                		}
						else if (ECCRangeIdentifierPhases == 9) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_3_ECC_Range_9__c;
                		}                		
                	}
                	else if (strEstimatedNumberofPhases == '4') {
                		if (ECCRangeIdentifierPhases == 1) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4_ECC_Range_1__c;
                		}	
                		else if (ECCRangeIdentifierPhases == 2) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4_ECC_Range_2__c;
                		}
						else if (ECCRangeIdentifierPhases == 3) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4_ECC_Range_3__c;
                		}
						else if (ECCRangeIdentifierPhases == 4) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4_ECC_Range_4__c;
                		}
						else if (ECCRangeIdentifierPhases == 5) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4_ECC_Range_5__c;
                		}
						else if (ECCRangeIdentifierPhases == 6) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4_ECC_Range_6__c;
                		}
						else if (ECCRangeIdentifierPhases == 7) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4_ECC_Range_7__c;
                		}
						else if (ECCRangeIdentifierPhases == 8) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4_ECC_Range_8__c;
                		}
						else if (ECCRangeIdentifierPhases == 9) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4_ECC_Range_9__c;
                		}                		
                	}
                	else if (strEstimatedNumberofPhases == '4+') {
                		if (ECCRangeIdentifierPhases == 1) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4Plus_ECC_Range_1__c;
                		}	
                		else if (ECCRangeIdentifierPhases == 2) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4Plus_ECC_Range_2__c;
                		}
						else if (ECCRangeIdentifierPhases == 3) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4Plus_ECC_Range_3__c;
                		}
						else if (ECCRangeIdentifierPhases == 4) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4Plus_ECC_Range_4__c;
                		}
						else if (ECCRangeIdentifierPhases == 5) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4Plus_ECC_Range_5__c;
                		}
						else if (ECCRangeIdentifierPhases == 6) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4Plus_ECC_Range_6__c;
                		}
						else if (ECCRangeIdentifierPhases == 7) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4Plus_ECC_Range_7__c;
                		}
						else if (ECCRangeIdentifierPhases == 8) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4Plus_ECC_Range_8__c;
                		}
						else if (ECCRangeIdentifierPhases == 9) {
                			TotalPhaseDurationMultiplier = objPSEPara.Number_of_Phases_4Plus_ECC_Range_9__c;
                		}                		
                	}
                	
                	if (TotalPhaseDurationMultiplier == null) {
                		TotalPhaseDurationMultiplier = 0;                		
                	}
                	if (SinglePhaseDurationMonths == null) {
                		SinglePhaseDurationMonths = 0;
                	}
                	
                	ProfServEst.Total_R_A_Construction_Duration_years__c = (TotalPhaseDurationMultiplier * SinglePhaseDurationMonths ) / 12;
                	
                	IF (ECC < 10000000) {
                		ProfServEst.Total_R_A_Design_Duration_years__c = ProfServEst.Total_R_A_Construction_Duration_years__c;
                	}
                	else {
                		ProfServEst.Total_R_A_Design_Duration_years__c = ProfServEst.Total_R_A_Construction_Duration_years__c * 0.68;
                	}
                }
                
                ProfServEst.CECC__c = ECC / ((ConstructionDuration * ( Annual_Escalation_Rate / 100 )) + 1);     
                
                 //update Design Build - Owned values
                 if (ProfServEst.Delivery_Method__c == 'Design Build - Owned' ) {
                 	//update Detail Complexity Index
                 	if (ProfServEst.For_Design_Build_Owned_Stipend_Compl__c == 'Low' && ProfServEst.For_Design_Build_Owned_Stipend_Detail__c == 'Low') {
                 		ProfServEst.Detail_Complexity_Index__c = objPSEPara.Complexity_Low_Detail_Low__c;
                 	}
                 	else if (ProfServEst.For_Design_Build_Owned_Stipend_Compl__c == 'Low' && ProfServEst.For_Design_Build_Owned_Stipend_Detail__c == 'Medium') {
                 		ProfServEst.Detail_Complexity_Index__c = objPSEPara.Complexity_Low_Detail_Medium__c;                 		
                 	}
                 	else if (ProfServEst.For_Design_Build_Owned_Stipend_Compl__c == 'Low' && ProfServEst.For_Design_Build_Owned_Stipend_Detail__c == 'High') {
                 		ProfServEst.Detail_Complexity_Index__c = objPSEPara.Complexity_Low_Detail_High__c;                 		
                 	}
                 	else if (ProfServEst.For_Design_Build_Owned_Stipend_Compl__c == 'Medium' && ProfServEst.For_Design_Build_Owned_Stipend_Detail__c == 'Low') {
                 		ProfServEst.Detail_Complexity_Index__c = objPSEPara.Complexity_Medium_Detail_Low__c;                 		
                 	}
                 	else if (ProfServEst.For_Design_Build_Owned_Stipend_Compl__c == 'Medium' && ProfServEst.For_Design_Build_Owned_Stipend_Detail__c == 'Medium') {
                 		ProfServEst.Detail_Complexity_Index__c = objPSEPara.Complexity_Medium_Detail_Medium__c;                 		
                 	}
                 	else if (ProfServEst.For_Design_Build_Owned_Stipend_Compl__c == 'Medium' && ProfServEst.For_Design_Build_Owned_Stipend_Detail__c == 'High') {
                 		ProfServEst.Detail_Complexity_Index__c = objPSEPara.Complexity_Medium_Detail_High__c;                 		
                 	}
                 	else if (ProfServEst.For_Design_Build_Owned_Stipend_Compl__c == 'High' && ProfServEst.For_Design_Build_Owned_Stipend_Detail__c == 'Low') {
                 		ProfServEst.Detail_Complexity_Index__c = objPSEPara.Complexity_High_Detail_Low__c;                 		
                 	}
                 	else if (ProfServEst.For_Design_Build_Owned_Stipend_Compl__c == 'High' && ProfServEst.For_Design_Build_Owned_Stipend_Detail__c == 'Medium') {
                 		ProfServEst.Detail_Complexity_Index__c = objPSEPara.Complexity_High_Detail_Medium__c;                 		
                 	}
                 	else if (ProfServEst.For_Design_Build_Owned_Stipend_Compl__c == 'High' && ProfServEst.For_Design_Build_Owned_Stipend_Detail__c == 'High') {
                 		ProfServEst.Detail_Complexity_Index__c = objPSEPara.Complexity_High_Detail_High__c;                 		
                 	}
                 	//update Cost Factor based on ECC
                 	if (ECC < 25000000) {
                 		ProfServEst.Cost_Factor_based_on_ECC__c = objPSEPara.ECC_Ranges_constant_25_000_000__c * Math.exp(objPSEPara.ECC_Ranges_exponent_25_000_000__c * Math.log(ECC));
                 	}
                 	else if (ECC >= 25000000 && ECC < 50000000) {
                 		ProfServEst.Cost_Factor_based_on_ECC__c = objPSEPara.ECC_Ranges_constant_50_000_000__c * Math.exp(objPSEPara.ECC_Ranges_exponent_50_000_000__c * Math.log(ECC));
                 	}	
                 	else if (ECC >= 50000000 && ECC < 100000000) {
                 		ProfServEst.Cost_Factor_based_on_ECC__c = objPSEPara.ECC_Ranges_constant_100_000_000__c * Math.exp(objPSEPara.ECC_Ranges_exponent_100_000_000__c * Math.log(ECC));
                 	}	
                 	else if (ECC >= 100000000 && ECC < 150000000) {
                 		ProfServEst.Cost_Factor_based_on_ECC__c = objPSEPara.ECC_Ranges_constant_150_000_000__c * Math.exp(objPSEPara.ECC_Ranges_exponent_150_000_000__c * Math.log(ECC));
                 	}	
                 	else if (ECC >= 150000000 && ECC < 200000000) {
                 		ProfServEst.Cost_Factor_based_on_ECC__c = objPSEPara.ECC_Ranges_constant_200_000_000__c * Math.exp(objPSEPara.ECC_Ranges_exponent_200_000_000__c * Math.log(ECC));
                 	}	
                 	else if (ECC > = 200000000) {
                 		ProfServEst.Cost_Factor_based_on_ECC__c = objPSEPara.ECC_Ranges_constant_100_000_0000__c * Math.exp(objPSEPara.ECC_Ranges_exponent_100_000_0000__c * Math.log(ECC));
                 	}
                 	//update Stipend Percentage Unadjusted	
                 	ProfServEst.Stipend_Percentage_Unadjusted__c = ProfServEst.Detail_Complexity_Index__c * ProfServEst.Cost_Factor_based_on_ECC__c;
                 	//update Stipend Percentage
                 	if (ProfServEst.Stipend_Percentage_Unadjusted__c / 100 < 0.001) {
                 		ProfServEst.Stipend_Percentage__c = 0.001;
                 	}
                 	else {
                 		ProfServEst.Stipend_Percentage__c = ProfServEst.Stipend_Percentage_Unadjusted__c;
                 	} 
                 	//Update Stipend Amount
                 	//ProfServEst.Stipend_Amount__c = NCMT_GenerateProjectDetails.roundofneg ( Math.Ceil(ECC * ProfServEst.Stipend_Percentage__c / 100), -3);
                 	ProfServEst.Stipend_Amount__c = ECC * ProfServEst.Stipend_Percentage__c / 100;
                 	ProfServEst.Stipend_Amount__c = Math.ceil(ProfServEst.Stipend_Amount__c / 1000);
                 	ProfServEst.Stipend_Amount__c = ProfServEst.Stipend_Amount__c * 1000;
                 	//update Cost Advantage %
                 	if (ECC < 25000000) {
                 		ProfServEst.Cost_Advantage__c = 0.05;
                 	}
                 	else if (ECC >= 25000000 && ECC < 50000000) {
                 		ProfServEst.Cost_Advantage__c = 0.05+(ECC-25000000)*(0.07-0.05)/(50000000-25000000);
                 	}	
                 	else if (ECC >= 50000000 && ECC < 100000000) {
                 		ProfServEst.Cost_Advantage__c = 0.07+(ECC-50000000)*(0.075-0.07)/(100000000-50000000);
                 	}	
                 	else if (ECC >= 100000000 && ECC < 250000000) {
                 		ProfServEst.Cost_Advantage__c = 0.075+(ECC-100000000)*(0.07-0.075)/(250000000-100000000);
                 	}	
                 	else if (ECC >= 250000000 && ECC < 500000000) {
                 		ProfServEst.Cost_Advantage__c = 0.07+(ECC-250000000)*(0.03-0.07)/(500000000-250000000);
                 	}	
                 	else if (ECC >= 500000000) {
                 		ProfServEst.Cost_Advantage__c = 0.03;
                 	}
                 	ProfServEst.Cost_Advantage__c = ProfServEst.Cost_Advantage__c  * 100;
                 	//update Cost Advantage Amount
                 	ProfServEst.Cost_Advantage_Amount__c = (ProfServEst.Cost_Advantage__c/ 100) * ECC;
                 }   
                 else {
                 	ProfServEst.Detail_Complexity_Index__c = 0;
                 	ProfServEst.Cost_Factor_based_on_ECC__c = 0;
                 	ProfServEst.Stipend_Percentage_Unadjusted__c = 0;
                 	ProfServEst.Stipend_Percentage__c = 0;
                 	ProfServEst.Stipend_Amount__c = 0;
                 	ProfServEst.Cost_Advantage__c = 0;
                 	ProfServEst.Cost_Advantage_Amount__c = 0;
                 }       
             }
    }

    public void GenerateProfServEstListData (ID ProfServEstID, ID ProfServEstCECCID, ID ProfServEstECCID, Decimal dblCECC, Decimal dblECC){
        string strSOQL;
        Decimal Design_Value_A_E;
        Decimal Design_Value_CMa;
        Decimal Design_Value_CMc;
        Decimal Design_Value_CMa_and_CMc;
        Decimal Design_Value_Cx;
        Decimal Construction_Value_A_E;
        Decimal Construction_Value_CMa;
        Decimal Construction_Value_CMc;
        Decimal Construction_Value_CMa_and_CMc;
        Decimal Construction_Value_Cx;
        
        Decimal Design_Value_A_E_ECC;
        Decimal Design_Value_CMa_ECC;
        Decimal Design_Value_CMc_ECC;
        Decimal Design_Value_CMa_and_CMc_ECC;
        Decimal Design_Value_Cx_ECC;
        Decimal Construction_Value_A_E_ECC;
        Decimal Construction_Value_CMa_ECC;
        Decimal Construction_Value_CMc_ECC;
        Decimal Construction_Value_CMa_and_CMc_ECC;
        Decimal Construction_Value_Cx_ECC;
        
        strSOQL = 'SELECT Type__c, Design_Value_A_E__c, Design_Value_CMa__c, Design_Value_CMc__c, Design_Value_CMa_and_CMc__c, Design_Value_Cx__c, ' + ' ' + 
                    'Construction_Value_A_E__c, Construction_Value_CMa__c, Construction_Value_CMc__c, Construction_Value_CMa_and_CMc__c, Construction_Value_Cx__c, ' + ' ' +
                    'Design_Constant_A_E__c, Design_Exponent_A_E__c, Design_Delivery_Method_Adjustment_A_E__c, ' + ' ' +
                    'Design_Constant_CMa__c, Design_Exponent_CMa__c, Design_CM_Role_Adjustment_CMa__c, ' + ' ' +
                    'Design_CM_Role_Adjustment_CMc__c, Design_CM_Role_Adjustment_CMa_and_CMc__c, ' + ' ' +
                    'Design_Constant_Cx__c, Design_Exponent_Cx__c, ' + ' ' +                    
                    'Construction_Constant_A_E__c, Construction_Exponent_A_E__c, Construction_Delivery_Method_Adj_A_E__c, ' + ' ' +
                    'Construction_Constant_CMa__c, Construction_Exponent_CMa__c, Construction_CM_Role_Adjustment_CMa__c, ' + ' ' +
                    'Construction_CM_Role_Adjustment_CMc__c, Construction_CM_Role_Adj_CMa_and_CMc__c, ' + ' ' +
                    'Construction_Constant_Cx__c, Construction_Exponent_Cx__c ' + ' ' +                    
                    'FROM AE_CMa_CMc_Cx__c ' + ' ' + 
                    'WHERE ID = :ProfServEstCECCID or ID = :ProfServEstECCID';

        List <AE_CMa_CMc_Cx__c> ListAE_CMa_CMc_Cx = Database.query(strSOQL);
        for (AE_CMa_CMc_Cx__c objAE_CMa_CMc_Cx: ListAE_CMa_CMc_Cx) {
            if (objAE_CMa_CMc_Cx.Type__c =='CECC') {
               if (dblCECC > 0) { 
	               Design_Value_A_E = (objAE_CMa_CMc_Cx.Design_Constant_A_E__c * Math.exp(objAE_CMa_CMc_Cx.Design_Exponent_A_E__c * Math.log(dblCECC)) ) * objAE_CMa_CMc_Cx.Design_Delivery_Method_Adjustment_A_E__c;
	               Design_Value_CMa = (objAE_CMa_CMc_Cx.Design_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Design_Exponent_CMa__c * Math.log(dblCECC)) ) * objAE_CMa_CMc_Cx.Design_CM_Role_Adjustment_CMa__c * 100;
	               Design_Value_CMc = (objAE_CMa_CMc_Cx.Design_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Design_Exponent_CMa__c * Math.log(dblCECC)) ) * objAE_CMa_CMc_Cx.Design_CM_Role_Adjustment_CMc__c * 100;
	               Design_Value_CMa_and_CMc = (objAE_CMa_CMc_Cx.Design_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Design_Exponent_CMa__c * Math.log(dblCECC)) ) * objAE_CMa_CMc_Cx.Design_CM_Role_Adjustment_CMa_and_CMc__c * 100;
	               Design_Value_Cx = objAE_CMa_CMc_Cx.Design_Constant_Cx__c * Math.exp(objAE_CMa_CMc_Cx.Design_Exponent_Cx__c * Math.log(dblCECC)) * 100;
	               
	               Construction_Value_A_E = (objAE_CMa_CMc_Cx.Construction_Constant_A_E__c * Math.exp(objAE_CMa_CMc_Cx.Construction_Exponent_A_E__c * Math.log(dblCECC)) ) * objAE_CMa_CMc_Cx.Construction_Delivery_Method_Adj_A_E__c;
	               Construction_Value_CMa = (objAE_CMa_CMc_Cx.Construction_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Construction_Exponent_CMa__c * Math.log(dblCECC)) ) * objAE_CMa_CMc_Cx.Construction_CM_Role_Adjustment_CMa__c * 100;
	               Construction_Value_CMc = (objAE_CMa_CMc_Cx.Construction_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Construction_Exponent_CMa__c * Math.log(dblCECC)) ) * objAE_CMa_CMc_Cx.Construction_CM_Role_Adjustment_CMc__c * 100;
	               Construction_Value_CMa_and_CMc = (objAE_CMa_CMc_Cx.Construction_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Construction_Exponent_CMa__c * Math.log(dblCECC)) ) * objAE_CMa_CMc_Cx.Construction_CM_Role_Adj_CMa_and_CMc__c * 100;
	               Construction_Value_Cx = objAE_CMa_CMc_Cx.Construction_Constant_Cx__c * Math.exp(objAE_CMa_CMc_Cx.Construction_Exponent_Cx__c * Math.log(dblCECC)) * 100;
               }    
			   else {
			   	   Design_Value_A_E = 0;
	               Design_Value_CMa = 0;
	               Design_Value_CMc = 0;
	               Design_Value_CMa_and_CMc = 0;
	               Design_Value_Cx = 0;
	               
	               Construction_Value_A_E = 0;
	               Construction_Value_CMa = 0;
	               Construction_Value_CMc = 0;
	               Construction_Value_CMa_and_CMc = 0;
	               Construction_Value_Cx = 0;               
               }
               
            }
            else {
			   if (dblECC > 0) {
	               Design_Value_A_E_ECC = (objAE_CMa_CMc_Cx.Design_Constant_A_E__c * Math.exp(objAE_CMa_CMc_Cx.Design_Exponent_A_E__c * Math.log(dblECC)) ) * objAE_CMa_CMc_Cx.Design_Delivery_Method_Adjustment_A_E__c;
	               Design_Value_CMa_ECC = (objAE_CMa_CMc_Cx.Design_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Design_Exponent_CMa__c * Math.log(dblECC)) ) * objAE_CMa_CMc_Cx.Design_CM_Role_Adjustment_CMa__c * 100;
	               Design_Value_CMc_ECC = (objAE_CMa_CMc_Cx.Design_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Design_Exponent_CMa__c * Math.log(dblECC)) ) * objAE_CMa_CMc_Cx.Design_CM_Role_Adjustment_CMc__c * 100;
	               Design_Value_CMa_and_CMc_ECC = (objAE_CMa_CMc_Cx.Design_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Design_Exponent_CMa__c * Math.log(dblECC)) ) * objAE_CMa_CMc_Cx.Design_CM_Role_Adjustment_CMa_and_CMc__c * 100;
	               Design_Value_Cx_ECC = objAE_CMa_CMc_Cx.Design_Constant_Cx__c * Math.exp(objAE_CMa_CMc_Cx.Design_Exponent_Cx__c * Math.log(dblECC)) * 100;
	               
	               Construction_Value_A_E_ECC = (objAE_CMa_CMc_Cx.Construction_Constant_A_E__c * Math.exp(objAE_CMa_CMc_Cx.Construction_Exponent_A_E__c * Math.log(dblECC)) ) * objAE_CMa_CMc_Cx.Construction_Delivery_Method_Adj_A_E__c;
	               Construction_Value_CMa_ECC = (objAE_CMa_CMc_Cx.Construction_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Construction_Exponent_CMa__c * Math.log(dblECC)) ) * objAE_CMa_CMc_Cx.Construction_CM_Role_Adjustment_CMa__c * 100;
	               Construction_Value_CMc_ECC = (objAE_CMa_CMc_Cx.Construction_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Construction_Exponent_CMa__c * Math.log(dblECC)) ) * objAE_CMa_CMc_Cx.Construction_CM_Role_Adjustment_CMc__c * 100;
	               Construction_Value_CMa_and_CMc_ECC = (objAE_CMa_CMc_Cx.Construction_Constant_CMa__c * Math.exp(objAE_CMa_CMc_Cx.Construction_Exponent_CMa__c * Math.log(dblECC)) ) * objAE_CMa_CMc_Cx.Construction_CM_Role_Adj_CMa_and_CMc__c * 100;
	               Construction_Value_Cx_ECC = objAE_CMa_CMc_Cx.Construction_Constant_Cx__c * Math.exp(objAE_CMa_CMc_Cx.Construction_Exponent_Cx__c * Math.log(dblECC)) * 100;
			   }
			   else {
			   	   Design_Value_A_E_ECC = 0;
	               Design_Value_CMa_ECC = 0;
	               Design_Value_CMc_ECC = 0;
	               Design_Value_CMa_and_CMc_ECC = 0;
	               Design_Value_Cx_ECC = 0;
	               
	               Construction_Value_A_E_ECC = 0;
	               Construction_Value_CMa_ECC = 0;
	               Construction_Value_CMc_ECC = 0;
	               Construction_Value_CMa_and_CMc_ECC = 0;
	               Construction_Value_Cx_ECC = 0;
			   }              
            }
        }

        List<Professional_Service_Estimate_List__c> objProfServEstListRecords = New List<Professional_Service_Estimate_List__c>();
        //add CECC EDRC records
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'CECC',
            EDRC_EMIC_Type__c = 'EDRC AE',
            Percentage_to_Use__c = Design_Value_A_E,
            Percentage_ECC__c = 0
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'CECC',
            EDRC_EMIC_Type__c = 'EDRC Cma',
            Percentage_to_Use__c = Design_Value_CMa,
            Percentage_ECC__c = 0
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'CECC',
            EDRC_EMIC_Type__c = 'EDRC CMc',
            Percentage_to_Use__c = Design_Value_CMc,
            Percentage_ECC__c = 0
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'CECC',
            EDRC_EMIC_Type__c = 'EDRC CMa and CMc',
            Percentage_to_Use__c = Design_Value_CMa_and_CMc,
            Percentage_ECC__c = 0
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'CECC',
            EDRC_EMIC_Type__c = 'EDRC Cx',
            Percentage_to_Use__c = Design_Value_Cx,
            Percentage_ECC__c = 0
        ));
        //add CECC EMIC records
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'CECC',
            EDRC_EMIC_Type__c = 'EMIC AE',
            Percentage_to_Use__c = Construction_Value_A_E,
            Percentage_ECC__c = 0
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'CECC',
            EDRC_EMIC_Type__c = 'EMIC Cma',
            Percentage_to_Use__c = Construction_Value_CMa,
            Percentage_ECC__c = 0
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'CECC',
            EDRC_EMIC_Type__c = 'EMIC CMc',
            Percentage_to_Use__c = Construction_Value_CMc,
            Percentage_ECC__c = 0
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'CECC',
            EDRC_EMIC_Type__c = 'EMIC CMa and CMc',
            Percentage_to_Use__c = Construction_Value_CMa_and_CMc,
            Percentage_ECC__c = 0
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'CECC',
            EDRC_EMIC_Type__c = 'EMIC Cx',
            Percentage_to_Use__c = Construction_Value_Cx,
            Percentage_ECC__c = 0
        ));      

        //add ECC EDRC records
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'ECC',
            EDRC_EMIC_Type__c = 'EDRC AE',
            Percentage_to_Use__c = Design_Value_A_E_ECC,
            Percentage_ECC__c = Design_Value_A_E_ECC
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'ECC',
            EDRC_EMIC_Type__c = 'EDRC Cma',
            Percentage_to_Use__c = Design_Value_CMa_ECC,
            Percentage_ECC__c = Design_Value_CMa_ECC
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'ECC',
            EDRC_EMIC_Type__c = 'EDRC CMc',
            Percentage_to_Use__c = Design_Value_CMc_ECC,
            Percentage_ECC__c = Design_Value_CMc_ECC
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'ECC',
            EDRC_EMIC_Type__c = 'EDRC CMa and CMc',
            Percentage_to_Use__c = Design_Value_CMa_and_CMc_ECC,
            Percentage_ECC__c = Design_Value_CMa_and_CMc_ECC
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'ECC',
            EDRC_EMIC_Type__c = 'EDRC Cx',
            Percentage_to_Use__c = Design_Value_Cx_ECC,
            Percentage_ECC__c = Design_Value_Cx_ECC         
        ));
        //add ECC EMIC records
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'ECC',
            EDRC_EMIC_Type__c = 'EMIC AE',
            Percentage_to_Use__c = Construction_Value_A_E_ECC,
            Percentage_ECC__c = Construction_Value_A_E_ECC
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'ECC',
            EDRC_EMIC_Type__c = 'EMIC Cma',
            Percentage_to_Use__c = Construction_Value_Cma_ECC,
            Percentage_ECC__c = Construction_Value_Cma_ECC
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'ECC',
            EDRC_EMIC_Type__c = 'EMIC CMc',
            Percentage_to_Use__c = Construction_Value_CMc_ECC,
            Percentage_ECC__c = Construction_Value_CMc_ECC
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'ECC',
            EDRC_EMIC_Type__c = 'EMIC CMa and CMc',
            Percentage_to_Use__c = Construction_Value_CMa_and_CMc_ECC,
            Percentage_ECC__c = Construction_Value_CMc_ECC
        ));
        objProfServEstListRecords.Add(new Professional_Service_Estimate_List__c(
            PS__c = ProfServEstID,
            Type__c = 'ECC',
            EDRC_EMIC_Type__c = 'EMIC Cx',
            Percentage_to_Use__c = Construction_Value_Cx_ECC,
            Percentage_ECC__c = Construction_Value_Cx_ECC
        ));
                
        insert objProfServEstListRecords;
    }
    
    public void DeleteProfServEstListData (ID ProfServEstID) {
        List <Professional_Service_Estimate_List__c> lstDelete = [SELECT Id from Professional_Service_Estimate_List__c where PS__c = :ProfServEstID limit 50000] ;
        IF (lstDelete.size() > 0) Delete lstDelete;
    }   

}