public with sharing class NCMT_Permsetdata{
   
    public List<user> fewpermsetinfo {get;set;}
    public List<user> displaypermsetinfo {get;set;}
    public List<PermissionSetAssignment> filterPermsetassign {get;set;}
    public Map<string, List<PermissionSetAssignment>> permissionSetAssignMap {get;set;}
    Set<String> setassignName = new Set<String>();
    

    public NCMT_Permsetdata() {
        //allpermsetinfo = new List<PermissionSetAssignment>();
        string strassigneename;
        string strassigneename1;
        fewpermsetinfo = new List<user>();
        List<AggregateResult> allpermsetinfo = [Select count_distinct(AssigneeId),Assignee.Name asgnname
                                                  FROM PermissionSetAssignment 
                                                    Where Assignee.isActive = True 
                                                        and PermissionSet.Name like '%NCMT%'
                                                        group by Assignee.Name
                                                        order by Assignee.Name limit 500];  
        
        if(allpermsetinfo.size() > 0){                                                              
        
            for(AggregateResult permasignset :allpermsetinfo)
            {
            strassigneename= (string) permasignset.get('asgnname');
            setassignName.add(strassigneename); 
            }
        }
        filterPermsetassign = new List<PermissionSetAssignment>();
        fewpermsetinfo = [Select Id,isActive, Email,NCMT_UserRegionCode__c,NCMT_User_Level__c,Name,Profile.Name, SystemModstamp 
                            FROM user
                            Where Name IN :setassignName
                            order by NCMT_UserRegionCode__c,Name limit 500];
        
        displaypermsetinfo = new List<user>(fewpermsetinfo);
        
        permissionSetAssignMap = new Map<string, List<PermissionSetAssignment>>();
        for(user p : fewpermsetinfo){
            permissionSetAssignMap.put(p.Name, new List<PermissionSetAssignment>());
        }
        List<PermissionSetAssignment> permsets = new List<PermissionSetAssignment>([SELECT PermissionSet.Name,Assignee.Name
                                                                                    FROM PermissionSetAssignment 
                                                                                    WHERE Assignee.Name IN :permissionSetAssignMap.keyset()
                                                                                    and PermissionSet.Name like '%NCMT%']);
        for(PermissionSetAssignment psa : permsets){
            permissionSetAssignMap.get(psa.Assignee.Name).add(psa);
        }
    }
    
}