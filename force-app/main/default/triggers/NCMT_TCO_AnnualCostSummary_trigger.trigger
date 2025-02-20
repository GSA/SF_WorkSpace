trigger NCMT_TCO_AnnualCostSummary_trigger on NCMT_TCO_Annual_Cost_Summary__c  (after update) {

    String strNCMTIDs;
    decimal dblBX7=0.0, dblBX13=0.0,dblBW18=0.0,dblBZ20=0.0,tot_gsf=0.0,dblBT30=0.0,
             dblroofmounted=0.0,dblwall=0.0,dblsite =0.0,dbltotunits=0.0,dblBT7 =0.0,dblportablewater = 0.0;
    map<string,decimal> coreshellmap = new map<string,decimal>();
    
    System.debug('RUN ANN COST SUMMARY TRIGGER====='+NCMT_GenerateTCOProjectDetailsExt.runTriggers);
    if(NCMT_GenerateTCOProjectDetailsExt.runTriggers == true) {

    if(trigger.isAfter && trigger.isUpdate){
    
        
       if(triggervalue.isPerformanceUpdate == false){ 
        for(NCMT_TCO_Annual_Cost_Summary__c  obj :trigger.new){
            strNCMTIDs = obj.Project_Name__c;
            dblBX7 = obj.BX7__c;
            dblBX13 = obj.BX13__c;
            dblBW18 = obj.BW18__c;
            dblBZ20 = obj.BZ20__c;
            dblBT30 = obj.BT30__c;
            dblBT7 = obj.BT7__c;    
        }
                
        string strNCMTID = strNCMTIDs;
        strNCMTID = strNCMTID.substring(0,strNCMTID.length()-3); 
        
        List<NCMT_TCO_Performance_Input__c> PerfInputlst =[select id, NCMT_Project__r.Total_GSF__c,R_Energy_Roof__c, R_Energy_Wall__c,R_Energy_Site__c,Is_Non_Portable_Water_Available__c
                                                           from  NCMT_TCO_Performance_Input__c
                                                           where NCMT_Project__c = :strNCMTIDs];
        IF(PerfInputlst.size()>0){   
            tot_gsf = PerfInputlst[0].NCMT_Project__r.Total_GSF__c;
            dblroofmounted = PerfInputlst[0].R_Energy_Roof__c;
            dblwall = PerfInputlst[0].R_Energy_Wall__c;
            dblsite = PerfInputlst[0].R_Energy_Site__c;
               if(PerfInputlst[0].Is_Non_Portable_Water_Available__c == null){ 
                   dblportablewater = 0;
               }else{
                 dblportablewater = Math.Round(decimal.Valueof(PerfInputlst[0].Is_Non_Portable_Water_Available__c)*3.33)*30;
               }
            
            system.debug('dblportable=='+PerfInputlst[0].Is_Non_Portable_Water_Available__c);
            system.debug('dblportablewater=='+dblportablewater);
        }
        List<NCMT_Core_Shell_Cost_Detail__c>  coreShellDList = [Select ID, Name,Unit_Cost__c,Total_Units__c,Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c 
                                                                  From NCMT_Core_Shell_Cost_Detail__c
                                                                  where NCMT_Project_ID__c = :strNCMTID 
                                                                  and Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c in ('CC290','CC289','CC292','CC293','CC-27179',
                                                                                                                                              'CC-27180','CC-27181','CC-27199','CC-27200','CC-27202','CC-27203',
                                                                                                                                              'CC-27159','CC-27157','CC-27158','CC-27161','CC-27162','CC294','CC310',
                                                                                                                                              'CC311','CC312','CC-27155','CC-27156','CC-27182','CC257','CC258','CC21',
                                                                                                                                              'CC167','CC176','CC174','CC201','CC380','CC269','CC270','CC271','CC272','CC273',
                                                                                                                                              'CC295','CC296','CC297','CC305','CC-00410','CC-00405','CC-00398','CC-00399','CC-00403',
                                                                                                                                              'CC-00404','CC-00401','CC406','CC-00409','CC-00412','CC-00402','CC-00411','CC-00407',
                                                                                                                                              'CC-00397','CC-00400','CC345','CC346','CC347','CC348','CC349','CC350','CC351','CC352',
                                                                                                                                              'CC353','CC-00408','CC354')
                                                                   ];
       if(coreShellDList.size()>0){   
            for(NCMT_Core_Shell_Cost_Detail__c CList: coreShellDList ){
                
                coreshellmap.put(CList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c,CList.Total_Units__c);
            }
                                                                   
        
            for(NCMT_Core_Shell_Cost_Detail__c CSDList: coreShellDList ){
                
                //coreshellmap.put(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c,CSDList.Total_Units__c);
                        
                IF(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC290' ||
                  CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27200' ||
                  CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27157' ||
                  CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27158'){
                    CSDList.Total_Units__c= Math.Floor(dblBX7/50)*50;
                }else if(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC289' || 
                        CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27199' ||
                        CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27159'){
                    CSDList.Total_Units__c= dblBX13;
                }else if(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC292' ||
                        CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27202'){
                    CSDList.Total_Units__c= Math.Max(dblBW18,(Math.Ceil(tot_gsf*dblBZ20/(-3))*(-3))*0.1) ;
                }else if(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC293' ||
                        CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27203'){
                    CSDList.Total_Units__c= Math.Ceil(tot_gsf*dblBZ20/(-3))*(-3);
                }else if(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27179'){
                    CSDList.Total_Units__c= dblBT30 * dblroofmounted;
                }else if(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27180'){
                    CSDList.Total_Units__c= dblBT30 * dblwall;
                }else if(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27181'){
                    CSDList.Total_Units__c= dblBT30 * dblsite;
                }else if(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27161'){
                    CSDList.Total_Units__c= dblBW18 + (Math.Ceil(tot_gsf*dblBZ20/(-3))*(-3)) + coreshellmap.get('CC294') + coreshellmap.get('CC310') + coreshellmap.get('CC311') + coreshellmap.get('CC312');
                }else if(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27162'){
                    CSDList.Total_Units__c= dblBW18 + (Math.Ceil(tot_gsf*dblBZ20/(-3))*(-3)) + coreshellmap.get('CC294');
                }else if(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27155' ||
                        CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27156'){
                    CSDList.Total_Units__c= dblBT7/1000;
                }else if(CSDList.Core_Shell_Cost_Parameter__r.Core_Shell_Cost_Parameter_Identifier__c == 'CC-27182'){
                    system.debug('coreshellmap257=='+coreshellmap.get('CC257'));
                    system.debug('coreshellmap258=='+coreshellmap.get('CC258'));
                    CSDList.Total_Units__c= (coreshellmap.get('CC257') + coreshellmap.get('CC258') )  * dblportablewater ;
                }        
            }
               
            triggervalue.isPerformanceUpdate =true;
            update coreShellDList ;
       }
            
     }
        
    }
                                                                   
    }
}