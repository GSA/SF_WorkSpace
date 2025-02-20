public with sharing class NCMT_GenerateProjectDetailsCoreShellPG {
	
    public void GenerateCoreShellDataPG(ID ProjectID, String strProjectType){
        String  strSOQL;
        string  strColumnToPick = 'Parking_Space_Unit_Cost__c';
        Decimal ItemSqFt = 0.0;
        
        Set<string> setAssignCustom2 = new Set <string> {'CC341'};
        Set<string> setAssignCustom3 = new Set <string> {'CC295'};
        Set<string> setAssignCustom5 = new Set <string> {'CC21','CC23','CC377','CC378'};
        Set<string> setAssignCustom11 = new Set <string> {'CC170'};
        Set<string> setAssignCustom12 = new Set <string> {'CC185','CC186','CC187','CC188'};
        Set<string> setAssignCustom16 = new Set <string> {'CC225','CC226','CC228'};
        Set<string> setAssignCustom17 = new Set <string> {'CC227'};
        Set<string> setAssignCustom18 = new Set <string> {'CC266'};
        Set<string> setAssignCustom21 = new Set <string> {'CC164'};
        Set<string> setAssignCustom22 = new Set <string> {'CC165'};
        Set<string> setAssignCustom23 = new Set <string> {'CC166'};
        Set<string> setAssignCustom26 = new Set <string> {'CC212'};
        Set<string> setAssignCustom32 = new Set <string> {'CC180'};
        Set<string> setAssignCustom34 = new Set <string> {'CC207'};
        Set<string> setAssignCustom37 = new Set <string> {'CC289'};
        Set<string> setAssignCustom38 = new Set <string> {'CC290'};
        Set<string> setAssignCustom40 = new Set <string> {'CC292'};
        Set<string> setAssignCustom42 = new Set <string> {'CC335','CC336','CC339'};
        Set<string> setAssignCustom43 = new Set <string> {'CC337'};
        Set<string> setAssignCustom46 = new Set <string> {'CC340'};
        Set<string> setAssignCustom54 = new Set <string> {'CC30','CC32'};
        Set<string> setAssignCustom55 = new Set <string> {'CC34','CC38','CC39'};
        Set<string> setAssignCustom56 = new Set <string> {'CC35'};
        Set<string> setAssignCustom57 = new Set <string> {'CC36'};
        Set<string> setAssignCustom58 = new Set <string> {'CC37'};
        Set<string> setAssignCustom60 = new Set <string> {'CC208'};
        Set<string> setAssignCustom61 = new Set <string> {'CC33'};
        Set<string> setAssignCustom62 = new Set <string> {'CC40'};
        Set<string> setAssignCustom63 = new Set <string> {'CC20'};
        Set<string> setAssignCustom64 = new Set <string> {'CC69'};
        Set<string> setAssignCustom65 = new Set <string> {'CC70'};
        Set<string> setAssignCustom66 = new Set <string> {'CC63'};
        Set<string> setAssignCustom67 = new Set <string> {'CC64'};
        Set<string> setAssignCustom68 = new Set <string> {'CC66'};
        Set<string> setAssignCustom69 = new Set <string> {'CC65'};
        Set<string> setAssignCustom72 = new Set <string> {'CC217','CC234','CC255','CC346','CC357'};
        Set<string> setAssignCustom73 = new Set <string> {'CC244'};
        Set<string> setAssignCustom74 = new Set <string> {'CC218','CC235','CC256','CC347','CC358'};
        Set<string> setAssignCustom75 = new Set <string> {'CC245'};
        Set<string> setAssignCustom76 = new Set <string> {'CC219','CC236','CC257','CC359'};
        Set<string> setAssignCustom77 = new Set <string> {'CC246'};
        Set<string> setAssignCustom78 = new Set <string> {'CC223','CC239','CC260','CC351','CC362'};
        Set<string> setAssignCustom79 = new Set <string> {'CC249'};
        Set<string> setAssignCustom80 = new Set <string> {'CC224','CC240','CC261','CC352','CC363'};
        Set<string> setAssignCustom81 = new Set <string> {'CC250'};
        Set<string> setAssignCustom82 = new Set <string> {'CC237','CC258','CC360'};
        Set<string> setAssignCustom83 = new Set <string> {'CC247'};
        Set<string> setAssignCustom84 = new Set <string> {'CC241','CC262','CC353','CC364'};
        Set<string> setAssignCustom85 = new Set <string> {'CC251'};
        Set<string> setAssignCustom86 = new Set <string> {'CC384'};
        Set<string> setAssignCustom87 = new Set <string> {'CC385'};
        Set<string> setAssignCustom88 = new Set <string> {'CC386'};
        Set<string> setAssignCustom89 = new Set <string> {'CC387'};
        Set<string> setAssignCustom90 = new Set <string> {'CC303','CC306'};
        Set<string> setAssignCustom91 = new Set <string> {'CC301'};
        Set<string> setAssignCustom92 = new Set <string> {'CC299'};
        Set<string> setAssignCustom93 = new Set <string> {'CC329','CC332'};
        Set<string> setAssignCustom94 = new Set <string> {'CC328','CC330'};
        Set<string> setAssignCustom95 = new Set <string> {'CC263'};
        Set<string> setAssignCustom96 = new Set <string> {'CC354'};
        Set<string> setAssignCustom97 = new Set <string> {'CC178'};
        Set<string> setAssignCustom98 = new Set <string> {'CC179','CC209'};
        Set<string> setAssignCustom99 = new Set <string> {'CC181'};
        Set<string> setAssignCustom100 = new Set <string> {'CC325'};
        Set<string> setAssignCustom101 = new Set <string> {'CC326'};
        Set<string> setAssignCustom102 = new Set <string> {'CC327'};
        Set<string> setAssignCustom103 = new Set <string> {'CC331'};
        Set<string> setAssignCustom104 = new Set <string> {'CC308','CC215','CC238','CC259','CC350','CC361'};
        Set<string> setAssignCustom105 = new Set <string> {'CC248'};
        Set<string> setAssignCustom106 = new Set <string> {'CC304','CC307','CC365'};
        Set<string> setAssignCustom107 = new Set <string> {'CC300'};
        Set<string> setAssignCustom108 = new Set <string> {'CC302'};
        Set<string> setAssignCustom109 = new Set <string> {'CC49'};
        Set<string> setAssignCustom110 = new Set <string> {'CC50'};
        Set<string> setAssignCustom111 = new Set <string> {'CC52'};
        Set<string> setAssignCustom112 = new Set <string> {'CC51'};
        Set<string> setAssignCustom113 = new Set <string> {'CC44','CC85','CC131'};
        Set<string> setAssignCustom114 = new Set <string> {'CC10'};
        Set<string> setAssignCustom115 = new Set <string> {'CC1','CC9'};
        Set<string> setAssignCustom116 = new Set <string> {'CC3'};
        Set<string> setAssignCustom117 = new Set <string> {'CC5'};
        Set<string> setAssignCustom118 = new Set <string> {'CC8'};
        Set<string> setAssignCustom119 = new Set <string> {'CC2'};
        Set<string> setAssignCustom120 = new Set <string> {'CC4'};
        Set<string> setAssignCustom121 = new Set <string> {'CC6'};
        Set<string> setAssignCustom122 = new Set <string> {'CC7'};
        Set<string> setAssignCustom123 = new Set <string> {'CC12','CC13'};
        Set<string> setAssignCustom124 = new Set <string> {'CC16'};
        Set<string> setAssignCustom125 = new Set <string> {'CC11'};
        Set<string> setAssignCustom126 = new Set <string> {'CC14'};
        Set<string> setAssignCustom127 = new Set <string> {'CC15'};
        Set<string> setAssignCustom128 = new Set <string> {'CC19'};
        Set<string> setAssignCustom129 = new Set <string> {'CC22'};
        Set<string> setAssignCustom130 = new Set <string> {'CC24'};
        Set<string> setAssignCustom131 = new Set <string> {'CC25'};
        Set<string> setAssignCustom132 = new Set <string> {'CC28'};
        Set<string> setAssignCustom133 = new Set <string> {'CC29','CC31'};
        Set<string> setAssignCustom134 = new Set <string> {'CC45','CC86','CC119'};
        Set<string> setAssignCustom135 = new Set <string> {'CC46'};
        Set<string> setAssignCustom136 = new Set <string> {'CC48'};
        Set<string> setAssignCustom137 = new Set <string> {'CC47'};
        Set<string> setAssignCustom138 = new Set <string> {'CC53'};
        Set<string> setAssignCustom139 = new Set <string> {'CC54'};
        Set<string> setAssignCustom140 = new Set <string> {'CC56'};
        Set<string> setAssignCustom141 = new Set <string> {'CC55'};
        Set<string> setAssignCustom142 = new Set <string> {'CC59'};
        Set<string> setAssignCustom143 = new Set <string> {'CC60'};
        Set<string> setAssignCustom144 = new Set <string> {'CC73'};
        Set<string> setAssignCustom145 = new Set <string> {'CC76'};
        Set<string> setAssignCustom146 = new Set <string> {'CC77'};
        Set<string> setAssignCustom147 = new Set <string> {'CC79'};
        Set<string> setAssignCustom148 = new Set <string> {'CC78'};
        Set<string> setAssignCustom149 = new Set <string> {'CC82'};
        Set<string> setAssignCustom150 = new Set <string> {'CC83'};
        Set<string> setAssignCustom151 = new Set <string> {'CC87','CC120'};
        Set<string> setAssignCustom152 = new Set <string> {'CC88'};
        Set<string> setAssignCustom153 = new Set <string> {'CC89'};
        Set<string> setAssignCustom154 = new Set <string> {'CC90','CC121','CC134'};
        Set<string> setAssignCustom155 = new Set <string> {'CC91'};
        Set<string> setAssignCustom156 = new Set <string> {'CC96','CC140'};
        Set<string> setAssignCustom157 = new Set <string> {'CC98','CC142'};
        Set<string> setAssignCustom158 = new Set <string> {'CC99'};
        Set<string> setAssignCustom159 = new Set <string> {'CC104','CC148'};
        Set<string> setAssignCustom160 = new Set <string> {'CC106'};
        Set<string> setAssignCustom161 = new Set <string> {'CC109','CC153'};
        Set<string> setAssignCustom162 = new Set <string> {'CC110'};
        Set<string> setAssignCustom163 = new Set <string> {'CC115','CC159'};
        Set<string> setAssignCustom164 = new Set <string> {'CC118'};
        Set<string> setAssignCustom165 = new Set <string> {'CC127','CC129'};
        Set<string> setAssignCustom166 = new Set <string> {'CC128'};
        Set<string> setAssignCustom167 = new Set <string> {'CC135'};
        Set<string> setAssignCustom168 = new Set <string> {'CC143'};
        Set<string> setAssignCustom169 = new Set <string> {'CC150'};
        Set<string> setAssignCustom170 = new Set <string> {'CC154'};
        Set<string> setAssignCustom171 = new Set <string> {'CC169'};
        Set<string> setAssignCustom172 = new Set <string> {'CC269','CC271'};
        Set<string> setAssignCustom173 = new Set <string> {'CC270'};
        Set<string> setAssignCustom174 = new Set <string> {'CC277'};
        Set<string> setAssignCustom175 = new Set <string> {'CC278','CC279','CC319'};
        Set<string> setAssignCustom176 = new Set <string> {'CC280','CC286','CC320'};
        Set<string> setAssignCustom177 = new Set <string> {'CC282'};
        Set<string> setAssignCustom178 = new Set <string> {'CC284'};
        Set<string> setAssignCustom179 = new Set <string> {'CC288'};
        Set<string> setAssignCustom180 = new Set <string> {'CC310'};
        Set<string> setAssignCustom181 = new Set <string> {'CC311','CC312'};
        Set<string> setAssignCustom182 = new Set <string> {'CC313','CC314'};
        Set<string> setAssignCustom183 = new Set <string> {'CC366'};
        Set<string> setAssignCustom184 = new Set <string> {'CC296'};
        Set<string> setAssignCustom185 = new Set <string> {'CC297'};
        Set<string> setAssignCustom186 = new Set <string> {'CC315'};
        Set<string> setAssignCustom187 = new Set <string> {'CC316'};
        Set<string> setAssignCustom188 = new Set <string> {'CC317'};
        Set<string> setAssignCustom189 = new Set <string> {'CC318'};
        Set<string> setAssignCustom190 = new Set <string> {'CC324'};
        Set<string> setAssignCustom191 = new Set <string> {'CC344'};
        Set<string> setAssignCustom192 = new Set <string> {'CC355'};
        Set<string> setAssignCustom193 = new Set <string> {'CC252'};
        //for parking space size
        Set<string> setAssignCustom194 = new Set <string> {'CC172','CC371','CC373','CC380','CC381','CC382','CC383'};
        Set<string> setAssignCustom195 = new Set <string> {'CC117','CC215','CC222','CC238','CC259','CC274','CC333','CC343','CC350','CC361','CC367','CC368','CC369','CC370'};
        Set<string> setAssignCustom196 = new Set <string> {'CC57','CC58','CC61','CC92','CC93','CC95'};
        Set<string> setAssignCustom197 = new Set <string> {'CC189','CC190','CC191','CC192'};
        Set<string> setAssignCustom198 = new Set <string> {'CC183'};
        Set<string> setAssignCustom199 = new Set <string> {'CC44'};
        Set<string> setAssignCustom200 = new Set <string> {'CC45','CC86'};
        Set<string> setAssignCustom201 = new Set <string> {'CC62','CC67','CC68','CC71','CC97','CC100','CC101','CC103'};
        Set<string> setAssignCustom202 = new Set <string> {'CC72','CC74','CC105','CC107'};
        Set<string> setAssignCustom203 = new Set <string> {'CC75','CC80','CC81','CC84','CC108','CC111','CC112','CC114'};
        Set<string> setAssignCustom204 = new Set <string> {'CC104'};
        Set<string> setAssignCustom205 = new Set <string> {'CC109'};
        Set<string> setAssignCustom206 = new Set <string> {'CC115'};
        Set<string> setAssignCustom207 = new Set <string> {'CC116'};
        Set<string> setAssignCustom208 = new Set <string> {'CC85'};
        Set<string> setAssignCustom209 = new Set <string> {'CC87'};
        Set<string> setAssignCustom210 = new Set <string> {'CC90'};
        Set<string> setAssignCustom211 = new Set <string> {'CC96'};
        Set<string> setAssignCustom212 = new Set <string> {'CC98'};
        Set<string> setAssignCustom213 = new Set <string> {'CC162','CC163','CC167','CC168'};
        Set<string> setAssignCustom214 = new Set <string> {'CC173'};
        Set<string> setAssignCustom215 = new Set <string> {'CC175'};
        Set<string> setAssignCustom216 = new Set <string> {'CC202'};
        Set<string> setAssignCustom217 = new Set <string> {'CC264'};
        Set<string> setAssignCustom218 = new Set <string> {'CC291','CC303','CC305','CC308'};
        Set<string> setAssignCustom219 = new Set <string> {'CC309'};
        Set<string> setAssignCustom220 = new Set <string> {'CC384','CC386'};
        Set<string> setAssignCustom221 = new Set <string> {'CC-00450'};
        Set<string> setAssignCustom222 = new Set <string> {'CC-00451'};
        
        integer btypenum =0;
		ID PLPID;
		string structuralFrame;
		decimal dblGrossSqFt = 0;
		decimal powerrevolvingdoors = 0;
		decimal mainentrydoors = 0;
		decimal BuildingPerimeter = 0;
		decimal AreaColumnCount = 0;
		decimal Add50percentofperimeter = 0;
		decimal totalcolumncount = 0;
		decimal averagecolumnarea = 0;
		decimal Weightperfooting = 0;
		decimal Soilcapacity = 0;
		decimal areaofcolumnbase = 0;
		decimal squaredimension = 0;
		decimal depth = 0;
		decimal Overexcavateforlayback = 0;
		decimal OverexcavationforFtgdepth = 0;
		decimal Exceedingspreads = 0;
		decimal piledemand = 0;
		decimal typicalpilelength = 0;
		decimal Overexcavateforlayback1 = 0;
		decimal OverexcavationforFtgdepth1 = 0;
		decimal dblSumDefault_Area_SF;
		integer totalcolumnsareaanalysis = 0;
		string  ProjectRecordTypeName;
		
		Map<ID,Schema.RecordTypeInfo> rt_Map = NCMT_Project__c.sObjectType.getDescribe().getRecordTypeInfosById();
		//ProjectRecordTypeName = rt_map.get(strProjectType).getName();
		ProjectRecordTypeName = strProjectType;
		system.debug('ProjectRecordTypeName2=========='+ProjectRecordTypeName);
		
		List<Site_Information__c> ListSiteinfo = [Select Footprint_Area__c,Finished_Site__c 
		                                            From Site_Information__c 
		                                            Where Project__c = :ProjectID];
		                                            
		List<Project_Level_Parameter__c> ListPLP = [Select ID,Above_Ground__c,Below_Ground__c,Sloped_Roof_SF__c,Green_Roof_SF__c,Flat_Roof_SF__c,Number_of_Stops__c,Base_SF__c,Mid_SF__c,Top_SF__c,
		                                                   Basement_Roof_SF__c,Window_Percentage_SF__c,Curtain_Wall_Percentage_SF__c,Stair_Analysis_Total_Flights__c,Addnl_Primary_Circulation_Stair_Flights__c,
		                                                   Atrium_Phantom_Floors__c,Roofing_Skylights_SF__c,Core_Shell_Partition_LF__c,Average_Story_Height__c,HVAC_Heating_Load_Mbtu__c,HVAC_Cooling_Load_Tons__c,
		                                                   HVAC_Air_Handling_Capacity_CFM__c,Electrical_Load_kW__c,Vertical_Conveyance_Escalators_PR__c,Plumbing_Fixtures_EA__c,Upper_Roof_SF__c,Cladding_Retaining_Wall_SF__c,
		                                                   Total_Roof_Area_SF__c,Atrium_Area_SF__c,Excavation_Percent_Shored_BG__c,Basement_Story_Height__c,Default_Water_Table_Depth__c,Average_Typical_Bay_Area__c,
		                                                   Cladding_Skin_Ratio__c,Typical_Bay_Size_A__c,Typical_Bay_Size_B__c,Dead_Load__c,Live_Load__c,Soil_Bearing_Strength__c,Cladding_Skin_Ratio_SF__c,
		                                                   Default_Freeze_Depth_Footing_Depth__c,Foot_Print_Area__c,Freeze_Depth_Footing_Depth__c,Water_Table_Depth__c,Excavation_Percentage_Shored__c,
		                                                   Finished_Wall_Area_SF__c, Structural_Frame__c
													  From Project_Level_Parameter__c 
													 Where NCMT_Project__c = :ProjectID];
        For (Project_Level_Parameter__c objplp: ListPLP) {
                 PLPID = objplp.ID;
                 structuralFrame = objplp.Structural_Frame__c;
        }													 
		//system.debug('plp list ======'+listplp);										 
		List<NCMT_Housing_Plan_Summary__c> ListHP = [Select Ground_floor_circulation__c,Atrium_Ground_floor_plan_area__c,Main_Lobby__c,Elevator_lobbies__c,Other_circulation__c,Mechanical_Electrical_IT__c,Loading_dock_Recycling_Trash__c,
		                                            		Restrooms__c,Stair_shafts__c,Conditioned_Core_Area__c,Total_USF__c,Enclosed_Parking__c,Total_GSF__c 
		                                               From NCMT_Housing_Plan_Summary__c 
		                                      		   Where Project__c = :ProjectID];
        
        NCMT_Project__c NCMTRec = [Select ID, Building_Height_Parameter__r.Pile_Y_N__c,Building_Height_Parameter__r.Col_fmk__c,Building_Height_Parameter__r.Col_C_S__c,Building_Height_Parameter__r.SW_thickness__c,
        								  Building_Height_Parameter__r.Slab_Thickness__c,Building_Height_Parameter__r.Beam_fmk__c,Building_Height_Parameter__r.Beam_C_S__c,Building_Height_Parameter__r.Columns__c,
        								  Building_Height_Parameter__r.Bracing__c,Building_Height_Parameter__r.Horiz_Steel__c,Building_Height_Parameter__r.Steel_FP__c,Building_Height_Parameter__r.Deck_FP__c,
        								  Gross_Area_w_o_parking_BGSF__c,Parking_Garage_Gross_Area_SF__c,below_grade__c,At_and_above_grade__c,Below_Grade_Structure__c,High__c,Number_of_Spaces__c,
        								  Building_Quality__c, Utilitarian__c, Medium__c
                                   From NCMT_Project__c
                                   Where ID = :ProjectID];
                                   
        AggregateResult[] arSumDefaultAreaSF = [SELECT SUM (Default_Area_SF__c ) SumDefaultAreaSF
									 			  FROM NCMT_Building_Massing_By_Floor__c 
									 			 WHERE Proj_Level_Parameter__c = :PLPID
									   			   AND Building_Massing_Area__c in ('Basement2 SF','Basement1 SF') ];   
									   			   
		For (AggregateResult ar : arSumDefaultAreaSF) {
			dblSumDefault_Area_SF = (Decimal) ar.get('SumDefaultAreaSF');
	    }									   			                           
                                   		                                      	                                      
		List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c 
		                                                        From NCMT_Project_Cost_Summary__c 
		                                                       Where Project_Name__c = :ProjectID];
		                                                       
		Map<string, String> mapCostSummary = new Map<string, String>();
		for(NCMT_Project_Cost_Summary__c objItem : listCostSummary){
			mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
		}
		Map<string,Decimal> SLPMap = new Map<string,decimal>();	
		for(System_Level_Parameter__c SLP : [SELECT Name, Value__c FROM System_Level_Parameter__c where Category__c = 'Core Shell Cost Parameters' ]) {
			SLPMap.put(SLP.Name,SLP.Value__c);	
		}

				
		//string strFiscalYear = String.ValueOf([SELECT MAX(Fiscal_Year__c) FiscalYear FROM NCMT_Core_Shell_Cost_Parameter__c][0].get('FiscalYear'));
		string strFiscalYear = String.ValueOf([SELECT MAX(Cost_Parameter_Date_FY__c) FiscalYear FROM NCMT_Project__c Where ID = :ProjectID][0].get('FiscalYear'));
		List<NCMT_Core_Shell_Cost_Detail__c> objProjectCoreShellDetailRecords = New List<NCMT_Core_Shell_Cost_Detail__c>();
		 
		// Pick the Security Parameters that affect this project ...
		//if (strProjectType == Schema.SObjectType.NCMT_Project__c.getRecordTypeInfosByName().get('Parking Garage').getRecordTypeId()){
		if (strProjectType == 'Parking Garage') {
			strColumnToPick = 'Parking_Space_Unit_Cost__c';
		} 
		
		// Generate the security parameters for this project ...
		strSOQL =   'Select  ID, Cost_Type__c, Core_Shell_Cost_Parameter_Identifier__c, Cost_Sub_Type__c, ' + strColumnToPick + ' ' + 
			        'From    NCMT_Core_Shell_Cost_Parameter__c ' + ' ' +   
		            'Where   Fiscal_Year__c = :strFiscalYear ' +  
		            'And 	 ' + strColumnToPick + ' > 0 ' +   
		            'Order by Core_Shell_Cost_Parameter_Identifier__c ';
		List<NCMT_Core_Shell_Cost_Parameter__c> objCoreShellParameters = Database.query(strSOQL); 
		
		if (ProjectRecordTypeName == 'Parking Garage'){
		// for parking garage calculating values for foundations cost category
        	 BuildingPerimeter = (listplp[0].Foot_Print_Area__c * listplp[0].Cladding_Skin_Ratio__c / (listplp[0].Average_Story_Height__c + 3));
			 AreaColumnCount = (listplp[0].Foot_Print_Area__c / listplp[0].Average_Typical_Bay_Area__c);
			 Add50percentofperimeter = ((listplp[0].Foot_Print_Area__c * listplp[0].Cladding_Skin_Ratio__c/listplp[0].Average_Story_Height__c)/((listplp[0].Typical_Bay_Size_A__c + listplp[0].Typical_Bay_Size_B__c)/2))/2;
			 totalcolumncount = Math.Round(AreaColumnCount + Add50percentofperimeter);
			 averagecolumnarea = listplp[0].Foot_Print_Area__c / totalcolumncount ;
			 Weightperfooting = (ncmtRec.At_and_above_grade__c + ncmtRec.Below_grade__c)* averagecolumnarea * (listplp[0].Dead_Load__c+listplp[0].Live_Load__c) * 0.5;
			 Soilcapacity = listplp[0].Soil_Bearing_Strength__c;
			 areaofcolumnbase = Weightperfooting/Soilcapacity ;
			 squaredimension = Math.Min((Math.Sqrt(areaofcolumnbase)).setscale(1),10);
			 // for calculating depth
			  if(ncmtrec.below_grade__c > 0) {
			  	 depth = 3;
			  }
			  else{
			  	 depth = Math.Max(3, integer.valueof(listplp[0].Freeze_Depth_Footing_Depth__c));
			  }
			 Overexcavateforlayback = Math.Round((depth.pow(2)/2)*(6*squaredimension));
			 OverexcavationforFtgdepth = Overexcavateforlayback; 
			 // for calculating Exceedingspreads
			  if(squaredimension == 10){
			     Exceedingspreads = 1;
			  }
			  else{
			     Exceedingspreads = 0;
			  }
			 piledemand = (areaofcolumnbase - 100)* Soilcapacity; 
			 typicalpilelength = Math.Max(piledemand/4500,75) * Exceedingspreads; 
			 Overexcavateforlayback1 = Math.Round(Math.Round(BuildingPerimeter)*2*3*4*0.5/27);
			 //for calculating OverexcavationforFtgdepth1
			  if(ncmtrec.below_grade__c == 0){
			     OverexcavationforFtgdepth1 = Math.round(Math.round(BuildingPerimeter)*2*Math.max((integer.valueof(listplp[0].Freeze_Depth_Footing_Depth__c) - 4),0)/27);
			  }
			  else {
				 OverexcavationforFtgdepth1 = 0;
			  }
		}
		
		for(NCMT_Core_Shell_Cost_Parameter__c objRecord: objCoreShellParameters) {	
		if(strColumnToPick == 'Parking_Space_Unit_Cost__c'){
			if(objRecord.Cost_type__c == 'Superstructure' && objRecord.Cost_Sub_Type__c != structuralFrame) {
            	ItemSqFt = 0;
            }else if (setAssignCustom194.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
					ItemSqFt = 1.0;
			} else if (setAssignCustom195.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
					ItemSqFt = ncmtrec.Parking_Garage_Gross_Area_SF__c;
			} else if (setAssignCustom196.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
					ItemSqFt = ncmtrec.Parking_Garage_Gross_Area_SF__c - listplp[0].Foot_Print_Area__c;
			} else if (setAssignCustom197.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				ItemSqFt = 1000;	
			} else if (setAssignCustom11.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
					ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(ncmtrec.Parking_Garage_Gross_Area_SF__c/350,-1);
			} else if (setAssignCustom32.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
					ItemSqFt = Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c/50000) + 3;	
			} else if (setAssignCustom198.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				   if (ncmtrec.Parking_Garage_Gross_Area_SF__c < 50000){
						ItemSqFt = 0;
				   }	
				   else
				   {
				   	    ItemSqFt = 1;
				   }
			} else if (setAssignCustom105.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
					ItemSqFt = Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * 0.3);
			} else if (setAssignCustom192.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
					ItemSqFt = Math.Ceil(ncmtrec.Parking_Garage_Gross_Area_SF__c / 100000);
			} else if (setAssignCustom114.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.Round(BuildingPerimeter);					
			} else if (setAssignCustom115.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
					ItemSqFt = totalcolumncount;
			} else if (setAssignCustom116.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(totalcolumncount * Overexcavateforlayback/27,-2);	
			} else if (setAssignCustom117.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(totalcolumncount * OverexcavationforFtgdepth/27,-2);	
			} else if (setAssignCustom118.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(totalcolumncount * ((areaofcolumnbase * 3)+(OverexcavationforFtgdepth*0.33))/27,-2);
			} else if (setAssignCustom119.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(totalcolumncount * Overexcavateforlayback/27,-2) + NCMT_GenerateProjectDetails.roundofneg(totalcolumncount * OverexcavationforFtgdepth/27,-2) + NCMT_GenerateProjectDetails.roundofneg(totalcolumncount * ((areaofcolumnbase * 3)+(OverexcavationforFtgdepth*0.33))/27,-2);
			} else if (setAssignCustom120.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(totalcolumncount * OverexcavationforFtgdepth/27,-2) + NCMT_GenerateProjectDetails.roundofneg(totalcolumncount * ((areaofcolumnbase * 3)+(OverexcavationforFtgdepth*0.33))/27,-2);	
			} else if (setAssignCustom121.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.Round(totalcolumncount * 3 * 4 *squaredimension* 1.25);	
			} else if (setAssignCustom122.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(totalcolumncount * ((areaofcolumnbase * 3)+(OverexcavationforFtgdepth*0.33))/27,-2) * SLPMap.get('Fnd_Rebar');
			} else if (setAssignCustom123.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg((Overexcavateforlayback1+OverexcavationforFtgdepth1),-2);	
			} else if (setAssignCustom124.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(Math.Round(BuildingPerimeter)*4*2/27,-1);
			} else if (setAssignCustom125.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				     integer remexcav = NCMT_GenerateProjectDetails.roundofneg((Overexcavateforlayback1+OverexcavationforFtgdepth1),-2);
				     integer concplac = NCMT_GenerateProjectDetails.roundofneg(Math.Round(BuildingPerimeter)*4*2/27,-1);
				     ItemSqFt = remexcav + concplac ;
			} else if (setAssignCustom126.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				     ItemSqFt = Math.Round(BuildingPerimeter) * 2 * 3;
			} else if (setAssignCustom127.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				     ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(Math.Round(BuildingPerimeter) * 4 * 2 / 27,-1) * SLPMap.get('Foundation Rebar');	
			} else if (setAssignCustom128.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				   if(ncmtrec.Building_Height_Parameter__r.Pile_Y_N__c == True){
				     ItemSqFt = totalcolumncount * typicalpilelength;
				   }	  
				   else{
				  	 ItemSqFt = 0;
				   }
			} else if (setAssignCustom63.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				   if(listPLP[0].Water_Table_Depth__c < 6){
				  	 ItemSqFt = listplp[0].Foot_Print_Area__c; 
				   }
				   else{
				      ItemSqFt = 0; 		
				   }
			} else if (setAssignCustom5.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
					ItemSqFt = listplp[0].Foot_Print_Area__c;
			} else if (setAssignCustom129.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(listplp[0].Foot_Print_Area__c * (SLPMap.get('SOG_subbase')/12)/27,-1);
			} else if (setAssignCustom130.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = listplp[0].Foot_Print_Area__c * SLPMap.get('SOG_reinf');	
			} else if (setAssignCustom131.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(listplp[0].Foot_Print_Area__c * (SLPMap.get('SOG_thick')/12)/27,-1);
			} else if (setAssignCustom132.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = dblSumDefault_Area_SF;
			} else if (setAssignCustom133.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				try {
				    ItemSqFt = Math.round(dblSumDefault_Area_SF * (listplp[0].Average_Story_Height__c+2)/27);
				}
				catch (exception e){
					ItemSqFt = 0;
				}
			} else if (setAssignCustom54.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(listPLP[0].Cladding_Retaining_Wall_SF__c * (listPLP[0].Average_Story_Height__c + 2)*0.5/27,-2);	
			} else if (setAssignCustom61.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  ItemSqFt = listPLP[0].Cladding_Retaining_Wall_SF__c * integer.valueof(listPLP[0].Excavation_Percentage_Shored__c)/100;
			} else if (setAssignCustom55.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  ItemSqFt = listPLP[0].Cladding_Retaining_Wall_SF__c; 
			} else if (setAssignCustom56.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  ItemSqFt = listPLP[0].Cladding_Retaining_Wall_SF__c * 2;	
			} else if (setAssignCustom57.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(listPLP[0].Cladding_Retaining_Wall_SF__c * (SLPMap.get('Ret_wall_thick')/12) / 27,-1) * SLPMap.get('Ret_wall_rebar') ;	
			} else if (setAssignCustom58.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(listPLP[0].Cladding_Retaining_Wall_SF__c * (SLPMap.get('Ret_wall_thick')/12) / 27,-1);
			} else if (setAssignCustom62.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				   if(listPLP[0].Water_Table_Depth__c <((listPLP[0].Below_Ground__c*listPLP[0].Basement_Story_Height__c)+6)){
				  	 ItemSqFt = listplp[0].Foot_Print_Area__c; 
				   }
				   else{
				      ItemSqFt = 0; 		
				   }
			} else if (setAssignCustom199.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * SLPMap.get('Misc_steel'));
			} else if (setAssignCustom200.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.round(ncmtrec.Parking_Garage_Gross_Area_SF__c/averagecolumnarea) * listplp[0].Average_Story_Height__c;
			} else if (setAssignCustom135.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.round(ncmtrec.Parking_Garage_Gross_Area_SF__c/averagecolumnarea) * listplp[0].Average_Story_Height__c * ncmtrec.Building_Height_Parameter__r.Col_fmk__c;
			} else if (setAssignCustom136.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.round(Math.round(ncmtrec.Parking_Garage_Gross_Area_SF__c/averagecolumnarea) * listplp[0].Average_Story_Height__c * ncmtrec.Building_Height_Parameter__r.Col_C_S__c/27);
			} else if (setAssignCustom137.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.round(Math.round(ncmtrec.Parking_Garage_Gross_Area_SF__c/averagecolumnarea) * listplp[0].Average_Story_Height__c * ncmtrec.Building_Height_Parameter__r.Col_C_S__c/27) * ncmtrec.Building_Height_Parameter__r.Col_fmk__c;	
			} else if (setAssignCustom109.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * SLPMap.get('Shearwall_factor'));
			} else if (setAssignCustom110.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * SLPMap.get('Shearwall_factor')) * 2;
			} else if (setAssignCustom111.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg((Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * SLPMap.get('Shearwall_factor'))) * (ncmtrec.Building_Height_Parameter__r.SW_thickness__c/12)/27,-1);		
			} else if (setAssignCustom112.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg((Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * SLPMap.get('Shearwall_factor'))) * (ncmtrec.Building_Height_Parameter__r.SW_thickness__c/12)/27,-1) * SLPMap.get('Shearwall_reinf');
			} else if (setAssignCustom138.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.Round(((ncmtrec.Parking_Garage_Gross_Area_SF__c - listplp[0].Foot_Print_Area__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1);
			} else if (setAssignCustom139.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.Round(((ncmtrec.Parking_Garage_Gross_Area_SF__c - listplp[0].Foot_Print_Area__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1) * 6;
			} else if (setAssignCustom140.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.Round(((ncmtrec.Parking_Garage_Gross_Area_SF__c - listplp[0].Foot_Print_Area__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1 * 3/27);
			} else if (setAssignCustom141.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.Round(((ncmtrec.Parking_Garage_Gross_Area_SF__c - listplp[0].Foot_Print_Area__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1 * 3/27) * SLPMap.get('Beam_reinf');
			} else if (setAssignCustom142.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				ItemSqFt = (ncmtrec.Parking_Garage_Gross_Area_SF__c - listplp[0].Foot_Print_Area__c) * SLPMap.get('Slab_reinf');	
			} else if (setAssignCustom143.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				ItemSqFt = NCMT_GenerateProjectDetails.roundofneg((ncmtrec.Parking_Garage_Gross_Area_SF__c - listplp[0].Foot_Print_Area__c) * (ncmtrec.Building_Height_Parameter__r.Slab_Thickness__c/12)/27,-1);
			} else if (setAssignCustom201.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				   if (ncmtrec.Below_Grade_Structure__c == True){
						ItemSqFt = listPLP[0].Flat_Roof_SF__c;	
				   }
				   else{
				   	    ItemSqFt = 0;
				   }
			}else if (setAssignCustom66.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
				  		ItemSqFt = Math.Round((listPLP[0].Flat_Roof_SF__c/listPLP[0].Average_Typical_Bay_Area__c) * 2 * Math.sqrt(listPLP[0].Average_Typical_Bay_Area__c) * 1.1);
				  }
				   else{
				   	    ItemSqFt = 0;
				   }	
			}else if (setAssignCustom67.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
				  		ItemSqFt = Math.Round((listPLP[0].Flat_Roof_SF__c/listPLP[0].Average_Typical_Bay_Area__c) * 2 * Math.sqrt(listPLP[0].Average_Typical_Bay_Area__c) * 1.1 * 6);	
				  }
				  else{
				   	    ItemSqFt = 0;
				   }
			}else if (setAssignCustom68.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
				  		ItemSqFt = Math.Round((listPLP[0].Flat_Roof_SF__c/listPLP[0].Average_Typical_Bay_Area__c) * 2 * Math.sqrt(listPLP[0].Average_Typical_Bay_Area__c) * 1.1 * 3/27);
				  }	
				  else{
				   	    ItemSqFt = 0;
				   }
			}else if (setAssignCustom69.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
				  		ItemSqFt = Math.Round((listPLP[0].Flat_Roof_SF__c/listPLP[0].Average_Typical_Bay_Area__c) * 2 * Math.sqrt(listPLP[0].Average_Typical_Bay_Area__c) * 1.1 * 3/27) * SLPMap.get('Beam_reinf');
				  }	
				  else{
				   	    ItemSqFt = 0;
				  }	
			}else if (setAssignCustom64.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
				  		ItemSqFt = Math.Round(listPLP[0].Flat_Roof_SF__c *  SLPMap.get('Slab_reinf')) ;	
				  }	
				  else{
				   	    ItemSqFt = 0;
				  }	
			}else if (setAssignCustom65.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
				  		ItemSqFt = NCMT_GenerateProjectDetails.roundofneg(listPLP[0].Flat_Roof_SF__c * ((ncmtrec.Building_Height_Parameter__r.Slab_Thickness__c-1)/12)/27,-1) ;
				  }	
				  else{
				   	    ItemSqFt = 0;
				  }	
			}else if (setAssignCustom202.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){	
		    	ItemSqFt = listPLP[0].Sloped_Roof_SF__c; 
			}else if (setAssignCustom144.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				ItemSqFt = Math.Round(listPLP[0].Sloped_Roof_SF__c * 12/2000) ;	
			}else if (setAssignCustom203.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				ItemSqFt = (listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c);	
			}else if (setAssignCustom145.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round(((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1);	
			}else if (setAssignCustom146.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round(((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1) * 7;
			}else if (setAssignCustom147.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round(((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1 * 4/27);
			}else if (setAssignCustom148.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round(((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)/listplp[0].Average_Typical_Bay_Area__c)*2*(Math.sqrt(listplp[0].Average_Typical_Bay_Area__c))*1.1 * 4/27)* 400;
			}else if (setAssignCustom149.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = (listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c) * 10;	
			}else if (setAssignCustom150.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = NCMT_GenerateProjectDetails.roundofneg((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c) * (12/12)/27,-1);	
			}else if (setAssignCustom204.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
			    		ItemSqFt = listPLP[0].Flat_Roof_SF__c * ncmtrec.Building_Height_Parameter__r.Deck_FP__c;	
				  }
				  else{
				   	    ItemSqFt = 0;
				  }
			}else if (setAssignCustom160.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round(listPLP[0].Sloped_Roof_SF__c * SLPMap.get('Steel_sloprf')/2000);	
			}else if (setAssignCustom205.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)*ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c/2000);	
			}else if (setAssignCustom162.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round((listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)*ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c/2000) * ncmtrec.Building_Height_Parameter__r.Steel_FP__c * 120;
			}else if (setAssignCustom206.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = (listPLP[0].Green_Roof_SF__c + listPLP[0].Basement_Roof_SF__c)* ncmtrec.Building_Height_Parameter__r.Deck_FP__c;	
			}else if (setAssignCustom207.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round(Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * SLPMap.get('Misc_steel'))/2000) + Math.Round(listPLP[0].Sloped_Roof_SF__c * 12/2000);
			} else if (setAssignCustom208.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				    ItemSqFt = Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * 0);	
			}else if (setAssignCustom209.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * ncmtrec.Building_Height_Parameter__r.Columns__c/2000);
			}else if (setAssignCustom152.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * ncmtrec.Building_Height_Parameter__r.Bracing__c/2000);	
			}else if (setAssignCustom153.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = Math.Round(ncmtrec.Parking_Garage_Gross_Area_SF__c * ncmtrec.Building_Height_Parameter__r.Columns__c/2000) * ncmtrec.Building_Height_Parameter__r.Steel_FP__c * 120;	
			}else if (setAssignCustom210.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				ItemSqFt = Math.Round((ncmtrec.Parking_Garage_Gross_Area_SF__c) * ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c/2000);
			}else if (setAssignCustom155.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				ItemSqFt = Math.Round((ncmtrec.Parking_Garage_Gross_Area_SF__c) * ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c/2000)* ncmtrec.Building_Height_Parameter__r.Steel_FP__c * 120;
			}else if (setAssignCustom211.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				ItemSqFt = (ncmtrec.Parking_Garage_Gross_Area_SF__c - listplp[0].Foot_Print_Area__c)* ncmtrec.Building_Height_Parameter__r.Deck_FP__c;	
			}else if (setAssignCustom212.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
			    		ItemSqFt = Math.Round(listPLP[0].Flat_Roof_SF__c * (ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c-2)/2000);	
				  }
				  else{
				  	    ItemSqFt = 0;
				  }	
			}else if (setAssignCustom158.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
			    		ItemSqFt = Math.Round(listPLP[0].Flat_Roof_SF__c * (ncmtrec.Building_Height_Parameter__r.Horiz_Steel__c - 2)/2000) * ncmtrec.Building_Height_Parameter__r.Steel_FP__c * 120;	
				  }
				  else{
				  	    ItemSqFt = 0;
				  }
		    }else if (setAssignCustom21.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && ncmtrec.Utilitarian__c == True){
			    ItemSqFt = listplp[0].Finished_Wall_Area_SF__c ;	
		    }else if (setAssignCustom22.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = 0;
		    }else if (setAssignCustom23.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = 0;		
		    }else if (setAssignCustom213.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = 	listplp[0].Finished_Wall_Area_SF__c ;	
			}else if (setAssignCustom214.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
				  	    ItemSqFt = 1;
				  }
				  else{
				  	    ItemSqFt = 0;
				  }	
			}else if (setAssignCustom215.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.High__c == True){
				  	  ItemSqFt = 1000;
				  }
				  else{
				  	  ItemSqFt = 0;
				  }	
			}else if (setAssignCustom12.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){
			    	 ItemSqFt = listPLP[0].Total_Roof_Area_SF__c;
				  }
				  else{
					 ItemSqFt = 0;
				  }	
			}else if (setAssignCustom216.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if (ncmtrec.Below_Grade_Structure__c == True){	
					  ItemSqFt = 0;
				  }	
				  else{
				  	  ItemSqFt = listPLP[0].Total_Roof_Area_SF__c;
				  }	
			} else if (setAssignCustom34.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  ItemSqFt = (ncmtrec.At_and_above_grade__c + ncmtrec.below_grade__c) * 100;
			} else if (setAssignCustom60.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  ItemSqFt = ncmtrec.Number_of_Spaces__c * 13 ;	
			} else if (setAssignCustom26.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){	
				  ItemSqFt = 2 * (ncmtrec.At_and_above_grade__c + ncmtrec.below_grade__c);	
		    } else if (setAssignCustom16.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			      ItemSqFt = 2 * (ncmtrec.At_and_above_grade__c + ncmtrec.below_grade__c); 
		    } else if (setAssignCustom17.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			      ItemSqFt = 2 * (ncmtrec.At_and_above_grade__c + ncmtrec.below_grade__c) * 20;	
		    } else if (setAssignCustom18.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = listPLP[0].Number_of_Stops__c ;	
		    } else if (setAssignCustom217.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
			    ItemSqFt = listPLP[0].Number_of_Stops__c * (ncmtrec.At_and_above_grade__c + ncmtrec.below_grade__c) ;
			} else if (setAssignCustom37.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if(ncmtrec.Below_Grade_Structure__c == True){
				     ItemSqFt = listPLP[0].HVAC_Heating_Load_Mbtu__c;	
				  }	
				  else{
				     ItemSqFt = 0 ;
				  }
			} else if (setAssignCustom38.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if(ncmtrec.Below_Grade_Structure__c == True){
				   ItemSqFt = listPLP[0].HVAC_Cooling_Load_Tons__c;	
				  }	
				  else{
				    ItemSqFt = 0;
				  }	
			} else if (setAssignCustom218.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if(ncmtrec.Below_Grade_Structure__c == True){
				   ItemSqFt = ncmtrec.Parking_Garage_Gross_Area_SF__c;	
				  }	
				  else{
				    ItemSqFt = 0;
				  }	
			} else if (setAssignCustom40.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if(ncmtrec.Below_Grade_Structure__c == True){
				  		ItemSqFt = listPLP[0].HVAC_Air_Handling_Capacity_CFM__c;
				  }
				  else{
				  	 	ItemSqFt = 0;
				  }
			} else if (setAssignCustom3.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				   if(ncmtrec.Below_Grade_Structure__c == True){
						ItemSqFt = Math.round(ncmtrec.Parking_Garage_Gross_Area_SF__c*0.1);
				   }
				   else{
				   	    ItemSqFt = 0;
				   }
			} else if (setAssignCustom219.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  if(ncmtrec.High__c == True){	
				  		ItemSqFt = ncmtrec.Parking_Garage_Gross_Area_SF__c;
				  }	
				  else{
				  	   ItemSqFt = 0;
				  }
			} else if (setAssignCustom42.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  	ItemSqFt = listPLP[0].Electrical_Load_kW__c;	
			} else if (setAssignCustom43.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				 	 ItemSqFt = Math.Round(listPLP[0].Electrical_Load_kW__c * 1.25);	
			} else if (setAssignCustom46.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				 	 ItemSqFt = Math.Round(listPLP[0].Electrical_Load_kW__c * 1.25) * 2;
			} else if (setAssignCustom2.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
					ItemSqFt = 300; 
			} else if (setAssignCustom191.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){	
					ItemSqFt = (ncmtrec.At_and_above_grade__c + ncmtrec.below_grade__c);	
			} else if (setAssignCustom220.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
				  	ItemSqFt = listsiteinfo[0].Finished_Site__c ;
		    }else if (setAssignCustom221.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && ncmtrec.Medium__c == True){
			    ItemSqFt = listplp[0].Finished_Wall_Area_SF__c ;	
		    }else if (setAssignCustom222.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c) && ncmtrec.High__c == True){
			    ItemSqFt = listplp[0].Finished_Wall_Area_SF__c ;				    				  													  				  			  			  
			} else {	
				ItemSqFt = 0;
			}	
		}
		 	 	
			objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
            	Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
               	Core_Shell_Cost_Parameter__c = objRecord.ID,
               	Total_Units__c = ItemSqFt,
               	Unit_Cost__c = (Decimal) objRecord.get(strColumnToPick)
            ));
		}		  
    	insert objProjectCoreShellDetailRecords;
    }
}