({
	doInit : function(cmp, event, helper) {
		cmp.set('v.columns', [
            {label: 'ID', fieldName: 'linkName', initialWidth: 87,type: 'url', typeAttributes: {
                        label: { fieldName: 'Name' }, target: '_parent', tooltip: 'Click for DES Item Page' 
                    },},
            {label: 'Line Item Number', fieldName: 'CSI_Line_Item_Number__c', initialWidth: 113,type: 'text'},
            //{label: 'Item Type', fieldName: 'Item_Type__c', type: 'text'},
            
            {label: 'Description', fieldName: 'Description__c', type: 'text',initialWidth: 350, wrapText: true}, 
            {label: 'Quantity', fieldName: 'Quantity__c', type: 'number',initialWidth: 120,editable:true, typeAttributes: {step: '0.01', minimumFractionDigits: '2'}},
            {label: 'Unit', fieldName: 'Unit__c', type: 'text',initialWidth: 75},
            {label: 'NCMT Subcontractor', fieldName: 'subLink',initialWidth: 9, type: 'url', typeAttributes: {
                        label: { fieldName: 'subName' }, target: '_parent', tooltip: 'Click for Subcontractor Page' 
                    }},
            {label: 'Total Direct Cost', fieldName: 'Total_Direct_Cost__c',initialWidth: 120,type: 'currency', typeAttributes: { currencyCode: 'USD', maximumFractionDigits: 2}},
            {label: 'Total Cost w/ Subcon. Markups', fieldName: 'Total_Cost__c',initialWidth: 120,type: 'currency', typeAttributes: { currencyCode: 'USD', maximumFractionDigits: 2}},
            {label: 'Cost Category Description', fieldName: 'Cost_Summary__c',initialWidth: 120, type: 'text', wrapText: true}
        ]);
        
        let getData = helper.fetchData(cmp);
        getData.then(function(res){
            cmp.set('v.projectId', res.projectId);
            cmp.set('v.desCopy', res.desCopy);
            console.log(res);
            console.log(res.treeStruc[0].Markup_Method__c);
            var isOandP = (res.treeStruc[0].Markup_Method__c == 'RSMeans - O&P');
            cmp.set('v.isOandP', isOandP);
            console.log(isOandP);
            if(res.treeStruc.length > 0) {
            	cmp.set('v.locationMultiplier', res.treeStruc[0].Project_ID__r.Location_Multiplier__c);
                console.log(cmp.get('v.locationMultiplier'));
                cmp.set('v.treeStruc', res.treeStruc[0]);
            }
            
            if(res.desCopy.length > 0)
            {
                var markupDes = res.desCopy[0].DES_Item__r.Markup_Method__c;
                var markupTree = res.treeStruc[0].Markup_Method__c;
                if(markupDes == markupTree || markupTree === undefined)
                	cmp.set('v.hasCopy', true);
            }
                
            helper.setData(cmp, res.desItems);
        });
	},
    
    copy : function(cmp, evt, hlp) {
        var table = cmp.find('desTable');
        var selectedRows = table.getSelectedRows();
        console.log(selectedRows.length);
        if(selectedRows.length < 1)
        {
        	cmp.set('v.message', ('No rows selected to copy. Please select at least one row.'));   
            cmp.set('v.showError', true);
		}
        else{
        if(cmp.get('v.hasCopy') == true)
       {
        console.log('has existing copy'); 
        //delete existing copy
        var action = cmp.get('c.deleteCopies');
        action.setParams({ copies : cmp.get('v.desCopy')});
        
        action.setCallback(this, function(res) {
           var state = res.getState();
            if(state === 'SUCCESS')
            {
                console.log('DELETE SUCCESS!');
                hlp.getDESCopies(cmp, selectedRows);
                console.log('desCopy', cmp.get('v.desCopy'));
            }
            else
                console.log('NO SUCCESS!');
        });
        
        $A.enqueueAction(action);
       }
       else
           hlp.getDESCopies(cmp, selectedRows);
    	}
    },
    
    paste : function(cmp, evt, hlp) {
        console.log('PASTE');
      	let button = evt.getSource();
    	button.set('v.disabled',true);
        button.set('v.label', 'Pasting...');
        
        var copies = cmp.get('v.desCopy');
        console.log(copies);
        
        hlp.pasteCopies(cmp, copies);
    },
    
    isRefreshed: function(component, event, helper) {
        location.reload();
    },
    
    handleSelect : function(cmp, evt, hlp) {
        var selectedVal = evt.getParam("value");
        console.log(selectedVal);
        var recordId = cmp.get('v.recordId');
        window.open(
            '/apex/NCMT_TreeView_Launcher?id='+recordId+'&fileType='+selectedVal,
            '_parent' 
        );
    },
    
    handleDelete : function(cmp, evt, hlp) {
        console.log('DELETE!');
        var table = cmp.find('desTable');
        var selectedRows = table.getSelectedRows();
        var message =  '';
        console.log(selectedRows.length);
        if(selectedRows.length > 0) {
            message = 'Are you sure you want to delete ' + selectedRows.length + ' NCMT DES Item';
            if(selectedRows.length > 1)
                message += 's?';
            else
                message += '?';
            
            cmp.set('v.showDelete', true);
        }
        else {
            message = 'No rows selected to delete. Please select at least one row.'
            cmp.set('v.showDelete', false);
        }
        
        cmp.set('v.message', message);
        //cmp.set('v.showDelete', true);
        cmp.set('v.showError', true);
        
        //hlp.deleteItems(cmp, selectedRows);
    
    },
    
    delete : function(cmp, evt, hlp) {
    	var table = cmp.find('desTable');
        var selectedRows = table.getSelectedRows();
    
    	hlp.deleteItems(cmp, selectedRows);
	},
    
  // Start of line Added as a soln to SFWS-1775
      
  onSave : function( component, event, helper ) {  

    var draftValues = event.getParam('draftValues');
    var action = component.get("c.updateDesLineItems");
    
    action.setParams({"desItemsList" : draftValues});
    action.setCallback(this, function(response) {
    var state = response.getState();
           
            if(state==='SUCCESS'){
                
               location.reload();
               alert('Record Updated Successfully..');                
            }
            else if(state==="Error"){
                var errors =response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: "+
                               errors[0].message);
                    }
                }
                else{
                    console.log(response.getReturnValue());
                }
              }
            });
        $A.enqueueAction(action);
        },
                               
//End of line added as a soln to SFWS-1775
  
 
 
 
    back : function(cmp, evt, hlp) {
        cmp.set('v.showError', false);
    	cmp.set('v.showDelete', false);
    }
})