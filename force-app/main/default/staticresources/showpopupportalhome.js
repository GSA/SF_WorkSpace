//SETTING UP OUR POPUP
//0 means disabled; 1 means enabled;
var popupStatus = 0;

//---------------------------------------------
// COOKIE FUNCTIONS
//---------------------------------------------

function getCookie(Name)
{
	var Argument;
	var ArgumetLength;
	var CookieLength;
	var EndString;
	var i;
	var j;
	
	Argument = Name + "=";
	ArgumentLength = Argument.length;
	CookieLength = document.cookie.length;
	i = 0;
	while (i < CookieLength)
	{
		j = i + ArgumentLength;
		if (document.cookie.substring(i, j) == Argument)
		{
			EndString = document.cookie.indexOf (";", j);
			if (EndString == -1)
				EndString = document.cookie.length;
			return unescape(document.cookie.substring(j, EndString));
		}
		i = document.cookie.indexOf(" ", i) + 1;
		if (i == 0)
            break;
	}
	return (null);
}

function setCookie(Name, Value)
{
	var ArgumentCount;
	var ArgumentValues;
	var Domain;
	var Expires;
	var Path;
	var Secure;
	
	ArgumentValues = setCookie.arguments;
	ArgumentCount = setCookie.arguments.length;
	
	Expires = (ArgumentCount > 2) ? ArgumentValues[2] : null;
	Path = (ArgumentCount > 3) ? ArgumentValues[3] : null;
	Domain = (ArgumentCount > 4) ? ArgumentValues[4] : null;
	Secure = (ArgumentCount > 5) ? ArgumentValues[5] : false;
		
	document.cookie = Name + "=" + escape(Value) +
		((Expires == null) ? "" : ("; expires=" + Expires.toGMTString())) +
		((Path == null) ? "" : ("; path=" + Path)) +
		((Domain == null) ? "" : ("; domain=" + Domain)) +
		((Secure == true) ? "; secure" : "");
}

function deleteCookie(Name)
{
	var CookieValue;
	var ExpirationDate;
	
	ExpirationDate = new Date();
	ExpirationDate.setTime (ExpirationDate.getTime() - 1);
	
	/* Make Sure Cookie Exists First */
	CookieValue = getCookie(Name);
	if (CookieValue != null) 
	{
        setCookie(Name, null, ExpirationDate, "/", null, true);
        //alert('Deleted Cookie: ' + Name);		  
	}    		    		    	
}
		
//loading popup with jQuery magic!
function loadPopup(){
	//alert(getCookie("apex__counter"));
    //loads popup only if it is disabled   
    if (popupStatus==0 && (getCookie("apex__counter") == '1')) {
        jQuery("#backgroundPopup").css({
            "opacity": "0.7"
        });
        jQuery("#backgroundPopup").fadeIn("slow");
        jQuery("#popupContact").fadeIn("slow");
        popupStatus = 1;       
    }
}

//disabling popup with jQuery magic!
function disablePopup(){
    //disables popup only if it is enabled
    if(popupStatus==1){
        jQuery("#backgroundPopup").fadeOut("slow");
        jQuery("#popupContact").fadeOut("slow");
        popupStatus = 0;
        deleteCookie("apex__counter");
    }
}

//centering popup
function centerPopup(){
    //request data for centering
    var windowWidth = document.documentElement.clientWidth;
    var windowHeight = document.documentElement.clientHeight;
    var popupHeight = jQuery("#popupContact").height();
    var popupWidth = jQuery("#popupContact").width();
    //centering
    jQuery("#popupContact").css({
        "height": popupHeight,
        "top": 35,
        "left": windowWidth/2-popupWidth/2
    });
    //only need force for IE6
    
    jQuery("#backgroundPopup").css({
        "height": windowHeight
    });
    
}


//CONTROLLING EVENTS IN jQuery
jQuery(document).ready(function(){
    
    //LOADING POPUP
    //Click the button event!
   // jQuery("#button").click(function(){
        //centering with css
     //   centerPopup();
        //load popup
     //   loadPopup();
   // });
                
    //CLOSING POPUP
    //Click the x event!
    jQuery("#popupContactClose").click(function(){
        disablePopup();
    });
    
    //Press Escape event!
    jQuery(document).keypress(function(e){
        if(e.keyCode==27 && popupStatus==1){
            disablePopup();
        }
    });

});