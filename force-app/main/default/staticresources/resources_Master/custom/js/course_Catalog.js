<script>
$(document).ready(function(){
    resetDataTables();
    var selectedCatalogId = '{!selectedCatalogId}';
    if (selectedCatalogId){
    	$('.catalogsTable').find('.radio').each(function() { 
    		//alert($(this).html());
    		var sfdcId = $(this).attr('sfdcid');
    		//alert(sfdcId);
    		if (sfdcId.indexOf(selectedCatalogId)!=-1){
    			$(this).click();
    			getCatalogDetailsJs(selectedCatalogId);
    		}
    	
    	
    	
    	});

    	}
});

function resetDataTables(){ 
	$(".tablesorter").dataTable( {
	        "sScrollY": "200px",
	        "bLengthChange": false,
	        "bFilter": true,
	        "bInfo": false,
	        "aoColumnDefs": [

{ "sWidth": "200px", "aTargets": [ 0 ]}
 
],
	        "bAutoWidth": false,
	         "bSort" :true,

	        "bPaginate": false,
	        "bScrollCollapse": true,
		"bJQueryUI": true,
		iDisplayLength : 25,
		"asStripClasses": [ 'odd', 'even' ]
	    } );
	}

function addHighlight(element){
    removeHighlight();
    $(element).parent().addClass('datahighlight');
}

function removeHighlight(){
    $(document).find('.datahighlight').removeClass('datahighlight');
}

function addHighlight2(element){
    removeHighlight2();
    $(element).parent().addClass('datahighlight2');
}

function removeHighlight2(){
    $(document).find('.datahighlight2').removeClass('datahighlight2');
}

function toggleRadio(radio) {

			$('.radio').each(function() {
				$(this).attr('checked', false);
			});
			$(radio).attr('checked', true);
		}
function selectAll(cb) {
			var b = $(cb).attr('checked');
			$('.courseCb').each(function() {
				$(this).attr('checked', b);
			});
		}
</script>