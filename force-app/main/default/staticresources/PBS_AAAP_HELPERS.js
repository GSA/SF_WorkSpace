// JavaScript source code
function debugAlertMethodStart(methodName, o) {
    debugAlertObj(methodName + " vvvvvvvvvvvvvvvvvvvv", o);
}
function debugAlertMethodStop(methodName, o) {
    debugAlertObj(methodName + " ^^^^^^^^^^^^^^^^^^^^", o);
}
function debugAlertObj(context, o) {
    if (o == null) {
        debugAlert(context);
    }
    else {
        debugAlert(context + "\n" + JSON.stringify(o));
    }
}
function debugAlert(msg) {
    console.log(msg);
    //alert("DEBUG: "+msg);
}

//this is required for proper functionning of uniform.js which other pages include
//https://stackoverflow.com/questions/14923301/uncaught-typeerror-cannot-read-property-msie-of-undefined-jquery-tools
jQuery.browser = {};
(function () {
    jQuery.browser.msie = false;
    jQuery.browser.version = 0;
    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
        jQuery.browser.msie = true;
        jQuery.browser.version = RegExp.$1;
    }
})();    
