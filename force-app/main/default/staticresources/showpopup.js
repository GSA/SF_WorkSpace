//SETTING UP OUR POPUP
//0 means disabled; 1 means enabled;
var popupStatus = 0;

//loading popup with jQuery magic!
function loadPopup(){
    //loads popup only if it is disabled
    if(popupStatus==0){
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