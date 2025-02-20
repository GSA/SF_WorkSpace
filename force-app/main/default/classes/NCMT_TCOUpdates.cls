public with sharing class NCMT_TCOUpdates {
    
   // @future 
   /* public static void TCOProjfutureupdate(ID ProjectID){
        
        NCMT_TCOUpdates objTCOUpdates = new NCMT_TCOUpdates();
          
          triggervalue.isPerformanceUpdate= true;
          triggervalue.isCostUpdate = true;
          objTCOUpdates.GenerateTCOCoreShellData(ProjectID);
          objTCOUpdates.UpdateTCOCoreShellData(ProjectID);
          triggervalue.isPerformanceUpdate= false;
          triggervalue.isCostUpdate = false;
          objTCOUpdates.UpdatePerfInput(ProjectID);
        
    }*/
    
    //@future 
    public void TCOfutureupdate(ID ProjectID){
        
        NCMT_TCOUpdates objTCOUpdates = new NCMT_TCOUpdates();
        NCMT_TCOFLOWController objTCOFLOW = new NCMT_TCOFLOWController();
        
        triggervalue.isPerformanceUpdate= true;
        triggervalue.isCostUpdate = true; 
        triggervalue.isHPLosUpdate = true;
        objTCOUpdates.UpdatePerfInput(ProjectID);
        objTCOFLOW.GenerateTCOCoreShellData(ProjectID);
       // objTCOUpdates.UpdateTCOCoreShellData(ProjectID);
        triggervalue.isPerformanceUpdate= false;
        triggervalue.isCostUpdate = false;
        objTCOUpdates.UpdateHPLOS(ProjectID);
        //triggervalue.isTCOPLPUpdate = true;
        //objTCOUpdates.UpdatePLPRecordType(ProjectID);
    }
    
    public void UpdatePerfInput (ID ProjectID){
        ID plpID;
        List<Project_Level_Parameter__c> plpList = [Select ID, Name
                                                    From Project_Level_Parameter__c
                                                    where NCMT_Project__c = :ProjectID];
             if(plpList.size()>0){
             //system.debug('plpList ==='+plpList);   
                 plpID = plpList[0].Id;
             }          
        List<NCMT_TCO_Performance_Input__c> perfIpList = [Select ID, Name,Project_Level_Parameter__c
                                                              From NCMT_TCO_Performance_Input__c
                                                              where NCMT_Project__c = :ProjectID];
        if(perfIpList.size()>0){
            perfIpList[0].Project_Level_Parameter__c = plpID;
            
            update perfIpList;
        }
        
    }
    
    /*public void GenerateTCOCoreShellData(ID ProjectID){
     
        Date CostParameterDate;
        String CostParameterYear;
        Decimal ItemSqFt = 0.0,dblportablewater =0.0;
        Decimal ModsPercent = 100; 
        List<NCMT_Core_Shell_Cost_Detail__c> objProjectCoreShellDetailRecords = New List<NCMT_Core_Shell_Cost_Detail__c>();
        Map<string, String> mapCostSummary = new Map<string, String>();
        Map<string, decimal> mapCostDetail = new Map<string, decimal>();
        Map<string, decimal> costparamMap = new Map<string, decimal>();
         
        Set<string> setAssign1 = new Set <string> {'CC-27143','CC-27144'}; 
        Set<string> setAssign2 = new Set <string> {'CC-27145','CC-27146','CC-27147','CC-27148'};  
        Set<string> setAssign3 = new Set <string> {'CC-27149'}; 
        Set<string> setAssign4 = new Set <string> {'CC-27150','CC-27151'};
        Set<string> setAssign5 = new Set <string> {'CC-27152'};  
        Set<string> setAssign6 = new Set <string> {'CC-27153','CC-27154','CC-27160','CC-27165','CC-27166','CC-27170','CC-27173','CC-27174','CC-27175','CC-27176','CC-27177','CC-27178'};
        Set<string> setAssign7 = new Set <string> {'CC-27157','CC-27158'};
        Set<string> setAssign8 = new Set <string> {'CC-27159'}; 
        Set<string> setAssign9 = new Set <string> {'CC-27161'};
        Set<string> setAssign10 = new Set <string> {'CC-27162'};  
        Set<string> setAssign11 = new Set <string> {'CC-27163'}; 
        Set<string> setAssign12 = new Set <string> {'CC-27164'}; 
        Set<string> setAssign13 = new Set <string> {'CC-27167'}; 
        Set<string> setAssign14 = new Set <string> {'CC-27168'}; 
        Set<string> setAssign15 = new Set <string> {'CC-27169'};
        Set<string> setAssign16 = new Set <string> {'CC-27171','CC-27172'};
        Set<string> setAssign17 = new Set <string> {'CC-27182'};     
        ID projCRID,PerfIpID ;
            
        NCMT_CustomSettings__c ncmt_customsettings = NCMT_CustomSettings__c.getOrgDefaults();
        CostParameterDate = ncmt_customsettings.Cost_Parameter_Date__c;
        CostParameterYear = string.valueof(CostParameterDate.year()+1);
        
         List<NCMT_Project_Cost_Summary__c> listCostSummary = [Select ID, Cost_Category_Description__c 
                                                                From NCMT_Project_Cost_Summary__c 
                                                               Where Project_Name__c = :ProjectID];
                                                               
        
        for(NCMT_Project_Cost_Summary__c objItem : listCostSummary){
            mapCostSummary.put(objItem.Cost_Category_Description__c, objItem.ID);
        }  
              
         
        List<NCMT_Core_Shell_Cost_Parameter__c>  objCoreShellParameters = [Select  ID, Core_Shell_Cost_Parameter_Identifier__c, Cost_Type__c, 
                                                                                     Cost_Sub_Type__c,Other_Space_Unit_Cost__c,Duplicate_Maintenance_Related__c
                                                                                        From    NCMT_Core_Shell_Cost_Parameter__c 
                                                                                        Where   Fiscal_Year__c = :CostParameterYear
                                                                                         And     Repair_Related__c = true
                                                                                        Order by Core_Shell_Cost_Parameter_Identifier__c];
            system.debug('objCoreShellParameters.size() =='+objCoreShellParameters.size());
         string strNCMTID = ProjectID;
         strNCMTID = strNCMTID.substring(0,strNCMTID.length()-3); 
         
         List<NCMT_Core_Shell_Cost_Parameter__c>  objCoreShellParams = [Select  ID, Core_Shell_Cost_Parameter_Identifier__c, Cost_Type__c, Cost_Sub_Type__c
                                                                                        From    NCMT_Core_Shell_Cost_Parameter__c 
                                                                                        Where   Fiscal_Year__c = :CostParameterYear
                                                                                        and Core_Shell_Cost_Parameter_Identifier__c in ('CC163','CC174','CC176','CC178','CC179','CC180'
                                                                                                                                        ,'CC181','CC182','CC183','CC200','CC185','CC189','CC193',
                                                                                                                                        'CC-00389','CC267','CC290','CC305','CC289','CC292','CC293','CC294',
                                                                                                                                        'CC310','CC311','CC312','CC301','CC302','CC315','CC316','CC308','CC309',
                                                                                                                                       'CC313','CC335','CC336','CC339','CC337','CC338','CC340','CC342','CC257','CC258',
                                                                                                                                       'CC198','CC199','CC203','CC204','CC194','CC195','CC196','CC197','CC269','CC288',
                                                                                                                                       'CC270','CC271','CC272','CC273','CC332','CC291','CC306','CC307','CC314','CC319',
                                                                                                                                        'CC329','CC330','CC331','CC-00457','CC-00463','CC-00465','CC-00466',
                                                                                                                                        'CC-00467','CC-00468','CC-00469','CC-00470','CC-00471','CC-00472')
                                                                                        Order by Core_Shell_Cost_Parameter_Identifier__c];
        for(NCMT_Core_Shell_Cost_Parameter__c CSlst: objCoreShellParams ){
         
                costparamMap.put(CSlst.Core_Shell_Cost_Parameter_Identifier__c,0);
         
         } 
        
        List<NCMT_Core_Shell_Cost_Detail__c>  coreShellDList = [Select ID, TCO_Project_Cost_Rate__c, TCO_Performance_Input__c , Name,Total_Units__c,Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c 
                                                                  From NCMT_Core_Shell_Cost_Detail__c
                                                                  where NCMT_Project_ID__c = :strNCMTID 
                                                                  and Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c in ('CC163','CC174','CC176','CC178','CC179','CC180'
                                                                                                                                               ,'CC181','CC182','CC183','CC200','CC185','CC189','CC193',
                                                                                                                                              'CC-00389','CC267','CC290','CC305','CC289','CC292','CC293','CC294',
                                                                                                                                              'CC310','CC311','CC312','CC301','CC302','CC315','CC316','CC308','CC309',
                                                                                                                                              'CC313','CC335','CC336','CC339','CC337','CC338','CC340','CC342','CC257','CC258',
                                                                                                                                               'CC198','CC199','CC203','CC204','CC194','CC195','CC196','CC197','CC269','CC288',
                                                                                                                                               'CC270','CC271','CC272','CC273','CC332','CC291','CC306','CC307','CC314','CC319',
                                                                                                                                                'CC329','CC330','CC331','CC-00457','CC-00463','CC-00465','CC-00466',
                                                                                                                                                'CC-00467','CC-00468','CC-00469','CC-00470','CC-00471','CC-00472')
                                                                   ];
                                                                   
                      
         for(NCMT_Core_Shell_Cost_Detail__c CSDList: coreShellDList ){
         
             costparamMap.put(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c,CSDList.Total_Units__c);
             projCRID = CSDList.TCO_Project_Cost_Rate__c;
             PerfIpID = CSDList.TCO_Performance_Input__c;
             
         }                                                          
            system.debug('costparamMap===--'+costparamMap);        
         for(NCMT_Core_Shell_Cost_Parameter__c objRecord: objCoreShellParameters) {
             
             if(!objRecord.Duplicate_Maintenance_Related__c){
                 ModsPercent = 100;
             }else{
                 ModsPercent = 0;
             }
             
             if (setAssign1.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC163');
             }else if(setAssign2.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC174') + costparamMap.get('CC176');
             }else if(setAssign3.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC178') + costparamMap.get('CC179') + costparamMap.get('CC180') + costparamMap.get('CC181') + costparamMap.get('CC182') + costparamMap.get('CC183');
             }
             else if(setAssign4.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC200') + costparamMap.get('CC185') + costparamMap.get('CC189') + costparamMap.get('CC193');
             }else if(setAssign5.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC-00389') + costparamMap.get('CC267');
             }else if(setAssign6.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC305');
             }else if(setAssign7.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC290');
             }else if(setAssign8.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC289');
             }else if(setAssign9.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC292') + costparamMap.get('CC293') + costparamMap.get('CC294')+ costparamMap.get('CC310')+ costparamMap.get('CC311')+ costparamMap.get('CC312');
             }else if(setAssign10.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC292') + costparamMap.get('CC293') + costparamMap.get('CC294');
             }else if(setAssign11.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC301') + costparamMap.get('CC302') + costparamMap.get('CC315') + costparamMap.get('CC316');
             }else if(setAssign12.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC308') + costparamMap.get('CC309') + costparamMap.get('CC313');
             }else if(setAssign13.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC335');
             }else if(setAssign14.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC336') + costparamMap.get('CC339');
             }else if(setAssign15.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC337') + costparamMap.get('CC338') + costparamMap.get('CC340');
             }else if(setAssign16.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC342');
             }else if(setAssign17.Contains(objRecord.Core_Shell_Cost_Parameter_Identifier__c)){
                 ItemSqFt = costparamMap.get('CC257') + costparamMap.get('CC258');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27183' ){
                 ItemSqFt = costparamMap.get('CC198');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27184' ){
                 ItemSqFt = costparamMap.get('CC199');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27185' ){
                 ItemSqFt = costparamMap.get('CC203');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27186' ){
                 ItemSqFt = costparamMap.get('CC204');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27187' ){
                 ItemSqFt = costparamMap.get('CC193');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27188' ){
                 ItemSqFt = costparamMap.get('CC194');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27189' ){
                 ItemSqFt = costparamMap.get('CC195');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27190' ){
                 ItemSqFt = costparamMap.get('CC196');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27191' ){
                 ItemSqFt = costparamMap.get('CC197');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27192' ){
                 ItemSqFt = costparamMap.get('CC269');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27193' ){
                 ItemSqFt = costparamMap.get('CC288');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27194' ){
                 ItemSqFt = costparamMap.get('CC270');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27195' ){
                 ItemSqFt = costparamMap.get('CC271');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27196' ){
                 ItemSqFt = costparamMap.get('CC272');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27197' ){
                 ItemSqFt = costparamMap.get('CC273');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27198' ){
                 ItemSqFt = costparamMap.get('CC332');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27199' ){
                 ItemSqFt = costparamMap.get('CC289');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27200' ){
                 ItemSqFt = costparamMap.get('CC290');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27201' ){
                 ItemSqFt = costparamMap.get('CC291');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27202' ){
                 ItemSqFt = costparamMap.get('CC292');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27203' ){
                 ItemSqFt = costparamMap.get('CC293');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27204' ){
                 ItemSqFt = costparamMap.get('CC294');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27205' ){
                 ItemSqFt = costparamMap.get('CC305');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27206' ){
                 ItemSqFt = costparamMap.get('CC306');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27207' ){
                 ItemSqFt = costparamMap.get('CC307');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27208' ){
                 ItemSqFt = costparamMap.get('CC308');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27209' ){
                 ItemSqFt = costparamMap.get('CC309');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27210' ){
                 ItemSqFt = costparamMap.get('CC310');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27211' ){
                 ItemSqFt = costparamMap.get('CC311');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27212' ){
                 ItemSqFt = costparamMap.get('CC312');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27213' ){
                 ItemSqFt = costparamMap.get('CC313');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27214' ){
                 ItemSqFt = costparamMap.get('CC314');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27215' ){
                 ItemSqFt = costparamMap.get('CC319');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27216' ){
                 ItemSqFt = costparamMap.get('CC329');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27217' ){
                 ItemSqFt = costparamMap.get('CC330');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27218' ){
                 ItemSqFt = costparamMap.get('CC331');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27219' ){
                 ItemSqFt = costparamMap.get('CC-00457');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27220' ){
                 ItemSqFt = costparamMap.get('CC-00463');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27221' ){
                 ItemSqFt = costparamMap.get('CC-00465');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27222' ){
                 ItemSqFt = costparamMap.get('CC-00466');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27223' ){
                 ItemSqFt = costparamMap.get('CC-00467');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27224' ){
                 ItemSqFt = costparamMap.get('CC-00468');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27225' ){
                 ItemSqFt = costparamMap.get('CC-00469');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27226' ){
                 ItemSqFt = costparamMap.get('CC-00470');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27227' ){
                 ItemSqFt = costparamMap.get('CC-00471');
             }else if(objRecord.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27228' ){
                 ItemSqFt = costparamMap.get('CC-00472');
             }else{
                  ItemSqFt = 0;
             }
             
             objProjectCoreShellDetailRecords.Add(new NCMT_Core_Shell_Cost_Detail__c(
                 Project_Cost_Summary__c = mapCostSummary.get(objRecord.Cost_Type__c),
                 Core_Shell_Cost_Parameter__c = objRecord.ID,
                 Total_Units__c = ItemSqFt,
                 Applicable_Cost__c = Modspercent,
                 Unit_Cost__c = objRecord.Other_Space_Unit_Cost__c,
                 TCO_Project_Cost_Rate__c = projCRID,
                 TCO_Performance_Input__c = PerfIpID
             ));
         }
         insert objProjectCoreShellDetailRecords;
     }*/
    
    /*public void UpdateTCOCoreShellData(ID ProjectID){
         ID projCRID,PerfIpID ;
        
        List<NCMT_TCO_Annual_Cost_Summary__c> NPVSummaryList = [Select ID, Name,Performance_Input__c,TCO_Project_Cost_Rate__c
                                                              From NCMT_TCO_Annual_Cost_Summary__c
                                                              where Project_Name__c = :ProjectID
                                                               ];
             if(NPVSummaryList.size()>0){
             system.debug('NPVSummaryList ==='+NPVSummaryList );   
                 //NPVSummaryID = NPVSummaryList[0].Id;
                 PerfIpID = NPVSummaryList[0].Performance_Input__c;
                 projCRID = NPVSummaryList[0].TCO_Project_Cost_Rate__c;
             } 
        
         system.debug('projCRID ==='+projCRID );   
         string strNCMTID = ProjectID;
         strNCMTID = strNCMTID.substring(0,strNCMTID.length()-3);                                   
     
         List<NCMT_Core_Shell_Cost_Detail__c>  coreShellDList = [Select ID, Name,TCO_Project_Cost_Rate__c,TCO_Performance_Input__c
                                                                  From NCMT_Core_Shell_Cost_Detail__c
                                                                  where NCMT_Project_ID__c = :strNCMTID 
                                                                   ];
       
       system.debug('ProjectID==='+ProjectID);
        system.debug('coreShellDList.size()==='+coreShellDList.size());
         
        //for updating exisitng records
        for (NCMT_Core_Shell_Cost_Detail__c CSList : coreShellDList){
            
                CSList.TCO_Project_Cost_Rate__c = projCRID ;
                CSList.TCO_Performance_Input__c = PerfIpID ;
        }
        
        update coreShellDList;
     
     }*/
         
    public void UpdateHPLOS(ID ProjectID){
        
        Decimal  dblSpace =0.0,  dblSpace1= 0.0, dblSpace2= 0.0, dblSpace3= 0.0, dblSpace4= 0.0, dblSpace5 = 0.0, dblSpace6 = 0.0, dblSpace7= 0.0, dblSpace8= 0.0, dblSpace9= 0.0, dblSpace10 = 0.0;
        Decimal  dblSpace11= 0.0, dblSpace12= 0.0, dblSpace13= 0.0, dblSpace14= 0.0, dblSpace15= 0.0, dblSpace16= 0.0, dblSpace17= 0.0, dblSpace18= 0.0, dblSpace19= 0.0, dblSpace20 = 0.0;
        Decimal  dblSpace21= 0.0, dblSpace22= 0.0, dblSpace23= 0.0, dblSpace24= 0.0, dblSpace25= 0.0, dblSpace26= 0.0, dblSpace27= 0.0, dblSpace28= 0.0, dblSpace29= 0.0, dblSpace30 = 0.0;
        Decimal  dblSpace31= 0.0, dblSpace32= 0.0, dblSpace33= 0.0, dblSpace34= 0.0, dblSpace35= 0.0, dblSpace36= 0.0, dblSpace37= 0.0, dblSpace38= 0.0, dblSpace39= 0.0, dblSpace40 = 0.0;
        Decimal  dblSpace41= 0.0, dblSpace42= 0.0, dblSpace43= 0.0, dblSpace44= 0.0, dblSpace45= 0.0, dblSpace46= 0.0, dblSpace47= 0.0, dblSpace48= 0.0, dblSpace49= 0.0, dblSpace50= 0.0, dblSpace51= 0.0, dblSpace52 = 0.0;
        Decimal  dblSpace53= 0.0, dblSpace54= 0.0, dblSpace55= 0.0, dblSpace56= 0.0, dblSpace57= 0.0, dblSpace58= 0.0, dblSpace59 = 0.0;
        Decimal  dblSpace60= 0.0, dblSpace61= 0.0, dblSpace62= 0.0, dblSpace63= 0.0, dblSpace64= 0.0, dblSpace65= 0.0, dblSpace66 = 0.0; 
        Decimal  dblSpace67= 0.0, dblSpace68= 0.0, dblSpace69= 0.0, dblSpace70= 0.0, dblSpace71= 0.0;
        
        
        List<NCMT_Housing_Plan_Summary__c> HPSummaryList = [Select ID, Name,Workstations_open_office_Use_USF__c,Closed_offices_Use_USF__c,Unfinished_Shell_Area_Use_USF__c,X8_20_person_rooms_Use_USF__c,
                                                                       X20_or_more_person_rooms_Use_USF__c,Teleconference_Use_USF__c,Auditorium_sloped_floor_Use_USF__c,General_storage_Use_USF__c,
                                                                       High_density_storage_Use_USF__c,Clinics_health_units_Use_USF__c,Child_care_Use_USF__c,ADP_high_density_PC_s_Use_USF__c,ADP_mainframe_Use_USF__c,VA_Ambulatory_Surgery_Use_USF__c,
                                                                       Climate_controlled_for_artifacts_Use_USF__c,Copy_Center_Use_USF__c,Courtroom_Bankruptcy_Use_USF__c,Courtroom_district_Ceremonial_Use_USF__c,Courtroom_district_Standard_Use_USF__c,
                                                                       Courtroom_Magistrate_Use_USF__c,Credit_Union_Use_USF__c,Data_Center_Use_USF__c,Enhanced_office_Use_USF__c,VA_Exam_Suite_Use_USF__c,Firing_range_Use_USF__c,Food_service_cafeteria_Use_USF__c,
                                                                       Grand_Jury_Room_Use_USF__c,Hardened_offices_suites_Use_USF__c,Holding_cell_Central_Use_USF__c,Holding_cell_Court_floors_Use_USF__c,VA_Infusion_Use_USF__c,Interview_Detention_Use_USF__c,
                                                                       Joint_use_retail_Use_USF__c,Judicial_chambers_Use_USF__c,Judicial_hearing_Use_USF__c,Kitchen_Break_room_Use_USF__c,Laboratory_Dry_electronic_Use_USF__c,
                                                                       Laboratory_Wet_chemistry_Use_USF__c,Libraries_Use_USF__c,Light_industrial_Use_USF__c,Locker_Shower_room_Use_USF__c,VA_Intake_Use_USF__c,
                                                                        Non_climate_controlled_Use_USF__c,Non_Marshal_Holding_Cell_Double_Use_USF__c,Non_Marshal_Holding_Cell_Single_Use_USF__c,VA_Pharmacy_Use_USF__c,
                                                                        Physical_fitness_Use_USF__c,Private_toilets_Use_USF__c,VA_Radiology_Use_USF__c,Sally_Port_Use_USF__c,Secured_Storage_SCIF_Enhanced_Use_USF__c,Secured_Storage_SCIF_Standard_Use_USF__c,
                                                                        Secure_Work_Environment_SWE_Enhd_UseUSF__c,Secure_Work_Environment_SWE_Std_Use_USF__c,Transaction_counter_space_Use_USF__c,USMS_Suite_Administration_Use_USF__c,
                                                                        USMS_Suite_Operations_Use_USF__c,Vault_Type_Storage_Use_USF__c,Warehouse_Use_USF__c,Atrium_Ground_floor_plan_area__c,Enclosed_Parking__c,Restrooms__c,Ground_floor_circulation__c,Elevator_lobbies__c,
                                                                        Other_circulation__c,Mechanical_Electrical_IT__c,Loading_dock_Recycling_Trash__c,Project__r.Surface_Parking__c
                                                                  From NCMT_Housing_Plan_Summary__c
                                                                  where Project__c = :ProjectID
                                                                   ];
                                                                   
        for (NCMT_Housing_Plan_Summary__c RowData : HPSummaryList) {
                system.debug('Housing Plan ID: ' + RowData.id);
                dblSpace1 = (Decimal) RowData.Unfinished_Shell_Area_Use_USF__c;
                dblSpace2 = (Decimal) RowData.Workstations_open_office_Use_USF__c;
                dblSpace3 = (Decimal) RowData.Closed_offices_Use_USF__c;
                dblSpace4 = (Decimal) RowData.Private_toilets_Use_USF__c;
                dblSpace5 = (Decimal) RowData.X8_20_person_rooms_Use_USF__c;
                dblSpace6 = (Decimal) RowData.X20_or_more_person_rooms_Use_USF__c;
                dblSpace7 = (Decimal) RowData.Teleconference_Use_USF__c;
                dblSpace8 = (Decimal) RowData.Auditorium_sloped_floor_Use_USF__c;
                dblSpace9 = (Decimal) RowData.General_storage_Use_USF__c;
                dblSpace10 = (Decimal) RowData.High_density_storage_Use_USF__c;
                dblSpace11 = (Decimal) RowData.Clinics_health_units_Use_USF__c;
                dblSpace12 = (Decimal) RowData.Physical_fitness_Use_USF__c;
                dblSpace13 = (Decimal) RowData.Child_care_Use_USF__c;
                dblSpace14 = (Decimal) RowData.Libraries_Use_USF__c;
                dblSpace15 = (Decimal) RowData.ADP_mainframe_Use_USF__c;
                dblSpace16 = (Decimal) RowData.ADP_high_density_PC_s_Use_USF__c;
                dblSpace17 = (Decimal) RowData.Joint_use_retail_Use_USF__c;
                dblSpace18 = (Decimal) RowData.Food_service_cafeteria_Use_USF__c;
                dblSpace19 = (Decimal) RowData.Climate_controlled_for_artifacts_Use_USF__c;
                dblSpace20 = (Decimal) RowData.Laboratory_Dry_electronic_Use_USF__c;
                dblSpace21 = (Decimal) RowData.Laboratory_Wet_chemistry_Use_USF__c;
                dblSpace22 = (Decimal) RowData.Firing_range_Use_USF__c;
                dblSpace23 = (Decimal) RowData.Copy_Center_Use_USF__c;
                dblSpace24 = (Decimal) RowData.Credit_Union_Use_USF__c;
                dblSpace25 = (Decimal) RowData.Transaction_counter_space_Use_USF__c;
                dblSpace26 = (Decimal) RowData.Kitchen_Break_room_Use_USF__c;
                dblSpace27 = (Decimal) RowData.Locker_Shower_room_Use_USF__c;
                dblSpace28 = (Decimal) RowData.Hardened_offices_suites_Use_USF__c;
                dblSpace29 = (Decimal) RowData.Secure_Work_Environment_SWE_Std_Use_USF__c;
                dblSpace30 = (Decimal) RowData.Secure_Work_Environment_SWE_Enhd_UseUSF__c;
                dblSpace31 = (Decimal) RowData.Secured_Storage_SCIF_Standard_Use_USF__c;
                dblSpace32 = (Decimal) RowData.Secured_Storage_SCIF_Enhanced_Use_USF__c;
                dblSpace33 = (Decimal) RowData.Vault_Type_Storage_Use_USF__c;
                dblSpace34 = (Decimal) RowData.Interview_Detention_Use_USF__c;
                dblSpace35 = (Decimal) RowData.Non_Marshal_Holding_Cell_Single_Use_USF__c;
                dblSpace36 = (Decimal) RowData.Non_Marshal_Holding_Cell_Double_Use_USF__c;
                dblSpace37 = (Decimal) RowData.Courtroom_district_Ceremonial_Use_USF__c;
                dblSpace38 = (Decimal) RowData.Courtroom_district_Standard_Use_USF__c;
                dblSpace39 = (Decimal) RowData.Courtroom_Bankruptcy_Use_USF__c;
                dblSpace40 = (Decimal) RowData.Courtroom_Magistrate_Use_USF__c;
                dblSpace41 = (Decimal) RowData.Grand_Jury_Room_Use_USF__c;
                dblSpace42 = (Decimal) RowData.Judicial_hearing_Use_USF__c;
                dblSpace43 = (Decimal) RowData.Judicial_chambers_Use_USF__c;
                dblSpace44 = (Decimal) RowData.Enhanced_office_Use_USF__c;
                dblSpace45 = (Decimal) RowData.USMS_Suite_Administration_Use_USF__c;
                dblSpace46 = (Decimal) RowData.USMS_Suite_Operations_Use_USF__c;
                dblSpace47 = (Decimal) RowData.Sally_Port_Use_USF__c;
                dblSpace48 = (Decimal) RowData.Holding_cell_Central_Use_USF__c;
                dblSpace49 = (Decimal) RowData.Holding_cell_Court_floors_Use_USF__c;
                dblSpace50 = (Decimal) RowData.Light_industrial_Use_USF__c;
                dblSpace51 = (Decimal) RowData.Warehouse_Use_USF__c;
                dblSpace52 = (Decimal) RowData.Non_climate_controlled_Use_USF__c;
                dblSpace53 = (Decimal) RowData.VA_Exam_Suite_Use_USF__c;
                dblSpace54 = (Decimal) RowData.VA_Ambulatory_Surgery_Use_USF__c;
                dblSpace55 = (Decimal) RowData.VA_Infusion_Use_USF__c;
                dblSpace56 = (Decimal) RowData.VA_Intake_Use_USF__c;
                dblSpace57 = (Decimal) RowData.VA_Pharmacy_Use_USF__c;
                dblSpace58 = (Decimal) RowData.VA_Radiology_Use_USF__c;
                dblSpace59 = (Decimal) RowData.Data_Center_Use_USF__c;
                dblSpace60 = (Decimal) RowData.Atrium_Ground_floor_plan_area__c;
                dblSpace61 = (Decimal) RowData.Enclosed_Parking__c;
                dblSpace62 = (Decimal) RowData.Restrooms__c;
                dblSpace63 = (Decimal) RowData.Ground_floor_circulation__c;
                dblSpace64 = (Decimal) RowData.Elevator_lobbies__c;
                dblSpace65 = (Decimal) RowData.Other_circulation__c;
                dblSpace66 = (Decimal) RowData.Mechanical_Electrical_IT__c;
                dblSpace67 = (Decimal) RowData.Loading_dock_Recycling_Trash__c; 
                dblSpace71 = (Decimal) RowData.Project__r.Surface_Parking__c * 350;
            }
        
        string strNCMTID = ProjectID;
            strNCMTID = strNCMTID.substring(0,strNCMTID.length()-3);
        
        List<NCMT_Core_Shell_Cost_Detail__c>  coreShellDList = [Select ID, Name,NCMT_Project_ID__c,Total_Units__c,Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c 
                                                                  From NCMT_Core_Shell_Cost_Detail__c
                                                                  where NCMT_Project_ID__c = :strNCMTID 
                                                                  and Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c in ('CC385','CC386','CC387')
                                                                   ];   
            for(NCMT_Core_Shell_Cost_Detail__c CSDLst:coreShellDList){   
                if(CSDLst.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC385'){
                    dblSpace68 = CSDLst.Total_Units__c;
                }else if(CSDLst.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC386'){
                    dblSpace69 = CSDLst.Total_Units__c;
                }else if(CSDLst.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC387'){
                    dblSpace70 = CSDLst.Total_Units__c;
                }
                
            }
        
        List<NCMT_TCO_HP_Level_of_Service__c> objHPLOSDetailRecords =[Select ID,Name,USF__c,Space_Type__c
                                                                       From NCMT_TCO_HP_Level_of_Service__c
                                                                       where Project_Name__c = :ProjectID];
        IF(objHPLOSDetailRecords.size()>0){
        for(NCMT_TCO_HP_Level_of_Service__c objRecord: objHPLOSDetailRecords) {
                
               if(objRecord.Space_Type__c == 'General Office Space Type, 20% Open'){
                    objRecord.USF__c = dblSpace3; 
                }else if(objRecord.Space_Type__c == 'General Office Space Type, 50% Open'){
                    objRecord.USF__c = 0; 
                }else if(objRecord.Space_Type__c == 'General Office Space Type, 80% Open'){
                    objRecord.USF__c = 0; 
                }else if(objRecord.Space_Type__c == 'General Office Space Type, 100% Open'){
                    objRecord.USF__c = dblSpace2; 
                }else if(objRecord.Space_Type__c == 'Enhanced Office Space Type'){
                    objRecord.USF__c = dblSpace44;                
                }else if(objRecord.Space_Type__c == 'General Storage'){
                    objRecord.USF__c = dblSpace9;
                }else if(objRecord.Space_Type__c == 'High Density Storage'){
                    objRecord.USF__c = dblSpace10;
                }else if(objRecord.Space_Type__c == 'Indoor Parking'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Outdoor Parking'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Dry/Electronic Lab'){
                    objRecord.USF__c = dblSpace20;
                }else if(objRecord.Space_Type__c == 'Wet Lab'){
                    objRecord.USF__c = dblSpace21;
                }else if(objRecord.Space_Type__c == 'Holding cell'){
                    objRecord.USF__c = dblSpace49;
                }else if(objRecord.Space_Type__c == 'USMS Suite: Administrative Area'){
                    objRecord.USF__c = dblSpace45;
                }else if(objRecord.Space_Type__c == 'USMS Suite, Sally Port'){
                    objRecord.USF__c = dblSpace47;
                }else if(objRecord.Space_Type__c == 'USMS Operations Area'){
                    objRecord.USF__c = dblSpace46;
                }else if(objRecord.Space_Type__c == 'USMS Suite: Central Holding Area'){
                    objRecord.USF__c = dblSpace48;
                }else if(objRecord.Space_Type__c == 'Private Toilet'){
                    objRecord.USF__c = dblSpace4;
                }else if(objRecord.Space_Type__c == 'Clinic/Health Unit'){
                    objRecord.USF__c = dblSpace11;
                }else if(objRecord.Space_Type__c == 'Fitness/Exercise'){
                    objRecord.USF__c = dblSpace12;
                }else if(objRecord.Space_Type__c == 'Childcare TI'){
                    objRecord.USF__c = dblSpace13;
                }else if(objRecord.Space_Type__c == 'Conference/Classrooms'){
                    objRecord.USF__c = (dblSpace5 + dblSpace6);
                }else if(objRecord.Space_Type__c == 'Teleconference'){
                    objRecord.USF__c = dblSpace7;
                }else if(objRecord.Space_Type__c == 'Auditorium'){
                    objRecord.USF__c = dblSpace8;
                }else if(objRecord.Space_Type__c == 'Library'){
                    objRecord.USF__c = dblSpace14;
                }else if(objRecord.Space_Type__c == 'ADP Mainframe'){
                    objRecord.USF__c = dblSpace15;
                }else if(objRecord.Space_Type__c == 'ADP - High Density PCs'){
                    objRecord.USF__c = dblSpace16;
                }else if(objRecord.Space_Type__c == 'Courtroom - District Court'){
                    objRecord.USF__c = dblSpace38;
                }else if(objRecord.Space_Type__c == 'Courtroom, District Grand Jury'){
                    objRecord.USF__c = dblSpace41;
                }else if(objRecord.Space_Type__c == 'Courtroom - Bankruptcy'){
                    objRecord.USF__c = dblSpace39;
                }else if(objRecord.Space_Type__c == 'Courtroom - Magistrate'){
                    objRecord.USF__c = dblSpace40;
                }else if(objRecord.Space_Type__c == 'Judicial Hearing Room'){
                    objRecord.USF__c = dblSpace42;
                }else if(objRecord.Space_Type__c == 'Judicial Chambers'){
                    objRecord.USF__c = dblSpace43;
                }else if(objRecord.Space_Type__c == 'Light Industrial'){
                    objRecord.USF__c = dblSpace50;
                }else if(objRecord.Space_Type__c == 'Warehouse'){
                    objRecord.USF__c = dblSpace51;
                }else if(objRecord.Space_Type__c == 'Joint Use-Retail'){
                    objRecord.USF__c = dblSpace17;
                }else if(objRecord.Space_Type__c == 'Copy Center'){
                    objRecord.USF__c = dblSpace23;
                }else if(objRecord.Space_Type__c == 'Credit Union'){
                    objRecord.USF__c = dblSpace24;
                }else if(objRecord.Space_Type__c == 'Food Service/Cafeteria'){
                    objRecord.USF__c = dblSpace18;
                }else if(objRecord.Space_Type__c == 'Exhibit Hall Climate Controlled'){
                    objRecord.USF__c = dblSpace52;
                }else if(objRecord.Space_Type__c == 'Exhibit Hall Non-Climate Controlled'){
                    objRecord.USF__c = dblSpace19;
                }else if(objRecord.Space_Type__c == 'Hardened Suite: 20% open'){
                    objRecord.USF__c = dblSpace28;
                }else if(objRecord.Space_Type__c == 'Hardened Suite: 50% open'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Hardened Suite: 80% open'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Hardened Suite: 100% open'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Secure Work Environment'){
                    objRecord.USF__c = dblSpace29;
                }else if(objRecord.Space_Type__c == 'Secure Work Environment: Enhanced'){
                    objRecord.USF__c = dblSpace30;
                }else if(objRecord.Space_Type__c == 'Secure Work Environment: Maximum'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Secured Storage/SCIF Standard'){
                    objRecord.USF__c = dblSpace31;
                }else if(objRecord.Space_Type__c == 'Secured Storage/SCIF Enhanced'){
                    objRecord.USF__c = dblSpace32;
                }else if(objRecord.Space_Type__c == 'Firing Range'){
                    objRecord.USF__c = dblSpace22;
                }else if(objRecord.Space_Type__c == 'Pedestrian Lobby, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Public Transaction Space, Tenant Improvement'){
                    objRecord.USF__c = dblSpace25;
                }else if(objRecord.Space_Type__c == 'Public restroom, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Detention Suite - exc holding, Tenant Improvement'){
                    objRecord.USF__c = dblSpace34;
                }else if(objRecord.Space_Type__c == 'Holding Cell - Single, Tenant Improvement'){
                    objRecord.USF__c = dblSpace35;
                }else if(objRecord.Space_Type__c == 'Holding Cell - Group, Tenant Improvement'){
                    objRecord.USF__c = dblSpace36;
                }else if(objRecord.Space_Type__c == 'Vehicle Sallyport, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Shower and Locker Rooms, Tenant Improvement'){
                    objRecord.USF__c = dblSpace27;
                }else if(objRecord.Space_Type__c == 'Kitchen-Break room, Tenant Improvement'){
                    objRecord.USF__c = dblSpace26;
                }else if(objRecord.Space_Type__c == 'Vehicle Breakdown, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Kennels, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Aviary Holding, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Maintenance Building, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Commercial Secondary Dock - North, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Commercial Secondary Dock - South, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Commercial Secondary Cargo Storage, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'POV Secondary - N (Enclosed) , Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Commercial Seizures, Tenant Improvement'){
                    objRecord.USF__c = 0;
                }else if(objRecord.Space_Type__c == 'Vaults/Secure Storage, Tenant Improvement'){
                    objRecord.USF__c = dblSpace33;
                }else if(objRecord.Space_Type__c == 'Medical Spaces - Intake'){
                    objRecord.USF__c = dblSpace56;
                }else if(objRecord.Space_Type__c == 'Medical Spaces - Exam Suite'){
                    objRecord.USF__c = dblSpace53;
                }else if(objRecord.Space_Type__c == 'Medical Spaces - Radiology'){
                    objRecord.USF__c = dblSpace58;
                }else if(objRecord.Space_Type__c == 'Medical Spaces - Ambulatory Surgery'){
                    objRecord.USF__c = dblSpace54;
                }else if(objRecord.Space_Type__c == 'Medical Spaces - Infusion'){
                    objRecord.USF__c = dblSpace55;
                }else if(objRecord.Space_Type__c == 'Medical Spaces - Pharmacy'){
                    objRecord.USF__c = dblSpace57;
                }else if(objRecord.Space_Type__c == 'Data Center'){
                    objRecord.USF__c = dblSpace59;
                }else if(objRecord.Space_Type__c == 'Atrium (Ground floor plan area)'){
                    objRecord.USF__c = dblSpace60;
                }else if(objRecord.Space_Type__c == 'Enclosed parking'){
                    objRecord.USF__c = dblSpace61;
                }else if(objRecord.Space_Type__c == 'Restrooms'){
                    objRecord.USF__c = dblSpace62;
                }else if(objRecord.Space_Type__c == 'Ground floor circulation'){
                    objRecord.USF__c = dblSpace63;
                }else if(objRecord.Space_Type__c == 'Elevator lobbies'){
                    objRecord.USF__c = dblSpace64;
                }else if(objRecord.Space_Type__c == 'Other circulation'){
                    objRecord.USF__c = dblSpace65;
                }else if(objRecord.Space_Type__c == 'Mechanical/Electrical/IT'){
                    objRecord.USF__c = dblSpace66;
                }else if(objRecord.Space_Type__c == 'Loading dock/Recycling/Trash'){
                    objRecord.USF__c = dblSpace67;
                }else if(objRecord.Space_Type__c == 'Core Site'){
                    objRecord.USF__c = dblSpace68;
                }else if(objRecord.Space_Type__c == 'Mid Site'){
                    objRecord.USF__c = dblSpace69;
                }else if(objRecord.Space_Type__c == 'Peripheral Site'){
                    objRecord.USF__c = dblSpace70;
                }else if(objRecord.Space_Type__c == 'Parking'){
                    objRecord.USF__c = dblSpace71;
                }
                
                IF(objRecord.USF__c > 0 )
                {
                    objRecord.Project__c = ProjectID;
                }else{
                    objRecord.Project__c = null;
                }
        }
        update objHPLOSDetailRecords;
       }
        
    }
        
    /*public void UpdatePerfData(ID ProjectID) {
        NCMT_TCO_Performance_Input__c PLP = [SELECT Id FROM NCMT_TCO_Performance_Input__c WHERE NCMT_Project__c = :ProjectID ];
        update PLP;
    }*/
}