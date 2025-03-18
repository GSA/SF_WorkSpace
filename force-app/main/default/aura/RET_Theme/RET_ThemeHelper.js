({
	getThemeData: function(component) {
		component.set("v.pathname", window.location.pathname.replace('/realestatetaxes/s/', ''));

		// Create the action and set parameters
	    var action = component.get("c.getUserType");

	    // Add callback behavior for when response is received
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	            component.set("v.userType", response.getReturnValue());
	        }
	        else {
	            var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
	        }
	    });

	    // Send action off to be executed
	    $A.enqueueAction(action);
	},
	jQuerySetup: function() {
		var $j = jQuery.noConflict();
		var documentType;
		
		$j(function() {

			$j(document).on('click', '.add-icon', function(e) {
				e.preventDefault();
				$j('#file-upload-header').text('Upload ' + $j(this).data('header-description'));

				document.getElementById('upload-frame').src += '';
				$j('#document-upload').show();
			});

		});
	},
	setNavHighlight: function(component) {
	    var path = window.location.pathname.replace('/realestatetaxes/s/', '');
	    console.log('Found path: ' + path);
	    
	    console.log('cmp: ' + component.get('v.pathname'));
	    switch(path) {
	    	case 'news-and-updates':
				console.log('highlighting news...');
				document.getElementById('ret-news').className = 'selected';
				break;
	    	case 'frequently-asked-questions':
				console.log('highlighting faq...');
				document.getElementById('ret-faqs').className = 'selected';
				break;
	    	case 'help':
				console.log('highlighting help...');
				document.getElementById('ret-help').className = 'selected';
				break;
	    	default:
	    		console.log('highlighting home...');
	    		document.getElementById('ret-home').className = 'selected';
	    		
	    }
	}
})