public with sharing class PBS_AAAP_AgencyRequirementShape {
    public String polyName { get; set; }                                                                // String to store the name of the polygon being saved for the user defined area
    public PBS_AAAP_Agency_Requirement__c currentObj;                            // Object instance to store the agency requirement information
    private ApexPages.StandardController stdController;                            // Instance of standard controller
    public String agncyID { get; set; }                                                                    // String to store the agency ID
    public String polyID { get; set; }                                                                    // String to store the polygon ID
    public String shape { get; set; }                                                                        // String to store the JSON representation of a polygon
    public PBS_AAAP_PolyObject__c polyShape;                                            // Poly Object to store the shape that was drawn by the user
    public String favPoly {get; set;}
    public String selectedFavPoly {get; set;}
    public String pId {get; set;}

    /*      local classes for use with generating JSON  */

    // class to represent the individual paths of a polygon
    public class PolygonPath {
        String index;
        String lat;
        String lng;

        public PolygonPath(Decimal pIndex, Decimal pLat, Decimal pLng) {
            index = pIndex.toPlainString();
            lat = pLat.toPlainString();
            lng = pLng.toPlainString();
        } // end constructor

        public PolygonPath() {
        }    // end constructor
    }    // end PolygonPaths


    // class to represent the polygon comprised of paths
    public class Polygon {
        List<PolygonPath> paths;

        public Polygon(List<PolygonPath> pPaths) {
            paths = pPaths;
        }    // end constructor

        public Polygon() {
        }        // end constructor
    }    // end Polygon


    // class to represent the circle
    public class Circle {
        PolygonPath path;            // circle's center point is stored as a point coordinate in the path
        Decimal radius;

        public Circle(Decimal pRadius, PolygonPath pPath) {
            radius = pRadius;
            path = pPath;
        }    // end constructor

        public Circle() {
        }    // end constructor

    }    // end Circle


    /* Constructor */
    public PBS_AAAP_AgencyRequirementShape(ApexPages.StandardController stdController) {
        this.stdController = stdController;
        this.polyID = ApexPages.currentPage().getParameters().get('polyId');
        System.debug('****** this.polyID: ' + this.polyID);

        if (ApexPages.currentPage().getParameters().containsKey('polyName')) {        // cannot use urlDecode on null values, so must check if key exists
            this.polyName = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('polyName'), 'UTF-8');
            System.debug('****** this.polyName: ' + this.polyName);
        }    // end if
        this.currentObj = (PBS_AAAP_Agency_Requirement__c) stdController.getRecord();
        this.agncyID = currentObj.Id;

        // determine if there is a polygon to render
        if (this.polyId != null && this.polyId.length() > 0) {
            List<PBS_AAAP_PolyPath__c> polyPaths = [SELECT p.ID, p.Poly_Object__c, p.longitude__c, p.latitude__c, p.Path_Index__c FROM PBS_AAAP_PolyPath__c p WHERE p.Poly_Object__c = :polyID];
            List<PolygonPath> pPaths = new List<PolygonPath>();
            this.polyShape = [SELECT p.Polygon_Type__c, p.PBS_AAAP_legacy_id__c, p.PBS_AAAP_Shape_Type__c, p.PBS_AAAP_Circle_Radius__c, p.PBS_AAAP_Agency_Requirement__c, p.Name, p.Id, p.PBS_AAAP_Saved_to_favorites__c FROM PBS_AAAP_PolyObject__c p WHERE p.id = :polyID];
            System.debug('****** polyShape: ' + polyShape);

            System.debug('****** favPoly: ' + this.polyShape.PBS_AAAP_Saved_to_favorites__c);
            System.debug('****** favPoly: ' + String.valueOf(this.polyShape.PBS_AAAP_Saved_to_favorites__c));

            //JK changed 1.21.21: solution to the issue of the 'Favorites' checkbox not being checked on page load: I have removed the if/else logic. When page loads, should always set the favPoly to the value of the field in SF. 
            //JK changed back to original functionality 1.29.21
            //favPoly = String.valueOf(this.polyShape.PBS_AAAP_Saved_to_favorites__c);

            if(ApexPages.currentPage().getParameters().get('copy') == 'true'){
                //maybe use logic here to set ANOTHER variable??
                System.debug('****** isTRUE: ');
                favPoly = 'false';//JK if a template(copy) is loaded, then false? 
            } else {
                System.debug('****** isFALSE: ');
                favPoly = String.valueOf(this.polyShape.PBS_AAAP_Saved_to_favorites__c);
            }
      
            System.debug('****** favPoly: ' + favPoly);
            System.debug('JK favPoly on load ' + favPoly);

            // create the paths
            for (PBS_AAAP_PolyPath__c path : polyPaths) {
                PolygonPath pPath = new PolygonPath(path.Path_Index__c, path.latitude__c, path.longitude__c);
                pPaths.add(pPath);
            }    // end for
            System.debug('****** pPaths: ' + pPaths);


            // determine the type of shape
            if (this.polyShape.PBS_AAAP_Shape_Type__c == 'circle') {
                Circle circleToJSON = new Circle(polyshape.PBS_AAAP_Circle_Radius__c, pPaths.get(0));
                // generate the JSON
                JSONGenerator jsonGen = JSON.createGenerator(true);
                jsonGen.writeStartObject();
                jsonGen.writeFieldName(polyShape.PBS_AAAP_Shape_Type__c);
                jsonGen.writeObject(circleToJSON);
                jsonGen.writeEndObject();

                this.shape = jsonGen.getAsString();
                System.debug('****** shape: ' + this.shape);

            } else {
                // create the polygon
                Polygon poly = new Polygon(pPaths);

                // generate the JSON
                JSONGenerator jsonGen = JSON.createGenerator(true);
                jsonGen.writeStartObject();
                jsonGen.writeFieldName(polyShape.PBS_AAAP_Shape_Type__c);
                jsonGen.writeObject(poly);
                jsonGen.writeEndObject();

                this.shape = jsonGen.getAsString();
                System.debug('****** shape: ' + this.shape);
            }    // end if

            system.debug('***** paths:'+shape);

        } else {
            this.shape = 'false';
            favPoly = 'false';//favPoly = 'fasle';//JK fixed misspelling 1.21.21. This misspelling was causing the User Delineated Area section to load without getting the current value of the checkbox.
        }    //end if


        System.debug('****** currentObj: ' + this.currentObj);
    }    // end constructor

    // action to return to the agency requirement edit page
    public PageReference backToAgncyReq() {
        PageReference pg = Page.PBS_AAAP_AgencyRequirementEdit;
        pg.getParameters().put('id', currentObj.Id);
        pg.getParameters().put('polyId', this.polyID);
        pg.getParameters().put('polyName', EncodingUtil.urlEncode(this.polyName, 'UTF-8'));//here is using the polyName it came in with?
        pg.setRedirect(true);
        return pg;
    }    // end backToAgncyReq

    // ESRI - action to return to the agency requirement edit page
    @RemoteAction
    public static String backToAgncyReq(String pAgncyReqId, String pPolyID, String pPolyName) {
        System.debug('Remote: ' + pAgncyReqId + ' , ' + pPolyID + ' , ' + pPolyName);
        PageReference pg = Page.PBS_AAAP_AgencyRequirementEdit;
        pg.getParameters().put('id', pAgncyReqId);
        pg.getParameters().put('polyId', pPolyID);
        pg.getParameters().put('polyName', EncodingUtil.urlEncode(pPolyName, 'UTF-8'));
        System.debug('base url: ' + URL.getSalesforceBaseUrl().toExternalForm());
        System.debug(pg.getUrl());
        String returnUrl = URL.getSalesforceBaseUrl().toExternalForm() + pg.getUrl();
        System.debug(returnUrl);
        return returnUrl;
    }   // end backToAgncyReq

    // action to return to the agency requirement edit page through a cancel process
    public PageReference cancelBackToAgncyReq() {
        PageReference pg = Page.PBS_AAAP_AgencyRequirementEdit;
        pg.getParameters().put('id', currentObj.Id);
        if (this.polyID != null) {
            pg.getParameters().put('polyId', this.polyId);
        }
        if (this.polyName != null) {
            pg.getParameters().put('polyName', EncodingUtil.urlEncode(this.polyName, 'UTF-8'));
        }
        pg.setRedirect(true);
        return pg;
    }


    // action to save the polygon values
    @RemoteAction
    public static List<String> savePoly(String pAgncyReqId, String pPolyID, String pShapeType, String pPolyName, List<String> pPaths, String pCircleRadius, String pFav, String isCopy) {
        Savepoint sp0 = Database.setSavepoint();        // generate a save point for rollback purposes
        List<String> results = new String[3];
        system.debug('JK pAgncyReqId: ' + pAgncyReqId);
        system.debug('JK pPolyID: ' + pPolyID);
        system.debug('JK pShapeType: ' + pShapeType);
        system.debug('JK pPolyName: ' + pPolyName);
        system.debug('JK pPaths: ' + pPaths);
        system.debug('JK pCircleRadius: ' + pCircleRadius);
        system.debug('JK isCopy ' + isCopy);

        // determine if we should be modifying an exising polygon or creating a new polygon
        try {
            Boolean errFlag = FALSE;
            system.debug('JK isCopy '+isCopy);
            system.debug('JK pFav '+pFav);
            List<PBS_AAAP_PolyObject__c> polyNames = new List<PBS_AAAP_PolyObject__c>();
            
            //JK: HERE IT IS MATCHING NAME. If the user does not change the name, HERE is where is grabs the polyID of the matching polygon name and then doesn't create a new one, but upserts
            // code added on 09-March
            polyNames = [SELECT Id FROM PBS_AAAP_PolyObject__c WHERE Name = :pPolyName AND PBS_AAAP_Saved_to_favorites__c = TRUE];
            System.debug('JK polyNames ' + polyNames);
            // if id is not passed then send the id
            if(string.isBlank(pPolyID)
                && !polyNames.isEmpty()){
                pPolyID = polyNames[0].Id;//JK  Why is it hardcoded to the first in the list??
                System.debug('JK pPolyID is blank and pPolyID is set to first polyNames returned from query ' + pPolyId);
            }
            
            //JK Why is this commented out??
            /**
            commented on 09-March-2020
            if(isCopy == 'true' && pFav == 'true'){                
                polyNames = [SELECT Id FROM PBS_AAAP_PolyObject__c WHERE Name = :pPolyName AND PBS_AAAP_Saved_to_favorites__c = TRUE];
                
                
                if(polyNames.size() > 0){
                    errFlag = TRUE;
                    results.set(0, 'failed');
                    results.set(1, 'A user delineated area with the same name has already been saved to AAAP favorites. Please enter an alternate name');
                    results.set(2, '');
                }
                
            }
            **/
            
            //JK changed 1.21.21: using the polyPaths to INSERT a NEW PBS_AAAP_PolyObject__c WITHOUT using the ID of the queried one
            if(!errFlag) {
                //I think that if it is new, the pPolyId is empty. If it is a copy and the name is changed, it creates a new polygon. If it is a copy and the name is NOT changed, then it MODIFIES.
                System.debug('JK pPolyID.length(): ' + pPolyID.length() + ' isCopy: ' + isCopy);
                System.debug('JK pPolyId ' + pPolyId);
      
                //polyID is populated AND isCopy = false:
                if (pPolyID.length() > 0 && isCopy != 'true') { // modification
                    //JK goes into here if isCopy is FALSE, issue here:
                    System.debug('JK Block 1');
                    System.debug('JK polyId.length is greater than 0 and isCopy is NOT true - a polygon exists for this AG already');
                    // a polygon exists for this agency requirement, so we must insure that we operate using those paths
                    List<PBS_AAAP_PolyPath__c> polyPaths = [SELECT p.ID, p.Poly_Object__c, p.longitude__c, p.latitude__c FROM PBS_AAAP_PolyPath__c p WHERE p.Poly_Object__c = :pPolyID];
                    system.debug('\n--polyPaths--'+polyPaths);
                    System.debug('JK polyPaths ' + polyPaths);
                    if (pPolyName.length() > 0) {
                        
                        // prepare the Poly Objects information with the information from the web page function
                   	//JK commented out 1.21.21
                        /*PBS_AAAP_PolyObject__c pObj = new PBS_AAAP_PolyObject__c(Name = pPolyName,
                                ID = pPolyID,
                                PBS_AAAP_Shape_Type__c = pShapeType,
                                PBS_AAAP_Saved_to_favorites__c = Boolean.valueOf(pFav),
                                PBS_AAAP_Circle_Radius__c = Decimal.valueOf(pCircleRadius).setScale(4));
                        system.debug('***** pObj: ' + pObj);  
                        upsert pObj;
                       */
                        //JK changed 2.21.20 removing ID and replacing w/insert. What does this do? Instead of reassigning a polygon that another AR is using to the CURRENT AR (and therefore eliminating that lookup relationship between the other AR and the polygon have), we are now creating a NEW polygon with the same polypath(map points) to go with this current AR. But MUST CHANGE THE NAME!
                        //2.1 added field lookup to AR: PBS_AAAP_Agency_Requirement__c = pAgncyReqId,added ID 2.2 ID = pPolyID,
                        PBS_AAAP_PolyObject__c pObj = new PBS_AAAP_PolyObject__c(Name = pPolyName,
                                PBS_AAAP_Agency_Requirement__c = pAgncyReqId,
                                ID = pPolyID,
                                PBS_AAAP_Shape_Type__c = pShapeType,
                                PBS_AAAP_Saved_to_favorites__c = Boolean.valueOf(pFav),
                                PBS_AAAP_Circle_Radius__c = Decimal.valueOf(pCircleRadius).setScale(4));
                        system.debug('JK new pObj before insert: ' + pObj); 
                        //2.1 changed here from insert to update. 
                        update pObj;
                        
                        //need logic for update

                        List<PBS_AAAP_PolyPath__c> polyPathData = new List<PBS_AAAP_PolyPath__c>();

                        for (String i : pPaths) {
                            system.debug('##### i (pre-split): ' + i);
                            i = i.replaceAll('\\[', '');
                            i = i.replaceAll('\\]', '');
                            List<String> str = i.split('\\*', 0) ;


                            system.debug('##### i (post-split): ' + str);
                            String ind = str[0];
                            Decimal lat = Decimal.valueOf(str[1]);
                            system.debug('##### lat: ' + lat);
                            Decimal lng = Decimal.valueOf(str[2]);
                            system.debug('##### lng: ' + lng);

                            polyPathData.add(new PBS_AAAP_PolyPath__c(Path_Index__c = Decimal.valueOf(ind), latitude__c = lat.setScale(15), longitude__c = lng.setScale(15), Poly_Object__c = pObj.Id));
                        } // end for

                        upsert polyPathData; // new path data

                        delete polyPaths; // remove the old paths data

                        results.set(0, 'success'); // indicate success
                        results.set(1, pObj.Id); // pass the polygon ID back to the JS
                        results.set(2, pObj.Name); // pass the polygon Name back to the JS

                    } else {
                        results.set(0, 'failed');
                        results.set(1, 'Please enter a shape name.');
                        results.set(2, '');
                    } // end if

                } else { // creation of new
                    //JK either poly ID is not populated OR isCopy is true. Goes in here if isCopy is TRUE, working
                    System.debug('JK gets here if pPolyID.length() not equal to 0 && isCopy != true: if it IS a copy ');
                    System.debug('JK Block 2');
                    if (pPolyName.length() > 0) {
                        string recId = null;
                        if(!polyNames.isEmpty()){
                            recId= polyNames[0].Id;
                        }
                        // prepare the Poly Objects information with the information from the web page function
                        PBS_AAAP_PolyObject__c pObj = new PBS_AAAP_PolyObject__c(Name = pPolyName,
                                PBS_AAAP_Agency_Requirement__c = pAgncyReqId,
                                PBS_AAAP_Shape_Type__c = pShapeType,
                                PBS_AAAP_Saved_to_favorites__c = Boolean.valueOf(pFav),
                                PBS_AAAP_Circle_Radius__c = Decimal.valueOf(pCircleRadius).setScale(4),
                                Polygon_Type__c = 'User Defined',Id = recId);
                        system.debug('----pObj: ' + pObj);
                        upsert pObj;
                        
                        List<PBS_AAAP_PolyPath__c> polyPaths = [SELECT p.ID, p.Poly_Object__c, p.longitude__c, p.latitude__c FROM PBS_AAAP_PolyPath__c p WHERE p.Poly_Object__c = :recId];
                        system.debug('\n--polyPaths--'+polyPaths);
                        if(!polyPaths.isEmpty()){
                            delete polyPaths;
                        }

                        List<PBS_AAAP_PolyObject__c> lstDelPoly = new List<PBS_AAAP_PolyObject__c>();
                        List<PBS_AAAP_PolyObject__c> lstUpdPoly = new List<PBS_AAAP_PolyObject__c>();
                        for (PBS_AAAP_PolyObject__c dPoly : [SELECT Id, PBS_AAAP_Saved_to_favorites__c FROM PBS_AAAP_PolyObject__c WHERE PBS_AAAP_Agency_Requirement__c = :pAgncyReqId]) {
                            if (dPoly.Id != pObj.Id) {
                                if(dPoly.PBS_AAAP_Saved_to_favorites__c){
                                    dPoly.PBS_AAAP_Agency_Requirement__c = NULL;
                                    lstUpdPoly.add(dPoly);
                                } else {
                                    lstDelPoly.add(dPoly);
                                }
                            }
                        }

                        if (!lstDelPoly.isEmpty()) {
                            delete lstDelPoly;
                        }

                        if (!lstUpdPoly.isEmpty()) {
                            update lstUpdPoly;
                        }

                        List<PBS_AAAP_PolyPath__c> polyPathData = new List<PBS_AAAP_PolyPath__c>();

                        for (String i : pPaths) {
                            system.debug('##### i (pre-split): ' + i);
                            i = i.replaceAll('\\[', '');
                            i = i.replaceAll('\\]', '');
                            List<String> str = i.split('\\*', 0) ;


                            system.debug('##### i (post-split): ' + str);
                            String ind = str[0];
                            Decimal lat = Decimal.valueOf(str[1]);
                            system.debug('##### lat: ' + lat);
                            Decimal lng = Decimal.valueOf(str[2]);
                            system.debug('##### lng: ' + lng);

                            polyPathData.add(new PBS_AAAP_PolyPath__c(Path_Index__c = Decimal.valueOf(ind), latitude__c = lat.setScale(15), longitude__c = lng.setScale(15), Poly_Object__c = pObj.Id));
                        } // end for

                        upsert polyPathData;

                        results.set(0, 'success'); // indicate success
                        results.set(1, pObj.Id); // pass the polygon ID back to the JS
                        results.set(2, pObj.Name); // pass the polygon Name back to the JS

                    } else {
                        results.set(0, 'failed');
                        results.set(1, 'Please enter a shape name.');
                        results.set(2, '');
                    } // end if
                } // end if
            }

        } catch (Exception e) {
            ApexPages.addMessages(e);
            results.set(0, 'failed');
            results.set(1, e.getMessage());
            results.set(2, '');
            Database.rollback(sp0);
            return results;
        }

        return results;

    }    // end savePoly

    public List<Selectoption> getFavoritePolys(){
        List<Selectoption> lstFavPolys = new List<selectoption>();
        
        lstFavPolys.add(new selectOption('', '- None -'));
        for(PBS_AAAP_PolyObject__c poly :[SELECT id,name,PBS_AAAP_Saved_to_favorites__c FROM PBS_AAAP_PolyObject__c WHERE PBS_AAAP_Saved_to_favorites__c = TRUE Order by Name ASC]){
            lstFavPolys.add(new selectoption(poly.id,poly.name));
        }
        System.debug('JK 1stFavPolys ' + lstFavPolys);
        return lstFavPolys;
    }

    public PageReference gotoFav(){
        String pName;
        system.debug('******PPP'+pId);
        pName = [SELECT Id, Name FROM PBS_AAAP_PolyObject__c WHERE Id = :pId LIMIT 1].Name;
        system.debug('******PPP'+pName);
        PageReference pref = new PageReference('/apex/pbs_aaap_agencyrequirementshape?id=' + agncyID + '&polyId=' +pId+ '&polyName=' +pName+ '&copy=true');//JK Here, when user chooses a favorite from the picklist, user is redirected and 'copy' is set to true in the URL params. Then is used in line 86 of this class.
        pref.setRedirect(true);
        return pref;
    }

}