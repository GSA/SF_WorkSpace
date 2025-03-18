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
    //var aaapUrl = (authType == "Guest" ? "/AAAP-LoginPage?startURL=/AAAP-PortalHome" : "/AAAP-PortalHome");
    //var rsapUrl = (authType == "Guest" ? "/RSAP-LoginPage?startURL=/RSAP-PortalHome" : "/RSAP-PortalHome");
/*	var aaapUrl = "/AAAP-LoginPage";
    var rsapUrl = "/RSAP-LoginPage";*/
    var aaapUrl = "/AAAP-PortalHome";
    var rsapUrl = "/RSAP-PortalHome";  
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
        cardType: "Card with Media",
        cardsPerRow: "3",
        header: "Automated Advanced Acquisition Platform (AAAP)",
        body: "AAAP allows offerors to submit office space to the government in response to a generic request for lease proposals, before or after the government publicizes a requirement.",
        buttonLinkUrl: aaapUrl,
        buttonLinkText: "AAAP Login",
        mediaUrl: $A.get("$ContentAsset.LeasingAAAPImagejpg"),
        mediaAltText: "A placeholder image"
      },
      {
        cardType: "Card with Media",
        cardsPerRow: "3",
        header: "Requirement Specific Acquisition Platform (RSAP)",
        body: "RSAP allows offerors to submit space to the government in response to a specific request for lease proposals, after the government publicizes a requirement.",
        buttonLinkUrl: rsapUrl,
        buttonLinkText: "RSAP Login",
        mediaUrl: $A.get("$ContentAsset.LeasingRSAPImagejpg"),
        mediaAltText: "A placeholder image"
      },
      {
        cardType: "Card with Media",
        cardsPerRow: "3",
        header: "Taxes",
        body: "Allows lessors to submit and manage tax adjustment requests, and submit tax appeal requests.",
        //buttonLinkUrl: "../../realestatetaxes/s/login/?startURL=/realestatetaxes/s",  
        buttonLinkUrl: retUrl,  
        buttonLinkText: "Tax Login",
        mediaUrl: $A.get("$ContentAsset.LeasingTaxesImagejpg"),
        mediaAltText: "A placeholder image"
      }
    ];
  }
});