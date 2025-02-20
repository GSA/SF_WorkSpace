global class PBS_AAAP_IdentifyWinnerForm implements Comparable {

    public  Id offerId {get;set;}
    public  Id spaceId {get;set;}

    public transient  string spaceName {get;set;}
    public transient  String buildingName {get;set;}
    public transient  String street {get;set;}
    public transient  String city {get;set;}
    public transient  String typeOfSpace {get;set;}
    public transient  double SFOfSpace {get;set;}
    public transient  boolean neworsucceedingOffer {get;set;}
    public transient  double pvCosts {get;set;}
    public transient  String statusFlag {get;set;}
    public transient  double lat {get;set;}
    public transient  double lng {get;set;}
    public transient  string leaseTerm {get;set;}
    public transient  double totalMarkUpSpace {get;set;}

    //Vaishali 07/31 Start
    public transient  integer firmTermYRs {get;set;}
    public transient  integer totalTermYRs {get;set;}
    public transient  Boolean rlpGT2016   {get; set;}     //Vaishali added for FY17
    public transient  Boolean rlpGT2019 {get; set;} 
//Vaishali 07/31 End

    // flags
    public transient  boolean isEnergyStar {get;set;}
    public transient  boolean isAwarded {get;set;}
    public transient  boolean isSelected {get;set;}
    public transient  boolean isMetro {get;set;}
    public transient  boolean isHistoricProperty {get;set;}
    public transient  boolean isHUBZONEArea {get;set;}
    public transient  boolean isBuildingProblem {get;set;}

    public transient  double baseRate {get;set;}
    public transient  double baseCostSrvcUtilPerABOA {get;set;}

    public transient  double BSACCost {get;set;}   //Vaishali RLP FY15

    public transient  double amortizRateT1Upto20 {get;set;}
    public transient  double amortizRateT1Above20 {get;set;}
    public transient  double costForTI {get;set;}
    public transient  double fullServiceRentFirm {get;set;}
    public transient  double fullyServRentOptionTerm {get;set;}
    public transient  double numOfMonthsFreeFirmTerm {get;set;}
    public transient  double numOfMonthsFreeOptionTerm {get;set;}
    public transient  double coopCommTogsaFirmTerm {get;set;}
    public transient  double vacantPremiseRate {get;set;}
    public transient  double HVACCost {get;set;}
    public transient  double daytimeCleaningCost {get;set;}
    public transient  double annualAmortTICosts {get;set;}
    public transient  double aeFees	{get; set;}
    public transient  String aeFeeUOM	{get; set;}
    public transient  double ownerPvCosts {get; set;}
    public transient  double overheadProfFees	{get; set;}
    public transient  double gcConditions	{get; set;}
    public transient  double costPerABOA {get; set;}
    public transient  double mgmtCoordFees {get; set;}
    public transient  String NewAndSucc {get;set;}
    public transient  double minSqFt {get; set;}
    public transient  double maxSqFt {get; set;}
    public transient  double numParkingSpaces {get; set;}
    public transient  double numResSrfcPrkSpace{get; set;}
    public transient  double numNonResSrfcPrkSpace{get; set;}
    public transient  double numResGargPrkSpace{get; set;}
    public transient  double numNonResGargPrkSpace{get; set;}
    public transient  double rateResSrfcPrkSpace{get; set;}
    public transient  double rateNonResSrfcPrkSpace{get; set;}
    public transient  double rateResGargPrkSpace{get; set;}
    public transient  double rateNonResGargPrkSpace{get; set;}


    // rlp info
    public transient  double newLease {get;set;}
    public transient  double succLease {get;set;}
    public transient  boolean newLeaseIncludeAE {get;set;}
    public transient  boolean succLeaseIncludeAE {get;set;}
    public transient  double physicalcosts {get;set;}
    public transient  double telecommcosts {get;set;}
    public transient  double otherupfrontcosts {get;set;}
    public transient  double maxTi	{get; set;}
    public transient  double discountRate {get; set;}
    public transient  double escalRate {get; set;}
    public transient  double BSACperABOA {get; set;}  //Vaishali RLP FY15
    public transient  double bsacForContinuingSpace {get;set;}

    // Agency Req. info
    public transient  double HVACOvertimeHours {get;set;}
    public transient  boolean includeHVACOverTime {get;set;}
    public transient  boolean includeDayTimeCleaning {get;set;}
    public transient  boolean isUserDelineatedArea {get;set;}
    public transient  string altDelineatedAreaSubMarket {set;get;}
    public transient  string subMarketDescriptor {set;get;}
    public transient  string subMarketPolygonId {get;set;}

    //Update by Snehith 04/05/2018 to add Offer Name on to the Identify winner page
    public transient  string offerName {get;set;}

    // compareTo implementation (required of the Comparable interface) for purposes of facillitating sorting of lists of records using this class as a type
    global integer compareTo(Object propertyRecComp){
        PBS_AAAP_IdentifyWinnerForm	propertyRec	=	(PBS_AAAP_IdentifyWinnerForm) propertyRecComp;
        if(pvCosts	==	propertyRec.pvCosts)	return 0;
        if(pvCosts	>	propertyRec.pvCosts)	return 1;
        return -1;
    }	// end compareTo

}