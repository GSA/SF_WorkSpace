({
    doInit : function(component, event, helper) {
        console.log('initing....');

        //Default values if not passed in from url parameters
        if (component.get('v.selectedCostType') == null || component.get('v.selectedCostType') == '')
            component.set('v.selectedCostType', 'cost');
        if (component.get('v.selectedGrouping') == null || component.get('v.selectedGrouping') == '')
            component.set('v.selectedGrouping', 'cost');
        if (component.get('v.selectedCategory') == null || component.get('v.selectedCategory') == '')
            component.set('v.selectedCategory', 'all');
        if (component.get('v.selectedCostDetail') == null || component.get('v.selectedCostDetail') == '')
            component.set('v.selectedCostDetail', 'all');

        if (component.get('v.selectedCostType') == 'cost')
            component.set('v.displayCostType', 'Constant Dollar')
        if (component.get('v.selectedCostType') == 'escalatedCost')
            component.set('v.displayCostType', 'Escalated Cost');
        if (component.get('v.selectedCostType') == 'escalatedDiscountedCost')
            component.set('v.displayCostType', 'Escalated &amp; Discounted Cost');

        component.set('v.expenditureLink','/00O35000000dcoZ?pv0=' +component.get('v.recordId'));
        helper.getProjectData(component, event, helper);

    },
    handleFilterChange: function (component, event, helper) {
        helper.displayData(component, event, helper);
    },
    //Formatting not possible with the lightning table
    //onRender: function (component, event, helper) {
    reRender: function (component, helper) {
        this.superRerender();

        var table = document.getElementsByClassName('slds-table')[0];
        
        console.log('lccTable', table);
        for (var i = 0, row; row = table.rows[i]; i++) {
            if (i == 0){
                row.className = 'totalsRow'; 
            }
            for (var j = 0, col; col = row.cells[j]; j++) {
                if (i == 0 && j == 0){
                    col.value = 'Totals';
                }
            }  
        }

        
    },
    printMe: function(cmp){
        var projId = cmp.get('v.recordId');
        var costType = encodeURI(cmp.get('v.selectedCostType'));
        var grouping = encodeURI(cmp.get('v.selectedGrouping'));
        var cat = encodeURI(cmp.get('v.selectedCategory'));
        var costDetail = encodeURI(cmp.get('v.selectedCostDetail'));
        
        window.open('apex/NCMT_TCOBuildingCostsPerYear?print=true&id=' +projId +
                '&costType=' +costType +'&grouping=' +grouping +'&cat=' +cat +'&costDetail=' +costDetail,
                    '_new'
                    );
        
    },
    
    funPrint: function(component, event){
        document.getElementById('prnBtn').style.display='none';  
        window.print();
        document.getElementById('prnBtn').style.display='block'; 
    }
})