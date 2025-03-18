({
	getUrlParameter: function(sParam) {
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;

            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');

                if (sParameterName[0] === sParam) {
                    return sParameterName[1] === undefined ? true : sParameterName[1];
                }
            }
	},
	initPage: function(component) {
		component.set("v.caseId", this.getUrlParameter('id'));
	    var action = component.get("c.getHostName");
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	var vfHost = response.getReturnValue();
	            component.set("v.vfHost", vfHost);

		        var vfOrigin = "https://" + vfHost;
		        window.addEventListener("message", function(event) {
		            if (event.origin === vfOrigin) {
						var request = JSON.parse(event.data);
						if(request.type === 'show-message') {
							document.getElementById('document-upload').style.display = 'none';
							
							var docLoader;
							if(request.editMode == true) {
								docLoader = component.get('c.getUpdatedCaseDocuments');
							} else {
								docLoader = component.get('c.loadExistingDocs');
							}							
							docLoader.setParams({ "caseId" : component.get("v.caseId") });	
							docLoader.setCallback(this, function(response) {
						        var state = response.getState();
						        if (component.isValid() && state === "SUCCESS") {
						            component.set("v.existingDocs", response.getReturnValue());
						            document.getElementById('ret-upload-spinner').style.display = 'block';
                                    document.getElementById('ret-upload-container').style.display = 'none';
                                    document.getElementById('modal-footer-buttons-new').style.display = 'block';
                                    document.getElementById('modal-footer-buttons-done').style.display = 'none';
                                    
                                    var btnValue = component.get("v.btnType");
                                    if(btnValue=== 'SaveWithNew'){
                                    	component.set("v.btnType", "");
                                        document.getElementById('file-upload-header').innerHTML = 'Upload New Document';
                                        document.getElementById('upload-frame').src = '/realestatetaxes/RET_FileUpload?caseId=' + component.get("v.caseId");
                                        document.getElementById('document-upload').style.display = 'block';
                                    }
						        }
						        else {
						            var errors = response.getError();
					                if (errors) {
					                    if (errors[0] && errors[0].message) {
					                    	component.set('v.errors', 'Unable to load documents: ' + errors[0].message);
					                    }
					                } else {
					                    component.set('v.errors', 'Unable to load documents for this tax submission due to an error.');
					                }
						        }
						    });
							$A.enqueueAction(docLoader);
				            
				            var toastEvent = $A.get("e.force:showToast");
					    	toastEvent.setParams({
					        	"title": "Success!",
					        	"message": request.msg,
					        	"type": "success",
					        	"duration": "7000"
					    	});
							toastEvent.fire();
						} else if (request.type === 'hide-spinner') {
							document.getElementById('ret-upload-spinner').style.display = 'none';
							document.getElementById('ret-upload-container').style.display = 'block';
						}
		            }
		        }, false);

	        } else {
	            var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    	component.set('v.errors', errors[0].message);
                    }
                } else {
                    component.set('v.errors', 'An error occurred setting up page data.');
                }
	        }
	    });
	    $A.enqueueAction(action);
	},
	loadExistingDocs: function(component) {
	    var action = component.get("c.getCaseDocuments");
	    action.setParams({ "caseId" : component.get("v.caseId") });

	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	            component.set("v.existingDocs", response.getReturnValue());
	        }
	        else {
	            var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    	component.set('v.errors', 'Unable to load documents: ' + errors[0].message);
                    }
                } else {
                    component.set('v.errors', 'Unable to load documents for this tax submission due to an error.');
                }
	        }
	    });
	    $A.enqueueAction(action);
	},
	showUploadPanel: function(component) {
		document.getElementById('ret-upload-spinner').style.display = 'block';
		document.getElementById('ret-upload-container').style.display = 'none';
		document.getElementById('modal-footer-buttons-new').style.display = 'block';
		document.getElementById('modal-footer-buttons-done').style.display = 'none';

		document.getElementById('file-upload-header').innerHTML = 'Upload New Document';
		document.getElementById('upload-frame').src = '/realestatetaxes/RET_FileUpload?caseId=' + component.get("v.caseId");;
		document.getElementById('document-upload').style.display = 'block';
	},
	saveDocument: function(component) {
		var vfOrigin = "https://" + component.get("v.vfHost");
		var vfWindow = document.getElementById('upload-frame').contentWindow;
		vfWindow.postMessage('{"caseId" : "' + component.get("v.caseId") + '"}', vfOrigin);
	},
	saveNewDocument: function(component) {
		component.set("v.btnType", "SaveWithNew");
		var vfOrigin = "https://" + component.get("v.vfHost");
        var vfWindow = document.getElementById('upload-frame').contentWindow; 
        vfWindow.postMessage('{"caseId" : "' + component.get("v.caseId") + '","btnType" : "SaveWithNew"}', vfOrigin);
    },
	editDocument: function(component, event) {
		document.getElementById('ret-upload-spinner').style.display = 'block';
		document.getElementById('ret-upload-container').style.display = 'none';
		
		var selectedDoc = event.currentTarget;
		var docId = selectedDoc.dataset.recordid;
		document.getElementById('file-upload-header').innerHTML = 'Edit Document Information';
		document.getElementById('upload-frame').src = '/realestatetaxes/RET_FileUpload?attachmentId=' + docId + '&caseId=' + component.get("v.caseId");
		document.getElementById('document-upload').style.display = 'block';
		document.getElementById('modal-footer-buttons-new').style.display = 'block';
		document.getElementById('modal-footer-buttons-done').style.display = 'none';
	},
	doneUploading: function(component) {
		this.loadExistingDocs(component);
		document.getElementById('document-upload').style.display = 'none';
	},
	confirmRemoveDocument: function(component, event) {
		var selectedDoc = event.currentTarget;
		var docId = selectedDoc.dataset.recordid;
		var docName = selectedDoc.dataset.recordname;
		component.set("v.selectedRecordId", docId);
		component.set("v.selectedRecordName", docName);
		document.getElementById('confirm-doc-delete').style.display = 'block';
	},
	removeDocument: function(component) {	    
	    var action = component.get("c.deleteSelectedDocument");
	    action.setParams({ "caseId" : component.get("v.caseId"),
						   "docToDelete" : component.get("v.selectedRecordId")
	    });

	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        var toastEvent = $A.get("e.force:showToast");

	        if (component.isValid() && state === "SUCCESS") {
	            component.set("v.existingDocs", response.getReturnValue());
		    	toastEvent.setParams({
		        	"title": "Success!",
		        	"message": "The selected document has been removed.",
		        	"type": "success"
		    	});
	        } else {
	            var errors = response.getError();
	            var errMsg;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    	errMsg = 'Unable to remove documents: ' + errors[0].message;
                    }
                } else {
                    errMsg = 'Unable to remove documents for this tax submission due to an error.';
                }
		    	toastEvent.setParams({
		        	"title": "Error:",
		        	"message": errMsg,
		        	"type": "error"
		    	});                
	        }
	        toastEvent.fire();
	    });
	    $A.enqueueAction(action);
	    document.getElementById('confirm-doc-delete').style.display = 'none';
	},
	dwnldAllAttachments : function(component) {
		var action = component.get("c.getUrls");
        action.setParams({ "caseId" : component.get("v.caseId") });
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        var toastEvent = $A.get("e.force:showToast");
            if (component.isValid() && state === "SUCCESS") {
               var filelinks = response.getReturnValue();
               if(this.BrowserDetection(component)==='Chrome' || this.BrowserDetection(component) ==='Safari'){
               		this.downloadAllChrome_Safari(component,filelinks);  
               }else if(this.BrowserDetection(component)==='IE'){
               		this.downloadAllurlIE(component,filelinks);
               }else if(this.BrowserDetection(component)==='Firefox'){
               		this.downloadAllFirefox(component,filelinks);
               }
               
	        }else {
	            var errors = response.getError();
	            var errMsg;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    	errMsg = 'Unable to download documents: ' + errors[0].message;
                    }
                } else {
                    errMsg = 'Unable to download documents for this tax submission due to an error.';
                }
		    	toastEvent.setParams({
		        	"title": "Error:",
		        	"message": errMsg,
		        	"type": "error"
		    	});                
	        }
	        toastEvent.fire();
	    });
	    $A.enqueueAction(action);
	},
	
	downloadAllChrome_Safari :function(component,urls){
		var keys = Object.keys(urls);
		var links = [];
		for (var i = 0; i<keys.length; i++) {
            	var link = document.createElement('a');
				link.style.display = 'none';
				document.body.appendChild(link);
	  			console.log('key = '+keys[i]+', value = '+urls[keys[i]]);
	  			link.setAttribute('download', keys[i]);
	  			link.setAttribute('href', urls[keys[i]]);
	  			links.push(link);
		}
		 for (var j=0;j<links.length;j++){
        	 (function(index) {
                setTimeout(function() { 
                	links[index].click();
                }, j*2000);
            })(j);
        }
	},


	downloadAllurlIE : function(component,urls){
		var keys = Object.keys(urls);
		var links = [];
        var extensions = ['png','jpeg','gif','jpg'];
        var imagelinks = [];
		for (var i = 0; i<keys.length; i++) {
            var link = document.createElement('a');
            link.style.display = 'none';
		    document.body.appendChild(link);
            link.setAttribute('id','downloadall');
        	console.log('key = '+keys[i]+', value = '+urls[keys[i]]);
  			link.setAttribute('download', keys[i]);
  			link.setAttribute('href', urls[keys[i]]);
  			link.setAttribute('target','_blank');
            var extsn = keys[i].split('.')[1];
            if(extensions.indexOf(extsn)!= -1){
               imagelinks.push(link);
            }else{
                links.push(link);
            } 
		}
        
        for (var j=0;j<links.length;j++){
        	 (function(index) {
                setTimeout(function() { 
                	links[index].click();
                }, j*2000);
            })(j);
        }
        for (var j=0;j<imagelinks.length;j++) {
            (function(index) {
                setTimeout(function() { 
                	window.open(imagelinks[index]); },2000);
            })(j);
        }
	},

	downloadAllFirefox : function(component,urls){
		var keys = Object.keys(urls);
		var links = [];
        var extensions = ['png','jpeg','gif','jpg','txt','pdf'];
        var otherlinks = [];
        for (var i = 0; i<keys.length; i++) {
            var link = document.createElement('a');
            link.style.display = 'none';
		    document.body.appendChild(link);
            link.setAttribute('id','downloadall');
  			link.setAttribute('download', keys[i]);
  			link.setAttribute('href', urls[keys[i]]);
  			link.setAttribute('target','_blank');
            var extsn = keys[i].split('.')[1];
            if(extensions.indexOf(extsn)!= -1){
               otherlinks.push(link);
            }else{
                links.push(link);
            }
		}

		for (var j=0;j<links.length;j++){
        	 (function(index) {
                setTimeout(function() { 
                	links[index].click();
                }, j*1);
            })(j);
        }

        for (var j=0;j<otherlinks.length;j++) {
     		//converting other links of type object to string
        	var urlstring = String(otherlinks[j]);

        	//Parsing the string for the href
        	var linkval = urlstring.substring(urlstring.indexOf(':')+2,urlstring.indexOf('{'))
        	
			window.open(linkval,'_blank');
        }
	},

	BrowserDetection : function(component) {
                var versionofIE = this.detectIE(component);
               	var browsername;
                if (versionofIE !== false) {
                	browsername = 'IE';
                }else if (navigator.userAgent.search("Chrome") >= 0) {
                	browsername = 'Chrome';
                }else if (navigator.userAgent.search("Firefox") >= 0) {
                	browsername = 'Firefox';
                }else if (navigator.userAgent.search("Safari") >= 0 && navigator.userAgent.search("Chrome") < 0) {
                	browsername = 'Safari';
                }else if (navigator.userAgent.search("Opera") >= 0) {
                	browsername = 'Opera';
                }
                return browsername;
    },

    detectIE : function(component) {
        var ua = window.navigator.userAgent;

        var msie = ua.indexOf('MSIE ');
        if (msie > 0) {
            // IE 10 or older => return version number
            return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
        }

        var trident = ua.indexOf('Trident/');
        if (trident > 0) {
            // IE 11 => return version number
            var rv = ua.indexOf('rv:');
            return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
        }

        var edge = ua.indexOf('Edge/');
        if (edge > 0) {
            // Edge (IE 12+) => return version number
            return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10);
        }
        // other browser
        return false;
    },

})