({
    doInit : function(cmp, evt, hlp) {
        let getData = hlp.fetchData(cmp);
        getData.then(function(res){
            cmp.set('v.project', res.project);
            cmp.set('v.locationMultiplier', res.project.Location_Multiplier__c);
            cmp.set('v.treeStruc', res.treeStruc);
            console.log(res.project.Markup_Method__c);
            var markupMethod = res.project.Markup_Method__c;
            var isOandP = (res.project.Markup_Method__c == 'RSMeans - O&P');
            cmp.set('v.isOandP', isOandP);
            cmp.set('v.treeCopy', res.treeCopy);
            
            //Only display Paste button (using v.hasCopy) if a copy with matching Markup Method exists
            if(res.treeCopy.length > 0) {
                console.log(res);
                var markupCopy;
                for (var i=0;i<res.treeCopy.length;i++)
                {
                    if(res.treeCopy[i].Tree_Structure__r.Markup_Method__c != null)
                    	markupCopy = res.treeCopy[i].Tree_Structure__r.Markup_Method__c;
                }
                
                console.log('copy markup method = ' + markupCopy);
                
                if(markupCopy == markupMethod || markupCopy === undefined) {
                    //cmp.set('v.treeCopy', res.treeCopy);
                    cmp.set('v.hasCopy', true);
                }
            }
            
            var columns = [
                // {
                //     type: 'url',
                //     fieldName: 'linkName',
                //     label: 'Tree Id',
                //     initialWidth: 150,
                //     typeAttributes: {
                //         label: { fieldName: 'Name' }, target: '_blank'} 
                    
                // },

                {
                    type: 'url',
                    fieldName: 'linkName',
                    label: 'Branch Name',
                    typeAttributes: {
                        label: { fieldName: 'Branch_Name__c' }, target: '_parent', tooltip: 'Click for Tree Structure Page' 
                    },
                    initialWidth: 220
                    
                },
                {
                    type: 'boolean',
                    fieldName: 'Include_In_Estimate__c',
                    label: 'Included In Estimate',
                    initialWidth: 100
                },

               /* {
                    type: 'number',
                    initialWidth: 60,
                    fieldName: 'Quantity__c',
                    label: 'QTY',
                },
                {
                    type: 'text',
                    initialWidth: 70,
                    fieldName: 'UOM__c',
                    label: 'UOM',
                },
                {
                    type: 'currency',
                    initialWidth: 100,
                    fieldName: 'Unit_Cost__c',
                    label: 'Unit Cost',
                },*/
                {
                    type: 'currency',
                    initialWidth: 140,
                    fieldName: 'Total_Direct_Cost__c',
                    label: 'Total Direct Cost',
                 },
                {
                    type: 'currency',
                    // initialWidth: 120,
                    fieldName: 'Total_Cost__c',
                    label: 'Total Branch Cost',
                 },

                {
                    type: 'currency',
                    // initialWidth: 150,
                    fieldName: 'ECCA__c',
                    label: 'ECCA',
                 },
                {
                    type: 'currency',
                    // initialWidth: 150,
                    fieldName: 'ECC__c',
                    label: 'ECC',
                 },

                
            ];
            if(!isOandP){ 
                columns.push({
                type: 'currency',
                initialWidth: 150,
                fieldName: 'ETPC__c',
                label: 'ETPC',
                })
            };
            cmp.set('v.gridColumns', columns);
           // Added line number 116 if condition to avoid the undefined error for the story SFWS-1819  
            if(res.treeStruc.length>0){    
            hlp.setTreeData(cmp, res.treeStruc, cmp.get('v.showPasteModal'));
                }
            
        });        
    },
    
    handleSectionToggle: function (cmp, event ) {  
          
        var openSections = event.getParam('openSections');  
  
        if ( openSections.length === 0 )   
            cmp.set('v.activeSectionsMessage', "All sections are closed");  
        else   
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));          
          
    },
                
    copy: function(cmp, event, helper) {
       console.log('COPY');   
       var tree = cmp.find('projTree');
       var selectedRows = tree.getSelectedRows();
        
       //if(cmp.get('v.hasCopy') == true)
       if(selectedRows.length > 0 && cmp.get('v.treeCopy').length > 0)
       {
        console.log('has existing copy'); 
        //delete existing copy
        var action = cmp.get('c.deleteCopies');
        action.setParams({ copies : cmp.get('v.treeCopy')});
        
        action.setCallback(this, function(res) {
           var state = res.getState();
            if(state === 'SUCCESS')
            {
                console.log('DELETE SUCCESS!');
            }
            else
                console.log('NO SUCCESS!');
        });
        
        $A.enqueueAction(action);
       }
       
		if(selectedRows.length < 1)
        {
        	//alert('No rows selected!');  
        	cmp.set('v.copyError', 'No rows selected to copy. Please select at least one row.');
        	cmp.set('v.isError', true);
            cmp.set('v.showPasteModal', true);
		}
        else{
           for(let i=0;i<selectedRows.length; i++)
           {
             console.log(selectedRows[i]);
           }
                         
           helper.getTreeCopies(cmp, selectedRows);
           cmp.set('v.hasCopy', true);
           console.log(cmp.get('v.treeCopy'));
    	}
    }, 
    
    paste: function(cmp, event, helper) {
        console.log('PASTE');
        var copies = cmp.get('v.treeCopy');
        
        var tree = cmp.find('projTree');
        var selectedRows = tree.getSelectedRows();
        console.log(selectedRows.length);
        
        if(selectedRows.length > 1)
        {
            alert('Only 1 row may be selected to paste');
        }
        if(selectedRows.length < 1)
        {
            //alert('No parent branch selected. Please select a row in which to paste');
            cmp.set('v.pasteError', 'No parent branch selected. Please select a row in which to paste');
        }
        else
        {
            var selectedParent = selectedRows[0].Id;
            helper.pasteCopies(cmp, copies, selectedParent);
        }
    },
                
    expandAllRows: function(cmp, event, helper) { 
        var tree = cmp.find('projTree');
       	tree.expandAll();
    },
                
    collapseAllRows: function(cmp, event, helper) { 
        var tree = cmp.find('projTree');
       	tree.collapseAll();
    },

    isRefreshed: function(component, event, helper) {
        location.reload();
    },
        
    togglePasteModal: function(cmp, event, helper) {
    	var status = cmp.get('v.showPasteModal');
        if(status === true) {
            cmp.set('v.showPasteModal', false);
            cmp.set('v.isError', false);
            cmp.set('v.isDelete', false);
            cmp.set('v.toDelete', null);
            cmp.set('v.deleteError', '');
            cmp.set('v.deleteError2', null);
            cmp.set('v.copyError', '');
            cmp.set('v.pasteError', '');
        } else {
            //Create tree with only Branches (not Leaves) listed
            let getPTree = helper.getPasteTree(cmp);
            getPTree.then(function(res){
                 console.log('PASTE TREE SUCCESS!');
                console.log(res.length);
                if(res.length > 0) {
                    var columns = [
                        {
                            type: 'text',
                            //initialWidth: 1000,
                            fieldName: 'Branch_Name__c',
                            label: 'Branch Name',
                        }
                    ];
                
                var pasteTree = res;
                
                cmp.set('v.pasteColumns', columns);
                helper.setTreeData(cmp, pasteTree, true);
                cmp.set('v.showPasteModal', true);
                cmp.find('pasteTree').expandAll();
                } 
                else { 
                    cmp.set('v.copyError', 'This tree does not contain any eligible branches in which to paste.');
        			cmp.set('v.isError', true);
            		cmp.set('v.showPasteModal', true);
                }
                //cmp.set('v.showPasteModal', true);
            });
           
        }
    },
        
        paste2: function(cmp, event, hlp) {
        console.log('PASTE');
        let button = event.getSource();
    	button.set('v.disabled',true);
        button.set('v.label', 'Pasting...');
        
        var copies = cmp.get('v.treeCopy');
        
        var tree = cmp.find('pasteTree');
        var selectedRows = tree.getSelectedRows();
        console.log(selectedRows);
            
        if(selectedRows.length > 1)
        {
            //alert('Only 1 row may be selected to paste');
            cmp.set('v.pasteError', 'Only 1 row may be selected to paste');
            button.set('v.disabled',false);
        	button.set('v.label', 'Paste');
        }
        else if(selectedRows.length < 1)
        {
            cmp.set('v.pasteError', 'No parent branch selected. Please select a row in which to paste.');
            button.set('v.disabled',false);
        	button.set('v.label', 'Paste');
        }
        else
        {
            var selectedParent = selectedRows[0].Id;
            console.log(selectedParent);
            console.log(copies);
            hlp.pasteCopies(cmp, copies, selectedParent);
        }
        },
            
	handleDelete : function(cmp, evt, hlp) {
          console.log('DELETE!');
          
           var tree = cmp.find('projTree');
           var selectedRows = tree.getSelectedRows();
           var numRows = selectedRows.length;
           var message = 'Are you sure you want to delete?';
           var message2;
           console.log(selectedRows);
           var branches = [];
           var topLevel = [];
           var treeStruc = cmp.get('v.treeStruc');
           //console.log(treeStruc);
        
        if(numRows > 0) {
          //if() {
           var childToDelete = [];
           for(var i=0;i<numRows;i++)
           {
               if(selectedRows[i].RecordType.Name === 'Tree Branch' && selectedRows[i].SortOrdertxt__c != '01')
               {
                   console.log(selectedRows[i]);
                   var test = treeStruc.find(function(tree){
                       //console.log('function! ' + tree.Id);
                       return tree.Id === selectedRows[i].Id;
                   });
                   console.log(test._children);
                   if(test._children != undefined) { //check for branch with no children selected
                       var childDelete = [];
                       childDelete = hlp.getChildIds(cmp, test._children, childDelete);
                       console.log('childDelete', childDelete);
                       for(var c=0;c<childDelete.length;c++) {
                           //console.log(childDelete[c]);
                           if(!childToDelete.includes(childDelete[c]))
                               childToDelete.push(childDelete[c]);
                       }
                       branches.push(selectedRows[i].Branch_Name__c);
                       //message2 = 'You have chosen to delete the following branches:';
                   }
               }
               else if (selectedRows[i].SortOrdertxt__c === '01')
               {
                   //message2 = 'This top-level branch cannot be deleted:';
                   topLevel = [selectedRows[i].Branch_Name__c];
                   //message = '';
               }
               
               if(!childToDelete.includes(selectedRows[i].Id) && selectedRows[i].SortOrdertxt__c != '01')
                   childToDelete.push(selectedRows[i].Id);
           }
            console.log('branches', branches);  
            console.log('childToDelete', childToDelete);
            console.log('topLevel', topLevel);
            //cmp.set('v.toDelete', childToDelete);
            if(topLevel.length > 0) {
                console.log('top level!');
                message = 'Please remove this branch from your selection.';
                message2 = 'This top-level branch cannot be deleted:';
                cmp.set('v.deleteError2', topLevel);
                cmp.set('v.isDelete', true);
            }
            else if(branches.length > 0) {
                console.log('branches!');
                message2 = 'You have chosen to delete the following branches:';
                cmp.set('v.deleteError2', branches);
                cmp.set('v.isDelete', true);
                cmp.set('v.toDelete', childToDelete);
            }
            else {
                console.log('leaf only');
                cmp.set('v.toDelete', childToDelete);
                cmp.set('v.isDelete', true);
             }
           
        
		   cmp.set('v.copyError', message);
           cmp.set('v.deleteError', message2);
           //cmp.set('v.deleteError2', branches);
           //cmp.set('v.isDelete', true);
           cmp.set('v.isError', true);
           cmp.set('v.showPasteModal', true);
        //}
        }
        else {
            cmp.set('v.copyError', 'No rows selected to delete.');
            cmp.set('v.isError', true);
           cmp.set('v.showPasteModal', true);
        }
       },
       delete : function(cmp, evt, hlp) {
       	   console.log('DELETE TREES');
           
           //var tree = cmp.find('projTree');
           //var selectedRows = tree.getSelectedRows();
           var selectedRows = cmp.get('v.toDelete');
           
           hlp.deleteTrees(cmp, selectedRows);
               
       }
})