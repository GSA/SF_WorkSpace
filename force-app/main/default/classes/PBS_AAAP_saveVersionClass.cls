public with sharing class PBS_AAAP_saveVersionClass{
    
    Static List<PBS_AAAP_RLP__c> rlpRecord = new List<PBS_AAAP_RLP__c>();
    Static List<PBS_AAAP_RLP__c> rlpIns = new List<PBS_AAAP_RLP__c>();
    Static List<PBS_AAAP_RLP__c> rlpUpd = new List<PBS_AAAP_RLP__c>();
    Static String newRlpId;
    Static String newRlpNo;
    Static String newRegionId;
    Static List<PBS_AAAP_Agency_Requirement__c> agReq = new List<PBS_AAAP_Agency_Requirement__c>();
    Static List<PBS_AAAP_Agency_Requirement__c> agencyReqIns = new List<PBS_AAAP_Agency_Requirement__c>();
    Static List<PBS_AAAP_Agency_Requirement__c> agencyReqUpd = new List<PBS_AAAP_Agency_Requirement__c>();
    Static Map<Id,List<PBS_AAAP_PolyObject__c>> mapAgPoly = new map<Id,List<PBS_AAAP_PolyObject__c>>();
    Static List<PBS_AAAP_PolyObject__c> listPoly = new List<PBS_AAAP_PolyObject__c>();
    //List<PBS_AAAP_PolyObject__c> listPolyFull = new List<PBS_AAAP_PolyObject__c>();
    //List<PBS_AAAP_PolyObject__c> listPolyIns = new List<PBS_AAAP_PolyObject__c>();
    Static Map<Id,List<PBS_AAAP_PolyPath__c>> mapPolyPath = new map<Id,List<PBS_AAAP_PolyPath__c>>();
    Static List<PBS_AAAP_PolyPath__c> listPath = new List<PBS_AAAP_PolyPath__c>();
    Static List<Id> polyIds = new List<Id>();
    Static List<Id> agIds = new List<Id>();
    Static List<PBS_AAAP_PolyPath__c> listPathIns = new List<PBS_AAAP_PolyPath__c>();
    Static Map<Id, List<PBS_AAAP_Space__c>> mapOffSpace = new Map<Id, List<PBS_AAAP_Space__c>>();
    Static Map<Id, List<PBS_AAAP_Rate__c>> mapSpaRates = new Map<Id, List<PBS_AAAP_Rate__c>>();
    Static List<PBS_AAAP_Space__c> spaceList = new List<PBS_AAAP_Space__c>();
    Static List<PBS_AAAP_Rate__c> rateList = new List<PBS_AAAP_Rate__c>();
    Static List<PBS_AAAP_Offer__c> offerList = new List<PBS_AAAP_Offer__c>();
    Static List<PBS_AAAP_Offer__c> lstInsOffer = new List<PBS_AAAP_Offer__c>();
    Static List<PBS_AAAP_Offer__c> lstUpdOffer = new List<PBS_AAAP_Offer__c>();
    Static List<PBS_AAAP_Space__c> lstInsSpace = new List<PBS_AAAP_Space__c>();
    Static List<PBS_AAAP_Rate__c> lstInsRates = new List<PBS_AAAP_Rate__c>();
    Static List<PBS_AAAP_Space__c> lstUpdSpace = new List<PBS_AAAP_Space__c>();
    Static List<PBS_AAAP_Rate__c> lstUpdRates = new List<PBS_AAAP_Rate__c>();

    public static string QueryStr(String ObjectName, String whereName, String recId, List<Id> Ids){
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
           if(s != 'lastvieweddate'
               && s != 'lastreferenceddate')
               query += ' ' + s + ',';
        }
    
        // Manually add related object's fields that are needed.
        //query += 'Account.Name,'; // modify as needed
        
        // Strip off the last comma if it exists.
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }
    
        // Add FROM statement
        query += ' FROM ' + objectName;
    
        // Add on a WHERE/ORDER/LIMIT statement as needed
        //query += ' WHERE Id =\'' + recId + '\''; // modify as needed
        if(recId != ''){
            query += ' WHERE ' + whereName + ' =\'' + recId + '\'';
        } else {
            String str = '(';
            for(Id i : Ids){
                str += '\''+i+'\'';
            }
            str += ')';
            str = str.replace('\'\'', '\',\'');
      
      // codition (19-feb-2019) i.e. if st is empty or () do not include in query
      if(str != '()') query += ' WHERE ' + whereName + ' IN' + str + '';
      
        
        }
        system.debug('*****'+query);
        /**
        try {
                agReq = database.query(query);
        } catch (QueryException e){
                //perform exception handling
        }
        **/
        return query;
    }
    
    public PBS_AAAP_saveVersionClass(){
    
    }

    /**
    public static void cloneRecords(Id recordId){
        
        
        PBS_AAAP_Agency_Requirement__c aReq = [SELECT ID, PBS_AAAP_Region__c, PBS_AAAP_RLP_Number__c FROM PBS_AAAP_Agency_Requirement__c WHERE Id =: recordId LIMIT 1];
        String regionId = aReq.PBS_AAAP_Region__c;
        String rlpId = aReq.PBS_AAAP_RLP_Number__c;
        
        PBS_AAAP_RLP__c rlpRecId = [SELECT Id FROM PBS_AAAP_RLP__c WHERE PBS_AAAP_RLP_Number__c =: rlpId AND PBS_AAAP_Region__c =: regionId LIMIT 1];
        
        rlpRecord = database.query(QueryStr('PBS_AAAP_RLP__c', 'Id', rlpRecId.Id, new List<Id>{}));
        
        for(PBS_AAAP_RLP__c rlp : rlpRecord){
            PBS_AAAP_RLP__c clonedRecord = rlp.clone(false,true,false,false);
            clonedRecord.PBS_AAAP_isActive__c = FALSE;
            clonedRecord.Is_Historical__c = TRUE;
            clonedRecord.Cloned_Date__c = system.now();
            clonedRecord.No_of_times_cloned__c = 0;
            clonedRecord.PBS_AAAP_STATUS__c = 'Posted/Active';
            clonedRecord.RLPExternalID__c = '';
            if(rlp.No_of_times_cloned__c == 0 || rlp.No_of_times_cloned__c == NULL){
                clonedRecord.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c +'-1';        
                rlp.No_of_times_cloned__c = 1;
            } else {
                Decimal x = rlp.No_of_times_cloned__c + 1;
                clonedRecord.PBS_AAAP_RLP_Number__c = rlp.PBS_AAAP_RLP_Number__c+'-'+x;
                rlp.No_of_times_cloned__c = rlp.No_of_times_cloned__c + 1;
            }  
            rlpIns.add(clonedRecord);   
            rlpUpd.add(rlp);
        }
        
        if(!rlpIns.isEmpty()){
            insert rlpIns;
            for(PBS_AAAP_RLP__c rlpi : rlpIns) {
                system.debug('*****'+rlpi.Id);
                newRlpNo = rlpi.PBS_AAAP_RLP_Number__c;
                newRlpId = rlpi.Id;
                newRegionId = rlpi.PBS_AAAP_Region__c;
                //rlpi.PBS_AAAP_STATUS__c = 'Posted/Active';
                //update rlpi;
            } 
        }
        
        if(!rlpUpd.isEmpty()){
            update rlpUpd;
        }
        
        agReq = database.query(QueryStr('PBS_AAAP_Agency_Requirement__c', 'Id', recordId, new List<Id>{}));
        
        for(PBS_AAAP_Agency_Requirement__c ag : agReq){
            agIds.add(ag.id);
        }
        
        listPoly = database.query(QueryStr('PBS_AAAP_PolyObject__c', 'PBS_AAAP_Agency_Requirement__c','', agIds));
        //listPoly = [SELECT Id, PBS_AAAP_Agency_Requirement__c FROM PBS_AAAP_PolyObject__c WHERE PBS_AAAP_Agency_Requirement__c =: agReq[0].Id];
        
        for(PBS_AAAP_PolyObject__c p : listPoly){
            polyIds.add(p.Id);
        }
        
        listPath = database.query(QueryStr('PBS_AAAP_PolyPath__c', 'Poly_Object__c', '', polyIds));
        system.debug('*****listPath'+listPath);
        
        for(PBS_AAAP_PolyPath__c pp: listPath){
            if(!mapPolyPath.containsKey(pp.Poly_Object__c))
                mapPolyPath.put(pp.Poly_Object__c, new list<PBS_AAAP_PolyPath__c>{pp});
            else
                mapPolyPath.get(pp.Poly_Object__c).add(pp);
        }
        system.debug('*****mapPolyPath'+mapPolyPath);
        
        for(PBS_AAAP_Agency_Requirement__c ag : agReq)
        {
            PBS_AAAP_Agency_Requirement__c clonedRecord = ag.clone(false,true,false,false);
            clonedRecord.Is_Historical__c = TRUE;
            clonedRecord.Cloned_Date__c = system.now();
            clonedRecord.No_of_times_cloned__c = 0;
            clonedRecord.PBS_AAAP_RLP_Number__c = newRlpNo;
            clonedRecord.Master_Agency_Requirement__c = ag.Id;
            if(ag.No_of_times_cloned__c == 0 || ag.No_of_times_cloned__c == NULL){
                clonedRecord.PBS_AAAP_Project_ID__c = ag.PBS_AAAP_Project_ID__c+'-1';        
                ag.No_of_times_cloned__c = 1;
            } else {
                Decimal x = ag.No_of_times_cloned__c + 1;
                clonedRecord.PBS_AAAP_Project_ID__c = ag.PBS_AAAP_Project_ID__c+'-'+x;
                ag.No_of_times_cloned__c = ag.No_of_times_cloned__c + 1;
            }   
            agencyReqIns.add(clonedRecord);   
            agencyReqUpd.add(ag);
        }
        
        if(!agencyReqIns.isEmpty()){
            insert agencyReqIns;
            Id newAgId;
            for(PBS_AAAP_Agency_Requirement__c ag : agencyReqIns) {
                system.debug('*****'+ag.Id);
                newAgId = ag.Id;
            }   
            for(PBS_AAAP_PolyObject__c po: listPoly){
                if(!mapAgPoly.containsKey(po.PBS_AAAP_Agency_Requirement__c))
                    mapAgPoly.put(po.PBS_AAAP_Agency_Requirement__c, new list<PBS_AAAP_PolyObject__c>{po});
                else
                    mapAgPoly.get(po.PBS_AAAP_Agency_Requirement__c).add(po);
            }
            system.debug('*****mapAgPoly'+mapAgPoly);
            
            for(List<PBS_AAAP_PolyObject__c> poly : mapAgPoly.values()){
                for(PBS_AAAP_PolyObject__c po : poly){
                    //listPolyFull = database.query(QueryStr('PBS_AAAP_PolyObject__c','PBS_AAAP_Agency_Requirement__c', po.PBS_AAAP_Agency_Requirement__c));
                    //for(PBS_AAAP_PolyObject__c pol : listPolyFull){
                    PBS_AAAP_PolyObject__c clonedRec = po.clone(false,true,false,false);
                    clonedRec.PBS_AAAP_Agency_Requirement__c = newAgId;
                    //listPolyIns.add(clonedRec);
                    insert clonedRec;
                    List<PBS_AAAP_PolyPath__c> ppList = mapPolyPath.get(po.Id);
                    Integer i = 0;
                    for(PBS_AAAP_PolyPath__c ppl : ppList){                
                        PBS_AAAP_PolyPath__c ppath = ppl.clone(false,true,false,false);
                        ppath.Poly_Object__c = clonedRec.Id;
                        listPathIns.add(ppath);
                        i++;
                    }
                    //}
                }
            }
        }
        if(!agencyReqUpd.isEmpty()){
            update agencyReqUpd;      
        }
        if(!listPathIns.isEmpty()){
            insert listPathIns;      
        }
        

        //PBS_AAAP_Offer__c offer = new PBS_AAAP_Offer__c();
        //offer.PBS_AAAP_RLP_Number__c = 'a08r0000006jvBG';
        //insert offer;

    }**/

    /**
    public static void cloneOffers(Set<Id> idList){
        system.debug('***NIK***'+idList);
        
        List<Id> lstIds = new List<Id>();
        lstIds.addAll(idList);
        offerList = database.query(QueryStr('PBS_AAAP_Offer__c', 'Id', '', lstIds));
        spaceList = database.query(QueryStr('PBS_AAAP_Space__c', 'PBS_AAAP_OFFER_NUMBER__c', '', lstIds));
        
        for(Id ids : idList){
            for(PBS_AAAP_Space__c sp : spaceList){
                if(sp.PBS_AAAP_OFFER_NUMBER__c == ids){
                    if(!mapOffSpace.containsKey(ids)){
                        mapOffSpace.put(ids, new list<PBS_AAAP_Space__c>{sp});
                    } else {
                        mapOffSpace.get(ids).add(sp);
                    }
                }
            }
        }
        
        List<Id> spaceIds = new List<Id>();
        for(PBS_AAAP_Space__c sp : spaceList){
            spaceIds.add(sp.Id);
        }
        
        rateList = database.query(QueryStr('PBS_AAAP_Rate__c', 'PBS_AAAP_SPACE__c', '', spaceIds));
        
        for(Id ids : spaceIds){
            for(PBS_AAAP_Rate__c rt : rateList){
                if(rt.PBS_AAAP_SPACE__c == ids){
                    if(!mapSpaRates.containsKey(ids)){
                        mapSpaRates.put(ids, new list<PBS_AAAP_Rate__c>{rt});
                    } else {
                        mapSpaRates.get(ids).add(rt);
                    }
                }
            }
        }
        
        system.debug('***Nik**Map1***'+mapOffSpace);
        system.debug('***Nik**Map2***'+mapSpaRates);
        system.debug('***Nik**ListSize***'+offerList.size());
        
        
        List<PBS_AAAP_Offer__c> cloneOffers = new List<PBS_AAAP_Offer__c>();
        List<PBS_AAAP_Space__c> cloneSpaces = new List<PBS_AAAP_Space__c>();
        List<PBS_AAAP_Rate__c> cloneRates = new List<PBS_AAAP_Rate__c>();
        
        for(PBS_AAAP_Offer__c off : offerList){
            PBS_AAAP_Offer__c newOffer = off.clone(false,true,false,false);
            newOffer.Is_Historical__c = TRUE;
            newOffer.Cloned_Date__c = system.now();
            newOffer.No_of_times_cloned__c = 0;
            newOffer.Master_Offer__c = off.Id;
            newOffer.OfferExternalId__c = '';
            newOffer.PBS_AAAP_RLP_Number__c = newRlpId;
            //lstInsOffer.add(newOffer);
            
            //insert newOffer;          
            cloneOffers.add(newOffer);
            
            if(off.No_of_times_cloned__c == 0 || off.No_of_times_cloned__c == NULL){       
                off.No_of_times_cloned__c = 1;
            } else {
                off.No_of_times_cloned__c = off.No_of_times_cloned__c + 1;
            } 
            lstUpdOffer.add(off);
            List<PBS_AAAP_Space__c> childSpace = new List<PBS_AAAP_Space__c>();
            childSpace = mapOffSpace.get(off.Id);
            for(PBS_AAAP_Space__c sp : childSpace){
                PBS_AAAP_Space__c newSpace = sp.clone(false,true,false,false);
                newSpace.Is_Historical__c = TRUE;
                newSpace.Cloned_Date__c = system.now();
                newSpace.No_of_times_cloned__c = 0;
                
                //newSpace.PBS_AAAP_OFFER_NUMBER__c = newOffer.Id;
                newSpace.PBS_AAAP_OFFER_NUMBER__r = newOffer;
                
                newSpace.SpaceExternalId__c = '';
                //lstInsSpace.add(newSpace);
                
                //insert newSpace;
                cloneSpaces.add(newSpace);
                
                if(sp.No_of_times_cloned__c == 0 || sp.No_of_times_cloned__c == NULL){       
                    sp.No_of_times_cloned__c = 1;
                } else {
                    sp.No_of_times_cloned__c = sp.No_of_times_cloned__c + 1;
                } 
                lstUpdSpace.add(sp);
                List<PBS_AAAP_Rate__c> childRate = new List<PBS_AAAP_Rate__c>();
                childRate = mapSpaRates.get(sp.Id);
                for(PBS_AAAP_Rate__c rt : childRate){
                    system.debug('***Nik**Rates***'+rt.Id);
                    PBS_AAAP_Rate__c newRate = rt.clone(false,true,false,false);
                    newRate.Is_Historical__c = TRUE;
                    newRate.Cloned_Date__c = system.now();
                    newRate.No_of_times_cloned__c = 0;
                    
                    //newRate.PBS_AAAP_SPACE__c = newSpace.Id;
                    //newRate.PBS_AAAP_OFFER_NUMBER__c = newOffer.Id;
                    newRate.PBS_AAAP_SPACE__r = newSpace;
                    newRate.PBS_AAAP_OFFER_NUMBER__r = newOffer;
                    
                    newRate.RateExternalId__c = '';
                    //lstInsRates.add(newRate);
                    if(rt.No_of_times_cloned__c == 0 || rt.No_of_times_cloned__c == NULL){    
                        newRate.Name = rt.Name+'-1';   
                        rt.No_of_times_cloned__c = 1;
                    } else {
                        Decimal x = rt.No_of_times_cloned__c + 1;
                        newRate.Name = rt.Name+'-'+x;
                        rt.No_of_times_cloned__c = rt.No_of_times_cloned__c + 1;
                    } 
                    
                    //insert newRate;
                    cloneRates.add(newRate);                    
                    lstUpdRates.add(rt);
                }
            }
        }
        
        // inserting clone records
        if(!cloneOffers.isEmpty()){
            insert cloneOffers;
            
            // updating the id in spaces
            for(PBS_AAAP_Space__c space : cloneSpaces){
                space.PBS_AAAP_OFFER_NUMBER__c = space.PBS_AAAP_OFFER_NUMBER__r.Id;
                space.PBS_AAAP_OFFER_NUMBER__r = null;
            }
            
            // updating id from rates
            for(PBS_AAAP_Rate__c rate : cloneRates){
                rate.PBS_AAAP_OFFER_NUMBER__c = rate.PBS_AAAP_OFFER_NUMBER__r.Id;
                rate.PBS_AAAP_OFFER_NUMBER__r = null;
            }
            
            // inserting space
            if(!cloneSpaces.isEmpty()){
                insert cloneSpaces;
            }
            
            // adding space id          
            for(PBS_AAAP_Rate__c rate : cloneRates){
                rate.PBS_AAAP_SPACE__c = rate.PBS_AAAP_SPACE__r.Id;
                rate.PBS_AAAP_SPACE__r = null;
            }
            
            // inserting rates
            if(!cloneRates.isEmpty()){
                insert cloneRates;
            }
            
        }
        
        if(!lstUpdOffer.isEmpty()){
            update lstUpdOffer;
        }
        
        if(!lstUpdSpace.isEmpty()){
            update lstUpdSpace;
        }
        
        if(!lstUpdRates.isEmpty()){
            update lstUpdRates;
        }
        
    }
    **/
    
    public static void cloneOffers2(Set<Id> idList, Id recordId){
        system.debug('***NIK***'+idList);
        
        // this will save the new list of the PBS_AAAP_Offer_Attachments to to be inserted
        List<PBS_AAAP_Offer_Attachments__c> lstNewOfferAtt = new List<PBS_AAAP_Offer_Attachments__c>();
        
        // this will save the list of attachment to be inserted
        List<ContentDocumentLink> lstNewAttachment = new  List<ContentDocumentLink>();
        
        // this will save the ids of new records for offer attachment and the attachment records
        map<string,List<PBS_AAAP_Offer_Attachments__c>> mapOfferAtt = new map<string,List<PBS_AAAP_Offer_Attachments__c>>();
        
        // getting the list of the offer attachment
        List<Id> setOfferAttIds = new List<Id>();
        
        // saving the attachment records
        map<string,List<ContentDocumentLink>> mapAttAttDetails = new map<string,List<ContentDocumentLink>>();
        
        PBS_AAAP_Offer_History__c oh = new PBS_AAAP_Offer_History__c();
        oh.PBS_AAAP_Agency_Requirement__c = recordId;
        oh.PBS_AAAP_Cloned_Date_Time__c = String.valueOf(System.now().format());

        List<Id> lstIds = new List<Id>();
        lstIds.addAll(idList);
        system.debug('\n--lstIds--'+lstIds);
        offerList = database.query(QueryStr('PBS_AAAP_Offer__c', 'Id', '', lstIds));
        spaceList = database.query(QueryStr('PBS_AAAP_Space__c', 'PBS_AAAP_OFFER_NUMBER__c', '', lstIds));
        List<PBS_AAAP_Offer_Attachments__c> lstOfferAtt = database.query(QueryStr('PBS_AAAP_Offer_Attachments__c', 'PBS_AAAP_Offer__c', '', lstIds));
        system.debug('\n--lstOfferAtt--'+lstOfferAtt);
        
        // getting the list of the offer attachmentids to query the attachment
        for(PBS_AAAP_Offer_Attachments__c offerAtt : lstOfferAtt){
            setOfferAttIds.add(offerAtt.Id);
            List<PBS_AAAP_Offer_Attachments__c> lstTemp = new List<PBS_AAAP_Offer_Attachments__c>();
            lstTemp.add(offerAtt);
            if(mapOfferAtt.containsKey(offerAtt.PBS_AAAP_Offer__c)){
                lstTemp.addAll(mapOfferAtt.get(offerAtt.PBS_AAAP_Offer__c));
            }
            mapOfferAtt.put(offerAtt.PBS_AAAP_Offer__c,lstTemp);
            
        }
        system.debug('\n--mapOfferAtt--'+mapOfferAtt);
        
        // getting attachment
        List<ContentDocumentLink> lstAtt = database.query(QueryStr('ContentDocumentLink', 'LinkedEntityId', '', setOfferAttIds));
        system.debug('\n--lstAtt--'+lstAtt);
        
        // getting the list of the offer attachmentids to query the attachment
        for(ContentDocumentLink offerAtt : lstAtt){            
            List<ContentDocumentLink> lstTemp = new List<ContentDocumentLink>();
            lstTemp.add(offerAtt);
            if(mapAttAttDetails.containsKey(offerAtt.LinkedEntityId)){
                lstTemp.addAll(mapAttAttDetails.get(offerAtt.LinkedEntityId));
            }
            mapAttAttDetails.put(offerAtt.LinkedEntityId,lstTemp);            
        }
        system.debug('\n--mapAttAttDetails--'+mapAttAttDetails);
        
        for(Id ids : idList){
            for(PBS_AAAP_Space__c sp : spaceList){
                if(sp.PBS_AAAP_OFFER_NUMBER__c == ids){
                    if(!mapOffSpace.containsKey(ids)){
                        mapOffSpace.put(ids, new list<PBS_AAAP_Space__c>{sp});
                    } else {
                        mapOffSpace.get(ids).add(sp);
                    }
                }
            }
        }

        List<Id> spaceIds = new List<Id>();
        for(PBS_AAAP_Space__c sp : spaceList){
            spaceIds.add(sp.Id);
        }
        rateList = database.query(QueryStr('PBS_AAAP_Rate__c', 'PBS_AAAP_SPACE__c', '', spaceIds));

        for(Id ids : spaceIds){
            for(PBS_AAAP_Rate__c rt : rateList){
                if(rt.PBS_AAAP_SPACE__c == ids){
                    if(!mapSpaRates.containsKey(ids)){
                        mapSpaRates.put(ids, new list<PBS_AAAP_Rate__c>{rt});
                    } else {
                        mapSpaRates.get(ids).add(rt);
                    }
                }
            }
        }

        system.debug('***Nik**Map1***'+mapOffSpace);
        system.debug('***Nik**Map2***'+mapSpaRates);
        system.debug('***Nik**ListSize***'+offerList.size());


        List<PBS_AAAP_Offer__c> cloneOffers = new List<PBS_AAAP_Offer__c>();
        List<PBS_AAAP_Space__c> cloneSpaces = new List<PBS_AAAP_Space__c>();
        List<PBS_AAAP_Rate__c> cloneRates = new List<PBS_AAAP_Rate__c>();

        for(PBS_AAAP_Offer__c off : offerList){
            PBS_AAAP_Offer__c newOffer = off.clone(false,true,false,false);
            newOffer.Is_Historical__c = TRUE;
            newOffer.Cloned_Date__c = system.now();
            newOffer.No_of_times_cloned__c = 0;
            newOffer.Master_Offer__c = off.Id;
            newOffer.OfferExternalId__c = '';
            newOffer.PBS_AAAP_RLP_Number__c = off.PBS_AAAP_RLP_Number__c;
            //lstInsOffer.add(newOffer);

            //insert newOffer;
            cloneOffers.add(newOffer);
            
            // making reference to the attached offer
            if(mapOfferAtt.containsKey(off.Id)){
                
                // list of offer letter
                List<PBS_AAAP_Offer_Attachments__c> lstOfferLetters = mapOfferAtt.get(off.Id);
                system.debug('\n--lstOfferLetters--'+lstOfferLetters);
                
                // for each offer attachment make clone
                for(PBS_AAAP_Offer_Attachments__c offerAtt : lstOfferLetters){
                    PBS_AAAP_Offer_Attachments__c newOfferAtt = offerAtt.clone(false,true,false,false);
                    
                    // mapping to new offer
                    newOfferAtt.PBS_AAAP_Offer__r = newOffer;
                    
                    // saving source Rec Id
                    newOfferAtt.Cloned_From__c = offerAtt.Id;
                    
                    // adding to the list
                    lstNewOfferAtt.add(newOfferAtt);
                    
                    /***
                    // cloning attachments
                    if(mapAttAttDetails.containsKey(offerAtt.Id)){
                        
                        // getting attachment
                        List<attachment> lstAttachmentRecs = mapAttAttDetails.get(offerAtt.Id);
                        
                        // close each recordId
                        for(attachment attc : lstAttachmentRecs){
                            attachment newAtt = attc.clone(false,true,false,false);
                            newAtt.Parent = offerAtt;
                            
                            // adding to insert List
                            lstNewAttachment.add(newAtt);
                        }
                    }
                    **/
                }
            }

            if(off.No_of_times_cloned__c == 0 || off.No_of_times_cloned__c == NULL){
                off.No_of_times_cloned__c = 1;
            } else {
                off.No_of_times_cloned__c = off.No_of_times_cloned__c + 1;
            }
            lstUpdOffer.add(off);
            List<PBS_AAAP_Space__c> childSpace = new List<PBS_AAAP_Space__c>();
            childSpace = mapOffSpace.get(off.Id);
            for(PBS_AAAP_Space__c sp : childSpace){
                PBS_AAAP_Space__c newSpace = sp.clone(false,true,false,false);
                newSpace.Is_Historical__c = TRUE;
                newSpace.Cloned_Date__c = system.now();
                newSpace.No_of_times_cloned__c = 0;
                newSpace.PBS_AAAP_Master_Space__c = sp.Id;

                //newSpace.PBS_AAAP_OFFER_NUMBER__c = newOffer.Id;
                newSpace.PBS_AAAP_OFFER_NUMBER__r = newOffer;

                newSpace.SpaceExternalId__c = '';
                //lstInsSpace.add(newSpace);

                //insert newSpace;
                cloneSpaces.add(newSpace);

                if(sp.No_of_times_cloned__c == 0 || sp.No_of_times_cloned__c == NULL){
                    sp.No_of_times_cloned__c = 1;
                } else {
                    sp.No_of_times_cloned__c = sp.No_of_times_cloned__c + 1;
                }
                lstUpdSpace.add(sp);
                List<PBS_AAAP_Rate__c> childRate = new List<PBS_AAAP_Rate__c>();
                childRate = mapSpaRates.get(sp.Id);
                for(PBS_AAAP_Rate__c rt : childRate){
                    system.debug('***Nik**Rates***'+rt.Id);
                    PBS_AAAP_Rate__c newRate = rt.clone(false,true,false,false);
                    newRate.Is_Historical__c = TRUE;
                    newRate.Cloned_Date__c = system.now();
                    newRate.No_of_times_cloned__c = 0;

                    //newRate.PBS_AAAP_SPACE__c = newSpace.Id;
                    //newRate.PBS_AAAP_OFFER_NUMBER__c = newOffer.Id;
                    newRate.PBS_AAAP_SPACE__r = newSpace;
                    newRate.PBS_AAAP_OFFER_NUMBER__r = newOffer;

                    newRate.RateExternalId__c = '';
                    //lstInsRates.add(newRate);
                    if(rt.No_of_times_cloned__c == 0 || rt.No_of_times_cloned__c == NULL){
                        newRate.Name = rt.Name+'-1';
                        rt.No_of_times_cloned__c = 1;
                    } else {
                        Decimal x = rt.No_of_times_cloned__c + 1;
                        newRate.Name = rt.Name+'-'+x;
                        rt.No_of_times_cloned__c = rt.No_of_times_cloned__c + 1;
                    }

                    //insert newRate;
                    cloneRates.add(newRate);
                    lstUpdRates.add(rt);
                }
            }
        }

        String offIdsString = '';

        // inserting clone records
        if(!cloneOffers.isEmpty()){
            insert cloneOffers;
            
            // update offer if in offer attachment
            for(PBS_AAAP_Offer_Attachments__c offerAtt : lstNewOfferAtt){
                offerAtt.PBS_AAAP_Offer__c = offerAtt.PBS_AAAP_Offer__r.Id;
                offerAtt.PBS_AAAP_Offer__r = null;
            }
            system.debug('\n--lstNewOfferAtt--'+lstNewOfferAtt+'\n--mapAttAttDetails--'+mapAttAttDetails);
            insert lstNewOfferAtt;
            
            // cloning attachments
            for(PBS_AAAP_Offer_Attachments__c offerAtt : lstNewOfferAtt){
                
                if(mapAttAttDetails.containsKey(offerAtt.Cloned_From__c)){
                
                    // getting attachment
                    List<ContentDocumentLink> lstAttachmentRecs = mapAttAttDetails.get(offerAtt.Cloned_From__c);
                    
                    // close each recordId
                    for(ContentDocumentLink attc : lstAttachmentRecs){
                        ContentDocumentLink newAtt = new ContentDocumentLink();                       
                        newAtt.LinkedEntityId = offerAtt.Id;
                        newAtt.ContentDocumentId = attc.ContentDocumentId;
                        newAtt.ShareType = attc.ShareType;
                        newAtt.Visibility  = attc.Visibility ;
                       
                        lstNewAttachment.add(newAtt);
                        system.debug('\n--newAtt--'+newAtt);
                    }
                }
            }
            system.debug('\n---lstNewAttachment---'+lstNewAttachment+'\n--Total--'+lstNewAttachment.size());
            insert lstNewAttachment;
           
        
            // updating the id in spaces
            for(PBS_AAAP_Space__c space : cloneSpaces){
                space.PBS_AAAP_OFFER_NUMBER__c = space.PBS_AAAP_OFFER_NUMBER__r.Id;
                space.PBS_AAAP_OFFER_NUMBER__r = null;
            }

            // updating id from rates
            for(PBS_AAAP_Rate__c rate : cloneRates){
                rate.PBS_AAAP_OFFER_NUMBER__c = rate.PBS_AAAP_OFFER_NUMBER__r.Id;
                rate.PBS_AAAP_OFFER_NUMBER__r = null;
            }

            // inserting space
            if(!cloneSpaces.isEmpty()){
                insert cloneSpaces;
            }

            // adding space id
            for(PBS_AAAP_Rate__c rate : cloneRates){
                rate.PBS_AAAP_SPACE__c = rate.PBS_AAAP_SPACE__r.Id;
                rate.PBS_AAAP_SPACE__r = null;
            }

            // inserting rates
            if(!cloneRates.isEmpty()){
                insert cloneRates;
            }


            for(PBS_AAAP_Offer__c off : cloneOffers){
                if(offIdsString == ''){
                    offIdsString = off.Id;
                } else {
                    offIdsString = offIdsString + ',' + off.Id;
                }
            }
        }

        oh.PBS_AAAP_Offer_Ids__c = offIdsString;
        insert oh;


        if(!lstUpdOffer.isEmpty()){
            update lstUpdOffer;
        }

        if(!lstUpdSpace.isEmpty()){
            update lstUpdSpace;
        }

        if(!lstUpdRates.isEmpty()){
            update lstUpdRates;
        }

    }
    
}