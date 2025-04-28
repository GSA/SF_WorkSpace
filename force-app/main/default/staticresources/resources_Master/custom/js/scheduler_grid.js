 // var roomView = false;
            var uiSender;
            var sectionDropSfdc;
            var bUnchanged = true;
          	var bSaving = false;
			var bCheckCourseLi = false;
			var selectedStaffOptions =new Array(); 
            var selectedRoomOptions =new Array(); 
          
j$confDialog =   j$("<div></div>").html(" Please only drop 1 section at a time").dialog({autoOpen: false, title: "Multiple Drop Violation", modal: true, height: 300, width: 400});
   
            j$(function() {
             	resetDroppable();    
                	resetDraggable(); 
            });
            
            function toggleRoomViewJs(){
            bRoomView = !bRoomView;
            }
            
            function resetDroppable(){
            
            	j$( ".droppableCell" ).sortable({
                    placeholder: "customHighlight", 
                    tolerance: 'pointer' ,
                    receive: function(event,ui){
                    bUnchanged = false;
                   if (j$(ui.item).hasClass('disabled')){    
                  		if (sectionDropSfdc==j$(ui.item).attr('sfdc')){
                   			j$confDialog.dialog("open");
                             		 j$(this).find('li').html('');    
                             		sectionDropSfdc=null; 
                   		}
                   		else {
                   	 		sectionDropSfdc =  j$(ui.item).attr('sfdc');
                   		}       
                        	var oldTeacherId = j$(this).find('.teacherId').val();
                        	var oldPeriodId = j$(this).find('.periodKey').val();
                        	var oldPeriodName = j$(this).find('#period').val();
                        	var oldTeacherName = j$(this).find('.teacherName').val();
                        	//alert(oldTeacherName);
                        	var oldRoomId = j$(this).find('.roomId').val();
                        	var oldRoomNumber = j$(this).find('#roomNumber').val();
                        	j$(this).find('.targetSect li').remove();
                        	if (!bRoomView){
                        		j$(ui.item).find('.teacherId').val(oldTeacherId);    
                        		j$(ui.item).find('.teacherName').val(oldTeacherName);
                        		j$(this).find('.teacherId').val(oldTeacherId);    
                        		j$(this).find('.teacherName').val(oldTeacherName);
                        	}
                        	j$(ui.item).find('.periodKey').val(oldPeriodId);
						j$(ui.item).find('#period').val(oldPeriodName);
						j$(this).find('.periodKey').val(oldPeriodId);
						j$(this).find('#period').val(oldPeriodName);
                        	if (bRoomView){
                        	 j$(ui.item).find('#roomNumber').val(oldRoomNumber);     
                        	  j$(ui.item).find('.roomId').val(oldRoomId);     
                        	   j$(this).find('#roomNumber').val(oldRoomNumber);     
                        	  j$(this).find('.roomId').val(oldRoomId);     
                        	  }
                        	j$(this).find('li').css('background-color', j$(ui.sender).css('background-color'));
                        	clickedCell = j$(ui.sender).parents('.occupiedCell');
                        	                        	
					j$(this).css('color',j$(clickedCell).css('color'));                      	
                        	//alert(j$(clickedCell).find('.innerTab').html());
                        	//var thisCell =clickedCell; openModal(j$(thisCell) , j$(thisCell).find('.courseId').val(),j$(thisCell).find('sectRpId'), j$(thisCell).find('.sectionId').val() , j$(thisCell).find('.bgColor').val(), null); 
                        	clearCell();
                        	j$(this).closest('.cell').addClass('occupiedCell');
                        	j$(this).closest('.cell').removeClass('droppableCell');     
                        	}
                        	
                       	else {
                     		if (sectionDropSfdc==j$(this).find('.secText').attr('sfdc')){
                   		 	j$confDialog.dialog("open");
                                   j$(this).find('li').remove();    
                   		 	sectionDropSfdc=null;  
                   		 }
                   		 else {
                    			sectionDropSfdc=j$(this).find('.secText').attr('sfdc');              
					       bCheckCourseLi = true;           
                       		openModal(j$(this),  j$(this).find('#courseId').val(),j$(this).find('#sectRpId').val(), j$(this).find('#sectId').val() , j$(ui.item).css('backgroundColor'), j$(ui.item).css('color')); 
                           	if (!bRoomMatters) saveModalNetNew();                       
                       		 if(j$(this).find('.courseLi')) j$(this).find('.courseLi').remove();
                        }
                        j$(this).closest('.cell').addClass('occupiedCell');
                        j$(this).closest('.cell').removeClass('droppableCell');   
                        }
                        
                       resetDraggable();
                        resetDroppable();
                    }                    , 
                    start: function(event, ui) { 
                    	j$(ui.helper).find('.secText').html('');
                    	j$(ui.helper).css('height','10px;');
                    },
                    cancel: ".disabled"
                });
            
            }
             
             
      function       toggleGridConfirmJs(){
	if(!bUnchanged){ 
		var b = confirm('You have unsaved changes.  Press OK to  change view without saving or press Cancel to return, then click Save Schedule');
		if (b) {
			toggleRoomViewJs(); showProgressBar('Toggling View'); toggleViewJs();
		}
	}
	else {
		toggleRoomViewJs(); showProgressBar('Toggling View'); toggleViewJs();
	}
}


		
              
     
            function resetDraggable(){
                j$( ".configuredCourse li" ).draggable({
                    helper:"clone", 
                    connectToSortable: ".droppableCell",
                     appendTo: '.page',
                    placeholder: "customHighlight",
                    start: function(event, ui) { 
                   	 sectionDropSfdc=null;
                    	j$(ui.helper).find('.secText').html('');
                    	//j$(ui.helper).css('height','10px');
                    }
                }); 
                
                  j$( "li" ).draggable({
                    connectToSortable: ".droppableCell",
                    helper:"clone", 
                    snap : "true",
                    snapTolerance: 40,
                    appendTo: '.page',
                    placeholder: "customHighlight2",
                    start: function(event, ui) { 
                     sectionDropSfdc=null;                    
                    	j$(ui.helper).find('#draggableCell').css('display','none');
                  //  	j$(ui.helper).css('height','10px');
                    	
                    }
                }); 
            }       

            var bgColor;
            var clickedCell;

            function resetColorPicker(){
                if (j$('#colorSelector')!=null){
                    if (j$('#colorSelector').hasClass('mColorPicker')==false){
                        j$('#colorSelector').mColorPicker();
                        j$('#colorSelector').bind('colorpicked', function () {
                            bCPInvoked=true;
                            var colorVal = j$(this).val();
                            j$(document).find('.tempColor').val(colorVal);
                        });
                    }
                }
            }
            
            function changeModal(cell, roomViewType, backgroundColor, bClickable){
	            if (bClickable){
	            bRoomView = roomViewType;
	            clickedCell = cell;
	             bgColor = backgroundColor;
			configureOptionList();
	               var roomNum =parseInt(j$(cell).find('#roomNumber').html());
	            if (bRoomView)     {//alert ('room view type '+roomViewType);
	                        pName = 'Room: '+parseInt(j$(cell).find('#roomNumber').html());}
	                    else 
	                        pName = 'Staff: '+ j$(cell).find('#teacherName').html();
	                    j$(cell).css('background-color','yellow');
	                    j$('.schedulerModal').dialog({
	                        title: 'Period: '+j$(cell).find('#period').html()+' '+pName,
	                        beforeClose: function(){ j$(cell).css('background-color',bgColor); },
	                        modal :true 
	                    });     
	                    j$(".schedulerModal").find(".selectedRoom").find('option').each(function() {
	                        if (j$(this).html()==roomNum)
	                            j$(this).attr("selected","selected") ;
	                    });
	            }
            }
            
            function resetOptionList(){
            	j$('.selectedRoom option').each( function() {
        					j$(this).attr("disabled",false);
        			});
            }
            
            function configureOptionList(){
            
            	var selectedPeriod;
            	 selectedStaffOptions =new Array(); 
                var selectedRoom; 
                 selectedRoomOptions =new Array(); 
                var roomVal;
                var staffVal;
                selectedPeriod = j$(clickedCell).find('#period').html();
        		if (!bRoomView){
        			j$('.occupiedCell').each(function() {
        				if (j$(this).find('#period').html()==selectedPeriod ){
        					selectedRoomOptions.push(j$(this).find('#roomNumber').html());
        					if (j$(this).find('.sectionId').val()==j$(clickedCell).find('.sectionId').val()){
        						roomVal=j$(this).find('#roomNumber').html();
        					}
        				}
        			});
        			j$('.selectedRoom option').each( function() {
        				var bDisabled = false;
        				var thisOption = j$(this).val().split('|')[1];
        				if(selectedRoomOptions.indexOf(thisOption)!=-1){
        					j$(this).attr("disabled","disabled");
        					bDisabled=true;
        				}

        				if (roomVal==thisOption){
        					j$(this).attr("selected", "selected");
        					j$(this).removeAttr('disabled');
        				}
        				else if (roomVal==null&&!bDisabled) {
        					roomVal =thisOption;
        					j$(this).attr("selected", "selected");
						
        				}
        			});
        		}
        		else {
        			j$('.occupiedCell').each(function() {
        				if (j$(this).find('#period').html()==selectedPeriod ){
        					selectedStaffOptions.push(j$(this).find('#teacherName').html());
        					staffVal=j$(this).find('#teacherName').html();
        					//alert(selectedStaffOptions);
        				}
        			});
        			j$('.selectedStaff option').each( function() {
        				var bDisabled = false;
        				var thisOption = j$(this).val().split('|')[1];
        				if(selectedStaffOptions.indexOf(thisOption)!=-1){
        					j$(this).attr("disabled","disabled");
        					bDisabled=true;
        				}

        				if (staffVal==thisOption){
        					j$(this).attr("selected", "selected");
        					j$(this).removeAttr('disabled');
        				}
        				else if (staffVal==null&&!bDisabled) {
        					staffVal =thisOption;
        					j$(this).attr("selected", "selected");
						
        				}
        			});
        		}
            }
            

            function openModal(cell, courseId, sectRpId, sectionId, backgroundColor, fontColor){
                clickedCell = cell;
		 if (courseId!=''){
                    var roomNum =   j$(clickedCell).find('#roomNumber').html();
                    var sectionName ;
                    var courseName ;
                    bgColor = backgroundColor;
    			  
                    if (courseId){
                    courseName = courseId.split('|')[1];
             		j$(clickedCell).find('#courseName').html(courseName);
                        j$(clickedCell).find('.courseId').val(courseId.split('|')[0]);
                    }
                    if (sectionId){
                    sectionName = sectionId.split('|')[1];
                        j$(clickedCell).find('#sectionName').html(sectionName);
                        j$(clickedCell).find('.sectionId').val(sectionId.split('|')[0]);
                    }
                     j$(clickedCell).find('.ssTitle').html(sectionName+' - '+courseName);
                     
                        j$(clickedCell).find('.sectionRpId').val(sectRpId);
                   
                    var pName;
                    if (bRoomView) 
                        pName = 'Room: '+parseInt(j$(cell).find('#roomNumber').html());
                    else 
                        pName = 'Staff: '+ j$(cell).find('#teacherName').html();
                    j$(cell).find('li').css('background-color','yellow');
                     configureOptionList();
                    j$('.schedulerModal').dialog({
                        title: 'Period: '+j$(cell).find('#period').html()+' '+pName,
                        beforeClose: function(){ 
                        	j$(cell).find('li').css('background-color',bgColor);
                        	if (fontColor) j$(cell).css('color',fontColor);
                        	 },
                        modal :true
                    });     
                    j$(".schedulerModal").find(".selectedRoom").find('option').each(function() {
                        if (j$(this).html()==roomNum)
                            j$(this).attr("selected","selected") ;
                    });
                }
            }
    
           
            
            
            function saveModalNetNew(){
                var staff;
                var room;
                if (bRoomView){
                    
                }
                var course =  j$('.selectedCourse').val();
                if (!bRoomView) 
                    room = j$('.selectedRoom').val();
                else 
                		staff =  j$('.selectedStaff').val();
                if (!bRoomView&&room){
                    j$(clickedCell).find('#roomNumber').html(room.split('|')[1]);
                    j$(clickedCell).find('.roomId').val(room.split('|')[0]);
                } 
                else if (bRoomView){  
                    j$(clickedCell).find('#teacherName').html(staff.split('|')[1]);
                    j$(clickedCell).find('.teacherId').val(staff.split('|')[0]);
                }
         
                j$(clickedCell).find('.innerTab').show();
                j$('.schedulerModal').dialog('close');
                j$(clickedCell).find('#removeLink').css('display','inline');
              if (bRoomMatters&&bCheckCourseLi)  j$(clickedCell).find('#changeRoomTemp').css('display', 'inline');
            
                
                j$(clickedCell).find('.bgColor').val(bgColor);
		if (bCheckCourseLi){
                j$('.courseLi').each(function() {
            
                    if ( j$(this).attr('sfdc')==j$(clickedCell).find('.sectionRpId').val()) {
                        var rpNum = 0;
                        rpNum = j$(this).find('#rpNum').html();              
                        if (rpNum > 1) {
                            rpNum--;
                            j$(this).find('#rpNum').html(rpNum);
                        } else { 
                            j$(this).css('display','none');
                        }
                    }
                });
                }
                bCheckCourseLi=false;
                resetOptionList();
            }
    
            function clearCell(){
                bgColor='#F0F0F0';
                bUnchanged=false;
             //   alert(j$(clickedCell).html());
                 j$(clickedCell).find('.ssTitle').html('');
                 j$(clickedCell).find('#sectionTip').html('');
                 
                  j$(clickedCell).find('#removeLink').css('display','none');
              if (bRoomMatters) {
               j$(clickedCell).find('#changeRoomTemp').css('display', 'none');
                 j$(clickedCell).find('#changeRoom').css('display', 'none');
               }
              
		        j$(clickedCell).find('#courseName').html('');
		        if (bRoomView)  j$(clickedCell).find('#teacherName').html('');
		    //    alert( j$(clickedCell).find('.courseId').val());
		        
		        j$(clickedCell).find('.courseId').val(null);
		//        alert( j$(clickedCell).find('.courseId').val());
		        if (bRoomView) j$(clickedCell).find('.teacherId').val();
		         if (!bRoomView) j$(clickedCell).find('.roomId').val('');  
		       j$(clickedCell).find('.sectionId').val('');  
		       j$(clickedCell).find('.sectionRpId').val('');  
		        j$('.schedulerModal').dialog('close');
		        j$(clickedCell).find('li').css('background-color', bgColor);  
		         j$(clickedCell).css('background-color', bgColor);  
		        j$(clickedCell).addClass('droppableCell');
		         j$( clickedCell ).removeClass('occupiedCell');
		         resetDraggable();
	        }