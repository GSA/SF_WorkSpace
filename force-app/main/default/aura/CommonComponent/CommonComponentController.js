({
	doInit : function(component, event, helper) {
        let url = (window.location != window.parent.location)
            ? document.referrer
            : document.location.href;
        var urlParam = url.substr(url.indexOf('?'));
        if(urlParam.length > 1){
		component.set('v.urlParam',urlParam);
        }
        console.log('**** url: ' , url);
	},

    iframeLoad : function(component, event, helper) {
        
        window.setTimeout(function(){
            let iframe = document.getElementById('myIframe');
            iframe.style.height = (iframe.contentWindow.document.body.scrollHeight + 35) + 'px';
        },1);

        window.addEventListener( "message",
          function (e) {
                let iframe = document.getElementById('myIframe');
                iframe.style.height = (iframe.contentWindow.document.body.scrollHeight + 35) + 'px';
          },
          false);
    },
 
})