({

    //Formatting not possible with the lightning table
    //happening on rerender but can't seem to get after rerender
    rerender: function (component, helper) {

        this.superRerender();

        var table = document.getElementsByClassName('slds-table')[0];
        
        console.log('lccTable', table);
        /*
        for (var i = 0, row; row = table.rows[i]; i++) {
            if (i == 0){
                row.className = 'totalsRow'; 
            }
            for (var j = 0, col; col = row.cells[j]; j++) {
                if (i == 0 && j == 0){
                    col.value = 'Totals';
                }
            }  
        }*/

        
    }
})