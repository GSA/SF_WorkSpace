public with sharing class NCMT_Utilities {

    //Aura method that simplifies code coverage as it reduces the # of often missed exception lines to cover
    public static void auraHandleDMLErrors(System.DmlException e) {
        String err = '';
        for (Integer i = 0; i < e.getNumDml(); i++) {
            if (err != '') err += '<br/>';
            err += e.getDmlMessage(i) +' on field(s) ' +e.getDmlFieldNames(i) +': ' +e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, 'Error here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ' +e.getDmlMessage(i) +': ' +e.getStackTraceString()); 
		} 
		AuraHandledException auraErr = new AuraHandledException(err);
        auraErr.setMessage(err);
        throw auraErr;
	}

    public static Map<String, Schema.SObjectType> globalMap;
	//Limited to objects with 20 or less child relationships, but could be updated to handle that
	//cloneChildren- api names of child objects to clone along with parent record from recordId
    public static SObject cloneMe(String objectName, Id recordId, Set<String> cloneChildren, Boolean insertClone){
		
       	globalMap = Schema.getGlobalDescribe();
		Schema.DescribeSObjectResult DescObj = globalMap.get(objectName).getDescribe();
		Map<String, List<String>> mapChildFields = new Map<String, List<String>>();
		Map<String, String> mapChildRelFields = new Map<String, String>();
		
		if (cloneChildren.size() > 0){
			Set<String> lowerChildren = new Set<String>();
			for (String c : cloneChildren){
				lowerChildren.add(c.toLowerCase());
			}

			Set<String> AvailChildToInit = new Set<String>();
			for (Schema.ChildRelationship c : DescObj.getChildRelationships()){
				//For now, attachments not allowed 
				if (c.getRelationshipName() != null &&c.getRelationshipName().toLowerCase() != 'attachments') 
					AvailChildToInit.add(c.getRelationshipName());
			}
			
			
			Map<String, String> mapChildRelObjects = new Map<String, String>();
			for (Schema.ChildRelationship c : DescObj.getChildRelationships()){
				Schema.DescribeSObjectResult ChildDesc = c.getChildSObject().getDescribe();
				
				if (ChildDesc.isCreateable() &&c.getRelationshipName() != null
					&&lowerChildren.contains(ChildDesc.getName().toLowerCase())
				){
					System.debug('child object ================== ' +ChildDesc.getName() +' ' +ChildDesc);
					String relName = c.getRelationshipName();
					String relField = c.getField().getDescribe().getLocalName();
					mapChildRelFields.put(relName, relField);
					
					List<String> childFields = getFieldNames(ChildDesc.getName());
					if (childFields.size() > 0){
						mapChildFields.put(c.getRelationshipName(), childFields);
						mapChildRelObjects.put(c.getRelationshipName(), ChildDesc.getName());
					}
				}
			}
		}

		List<String> fieldList = getFieldNames(objectName);

		String strSoQl = 'Select Id';
		for (String f : fieldList){
			strSoQL += ', ' +f;
		}
		for (String childObj : mapChildFields.keySet()){
			strSoQL += ', (Select Id';
			for (String f : mapChildFields.get(childObj)){
				strSoQL += ', ' +f;
			}
			strSoQL += ' from ' +childObj +')';
		} 
		strSoQL += ' from ' +objectName +' where Id = \'' +recordId +'\''; 
        System.debug('CLONE QUERY FOR ' + objectName);
        System.debug(strSoQL);
		SObject obj = Database.query(strSoQL);
		SObject newObj = obj.clone(false, true);
		
        //Added by Caroline 06/11/20
        if(insertClone == true)
        	insert newObj;
		
		
			
		Map<String, SObject> quoteMap = new Map<String, SObject>();
		for (String childRel : mapChildFields.keySet()){
			List<Sobject> objs = new List<Sobject>();
			List<Sobject> updateObjs = new List<Sobject>();
			
			for (SObject childRecord : obj.getSobjects(childRel)){
			
				Sobject cloneChild = childRecord.clone(false, true);
				System.debug('child object ====== '+childRel +' rel field name ==== ' +mapChildRelFields.get(childRel));
				cloneChild.put(mapChildRelFields.get(childRel), String.valueOf(newObj.get('Id')));
				System.debug('child record ==== ' +cloneChild);
				
			
				
				objs.add(cloneChild);
				
			}
			insert objs;
			
		}//end child relationships
		
		return obj;
	}
	
	//Pass in object API name and 
	//Returns list of all fields accessible to current user except Id and any binary fields
	//By default, only returns accessible
	//use getFieldNames(String objName, String mode) to get all or only createable
	public static List<String> getFieldNames(String objName){
		return getFieldNames(objName, 'all');
	}

	public static List<String> getFieldNames(String objName, String mode){
		if (globalMap == null) globalMap = Schema.getGlobalDescribe();
		Schema.DescribeSObjectResult DescObj = globalMap.get(objName).getDescribe();
		
		SObjectType token = Schema.getGlobalDescribe().get(objName);
		List<String> fieldList = new List<String>();
		if ((mode == 'accessible' &&DescObj.isAccessible())
			|| (mode == 'createable' &&DescObj.isCreateable())
			|| mode == 'all'
		){
			Map<String, Schema.SObjectField> mapFields = DescObj.Fields.getMap();
			for (String f : mapFields.keySet()){
				Schema.DescribeFieldResult DescField = mapFields.get(f).getDescribe();
				if (((mode == 'accessible' &&DescField.isAccessible())
					|| (mode == 'createable' &&DescField.isCreateable())
					|| mode == 'all')
					&&f.toLowerCase() != 'id'
					&&DescField.getType().Name().toLowerCase() != 'base64' //no binary fields
					&&f.toLowerCase() != 'isdeleted' //causes error when using recalculateFormulas
					&&f.toLowerCase() != 'systemmodstamp' //causes error when using recalculateFormulas
					&&f.toLowerCase() != 'lastmodifieddate' //causes error when using recalculateFormulas
					&&f.toLowerCase() != 'createdbyid' //causes error when using recalculateFormulas
					&&f.toLowerCase() != 'createddate' //causes error when using recalculateFormulas
					&&f.toLowerCase() != 'lastmodifiedbyid' //causes error when using recalculateFormulas
	            ){
	            	fieldList.add(f.toLowerCase());
	            }
			}
		}
		
		return fieldList;
	}

	//Pass in object API name and 
	//Returns string of all fields accessible to current user except Id and any binary fields
	//That can be plugged into SoQL
	//By default, only returns accessible
	//use getFieldNames(String objName, String mode) to get all or only createable
	public static String getFieldSoQL(String objName){
		return getFieldSoQL(objName, 'accessible');
	}

	//That can be plugged into SoQL
	public static String getFieldSoQL(String objName, String mode){
		String strFields = 'Id';
		for (String f : getFieldNames(objName, mode)){
			strFields += ', ' +f;
		}
		return strFields;
	}

	//Should make this generic to all objects but I don't feel like it right now
	public static Id getProjectRecordTypeId(String recordTypeDevName){
		return NCMT_Project__c.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId();
	}
    
    @InvocableMethod
    public static void toggle_TCORunTriggers()
    {
		System.debug('Hello from Process Builder!');
        NCMT_GenerateTCOProjectDetailsExt.runTriggers = false;
    }
}