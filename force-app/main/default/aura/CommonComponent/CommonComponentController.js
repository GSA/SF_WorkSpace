({
    doInit : function(component, event, helper) {
        let url = (window.location != window.parent.location)
        ? document.referrer
        : document.location.href;
        var urlParam = url.substr(url.indexOf('?'));
        if(urlParam.length > 1){
            component.set('v.urlParam',urlParam);
        }
        window.addEventListener('navigatetopage', $A.getCallback(function(event) {
            var message = event.detail;
            var vfFrame = document.getElementById('myIframe');
            if (vfFrame && vfFrame.contentWindow) {
                vfFrame.contentWindow.postMessage(message);
            } else {
                console.error('Visualforce iframe not found or contentWindow not accessible.');
            }
        }));
    },
    iframeLoad : function(component, event, helper) {
        
        window.setTimeout(function(){
            let iframe = document.getElementById('myIframe');
            iframe.style.height = (iframe.contentWindow.document.body.scrollHeight + 35) + 'px';
        },1000);
        
        window.addEventListener( "message",
                                function (e) {
                                    let iframe = document.getElementById('myIframe');
                                    iframe.style.height = (iframe.contentWindow.document.body.scrollHeight + 35) + 'px';
                                },
                                false);
    },
    
})