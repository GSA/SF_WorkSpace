({
  init: function(component) {
      console.log('In helper init() method...');
      var action = component.get("c.getUserType");
      console.log('about to set callback for getUserType() function...');
      action.setCallback(this, function(response) {
	  	  var state = response.getState();
		  if (component.isValid() && state === "SUCCESS") {
	           var returnedUserType = response.getReturnValue();
	           console.log('UserType ** '+returnedUserType);
               component.set("v.userType", returnedUserType);
               console.log('About to call generateDataMapped() function...');
    		   component.set("v.cardDataMapped", this.generateDataMapped(returnedUserType));
               console.log('Done with generateDataMapped() function');
    		   var cardList = component.find("cardList");
    		   cardList.processCardData();
	      } else {
	           console.log('error response = ' + JSON.stringify(response));
	      }
  	  });
      console.log('about to enqueue getUserType callout...');
      $A.enqueueAction(action);
  },
  generateDataMapped: function(authType) {
    console.log('in generateDataMapped() function with authtype: ' + authType);
    var aaapUrl = "/Offer-Home";
    var rsapUrl = "/Offer-Home"; 
    var urlString = window.location.href;
    console.log('urlString = ' + urlString);
    var retUrl;
    if (urlString.includes("leasing.gsa.gov")){
        console.log('set URL to go to RET prod');
        retUrl = 'https://ret.gsa.gov/realestatetaxes/s/login/?startURL=/realestatetaxes/s';
    } else {
        console.log('set URL to go to RET nonprod');
        retUrl = '../../realestatetaxes/s/login/?startURL=/realestatetaxes/s';
    }
    return [
      {
        cardType: "Flag Left",
        cardsPerRow: "2",
        header: "Offer space",
        body: "Enter property and rate details to submit an offer to lease space to the government.",
        buttonLinkUrl: rsapUrl,
        buttonLinkText: "Offer",
        mediaUrl: $A.get("$ContentAsset.LeasingRSAPImagejpg"),
        mediaAltText: "A placeholder image"
      },
      {
        cardType: "Flag Left",
        cardsPerRow: "2",
        header: "Manage lease",
        body:"Upload documents, such as tax bills or drawings, to manage existing leases with the government.",
        buttonLinkUrl: retUrl,  
        buttonLinkText: "Manage",
        mediaUrl: $A.get("$ContentAsset.LeasingTaxesImagejpg"),
        mediaAltText: "A placeholder image"
      }
    ];
  }
});