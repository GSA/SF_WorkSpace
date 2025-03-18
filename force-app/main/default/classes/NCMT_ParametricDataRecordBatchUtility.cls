public with sharing class NCMT_ParametricDataRecordBatchUtility {
    public static void copyReportDataToObject( List<Id> projectIds){
        List<NCMT_Parameters__c> ncmtParametersToInsert =new List<NCMT_Parameters__c>();
        Map<Id,reportData> reportDataMap =  getProjectData(projectIds);
         //system.debug(':::reportDataMap:::'+reportDataMap.keySet());
        for(String projectId : reportDataMap.keySet()){
            reportData  projectReportData= reportDataMap.get(projectId);
            //Floors
            NCMT_Parameters__c numberOfFloors =  setDefaultNCMTParamater(projectReportData);
            numberOfFloors.Parameter_Section_Name__c='Floors';
            numberOfFloors.Parameter_Name__c = 'Number of floors';
            numberOfFloors.Default_Value__c=String.ValueOf(projectReportData.PLPData.Default_Above_Ground__c);
            numberOfFloors.User_Value__c =String.ValueOf(projectReportData.PLPData.Above_Ground__c);
            numberOfFloors.Unit__c ='EA';
            ncmtParametersToInsert.add(numberOfFloors);
            NCMT_Parameters__c basementFloors =  setDefaultNCMTParamater(projectReportData);
            basementFloors.Parameter_Section_Name__c='Floors';
            basementFloors.Parameter_Name__c = 'Basement floors';
            basementFloors.Default_Value__c=String.ValueOf(projectReportData.PLPData.Default_Below_Ground__c);
            basementFloors.User_Value__c =String.ValueOf(projectReportData.PLPData.Below_Ground__c);
            basementFloors.Unit__c ='EA';
            ncmtParametersToInsert.add(basementFloors);
            //Areas
            NCMT_Parameters__c bldgGrossArea =  setDefaultNCMTParamater(projectReportData);
            bldgGrossArea.Parameter_Section_Name__c='Areas';
            bldgGrossArea.Parameter_Name__c='Building Gross Enclosed Area';
            bldgGrossArea.Default_Value__c = String.ValueOf(projectReportData.PLPData.NCMT_Project__r.Total_GSF__c);
            bldgGrossArea.Unit__c ='SF';
            bldgGrossArea.Override_Comments_Label__c ='Massing';
            bldgGrossArea.Override_Comments__c = projectReportData.PLPData.Massing_Override_Comments__c;
            ncmtParametersToInsert.add(bldgGrossArea);
            NCMT_Parameters__c footprintArea =  setDefaultNCMTParamater(projectReportData);
            footprintArea.Parameter_Section_Name__c='Areas';
            footprintArea.Parameter_Name__c='Footprint Area';
            footprintArea.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Foot_Print_Area__c);
            footprintArea.User_Value__c = String.ValueOf(projectReportData.PLPData.Foot_Print_Area__c);
            footprintArea.Unit__c ='SF';
            ncmtParametersToInsert.add(footprintArea);
            NCMT_Parameters__c basement =  setDefaultNCMTParamater(projectReportData);
            basement.Parameter_Section_Name__c='Areas';
            basement.Parameter_Name__c='Basement';
            basement.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Basement_SF__c);
            basement.User_Value__c = String.ValueOf(projectReportData.PLPData.Basement_SF__c);
            basement.Unit__c ='SF';
            ncmtParametersToInsert.add(basement);
            NCMT_Parameters__c elevatedFlrArea =  setDefaultNCMTParamater(projectReportData);
            elevatedFlrArea.Parameter_Section_Name__c='Areas';
            elevatedFlrArea.Parameter_Name__c='Elevated Floor Area';
            elevatedFlrArea.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Elevated_Floor_Area_SF__c);
            elevatedFlrArea.User_Value__c = String.ValueOf(projectReportData.PLPData.Elevated_Floor_Area_SF__c);
            elevatedFlrArea.Unit__c ='SF';
            ncmtParametersToInsert.add(elevatedFlrArea);
            NCMT_Parameters__c grossSiteArea =  setDefaultNCMTParamater(projectReportData);
            grossSiteArea.Parameter_Section_Name__c='Areas';
            grossSiteArea.Parameter_Name__c='Gross Site Area';
            grossSiteArea.Default_Value__c = String.ValueOf(projectReportData.PLPData.NCMT_Project__r.Calculated_Site_Area__c);
            grossSiteArea.User_Value__c = String.ValueOf(projectReportData.PLPData.NCMT_Project__r.Override_Calculated_Site_Area__c);
            grossSiteArea.Unit__c ='SF';
            ncmtParametersToInsert.add(grossSiteArea);
            NCMT_Parameters__c finishedSiteArea =  setDefaultNCMTParamater(projectReportData);
            finishedSiteArea.Parameter_Section_Name__c='Areas';
            finishedSiteArea.Parameter_Name__c='Finished Site Area';
            finishedSiteArea.Default_Value__c = String.ValueOf(projectReportData.siteData.Finished_Site__c);
            finishedSiteArea.User_Value__c = String.ValueOf(projectReportData.siteData.Finished_Site__c);
            finishedSiteArea.Unit__c ='SF';
            ncmtParametersToInsert.add(finishedSiteArea);
            //Building Height
            NCMT_Parameters__c basementperFloor =  setDefaultNCMTParamater(projectReportData);
            basementperFloor.Parameter_Section_Name__c='Building Height';
            basementperFloor.Parameter_Name__c='Basement (Per Basement Floor)';
            basementperFloor.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Basement_Story_Height__c);
            basementperFloor.User_Value__c = String.ValueOf(projectReportData.PLPData.Basement_Story_Height__c);
            basementperFloor.Unit__c ='FT';
            ncmtParametersToInsert.add(basementperFloor);
            NCMT_Parameters__c upperperFloor =  setDefaultNCMTParamater(projectReportData);
            upperperFloor.Parameter_Section_Name__c='Building Height';
            upperperFloor.Parameter_Name__c='Upper Floors (Average Per Floor)';
            upperperFloor.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Average_Story_Height__c);
            upperperFloor.User_Value__c = String.ValueOf(projectReportData.PLPData.Average_Story_Height__c);
            upperperFloor.Unit__c ='FT';
            ncmtParametersToInsert.add(upperperFloor);
            //Structural System
            NCMT_Parameters__c foundations =  setDefaultNCMTParamater(projectReportData);
            foundations.Parameter_Section_Name__c='Structural System';
            foundations.Parameter_Name__c='Foundations';
            foundations.Default_Value__c = String.ValueOf(projectReportData.foundations);
            foundations.Override_Comments_Label__c ='Structure';
            foundations.Override_Comments__c = projectReportData.PLPData.Structure_Override_Comments__c;
            ncmtParametersToInsert.add(foundations);
            NCMT_Parameters__c structuralFrame =  setDefaultNCMTParamater(projectReportData);
            structuralFrame.Parameter_Section_Name__c='Structural System';
            structuralFrame.Parameter_Name__c='Structural Frame';
            structuralFrame.Default_Value__c = String.ValueOf(projectReportData.PLPData.Structural_Frame__c);
            ncmtParametersToInsert.add(structuralFrame);
            NCMT_Parameters__c typicalBaySize =  setDefaultNCMTParamater(projectReportData);
            typicalBaySize.Parameter_Section_Name__c='Structural System';
            typicalBaySize.Parameter_Name__c='Typical Bay Size';
            typicalBaySize.Default_Value__c = String.ValueOf(projectReportData.PLPData.Average_Typical_Bay_Area__c);
            ncmtParametersToInsert.add(typicalBaySize);
            NCMT_Parameters__c deadLoad =  setDefaultNCMTParamater(projectReportData);
            deadLoad.Parameter_Section_Name__c='Structural System';
            deadLoad.Parameter_Name__c='Dead Load';
            deadLoad.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Dead_Load__c);
            deadLoad.User_Value__c = String.ValueOf(projectReportData.PLPData.Dead_Load__c);
            deadLoad.Unit__c ='#/SF';
            ncmtParametersToInsert.add(deadLoad);
            NCMT_Parameters__c liveLoad =  setDefaultNCMTParamater(projectReportData);
            liveLoad.Parameter_Section_Name__c='Structural System';
            liveLoad.Parameter_Name__c='Live Load';
            liveLoad.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Live_Load__c);
            liveLoad.User_Value__c = String.ValueOf(projectReportData.PLPData.Live_Load__c);
            liveLoad.Unit__c ='#/SF';
            ncmtParametersToInsert.add(liveLoad);
            //Cladding
            NCMT_Parameters__c type =  setDefaultNCMTParamater(projectReportData);
            type.Parameter_Section_Name__c='Cladding';
            type.Parameter_Name__c='Type';
            type.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Cladding_Type__c);
            type.User_Value__c = String.ValueOf(projectReportData.PLPData.Cladding_Type__c);
            ncmtParametersToInsert.add(type);
            NCMT_Parameters__c quality =  setDefaultNCMTParamater(projectReportData);
            quality.Parameter_Section_Name__c='Cladding';
            quality.Parameter_Name__c='Quality';
            quality.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Cladding_Quality__c);
            quality.User_Value__c = String.ValueOf(projectReportData.PLPData.Cladding_Quality__c);
            ncmtParametersToInsert.add(quality);
            NCMT_Parameters__c skinRatio =  setDefaultNCMTParamater(projectReportData);
            skinRatio.Parameter_Section_Name__c='Cladding';
            skinRatio.Parameter_Name__c='Skin Ratio';
            skinRatio.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Skin_Ratio__c);
            skinRatio.User_Value__c = String.ValueOf(projectReportData.PLPData.Cladding_Skin_Ratio__c);
            skinRatio.Override_Comments_Label__c ='Skin';
            skinRatio.Override_Comments__c = projectReportData.PLPData.Skin_System_Override_Comments__c;
            ncmtParametersToInsert.add(skinRatio);
            NCMT_Parameters__c glazingRatio =  setDefaultNCMTParamater(projectReportData);
            glazingRatio.Parameter_Section_Name__c='Cladding';
            glazingRatio.Parameter_Name__c='Glazing Ratio (% of above-grade skin)';
            glazingRatio.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Glazing_Ratio__c);
            glazingRatio.User_Value__c = String.ValueOf(projectReportData.PLPData.Glazing_Ratio_of_above_grade_skin__c);
            glazingRatio.Unit__c= 'Percent';
            ncmtParametersToInsert.add(glazingRatio);
            NCMT_Parameters__c totalWallArea =  setDefaultNCMTParamater(projectReportData);
            totalWallArea.Parameter_Section_Name__c='Cladding';
            totalWallArea.Parameter_Name__c='Total Wall Area';
            totalWallArea.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Total_Wall_Area_SF__c);
            totalWallArea.User_Value__c = String.ValueOf(projectReportData.PLPData.Cladding_Skin_Ratio_SF__c);
            totalWallArea.Unit__c= 'SF';
            ncmtParametersToInsert.add(totalWallArea);
            NCMT_Parameters__c finishedWallArea =  setDefaultNCMTParamater(projectReportData);
            finishedWallArea.Parameter_Section_Name__c='Cladding';
            finishedWallArea.Parameter_Name__c='Finished Wall Area (Including Glazing)';
            finishedWallArea.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Finished_Wall_Area_SF__c);
            finishedWallArea.User_Value__c = String.ValueOf(projectReportData.PLPData.Finished_Wall_Area_SF__c);
            finishedWallArea.Unit__c= 'SF';
            ncmtParametersToInsert.add(finishedWallArea);
            NCMT_Parameters__c retainingWall =  setDefaultNCMTParamater(projectReportData);
            retainingWall.Parameter_Section_Name__c='Cladding';
            retainingWall.Parameter_Name__c='Retaining Wall';
            retainingWall.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Retaining_Wall_SF__c);
            retainingWall.User_Value__c = String.ValueOf(projectReportData.PLPData.Cladding_Retaining_Wall_SF__c);
            retainingWall.Unit__c= 'SF';
            ncmtParametersToInsert.add(retainingWall);
            NCMT_Parameters__c finishedopaqueWall =  setDefaultNCMTParamater(projectReportData);
            finishedopaqueWall.Parameter_Section_Name__c='Cladding';
            finishedopaqueWall.Parameter_Name__c='Finished Opaque Wall (Excl Glazing)';
            finishedopaqueWall.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Finished_Opaque_Wall_SF__c);
            finishedopaqueWall.User_Value__c = String.ValueOf(projectReportData.PLPData.Finished_Opaque_Wall_SF__c);
            finishedopaqueWall.Unit__c= 'SF';
            ncmtParametersToInsert.add(finishedopaqueWall);
            NCMT_Parameters__c glazing =  setDefaultNCMTParamater(projectReportData);
            glazing.Parameter_Section_Name__c='Cladding';
            glazing.Parameter_Name__c='Glazing';
            glazing.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Glazing_SF__c);
            glazing.User_Value__c = String.ValueOf(projectReportData.PLPData.Glazing_Ratio_SF__c);
            glazing.Unit__c= 'SF';
            glazing.Override_Comments_Label__c ='Cladding';
            glazing.Override_Comments__c = projectReportData.PLPData.Cladding_Override_Comments__c;
            ncmtParametersToInsert.add(glazing);
            //Roofing
            NCMT_Parameters__c totalRoofArea =  setDefaultNCMTParamater(projectReportData);
            totalRoofArea.Parameter_Section_Name__c='Roofing';
            totalRoofArea.Parameter_Name__c='Total roof area';
            totalRoofArea.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Foot_Print_Area__c);
            totalRoofArea.User_Value__c = String.ValueOf(projectReportData.PLPData.Total_Roof_Area_SF__c);
            totalRoofArea.Unit__c= 'SF';
            totalRoofArea.Override_Comments_Label__c ='Roof System';
            totalRoofArea.Override_Comments__c = projectReportData.PLPData.Roof_System_Override_Comments__c;
            ncmtParametersToInsert.add(totalRoofArea);
            NCMT_Parameters__c basementRoof =  setDefaultNCMTParamater(projectReportData);
            basementRoof.Parameter_Section_Name__c='Roofing';
            basementRoof.Parameter_Name__c='Basement roof';
            basementRoof.Default_Value__c = '0';
            basementRoof.User_Value__c = String.ValueOf(projectReportData.PLPData.Basement_Roof_SF__c);
            basementRoof.Unit__c= 'SF';
            ncmtParametersToInsert.add(basementRoof);
            NCMT_Parameters__c upperRoof =  setDefaultNCMTParamater(projectReportData);
            upperRoof.Parameter_Section_Name__c='Roofing';
            upperRoof.Parameter_Name__c='Upper roof';
            upperRoof.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Foot_Print_Area__c);
            upperRoof.User_Value__c = String.ValueOf(projectReportData.PLPData.Upper_Roof_SF__c);
            upperRoof.Unit__c= 'SF';
            ncmtParametersToInsert.add(upperRoof);
            NCMT_Parameters__c slopedRoof =  setDefaultNCMTParamater(projectReportData);
            slopedRoof.Parameter_Section_Name__c='Roofing';
            slopedRoof.Parameter_Name__c='Sloped roof';
            slopedRoof.Default_Value__c = '0';
            slopedRoof.User_Value__c = String.ValueOf(projectReportData.PLPData.Sloped_Roof_SF__c);
            slopedRoof.Unit__c= 'SF';
            ncmtParametersToInsert.add(slopedRoof);
            NCMT_Parameters__c greenRoof =  setDefaultNCMTParamater(projectReportData);
            greenRoof.Parameter_Section_Name__c='Roofing';
            greenRoof.Parameter_Name__c='Green roof';
            greenRoof.Default_Value__c = '0';
            greenRoof.User_Value__c = String.ValueOf(projectReportData.PLPData.Green_Roof_SF__c);
            greenRoof.Unit__c= 'SF';
            ncmtParametersToInsert.add(greenRoof);
            NCMT_Parameters__c flatRoof =  setDefaultNCMTParamater(projectReportData);
            flatRoof.Parameter_Section_Name__c='Roofing';
            flatRoof.Parameter_Name__c='Flat roof';
            flatRoof.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Foot_Print_Area__c);
            flatRoof.User_Value__c = String.ValueOf(projectReportData.PLPData.Flat_Roof_SF__c);
            flatRoof.Unit__c= 'SF';
            ncmtParametersToInsert.add(flatRoof);
            NCMT_Parameters__c skylights =  setDefaultNCMTParamater(projectReportData);
            skylights.Parameter_Section_Name__c='Roofing';
            skylights.Parameter_Name__c='Skylights';
            skylights.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Roofing_Skylights__c);
            skylights.User_Value__c = String.ValueOf(projectReportData.PLPData.Roofing_Skylights__c);
            skylights.Unit__c= 'SF';
            skylights.Override_Comments_Label__c ='Roofing';
            skylights.Override_Comments__c = projectReportData.PLPData.Roofing_Override_Comments__c;
            ncmtParametersToInsert.add(skylights);
            //Site Conditions
			NCMT_Parameters__c soilbearingcap =  setDefaultNCMTParamater(projectReportData);
            soilbearingcap.Parameter_Section_Name__c='Site Conditions';
            soilbearingcap.Parameter_Name__c='Soil bearing capacity';
            soilbearingcap.Default_Value__c = String.ValueOf(projectReportData.PLPData.Soil_Bearing_Strength__c);
            soilbearingcap.Unit__c= 'KSF';
            ncmtParametersToInsert.add(soilbearingcap);            
            NCMT_Parameters__c siteAccess =  setDefaultNCMTParamater(projectReportData);
            siteAccess.Parameter_Section_Name__c='Site Conditions';
            siteAccess.Parameter_Name__c='Site Access';
            siteAccess.Default_Value__c = String.ValueOf(projectReportData.PLPData.Site_Access__c);
            siteAccess.User_Value__c = String.ValueOf(projectReportData.PLPData.Site_Access_Cost_Impact__c);
            siteAccess.Unit__c= 'Percent';
            ncmtParametersToInsert.add(siteAccess);
            NCMT_Parameters__c siteRemoteness =  setDefaultNCMTParamater(projectReportData);
            siteRemoteness.Parameter_Section_Name__c='Site Conditions';
            siteRemoteness.Parameter_Name__c='Site Remoteness';
            siteRemoteness.Default_Value__c = String.ValueOf(projectReportData.PLPData.Site_Remoteness__c);
            siteRemoteness.User_Value__c = String.ValueOf(projectReportData.PLPData.SiteRemoteness_Cost_Impact__c);
            siteRemoteness.Unit__c= 'Percent';
            ncmtParametersToInsert.add(siteRemoteness);
            NCMT_Parameters__c otherSpecialCond =  setDefaultNCMTParamater(projectReportData);
            otherSpecialCond.Parameter_Section_Name__c='Site Conditions';
            otherSpecialCond.Parameter_Name__c='Other Special Condition:';
            otherSpecialCond.Default_Value__c = String.ValueOf(projectReportData.PLPData.Other_Special_Condition_Specify__c);
            otherSpecialCond.User_Value__c = String.ValueOf(projectReportData.PLPData.Cost_Impact_Percent__c);
            otherSpecialCond.Unit__c= 'Percent';
            ncmtParametersToInsert.add(otherSpecialCond);
            NCMT_Parameters__c freezeDepth =  setDefaultNCMTParamater(projectReportData);
            freezeDepth.Parameter_Section_Name__c='Site Conditions';
            freezeDepth.Parameter_Name__c='Freeze Depth/Footing depth';
            freezeDepth.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Freeze_Depth_Footing_Depth__c);
            freezeDepth.User_Value__c = String.ValueOf(projectReportData.PLPData.Freeze_Depth_Footing_Depth_BG__c);
            freezeDepth.Unit__c= 'Ft';
            ncmtParametersToInsert.add(freezeDepth);
            NCMT_Parameters__c WaterDepth =  setDefaultNCMTParamater(projectReportData);
            WaterDepth.Parameter_Section_Name__c='Site Conditions';
            WaterDepth.Parameter_Name__c='Water table depth';
            WaterDepth.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Water_Table_Depth__c);
            WaterDepth.User_Value__c = String.ValueOf(projectReportData.PLPData.Water_Table_Depth__c);
            WaterDepth.Unit__c= 'Ft';
            ncmtParametersToInsert.add(WaterDepth);
            NCMT_Parameters__c excavationper =  setDefaultNCMTParamater(projectReportData);
            excavationper.Parameter_Section_Name__c='Site Conditions';
            excavationper.Parameter_Name__c='Excavation: Percentage shored';
            excavationper.Default_Value__c = String.ValueOf(projectReportData.PLPData.Excavation_Percentage_Shored_BG__c);
            excavationper.User_Value__c = String.ValueOf(projectReportData.PLPData.Excavation_Percent_Shored_BG__c);
            excavationper.Unit__c= 'Percent';
            ncmtParametersToInsert.add(excavationper);
            //Interior Construction
            NCMT_Parameters__c coreshellPartition =  setDefaultNCMTParamater(projectReportData);
            coreshellPartition.Parameter_Section_Name__c='Interior Construction';
            coreshellPartition.Parameter_Name__c='Core/Shell Partition Ratio';
            coreshellPartition.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Core_Shell_Partition_Ratio__c);
            coreshellPartition.User_Value__c = String.ValueOf(projectReportData.PLPData.Int_Const_Core_Shell_Partition_ratio__c);
            coreshellPartition.Override_Comments_Label__c ='Interior';
            coreshellPartition.Override_Comments__c = projectReportData.PLPData.Interior_Override_Comments__c;
            ncmtParametersToInsert.add(coreshellPartition);
            //Vertical Conveyance
            NCMT_Parameters__c stairsFlights =  setDefaultNCMTParamater(projectReportData);
            stairsFlights.Parameter_Section_Name__c='Vertical Conveyance';
            stairsFlights.Parameter_Name__c='Stairs - Flight';
            stairsFlights.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Stairs_Flight__c);
            stairsFlights.User_Value__c = String.ValueOf(projectReportData.PLPData.Use_Stairs_Flight__c);
            stairsFlights.Unit__c = 'EA';
            stairsFlights.Override_Comments_Label__c ='Vertical';
            stairsFlights.Override_Comments__c = projectReportData.PLPData.Vertical_Transportation_Override_Comment__c;
            ncmtParametersToInsert.add(stairsFlights);
            NCMT_Parameters__c elevatorsPublic =  setDefaultNCMTParamater(projectReportData);
            elevatorsPublic.Parameter_Section_Name__c='Vertical Conveyance';
            elevatorsPublic.Parameter_Name__c='Elevators - Public';
            elevatorsPublic.Default_Value__c = String.ValueOf(projectReportData.PLPData.Def_Vertical_Conveyance_Elevators_Stops__c);
            elevatorsPublic.User_Value__c = String.ValueOf(projectReportData.PLPData.Number_of_Stops__c);
            elevatorsPublic.Unit__c = 'Stops';
            ncmtParametersToInsert.add(elevatorsPublic);
            NCMT_Parameters__c elevatorsPrivate =  setDefaultNCMTParamater(projectReportData);
            elevatorsPrivate.Parameter_Section_Name__c='Vertical Conveyance';
            elevatorsPrivate.Parameter_Name__c='Elevators - Private';
            elevatorsPrivate.User_Value__c = 'Incl. in TI';
            ncmtParametersToInsert.add(elevatorsPrivate);
            NCMT_Parameters__c escalatorsPairs =  setDefaultNCMTParamater(projectReportData);
            escalatorsPairs.Parameter_Section_Name__c='Vertical Conveyance';
            escalatorsPairs.Parameter_Name__c='Escalators - Pairs';
            escalatorsPairs.Default_Value__c = '0';
            escalatorsPairs.User_Value__c = String.ValueOf(projectReportData.PLPData.Vertical_Conveyance_Escalators_PR__c);
            escalatorsPairs.Unit__c = 'EA';
            ncmtParametersToInsert.add(escalatorsPairs);
            //Plumbing
            NCMT_Parameters__c fixturesPublic =  setDefaultNCMTParamater(projectReportData);
            fixturesPublic.Parameter_Section_Name__c='Plumbing';
            fixturesPublic.Parameter_Name__c='Fixtures - Public Restrooms';
            fixturesPublic.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Fixtures_Public_Restrooms__c);
            fixturesPublic.User_Value__c = String.ValueOf(projectReportData.PLPData.Use_Fixtures_Public_Restrooms__c);
            fixturesPublic.Unit__c = 'EA';
            ncmtParametersToInsert.add(fixturesPublic);
            NCMT_Parameters__c fixturesUtility =  setDefaultNCMTParamater(projectReportData);
            fixturesUtility.Parameter_Section_Name__c='Plumbing';
            fixturesUtility.Parameter_Name__c='Fixtures - Utility And Water Coolers';
            fixturesUtility.Default_Value__c = String.ValueOf(projectReportData.PLPData.Fixtures_Utility_Water_Coolers__c);
            fixturesUtility.User_Value__c = String.ValueOf(projectReportData.PLPData.Fixtures_Utility_Water_Coolers__c);
            fixturesUtility.Unit__c = 'EA';
            ncmtParametersToInsert.add(fixturesUtility);
            //HVAC
            NCMT_Parameters__c heatingLoad =  setDefaultNCMTParamater(projectReportData);
            heatingLoad.Parameter_Section_Name__c='HVAC';
            heatingLoad.Parameter_Name__c='Heating Load';
            heatingLoad.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Heating_Load_Mbtuh__c);
            heatingLoad.User_Value__c = String.ValueOf(projectReportData.PLPData.HVAC_Heating_Load_Mbtu__c);
            heatingLoad.Unit__c = 'Mbtuh';
            ncmtParametersToInsert.add(heatingLoad);
            NCMT_Parameters__c coolingLoad =  setDefaultNCMTParamater(projectReportData);
            coolingLoad.Parameter_Section_Name__c='HVAC';
            coolingLoad.Parameter_Name__c='Cooling Load';
            coolingLoad.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Cooling_Load__c);
            coolingLoad.User_Value__c = String.ValueOf(projectReportData.PLPData.HVAC_Cooling_Load_Tons__c);
            coolingLoad.Unit__c = 'TON';
            ncmtParametersToInsert.add(coolingLoad);
            NCMT_Parameters__c AHULoad =  setDefaultNCMTParamater(projectReportData);
            AHULoad.Parameter_Section_Name__c='HVAC';
            AHULoad.Parameter_Name__c='AHU Load';
            AHULoad.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_AHU_Load__c);
            AHULoad.User_Value__c = String.ValueOf(projectReportData.PLPData.HVAC_Air_Handling_Capacity_CFM__c);
            AHULoad.Unit__c = 'CFM';
            ncmtParametersToInsert.add(AHULoad);
            //Electrical
            NCMT_Parameters__c elecLoad =  setDefaultNCMTParamater(projectReportData);
            elecLoad.Parameter_Section_Name__c='Electrical';
            elecLoad.Parameter_Name__c='Electrical Load - Primary';
            elecLoad.Default_Value__c = String.ValueOf(projectReportData.PLPData.Default_Electrical_Load_Primary_kW__c);
            elecLoad.User_Value__c = String.ValueOf(projectReportData.PLPData.Electrical_Load_kW__c);
            elecLoad.Unit__c = 'kW';
            elecLoad.Override_Comments_Label__c ='MEP';
            elecLoad.Override_Comments__c = projectReportData.PLPData.MEP_Override_Comments__c;
            ncmtParametersToInsert.add(elecLoad);
            NCMT_Parameters__c panelboards =  setDefaultNCMTParamater(projectReportData);
            panelboards.Parameter_Section_Name__c='Electrical';
            panelboards.Parameter_Name__c='Panelboards';
            panelboards.Default_Value__c = String.ValueOf(projectReportData.PLPData.Panelboards__c);
            panelboards.Unit__c = 'EA';
            ncmtParametersToInsert.add(panelboards);
            NCMT_Parameters__c lightfix =  setDefaultNCMTParamater(projectReportData);
            lightfix.Parameter_Section_Name__c='Electrical';
            lightfix.Parameter_Name__c='Light Fixtures';
            lightfix.Default_Value__c = String.ValueOf(projectReportData.hpData.Light_Fixtures__c);
            lightfix.Unit__c = 'EA';
            ncmtParametersToInsert.add(lightfix);
        	//system.debug(':::bldgmassData:::'+projectReportData.bldgmassData);
            //system.debug(':::bldgmassData-projectid:::'+projectReportData.PLPData.NCMT_Project__r.id);
            //system.debug(':::bldgmassData-:::'+projectReportData);
            for(NCMT_Building_Massing_By_Floor__c bldg : projectReportData.bldgmassData){
                NCMT_Parameters__c bldgmassflr =  setDefaultNCMTParamater(projectReportData);
                bldgmassflr.Parameter_Section_Name__c='Footprint Areas';
                bldgmassflr.Parameter_Name__c=  String.ValueOf(bldg.Building_Massing_Area__c);
                bldgmassflr.Default_Value__c = String.ValueOf(bldg.Default_Area_SF__c);
                bldgmassflr.User_Value__c = String.ValueOf(bldg.Use_Area_SF__c);
                bldgmassflr.Unit__c = 'SF';
                
                ncmtParametersToInsert.add(bldgmassflr);
            }
        }
        if(ncmtParametersToInsert.size() > 0){
           list<NCMT_Parameters__c> ncmtParametersToDelete = [select id from NCMT_Parameters__c where Project_ID__c In : reportDataMap.keySet()];
            delete ncmtParametersToDelete;
           insert ncmtParametersToInsert; 
        }
    }
    public static NCMT_Parameters__c setDefaultNCMTParamater(reportData projectReportData){
		NCMT_Parameters__c ncmtParameter =  new NCMT_Parameters__c();
        ncmtParameter.Project_ID__c=projectReportData.PLPData.NCMT_Project__r.id;
        ncmtParameter.Project_Name__c=projectReportData.PLPData.NCMT_Project__r.Name;
        return ncmtParameter;
    }
    private static Map<Id,reportData> getProjectData( List<Id> projectIds){
        Map<Id,reportData> responseMap = new Map<Id,reportData>();
        Map<Id,Project_Level_Parameter__c> PLPDataMap = new Map<Id,Project_Level_Parameter__c>();
        Map<Id,List<NCMT_Building_Massing_By_Floor__c>> bldgmassDataMap = new Map<Id,List<NCMT_Building_Massing_By_Floor__c>>();
        Map<Id,Site_Information__c> siteDataMap = new Map<Id,Site_Information__c>();
        Map<Id,NCMT_Housing_Plan_Summary__c> hpDataMap = new Map<Id,NCMT_Housing_Plan_Summary__c>();
        Map<Id,NCMT_Core_Shell_Cost_Detail__c> csdListMap = new Map<Id,NCMT_Core_Shell_Cost_Detail__c>();
        Map<Id,String> foundationsMap = new Map<Id,String>();
        string strNCMTID;
        
        Set<Id> strNCMTIDs = new Set<Id>();
        for(String projectId : projectIds){
            strNCMTID = projectId.substring(0,projectId.length()-3);   
            strNCMTIDs.add(strNCMTID);
        }
        
        
        for(Project_Level_Parameter__c projectLevelParameter : [select id, Name,Above_Ground__c,Below_Ground__c,Default_Above_Ground__c,Default_Below_Ground__c,Default_Foot_Print_Area__c,Foot_Print_Area__c,
                                                                Basement_SF__c,Default_Basement_SF__c,Default_Elevated_Floor_Area_SF__c,Elevated_Floor_Area_SF__c,Default_Average_Story_Height__c,Average_Story_Height__c,
                                                                Basement_Story_Height__c,Default_Basement_Story_Height__c,Structural_Frame__c,Average_Typical_Bay_Area__c,Dead_Load__c,Default_Dead_Load__c,Live_Load__c,
                                                                Default_Live_Load__c,Default_Cladding_Type__c,Cladding_Type__c,Default_Cladding_Quality__c,Cladding_Quality__c,Cladding_Skin_Ratio__c,Default_Skin_Ratio__c,
                                                                Default_Glazing_Ratio__c,Glazing_Ratio_of_above_grade_skin__c,Cladding_Skin_Ratio_SF__c,Default_Total_Wall_Area_SF__c,Cladding_Retaining_Wall_SF__c,Default_Retaining_Wall_SF__c,
                                                                Finished_Opaque_Wall_SF__c,Default_Finished_Wall_Area_SF__c,Finished_Wall_Area_SF__c,Default_Glazing_SF__c,Glazing_Ratio_SF__c,Default_Finished_Opaque_Wall_SF__c,
                                                                Total_Roof_Area_SF__c,Upper_Roof_SF__c,Basement_Roof_SF__c,Sloped_Roof_SF__c,Green_Roof_SF__c,Flat_Roof_SF__c,Roofing_Skylights__c,Default_Roofing_Skylights__c,
                                                                Soil_Bearing_Strength__c,Site_Access__c,Site_Access_Cost_Impact__c,Site_Remoteness__c,SiteRemoteness_Cost_Impact__c,Other_Special_Condition_Specify__c,Cost_Impact_Percent__c,
                                                                Freeze_Depth_Footing_Depth_BG__c,Default_Freeze_Depth_Footing_Depth__c,Default_Water_Table_Depth__c,Water_Table_Depth__c,Excavation_Percent_Shored_BG__c,
                                                                Excavation_Percentage_Shored_BG__c,Int_Const_Core_Shell_Partition_ratio__c,Default_Core_Shell_Partition_Ratio__c,Default_Stairs_Flight__c,Use_Stairs_Flight__c,
                                                                Def_Vertical_Conveyance_Elevators_Stops__c,Vertical_Conveyance_Escalators_PR__c,HVAC_Heating_Load_Mbtu__c,Default_Heating_Load_Mbtuh__c,HVAC_Cooling_Load_Tons__c,
                                                                Default_Cooling_Load__c,HVAC_Air_Handling_Capacity_CFM__c,Default_AHU_Load__c,Electrical_Load_kW__c,Number_of_Stops__c,Default_Electrical_Load_Primary_kW__c,Panelboards__c,
                                                                Fixtures_Utility_Water_Coolers__c,Default_Fixtures_Public_Restrooms__c,Use_Fixtures_Public_Restrooms__c,Cladding_Override_Comments__c,Interior_Override_Comments__c,Massing_Override_Comments__c,
                                                                MEP_Override_Comments__c,Structure_Override_Comments__c,Skin_System_Override_Comments__c,Roof_System_Override_Comments__c,Vertical_Transportation_Override_Comment__c,
                                                                NCMT_Project__r.id, NCMT_Project__r.Name,NCMT_Project__r.Total_GSF__c, NCMT_Project__r.Calculated_Site_Area__c,NCMT_Project__r.Override_Calculated_Site_Area__c,Roofing_Override_Comments__c                              
                                                                from Project_Level_Parameter__c  
                                                                where  NCMT_Project__c IN : projectIds]){
                                                                    PLPDataMap.put(projectLevelParameter.NCMT_Project__c,projectLevelParameter);
                                                                    
                                                                    
                                                                }
        
        for(NCMT_Building_Massing_By_Floor__c ncmtBuildingMassingByFloor : [select id, Name,Building_Massing_Area__c,Default_Area_SF__c,
                                                                            Default_Skylights_SF__c,Use_Area_SF__c,NCMT_Project_ID__c 
                                                                            from NCMT_Building_Massing_By_Floor__c
                                                                            where  NCMT_Project_ID__c IN : projectIds]){
                                                                                if(bldgmassDataMap.containsKey(ncmtBuildingMassingByFloor.NCMT_Project_ID__c)){
                                                                                    bldgmassDataMap.get(ncmtBuildingMassingByFloor.NCMT_Project_ID__c).add(ncmtBuildingMassingByFloor);
                                                                                }
                                                                                else{
                                                                                    bldgmassDataMap.put(ncmtBuildingMassingByFloor.NCMT_Project_ID__c, new List<NCMT_Building_Massing_By_Floor__c>{ncmtBuildingMassingByFloor});
                                                                                }
                                                                            }
        
        for(Site_Information__c siteInformation : [select id, Name,Finished_Site__c,Project__c
                                                   from Site_Information__c
                                                   where  Project__c IN : projectIds]){
                                                       
                                                       siteDataMap.put(siteInformation.Project__c,siteInformation);
                                                   }
        
        for(NCMT_Housing_Plan_Summary__c ncmtHousingPlanSummary : [select id, Name,Light_Fixtures__c,Project__c
                                                                   from NCMT_Housing_Plan_Summary__c
                                                                   where  Project__c IN : projectIds]){
                                                                       hpDataMap.put(ncmtHousingPlanSummary.Project__c,ncmtHousingPlanSummary);
                                                                       
                                                                   }
        
        for(NCMT_Core_Shell_Cost_Detail__c ncmtCoreShellCostDetail : [select id, Name,Total_Cost__c,NCMT_Project_ID__c 
                                                                      from NCMT_Core_Shell_Cost_Detail__c
                                                                      where  (NCMT_Project_ID__c IN :projectIds OR NCMT_Project_ID__c =:strNCMTID)
                                                                      and Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c IN ('CC19')]){
                                                                          csdListMap.put(ncmtCoreShellCostDetail.NCMT_Project_ID__c,ncmtCoreShellCostDetail);
                                                                          
                                                                      }
        
        
        
        for(Id projectId : projectIds){
            //system.debug(':::projectId:::'+projectId);
            reportData response = new reportData();
            response.PLPData= PLPDataMap.get(projectId);
            response.bldgmassData = bldgmassDataMap.get(projectId);
            response.siteData = siteDataMap.get(projectId);
            response.hpData = hpDataMap.get(projectId);
            response.coreShellData = csdListMap.get(projectId);
            if(response.coreShellData.Total_Cost__c > 0){
                response.foundations = 'Special';
            }else{
                response.foundations = 'Spread';
            }
            //system.debug('::responseMap:::'+responseMap.keySet());
            responseMap.put(projectId,response);
        }
        return responseMap;
        
    }
    
    
    
    public class reportData{
        @AuraEnabled public NCMT_Project__c ProjectDetails{get;set;}
        @AuraEnabled public Project_Level_Parameter__c PLPData{get;set;}
        @AuraEnabled public Site_Information__c siteData{get;set;}
        @AuraEnabled public NCMT_Housing_Plan_Summary__c hpData{get;set;}
        @AuraEnabled public NCMT_Core_Shell_Cost_Detail__c coreShellData{get;set;}
        @auraenabled public string Reviewed_By{get;set;}
        @auraenabled public string Approved_By{get;set;}
        @auraenabled public string foundations{get;set;}
        @AuraEnabled public List<NCMT_Building_Massing_By_Floor__c> bldgmassData{get;set;} 
        public reportData(){
            this.Reviewed_By ='';
            this.Approved_By ='';
            this.foundations='';
            this.ProjectDetails=new NCMT_Project__c();
            this.PLPData=new Project_Level_Parameter__c();
            this.siteData=new Site_Information__c();
            this.hpData=new NCMT_Housing_Plan_Summary__c();
            this.coreShellData=new NCMT_Core_Shell_Cost_Detail__c();
            this.bldgmassData=new List<NCMT_Building_Massing_By_Floor__c>();
        }
    }
    
}