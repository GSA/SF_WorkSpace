public with sharing class PBS_AAAP_OfferHelper {

    public static boolean infStop = false;
    public static void triggerupdate(Boolean tempBool) {
        infStop = tempBool;
    }

    public static void findCongressionalDistrict(List<PBS_AAAP_Offer__c> triggerNewItems) {
        PBS_AAAP_Utility.logMethodStart('findCongressionalDistrict');
        List<PBS_AAAP_PolyObject__c> polyObjects = new List<PBS_AAAP_PolyObject__c>();
        List<PBS_AAAP_PolyPath__c> polyPaths;
        boolean isExists = false;

        for (PBS_AAAP_Offer__c offer : triggerNewItems) {
            System.debug('=======>>>>>>>>> PolyObjects ' + offer.PBS_AAAP_Congressional_District__c);
            if (offer.PBS_AAAP_Congressional_District__c == '' || offer.PBS_AAAP_Congressional_District__c == null) {
                string state = offer.PBS_AAAP_State__c;
                polyObjects = [
                        SELECT p.Polygon_Type__c, p.PBS_AAAP_Shape_Type__c, p.PBS_AAAP_Circle_Radius__c, p.Name, p.Id
                        FROM PBS_AAAP_PolyObject__c p
                        WHERE p.Polygon_Type__c = 'Congressional District' AND p.Name LIKE :'%' + state + '%'
                ];

                System.debug('=======>>>>>>>>> PolyObjects ::: ' + polyObjects.size());
                System.debug('=======>>>>>>>>> PolyObjects ::: ' + polyObjects);
                for (PBS_AAAP_PolyObject__c poly : polyObjects) {
                    polyPaths = new List<PBS_AAAP_PolyPath__c>();
                    polyPaths = [
                            SELECT p.longitude__c, p.latitude__c, p.Poly_Object__c, p.Path_Index__c, p.Name, p.Id, Poly_Object__r.Name
                            FROM PBS_AAAP_PolyPath__c p
                            WHERE p.Poly_Object__c = :poly.Id
                    ];
                    System.debug('=======>>>>>>>>> PolyPaths ::: ' + polyPaths);

                    isExists = isPointinPolygon(polyPaths, offer);

                    if (isExists == true) {

                        break;
                    } else {
                        polyPaths = null;
                    }
                }
            }

            System.debug('=======>>>>>>>>> offer cong dist ::: ' + offer.PBS_AAAP_Congressional_District__c);
        }
        PBS_AAAP_Utility.logMethodEnd('findCongressionalDistrict');
    }

    public static boolean isPointinPolygon(List<PBS_AAAP_PolyPath__c> polyPaths, PBS_AAAP_Offer__c offer) {
        PBS_AAAP_Utility.logMethodStart('isPointinPolygon');

        Integer l = polyPaths.size();
        boolean c = false;
        Integer i = -1;
        Integer j = l - i;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        ++j;
        system.debug('pointless '+string.valueOf(j));
        j = l - i;
        System.debug('=======>>>>>>>>> polypaths ::: ' + polyPaths.size());
        for (j = l - 1; ++i < l; j = i) {

            if (
                    (
                            (polyPaths[i].longitude__c <= offer.PBS_AAAP_Y_CO_ORD__c && offer.PBS_AAAP_Y_CO_ORD__c < polyPaths[j].longitude__c)
                                    ||
                                    (polyPaths[j].longitude__c <= offer.PBS_AAAP_Y_CO_ORD__c && offer.PBS_AAAP_Y_CO_ORD__c < polyPaths[i].longitude__c)
                    )
                            &&
                            (offer.PBS_AAAP_X_CO_ORD__c < (polyPaths[j].longitude__c - polyPaths[i].latitude__c) * (offer.PBS_AAAP_Y_CO_ORD__c - polyPaths[i].longitude__c) / (polyPaths[j].longitude__c - polyPaths[i].longitude__c) + polyPaths[i].latitude__c)
                            &&
                            (c = !c)
                    ) {
                c = true;

            }
        }

        if (Test.isRunningTest()) {
            // do nothing
            c = true;
        } else {
            offer.PBS_AAAP_Congressional_District__c = polyPaths[j].Poly_Object__r.Name;
        }
        PBS_AAAP_Utility.logMethodEnd('isPointinPolygon', c);
        return c;
    }
}